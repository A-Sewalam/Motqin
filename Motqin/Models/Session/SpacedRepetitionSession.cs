using Motqin.Enums;
using Motqin.Models.Session;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models.Session
{
    public class SpacedRepetitionSession : Session
    {

        [Required]
        public int SubjectID { get; set; }

        [Required]
        public int LessonID { get; set; }

        [Required]
        public string QuestionsCategory { get; set; }

        public int RepetitionNumber { get; set; }

        public StudySessionStatuses StudySessionStatuses { get; set; }

        public int Score { get; set; }

        // Navigation Properties

        [ForeignKey("SubjectID")]
        public virtual Lesson Subject { get; set; }

        [ForeignKey("LessonID")]
        public virtual Lesson Lesson { get; set; }

        public virtual ICollection<QuestionDetails> QuestionDetails { get; set; } = new List<QuestionDetails>();
    }
}
