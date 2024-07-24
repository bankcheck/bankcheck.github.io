program OpenComPortsDelphi;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  AboutDlg in 'AboutDlg.pas' {AboutForm},
  OpenDlg in 'OpenDlg.pas' {CommPortInit},
  CloseDlg in 'CloseDlg.pas' {ClosePort};

{$R *.RES}

begin
  Application.Title := 'Fax ActiveX Control - Delphi OpenComPorts Sample';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
