CREATE OR REPLACE FUNCTION "NHS_ACT_DEPT" (
	v_action   IN VARCHAR2,
	v_DPTCODE  IN DEPT.DPTCODE%TYPE,
	v_DPTNAME  IN DEPT.DPTNAME%TYPE,
	v_DPTCNAME IN DEPT.DPTCNAME%TYPE,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM DEPT WHERE DPTCODE = v_DPTCODE;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO DEPT
			VALUES (
				v_DPTCODE,
				v_DPTNAME,
				V_DPTCNAME,
				GET_CURRENT_STECODE,
				null, null
			);
--		ELSE
--			o_errcode := -1;
--			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE	DEPT
			SET
				DPTNAME = v_DPTNAME,
				DPTCNAME = V_DPTCNAME
			WHERE DPTCODE = v_DPTCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE DEPT WHERE DPTCODE = v_DPTCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_DEPT;
/
