program voiceOCX;

uses
  Forms,
  MAINunit in 'MAINunit.pas' {frmMain},
  CHILDWINunit in 'CHILDWINunit.pas' {frmChild},
  DIALOGICOPENunit in 'DIALOGICOPENunit.pas' {frmDialogicOpen},
  HELPunit in 'HELPunit.pas' {frmHelp},
  OPENBROOKunit in 'OPENBROOKunit.pas' {frmOpenBrook},
  OPENNMSunit in 'OPENNMSunit.pas' {frmOpenNMS},
  SELECTPORTunit in 'SELECTPORTunit.pas' {frmSelectPort},
  About in 'about.pas' {AboutBox};    

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmDialogicOpen, frmDialogicOpen);
  Application.CreateForm(TfrmHelp, frmHelp);
  Application.CreateForm(TfrmOpenBrook, frmOpenBrook);
  Application.CreateForm(TfrmOpenNMS, frmOpenNMS);
  Application.CreateForm(TfrmSelectPort, frmSelectPort);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
