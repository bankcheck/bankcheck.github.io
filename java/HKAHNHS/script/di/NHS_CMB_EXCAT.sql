create or replace
FUNCTION "NHS_CMB_EXCAT"
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
    SELECT
      ECCCODE, ''
    FROM EXCAT
    ORDER BY ECCCODE;
  RETURN outcur;
end NHS_CMB_EXCAT;