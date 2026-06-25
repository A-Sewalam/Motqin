using System.ComponentModel.DataAnnotations;

namespace Motqin.Dtos.Authentication
{
    public class UserRegisterDto
    {
        [Required]
        public string UserName { get; set; }
        [Required]
        [EmailAddress]
        public string EmailAddress { get; set; }
        [Required]
        public string Password { get; set; }

    }
}
