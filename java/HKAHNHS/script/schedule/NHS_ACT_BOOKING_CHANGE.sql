CREATE OR REPLACE FUNCTION "NHS_ACT_BOOKING_CHANGE" (
	i_action      IN VARCHAR2,
	i_bkgid       IN VARCHAR2,
	i_patno       IN VARCHAR2,
	i_bkgpname    IN VARCHAR2,
	i_bkgpcname   IN VARCHAR2,
	i_bkgptel     IN VARCHAR2,
	i_bkgmtel     IN VARCHAR2,
	i_bkgrmk      IN VARCHAR2,
	i_bksid       IN VARCHAR2,
--	i_SMS         IN VARCHAR2,
	i_smcid       IN VARCHAR2,
--	i_isUpdPatSMS IN VARCHAR2,
	i_ALERT       IN VARCHAR2,
	i_LMP          IN VARCHAR2,
	i_EDC          IN VARCHAR2,
	i_BirthOrder   IN VARCHAR2,
	i_ReferralDoc  IN VARCHAR2,
	i_Weeks        IN VARCHAR2,
  	i_NatOfVisit   IN VARCHAR2,
	i_usrid       IN VARCHAR2,
	o_errmsg      OUT VARCHAR2)
RETURN  NUMBER
AS
--	v_patnoExists NUMBER;
	v_noOfRec NUMBER;
	v_DocCode VARCHAR2(10);
	v_ANTCHKDT DATE;
	v_BKGALERT BOOKING.BKGALERT%TYPE;
--	v_PatSMS VARCHAR2(2);
--	v_SMSMandaty VARCHAR2(1);
	v_LMP DATE;
	v_EDC DATE;

	MSG_DOCTOR_INACTION VARCHAR2(42) := 'The current doctor is inactive or invalid.';
BEGIN
	v_noOfRec := 0;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM BOOKING WHERE BKGID = TO_NUMBER(i_bkgid);
--	SELECT count(1) INTO v_patnoExists FROM PATIENT WHERE PATNO = i_patno;

	IF v_noOfRec = 1 THEN
		-- get doctor code and slot time
		SELECT S.DocCode, SL.SLTSTIME, B.BKGALERT INTO v_DocCode, v_ANTCHKDT, v_BKGALERT
		FROM   BOOKING B, SCHEDULE S, SLOT SL
		WHERE  B.SCHID = S.SCHID
		AND    B.SLTID = SL.SLTID
		AND    B.BKGID = TO_NUMBER(i_bkgid);

		SELECT COUNT(1) INTO v_noOfRec FROM Doctor WHERE DocCode = v_DocCode AND DocSts = -1;
		IF v_noOfRec = 0 THEN
			o_errmsg := MSG_DOCTOR_INACTION;
			RETURN -1;
		END IF;

		-- check quota
		IF i_ALERT IS NOT NULL AND i_ALERT != v_BKGALERT THEN
			SELECT COUNT(1) INTO v_noOfRec FROM BOOKINGALERT WHERE BKAID = i_ALERT AND (BKAQUOTAD = -1 OR BKAQUOTAM = -1 OR BKAQUOTAY = -1);
			IF v_noOfRec > 0 THEN
				v_noOfRec := NHS_UTL_ALERTQUOTA(i_ALERT, v_DocCode, v_ANTCHKDT);
				IF v_noOfRec = 0 THEN
					o_errmsg := 'Quota is filled.';
					RETURN -1;
				END IF;
			END IF;
		END IF;

		IF i_LMP IS NOT NULL THEN
			BEGIN
				v_LMP := TO_DATE(i_LMP, 'dd/MM/yyyy');
			EXCEPTION
			WHEN OTHERS THEN
				o_errmsg := 'Invalid LMP.';
				RETURN -1;
			END;
		END IF;

		IF i_EDC IS NOT NULL THEN
			BEGIN
				v_EDC := TO_DATE(i_EDC, 'dd/MM/yyyy');
			EXCEPTION
			WHEN OTHERS THEN
				o_errmsg := 'Invalid EDC.';
				RETURN -1;
			END;
		END IF;

--    		IF v_patnoExists > 0 THEN
--     			SELECT NVL(PatSMS, '0') INTO v_PatSMS FROM Patient WHERE PatNo = i_patno;
--    		ELSE
--      		v_PatSMS := 0;
--    		END IF;

--		SELECT Param1 INTO v_SMSMandaty FROM SysParam WHERE ParCde = 'SMSMANDATY';

--		IF v_SMSMandaty = 'Y' AND v_PatSMS <> i_SMS THEN
--			IF i_isUpdPatSMS = 'Y' THEN
--				UPDATE Patient SET PatSMS = i_SMS WHERE PatNo = i_patno;
--			ELSIF i_isUpdPatSMS IS NULL THEN
--				o_errmsg := 'SMS in patient profile is ' || (CASE WHEN v_PatSMS = '-1' THEN 'Yes' ELSE 'No' END) || ', but now you choose ' || (CASE WHEN i_SMS = '-1' THEN 'Yes' ELSE 'No' END) || ', are you sure to update SMS in patient profile?';
--				RETURN -100;
--			END IF;
--		END IF;

		UPDATE BOOKING
		SET
--			PATNO = i_patno,
--			BKGPNAME = i_bkgpname,
--			BKGPCNAME = i_bkgpcname,
			BKGPTEL = i_bkgptel,
			BKGMTEL = i_bkgmtel,
			BKGRMK = i_bkgrmk,
			BKSID = i_bksid,
--			SMS = i_SMS,
			SMCID = i_smcid,
			BKGALERT = i_ALERT,
			BKGOBLMP = v_LMP,
			BKGOBEDC = v_EDC,
			BKGOBBIRTHORDER = i_BirthOrder,
			BKGOBREFERRALDOC = i_ReferralDoc,
			BKGOBWEEKS = i_Weeks
		WHERE BKGID = TO_NUMBER(i_bkgid);

		SELECT COUNT(1) INTO v_noOfRec FROM BOOKING_EXTRA WHERE BKGID = TO_NUMBER(i_bkgid);
		IF v_noOfRec = 0 THEN
			INSERT INTO BOOKING_EXTRA (BKGID, BKGUUSER,NATUREOFVISIT, BKGUDATE)
			VALUES (TO_NUMBER(i_bkgid), i_usrid,I_NATOFVISIT,  SYSDATE);
		ELSE
			UPDATE BOOKING_EXTRA
			SET    BKGUUSER = i_usrid, BKGUDATE = SYSDATE, NATUREOFVISIT = i_NatOfVisit
			WHERE  BKGID = TO_NUMBER(i_bkgid);
		END IF;
	ELSE
		v_noOfRec := -1;
		o_errmsg := 'Fail to change the appointment detail.';
	END IF;

	IF v_noOfRec < 0 THEN
		ROLLBACK;
	END IF;

	RETURN v_noOfRec;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errmsg := 'Fail to change the appointment.';
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_ACT_BOOKING_CHANGE;
/
