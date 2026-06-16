using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models.Payment
{
    public class Wallet
    {
        public int Id { get; set; }
        public required string UserId { get; set; }

        [ForeignKey(nameof(UserId))]
        public virtual User User { get; set; } = null!;
        public decimal Balance { get; set; } = 0.00m;
        public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

        public virtual ICollection<WalletTransaction> Transactions { get; set; } = new List<WalletTransaction>();
    }
}
