CREATE OR REPLACE FUNCTION "NHS_LIS_TRANSACTION_DETAIL"(
	v_PatNo    IN VARCHAR2,
	v_SlpNo    IN VARCHAR2,
	v_SlpType  IN VARCHAR2,
	v_SlpSts   IN VARCHAR2,
	v_PatFName IN VARCHAR2,
	v_PatGName IN VARCHAR2,
	v_DocCode  IN VARCHAR2,
	v_RegDate  IN VARCHAR2,
	v_NoPatNo  IN VARCHAR2,
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
	IF v_PatNo is null and v_SlpNo is null and v_SlpType is null
			and v_PatFName is null and v_PatGName is null and v_DocCode is null
			and v_RegDate is null and v_SlpSts is null THEN
		RETURN NULL;
	END IF;

	SELECT COUNT(1) INTO v_Count FROM Usr WHERE UsrID = v_UsrID;
	IF v_Count = 1 THEN
		SELECT UsrInp, UsrOut, UsrDay INTO v_UsrInp, v_UsrOut, v_UsrDay FROM Usr WHERE UsrID = v_UsrID;
	END IF;

	--sqlbuff := 'SELECT /*+ ORDERED USE_NL(S, D, I, R, P) INDEX(S ';
	--IF v_SlpNo IS NOT NULL THEN
	--	sqlbuff := sqlbuff || 'PK_SLIP';
	--ELSE
		sqlbuff := sqlbuff || 'idx_slip_101';
	--END IF;

	--sqlbuff := sqlbuff || ') */
	sqlbuff := 'SELECT
			DECODE(S.SlpRemark, NULL, '''', ''*''),
			DECODE(S.EDC, NULL, '''', '''', '''', ''#''),
			DECODE(SM.SlpNo, NULL, '''', DECODE(SM.UsrID, ''PRIMARYSLP'', ''P'', ''M'')),
			TO_CHAR(R.REGDATE, ''DD/MM/YYYY HH24:MI:SS''),
			S.SlpNo,
			S.SlpType,
			S.SlpSts,
			S.ArcCode,
			A.ArcName,
			P.PatNo,
			DECODE(NVL(P.TITDESC, ''''), '''', '''',  ''<font color=blue>'' || P.TITDESC || ''</font> '') || NVL(S.SlpFName, P.PatFName),
			NVL(S.SlpGName, P.PatGName),
			D.DocCode,
			D.DocFName,
			D.DocGName,
			TO_CHAR(R.REGDATE, ''DD/MM/YYYY HH24:MI:SS''),
			TO_CHAR(I.INPDDATE, ''DD/MM/YYYY HH24:MI:SS''),
			S.SlpDAmt,
			S.SlpPAmt,
			S.SlpCAmt + S.SlpDAmt + S.SlpPAmt AS SlpNAmt,
			NVL(UR.USRNAME,S.USRID),
			NVL(S.PatCName, P.PatCName),
			D.DocCName,
			(SELECT COUNT(1) FROM OT_Log WHERE OtlSts <> ''X'' AND PatNo = S.PatNo AND SlpNo = S.SlpNo),
			TO_CHAR(SE.SLPDATE, ''DD/MM/YYYY HH24:MI:SS'')
		FROM Slip S
		LEFT JOIN Reg R ON S.RegID = R.RegID
		LEFT JOIN Patient P ON S.PatNo = P.PatNo
		LEFT JOIN Doctor D ON S.DocCode = D.DocCode
		LEFT JOIN InPat I ON R.INPID = I.INPID
		LEFT JOIN Arcode A ON S.ArcCode = A.ArcCode
		LEFT JOIN SlipMerge SM ON S.SlpNo = SM.SlpNo
		LEFT JOIN USR UR ON S.USRID = UR.USRID
		LEFT JOIN SLIP_EXTRA SE ON S.SlpNo = SE.SlpNo
		WHERE SlpSts IN (''A'', ''C'', ''F'', ''R'') ';

	IF v_PatNo IS NOT NULL THEN
		sqlbuff := sqlbuff || ' AND S.PatNo = ''' || v_PatNo || '''';
	END IF;

	IF v_SlpNo IS NOT NULL THEN
		sqlbuff := sqlbuff || ' AND S.SlpNo = ''' || v_SlpNo || '''';
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

	IF v_SlpSts IS NOT NULL THEN
		sqlbuff := sqlbuff || ' AND S.SlpSts = ''' || v_SlpSts || '''';
	END IF;

	IF v_DocCode IS NOT NULL THEN
		sqlbuff := sqlbuff || ' AND S.DocCode = ''' || v_DocCode || '''';
	END IF;

	IF v_RegDate IS NOT NULL THEN
		sqlbuff := sqlbuff || ' AND R.REGDATE >= TO_DATE(''' || v_RegDate || ' 00:00:00'', ''DD/MM/YYYY HH24:MI:SS'')';
	END IF;

	IF v_NoPatNo = 'Y' THEN
		IF v_PatFName IS NOT NULL THEN
			IF v_PatFName LIKE '%' THEN
				sqlbuff := sqlbuff || ' AND S.SlpFName LIKE ''' || v_PatFName || '''';
			ELSE
				sqlbuff := sqlbuff || ' AND S.SlpFName = ''' || v_PatFName || '''';
			END IF;
		END IF;

		IF v_PatGName IS NOT NULL THEN
			IF v_PatGName LIKE '%' THEN
				sqlbuff := sqlbuff || ' AND S.SlpGName LIKE ''' || v_PatGName || '''';
			ELSE
				sqlbuff := sqlbuff || ' AND S.SlpGName = ''' || v_PatGName || '''';
			END IF;
		END IF;
		sqlbuff := sqlbuff || ' AND S.PatNo IS NULL';
	ELSE
		IF v_PatFName IS NOT NULL THEN
			IF v_PatFName LIKE '%' THEN
				sqlbuff := sqlbuff || ' AND (S.SlpFName LIKE ''' || v_PatFName || '%'' OR P.PatFName LIKE ''' || v_PatFName || ''')';
			ELSE
				sqlbuff := sqlbuff || ' AND (S.SlpFName = ''' || v_PatFName || ''' OR P.PatFName = ''' || v_PatFName || ''')';
			END IF;
		END IF;

		IF v_PatGName IS NOT NULL THEN
			IF v_PatGName LIKE '%' THEN
				sqlbuff := sqlbuff || ' AND (S.SlpGName LIKE ''' || v_PatGName || '%'' OR P.PatGName LIKE ''' || v_PatGName || ''')';
			ELSE
				sqlbuff := sqlbuff || ' AND (S.SlpGName = ''' || v_PatGName || ''' OR P.PatGName = ''' || v_PatGName || ''')';
			END IF;
		END IF;
	END IF;

	sqlbuff := sqlbuff || ' ORDER BY S.SlpNo DESC';

	OPEN OUTCUR FOR sqlbuff;
	RETURN OUTCUR;
END NHS_LIS_TRANSACTION_DETAIL;
/
