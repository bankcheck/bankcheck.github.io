create or replace
FUNCTION "NHS_ACT_BOOKING_CHECK"(
	i_action       IN VARCHAR2,
	i_BkgID        IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_UsrID        IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	RETURN  NUMBER
AS
	v_Count    NUMBER;
	v_errcode  NUMBER := -1;
	v_RegState VARCHAR2(1);
	v_BkgSDate DATE;

	SCH_BLOCK VARCHAR2(1) := 'B';
	SCH_CANCEL VARCHAR2(1) := 'C';
	SCH_CONFIRM VARCHAR2(1) := 'F';

	MSG_24_HOUR VARCHAR2(40) := 'Cannot confirm appointment 24 hours ago.';
	MSG_BOOKING_LOCK VARCHAR2(43) := 'Appointment record is locked by other user.';
	MSG_APPOINTMENT_BLOCKED VARCHAR2(51) := 'Selected appointment is blocked for further action.';
	MSG_APPOINTMENT_CANCELLED VARCHAR2(34) := 'Selected appointment is cancelled.';
	MSG_APPOINTMENT_CONFIRMED VARCHAR2(41) := 'Selected appointment has been registered.';
BEGIN
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO v_Count FROM Booking WHERE BkgID = i_BkgID;
	IF v_Count != 1 THEN
		o_errmsg := 'Selected appointment is not found.';
		RETURN v_errcode;
	END IF;

	-- bCanReg
	SELECT BkgSts, BkgSDate INTO v_RegState, v_BkgSDate FROM Booking WHERE BkgID = i_BkgID;
	IF v_RegState = SCH_BLOCK THEN
		o_errmsg := MSG_APPOINTMENT_BLOCKED;
		RETURN v_errcode;
	ELSIF v_RegState = SCH_CANCEL THEN
		o_errmsg := MSG_APPOINTMENT_CANCELLED;
		RETURN v_errcode;
	ELSIF v_RegState = SCH_CONFIRM THEN
		o_errmsg := MSG_APPOINTMENT_CONFIRMED;
		RETURN v_errcode;
	END IF;

	-- more than 24 hours
	SELECT SYSDATE - v_BkgSDate INTO v_Count FROM DUAL;
	IF v_Count > 1 THEN
		o_errmsg := MSG_24_HOUR;
		RETURN v_errcode;
	END IF;

	v_errcode := NHS_ACT_RecordLock('', 'Booking', i_BkgID, i_ComputerName, i_UsrID, o_errmsg);
	IF v_errcode < 0 THEN
		o_errmsg := MSG_BOOKING_LOCK;
		RETURN v_errcode;
	END IF;

	v_errcode := 0;

	RETURN v_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errmsg := 'Fail to select the appointment.';
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	return -1;
END NHS_ACT_BOOKING_CHECK;
/
