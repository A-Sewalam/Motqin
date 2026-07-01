using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.SemanticKernel;
using Microsoft.SemanticKernel.Connectors.Google;
using Motqin.Dtos.Planner;
using Motqin.Models;
using Motqin.Services;
using System.Text.Json;

namespace Motqin.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PlannerController : ControllerBase
    {
        private readonly IPlannerService plannerService;
        private readonly Kernel kernel;

        public PlannerController(IPlannerService plannerService, Kernel kernel)
        {
            this.plannerService = plannerService;
            this.kernel = kernel;
        }

        [HttpPost("Times/")]
        public async Task<ActionResult<FreeTime>> AddFreetime(FreetimeDto freetime)
        {
            var _freetime = await plannerService.AddFreeTime(freetime);
            return Ok(_freetime);
        }

        [HttpPost("UserLessons/")]
        public async Task<ActionResult<UserLessons>> AddLessonToBeStudied(ToBeStudiedDto toBeStudied)
        {
            var lesson = await plannerService.AddLessonToBeStudied(toBeStudied);
            return Ok(lesson);
        }

        [HttpDelete]
        public async Task<IActionResult> DeleteFreetime(int id)
        {
            await plannerService.DeleteFreeTime(id);
            return NoContent();
        }

        [HttpGet]
        public async Task<IActionResult> MakePlan(string UserId)
        {
            await plannerService.Plan(UserId);
            return Ok();
        }
        
        [HttpPost("generate-schedule")]
        public async Task<IActionResult> GenerateSchedule([FromQuery] string userId)
        {
            // 1. Fetch contextual application data
            var freeTimeSlots = plannerService.GetFreeTimes(userId);

            var LessonsToStudy = plannerService.GetLessonsToStudy(userId);

            var LessonsToReview = plannerService.GetLessonsToReview(userId);

            // 2. Build the system prompt embedding constraints and parameters
            string systemPrompt = $"""
            You are an automated academic scheduler. Your job is to pair pending lessons with available free time slots.
            
            CRITERIA:
            - Prioritize placing high-difficulty lessons early in the day when focus levels are highest.
            - Never schedule overlapping sessions.
            - Provide a brief focus tip tailored to the specific topic.
            -CRITICAL OUTPUT FORMATTING:
            - All time strings for PlannedStartTime and PlannedEndTime MUST use the exact strict format: "HH:mm:ss" (e.g., "14:30:00"). Do not include dates, AM/PM indicators, or localized strings.

            AVAILABLE TIME SLOTS:
            {JsonSerializer.Serialize(freeTimeSlots)}

            LESSONS TO STUDY:
            {JsonSerializer.Serialize(LessonsToStudy)}

            LESSONS TO REVIEW:
            {JsonSerializer.Serialize(LessonsToReview)}
            """;

            // 3. Configure execution settings optimized specifically for Gemini
            GeminiPromptExecutionSettings settings = new()
            {
                // Tell Gemini to return valid JSON
                ResponseMimeType = "application/json",

                // Pass your target C# model type directly to enforce the structural schema
                ResponseSchema = typeof(PlannerResponse),

                Temperature = 0.2f
            };

            // 4. Send request to Gemini
            var chatResult = await kernel.InvokePromptAsync(systemPrompt, new KernelArguments(settings));

            // 5. Parse JSON string into C# Record
            var structuredPlan = JsonSerializer.Deserialize<PlannerResponse>(chatResult.ToString(), new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });

            if (structuredPlan == null)
            {
                return BadRequest("The AI engine failed to generate a coherent structural plan.");
            }

            // 6. Map and persist to DB here...
            // foreach (var slot in structuredPlan.ScheduledSlots) { ... }

            return Ok(new
            {
                Message = "Schedule successfully generated and saved.",
                Reasoning = structuredPlan.OptimizationReasoning
            });
        }
    }
}
