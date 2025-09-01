CREATE OR REPLACE FUNCTION "NHS_UTL_BOOKING_CANCEL_LOG" (
	i_SchID IN VARCHAR2,
	i_BkgID IN VARCHAR2,
	i_StartTime  IN DATE,
	i_Endtime  IN DATE,
	i_UsrID  IN VARCHAR2,
	o_errmsg OUT VARCHAR2
)
	RETURN  NUMBER
AS
	v_noOfRec NUMBER;
	OUTCUR TYPES.CURSOR_TYPE;
	o_errcode NUMBER;
	v_SLTID NUMBER;
	v_SltCnt NUMBER;
	v_SchCnt NUMBER;
	v_syslog_remark VARCHAR2(500);
BEGIN
	-- debug SLOT.SLTCNT < 0
	v_noOfRec := 0;
	o_errmsg := 'OK';

	-- debug log start
	SELECT count(1) INTO v_noOfRec FROM Schedule WHERE SchID = i_SchID;
	IF v_noOfRec <= 0 THEN
		v_syslog_remark := 'BkgID=' || i_BkgID ||', SchID=' || i_SchID || ' (No schedule found), StartTime=' || to_char(i_StartTime, 'dd/mm/yyyy hh24:mi:ss') || ', Endtime=' || to_char(i_Endtime, 'dd/mm/yyyy hh24:mi:ss');
		o_errcode := NHS_ACT_SYSLOG('ADD', 'Appointment', 'Cancel Booking', v_syslog_remark, i_USRID, NULL, o_errmsg);
	ELSIF v_noOfRec = 1 THEN
		SELECT SchCnt INTO v_SchCnt FROM Schedule WHERE SchID = i_SchID;
		
		OPEN OUTCUR FOR
			SELECT SLTID, SltCnt FROM SLOT WHERE SchID = i_SchID AND SltSTime BETWEEN i_StartTime AND i_Endtime;
		LOOP
			FETCH OUTCUR INTO v_SLTID, v_SltCnt;
			EXIT WHEN OUTCUR%NOTFOUND;
			
			v_syslog_remark := 'BkgID=' || i_BkgID ||', SchID=' || i_SchID || ', SLTID=' || v_SLTID  || ', StartTime=' || to_char(i_StartTime, 'dd/mm/yyyy hh24:mi:ss') || ', Endtime=' || to_char(i_Endtime, 'dd/mm/yyyy hh24:mi:ss') || ', old SltCnt=' || v_SltCnt  || ', old SchCnt=' || v_SchCnt;
			o_errcode := NHS_ACT_SYSLOG('ADD', 'Appointment', 'Cancel Booking', v_syslog_remark, i_USRID, NULL, o_errmsg);
			IF o_errcode >= 0 THEN
				v_noOfRec := v_noOfRec + 1;
			END IF;
		END LOOP;
		CLOSE OUTCUR;
	ELSE
		v_syslog_remark := 'BkgID=' || i_BkgID ||', SchID=' || i_SchID || ' (Schedule ID not unique: ' || v_noOfRec || '), StartTime=' || to_char(i_StartTime, 'dd/mm/yyyy hh24:mi:ss') || ', Endtime=' || to_char(i_Endtime, 'dd/mm/yyyy hh24:mi:ss');
		o_errcode := NHS_ACT_SYSLOG('ADD', 'Appointment', 'Cancel Booking', v_syslog_remark, i_USRID, NULL, o_errmsg);
	
	END IF;
	-- debug log end

	RETURN v_noOfRec;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errmsg := 'Fail to log cancel booking.';
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	return -1;
END NHS_UTL_BOOKING_CANCEL_LOG;
/
