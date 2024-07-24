unit FaxDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFaxConfigDlg = class(TForm)
    SpeakerModeRadioGroup: TRadioGroup;
    SpeakerVolumeRadioGroup: TRadioGroup;
    BaudRateRadioGroup: TRadioGroup;
    EnableECMCheckBox: TCheckBox;
    EnableBFTCheckBox: TCheckBox;
    OKbutton: TButton;
    CancelButton: TButton;
    SaveDialog1: TSaveDialog;
    procedure ShowFAxConfigDialog(Sender: TObject);
    procedure ClickOK(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FaxConfigDlg: TFaxConfigDlg;

implementation

uses Main, OpenDlg;

{$R *.DFM}

procedure TFaxConfigDlg.ShowFAxConfigDialog(Sender: TObject);
begin
    BaudRateRadioGroup.ItemIndex:=MainForm.BaudRate-2;
    SpeakerModeRadioGroup.ItemIndex:=MainForm.SpeakerMode;
    SpeakerVolumeRadioGroup.ItemIndex:=MainForm.SpeakerVolume;



    if MainForm.EnableECM=EC_ENABLE then
         EnableECMCheckBox.Checked:=True
    else
         EnableECMCheckBox.Checked:=False;

    if MainForm.EnableBFT=BF_ENABLE then
         EnableBFTCheckBox.Checked:=True
    else
         EnableBFTCheckBox.Checked:=False;
        
end;

procedure TFaxConfigDlg.ClickOK(Sender: TObject);
begin
    MainForm.BaudRate:=BaudRateRadioGroup.ItemIndex+2;
    MainForm.SpeakerMode:=SpeakerModeRadioGroup.ItemIndex;
    MainForm.SpeakerVolume:=SpeakerVolumeRadioGroup.ItemIndex;

    if  EnableECMCheckBox.Checked then
         MainForm.EnableECM:=EC_ENABLE
    else
         MainForm.EnableECM:=EC_DISABLE;

    if  EnableBFTCheckBox.Checked then
         MainForm.EnableBFT:=BF_ENABLE
    else
         MainForm.EnableBFT:=BF_DISABLE;

    MainForm.FAX1.SetSpeakerMode(MainForm.ActualFaxPort,MainForm.SpeakerMode,MainForm.SpeakerVolume);
    MainForm.FAX1.SetPortCapability(MainForm.ActualFaxPort,PC_ECM,MainForm.EnableECM);
    MainForm.FAX1.SetPortCapability(MainForm.ActualFaxPort,PC_BINARY,MainForm.EnableBFT);
    MainForm.FAX1.SetPortCapability(MainForm.ActualFaxPort,PC_MAX_BAUD_SEND,MainForm.BaudRate);
    close;

end;

procedure TFaxConfigDlg.CancelClick(Sender: TObject);
begin
close;
end;


end.
