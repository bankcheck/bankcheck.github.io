CREATE OR REPLACE FUNCTION "NHS_ACT_GLCODE" (
	v_action  IN VARCHAR2,
	v_GLCCODE IN GLCODE.GLCCODE%TYPE,
	v_GLCNAME IN GLCODE.GLCNAME%TYPE,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	 SELECT count(1) INTO v_noOfRec FROM GLCODE WHERE GLCCODE = v_GLCCODE;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO GLCODE (
				GLCCODE,
				GLCNAME,
				STECODE
			) VALUES (
				v_GLCCODE,
				v_GLCNAME,
				GET_CURRENT_STECODE
			);
--		ELSE
--			o_errcode := -1;
--			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE	GLCODE
			SET
				GLCNAME			= v_GLCNAME
			WHERE	GLCCODE = v_GLCCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE GLCODE WHERE GLCCODE = v_GLCCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_GLCODE;
/
