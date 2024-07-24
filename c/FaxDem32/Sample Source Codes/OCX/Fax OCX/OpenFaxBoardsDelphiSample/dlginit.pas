unit dlginit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TDialogic = class(TForm)
    GammaLinkChannelsGroupBox: TGroupBox;
    DialogicChannelsListBox: TListBox;
    OKButton: TButton;
    CancelButton: TButton;
    procedure OnShowDlgcInit(Sender: TObject);
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

uses Main;

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
end;

procedure TDialogic.CancleClicked(Sender: TObject);
begin
     Close;
end;

procedure TDialogic.OnOK(Sender: TObject);
var errorOpenPort:integer;
begin
     Screen.Cursor:=-11;
     errorOpenPort:=MainForm.FAX1.OpenPort(DialogicChannelsListBox.Items[DialogicChannelsListBox.ItemIndex]);
     if errorOPenPort<>0 then
        begin
                  MessageDlg(MainForm.Errors(errorOpenPort),mtWarning,[mbOK],0);
                  Screen.Cursor:=-2;
                  Exit;
        end
     else
     begin
        MainForm.EventListBox.Items.Add(DialogicChannelsListBox.Items[DialogicChannelsListBox.ItemIndex] + ' was opened');
     end;

     if (Length(MainForm.FAX1.DialogicChannelsOpen)>0) then
     begin
        MainForm.Close1.Enabled:=True;
     end;

     if Length(MainForm.FAX1.AvailableDialogicChannels) > 0 then
        MainForm.Dialogicchannel1.Enabled := True
    else
        MainForm.Dialogicchannel1.Enabled := False;
     Screen.Cursor:=-2;
     Close;
end;

end.
