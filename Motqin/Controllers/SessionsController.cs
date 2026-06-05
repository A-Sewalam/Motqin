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
        private readonly SubjectsService _subjectsService;

        public SessionsController(SubjectsService service)
        {
            _subjectsService = service;
        }
        [HttpGet("Start/{sessionId}")]
        public async Task<ActionResult<SpacedRepetitionSession>> StartStudySession(int sessionId, DateTime startTime)
        {
            var session = await _subjectsService.GetStudySessionById(sessionId);
            if (session is null) return NotFound();
            session.StartTime = startTime;
            session.RepetitionNumber++;
            return Ok(session);
        }
        [HttpGet("End/{sessionId}")]
        public async Task<ActionResult<SpacedRepetitionSession>> EndStudySession(int sessionId, DateTime endTime, int score)
        {
            var session = await _subjectsService.GetStudySessionById(sessionId);
            if (session is null) return NotFound();
            session.EndTime = endTime;
            session.Score = score;
            return Ok(session);
        }
    }
}
