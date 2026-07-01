using Motqin.Models.Session;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models
{
    public class Lesson
    {
        [Key]
        public int LessonId { get; set; }

        [Required]
        public int SubjectID { get; set; }

        [Required]
        [StringLength(200)]
        public string Title { get; set; }

        public int Difficulty { get; set; }

        public int? EstimatedDuration { get; set; }
        // Navigation Properties
        [ForeignKey("SubjectID")]
        public virtual Subject Subject { get; set; }

        public virtual ICollection<Question> Questions { get; set; } = new List<Question>();
        public virtual ICollection<SpacedRepetitionSession> StudySessions { get; set; } = new List<SpacedRepetitionSession>();
        public virtual ICollection<StudyPlan> StudyPlans { get; set; } = new List<StudyPlan>();
        public virtual ICollection<UserLessons> UsersToStudy { get; set; } = [];
    }
}
