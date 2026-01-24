using Motqin.Enums;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Motqin.Models
{
    public class Subject
    {
        [Key]
        public int SubjectID { get; set; }

        [Required]
        [StringLength(100)]
        public required string Name { get; set; }

        [StringLength(100)]
        public required string Country { get; set; }

        [StringLength(50)]
        public EducationalStage EducationalStage { get; set; }

        [StringLength(50)]
        public GradeLevel GradeLevel { get; set; }

        // Navigation Property
        public virtual ICollection<Lesson> Lessons { get; set; } = new List<Lesson>();
    }
}
