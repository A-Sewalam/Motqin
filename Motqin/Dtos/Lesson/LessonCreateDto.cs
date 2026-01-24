using System.ComponentModel.DataAnnotations;

namespace Motqin.Dtos.Lesson
{
    public class LessonCreateDto
    {
        [Required, MaxLength(200)]
        public string Title { get; set; } = string.Empty;
        [Required]
        public int SubjectID { get; set; }
    }
}
