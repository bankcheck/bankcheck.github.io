create or replace
FUNCTION "NHS_CMB_MODULE"
(
	p_project_id IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
    select distinct pmp_module_id
		FROM   pmp_task
		WHERE  ROWNUM < 100 and
           pmp_project_id = p_project_id
		ORDER  BY pmp_module_id;
	RETURN outcur;
END NHS_CMB_MODULE;