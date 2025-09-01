-- Schedule.bas / UpdateSchedule
CREATE OR REPLACE FUNCTION NHS_UTL_UpdateSchedule (
	i_Scheduleid    IN NUMBER,
	i_NewScheduleID IN NUMBER,
	i_StartTime     IN DATE,
	i_Endtime       IN DATE,
	i_Block         IN BOOLEAN := FALSE,
	i_UserID        IN VARCHAR2
)
	RETURN NUMBER
IS
	SCH_NORMAL VARCHAR(1) := 'N';
	SCH_CONFIRM VARCHAR(1) := 'F';
	SCH_BLOCK VARCHAR(1) := 'B';
	v_DocCode Schedule.DocCode%TYPE;
	v_SteCode Schedule.SteCode%TYPE;
	v_SchLen Schedule.SchLen%TYPE;
	v_SchNSlot Schedule.SchNSlot%TYPE;
	v_SchCnt Schedule.SchCnt%TYPE;
	v_SchSts Schedule.SchSts%TYPE;
	v_UsrID_B Schedule.UsrID_B%TYPE;
	v_SCHDATE_B Schedule.SCHDATE_B%TYPE;
	v_UsrID_U Schedule.UsrID_U%TYPE;
	v_SCHDATE_U Schedule.SCHDATE_U%TYPE;
	v_UsrID_C Schedule.UsrID_C%TYPE;
	v_SCHDATE_C Schedule.SCHDATE_C%TYPE;
	v_SchDesc Schedule.SCHDESC%TYPE;
	v_DocPractice Schedule.DocPractice%TYPE;
	v_RmkModUser Schedule.RmkModUser%TYPE;
	v_RmkModDate Schedule.RmkModDate%TYPE;
	v_DocLocID Schedule.DocLocID%TYPE;
	v_Count NUMBER;
	v_errmsg VARCHAR2(100);
	o_errcode NUMBER := -1;
BEGIN
	SELECT COUNT(1) INTO v_Count FROM Schedule WHERE SchID = i_Scheduleid;
	IF v_Count = 0 THEN
		-- no record found in schedule
		RETURN o_errcode;
	END IF;

	IF i_Block THEN
		UPDATE Booking SET BkgSts = SCH_BLOCK WHERE SchID = i_Scheduleid and BkgSts = SCH_NORMAL;
	ELSE
		UPDATE Slot SET SchID = i_NewScheduleID
		WHERE  SchID = i_Scheduleid
		AND    SltSTime >= i_StartTime
		AND    SltSTime <= i_Endtime;

		UPDATE Booking SET SchID = i_NewScheduleID
		WHERE  SchID = i_Scheduleid
		AND    BkgSDate >= i_StartTime
		AND    BkgSDate <= i_Endtime;
	END IF;

	-- extract schedule value
	SELECT DocCode, SteCode, SchLen, SchCnt, SchSts, UsrID_B, SCHDATE_B, UsrID_U, SCHDATE_U, UsrID_C, SCHDATE_C, SCHDESC, DocPractice, RmkModUser, RmkModDate, DocLocID
	INTO   v_DocCode, v_SteCode, v_SchLen, v_SchCnt, v_SchSts, v_UsrID_B, v_SCHDATE_B, v_UsrID_U, v_SCHDATE_U, v_UsrID_C, v_SCHDATE_C, v_SchDesc, v_DocPractice, v_RmkModUser, v_RmkModDate, v_DocLocID
	FROM   Schedule WHERE SchID = i_Scheduleid;

	-- amend value
	IF i_Block THEN
		v_UsrID_B := i_UserID;
		v_SCHDATE_B := SYSDATE;
		v_UsrID_C := i_UserID;
		v_SCHDATE_C := SYSDATE;
		v_SchSts := SCH_BLOCK;
	END IF;

	IF v_SchLen = 0 THEN
		v_SchNSlot := TRUNC(ROUND((((i_Endtime+ (1/1440)) - i_StartTime) * 1440 )) / 1);
	ELSE
		v_SchNSlot := TRUNC(ROUND((((i_Endtime+ (1/1440)) - i_StartTime) * 1440 )) / v_SchLen);
	END IF;

	SELECT COUNT(1) INTO v_SchCnt
	FROM   Booking
	WHERE  SchID = i_NewScheduleID AND BkgSts IN (SCH_NORMAL, SCH_CONFIRM);

	-- update schedule or insert new schedule
	IF i_Scheduleid = i_NewScheduleID THEN
		UPDATE SCHEDULE
		SET
			SchID = i_NewScheduleID,
			UsrID_B = v_UsrID_B,
			SCHDATE_B = v_SCHDATE_B,
			UsrID_C = v_UsrID_C,
			SCHDATE_C = v_SCHDATE_C,
			SchSts = v_SchSts,
			SchSDate = i_StartTime,
			SchEDate = i_Endtime,
			SchNSlot = v_SchNSlot,
			SchCnt = v_SchCnt
		WHERE SchID = i_Scheduleid;

		o_errcode := NHS_ACT_SYSLOG('MOD', 'Schedule', 'Modify Schedule for ' || v_DocCode || ' from ' || TO_CHAR(i_StartTime, 'DD/MM/YYYY HH24:MI') || ' to ' || TO_CHAR(i_Endtime, 'DD/MM/YYYY HH24:MI'), i_NewScheduleID, i_UserID, NULL, v_errmsg);
	ELSE
		INSERT INTO SCHEDULE(
			SchID,
			DocCode,
			SteCode,
			SchSDate,
			SchEDate,
			SchLen,
			SchNSlot,
			SchCnt,
			SchSts,
			UsrID_B,
			SCHDATE_B,
			UsrID_U,
			SCHDATE_U,
			UsrID_C,
			SCHDATE_C,
			SchDesc,
			DocPractice,
			RmkModUser,
			RmkModDate,
			DocLocID
		) VALUES (
			i_NewScheduleID,
			v_DocCode,
			v_SteCode,
			i_StartTime,
			i_Endtime,
			v_SchLen,
			v_SchNSlot,
			v_SchCnt,
			v_SchSts,
			v_UsrID_B,
			v_SCHDATE_B,
			v_UsrID_U,
			v_SCHDATE_U,
			v_UsrID_C,
			v_SCHDATE_C,
			v_SchDesc,
			v_DocPractice,
			v_RmkModUser,
			v_RmkModDate,
			v_DocLocID
		);

		o_errcode := NHS_ACT_SYSLOG('ADD', 'Schedule', 'Create Schedule for ' || v_DocCode || ' from ' || TO_CHAR(i_StartTime, 'DD/MM/YYYY HH24:MI') || ' to ' || TO_CHAR(i_Endtime, 'DD/MM/YYYY HH24:MI'), i_NewScheduleID, i_UserID, NULL, v_errmsg);
	END IF;

	o_errcode := 0;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -999;
END NHS_UTL_UpdateSchedule;
/
