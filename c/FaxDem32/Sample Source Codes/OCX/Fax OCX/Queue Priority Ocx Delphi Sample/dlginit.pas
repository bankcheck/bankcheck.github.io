unit dlginit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TDialogic = class(TForm)
    Label1: TLabel;
    Label3: TLabel;
    GammaLinkChannelsGroupBox: TGroupBox;
    DialogicChannelsListBox: TListBox;
    HeaderCheckBox: TCheckBox;
    NumberOfRingsEdit: TEdit;
    OKButton: TButton;
    CancelButton: TButton;
    LocalIDEdit: TEdit;
    OpenDialog: TOpenDialog;
    procedure OnShowDlgcInit(Sender: TObject);
    procedure HeaderCheckboxClicked(Sender: TObject);
    procedure NrOfRingsedit(Sender: TObject);
    procedure LocalIDEditChange(Sender: TObject);
    procedure CancleClicked(Sender: TObject);
    procedure OnOK(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Dialogic: TDialogic;

implementation

uses Main, FaxDlg;

{$R *.DFM}

procedure TDialogic.OnShowDlgcInit(Sender: TObject);
var
   DialogicChannels,temp:string;
   index:byte;
begin
     DialogicChannelsListBox.Clear;
     DialogicChannels:=MainForm.FAX1.AvailableDialogicChannels+' ';
     index:=Pos(' ',DialogicChannels);
     while index<>0 do
     begin
          temp:=copy(DialogicChannels,1,index-1);
          DialogicChannelsListBox.Items.Add(temp);
          delete(DialogicChannels,1,index);
          index:=Pos(' ',DialogicChannels);
     end;
     DialogicChannelsListBox.ItemIndex:=0;
     LocalIDEdit.Text:=MainForm.Fax1.LocalID;
     NumberOfRingsEdit.Text:=IntToStr(MainForm.Fax1.Rings);
     HeaderCheckBox.Checked:=MainForm.FAX1.Header;


end;

procedure TDialogic.HeaderCheckboxClicked(Sender: TObject);
begin
    MainForm.FAX1.Header:=HeaderCheckBox.Checked;
end;

procedure TDialogic.NrOfRingsedit(Sender: TObject);
begin
     MainForm.Fax1.Rings:=StrToIntDef(NumberOfRingsEdit.Text,0);
     NumberOfRingsEdit.Text:=IntToStr(MainForm.Fax1.Rings);
end;

procedure TDialogic.LocalIDEditChange(Sender: TObject);
begin
     MainForm.Fax1.LocalID:=LocalIDEdit.Text+' ';
end;

procedure TDialogic.CancleClicked(Sender: TObject);
begin
     Close;
end;

procedure TDialogic.OnOK(Sender: TObject);
var errorOpenPort:integer;
begin
     Screen.Cursor:=-11;
     MainForm.ActualFaxPort:=DialogicChannelsListBox.Items[DialogicChannelsListBox.ItemIndex];
     errorOpenPort:=MainForm.FAX1.OpenPort(MainForm.ActualFaxPort);
     if errorOPenPort<>0 then
        begin
//              MessageDlg('Unable to open Dialogic'+MainForm.ActualFaxPort+' Error code:'+IntToStr(errorOpenPort),mtWarning,[mbOK],0)
                  MessageDlg(MainForm.Errors(errorOpenPort),mtWarning,[mbOK],0);
                  Screen.Cursor:=-2;
                  Exit;
        end
     else
     begin
//     MainForm.FAX1.SetSpeakerMode(MainForm.ActualFaxPort,FaxConfigDlg.SpeakerModeRadioGroup.ItemIndex,FaxConfigDlg.SpeakerVolumeRadioGroup.ItemIndex);
        MainForm.EventListBox.Items.Add(DialogicChannelsListBox.Items[DialogicChannelsListBox.ItemIndex] + ' was opened');

        if HeaderCheckBox.Checked then
            MainForm.FAX1.Header := True
        else
            MainForm.FAX1.Header := False;

        MainForm.FAX1.SetPortCapability(MainForm.ActualFaxPort, PC_MAX_BAUD_SEND, MainForm.BaudRate);

     end;

     if (Length(MainForm.FAX1.DialogicChannelsOpen)>0) then
     begin
        MainForm.Close1.Enabled:=True;
        MainForm.ShowFaxManager1.Enabled:=True;
        MainForm.Send1.Enabled:=True;
     end;
     Close;

    if Length(MainForm.FAX1.AvailableDialogicChannels) > 0 then
        MainForm.Dialogicchannel1.Enabled := True
    else
        MainForm.Dialogicchannel1.Enabled := False;

     Screen.Cursor:=-2;
end;

end.
