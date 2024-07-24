object frmOpenNMS: TfrmOpenNMS
  Left = 192
  Top = 107
  Width = 294
  Height = 304
  Caption = 'Open NMS Channel'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 200
    Width = 80
    Height = 13
    Caption = 'DID/DNIS digits:'
  end
  object Label2: TLabel
    Left = 16
    Top = 224
    Width = 122
    Height = 13
    Caption = 'NMS Telephony Protocol:'
  end
  object lvChannelList: TListView
    Left = 16
    Top = 16
    Width = 250
    Height = 137
    Columns = <
      item
        Caption = 'Name'
        Width = 121
      end
      item
        Caption = 'Type'
        Width = 121
      end>
    GridLines = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object chbLogEn: TCheckBox
    Left = 16
    Top = 168
    Width = 97
    Height = 17
    Caption = 'Enable Log'
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 104
    Top = 192
    Width = 49
    Height = 21
    TabOrder = 2
    Text = '3'
  end
  object btnOK: TButton
    Left = 192
    Top = 168
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 192
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object ProtocolCombo: TComboBox
    Left = 16
    Top = 240
    Width = 257
    Height = 21
    ItemHeight = 13
    TabOrder = 5
    Text = 'ProtocolCombo'
  end
end
