create or replace
FUNCTION "NHS_CMB_LOCATION"
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
      SELECT LOCCODE,LOCNAME
      FROM LOCATION@IWEB
      WHERE ROWNUM < 100
      ORDER BY LOCNAME;
      RETURN outcur;
END NHS_CMB_LOCATION;