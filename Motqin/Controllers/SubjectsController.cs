using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Motqin.Data.Helpers;
using Motqin.Dtos.Subject;
using Motqin.Enums;
using Motqin.Models;
using Motqin.Services;

namespace Motqin.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize(Roles = UserRoles.Student)]

    public class SubjectsController : ControllerBase
    {
        private readonly SubjectsService _subjectsService;

        public SubjectsController(SubjectsService service)
        {
            _subjectsService = service;
        }
        // may cause Circular References because of navigation properity!!!!!!!!!!!!!!!!!!!!!!!!!
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Subject>>> GetAll()
        {
            var items = await _subjectsService.GetAllAsync();
            return Ok(items);
        }

        [HttpGet("{id:int}")]
        public async Task<ActionResult<Subject>> GetById(int id)
        {
            var item = await _subjectsService.GetByIdAsync(id);
            if (item is null) return NotFound();
            return Ok(item);
        }

        // New endpoint: subjects for the user's grade level
        //[HttpGet("get-subjects-by-user-grade-level")]
        //public async Task<IActionResult> GetSubjectsByUserGradeLevel(int userId)
        //{
        //    var subjects = await _subjectsService.GetByUserGradeLevelAsync(userId);
        //    if (subjects is null) return NotFound(); // user not found
        //    return Ok(subjects.Select(s => new SubjectReadDto
        //    {
        //        SubjectID = s.SubjectID,
        //        Name = s.Name,
        //        Country = s.Country,
        //        EducationalStage = s.EducationalStage,
        //        GradeLevel = s.GradeLevel
        //    }));
        //}

        [HttpPost]
        public async Task<ActionResult<Subject>> Create([FromBody] SubjectDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            var created = await _subjectsService.CreateAsync(dto);
            return CreatedAtAction(nameof(GetById), new { id = created.SubjectID }, created);
        }

        [HttpPut("{id:int}")]
        public async Task<IActionResult> Update(int id, [FromBody] SubjectDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);

            if (!await _subjectsService.ExistsAsync(id)) return NotFound();

            var subject = new Subject
            {
                SubjectID = id,
                Name = dto.Name,
                Country = dto.Country,
                EducationalStage = dto.EducationalStage,
                GradeLevel = dto.GradeLevel
            };

            var updated = await _subjectsService.UpdateAsync(subject);
            if (!updated) return NotFound();
            return NoContent();
        }

        [HttpDelete("{id:int}")]
        public async Task<IActionResult> Delete(int id)
        {
            var deleted = await _subjectsService.DeleteAsync(id);
            if (!deleted) return NotFound();
            return NoContent();
        }
    }
}