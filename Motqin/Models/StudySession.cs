using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models
{
    public class StudySession
    {
        [Key]
        public int SessionID { get; set; }

        [Required]
        public int UserID { get; set; }

        [Required]
        public int LessonID { get; set; }

        [Required]
        public string QuestionsCategory { get; set; }

        public DateTime StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public int Score { get; set; }

        // Navigation Properties
        [ForeignKey("UserID")]
        public virtual User User { get; set; }

        [ForeignKey("LessonID")]
        public virtual Lesson Lesson { get; set; }

        public virtual ICollection<QuestionDetails> QuestionDetails { get; set; } = new List<QuestionDetails>();
    }
}
