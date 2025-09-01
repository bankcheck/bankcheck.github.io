CREATE OR REPLACE FUNCTION "NHS_ACT_SCHEDULE_UNBLOCK" (
	i_Action IN VARCHAR2,
	i_SchID  IN VARCHAR2,
	i_UsrID  IN VARCHAR2,
	o_errmsg OUT VARCHAR2
)
	RETURN  NUMBER
AS
	v_noOfRec NUMBER;
	v_SchCount NUMBER;
	SCH_NORMAL VARCHAR2(1) := 'N';
	SCH_BLOCK VARCHAR2(1) := 'B';
	SCH_CONFIRM VARCHAR2(1) := 'F';
BEGIN
	v_noOfRec := -1;
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO v_noOfRec FROM Schedule WHERE SchID = TO_NUMBER(i_SchID) AND SchSts = SCH_BLOCK;
	IF v_noOfRec > 0 THEN
		UPDATE Booking SET BkgSts = SCH_NORMAL WHERE SchID = TO_NUMBER(i_SchID) AND BkgSts = SCH_BLOCK;

		SELECT COUNT(1) INTO v_SchCount FROM Booking WHERE SchID = TO_NUMBER(i_SchID) AND BkgSts IN (SCH_NORMAL, SCH_CONFIRM);

		UPDATE Schedule
		SET
			SchSts = SCH_NORMAL,
			UsrID_U = i_UsrID,
			SCHDATE_U = SYSDATE,
			UsrID_C = i_UsrID,
			SCHDATE_C = SYSDATE,
			SchCnt = v_SchCount
		WHERE SchID = TO_NUMBER(i_SchID);
  	ELSE
		v_noOfRec := -1;
		o_errmsg := 'Schedule is not currently blocked.';
	END IF;

	RETURN v_noOfRec;
EXCEPTION
WHEN OTHERS THEN
	o_errmsg := 'Fail to unblock schedule.';
	ROLLBACK;
	RETURN -1;
END NHS_ACT_SCHEDULE_UNBLOCK;
/
