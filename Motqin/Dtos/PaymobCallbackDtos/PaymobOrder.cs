using System.Text.Json.Serialization;
namespace Motqin.Dtos.PaymobCallbackModels
{
    public class PaymobOrder
    {
        [JsonPropertyName("id")]
        public long Id { get; set; }

        [JsonPropertyName("created_at")]
        public DateTime CreatedAt { get; set; }

        [JsonPropertyName("delivery_needed")]
        public bool DeliveryNeeded { get; set; }

        [JsonPropertyName("merchant")]
        public PaymobMerchant? Merchant { get; set; }

        [JsonPropertyName("collector")]
        public string? Collector { get; set; }

        [JsonPropertyName("amount_cents")]
        public int AmountCents { get; set; }

        [JsonPropertyName("shipping_data")]
        public PaymobShippingData? ShippingData { get; set; }

        [JsonPropertyName("currency")]
        public string? Currency { get; set; }

        [JsonPropertyName("is_payment_locked")]
        public bool IsPaymentLocked { get; set; }

        [JsonPropertyName("is_return")]
        public bool IsReturn { get; set; }

        [JsonPropertyName("is_cancel")]
        public bool IsCancel { get; set; }

        [JsonPropertyName("is_returned")]
        public bool IsReturned { get; set; }

        [JsonPropertyName("is_canceled")]
        public bool IsCanceled { get; set; }

        [JsonPropertyName("merchant_order_id")]
        public string? MerchantOrderId { get; set; }

        [JsonPropertyName("wallet_notification")]
        public string? WalletNotification { get; set; }

        [JsonPropertyName("paid_amount_cents")]
        public int PaidAmountCents { get; set; }

        [JsonPropertyName("notify_user_with_email")]
        public bool NotifyUserWithEmail { get; set; }

        [JsonPropertyName("items")]
        public List<object>? Items { get; set; }

        [JsonPropertyName("order_url")]
        public string? OrderUrl { get; set; }

        [JsonPropertyName("commission_fees")]
        public int? CommissionFees { get; set; }

        [JsonPropertyName("delivery_fees_cents")]
        public int? DeliveryFeesCents { get; set; }

        [JsonPropertyName("delivery_vat_cents")]
        public int? DeliveryVatCents { get; set; }

        [JsonPropertyName("payment_method")]
        public string? PaymentMethod { get; set; }

        [JsonPropertyName("merchant_staff_tag")]
        public string? MerchantStaffTag { get; set; }

        [JsonPropertyName("api_source")]
        public string? ApiSource { get; set; }
    }
}
