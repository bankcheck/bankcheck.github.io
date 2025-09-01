-- txnCharg/TelLog \ ItemChargeValidate
CREATE OR REPLACE FUNCTION NHS_UTL_ITEMCHARGEVALIDATE (
--	i_ItmName    IN OUT VARCHAR2,
--	i_ItmCName   IN VARCHAR2,
	i_ItmCat     IN OUT VARCHAR2,
	i_ItmType    IN VARCHAR2,
	-------------------------------
	i_TxMode     IN VARCHAR2,
	i_TxDate     IN VARCHAR2,
	i_SlpNo      IN VARCHAR2,
	i_ItmCode    IN VARCHAR2,
	i_SlpType    IN VARCHAR2,
	i_ChrgType   IN VARCHAR2,
	i_AcmCode    IN VARCHAR2,
	i_Unit       IN NUMBER,
	i_Amount     IN NUMBER,
	i_SlpHDisc   IN NUMBER,
	i_SlpDDisc   IN NUMBER,
	i_SlpSDisc   IN NUMBER,
	-------------------------------
	o_StnOAmt    OUT NUMBER,
	o_StnBAmt    OUT NUMBER,
	o_StnCpsFlag OUT VARCHAR2,
	o_SlpCpsid   OUT NUMBER,
	o_flagToDi   OUT BOOLEAN,
	o_StnDisc    OUT NUMBER,
	o_StnRlvl    OUT NUMBER,
	o_errmsg     OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER := -1;
	v_Count NUMBER;
	v_CPSID NUMBER;
	v_CPSPct NUMBER;
	v_StnRlvl NUMBER;
	v_Credit BOOLEAN;

	v_AcmCode ItemChg.AcmCode%TYPE;
	v_DiDeptCode Sysparam.param1%TYPE;
	v_DefaultRate ItemChg.ItcAmt1%TYPE;
	v_SecondRate ItemChg.ItcAmt1%TYPE;
	v_CPS_DefaultRate ItemChg.ItcAmt1%TYPE;
	v_CPS_SecondRate ItemChg.ItcAmt1%TYPE;
	v_Rate1 ItemChg.ItcAmt1%TYPE;
	v_Rate2 ItemChg.ItcAmt1%TYPE;
	v_Rate3 ItemChg.ItcAmt1%TYPE;
	v_Rate4 ItemChg.ItcAmt1%TYPE;
	v_DeptCode Item.Dptcode%TYPE;

	TXN_ADD_MODE VARCHAR2(3) := 'ADD';
	TXN_CREDITITEMPER_MODE VARCHAR2(13) := 'CREDITITEMPER';
	SLIPTX_CPS_STD VARCHAR(1) := '';       -- Standard Rate
	SLIPTX_CPS_STD_FIX VARCHAR(1) := 'F';  -- Standard Rate With CPS Fix Amount
	SLIPTX_CPS_STD_PCT VARCHAR(1) := 'P';  -- Standard Rate With CPS Percentage Disc
	SLIPTX_CPS_STA VARCHAR(1) := 'S';      -- Stat Rate
	SLIPTX_CPS_STA_FIX VARCHAR(1) := 'T';  -- Stat Rate With CPS Fix Amount
	SLIPTX_CPS_STA_PCT VARCHAR(1) := 'U';  -- Stat Rate With CPS Percentage Disc
	TYPE_DOCTOR VARCHAR(1) := 'D';
	TYPE_HOSPITAL VARCHAR(1) := 'H';
	TYPE_SPECIAL VARCHAR(1) := 'S';
	TYPE_OTHERS VARCHAR(1) := 'O';
BEGIN
--	SELECT COUNT(1) INTO v_Count FROM Slip S, Arcode A WHERE S.Arccode = A.Arccode AND Slpno = i_SlpNo;
	SELECT COUNT(1) INTO v_Count
	FROM   SLIP, ARCODE AC,
	(
		SELECT NVL(DECODE(e.slpmid, '', '', '0', 'DEP', 'DEP' || e.slpmid), s.arccode) as arccodeMisc
		FROM   slip s, slip_extra e
		WHERE  s.SLPNO = E.SLPNO(+)
		AND    s.slpno = i_SlpNo
	) AM
	WHERE  AM.ARCCODEMISC = AC.ARCCODE
	AND    SLIP.SLPNO = i_SlpNo;

	IF v_Count > 0 THEN
--		SELECT A.Cpsid INTO o_SlpCpsid
--		FROM   Slip S, Arcode A
--		WHERE  S.Arccode = A.Arccode
--		AND    S.Slpno = i_SlpNo;

		SELECT CPSID INTO o_SlpCpsid
		FROM   SLIP, ARCODE AC,
		(
			SELECT NVL(DECODE(e.slpmid, '', '', '0', 'DEP', 'DEP' || e.slpmid), s.arccode) as arccodeMisc
			FROM   slip s, slip_extra e
			WHERE  s.SLPNO = E.SLPNO(+)
			AND    s.slpno = i_SlpNo
		) AM
		WHERE  AM.ARCCODEMISC = AC.ARCCODE
		AND    SLIP.SLPNO = i_SlpNo;
	END IF;

	-- special handle for urgent care
	IF i_SlpType = 'O' THEN
		SELECT COUNT(1) INTO v_Count
		FROM   Slip
		WHERE  SlpNo = i_SlpNo
		AND    SlpType = 'O';
		IF v_Count > 0 THEN
			SELECT 'ZZ' || RegOPCat INTO v_AcmCode
			FROM   Slip
			WHERE  SlpNo = i_SlpNo
			AND    SlpType = 'O';
		END IF;
	END IF;

	BEGIN
		IF i_TxMode = TXN_ADD_MODE THEN
			v_Credit := FALSE;
		ELSE
			v_Credit := TRUE;
		END IF;

		IF v_AcmCode IS NOT NULL AND (i_AcmCode IS NULL OR i_AcmCode != v_AcmCode) THEN
			NHS_SYS_LookupItemCharge(i_TxDate, i_ItmCode, i_SlpType, v_AcmCode, v_Credit,
				o_StnRlvl, v_DefaultRate, v_SecondRate, v_CPS_DefaultRate, v_CPS_SecondRate,
				v_CPSID, v_CPSPct, NULL);

			IF o_SlpCpsid IS NULL THEN
				o_SlpCpsid := NULL;
				v_CPSPct := NULL;
			ELSE
				NHS_SYS_LookupItemCharge(i_TxDate, i_ItmCode, i_SlpType, v_AcmCode, v_Credit,
					v_StnRlvl, v_Rate1, v_Rate2, v_Rate3, v_Rate4, -- another variable to store value
					o_SlpCpsid, v_CPSPct, NULL);

				IF v_Rate1 IS NULL AND v_Rate2 IS NULL AND v_Rate3 IS NULL AND v_Rate4 IS NULL THEN
					o_SlpCpsid := NULL;
					v_CPSPct := NULL;
				ELSE
					v_CPS_DefaultRate := v_Rate3;
					v_CPS_SecondRate := v_Rate4;
					o_StnRlvl := v_StnRlvl;
				END IF;
			END IF;
		END IF;

		IF v_DefaultRate IS NULL AND v_SecondRate IS NULL AND v_Rate1 IS NULL AND v_Rate2 IS NULL THEN
			NHS_SYS_LookupItemCharge(i_TxDate, i_ItmCode, i_SlpType, i_AcmCode, v_Credit,
				o_StnRlvl, v_DefaultRate, v_SecondRate, v_CPS_DefaultRate, v_CPS_SecondRate,
				v_CPSID, v_CPSPct, NULL);

			IF o_SlpCpsid IS NULL THEN
				o_SlpCpsid := NULL;
				v_CPSPct := NULL;
			ELSE
				NHS_SYS_LookupItemCharge(i_TxDate, i_ItmCode, i_SlpType, i_AcmCode, v_Credit,
					v_StnRlvl, v_Rate1, v_Rate2, v_Rate3, v_Rate4, -- another variable to store value
					o_SlpCpsid, v_CPSPct, NULL);

				IF v_Rate1 IS NULL AND v_Rate2 IS NULL AND v_Rate3 IS NULL AND v_Rate4 IS NULL THEN
					o_SlpCpsid := NULL;
					v_CPSPct := NULL;
				ELSE
					v_CPS_DefaultRate := v_Rate3;
					v_CPS_SecondRate := v_Rate4;
					o_StnRlvl := v_StnRlvl;
				END IF;
			END IF;
		END IF;
	END;

	IF v_DefaultRate IS NOT NULL THEN
		IF i_ItmCat IS NULL THEN
			SELECT COUNT(1) INTO v_Count FROM Item WHERE Itmcode = i_ItmCode;
			IF v_Count > 0 THEN
				FOR r IN (SELECT ItmCat FROM Item WHERE Itmcode = i_ItmCode) LOOP
					 i_ItmCat := r.ItmCat;
					EXIT;
				END LOOP;
			END IF;
		END IF;
		IF i_ItmCat IS NOT NULL THEN
			IF i_TxMode = TXN_ADD_MODE THEN
				o_StnOAmt := i_Unit * v_DefaultRate;
			ELSE
				o_StnOAmt := i_Unit * -v_DefaultRate;
			END IF;

			IF i_TxMode = TXN_CREDITITEMPER_MODE THEN
				o_StnDisc := 0;
			ELSE
				IF i_ItmType = TYPE_DOCTOR THEN
					o_StnDisc := i_SlpDDisc;
				ELSIF i_ItmType = TYPE_HOSPITAL THEN
					o_StnDisc := i_SlpHDisc;
				ELSE
					o_StnDisc := i_SlpSDisc;
				END IF;
			END IF;

			IF o_SlpCpsid IS NULL THEN
				-- Is Not CPS
				IF i_Amount <= 0 THEN
					IF i_ChrgType = 'R' THEN
						IF i_TxMode = TXN_ADD_MODE THEN
							o_StnBAmt := i_Unit * v_DefaultRate;
						ELSE
							o_StnBAmt := i_Unit * -v_DefaultRate;
						END IF;
					ELSE
						IF i_TxMode = TXN_ADD_MODE THEN
							o_StnBAmt := i_Unit * v_SecondRate;
						ELSE
							o_StnBAmt := i_Unit * -v_SecondRate;
						END IF;
					END IF;
				ELSE
					IF i_TxMode = TXN_ADD_MODE THEN
						o_StnBAmt := i_Unit * i_Amount;
					ELSE
						o_StnBAmt := i_Unit * -i_Amount;
					END IF;
				END IF;

				IF i_ChrgType = 'R' THEN
					o_StnCpsFlag := SLIPTX_CPS_STD;
				ELSE
					o_StnCpsFlag := SLIPTX_CPS_STA;
				END IF;
			ELSE
				-- Is CPS
				IF v_CPSPct IS NULL THEN
					IF i_Amount <= 0 THEN
						IF i_ChrgType = 'R' THEN
							IF i_TxMode = TXN_ADD_MODE THEN
								o_StnBAmt := i_Unit * v_CPS_DefaultRate;
							ELSE
								o_StnBAmt := i_Unit * -v_CPS_DefaultRate;
							END IF;
						ELSE
							IF i_TxMode = TXN_ADD_MODE THEN
								o_StnBAmt := i_Unit * v_CPS_SecondRate;
							ELSE
								o_StnBAmt := i_Unit * -v_CPS_SecondRate;
							END IF;
						END IF;
					ELSE
						IF i_TxMode = TXN_ADD_MODE THEN
							o_StnBAmt := i_Unit * i_Amount;
						ELSE
							o_StnBAmt := i_Unit * -i_Amount;
						END IF;
					END IF;

					IF i_ChrgType = 'R' THEN
						o_StnCpsFlag := SLIPTX_CPS_STD_FIX;
					ELSE
						o_StnCpsFlag := SLIPTX_CPS_STA_FIX;
					END IF;
				ELSE
					-- % Override Discount
					IF i_TxMode = TXN_ADD_MODE THEN
						o_StnDisc := v_CPSPct;

						IF i_Amount <= 0 THEN
							IF i_ChrgType = 'R' THEN
								IF i_TxMode = TXN_ADD_MODE THEN
									o_StnBAmt := i_Unit * v_DefaultRate;
								ELSE
									o_StnBAmt := i_Unit * -v_DefaultRate;
								END IF;
							ELSE
								IF i_TxMode = TXN_ADD_MODE THEN
									o_StnBAmt := i_Unit * v_SecondRate;
								ELSE
									o_StnBAmt := i_Unit * -v_SecondRate;
								END IF;
							END IF;
						ELSE
							IF i_TxMode = TXN_ADD_MODE THEN
								o_StnBAmt := i_Unit * i_Amount;
							ELSE
								o_StnBAmt := i_Unit * -i_Amount;
							END IF;
						END IF;

						IF i_ChrgType = 'R' THEN
							o_StnCpsFlag := SLIPTX_CPS_STD_PCT;
						ELSE
							o_StnCpsFlag := SLIPTX_CPS_STA_PCT;
						END IF;
					END IF;
				END IF;
			END IF;

			SELECT COUNT(1) INTO v_Count FROM Item WHERE ItmCode = i_ItmCode;
			IF v_Count > 0 THEN
				SELECT Dptcode INTO v_DeptCode FROM Item WHERE ItmCode = i_ItmCode;
				IF v_DeptCode IS NOT NULL THEN
					-- Comment: IF not DI's department code
					SELECT param1 INTO v_DiDeptCode FROM Sysparam WHERE parcde = 'DIDeptID';
					IF v_DeptCode IS NOT NULL AND InStr(v_DiDeptCode, v_DeptCode) > 0 THEN
						o_flagToDi := TRUE;
					ELSE
						o_flagToDi := FALSE;
					END IF;
				END IF;
			END IF;

			o_errcode := 0;
		ELSE
			o_errmsg := 'Deposit Added Failed.';
		END IF;
	ELSE
		o_errmsg := 'Invalid item charge rate.';
	END IF;

	RETURN o_errcode;

EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_errmsg := SQLERRM || o_errmsg;

	RETURN -1;
END NHS_UTL_ITEMCHARGEVALIDATE;
/
