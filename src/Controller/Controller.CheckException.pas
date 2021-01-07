unit Controller.CheckException;

interface

uses
  System.SysUtils, Forms, System.Classes;

type
  TException = class
  private
    FLogFile: String;
  public
    constructor Create;
    procedure CheckException(Sender: TObject; e: Exception);
    procedure SaveLog(Value: String);
  end;

implementation

uses
  Vcl.Dialogs;

{ TException }

procedure TException.CheckException(Sender: TObject; e: Exception);
begin
  SaveLog('======================================================');

  if TComponent(Sender) is TForm then
  begin
    SaveLog('Form: ' + TForm(Sender).Name);
    SaveLog('Caption: ' + TForm(Sender).Caption);
    SaveLog('Classe: ' + e.ClassName);
    SaveLog('Erro: ' + e.Message);
  end
  else
  begin
    SaveLog('Form: ' + TForm(TComponent(Sender).Owner).Name);
    SaveLog('Caption: ' + TForm(TComponent(Sender).Owner).Caption);
    SaveLog('Classe: ' + e.ClassName);
    SaveLog('Erro: ' + e.Message);
  end;

  ShowMessage(e.Message);
end;

constructor TException.Create;
begin
  FLogFile := ChangeFileExt(ParamStr(0), '.log');
  Application.OnException := CheckException;
end;

procedure TException.SaveLog(Value: String);
var
  txtLog: TextFile;
begin
  AssignFile(txtLog, FLogFile);
  if FileExists(FLogFile) then
    Append(txtLog)
  else
    Rewrite(txtLog);

  Writeln(txtLog, FormatDateTime('dd-mm-yyyy hh:nn:ss - ', Now) + Value);

  CloseFile(txtLog);
end;

var
  MyException : TException;

initialization
  MyException := TException.Create;
finalization
  MyException.Free;

end.
