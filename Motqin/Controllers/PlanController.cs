using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Motqin.Services;

namespace Motqin.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PlanController : ControllerBase
    {
        private readonly PlanService planService;
        private readonly SessionService sessionService;

        public PlanController(PlanService planService, SessionService sessionService)
        {
            this.planService = planService;
            this.sessionService = sessionService;
        }

        public SessionService SessionService { get; }

        [HttpPost("{id:int}")]
        public async Task<ActionResult> SetSpacedRepititionPlan(int id)
        {
            var plan = planService.GetById(id);
            if (plan == null) return NotFound();
            planService.SetNextReviewDate(plan);

            return Ok(plan);
        }
    }
}
