object fThreads: TfThreads
  Left = 0
  Top = 0
  Caption = 'fThreads'
  ClientHeight = 237
  ClientWidth = 430
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
  object Label1: TLabel
    Left = 94
    Top = 29
    Width = 64
    Height = 13
    Caption = 'Qtd. Threads'
  end
  object Label2: TLabel
    Left = 280
    Top = 29
    Width = 26
    Height = 13
    Caption = 'Timer'
  end
  object EdtqtdTrheads: TEdit
    Left = 80
    Top = 48
    Width = 95
    Height = 21
    TabOrder = 0
  end
  object edtTimer: TEdit
    Left = 248
    Top = 48
    Width = 95
    Height = 21
    TabOrder = 1
  end
  object btnProcessar: TButton
    Left = 175
    Top = 75
    Width = 75
    Height = 25
    Caption = 'Processar'
    TabOrder = 2
    OnClick = btnProcessarClick
  end
  object ProgressBar1: TProgressBar
    AlignWithMargins = True
    Left = 3
    Top = 210
    Width = 424
    Height = 17
    Margins.Bottom = 10
    Align = alBottom
    TabOrder = 3
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 114
    Width = 424
    Height = 90
    Align = alBottom
    TabOrder = 4
  end
end