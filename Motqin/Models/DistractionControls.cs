using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models
{
    public class DistractionControl
    {
        [Key]
        public int ControlID { get; set; }

        [Required]
        public string UserID { get; set; }

        public string BlockedApps { get; set; } // JSON

        [EmailAddress]
        public string SupervisorEmail { get; set; }

        public bool IsActive { get; set; }

        // Navigation Property
        [ForeignKey("UserID")]
        public virtual User User { get; set; }
    }
}
