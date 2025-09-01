create or replace
FUNCTION "NHS_LIS_LOOKUP" (
 v_table      IN varchar2,
 v_result     IN varchar2,
 v_criteria   IN varchar2
 )
  RETURN Types.cursor_type
AS
  outcur Types.cursor_type;
  sqlbuf varchar2(500);
BEGIN
   sqlbuf:='select '|| v_result||' from '||v_table||'@IWEB where '||v_criteria;
   open outcur for sqlbuf;
   RETURN outcur;
end NHS_LIS_LOOKUP;