create or replace FUNCTION NHS_GET_ECGGETSLIPINFO(
	v_SLPNO IN VARCHAR2
)
	RETURN TYPES.cursor_type
AS
	OUTCUR TYPES.cursor_type;
BEGIN
	OPEN OUTCUR FOR
        SELECT    
        S.SLPNO,
        S.PATNO,
        S.SLPTYPE,
        S.DOCCODE,
        I.ACMCODE,
        S.SLPHDISC,
        S.SLPDDISC,
        S.SLPSDISC,
        I.BEDCODE
        FROM    SLIP S, REG R, INPAT I 
        WHERE   S.SLPNO = v_SLPNO
        AND     S.SLPNO = R.SLPNO(+)
        AND     R.INPID = I.INPID(+);
	RETURN OUTCUR;
END NHS_GET_ECGGETSLIPINFO;