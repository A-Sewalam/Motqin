using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Motqin.Models.Payment;

namespace PaymobIntegration.Data.Config
{
    public class UserSubscriptionConfigurations : IEntityTypeConfiguration<UserSubscription>
    {
        public void Configure(EntityTypeBuilder<UserSubscription> builder)
        {
            builder.ToTable("UserSubscriptions");

            builder.HasKey(x => x.Id);

            builder.Property(x => x.StartDate).IsRequired();
            builder.Property(x => x.EndDate).IsRequired();
            builder.Property(x => x.Status).HasMaxLength(20).IsRequired();

            // Relations
            builder.HasOne(ss => ss.User)
                .WithMany(s => s.Subscriptions)
                .HasForeignKey(ss => ss.UserId)
                .OnDelete(DeleteBehavior.Cascade)
                .IsRequired();

            builder.HasOne(ss => ss.Bundle)
                .WithMany()
                .HasForeignKey(ss => ss.BundleId)
                .OnDelete(DeleteBehavior.Restrict)
                .IsRequired();

            // Indexing
            builder.HasIndex(ss => new { ss.UserId, ss.Status });
        }
    }
}
