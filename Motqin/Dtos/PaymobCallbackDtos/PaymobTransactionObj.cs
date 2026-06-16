using System.Text.Json.Serialization;
namespace Motqin.Dtos.PaymobCallbackModels
{
    public class PaymobTransactionObj
    {
        [JsonPropertyName("id")]
        public long Id { get; set; }

        [JsonPropertyName("pending")]
        public bool Pending { get; set; }

        [JsonPropertyName("amount_cents")]
        public int AmountCents { get; set; }

        [JsonPropertyName("success")]
        public bool Success { get; set; }

        [JsonPropertyName("is_auth")]
        public bool IsAuth { get; set; }

        [JsonPropertyName("is_capture")]
        public bool IsCapture { get; set; }

        [JsonPropertyName("is_standalone_payment")]
        public bool IsStandalonePayment { get; set; }

        [JsonPropertyName("is_voided")]
        public bool IsVoided { get; set; }

        [JsonPropertyName("is_refunded")]
        public bool IsRefunded { get; set; }

        [JsonPropertyName("is_3d_secure")]
        public bool Is3dSecure { get; set; }

        [JsonPropertyName("integration_id")]
        public int IntegrationId { get; set; }

        [JsonPropertyName("profile_id")]
        public int ProfileId { get; set; }

        [JsonPropertyName("has_parent_transaction")]
        public bool HasParentTransaction { get; set; }

        [JsonPropertyName("order")]
        public PaymobOrder? Order { get; set; }

        [JsonPropertyName("created_at")]
        public DateTime CreatedAt { get; set; }

        [JsonPropertyName("currency")]
        public string? Currency { get; set; }

        [JsonPropertyName("source_data")]
        public PaymobSourceData? SourceData { get; set; }

        [JsonPropertyName("api_source")]
        public string? ApiSource { get; set; }

        [JsonPropertyName("terminal_id")]
        public string? TerminalId { get; set; }

        [JsonPropertyName("merchant_commission")]
        public int? MerchantCommission { get; set; }

        [JsonPropertyName("installment")]
        public string? Installment { get; set; }

        [JsonPropertyName("discount_details")]
        public List<object>? DiscountDetails { get; set; }

        [JsonPropertyName("is_void")]
        public bool IsVoid { get; set; }

        [JsonPropertyName("is_refund")]
        public bool IsRefund { get; set; }

        [JsonPropertyName("data")]
        public PaymobGatewayData? Data { get; set; }

        [JsonPropertyName("is_hidden")]
        public bool IsHidden { get; set; }

        [JsonPropertyName("payment_key_claims")]
        public PaymobPaymentKeyClaims? PaymentKeyClaims { get; set; }

        [JsonPropertyName("error_occured")]
        public bool ErrorOccured { get; set; }

        [JsonPropertyName("is_live")]
        public bool IsLive { get; set; }

        [JsonPropertyName("other_endpoint_reference")]
        public string? OtherEndpointReference { get; set; }

        [JsonPropertyName("refunded_amount_cents")]
        public int? RefundedAmountCents { get; set; }

        [JsonPropertyName("source_id")]
        public int SourceId { get; set; }

        [JsonPropertyName("is_captured")]
        public bool IsCaptured { get; set; }

        [JsonPropertyName("captured_amount")]
        public int? CapturedAmount { get; set; }

        [JsonPropertyName("merchant_staff_tag")]
        public string? MerchantStaffTag { get; set; }

        [JsonPropertyName("updated_at")]
        public DateTime UpdatedAt { get; set; }

        [JsonPropertyName("is_settled")]
        public bool IsSettled { get; set; }

        [JsonPropertyName("bill_balanced")]
        public bool BillBalanced { get; set; }

        [JsonPropertyName("is_bill")]
        public bool IsBill { get; set; }

        [JsonPropertyName("owner")]
        public long Owner { get; set; }

        [JsonPropertyName("parent_transaction")]
        public string? ParentTransaction { get; set; }
    }
}
