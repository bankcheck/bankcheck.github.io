program ReceiveFaxWithDTMFDelphi;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  AboutDlg in 'AboutDlg.pas' {AboutForm},
  CloseDlg in 'CloseDlg.pas' {ClosePort},
  GammaInit in 'GammaInit.pas' {GammaLinkInit},
  BrookTrout in 'BrookTrout.pas' {BrooktroutInit},
  dlginit in 'dlginit.pas' {Dialogic},
  NMSInit in 'NMSInit.pas' {NMS};

{$R *.RES}

begin
  Application.Title := 'Fax ActiveX Control - Delphi ReceiveFaxWithDTMF Sample';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
