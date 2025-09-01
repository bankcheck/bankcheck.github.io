CREATE OR REPLACE FUNCTION "NHS_ACT_WARD" (
	v_action  IN VARCHAR2,
	v_WRDCODE IN WARD.WRDCODE%TYPE,
	V_WRDNAME IN WARD.WRDNAME%TYPE,
	V_DPTCODE IN WARD.DPTCODE%TYPE,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM WARD WHERE WRDCODE = v_WRDCODE AND STECODE = GET_CURRENT_STECODE;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO WARD (
				WRDCODE,
				STECODE,
				WRDNAME,
				DPTCODE
			 ) VALUES (
				V_WRDCODE,
				GET_CURRENT_STECODE,
				V_WRDNAME,
				V_DPTCODE
			);
--		ELSE
--			o_errcode := -1;
--			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE WARD
				SET
				WRDNAME	= V_WRDNAME,
				DPTCODE	= V_DPTCODE
			WHERE WRDCODE = V_WRDCODE
			AND	STECODE = GET_CURRENT_STECODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		 END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE WARD WHERE WRDCODE = V_WRDCODE AND STECODE = GET_CURRENT_STECODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_WARD;
/
