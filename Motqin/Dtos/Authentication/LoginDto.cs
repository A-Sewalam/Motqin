using System.ComponentModel.DataAnnotations;

namespace Motqin.Dtos.Authentication
{
    public class LoginDto
    {
        [Required]
        public string EmailAddress { get; set; }
        [Required]
        public string Password { get; set; }
    }
}
