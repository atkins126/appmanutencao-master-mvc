object fThreads: TfThreads
  Left = 0
  Top = 0
  Caption = 'Threads'
  ClientHeight = 267
  ClientWidth = 313
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
    Left = 62
    Top = 37
    Width = 64
    Height = 13
    Caption = 'Qtd. Threads'
  end
  object Label2: TLabel
    Left = 224
    Top = 37
    Width = 26
    Height = 13
    Caption = 'Timer'
  end
  object EdtqtdTrheads: TEdit
    Left = 62
    Top = 56
    Width = 57
    Height = 21
    TabOrder = 0
  end
  object edtTimer: TEdit
    Left = 206
    Top = 56
    Width = 57
    Height = 21
    TabOrder = 1
  end
  object btnProcessar: TButton
    Left = 125
    Top = 83
    Width = 75
    Height = 25
    Caption = 'Processar'
    TabOrder = 2
    OnClick = btnProcessarClick
  end
  object ProgressBar1: TProgressBar
    AlignWithMargins = True
    Left = 3
    Top = 233
    Width = 307
    Height = 24
    Margins.Bottom = 10
    Align = alBottom
    Max = 101
    TabOrder = 3
    ExplicitTop = 265
  end
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 3
    Top = 117
    Width = 307
    Height = 110
    Align = alBottom
    Alignment = taCenter
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    ExplicitTop = 115
  end
end
