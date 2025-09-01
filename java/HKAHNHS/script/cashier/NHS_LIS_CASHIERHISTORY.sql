CREATE OR REPLACE FUNCTION "NHS_LIS_CASHIERHISTORY" (
	v_PayType       IN VARCHAR2,
	v_Receipt       IN VARCHAR2,
	v_ReceiptNo     IN VARCHAR2,
	v_StartDate     IN VARCHAR2,
	v_EndDate       IN VARCHAR2,
	v_Status        IN VARCHAR2,
	v_Reference     IN VARCHAR2,
	v_CashierCode   IN VARCHAR2,
	v_paymentMethod IN VARCHAR2,
	v_cardType      IN VARCHAR2,
	v_amtFrom       IN VARCHAR2,
	v_amtTo         IN VARCHAR2,
	v_sortBy        IN VARCHAR2
)
	return types.cursor_type
AS
	sqlstr VARCHAR2(2000);
	outcur types.cursor_type;
BEGIN
	sqlstr := 'SELECT
				C.CtxId,
				DECODE(C.CtxType,''P'',''Payout'',''R'',''Receipt'',''A'',''Advance & Withdraw''),
				TO_CHAR(C.CtxTdate,''dd/mm/yyyy''),
				C.CtxName,
				TO_CHAR(C.CtxAmt,''fm999999999999999.00'') as CtxAmt,
				C.SlpNo,
				C.CtxDesc,
				C.CtxSNo,
				DECODE(C.CtxSts,''N'',''Normal'',''V'',''Void'',''R'',''Reverse'',''Manual''),
				C.CshCode,
				P.PayDesc,
				C.CtxCat,
				C.CtxType,
				CASE WHEN NHS_UTL_ISCHEQUETRANSACTION(C.CtxID) >= 0 THEN ''Y'' ELSE ''N'' END,
				CASE WHEN (SYSDATE - 1) <= C.CtxTdate THEN ''Y'' ELSE ''N'' END,
				P.PayCode,
				CD.CTNCTYPE
			FROM
				CashTx C,
				PayCode P,
				CardTx CD
			WHERE C.CtxMeth = P.PayType
			AND   C.CTNID = CD.CTNID(+)
			AND   C.CshCode >= CHR(0) ';

	IF v_PayType IS NOT NULL THEN
		sqlstr := sqlstr || 'AND C.CtxType = ''' || v_PayType || ''' ';
	END IF;

	IF v_Receipt IS NOT NULL THEN
		sqlstr := sqlstr || 'AND Upper(C.CtxName) LIKE ''' || Upper(v_Receipt) || '%'' ';
	END IF;

	IF v_ReceiptNo IS NOT NULL THEN
		sqlstr := sqlstr || 'AND C.CtxSNo = ''' || v_ReceiptNo || ''' ';
	END IF;

	IF V_STARTDATE IS NOT NULL THEN
		sqlstr := sqlstr || 'AND C.CtxTdate >= TO_DATE(''' || v_StartDate || ' 00:00:00'', ''DD/MM/YYYY HH24:MI:SS'') ';
	END IF;

	IF V_ENDDATE IS NOT NULL THEN
		sqlstr := sqlstr || 'AND C.CtxTdate <= TO_DATE(''' || v_EndDate || ' 23:59:59'', ''DD/MM/YYYY HH24:MI:SS'') ';
	END IF;

	IF v_Reference IS NOT NULL THEN
		sqlstr := sqlstr || 'AND C.CtxDesc LIKE ''' || v_Reference||'%'' ';
	END IF;

	IF v_Status IS NOT NULL AND v_Status <> 'A' then
		sqlstr := sqlstr || 'AND C.CtxSts = ''' || v_Status || ''' ';
	END IF;

	IF v_CashierCode IS NOT NULL THEN
		sqlstr := sqlstr || 'AND C.CshCode = ''' || v_CashierCode || ''' ';
	END IF;

	IF v_paymentMethod IS NOT NULL THEN
		sqlstr := sqlstr || 'AND C.CtxMeth = ''' || v_paymentMethod || ''' ';
	END IF;

	IF v_cardType IS NOT NULL THEN
		sqlstr := sqlstr || 'AND UPPER(TRIM(CD.CTNCTYPE)) = UPPER(''' || v_cardType || ''') ';
	END IF;

	IF v_amtFrom IS NOT NULL THEN
		sqlstr := sqlstr || 'AND CtxAmt >= '||v_amtFrom;
	END IF;

	IF v_amtTo IS NOT NULL THEN
		sqlstr := sqlstr || 'AND CtxAmt <= '||v_amtTo;
	END IF;

	IF v_sortBy IS NOT NULL THEN
		IF v_sortBy = 'D' THEN
			sqlstr := sqlstr || ' ORDER BY C.CtxTdate DESC, C.CtxSNo DESC';
		ELSIF v_sortBy = 'CT' THEN
			sqlstr := sqlstr || ' ORDER BY C.CtxTdate DESC, CD.CTNCTYPE ASC';
		END IF;
	ELSE
		sqlstr := sqlstr || ' ORDER BY C.CtxTdate DESC, C.CtxSNo DESC';
	END IF;

	OPEN outcur FOR sqlstr;
	RETURN outcur;
END NHS_LIS_CASHIERHISTORY;
/
