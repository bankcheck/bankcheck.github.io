CREATE OR REPLACE FUNCTION "NHS_ACT_DEPTSERVROLEASSIGNMENT" (
	v_action  IN VARCHAR2,
	v_ROLID   IN ROLE.ROLID%TYPE,
	v_DSCCODE IN DPSERV.DSCCODE%TYPE,
	v_DSCDESC IN DPSERV.DSCDESC%TYPE,
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

	SELECT count(1) INTO v_noOfRec FROM ROLE_DEPT_SERV
	WHERE ROLE_ID = v_ROLID
	AND	 DSCCODE = v_DSCCODE;

	SELECT MAX(RDS_ID) + 1 INTO v_maxid FROM ROLE_DEPT_SERV;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO ROLE_DEPT_SERV (
				RDS_ID,
				ROLE_ID,
				DSCCODE,
				STECODE
			) VALUES (
				v_maxid,
				v_ROLID,
				v_DSCCODE,
				GET_CURRENT_STECODE);
		ELSE
			o_errcode := -1;
			o_errmsg := 'Record already exists.';
		END IF;

	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE ROLE_DEPT_SERV
			WHERE DSCCODE = v_DSCCODE
			AND	 ROLE_ID = v_ROLID;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_DEPTSERVROLEASSIGNMENT;
/
