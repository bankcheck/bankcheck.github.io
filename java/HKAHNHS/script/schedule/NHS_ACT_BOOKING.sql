CREATE OR REPLACE FUNCTION "NHS_ACT_BOOKING" (
	i_action       IN VARCHAR2,
	i_DOCCODE      IN VARCHAR2,
	i_ANTCHKDT     IN VARCHAR2,
	i_SLTID        IN VARCHAR2,
	i_SCHID        IN VARCHAR2,
	i_PATNO        IN VARCHAR2,
	i_FULLNAME     IN VARCHAR2,
	i_HPHONE       IN VARCHAR2,
	i_MPHONE       IN VARCHAR2,
	i_SESSION      IN VARCHAR2,
	i_BKSID        IN VARCHAR2,
	i_REMARK       IN VARCHAR2,
--	i_SMS          IN VARCHAR2,
	i_SMCID        IN VARCHAR2,
	i_SLOT         IN VARCHAR2,
--	i_updatePatSMS IN VARCHAR2,
	i_ALERT        IN VARCHAR2,
	i_LMP          IN VARCHAR2,
	i_EDC          IN VARCHAR2,
	i_BirthOrder   IN VARCHAR2,
	i_ReferralDoc  IN VARCHAR2,
	i_Weeks        IN VARCHAR2,
	i_BkgID        IN VARCHAR2,
	i_Override     IN VARCHAR2,
	i_UsrID        IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_LblRmk       IN VARCHAR2,
	i_NatOfVisit   IN VARCHAR2,
	o_errMsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec Integer;
	v_noOfSameRec INTEGER;
	v_appointmentDayCount INTEGER;
	v_count INTEGER;
	v_BKGSDATE DATE;
	v_BKGEDATE DATE;
	v_BKGID BOOKING.BKGID%TYPE;
	v_BKGID1 BOOKING.BKGID%TYPE;
	v_BKGID2 BOOKING.BKGID%TYPE;
	v_BKGSTS BOOKING.BKGSTS%TYPE;
	v_PATCNAME PATIENT.PATCNAME%TYPE;
	v_HPHONE PATIENT.PATHTEL%TYPE;
	v_MPHONE PATIENT.PATPAGER%TYPE;
	v_PatSMS NUMBER(1);
	v_SCHSTS SCHEDULE.SCHSTS%TYPE;
	v_DOCLOCID SCHEDULE.DOCLOCID%TYPE;
	v_SCHID SCHEDULE.SCHID%TYPE;
	v_rslt NUMBER;
	v_FULLNAME VARCHAR2(81);
	v_patcnt NUMBER;
	v_errMsg VARCHAR2(500);
	v_expirydate VARCHAR2(10);
	v_Schdate VARCHAR2(50);
	v_docname VARCHAR2(90);
	v_LMP DATE;
	v_EDC DATE;
	v_Weeks NUMBER;
	v_AGE NUMBER;
	v_AgeLowerLimit NUMBER;
	v_AgeUpperLimit NUMBER;
	v_OverrideBooking VARCHAR2(1) := 'N';
	v_OverrideAgeLimit VARCHAR2(1) := 'N';
	v_OverrideVaccine VARCHAR2(1) := 'N';
	v_OverrideInitAsseC19HC VARCHAR2(1) := 'N';
	v_InitialAssessed VARCHAR2(10);
	v_CheckDateTimeInNum NUMBER;
	v_CheckDateTime DATE;
	v_REMARK VARCHAR2(175);
	v_REMARK2 VARCHAR2(175);
	v_VaccineDate1 DATE;
	v_VaccineDate2 DATE;
	o_errCode NUMBER := -1;

	STATUS_NORMAL VARCHAR2(1) := 'N';
	STATUS_PENDING VARCHAR2(1) := 'P';
	STATUS_CANCEL VARCHAR2(1) := 'C';
BEGIN
	v_noOfRec := -1;
	o_errMsg := 'OK';

	IF LENGTH(i_Override) > 0 THEN
		v_OverrideBooking := SUBSTR(i_Override, 1, 1);
	END IF;

	IF LENGTH(i_Override) > 1 THEN
		v_OverrideAgeLimit := SUBSTR(i_Override, 2, 1);
	END IF;

	IF LENGTH(i_Override) > 1 THEN
		v_OverrideVaccine := SUBSTR(i_Override, 3, 1);
	END IF;

	IF LENGTH(i_Override) > 3 THEN
		v_OverrideInitAsseC19HC := SUBSTR(i_Override, 4, 1);
	END IF;
	
	SELECT SLTSTIME INTO v_BKGSDATE FROM SLOT WHERE SLTID = TO_NUMBER(i_SLTID);
	v_BKGEDATE := v_BKGSDATE + (TO_NUMBER(i_SLOT) * TO_NUMBER(i_SESSION) - 1) / (24*60);
	v_PATCNAME := '';

	-- allow book previous two hours only
	IF v_BKGSDATE < SYSDATE - (120 / 1440) THEN
		o_errMsg := 'Appointment can only allow two hours before.';
		return -1;
	END IF;

	-- check doctor status
	SELECT DOCSTS INTO v_noOfRec FROM DOCTOR WHERE DOCCODE = i_DOCCODE;
	IF v_noOfRec != -1 THEN
		SELECT TO_CHAR(DOCTDATE, 'DD/MM/YYYY') INTO v_expirydate
		FROM Doctor
		WHERE UPPER(DocCode) = UPPER(i_DOCCODE);

		o_errMsg := 'Inactive doctor.<br/>Admission Expiry Date: ' || v_expirydate;
		return -1;
	END IF;

	v_noOfRec := 0;
	IF GET_CURRENT_STECODE() = 'TWAH' THEN
		-- check booking source = 'Mobile'
		SELECT COUNT(1) INTO v_noOfRec FROM BOOKINGSRC WHERE BKSID = i_BKSID AND BKSDESC = 'Mobile';
	ELSE
		v_noOfRec := 1;
	END IF;

	IF v_noOfRec > 0 THEN
		-- get doctor name
		SELECT DOCFNAME || ' ' || DOCGNAME INTO v_FULLNAME
		FROM Doctor
		WHERE UPPER(DocCode) = UPPER(i_DOCCODE);

		IF i_PATNO IS NOT NULL THEN
			IF GET_CURRENT_STECODE() = 'HKAH' THEN
				-- check alert code for DENY
				SELECT COUNT(1) INTO v_COUNT
				FROM   PATALTLINK
				WHERE  PATNO = i_PATNO
				AND    USRID_C IS NULL
				AND    ALTID IN (SELECT ALTID FROM ALERT WHERE ALTCODE IN ('DENY'));
				IF v_Count > 0 THEN
					o_errMsg := '<font color=red>DO NOT PROVIDE HOSPITAL SERVICE!</font>';
					return -1;
				END IF;
			END IF;

			-- check alert code for REFUS
			SELECT COUNT(1) INTO v_COUNT
			FROM   PATALTLINK
			WHERE  PATNO = i_PATNO
			AND    USRID_C IS NULL
			AND    ALTID IN (SELECT ALTID FROM ALERT WHERE ALTCODE IN ('N' || i_DOCCODE, 'D' || i_DOCCODE));
			IF v_Count > 0 THEN
				o_errMsg := '<font color=red>DR. ' || v_FULLNAME || ' (' || i_DOCCODE || ') REFUSES TO SEE THIS PATIENT IN FUTURE.</font>';
				return -1;
			END IF;

			SELECT COUNT(1) INTO v_COUNT
			FROM   PATALTLINK
			WHERE  PATNO = i_PATNO
			AND    USRID_C IS NULL
			AND    ALTID IN (SELECT ALTID FROM ALERT WHERE ALTCODE IN ('P' || i_DOCCODE));
			IF v_Count > 0 THEN
				o_errMsg := '<font color=red>THIS PATIENT REFUSES TO SEE DR. ' || v_FULLNAME || ' (' || i_DOCCODE || ') IN FUTURE.</font>';
				return -1;
			END IF;
		END IF;

		-- check age limit (lower)
		SELECT COUNT(1) INTO v_COUNT
		FROM   HPSTATUS
		WHERE  HPTYPE = 'MOBILEAPP'
		AND    HPKEY = 'AGELLIMIT'
		AND    HPSTATUS = i_DOCCODE
		AND    HPACTIVE = -1;
		IF v_Count > 0 THEN
			SELECT HPRMK INTO v_AgeLowerLimit
			FROM   HPSTATUS
			WHERE  HPTYPE = 'MOBILEAPP'
			AND    HPKEY = 'AGELLIMIT'
			AND    HPSTATUS = i_DOCCODE
			AND    HPACTIVE = -1;
		ELSE
			v_AgeLowerLimit := -1;
		END IF;

		-- check age limit (upper)
		SELECT COUNT(1) INTO v_COUNT
		FROM   HPSTATUS
		WHERE  HPTYPE = 'MOBILEAPP'
		AND    HPKEY = 'AGEULIMIT'
		AND    HPSTATUS = i_DOCCODE
		AND    HPACTIVE = -1;
		IF v_Count > 0 THEN
			SELECT HPRMK INTO v_AgeUpperLimit
			FROM   HPSTATUS
			WHERE  HPTYPE = 'MOBILEAPP'
			AND    HPKEY = 'AGEULIMIT'
			AND    HPSTATUS = i_DOCCODE
			AND    HPACTIVE = -1;
		ELSE
			v_AgeUpperLimit := -1;
		END IF;

		IF i_PATNO IS NOT NULL AND v_OverrideAgeLimit = 'N' THEN
			-- get patient number
			SELECT TRUNC(MONTHS_BETWEEN(SYSDATE, PATBDATE)/ 12) INTO v_AGE FROM PATIENT WHERE PATNO = i_PATNO;

			-- check age limit (lower or upper)
			IF v_AgeLowerLimit != -1 AND v_AgeUpperLimit != -1 AND (v_AGE < v_AgeLowerLimit OR v_AGE > v_AgeUpperLimit) THEN
				o_errMsg := '<font color=red>DR. ' || v_FULLNAME || ' (' || i_DOCCODE || ') ONLY SEE PATIENT BETWEEN  ' || v_AgeLowerLimit || ' AND ' || v_AgeUpperLimit || '.</font>';
				return -3;
			END IF;

			-- check age limit (lower)
			IF v_AgeLowerLimit != -1 AND v_AGE < v_AgeLowerLimit THEN
				o_errMsg := '<font color=red>DR. ' || v_FULLNAME || ' (' || i_DOCCODE || ') DOES NOT SEE PATIENT BELOW  ' || v_AgeLowerLimit || '.</font>';
				return -3;
			END IF;

			-- check age limit (upper)
			IF v_AgeUpperLimit != -1 AND v_AGE > v_AgeUpperLimit THEN
				o_errMsg := '<font color=red>DR. ' || v_FULLNAME || ' (' || i_DOCCODE || ') DOES NOT SEE PATIENT OVER ' || v_AgeUpperLimit || '.</font>';
				return -3;
			END IF;
		END IF;
	END IF;

	-- check session
	SELECT COUNT(1) INTO v_Count FROM SCHEDULE WHERE SCHID = i_SCHID AND SCHSDATE <= v_BKGSDATE AND SCHEDATE >= v_BKGEDATE;
	IF v_Count = 0 THEN
		o_errMsg := 'Invalid range for before or after schedule';
		return -4;
	END IF;

	-- lock
	v_rslt := NHS_ACT_RECORDLOCK('', 'Schedule', i_SCHID, i_ComputerName, i_UsrID, o_errMsg);
	IF v_rslt <> 0 THEN
		return -1;
	END IF;

	-- check schedule
	SELECT SCHSTS, DOCLOCID INTO v_SCHSTS, v_DOCLOCID FROM SCHEDULE WHERE SchID = i_SCHID;
	IF v_SCHSTS = 'B' THEN
		o_errMsg := 'Schedule already blocked.';
		GOTO UnlockSchedule;
	END IF;

	-- check phone length
	IF LENGTH(I_HPHONE) > 20 OR LENGTH(I_MPHONE) > 20 THEN
		o_errMsg := 'Phone Number is too long.';
		GOTO UnlockSchedule;
	ELSE
		IF i_PATNO IS NOT NULL THEN
			SELECT COUNT(1) INTO v_noOfRec FROM PATIENT WHERE PATNO = i_PATNO;
			IF v_noOfRec = 1 THEN
				SELECT PATCNAME, PATHTEL, PATPAGER INTO v_PATCNAME, v_HPHONE, v_MPHONE FROM PATIENT WHERE PATNO = i_PATNO;
			END IF;
		END IF;

		IF i_HPHONE IS NOT NULL THEN
			v_HPHONE := i_HPHONE;
		END IF;

--		IF i_MPHONE IS NOT NULL THEN
			v_MPHONE := i_MPHONE;
--		END IF;
	END IF;

	-- if there exist record
	SELECT count(1) INTO v_noOfRec FROM BOOKING where SCHID = TO_NUMBER(i_SCHID) AND SLTID = TO_NUMBER(i_SLTID) AND PATNO = i_PATNO AND BKGSTS NOT IN (STATUS_CANCEL);
	IF v_noOfRec > 0 THEN
		o_errMsg := 'Appointment already exists for this patient in the same time slot.';
		GOTO UnlockSchedule;
	END IF;

	-- if already booked
	IF v_OverrideBooking = 'N' AND i_BkgID IS NULL THEN
		SELECT SLTCNT INTO v_noOfRec FROM SLOT where SCHID = TO_NUMBER(i_SCHID) AND SLTID = TO_NUMBER(i_SLTID);

		-- if there exist record of same patient ,on same date with same doctor
--		SELECT To_Char(Schsdate, 'DD/MM/YYYY') INTO v_Schdate FROM Schedule WHERE Schid = i_SCHID;
--
--		SELECT Count(1) INTO v_noOfSameRec
--		FROM   Booking B, Schedule S WHERE B.Schid = S.Schid
--		AND   (B.Patno = i_PATNO OR (i_PATNO IS NULL AND BKGPNAME = TRIM(i_FULLNAME)))
--		AND    S.Doccode = i_DOCCODE
--		AND    TO_CHAR(B.Bkgsdate, 'dd/mm/yyyy') = v_Schdate AND B.Bkgsts NOT IN (STATUS_CANCEL);

		SELECT Count(1) INTO v_noOfSameRec
		FROM   Booking B
		INNER JOIN Schedule S ON B.Schid = S.Schid
		WHERE  B.Patno = i_PATNO
		AND    S.Doccode = i_DOCCODE
		AND    B.Bkgsdate >= TO_DATE(TO_CHAR(v_BKGSDATE, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
		AND    B.Bkgsdate <= TO_DATE(TO_CHAR(v_BKGSDATE, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')
		AND    B.BKGSTS NOT IN (STATUS_CANCEL);

		SELECT DOCFNAME || ' ' || DOCGNAME INTO v_docname FROM DOCTOR WHERE doccode = i_DOCCODE;

		IF v_noOfRec > 0 THEN
			o_errMsg := '<font color=''blue''>Appointment has already exist in the time slot.</font></br>';
		END IF;

		IF v_noOfSameRec > 0 THEN
			IF v_noOfRec > 0 THEN
				o_errMsg := o_errMsg || 'Patient ' || i_PATNO || ' has Appointment with Doctor <font color=''red''>' || v_docname || '</br>on the same date. </font>';
			ELSE
				o_errMsg := 'Patient ' || i_PATNO || ' (' || TRIM(i_FULLNAME) || ') has Appointment with Doctor <font color=''red''>' || v_docname || ' </br>on the same date (' || v_BKGSDATE || '). </font>';
			END IF;
		END IF;

		If v_noOfRec > 0 Or v_noOfSameRec > 0 Then
			o_errMsg := o_errMsg || ' Continue?';
			o_errCode := -2;
			GOTO UnlockSchedule;
		END IF;
	END IF;

	-- if sms is different to patient master
--	IF i_PATNO IS NOT NULL AND i_updatePatSMS IS NULL AND i_SMS IS NOT NULL THEN
--		SELECT COUNT(1) INTO v_noOfRec FROM PATIENT WHERE PATNO = i_PATNO;
--		IF v_noOfRec = 1 THEN
--			SELECT PatSMS INTO v_PatSMS FROM PATIENT WHERE PATNO = i_PATNO;
--			IF v_PatSMS = -1 AND i_SMS = '0' THEN
--				o_errMsg := 'SMS in patient profile is <font color=''green''>YES</font>, but now you choose <font color=''red''>NO</font>, are you sure to update SMS in patient profile?';
--				o_errCode := -3;
--				GOTO UnlockSchedule;
--			ELSIF v_PatSMS = 0 AND i_SMS = '-1' THEN
--				o_errMsg := 'SMS in patient profile is <font color=''red''>NO</font>, but now you choose <font color=''green''>YES</font>, are you sure to update SMS in patient profile?';
--				o_errCode := -3;
--				GOTO UnlockSchedule;
--			END IF;
--		END IF;
--	END IF;

	-- check fullname length
	IF LENGTH(TRIM(i_FULLNAME)) > 81 THEN
		v_FULLNAME := SUBSTR(i_FULLNAME, 1, 81);
	ELSE
		v_FULLNAME := i_FULLNAME;
	END IF;

	-- check remark length
	IF LENGTH(i_REMARK) > 175 THEN
		o_errMsg := 'Remark is too long.';
		GOTO UnlockSchedule;
	ELSE
		v_REMARK := i_REMARK;
	END IF;

	-- check patno
	IF i_PATNO IS NOT NULL AND LENGTH(i_PATNO) > 0 THEN
		SELECT COUNT(1) INTO v_patcnt
		FROM PATIENT
		WHERE PATNO = i_PATNO;

		IF V_PATCNT <= 0 THEN
			o_errMsg := 'Missing patient name/phone.';
			GOTO UnlockSchedule;
		END IF;
	END IF;

	-- check quota
	IF GET_CURRENT_STECODE() = 'HKAH' THEN
--		IF i_DOCCODE = 'HC' AND i_ALERT != '71' AND i_ALERT != '72' AND i_ALERT != '73' THEN
--			o_errMsg := '<font color=''blue''>HC</font> must select <font color=''red''>C-19 Health Code</font> in initial assessed.';
--			GOTO UnlockSchedule;
		IF i_DOCCODE = 'PBOG' AND i_ALERT != '20' THEN
			o_errMsg := '<font color=''blue''>PBOG</font> must select <font color=''red''>C-19 AM/PM/EVE (PBOG)</font> in initial assessed.';
			GOTO UnlockSchedule;
		ELSIF i_DOCCODE = 'COVID' AND i_ALERT != '60' AND i_ALERT != '61' AND i_ALERT != '62' AND i_ALERT != '63' AND i_ALERT != '64' THEN
			o_errMsg := '<font color=''blue''>COVID</font> must select <font color=''red''>COVID VACC</font> in initial assessed.';
			GOTO UnlockSchedule;
		ELSIF v_OverrideInitAsseC19HC = 'N' THEN
			IF i_DOCCODE = 'HC' AND i_ALERT != '71' THEN
				o_errMsg := '<font color=''red''>C-19 HC (PCR)</font> not selected in initial assessed for <font color=''blue''>' || i_DOCCODE || '</font>. Do you want to make this booking?';
				return -5;
			ELSIF i_DOCCODE = 'OPDN' AND i_ALERT != '25' THEN
				o_errMsg := '<font color=''red''>C-19 TEST (OPDN)</font> not selected in initial assessed for <font color=''blue''>' || i_DOCCODE || '</font>. Do you want to make this booking?';
				return -5;
			END IF;		
		END IF;
	END IF;

	IF i_ALERT IS NOT NULL THEN
		v_InitialAssessed := i_ALERT;

		IF GET_CURRENT_STECODE = 'HKAH' THEN
			IF v_InitialAssessed = '10' THEN
				v_CheckDateTimeInNum := TO_NUMBER(TO_CHAR(v_BKGSDATE, 'HH24MI'));

				IF v_CheckDateTimeInNum >= 1800 THEN
					v_InitialAssessed := '13';
				ELSIF v_CheckDateTimeInNum >= 1200 THEN
					v_InitialAssessed := '12';
				ELSE
					v_InitialAssessed := '11';
				END IF;
--			ELSIF v_InitialAssessed = '71' OR v_InitialAssessed = '72' OR v_InitialAssessed = '73' THEN
--				IF i_DOCCODE IS NULL OR i_DOCCODE != 'HC' THEN
--					o_errMsg := '<font color=''blue''>C-19 Health Code</font> must select <font color=''red''>HC</font> doctor.';
--					GOTO UnlockSchedule;
--				END IF;
			ELSIF v_InitialAssessed = '20' THEN
				IF i_DOCCODE IS NULL OR i_DOCCODE != 'PBOG' THEN
					o_errMsg := '<font color=''blue''>C-19 AM/PM/EVE</font> must select <font color=''red''>PBOG</font> doctor.';
					GOTO UnlockSchedule;
				END IF;

				v_CheckDateTimeInNum := TO_NUMBER(TO_CHAR(v_BKGSDATE, 'HH24MI'));

				IF v_CheckDateTimeInNum >= 1800 THEN
					v_InitialAssessed := '23';
				ELSIF v_CheckDateTimeInNum >= 1120 THEN
					v_InitialAssessed := '22';
				ELSE
					v_InitialAssessed := '21';
				END IF;
			ELSIF v_InitialAssessed = '61' OR v_InitialAssessed = '62' OR v_InitialAssessed = '63' THEN
				IF i_DOCCODE IS NULL OR i_DOCCODE != 'COVID' THEN
					o_errMsg := '<font color=''blue''>COVID VACC</font> must select <font color=''red''>COVID</font> doctor.';
					GOTO UnlockSchedule;
				END IF;

				-- no double booking
--				SELECT Count(1) INTO v_Count
--				FROM   Booking B
--				INNER JOIN Schedule S ON B.Schid = S.Schid
--				WHERE  S.Doccode = i_DOCCODE
--				AND    B.Bkgsdate >= v_BKGSDATE
--				AND    B.Bkgsdate <= v_BKGSDATE
--				AND    B.BKGSTS NOT IN (STATUS_CANCEL);
--				IF v_Count > 0 THEN
--					o_errMsg := 'No double booking for vaccine. Some booking maybe pending.';
--					GOTO UnlockSchedule;
--				END IF;

				IF v_OverrideVaccine = 'N' THEN
					v_CheckDateTimeInNum := TO_NUMBER(TO_CHAR(SYSDATE, 'HH24MI'));
					v_CheckDateTime := TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
					IF v_CheckDateTimeInNum < 1200 AND v_BKGSDATE < v_CheckDateTime THEN
						o_errMsg := 'Fail to make same day booking, continue?';
						return -4;
					END IF;

					v_CheckDateTime := TO_DATE(TO_CHAR(SYSDATE + 1, 'DD/MM/YYYY') || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS');
					IF v_CheckDateTimeInNum >= 1200 AND v_BKGSDATE < v_CheckDateTime THEN
						o_errMsg := 'Fail to make same day or tomorrow booking after 12:00P.M., continue?';
						return -4;
					END IF;
				END IF;

				-- check if any previous booking
				IF i_BkgID IS NOT NULL AND v_InitialAssessed != '63' THEN
					o_errMsg := 'Vaccine booking cannot edit. Please cancel the previous bookings first.';
					GOTO UnlockSchedule;
				END IF;

				IF (v_InitialAssessed = '61' OR v_InitialAssessed = '63') AND i_PATNO IS NOT NULL THEN
					IF i_BkgID IS NULL THEN
						SELECT COUNT(1) INTO v_Count FROM BOOKING WHERE PATNO = i_PATNO AND BKGSTS NOT IN (STATUS_CANCEL) AND BKGALERT IN ('61', '63') AND BKGSDATE >= TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
						IF v_Count > 0 THEN
							SELECT MAX(BKGSDATE) INTO v_VaccineDate1 FROM BOOKING WHERE PATNO = i_PATNO AND BKGSTS NOT IN (STATUS_CANCEL) AND BKGALERT IN ('61', '63') AND BKGSDATE >= TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
							o_errMsg := 'Vaccine 1st shot booking already made at ' || TO_CHAR(v_VaccineDate1, 'DD/MM/YYYY HH24:MI:SS') || '.';
							GOTO UnlockSchedule;
						END IF;
					END IF;

					SELECT Count(1) INTO v_Count
					FROM   HPSTATUS
					WHERE  HPTYPE = 'VACCINE'
					AND    HPKEY = 'COVID19'
					AND    HPSTATUS = i_PATNO;

					IF v_Count = 0 THEN
						INSERT INTO HPSTATUS (HPTYPE, HPKEY, HPSTATUS)
						VALUES ('VACCINE', 'COVID19', i_PATNO);
					END IF;
				ELSIF v_InitialAssessed = '62' AND i_PATNO IS NOT NULL THEN
					-- check if any previous booking
					IF i_BkgID IS NULL THEN
						SELECT COUNT(1) INTO v_Count FROM BOOKING WHERE PATNO = i_PATNO AND BKGSTS NOT IN (STATUS_CANCEL) AND BKGALERT = '62' AND BKGSDATE >= TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
						IF v_Count > 0 THEN
							SELECT MAX(BKGSDATE) INTO v_VaccineDate2 FROM BOOKING WHERE PATNO = i_PATNO AND BKGSTS NOT IN (STATUS_CANCEL) AND BKGALERT = '62' AND BKGSDATE >= TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS');
							o_errMsg := 'Vaccine 2nd shot booking already made at ' || TO_CHAR(v_VaccineDate2, 'DD/MM/YYYY HH24:MI:SS') || '.';
							GOTO UnlockSchedule;
						END IF;
					ELSE
						SELECT COUNT(1) INTO v_Count FROM BOOKING WHERE PATNO = i_PATNO AND BKGSTS NOT IN (STATUS_CANCEL) AND BKGALERT = '62' AND BKGSDATE >= TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND BKGID != i_BkgID;
						IF v_Count > 0 THEN
							SELECT MAX(BKGSDATE) INTO v_VaccineDate2 FROM BOOKING WHERE PATNO = i_PATNO AND BKGSTS NOT IN (STATUS_CANCEL) AND BKGALERT = '62' AND BKGSDATE >= TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') AND BKGID != i_BkgID;
							o_errMsg := 'Vaccine 2nd shot booking already made at ' || TO_CHAR(v_VaccineDate2, 'DD/MM/YYYY HH24:MI:SS') || '.';
							GOTO UnlockSchedule;
						END IF;
					END IF;

					-- check if any booking for first shot
--					SELECT COUNT(1) INTO v_Count FROM BOOKING WHERE PATNO = i_PATNO AND BKGSTS NOT IN (STATUS_CANCEL) AND BKGALERT = '61';
--					IF v_Count = 0 THEN
--						o_errMsg := 'Vaccine 1st shot booking is not found.';
--						GOTO UnlockSchedule;
--					END IF;

					SELECT Count(1) INTO v_Count
					FROM   HPSTATUS
					WHERE  HPTYPE = 'VACCINE'
					AND    HPKEY = 'COVID19'
					AND    HPSTATUS = i_PATNO;
					IF v_Count = 1 THEN
						SELECT HPRMK1 INTO v_BKGID1
						FROM   HPSTATUS
						WHERE  HPTYPE = 'VACCINE'
						AND    HPKEY = 'COVID19'
						AND    HPSTATUS = i_PATNO;

						IF v_BKGID1 IS NOT NULL THEN
							-- check booking
							SELECT Count(1) INTO v_Count
							FROM   BOOKING B
							WHERE  B.PATNO = i_PATNO
							AND    B.BKGID = v_BKGID1
							AND    B.BKGSTS NOT IN (STATUS_CANCEL);
							IF v_Count = 0 THEN
								o_errMsg := 'Vaccine 1st shot booking is cancelled.';
								GOTO UnlockSchedule;
							END IF;

							-- check the date must be 28 days after first shot
							SELECT TRIM(MAX(BKGSDATE) + 28) INTO v_VaccineDate2 FROM BOOKING WHERE PATNO = i_PATNO AND BKGSTS NOT IN (STATUS_CANCEL) AND BKGALERT = '61';
							IF v_VaccineDate2 > v_BKGSDATE THEN
								o_errMsg := 'Vaccine 2nd shot booking must be made on or after ' || TO_CHAR(v_VaccineDate2, 'DD/MM/YYYY') || '.';
								GOTO UnlockSchedule;
							END IF;
						END IF;
					ELSE
						INSERT INTO HPSTATUS (HPTYPE, HPKEY, HPSTATUS)
						VALUES ('VACCINE', 'COVID19', i_PATNO);
					END IF;
				END IF;
			END IF;

			IF v_InitialAssessed IN ('10', '11', '12', '13', '15', '20', '21', '22', '23') THEN
				IF v_REMARK IS NULL THEN
					v_REMARK := 'C-19 TEST';
				ELSIF LENGTH(v_REMARK) < 175 - 9 AND v_REMARK NOT LIKE 'C-19 TEST%' THEN
					v_REMARK := 'C-19 TEST ' || v_REMARK;
				END IF;
			ELSIF v_InitialAssessed IN ('30', '31', '32', '33') THEN
				IF v_REMARK IS NULL THEN
					v_REMARK := 'FLU VACC';
				ELSE
					v_REMARK := 'FLU VACC ' || v_REMARK;
				END IF;
			ELSIF v_InitialAssessed IN ('40', '41', '42', '43') THEN
				IF v_REMARK IS NULL THEN
					v_REMARK := 'FLU MIST';
				ELSE
					v_REMARK := 'FLU MIST ' || v_REMARK;
				END IF;
			ELSIF v_InitialAssessed IN ('100') THEN
				SELECT COUNT(1) INTO v_count FROM BOOKINGALERT WHERE BKAID = v_InitialAssessed;
				IF v_count > 0 THEN
					SELECT BKADESC INTO v_REMARK2 FROM BOOKINGALERT WHERE BKAID = v_InitialAssessed;
					IF v_REMARK IS NULL THEN
						v_REMARK := v_REMARK2;
					ELSE
						IF INSTR(v_REMARK, v_REMARK2) > 0 THEN
							v_REMARK := v_REMARK;
						ELSE
							v_REMARK := v_REMARK2 || ' ' || v_REMARK;
						END IF;
					END IF;
				END IF;
			ELSE
				SELECT COUNT(1) INTO v_count FROM BOOKINGALERT WHERE BKAID = v_InitialAssessed AND (BKAQUOTAD = -1 OR BKAQUOTAM = -1 OR BKAQUOTAY = -1);
				IF v_count > 0 THEN
					SELECT BKADESC INTO v_REMARK2 FROM BOOKINGALERT WHERE BKAID = v_InitialAssessed AND (BKAQUOTAD = -1 OR BKAQUOTAM = -1 OR BKAQUOTAY = -1);
					IF v_REMARK IS NULL THEN
						v_REMARK := v_REMARK2;
					ELSE
						IF INSTR(v_REMARK, v_REMARK2) > 0 THEN
							v_REMARK := v_REMARK;
						ELSE
							v_REMARK := v_REMARK2 || ' ' || v_REMARK;
						END IF;
					END IF;
				END IF;
			END IF;

			IF LENGTH(v_REMARK) > 175 THEN
				v_REMARK := SUBSTR(v_REMARK, 1, 175);
			END IF;
		END IF;

		SELECT COUNT(1) INTO v_count FROM BOOKINGALERT WHERE BKAID = v_InitialAssessed AND (BKAQUOTAD = -1 OR BKAQUOTAM = -1 OR BKAQUOTAY = -1);
		IF v_count > 0 THEN
			v_count := NHS_UTL_ALERTQUOTA(v_InitialAssessed, i_DOCCODE, v_BKGSDATE);
			IF v_count = 0 THEN
				o_errMsg := 'Quota is full.';
				GOTO UnlockSchedule;
			END IF;
		END IF;
	END IF;

	IF i_LMP IS NOT NULL THEN
		BEGIN
			v_LMP := TO_DATE(i_LMP, 'dd/MM/yyyy');
		EXCEPTION
		WHEN OTHERS THEN
			o_errMsg := 'Invalid LMP.';
			GOTO UnlockSchedule;
		END;
	END IF;

	IF i_EDC IS NOT NULL THEN
		BEGIN
			v_EDC := TO_DATE(i_EDC, 'dd/MM/yyyy');
		EXCEPTION
		WHEN OTHERS THEN
			o_errMsg := 'Invalid EDC.';
			GOTO UnlockSchedule;
		END;
	END IF;

	IF i_Weeks IS NOT NULL THEN
		BEGIN
			v_Weeks := TO_NUMBER(i_Weeks);
			IF v_weeks > 40 THEN
				o_errMsg := 'Weeks must be less than or equal to 40.';
				GOTO UnlockSchedule;
			END IF;
		EXCEPTION
		WHEN OTHERS THEN
			o_errMsg := 'Invalid weeks.';
			GOTO UnlockSchedule;
		END;
	END IF;

	IF i_PATNO IS NOT NULL THEN
		SELECT PatSMS INTO v_PatSMS FROM Patient WHERE Patno = i_PATNO;
	ELSIF i_MPHONE IS NOT NULL THEN
		v_PatSMS := -1;
	ELSE
		v_PatSMS := 0;
	END IF;

	IF i_BkgID IS NOT NULL THEN
		o_errCode := NHS_ACT_BOOKING_CANCEL(i_action, i_BkgID, i_UsrID, o_errMsg);
	END IF;

	SELECT SEQ_BOOKING.NEXTVAL INTO v_BKGID FROM DUAL;
	INSERT INTO BOOKING (
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
		BKGALERT,
		BKGOBLMP,
		BKGOBEDC,
		BKGOBBIRTHORDER,
		BKGOBREFERRALDOC,
		BKGOBWEEKS,
		DOCLOCID,
		STECODE,
		USRID
	) VALUES (
		v_BKGID,
		TO_NUMBER(i_SCHID),
		TO_NUMBER(i_SLTID),
		i_PATNO,
		v_FULLNAME,
		v_PATCNAME,
		v_HPHONE,
		v_MPHONE,
		v_BKGSDATE,
		v_BKGEDATE,
		SYSDATE,
		TO_NUMBER(i_SESSION),
		STATUS_NORMAL,
		i_BKSID,
		v_REMARK,
		v_PatSMS,
		i_SMCID,
		v_InitialAssessed,
		v_LMP,
		v_EDC,
		i_BirthOrder,
		i_ReferralDoc,
		i_Weeks,
		v_DOCLOCID,
		GET_CURRENT_STECODE,
		i_UsrID
	);

	-- insert booking extra
	IF i_LblRmk IS NOT NULL AND LENGTH(i_LblRmk) > 0 THEN
		INSERT INTO BOOKING_EXTRA (BKGID, LBLRMK, NATUREOFVISIT, BKGID_C)
		VALUES (v_BKGID, i_LblRmk, i_NatOfVisit, i_BkgID);
		IF (length(i_LblRmk || v_REMARK) < 175) THEN
			UPDATE BOOKING
			SET BKGRMK = i_LblRmk || ' ' || v_REMARK
			WHERE BKGID = v_BKGID;
		END IF;
	ELSE
		INSERT INTO BOOKING_EXTRA (BKGID, NATUREOFVISIT, BKGID_C)
		VALUES (v_BKGID, i_NatOfVisit, i_BkgID);
	END IF;

	-- vaccine #1
	IF GET_CURRENT_STECODE = 'HKAH' AND v_InitialAssessed = '61' THEN
		IF i_PATNO IS NOT NULL THEN
			UPDATE BOOKING
			SET BKGSTS = STATUS_PENDING
			WHERE BKGID = v_BKGID;

			UPDATE HPSTATUS
			SET HPSDATE = v_BKGSDATE, HPRMK1 = v_BKGID
			WHERE  HPTYPE = 'VACCINE'
			AND    HPKEY = 'COVID19'
			AND    HPSTATUS = i_PATNO;
		ELSE
			-- update slot
			UPDATE SLOT
			SET    SLTCNT = SLTCNT + 1
			WHERE  SCHID = TO_NUMBER(i_SCHID)
			AND    SltSTime BETWEEN v_BKGSDATE AND v_BKGEDATE;

			-- update schedule
			UPDATE SCHEDULE
			SET    SCHCNT = SCHCNT + 1
			WHERE  SCHID = TO_NUMBER(i_SCHID);
		END IF;

		o_errMsg := '<font color=''red''>Please remember to make booking for vaccine 2nd shot after ' || TO_CHAR(v_VaccineDate1, 'DD/MM/YYYY') || ' for this patient.</font>';
	ELSE
		-- update slot
		UPDATE SLOT
		SET    SLTCNT = SLTCNT + 1
		WHERE  SCHID = TO_NUMBER(i_SCHID)
		AND    SltSTime BETWEEN v_BKGSDATE AND v_BKGEDATE;

		-- update schedule
		UPDATE SCHEDULE
		SET    SCHCNT = SCHCNT + 1
		WHERE  SCHID = TO_NUMBER(i_SCHID);
	END IF;

	-- vaccine #2
	IF GET_CURRENT_STECODE = 'HKAH' AND v_InitialAssessed = '62' THEN
		v_VaccineDate2 := v_BKGSDATE;
		v_BKGID2 := v_BKGID;

		IF i_PATNO IS NOT NULL THEN
			UPDATE HPSTATUS
			SET HPEDATE = v_BKGSDATE, HPRMK2 = v_BKGID2
			WHERE  HPTYPE = 'VACCINE'
			AND    HPKEY = 'COVID19'
			AND    HPSTATUS = i_PATNO;

			SELECT HPRMK1 INTO v_BKGID1
			FROM   HPSTATUS
			WHERE  HPTYPE = 'VACCINE'
			AND    HPKEY = 'COVID19'
			AND    HPSTATUS = i_PATNO;

			IF v_BKGID1 IS NOT NULL THEN
				SELECT COUNT(1) INTO v_count
				FROM   BOOKING
				WHERE  BKGID = v_BKGID1
				AND    PATNO = i_PATNO
				AND    BKGSTS != STATUS_CANCEL;

				IF v_count = 1 THEN
					SELECT SCHID, BKGSDATE, BKGEDATE, BKGSTS INTO v_SCHID, v_BKGSDATE, v_BKGEDATE, v_BKGSTS
					FROM   BOOKING
					WHERE  BKGID = v_BKGID1
					AND    PATNO = i_PATNO;

					v_VaccineDate1 := v_BKGSDATE;

					IF v_BKGSTS = STATUS_PENDING THEN
						UPDATE BOOKING
						SET BKGSTS = STATUS_NORMAL
						WHERE BKGID = v_BKGID1;

						-- update slot
						UPDATE SLOT
						SET    SLTCNT = SLTCNT + 1
						WHERE  SCHID = TO_NUMBER(v_SCHID)
						AND    SltSTime BETWEEN v_BKGSDATE AND v_BKGEDATE;

						-- update schedule
						UPDATE SCHEDULE
						SET    SCHCNT = SCHCNT + 1
						WHERE  SCHID = TO_NUMBER(v_SCHID);
					END IF;

					UPDATE BOOKING
					SET BKGRMK = '1st dose and 2nd dose on ' || TO_CHAR(v_VaccineDate2, 'DD/MM/YYYY HH24:MI:SS')
					WHERE BKGID = v_BKGID1;

					UPDATE BOOKING
					SET BKGRMK = '2nd dose and 1st dose on ' || TO_CHAR(v_VaccineDate1, 'DD/MM/YYYY HH24:MI:SS')
					WHERE BKGID = v_BKGID2;

					o_errMsg := 'Vaccine Booking is completed. Patient <font color=''blue''>' || i_PATNO || '</font> booked shot 1 at <font color=''blue''>' || TO_CHAR(v_VaccineDate1, 'DD/MM/YYYY HH24:MI:SS') || '</font> and shot 2 at <font color=''blue''>' || TO_CHAR(v_VaccineDate2, 'DD/MM/YYYY HH24:MI:SS') || '</font>.';
				ELSE
					o_errMsg := 'Vaccine Booking is completed. Patient booked shot 2 at <font color=''blue''>' || TO_CHAR(v_VaccineDate2, 'DD/MM/YYYY HH24:MI:SS') || '</font>.';
				END IF;
			ELSE
				o_errMsg := 'Vaccine Booking is completed. Patient booked shot 2 at <font color=''blue''>' || TO_CHAR(v_VaccineDate2, 'DD/MM/YYYY HH24:MI:SS') || '</font>.';
			END IF;
		ELSE
			o_errMsg := 'Vaccine Booking is completed. Patient booked shot 2 at <font color=''blue''>' || TO_CHAR(v_VaccineDate2, 'DD/MM/YYYY HH24:MI:SS') || '</font>.';
		END IF;
	ELSIF GET_CURRENT_STECODE = 'HKAH' AND v_InitialAssessed = '63' THEN
		v_VaccineDate1 := v_BKGSDATE;
		v_BKGID1 := v_BKGID;

		IF i_PATNO IS NOT NULL THEN
			UPDATE HPSTATUS
			SET HPSDATE = v_BKGSDATE, HPRMK1 = v_BKGID1
			WHERE  HPTYPE = 'VACCINE'
			AND    HPKEY = 'COVID19'
			AND    HPSTATUS = i_PATNO;
		END IF;

		o_errMsg := 'Vaccine Booking is completed. Patient booked shot 1 at <font color=''blue''>' || TO_CHAR(v_VaccineDate1, 'DD/MM/YYYY HH24:MI:SS') || '</font>.';
	END IF;

	v_rslt := NHS_ACT_RECORDUNLOCK('', 'Schedule', i_SCHID, i_ComputerName, i_UsrID, v_errMsg);

	RETURN v_BKGID;
<<UnlockSchedule>>
	v_rslt := NHS_ACT_RECORDUNLOCK('', 'Schedule', i_SCHID, i_ComputerName, i_UsrID, v_errMsg);
	RETURN o_errCode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	v_rslt := NHS_ACT_RECORDUNLOCK('', 'Schedule', i_SCHID, i_ComputerName, i_UsrID, o_errMsg);
	o_errMsg := 'Fail to make booking.';
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - ' || SQLCODE || ' -ERROR- '||SQLERRM);
	RETURN o_errCode;
END NHS_ACT_BOOKING;
/
