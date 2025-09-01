create or replace
FUNCTION "NHS_RPT_RPTNEWDOCFEETXLST_TPA"(
	V_DATEEND 	IN VARCHAR2,
    V_SPHID 	IN VARCHAR2)
RETURN TYPES.CURSOR_TYPE AS
  	OUTCUR TYPES.CURSOR_TYPE;
  	STRSQL Varchar2(30000);
  
	cp_DATEEND	df_chkpt.DATEEND%TYPE;
	cp_SPHID	df_chkpt.SPHID%TYPE;
	cp_STATUS	df_chkpt.STATUS%TYPE;
	cp_NEXTNO	df_chkpt.NEXTNO%TYPE;
	cp_PCYID	df_chkpt.PCYID%TYPE;
	cp_REPORT	df_chkpt.REPORT%TYPE;
	cp_USRID	df_chkpt.USRID%TYPE;
	cp_MACHINE	df_chkpt.MACHINE%TYPE;
Begin
	If V_DATEEND Is Not Null AND V_SPHID IS NULL Then
	  	cp_DATEEND := NULL;
		cp_SPHID := NULL;
  
		OUTCUR := Nhs_Get_Docfee_Chkpt;
		Fetch OUTCUR Into Cp_Dateend, Cp_Sphid, Cp_Status, Cp_Nextno, Cp_Pcyid, Cp_Report, Cp_Usrid, Cp_Machine;
		close OUTCUR;
	ELSE
	  	Cp_Dateend := TO_DATE(V_DATEEND, 'DD/MM/YYYY');
	  	Cp_SPHID := V_SPHID;
	end if;


	STRSQL := '
		select a.GRP,
  A.Subgrp,
  A.Doccode,
  a.DOCFNAME,
  A.Docgname,
  a.SLPNO,
  A.Slptype,
  a.STNID,
  A.Stnsts,
  to_char(A.Stncdate, ''dd/MM/yyyy'') Stncdate,
  A.Itmcode,
  A.Stndesc,
  A.Stnbamt,
  A.Stndisc,
  A.Stnnamt,
  a.PATNO,
  A.Slpfname,
  A.Slpgname,
  a.PATFNAME,
  A.Patgname,
  A.Pcyid,
  a.DSCCODE,
  A.Dfx_Pct,
  A.Dfx_Famt,
  A.Dfx_Samt,
  A.Dfx_Pamt,
  A.Dfx_Camt,
  A.Commission,
  A.Dfx_Code,
  A.Stnoamt,
   to_char(a.STNTDATE, ''dd/MM/yyyy'') STNTDATE,
			b.tittle,decode(b.RPTTO,NULL,'''',''C'',DOCADD1,''H'',DOCHOMADD1,''O'',DOCOFFADD1) AS ADD1, 
			decode(b.RPTTO,NULL,'''',''C'',DOCADD2,''H'',DOCHOMADD2,''O'',DOCOFFADD2) AS ADD2, 
			decode(b.RPTTO,NULL,'''',''C'',DOCADD3,''H'',DOCHOMADD3,''O'',DOCOFFADD3) AS ADD3, 
			decode(b.RPTTO,NULL,'''',''C'',DOCADD4,''H'',DOCHOMADD4,''O'',DOCOFFADD4) AS ADD4,
			A.ARCCODE, A.AR_PCT
			from df_sliptx a,doctor b
			where a.doccode=b.doccode(+)
	order by a.STNTDATE, a.PATNO';
  OPEN OUTCUR FOR STRSQL;
  RETURN OUTCUR;
END NHS_RPT_RPTNEWDOCFEETXLST_TPA;
/
