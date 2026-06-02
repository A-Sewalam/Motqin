using System.ComponentModel.DataAnnotations;

namespace Motqin.Models
{
    public class UserAddedQuestion
    {
        [Key]
        public int ID { get; set; }

        [Required]
        public int LessonID { get; set; }

        public int DisplayOrder { get; set; } = 0;   // for structured lesson ordering

        public int Priority { get; set; } = 2;       // 1 = High, 2 = Medium, 3 = Low


        [Required]
        public required string QuestionCategory { get; set; }  // Basic / Advanced

        [Required]
        public required string QuestionText { get; set; }

        [StringLength(20)]
        public required string DifficultyLevel { get; set; } 

        public virtual Lesson Lesson { get; set; } = null!;
        public virtual ICollection<QuestionDetails> QuestionDetails { get; set; } = null!;
    }
}
