using Microsoft.EntityFrameworkCore;
using Motqin.Data;
using Motqin.Models;
using Motqin.Dtos.Question;

namespace Motqin.Services
{
    public class QuestionsService
    {
        private readonly AppDbContext _context;

        public QuestionsService(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<Question>> GetAllAsync() =>
            await _context.Questions.AsNoTracking().ToListAsync();

        public async Task<Question?> GetByIdAsync(int id)
        {
            return await _context.Questions
                                 .AsNoTracking()
                                 .FirstOrDefaultAsync(q => q.QuestionID == id);
        }

        public async Task<List<Question>> GetByLessonIdAsync(int lessonId) =>
            await _context.Questions
                          .Where(q => q.LessonID == lessonId)
                          .AsNoTracking()
                          .ToListAsync();

        // return type Question or MultipleChoiceQuestion (??)
        public async Task<Question> CreateMultipleChoiceQuestionAsync(MultipleChoiceQuestionDto questionDto)
        {
            var lessonExists = await _context.Lessons
                    .AnyAsync(l => l.LessonID == questionDto.LessonID);
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
                    .AnyAsync(l => l.LessonID == questionDto.LessonID);
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
    }
}
