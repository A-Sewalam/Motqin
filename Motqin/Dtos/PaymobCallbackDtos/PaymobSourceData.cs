using System.Text.Json.Serialization;
namespace Motqin.Dtos.PaymobCallbackModels
{
    public class PaymobSourceData
    {
        [JsonPropertyName("pan")]
        public string? Pan { get; set; }

        [JsonPropertyName("type")]
        public string? Type { get; set; }

        [JsonPropertyName("tenure")]
        public string? Tenure { get; set; }

        [JsonPropertyName("sub_type")]
        public string? SubType { get; set; }
    }
}
