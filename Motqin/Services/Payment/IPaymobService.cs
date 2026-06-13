using Motqin.Dtos.PaymobCallbackModels;

namespace Motqin.Services.Payment
{
    public interface IPaymobService
    {
        Task<string> ProcessPaymentAsync(string userId, decimal amount); // returns [redirectUrl]
        Task UpdatePaymentProcessAsync(bool isSuccess, string specialReference, long paymobTransactionId, string paymentMethod, int amountCents);
        bool ValidateHmacQuery(IQueryCollection? query);
        bool ValidateHmacPayload(PaymobWebhookResult payload, string? receivedHmac);
    }
}
