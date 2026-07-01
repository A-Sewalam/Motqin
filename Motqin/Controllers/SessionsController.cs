using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Motqin.Models.Session;
using Motqin.Services;

namespace Motqin.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class SessionsController : ControllerBase
    {
        private readonly SessionService _sessionService;

        public SessionsController(SessionService service)
        {
            _sessionService = service;
        }
        [HttpGet("Start/{sessionId}")]
        public async Task<ActionResult<StudySession>> StartStudySession(int sessionId, TimeOnly startTime, DateOnly date)
        {
            var session = await _sessionService.GetStudySessionById(sessionId);
            if (session is null) return NotFound();
            session.StartTime = startTime;
            session.Date = date;
            session.Status = Enums.StudySessionStatuses.Inprogress;
            var spacedRepititionSession = session.SpacedRepetitionSession;
            spacedRepititionSession.LastReviewDate = date;
            return Ok(session);
        }
        [HttpGet("End/{sessionId}")]
        public async Task<ActionResult<StudySession>> EndStudySession(int sessionId, TimeOnly endTime, int score)
        {
            var session = await _sessionService.GetStudySessionById(sessionId);
            if (session is null) return NotFound();
            session.EndTime = endTime;
            session.Score = score;
            session.Status = Enums.StudySessionStatuses.Completed;

            var spacedRepititionSession = session.SpacedRepetitionSession;
            spacedRepititionSession.Score = (spacedRepititionSession.Score * spacedRepititionSession.RepetitionNumber + score) / (++spacedRepititionSession.RepetitionNumber);
            return Ok(session);
        }
    }
}
