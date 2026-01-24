using Microsoft.EntityFrameworkCore;
using Motqin.Data;
using Motqin.Models;

namespace Motqin.Services
{
    public interface ILessonsService
    {
        Task<IEnumerable<Lesson>> GetAllAsync(int subjectId);
        Task<Lesson?> GetByIdAsync(int id);
        Task CreateAsync(Lesson lesson);
        Task UpdateAsync(Lesson lesson);
        Task DeleteAsync(int id);
    }

    public class LessonsService : ILessonsService
    {
        private readonly AppDbContext _context;
        public LessonsService(AppDbContext context) => _context = context;

        public async Task<IEnumerable<Lesson>> GetAllAsync(int subjectId) =>
            await _context.Lessons.Where(l => l.SubjectID == subjectId).AsNoTracking().ToListAsync();

        public async Task<Lesson?> GetByIdAsync(int id) =>
            await _context.Lessons.FindAsync(id);

        public async Task CreateAsync(Lesson lesson)
        {
            await _context.Lessons.AddAsync(lesson);
            await _context.SaveChangesAsync();
        }

        public async Task UpdateAsync(Lesson lesson)
        {
            var existingLesson = await _context.Lessons.FindAsync(lesson.LessonID);
            if (existingLesson == null) return;
            existingLesson.Title = lesson.Title;
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var lesson = await _context.Lessons.FindAsync(id);
            if (lesson != null)
            {
                _context.Lessons.Remove(lesson);
                await _context.SaveChangesAsync();
            }
        }
    }
}
