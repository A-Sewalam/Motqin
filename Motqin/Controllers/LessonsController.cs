using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Motqin.Dtos.Api;
using Motqin.Dtos.Lesson;
using Motqin.Models;
using Motqin.Services;

namespace Motqin.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LessonsController : ControllerBase
    {
        private readonly ILessonsService _lessonsService;
        private readonly ISubjectsService _subjectsService;

        public LessonsController(ILessonsService lessonsService, ISubjectsService subjectsService)
        {
            _lessonsService = lessonsService;
            _subjectsService = subjectsService;
        }


        [HttpGet]
        public async Task<ActionResult<ApiResponse<IEnumerable<LessonReadDto>>>> GetBySubjectId([FromQuery] int subjectId)
        {
            if (subjectId <= 0)
                return BadRequest(ApiResponse<IEnumerable<LessonReadDto>>.Fail("invalid_input", "subjectId must be a positive integer."));

            var lessons = await _lessonsService.GetAllAsync(subjectId);
            var dto = lessons.Select(l => new LessonReadDto
            {
                LessonId = l.LessonId,
                SubjectID = l.SubjectID,
                Title = l.Title
            });

            return Ok(ApiResponse<IEnumerable<LessonReadDto>>.Ok(dto));
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ApiResponse<LessonReadDto>>> GetById(int id)
        {
            if (id <= 0) return BadRequest(ApiResponse<LessonReadDto>.Fail("invalid_input", "id must be a positive integer."));

            var lesson = await _lessonsService.GetByIdAsync(id);
            if (lesson == null) return NotFound(ApiResponse<LessonReadDto>.Fail("not_found", "Lesson not found."));

            var readDto = new LessonReadDto
            {
                LessonId = lesson.LessonId,
                SubjectID = lesson.SubjectID,
                Title = lesson.Title
            };

            return Ok(ApiResponse<LessonReadDto>.Ok(readDto));
        }

        [HttpPost]
        public async Task<ActionResult<LessonReadDto>> Create(LessonCreateDto dto)
        {
            var subject = await _subjectsService.GetByIdAsync(dto.SubjectID);
            if (subject == null)
            {
                return BadRequest("Invalid Subject ID.");
            }
            var lesson = new Lesson
            {
                SubjectID = dto.SubjectID,
                Title = dto.Title
            };

            await _lessonsService.CreateAsync(lesson);

            return CreatedAtAction(nameof(GetById), new { id = lesson.LessonId }, new LessonReadDto
            {
                LessonId = lesson.LessonId,
                SubjectID = lesson.SubjectID,
                Title = lesson.Title
            });
        }

        [HttpPut("{id}")]
        [Authorize]
        public async Task<ActionResult<ApiResponse<object>>> Update(int id, [FromBody] LessonUpdateDto dto)
        {
            if (id <= 0) return BadRequest(ApiResponse<object>.Fail("invalid_input", "id must be a positive integer."));
            if (!ModelState.IsValid)
                return BadRequest(ApiResponse<object>.Fail("validation_error", "Invalid request body."));

            var existing = await _lessonsService.GetByIdAsync(id);
            if (existing == null) return NotFound(ApiResponse<object>.Fail("not_found", "Lesson not found."));

            var subjectExists = await _subjectsService.GetByIdAsync(dto.SubjectID);
            if (subjectExists == null) return BadRequest(ApiResponse<object>.Fail("invalid_subject", "Invalid SubjectID."));

            // Check for duplicate title on update (exclude current)
            if (!string.Equals(existing.Title, dto.Title, System.StringComparison.OrdinalIgnoreCase)
                && await _lessonsService.ExistsAsync(dto.Title, dto.SubjectID))
            {
                return Conflict(ApiResponse<object>.Fail("duplicate_resource", "Another lesson with the same title exists for this subject."));
            }

            existing.Title = dto.Title;
            existing.SubjectID = dto.SubjectID;
            await _lessonsService.UpdateAsync(existing);
            return NoContent();
        }
        [HttpDelete("{id}")]
        [Authorize]
        public async Task<ActionResult<ApiResponse<object>>> Delete(int id)
        {
            if (id <= 0) return BadRequest(ApiResponse<object>.Fail("invalid_input", "id must be a positive integer."));

            var lesson = await _lessonsService.GetByIdAsync(id);
            if (lesson == null) return NotFound(ApiResponse<object>.Fail("not_found", "Lesson not found."));

            await _lessonsService.DeleteAsync(id);
            return NoContent();
        }
    }
}
