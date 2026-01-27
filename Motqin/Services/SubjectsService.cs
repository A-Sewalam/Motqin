using Microsoft.EntityFrameworkCore;
using Motqin.Data;
using Motqin.Dtos.Subject;
using Motqin.Enums;
using Motqin.Models;

namespace Motqin.Services
{
    public interface ISubjectsService
    {
        Task<List<Subject>> GetAllAsync();
        Task<List<Subject>?> GetByUserGradeLevelAsync(int userId);
        Task<Subject?> GetByIdAsync(int id);
        Task<Subject> CreateAsync(SubjectDto subjectDto);
        Task<bool> UpdateAsync(Subject subject);
        Task<bool> DeleteAsync(int id);
        Task<bool> ExistsAsync(int id);
    }

    public class SubjectsService : ISubjectsService
    {
        private readonly AppDbContext _context;

        public SubjectsService(AppDbContext context)
        {
            _context = context;
        }

        public async Task<List<Subject>> GetAllAsync() =>
            await _context.Subjects.AsNoTracking().ToListAsync();

        // New: get subjects matching the user's grade level.
        // Returns null if user not found; returns empty list if user has no grade or no matching subjects.
        public async Task<List<Subject>?> GetByUserGradeLevelAsync(int userId)
        {
            var user = await _context.Users
                                     .AsNoTracking()
                                     .FirstOrDefaultAsync(u => u.UserId == userId);

            if (user is null)
                return null;

            var country = user.Country;
            var gradeLevel = user.GradeLevel;
            var educationalStage = user.EducationalStage;


            var subjects = await GetAllAsync(country, gradeLevel, educationalStage);

            return subjects;
        }

        public async Task<Subject?> GetByIdAsync(int id)
        {
            return await _context.Subjects
                    .AsNoTracking()
                    .FirstOrDefaultAsync(s => s.SubjectID == id);
        }

        public async Task<Subject> CreateAsync(SubjectDto subjectDto)
        {
            var newSubject = new Subject()
            {
                Name = subjectDto.Name,
                Country = subjectDto.Country,
                EducationalStage = subjectDto.EducationalStage,
                GradeLevel = subjectDto.GradeLevel
            };

            _context.Subjects.Add(newSubject);
            await _context.SaveChangesAsync();

            return newSubject;
        }

        public async Task<bool> UpdateAsync(Subject subject)
        {
            // check change tracker first
            var existing = await _context.Subjects.FindAsync(new object[] { subject.SubjectID });
            if (existing is null) return false;

            existing.Name = subject.Name;
            existing.Country = subject.Country;
            existing.EducationalStage = subject.EducationalStage;
            existing.GradeLevel = subject.GradeLevel;

            _context.Subjects.Update(existing);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> DeleteAsync(int id)
        {
            var existing = await _context.Subjects.FindAsync(new object[] { id });
            if (existing is null) return false;

            _context.Subjects.Remove(existing);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ExistsAsync(int id) =>
            await _context.Subjects.AnyAsync(s => s.SubjectID == id);

        private async Task<List<Subject>> GetAllAsync(string country, GradeLevel gradeLevel, EducationalStage educationalStage) =>
            await _context.Subjects.Where(s => s.Country == country && s.GradeLevel == gradeLevel && s.EducationalStage == educationalStage)
                                    .AsNoTracking().ToListAsync();
    }
}
