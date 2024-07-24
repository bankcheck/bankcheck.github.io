unit HELPunit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmHelp = class(TForm)
    RichEdit1: TRichEdit;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHelp: TfrmHelp;

implementation

{$R *.DFM}

procedure TfrmHelp.FormShow(Sender: TObject);
begin
RichEdit1.Lines.LoadFromFile('vmvbhelp.rtf');
end;

procedure TfrmHelp.Button1Click(Sender: TObject);
begin
Close;
end;

end.
