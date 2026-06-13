using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Motqin.Models.Payment;

namespace PaymobIntegration.Data.Config
{
    public class BundleConfigurations : IEntityTypeConfiguration<Bundle>
    {
        public void Configure(EntityTypeBuilder<Bundle> builder)
        {
            builder.ToTable("Bundles");
           
            builder.HasKey(b => b.Id);

            builder.Property(b => b.Title).HasMaxLength(100).IsRequired();
            builder.Property(b => b.Price)
                .HasColumnType("decimal(18,2)").IsRequired();
            builder.Property(b => b.DurationDays).IsRequired();

        }
    }
}
