create or replace
FUNCTION "NHS_ACT_BOOKING_CHANGE" (
	i_action IN VARCHAR2,
	i_bkgid  IN VARCHAR2,
	i_patno IN VARCHAR2,
	i_bkgpname IN VARCHAR2,
	i_bkgpcname IN VARCHAR2,
	i_bkgptel IN VARCHAR2,
	i_bkgmtel IN VARCHAR2,
	i_bkgrmk  IN VARCHAR2,
	i_bksid  IN VARCHAR2,
	i_sms  IN VARCHAR2,
	i_smcid  IN VARCHAR2,
	i_OBTENTATIVE IN VARCHAR2,
	i_EDCMonth IN VARCHAR2,
	i_usrid IN VARCHAR2,
	o_errmsg	OUT VARCHAR2)
RETURN  NUMBER
AS
	v_noOfRec NUMBER;
	v_EDCMonth INTEGER;
	v_EDC VARCHAR2(10);
	v_currentMonth INTEGER;
	v_EDCYear INTEGER;
	v_bookingid INTEGER;
	v_LASTNAME VARCHAR2(20);
	v_FIRSTNAME VARCHAR2(20);
	v_doccode VARCHAR2(10);
	v_ANTCHKDT DATE;
BEGIN
	v_noOfRec := 0;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM BOOKING@IWEB WHERE BKGID = TO_NUMBER(i_bkgid);

	IF v_noOfRec > 0 THEN
		UPDATE BOOKING@IWEB
		SET
			PATNO = i_patno,
			BKGPNAME = i_bkgpname,
			BKGPCNAME = i_bkgpcname,
			BKGPTEL = i_bkgptel,
			BKGMTEL = i_bkgmtel,
			BKGRMK = i_bkgrmk,
			BKSID = i_bksid,
			SMS = i_sms,
			SMCID = i_smcid
		WHERE BKGID = TO_NUMBER(i_bkgid);

		-- EDC must be at least 4 weeks
		IF i_OBTENTATIVE IS NOT NULL THEN
			v_EDCMonth := TO_NUMBER(i_EDCMonth);
			v_currentMonth := TO_NUMBER(TO_CHAR(SYSDATE, 'MM'));
			v_EDCYear := TO_NUMBER(TO_CHAR(SYSDATE, 'yyyy'));
			IF v_currentMonth >= v_EDCMonth THEN
				v_EDCYear := v_EDCYear + 1;
			END IF;
			v_EDC := '01/' || v_EDCMonth || '/' || v_EDCYear;
			SELECT TO_DATE(v_EDC, 'dd/MM/yyyy') - TRUNC(SYSDATE) INTO v_noOfRec FROM DUAL;
			IF v_noOfRec > 252 THEN
				o_errmsg := 'EDC is less than 4 weeks.';
				return -1;
			END IF;

			--UPDATE OB_BOOKINGS BY ANDREW
			SELECT count(1) INTO v_noOfRec FROM OB_BOOKINGS WHERE OB_BKG_ID = TO_NUMBER(i_bkgid);
			IF v_noOfRec > 0 THEN
				UPDATE OB_BOOKINGS
				SET
					OB_DOC_TYPE = i_OBTENTATIVE,
					OB_EXPECTED_DELIVERYDATE = TO_DATE(v_EDC, 'dd/MM/yyyy'),
					OB_ESTIMATE_DELIVERYDATE = TO_DATE(v_EDC, 'dd/MM/yyyy'),
					OB_MODIFIED_USER = i_usrid,
					OB_MODIFIED_DATE = SYSDATE,
					OB_ENABLED = 1
				WHERE OB_BKG_ID = i_bkgid;
			ELSE
				-- get doctor code and slot time
				SELECT S.DOCCODE, SL.SLTSTIME INTO v_doccode, v_ANTCHKDT
				FROM   BOOKING@IWEB B, SCHEDULE@IWEB S, SLOT@IWEB SL
				WHERE  B.SCHID = S.SCHID
				AND    B.SLTID = SL.SLTID
				AND    B.BKGID = TO_NUMBER(i_bkgid);

				-- get booking id
				SELECT COUNT(1) INTO v_bookingid FROM OB_BOOKINGS;
				IF v_bookingid = 0 THEN
					v_bookingid := 1;
				ELSE
					SELECT MAX(OB_BOOKING_ID) + 1 INTO v_bookingid FROM OB_BOOKINGS;
				END IF;

				-- full name -> last/first name
				v_noOfRec := INSTR(i_bkgpname, ' ', 1, 1);
				IF v_noOfRec < 20 AND v_noOfRec > 0 THEN
					v_LASTNAME := SUBSTR(i_bkgpname, 1, v_noOfRec - 1);
					IF LENGTH(i_bkgpname) - v_noOfRec < 20 THEN
						v_FIRSTNAME := SUBSTR(i_bkgpname, v_noOfRec + 1, LENGTH(i_bkgpname) - v_noOfRec);
					ELSE
						v_FIRSTNAME := SUBSTR(i_bkgpname, v_noOfRec + 1, 20);
					END IF;
				ELSE
					v_LASTNAME := SUBSTR(i_bkgpname, 1, 20);
					IF LENGTH(i_bkgpname) < 40 THEN
						v_FIRSTNAME := SUBSTR(i_bkgpname, 21, LENGTH(i_bkgpname) - 20);
					ELSE
						v_FIRSTNAME := SUBSTR(i_bkgpname, 21, 20);
					END IF;
				END IF;

				INSERT INTO OB_BOOKINGS
				(OB_BOOKING_ID, OB_DOCTOR_CODE, OB_PATIENT_ID, OB_LASTNAME, OB_FIRSTNAME, OB_CONTACT_NO, OB_DOC_TYPE, OB_EXPECTED_DELIVERYDATE, OB_ESTIMATE_DELIVERYDATE,
					OB_CHECKED_DATE1, OB_HOLD_EXPIRY_DATE, OB_BKG_ID, OB_BOOKING_STATUS, OB_CREATED_USER, OB_MODIFIED_USER)
				VALUES (
					v_bookingid,
					v_doccode,
					i_patno,
					v_LASTNAME,
					v_FIRSTNAME,
					i_bkgmtel,
					i_OBTENTATIVE,
					TO_DATE(v_EDC, 'dd/MM/yyyy'),
					TO_DATE(v_EDC, 'dd/MM/yyyy'),
					v_ANTCHKDT,--OB_CHECKED_DATE1
					SYSDATE + 7,
					i_bkgid,
					'T',
					i_usrid,
					i_usrid
					);
			END IF;
			--END UPDATE
		ELSE
			--UPDATE OB_BOOKINGS
			SELECT count(1) INTO v_noOfRec FROM OB_BOOKINGS WHERE OB_BKG_ID = TO_NUMBER(i_bkgid);
			IF v_noOfRec > 0 THEN
				UPDATE OB_BOOKINGS
				SET
					OB_MODIFIED_USER = i_usrid,
					OB_MODIFIED_DATE = SYSDATE,
					OB_ENABLED = 0
				WHERE OB_BKG_ID = i_bkgid;
			END IF;
		END IF;
	ELSE
		v_noOfRec := -1;
		o_errmsg := 'Fail to change the appointment detail.';
	END IF;

	IF v_noOfRec >= 0 THEN
		COMMIT;
	ELSE
		ROLLBACK;
	END IF;

	RETURN v_noOfRec;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errmsg := 'Fail to change the appointment.';
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	return -1;
END NHS_ACT_BOOKING_CHANGE;