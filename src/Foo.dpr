program Foo;

uses
  Vcl.Forms,
  View.Main in 'View\View.Main.pas' {fMain},
  View.DatasetLoop in 'View\View.DatasetLoop.pas' {fDatasetLoop},
  View.ClienteServidor in 'View\View.ClienteServidor.pas' {fClienteServidor},
  Controller.CheckException in 'Controller\Controller.CheckException.pas',
  View.Threads in 'View\View.Threads.pas' {fThreads},
  Controller.Threading in 'Controller\Controller.Threading.pas',
  Model.EnviaArquivos in 'Model\Model.EnviaArquivos.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  ApPlication.Run;
end.
