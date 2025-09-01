CREATE OR REPLACE FUNCTION NHS_ACT_MEDRECDTL (
	i_ACTION   IN VARCHAR2,
	i_DOCCODE  IN VARCHAR2,
	i_REQBY    IN VARCHAR2,
	i_PURPOSE  IN MEDRECDTL.MrdRmk%TYPE,
	i_UserID   IN MEDRECDTL.UsrID%TYPE,
	i_CompName IN MEDRECDTL.ReqLoc%TYPE,
	i_VolNo    IN MEDRECHDR.MrhVolLab%TYPE,
	i_PatNo    IN MEDRECHDR.PatNo%TYPE,
	o_errMsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errCode NUMBER;
	v_COUNT NUMBER;
	v_MrdID NUMBER;
	v_MrhID NUMBER;
	v_DOCCODE MEDRECDTL.DOCCODE%TYPE;
	v_MRDRMK MEDRECDTL.MRDRMK%TYPE;
	v_CompName MEDRECDTL.ReqLoc%TYPE;
	CREATE_MR_ERR EXCEPTION;
BEGIN
	o_errCode := -1;
	o_errMsg := 'OK';

	IF i_DOCCODE IS NOT NULL THEN
		SELECT COUNT(1) INTO v_COUNT FROM DOCTOR WHERE DOCCODE = i_DOCCODE;
		IF v_COUNT = 1 THEN
			v_DOCCODE := i_DOCCODE;
		ELSE
			v_MRDRMK := i_REQBY;
		END IF;
	END IF;

	IF i_PURPOSE IS NOT NULL THEN
		IF v_MRDRMK IS NOT NULL THEN
			v_MRDRMK := v_MRDRMK || ' (' || i_PURPOSE || ')';
		ELSE
			v_MRDRMK := i_PURPOSE;
		END IF;
	END IF;

	SELECT MrhID INTO v_MrhID
	FROM   MEDRECHDR
	WHERE  patno = i_patno
	AND    mrhvollab = i_volno
	AND    ROWNUM = 1;

	IF LENGTH(i_PURPOSE) > 100 THEN
		v_MRDRMK := SUBSTR(i_PURPOSE, 1, 100);
	ELSE
		v_MRDRMK := i_PURPOSE;
	END IF;

	IF LENGTH(i_CompName) > 20 THEN
		v_CompName := SUBSTR(i_CompName, 1, 20);
	ELSE
		v_CompName := i_CompName;
	END IF;

	-- check duplicate request (within 1 minute)
	SELECT COUNT(1) INTO v_COUNT
	FROM   MEDRECDTL
	WHERE  MrhID = v_MrhID
	AND    MrdSts = 'R'
	AND    UsrID = i_UserID
	AND    MrdRmk = v_MRDRMK
	AND    ReqLoc = v_CompName
	AND    MrdDDate > SYSDATE - (1 / 1440);

	IF v_COUNT > 0 THEN
		o_errCode := -1;
		o_errMsg := 'Duplicate request. Please try again later.';
		RAISE CREATE_MR_ERR;
	END IF;

	-- get next mrdid
	SELECT SEQ_MEDRECDTL.NEXTVAL INTO v_MrdID FROM DUAL;

	INSERT INTO MEDRECDTL(MrdID, MrhID, MrdDDate, MrdSts, UsrID, MrdRmk, ReqLoc, DOCCODE)
	VALUES (v_MrdID, v_MrhID, SYSDATE, 'R', i_UserID, v_MRDRMK, v_CompName, v_DOCCODE);

	o_errCode := v_MrdID;

	RETURN o_errCode;
EXCEPTION
WHEN CREATE_MR_ERR THEN
	ROLLBACK;
	RETURN o_errCode;
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_ACT_MEDRECDTL;
/
