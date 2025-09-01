CREATE OR REPLACE FUNCTION "NHS_ACT_SCHEDULE_MUTI" (
	i_action       IN VARCHAR2,
	i_DocCode      IN VARCHAR2,
	i_SchSDate     IN VARCHAR2,
	i_SchEDate     IN VARCHAR2,
	i_IsBlock      IN VARCHAR2,
	i_COMPUTERNAME IN VARCHAR2,
	i_UserID       IN VARCHAR2,
	o_ErrMsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
	v_SchID NUMBER;
	v_OldSchID NUMBER;
	v_NewSchID NUMBER;
	v_IsCallBlock BOOLEAN := FALSE;
	v_SchSDate DATE;
	v_SchEDate DATE;
	v_CurrDate DATE;

	MSG_ADDSCH_SAMEDATE VARCHAR2(21) := 'Date range incorrect.';
	MSG_ADDSCH_PASSDATE VARCHAR2(53) := 'Creation of schedule with passed date is not allowed.';
	MSG_GENERATE_FAIL VARCHAR2(34) := 'Schedule generation failed due to ';
	MSG_ACCESS_DENY_ALL VARCHAR2(64) := 'Schedule generation failed due to no user rights to all doctors.';
	MSG_ACCESS_DENY_SELECTED VARCHAR2(70) := 'Schedule generation failed due to no user rights for selected doctors.';

	v_Logrmk VARCHAR2(500);
	o_ErrMsg1 Varchar2(500);
	o_ErrCode NUMBER;
BEGIN
	v_noOfRec := 0;
	o_ErrMsg := 'OK';

	v_SchSDate := TRIM(TO_DATE(i_SchSDate, 'DD/MM/YYYY HH24:MI:SS'));
	v_SchEDate := TRIM(TO_DATE(i_SchEDate, 'DD/MM/YYYY HH24:MI:SS'));

	v_Logrmk :='<[NHS_ACT_SCHEDULE_MUTI 1]i_DocCode:'||i_DocCode||' i_SchSDate:'||i_SchSDate||
	     'i_SchEDate:'||i_SchEDate||'i_IsBlock:'||i_IsBlock||'i_UserID:'||I_Userid||'>';

	IF v_SchSDate >= v_SchEDate THEN
		o_ErrMsg := MSG_ADDSCH_SAMEDATE;
		RETURN -1;
	END IF;

	v_CurrDate := TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY'), 'DD/MM/YYYY');
	IF v_CurrDate > v_SchSDate THEN
		o_ErrMsg := MSG_ADDSCH_PASSDATE;
		RETURN -1;
	END IF;

	-- check access right
	SELECT COUNT(1) INTO v_noOfRec FROM USRACCESSDOC WHERE USRID = i_UserID AND DOCCODE = 'ALL' AND SPCCODE != 'ALL';

	IF v_noOfRec > 0 THEN
		IF i_DocCode IS NULL THEN
			o_ErrMsg := MSG_ACCESS_DENY_ALL;
			RETURN -1;
		ELSE
			SELECT COUNT(1) INTO v_noOfRec
			FROM   DOCTOR
			WHERE  DOCCODE = i_DocCode
			AND   (DOCCODE IN (SELECT DOCCODE FROM USRACCESSDOC WHERE USRID = i_UserID AND SPCCODE = 'ALL')
			OR     SPCCODE IN (SELECT SPCCODE FROM USRACCESSDOC WHERE USRID = i_UserID  AND DOCCODE = 'ALL'));

			IF v_noOfRec = 0 THEN
				o_ErrMsg := MSG_ACCESS_DENY_SELECTED;
				RETURN -1;
			END IF;
		END IF;
	END IF;

	-- check existing records
	SELECT COUNT(1) INTO v_noOfRec
	FROM   schedule sch, slot slt
	WHERE  slt.sltstime BETWEEN v_SchSDate AND v_SchEDate + 1
	AND    slt.sltcnt > 0
	AND    sch.schid = slt.schid
	AND    sch.schsts = 'N'
	AND   (sch.doccode = i_DocCode OR i_DocCode IS NULL);

	IF v_noOfRec > 0 THEN
		IF i_IsBlock = 'N' THEN
       			v_Logrmk :=v_Logrmk||'<[NHS_ACT_SCHEDULE_MUTI 2] POP ALREADY EXISTING MSG>Record:'||v_noOfRec;
				o_ErrMsg := 'Appointment already exists within the date range! Block the Appointment?';
      			o_ErrCode := NHS_ACT_Syslog('ADD', 'ACT_SCHEDULE', 'ACT_SCHEDULE_MUTI', v_Logrmk, I_Userid, Null, o_ErrMsg1);
			RETURN -100;
		ELSE
			v_IsCallBlock := TRUE;
			-- BlockExistApp
			FOR R IN (
				SELECT sch.SchLen, slt.SltSTime, sch.SchID, slt.SltID
				FROM   Schedule sch, Slot slt
				WHERE  slt.sltstime BETWEEN v_SchSDate AND v_SchEDate + 1
				AND    slt.sltcnt > 0
				AND    sch.schid = slt.schid
				AND    sch.schsts = 'N'
				AND   (sch.doccode = i_DocCode OR i_DocCode IS NULL))
			LOOP
				IF v_OldSchID IS NULL AND v_NewSchID IS NULL THEN
					v_OldSchID := R.SchID;
					v_NewSchID := v_OldSchID;
				END IF;

				v_SchID := R.SchID;
				IF v_SchID = v_OldSchID THEN
					v_SchID := v_NewSchID;
				ELSE
					v_OldSchID := v_SchID;
					v_NewSchID := v_OldSchID;
				END IF;

				v_NewSchID := NHS_ACT_SCHEDULE_BLOCK(i_action, TO_CHAR(v_SchID), TO_CHAR(R.SltSTime, 'DD/MM/YYYY HH24:MI'), TO_CHAR(R.SltSTime + (R.SchLen - 1) / 1440, 'DD/MM/YYYY HH24:MI'), i_UserID, o_ErrMsg);

				IF v_NewSchID < 0 THEN
					ROLLBACK;
					RETURN v_NewSchID;
				END IF;
			END LOOP;
		END IF;
	END IF;
  	v_Logrmk :=v_Logrmk||'<[NHS_ACT_SCHEDULE_MUTI 3] DELETE FROM SLOT AND SCHEDULE>';
	-- DeleteExistSch
	DELETE FROM slot
	WHERE  schid IN ( SELECT schid
					  FROM   schedule
					  WHERE  schsts = 'N'
					  AND    schsdate >= v_SchSDate
					  AND    schedate <= v_SchEDate + 1
					  AND   (i_DocCode IS NULL OR doccode = i_DocCode)
	);
	
	DELETE FROM Schedule_extra
	WHERE SCHID IN (
		SELECT SCHID FROM Schedule
		WHERE  schsts = 'N'
		AND    schsdate >= v_SchSDate
		AND    schedate <= v_SchEDate + 1
		AND   (i_DocCode IS NULL OR doccode = i_DocCode)
	);

	DELETE FROM Schedule
	WHERE  schsts = 'N'
	AND    schsdate >= v_SchSDate
	AND    schedate <= v_SchEDate + 1
	AND   (i_DocCode IS NULL OR doccode = i_DocCode);

	FOR R IN (
		SELECT DISTINCT t.DocCode,
			TO_CHAR(t.TEMSTIME, 'HH24:MI') TEMSTIME, TO_CHAR(t.TEMETIME, 'HH24:MI') TEMETIME,
			t.TEMLEN, t.TEMDAY, t.DOCPRACTICE, t.DOCLOCID
		FROM   template t, doctor d
		WHERE  t.doccode = d.doccode
		AND    d.docsts = -1
		AND   (t.doccode = i_DocCode OR i_DocCode IS NULL)
		AND    t.SteCode = GET_CURRENT_STECODE
		ORDER BY t.TEMDAY, t.DocCode)
	LOOP
	    	IF(R.TEMLEN > 0) THEN
	      		v_noOfRec := NHS_ACT_SCHEDULE(i_action, R.DocCode,
				R.TEMSTIME, R.TEMETIME, TO_CHAR(v_SchSDate, 'DD/MM/YYYY'), TO_CHAR(v_SchEDate, 'DD/MM/YYYY'),
				TO_CHAR(R.TEMLEN), TO_CHAR(R.TEMDAY), R.DOCPRACTICE, R.DOCLOCID, 'N', i_COMPUTERNAME, i_UserID, o_ErrMsg);

			IF v_noOfRec < 0 THEN
				ROLLBACK;
				RETURN v_noOfRec;
			END IF;
	    	END IF;
	END LOOP;

  	o_ErrCode := NHS_ACT_Syslog('ADD', 'ACT_SCHEDULE', 'ACT_SCHEDULE_MUTI', v_Logrmk, I_Userid, Null, o_ErrMsg1);
	RETURN v_noOfRec;
EXCEPTION
WHEN OTHERS THEN
	o_ErrMsg := MSG_GENERATE_FAIL || SQLERRM || '.';
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	ROLLBACK;
	RETURN -1;
END NHS_ACT_SCHEDULE_MUTI;
/
