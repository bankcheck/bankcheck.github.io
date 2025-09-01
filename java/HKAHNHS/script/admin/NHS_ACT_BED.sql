CREATE OR REPLACE FUNCTION "NHS_ACT_BED" (
	v_action    IN VARCHAR2,
	v_BEDCODE   IN BED.BEDCODE%TYPE,
	V_BEDOFF    IN BED.BEDOFF%TYPE,
	V_BEDDESC   IN BED.BEDDESC%TYPE,
	V_ROMCODE   IN BED.ROMCODE%TYPE,
	V_EXTPHONE  IN BED.EXTPHONE%TYPE,
	o_errmsg    OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM BED WHERE BEDCODE = v_BEDCODE;

	IF v_action = 'ADD' THEN
		IF v_noOfRec = 0 THEN
			INSERT INTO BED (
				BEDCODE,
				BEDDESC,
				BEDOFF,
				ROMCODE,
				BEDSTS,
				BEDDDATE,
				BEDREMARK,
				BEDRDATE,
				STECODE,
				EXTPHONE
			) VALUES (
				V_BEDCODE,
				V_BEDDESC,
				V_BEDOFF,
				V_ROMCODE,
				'F',
				sysdate,
				null,
				null,
				GET_CURRENT_STECODE,
				V_EXTPHONE
			);
--		ELSE
--			o_errcode := -1;
--			o_errmsg := 'Record already exists.';
		END IF;
	ELSIF v_action = 'MOD' THEN
		IF v_noOfRec > 0 THEN
			UPDATE BED
			SET
				BEDDESC  = V_BEDDESC,
				BEDOFF   = V_BEDOFF,
				ROMCODE  = V_ROMCODE,
				EXTPHONE = V_EXTPHONE
			WHERE BEDCODE = v_BEDCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSIF v_action = 'DEL' THEN
		IF v_noOfRec > 0 THEN
			DELETE BED WHERE BEDCODE = v_BEDCODE;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to delete due to record not exist.';
		END IF;
	END IF;
	RETURN o_errcode;
END NHS_ACT_BED;
/
