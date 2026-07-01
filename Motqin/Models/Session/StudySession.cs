using Motqin.Enums;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models.Session
{
    public class StudySession
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string UserID { get; set; }

        public TimeOnly StartTime { get; set; }
        public TimeOnly EndTime { get; set; }
        public DateOnly Date { get; set; }
        public TimeOnly PlannedStartTime { get; set; }
        public TimeOnly PlannedEndTime { get; set; }
        public DateOnly PlannedDate { get; set; }
        public StudySessionStatuses Status { get; set; }
        public int Score { get; set; }

        public int? SpacesRepititionSessionId { get; set; }
        [ForeignKey("SpacesRepititionSessionId")]
        public SpacedRepetitionSession? SpacedRepetitionSession { get; set; }

        [ForeignKey("UserID")]
        public virtual User User { get; set; }

        [Required]
        public int LessonID { get; set; }

        [ForeignKey("LessonID")]
        public virtual Lesson Lesson { get; set; }
    }
}
