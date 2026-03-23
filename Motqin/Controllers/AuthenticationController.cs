using Google.Apis.Auth;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Motqin.Data;
using Motqin.Data.Helpers;
using Motqin.Dtos.Authentication;
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


        public AuthenticationController(UserManager<User> userManager,
            RoleManager<IdentityRole> roleManager,
            AppDbContext context,
            IConfiguration configuration,
            TokenValidationParameters tokenValidationParameters,
            IEmailService emailService)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _context = context;
            _configuration = configuration;
            _tokenValidationParameters = tokenValidationParameters;
            _emailService = emailService;

        }

        [HttpPost("register-user")]
        public async Task<IActionResult> Register([FromBody] UserRegisterDto userRegisterDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest("Please, provide all the required fields");
            }

            var userExists = await _userManager.FindByEmailAsync(userRegisterDto.EmailAddress);
            if (userExists != null)
            {
                return BadRequest($"User {userRegisterDto.EmailAddress} already exists");
            }

            User newUser = new User()
            {

                Email = userRegisterDto.EmailAddress,
                EmailConfirmed = false,
                UserName = userRegisterDto.UserName,
                SecurityStamp = Guid.NewGuid().ToString(),

                //  default values 
                Country = "Egypt", 
                EducationalStage = EducationalStage.Secondary, 
                GradeLevel = GradeLevel.Third
            };
            var result = await _userManager.CreateAsync(newUser, userRegisterDto.Password);

            if (result.Succeeded)
            {

                //Add user role

                switch (userRegisterDto.Role)
                {
                    case UserRoles.Manager:
                        await _userManager.AddToRoleAsync(newUser, UserRoles.Manager);
                        break;
                    case UserRoles.Student:
                        await _userManager.AddToRoleAsync(newUser, UserRoles.Student);
                        break;
                    default:
                        break;
                }

                // generate email confirmation token
                var code = await _userManager.GenerateEmailConfirmationTokenAsync(newUser);

                // email service to send the mail, but not implemented yet 

               await _emailService.SendEmailAsync(
               newUser.Email,
               "Confirm your email",
                $@"
                <h2>Welcome {newUser.UserName}!</h2>    
                <p>Your email verification code is:</p>
                <h3>{code}</h3>
                <p>Please enter this code in the application to verify your email.</p>
                ");



                return Ok($"Please confirm your email with the code sent to you ");
            }
            return BadRequest("User could not be created");
        }

        [HttpPost("VerifyEmailAuthority")]
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


        [HttpPost("login-user")]
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
                new Claim(ClaimTypes.Name, user.UserName),
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

        

[HttpPost("google-regester-or-login")]
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
                Email = payload.Email,
                UserName = payload.Email,
                EmailConfirmed = true, // Google already verified email
                SecurityStamp = Guid.NewGuid().ToString(),
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


}
}
