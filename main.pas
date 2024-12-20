program Todos;
{$mode ObjFPC}

uses crt, sysutils, dateutils, strutils, SQLiteUnit, InputUnit, LogUnit, sqlite3conn;

// Types
type 
  TTodo = record
    title: string[50];
    completed: boolean;
    createdAt: int64;
end;

procedure AddTodo();
begin
  ExecuteSQLQuery('INSERT INTO Todos (task, complete) VALUES (''Oliver'', false)');
end;

procedure Setup();
begin
  try
    // Setup the database with the specified file
    SetupDatabase();

    AddTodo();
  except
    on E: Exception do
      ErrorLog('An error occurred: ' + E.Message);
  end;
end;

begin
  Setup();

  readkey;
end.