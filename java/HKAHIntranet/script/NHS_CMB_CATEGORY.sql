create or replace
FUNCTION "NHS_CMB_CATEGORY"
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
  select distinct pmp_service_cat
		FROM   pmp_task
		WHERE  ROWNUM < 100
		ORDER  BY pmp_service_cat;
	RETURN outcur;
END NHS_CMB_CATEGORY;