using Motqin.Data;
using Motqin.Models.Session;

namespace Motqin.Services
{
    public interface ISessionService
    {
        StudySession? GetById(int id);
    }

    public class SessionService : ISessionService
    {
        private readonly AppDbContext context;

        public SessionService(AppDbContext context)
        {
            this.context = context;
        }

        public StudySession? GetById(int id) => context.StudySessions.Find(id);
    }
}
