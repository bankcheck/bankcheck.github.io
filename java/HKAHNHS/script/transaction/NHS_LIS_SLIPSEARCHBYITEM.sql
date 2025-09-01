CREATE OR REPLACE FUNCTION "NHS_LIS_SLIPSEARCHBYITEM"(
	v_PatNo    IN VARCHAR2,
	v_DeptCode IN VARCHAR2,
	v_SlpType  IN VARCHAR2,
	v_ArcCode  IN VARCHAR2,
	v_DateFrom IN VARCHAR2,
	v_DateTo   IN VARCHAR2,
	v_UsrID    IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	v_Count NUMBER;
	v_UsrInp NUMBER := 0;
	v_UsrOut NUMBER := 0;
	v_UsrDay NUMBER := 0;
	OUTCUR TYPES.CURSOR_TYPE;
	sqlbuff VARCHAR2(2000);
	sqlbuff2 VARCHAR2(1000);
BEGIN
	SELECT COUNT(1) INTO v_Count FROM Usr WHERE UsrID = v_UsrID;
	IF v_Count = 1 THEN
		SELECT UsrInp, UsrOut, UsrDay INTO v_UsrInp, v_UsrOut, v_UsrDay FROM Usr WHERE UsrID = v_UsrID;
	END IF;

	sqlbuff := 'SELECT /*+ ORDERED USE_NL(S, D, I, R, P) INDEX(S idx_slip_101) */
			DECODE(S.SlpRemark, NULL, '''', ''*''),
			DECODE(S.EDC, NULL, '''', '''', '''', ''#''),
			TO_CHAR(R.REGDATE, ''DD/MM/YYYY HH24:MI:SS''),
			S.SlpNo,
			S.SlpType,
			S.SlpSts,
			S.ArcCode,
			A.ArcName,
			P.PatNo,
			NVL(S.SlpFName, P.PatFName),
			NVL(S.SlpGName, P.PatGName),
			D.DocCode,
			D.DocFName,
			D.DocGName,
			SL.Stndesc,
			SL.Stndesc1,
			SL.Stnnamt,
			S.SlpRemark,
			S.USRID,
			NVL(S.PatCName, P.PatCName),
			D.DocCName,
			'''',
			trunc(SYSDATE) - trunc(DECODE(SL.StnCDate, NULL, SYSDATE, SL.StnCDate))
		FROM Slip S
		INNER JOIN SlipTx SL ON S.SlpNo = SL.SlpNo
		LEFT  JOIN Reg R ON S.RegID = R.RegID
		LEFT  JOIN Patient P ON S.PatNo = P.PatNo
		LEFT  JOIN Doctor D ON S.DocCode = D.DocCode
		LEFT  JOIN Arcode A ON S.ArcCode = A.ArcCode
		WHERE S.SlpSts IN (''A'', ''C'', ''F'', ''R'')
		AND   SL.Stnsts IN (''N'',''A'') ';

	IF v_PatNo IS NOT NULL THEN
		sqlbuff := sqlbuff || ' AND S.PatNo = ''' || v_PatNo || '''';
	END IF;

	IF v_ArcCode IS NOT NULL THEN
		sqlbuff := sqlbuff || ' AND S.ArcCode = ''' || v_ArcCode || '''';
	END IF;

	IF v_DeptCode IS NOT NULL THEN
		sqlbuff := sqlbuff || ' AND SL.DscCode= ''' || v_DeptCode || '''';
	END IF;

	IF v_SlpType IS NOT NULL THEN
		sqlbuff := sqlbuff || ' AND S.SlpType = '''  || v_SlpType || '''';
	ELSIF v_UsrInp = 0 OR v_UsrOut = 0 OR v_UsrDay = 0 THEN
		IF v_UsrInp = -1 THEN
			sqlbuff2 := sqlbuff2 || ' S.SlpType = ''I''';
		END IF;
		IF v_UsrOut = -1 THEN
			IF sqlbuff2 IS NOT NULL AND LENGTH(sqlbuff2) > 0 THEN sqlbuff2 := sqlbuff2 || ' OR'; END IF;
			sqlbuff2 := sqlbuff2 || ' S.SlpType = ''O''';
		END IF;
		IF v_UsrDay = -1 THEN
			IF sqlbuff2 IS NOT NULL AND LENGTH(sqlbuff2) > 0 THEN sqlbuff2 := sqlbuff2 || ' OR'; END IF;
			sqlbuff2 := sqlbuff2 || ' S.SlpType = ''D''';
		END IF;
		IF sqlbuff2 IS NOT NULL AND LENGTH(sqlbuff2) > 0 THEN
			sqlbuff := sqlbuff || ' AND (' || sqlbuff2 || ')';
		END IF;
	END IF;

	IF v_DateFrom IS NOT NULL THEN
		sqlbuff := sqlbuff || ' AND SL.StnCDate >= TO_DATE(''' || v_DateFrom || ''', ''DD/MM/YYYY'') ';
	END IF;

	IF v_DateTo IS NOT NULL THEN
		sqlbuff := sqlbuff || ' AND SL.StnCDate <= TO_DATE(''' || v_DateTo || ''', ''DD/MM/YYYY'') ';
	END IF;

	sqlbuff := sqlbuff || ' ORDER BY S.SlpNo DESC';

--	OPEN OUTCUR FOR SELECT sqlbuff from dual;
	OPEN OUTCUR FOR sqlbuff;
	RETURN OUTCUR;
END NHS_LIS_SLIPSEARCHBYITEM;
/
