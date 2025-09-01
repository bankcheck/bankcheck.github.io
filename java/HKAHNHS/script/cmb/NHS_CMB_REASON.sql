CREATE OR REPLACE FUNCTION NHS_CMB_REASON
  RETURN Types.CURSOR_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN OUTCUR FOR
      SELECT r.rsncode, r.rsndesc
      FROM REASON r
      WHERE ROWNUM < 100
      ORDER BY r.rsndesc;
   RETURN OUTCUR;
END NHS_CMB_REASON;
/


