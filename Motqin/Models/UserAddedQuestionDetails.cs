using Motqin.Models.Session;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models
{
    public class UserAddedQuestionDetails
    {
        [Key]
        public int DetailID { get; set; }

        [Required]
        public int SessionID { get; set; }

        [Required]
        public int QuestionID { get; set; }

        public DateTime StartTime { get; set; }
        public DateTime EndTime { get; set; }

        public string? UserAnswer { get; set; }
        public bool IsCorrect { get; set; }

        // Navigation Properties
        [ForeignKey("SessionID")]
        public virtual SpacedRepetitionSession StudySession { get; set; } = null!;

        [ForeignKey("QuestionID")]
        public virtual Question Question { get; set; } = null!;
    }
}
