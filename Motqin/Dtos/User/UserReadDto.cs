using Motqin.Enums;

namespace Motqin.Dtos.User
{
    public class UserReadDto
    {
        public int UserId { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string? Role { get; set; }
        public GradeLevel? GradeLevel { get; set; }
    }
}
