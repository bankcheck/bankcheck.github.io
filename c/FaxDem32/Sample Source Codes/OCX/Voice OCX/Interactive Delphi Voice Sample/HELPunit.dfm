object frmHelp: TfrmHelp
  Left = 192
  Top = 107
  Width = 509
  Height = 531
  Caption = 'frmHelp'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RichEdit1: TRichEdit
    Left = 0
    Top = 0
    Width = 501
    Height = 449
    Align = alTop
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 216
    Top = 464
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 1
    OnClick = Button1Click
  end
end
