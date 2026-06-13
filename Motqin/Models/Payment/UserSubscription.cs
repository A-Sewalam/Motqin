using System.ComponentModel.DataAnnotations.Schema;

namespace Motqin.Models.Payment
{
    public class UserSubscription
    {
        public int Id { get; set; }
        public required string UserId { get; set; }
        [ForeignKey(nameof(UserId))]
        public User User { get; set; } = null!;

        public int BundleId { get; set; }
        [ForeignKey(nameof(BundleId))]
        public Bundle Bundle { get; set; } = null!;

        public DateTimeOffset StartDate { get; set; } = DateTimeOffset.UtcNow;
        public DateTimeOffset EndDate { get; set; }
        public string Status { get; set; } = "Active"; // "Active", "Expired"
    }
}
