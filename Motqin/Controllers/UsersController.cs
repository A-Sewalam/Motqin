using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Motqin.Controllers
{
    using Microsoft.AspNetCore.Http.HttpResults;
    using Microsoft.AspNetCore.Mvc;
    using Motqin.Dtos.User;
    using Motqin.Models;
    using Motqin.Services;

    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly IUsersService _usersService;

        public UsersController(IUsersService usersService)
        {
            _usersService = usersService;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<UserReadDto>>> GetAll()
        {
            var users = await _usersService.GetAllAsync();

            var readDtos = users.Select(user => new UserReadDto
            {
                UserId = user.UserId,
                Name = user.Name,
                Email = user.Email,
                Role = user.Role,
                GradeLevel = user.GradeLevel,
                Country = user.Country,
                EducationalStage = user.EducationalStage
            });

            return Ok(readDtos);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<UserReadDto>> GetById(int id)
        {
            var user = await _usersService.GetByIdAsync(id);
            if (user == null) return NotFound();

            var readDto = new UserReadDto
            {
                UserId = user.UserId,
                Name = user.Name,
                Email = user.Email,
                Role = user.Role,
                GradeLevel = user.GradeLevel,
                Country = user.Country,
                EducationalStage = user.EducationalStage
            };

            return Ok(readDto);
        }

        [HttpPost]
        public async Task<ActionResult<UserReadDto>> Create(UserCreateDto createDto)
        {
            var user = new User
            {
                Name = createDto.Name,
                Email = createDto.Email,
                Role = createDto.Role,
                GradeLevel = createDto.GradeLevel,
                PasswordHash = PasswordHasher.HashPassword(createDto.Password),
                Country = createDto.Country,
                EducationalStage = createDto.EducationalStage
            };

            await _usersService.CreateAsync(user);

            var readDto = new UserReadDto
            {
                UserId = user.UserId,
                Name = user.Name,
                Email = user.Email,
                Role = user.Role,
                GradeLevel = user.GradeLevel,
                Country = createDto.Country,
                EducationalStage = createDto.EducationalStage
            };

            return CreatedAtAction(nameof(GetById), new { id = readDto.UserId }, readDto);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, UserUpdateDto updateDto)
        {
            var userToUpdate = await _usersService.GetByIdAsync(id);
            if (userToUpdate == null) return NotFound();

            userToUpdate.Name = updateDto.Name;
            userToUpdate.Role = updateDto.Role;
            userToUpdate.GradeLevel = updateDto.GradeLevel;

            await _usersService.UpdateAsync(userToUpdate);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var user = await _usersService.GetByIdAsync(id);
            if (user == null) return NotFound();

            await _usersService.DeleteAsync(id);
            return NoContent();
        }
    }
}
