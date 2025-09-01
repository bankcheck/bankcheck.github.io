create or replace
FUNCTION      "NHS_GET_ISSHWPYINSTN"(
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
  SELECT count(1)
  FROM DOCTOR D, DOCTOR_EXTRA E
  WHERE 
  D.DOCCODE = E.DOCCODE(+)
  AND (D.payinstruction is not null or (E.SMDINSTRUCTION is not null and v_noOfRec > 0))
  and (D.doccode in (select distinct doccode from sliptx where stnsts = 'N' and slpno = V_SLPNO) 
  or D.doccode in (select doccode  from slip where slpno = V_SLPNO));
  
	RETURN OUTCUR;
END NHS_GET_ISSHWPYINSTN;
/