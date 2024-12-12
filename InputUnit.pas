unit InputUnit;
{$mode ObjFPC}

interface

uses SysUtils, strutils, crt;

function Prompt(): string;
function Prompt(str: string): string;

implementation

function Prompt(str: string): string;
var input: string;
begin
  if not IsEmptyStr(str, []) then Write(str, ' ');

  ReadLn(input);
  Prompt := input;
end;

function Prompt(): string;
begin
  Prompt := Prompt('');
end;

end.