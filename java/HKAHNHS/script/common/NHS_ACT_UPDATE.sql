CREATE OR REPLACE FUNCTION "NHS_ACT_UPDATE" (
	v_action   IN VARCHAR2,
	v_table    IN varchar2,
	v_value    IN varchar2,
	v_criteria IN varchar2,
	o_errmsg   OUT VARCHAR2
 )
	return number
AS
	sqlbuf varchar2(500);
	o_errcode	NUMBER;
BEGIN
	o_errcode:=0;
	o_errmsg:='ok';

	sqlbuf:='UPDATE ' || v_table || ' SET ' || v_value || ' WHERE 1=1 ';
	IF v_criteria IS NOT NULL THEN
		sqlbuf := sqlbuf ||' AND ' || v_criteria;
	END IF;

	EXECUTE IMMEDIATE sqlbuf;
	IF sql%rowcount = 0 THEN
		o_errcode := -1;
		o_errmsg:='fail to update data.';
	END IF;
	RETURN o_errcode;

EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;

	RETURN -999;
END NHS_ACT_UPDATE;
/


