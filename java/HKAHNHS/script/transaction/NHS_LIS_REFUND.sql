CREATE OR REPLACE FUNCTION "NHS_LIS_REFUND"(v_SlpNo IN VARCHAR2)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
BEGIN
	OPEN OUTCUR FOR
	SELECT
		st.stnnamt, st.usrid, dt.refno,dt.ctntid,TO_CHAR(st.stncdate, 'dd/mm/yyyy'),
		TO_CHAR(DECODE(ct.ctxmeth, 'O', ct.ctxtdate,'D' ,dt.ctntdate,'E', dt.ctntdate,'T', dt.ctntdate, 'U', dt.ctntdate, st.stntdate), 'dd/mm/yyyy') AS stntdate,
		st.stndesc,
		DECODE(st.stntype, 'P', '', dt.ctnctype) as ctnctype,
		DECODE(st.stntype, 'P', '', dt.ctncno) AS ctncno,
		DECODE(st.stntype,'P', '', dt.ctnhold) as ctnhold,
		DECODE(st.stntype, 'P', '', dt.ctntrace) AS ctntrace,
		DECODE(st.stntype,'P', '', SUBSTR(dt.ctnexp, 3, 2) || SUBSTR(dt.ctnexp, 1, 2)) AS ctnexp,
		st.itmcode, st.stnid, st.stnseq, st.doccode
	FROM  Sliptx st, Cashtx ct, Cardtx dt
	WHERE st.slpno = v_SlpNo
	AND   st.stntype in ('S', 'P')
	AND   st.stnxref = ct.ctxid (+)
	AND   ct.ctnid = dt.ctnid (+)
	AND   st.stnsts IN ('N', 'A');

	RETURN OUTCUR;
END NHS_LIS_REFUND;
/
