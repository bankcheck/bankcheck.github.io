CREATE OR REPLACE FUNCTION "NHS_ACT_USERASSIGNMENT" (
	v_action  IN VARCHAR2,
	v_ROLID   IN ROLE.ROLID%TYPE,
	v_USRID   IN USRROLE.USRID%TYPE,
	v_USRNAME IN USR.USRNAME%TYPE,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_maxid NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM USRROLE
	WHERE ROLID = v_ROLID
	AND	 USRID = v_USRID;

	SELECT MAX(UROID) + 1 INTO v_maxid FROM USRROLE;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO USRROLE (
				UROID,
				USRID,
				ROLID,
				STECODE
			) VALUES (
				v_maxid,
				v_USRID,
				v_ROLID,
				GET_CURRENT_STECODE
			);
		ELSE
			o_errcode := -1;
			o_errmsg := 'Record already exists.';
		END IF;

	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE USRROLE
			WHERE USRID = v_USRID
			AND	 ROLID = v_ROLID;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_USERASSIGNMENT;
/
