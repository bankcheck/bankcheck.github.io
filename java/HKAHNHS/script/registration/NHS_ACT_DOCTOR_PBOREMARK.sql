CREATE OR REPLACE FUNCTION NHS_ACT_DOCTOR_PBOREMARK (
	v_action  IN VARCHAR2,
	v_DocCode IN VARCHAR2,
	v_Remark  IN VARCHAR2,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF v_action = 'MOD' THEN
		UPDATE DOCTOR_EXTRA SET PBO_REMARK = v_Remark WHERE DOCCODE = v_DocCode;
	ELSE
		o_errmsg := 'Fail to update PBO remark.';
	END IF;

	return o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errcode := -1;
	o_errmsg := 'Fail to update PBO remark due to ' || SQLERRM;
	RETURN o_errcode;
END NHS_ACT_DOCTOR_PBOREMARK;
/
