CREATE OR REPLACE FUNCTION "NHS_ACT_ROLE" (
	v_action  IN VARCHAR2,
	v_ROLNAM  IN ROLE.ROLNAM%TYPE,
	v_ROLDESC IN ROLE.ROLDESC%TYPE,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_maxRolID NUMBER;
	v_noOfRec NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT max(ROLID) + 1 INTO v_maxRolID FROM ROLE;

	IF v_maxRolID = NULL THEN
		v_maxRolID := 1;
	END IF;

	SELECT count(1) INTO v_noOfRec FROM ROLE WHERE ROLNAM = v_ROLNAM;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO ROLE (
				ROLID,
				ROLNAM,
				ROLDESC,
				STECODE
			) VALUES (
				v_maxRolID,
				v_ROLNAM,
				v_ROLDESC,
				GET_CURRENT_STECODE
			);
--		ELSE
--			o_errcode := -1;
--			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE	ROLE
			SET
				ROLDESC = v_ROLDESC
			WHERE ROLNAM = v_ROLNAM;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE ROLE WHERE ROLNAM = v_ROLNAM;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_ROLE;
/
