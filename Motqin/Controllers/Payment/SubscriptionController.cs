using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Motqin.Services.Payment;
using System.Security.Claims;

namespace PaymobIntegration.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SubscriptionController : ControllerBase
    {
        private readonly ISubscriptionService _subscriptionService;

        public SubscriptionController(ISubscriptionService subscriptionService)
        {
            _subscriptionService = subscriptionService;
        }

        //[Authorize]
        [HttpPost("subscribe-to-bundle")]
        public async Task<IActionResult> SubscribeToBundle(string userId, int bundleId)
        {
            try
            {
                //var userId = HttpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                //if (string.IsNullOrEmpty(userId))
                //    return Unauthorized("User not authenticated.");

                var subscription = await _subscriptionService.SubscribeToBundle(userId, bundleId);
                return Ok(new { message = "Subscribed successfully!", expiresAt = subscription.EndDate });
            }
            catch (Exception ex)
            {
                return BadRequest($"Can't Subscibe - {ex.Message}");
            }
        }
    }
}
