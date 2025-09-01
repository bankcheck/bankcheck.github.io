create or replace
FUNCTION "NHS_CMB_PORTAL_USER"
( i_deptCode VARCHAR2 )
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
  IF i_deptCode = 'ALL' THEN
    OPEN outcur FOR
      SELECT CO_STAFF_ID, CO_STAFFNAME
      FROM   CO_STAFFS
      ORDER  BY CO_STAFFNAME;
  ELSE
    OPEN outcur FOR
      SELECT CO_STAFF_ID, CO_STAFFNAME
      FROM   CO_STAFFS
      WHERE  CO_DEPARTMENT_CODE = i_deptCode
      ORDER  BY CO_STAFFNAME;
  END IF;
	RETURN outcur;
END NHS_CMB_PORTAL_USER;