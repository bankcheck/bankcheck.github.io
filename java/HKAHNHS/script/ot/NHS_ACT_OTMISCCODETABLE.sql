CREATE OR REPLACE FUNCTION "NHS_ACT_OTMISCCODETABLE"
(
	v_action	IN VARCHAR2,
	v_CODETYPE	IN VARCHAR2,
	v_OTCORD	IN VARCHAR2,
	v_OTCDESC	IN VARCHAR2,
	v_OTCSTS	IN VARCHAR2,
	v_OTCNUM_1	IN VARCHAR2,
	v_OTCCHR_1	IN VARCHAR2,
	v_OTCID		IN VARCHAR2,
	v_STECODE	IN VARCHAR2,
	o_errmsg	OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode	NUMBER;
	v_noOfRec	NUMBER;
	v_newOtcid	NUMBER;
	l_OTCID		NUMBER;
	l_OTCORD	NUMBER;
	l_OTCNUM_1	NUMBER;
	l_OTCSTS	NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';
	l_OTCID := TO_NUMBER(v_OTCID);
	l_OTCORD := TO_NUMBER(v_OTCORD);
	l_OTCNUM_1 := TO_NUMBER(v_OTCNUM_1);
	l_OTCSTS := TO_NUMBER(v_OTCSTS);

	SELECT count(1) INTO v_noOfRec FROM OT_CODE WHERE OTCID = l_OTCID;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			select seq_ot_code.NEXTVAL into v_newOtcid from dual;

			INSERT INTO OT_CODE
			VALUES (
				v_newOtcid,
				v_CODETYPE,
				l_OTCORD,
				v_OTCDESC,
				l_OTCNUM_1,
				v_OTCCHR_1,
				l_OTCSTS,
				v_STECODE
	  		);
		--ELSE
	  		--o_errcode := -1;
	  		--o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
		  UPDATE	OT_CODE
		  SET
				OTCTYPE		= v_CODETYPE,
				OTCORD		= l_OTCORD,
				OTCDESC		= v_OTCDESC,
				OTCNUM_1	= l_OTCNUM_1,
				OTCCHR_1	= v_OTCCHR_1,
				OTCSTS		= l_OTCSTS
		  WHERE	OTCID		= l_OTCID;
		ELSE
		  o_errcode := -1;
		  o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE OT_CODE WHERE OTCID = l_OTCID;
		ELSE
	  		o_errcode := -1;
	  		o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;
	RETURN o_errcode;
END NHS_ACT_OTMISCCODETABLE;
/
