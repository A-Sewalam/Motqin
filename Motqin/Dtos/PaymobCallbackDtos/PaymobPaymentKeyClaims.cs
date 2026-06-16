using System.Text.Json.Serialization;
namespace Motqin.Dtos.PaymobCallbackModels
{
    public class PaymobPaymentKeyClaims
    {
        [JsonPropertyName("user_id")]
        public int UserId { get; set; }

        [JsonPropertyName("currency")]
        public string? Currency { get; set; }

        [JsonPropertyName("order_id")]
        public long OrderId { get; set; }

        [JsonPropertyName("amount_cents")]
        public int AmountCents { get; set; } 

        [JsonPropertyName("billing_data")]
        public PaymobBillingData? BillingData { get; set; }

        [JsonPropertyName("redirect_url")]
        public string? RedirectUrl { get; set; }

        [JsonPropertyName("integration_id")]
        public int IntegrationId { get; set; }
    }
}
