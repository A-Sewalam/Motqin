using Microsoft.EntityFrameworkCore;
using Motqin.Data;
using Motqin.Models;
using Motqin.Dtos.Question;

namespace Motqin.Services
{
    public interface IQuestionsService
    {
        Task<bool> ExistsByTextAsync(string questionText, int lessonId);
        Task<(List<Question> Items, int Total)> GetPagedAsync(int? lessonId, string? category, string? search, int page, int pageSize, string? sort);
        Task<QuestionDetails> StartQuestionAsync(int questionId, int sessionId, DateTime startTime);
        Task<QuestionDetails> EndQuestionAsync(int questionId, int sessionId, DateTime endTime, string? userAnswer, bool isCorrect);
        Task<Question> CreateFillInTheBlankQuestionAsync(FillInTheBlankQuestionDto questionDto);
        Task<Question> CreateMultipleChoiceQuestionAsync(MultipleChoiceQuestionDto questionDto);
        Task<bool> DeleteAsync(int id);
        Task<bool> ExistsAsync(int id);
        Task<List<Question>> GetAllAsync();
        Task<List<Question>> GetByCategoryAndLessonIdAsync(string category, int lessonId);
        Task<Question?> GetByIdAsync(int id);
        Task<QuestionDetails?> GetDetailsByIdAsync(int id);
        Task<List<Question>> GetByLessonIdAsync(int lessonId);
        Task<bool> UpdateAsync(Question question);
        Task<bool> UpdateFillInTheBlankQuestionAsync(FillInTheBlankQuestionDto dto);
        Task<bool> UpdateMultipleChoiceQuestionAsync(MultipleChoiceQuestionDto dto);
        Task UserAddQuestion(UserAddedQuestion question);
        Task UserDeleteQuestion(int questionId, string UserId);
    }

    public class QuestionsService : IQuestionsService
    {
        private readonly AppDbContext _context;

        public QuestionsService(AppDbContext context)
        {
            _context = context;
        }

        public async Task<(List<Question> Items, int Total)> GetPagedAsync(int? lessonId, string? category, string? search, int page, int pageSize, string? sort)
        {
            if (page <= 0) page = 1;
            if (pageSize <= 0) pageSize = 20;

            var query = _context.Questions.AsQueryable();

            if (lessonId.HasValue)
                query = query.Where(q => q.LessonID == lessonId.Value);

            if (!string.IsNullOrWhiteSpace(category))
                query = query.Where(q => q.QuestionCategory == category);

            if (!string.IsNullOrWhiteSpace(search))
                query = query.Where(q => q.QuestionText.Contains(search));

            var total = await query.CountAsync();

            // sorting (basic)
            if (!string.IsNullOrWhiteSpace(sort))
            {
                if (sort.Equals("difficulty", StringComparison.OrdinalIgnoreCase))
                    query = query.OrderBy(q => q.DifficultyLevel);
                else if (sort.Equals("created", StringComparison.OrdinalIgnoreCase))
                    query = query.OrderBy(q => q.QuestionID);
                else
                    query = query.OrderBy(q => q.QuestionID);
            }
            else
            {
                query = query.OrderBy(q => q.QuestionID);
            }

            var items = await query.Skip((page - 1) * pageSize).Take(pageSize).AsNoTracking().ToListAsync();
            return (items, total);
        }

        public async Task<List<Question>> GetAllAsync() =>
            await _context.Questions.AsNoTracking().ToListAsync();

        public async Task<Question?> GetByIdAsync(int id)
        {
            return await _context.Questions
                                 .AsNoTracking()
                                 .FirstOrDefaultAsync(q => q.QuestionID == id);
        }

        public async Task<bool> ExistsByTextAsync(string questionText, int lessonId)
        {
            return await _context.Questions
                .AnyAsync(q => q.LessonID == lessonId && q.QuestionText == questionText);
        }

        public async Task<QuestionDetails> StartQuestionAsync(int questionId, int sessionId, DateTime startTime)
        {
            // ensure question exists
            var questionExists = await _context.Questions.AnyAsync(q => q.QuestionID == questionId);
            if (!questionExists) throw new KeyNotFoundException("Question not found");

            var session = await _context.SpacedRepetitionSessions.FindAsync(sessionId);
            if (session == null) throw new KeyNotFoundException("Session not found");

            var details = await _context.QuestionDetails.FirstOrDefaultAsync(d => d.SessionID == sessionId && d.QuestionID == questionId);
            if (details == null)
            {
                details = new QuestionDetails
                {
                    SessionID = sessionId,
                    QuestionID = questionId,
                    StartTime = startTime,
                    EndTime = default,
                    UserAnswer = null,
                    IsCorrect = false
                };
                _context.QuestionDetails.Add(details);
            }
            else
            {
                details.StartTime = startTime;
            }
            await _context.SaveChangesAsync();
            return details;
        }

        public async Task<QuestionDetails> EndQuestionAsync(int questionId, int sessionId, DateTime endTime, string? userAnswer, bool isCorrect)
        {
            var questionExists = await _context.Questions.AnyAsync(q => q.QuestionID == questionId);
            if (!questionExists) throw new KeyNotFoundException("Question not found");

            var session = await _context.SpacedRepetitionSessions.FindAsync(sessionId);
            if (session == null) throw new KeyNotFoundException("Session not found");

            var details = await _context.QuestionDetails.FirstOrDefaultAsync(d => d.SessionID == sessionId && d.QuestionID == questionId);
            if (details == null)
            {
                details = new QuestionDetails
                {
                    SessionID = sessionId,
                    QuestionID = questionId,
                    StartTime = DateTime.UtcNow,
                    EndTime = endTime,
                    UserAnswer = userAnswer,
                    IsCorrect = isCorrect
                };
                _context.QuestionDetails.Add(details);
            }
            else
            {
                details.EndTime = endTime;
                details.UserAnswer = userAnswer;
                details.IsCorrect = isCorrect;
            }
            await _context.SaveChangesAsync();
            return details;
        }
        public async Task<QuestionDetails?> GetDetailsByIdAsync(int id)
        {
            return await _context.QuestionDetails
                                 .AsNoTracking()
                                 .FirstOrDefaultAsync(q => q.QuestionID == id);
        }
        public async Task<List<Question>> GetByLessonIdAsync(int lessonId)
        {
            return await _context.Questions
                          .Where(q => q.LessonID == lessonId)
                          .AsNoTracking()
                          .ToListAsync();
        }

        public async Task<List<Question>> GetByCategoryAndLessonIdAsync(string category, int lessonId)
        {
            return await _context.Questions
                            .Where(q => q.QuestionCategory == category && q.LessonID == lessonId)
                            .AsNoTracking()
                            .ToListAsync();
        }

        // return type Question or MultipleChoiceQuestion (??)
        public async Task<Question> CreateMultipleChoiceQuestionAsync(MultipleChoiceQuestionDto questionDto)
        {
            var lessonExists = await _context.Lessons
                    .AnyAsync(l => l.LessonId == questionDto.LessonID);
            if (!lessonExists)
                throw new Exception("Lesson not found");

            var newQuestion = new MultipleChoiceQuestion()
            {
                LessonID = questionDto.LessonID,
                QuestionCategory = questionDto.QuestionCategory,
                QuestionText = questionDto.QuestionText,
                DifficultyLevel = questionDto.DifficultyLevel,
                AnswerOptions = questionDto.AnswerOptions,
                CorrectAnswer = questionDto.CorrectAnswer
            };

            _context.Questions.Add(newQuestion);
            await _context.SaveChangesAsync();
            return newQuestion;
        }

        public async Task<Question> CreateFillInTheBlankQuestionAsync(FillInTheBlankQuestionDto questionDto)
        {
            var lessonExists = await _context.Lessons
                    .AnyAsync(l => l.LessonId == questionDto.LessonID);
            if (!lessonExists)
                throw new Exception("Lesson not found");

            var newQuestion = new FillInTheBlankQuestion()
            {
                LessonID = questionDto.LessonID,
                QuestionCategory = questionDto.QuestionCategory,
                QuestionText = questionDto.QuestionText,
                DifficultyLevel = questionDto.DifficultyLevel,
                CorrectText = questionDto.CorrectText,
                CaseSensitive = questionDto.CaseSensitive
            };

            _context.Questions.Add(newQuestion);
            await _context.SaveChangesAsync();
            return newQuestion;
        }

        public async Task<bool> UpdateAsync(Question question)
        {
            var existing = await _context.Questions.FindAsync(new object[] { question.QuestionID });
            if (existing is null) return false;

            // Update base scalar properties; derived-type-specific properties will be preserved
            existing.LessonID = question.LessonID;
            existing.QuestionText = question.QuestionText;
            existing.DifficultyLevel = question.DifficultyLevel;
            existing.QuestionCategory = question.QuestionCategory;

            _context.Questions.Update(existing);
            await _context.SaveChangesAsync();
            return true;
        }

        // New: update derived MultipleChoiceQuestion fully
        public async Task<bool> UpdateMultipleChoiceQuestionAsync(MultipleChoiceQuestionDto dto)
        {
            var existing = await _context.Questions
                                         .OfType<MultipleChoiceQuestion>()
                                         .FirstOrDefaultAsync(q => q.QuestionID == dto.QuestionID);
            if (existing is null) return false;

            existing.LessonID = dto.LessonID;
            existing.QuestionCategory = dto.QuestionCategory;
            existing.QuestionText = dto.QuestionText;
            existing.DifficultyLevel = dto.DifficultyLevel;
            existing.AnswerOptions = dto.AnswerOptions;
            existing.CorrectAnswer = dto.CorrectAnswer;

            await _context.SaveChangesAsync();
            return true;
        }

        // New: update derived FillInTheBlankQuestion fully
        public async Task<bool> UpdateFillInTheBlankQuestionAsync(FillInTheBlankQuestionDto dto)
        {
            var existing = await _context.Questions
                                         .OfType<FillInTheBlankQuestion>()
                                         .FirstOrDefaultAsync(q => q.QuestionID == dto.QuestionID);
            if (existing is null) return false;

            existing.LessonID = dto.LessonID;
            existing.QuestionCategory = dto.QuestionCategory;
            existing.QuestionText = dto.QuestionText;
            existing.DifficultyLevel = dto.DifficultyLevel;
            existing.CorrectText = dto.CorrectText;
            existing.CaseSensitive = dto.CaseSensitive;

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var existing = await _context.Questions.FindAsync(new object[] { id });
            if (existing is null) return false;

            _context.Questions.Remove(existing);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ExistsAsync(int id) =>
            await _context.Questions.AnyAsync(q => q.QuestionID == id);

        public async Task UserAddQuestion(UserAddedQuestion question)
        {
            await _context.UserAddedQuestions.AddAsync(question);
            await _context.SaveChangesAsync();
        }

        public async Task UserDeleteQuestion(int questionId, string userId)
        {
            var user = _context.Users.FirstOrDefault(u => u.Id == userId);
            var question = _context.UserAddedQuestions.FirstOrDefault(q => q.ID == questionId);
            if (user != null && question != null)
            {
                var userDeletedQuestion = new UserDeletedQuestion
                {
                    UserId = userId,
                    QuestionId = questionId
                };
                _context.Add(userDeletedQuestion);
                await _context.SaveChangesAsync();
            }
        }
    }
}
