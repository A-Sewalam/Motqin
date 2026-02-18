using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Motqin.Data.Helpers;
using Motqin.Dtos.Lesson;
using Motqin.Dtos.User;
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
        public async Task<ActionResult<IEnumerable<LessonReadDto>>> GetBySubjectId(int subjectId)
        {
            var lessons = await _lessonsService.GetAllAsync(subjectId);
            return Ok(lessons.Select(l => new LessonReadDto
            {
                LessonId = l.LessonID,
                SubjectID = l.SubjectID,
                Title = l.Title
            }));
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<LessonReadDto>> GetById(int id)
        {
            var lesson = await _lessonsService.GetByIdAsync(id);
            if (lesson == null) return NotFound();

            var readDto = new LessonReadDto
            {
                LessonId = lesson.LessonID,
                SubjectID = lesson.SubjectID,
                Title = lesson.Title
            };

            return Ok(readDto);
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

            return CreatedAtAction(nameof(GetById), new { id = lesson.LessonID }, new LessonReadDto
            {
                LessonId = lesson.LessonID,
                SubjectID = lesson.SubjectID,
                Title = lesson.Title
            });
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, LessonUpdateDto dto)
        {
            var existing = await _lessonsService.GetByIdAsync(id);
            if (existing == null) return NotFound();
            var subjectExists = await _subjectsService.GetByIdAsync(dto.SubjectID);
            if (subjectExists == null) return BadRequest("Invalid SubjectID");

            existing.Title = dto.Title;
            existing.SubjectID = dto.SubjectID;
            await _lessonsService.UpdateAsync(existing);
            return NoContent();
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var lesson = await _lessonsService.GetByIdAsync(id);
            if (lesson == null) return NotFound();

            await _lessonsService.DeleteAsync(id);
            return NoContent();
        }
    }
}
