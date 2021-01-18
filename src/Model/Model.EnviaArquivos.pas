unit Model.EnviaArquivos;

interface

uses
  Datasnap.DBClient, System.threading, Vcl.Dialogs, System.UITypes,
  Winapi.Windows, Vcl.Forms;

type
  TEnviaArquivosServidor = class
  private
    procedure DeleteFiles;
    procedure EnviarArquivo; virtual; abstract;
    function InitDataset: TClientDataset;
   end;

type
  TEnviarSemErros = class(TEnviaArquivosServidor)
    procedure EnviarArquivo; override;
  end;

type
  TEnviarComErros = class(TEnviaArquivosServidor)
    procedure EnviarArquivo; override;
  end;

type
  TEnviarParalelo = class(TEnviaArquivosServidor)
    procedure EnviarArquivo; override;
  end;

const
  QTD_ARQUIVOS_ENVIAR = 100;

implementation

uses
  Data.DB, View.ClienteServidor, System.SysUtils, System.Variants, Vcl.Controls,
  System.IOUtils, System.Classes, FireDAC.Comp.Client;

{ EnviaArquivosServidor }

function TEnviaArquivosServidor.InitDataset: TClientDataset;
begin
  Result := TClientDataset.Create(nil);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
end;

procedure TEnviaArquivosServidor.DeleteFiles;
var
  i: integer;
  sr: TSearchRec;
begin
  { Deleta os arquivos caso caia em except }

  i := FindFirst('Servidor\*.*', faAnyFile, sr);
  while i = 0 do
  begin
    DeleteFile('Servidor\' + sr.Name);
    i := FindNext(sr);
  end;
end;

{ TEnviarParalelo }

procedure TEnviarParalelo.EnviarArquivo;
var
  cds: TClientDataset;
  FServidor: TServidor;
  aTask : iTask;
begin
  aTask := TTask.Create(
  procedure
  begin

    TParallel.For(0, QTD_ARQUIVOS_ENVIAR,
    procedure(i:integer)
    begin

     TThread.Synchronize(TThread.CurrentThread,
      procedure
      begin
         FServidor := TServidor.Create;
        try
          cds := InitDataset;
          cds.Append;
          TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FServidor.Fpath);
          cds.Post;
        finally
          FServidor.SalvarArquivosFracionados(cds.Data,i);
          FServidor.Free;
          cds.Free;
        end;

        Application.ProcessMessages;
        fClienteServidor.ProgressBar.Position := i;
      end);

    end);

    ShowMessage('Processo concluído!');
    fClienteServidor.ProgressBar.Position := 0;
  end);
  aTask.Start;
end;

{ TEnviarComErros }

procedure TEnviarComErros.EnviarArquivo;
var
  cds: TClientDataset;
  FServidor: TServidor;
  aTask: iTask;
begin
  aTask := TTask.Create(
  procedure
  var i :integer;
  begin
   for i := 0 to QTD_ARQUIVOS_ENVIAR do
    begin
      try
       FServidor := TServidor.Create;
        try
          cds := InitDataset;
          cds.Append;
          TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FServidor.Fpath);
          cds.Post;

  {$REGION Simulação de erro, não alterar}
          if i = (QTD_ARQUIVOS_ENVIAR / 2) then
            FServidor.SalvarArquivos(NULL);
  {$ENDREGION}
        finally
          FServidor.SalvarArquivosFracionados(cds.Data, i);
          cds.Free;
          FServidor.Free;
        end;
       except
        fClienteServidor.ProgressBar.Position := 0;
        DeleteFiles;
        Abort;
      end;

      Application.ProcessMessages;
      fClienteServidor.ProgressBar.Position := i;
    end;

    ShowMessage('Processo concluído!');
    fClienteServidor.ProgressBar.Position := 0;
  end);
  aTask.Start;

end;

{ TEnviarSemErros }

procedure TEnviarSemErros.EnviarArquivo;
var
  cds: TClientDataset;
  FServidor: TServidor;
  aTask : iTask;
begin
  aTask := TTask.Create(
  procedure
  var i :integer;
  begin
   for i := 0 to QTD_ARQUIVOS_ENVIAR do
    begin
      FServidor := TServidor.Create;
      try
        cds := InitDataset;
        cds.Append;
        TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FServidor.Fpath);
        cds.Post;
      finally
        FServidor.SalvarArquivosFracionados(cds.Data,i);
        cds.Free;
        FServidor := TServidor.Create;
      end;

     TThread.Synchronize(TThread.CurrentThread,
     procedure
      begin
       Application.ProcessMessages;
       fClienteServidor.ProgressBar.Position := i;
      end);
    end;

    ShowMessage('Processo concluído!');
    fClienteServidor.ProgressBar.Position := 0;
  end);
  aTask.Start;

end;

end.
