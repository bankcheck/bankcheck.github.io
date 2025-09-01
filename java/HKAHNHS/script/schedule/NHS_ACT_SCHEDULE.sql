create or replace FUNCTION "NHS_ACT_SCHEDULE" (
	i_ACTION        IN VARCHAR2,
	i_DOCCODE       IN VARCHAR2,
	i_TEMSTIME      IN VARCHAR2,
	i_TEMETIME      IN VARCHAR2,
	i_SCHSDATE      IN VARCHAR2,
	i_SCHEDATE      IN VARCHAR2,
	i_TEMLEN        IN VARCHAR2,
	i_WEEKDAY       IN VARCHAR2,
	i_DOCPRACTICE   IN VARCHAR2,
	i_DOCLOCID      IN VARCHAR2,
	i_allowPH       IN VARCHAR2,
  i_RMID          IN VARCHAR2,
	i_COMPUTERNAME  IN VARCHAR2,
	i_USRID         IN VARCHAR2,
	o_errmsg        OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
	v_SCHID NUMBER;
	v_TEMLEN NUMBER;
	v_TEMSTIME DATE;
	v_TEMETIME DATE;
	v_SCHSDATE DATE;
	v_SCHEDATE DATE;
	v_date DATE;
	v_STECODE VARCHAR2(20);
	v_SCHNSLOT NUMBER;
	v_H NUMBER;
	v_M NUMBER;
	v_date1 DATE;
	v_DATE2 DATE;
	v_rslt NUMBER;
	errMsg VARCHAR2(500);
	DAY_DIFF NUMBER;
	v_MinDiff NUMBER;
	v_PHDay VARCHAR2(10);
	v_PHDesc VARCHAR2(100);
	v_msg VARCHAR2(1000);
BEGIN
	v_noOfRec := 0;
	o_errmsg := '';

	-- transfer
	v_TEMLEN := TO_NUMBER(i_TEMLEN);
	v_TEMSTIME := TO_DATE(i_TEMSTIME, 'HH24:MI');
	v_TEMETIME := TO_DATE(i_TEMETIME, 'HH24:MI');
	v_SCHSDATE := TO_DATE((i_SCHSDATE || ' ' || i_TEMSTIME), 'DD/MM/YYYY HH24:MI');
	v_SCHEDATE := TO_DATE((i_SCHEDATE || ' ' || i_TEMETIME), 'DD/MM/YYYY HH24:MI');
	v_STECODE := GET_CURRENT_STECODE;
	v_rslt := NHS_ACT_RECORDLOCK('', 'Slot', 'SltID', i_COMPUTERNAME, i_USRID, o_errmsg);

	SELECT TO_DATE(i_SCHEDATE, 'DD/MM/YYYY') - TO_DATE(i_SCHSDATE, 'DD/MM/YYYY') INTO DAY_DIFF FROM DUAL;

	IF v_rslt = 0 THEN
		SELECT TO_NUMBER(FLOOR((v_SCHEDATE - v_SCHSDATE) * 24 * 60)) MINUTES INTO v_MinDiff
		FROM DUAL;

		IF v_mindiff < v_temlen - 1 THEN
			v_rslt := NHS_ACT_RECORDUNLOCK('', 'Slot', 'SltID', i_COMPUTERNAME, i_USRID, o_errmsg);
			o_errmsg := 'The time range is smaller than duration. ';
			RETURN -1;
		END IF;

		-- add schedule
		FOR i In 0..DAY_DIFF
		LOOP
			v_date := TO_DATE(TO_CHAR(v_SCHSDATE + i, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI');

			-- proceed if same week of day
			IF i_weekDay IS NULL OR i_weekDay = TO_CHAR(v_date, 'D') THEN
				-- calculate time slot range
				v_date1 := TO_DATE(((TO_CHAR(v_date, 'DD/MM/YYYY') || ' ' || i_TEMSTIME)), 'DD/MM/YYYY HH24:MI');
				v_date2 := TO_DATE(((TO_CHAR(v_date, 'DD/MM/YYYY') || ' ' || i_TEMETIME)), 'DD/MM/YYYY HH24:MI');

				SELECT COUNT(1) INTO v_noOfRec
				FROM   SCHEDULE
				WHERE  doccode = i_DOCCODE
				AND    SchSDate <= v_date1
				AND    SchEDate >= v_date1
				AND    SchSts <> 'B';

				IF v_noOfRec > 0 THEN
					v_rslt := NHS_ACT_RECORDUNLOCK('', 'Slot', 'SltID', i_COMPUTERNAME, i_USRID, o_errmsg);
					o_errmsg := 'Duplicated schedule. ';
					RETURN -1;
				END IF;

				SELECT COUNT(1) INTO v_noOfRec
				FROM   SCHEDULE
				WHERE  doccode = i_DOCCODE
				AND    SchSDate < v_date2
				AND    SchEDate >= v_date2
				AND    SchSts <> 'B';

				IF v_noOfRec > 0 THEN
					v_rslt := NHS_ACT_RECORDUNLOCK('', 'Slot', 'SltID', i_COMPUTERNAME, i_USRID, o_errmsg);
					o_errmsg := 'Duplicated schedule. ';
					RETURN -1;
				END IF;

				SELECT COUNT(1) INTO v_noOfRec
				FROM   SCHEDULE
				WHERE  doccode = i_DOCCODE
				AND    SchSDate >= v_date1
				AND    SchEDate <= v_date2
				AND    SchSts <> 'B';

				IF v_noOfRec > 0 THEN
					v_rslt := NHS_ACT_RECORDUNLOCK('', 'Slot', 'SltID', i_COMPUTERNAME, i_USRID, o_errmsg);
					o_errmsg := 'Duplicated schedule. ';
					RETURN -1;
				END IF;

				SELECT COUNT(1) INTO v_noOfRec
				FROM   PUBLIC_HOLIDAY
				WHERE  TO_CHAR(HOLIDAY, 'DD/MM/YYYY') = TO_CHAR(v_date, 'DD/MM/YYYY')
				AND    ENABLED = 1;

				IF i_allowPH = 'N' AND v_noOfRec > 0 THEN
					SELECT TO_CHAR(HOLIDAY, 'DD/MM/YYYY'), DESCRIPTION INTO v_PHDay, v_PHDesc
					FROM PUBLIC_HOLIDAY
					WHERE TO_CHAR(HOLIDAY, 'DD/MM/YYYY') = TO_CHAR(v_date, 'DD/MM/YYYY')
					AND ENABLED = 1;

					v_msg := v_msg || v_PHDay || ', ';

					CONTINUE;
				END IF;

				v_H := TO_NUMBER(TO_CHAR(v_TEMETIME, 'hh24')) - TO_NUMBER(TO_CHAR(v_TEMSTIME, 'hh24'));
				v_M := TO_NUMBER(TO_CHAR(v_TEMETIME, 'mi')) - TO_NUMBER(TO_CHAR(v_TEMSTIME, 'mi')) + 1;
				v_SCHNSLOT := floor((v_H * 60 + v_M) / i_TEMLEN);

				SELECT SEQ_SCHEDULE.NEXTVAL INTO v_SCHID FROM DUAL;

				INSERT INTO SCHEDULE(
					SCHID,
					DOCCODE,
					STECODE,
					SCHSDATE,
					SCHEDATE,
					SCHLEN,
					SCHNSLOT,
					SCHCNT,
					SCHSTS,
					DOCPRACTICE,
					DOCLOCID,
					USRID_C,
					SCHDATE_C
				) VALUES(
					v_SCHID,
					i_DOCCODE,
					v_STECODE,
					TO_DATE(TO_CHAR(v_date, 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI'),
					TO_DATE(TO_CHAR((v_date + (v_SCHNSLOT * v_TEMLEN - 1) / (24 * 60)), 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI'),
					v_TEMLEN,
					v_SCHNSLOT,
					0,
					'N',
					i_DOCPRACTICE,
					i_DOCLOCID,
					i_USRID,
					SYSDATE
				);

				v_noOfRec := NHS_ACT_SYSLOG('ADD', 'Schedule', 'Create Schedule for ' || i_DOCCODE || ' from ' || TO_CHAR(v_date, 'DD/MM/YYYY HH24:MI') || ' to ' || TO_CHAR((v_date + (v_SCHNSLOT * v_TEMLEN - 1) / (24 * 60)), 'DD/MM/YYYY HH24:MI'), v_SCHID, i_USRID, i_COMPUTERNAME, o_errmsg);

				-- loop to add time slot
				-- WHILE v_date2 - v_date1 > 0 LOOP
				WHILE TO_NUMBER(CEIL((v_date2 - v_date1) * 24 * 60)) >= v_TEMLEN - 1 LOOP
					INSERT INTO SLOT(
						SCHID,
						SLTID,
						SLTCNT,
						SLTSTIME
					) VALUES(
						v_SCHID,
						SEQ_SLOT.NEXTVAL,
						0,
						v_date1
					);

					v_date1 := TO_DATE(TO_CHAR((v_date1 + v_TEMLEN / (24 * 60)), 'DD/MM/YYYY HH24:MI'), 'DD/MM/YYYY HH24:MI');
				END LOOP;
          INSERT INTO SCHEDULE_EXTRA (
          SCHID, RMID
          ) VALUES (
          v_SCHID,
          i_RMID);
			END IF;
		END LOOP;
		v_rslt := NHS_ACT_RECORDUNLOCK('', 'Slot', 'SltID', i_COMPUTERNAME,	i_USRID, errMsg);

		IF v_msg IS NULL THEN
			o_errmsg := 'Schedule successfully added.';
		ELSE
			IF DAY_DIFF = 0 THEN
				o_errmsg := 'Schedule added failure due to ' || SUBSTR(v_msg, 1, LENGTH(v_msg)-2) || ' is Public Holiday. Please tick the box next to Generate on Public Holiday to continue set up schedule';
			ELSE
				o_errmsg := 'Schedule successfully added. But the schedule on ' || SUBSTR(v_msg, 1, LENGTH(v_msg)-2) || ' does not be generated.';
			END IF;
		END IF;
	ELSE
		o_errmsg := 'Fail to generate schedule.';
		v_noOfRec := -1;
	END IF;

	RETURN v_noOfRec;
EXCEPTION
WHEN OTHERS THEN
	v_rslt := NHS_ACT_RECORDUNLOCK('', 'Slot', 'SltID', i_COMPUTERNAME, i_USRID, o_errmsg);
	o_errmsg := 'Fail to generate schedule.';
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - ' || SQLCODE || ' -ERROR- ' || SQLERRM);
	return -1;
	ROLLBACK;
END NHS_ACT_SCHEDULE;
/