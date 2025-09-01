create or replace
FUNCTION OB_BOOKING_CREATE ( i_usrid IN VARCHAR2, i_bookingid VARCHAR2, i_skip_quota_Check VARCHAR2 )
RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_count INTEGER;
	v_count2 INTEGER;

	v_doccode VARCHAR2(4);
	v_patno VARCHAR2(10);
	v_last_name VARCHAR2(50);
	v_first_name VARCHAR2(60);
	v_chinese_name VARCHAR2(30);
	v_contact_no VARCHAR2(50);
	v_dob VARCHAR2(10);
	v_doc_type VARCHAR2(1);
	v_doc_no VARCHAR2(30);
	v_edc VARCHAR2(10);
	v_kin_last_name VARCHAR2(50);
	v_kin_first_name VARCHAR2(60);
	v_kin_chinese_name VARCHAR2(30);
	v_kin_contact_no VARCHAR2(50);
	v_kin_dob VARCHAR2(10);
	v_kin_doc_type VARCHAR2(2);
	v_kin_hkidholder VARCHAR2(1);
	v_kin_doc_no VARCHAR2(30);
	v_checked_date1 VARCHAR2(10);
	v_checked_date2 VARCHAR2(10);
	v_checked_date3 VARCHAR2(10);
	v_checked_date4 VARCHAR2(10);
	v_checked_date5 VARCHAR2(10);

	v_pbpid NUMBER;
	v_is_mainland NUMBER;
	v_ward_code VARCHAR2(4);
	v_bpb_type VARCHAR2(1);

	v_status VARCHAR2(1);
	v_returnStatus VARCHAR2(1);

	v_errcode NUMBER;
	v_errmsg VARCHAR2(100);
	v_return BOOLEAN;
BEGIN
	-- set default to waiting
	v_returnStatus := 'W';
	v_is_mainland := 0;
	v_errmsg := '';

	-- extract booking info
	SELECT COUNT(1) INTO v_count FROM OB_BOOKINGS WHERE OB_BOOKING_ID = i_bookingid AND OB_BOOKING_STATUS IN ('O', 'T', 'W', 'X');

	SELECT COUNT(1) INTO v_count2
	FROM   OB_BOOKINGS B, BEDPREBOK@IWEB BB
	WHERE  B.OB_PBP_ID = BB.PBPID
	AND    B.OB_BOOKING_ID = i_bookingid
	AND    B.OB_BOOKING_STATUS = 'B'
	AND    BB.WRDCODE = 'OB'
	AND    BB.BPBSTS = 'D'
	AND    BB.FORDELIVERY = '-1';

	IF v_count + v_count2 = 1 THEN
		-- get doctor code and delivery day
		SELECT OB_DOCTOR_CODE, OB_PATIENT_ID, OB_LASTNAME, OB_FIRSTNAME, OB_CHINESENAME, OB_CONTACT_NO, TO_CHAR(OB_DOB, 'DD/MM/YYYY'), OB_DOC_TYPE, OB_DOC_NO, TO_CHAR(OB_EXPECTED_DELIVERYDATE, 'DD/MM/YYYY'),
		       OB_KIN_LASTNAME, OB_KIN_FIRSTNAME, OB_KIN_CHINESENAME, OB_KIN_CONTACT_NO, TO_CHAR(OB_KIN_DOB, 'DD/MM/YYYY'), OB_KIN_DOC_TYPE, OB_KIN_DOC_NO,
		       TO_CHAR(OB_CHECKED_DATE1, 'DD/MM/YYYY'), TO_CHAR(OB_CHECKED_DATE2, 'DD/MM/YYYY'), TO_CHAR(OB_CHECKED_DATE3, 'DD/MM/YYYY'), TO_CHAR(OB_CHECKED_DATE4, 'DD/MM/YYYY'), TO_CHAR(OB_CHECKED_DATE5, 'DD/MM/YYYY'), OB_BOOKING_STATUS
		INTO   v_doccode, v_patno, v_last_name, v_first_name, v_chinese_name, v_contact_no, v_dob, v_doc_type, v_doc_no, v_edc,
		       v_kin_last_name, v_kin_first_name, v_kin_chinese_name, v_kin_contact_no, v_kin_dob, v_kin_doc_type, v_kin_doc_no,
		       v_checked_date1, v_checked_date2, v_checked_date3, v_checked_date4, v_checked_date5, v_status
		FROM   OB_BOOKINGS WHERE OB_BOOKING_ID = i_bookingid;

		IF i_skip_quota_Check = 'Y' OR v_status = 'T' THEN
			v_returnStatus := 'B';
		ELSE
--			v_errcode := OB_CHECK_QUOTA (v_doccode, v_edc, v_doc_type);

--			IF v_errcode = 0 THEN
				-- set status to booked
				v_returnStatus := 'B';
--			ELSIF v_errcode = -1 THEN
--				v_errmsg := 'OB Booking is in waiting list due to daily quota is fulled.';
--			ELSIF v_errcode = -2 THEN
--				v_errmsg := 'OB Booking is in waiting list due to monthly quota is fulled.';
--			ELSIF v_errcode = -3 THEN
--				v_errmsg := 'OB Booking is in waiting list due to period quota is fulled.';
--			ELSE
--				v_errmsg := 'OB Booking is in waiting list due to quota is fulled.';
--			END IF;
		END IF;

		IF v_returnStatus = 'B' THEN
			v_errmsg := '';

			-- get ward code
			SELECT PARAM1 INTO v_ward_code FROM SYSPARAM@IWEB WHERE PARCDE = 'obwardcode';

			-- get BPB type
			v_bpb_type := NHS_UTL_BPBTYPE(v_edc);
			IF v_bpb_type = 'S' THEN
				v_bpb_type := 'W';
			END IF;

			-- check father's tel
			IF LENGTH(v_kin_contact_no) > 15 THEN
				v_kin_contact_no := SUBSTR(v_kin_contact_no, 1, 15);
			END IF;

			-- check whether the patient is mainland or hk
			IF v_doc_type = 'C' OR v_doc_type = 'L' OR v_doc_type = 'X' THEN
				v_is_mainland := -1;
			END IF;
			-- change macau SAR id holder
			IF v_doc_type = 'X' THEN
				v_doc_type := 'C';
			END IF;
			-- check hkid holder
			IF v_kin_doc_type = '9Y' THEN
				v_kin_doc_type := '9';
				v_kin_hkidholder := 'Y';
			ELSE
				v_kin_hkidholder := 'N';
			END IF;

			-- create booking to HATS
			v_pbpid := NHS_ACT_BEDPREBOK (
				'ADD',
				'',
				v_patno,
				'F',
				v_doc_no,
				v_first_name,
				v_last_name,
				'',
				v_chinese_name,
				v_contact_no,
				'',
				v_edc || ' 00:00:00',
				v_doccode,
				-1,
				v_is_mainland,
				v_ward_code,
				'',
				'',
				'',
				'',
				'DEP4',
				'',
				'',
				'',
				'',
				'',
				'',
				'0',
				'0',
				'0',
				'0',
				'0',
				'',
				'',
				'',
				'',
				'',
				v_bpb_type,
				i_usrid,
				'HKAH',
				'',
				'',
				'',
				v_doc_type,
				v_kin_doc_no,
				v_kin_doc_type,
				v_kin_first_name,
				v_kin_last_name,
				'',
				'',
				v_kin_chinese_name,
				v_kin_dob,
				v_kin_contact_no,
				v_kin_hkidholder,
				'',
				'',
				'',
				v_checked_date1,
				v_checked_date2,
				v_checked_date3,
				v_checked_date4,
				v_checked_date5,
				'',
				'',
				'',
				'',
				'',
				'Y',
				'N',
				v_errmsg);

			-- store pbpid
			IF v_pbpid > 0 AND v_errmsg = 'OK' THEN
				-- update status to
				UPDATE OB_BOOKINGS
				SET    OB_PBP_ID = v_pbpid, OB_BOOKING_STATUS = v_returnStatus
				WHERE  OB_BOOKING_ID = i_bookingid
				AND    OB_BOOKING_STATUS IN ('O', 'T', 'W', 'X', 'B');
			ELSE
				v_returnStatus := 'X';
				--v_errmsg := 'Fail to Create OB Booking status in HATS. Please call IT support!';
			END IF;
		ELSE
			v_errmsg := 'OB Booking is in waiting list due to monthly quota is fulled.';

			-- update status to
			UPDATE OB_BOOKINGS
			SET    OB_BOOKING_STATUS = 'W'
			WHERE  OB_BOOKING_ID = i_bookingid
			AND    OB_BOOKING_STATUS = 'O';
		END IF;

		v_count := OB_BOOKING_ADD_HISTORY(i_bookingid, TO_CHAR(v_pbpid), '', v_returnStatus, '', i_usrid);
	ELSE
		v_returnStatus := 'X';
		v_errmsg := 'OB Booking status is invalid. Please call IT support!';
	END IF;

	COMMIT;

	-- output
	OPEN OUTCUR FOR
		SELECT v_returnStatus, v_errmsg FROM DUAL;
	RETURN OUTCUR;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	v_returnStatus := -1;
	v_errmsg := SQLERRM;

	-- output
	OPEN OUTCUR FOR
		SELECT v_returnStatus, v_errmsg FROM DUAL;
	RETURN OUTCUR;
END OB_BOOKING_CREATE;
/