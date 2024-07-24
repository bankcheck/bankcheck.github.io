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
    GroupBox2: TGroupBox;
    NoCompressionButton: TRadioButton;
    Group31DButton: TRadioButton;
    ColorFaxButton: TRadioButton;
    Group32DButton: TRadioButton;
    Group4Button: TRadioButton;
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
   FileType,NrOfPages,i,compression:shortint;
   ftype,colorfax:byte;
   Extension:string[3];
   notNumber:boolean;
   PhoneNum,checkFile:string;
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
     MainForm.FAX1.FaxFileName:=FileToSendEdit.Text;
     MainForm.FAX1.PageFileName:=FileToSendEdit.Text;
     Extension:=copy(MainForm.FAX1.PageFileName,Length(MAinForm.FAX1.PageFileName)-2,3);

     if UpperCase(Extension)='TIF' then
         NrOfPages:=MainForm.FAX1.GetNumberOfImages(Mainform.FAX1.PageFileName,PAGE_FILE_TIFF_G31D)
     else NrOfPages:=1;

    If NoCompressionButton.Checked = True Then
            compression := 4
        Else if Group31DButton.Checked = True Or ColorFaxButton.Checked = True Then
            compression := 2
        Else If Group32DButton.Checked = True Then
            compression := 3
        Else If Group4Button.Checked = True Then
            compression := 5
        Else compression := 2;

     If ColorFaxButton.Checked = True Then
       begin
        ftype := 2;
        colorfax := 3;
        If MainForm.EnableBFT = 3 Then
           MainForm.EnableBFT := 2;
       end
     Else
       begin
        colorfax := 2;
        If MainForm.EnableBFT = 3 Then
            ftype := 2
        Else ftype := 1
       end;


     if NrOfPages > 0 then
     begin
         FaxID := MainForm.FAX1.CreateFaxObject(ftype, NrOfPages, 3, 2, 1, compression, MainForm.EnableBFT, MainForm.EnableECM, 2, 1);

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
     OpenPorts:=MainForm.FAX1.PortsOpen+' '+MainForm.FAX1.GammaChannelsOpen+' '+MainForm.FAX1.BrooktroutChannelsOpen+' '+MainForm.FAX1.DialogicChannelsOpen+' '+MainForm.FAX1.CmtrxChannelsOpen+' '+MainForm.FAX1.NMSChannelsOpen+' ';
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
end;

end.
