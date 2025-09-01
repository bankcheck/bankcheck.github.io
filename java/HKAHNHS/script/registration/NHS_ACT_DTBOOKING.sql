create or replace FUNCTION      "NHS_ACT_DTBOOKING" (
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
	i_BkgID        IN VARCHAR2,
	i_Override     IN VARCHAR2,
	i_UsrID        IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_LblRmk       IN VARCHAR2,
	o_errMsg       OUT VARCHAR2
)
	RETURN  NUMBER
AS
	v_noOfRec Integer;
	v_noOfSameRec INTEGER;
  v_noOfSameRmRec INTEGER;
	v_appointmentDayCount INTEGER;
	v_count INTEGER;
	v_BKGSDATE DATE;
	v_BKGEDATE DATE;
	v_BKGID BOOKING.BKGID%TYPE;
	v_PATCNAME PATIENT.PATCNAME%TYPE;
	v_HPHONE PATIENT.PATHTEL%TYPE;
	v_MPHONE PATIENT.PATPAGER%TYPE;
	v_PatSMS NUMBER(1);
	v_SCHSTS SCHEDULE.SCHSTS%TYPE;
	v_DOCLOCID SCHEDULE.DOCLOCID%TYPE;
	v_rslt NUMBER;
	V_FULLNAME VARCHAR2(81);
	v_patcnt NUMBER;
	v_errMsg VARCHAR2(500);
	v_expirydate VARCHAR2(10);
	v_Schdate VARCHAR2(50);
	v_docname VARCHAR2(90);
  v_TEMPMOLTYPE VARCHAR(20);
	v_LMP DATE;
	v_EDC DATE;
	o_errCode NUMBER := -1;

	SCH_CANCEL VARCHAR2(1) := 'C';
BEGIN
	v_noOfRec := -1;
	o_errMsg := 'OK';

	IF i_BkgID IS NOT NULL THEN
		o_errCode := NHS_ACT_BOOKING_CANCEL(i_action, i_BkgID, i_UsrID, o_errMsg);
	END IF;

	SELECT SLTSTIME INTO v_BKGSDATE FROM SLOT WHERE SLTID = TO_NUMBER(i_SLTID);
	v_BKGEDATE := v_BKGSDATE + (TO_NUMBER(i_SLOT) * TO_NUMBER(i_SESSION) - 1) / (24*60);
	v_PATCNAME := '';

	-- check doctor status
	SELECT DOCSTS INTO v_noOfRec FROM DOCTOR WHERE DOCCODE = i_DOCCODE;
	IF v_noOfRec != -1 THEN
		SELECT TO_CHAR(DOCTDATE, 'DD/MM/YYYY') INTO v_expirydate
		FROM Doctor
		WHERE UPPER(DocCode) = UPPER(i_DOCCODE);

		o_errMsg := 'Inactive doctor.<br/>Admission Expiry Date: ' || v_expirydate;
		RETURN -1;
	END IF; 

	-- lock
	v_rslt := NHS_ACT_RECORDLOCK('', 'Schedule', i_SCHID, i_ComputerName, i_UsrID, o_errMsg);
	IF v_rslt <> 0 THEN
		return -1;
	END IF;

	
	
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
	SELECT count(1) INTO v_noOfRec FROM BOOKING where SCHID = TO_NUMBER(i_SCHID) AND SLTID = TO_NUMBER(i_SLTID) AND PATNO = i_PATNO AND BKGSTS NOT IN (SCH_CANCEL);
	IF v_noOfRec > 0 THEN
		o_errMsg := 'Appointment already exists for this patient.';
		GOTO UnlockSchedule;
	END IF;

	-- allow book previous two hours only
	IF v_BKGSDATE < SYSDATE - (120 / 1440) THEN
		o_errMsg := 'Appointment can only allow two hours before.';
		GOTO UnlockSchedule;
	END IF;

	-- if already booked
	IF i_Override = 'N' THEN
		SELECT SLTCNT INTO v_noOfRec FROM SLOT WHERE SCHID = TO_NUMBER(i_SCHID) AND SLTID = TO_NUMBER(i_SLTID);
    
    SELECT COUNT(1) INTO v_noOfSameRmRec
    FROM   BOOKING B
    WHERE B.BKGSTS NOT IN ('C','U')
    AND    B.DOCLOCID = '3'
    AND B.BKGSDATE >= TO_DATE(TO_CHAR(v_BKGSDATE, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI:SS')
    AND B.BKGSDATE  < TO_DATE(TO_CHAR(v_BKGEDATE, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI:SS')
    AND B.BKGEDATE >= TO_DATE(TO_CHAR(v_BKGSDATE, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI:SS')
    AND B.BKGEDATE  < TO_DATE(TO_CHAR(v_BKGEDATE, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI:SS');
--    AND    (B.BKGSDATE < TO_DATE(TO_CHAR(v_BKGSDATE, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI') OR B.BKGSDATE < TO_DATE(TO_CHAR(v_BKGEDATE, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI'))
--    AND    (B.BKGEDATE > TO_DATE(TO_CHAR(v_BKGSDATE, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI') OR B.BKGEDATE > TO_DATE(TO_CHAR(v_BKGEDATE, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI'));
    

		SELECT Count(1) INTO v_noOfSameRec
		FROM   Booking B, Schedule S WHERE B.Schid = S.Schid
		AND   (B.Patno = i_PATNO)
		AND    S.Doccode = i_DOCCODE
    AND B.BKGSDATE >= TO_DATE(TO_CHAR(v_BKGSDATE, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI:SS')
		AND B.BKGSDATE < TO_DATE(TO_CHAR(v_BKGSDATE, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI:SS')
    AND B.BKGEDATE >= TO_DATE(TO_CHAR(v_BKGSDATE, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI:SS') 
    AND B.BKGEDATE < TO_DATE(TO_CHAR(v_BKGSDATE, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI:SS')
		AND    B.BKGSTS not in (SCH_CANCEL);



		SELECT DOCFNAME || DOCGNAME INTO v_docname FROM DOCTOR WHERE doccode = i_DOCCODE;

		IF v_noOfRec > 0 THEN
			o_errMsg := '<font color=''blue''>Appointment has already exist in the time slot.</font></br>';
		END IF;
    
--    IF V_NOOFSAMERMREC > 0 THEN
--      o_errMsg := '<font color=''red''>Appointment has already exist in this Room</font></br>';
--    END IF;

		IF v_noOfSameRec > 0 THEN
			IF v_noOfRec > 0 THEN
				o_errMsg := o_errMsg || 'Patient ' || i_PATNO || ' has Appointment with Doctor <font color=''red''>' || v_docname || '</br>on the same date. </font>';
			ELSE
				o_errMsg := 'Patient ' || i_PATNO || ' (' || TRIM(i_FULLNAME) || ') has Appointment with Doctor <font color=''red''>' || v_docname || ' </br>on the same date (' || v_BKGSDATE || '). </font>';
			END IF;
		END IF;

		If v_noOfRec > 0 Or v_noOfSameRec > 0 OR v_noOfSameRmRec > 0 Then
			o_errMsg := o_errMsg || ' Continue?';
			o_errCode := -2;
			GOTO UnlockSchedule;
		END IF;
	END IF;

	-- check fullname length
	IF LENGTH(TRIM(i_FULLNAME)) > 81 THEN
		V_FULLNAME := SUBSTR(i_FULLNAME, 1, 81);
	ELSE
		V_FULLNAME := i_FULLNAME;
	END IF;

	-- check remark length
	IF LENGTH(I_REMARK) > 175 THEN
		o_errMsg := 'Remark is too long.';
		GOTO UnlockSchedule;
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

	IF i_PATNO IS NOT NULL THEN
		SELECT PatSMS INTO v_PatSMS FROM Patient WHERE Patno = i_PATNO;
	ELSIF i_MPHONE IS NOT NULL THEN
		v_PatSMS := -1;
	ELSE
		v_PatSMS := 0;
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
		DOCLOCID,
		STECODE,
		USRID
	) VALUES (
		v_BKGID,
		TO_NUMBER(i_SCHID),
		TO_NUMBER(i_SLTID),
		i_PATNO,
		V_FULLNAME,
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
		v_PatSMS,
		I_SMCID,
    '0',
		'3',
		GET_CURRENT_STECODE,
		i_UsrID
	);

	-- insert booking extra
	IF i_LblRmk IS NOT NULL AND LENGTH(i_LblRmk) > 0 THEN
		INSERT INTO BOOKING_EXTRA (BKGID, LBLRMK)
		VALUES (v_BKGID, i_LblRmk);
		IF (length(i_REMARK || i_LblRmk) < 175) THEN
	      		UPDATE BOOKING
	      		SET BKGRMK = i_LblRmk || ' ' || i_REMARK
	      		WHERE BKGID = v_BKGID;
	    	END IF;
	END IF;

	-- update slot
	UPDATE SLOT
	SET    SLTCNT = SLTCNT + 1
	WHERE  SCHID = TO_NUMBER(i_SCHID)
	AND    SltSTime BETWEEN v_BKGSDATE AND v_BKGEDATE;

	-- update schedule
	UPDATE SCHEDULE
	SET    SCHCNT = SCHCNT + 1
	WHERE  SCHID = TO_NUMBER(i_SCHID);

	v_rslt := NHS_ACT_RECORDUNLOCK('', 'Schedule', i_SCHID, i_ComputerName, i_UsrID, v_errMsg);

	RETURN v_BKGID;
<<UnlockSchedule>>
	v_rslt := NHS_ACT_RECORDUNLOCK('', 'Schedule', i_SCHID, i_ComputerName, i_UsrID, v_errMsg);
	RETURN o_errCode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	v_rslt := NHS_ACT_RECORDUNLOCK('', 'Schedule', i_SCHID, i_ComputerName, i_UsrID, o_errMsg);
	o_errMsg := 'Fail to generate booking.';
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - ' || SQLCODE || ' -ERROR- '||SQLERRM);
	RETURN O_ERRCODE;
END NHS_ACT_DTBOOKING;
/
