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

uses View.Threads, Vcl.Forms;

procedure TThreadObject.Execute;
var
  I: integer;
  aTask: iTask;
begin
  fThreads.Memo1.Lines.Add(ThreadID.ToString + ' - Iniciando processamento');
  TParallel.for(0, 100,
    procedure(I: integer)
    begin
      sleep(Random(TimeWaiting));
      fThreads.ProgressBar1.Position := I;
      Synchronize(Application.ProcessMessages);
    end);
  fThreads.Memo1.Lines.Add(ThreadID.ToString + ' - Processamento Finalizado');
  fThreads.Memo1.Lines.Add(' ');
end;

procedure TThreadObject.SetTimeWaiting(const Value: integer);
begin
  FTimeWaiting := Value;
end;

end.
