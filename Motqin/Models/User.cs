using Microsoft.AspNetCore.Identity;
using Motqin.Enums;
using Motqin.Models.Payment;
using Motqin.Models.Session;
using System.ComponentModel.DataAnnotations;

namespace Motqin.Models
{
    public class User : IdentityUser
    {
        [Required(ErrorMessage = "Name is required")]
        [StringLength(100, ErrorMessage = "Name cannot exceed 100 characters")]
        public string FullName { get; set; } // we use custome name to allow us add duplicated user name 
        public DateTime CreatedAt { get; set; }

        [StringLength(100)]
        public  string Country { get; set; }
        public EducationalStage EducationalStage { get; set; }
        public GradeLevel GradeLevel { get; set; }

        // Navigation properties
        public virtual ICollection<SpacedRepetitionSession> StudySessions { get; set; } = [];
        public virtual ICollection<StudyPlan> StudyPlans { get; set; } = []; 
        public virtual ICollection<DistractionControl> DistractionControls { get; set; } = [];
        public virtual ICollection<CompetitionEntry> CompetitionEntries { get; set; } = [];

        // for payment
        public virtual Wallet Wallet { get; set; } = null!;
        public virtual ICollection<UserSubscription> Subscriptions { get; set; } = new List<UserSubscription>();

        public virtual ICollection<UserLessons> ToBeStudiedLessons { get; set; } = [];
    }
}
