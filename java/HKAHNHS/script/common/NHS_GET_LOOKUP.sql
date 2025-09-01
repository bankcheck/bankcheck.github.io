CREATE OR REPLACE FUNCTION "NHS_GET_LOOKUP" (
	v_table    IN varchar2,
	v_result   IN varchar2,
	v_criteria IN varchar2
)
	RETURN Types.cursor_type
AS
BEGIN
	RETURN NHS_LIS_LOOKUP(v_table, v_result, v_criteria);
END NHS_GET_LOOKUP;
/
