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
    Label3: TLabel;
    ConfigFileEdit: TEdit;
    BrowseButton: TButton;
    LocalIDEdit: TEdit;
    DTMFCheckBox: TCheckBox;
    HeaderCheckBox: TCheckBox;
    procedure ShowBrooktroutInit(Sender: TObject);
    procedure HeaderCheckBoxClick(Sender: TObject);
    procedure LocalIDEditChange(Sender: TObject);
    procedure ConfigFileEditChange(Sender: TObject);
    procedure BrowseButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BrooktroutInit: TBrooktroutInit;

implementation

uses Main, FaxDlg;

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
     BrooktroutChannelsListBox.ItemIndex:=0;
     LocalIDEdit.Text:=MainForm.Fax1.LocalID;
     ConfigFileEdit.Text:=MainForm.FAX1.BrooktroutCFile;
     HeaderCheckBox.Checked:=MainForm.FAX1.Header;
end;

procedure TBrooktroutInit.HeaderCheckBoxClick(Sender: TObject);
begin
    MainForm.FAX1.Header:=HeaderCheckBox.Checked;
end;

procedure TBrooktroutInit.LocalIDEditChange(Sender: TObject);
begin
     MainForm.Fax1.LocalID:=LocalIDEdit.Text;
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
     MainForm.ActualFaxPort:=BrooktroutChannelsListBox.Items[BrooktroutChannelsListBox.ItemIndex];
     errorOpenPort:=MainForm.FAX1.OpenPort(MainForm.ActualFaxPort);
     if errorOPenPort<>0 then
      begin
//              MessageDlg('Unable to open BrooktroutChannel:'+MainForm.ActualFaxPort+' Error code:'+IntToStr(errorOpenPort),mtWarning,[mbOK],0)
                  MessageDlg(MainForm.Errors(errorOpenPort),mtWarning,[mbOK],0);
                  Screen.Cursor:=-2;
                  Exit;
        end
     else
     begin
        MainForm.FAX1.SetSpeakerMode(MainForm.ActualFaxPort,MainForm.SpeakerMode,MainForm.SpeakerVolume);

        if DTMFCheckBox.Checked then
            MainForm.FAX1.RecvDTMF(BrooktroutChannelsListBox.Items[BrooktroutChannelsListBox.ItemIndex], 5, 20);
        MainForm.EventListBox.Items.Add(BrooktroutChannelsListBox.Items[BrooktroutChannelsListBox.ItemIndex] + ' was opened');
        if HeaderCheckBox.Checked then
            MainForm.FAX1.Header := True
        else
            MainForm.FAX1.Header := False;

        MainForm.FAX1.SetPortCapability(MainForm.ActualFaxPort, PC_MAX_BAUD_SEND, MainForm.BaudRate);
      end;

     if Length(MainForm.FAX1.BrooktroutChannelsOpen)>0 then
     begin
        MainForm.Close1.Enabled:=True;
        MainForm.ShowFaxManager1.Enabled:=True;
        MainForm.Send1.Enabled:=True;
     end;

     if Length(MainForm.FAX1.AvailableBrooktroutChannels) > 0 then
        MainForm.BrooktroutChannel1.Enabled := True
    else
        MainForm.BrooktroutChannel1.Enabled := False;
     Screen.Cursor:=-2;
     Close;



end;

end.
