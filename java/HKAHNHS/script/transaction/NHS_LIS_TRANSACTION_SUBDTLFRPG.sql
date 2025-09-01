create or replace
FUNCTION  "NHS_LIS_TRANSACTION_SUBDTLFRPG" (
	i_SLPNO   IN VARCHAR2,
  i_showPkg IN VARCHAR2,
  i_servCode IN VARCHAR2,
	i_UserID  IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	STRSQL VARCHAR2(2000);
	v_Count NUMBER;
	v_IsPBOUser NUMBER;
BEGIN
	SELECT COUNT(1) INTO v_Count FROM Usr WHERE UsrId = i_UserID;
	IF v_Count > 0 THEN
		SELECT USRPBO INTO v_IsPBOUser FROM Usr WHERE UsrId = i_UserID;
	END IF;

	STRSQL := '
		SELECT SX.Stnseq,
			SX.Pkgcode,
			XR.Stnid,
			SX.Itmcode,
			SX.Itmtype,
			SX.Stndesc || '' '' || SX.Stndesc1 AS STNDESC,
			SX.Unit,
			SX.Irefno,
			SX.Stndisc,
			SX.Stnnamt,
			SX.Stnbamt,
			SX.Doccode,
			TO_CHAR(SX.Stntdate, ''dd/MM/YYYY''),
			SX.DscCode,
			SX.Stnsts,
			SP.Spcname,
			SX.USRID,
			SX.Acmcode,
			SX.Stnrlvl,
			TO_CHAR(DECODE(SXE.STNSDATE, NULL, SX.STNCDATE, SXE.STNSDATE), ''dd/MM/YYYY HH24:MI:SS''),
			SX.GlcCode,
			D.Docfname || '' '' || D.Docgname,
			SX.Stnid,
			TO_CHAR(SX.Stnadoc, ''dd/MM/YYYY''),
			SX.Stnxref,
			XR.Xrgid,
			SX.Stntype,
			SX.Stncpsflag
	FROM  SlipTx SX
	LEFT  JOIN Doctor D ON SX.Doccode = D.Doccode
	LEFT  JOIN Spec SP ON D.SPCCODE = SP.SPCCODE
	LEFT  JOIN SlipTx_EXTRA SXE ON SX.Stnid = SXE.Stnid ';

	IF v_IsPBOUser = 0 THEN
		STRSQL := STRSQL || 'LEFT  JOIN Item I ON SX.ITMCODE = I.ITMCODE AND I.STECODE = ''' || GET_CURRENT_STECODE || ''' ';
	END IF;

	STRSQL := STRSQL || '
		LEFT  JOIN XReg XR ON SX.DIXREF = XR.STNID
		WHERE SX.SLPNO = ''' || i_SLPNO || ''' ';

		STRSQL := STRSQL || 'AND  SX.STNSTS IN (''N'',''A'') ';
		STRSQL := STRSQL || 'AND  SX.Stnxref is null ';
  
  IF i_showPkg = 'N' THEN
      		STRSQL := STRSQL || 'AND  SX.Pkgcode is null ';
  END IF;
  
  IF i_servCode is not null THEN
    	STRSQL := STRSQL || 'AND  SX.DscCode ='''||i_servCode||''' ';
  END IF;
	
  IF v_IsPBOUser = 0 THEN
		STRSQL := STRSQL || 'AND  I.DscCode IN (SELECT DscCode FROM ROLE_DEPT_SERV R INNER JOIN UsrRole U ON R.Role_ID = U.RolID WHERE U.USRID = ''' || i_UserID || ''') ';
	END IF;

		STRSQL := STRSQL || 'ORDER BY SX.Stnseq DESC';

	OPEN OUTCUR FOR STRSQL;
	RETURN OUTCUR;
END NHS_LIS_TRANSACTION_SUBDTLFRPG;
/
