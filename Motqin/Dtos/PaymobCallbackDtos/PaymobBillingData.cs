using System.Text.Json.Serialization;
namespace Motqin.Dtos.PaymobCallbackModels
{
    public class PaymobBillingData
    {
        [JsonPropertyName("city")]
        public string? City { get; set; }

        [JsonPropertyName("email")]
        public string? Email { get; set; }

        [JsonPropertyName("first_name")]
        public string? FirstName { get; set; }

        [JsonPropertyName("last_name")]
        public string? LastName { get; set; }

        [JsonPropertyName("phone_number")]
        public string? PhoneNumber { get; set; }
    }
}
