using System.ComponentModel.DataAnnotations;

namespace Motqin.Models
{
    public class UserDeletedQuestion
    {
        public int Id { get; set; }
        [Required]
        public required string UserId { get; set; }
        public int QuestionId { get; set; }
    }
}
