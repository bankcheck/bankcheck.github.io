unit SendDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls;

type
  TSendFax = class(TForm)
    Label1: TLabel;
    PhoneNrEdit: TEdit;
    Label2: TLabel;
    FileToSendEdit: TEdit;
    BrowseButton: TButton;
    OKButton: TButton;
    CancelButton: TButton;
    OpenDialog1: TOpenDialog;
    Label3: TLabel;
    PortListBox: TListBox;
    GroupBox1: TGroupBox;
    QueueButton: TRadioButton;
    ImmediateButton: TRadioButton;
    procedure ClickBrowseButton(Sender: TObject);
    procedure ClickOK(Sender: TObject);
    procedure ClickCancel(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SendFax: TSendFax;

implementation

uses Main;

{$R *.DFM}

procedure TSendFax.ClickBrowseButton(Sender: TObject);
begin
     if OpenDialog1.Execute then
          FileToSendEdit.Text:=OpenDialog1.FileName;
end;

procedure TSendFax.ClickOK(Sender: TObject);
var
   FaxID,SendFaxError,SetFaxPageError:longint;
   NrOfPages,i:shortint;
   Extension:string[3];
   notNumber:boolean;
   PhoneNum:string;
begin

        notNumber:=False;
        PhoneNum:=PhoneNrEdit.Text;
        i:=0;
        While((i<Length(PhoneNum)) and (notNumber=False)) do
                begin
                       if (((System.Ord(PhoneNum[i+1])<48) or (System.Ord(PhoneNum[i+1])>57)) and (System.Ord(PhoneNum[i+1])<>44)) then
                       notNumber:=True;
                       i:=i+1;
                end;
        if ((length(PhoneNum)=0) or (notNumber=True)) then
           begin
                if (notNumber=True) then
                        MessageDlg('The given phone number is incorrect.',mtWarning,[mbOK],0)
                else MessageDlg('You must specify the phone number.',mtWarning,[mbOK],0);
                PhoneNrEdit.SetFocus;
                exit;
           end;

        if (FileExists(FileToSendEdit.Text)=False) Then
          begin
            MessageDlg('You must specify an existing file to send.',mtWarning,[mbOK],0);
            FileToSendEdit.SetFocus;
            exit;
          end;

     SetFaxPageError:=0;
     MainForm.FAX1.PageFileName:=FileToSendEdit.Text;
     Extension:=copy(MainForm.FAX1.PageFileName,Length(MAinForm.FAX1.PageFileName)-2,3);

     if UpperCase(Extension)='TIF' then
         NrOfPages:=MainForm.FAX1.GetNumberOfImages(Mainform.FAX1.PageFileName,PAGE_FILE_TIFF_G31D)
     else
        begin
            MessageDlg('You must specify a TIFF file!',mtWarning,[mbOK],0);
            FileToSendEdit.SetFocus;
            exit;
        end;

     if NrOfPages > 0 then
     begin
         FaxID := MainForm.FAX1.CreateFaxObject(1, NrOfPages, 3, 2, 1, 2, 2, 1, 2, 1);
         if FaxID = 0 then
         begin
            MessageDlg('Can not create fax Object! Error code : '+IntToStr(MainForm.FAX1.FaxError),
                                  mtWarning,[mbOK],0);
         end
         else
         begin
                 MainForm.FAX1.SetFaxParam(FaxID,FP_SEND,NrOfPages);
                 MainForm.FAX1.SetPhoneNumber(FaxID,PhoneNrEdit.Text);
                 for i:=1 to NrOfPages do
                 begin
                        if MainForm.FAX1.SetFaxPage(FaxID,i,PAGE_FILE_UNKNOWN,i) > 0 then
                        begin
                            MessageDlg('Can not set fax page ! Error code : '+IntToStr(MainForm.FAX1.FaxError),
                                  mtError,[mbOK],0);
                            SetFaxPageError := 1;
                        end;
                 end;
                 if SetFaxPageError=0 then
                 begin
                      SendFaxError:=0;
                      If ImmediateButton.Checked = True Then
                        SendFaxError:= MainForm.FAX1.SendNow(PortListBox.Items[PortListBox.ItemIndex], FaxID)
                      Else If QueueButton.Checked = True Then
                        SendFaxError:= MainForm.FAX1.SendFaxObj(FaxID);
                      if SendFaxError<>0 then
                        begin
                             MainForm.FAX1.ClearFaxObject(FaxID);
                             MessageDlg('Error sending fax ! Error code : '+IntToStr(SendFaxError),mtWarning,[mbOK],0);
                        end;

                 end;
         end;
     end;
Close;

end;

procedure TSendFax.ClickCancel(Sender: TObject);
begin
     Close;
end;

procedure TSendFax.FormShow(Sender: TObject);
var
   OpenPorts,temp:string;
   index:integer;
begin
     PortListBox.Clear;
     OpenPorts:=MainForm.FAX1.PortsOpen+' ';
     index:=Pos(' ',OpenPorts);
     while index<>0 do
     begin
      if index>1 then
     begin
          temp:=copy(OpenPorts,1,index-1);
          PortListBox.Items.Add(temp);
     end;
          delete(OpenPorts,1,index);
          index:=Pos(' ',OpenPorts);
     end;
     FileToSendEdit.Text := 'Test.tif';
     PortListBox.ItemIndex:=0;
     PhoneNrEdit.SetFocus;
end;
end.
