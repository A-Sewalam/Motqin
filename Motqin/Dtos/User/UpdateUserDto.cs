using System.ComponentModel.DataAnnotations;

namespace Motqin.Dtos.User
{
    public class UserUpdateDto
    {
        [Required]
        [MaxLength(100)]
        public string Name { get; set; } = string.Empty;

        public string? Role { get; set; }

        public string? GradeLevel { get; set; }
    }
}
