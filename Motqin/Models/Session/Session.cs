using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models.Session
{
    public  class Session
    {
        [Key]
        public int SessionID { get; set; }

        [Required]
        public string UserID { get; set; }

        public DateTime StartTime { get; set; }
        public DateTime? EndTime { get; set; }

        [ForeignKey("UserID")]
        public virtual User User { get; set; }
    }
}
