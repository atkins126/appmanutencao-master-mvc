unit View.Threads;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  System.Threading;

type
  TfThreads = class(TForm)
    EdtqtdTrheads: TEdit;
    edtTimer: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnProcessar: TButton;
    ProgressBar1: TProgressBar;
    Memo1: TMemo;
    procedure StartProcess;
    procedure btnProcessarClick(Sender: TObject);

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
  private
    Processed: boolean;
  published
    { Private declarations }
  public
    { Public declarations }

  end;

var
  fThreads: TfThreads;

implementation

{$R *.dfm}

uses Controller.Threading;

procedure TfThreads.btnProcessarClick(Sender: TObject);
var
  aTask: iTask;
begin
  aTask := TTask.Create(
  procedure
   begin
    Processed := False;
    StartProcess;
    ShowMessage('Processo concluído com sucesso!');
   end);
  aTask.Start;
end;

procedure TfThreads.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if not Processed then
  begin
    ShowMessage('Espere até o término dos processos.');
    Abort;
  end;
end;

procedure TfThreads.FormCreate(Sender: TObject);
begin
 Processed := True;
end;

procedure TfThreads.StartProcess;
var
  I: Integer;
  MyThread: TThreadObject;
begin
  fThreads.ProgressBar1.Position := 0;
  fThreads.ProgressBar1.Max := 101;

  try
    for I := 1 to StrToInt(EdtqtdTrheads.Text) do
    begin
      MyThread := TThreadObject.Create;
      try
        MyThread.TimeWaiting := StrToInt(edtTimer.Text);
        MyThread.Execute;
      finally
        MyThread.Free;
      end;

    end;
  finally
   ProgressBar1.Position := 0;
   Processed := True;
  end;

end;

end.
