using Google.Apis.Auth;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Motqin.Data;
using Motqin.Data.Helpers;
using Motqin.Dtos.Authentication;
using Motqin.Dtos.Authentication.Motqin.Dtos.Authentication;
using Motqin.Enums;
using Motqin.Models;
using Motqin.Services;
using SchoolApp.API.Data.Models;
using SchoolApp.API.Data.ViewModels;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Motqin.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthenticationController : ControllerBase
    {
        private readonly UserManager<User> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;
        private readonly AppDbContext _context;
        private readonly IConfiguration _configuration;
        private readonly TokenValidationParameters _tokenValidationParameters;
        private readonly IEmailService _emailService;
        private readonly IHttpClientFactory _httpClientFactory;


        public AuthenticationController(UserManager<User> userManager,
            RoleManager<IdentityRole> roleManager,
            AppDbContext context,
            IConfiguration configuration,
            TokenValidationParameters tokenValidationParameters,
            IEmailService emailService,
            IHttpClientFactory httpClientFactory)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _context = context;
            _configuration = configuration;
            _tokenValidationParameters = tokenValidationParameters;
            _emailService = emailService;
            _httpClientFactory = httpClientFactory;
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] UserRegisterDto userRegisterDto)
        {
            if (!ModelState.IsValid)
            {
                var modelErrors = ModelState.ToDictionary(
                    kvp => kvp.Key,
                    kvp => kvp.Value.Errors.Select(e => e.ErrorMessage).ToList()
                );
                return BadRequest(new { Message = "Validation Failed", Errors = modelErrors });
            }

            var userExists = await _userManager.FindByEmailAsync(userRegisterDto.EmailAddress);
            if (userExists != null)
            {
                if (!userExists.EmailConfirmed)
                {
                    return BadRequest(new
                    {
                        Message = "Registration Failed",
                        Code = "UnconfirmedAccount", 
                        Errors = new Dictionary<string, List<string>>
            {
                { "Email", new List<string> { "An account with this email was created but not verified. Please check your inbox or request a new verification link." } }
            }
                    });
                }

                // 2. User exists and IS fully confirmed (Standard Duplicate Error)
                return BadRequest(new
                {
                    Message = "Registration Failed",
                    Code = "DuplicateAccount", 
                    Errors = new Dictionary<string, List<string>>
        {
            { "Email", new List<string> { $"The email {userRegisterDto.EmailAddress} is already in use. Please log in." } }
        }
                });
            }

            User newUser = new User()
            {

                UserName = userRegisterDto.EmailAddress, 
                Email = userRegisterDto.EmailAddress,
                FullName = userRegisterDto.UserName,     
                EmailConfirmed = false,
                SecurityStamp = Guid.NewGuid().ToString(),
                CreatedAt = DateTime.UtcNow,

                //  default values 
                Country = "Egypt", 
                EducationalStage = EducationalStage.Secondary, 
                GradeLevel = GradeLevel.Third
            };
            var result = await _userManager.CreateAsync(newUser, userRegisterDto.Password);

            if (result.Succeeded)
            {

                //Add user role
                await _userManager.AddToRoleAsync(newUser, UserRoles.Manager);

                // generate email confirmation token
                var code = await _userManager.GenerateEmailConfirmationTokenAsync(newUser);
                try
                {
                    await _emailService.SendEmailAsync(
                    newUser.Email,
                    "Confirm your email",
                     $@"
                <h2>Welcome {newUser.UserName}!</h2>    
                <p>Your email verification code is:</p>
                <h3>{code}</h3>
                <p>Please enter this code in the application to verify your email.</p>
                ");



                    return Ok(new
                    {
                        Message = "Registration successful. Please check your email to verify your account.",
                        RequiresEmailResend = false
                    });

                }
                catch (Exception ex)
                {

                    return Ok(new
                    {
                        Message = "Registration successful, but we could not send the verification email at this time.",
                        RequiresEmailResend = true,
                        // Optional: You can remove the Error property in production to hide technical details from users
                        Error = "Email service temporarily unavailable."
                    });

                    // need to re send the verifecation email
                }
            }


                var identityErrors = new Dictionary<string, List<string>>();

            foreach (var error in result.Errors)
            {
                
                if (error.Code.StartsWith("Password"))
                {
                    if (!identityErrors.ContainsKey("Password")) identityErrors["Password"] = new List<string>();
                    identityErrors["Password"].Add(error.Description);
                }

                else if (error.Code.Contains("Email"))
                {
                    if (!identityErrors.ContainsKey("Email")) identityErrors["Email"] = new List<string>();
                    identityErrors["Email"].Add(error.Description);
                }

                else if (error.Code.Contains("UserName"))
                {
                    if (!identityErrors.ContainsKey("UserName")) identityErrors["UserName"] = new List<string>();
                    identityErrors["UserName"].Add(error.Description);
                }

                else
                {
                    if (!identityErrors.ContainsKey("General")) identityErrors["General"] = new List<string>();
                    identityErrors["General"].Add(error.Description);
                }
            }

            return BadRequest(new { Message = "Validation Failed", Errors = identityErrors });
        
        }

        [HttpPost("verify-email")]
        public async Task<IActionResult> VerifyEmailAuthority(string? email, string? code) // we can make Dto
        {
            // 1. Validate the input payload
            if (email == null || code == null)
            {
                return BadRequest(new { error = "Invalid payload" });
            }

            // 2. Find the user by the provided email
            var user = await _userManager.FindByEmailAsync(email);
            if (user == null)
            {
                return BadRequest(new { error = "Invalid payload" });
            }

            // 3. Attempt to confirm the email using the provided code/token
            var isVerified = await _userManager.ConfirmEmailAsync(user, code);

            if (isVerified.Succeeded)
            {
                return Ok(new
                {
                    message = "email confirmed"
                });
            }

            // 4. Return generic error if verification fails
            return BadRequest(new { error = "something went wrong" });
        }


        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto loginDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest("Please, provide all required fields");
            }

          

            var userExists = await _userManager.FindByEmailAsync(loginDto.EmailAddress);

            if (userExists != null && await _userManager.CheckPasswordAsync(userExists, loginDto.Password)) // guaranteed that the email is not null
                                                                                                            // to pass it to user manager.
            {
                
                if (!await _userManager.IsEmailConfirmedAsync(userExists))
                {
                    return Unauthorized("Email is not confirmed. Please check your inbox.");
                }

                var tokenValue = await GenerateJWTTokenAsync(userExists, null);
                return Ok(tokenValue);
            }
            return Unauthorized();
        }

        [HttpPost("refresh-token")]
        public async Task<IActionResult> RefreshToken([FromBody] TokenRequestDto tokenRequestDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest("Please, provide all required fields");
            }

            var result = await VerifyAndGenerateTokenAsync(tokenRequestDto);
            return Ok(result);
        }

        private async Task<AuthResultDto> VerifyAndGenerateTokenAsync(TokenRequestDto tokenRequestVM)
        {
            var jwtTokenHandler = new JwtSecurityTokenHandler();
            var storedToken = await _context.RefreshTokens.FirstOrDefaultAsync(x => x.Token == tokenRequestVM.RefreshToken);
            var dbUser = await _userManager.FindByIdAsync(storedToken.UserId);



            try
            {
                var tokenCheckResult = jwtTokenHandler.ValidateToken(tokenRequestVM.Token,
                    _tokenValidationParameters,
                    out var validatedToken);

                // This function where the token gets validated.

                return await GenerateJWTTokenAsync(dbUser, storedToken);
            }
            catch (SecurityTokenExpiredException)
            {
                if (storedToken.DateExpire >= DateTime.UtcNow)
                {
                    return await GenerateJWTTokenAsync(dbUser, storedToken);
                }
                else
                {
                    return await GenerateJWTTokenAsync(dbUser, null);
                }
            }
        }

        private async Task<AuthResultDto> GenerateJWTTokenAsync(User user, RefreshToken rToken)
        {
            var authClaims = new List<Claim>()
            {
                new Claim(ClaimTypes.Name, user.FullName),
                new Claim(ClaimTypes.NameIdentifier, user.Id),
                new Claim(JwtRegisteredClaimNames.Email, user.Email),
                new Claim(JwtRegisteredClaimNames.Sub, user.Email),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
            };

            //Add User Role Claims
            var userRoles = await _userManager.GetRolesAsync(user);
            foreach (var userRole in userRoles)
            {
                authClaims.Add(new Claim(ClaimTypes.Role, userRole)); 
            }


            var authSigningKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(_configuration["JWT:Secret"]));

            var token = new JwtSecurityToken(
                issuer: _configuration["JWT:Issuer"],
                audience: _configuration["JWT:Audience"],
                expires: DateTime.UtcNow.AddMinutes(1),
                claims: authClaims,
                signingCredentials: new SigningCredentials(authSigningKey, SecurityAlgorithms.HmacSha256));

            var jwtToken = new JwtSecurityTokenHandler().WriteToken(token);

            if (rToken != null)
            {
                var rTokenResponse = new AuthResultDto()
                {
                    Token = jwtToken,
                    RefreshToken = rToken.Token,
                    ExpiresAt = token.ValidTo
                };
                return rTokenResponse;
            }

            var refreshToken = new RefreshToken()
            {
                JwtId = token.Id,
                IsRevoked = false,
                UserId = user.Id,
                DateAdded = DateTime.UtcNow,
                DateExpire = DateTime.UtcNow.AddMonths(6),
                Token = Guid.NewGuid().ToString() + "-" + Guid.NewGuid().ToString()
            };
            await _context.RefreshTokens.AddAsync(refreshToken);
            await _context.SaveChangesAsync();


            var response = new AuthResultDto()
            {
                Token = jwtToken,
                RefreshToken = refreshToken.Token,
                ExpiresAt = token.ValidTo
            };

            return response;
        }

        

[HttpPost("google")]
    public async Task<IActionResult> GoogleRegesterOrLogin([FromBody] GoogleRegesterOrLoginDto model)
    {
        if (string.IsNullOrWhiteSpace(model.IdToken))
            return BadRequest("Invalid request");

        GoogleJsonWebSignature.Payload payload;

        try
        {
            payload = await GoogleJsonWebSignature.ValidateAsync(model.IdToken,
                new GoogleJsonWebSignature.ValidationSettings
                {
                    Audience = new List<string>
                    {
                    _configuration["GoogleAuthSettings:ClientId"]
                    }
                });
        }
        catch
        {
            return BadRequest("Invalid Google token");
        }

        // Check if user already exists
        var user = await _userManager.FindByEmailAsync(payload.Email);

        if (user == null)
        {
            user = new User
            {
                UserName = payload.Email,                
                Email = payload.Email,
                FullName = payload.Name,                 
                EmailConfirmed = true,
                SecurityStamp = Guid.NewGuid().ToString(),
                CreatedAt = DateTime.UtcNow,

                Country = "Egypt",
                EducationalStage = EducationalStage.Secondary,
                GradeLevel = GradeLevel.Third
            };

            var result = await _userManager.CreateAsync(user);
            if (!result.Succeeded)
                return BadRequest("User creation failed");

            await _userManager.AddToRoleAsync(user, UserRoles.Student);
        }

        // Generate your JWT
        var token = await GenerateJWTTokenAsync(user, null);

        return Ok(token);
    }
        [HttpPost("register-phone")]
        public async Task<IActionResult> RegisterPhone([FromBody] PhoneRegisterDto dto)
        {
            if (!ModelState.IsValid)/// model validation
            {
                return BadRequest(new { Message = "Validation Failed", Errors = ModelState });
            }

            // 1. Check if the phone number already exists
            var existingUser = await _userManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == dto.PhoneNumber);
            // exist virified , or not verified
            if (existingUser != null)
            {
                if (existingUser.PhoneNumberConfirmed)
                {
                    return BadRequest(new { Message = "This phone number is already registered. Please log in." });
                }

                // 2. If they exist but never verified their phone, just generate and send a NEW code
                var resendCode = await _userManager.GenerateChangePhoneNumberTokenAsync(existingUser, existingUser.PhoneNumber);

                // TODO: Call your SMS service provider here to send 'resendCode' to existingUser.PhoneNumber

                return Ok(new { Message = "Account exists but is unverified. A new SMS code has been sent." });
            }

            // 3. Create the new User
            User newUser = new User()
            {
                UserName = dto.PhoneNumber, 
                PhoneNumber = dto.PhoneNumber,
                CreatedAt = DateTime.UtcNow,

                // default values
                PhoneNumberConfirmed = false,
                FullName = dto.Name, // Using the duplicate-friendly property we discussed
                Email = $"{dto.PhoneNumber}@motqin.internal", // Dummy email to bypass Identity's unique email requirement
                SecurityStamp = Guid.NewGuid().ToString(),
                Country = "Egypt",
                EducationalStage = EducationalStage.Secondary,
                GradeLevel = GradeLevel.Third
            };

            // 4. Generate a random complex password to satisfy Identity's password rules

            // (Guid + uppercase + lowercase + number + special character)
            string randomGeneratedPassword = Guid.NewGuid().ToString() + "Aa1@";

            var result = await _userManager.CreateAsync(newUser, randomGeneratedPassword);

            if (result.Succeeded)
            {
                await _userManager.AddToRoleAsync(newUser, UserRoles.Student);

                // 5. Generate the 6-digit SMS OTP Token
                var code = await _userManager.GenerateChangePhoneNumberTokenAsync(newUser, newUser.PhoneNumber);

                try
                {
                    // TODO: Call your SMS provider (e.g., Twilio, Infobip, Vodafone) here
                    // await _smsService.SendSmsAsync(newUser.PhoneNumber, $"Your Motqin verification code is: {code}");

                    return Ok(new { Message = $"Registration successful. Please check your phone for the verification code, your code is {code}" });
                }
                catch (Exception)
                {
                    return Ok(new { Message = "Registration successful, but SMS failed to send. Please request a new code.", RequiresSmsResend = true });
                }
            }

            // 6.Handle unexpected Identity errors
            var identityErrors = result.Errors.Select(e => e.Description).ToList();
            return BadRequest(new { Message = "Registration Failed", Errors = identityErrors });
        }


        [HttpPost("verify-phone")]
        public async Task<IActionResult> VerifyPhone([FromBody] PhoneVerifyDto dto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(new { Message = "Validation Failed", Errors = ModelState });
            }

            // 1. Find the user
            var user = await _userManager.Users.FirstOrDefaultAsync(u => u.PhoneNumber == dto.PhoneNumber);

            if (user == null)
            {
                return BadRequest(new { Message = "Invalid phone number." });
            }

            if (user.PhoneNumberConfirmed)
            {
                return BadRequest(new { Message = "This phone number is already verified." });
            }

            // 2. Validate the SMS code
            var isVerified = await _userManager.VerifyChangePhoneNumberTokenAsync(user, dto.Code, user.PhoneNumber);

            if (isVerified)
            {
                // 3. Mark the phone as confirmed in the database
                user.PhoneNumberConfirmed = true;
                await _userManager.UpdateAsync(user);

                // 4. Best UX: Automatically log them in by returning a JWT token right now
                var token = await GenerateJWTTokenAsync(user, null);

                return Ok(new
                {
                    Message = "Phone number verified successfully.",
                    Token = token // The frontend saves this and redirects them to the main screen
                });
            }

            return BadRequest(new { Message = "Invalid or expired verification code." });
        }

        [HttpPost("facebook")]
        public async Task<IActionResult> FacebookLogin([FromBody] FacebookLoginDto model)
        {
            if (string.IsNullOrWhiteSpace(model.AccessToken))
                return BadRequest("Invalid request");

            var httpClient = _httpClientFactory.CreateClient();

            // 1. Get app credentials from appsettings
            var appId = _configuration["Authentication:Facebook:AppId"];
            var appSecret = _configuration["Authentication:Facebook:AppSecret"];

            // 2. Validate the token using Facebook's debug_token endpoint
            var debugTokenUrl = $"https://graph.facebook.com/debug_token?input_token={model.AccessToken}&access_token={appId}|{appSecret}";
            var tokenValidationResponse = await httpClient.GetAsync(debugTokenUrl);

            if (!tokenValidationResponse.IsSuccessStatusCode)
                return BadRequest("Invalid Facebook token");

            var validationResult = await tokenValidationResponse.Content.ReadFromJsonAsync<FacebookTokenValidationResult>();

            if (validationResult == null || !validationResult.Data.IsValid || validationResult.Data.AppId != appId)
            {
                return Unauthorized("Token is invalid or not associated with this application.");
            }

            // 3. Fetch user info using the validated token
            var userInfoUrl = $"https://graph.facebook.com/v18.0/me?fields=id,email,name&access_token={model.AccessToken}";
            var userInfoResponse = await httpClient.GetAsync(userInfoUrl);

            if (!userInfoResponse.IsSuccessStatusCode)
                return BadRequest("Failed to retrieve user info from Facebook.");

            var facebookUser = await userInfoResponse.Content.ReadFromJsonAsync<FacebookUserInfoResult>();

            if (facebookUser == null || string.IsNullOrWhiteSpace(facebookUser.Email))
            {
                // Note: Users can sign up for Facebook using only a phone number, which means Email might be null.
                return BadRequest("Your Facebook account does not have an associated email address.");
            }

            // 4. Check if user already exists in your database
            var user = await _userManager.FindByEmailAsync(facebookUser.Email);

            if (user == null)
            {
                // 5. Create new user if they don't exist
                user = new User
                {
                    Email = facebookUser.Email,
                    UserName = facebookUser.Email, 
                    EmailConfirmed = true,         
                    SecurityStamp = Guid.NewGuid().ToString(),
                    FullName = facebookUser.Name,  
                    CreatedAt = DateTime.UtcNow,

                    // Your default values
                    Country = "Egypt",
                    EducationalStage = EducationalStage.Secondary,
                    GradeLevel = GradeLevel.Third
                };

                var result = await _userManager.CreateAsync(user);
                if (!result.Succeeded)
                    return BadRequest(new { Message = "User creation failed", Errors = result.Errors.Select(e => e.Description) });

                await _userManager.AddToRoleAsync(user, UserRoles.Student);
            }

            // 6. Generate your application's JWT
            var token = await GenerateJWTTokenAsync(user, null);

            return Ok(token);
        }


    }
}
