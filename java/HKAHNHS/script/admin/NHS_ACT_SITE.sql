CREATE OR REPLACE FUNCTION "NHS_ACT_SITE" (
	v_action   IN VARCHAR2,
	v_STECODE  IN VARCHAR2,
	v_STENAME  IN VARCHAR2,
	v_STELOGO  IN VARCHAR2,
	v_STESNAME IN VARCHAR2,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';
	SELECT count(1) INTO v_noOfRec FROM SITE WHERE STECODE = v_STECODE;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO SITE
			(
				STECODE,
				STENAME,
				STELOGO,
				STESNAME
			) VALUES (
				v_STECODE,
				v_STENAME,
				v_STELOGO,
				v_STESNAME
			);
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE	SITE
			SET
				STENAME  = v_STENAME,
				STELOGO  = v_STELOGO,
				STESNAME = v_STESNAME
			WHERE	STECODE  = v_STECODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE SITE WHERE STECODE = v_STECODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;
	RETURN o_errcode;
END NHS_ACT_SITE;
/
