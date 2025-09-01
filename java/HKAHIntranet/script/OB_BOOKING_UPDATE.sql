create or replace
FUNCTION OB_BOOKING_UPDATE (
	i_usrid IN VARCHAR2,
	i_bookingid VARCHAR2,
	i_doccode VARCHAR2,
	i_patno VARCHAR2,
	i_last_name VARCHAR2,
	i_first_name VARCHAR2,
	i_chinese_name VARCHAR2,
	i_contact_no VARCHAR2,
	i_dob VARCHAR2,
	i_doc_type VARCHAR2,
	i_doc_no VARCHAR2,
	i_kin_last_name VARCHAR2,
	i_kin_first_name VARCHAR2,
	i_kin_chinese_name VARCHAR2,
	i_kin_contact_no VARCHAR2,
	i_kin_dob VARCHAR2,
	i_kin_doc_type VARCHAR2,
	i_kin_doc_no VARCHAR2,
	i_checked_date1 VARCHAR2,
	i_checked_date2 VARCHAR2,
	i_checked_date3 VARCHAR2,
	i_checked_date4 VARCHAR2,
	i_checked_date5 VARCHAR2,
	i_lab_test_ready VARCHAR2,
	i_pbo_remark VARCHAR2
)
RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_count INTEGER;

	v_pbpid VARCHAR2(10);
	v_bkgid VARCHAR2(10);
	v_is_mainland NUMBER;
	v_doc_type VARCHAR2(1);
	v_kin_doc_type VARCHAR2(1);
	v_kin_hkidholder VARCHAR2(1);
	v_kin_contact_no VARCHAR2(15);

	v_status VARCHAR2(1);

	v_errmsg VARCHAR2(100);
	v_return NUMBER;
BEGIN
	-- set default to waiting
	v_status := 'W';
	v_is_mainland := 0;
	v_doc_type := i_doc_type;
	v_errmsg := '';

	-- extract booking info
	SELECT COUNT(1) INTO v_count FROM OB_BOOKINGS WHERE OB_BOOKING_ID = i_bookingid AND OB_ENABLED = 1;

	IF v_count = 1 THEN
		UPDATE OB_BOOKINGS
		SET    OB_DOCTOR_CODE = i_doccode, OB_PATIENT_ID = i_patno, OB_LASTNAME = i_last_name, OB_FIRSTNAME = i_first_name, OB_CHINESENAME = i_chinese_name,
		       OB_CONTACT_NO = i_contact_no, OB_DOB = TO_DATE(i_dob, 'dd/MM/YYYY'), OB_DOC_TYPE = v_doc_type, OB_DOC_NO = i_doc_no,
		       OB_KIN_LASTNAME = i_kin_last_name, OB_KIN_FIRSTNAME = i_kin_first_name, OB_KIN_CHINESENAME = i_kin_chinese_name,
		       OB_KIN_CONTACT_NO = i_kin_contact_no, OB_KIN_DOB = TO_DATE(i_kin_dob, 'dd/MM/YYYY'), OB_KIN_DOC_TYPE = i_kin_doc_type, OB_KIN_DOC_NO = i_kin_doc_no,
		       OB_CHECKED_DATE1 = TO_DATE(i_checked_date1, 'dd/MM/YYYY'),
		       OB_CHECKED_DATE2 = TO_DATE(i_checked_date2, 'dd/MM/YYYY'),
		       OB_CHECKED_DATE3 = TO_DATE(i_checked_date3, 'dd/MM/YYYY'),
		       OB_CHECKED_DATE4 = TO_DATE(i_checked_date4, 'dd/MM/YYYY'),
		       OB_CHECKED_DATE5 = TO_DATE(i_checked_date5, 'dd/MM/YYYY'),
		       OB_LAB_TEST_READY = i_lab_test_ready,
		       OB_MODIFIED_DATE = SYSDATE, OB_MODIFIED_USER = i_usrid
		WHERE  OB_BOOKING_ID = i_bookingid
		AND    OB_ENABLED = 1;

		-- pbo remark is for pbo only, empty when it is from doctor
		IF i_pbo_remark IS NOT NULL THEN
			UPDATE OB_BOOKINGS
			SET    OB_PBOREMARK = i_pbo_remark
			WHERE  OB_BOOKING_ID = i_bookingid
			AND    OB_ENABLED = 1;
		END IF;

		SELECT OB_BOOKING_STATUS, OB_PBP_ID, OB_BKG_ID INTO v_status, v_pbpid, v_bkgid FROM OB_BOOKINGS WHERE OB_BOOKING_ID = i_bookingid AND OB_ENABLED = 1;

		IF v_status = 'B' AND v_pbpid IS NOT NULL THEN
			IF v_doc_type = 'C' OR v_doc_type = 'L' OR v_doc_type = 'X' THEN
				v_is_mainland := -1;
			END IF;
			-- change macau SAR id holder
			IF v_doc_type = 'X' THEN
				v_doc_type := 'C';
			END IF;
			IF i_kin_doc_type = '9Y' THEN
				v_kin_doc_type := '9';
				v_kin_hkidholder := 'Y';
			ELSE
				v_kin_doc_type := i_kin_doc_type;
				v_kin_hkidholder := 'N';
			END IF;

			-- check father's tel
			IF LENGTH(i_kin_contact_no) > 15 THEN
				v_kin_contact_no := SUBSTR(i_kin_contact_no, 1, 15);
			ELSE
				v_kin_contact_no := i_kin_contact_no;
			END IF;

			-- update booking to HATS
			UPDATE BEDPREBOK@IWEB
			   SET PATNO      = i_patno,
			       BPBPNAME   = i_last_name || ' ' || i_first_name,
			       BPBCNAME   = i_chinese_name,
			       PATFNAME   = i_last_name,
			       PATGNAME   = i_first_name,
			       ISMAINLAND = v_is_mainland,
			       PATPAGER   = i_contact_no,
			       PATIDNO    = i_doc_no,
			       EDITUSER   = i_usrid,
			       EDITDATE   = SYSDATE,
			       PATDOCTYPE = v_doc_type,
			       HUSDOCNO   = i_kin_doc_no,
			       HUSDOCTYPE = v_kin_doc_type,
			       FA_HKIDHOLDER = v_kin_hkidholder,
			       HUSGNAME   = i_kin_first_name,
			       HUSFNAME   = i_kin_last_name,
			       FA_CNAME   = i_kin_chinese_name,
			       FA_DOB     = TO_DATE(i_kin_dob, 'DD/MM/YYYY'),
			       FA_TEL     = v_kin_contact_no,
			       ANTCHKDT1  = TO_DATE(i_checked_date1, 'DD/MM/YYYY'),
			       ANTCHKDT2  = TO_DATE(i_checked_date2, 'DD/MM/YYYY'),
			       ANTCHKDT3  = TO_DATE(i_checked_date3, 'DD/MM/YYYY'),
			       ANTCHKDT4  = TO_DATE(i_checked_date4, 'DD/MM/YYYY'),
			       ANTCHKDT5  = TO_DATE(i_checked_date5, 'DD/MM/YYYY')
			 WHERE PBPID      = v_pbpid;

			-- pbo remark is for pbo only, empty when it is from doctor
			IF i_pbo_remark IS NOT NULL THEN
				UPDATE BEDPREBOK@IWEB
				SET    BPBRMK = i_pbo_remark
				WHERE  PBPID  = v_pbpid;
			END IF;
		ELSIF v_status = 'T' AND v_bkgid IS NOT NULL THEN
			-- update appointment to HATS
			UPDATE BOOKING@IWEB
			   SET	PATNO = i_patno,
					BKGPNAME = i_last_name || ' ' || i_first_name,
					BKGPCNAME = i_chinese_name,
					BKGMTEL = i_contact_no
			WHERE BKGID = TO_NUMBER(v_bkgid);
		END IF;

		v_status := 'U';
		v_errmsg := 'ob booking is updated.';
	ELSE
		v_status := 'X';
		v_errmsg := 'ob booking is invalid.';
	END IF;

	COMMIT;

	-- output
	OPEN OUTCUR FOR
		SELECT v_status, v_errmsg FROM DUAL;
	RETURN OUTCUR;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN NULL;
END OB_BOOKING_UPDATE;
/