CREATE OR REPLACE FUNCTION "NHS_ACT_BOOKING_CANCEL" (
	i_action IN VARCHAR2,
	i_BkgID  IN VARCHAR2,
	i_UsrID  IN VARCHAR2,
	o_errmsg OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
	v_BKGID2 BOOKING.BKGID%TYPE;
	v_SchID BOOKING.SCHID%TYPE;
	v_PatNo BOOKING.PATNO%TYPE;
	v_StartTime BOOKING.BKGSDATE%TYPE;
	v_Endtime BOOKING.BKGEDATE%TYPE;
	v_BkgSts BOOKING.BKGSTS%TYPE;
	v_BkgAlert BOOKING.BKGALERT%TYPE;
	SCH_NORMAL VARCHAR2(1) := 'N';
	SCH_CONFIRM VARCHAR2(1) := 'F';
	SCH_PENDING VARCHAR2(1) := 'P';
	SCH_CANCEL VARCHAR2(1) := 'C';

	o_errcode NUMBER;
	o_errmsg1 VARCHAR2(500);
BEGIN
	v_noOfRec := -1;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM BOOKING WHERE BkgID = TO_NUMBER(i_BkgID) AND BkgSts IN (SCH_NORMAL, SCH_CONFIRM, SCH_PENDING);
	IF v_noOfRec = 1 THEN
		SELECT SchID, PatNo, BkgSDate, BkgEDate, BkgSts, BkgAlert INTO v_SchID, v_PatNo, v_StartTime, v_Endtime, v_BkgSts, v_BKGALERT
		FROM   BOOKING
		WHERE  BkgID = TO_NUMBER(i_BkgID)
		AND    BkgSts IN (SCH_NORMAL, SCH_CONFIRM, SCH_PENDING);

		-- debug log start
		o_errcode := NHS_UTL_BOOKING_CANCEL_LOG(v_SchID, i_BkgID, v_StartTime, v_Endtime, i_UsrID, o_errmsg1);
		-- debug log end

		UPDATE BOOKING SET BkgSts = SCH_CANCEL, CancelBy = i_UsrID, BkgADate = SYSDATE
		WHERE BkgID = TO_NUMBER(i_BkgID);

		IF v_BkgSts = SCH_NORMAL THEN
			UPDATE Slot SET SltCnt = SltCnt - 1 WHERE SchID = v_SchID AND SltSTime BETWEEN v_StartTime AND v_Endtime AND SLTCNT > 0;

			UPDATE Schedule SET SchCnt = SchCnt - 1 WHERE SchID = v_SchID;
		END IF;

		-- vaccine
		IF GET_CURRENT_STECODE = 'HKAH' AND v_PatNo IS NOT NULL THEN
			IF v_BkgAlert = '61' THEN
				UPDATE HPSTATUS
				SET    HPSDATE = '', HPRMK1 = ''
				WHERE  HPTYPE = 'VACCINE'
				AND    HPKEY = 'COVID19'
				AND    HPSTATUS = v_PatNo;

				SELECT HPRMK2 INTO v_BKGID2
				FROM   HPSTATUS
				WHERE  HPTYPE = 'VACCINE'
				AND    HPKEY = 'COVID19'
				AND    HPSTATUS = v_PatNo;

				IF v_BKGID2 IS NOT NULL THEN
					v_noOfRec := NHS_ACT_BOOKING_CANCEL(i_action, v_BKGID2, i_UsrID, o_errmsg);
				END IF;
			ELSIF v_BkgAlert = '62' THEN
				UPDATE HPSTATUS
				SET    HPEDATE = '', HPRMK2 = ''
				WHERE  HPTYPE = 'VACCINE'
				AND    HPKEY = 'COVID19'
				AND    HPSTATUS = v_PatNo;

--				SELECT HPRMK1 INTO v_BKGID2
--				FROM   HPSTATUS
--				WHERE  HPTYPE = 'VACCINE'
--				AND    HPKEY = 'COVID19'
--				AND    HPSTATUS = v_PatNo;
--
--				IF v_BKGID2 IS NOT NULL THEN
--					v_noOfRec := NHS_ACT_BOOKING_CANCEL(i_action, v_BKGID2, i_UsrID, o_errmsg);
--				END IF;
			END IF;
		END IF;
	ELSE
		v_noOfRec := -1;
		o_errmsg := 'Fail to cancel the appointment due to already confirmed or cancelled.';
	END IF;

	-- cancel OB Booking if necessary
--	SELECT count(1) INTO v_noOfRec FROM OB_BOOKINGS@PORTAL WHERE OB_BKG_ID = TO_NUMBER(i_BkgID);
--	IF v_noOfRec > 0 THEN
--		UPDATE OB_BOOKINGS@PORTAL SET OB_ENABLED = 0 WHERE OB_BKG_ID = TO_NUMBER(i_BkgID);
--	END IF;

	RETURN v_noOfRec;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errmsg := 'Fail to cancel the appointment.';
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	return -1;
END NHS_ACT_BOOKING_CANCEL;
/
