using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Motqin;
using Motqin.Data;
using Motqin_Tests;
using System.Data.Common;
using Microsoft.Extensions.DependencyInjection.Extensions;

public class ApiFactory<TDbContext> : WebApplicationFactory<Program> where TDbContext : DbContext
{
    // Use a backing field to ensure we only create it once
    private DbConnection _connection;
    public DbConnection Connection => _connection ??= CreateConnection();
    public DbTransaction CurrentTransaction { get; set; }

    private DbConnection CreateConnection()
    {
        var conn = new SqlConnection("Data Source=.;Initial Catalog=my-books-db;Integrated Security=True;Pooling=False;Encrypt=False;Trust Server Certificate=False");
        conn.Open();
        return conn;
    }

    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.ConfigureServices(services =>
        {
            services.RemoveAll<DbContextOptions<TDbContext>>();

            // Use the property here - it will call CreateConnection if null
            services.AddDbContext<TDbContext>(options =>
            {
                options.UseSqlServer(Connection);
                if (CurrentTransaction != null)
                {
                    options.AddInterceptors(new TransactionInterceptor(CurrentTransaction));
                }
            });
        });
    }

    protected override void Dispose(bool disposing)
    {
        if (disposing)
        {
            _connection?.Dispose();
        }
        base.Dispose(disposing);
    }
}