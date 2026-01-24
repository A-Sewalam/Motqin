using Motqin.Models;
using System.ComponentModel.DataAnnotations;

public abstract class Question
{
    [Key]
    public int QuestionID { get; set; }

    [Required]
    public int LessonID { get; set; }

    [Required]
    public string QuestionCategory { get; set; }

    [Required]
    public string QuestionText { get; set; }

    [StringLength(20)]
    public string DifficultyLevel { get; set; }

    public virtual Lesson Lesson { get; set; }
    public virtual ICollection<QuestionDetails> QuestionDetails { get; set; }
}
