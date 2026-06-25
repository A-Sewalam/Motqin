using System.Text.Json.Serialization;

namespace Motqin.Dtos.Authentication
{


    namespace Motqin.Dtos.Authentication
    {
        // The payload sent from your frontend
        public class FacebookLoginDto
        {
            public string AccessToken { get; set; } = string.Empty;
        }

        // Used to validate the token is for your app
        public class FacebookTokenValidationResult
        {
            [JsonPropertyName("data")]
            public FacebookTokenValidationData Data { get; set; }
        }

        public class FacebookTokenValidationData
        {
            [JsonPropertyName("app_id")]
            public string AppId { get; set; }

            [JsonPropertyName("is_valid")]
            public bool IsValid { get; set; }

            [JsonPropertyName("user_id")]
            public string UserId { get; set; }
        }

        // Used to extract the user's profile info
        public class FacebookUserInfoResult
        {
            [JsonPropertyName("id")]
            public string Id { get; set; }

            [JsonPropertyName("email")]
            public string Email { get; set; }

            [JsonPropertyName("name")]
            public string Name { get; set; }
        }
    }
}
