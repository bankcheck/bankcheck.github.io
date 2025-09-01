CREATE OR REPLACE FUNCTION "NHS_ACT_ALERT" (
	v_action    IN VARCHAR2,
--	v_ALTID     IN ALERT.ALTID%TYPE,
	v_ALTCODE   IN ALERT.ALTCODE%TYPE,
	v_ALTDESC   IN ALERT.ALTDESC%TYPE,
	v_ALTEMAIL  IN ALERT.ALTEMAIL%TYPE,
	v_ALERT     IN ALERT.ALERT%TYPE,
	o_errmsg    OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_id      NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM ALERT WHERE ALTCODE = v_ALTCODE;
	SELECT MAX(ALTID) + 1 INTO v_id FROM ALERT;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO ALERT(
				ALTID,
				ALTCODE,
				ALTDESC,
				ALTEMAIL,
				ALERT,
				STECODE
			) VALUES (
				v_id,
				v_ALTCODE,
				v_ALTDESC,
				v_ALTEMAIL,
				v_ALERT,
				GET_CURRENT_STECODE
			);
--		ELSE
--			o_errcode := -1;
--			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE ALERT
			SET
				ALTDESC = v_ALTDESC,
				ALTEMAIL = v_ALTEMAIL,
				ALERT = v_ALERT
			WHERE ALTCODE = v_ALTCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE ALERT WHERE ALTCODE = v_ALTCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;
	RETURN o_errcode;
END NHS_ACT_ALERT;
/
