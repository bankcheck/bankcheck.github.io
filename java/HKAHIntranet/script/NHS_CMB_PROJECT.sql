create or replace
FUNCTION "NHS_CMB_PROJECT"
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
--    select distinct pmp_project_id
--		FROM   pmp_project
--		WHERE  ROWNUM < 100 and
--           pmp_project_id like '%'
--		ORDER  BY pmp_project_id;
    select distinct pmp_project_id
		FROM   pmp_task
--		WHERE  ROWNUM < 100 and
--           pmp_project_id like '%'
		ORDER  BY pmp_project_id;

	RETURN outcur;
END NHS_CMB_PROJECT;