using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models
{
    public class StudyPlan
    {
        [Key]
        public int PlanID { get; set; }

        [Required]
        public string UserID { get; set; }

        [Required]
        public int LessonID { get; set; }

        public DateTime NextReviewDate { get; set; }
        public int ReviewInterval { get; set; }

        [StringLength(50)]
        public string Status { get; set; }

        // Navigation Properties
        [ForeignKey("UserID")]
        public virtual User User { get; set; }

        [ForeignKey("LessonID")]
        public virtual Lesson Lesson { get; set; }
    }
}
