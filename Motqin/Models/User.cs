using Microsoft.AspNetCore.Identity;
using Motqin.Enums;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace Motqin.Models
{
    public class User : IdentityUser
    {

        [StringLength(100)]
        public  string Country { get; set; }

        public EducationalStage EducationalStage { get; set; }
        public GradeLevel GradeLevel { get; set; }

        // Navigation properties
        public virtual ICollection<StudySession> StudySessions { get; set; } = [];
        public virtual ICollection<StudyPlan> StudyPlans { get; set; } = []; 
        public virtual ICollection<DistractionControl> DistractionControls { get; set; } = [];
        public virtual ICollection<CompetitionEntry> CompetitionEntries { get; set; } = [];
    }
}
