CREATE OR REPLACE FUNCTION "NHS_ACT_SCHEDULE_RMK" (
	v_action  IN VARCHAR2,
	v_SchID   IN VARCHAR2,
	v_SchDesc IN VARCHAR2,
	v_usrid   IN VARCHAR2,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
BEGIN
	v_noOfRec := -1;
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO v_noOfRec FROM Schedule WHERE SchID = TO_NUMBER(v_SchID);
	IF v_noOfRec > 0 then
		UPDATE Schedule
		SET
			SchDesc = v_SchDesc,
			RmkModUser = v_usrid,
			RmkModDate = TO_DATE(to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
		WHERE SchID = TO_NUMBER(v_SchID);
	ELSE
		o_errmsg := 'Fail to update remark.';
		v_noOfRec := -1;
	END IF;

	RETURN v_noOfRec;
EXCEPTION
	WHEN   OTHERS   THEN
		v_noOfRec := -1;
		o_errmsg := 'Remark is too long.';
		ROLLBACK;
END NHS_ACT_SCHEDULE_RMK;
/
