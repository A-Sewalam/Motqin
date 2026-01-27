using Motqin.Enums;
using System.ComponentModel.DataAnnotations;

namespace Motqin.Dtos.User
{
    public class UserCreateDto
    {
        [Required] 
        public string Name { get; set; } = string.Empty;
        [Required, EmailAddress] 
        public string Email { get; set; } = string.Empty;
        [Required, MinLength(8)]
        public string Password { get; set; } = string.Empty; 
        public string? Role { get; set; }
        public GradeLevel GradeLevel { get; set; }
    }
}
