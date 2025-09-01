CREATE OR REPLACE FUNCTION "NHS_ACT_RACE" (
	v_action		IN VARCHAR2,
	v_RACDESC		RACE.RACDESC%TYPE,
	v_RACDESC1		RACE.RACDESC%TYPE,
	o_errmsg		OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
	o_errcode	NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';
	SELECT count(1) INTO v_noOfRec FROM RACE WHERE RACDESC = v_RACDESC;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO RACE (
				RACDESC
			) VALUES (
				v_RACDESC
			);
--		ELSE
--			o_errcode := -1;
--			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
--		IF v_noOfRec > 0 THEN
			UPDATE	RACE
			SET
				RACDESC = v_RACDESC
			WHERE	RACDESC = v_RACDESC1;
--		ELSE
--			o_errcode := -1;
--			o_errmsg := 'Fail to update due to record not exist.';
--		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE RACE WHERE RACDESC = v_RACDESC;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;
	return o_errcode;
END NHS_ACT_RACE;
/
