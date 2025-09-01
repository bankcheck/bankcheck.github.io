CREATE OR REPLACE FUNCTION "NHS_GET_ROOMFEE" (
	v_ACMCODE  IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	v_ItmCode ItemChg.ItmCode%TYPE := 'RC122';
	v_SlpType ItemChg.ItcType%TYPE := 'I';
	v_Credit BOOLEAN := FALSE;
	v_StnRlvl Item.ItmRLvl%TYPE;
	v_DefaultRate1 ItemChg.ItcAmt1%TYPE;
	v_DefaultRate2 ItemChg.ItcAmt1%TYPE;
	v_SecondRate ItemChg.ItcAmt1%TYPE;
	v_CPS_DefaultRate ItemChg.ItcAmt1%TYPE;
	v_CPS_SecondRate ItemChg.ItcAmt1%TYPE;
	v_CPSID ItemChg.Cpsid%TYPE;
	v_CPSPct ItemChg.Cpspct%TYPE;
BEGIN
--	NHS_SYS_LookupItemCharge( v_ItmCode, v_SlpType, v_ACMCODE, v_Credit,
--		v_StnRlvl, v_DefaultRate, v_SecondRate, v_CPS_DefaultRate, v_CPS_SecondRate,
--		v_CPSID, v_CPSPct, NULL);

	IF GET_CURRENT_STECODE = 'HKAH' THEN
		-- 'RMMED', 'RMMS'
		IF v_ACMCODE = 'I' THEN
			v_DefaultRate1 := 3800;
			v_DefaultRate2 := 8400;
		ELSIF v_ACMCODE = 'P' THEN
			v_DefaultRate1 := 2300;
			v_DefaultRate2 := 3300;
		ELSIF v_ACMCODE = 'S' THEN
			v_DefaultRate1 := 2000;
			v_DefaultRate2 := 2200;
		ELSIF v_ACMCODE = 'T' THEN
			v_DefaultRate1 := 750;
			v_DefaultRate2 := 900;
		END IF;
	ELSE
		-- 'RC122'
		IF v_ACMCODE = 'A' THEN
			v_DefaultRate1 := 4000;
			v_DefaultRate2 := 4000;
		ELSIF v_ACMCODE = 'B' THEN
			v_DefaultRate1 := 3500;
			v_DefaultRate2 := 3500;
		ELSIF v_ACMCODE = 'C' THEN
			v_DefaultRate1 := 2500;
			v_DefaultRate2 := 2500;
		ELSIF v_ACMCODE = 'E' THEN
			v_DefaultRate1 := 1200;
			v_DefaultRate2 := 1300;
		ELSIF v_ACMCODE = 'F' THEN
			v_DefaultRate1 := 950;
			v_DefaultRate2 := 1200;
		ELSIF v_ACMCODE = 'L' THEN
			v_DefaultRate1 := 120;
			v_DefaultRate2 := 120;
		END IF;
	END IF;

	OPEN OUTCUR FOR
		SELECT v_DefaultRate1, v_DefaultRate2 FROM DUAL;

	RETURN OUTCUR;
END NHS_GET_ROOMFEE;
/
