CREATE OR REPLACE FUNCTION NHS_GET_BOOKINGINFO (
	v_DocCode  VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_Count NUMBER;
	v_Remark VARCHAR2(100);
	v_SMSContent VARCHAR2(20);
BEGIN
	IF GET_CURRENT_STECODE = 'HKAH' THEN
		IF v_DocCode IS NOT NULL THEN
			IF v_DocCode IN ('PBOG', 'HC') THEN
				v_Remark := 'C-19 TEST';
			ELSE
				-- cardiologists
				SELECT COUNT(1) INTO v_Count
				FROM   DOCTOR
				WHERE  DOCCODE = v_DocCode
				AND    SPCCODE IN ('CARDIO', 'CARDTHO');

				IF v_Count = 1 THEN
					IF TO_CHAR(sysdate, 'd') IN ('2', '3', '4', '5', '6')
							AND TO_CHAR(sysdate, 'HH24MI') >= ('0830')
							AND TO_CHAR(sysdate, 'HH24MI') <= ('1730') THEN
						-- Monday to Friday 8:30 to 17:30
						v_SMSContent := '2';
					END IF;
				END IF;
			END IF;
		END IF;
	END IF;

	OPEN OUTCUR FOR
		SELECT v_Remark, v_SMSContent FROM DUAL;

	RETURN OUTCUR;
END NHS_GET_BOOKINGINFO;
/
