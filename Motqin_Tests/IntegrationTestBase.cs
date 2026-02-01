using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Motqin_Tests;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.Extensions.DependencyInjection;
using Motqin.Data;
using Xunit;

public class IntegrationTestBase : IClassFixture<ApiFactory<AppDbContext>>, IAsyncLifetime
{
    protected readonly ApiFactory<AppDbContext> Factory;
    protected readonly HttpClient Client;
    protected AppDbContext DbContext;
    private IDbContextTransaction _transaction;

    public IntegrationTestBase(ApiFactory<AppDbContext> factory)
    {
        Factory = factory;
        // CreateClient() triggers ConfigureWebHost, initializing the connection
        Client = factory.CreateClient();
    }

    public async Task InitializeAsync()
    {
        // 1. Get a fresh DbContext scope
        var scope = Factory.Services.CreateScope();
        DbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();

        // 2. Start Transaction
        _transaction = await DbContext.Database.BeginTransactionAsync();

        // 3. Share the transaction with the Factory for the Interceptor
        Factory.CurrentTransaction = _transaction.GetDbTransaction();
    }

    public async Task DisposeAsync()
    {
        if (_transaction != null)
        {
            await _transaction.RollbackAsync();
            await _transaction.DisposeAsync();
        }
        await DbContext.DisposeAsync();
    }
}
