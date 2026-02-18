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


        public AuthenticationController(UserManager<User> userManager,
            RoleManager<IdentityRole> roleManager,
            AppDbContext context,
            IConfiguration configuration,
            TokenValidationParameters tokenValidationParameters)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _context = context;
            _configuration = configuration;
            _tokenValidationParameters = tokenValidationParameters;

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

                return Ok("User created");
            }
            return BadRequest("User could not be created");
        }

        [HttpPost("login-user")]
        public async Task<IActionResult> Login([FromBody] LoginDto loginDto)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest("Please, provide all required fields");
            }

            var userExists = await _userManager.FindByEmailAsync(loginDto.EmailAddress);
            if (userExists != null && await _userManager.CheckPasswordAsync(userExists, loginDto.Password))
            {
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
                var tokenCheckResult = jwtTokenHandler.ValidateToken(tokenRequestVM.Token/*This is the token whose authenticity you must prove*/,
                    _tokenValidationParameters/*A rulebook describing how the token must be validated.*/,
                    out var validatedToken/*Receives the validated token object -- out used to returen one more thing from the function*/);

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

            var jwtToken = new JwtSecurityTokenHandler().WriteToken(token); //  here when we receive the final format of the token.

            if (rToken != null) //here if a fresh token is valid, we just need to make a new token.
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
    }
}
