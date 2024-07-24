program OpenFaxBoardsDelphi;

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
  Application.Title := 'Fax ActiveX Control - Delphi OpenFaxBoards Sample';
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
