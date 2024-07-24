unit GammaInit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TGammaLinkInit = class(TForm)
    GammaLinkChannelsGroupBox: TGroupBox;
    GammaChannelsListBox: TListBox;
    HeaderCheckBox: TCheckBox;
    NumberOfRingsEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ConfigFileEdit: TEdit;
    BrowseButton: TButton;
    OKButton: TButton;
    CancelButton: TButton;
    OpenDialog: TOpenDialog;
    Label3: TLabel;
    LocalIDEdit: TEdit;
    procedure ShowInitGammaLink(Sender: TObject);
    procedure OnLocalEditChange(Sender: TObject);
    procedure OnNrOfRingsEditChange(Sender: TObject);
    procedure CliickHeaderCheckBoxCheckBox(Sender: TObject);
    procedure OnClickBrowse(Sender: TObject);
    procedure OnConfigFileEditChange(Sender: TObject);
    procedure OnClickCancel(Sender: TObject);
    procedure OnClickOK(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GammaLinkInit: TGammaLinkInit;

implementation

uses Main, FaxDlg;

{$R *.DFM}

procedure TGammaLinkInit.ShowInitGammaLink(Sender: TObject);
var
   GammaChannels,temp:string;
   index:byte;
begin
     GammaChannelsListBox.Clear;
     GammaChannels:=MainForm.FAX1.AvailableGammaChannels+' ';
     index:=Pos(' ',GammaChannels);
     while index<>0 do
     begin
          temp:=copy(GammaChannels,1,index-1);
          GammaChannelsListBox.Items.Add(temp);
          delete(GammaChannels,1,index);
          index:=Pos(' ',GammaChannels);
     end;


     GammaChannelsListBox.ItemIndex:=0;
     LocalIDEdit.Text:=MainForm.Fax1.LocalID;
     NumberOfRingsEdit.Text:=IntToStr(MainForm.Fax1.Rings);
     HeaderCheckBox.Checked:=MainForm.FAX1.Header;
end;

procedure TGammaLinkInit.OnLocalEditChange(Sender: TObject);
begin
     MainForm.Fax1.LocalID:=LocalIDEdit.Text+' ';
end;

procedure TGammaLinkInit.OnNrOfRingsEditChange(Sender: TObject);
begin
     MainForm.Fax1.Rings:=StrToIntDef(NumberOfRingsEdit.Text,0);
     NumberOfRingsEdit.Text:=IntToStr(MainForm.Fax1.Rings);
end;

procedure TGammaLinkInit.CliickHeaderCheckBoxCheckBox(Sender: TObject);
begin
    MainForm.FAX1.Header:=HeaderCheckBox.Checked; 
end;

procedure TGammaLinkInit.OnClickBrowse(Sender: TObject);
begin
     if OpenDialog.Execute then
          ConfigFileEdit.Text:=OpenDialog.FileName;
end;

procedure TGammaLinkInit.OnConfigFileEditChange(Sender: TObject);
begin
     MainForm.FAX1.GammaCFile:=ConfigFileEdit.Text;
end;

procedure TGammaLinkInit.OnClickCancel(Sender: TObject);
begin
     Close;
end;

procedure TGammaLinkInit.OnClickOK(Sender: TObject);
var errorOpenPort:integer;
begin
     Screen.Cursor:=-11;
     MainForm.ActualFaxPort:=GammaChannelsListBox.Items[GammaChannelsListBox.ItemIndex];
     errorOpenPort:=MainForm.FAX1.OpenPort(MainForm.ActualFaxPort);
     if errorOPenPort<>0 then
        begin
//              MessageDlg('Unable to open GammaChannel:'+MainForm.ActualFaxPort+' Error code:'+IntToStr(errorOpenPort),mtWarning,[mbOK],0)
                  MessageDlg(MainForm.Errors(errorOpenPort),mtWarning,[mbOK],0);
                  Screen.Cursor:=-2;
                  Exit;
        end
     else
     begin
//     MainForm.FAX1.SetSpeakerMode(MainForm.ActualFaxPort,FaxConfigDlg.SpeakerModeRadioGroup.ItemIndex,FaxConfigDlg.SpeakerVolumeRadioGroup.ItemIndex);
        MainForm.EventListBox.Items.Add(GammaChannelsListBox.Items[GammaChannelsListBox.ItemIndex] + ' was opened');

        if HeaderCheckBox.Checked then
            MainForm.FAX1.Header := True
        else
            MainForm.FAX1.Header := False;

        MainForm.FAX1.SetPortCapability(MainForm.ActualFaxPort, PC_MAX_BAUD_SEND, MainForm.BaudRate);

     end;

     if (Length(MainForm.FAX1.GammaChannelsOpen)>0) then
     begin
        MainForm.Close1.Enabled:=True;
        MainForm.ShowFaxManager1.Enabled:=True;
        MainForm.Send1.Enabled:=True;
     end;
     Close;

    if Length(MainForm.FAX1.AvailableGammaChannels) > 0 then
        MainForm.Gammalinkchannel1.Enabled := True
    else
        MainForm.Gammalinkchannel1.Enabled := False;

     Screen.Cursor:=-2;

end;

end.
