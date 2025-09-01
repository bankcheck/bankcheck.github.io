create or replace function NHS_CMB_PURSE
 RETURN Types.CURSOR_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN OUTCUR FOR
      SELECT seq,purpose
      FROM callchartpurpose
      ORDER BY purpose;
   RETURN OUTCUR;
end NHS_CMB_PURSE;
/
