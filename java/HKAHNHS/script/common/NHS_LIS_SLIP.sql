CREATE OR REPLACE FUNCTION "NHS_LIS_SLIP"
(
	v_SLPNO SLIP.SLPNO%TYPE
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
	SELECT  S.SLPNO,
          P.PATNO,
          I.BEDCODE,
          A.AcmCode,
          R.DOCCODE,
          R.REGDATE,
          D.DOCFNAME || ' ' || D.DOCGNAME AS DOCNAME,
          P.PATFNAME || ' ' || P.PATGNAME AS PATNAME
	FROM    SLIP S, INPAT I, ACM A, REG R,  PATIENT P, DOCTOR D
	WHERE   S.SLPNO = v_SLPNO
	AND     S.SLPNO = R.SLPNO
	AND     R.INPID = I.INPID
	AND     A.AcmCode = i.AcmCode
	AND     P.PATNO = S.PATNO
	AND     d.DocCode = R.DocCode;
	RETURN OUTCUR;
END NHS_LIS_SLIP;
/


