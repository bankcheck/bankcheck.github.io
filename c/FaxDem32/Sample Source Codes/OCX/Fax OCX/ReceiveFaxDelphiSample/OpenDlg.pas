unit OpenDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Main;

type
  TCommPortInit = class(TForm)
    OK: TButton;
    Button2: TButton;
    COMPortListBox: TListBox;
    procedure ShowInitCOMPort(Sender: TObject);
    procedure ClickOK(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private

    { Private declarations }
  public

    { Public declarations }
  end;

var
  CommPortInit: TCommPortInit;
  rings:string;

implementation

{$R *.DFM}

procedure TCommPortInit.ShowInitCOMPort(Sender: TObject);
var
   COMPorts,temp:string;
   index:byte;
begin
     COMPortListBox.Clear;
     COMPorts:=MainForm.FAX1.AvailablePorts+' ';
     index:=Pos(' ',COMPorts);
     while index<>0 do
     begin
          temp:=copy(COMPorts,1,index-1);
          COMPortListBox.Items.Add(temp);
          delete(COMPorts,1,index);
          index:=Pos(' ',COMPorts);
     end;
     COMPortListBox.ItemIndex:=0;
end;

procedure TCommPortInit.ClickOK(Sender: TObject);
var errorOpenport:integer;
begin
     Screen.Cursor:=-11;
    MainForm.FAX1.FaxType := 'GCLASS1(SFC)';
    MainForm.FAX1.TestModem(COMPortListBox.Items[COMPortListBox.ItemIndex]);
    if (Length(MainForm.FAX1.ClassType)<>0) then
     begin
         errorOpenPort:=MainForm.FAX1.OpenPort(COMPortListBox.Items[COMPortListBox.ItemIndex]);
         if errorOPenPort<>0 then
                  MessageDlg(MainForm.Errors(errorOpenPort),mtWarning,[mbOK],0)
         else
           begin
             MainForm.Close1.Enabled:=True;
             MainForm.EventListBox.Items.Add(COMPortListBox.Items.Strings[COMPortListBox.ItemIndex] + ' was opened');
             MainForm.FAX1.SetPortCapability(COMPortListBox.Items[COMPortListBox.ItemIndex],PC_ECM,EC_ENABLE);
             MainForm.FAX1.SetPortCapability(COMPortListBox.Items[COMPortListBox.ItemIndex],PC_MAX_BAUD_SEND,BR_33600);
           end;
     end
     else
         begin
         MessageDlg('No Modem on '+COMPortListBox.Items[COMPortListBox.ItemIndex]+' port!',
                    mtWarning,[mbOK],0);
         Screen.Cursor:=-2;
         Exit;
         end;
     if (Length(MainForm.Fax1.AvailablePorts)>0) then
          MainForm.Comm1.Enabled:=True
     else
          MainForm.Comm1.Enabled:=False;
     Screen.Cursor:=-2;

     Close;
end;

procedure TCommPortInit.Button2Click(Sender: TObject);
begin
        Close;
end;
end.
