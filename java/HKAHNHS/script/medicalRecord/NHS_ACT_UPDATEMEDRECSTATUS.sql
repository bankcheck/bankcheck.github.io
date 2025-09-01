create or replace
FUNCTION "NHS_ACT_UPDATEMEDRECSTATUS" (
	v_action IN VARCHAR2,
	v_MRDID  IN VARCHAR2,
	o_errmsg OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';
 
  UPDATE MEDRECDTL 
  SET MRDSTS = 'R'
  WHERE MRDID = v_MRDID
  AND MRDSTS = 'T';
  
	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	o_errcode := -1;
	o_errmsg := 'Fail to UPDATE.';
	ROLLBACK;

	RETURN o_errcode;
END NHS_ACT_UPDATEMEDRECSTATUS;
/
