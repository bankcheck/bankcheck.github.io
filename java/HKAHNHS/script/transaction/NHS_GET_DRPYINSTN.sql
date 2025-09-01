create or replace
FUNCTION "NHS_GET_DRPYINSTN"(
  V_SLPNO VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
  v_noOfRec NUMBER;
  V_PATNO VARCHAR2(20);
BEGIN

  select patno into v_patno from slip where slpno= V_SLPNO;
  IF v_patno is not null THEN
      SELECT count(1) into v_noOfRec
      FROM   PATALTLINK P, ALERT A
      WHERE  P.ALTID = A.ALTID
      AND    P.PATNO = v_PATNO
      AND    P.USRID_C IS NULL
      AND    P.ALTID IN ('43','44','45','46','47');
  END IF;
  
	OPEN outcur FOR
      SELECT a.doccode,a.docfname|| ' '|| a.docgname,a.payinstruction,e.smdinstruction
    FROM doctor a,
      (SELECT DISTINCT doccode,slpno FROM
        (SELECT DISTINCT doccode,slpno
        FROM sliptx
        WHERE stnsts = 'N'
        AND slpno    = V_SLPNO
        UNION
        SELECT doccode, slpno FROM slip WHERE slpno= V_SLPNO)) b,
        DOCTOR_EXTRA e
      WHERE a.DocCode = b.DocCode 
      AND a.doccode = e.doccode(+)  
      and (payinstruction is not null or (e.smdinstruction is not null and v_noOfRec > 0));
  
	RETURN OUTCUR;
END NHS_GET_DRPYINSTN;
/