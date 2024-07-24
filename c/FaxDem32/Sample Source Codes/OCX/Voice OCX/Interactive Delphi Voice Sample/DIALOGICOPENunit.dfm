object frmDialogicOpen: TfrmDialogicOpen
  Left = 192
  Top = 107
  Width = 348
  Height = 289
  Caption = 'Open Dialogic Channel'
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
    Top = 176
    Width = 50
    Height = 13
    Caption = 'Line Type:'
  end
  object Label2: TLabel
    Left = 176
    Top = 176
    Width = 42
    Height = 13
    Caption = 'Protocol:'
    Enabled = False
  end
  object lvChannelList: TListView
    Left = 16
    Top = 16
    Width = 305
    Height = 150
    Columns = <
      item
        Caption = 'Name'
        Width = 150
      end
      item
        Caption = 'Type'
        Width = 140
      end>
    GridLines = True
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = lvChannelListClick
  end
  object LineType: TComboBox
    Left = 16
    Top = 192
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
    OnChange = LineTypeChange
    Items.Strings = (
      'Analog'
      'ISDN PRI'
      'T1'
      'E1')
  end
  object Protocol: TEdit
    Left = 176
    Top = 192
    Width = 145
    Height = 21
    Enabled = False
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 88
    Top = 224
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 176
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = btnCancelClick
  end
end
