CREATE OR REPLACE FUNCTION NHS_LIS_SYSPARA(
	v_mustAPara Varchar2
)
  	RETURN Types.cursor_type AS
  	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
		SELECT
		'',
		pardesc,
		param1,
		param2,
    parcde
		FROM SYSPARAM
		WHERE (v_mustAPara = 'DI'   AND PARCDE IN ('DIDeptID','XRAY','CTSCAN','DIUsr','DEFAULTDOC','DIOSDOC','XRI','XRD','XRO','XRR','CTI','CTD','CTO','CTR','HOSPADD','DITEL','DIRPTDR','USEREFPBA'))
		OR    (v_mustAPara = 'PHAR' AND PARCDE IN ('PharDeptID','PharDDID','SigLvl','DrgChkLvl','PXUsr','PItmCode','PXDOC','BringInDrg','RefillLvl','OTC','PresInst','ROLEPX','ROLEDR','ROLENU','PRESPATH'))
		OR    (v_mustAPara = 'PBA'  AND PARCDE IN ('LblPrnNo','OpPageSize','IpPageSize','DCPageSize','DpPageSize','DisPatDest','DisClsTmp','CHQCOMBUF','MAILPATH','CSRDSCCODE','CSRSCH','ADMFRMPATH','ADMFRM2PAT', 'NEXTPATNO','IPGENLAB2','SN2EXPSCH','DAYENDCANS','DisplayCap','GenLabel','OpdDeptID','LOGINTIMEO','RlsDestDir','NurseryBed','MedPrnNo','Recorder','ANOTE','AOPNOTE','ADCNOTE','CvrLetter','List','GrtPayDir','IPBufDAY','IPOTAMT','IPADDAY','AdmDestDir','ChkDigit','Chk*','PBAState1','PBAState2','IPREMFLAG','FURGUAFLAG','ADMINSFLAG','RNoPatSize','IPREMFLAG','FURGUAFLAG','ADMINSFLAG','MultiPath','MulLangVer','DefLang','LBLTYP','DAYENDLOCK','AppLabNum','templ_pwd','templ_path','PRTSTAT','PRTIPSUM','maxmprebok','maxdprebok','obwardcode','addedxedoc','temp_cert','obwaitcnt','obprint','temp_oblet','OBDTF','OBAUTOWAIT','TicketLblN','PrnTktLbl','DOCPICPATH','weightunit','dayRemind','OTABed','HosSupName','OBCnxlTemp','TicketGen','DUPBPCHKF','DUPBPDAY','DUPBPDOC','DUPBPGN'))
		OR    (v_mustAPara = 'MRLC' AND PARCDE IN ('MRNPSL','MRNPCL','MRNVSL','MRNVCL','MRIPSL','MRIPCL','MROPSL','MROPCL','MRDCSL','MRDCCL','MRTRCL'))
		OR    (v_mustAPara = 'MRVN' AND PARCDE IN ('MRNPVN','MRNVVN'))
		OR    (v_mustAPara = 'MRMT' AND PARCDE IN ('MRNPMT','MRNVMT'))
		ORDER BY pardesc;
	RETURN OUTCUR;
END NHS_LIS_SYSPARA;
/
