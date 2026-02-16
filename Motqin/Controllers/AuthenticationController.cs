using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Motqin.Data;
using Motqin.Dtos.Authentication;
using Motqin.Enums;
using Motqin.Models;

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

        public AuthenticationController(UserManager<User> userManager,
            RoleManager<IdentityRole> roleManager,
            AppDbContext context,
            IConfiguration configuration)
        {
            _userManager = userManager;
            _roleManager = roleManager;
            _context = context;
            _configuration = configuration;
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

            if (result.Succeeded) return Ok("User created");
            return BadRequest("User could not be created");
        }
    }
}
