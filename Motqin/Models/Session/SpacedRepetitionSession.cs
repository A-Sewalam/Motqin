using Motqin.Enums;
using Motqin.Models.Session;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models.Session
{
    public class SpacedRepetitionSession 
    {
        [Key]
        public int Id { get; set; }

        public int RepetitionNumber { get; set; } = 0;

        public int Score { get; set; }

        public DateOnly LastReviewDate { get; set; }

        public ICollection<StudySession> StudySessions { get; set; } = [];

        public string UserId { get; set; }
        [ForeignKey("UserId")]
        public User User { get; set; }

        public int LessonId {  get; set; }
        [ForeignKey("LessonId")]
        public Lesson Lesson { get; set; }
    }
}
