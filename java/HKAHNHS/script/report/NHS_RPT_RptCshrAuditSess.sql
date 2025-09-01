CREATE OR REPLACE FUNCTION "NHS_RPT_RPTCSHRAUDITSESS" (
  v_SteCode VARCHAR2,
  v_CashierCode varchar2,
  v_CshSID varchar2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
	SELECT Type, ctxmeth, ctnctype, ctxtype, ctxsno, ctxname, ctxdesc, ctxamt
	FROM (
		SELECT
			'Normal' as Type,
			ct.ctxmeth,
			cd.ctnctype,
			ct.ctxtype,
			ct.ctxsno,
			ct.ctxname,
			ct.ctxdesc,
			ct.ctxamt
		FROM  cardtx cd, cashtx ct, cashier cs, site sit
		WHERE ct.cshcode = v_CashierCode
		AND   ct.cshsid = v_CshSID
		AND   cs.stecode = v_SteCode
		AND   ct.ctnid = cd.ctnid(+)
		AND   ct.cshcode= cs.cshcode
		AND   ct.ctxsts IN ('N','V')
		AND   cs.stecode= sit.stecode
	UNION ALL
		-- only for Receipt(payment) --CASHTX_TXNTYPE_RECEIVE
		SELECT
			decode(ct.cshsid, ct1.cshsid, 'Voided Items (This Session)', 'Voided Items (Other Session)') as Type,
			ct.ctxmeth,
			cd.ctnctype,
			ct.ctxtype,
			ct.ctxsno,
			ct.ctxname,
			ct.ctxdesc,
			ct.ctxamt
		FROM  cardtx cd, cashtx ct, cashier cs, site sit, cashtx ct1
		WHERE ct.cshcode = v_CashierCode
		AND   ct.cshsid = v_CshSID
		AND   cs.stecode = v_SteCode
		AND   ct.ctnid = cd.ctnid(+)
		AND   ct.cshcode = cs.cshcode
		AND   ct.ctxsts = 'R'
		AND   cs.stecode = sit.stecode
		AND   ct.ctxtype = ct1.ctxtype
		AND   ct.ctxsno = ct1.ctxsno
		AND   ct1.ctxsts = 'V'    -- CASHTX_STS_VOID
	UNION ALL
		-- only for Payout(Refund) --CASHTX_TXNTYPE_PAYOUT
		SELECT
			'Voided Items (Payout)' as Type,
			ct.ctxmeth,
			cd.ctnctype,
			ct.ctxtype,
			ct.ctxsno,
			ct.ctxname,
			ct.ctxdesc,
			ct.ctxamt
		FROM  cardtx cd, cashtx ct, cashier cs, site sit
		WHERE ct.cshcode = v_CashierCode
		AND   ct.cshsid = v_CshSID
		AND   cs.stecode = v_SteCode
		AND   ct.ctnid = cd.ctnid(+)
		AND   ct.cshcode = cs.cshcode
		AND   ct.ctxsts = 'R'
		AND   cs.stecode = sit.stecode
		AND   ct.ctxsno is null
	)
	RIGHT JOIN 
    	(SELECT NULL, NULL, NULL, NULL, NULL, NULL, NULL FROM DUAL) ON 1=1
	ORDER BY Type, ctxmeth, ctnctype, ctxtype, ctxsno, ctxname, ctxdesc, ctxamt;
	RETURN OUTCUR;
END NHS_RPT_RPTCSHRAUDITSESS;
/

