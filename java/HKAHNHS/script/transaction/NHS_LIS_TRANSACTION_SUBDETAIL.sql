CREATE OR REPLACE FUNCTION "NHS_LIS_TRANSACTION_SUBDETAIL" (
	i_SLPNO   IN VARCHAR2,
	i_HISTORY IN VARCHAR2,
	i_OrderBy IN VARCHAR2,
	i_UserID  IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	STRSQL VARCHAR2(2000);
	v_Count NUMBER;
	v_IsPBOUser NUMBER;
	v_isCashier Number;
BEGIN
	SELECT COUNT(1) INTO v_Count FROM Usr WHERE UsrId = i_UserID;
	IF v_Count > 0 THEN
		SELECT USRPBO INTO v_IsPBOUser FROM Usr WHERE UsrId = i_UserID;
		Select Count(1) Into V_Iscashier From Cashier Where Usrid = I_Userid;
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
			SX.Stncpsflag,
			SX.Dixref,
			SX.Stnoamt,
			SX.Stnascm,
			SX.Stndesc,
			SX.Stndesc1,
			SX.Stndiflag,
			(SELECT COUNT(1) FROM Slppaydtl WHERE SX.Stnid = STNID AND (Spdsts =''A'' or Spdsts=''N'') AND Sphid IS NOT NULL) AS bIsNull,
			DECODE(C.Ctxmeth, ''E'', 1, 0) AS isEPSPayment,
			CASE WHEN NHS_UTL_isChequeTransaction(SX.Stnxref) >= 0 THEN ''Y'' ELSE ''N'' END,
			XR.xr.stnID AS xrStnID,
--			(SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE = ''PAYMENTMETHOD'' AND ID = (SELECT CT.CTXMETH FROM CASHTX CT, SLIPTX TX WHERE CT.CTXID = TX.STNXREF AND TX.STNID = SX.STNID))
			SX.STNCDATE
	FROM  SlipTx SX
	LEFT  JOIN Doctor D ON SX.Doccode = D.Doccode
	LEFT  JOIN Spec SP ON D.SPCCODE = SP.SPCCODE
	LEFT  JOIN SlipTx_EXTRA SXE ON SX.Stnid = SXE.Stnid ';

	IF v_IsPBOUser = 0 THEN
		STRSQL := STRSQL || 'LEFT  JOIN Item I ON SX.ITMCODE = I.ITMCODE AND I.STECODE = ''' || GET_CURRENT_STECODE || ''' ';
	END IF;

	STRSQL := STRSQL || '
		LEFT  JOIN XReg XR ON SX.DIXREF = XR.STNID
		LEFT  JOIN Cashtx C ON SX.Stnxref = C.Ctxid
		WHERE SX.SLPNO = ''' || i_SLPNO || ''' ';

	IF NVL(i_HISTORY,'N') != 'Y' THEN
		STRSQL := STRSQL || 'AND  SX.STNSTS IN (''N'',''A'') ';
	END IF;

--	IF v_IsPBOUser = 0 THEN
--		STRSQL := STRSQL || 'AND  I.DscCode IN (SELECT DscCode FROM ROLE_DEPT_SERV R INNER JOIN UsrRole U ON R.Role_ID = U.RolID WHERE U.USRID = ''' || i_UserID || ''') ';
--	END IF;

	If V_Ispbouser = 0 Then
	    If V_Iscashier > 0 Then
	      Strsql := Strsql || 'AND  (I.DscCode IN (SELECT DscCode FROM ROLE_DEPT_SERV R INNER JOIN UsrRole U ON R.Role_ID = U.RolID WHERE U.USRID = ''' || I_Userid || ''') ';
	      Strsql := Strsql || 'OR (SX.STNTYPE in (''S'',''R''))) ';
	    ELSE
	      Strsql := Strsql || 'AND  I.DscCode IN (SELECT DscCode FROM ROLE_DEPT_SERV R INNER JOIN UsrRole U ON R.Role_ID = U.RolID WHERE U.USRID = ''' || I_Userid || ''') ';
	    End If;
	END IF;

	IF i_OrderBy = 'dptcode' THEN
		STRSQL := STRSQL || 'ORDER BY substr(Sx.GlcCode, 1, 4), Sx.StnTDate';
	ELSIF i_OrderBy = 'tdate' THEN
		STRSQL := STRSQL || 'ORDER BY Sx.StnTDate Desc';
	ELSIF i_OrderBy = 'dptsrv' THEN
		STRSQL := STRSQL || 'ORDER BY Sx.DscCode, Sx.StnTDate';
	ELSIF i_OrderBy = 'itmcode' THEN
		STRSQL := STRSQL || 'ORDER BY SX.Itmcode, Sx.StnTDate';
	ELSE
		STRSQL := STRSQL || 'ORDER BY SX.Stnseq DESC';
	END IF;

	OPEN OUTCUR FOR STRSQL;
	RETURN OUTCUR;
END NHS_LIS_TRANSACTION_SUBDETAIL;
/
