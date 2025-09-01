create or replace
FUNCTION "NHS_CMB_TASK"
(
	p_project_id IN VARCHAR2,
  p_module_id IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
    select distinct pmp_task_id
		FROM   pmp_task
		WHERE  ROWNUM < 100 and
           pmp_project_id = p_project_id and
           pmp_module_id = p_module_id
		ORDER  BY pmp_task_id  ;
	RETURN outcur;
END NHS_CMB_TASK;