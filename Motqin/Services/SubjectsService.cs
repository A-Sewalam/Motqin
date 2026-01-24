using Microsoft.EntityFrameworkCore;
using Motqin.Data;
using Motqin.Enums;
using Motqin.Models;

namespace Motqin.Services
{
    public interface ISubjectsService
    {
        Task<IEnumerable<Subject>> GetAllAsync(string country, GradeLevel gradeLevel, EducationalStage educationalStage);
    }

    public class SubjectsService : ISubjectsService
    {
        private readonly AppDbContext context;

        public SubjectsService(AppDbContext context)
        {
            this.context = context;
        }

        public async Task<IEnumerable<Subject>> GetAllAsync(string country, GradeLevel gradeLevel, EducationalStage educationalStage) =>
            await context.Subjects.Where(s =>s.Country == country && s.GradeLevel == gradeLevel && s.EducationalStage == educationalStage).AsNoTracking().ToListAsync();
    }
}
