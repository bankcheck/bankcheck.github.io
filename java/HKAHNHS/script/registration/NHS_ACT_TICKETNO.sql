create or replace FUNCTION NHS_ACT_TICKETNO (
	i_step         IN VARCHAR2,
	i_patNo        IN VARCHAR2,
	i_lockType     IN VARCHAR2,
	i_lockKey      IN VARCHAR2,
	i_computerName IN VARCHAR2,
	i_usrId        IN VARCHAR2,
	i_regopcat     IN VARCHAR2,
	i_doccode      IN VARCHAR2,
	i_bkgid        IN VARCHAR,
	i_regDate      IN VARCHAR,
	i_isYes1S      IN VARCHAR
)
	RETURN TYPES.CURSOR_TYPE
AS
	v_ticketGenMth VARCHAR2(10);
	v_bkgid VARCHAR2(20);
	v_ticketNo NUMBER;
	v_isYes1 NUMBER(1);
	v_returnRecordLock NUMBER(1);
	v_stepReturn NUMBER(1);
	TYPE rt1 IS record (v_ticketNo1 NUMBER);
	rtnType1 rt1;
	rtnCursor TYPES.CURSOR_TYPE;
	o_errcode NUMBER;
	o_errmsg VARCHAR2(1000);
	OUTCUR TYPES.CURSOR_TYPE;
	INTERNAL_FUNCTION_ERR EXCEPTION;
	EXIT_FOR_DIALOG EXCEPTION;
BEGIN
	o_errcode := 0;

	IF i_isYes1S IS NOT NULL THEN
		v_isYes1 := TO_NUMBER(i_isYes1S);
	END IF;

	IF i_regopcat = 'W' OR i_regopcat = 'P' THEN
		v_bkgid := NULL;
	ELSE
		v_bkgid := i_bkgid;
	END IF;

	SELECT Param1 INTO v_ticketGenMth FROM SysParam WHERE ParCde= 'TicketGen';

	IF TRIM(v_ticketGenMth) = 'A' THEN
		v_returnRecordLock := NHS_ACT_RECORDLOCK(NULL, i_lockType, i_lockKey, i_computerName, i_usrId, o_errmsg);

		IF v_returnRecordLock = 0 THEN
			rtnCursor := NHS_GET_TICKETNO(NULL);
			LOOP
				FETCH rtnCursor INTO rtnType1 ;
				EXIT WHEN rtnCursor%NOTFOUND;
			END LOOP;
			v_ticketNo := rtnType1.v_ticketNo1;

			IF v_ticketNo = -1 THEN
					o_errmsg := 'Get Ticket Number failed.';
					RAISE INTERNAL_FUNCTION_ERR;
			END IF;

			IF i_step = 0 AND v_ticketNo = 0 THEN
				o_errcode := -100;
				o_errmsg := 'Ticket Number is not available. Do you want to continue?';
				v_stepReturn := 1;
				RAISE EXIT_FOR_DIALOG;
			END IF;

			IF v_ticketNo = 0 THEN
				v_ticketNo := NULL;
			END IF;
		ELSE
			o_errmsg := 'Ticket Table is locked. Please try again later.'||o_errmsg;
			RAISE INTERNAL_FUNCTION_ERR;
		END IF;
	ELSE
		BEGIN
			CIS_GET_TICKET(i_regopcat, i_doccode, v_bkgid, v_ticketNo);
		EXCEPTION
		WHEN OTHERS THEN
			o_errmsg := 'Cannot call database function CIS_GET_TICKET. Please contact system administrator.';
			RAISE INTERNAL_FUNCTION_ERR;
		END;

		IF i_step = 0 AND v_ticketNo = 0 THEN
			o_errcode := -100;
			o_errmsg := 'Ticket Number is not available. Do you want to continue?';
			v_stepReturn := 1;
			RAISE EXIT_FOR_DIALOG;
		END IF;

		IF v_ticketNo < 0 THEN
			o_errmsg := 'Get Ticket Number failed.';
			RAISE INTERNAL_FUNCTION_ERR;
		END IF;

		IF v_ticketNo = 0 THEN
			v_ticketNo := NULL;
		END IF;
	END IF;

	OPEN OUTCUR FOR
		SELECT o_errcode, v_stepReturn, v_ticketNo, v_isYes1, o_errmsg
		FROM DUAL;
	RETURN OUTCUR;
EXCEPTION
WHEN EXIT_FOR_DIALOG THEN
	ROLLBACK;
	OPEN OUTCUR FOR
		SELECT o_errcode, v_stepReturn, v_ticketNo, v_isYes1, o_errmsg
		FROM DUAL;
	RETURN OUTCUR;
WHEN INTERNAL_FUNCTION_ERR THEN
	ROLLBACK;
	o_errcode := -3;
	OPEN OUTCUR FOR
		SELECT o_errcode, v_stepReturn, v_ticketNo, v_isYes1, v_returnRecordLock||';'||o_errmsg
		FROM DUAL;
	RETURN OUTCUR;
WHEN OTHERS THEN
	o_errcode := -1;
	o_errmsg := '[SQLERRM]:'||'['||SQLERRM||']';
	ROLLBACK;
	OPEN OUTCUR FOR
		SELECT o_errcode, v_stepReturn, v_ticketNo, v_isYes1, o_errmsg
		FROM DUAL;
	RETURN OUTCUR;
END NHS_ACT_TICKETNO;
/
