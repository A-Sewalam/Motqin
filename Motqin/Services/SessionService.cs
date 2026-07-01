using Motqin.Data;
using Motqin.Models.Session;
using System.Threading.Tasks;

namespace Motqin.Services
{
    public interface ISessionService
    {
        Task<StudySession?> GetStudySessionById(int id);
        Task<SpacedRepetitionSession?> GetSPacedRepititionById(int id);
    }

    public class SessionService : ISessionService
    {
        private readonly AppDbContext context;

        public SessionService(AppDbContext context)
        {
            this.context = context;
        }

        public async Task<SpacedRepetitionSession?> GetSPacedRepititionById(int id) => await context.SpacedRepetitionSessions.FindAsync(id);

        public async Task<StudySession?> GetStudySessionById(int id) => await context.StudySessions.FindAsync(id);
    }
}
