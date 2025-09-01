-- TelLog \ LookUpPkgCode
CREATE OR REPLACE FUNCTION NHS_UTL_LOOKUPPKGCODE (
	i_PkgCode  IN VARCHAR2,
	i_Mode     IN VARCHAR2 := 'SLIPTX',
	-----------------------------------
	i_TxMode   IN VARCHAR2,
	i_TxDate   IN DATE,
	i_SlpNo    IN VARCHAR2,
	i_DocCode  IN VARCHAR2,
	i_SlpType  IN VARCHAR2,
	i_ChrgType IN VARCHAR,
	i_AcmCode  IN VARCHAR2,
	i_Unit     IN NUMBER,
	i_SlpHDisc IN NUMBER,
	i_SlpDDisc IN NUMBER,
	i_SlpSDisc IN NUMBER,
	o_errmsg   OUT VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	v_Count NUMBER;
	v_KeyCount NUMBER;
	v_Credit NUMBER;
	v_PkgCode Package.PkgCode%TYPE;
	v_PkgAlert Package.PkgAlert%TYPE;
	v_DeptCode Item.Dptcode%TYPE;
	v_SlpType Slip.SlpType%TYPE;
	v_AcmCode ItemChg.AcmCode%TYPE;
	memSlpCpsid ItemCreditChg.CPSID%type;

	o_OUTCUR TYPES.CURSOR_TYPE;
	c_doPackageCharge TYPES.CURSOR_TYPE;
	r_doPackageCharge Sys.LookupPackageCharge_Rec;
	r_doCharge LookupCharge_Obj := LookupCharge_Obj(NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, 0, NULL);
	t_doCharge LookupCharge_Tab := LookupCharge_Tab();

	PKGTX_TYPE_NATUREOFVISIT VARCHAR2(1) := 'N';
	TXN_ADD_MODE VARCHAR2(3) := 'ADD';
	TXN_CREDITITEMPER_MODE VARCHAR2(13) := 'CREDITITEMPER';
	MSG_ITMPKG_CODE VARCHAR2(22) := 'INVALID_ITMPKG_CODE';
	MSG_ITMCHARGE_RATE VARCHAR(25) := 'INVALID_ITMCHARGE_RATE';
	SLIPTX_CPS_STD VARCHAR(1) := '';  -- Standard Rate
	SLIPTX_CPS_STD_FIX VARCHAR(1) := 'F';  -- Standard Rate With CPS Fix Amount
	SLIPTX_CPS_STD_PCT VARCHAR(1) := 'P';  -- Standard Rate With CPS Percentage Disc
	SLIPTX_CPS_STA VARCHAR(1) := 'S';      -- Stat Rate
	SLIPTX_CPS_STA_FIX VARCHAR(1) := 'T';  -- Stat Rate With CPS Fix Amount
	SLIPTX_CPS_STA_PCT VARCHAR(1) := 'U';  -- Stat Rate With CPS Percentage Disc
	TYPE_DOCTOR VARCHAR(1) := 'D';
	TYPE_HOSPITAL VARCHAR(1) := 'H';
	TYPE_SPECIAL VARCHAR(1) := 'S';
	TYPE_OTHERS VARCHAR(1) := 'O';
	v_stntdate DATE;
BEGIN
	o_errmsg := '';

	IF i_TxDate IS NOT NULL THEN
		v_stntdate := i_TxDate;
	ELSE
		v_stntdate := TRUNC(SYSDATE);
	END IF;

	IF i_TxMode = TXN_ADD_MODE THEN
		SELECT COUNT(1) INTO v_Count FROM Package where PkgCode = i_PkgCode and PkgType != PKGTX_TYPE_NATUREOFVISIT;
		IF v_COUNT = 1 THEN
			SELECT PkgCode, PkgAlert INTO v_PkgCode, v_PkgAlert FROM Package where PkgCode = i_PkgCode and PkgType != PKGTX_TYPE_NATUREOFVISIT;
		END IF;
		v_Credit := 0;
	ELSE
		SELECT COUNT(1) INTO v_Count FROM CreditPkg where PkgCode = i_PkgCode and PkgType != PKGTX_TYPE_NATUREOFVISIT;
		IF v_COUNT = 1 THEN
			SELECT PkgCode, PkgAlert INTO v_PkgCode, v_PkgAlert FROM CreditPkg where PkgCode = i_PkgCode and PkgType != PKGTX_TYPE_NATUREOFVISIT;
		END IF;
		v_Credit := 1;
	END IF;

	IF v_PkgCode IS NOT NULL THEN
		IF v_PkgAlert IS NOT NULL THEN
			o_errmsg := v_PkgAlert;
		END IF;

		IF i_Mode = 'SLIPTX' OR i_Mode = 'PKGTX' THEN
			BEGIN
				SELECT CPSID INTO memSlpCpsid
				FROM SLIP, ARCODE AC,
				(
					select  NVL(decode(e.slpmid, '', '', '0', 'DEP', 'DEP' || e.slpmid), s.arccode) as arccodeMisc
					from slip s, slip_extra e
					where s.SLPNO = E.SLPNO(+)
					and s.slpno = i_SlpNo
				) AM
				WHERE AM.ARCCODEMISC = AC.ARCCODE
				AND SLIP.SLPNO = i_SlpNo;

--				SELECT CPSID
--				INTO memSlpCpsid
--				FROM SLIP, ARCODE
--				WHERE SLIP.ARCCODE=ARCODE.ARCCODE
--				AND SLIP.SLPNO = i_SlpNo;
			EXCEPTION
			WHEN OTHERS THEN
				memSlpCpsid := null;
			END;

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

			IF v_AcmCode IS NOT NULL AND (i_AcmCode IS NULL OR i_AcmCode != v_AcmCode) THEN
				c_doPackageCharge := NHS_SYS_LookupPackageCharge(TO_CHAR(i_TxDate, 'DD/MM/YYYY'), v_PkgCode, i_SlpType, NULL, v_AcmCode, memSlpCpsid, v_Credit);
				IF c_doPackageCharge IS NULL THEN
					c_doPackageCharge := NHS_SYS_LookupPackageCharge(TO_CHAR(i_TxDate, 'DD/MM/YYYY'), v_PkgCode, i_SlpType, NULL, i_AcmCode, memSlpCpsid, v_Credit);
				END IF;
			ELSE
				c_doPackageCharge := NHS_SYS_LookupPackageCharge(TO_CHAR(i_TxDate, 'DD/MM/YYYY'), v_PkgCode, i_SlpType, NULL, i_AcmCode, memSlpCpsid, v_Credit);
			END IF;
		END IF;
	ELSE
		o_errmsg := MSG_ITMPKG_CODE;
		RETURN NULL;
	END IF;

	IF c_doPackageCharge IS NOT NULL THEN
		v_KeyCount := 1;
		LOOP
			FETCH c_doPackageCharge into r_doPackageCharge;
			EXIT WHEN c_doPackageCharge%NOTFOUND;

			r_doCharge.PkgCode := v_PkgCode;
			r_doCharge.ItmCode := r_doPackageCharge.ItmCode;
			r_doCharge.ItmCat  := r_doPackageCharge.ItmCat;
			r_doCharge.ItmType := r_doPackageCharge.ItmType;
			r_doCharge.StnOAmt := r_doPackageCharge.ItcAmt1;
			r_doCharge.Unit := i_Unit;
			r_doCharge.StnOAmt := i_Unit * r_doPackageCharge.ItcAmt1;

			r_doCharge.AcmCode := i_AcmCode;

			IF r_doPackageCharge.CpsId IS NULL THEN
				IF i_ChrgType = 'R' THEN
					SELECT i_Unit * DECODE(i_TxMode, TXN_ADD_MODE, r_doPackageCharge.ItcAmt1, -r_doPackageCharge.ItcAmt1) INTO r_doCharge.StnBAmt FROM DUAL;
					r_doCharge.StnCpsFlag := SLIPTX_CPS_STD;
				ELSE
					SELECT i_Unit * DECODE(i_TxMode, TXN_ADD_MODE, r_doPackageCharge.ItcAmt2, -r_doPackageCharge.ItcAmt2) INTO r_doCharge.StnBAmt FROM DUAL;
					r_doCharge.StnCpsFlag := SLIPTX_CPS_STA;
				END IF;
			ELSIF r_doPackageCharge.cpspct IS NULL THEN
				IF i_ChrgType = 'R' THEN
					SELECT i_Unit * DECODE(i_TxMode, TXN_ADD_MODE, r_doPackageCharge.ItcAmt3, -r_doPackageCharge.ItcAmt3) INTO r_doCharge.StnBAmt FROM DUAL;
					r_doCharge.StnCpsFlag := SLIPTX_CPS_STD_FIX;
				ELSE
					SELECT i_Unit * DECODE(i_TxMode, TXN_ADD_MODE, r_doPackageCharge.ItcAmt4, -r_doPackageCharge.ItcAmt4) INTO r_doCharge.StnBAmt FROM DUAL;
					r_doCharge.StnCpsFlag := SLIPTX_CPS_STA_FIX;
				END IF;
			ELSE
				IF i_ChrgType = 'R' THEN
					SELECT i_Unit * DECODE(i_TxMode, TXN_ADD_MODE, r_doPackageCharge.ItcAmt1, -r_doPackageCharge.ItcAmt1) INTO r_doCharge.StnBAmt FROM DUAL;
					r_doCharge.StnCpsFlag := SLIPTX_CPS_STD_PCT;
				ELSE
					SELECT i_Unit * DECODE(i_TxMode, TXN_ADD_MODE, r_doPackageCharge.ItcAmt2, -r_doPackageCharge.ItcAmt2) INTO r_doCharge.StnBAmt FROM DUAL;
					r_doCharge.StnCpsFlag := SLIPTX_CPS_STA_PCT;
				END IF;
			END IF;

			IF i_TxMode = TXN_CREDITITEMPER_MODE THEN
				r_doCharge.StnDisc := 0;
			ELSE
				IF r_doPackageCharge.cpspct IS NULL THEN
					IF r_doPackageCharge.ItmType = TYPE_DOCTOR THEN
						r_doCharge.StnDisc := i_SlpDDisc;
					ELSIF r_doPackageCharge.ItmType = TYPE_HOSPITAL THEN
						r_doCharge.StnDisc := i_SlpHDisc;
					ELSE
						r_doCharge.StnDisc := i_SlpSDisc;
					END IF;
				ELSE
					r_doCharge.StnDisc := r_doPackageCharge.cpspct;
				END IF;
			END IF;

			r_doCharge.DocCode := i_DocCode;
			r_doCharge.StnTDate := v_stntdate;
			r_doCharge.StnRlvl := r_doPackageCharge.ItmRlvl;
			r_doCharge.StnDesc := r_doPackageCharge.ItmName;

			SELECT COUNT(1) INTO v_Count FROM Item WHERE ItmCode = r_doCharge.ItmCode;
			IF v_Count > 0 THEN
				SELECT Dptcode INTO v_DeptCode FROM Item WHERE ItmCode = r_doCharge.ItmCode;
				IF v_DeptCode IS NOT NULL THEN
					SELECT COUNT(1) INTO v_Count FROM Sysparam WHERE Parcde = 'DIDeptID' AND Param1 LIKE '%' || v_DeptCode || '%' ;
					IF v_Count = 0 THEN
						r_doCharge.StnDIFlag := 0;
					ELSE
						r_doCharge.StnDIFlag := -1;
					END IF;
				END IF;
			END IF;

			SELECT COUNT(1) INTO v_Count FROM Slip WHERE SlpNo = i_SlpNo;
			IF v_Count > 0 THEN
				SELECT SlpType INTO v_SlpType FROM Slip WHERE SlpNo = i_SlpNo;
			END IF;

			r_doCharge.GlcCode := NHS_UTL_LookupGLCode(TO_CHAR(i_TxDate, 'DD/MM/YYYY'), r_doPackageCharge.ItmCode, '', v_SlpType, NULL, NULL, v_PkgCode, i_AcmCode, v_DeptCode);

			t_doCharge.EXTEND(1);
			t_doCharge(v_KeyCount) := r_doCharge;
			v_KeyCount := v_KeyCount + 1;
		END LOOP;
	ELSE
		o_errmsg := MSG_ITMCHARGE_RATE;
	END IF;

	OPEN o_OUTCUR FOR
		SELECT
			PkgCode,
			ItmCode,
			ItmCat,
			ItmType,
			StnOAmt,
			StnBAmt,
			StnDisc,
			StnTDate,
			DocCode,
			StnDesc,
			AcmCode,
			StnDIFlag,
			StnCpsFlag,
			Unit,
			StnRlvl,
			GlcCode
		FROM TABLE(t_doCharge);
	RETURN o_OUTCUR;

EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;

	RETURN NULL;
END NHS_UTL_LOOKUPPKGCODE;
/
