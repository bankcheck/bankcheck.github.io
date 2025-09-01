create or replace FUNCTION "NHS_ACT_SCHEDULE_BY_LOC" (
	v_action       IN VARCHAR2,
	v_DOCLOCID     IN VARCHAR2,
	v_SchSDate     IN VARCHAR2,
	v_SchEDate     IN VARCHAR2,
	v_IsBlock      IN VARCHAR2,
	v_COMPUTERNAME IN VARCHAR2,
	v_UserID       IN VARCHAR2,
	o_ErrMsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
	v_SchID NUMBER;
	v_OldSchID NUMBER;
	v_NewSchID NUMBER;
	v_IsCallBlock BOOLEAN := FALSE;

	v_logRmk VARCHAR2(500);
	o_ErrMsg1 VARCHAR2(500);
	o_ErrCode NUMBER;

	MSG_GENERATE_FAIL VARCHAR2(34) := 'Schedule generation failed due to ';
	MSG_ACCESS_DENY_SELECTED VARCHAR2(85) := 'Schedule generation failed due to no user rights to all doctors in selected location.';
BEGIN
	v_noOfRec := 0;
	o_ErrMsg := 'OK';
	v_logRmk :='<[NHS_ACT_SCHEDULE_BY_LOC 1]v_DOCLOCID:'||v_DOCLOCID||' v_SchSDate:'||v_SchSDate||
	     'v_SchEDate:'||v_SchEDate||'v_IsBlock:'||v_IsBlock||'v_UserID:'||v_UserID||'>';

	-- check access right
	SELECT COUNT(1) INTO v_noOfRec FROM USRACCESSDOC WHERE USRID = v_UserID AND DOCCODE = 'ALL' AND SPCCODE != 'ALL';

	IF v_noOfRec > 0 THEN
		o_ErrMsg := MSG_ACCESS_DENY_SELECTED;
		RETURN -1;
	END IF;

	-- check existing records
	SELECT COUNT(1) INTO v_noOfRec
	FROM   schedule sch, slot slt
	WHERE  slt.sltstime BETWEEN TO_DATE(v_SchSDate, 'DD/MM/YYYY') AND TO_DATE(v_SchEDate, 'DD/MM/YYYY') + 1
	AND    slt.sltcnt > 0
	AND    sch.schid = slt.schid
	AND    sch.SCHSTS = 'N'
	AND    sch.DOCLOCID = v_DOCLOCID;

	IF v_noOfRec > 0 THEN
		IF v_IsBlock = 'N' THEN
			v_logRmk :=v_logRmk||'<[NHS_ACT_SCHEDULE_BY_LOC 3] POP block app alert>';
			o_ErrMsg := 'Appointment already exists within the date range! Block the Appointment?';
			o_ErrCode := NHS_ACT_SYSLOG('ADD', 'ACT_SCHEDULE', 'ACT_SCH_BY_LOC', v_logRmk, v_UserID, NULL, o_ErrMsg1);
			RETURN -100;
		ELSE
			v_IsCallBlock := TRUE;
			-- BlockExistApp
			FOR R IN (
				SELECT sch.SchLen, slt.SltSTime, sch.SchID, slt.SltID
				FROM   schedule sch, slot slt
				WHERE  slt.sltstime BETWEEN TO_DATE(v_SchSDate, 'DD/MM/YYYY') AND TO_DATE(v_SchEDate, 'DD/MM/YYYY') + 1
				AND    slt.sltcnt > 0
				AND    sch.schid = slt.schid
				AND    sch.schsts = 'N'
				AND    sch.DOCLOCID = v_DOCLOCID)
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

				v_NewSchID := NHS_ACT_SCHEDULE_BLOCK(v_action, TO_CHAR(v_SchID), TO_CHAR(R.SltSTime, 'DD/MM/YYYY HH24:MI'), TO_CHAR(R.SltSTime + (R.SchLen - 1) / 1440, 'DD/MM/YYYY HH24:MI'), v_UserID, o_ErrMsg);

				IF v_NewSchID < 0 THEN
					ROLLBACK;
					RETURN v_NewSchID;
				END IF;
			END LOOP;
		END IF;
	END IF;
	v_logRmk :=v_logRmk||'<[NHS_ACT_SCHEDULE_BY_LOC 5:DELETE FROM Slot 1]>';

	-- DeleteExistSch
	DELETE FROM Slot
	WHERE  schid IN (
		SELECT s.schid
		FROM   Schedule s
		WHERE  schsts = 'N'
		AND    s.schsdate >= TO_DATE(v_SchSDate, 'DD/MM/YYYY')
		AND    s.schedate <= TO_DATE(v_SchEDate, 'DD/MM/YYYY') + 1
		AND    s.DOCLOCID = v_DOCLOCID
	);
	v_logRmk :=v_logRmk||'<[NHS_ACT_SCHEDULE_BY_LOC 5:DELETE FROM SCHEDULE 1>';
	DELETE FROM Schedule
	WHERE  schid IN (
		SELECT s.schid
		FROM   Schedule s
		WHERE  schsts = 'N'
		AND    s.schsdate >= TO_DATE(v_SchSDate, 'DD/MM/YYYY')
		AND    s.schedate <= TO_DATE(v_SchEDate, 'DD/MM/YYYY') + 1
		AND    s.DOCLOCID = v_DOCLOCID
	);

	FOR R IN (
		SELECT t.DocCode, TO_CHAR(t.TEMSTIME, 'HH24:MI') TEMSTIME, TO_CHAR(t.TEMETIME, 'HH24:MI') TEMETIME, t.TEMLEN, t.TEMDAY, t.DOCPRACTICE, t.DOCLOCID, t.RMID
		FROM   template t, doctor d
		WHERE  t.doccode = d.doccode
		AND    d.docsts = -1
		AND    t.DOCLOCID = v_DOCLOCID
		AND    t.SteCode = GET_CURRENT_STECODE
		ORDER BY t.DocCode, t.TEMDAY)
	LOOP
		v_noOfRec := NHS_ACT_SCHEDULE(v_action, R.DocCode, R.TEMSTIME, R.TEMETIME, v_SchSDate, v_SchEDate, TO_CHAR(R.TEMLEN), TO_CHAR(R.TEMDAY), R.DOCPRACTICE, R.DOCLOCID, 'N', R.RMID, v_COMPUTERNAME, v_UserID, o_ErrMsg);
		IF v_noOfRec < 0 THEN
			ROLLBACK;
			RETURN v_noOfRec;
		END IF;
	END LOOP;
	o_ErrCode := NHS_ACT_Syslog('ADD', 'ACT_SCHEDULE', 'ACT_SCH_BY_LOC', v_Logrmk, v_Userid, Null, o_ErrMsg1);

	RETURN v_noOfRec;
EXCEPTION
WHEN OTHERS THEN
	o_ErrMsg := MSG_GENERATE_FAIL || SQLERRM || '.';
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	ROLLBACK;
	RETURN -1;
END NHS_ACT_SCHEDULE_BY_LOC;
/