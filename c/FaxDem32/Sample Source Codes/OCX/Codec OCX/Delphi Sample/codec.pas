unit codec;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, OleCtrls, CODECOCXLib_TLB;

type
  TForm1 = class(TForm)
    GroupBox1: TGroupBox;
    WAV2VOC: TRadioButton;
    VOC2WAV: TRadioButton;
    WAV2IMAADPCM: TRadioButton;
    IMAADPCM2WAV: TRadioButton;
    WAV2DIALOGICADPCM: TRadioButton;
    DIALOGICADPCM2WAV: TRadioButton;
    BROWSEDEST: TButton;
    DEST: TEdit;
    GroupBox2: TGroupBox;
    SRC: TEdit;
    BROWSESRC: TButton;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    SYNC: TRadioButton;
    ASYNC: TRadioButton;
    GroupBox5: TGroupBox;
    Messages: TListBox;
    Start: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    CodecOCX1: TCodecOCX;
    PCM12PCM8: TRadioButton;
    PCM82PCM11: TRadioButton;
    procedure OnClickIMAADPCM2WAV(Sender: TObject);
    procedure OnClickWAV2VOC(Sender: TObject);
    procedure OnClickVOC2WAV(Sender: TObject);
    procedure OnClickWAV2IMAADPCM(Sender: TObject);
    procedure OnWAV2DialogicADPCM(Sender: TObject);
    procedure OnDialogicADPCM2WAV(Sender: TObject);
    procedure AddMessage(Text:String);
    procedure OnBrowseSRC(Sender: TObject);
    procedure OnBrowseDest(Sender: TObject);
    procedure OnCreate(Sender: TObject);
    procedure OnClickSync(Sender: TObject);
    procedure OnClickASYNC(Sender: TObject);
    procedure OnStart(Sender: TObject);
    procedure OnFinishConversion(Sender: TObject; ConversionID: Integer);
    procedure OnFStartConversion(Sender: TObject; ConversionID: Integer);
    procedure OnPCM112PCM8(Sender: TObject);
    procedure OnPCM82PCM11(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  format:integer;
  mode:WordBool;

implementation

{$R *.DFM}

procedure TForm1.OnClickIMAADPCM2WAV(Sender: TObject);
begin
     AddMessage('IMA ADPCM to WAV conversion has been selected.');
     format:=3;
end;

procedure TForm1.OnClickWAV2VOC(Sender: TObject);
begin
     AddMessage('WAV to VOC conversion has been selected.');
     format:=0;
end;

procedure TForm1.OnClickVOC2WAV(Sender: TObject);
begin
     AddMessage('VOC to WAV conversion has been selected.');
     format:=1;
end;

procedure TForm1.OnClickWAV2IMAADPCM(Sender: TObject);
begin
     AddMessage('WAV to IMA ADPCM conversion has been selected.');
     format:=2;
end;

procedure TForm1.OnWAV2DialogicADPCM(Sender: TObject);
begin
     AddMessage('WAV to Dialogic ADPCM conversion has been selected.');
     format:=4;
end;

procedure TForm1.OnDialogicADPCM2WAV(Sender: TObject);
begin
     AddMessage('Dialogic ADPCM to WAV conversion has been selected.');
     format:=5;
end;


procedure  TForm1.AddMessage(Text:String);
begin
     Messages.Items.Add(Text);
     Messages.Itemindex:=Messages.Items.Count-1;
end;

procedure TForm1.OnBrowseSRC(Sender: TObject);
begin
     OpenDialog1.Filter := 'All files (*.*)|*.*';
     if OpenDialog1.Execute then
         SRC.Text:=OpenDialog1.FileName;
end;

procedure TForm1.OnBrowseDest(Sender: TObject);
begin
     SaveDialog1.Filter := 'All files (*.*)|*.*';
     if SaveDialog1.Execute then
         DEST.Text:=SaveDialog1.FileName;
end;

procedure TForm1.OnCreate(Sender: TObject);
begin
     format:=0;
     mode:=true;
end;

procedure TForm1.OnClickSync(Sender: TObject);
begin
     mode:=true;
end;

procedure TForm1.OnClickASYNC(Sender: TObject);
begin
     mode:=false;
end;

procedure TForm1.OnStart(Sender: TObject);
var
   ret:integer;
begin
     if SRC.Text = '' then
     begin
        Application.MessageBox('No source file was specified','Error',MB_OK);
        exit;
     end;
     if DEST.Text = '' then
     begin
        Application.MessageBox('No destination file was specified','Error',MB_OK);
        exit;
     end;
      Case format of
        0:
        begin
            AddMessage('Converting WAV to VOC...');
            ret := CodecOCX1.ConvertWAVToVOC(SRC.Text, DEST.Text, mode);
        end;
        1:
        begin
            AddMessage('Converting VOC to WAV...');
            ret := CodecOCX1.ConvertVOCToWAV(SRC.Text, DEST.Text, mode);
        end;
        2:
        begin
            AddMessage('Converting WAV to IMA ADPCM....');
            ret := CodecOCX1.ConvertWAVToIMAADPCM(SRC.Text, DEST.Text, mode);
        end;
        3:
        begin
            AddMessage('Converting IMA ADPCM To WAV...');
            ret := CodecOCX1.ConvertIMAADPCMToWAV(SRC.Text, DEST.Text, mode);
        end;
        4:
        begin
            AddMessage('Converting WAV To Dialogic ADPCM...');
            ret := CodecOCX1.ConvertWAVToDialogicADPCM(SRC.Text, DEST.Text, mode);
        end;
        5:
        begin
            AddMessage('Converting Dialogic ADPCM To WAV...');
            ret := CodecOCX1.ConvertDialogicADPCMToWAV(SRC.Text, DEST.Text, mode);
        end;
        6:
        begin
            AddMessage('Converting PCM 11 KHz To PCM 8 KHz...');
            ret := CodecOCX1.ConvertPCM11ToPCM8(SRC.Text, DEST.Text, mode);
        end;
        7:
        begin
            AddMessage('Converting PCM 8 KHz To PCM 11 KHz...');
            ret := CodecOCX1.ConvertPCM8ToPCM11(SRC.Text, DEST.Text, mode);
        end;
      else
        begin
            AddMessage('Converting WAV to VOC...');
            ret := CodecOCX1.ConvertWAVToVOC(SRC.Text, DEST.Text, mode);
        end;
      End;

    If mode Then
        If ret = 0 Then
            AddMessage('Conversion failed!')
        Else
            AddMessage('Conversion finished successfully!')
    Else
        If ret <> 0 Then
            AddMessage ('Conversion job has been created! Conversion ID:' + IntToStr(ret))
        Else
            AddMessage('Conversion failed!');
end;

procedure TForm1.OnFinishConversion(Sender: TObject;
  ConversionID: Integer);
begin
   AddMessage ('Conversion finished! Conversion ID:' + IntToStr(ConversionID))
end;

procedure TForm1.OnFStartConversion(Sender: TObject;
  ConversionID: Integer);
begin
   AddMessage ('Conversion started! Conversion ID:' + IntToStr(ConversionID))
end;

procedure TForm1.OnPCM112PCM8(Sender: TObject);
begin
     AddMessage('PCM 11 Khz to PCM 8 KHz conversion has been selected.');
     format:=6;
end;

procedure TForm1.OnPCM82PCM11(Sender: TObject);
begin
     AddMessage('PCM 8 Khz to PCM 11 KHz conversion has been selected.');
     format:=7;
end;

end.


