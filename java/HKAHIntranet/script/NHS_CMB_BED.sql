create or replace
FUNCTION      "NHS_CMB_BED" RETURN Types.CURSOR_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN OUTCUR FOR
      SELECT BEDCODE, BEDDESC
      FROM BED@IWEB
      WHERE  BEDSTS='F'
      ORDER BY BEDCODE ;
   RETURN OUTCUR;
end NHS_CMB_BED;