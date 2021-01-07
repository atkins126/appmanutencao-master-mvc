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
    property TimeWaiting : integer read FTimeWaiting write SetTimeWaiting;
    procedure Execute; override;
  end;

implementation

uses View.Threads;

procedure TThreadObject.Execute;
var
  I: Integer;
begin
  fThreads.Memo1.Lines.Add(ThreadID.ToString +' - Iniciando processamento');

 for I := 0 to 100 do
  begin
    TTask.Run(procedure
    begin
     sleep(Random(TimeWaiting));
    end);

   fThreads.ProgressBar1.Position := I;
  end;

 fThreads.Memo1.Lines.Add(ThreadID.ToString + ' - Processamento Finalizado');
 fThreads.Memo1.Lines.Add(' ');
end;

procedure TThreadObject.SetTimeWaiting(const Value: integer);
begin
  FTimeWaiting := Value;
end;

end.
