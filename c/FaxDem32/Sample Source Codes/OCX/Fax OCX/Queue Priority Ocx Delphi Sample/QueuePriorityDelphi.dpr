program QueuePriorityDelphi;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  AboutDlg in 'AboutDlg.pas' {AboutForm},
  OpenDlg in 'OpenDlg.pas' {CommPortInit},
  CloseDlg in 'CloseDlg.pas' {ClosePort},
  SendDlg in 'SendDlg.pas' {SendFax},
  FaxDlg in 'FaxDlg.pas' {FaxConfigDlg},
  GammaInit in 'GammaInit.pas' {GammaLinkInit},
  BrookTrout in 'BrookTrout.pas' {BrooktroutInit},
  dlginit in 'dlginit.pas' {Dialogic},
  NMSInit in 'NMSInit.pas' {NMS};

{$R *.RES}

begin
  Application.Title := 'Fax ActiveX Control - Delphi Queue Priority Sample';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
