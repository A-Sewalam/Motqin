using System.ComponentModel.DataAnnotations;

namespace Motqin.Dtos.Planner
{
    public class ToBeStudiedDto
    {
        [Required]
        public string UserId { get; set; }

        [Required]
        public int LessonId { get; set; }
    }
}
