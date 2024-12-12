unit LogUnit;

interface

uses crt, GlobalsUnit;

procedure DevLog(str: string);
procedure ErrorLog(str: string);

implementation

procedure Devlog(str: string);
begin
  if (ENVIRONMENT = Development) then
  begin
    // Set text color to blue
    TextColor(11);

    WriteLn('[dev] ', str);

    // Reset text color
    TextColor(0);
  end
end;

procedure ErrorLog(str: string);
begin
  // Set text color to red
  TextColor(4);

  WriteLn('[error] ', str);

  // Reset text color
  TextColor(0);
end;

end.