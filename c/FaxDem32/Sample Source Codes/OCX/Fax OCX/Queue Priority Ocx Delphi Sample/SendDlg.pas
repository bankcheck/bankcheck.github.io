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
   loops, actPage: integer;
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
     else begin
        MessageDlg('You must specify a TIFF file!',mtWarning,[mbOK],0);
        FileToSendEdit.SetFocus;
        exit;
     end;

     for loops:=1 to 10 do
       begin
         if loops=1 then
                actPage:=NrOfPages
         else begin
                Randomize;
                repeat
                actPage:=random(NrOfPages);
                until actPage<>0;
         end;

         FaxID := MainForm.FAX1.CreateFaxObject(1, 1, 3, 2, 1, 2, 2, 3, 2, 1);

         if FaxID = 0 then
         begin
            MessageDlg('Can not create fax Object! Error code : '+IntToStr(MainForm.FAX1.FaxError),
                                  mtWarning,[mbOK],0);
         end
         else
         begin
                 MainForm.FAX1.SetFaxParam(FaxID,FP_SEND,1);
                 MainForm.FAX1.SetFaxParam(FaxID,FP_PRIORITY,actPage);
                 MainForm.FAX1.SetPhoneNumber(FaxID,PhoneNrEdit.Text);
                 MainForm.EventListBox.Items.Add('Setup page ' + IntToStr(actPage) + ' for sending ' + MainForm.FAX1.PageFileName);
                 if MainForm.FAX1.SetFaxPage(FaxID,1,PAGE_FILE_TIFF_G31D,actPage) > 0 then
                        begin
                            MessageDlg('Can not set fax page ! Error code : '+IntToStr(MainForm.FAX1.FaxError),
                                  mtError,[mbOK],0);
                            SetFaxPageError := 1;
                            break;
                        end;
                 if SetFaxPageError=0 then
                 begin
                      SendFaxError:= MainForm.FAX1.SendFaxObj(FaxID);
                      if SendFaxError<>0 then
                        begin
                             MainForm.FAX1.ClearFaxObject(FaxID);
                             MessageDlg('Error sending fax ! Error code : '+IntToStr(SendFaxError),mtWarning,[mbOK],0);
                        end
                      else
                        MainForm.EventListBox.Items.Add(MainForm.ActualFaxPort + ': Fax has been sent to queue');

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
     FileToSendEdit.Text := 'Testqueue.tif';
     PortListBox.ItemIndex:=0;
end;

end.
