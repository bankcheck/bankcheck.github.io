create or replace
FUNCTION "NHS_LIS_ECGQUEUER_REMOVE_DR"(
  v_xrgid IN VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR  
    select docCode from xreport where xrgid = '' || v_xrgid || '';
    
    --549001
  
  RETURN OUTCUR;
END NHS_LIS_ECGQUEUER_REMOVE_DR;