create or replace
FUNCTION           NHS_CMB_OBCERT(
	v_comBoType IN VARCHAR2
)
RETURN Types.CURSOR_type
AS
	outcur types.cursor_type;
  sqlbuff VARCHAR2(2000);

BEGIN
  IF v_comBoType = 'status' THEN
    sqlbuff := 'SELECT level, CASE WHEN level = 1  Then ''Valid'' 
                                 WHEN level = 2  THEN ''Invalid / Cancellation of Booking''
                                 WHEN level = 3  THEN ''Invalid / Replacement for Certificate'' END VALUE
                                 FROM DUAL CONNECT BY level <=3';
  ELSIF v_comBoType = 'repltrsn' THEN
    sqlbuff := 'SELECT level, CASE WHEN level = 1  Then ''Damaged Certificate'' 
                                 WHEN level = 2  THEN ''Printing Problem''
                                 WHEN level = 3  THEN ''Wrong Data'' END VALUE
                                 FROM DUAL CONNECT BY level <=3';                                 
  END IF;
OPEN OUTCUR FOR sqlbuff;
	RETURN OUTCUR;
END NHS_CMB_OBCERT;
/
