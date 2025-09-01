CREATE OR REPLACE FUNCTION "NHS_ACT_ROOM" (
	v_action  IN VARCHAR2,
	v_ROMCODE IN ROOM.ROMCODE%TYPE,
	v_WRDCODE IN ROOM.WRDCODE%TYPE,
	v_ACMCODE IN ROOM.ACMCODE%TYPE,
	v_ROMSEX  IN ROOM.ROMSEX%TYPE,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_noOfRec NUMBER;
	o_errcode NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';
	SELECT count(1) INTO v_noOfRec FROM ROOM WHERE ROMCODE = v_ROMCODE;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO ROOM
			VALUES (
				v_ROMCODE,
				v_WRDCODE,
				v_ACMCODE,
				v_ROMSEX,
				GET_CURRENT_STECODE
			);
--		ELSE
--			o_errcode := -1;
--			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE	ROOM
			SET
				WRDCODE = v_WRDCODE,
				ACMCODE = v_ACMCODE,
				ROMSEX = v_ROMSEX
			WHERE ROMCODE = v_ROMCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE ROOM WHERE ROMCODE = v_ROMCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;

	RETURN o_errcode;
END NHS_ACT_ROOM;
/
