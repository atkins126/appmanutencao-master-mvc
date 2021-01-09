unit View.ClienteServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants,
  Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Datasnap.DBClient, IOUtils, System.SyncObjs, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  zLib, System.Classes, System.SysUtils, Data.DB, System.Threading, System.NetEncoding;

type
  TServidor = class
  private
    FPath: WideString;
  public
    constructor Create;
    // Tipo do parâmetro não pode ser alterado
    function SalvarArquivos(AData: OleVariant): Boolean;
    function SalvarArquivosFracionados(AData: OleVariant; i:integer): Boolean;
  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btEnviarParaleloClick(Sender: TObject);

  private
    FServidor: TServidor;
  public
  end;

var
  fClienteServidor: TfClienteServidor;

implementation

uses
   Model.EnviaArquivos;

{$R *.dfm}

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
 EnviarComErros : TEnviarComErros;
begin
  EnviarComErros := TEnviarComErros.Create;
  try
    EnviarComErros.EnviarArquivo;
  finally
    EnviarComErros.Free;
  end;
end;

procedure TfClienteServidor.btEnviarParaleloClick(Sender: TObject);
var
 EnviarParalelo : TEnviarParalelo;
begin
  EnviarParalelo := TEnviarParalelo.Create;
  try
    EnviarParalelo.EnviarArquivo;
  finally
   EnviarParalelo.Free;
  end;
end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
 EnviarSemErros : TEnviarSemErros;
begin
  EnviarSemErros := TEnviarSemErros.Create;
  try
    EnviarSemErros.EnviarArquivo;
  finally
   EnviarSemErros.Free;
  end;
end;

procedure TfClienteServidor.FormClose(Sender: TObject;
var Action: TCloseAction);
begin
  FServidor.Free;
end;

procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;
  FServidor := TServidor.Create;
end;

{ TServidor }
constructor TServidor.Create;
begin
  { Força a criação da pasta se não tiver }
  if (not DirectoryExists('Servidor')) then
    CreateDir('Servidor');

  FPath := ExtractFilePath(ParamStr(0)) + 'Servidor\';
end;

function TServidor.SalvarArquivos(AData: OleVariant): Boolean;
var
  cds: TClientDataset;
  FileName: string;
begin
  Result := False;
  cds := TClientDataset.Create(nil);

  try
    try
      cds.Data := AData;

{$REGION Simulação de erro, não alterar}
      if cds.RecordCount = 0 then
        Exit;
{$ENDREGION}
      cds.First;

      while not cds.Eof do
      begin
        FileName := FPath + cds.RecNo.ToString + '.pdf';

        if TFile.Exists(FileName) then
          TFile.Delete(FileName);

        TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);
        cds.Next;
      end;

      Result := True;
    except
      raise;
    end;

  finally
    cds.Free;
  end;

end;

function TServidor.SalvarArquivosFracionados(AData: OleVariant;
  i: integer): Boolean;

 var
  cds: TClientDataset;
  FileName: string;
begin
  Result := False;
  cds := TClientDataset.Create(nil);

  try
    try
      cds.Data := AData;

{$REGION Simulação de erro, não alterar}
      if cds.RecordCount = 0 then
        Exit;
{$ENDREGION}
      FileName := FPath + i.ToString + '.pdf';

      if TFile.Exists(FileName) then
        TFile.Delete(FileName);

      TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);

      Result := True;
    except
      raise;
    end;

  finally
    cds.Free;
  end;

end;
end.
