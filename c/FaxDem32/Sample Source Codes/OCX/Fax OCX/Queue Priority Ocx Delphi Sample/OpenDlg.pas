unit OpenDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Main;

type
  TCommPortInit = class(TForm)
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ClassTypeLabel: TLabel;
    ManufacturerLabel: TLabel;
    ModelLabel: TLabel;
    TestModemButton: TButton;
    OK: TButton;
    Button2: TButton;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    COMPortListBox: TListBox;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    ResetStrTextBox: TEdit;
    SetupStrTextBox: TEdit;
    TestDialtoneButton: TButton;
    FaxTypeCombo: TComboBox;
    GroupBox1: TGroupBox;
    GroupBox4: TGroupBox;
    ChkDebug: TCheckBox;
    Label9: TLabel;
    LocalIDEdit: TEdit;
    NrAnswerRingsEdit: TEdit;
    HeaderCreateCheckBox: TCheckBox;
    procedure ShowInitCOMPort(Sender: TObject);
    procedure TestModemButtonClick(Sender: TObject);
    procedure LocalIDEditChange(Sender: TObject);
    procedure ChangeNrAnswerRingsEdit(Sender: TObject);
    procedure ClickCreateHeader(Sender: TObject);
    procedure ClickOK(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FaxTypeComboChange(Sender: TObject);
    procedure TestDialtoneButtonClick(Sender: TObject);
    procedure NrAnswerRingsEditKeyPress(Sender: TObject; var Key: Char);
  private

    { Private declarations }
  public

    { Public declarations }
  end;

var
  CommPortInit: TCommPortInit;
  rings:string;

implementation

uses  FaxDlg;

{$R *.DFM}
        
procedure TCommPortInit.ShowInitCOMPort(Sender: TObject);
var
   COMPorts,temp:string;
   index:byte;
   sel,First,wasThere1:boolean;
   wasThere2:byte;
   szFax,IniFileName,szReset:string;
   szFaxName,szFaxName1:string;
   nFaxes,LocalFax,headerInt,i:integer;
begin

     HeaderCreateCheckBox.Checked:=MainForm.FAX1.Header;
     ChkDebug.Checked:=MainForm.EnableDebug;

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
     ClassTypeLabel.Caption:='';
     ManufacturerLabel.Caption:='';
     ModelLabel.Caption:='';

    wasThere1 := False;
    wasThere2 := 0;
    First := True;
    LocalFax := 0;
    IniFileName := 'faxcpp1.ini';
    nFaxes := 1;
    FaxTypeCombo.Clear;
    While nFaxes <> -1 do
        begin
            inc(LocalFax);
            szFax := 'Fax' + IntToStr(LocalFax);
            SetLength(szFaxName,255);
            If (GetPrivateProfileString('Faxes', PChar(szFax), '', PChar(szFaxName),250, PChar(IniFileName)) = 0) Then
              begin
                wasThere1 := False;
                If (First = False) Then
                   begin
                    nFaxes := -1;
                    wasThere1 := True;
                   end
                Else
                  begin
                    First := False;
                    wasThere1 := True;
                  end;
              end
            Else wasThere1 := False;
            If (wasThere1 = False) Then
              begin
                SetLength(szFaxName1,255);
                if (GetPrivateProfileString(PChar(szFaxName), 'Long Name','', PChar(szFaxName1), 250, PChar(IniFileName))=0) then
                begin
                  wasThere2:= 0;
                     If (First = False) Then
                      begin
                        nFaxes:= -1;
                        wasThere2:=1;
                      end
                    Else
                       begin
                         First:=False;
                         wasThere2:=1;
                       end;
                end
                else   wasThere2:=0;

              end;
            If ((wasThere1 = False) And (wasThere2=0) And (nFaxes <> -1)) Then
              begin
                FaxTypeCombo.Items.Add(szFaxName1);
                nFaxes := nFaxes + 1;
              end;
        end;
     FaxTypeCombo.ItemIndex:=GetProfileInt('Fax', 'Selected', 1) - 1;
     FaxTypeComboChange(Sender);
     LocalIDEdit.Text:=MainForm.Fax1.LocalID;
     NrAnswerRingsEdit.Text:=IntToStr(MainForm.Fax1.Rings);


end;

procedure TCommPortInit.TestModemButtonClick(Sender: TObject);
var
   FaxType, TypeString, FaxClass:string;
   i: Integer;
begin
if COMPortListBox.ItemIndex<>-1 then
begin
     Screen.Cursor:=-11;
     MainForm.Fax1.TestModem(COMPortListBox.Items[COMPortListBox.ItemIndex]);
     Screen.Cursor:=-2;
     FaxType:=MainForm.Fax1.ClassType;
     if Length(FaxType)>0 then
     begin
        i:=1;
        while  i <= Length(FaxType) do
        begin
            if not (FaxType[i]= ',') then
                FaxClass:= FaxClass + FaxType[i];
            if  (i = Length(FaxType)) or (FaxType[i]= ',') then
            begin

                if FaxClass='0' then
                begin
                   if Length(TypeString)>0 then
                        TypeString:=TypeString+', Data'
                   else
                        TypeString:=TypeString+'Data';
                end
                else if FaxClass='1' then
                begin
                   if Length(TypeString)>0 then
                        TypeString:=TypeString+', Fax Class 1'
                   else
                        TypeString:=TypeString+'Fax Class 1';
                end
                else if FaxClass='1.0'then
                begin
                   if Length(TypeString)>0 then
                        TypeString:=TypeString+', Fax Class 1.0'
                   else
                        TypeString:=TypeString+'Fax Class 1.0';
                end
                else if FaxClass='2' then
                begin
                   if Length(TypeString)>0 then
                        TypeString:=TypeString+', Fax Class 2'
                   else
                        TypeString:=TypeString+'Fax Class 2';
                end
                else if FaxClass='2.0' then
                begin
                   if Length(TypeString)>0 then
                        TypeString:=TypeString+', Fax Class 2.0'
                   else
                        TypeString:=TypeString+'Fax Class 2.0';
                end
                else if FaxClass='2.1' then
                begin
                   if Length(TypeString)>0 then
                        TypeString:=TypeString+', Fax Class 2.1'
                   else
                        TypeString:=TypeString+'Fax Class 2.1';
                end

                else if FaxClass='8' then
                begin
                   if Length(TypeString)>0 then
                        TypeString:=TypeString+', Class 8'
                   else
                        TypeString:=TypeString+'Class 8';
                end
                else if FaxClass='80' then
                begin
                   if Length(TypeString)>0 then
                        TypeString:=TypeString+', Class 80'
                   else
                        TypeString:=TypeString+'Class 80';
                end
                else if Length(FaxClass)>0 then
                begin
                      if (Length(TypeString)>0) then
                         TypeString:=TypeString+', Class ' + FaxClass
                      else
                         TypeString:=TypeString+'Class ' + FaxClass;
                end;
                FaxClass:='';
            end;

           Inc(i);
        end;
     end;

     if Length(TypeString)=0 then
          ClassTypeLabel.Caption:='No modem on '+COMPortListBox.Items[COMPortListBox.ItemIndex]
     else
          ClassTypeLabel.Caption:=TypeString;
     ManufacturerLabel.Caption:=MainForm.Fax1.Manufacturer;
     ModelLabel.Caption:=MainForm.Fax1.Model;
end;


end;

procedure TCommPortInit.LocalIDEditChange(Sender: TObject);
begin
     MainForm.Fax1.LocalID:=LocalIDEdit.Text+' ';
end;

procedure TCommPortInit.ChangeNrAnswerRingsEdit(Sender: TObject);
var phtext:string;
begin
        phtext:=NrAnswerRingsEdit.Text;
        if (Length(phtext)>0) then
	        if ((System.Ord(phtext[1])<48) or (System.Ord(phtext[1]) > 57)) then
                   begin
        		if (rings<>null) then NrAnswerRingsEdit.Text:=rings;
			NrAnswerRingsEdit.SelectAll();
                   end;
     MainForm.Fax1.Rings:=StrToIntDef(NrAnswerRingsEdit.Text,1);
end;

procedure TCommPortInit.ClickCreateHeader(Sender: TObject);
begin
      MainForm.FAX1.Header:=HeaderCreateCheckBox.Checked;
end;

procedure TCommPortInit.ClickOK(Sender: TObject);
var errorOpenport:integer;
    IniFileName,szFaxName,szFaxName1:string;
    nFax,SelectedFax,head:Integer;
begin
     head:=0;
     Screen.Cursor:=-11;
     if (length(NrAnswerRingsEdit.Text)=0) then
           begin
                MessageDlg('You must specify the number of rings.',mtWarning,[mbOK],0);
                NrAnswerRingsEdit.SetFocus;
                Screen.Cursor:=-2;
                exit;
           end;

     MainForm.FAX1.SetSetupString(SetupStrTextBox.Text, FaxTypeCombo.ItemIndex + 1);
     MainForm.FAX1.SetResetString(ResetStrTextBox.Text, FaxTypeCombo.ItemIndex + 1);

     If (HeaderCreateCheckBox.Checked = False) Then
       begin
        MainForm.FAX1.Header := False;
        head:=0;
       end
     Else
      begin
        head:=1;
        MainForm.FAX1.Header:=True;
        MainForm.FAX1.HeaderHeight := 25;
        MainForm.FAX1.HeaderFaceName := 'Arial';
        MainForm.FAX1.HeaderFontSize := 10;
      end;

     if ChkDebug.Checked then
        MainForm.EnableDebug := true
     else
        MainForm.EnableDebug := false;


    IniFileName := 'faxcpp1.ini';
    //Get fax name.
    nFax := FaxTypeCombo.ItemIndex + 1;
    szFaxName := 'Fax' + IntToStr(nFax);
    SetLength(szFaxName1,255);
    GetPrivateProfileString('Faxes', PChar(szFaxName), '', PChar(szFaxName1), 250, PChar(IniFileName));
    SelectedFax := nFax;
    WriteProfileString('Fax', 'Selected', PChar(IntToStr(SelectedFax)));
    MainForm.FAX1.LocalID := LocalIDEdit.Text;
    MainForm.FAX1.Rings := StrToInt(NrAnswerRingsEdit.Text);
    WriteProfileString('Fax', 'Header', PChar(IntToStr(head)));
    MainForm.FAX1.FaxType := szFaxName1;
    MainForm.FAX1.TestModem(COMPortListBox.Items[COMPortListBox.ItemIndex]);
    if (Length(MainForm.FAX1.ClassType)<>0) then
     begin
        If (MainForm.FAX1.FaxType = 'GCLASS1(SFC)') And ((Pos('1',MainForm.FAX1.ClassType) = 0) Or (Pos('1.0',MainForm.FAX1.ClassType) = Pos('1',MainForm.FAX1.ClassType))) Then
          begin
            ShowMessage('The selected modem does not support Class 1');
            Screen.Cursor:=-2;
             exit;
          end
        Else If (MainForm.FAX1.FaxType = 'GCLASS1(HFC)') And ((Pos('1',MainForm.FAX1.ClassType) = 0) Or (Pos('1.0',MainForm.FAX1.ClassType) = Pos('1',MainForm.FAX1.ClassType))) Then
          begin
            ShowMessage('The selected modem does not support Class 1');
            Screen.Cursor:=-2;
            exit;
          end
        Else If (MainForm.FAX1.FaxType = 'GCLASS1.0(SFC)') And (Pos('1.0',MainForm.FAX1.ClassType) = 0) Then
          begin
            ShowMessage('The selected modem does not support Class 1.0');
            Screen.Cursor:=-2;
            exit;
          end
        Else If (MainForm.FAX1.FaxType = 'GCLASS1.0(HFC)') And (Pos('1.0',MainForm.FAX1.ClassType) = 0) Then
          begin
            ShowMessage( 'The selected modem does not support Class 1.0');
            Screen.Cursor:=-2;
             exit;
          end
        Else If ((MainForm.FAX1.FaxType = 'GCLASS2S/RF/') Or (MainForm.FAX1.FaxType = 'GCLASS2R')) And ((Pos('2',MainForm.FAX1.ClassType) = 0) Or (Pos('2.0',MainForm.FAX1.ClassType) = Pos('2',MainForm.FAX1.ClassType))) Then
          begin
            ShowMessage( 'The selected modem does not support Class 2');
            Screen.Cursor:=-2;
             exit;
          end
        Else If ((MainForm.FAX1.FaxType = 'GCLASS2.0') Or (MainForm.FAX1.FaxType = 'GCLASS2.0 MULTITECH')) And (Pos('2.0',MainForm.FAX1.ClassType) = 0) Then
          begin
            ShowMessage( 'The selected modem does not support Class 2.0');
            Screen.Cursor:=-2;
            exit;
          end
        Else If ((MainForm.FAX1.FaxType = 'GH14.4F(HFC)') Or (MainForm.FAX1.FaxType = 'GU.S.R14.4F(HFC)')) And ((Pos('1',MainForm.FAX1.ClassType) = 0) Or (Pos('1.0',MainForm.FAX1.ClassType) = Pos('1',MainForm.FAX1.ClassType))) Then
            begin
            ShowMessage( 'The selected modem does not support Class 1');
            Screen.Cursor:=-2;
            exit;
            end;

         MainForm.ActualFaxPort:=COMPortListBox.Items[COMPortListBox.ItemIndex];
         MainForm.FAX1.SpeakerVolume:=MainForm.SpeakerVolume;
         MainForm.FAX1.SpeakerMode:=MainForm.SpeakerMode;
         Sleep(2000);
         errorOpenPort:=MainForm.FAX1.OpenPort(MainForm.ActualFaxPort);
         if errorOPenPort<>0 then
                  MessageDlg(MainForm.Errors(errorOpenPort),mtWarning,[mbOK],0)
         else
           begin
             MainForm.Close1.Enabled:=True;
             MainForm.Send1.Enabled:=True;
             MainForm.ShowFaxManager1.Enabled:=True;
             MainForm.EventListBox.Items.Add(COMPortListBox.Items.Strings[COMPortListBox.ItemIndex] + ' was opened');
           end;
         MainForm.FAX1.SetSpeakerMode(MainForm.ActualFaxPort,MainForm.SpeakerMode,MainForm.SpeakerVolume);
         MainForm.FAX1.SetPortCapability(MainForm.ActualFaxPort,PC_ECM,MainForm.EnableECM);
         MainForm.FAX1.SetPortCapability(MainForm.ActualFaxPort,PC_BINARY,MainForm.EnableBFT);
         MainForm.FAX1.SetPortCapability(MainForm.ActualFaxPort,PC_MAX_BAUD_SEND,MainForm.BaudRate);
         MainForm.FAX1.EnableLog(MainForm.ActualFaxPort, MainForm.EnableDebug);
         MainForm.FAX1.HeaderHeight:=25;
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

procedure TCommPortInit.FaxTypeComboChange(Sender: TObject);
begin
        ResetStrTextBox.Text := MainForm.FAX1.GetResetString(FaxTypeCombo.ItemIndex + 1);
        SetupStrTextBox.Text := MainForm.FAX1.GetSetupString(FaxTypeCombo.ItemIndex + 1);
end;

procedure TCommPortInit.TestDialtoneButtonClick(Sender: TObject);
var szPortName:String;
    iError,i:Integer;

begin

        szPortName := COMPortListBox.Items[COMPortListBox.ItemIndex];
        Screen.Cursor:=-11;
        iError := MainForm.FAX1.DetectDialTone(szPortName);
        Screen.Cursor:=-2;
        If (1 = iError) Then
            ShowMessage('Dialtone Detected.')
        Else If (0 = iError) Then
            ShowMessage('No Dialtone!')
        Else If (-1 = iError) Then
            ShowMessage('No Modem on COM Port!');

end;
procedure TCommPortInit.NrAnswerRingsEditKeyPress(Sender: TObject;
  var Key: Char);
begin
    rings:=NrAnswerRingsEdit.Text;
end;

end.
