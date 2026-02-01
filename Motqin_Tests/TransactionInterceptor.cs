using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Common;
using Microsoft.EntityFrameworkCore.Diagnostics;

namespace Motqin_Tests;


public class TransactionInterceptor : DbCommandInterceptor
{
    private readonly DbTransaction _transaction;

    public TransactionInterceptor(DbTransaction transaction)
    {
        _transaction = transaction;
    }

    public override InterceptionResult<DbDataReader> ReaderExecuting(
        DbCommand command, CommandEventData eventData, InterceptionResult<DbDataReader> result)
    {
        command.Transaction = _transaction;
        return result;
    }

    public override ValueTask<InterceptionResult<DbDataReader>> ReaderExecutingAsync(
        DbCommand command, CommandEventData eventData, InterceptionResult<DbDataReader> result, CancellationToken cancellationToken = default)
    {
        command.Transaction = _transaction;
        return new ValueTask<InterceptionResult<DbDataReader>>(result);
    }

    // Note: You should also override NonQueryExecuting and ScalarExecuting 
    // using the same logic (command.Transaction = _transaction) to cover Updates/Inserts.
}
