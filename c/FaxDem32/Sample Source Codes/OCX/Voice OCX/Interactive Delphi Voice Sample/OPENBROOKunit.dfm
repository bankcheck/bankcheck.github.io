object frmOpenBrook: TfrmOpenBrook
  Left = 192
  Top = 107
  Width = 386
  Height = 146
  Caption = 'Open Brooktrout Channel'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 90
    Height = 13
    Caption = 'Available Channels'
  end
  object Label2: TLabel
    Left = 136
    Top = 48
    Width = 62
    Height = 13
    Caption = 'Modem Type'
  end
  object Label3: TLabel
    Left = 136
    Top = 8
    Width = 49
    Height = 13
    Caption = 'Config file:'
  end
  object lvChannelList: TListBox
    Left = 16
    Top = 24
    Width = 105
    Height = 81
    ItemHeight = 13
    TabOrder = 0
  end
  object chbLogEn: TCheckBox
    Left = 136
    Top = 88
    Width = 97
    Height = 17
    Caption = 'Enable Log'
    TabOrder = 1
  end
  object ModemType: TEdit
    Left = 136
    Top = 64
    Width = 137
    Height = 21
    TabOrder = 2
    Text = 'Unknown Modem'
  end
  object btnOK: TButton
    Left = 288
    Top = 16
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 288
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object btnTest: TButton
    Left = 288
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 5
    OnClick = btnTestClick
  end
  object ConfigFile: TEdit
    Left = 136
    Top = 24
    Width = 137
    Height = 21
    TabOrder = 6
  end
end
