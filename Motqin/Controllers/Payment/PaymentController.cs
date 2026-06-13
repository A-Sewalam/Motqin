using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Motqin.Data.Helpers;
using Motqin.Dtos.PaymobCallbackModels;
using Motqin.Services.Payment;
using System.Security.Claims;

namespace Motqin.Controllers.Payment
{
    [Route("api/[controller]")]
    [ApiController]
    public class PaymentController : ControllerBase
    {
        private readonly IPaymobService _paymobService;

        public PaymentController(IPaymobService paymobService)
        {
            _paymobService = paymobService;
        }

        //[Authorize]
        [HttpPost("recharge-wallet")]
        public async Task<IActionResult> RechargeWallet(
            [FromQuery] string userId,
            [FromQuery] decimal amount)
        {
            try
            {
                //var userId = HttpContext.User.FindFirst(ClaimTypes.NameIdentifier)?.Value;
                //if (string.IsNullOrEmpty(userId))
                //    return Unauthorized("User not authenticated.");

                if (amount <= 0)
                    return BadRequest("Amount must be positive");

                var redirectUrl = await _paymobService.ProcessPaymentAsync(userId, amount);
                return Ok(new {RedirectUrl =  redirectUrl});
            }
            catch (Exception ex)
            {
                return BadRequest($"Error processing payment: {ex.Message}");
            }
        }


        [HttpGet("client-callback")]
        public async Task<IActionResult> ClientCallback()
        {
            try
            {
                var query = Request.Query;
                if (_paymobService.ValidateHmacQuery(query))
                {
                    bool.TryParse(query["success"], out bool isSuccess);
                    var specialReference = query["merchant_order_id"];

                    if (isSuccess)
                        return Content(HtmlGenerator.GenerateSuccessHtml(), "text/html");

                    return Content(HtmlGenerator.GenerateFailedHtml(), "text/html");
                }
                return Content(HtmlGenerator.GenerateSecurityHtml(), "text/html");
            }
            catch (Exception ex)
            {
                return BadRequest($"message = {ex.Message}");
            }
        }


        [HttpPost("server-callback")]
        public async Task<IActionResult> ServerCallback([FromBody] PaymobWebhookResult payload)
        {
            try
            {
                if (payload?.Obj == null)
                    return BadRequest("Invalid payload structure.");

                if (!_paymobService.ValidateHmacPayload(payload, Request.Query["hmac"]))
                    return Unauthorized("Invalid HMAC");

                PaymobTransactionObj obj = payload.Obj;
                string? merchantOrderId = obj.Order?.MerchantOrderId;
                int amountCents = obj.AmountCents;
                long paymobTransactionId = obj.Id;
                string paymentMethod = obj.SourceData?.Type ?? "N/A";
                bool isSuccess = obj.Success;

                if (string.IsNullOrEmpty(merchantOrderId))
                    return BadRequest("Missing merchant_order_id, Can't link transaction.");
                
                if (!obj.Pending)
                    await _paymobService.UpdatePaymentProcessAsync(isSuccess, merchantOrderId, paymobTransactionId, paymentMethod, amountCents);
                else
                    return Ok(new { message = "Transaction is still pending on Paymob." });

                return Ok(new { message = "Transaction is processed successfully." });
            }
            catch (Exception ex)
            {
                return BadRequest($"Error processing server callback {ex.Message}");
            }
        }

    }

}
