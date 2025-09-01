CREATE OR REPLACE FUNCTION NHS_ACT_PATCHALERT(
	v_action  IN VARCHAR2,
	v_REGFX   IN VARCHAR2,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_Count NUMBER;
	v_Count2 NUMBER;
	v_REGFU VARCHAR2(5) := 'REGFU';
	v_REG18 VARCHAR2(5) := 'REG18';
	v_REGUA VARCHAR2(5) := 'REGUA';
	v_AltID_REGFX VARCHAR2(5);
	v_AltID_REGFU VARCHAR2(5);
	v_AltID_REG18 VARCHAR2(5);
	v_AltID_REGUA VARCHAR2(5);
	v_PalID VARCHAR2(10);
	v_errmsg VARCHAR2(1000);
BEGIN
	o_errMsg := 'OK';

	SELECT AltID INTO v_AltID_REGFX FROM Alert WHERE AltCode = v_REGFX;
	SELECT AltID INTO v_AltID_REGFU FROM Alert WHERE AltCode = v_REGFU;
	SELECT AltID INTO v_AltID_REG18 FROM Alert WHERE AltCode = v_REG18;
	SELECT AltID INTO v_AltID_REGUA FROM Alert WHERE AltCode = v_REGUA;

	SELECT COUNT(1) INTO v_Count2
	FROM   Patient p, PatAltLink L
	WHERE  p.PatNo = l.PatNo
	AND    l.UsrID_C IS NOT NULL
	AND    l.PalCDATE > SYSDATE - 1
	AND    l.AltID = v_AltID_REGFX
	AND    p.PatNo IN (SELECT PATNO FROM PATIENT WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, PATBDATE)/ 12) < 18);

	FOR R IN (
		SELECT p.PatNo
		FROM   Patient p, PatAltLink L
		WHERE  p.PatNo = l.PatNo
		AND    l.UsrID_C IS NOT NULL
		AND    l.PalCDATE > SYSDATE - 1
		AND    l.AltID = v_AltID_REGFX
		AND    p.PatNo IN (SELECT PATNO FROM PATIENT WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, PATBDATE)/ 12) < 18)
	)
	LOOP
		SELECT COUNT(1) INTO v_Count FROM PatAltLink WHERE PatNo = R.PatNo AND AltID = v_AltID_REG18 AND (UsrID_C IS NULL OR UsrID_C = 'PORTAL');
		IF v_Count = 0 THEN
			v_PalID := NHS_ACT_PATALERT('ADD', v_AltID_REG18, R.PatNo, 'PORTAL', NULL, NULL, v_errmsg);

			UPDATE PatAltLink
			SET    PalCDate = SYSDATE, UsrID_C = 'PORTAL'
			WHERE  PalID = v_PalID
			AND    PatNo = R.PatNo
			AND    AltID = v_AltID_REG18
			AND    PalCDate IS NULL
			AND    UsrID_C IS NULL;

			DBMS_OUTPUT.PUT_LINE('[' || R.PatNo || '] Just add REG18');
		ELSE
			DBMS_OUTPUT.PUT_LINE('[' || R.PatNo || '] Already add REG18');
		END IF;
	END LOOP;

	-- hide incapable alert at midnight
	UPDATE PatAltLink
	SET    PalCDate = SYSDATE, UsrID_C = 'PORTAL'
	WHERE  PalCDate IS NULL
	AND    UsrID_C IS NULL
	AND    AltID = v_AltID_REGFU;

	-- pop up if above 18
	UPDATE PatAltLink
	SET    PalCDate = '', UsrID_C = ''
	WHERE  PatNo IN (
		SELECT p.PatNo
		FROM   Patient p, PatAltLink L
		WHERE  p.PatNo = l.PatNo
		AND    l.PalCDate IS NOT NULL
		AND    l.UsrID_C = 'PORTAL'
		AND    l.AltID = v_AltID_REG18
		AND    TRUNC(MONTHS_BETWEEN(SYSDATE, P.PATBDATE)/ 12) >= 18
		GROUP BY p.PatNo
	)
	AND    AltID = v_AltID_REG18
	AND    UsrID_C = 'PORTAL';

	RETURN v_Count2;

END NHS_ACT_PATCHALERT;
/
