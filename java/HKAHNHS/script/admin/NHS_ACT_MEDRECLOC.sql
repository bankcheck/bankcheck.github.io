CREATE OR REPLACE FUNCTION "NHS_ACT_MEDRECLOC" (
	v_action  IN VARCHAR2,
	v_MRLID   IN MEDRECLOC.MRLID%TYPE,
	v_MRLDESC IN MEDRECLOC.MRLDESC%TYPE,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM MEDRECLOC WHERE MRLID = v_MRLID;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO MEDRECLOC
			VALUES (
				v_MRLID,
				v_MRLDESC,
				GET_CURRENT_STECODE
			);
--		ELSE
--			o_errcode := -1;
--			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE	MEDRECLOC
			SET
				MRLDESC = v_MRLDESC
			WHERE MRLID = v_MRLID;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE MEDRECLOC WHERE MRLID = v_MRLID;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_MEDRECLOC;
/
