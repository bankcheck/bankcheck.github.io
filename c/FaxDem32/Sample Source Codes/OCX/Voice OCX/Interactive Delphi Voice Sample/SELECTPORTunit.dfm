object frmSelectPort: TfrmSelectPort
  Left = 192
  Top = 107
  Width = 324
  Height = 312
  Caption = 'Select Port/Modem'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 79
    Height = 13
    Caption = 'Serial port to use'
  end
  object Label2: TLabel
    Left = 16
    Top = 64
    Width = 65
    Height = 13
    Caption = 'Modem Type:'
  end
  object Label3: TLabel
    Left = 16
    Top = 112
    Width = 63
    Height = 13
    Caption = 'Manufacturer'
  end
  object Label4: TLabel
    Left = 16
    Top = 160
    Width = 29
    Height = 13
    Caption = 'Model'
  end
  object Label5: TLabel
    Left = 16
    Top = 208
    Width = 91
    Height = 13
    Caption = 'Modem Capabilities'
  end
  object AllPorts: TComboBox
    Left = 16
    Top = 32
    Width = 89
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    Text = 'AllPorts'
    OnChange = AllPortsChange
  end
  object cbModemType: TComboBox
    Left = 16
    Top = 80
    Width = 193
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    Text = 'cbModemType'
    OnChange = cbModemTypeChange
    Items.Strings = (
      'Auto detect modem type'
      'Rockwell Chipset Based Modem'
      'USRobotics Sportster Modem'
      'Lucent Chipset Based Modem'
      'Cirrus Logic Chipset Based Modem'
      'Rockwell/Conexant HCF modem')
  end
  object Manufacturer: TEdit
    Left = 16
    Top = 128
    Width = 281
    Height = 21
    TabOrder = 2
  end
  object Model: TEdit
    Left = 16
    Top = 176
    Width = 281
    Height = 21
    TabOrder = 3
  end
  object ModemCaps: TEdit
    Left = 16
    Top = 224
    Width = 281
    Height = 21
    TabOrder = 4
  end
  object btnLog: TCheckBox
    Left = 16
    Top = 256
    Width = 97
    Height = 17
    Caption = 'Enable Log'
    TabOrder = 5
  end
  object btnOpenPort: TButton
    Left = 224
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Open Port'
    TabOrder = 6
    OnClick = btnOpenPortClick
  end
  object btnTest: TButton
    Left = 224
    Top = 48
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 7
    OnClick = btnTestClick
  end
  object btnCancel: TButton
    Left = 224
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = btnCancelClick
  end
end
