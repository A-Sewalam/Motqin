using Microsoft.AspNetCore.Mvc;
using Motqin.Services;
using Motqin.Models;
using Motqin.Dtos.Question;
using Motqin.Dtos.Api;
using Microsoft.AspNetCore.Authorization;
using Motqin.Dtos.Common;

namespace Motqin.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class QuestionsController : ControllerBase
    {
        private readonly QuestionsService _questionsService;

        public QuestionsController(QuestionsService service)
        {
            _questionsService = service;
        }

        [HttpGet]
        public async Task<ActionResult<ApiResponse<PagedResult<QuestionReadDto>>>> GetAll([FromQuery] int? lessonId, [FromQuery] string? category, [FromQuery] string? search, [FromQuery] int page = 1, [FromQuery] int pageSize = 20, [FromQuery] string? sort = null)
        {
            var (items, total) = await _questionsService.GetPagedAsync(lessonId, category, search, page, pageSize, sort);

            var dtos = items.Select(q => new QuestionReadDto
            {
                QuestionID = q.QuestionID,
                LessonID = q.LessonID,
                QuestionCategory = q.QuestionCategory,
                QuestionText = q.QuestionText,
                DifficultyLevel = q.DifficultyLevel,
                QuestionType = q.GetType().Name,
                AnswerOptions = q is MultipleChoiceQuestion mcq ? mcq.AnswerOptions : null,
                CorrectAnswer = q is MultipleChoiceQuestion mcq2 ? mcq2.CorrectAnswer : null,
                CorrectText = q is FillInTheBlankQuestion fib ? fib.CorrectText : null,
                CaseSensitive = q is FillInTheBlankQuestion fib2 ? fib2.CaseSensitive : null
            }).ToList();

            var paged = new PagedResult<QuestionReadDto>
            {
                Items = dtos,
                Total = total,
                Page = page,
                PageSize = pageSize
            };

            return Ok(ApiResponse< Motqin.Dtos.Common.PagedResult<QuestionReadDto> >.Ok(paged));
        }

        [HttpGet("{id:int}")]
        public async Task<ActionResult<ApiResponse<QuestionReadDto>>> GetById(int id)
        {
            if (id <= 0) return BadRequest(ApiResponse<QuestionReadDto>.Fail("invalid_input", "id must be a positive integer."));

            var item = await _questionsService.GetByIdAsync(id);
            if (item is null) return NotFound(ApiResponse<QuestionReadDto>.Fail("not_found", "Question not found."));

            var dto = new QuestionReadDto
            {
                QuestionID = item.QuestionID,
                LessonID = item.LessonID,
                QuestionCategory = item.QuestionCategory,
                QuestionText = item.QuestionText,
                DifficultyLevel = item.DifficultyLevel,
                QuestionType = item.GetType().Name,
                AnswerOptions = item is MultipleChoiceQuestion mcq ? mcq.AnswerOptions : null,
                CorrectAnswer = item is MultipleChoiceQuestion mcq2 ? mcq2.CorrectAnswer : null,
                CorrectText = item is FillInTheBlankQuestion fib ? fib.CorrectText : null,
                CaseSensitive = item is FillInTheBlankQuestion fib2 ? fib2.CaseSensitive : null
            };

            return Ok(ApiResponse<QuestionReadDto>.Ok(dto));
        }

        [HttpGet("by-lesson")]
        public async Task<ActionResult<ApiResponse<IEnumerable<QuestionReadDto>>>> GetByLesson([FromQuery] int lessonId)
        {
            if (lessonId <= 0) return BadRequest(ApiResponse<IEnumerable<QuestionReadDto>>.Fail("invalid_input", "lessonId must be a positive integer."));
            var items = await _questionsService.GetByLessonIdAsync(lessonId);
            var dtos = items.Select(item => new QuestionReadDto
            {
                QuestionID = item.QuestionID,
                LessonID = item.LessonID,
                QuestionCategory = item.QuestionCategory,
                QuestionText = item.QuestionText,
                DifficultyLevel = item.DifficultyLevel,
                QuestionType = item.GetType().Name,
                AnswerOptions = item is MultipleChoiceQuestion mcq ? mcq.AnswerOptions : null,
                CorrectAnswer = item is MultipleChoiceQuestion mcq2 ? mcq2.CorrectAnswer : null,
                CorrectText = item is FillInTheBlankQuestion fib ? fib.CorrectText : null,
                CaseSensitive = item is FillInTheBlankQuestion fib2 ? fib2.CaseSensitive : null
            });
            return Ok(ApiResponse<IEnumerable<QuestionReadDto>>.Ok(dtos));
        }

        [HttpGet("by-category-and-lesson")]
        public async Task<ActionResult<ApiResponse<IEnumerable<QuestionReadDto>>>> GetByCategoryAndLesson([FromQuery] string category, [FromQuery] int lessonId)
        {
            if (lessonId <= 0) return BadRequest(ApiResponse<IEnumerable<QuestionReadDto>>.Fail("invalid_input", "lessonId must be a positive integer."));
            if (string.IsNullOrWhiteSpace(category)) return BadRequest(ApiResponse<IEnumerable<QuestionReadDto>>.Fail("invalid_input", "category is required."));
            var items = await _questionsService.GetByCategoryAndLessonIdAsync(category, lessonId);
            var dtos = items.Select(item => new QuestionReadDto
            {
                QuestionID = item.QuestionID,
                LessonID = item.LessonID,
                QuestionCategory = item.QuestionCategory,
                QuestionText = item.QuestionText,
                DifficultyLevel = item.DifficultyLevel,
                QuestionType = item.GetType().Name,
                AnswerOptions = item is MultipleChoiceQuestion mcq ? mcq.AnswerOptions : null,
                CorrectAnswer = item is MultipleChoiceQuestion mcq2 ? mcq2.CorrectAnswer : null,
                CorrectText = item is FillInTheBlankQuestion fib ? fib.CorrectText : null,
                CaseSensitive = item is FillInTheBlankQuestion fib2 ? fib2.CaseSensitive : null
            });
            return Ok(ApiResponse<IEnumerable<QuestionReadDto>>.Ok(dtos));
        }
        [HttpPost("{id:int}/start")]
        [Authorize]
        public async Task<ActionResult<ApiResponse<QuestionDetailsDto>>> StartQuestion(int id, [FromBody] StartQuestionDto dto)
        {
            if (id <= 0) return BadRequest(ApiResponse<QuestionDetailsDto>.Fail("invalid_input", "id must be a positive integer."));
            if (dto == null) return BadRequest(ApiResponse<QuestionDetailsDto>.Fail("invalid_input", "body is required."));

            var details = await _questionsService.StartQuestionAsync(id, dto.SessionId, dto.StartTime);
            var outDto = new QuestionDetailsDto
            {
                DetailID = details.DetailID,
                SessionID = details.SessionID,
                QuestionID = details.QuestionID,
                StartTime = details.StartTime,
                EndTime = details.EndTime,
                UserAnswer = details.UserAnswer,
                IsCorrect = details.IsCorrect
            };
            return Ok(ApiResponse<QuestionDetailsDto>.Ok(outDto));
        }

        [HttpPost("{id:int}/end")]
        [Authorize]
        public async Task<ActionResult<ApiResponse<QuestionDetailsDto>>> EndQuestion(int id, [FromBody] EndQuestionDto dto)
        {
            if (id <= 0) return BadRequest(ApiResponse<QuestionDetailsDto>.Fail("invalid_input", "id must be a positive integer."));
            if (dto == null) return BadRequest(ApiResponse<QuestionDetailsDto>.Fail("invalid_input", "body is required."));

            var details = await _questionsService.EndQuestionAsync(id, dto.SessionId, dto.EndTime, dto.UserAnswer, dto.IsCorrect);
            var outDto = new QuestionDetailsDto
            {
                DetailID = details.DetailID,
                SessionID = details.SessionID,
                QuestionID = details.QuestionID,
                StartTime = details.StartTime,
                EndTime = details.EndTime,
                UserAnswer = details.UserAnswer,
                IsCorrect = details.IsCorrect
            };
            return Ok(ApiResponse<QuestionDetailsDto>.Ok(outDto));
        }
        [HttpPost("mcq")]
        [Authorize]
        public async Task<ActionResult<ApiResponse<QuestionReadDto>>> CreateMcq([FromBody] MultipleChoiceQuestionDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ApiResponse<QuestionReadDto>.Fail("validation_error", "Invalid request body."));

            if (await _questionsService.ExistsByTextAsync(dto.QuestionText, dto.LessonID))
            {
                return Conflict(ApiResponse<QuestionReadDto>.Fail("duplicate_resource", "A question with the same text already exists for this lesson."));
            }

            var created = await _questionsService.CreateMultipleChoiceQuestionAsync(dto);
            var outDto = new QuestionReadDto
            {
                QuestionID = created.QuestionID,
                LessonID = created.LessonID,
                QuestionCategory = created.QuestionCategory,
                QuestionText = created.QuestionText,
                DifficultyLevel = created.DifficultyLevel,
                QuestionType = created.GetType().Name,
                AnswerOptions = created is MultipleChoiceQuestion mcq ? mcq.AnswerOptions : null,
                CorrectAnswer = created is MultipleChoiceQuestion mcq2 ? mcq2.CorrectAnswer : null
            };
            return CreatedAtAction(nameof(GetById), new { id = created.QuestionID }, ApiResponse<QuestionReadDto>.Ok(outDto));
        }

        [HttpPost("fill")]
        [Authorize]
        public async Task<ActionResult<ApiResponse<QuestionReadDto>>> CreateFill([FromBody] FillInTheBlankQuestionDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ApiResponse<QuestionReadDto>.Fail("validation_error", "Invalid request body."));

            if (await _questionsService.ExistsByTextAsync(dto.QuestionText, dto.LessonID))
            {
                return Conflict(ApiResponse<QuestionReadDto>.Fail("duplicate_resource", "A question with the same text already exists for this lesson."));
            }

            var created = await _questionsService.CreateFillInTheBlankQuestionAsync(dto);
            var outDto = new QuestionReadDto
            {
                QuestionID = created.QuestionID,
                LessonID = created.LessonID,
                QuestionCategory = created.QuestionCategory,
                QuestionText = created.QuestionText,
                DifficultyLevel = created.DifficultyLevel,
                QuestionType = created.GetType().Name,
                CorrectText = created is FillInTheBlankQuestion fib ? fib.CorrectText : null,
                CaseSensitive = created is FillInTheBlankQuestion fib2 ? fib2.CaseSensitive : null
            };
            return CreatedAtAction(nameof(GetById), new { id = created.QuestionID }, ApiResponse<QuestionReadDto>.Ok(outDto));
        }

        [HttpPut("mcq/{id:int}")]
        [Authorize]
        public async Task<ActionResult<ApiResponse<object>>> UpdateMcq(int id, [FromBody] MultipleChoiceQuestionDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ApiResponse<object>.Fail("validation_error", "Invalid request body."));
            if (dto.QuestionID != id) return BadRequest(ApiResponse<object>.Fail("invalid_input", "ID mismatch."));

            var existing = await _questionsService.GetByIdAsync(id);
            if (existing is null) return NotFound(ApiResponse<object>.Fail("not_found", "Question not found."));

            if (!string.Equals(existing.QuestionText, dto.QuestionText, System.StringComparison.OrdinalIgnoreCase)
                && await _questionsService.ExistsByTextAsync(dto.QuestionText, dto.LessonID))
            {
                return Conflict(ApiResponse<object>.Fail("duplicate_resource", "Another question with the same text exists for this lesson."));
            }

            var updated = await _questionsService.UpdateMultipleChoiceQuestionAsync(dto);
            if (!updated) return NotFound(ApiResponse<object>.Fail("not_found", "Question not found or update failed."));
            return NoContent();
        }

        [HttpPut("fill/{id:int}")]
        [Authorize]
        public async Task<ActionResult<ApiResponse<object>>> UpdateFill(int id, [FromBody] FillInTheBlankQuestionDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ApiResponse<object>.Fail("validation_error", "Invalid request body."));
            if (dto.QuestionID != id) return BadRequest(ApiResponse<object>.Fail("invalid_input", "ID mismatch."));

            var existing = await _questionsService.GetByIdAsync(id);
            if (existing is null) return NotFound(ApiResponse<object>.Fail("not_found", "Question not found."));

            if (!string.Equals(existing.QuestionText, dto.QuestionText, System.StringComparison.OrdinalIgnoreCase)
                && await _questionsService.ExistsByTextAsync(dto.QuestionText, dto.LessonID))
            {
                return Conflict(ApiResponse<object>.Fail("duplicate_resource", "Another question with the same text exists for this lesson."));
            }

            var updated = await _questionsService.UpdateFillInTheBlankQuestionAsync(dto);
            if (!updated) return NotFound(ApiResponse<object>.Fail("not_found", "Question not found or update failed."));
            return NoContent();
        }

        [HttpDelete("{id:int}")]
        [Authorize]
        public async Task<ActionResult<ApiResponse<object>>> Delete(int id)
        {
            if (id <= 0) return BadRequest(ApiResponse<object>.Fail("invalid_input", "id must be a positive integer."));

            var deleted = await _questionsService.DeleteAsync(id);
            if (!deleted) return NotFound(ApiResponse<object>.Fail("not_found", "Question not found."));
            return NoContent();
        }

        [HttpDelete("user/{id:int}")]
        [Authorize]
        public async Task<ActionResult<ApiResponse<object>>> DeleteUserQuestion(int id, [FromQuery] string userId)
        {
            if (id <= 0) return BadRequest(ApiResponse<object>.Fail("invalid_input", "id must be a positive integer."));
            if (string.IsNullOrWhiteSpace(userId)) return BadRequest(ApiResponse<object>.Fail("invalid_input", "userId is required."));

            await _questionsService.UserDeleteQuestion(id, userId);
            return NoContent();
        }

        [HttpPost("user/fill")]
        [Authorize]
        public async Task<ActionResult<ApiResponse<UserAddedQuestion>>> UserAddFill([FromBody] FillInTheBlankQuestionDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ApiResponse<UserAddedQuestion>.Fail("validation_error", "Invalid request body."));

            var question = new UserAddedQuestion
            {
                LessonID = dto.LessonID,
                DisplayOrder = 0,
                Priority = 2,
                QuestionCategory = dto.QuestionCategory,
                QuestionText = dto.QuestionText,
                DifficultyLevel = dto.DifficultyLevel
            };
            await _questionsService.UserAddQuestion(question);
            return CreatedAtAction(nameof(GetById), new { id = question.ID }, ApiResponse<UserAddedQuestion>.Ok(question));
        }

        [HttpPost("user/mcq")]
        [Authorize]
        public async Task<ActionResult<ApiResponse<UserAddedQuestion>>> UserAddMCQ([FromBody] MultipleChoiceQuestionDto dto)
        {
            if (!ModelState.IsValid) return BadRequest(ApiResponse<UserAddedQuestion>.Fail("validation_error", "Invalid request body."));

            var question = new UserAddedQuestion
            {
                LessonID = dto.LessonID,
                DisplayOrder = 0,
                Priority = 2,
                QuestionCategory = dto.QuestionCategory,
                QuestionText = dto.QuestionText,
                DifficultyLevel = dto.DifficultyLevel
            };
            await _questionsService.UserAddQuestion(question);
            return CreatedAtAction(nameof(GetById), new { id = question.ID }, ApiResponse<UserAddedQuestion>.Ok(question));
        }
    }
}