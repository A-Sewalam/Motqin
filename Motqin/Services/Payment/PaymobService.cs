using Microsoft.EntityFrameworkCore;
using Motqin.Data;
using Motqin.Dtos.PaymobCallbackModels;
using Motqin.Models.Payment;
using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace Motqin.Services.Payment
{
    public class PaymobService : IPaymobService
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _config;

        public PaymobService(AppDbContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        public async Task<string> ProcessPaymentAsync(string userId, decimal amount)
        {
            var user = await _context.Users.FirstOrDefaultAsync(s => s.Id == userId);

            if (user == null)
                throw new InvalidOperationException($"User with ID: {userId} is NOT found");

            var wallet = await _context.Wallets.FirstOrDefaultAsync(w => w.UserId == userId);
            
            if (wallet == null)
                throw new InvalidOperationException($"Wallet for user with ID: {userId} is NOT found");
            
            // Get Paymob configurations
            var apiKey = _config["Paymob:ApiKey"] ??
                throw new ArgumentException("Paymob API key is not configured");

            var secretKey = _config["Paymob:SecretKey"] ??
                throw new ArgumentException("Paymob Secret key is not configured");

            var publicKey = _config["Paymob:PublicKey"] ??
                throw new ArgumentException("Paymob Public key is not configured");

            // for card
            var cardIntegrationIdStr = _config["Paymob:CardIntegrationId"] ??
                throw new ArgumentException("Paymob CardIntegrationId is not configured");
            int cardIntegrationId = int.Parse(cardIntegrationIdStr);
            
            // for mobile wallet 
            var walletIntegrationIdStr = _config["Paymob:WalletIntegrationId"] ??
                throw new ArgumentException("Paymob WalletIntegrationId is not configured");
            int walletIntegrationId = int.Parse(walletIntegrationIdStr);

            var randomPart = RandomNumberGenerator.GetInt32(1000000, 9999999);
            var specialReference = $"{randomPart}-{userId.Substring(0, 8)}-{DateTime.UtcNow.Ticks}";
            int amountByCents = (int)(amount * 100);

            // Prepare billing data
            var billingData = new
            {
                apartment = "N/A",
                first_name = user.UserName ?? "Guest",
                last_name = null ?? "Motqin",                  // fake last_name
                street = "N/A",
                building = "N/A",
                phone_number = user.PhoneNumber,
                country = "N/A",
                email = user.Email,
                floor = "N/A",
                state = "N/A",
                city = "N/A"
            };

            // Prepare intention request payload
            var payload = new
            {
                amount = amountByCents,
                currency = "EGP",
                payment_methods = new[] { cardIntegrationId, walletIntegrationId }, // you can choose from fornt-end
                billing_data = billingData,
                items = new[]
                {
                    new
                    {
                        name = $"Recharge Wallet #{randomPart-145}",
                        amount = amountByCents,
                        description = $"Deposit by {amount.ToString("C3")} in your Wallet",
                        quantity = 1
                    }
                },
                extras = new
                {
                    WalletId = wallet.Id  // not important
                },
                special_reference = specialReference,
                expiration = 3600, // 1 hour expiration
                merchant_order_id = specialReference
               
                // redirection_url = "put link here"
            };
            
            // return value
            string redirectUrl = string.Empty;

            // Create HTTP request for Paymob's intention API
            var requestMessage = new HttpRequestMessage(HttpMethod.Post, "https://accept.paymob.com/v1/intention/");
            requestMessage.Headers.Authorization = new AuthenticationHeaderValue("token", secretKey);
            requestMessage.Content = JsonContent.Create(payload);

            using (var httpClient = new HttpClient())
            {
                // Send the request and process response
                var response = await httpClient.SendAsync(requestMessage);
                var responseContent = await response.Content.ReadAsStringAsync();

                if (!response.IsSuccessStatusCode)
                    throw new Exception($"Paymob Intention API call failed with status {response.StatusCode}: {responseContent}");

                // Parse the response to get client_secret
                var resultJson = JsonDocument.Parse(responseContent);
                var clientSecret = resultJson.RootElement.GetProperty("client_secret").GetString();

                // Generate payment URL for the unified checkout
                redirectUrl = $"https://accept.paymob.com/unifiedcheckout/?publicKey={publicKey}&clientSecret={clientSecret}";
            }

            // Add Transaction Record
            var walletTransaction = new WalletTransaction
            {
                WalletId = wallet.Id,
                Amount = amount,
                TransactionType = "Deposit",
                ReferenceId = specialReference,
                PaymentMethod = null,             // you can take it from front-end
                PaymentStatus = "Pending"
            };

            _context.WalletTransactions.Add(walletTransaction);
            await _context.SaveChangesAsync();

            return redirectUrl;
        }

        public async Task UpdatePaymentProcessAsync(bool isSuccess, string specialReference, long paymobTransactionId, string paymentMethod, int amountCents)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var walletTransaction = await _context.WalletTransactions
                 .Include(wt => wt.Wallet)
                 .FirstOrDefaultAsync(wt => wt.ReferenceId == specialReference);

                if (walletTransaction == null)
                    throw new KeyNotFoundException($"Payment with transaction ID {specialReference} not found.");

                // Idempotency Check
                if (walletTransaction.PaymentStatus == "Successed")
                {
                    await transaction.RollbackAsync();
                    return;
                }

                if (isSuccess)
                {
                    walletTransaction.PaymentStatus = "Successed";
                    walletTransaction.Wallet.Balance += amountCents / 100m;
                    walletTransaction.Wallet.UpdatedAt = DateTime.UtcNow;
                }
                else
                {
                    walletTransaction.PaymentStatus = "Failed";
                }
                walletTransaction.PaymobTransactionId = paymobTransactionId.ToString();
                walletTransaction.PaymentMethod = paymentMethod;

                await _context.SaveChangesAsync();

                await transaction.CommitAsync();
            }
            catch (Exception)
            {
                // you can log errors here
                await transaction.RollbackAsync();
                throw;
            }
        }

        public bool ValidateHmacQuery(IQueryCollection? query)
        {
            if (query == null)
                throw new NullReferenceException(nameof(query));

            string[] fields = 
            {
                "amount_cents", "created_at", "currency", "error_occured", "has_parent_transaction",
                "id", "integration_id", "is_3d_secure", "is_auth", "is_capture", "is_refunded",
                "is_standalone_payment", "is_voided", "order", "owner", "pending",
                "source_data.pan", "source_data.sub_type", "source_data.type", "success"
            };

            var concatenated = new StringBuilder();
            foreach (var field in fields)
            {
                if (query.TryGetValue(field, out var value))
                    concatenated.Append(value);
                else
                    throw new KeyNotFoundException($"Missing expected field {field}.");
            }

            string? recievedHmac = query["hmac"];
            if (string.IsNullOrEmpty(recievedHmac))
                throw new KeyNotFoundException("Missing HMAC in query string");

            string calculatedHmac = ComputeHmacSHA512(concatenated.ToString(), _config["Paymob:HmacSecret"]);

            return calculatedHmac.Equals(recievedHmac, StringComparison.OrdinalIgnoreCase);
        }

        public bool ValidateHmacPayload(PaymobWebhookResult payload, string? receivedHmac)
        {
            if (payload == null) 
                throw new NullReferenceException(nameof(payload));
            if (payload?.Obj == null)
                throw new ArgumentNullException("Invalid payload structure.");

            PaymobTransactionObj obj = payload.Obj;

            var concatenated = new StringBuilder();
            concatenated.Append(obj.AmountCents);
            concatenated.Append(obj.CreatedAt.ToString("yyyy-MM-ddTHH:mm:ss.ffffff")); // same format for Paymob
            concatenated.Append(obj.Currency);
            concatenated.Append(obj.ErrorOccured ? "true" : "false");
            concatenated.Append(obj.HasParentTransaction ? "true" : "false");
            concatenated.Append(obj.Id);
            concatenated.Append(obj.IntegrationId);
            concatenated.Append(obj.Is3dSecure ? "true" : "false");
            concatenated.Append(obj.IsAuth ? "true" : "false");
            concatenated.Append(obj.IsCapture ? "true" : "false");
            concatenated.Append(obj.IsRefunded ? "true" : "false");
            concatenated.Append(obj.IsStandalonePayment ? "true" : "false");
            concatenated.Append(obj.IsVoided ? "true" : "false");
            // dealing whith (nullable) fields [Order, SourceData]
            concatenated.Append(obj.Order?.Id.ToString() ?? "");
            concatenated.Append(obj.Owner);
            concatenated.Append(obj.Pending ? "true" : "false");
            concatenated.Append(obj.SourceData?.Pan ?? "");
            concatenated.Append(obj.SourceData?.SubType ?? "");
            concatenated.Append(obj.SourceData?.Type ?? "");
            concatenated.Append(obj.Success ? "true" : "false");

            if (string.IsNullOrEmpty(receivedHmac))
                throw new ArgumentNullException("Missing HMAC parameter");

            string calculatedHmac = ComputeHmacSHA512(concatenated.ToString(), _config["Paymob:HmacSecret"]);

            return calculatedHmac.Equals(receivedHmac, StringComparison.OrdinalIgnoreCase);
        }

        private string ComputeHmacSHA512(string data, string secret)
        {
            var keyBytes = Encoding.UTF8.GetBytes(secret);
            var dataBytes = Encoding.UTF8.GetBytes(data);

            using (var hmac = new HMACSHA512(keyBytes))
            {
                var hash = hmac.ComputeHash(dataBytes);
                return BitConverter.ToString(hash).Replace("-", "").ToLower();
            }
        }

    }
}
