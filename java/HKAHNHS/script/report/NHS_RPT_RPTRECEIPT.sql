CREATE OR REPLACE FUNCTION NHS_RPT_RPTRECEIPT (
	v_SDate      VARCHAR2,
	v_EDate      VARCHAR2,
	v_SteCode    VARCHAR2,
	v_ReportType VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	CASHTX_PATIENT_RELATED VARCHAR2(1) := 'P';
BEGIN
	IF v_ReportType = 'N' THEN
		OPEN outcur FOR
			SELECT
				cs.usrid,
				ct.ctxsno,
				ct.ctxname,
				ct.ctxamt,
				ct.slpno as ctxdesc,
				TO_CHAR(ct.ctxcdate, 'dd/mm/yyyy') ctxcdate,
				decode(ct.ctxmeth,'C', 'Cash', 'D', 'Credit Card', 'E', 'EPS', 'Q', 'Cheque', 'A', 'Autopay','R', 'WECHAT/ALI PAY', 'U', 'CUP', 'T', 'OCTOPUS') as ctxmeth,
				sit.stename,
				cd.ctnctype,
				DECODE(Nvl(r.regtype, 'O'), 'D', 'Day Case', 'I', 'In-Patient', 'O', 'Out-Patient', 'Z', 'Non-Patient') as regtype
			FROM  cashtx ct, cashier cs, site sit, cardtx cd, reg r,slip s
			WHERE ct.ctxtdate >= TO_DATE(v_SDate, 'DD/MM/YYYY')
			AND   ct.ctxtdate < TO_DATE(v_EDate, 'DD/MM/YYYY') + 1
			AND   ct.slpno = s.slpno
			AND   s.regid = r.regid (+)
			AND   ct.ctxtype = 'R'
			AND   ct.ctxcat = CASHTX_PATIENT_RELATED
			AND ((ct.ctxsts IN ('N', 'R') AND TO_CHAR(ct.ctxtdate, 'DD/MM/YYYY') != TO_CHAR(ct.ctxcdate, 'DD/MM/YYYY'))
			OR   (ct.ctxsts = 'V' AND TO_CHAR(ct.ctxvdate, 'DD/MM/YYYY') != TO_CHAR(ct.ctxcdate, 'DD/MM/YYYY')))
			AND   ct.ctnid = cd.ctnid(+)
			AND   ct.cshcode = cs.cshcode
			AND   cs.stecode= v_SteCode
			AND   cs.stecode = sit.stecode ;
	ELSE
		OPEN outcur FOR
			SELECT
				cs.usrid,
				ct.ctxsno,
				ct.ctxname,
				ct.ctxamt,
				ct.slpno as ctxdesc,
				TO_CHAR(ct.ctxcdate, 'dd/mm/yyyy') ctxcdate,
				decode(ct.ctxmeth,'C', 'Cash', 'D', 'Credit Card', 'E', 'EPS', 'Q', 'Cheque', 'A', 'Autopay','R', 'WECHAT/ALI PAY', 'U', 'CUP', 'T', 'OCTOPUS') as ctxmeth,
				sit.stename,
				cd.ctnctype,
				DECODE(Nvl(r.regtype, 'O'), 'D', 'Day Case', 'I', 'In-Patient', 'O', 'Out-Patient', 'Z', 'Non-Patient') as regtype
			FROM  cashtx ct, cashier cs, site sit, cardtx cd, reg r,slip s
			WHERE ct.ctxcdate >= TO_DATE(v_SDate, 'DD/MM/YYYY')
			AND   ct.ctxcdate < TO_DATE(v_EDate, 'DD/MM/YYYY') + 1
			AND   ct.slpno = s.slpno
			AND   s.regid = r.regid (+)
			AND   ct.ctxtype = 'R'
			AND   ct.ctxcat = CASHTX_PATIENT_RELATED
			AND   ct.ctxsts IN ('N', 'V', 'R')
			AND   ct.ctnid = cd.ctnid(+)
			AND   ct.cshcode = cs.cshcode
			AND   cs.stecode= v_SteCode
			AND   cs.stecode = sit.stecode ;
	END IF;

	RETURN outcur;
END NHS_RPT_RPTRECEIPT;
/
