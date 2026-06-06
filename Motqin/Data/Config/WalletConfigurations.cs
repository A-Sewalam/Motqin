using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Motqin.Models.Payment;

namespace PaymobIntegration.Data.Config
{
    public class WalletConfigurations : IEntityTypeConfiguration<Wallet>
    {
        public void Configure(EntityTypeBuilder<Wallet> builder)
        {
            builder.ToTable("Wallets");
           
            builder.HasKey(w => w.Id);

            builder.Property(w => w.Balance).HasColumnType("decimal(18,2)").IsRequired();

            // Relations
            builder.HasOne(w => w.User)
                .WithOne(s => s.Wallet)
                .HasForeignKey<Wallet>(w => w.UserId)
                .IsRequired();

            builder.HasMany(w => w.Transactions)
                .WithOne(wt => wt.Wallet)
                .HasForeignKey(wt => wt.WalletId)
                .IsRequired();

            builder.HasIndex(w => w.UserId)
                .IsUnique();
        }
    }
}
