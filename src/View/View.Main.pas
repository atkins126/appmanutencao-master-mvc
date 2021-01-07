unit View.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfMain = class(TForm)
    btDatasetLoop: TButton;
    btThreads: TButton;
    btStreams: TButton;
    procedure btDatasetLoopClick(Sender: TObject);
    procedure btStreamsClick(Sender: TObject);
    procedure btThreadsClick(Sender: TObject);

  private
  public
  end;

var
  fMain: TfMain;

implementation

uses
  View.DatasetLoop, View.ClienteServidor, Controller.CheckException,
  View.Threads;

{$R *.dfm}

procedure TfMain.btDatasetLoopClick(Sender: TObject);
begin
 if not Assigned(fDatasetLoop) then
   Application.CreateForm(TfDatasetLoop, fDatasetLoop);

  fDatasetLoop.Show;
end;

procedure TfMain.btStreamsClick(Sender: TObject);
begin
 if not Assigned(fClienteServidor) then
   Application.CreateForm(TfClienteServidor, fClienteServidor);

  fClienteServidor.Show;
end;

procedure TfMain.btThreadsClick(Sender: TObject);
begin
 if not Assigned(fThreads) then
   Application.CreateForm(TfThreads, fThreads);

  fThreads.Show;
end;

end.
