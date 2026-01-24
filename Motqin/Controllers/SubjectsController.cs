using Microsoft.AspNetCore.Mvc;
using Motqin.Services;
using Motqin.Dtos.Subject;
using Motqin.Models;

namespace Motqin.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SubjectsController : ControllerBase
    {
        private readonly SubjectsService _subjectsService;

        public SubjectsController(SubjectsService service)
        {
            _subjectsService = service;
        }

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