program SendFaxDelphi;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  AboutDlg in 'AboutDlg.pas' {AboutForm},
  OpenDlg in 'OpenDlg.pas' {CommPortInit},
  CloseDlg in 'CloseDlg.pas' {ClosePort},
  SendDlg in 'SendDlg.pas' {SendFax};

{$R *.RES}

begin
  Application.Title := 'Fax ActiveX Control - SendFax Delphi Sample';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
