using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Motqin.Models.Payment;

namespace PaymobIntegration.Data.Config
{
    public class WalletTransactionConfigurations : IEntityTypeConfiguration<WalletTransaction>
    {
        public void Configure(EntityTypeBuilder<WalletTransaction> builder)
        {
            builder.ToTable("WalletTransactions");
           
            builder.HasKey(x => x.Id);

            builder.Property(x => x.Amount).HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(x => x.TransactionType).HasMaxLength(20).IsRequired();
            builder.Property(x => x.ReferenceId).HasMaxLength(50).IsRequired(false);
            builder.Property(x => x.PaymentStatus).HasMaxLength(20).IsRequired();
            builder.Property(x => x.PaymentMethod).HasMaxLength(20).IsRequired(false);

        }
    }
}
