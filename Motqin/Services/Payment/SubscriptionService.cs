using Microsoft.EntityFrameworkCore;
using Motqin.Data;
using Motqin.Models.Payment;

namespace Motqin.Services.Payment
{
    public class SubscriptionService : ISubscriptionService
    {
        private readonly AppDbContext _context;

        public SubscriptionService(AppDbContext conext)
        {
            _context = conext;
        }

        public async Task<UserSubscription> SubscribeToBundle(string userId, int bundleId)
        {
            var user = await _context.Users
                .Include(s => s.Wallet)
                .FirstOrDefaultAsync(s => s.Id == userId);

            if (user == null)
                throw new KeyNotFoundException($"User with Id: {userId} is not found.");

            var bundle = await _context.Bundles
                .FirstOrDefaultAsync(b => b.Id == bundleId);

            if (bundle == null)
                throw new KeyNotFoundException($"Bundle with Id: {bundleId} is not found.");

            if (user.Wallet.Balance < bundle.Price)
                throw new InvalidOperationException("Insufficient wallet balance.");

            bool hasActiveSub = await _context.UserSubscriptions.AnyAsync(s => 
                s.UserId == userId && s.BundleId == bundleId &&
                s.Status == "Active" && s.EndDate > DateTimeOffset.UtcNow);

            if (hasActiveSub)
                throw new InvalidOperationException("You already have an active subscription for this bundle.");

            var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                user.Wallet.Balance -= bundle.Price;
                user.Wallet.UpdatedAt = DateTime.UtcNow;

                // log transaction
                var walletTransaction = new WalletTransaction
                {
                    WalletId = user.Wallet.Id,
                    Amount = -bundle.Price,
                    ReferenceId = null,
                    TransactionType = "Subscribe",
                    PaymentMethod = null,              // you can take it from front-end
                    PaymentStatus = "Successed",
                    PaymobTransactionId = null
                };

                var userSub = new UserSubscription
                {
                    UserId = userId,
                    BundleId = bundleId,
                    StartDate = DateTimeOffset.UtcNow,
                    EndDate = DateTimeOffset.UtcNow.AddDays(bundle.DurationDays),
                    Status = "Active"
                };

                _context.WalletTransactions.Add(walletTransaction);
                _context.UserSubscriptions.Add(userSub);
                await _context.SaveChangesAsync();

                await transaction.CommitAsync();
                return userSub;
            }
            catch
            {
                await transaction.RollbackAsync();
                throw new InvalidOperationException("Error processing subscription.");
            }
        }
    }
}
