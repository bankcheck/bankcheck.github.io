unit GammaInit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TGammaLinkInit = class(TForm)
    GammaLinkChannelsGroupBox: TGroupBox;
    GammaChannelsListBox: TListBox;
    Label2: TLabel;
    ConfigFileEdit: TEdit;
    BrowseButton: TButton;
    OKButton: TButton;
    CancelButton: TButton;
    OpenDialog: TOpenDialog;
    GChannelTypeLabel: TLabel;
    Label1: TLabel;
    DTMFGamma: TEdit;
    procedure ShowInitGammaLink(Sender: TObject);
    procedure OnClickBrowse(Sender: TObject);
    procedure OnConfigFileEditChange(Sender: TObject);
    procedure OnClickCancel(Sender: TObject);
    procedure OnClickOK(Sender: TObject);
    procedure DTMFGammaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GammaLinkInit: TGammaLinkInit;

implementation

uses Main;

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
     if Length(DTMFGamma.Text)=0 then
        begin
             MessageDlg('You must specify the number of the DTMF digits!',mtWarning,[mbOK],0);
             Screen.Cursor:=-2;
             Exit;
        end;
     errorOpenPort:=MainForm.FAX1.OpenPort(GammaChannelsListBox.Items[GammaChannelsListBox.ItemIndex]);
     if errorOPenPort<>0 then
        begin
                  MessageDlg(MainForm.Errors(errorOpenPort),mtWarning,[mbOK],0);
                  Screen.Cursor:=-2;
                  Exit;
        end
     else
     begin
        MainForm.FAX1.RecvDTMF(GammaChannelsListBox.Items[GammaChannelsListBox.ItemIndex], StrToInt(DTMFGamma.Text), 20);
        MainForm.EventListBox.Items.Add(GammaChannelsListBox.Items[GammaChannelsListBox.ItemIndex] + ' was opened');
        MainForm.FAX1.SetPortCapability(GammaChannelsListBox.Items[GammaChannelsListBox.ItemIndex], PC_MAX_BAUD_SEND, BR_33600);
     end;

     if (Length(MainForm.FAX1.GammaChannelsOpen)>0) then
     begin
        MainForm.Close1.Enabled:=True;
     end;
     Close;

    if Length(MainForm.FAX1.AvailableGammaChannels) > 0 then
        MainForm.Gammalinkchannel1.Enabled := True
    else
        MainForm.Gammalinkchannel1.Enabled := False;

     Screen.Cursor:=-2;

end;

procedure TGammaLinkInit.DTMFGammaKeyPress(Sender: TObject; var Key: Char);
begin
        if (((System.Ord(Key)<48) or (System.Ord(Key)>57))) then
                Key:=System.Chr(0);
end;

end.
