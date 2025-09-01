CREATE OR REPLACE FUNCTION "NHS_LIS_ITEM_WITHSUPP" (
	v_patno IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	OUTCUR types.cursor_type;
BEGIN
	OPEN OUTCUR FOR
	SELECT ST.DIXREF as STNID, TO_CHAR(REG.REGDATE, 'DD/MM/YYYY'), REG.REGTYPE, ST.SLPNO, ST.ITMCODE, ITM.ITMNAME,
             SUM(stnnamt) AS stnnamt, ST.DOCCODE AS DRCODE, D.DOCFNAME || ' ' || D.DOCGNAME AS DRNAME,
             MAX(TO_CHAR(st.stntdate, 'DD/MM/YYYY')) AS txndate
    FROM     sliptx st, slip s, item itm, doctor d, Reg reg
    WHERE    st.slpno = s.slpno AND st.itmcode = itm.itmcode AND st.doccode = d.doccode
    AND      s.regid = reg.regid
    AND      s.patno = v_patno
    GROUP BY ST.DIXREF, REG.REGDATE,
             REG.REGTYPE, ST.SLPNO, ST.ITMCODE, ITM.ITMNAME, ST.DOCCODE, D.DOCFNAME || ' ' || D.DOCGNAME
    HAVING  (SELECT COUNT(1) FROM txnendosdtls WHERE stnid = st.dixref) > 0
    ORDER BY reg.regdate DESC, txndate DESC;

	RETURN OUTCUR;
END NHS_LIS_ITEM_WITHSUPP;
/
