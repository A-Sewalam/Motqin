using Motqin.Models.Payment;

namespace Motqin.Services.Payment
{
    public interface ISubscriptionService
    {
        Task<UserSubscription> SubscribeToBundle(string userId, int bundleId);
    }
}
