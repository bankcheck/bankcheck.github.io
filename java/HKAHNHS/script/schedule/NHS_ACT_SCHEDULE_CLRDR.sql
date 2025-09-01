CREATE OR REPLACE FUNCTION "NHS_ACT_SCHEDULE_CLRDR" (
	i_action       IN VARCHAR2,
	i_DocCode      IN VARCHAR2,
	i_SchSDate     IN VARCHAR2,
	i_IsBlock      IN VARCHAR2,
	i_COMPUTERNAME IN VARCHAR2,
	i_UserID       IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
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
	MSG_GENERATE_FAIL VARCHAR2(27) := 'Schedule generation failed.';
BEGIN
	v_noOfRec := 0;
	o_errmsg := 'OK';

	v_SchSDate := TRIM(TO_DATE(i_SchSDate, 'DD/MM/YYYY HH24:MI:SS'));
--	v_SchEDate := TRIM(TO_DATE(i_SchEDate, 'DD/MM/YYYY HH24:MI:SS'));

--	IF v_SchSDate >= v_SchEDate THEN
--		o_errmsg := MSG_ADDSCH_SAMEDATE;
--		RETURN -1;
--	END IF;

	v_CurrDate := TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY'), 'DD/MM/YYYY');
	IF v_CurrDate > v_SchSDate THEN
		o_errmsg := MSG_ADDSCH_PASSDATE;
		RETURN -1;
	END IF;

	-- check existing records
	SELECT COUNT(1) INTO v_noOfRec
	FROM   schedule sch, slot slt
	WHERE  slt.sltstime > v_SchSDate
	AND    slt.sltcnt > 0
	AND    sch.schid = slt.schid
	AND    sch.schsts = 'N'
	AND   (sch.doccode = i_DocCode OR i_DocCode IS NULL);

	IF v_noOfRec > 0 THEN
		IF i_IsBlock = 'N' THEN
			o_errmsg := 'Appointment already exists within the date range! Block the Appointment?';
			RETURN -100;
		ELSE
			v_IsCallBlock := TRUE;
			-- BlockExistApp
			FOR R IN (
				SELECT sch.SchLen, slt.SltSTime, sch.SchID, slt.SltID
				FROM   Schedule sch, Slot slt
				WHERE  slt.sltstime > v_SchSDate
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

				v_NewSchID := NHS_ACT_SCHEDULE_BLOCK(i_action, TO_CHAR(v_SchID), TO_CHAR(R.SltSTime, 'DD/MM/YYYY HH24:MI'), TO_CHAR(R.SltSTime + (R.SchLen - 1) / 1440, 'DD/MM/YYYY HH24:MI'), i_UserID, o_errmsg);

				IF v_NewSchID < 0 THEN
					ROLLBACK;
					RETURN v_NewSchID;
				END IF;
			END LOOP;
		END IF;
	END IF;

	-- DeleteExistSch
	DELETE FROM slot
	WHERE  schid IN ( SELECT schid
					  FROM   schedule
					  WHERE  schsts = 'N'
					  AND    schsdate >= v_SchSDate
					  AND   (i_DocCode IS NULL OR doccode = i_DocCode)
	);
	
	DELETE FROM Schedule_extra
	WHERE  schid in (
	    select schid from Schedule
	        WHERE  schsts = 'N'
		AND    schsdate >= v_SchSDate
		AND   (i_DocCode IS NULL OR doccode = i_DocCode)
    );

	DELETE FROM Schedule
	WHERE  schsts = 'N'
	AND    schsdate >= v_SchSDate
	AND   (i_DocCode IS NULL OR doccode = i_DocCode);
/* hide regenearte schedule from act_schedule_muti
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
		v_noOfRec := NHS_ACT_SCHEDULE(i_action, R.DocCode,
			R.TEMSTIME, R.TEMETIME, TO_CHAR(v_SchSDate, 'DD/MM/YYYY'), TO_CHAR(v_SchEDate, 'DD/MM/YYYY'),
			TO_CHAR(R.TEMLEN), TO_CHAR(R.TEMDAY), R.DOCPRACTICE, R.DOCLOCID, 'N', i_COMPUTERNAME, i_UserID, o_errmsg);

		IF v_noOfRec < 0 THEN
			ROLLBACK;
			RETURN v_noOfRec;
		END IF;
	END LOOP;
*/
	RETURN v_noOfRec;
EXCEPTION
WHEN OTHERS THEN
	o_errmsg := MSG_GENERATE_FAIL;
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	ROLLBACK;
	RETURN -1;
END NHS_ACT_SCHEDULE_CLRDR;
/
