using Motqin.Enums;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Motqin.Models
{
    public class User
    {
        [Key]
        public int UserId { get; set; }

        [Required, MaxLength(100)]
        public string Name { get; set; } = string.Empty;

        [Required, EmailAddress]
        public string Email { get; set; } = string.Empty;

        [Required]
        public string PasswordHash { get; set; } = string.Empty;

        public string? Role { get; set; }

        [StringLength(100)]
        public  string Country { get; set; }

        [StringLength(50)]
        public EducationalStage EducationalStage { get; set; }
        public GradeLevel GradeLevel { get; set; }

        // Navigation properties
        public virtual ICollection<StudySession> StudySessions { get; set; } = [];
        public virtual ICollection<StudyPlan> StudyPlans { get; set; } = []; 
        public virtual ICollection<DistractionControl> DistractionControls { get; set; } = [];
        public virtual ICollection<CompetitionEntry> CompetitionEntries { get; set; } = [];
    }
}
