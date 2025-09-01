CREATE OR REPLACE FUNCTION NHS_CMB_OTCTYPE
  RETURN Types.CURSOR_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN OUTCUR FOR
      SELECT distinct c.otctype
      FROM OT_CODE c
      --WHERE ROWNUM < 100
      ORDER BY otctype;
   RETURN OUTCUR;
END NHS_CMB_OTCTYPE;
/


