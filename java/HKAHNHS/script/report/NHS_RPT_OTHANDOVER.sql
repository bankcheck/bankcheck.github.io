create or replace
FUNCTION "NHS_RPT_OTHANDOVER"(
	V_OTAID IN VARCHAR2,
	V_OTROOM_TYPE IN VARCHAR2
)
  RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
BEGIN
  OPEN OUTCUR FOR
	 select 
		bed.romcode as Room, bed.bedcode as Bed, to_char(ota.otaosdate,'dd/mm/yyyy hh24:mi') as OTStart, to_char(otaoedate,'hh24:mi') as OTEnd,
		otp.otpdesc as Operation, decode(nvl(ota.doccode_s,' '),' ', dr_e.docfname || ' ' || dr_e.docgname, dr_s.docfname || ' ' || dr_s.docgname) as Surgeon,otc.otcdesc as OTRoom, to_char(OTAID) as otaid,
	  '<BT>OTPICKUP</BT><RN>'|| OTAID || '</RN>' As Barcode
	 From OT_APP ota, doctor dr_s, doctor dr_e, ot_proc otp, ot_code otc, inpat ip, reg reg, bed bed
	 Where Ota.Doccode_S = Dr_S.Doccode(+) And Ota.Doccode_E = Dr_E.Doccode(+)
		 and Ota.Otcid_Rm = Otc.Otcid
		 and Otc.Otctype = V_OTROOM_TYPE
		 and ota.otpid = otp.otpid(+)
		 and Ota.Pbpid = Reg.Pbpid(+) And Reg.Inpid = Ip.Inpid(+) And Ip.Bedcode = Bed.Bedcode
		 and ota.otaid = V_OTAID;
  RETURN OUTCUR;
END NHS_RPT_OTHANDOVER;
/
