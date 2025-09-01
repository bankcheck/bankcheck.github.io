CREATE OR REPLACE FUNCTION "NHS_ACT_UNLOCKDAYEND" (
	v_action    IN VARCHAR2,
	v_SteCode   IN VARCHAR2,
	o_errmsg    OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_Count NUMBER;
	v_RlkID NUMBER;
	v_RlkType VARCHAR2(30);
	v_RlkTime VARCHAR2(10);
	DayendUser VARCHAR2(10) := 'D_A_Y_E_ND';
	DayendMac VARCHAR2(11) := 'S_E_R_V_E_R';
	DayendType VARCHAR2(18) := 'D.A.Y.E.N.D REPORT';
	DayendKey VARCHAR2(6) := 'NO KEY';
	DayendErrMsg VARCHAR2(10) := 'FAILED KEY';
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO v_Count FROM rlock
	WHERE  USRID = DayendUser
	AND    RLKMAC = DayendMac
	AND    STECODE = v_SteCode;

	IF v_Count = 1 THEN
		SELECT RlkID, RlkType INTO v_RlkID, v_RlkType FROM rlock
		WHERE  USRID = DayendUser
		AND    RLKMAC = DayendMac
		AND    STECODE = v_SteCode;

		v_Count := INSTR(v_RlkType, '^');
		IF v_Count >= 0 THEN
			v_RlkTime := SUBSTR(v_RlkType, v_Count, LENGTH(v_RlkType) - v_Count);
		ELSE
			v_RlkTime := '00:00';
		END IF;

		UPDATE rlock
		SET    RLKKEY = DayendKey, RLKDATE = TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY') || ' ' || v_RlkTime, 'DD/MM/YYYY HH24:MI')
		WHERE  RlkID = v_RlkID;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	o_errCode := -1;
	o_errmsg:= SQLERRM;
	ROLLBACK;
	RETURN o_errCode;
END NHS_ACT_UNLOCKDAYEND;
/
