unit Model.EnviaArquivos_Interfaces;

interface
 type
  iEnviaArquivos = interface
  ['{13568154-A8C2-4034-9EE8-A5D5DA52DFAC}']
   function EnviarSemErros: iEnviaArquivos;
   function EnviarComErros: iEnviaArquivos;
   function EnviaParalelo:  iEnviaArquivos;
   function InitDataset: iEnviaArquivos;
   function SetPath: iEnviaArquivos;
 end;

implementation

end.
