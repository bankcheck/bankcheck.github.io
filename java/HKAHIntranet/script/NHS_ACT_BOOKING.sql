create or replace
FUNCTION "NHS_ACT_BOOKING" (
	i_action IN VARCHAR2,
	i_DOCCODE IN VARCHAR2,
	i_ANTCHKDT IN VARCHAR2,
	i_SLTID IN VARCHAR2,
	i_SCHID IN VARCHAR2,
	i_PATNO IN VARCHAR2,
	i_FULLNAME IN VARCHAR2,
	i_HPHONE IN VARCHAR2,
	i_MPHONE IN VARCHAR2,
	i_SESSION IN VARCHAR2,
	i_BKSID IN VARCHAR2,
	i_REMARK IN VARCHAR2,
	i_SMS IN VARCHAR2,
	i_SMCID IN VARCHAR2,
	i_OBTENTATIVE IN VARCHAR2,
	i_EDCMonth IN VARCHAR2,
	i_SLOT IN VARCHAR2,
	i_OVERRIDE IN VARCHAR2,
	i_usrid IN VARCHAR2,
	o_errmsg OUT VARCHAR2)
RETURN  NUMBER
AS
	v_noOfRec INTEGER;
	v_count INTEGER;
	v_STECODE VARCHAR2(4);
	v_BKGSDATE DATE;
	v_BKGEDATE DATE;
	v_BKGID INTEGER;
	v_PATCNAME VARCHAR2(20);
	v_HPHONE VARCHAR2(20);
	v_MPHONE VARCHAR2(20);
	v_bookingid INTEGER;
	v_EDCMonth INTEGER;
	v_EDC VARCHAR2(10);
	v_currentMonth INTEGER;
	v_EDCYear INTEGER;
	v_LASTNAME VARCHAR2(20);
	v_FIRSTNAME VARCHAR2(20);
	v_SCHSTS VARCHAR2(10);
BEGIN
	v_noOfRec := -1;
	o_errmsg := 'OK';
	v_STECODE := 'HKAH';

	SELECT SLTSTIME INTO v_BKGSDATE FROM SLOT@IWEB WHERE SLTID = TO_NUMBER(i_SLTID);
	v_BKGEDATE := v_BKGSDATE + (TO_NUMBER(i_SLOT) * TO_NUMBER(i_SESSION) - 1) / (24*60);
	v_PATCNAME := '';

	-- check doctor status
	SELECT DOCSTS INTO v_noOfRec FROM DOCTOR@IWEB WHERE DOCCODE = i_DOCCODE;
	IF v_noOfRec != -1 THEN
		o_errmsg := 'Inactive doctor.';
		return -1;
	END IF;

	-- check schedule
	SELECT SCHSTS INTO v_SCHSTS FROM SCHEDULE@IWEB WHERE SchID = i_SCHID;
	IF v_SCHSTS = 'B' THEN
		o_errmsg := 'Schedule already blocked.';
		return -1;
	END IF;

	-- check phone length
	IF LENGTH(i_HPHONE) > 20 OR LENGTH(i_MPHONE) > 20 THEN
		o_errmsg := 'Phone Number is too long.';
		return -1;
	ELSE
		IF i_PATNO IS NOT NULL THEN
			SELECT COUNT(1) INTO v_noOfRec FROM PATIENT@IWEB WHERE PATNO = i_PATNO;
			IF v_noOfRec = 1 THEN
				SELECT PATCNAME, PATHTEL, PATPAGER INTO v_PATCNAME, v_HPHONE, v_MPHONE FROM PATIENT@IWEB WHERE PATNO = i_PATNO;
			END IF;
		END IF;

		IF i_HPHONE IS NOT NULL THEN
			v_HPHONE := i_HPHONE;
		END IF;

		IF i_MPHONE IS NOT NULL THEN
			v_MPHONE := i_MPHONE;
		END IF;
	END IF;

	-- if there exist record
	SELECT count(1) INTO v_noOfRec FROM BOOKING@IWEB where SCHID = TO_NUMBER(i_SCHID) AND SLTID = TO_NUMBER(i_SLTID) AND PATNO = i_PATNO AND BKGSTS NOT IN ('C');
	IF v_noOfRec > 0 THEN
		o_errmsg := 'Appointment already exists for this patient.';
		return -1;
	END IF;

	-- if already booked
	IF i_OVERRIDE = 'N' THEN
		SELECT SLTCNT INTO v_noOfRec FROM SLOT@IWEB where SCHID = TO_NUMBER(i_SCHID) AND SLTID = TO_NUMBER(i_SLTID);
		IF v_noOfRec > 0 THEN
			o_errmsg := 'Appointment is already made. Continuous?';
			return -2;
		END IF;
	END IF;

	IF i_OBTENTATIVE IS NOT NULL THEN
		-- if appointment is one week after for tentative booking
		SELECT TRUNC(v_BKGSDATE) - TRUNC(SYSDATE) INTO v_noOfRec FROM DUAL;
		IF v_noOfRec >= 7 THEN
			o_errmsg := 'The tentative booking cannot be made after 7 days.';
			return -1;
		END IF;

		-- EDC must be at least 4 weeks
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
	END IF;

	-- check phone length
	IF LENGTH(i_REMARK) > 50 THEN
		o_errmsg := 'Remark is too long.';
		return -1;
	END IF;

	SELECT SEQ_BOOKING.NEXTVAL@IWEB INTO v_BKGID FROM DUAL;
	INSERT INTO BOOKING@IWEB (
		BKGID,
		SCHID,
		SLTID,
		PATNO,
		BKGPNAME,
		BKGPCNAME,
		BKGPTEL,
		BKGMTEL,
		BKGSDATE,
		BKGEDATE,
		BKGCDATE,
		BKGSCNT,
		BKGSTS,
		BKSID,
		BKGRMK,
		SMS,
		SMCID,
		STECODE,
		USRID
	) VALUES (
		v_BKGID,
		TO_NUMBER(i_SCHID),
		TO_NUMBER(i_SLTID),
		i_PATNO,
		i_FULLNAME,
		v_PATCNAME,
		v_HPHONE,
		v_MPHONE,
		v_BKGSDATE,
		v_BKGEDATE,
		SYSDATE,
		TO_NUMBER(i_SESSION),
		'N',
		i_BKSID,
		i_REMARK,
		i_SMS,
		i_SMCID,
		v_STECODE,
		i_usrid
	);

	For var in 1..TO_NUMBER(i_SESSION) LOOP
		UPDATE SLOT@IWEB
		SET    SLTCNT = SLTCNT + 1
		WHERE  SCHID = TO_NUMBER(i_SCHID)
		AND    SLTID = TO_NUMBER(i_SLTID) + var - 1;
	END LOOP;

	-- update schedule
	UPDATE SCHEDULE@IWEB
	SET    SCHCNT = SCHCNT + TO_NUMBER(i_SESSION)
	WHERE  SCHID = TO_NUMBER(i_SCHID);

	-- create OB tentative booking
	IF i_OBTENTATIVE IS NOT NULL THEN
		-- get booking id
		SELECT COUNT(1) INTO v_bookingid FROM OB_BOOKINGS;
		IF v_bookingid = 0 THEN
			v_bookingid := 1;
		ELSE
			SELECT MAX(OB_BOOKING_ID) + 1 INTO v_bookingid FROM OB_BOOKINGS;
		END IF;

		-- full name -> last/first name
		v_count := INSTR(i_FULLNAME, ' ', 1, 1);
		IF v_count < 20 AND v_count > 0 THEN
			v_LASTNAME := SUBSTR(i_FULLNAME, 1, v_count - 1);
			IF LENGTH(i_FULLNAME) - v_count < 20 THEN
				v_FIRSTNAME := SUBSTR(i_FULLNAME, v_count + 1, LENGTH(i_FULLNAME) - v_count);
			ELSE
				v_FIRSTNAME := SUBSTR(i_FULLNAME, v_count + 1, 20);
			END IF;
		ELSE
			v_LASTNAME := SUBSTR(i_FULLNAME, 1, 20);
			IF LENGTH(i_FULLNAME) < 40 THEN
				v_FIRSTNAME := SUBSTR(i_FULLNAME, 21, LENGTH(i_FULLNAME) - 20);
			ELSE
				v_FIRSTNAME := SUBSTR(i_FULLNAME, 21, 20);
			END IF;
		END IF;

		INSERT INTO OB_BOOKINGS
		(OB_BOOKING_ID, OB_DOCTOR_CODE, OB_PATIENT_ID, OB_LASTNAME, OB_FIRSTNAME, OB_CONTACT_NO, OB_DOC_TYPE, OB_EXPECTED_DELIVERYDATE, OB_ESTIMATE_DELIVERYDATE,
			OB_CHECKED_DATE1, OB_HOLD_EXPIRY_DATE, OB_BKG_ID, OB_BOOKING_STATUS, OB_CREATED_USER, OB_MODIFIED_USER)
		VALUES (v_bookingid, i_DOCCODE, i_PATNO, v_LASTNAME, v_FIRSTNAME, i_MPHONE, i_OBTENTATIVE, TO_DATE(v_EDC, 'dd/MM/yyyy'), TO_DATE(v_EDC, 'dd/MM/yyyy'),
			TO_DATE(i_ANTCHKDT, 'dd/MM/yyyy hh24:mi:ss'), SYSDATE + 7, v_BKGID, 'T', i_usrid, i_usrid);

		o_errmsg := 'The tentative booking will be cancelled after 7 days.';
	END IF;

	COMMIT;

	return 0;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errmsg := 'Fail to generate booking.';
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	return -1;
END NHS_ACT_BOOKING;