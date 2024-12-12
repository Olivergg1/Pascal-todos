unit SQLHelperUnit;
{$mode ObjFPC}

interface

uses SysUtils, Classes, sqldb, sqlite3conn, db, InputUnit, LogUnit, GlobalsUnit;

procedure SetupDatabase();
procedure ExecuteSQLFromFile(transaction: TSQLTransaction; const FileName: string);
procedure ExecuteSQLQuery(const SQL: string);

implementation

var DatabaseConnection: TSQLite3Connection;

procedure OpenConnection();
begin
  if DatabaseConnection = nil then
  begin
    DatabaseConnection := TSQLite3Connection.Create(nil);
    DatabaseConnection.DatabaseName := DATABASE_FILENAME;
  end;

  if not DatabaseConnection.Connected then DatabaseConnection.Open;
end;

procedure CloseConnection();
begin
  if DatabaseConnection <> nil then
  begin
    DatabaseConnection.Close;
    FreeAndNil(DatabaseConnection);
  end;
end;

procedure SetupDatabase();
var
  SQLTransaction: TSQLTransaction;
begin
  SQLTransaction := TSQLTransaction.Create(nil);

  try
    OpenConnection();
    DatabaseConnection.Transaction := SQLTransaction;

    // Execute table creation SQL files
    ExecuteSQLFromFile(SQLTransaction, './sql/create_todos_table.sql');

    Devlog('Database setup completed.');
  except
    on E: Exception do
      ErrorLog('Error during setup: ' + E.Message);
  end;

  SQLTransaction.Free;
end;

procedure ExecuteSQLFromFile(transaction: TSQLTransaction; const FileName: string);
var
  SQLFile: TStringList;
  Query: TSQLQuery;
begin
  SQLFile := TStringList.Create;
  Query := TSQLQuery.Create(nil);
  try
    // Load SQL file
    if not FileExists(FileName) then
      raise Exception.Create('SQL file not found: ' + FileName);
    SQLFile.LoadFromFile(FileName);

    OpenConnection();

    // Prepare and execute the SQL
    Query.Database := DatabaseConnection;
    Query.Transaction := transaction;
    Query.SQL.Text := SQLFile.Text;
    Query.ExecSQL;

    // Commit changes
    transaction.Commit;

    Devlog('Executed SQL from file: ' + FileName);
  finally
    SQLFile.Free;
    Query.Free;
    CloseConnection();
  end;
end;

procedure ExecuteSQLQuery(const SQL: string);
var Query: TSQLQuery;
var Transaction: TSQLTransaction;
begin
  Query := TSQLQuery.Create(nil);
  Transaction := TSQLTransaction.Create(nil);
  
  try
    OpenConnection();

    DatabaseConnection.Transaction := Transaction;
    Query.Database := DatabaseConnection;
    Query.SQL.Text := SQL;

    Query.ExecSQL;

    Transaction.Commit;

    DevLog('Executed SQL query: ' + SQL);
  except
    on E: Exception do
      ErrorLog('Error while executing SQL query: ' + E.Message);
  end;

  Query.Free;
  Transaction.Free;
  CloseConnection();
end;

end.