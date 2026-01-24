using Microsoft.AspNetCore.Mvc;
using Motqin.Services;
using Motqin.Models;
using Motqin.Dtos.Question;

namespace Motqin.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class QuestionsController : ControllerBase
    {
        private readonly QuestionsService _service;

        public QuestionsController(QuestionsService service)
        {
            _service = service;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<Question>>> GetAll()
        {
            var items = await _service.GetAllAsync();
            return Ok(items);
        }

        [HttpGet("{id:int}")]
        public async Task<ActionResult<Question>> GetById(int id)
        {
            var item = await _service.GetByIdAsync(id);
            if (item is null) return NotFound();
            return Ok(item);
        }

        [HttpGet("lesson/{lessonId:int}")]
        public async Task<ActionResult<IEnumerable<Question>>> GetByLesson(int lessonId)
        {
            var items = await _service.GetByLessonIdAsync(lessonId);
            return Ok(items);
        }

        [HttpPost("mcq")]
        public async Task<ActionResult<Question>> CreateMcq([FromBody] MultipleChoiceQuestionDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            var created = await _service.CreateMultipleChoiceQuestionAsync(dto);
            return CreatedAtAction(nameof(GetById), new { id = created.QuestionID }, created);
        }

        [HttpPost("fill")]
        public async Task<ActionResult<Question>> CreateFill([FromBody] FillInTheBlankQuestionDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            var created = await _service.CreateFillInTheBlankQuestionAsync(dto);
            return CreatedAtAction(nameof(GetById), new { id = created.QuestionID }, created);
        }

        [HttpPut("mcq/{id:int}")]
        public async Task<IActionResult> UpdateMcq(int id, [FromBody] MultipleChoiceQuestionDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            if (dto.QuestionID != id) return BadRequest("ID mismatch");

            var updated = await _service.UpdateMultipleChoiceQuestionAsync(dto);
            if (!updated) return NotFound();
            return NoContent();
        }

        [HttpPut("fill/{id:int}")]
        public async Task<IActionResult> UpdateFill(int id, [FromBody] FillInTheBlankQuestionDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ModelState);
            if (dto.QuestionID != id) return BadRequest("ID mismatch");

            var updated = await _service.UpdateFillInTheBlankQuestionAsync(dto);
            if (!updated) return NotFound();
            return NoContent();
        }

        [HttpDelete("{id:int}")]
        public async Task<IActionResult> Delete(int id)
        {
            var deleted = await _service.DeleteAsync(id);
            if (!deleted) return NotFound();
            return NoContent();
        }
    }
}