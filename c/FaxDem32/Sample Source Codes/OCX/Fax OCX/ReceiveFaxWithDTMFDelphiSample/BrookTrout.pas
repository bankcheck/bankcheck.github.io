unit BrookTrout;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TBrooktroutInit = class(TForm)
    GammaLinkChannelsGroupBox: TGroupBox;
    BrooktroutChannelsListBox: TListBox;
    OKButton: TButton;
    CancelButton: TButton;
    OpenDialog: TOpenDialog;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    ConfigFileEdit: TEdit;
    BrowseButton: TButton;
    Label1: TLabel;
    DTMFBrook: TEdit;
    procedure ShowBrooktroutInit(Sender: TObject);
    procedure ConfigFileEditChange(Sender: TObject);
    procedure BrowseButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure DTMFBrookKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BrooktroutInit: TBrooktroutInit;

implementation

uses Main;

{$R *.DFM}

procedure TBrooktroutInit.ShowBrooktroutInit(Sender: TObject);
var
   BrooktroutChannels,temp:string;
   index:byte;
begin
     BrooktroutChannelsListBox.Clear;
     BrooktroutChannels:=MainForm.FAX1.AvailableBrooktroutChannels+' ';
     index:=Pos(' ',BrooktroutChannels);
     while index<>0 do
     begin
          temp:=copy(BrooktroutChannels,1,index-1);
          BrooktroutChannelsListBox.Items.Add(temp);
          delete(BrooktroutChannels,1,index);
          index:=Pos(' ',BrooktroutChannels);
     end;
     ConfigFileEdit.Text:=MainForm.FAX1.BrooktroutCFile;
     BrooktroutChannelsListBox.ItemIndex:=0;
end;

procedure TBrooktroutInit.ConfigFileEditChange(Sender: TObject);
begin
     MainForm.FAX1.BrooktroutCFile:=ConfigFileEdit.Text;
end;

procedure TBrooktroutInit.BrowseButtonClick(Sender: TObject);
begin
     OpenDialog.Filter := 'Config files (*.cfg)|*.cfg|All files (*.*)|*.*';
     if OpenDialog.Execute then
          ConfigFileEdit.Text:=OpenDialog.FileName;
end;

procedure TBrooktroutInit.CancelButtonClick(Sender: TObject);
begin
     close;
end;

procedure TBrooktroutInit.OKButtonClick(Sender: TObject);
var errorOpenPort:integer;
begin
     Screen.Cursor:=-11;
     if Length(DTMFBrook.Text)=0 then
        begin
             MessageDlg('You must specify the number of the DTMF digits!',mtWarning,[mbOK],0);
             Screen.Cursor:=-2;
             Exit;
        end;
     errorOpenPort:=MainForm.FAX1.OpenPort(BrooktroutChannelsListBox.Items[BrooktroutChannelsListBox.ItemIndex]);
     if errorOPenPort<>0 then
      begin
                  MessageDlg(MainForm.Errors(errorOpenPort),mtWarning,[mbOK],0);
                  Screen.Cursor:=-2;
                  Exit;
        end
     else
     begin
        MainForm.FAX1.RecvDTMF(BrooktroutChannelsListBox.Items[BrooktroutChannelsListBox.ItemIndex], StrToInt(DTMFBrook.Text), 20);
        MainForm.EventListBox.Items.Add(BrooktroutChannelsListBox.Items[BrooktroutChannelsListBox.ItemIndex] + ' was opened');
        MainForm.FAX1.SetPortCapability(BrooktroutChannelsListBox.Items[BrooktroutChannelsListBox.ItemIndex], PC_MAX_BAUD_SEND, BR_33600);
      end;

     if Length(MainForm.FAX1.BrooktroutChannelsOpen)>0 then
     begin
        MainForm.Close1.Enabled:=True;
     end;

     if Length(MainForm.FAX1.AvailableBrooktroutChannels) > 0 then
        MainForm.BrooktroutChannel1.Enabled := True
    else
        MainForm.BrooktroutChannel1.Enabled := False;
     Screen.Cursor:=-2;
     Close;
end;

procedure TBrooktroutInit.DTMFBrookKeyPress(Sender: TObject;
  var Key: Char);
begin
        if (((System.Ord(Key)<48) or (System.Ord(Key)>57))) then
                Key:=System.Chr(0);
end;
end.
