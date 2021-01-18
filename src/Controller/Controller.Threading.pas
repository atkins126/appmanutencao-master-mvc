unit Controller.Threading;

interface

uses
  System.Threading, System.Classes, System.SysUtils;

type
  TThreadObject = class(TThread)
  private
    FTimeWaiting: integer;
    procedure SetTimeWaiting(const Value: integer);

    { Private declarations }
  public
    property TimeWaiting: integer read FTimeWaiting write SetTimeWaiting;
    procedure Execute; override;
  end;

implementation

uses View.Threads, Vcl.Forms, System.SyncObjs;

procedure TThreadObject.Execute;
var
  i: Integer;
begin
  for i := 0 to 100 do
  begin
   sleep(Random(TimeWaiting));
   fThreads.ProgressBar1.Position := i;
   Application.ProcessMessages;
  end;
end;

procedure TThreadObject.SetTimeWaiting(const Value: integer);
begin
  FTimeWaiting := Value;
end;

end.
