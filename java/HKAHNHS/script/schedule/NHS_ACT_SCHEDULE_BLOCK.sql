CREATE OR REPLACE FUNCTION "NHS_ACT_SCHEDULE_BLOCK" (
	i_action   IN VARCHAR2,
	i_SchID    IN VARCHAR2,
	i_SchSDate IN VARCHAR2,
	i_SchEDate IN VARCHAR2,
	i_usrid    IN VARCHAR2,
	o_errmsg   OUT VARCHAR2)
RETURN  NUMBER
AS
	o_errcode0 NUMBER;
	o_errcode1 NUMBER;
	v_SchSDate VARCHAR2(20);
	v_SchEDate VARCHAR2(20);
	v_Scheduleid NUMBER;
	v_NewScheduleID NUMBER;
	v_BlockStartTime DATE;
	v_BlockEndTime DATE;
	v_StartTime DATE;
	v_Endtime DATE;
BEGIN
	o_errcode0 := 0;
	o_errmsg := 'OK';
	v_Scheduleid := TO_NUMBER(i_SchID);

	IF LENGTH(i_SchSDate) > 16 THEN
		v_SchSDate := SUBSTR(i_SchSDate, 0, 16);
	ELSE
		v_SchSDate := i_SchSDate;
	END IF;

	IF LENGTH(i_SchEDate) > 16 THEN
		v_SchEDate := SUBSTR(i_SchEDate, 0, 16);
	ELSE
		v_SchEDate := i_SchEDate;
	END IF;

	v_BlockStartTime := TO_DATE(v_SchSDate, 'DD/MM/YYYY HH24:MI');
	v_BlockEndTime := TO_DATE(v_SchEDate, 'DD/MM/YYYY HH24:MI');

	SELECT count(1) INTO o_errcode1 FROM SCHEDULE WHERE SchID = v_Scheduleid;
	if o_errcode1 > 0 then
		SELECT SchSDate, SchEDate into v_StartTime, v_Endtime from SCHEDULE where SchID = v_Scheduleid;

		IF v_BlockStartTime - v_StartTime > 0 THEN
			SELECT SEQ_SCHEDULE.NEXTVAL INTO v_NewScheduleID FROM DUAL;

			o_errcode1 := NHS_UTL_UpdateSchedule(v_Scheduleid, v_NewScheduleID, v_StartTime, v_BlockStartTime - (1/1440), FALSE, i_usrid);
			IF o_errcode1 < 0 THEN
				o_errmsg := 'Fail to block schedule.';
				RETURN o_errcode1;
			END IF;
		END IF;
		IF v_Endtime - v_BlockEndTime > 0 THEN
			SELECT SEQ_SCHEDULE.NEXTVAL INTO v_NewScheduleID FROM DUAL;

			o_errcode1 := NHS_UTL_UpdateSchedule(v_Scheduleid, v_NewScheduleID, v_BlockEndTime + (1/1440), v_Endtime, FALSE, i_usrid);
			IF o_errcode1 < 0 THEN
				o_errmsg := 'Fail to block schedule.';
				RETURN o_errcode1;
			ELSE
				o_errcode0 := v_NewScheduleID;
			END IF;
		END IF;
		o_errcode1 := NHS_UTL_UpdateSchedule(v_Scheduleid, v_Scheduleid, v_BlockStartTime, v_BlockEndTime, TRUE, i_usrid);
		IF o_errcode1 < 0 THEN
			o_errmsg := 'Fail to block schedule.';
			RETURN o_errcode1;
		END IF;
	ELSE
		o_errcode1 := -1;
		o_errmsg := 'Fail to change the appointment detail.';
	END IF;

	RETURN o_errcode0;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -999;
END NHS_ACT_SCHEDULE_BLOCK;
/
