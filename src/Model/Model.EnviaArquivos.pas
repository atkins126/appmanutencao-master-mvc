﻿unit Model.EnviaArquivos;

interface

uses
  Datasnap.DBClient, System.threading, Vcl.Dialogs, System.UITypes;

type
  TEnviaArquivosServidor = class
  private
    FTipoEnvio: integer;
    FPath: WideString;

    procedure EnviarArquivo; virtual; abstract;
    function GetTipoEnvio: integer;
    function InitDataset: TClientDataset;
  public
    constructor Create;

  private
    procedure DeleteFiles;
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
  System.IOUtils, System.Classes;

{ EnviaArquivosServidor }

constructor TEnviaArquivosServidor.Create;
begin
  FPath := ExtractFilePath(ParamStr(0)) + 'Servidor\';
  FPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
    'pdf.pdf';
end;

function TEnviaArquivosServidor.GetTipoEnvio: integer;
begin
  Result := FTipoEnvio;
end;

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
 {Deleta os arquivos caso caia em except}

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
  SizeFile: integer;
  FServidor: TServidor;
  FileEntrada: TFileStream;
begin
  FServidor := TServidor.Create;
  FileEntrada := TFileStream.Create(FPath, fmOpenRead and fmShareExclusive);
  SizeFile := FileEntrada.Size;
  fClienteServidor.ProgressBar.Max := QTD_ARQUIVOS_ENVIAR;
  fClienteServidor.ProgressBar.Position := 0;

  FileEntrada.Free;

  cds := InitDataset;
  try
    if (SizeFile > 1000) then
    begin
      if MessageDlg('Arquivo muito grande, deseja realmente enviar?',
        mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
      begin
        TTask.Run(
          procedure
          begin
            TThread.Synchronize(TThread.CurrentThread,
              procedure
              begin
                TParallel.For(1, QTD_ARQUIVOS_ENVIAR,
                  procedure(i: integer)
                  begin
                    try
                      cds := InitDataset;
                      cds.Append;
                      TBlobField(cds.FieldByName('Arquivo'))
                        .LoadFromFile(FPath);
                      cds.Post;

                    finally
                      cds.Free;
                      cds := InitDataset;
                      FServidor.SalvarArquivosFracionados(cds.Data, i);
                    end;

                    fClienteServidor.ProgressBar.Position := i;
                  end);
                ShowMessage('Arquivos enviados com sucesso!');
              end);

          end);
        fClienteServidor.ProgressBar.Position := 0;
      end
      else
      begin
        fClienteServidor.ProgressBar.Position := 0;
        Abort;
      end;

    end
    else
    begin
      TTask.Run(
        procedure
        begin
          TThread.Synchronize(TThread.CurrentThread,
            procedure
            begin
              TParallel.For(1, QTD_ARQUIVOS_ENVIAR,
                procedure(i: integer)
                begin
                  try
                    cds := InitDataset;
                    cds.Append;
                    TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
                    cds.Post;

                  finally
                    cds.Free;
                    cds := InitDataset;
                    FServidor.SalvarArquivos(cds.Data);
                  end;

                  fClienteServidor.ProgressBar.Position := i;
                end);
              ShowMessage('Arquivos enviados com sucesso!');
            end);

        end);
      fClienteServidor.ProgressBar.Position := 0;

    end;

  finally
    FServidor.Free;
    cds.Free;
  end;
end;

{ TEnviarComErros }

procedure TEnviarComErros.EnviarArquivo;
var
  cds: TClientDataset;
  i, SizeFile: integer;
  FServidor: TServidor;
  FileEntrada: TFileStream;

begin
  FServidor   := TServidor.Create;
  FileEntrada := TFileStream.Create(FPath, fmOpenRead and fmShareExclusive);
  SizeFile    := FileEntrada.Size;
  fClienteServidor.ProgressBar.Position := 0;
  fClienteServidor.ProgressBar.Max := QTD_ARQUIVOS_ENVIAR;

 {Libera pra não ficar na memória e para liberar o arquivo}
  FileEntrada.Free;

  cds := InitDataset;
  try
    if (SizeFile > 1000) then
    begin
      if MessageDlg('Arquivo muito grande, deseja realmente enviar?',
        mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
      begin
        for i := 1 to QTD_ARQUIVOS_ENVIAR do
        begin
          try
            try
              cds.Append;
              TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
              cds.Post;

{$REGION Simulação de erro, não alterar}
              if i = (QTD_ARQUIVOS_ENVIAR / 2) then
                FServidor.SalvarArquivos(NULL);
{$ENDREGION}
            finally
              FServidor.SalvarArquivosFracionados(cds.Data, i);
              cds.Free;
              cds := InitDataset;
            end;
          except
            fClienteServidor.ProgressBar.Position := 0;
            DeleteFiles;
            Abort;
          end;

          fClienteServidor.ProgressBar.Position := i;
        end;

        ShowMessage('Arquivos enviados com sucesso!');
      end
      else
      begin
        fClienteServidor.ProgressBar.Position := 0;
        Abort;
      end;

    end
    else
    begin
      for i := 0 to QTD_ARQUIVOS_ENVIAR do
      begin
        cds.Append;
        TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
        cds.Post;

{$REGION Simulação de erro, não alterar}
        if i = (QTD_ARQUIVOS_ENVIAR / 2) then
          FServidor.SalvarArquivos(NULL);
{$ENDREGION}
        fClienteServidor.ProgressBar.Position := i;
      end;

      FServidor.SalvarArquivos(cds.Data);
    end;

  finally
    FServidor.Free;
    cds.Free;
  end;
end;

{ TEnviarSemErros }

procedure TEnviarSemErros.EnviarArquivo;
var
  cds: TClientDataset;
  i, SizeFile: integer;
  FServidor: TServidor;
  FileEntrada: TFileStream;

begin
  FServidor := TServidor.Create;
  FileEntrada := TFileStream.Create(FPath, fmOpenRead and fmShareExclusive);
  SizeFile := FileEntrada.Size;
  fClienteServidor.ProgressBar.Max := QTD_ARQUIVOS_ENVIAR;
  fClienteServidor.ProgressBar.Position := 0;

  FileEntrada.Free;

  cds := InitDataset;
  try
    if (SizeFile > 1000) then
    begin
      if MessageDlg('Arquivo muito grande, deseja realmente enviar?',
        mtConfirmation, [mbYes, mbNo], 0, mbYes) = mrYes then
      begin
        for i := 1 to QTD_ARQUIVOS_ENVIAR do
        begin

          try
            cds.Append;
            TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
            cds.Post;
          finally
            FServidor.SalvarArquivosFracionados(cds.Data, i);
            cds.Free;
            cds := InitDataset;
          end;

          fClienteServidor.ProgressBar.Position := i;
        end;

        ShowMessage('Arquivos enviados com sucesso!');
      end
      else
      begin
        fClienteServidor.ProgressBar.Position := 0;
        Abort;
      end;

    end
    else
    begin
      for i := 0 to QTD_ARQUIVOS_ENVIAR do
      begin
        cds.Append;
        TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
        cds.Post;

        fClienteServidor.ProgressBar.Position := i;
      end;

      FServidor.SalvarArquivos(cds.Data);
    end;

  finally
    FServidor.Free;
    cds.Free;
  end;

end;

end.
