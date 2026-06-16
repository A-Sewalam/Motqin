using System.Text.Json.Serialization;
namespace Motqin.Dtos.PaymobCallbackModels
{
    public class PaymobWebhookResult
    {
        [JsonPropertyName("type")]
        public string? Type { get; set; }

        [JsonPropertyName("obj")]
        public PaymobTransactionObj? Obj { get; set; }

        [JsonPropertyName("issuer_bank")]
        public string? IssuerBank { get; set; }

        [JsonPropertyName("transaction_processed_callback_responses")]
        public string? TransactionProcessedCallbackResponses { get; set; }
    }
}
