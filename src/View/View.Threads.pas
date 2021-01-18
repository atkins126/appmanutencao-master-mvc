unit View.Threads;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Dialogs, Vcl.ComCtrls,
  Vcl.StdCtrls,
  System.Threading, Winapi.Windows, Vcl.Forms;

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
begin
  if EdtqtdTrheads.Text = '' then
  begin
    ShowMessage('Informe a quantidade de Tthreads a ser executada!');
    exit;
  end
 else if edtTimer.Text = '' then
  begin
    ShowMessage('Informe o timer!');
    exit;
  end;

  Memo1.Clear;
  Processed := False;

  StartProcess;
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
  MyThread: TThreadObject;
  aTask: itask;
begin
 TThread.Synchronize(TThread.CurrentThread,
  procedure
  begin
    aTask := TTask.Create(
    procedure
    var
      I: Integer;
    begin
      for I := 1 to StrToInt(EdtqtdTrheads.Text) do
      begin
        MyThread := TThreadObject.Create;
        try
          Memo1.Lines.Add(MyThread.ThreadID.ToString +' - Iniciando processamento');
          MyThread.TimeWaiting := StrToInt(edtTimer.Text);
          MyThread.Execute;
        finally
          Memo1.Lines.Add(MyThread.ThreadID.ToString +' - Processamento Finalizado');
          Memo1.Lines.Add(' ');
          MyThread.Free;
        end;
      end;

      ShowMessage('Processo concluído com sucesso!');
      ProgressBar1.Position := 0;
      Processed := True;

    end);
    aTask.Start;
  end);

end;

end.
