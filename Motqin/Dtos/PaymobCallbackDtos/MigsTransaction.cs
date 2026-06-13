using System.Text.Json.Serialization;
namespace Motqin.Dtos.PaymobCallbackModels
{
    public class MigsTransaction
    {
        [JsonPropertyName("authorizationCode")]
        public string? AuthorizationCode { get; set; }

        [JsonPropertyName("id")]
        public string? Id { get; set; }

        [JsonPropertyName("type")]
        public string? Type { get; set; }
    }
}
