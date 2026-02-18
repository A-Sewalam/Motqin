using System;

namespace SchoolApp.API.Data.ViewModels
{
    internal class AuthResultDto
    {
        public string Token { get; set; }
        public string RefreshToken { get; set; }
        public DateTime ExpiresAt { get; set; }
    }
}