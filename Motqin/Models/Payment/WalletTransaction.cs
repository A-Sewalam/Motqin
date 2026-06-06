using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models.Payment
{
    public class WalletTransaction
    {
        public int Id { get; set; }
        public int WalletId { get; set; }
        [ForeignKey(nameof(WalletId))]
        public virtual Wallet Wallet { get; set; } = null!;

        public decimal Amount { get; set; }
        public string? ReferenceId { get; set; }
        public required string TransactionType { get; set; } // "Deposit", "Subscribe", "Refund"
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
        public string? PaymentMethod { get; set; } // "card", "wallet"
        public string PaymentStatus { get; set; } = "Pending"; // "Pending", "Successed", "Failed"
        public string? PaymobTransactionId { get; set; }
    }
}
