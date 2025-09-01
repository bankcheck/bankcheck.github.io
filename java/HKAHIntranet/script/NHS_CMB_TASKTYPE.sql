create or replace
FUNCTION "NHS_CMB_TASKTYPE"
   RETURN Types.cursor_type
AS
   outcur types.cursor_type;
BEGIN
   OPEN outcur FOR
  select distinct pmp_task_type
  from pmp_task
           WHERE  ROWNUM < 100
           ORDER  BY pmp_task_type;
   RETURN outcur;
END NHS_CMB_TASKTYPE;