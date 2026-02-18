using System.ComponentModel.DataAnnotations;

namespace SchoolApp.API.Data.ViewModels
{
    public class TokenRequestDto // if replaced public with internal will be a problem
    {
        [Required]
        public string Token { get; set; }

        [Required]
        public string RefreshToken { get; set; }
    }
}