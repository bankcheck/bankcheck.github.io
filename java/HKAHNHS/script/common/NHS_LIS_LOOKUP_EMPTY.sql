create or replace
FUNCTION NHS_LIS_LOOKUP_EMPTY (
 v_table      IN varchar2,
 v_result     IN varchar2,
 v_criteria   IN varchar2
 )
  RETURN Types.cursor_type
AS
  outcur Types.cursor_type;
  sqlbuf varchar2(2000);
BEGIN
   sqlbuf:=v_table;
   open outcur for sqlbuf;
   RETURN OUTCUR;
END NHS_LIS_LOOKUP_EMPTY;
/