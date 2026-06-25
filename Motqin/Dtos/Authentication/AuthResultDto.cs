using System;
using System.ComponentModel.DataAnnotations;

namespace SchoolApp.API.Data.ViewModels
{
    internal class AuthResultDto
    {
        public string Token { get; set; }
        public string RefreshToken { get; set; }
        public DateTime ExpiresAt { get; set; }
    }

    public class PhoneRegisterDto
    {
        [Required(ErrorMessage = "Name is required.")]
        public string Name { get; set; }

        [Required(ErrorMessage = "Phone number is required.")]
        [Phone(ErrorMessage = "Invalid phone number format.")]
        public string PhoneNumber { get; set; }
    }

    public class PhoneVerifyDto
    {
        [Required]
        public string PhoneNumber { get; set; }

        [Required]
        public string Code { get; set; }
    }
}