using System.Text.Json.Serialization;
namespace Motqin.Dtos.PaymobCallbackModels
{
    public class PaymobGatewayData
    {
        [JsonPropertyName("gateway_integration_pk")]
        public int GatewayIntegrationPk { get; set; }

        [JsonPropertyName("klass")]
        public string? Klass { get; set; }

        [JsonPropertyName("created_at")]
        public DateTime CreatedAt { get; set; }

        [JsonPropertyName("amount")]
        public int Amount { get; set; } 

        [JsonPropertyName("currency")]
        public string? Currency { get; set; }

        [JsonPropertyName("migs_order")]
        public MigsOrder? MigsOrder { get; set; }

        [JsonPropertyName("merchant")]
        public string? Merchant { get; set; }

        [JsonPropertyName("migs_result")]
        public string? MigsResult { get; set; }

        [JsonPropertyName("migs_transaction")]
        public MigsTransaction? MigsTransaction { get; set; }

        [JsonPropertyName("txn_response_code")]
        public string? TxnResponseCode { get; set; }

        [JsonPropertyName("acq_response_code")]
        public string? AcqResponseCode { get; set; }

        [JsonPropertyName("message")]
        public string? Message { get; set; }

        [JsonPropertyName("merchant_txn_ref")]
        public string? MerchantTxnRef { get; set; }

        [JsonPropertyName("order_info")]
        public string? OrderInfo { get; set; }

        [JsonPropertyName("receipt_no")]
        public string? ReceiptNo { get; set; }

        [JsonPropertyName("transaction_no")]
        public string? TransactionNo { get; set; }

        [JsonPropertyName("batch_no")]
        public int BatchNo { get; set; } 

        [JsonPropertyName("authorize_id")]
        public string? AuthorizeId { get; set; }

        [JsonPropertyName("card_type")]
        public string? CardType { get; set; }

        [JsonPropertyName("card_num")]
        public string? CardNum { get; set; }

        [JsonPropertyName("secure_hash")]
        public string? SecureHash { get; set; }

        [JsonPropertyName("captured_amount")]
        public int? CapturedAmount { get; set; } 

        [JsonPropertyName("authorised_amount")]
        public int? AuthorisedAmount { get; set; }

        [JsonPropertyName("refunded_amount")]
        public int? RefundedAmount { get; set; } 
    }
}
