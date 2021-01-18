object fClienteServidor: TfClienteServidor
  Left = 0
  Top = 0
  Caption = 'Cliente - Servidor'
  ClientHeight = 88
  ClientWidth = 495
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ProgressBar: TProgressBar
    AlignWithMargins = True
    Left = 5
    Top = 57
    Width = 485
    Height = 23
    Margins.Left = 5
    Margins.Right = 5
    Margins.Bottom = 8
    Align = alBottom
    TabOrder = 0
  end
  object btEnviarSemErros: TButton
    Left = 56
    Top = 19
    Width = 113
    Height = 25
    Caption = 'Enviar sem erros'
    TabOrder = 1
    OnClick = btEnviarSemErrosClick
  end
  object btEnviarComErros: TButton
    Left = 175
    Top = 19
    Width = 113
    Height = 25
    Caption = 'Enviar com erros'
    TabOrder = 2
    OnClick = btEnviarComErrosClick
  end
  object btEnviarParalelo: TButton
    Left = 294
    Top = 19
    Width = 113
    Height = 25
    Caption = 'Enviar paralelo'
    TabOrder = 3
    OnClick = btEnviarParaleloClick
  end
end
