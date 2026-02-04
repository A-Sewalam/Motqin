using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models
{
    public class CompetitionEntry
    {
        [Key]
        public int EntryID { get; set; }

        [Required]
        public int CompetitionID { get; set; }

        [Required]
        public string UserID { get; set; }

        public int Score { get; set; }
        public int Rank { get; set; }

        // Navigation Properties
        [ForeignKey("CompetitionID")]
        public virtual Competition Competition { get; set; }

        [ForeignKey("UserID")]
        public virtual User User { get; set; }
    }
}
