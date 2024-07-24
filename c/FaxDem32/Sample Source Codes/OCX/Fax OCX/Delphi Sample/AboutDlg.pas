unit AboutDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ExtCtrls;

function ShellExecuteA(hWnd: HWND; Operation, FileName, Parameters,
   Directory: PChar; ShowCmd: Integer): HINST;
   stdcall; external 'shell32.dll';
type
  TAboutForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    mailLabel: TLabel;
    Label6: TLabel;
    webLabel: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure mailLabelClick(Sender: TObject);
    procedure webLabelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.DFM}

procedure TAboutForm.Button1Click(Sender: TObject);
begin
     close;
end;

procedure TAboutForm.mailLabelClick(Sender: TObject);
var mail: String;
    ret: integer;
begin
     mail:='mailto:'+mailLabel.Caption;
     ret:=ShellExecuteA(Handle, 'open', PChar(mail), '', '', 1);
     if (ret<=32) then MessageDlg('Error opening'+mailLabel.Caption,mtWarning,[mbOK],0);
end;

procedure TAboutForm.webLabelClick(Sender: TObject);
var ret: integer;
begin
        ret:=ShellExecuteA(Handle,'open',PChar(webLabel.Caption),'','',1);
        if (ret<=32) then MessageDlg('Error opening'+webLabel.Caption,mtWarning,[mbOK],0);

end;

end.
