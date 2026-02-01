using System.ComponentModel.DataAnnotations;

namespace Motqin.Dtos.Lesson
{
    public class LessonCreateDto
    {
        [Required, MinLength(3), MaxLength(20)]
        public string Title { get; set; } 
        [Required]
        public int SubjectID { get; set; }
    }
}
