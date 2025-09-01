CREATE OR REPLACE FUNCTION "NHS_ACT_SCHEDULE_SINGLE" (
	i_action       IN VARCHAR2,
	i_DocCode      IN VARCHAR2,
	i_SchSDate     IN VARCHAR2,
	i_SchEDate     IN VARCHAR2,
	i_TEMLEN       IN VARCHAR2,
	i_DOCPRACTICE  IN VARCHAR2,
	i_DOCLOCID     IN VARCHAR2,
	i_allowPH      IN VARCHAR2,
	i_Override     IN VARCHAR2,
	i_COMPUTERNAME IN VARCHAR2,
	i_UserID       IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
	v_SchSDate DATE;
	v_SchEDate DATE;
	v_CurrDate DATE;

	DOCTOR_STATUS_ACTIVE NUMBER := -1;
	MSG_ADDSCH_NOTSAME VARCHAR2(43) := 'The date range must be within the same day.';
	MSG_ADDSCH_PASSDATE VARCHAR2(53) := 'Creation of schedule with passed date is not allowed.';
BEGIN
	v_noOfRec := 0;
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO v_noOfRec FROM DOCTOR WHERE DocCode = i_DocCode AND DocSts = DOCTOR_STATUS_ACTIVE;
	IF v_noOfRec = 0 THEN
		o_errmsg := 'Please enter a valid active doctor.';
		RETURN -1;
	END IF;

	v_SchSDate := TO_DATE(i_SchSDate, 'DD/MM/YYYY HH24:MI:SS');
	v_SchEDate := TO_DATE(i_SchEDate, 'DD/MM/YYYY HH24:MI:SS');

	IF TO_CHAR(v_SchSDate, 'DD/MM/YYYY') <> TO_CHAR(v_SchEDate, 'DD/MM/YYYY') THEN
		o_errmsg := MSG_ADDSCH_NOTSAME;
		RETURN -1;
	END IF;

	v_CurrDate := TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY'), 'DD/MM/YYYY');
	IF v_CurrDate > v_SchSDate THEN
		o_errmsg := MSG_ADDSCH_PASSDATE;
		RETURN -1;
	END IF;

	SELECT COUNT(1) INTO v_noOfRec
	FROM   DOCTOR D LEFT JOIN DOCSPCLINK DL ON D.DocCode = DL.DocCode
	WHERE  D.DocCode = i_DocCode
	AND    D.DocSts = DOCTOR_STATUS_ACTIVE
	AND   (D.SPCCODE = 'OTORHIN'
	OR     DL.SPCCODE = 'OTORHIN');
	IF v_noOfRec > 0 THEN
		SELECT COUNT(1) INTO v_noOfRec
		FROM   SCHEDULE S, DOCTOR D
		WHERE  S.DOCCODE = D.DOCCODE
		AND   (v_SchSDate - 1/24 BETWEEN S.SCHSDATE AND S.SCHEDATE
		OR     v_SchEDate + 1/24 BETWEEN S.SCHSDATE AND S.SCHEDATE
		OR     S.SCHSDATE BETWEEN v_SchSDate - 1/24 AND v_SchEDate + 1/24
		OR     S.SCHEDATE BETWEEN v_SchSDate - 1/24 AND v_SchEDate + 1/24)
		AND    S.SCHSTS = 'N'
		AND   (D.DOCCODE IN (SELECT DOCCODE FROM DOCSPCLINK WHERE SPCCODE = 'OTORHIN')
		OR     D.DOCCODE IN (SELECT DOCCODE FROM DOCTOR WHERE SPCCODE = 'OTORHIN'));

		IF v_noOfRec > 0  and i_Override = 'N' THEN
			o_errmsg := 'There is another <font color=''green''>Otorhinolaryngology</font> Doctor in the same schedule (+/- 1 hour), are you sure to add schedule?';
			RETURN -100;
		END IF;
	END IF;

	SELECT COUNT(1) INTO v_noOfRec
	FROM   DOCTOR D LEFT JOIN DOCSPCLINK DL ON D.DocCode = DL.DocCode
	WHERE  D.DocCode = i_DocCode
	AND    D.DocSts = DOCTOR_STATUS_ACTIVE
	AND   (D.SPCCODE = 'OPTHAL'
	OR     DL.SPCCODE = 'OPTHAL');
	IF v_noOfRec > 0 THEN
		SELECT COUNT(1) INTO v_noOfRec
		FROM   SCHEDULE S, DOCTOR D
		WHERE  S.DOCCODE = D.DOCCODE
		AND   (v_SchSDate - 1/24 BETWEEN S.SCHSDATE AND S.SCHEDATE
		OR     v_SchEDate + 1/24 BETWEEN S.SCHSDATE AND S.SCHEDATE
		OR     S.SCHSDATE BETWEEN v_SchSDate - 1/24 AND v_SchEDate + 1/24
		OR     S.SCHEDATE BETWEEN v_SchSDate - 1/24 AND v_SchEDate + 1/24)
		AND    S.SCHSTS = 'N'
		AND   (D.DOCCODE IN (SELECT DOCCODE FROM DOCSPCLINK WHERE SPCCODE = 'OPTHAL')
		OR     D.DOCCODE IN (SELECT DOCCODE FROM DOCTOR WHERE SPCCODE = 'OPTHAL'));

		IF v_noOfRec > 0 and i_Override = 'N' THEN
			o_errmsg := 'There is another <font color=''green''>Ophthalmology</font> doctor in the same schedule (+/- 1 hour), are you sure to add schedule?';
			RETURN -100;
		END IF;
	END IF;

	v_noOfRec := NHS_ACT_SCHEDULE(i_action, i_DocCode,
		TO_CHAR(v_SchSDate, 'HH24:MI'), TO_CHAR(v_SchEDate, 'HH24:MI'),
		TO_CHAR(v_SchSDate, 'DD/MM/YYYY'), TO_CHAR(v_SchEDate, 'DD/MM/YYYY'),
		i_TEMLEN, NULL, i_DOCPRACTICE, i_DOCLOCID, i_allowPH, i_COMPUTERNAME, i_UserID, o_errmsg);

	IF v_noOfRec < 0 THEN
		ROLLBACK;
		RETURN v_noOfRec;
	END IF;

	RETURN v_noOfRec;
EXCEPTION
WHEN OTHERS THEN
	o_errmsg := 'Schedule add failed.';
	DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	ROLLBACK;
	RETURN -1;
END NHS_ACT_SCHEDULE_SINGLE;
/
