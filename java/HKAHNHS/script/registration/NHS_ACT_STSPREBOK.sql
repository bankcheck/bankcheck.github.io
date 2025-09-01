CREATE OR REPLACE FUNCTION NHS_ACT_STSPREBOK (
	v_action       IN VARCHAR2,
	v_computername IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF v_action = 'MOD' THEN
		UPDATE STSPREBOK SET ENDDATE = SYSDATE WHERE COMPUTERNAME = v_computername AND ENDDATE IS NULL;
	ELSE
		o_errmsg := 'update error.';
	END IF;

	return o_errcode;
END NHS_ACT_STSPREBOK;
/
