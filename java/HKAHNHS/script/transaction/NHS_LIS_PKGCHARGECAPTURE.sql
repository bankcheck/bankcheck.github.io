CREATE OR REPLACE FUNCTION "NHS_LIS_PKGCHARGECAPTURE" (
	i_SlipNo    IN VARCHAR2,
	i_PkgCode   IN VARCHAR2,
	i_ItmCode   IN VARCHAR2,
	i_TransDate IN VARCHAR2,
	i_StdRate   IN VARCHAR2,
	i_UsrID     IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	O_ErrCode NUMBER;
	O_ErrMsg VARCHAR2(100);
	v_Count NUMBER;

	OUTCUR TYPES.CURSOR_TYPE;
	v_Rate1 ItemChg.ITCAMT1%TYPE;
	v_Rate2 ItemChg.ITCAMT2%TYPE;
	v_Rate3 ItemChg.ITCAMT1%TYPE;
	v_Rate4 ItemChg.ITCAMT2%TYPE;
	v_ITMRLVL Item.ITMRLVL%TYPE;
	v_CPSID ItemChg.CPSID%TYPE;
	v_CPSPct ItemChg.CPSPct%TYPE;
	v_ItmName ITEM.ITMNAME%TYPE;

	v_DptCode Usr.DptCode%TYPE;
	v_DocCode Slip.DocCode%TYPE;
	v_AcmCode Inpat.AcmCode%TYPE;
	v_BedCode Inpat.Bedcode%TYPE;
	v_Slptype Slip.Slptype%TYPE;
	v_SlpHDisc Slip.SlpHDisc%TYPE;
	v_SlpDDisc Slip.SlpDDisc%TYPE;
	v_SlpSDisc Slip.SlpSDisc%TYPE;

	v_KeyCount NUMBER;
	c_doPackageCharge TYPES.CURSOR_TYPE;
	r_doPackageCharge Sys.LookupPackageCharge_Rec;
	r_itemCharge LookupCharge_Obj := LookupCharge_Obj(NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, 0, NULL);
	t_itemcharge LookupCharge_tab := LookupCharge_tab();

	TXN_ADD_MODE VARCHAR2(3) := 'ADD';
	PKGTX_TYPE_NATUREOFVISIT VARCHAR2(1) := 'N';
	SLIPTX_CPS_STD VARCHAR2(1) := '';		-- Standard Rate
	SLIPTX_CPS_STD_FIX VARCHAR2(1) := 'F';	-- Standard Rate With CPS Fix Amount
	SLIPTX_CPS_STD_PCT VARCHAR2(1) := 'P';	-- Standard Rate With CPS Percentage Disc
	SLIPTX_CPS_STA VARCHAR2(1) := 'S';		-- Stat Rate
	SLIPTX_CPS_STA_FIX VARCHAR2(1) := 'T';	-- Stat Rate With CPS Fix Amount
	SLIPTX_CPS_STA_PCT VARCHAR2(1) := 'U';	-- Stat Rate With CPS Percentage Disc

	MSG_SLIP_NO VARCHAR2(20) := 'Invalid slip number.';
	MSG_PKG_CODE VARCHAR2(21) := 'Invalid package code.';
	MSG_ITMPKG_CODE VARCHAR2(22) := 'Invalid item/pkg code.';
	MSG_ITMCHARGE_RATE VARCHAR2(25) := 'Invalid item charge rate.';
BEGIN
	O_ErrCode := -1;
	O_ErrMsg := 'OK';

	SELECT COUNT(1) INTO v_Count FROM Usr WHERE UsrID = i_UsrID AND UsrPBO = 0;
	IF v_Count = 1 THEN
		SELECT dptcode INTO v_DptCode FROM Usr WHERE UsrID = i_UsrID AND UsrPBO = 0;
	END IF;

	SELECT COUNT(1) INTO v_Count FROM Slip WHERE SlpNo = i_SlipNo;
	IF v_Count = 1 THEN
		SELECT S.Slptype, S.SlpHDisc, S.SlpDDisc, S.SlpSDisc, S.DocCode, I.Acmcode, I.Bedcode
		INTO   v_Slptype, v_SlpHDisc, v_SlpDDisc, v_SlpSDisc, v_DocCode, v_AcmCode, v_BedCode
		FROM   Slip S
		LEFT JOIN Reg R ON S.Regid = R.Regid
		LEFT JOIN Inpat I ON R.Inpid = I.Inpid
		WHERE  S.Slpno = i_SlipNo;
	ELSE
		O_ErrMsg := MSG_SLIP_NO;
		GOTO Return_Error;
	END IF;

	--LookUpSpecPkgCode
	IF i_PkgCode IS NOT NULL AND LENGTH(i_PkgCode) > 0 THEN
		SELECT COUNT(1) INTO v_Count
		FROM Package
		WHERE PKGCODE = i_PkgCode
    	AND   PKGTYPE <> PKGTX_TYPE_NATUREOFVISIT
		AND  (v_DptCode IS NULL OR DPTCODE = v_DptCode);

		IF v_Count = 0 THEN
			O_ErrCode := -200;
			O_ErrMsg := MSG_PKG_CODE;
			GOTO Return_Error;
		END IF;
	END IF;

	--LookupItemCode
	IF i_ItmCode IS NOT NULL AND LENGTH(i_ItmCode) > 0 THEN
		SELECT COUNT(1) INTO v_Count
		FROM   ITEM
		WHERE  ITMCODE = i_ItmCode
		AND   (v_DptCode IS NULL OR DPTCODE = v_DptCode);

		IF v_Count = 1 THEN
			SELECT ItmName INTO v_ItmName
			FROM   ITEM
			WHERE  ITMCODE = i_ItmCode
			AND  (v_DptCode IS NULL OR DPTCODE = v_DptCode);

			--ItemChargeValidate
			NHS_SYS_LookupItemCharge(i_TransDate, i_ItmCode, v_Slptype, v_AcmCode, NULL,
				v_ItmrLvl, v_Rate1, v_Rate2, v_Rate3, v_Rate4, v_CPSID, v_CPSPct, NULL);

			IF v_Rate1 IS NULL OR LENGTH(v_Rate1) <= 0 THEN
				O_ErrCode := -100;
				O_ErrMsg := MSG_ITMCHARGE_RATE;
				GOTO Return_Error;
			END IF;

			r_itemCharge.PkgCode := i_PkgCode;
			r_itemCharge.ItmCode := i_ItmCode;
			r_itemCharge.StnOAmt := v_Rate1;

			IF v_CPSID IS NULL THEN
				IF i_StdRate = 'Y' THEN
					r_itemCharge.StnBAmt := v_Rate3;
					r_itemCharge.StnCpsFlag := SLIPTX_CPS_STD;
				ELSE
					r_itemCharge.StnBAmt := v_Rate4;
					r_itemCharge.StnCpsFlag := SLIPTX_CPS_STA;
				END IF;
			ELSIF r_doPackageCharge.cpspct IS NOT NULL THEN
				IF i_StdRate = 'Y' THEN
					r_itemCharge.StnBAmt := v_Rate3;
					r_itemCharge.StnCpsFlag := SLIPTX_CPS_STD_PCT;
				ELSE
					r_itemCharge.StnBAmt := v_Rate4;
					r_itemCharge.StnCpsFlag := SLIPTX_CPS_STA_PCT;
				END IF;
			ELSE
				IF i_StdRate = 'Y' THEN
					r_itemCharge.StnBAmt := v_Rate1;
					r_itemCharge.StnCpsFlag := SLIPTX_CPS_STD_FIX;
				ELSE
					r_itemCharge.StnBAmt := v_Rate2;
					r_itemCharge.StnCpsFlag := SLIPTX_CPS_STA_FIX;
				END IF;
			END IF;

			r_itemCharge.AcmCode := v_AcmCode;
			r_itemCharge.DocCode := v_DocCode;
			r_itemCharge.StnTDate := TO_DATE(i_TransDate, 'DD/MM/YYYY');
			r_itemCharge.StnRlvl := v_ItmrLvl;
			r_itemCharge.StnDesc := v_ItmName;
			r_itemCharge.GlcCode := NHS_UTL_LookupGLCode(i_TransDate, i_ItmCode, v_BedCode, v_SlpType, NULL, NULL, NULL, v_AcmCode, NULL);
			r_itemCharge.CPSID := v_CPSID;

			t_itemcharge.EXTEND(1);
			t_itemcharge(1) := r_itemCharge;

			OPEN OUTCUR FOR
			SELECT PkgCode, ItmCode, StnBAmt, DocCode, TO_CHAR(StnTDate, 'DD/MM/YYYY'), StnDesc, AcmCode, StnCpsFlag, NULL, '0', CPSID, StnOAmt, 'N'
			FROM   TABLE(t_itemcharge);

			RETURN OUTCUR;
		END IF;
	ELSE
		O_ErrCode := -100;
		O_ErrMsg := MSG_ITMPKG_CODE;
		GOTO Return_Error;
	END IF;

	-- LookUpPkgCode
	IF i_ItmCode IS NOT NULL AND i_PkgCode IS NOT NULL THEN
		SELECT COUNT(1) INTO v_Count
		FROM   Package
		WHERE  PKGCODE = i_ItmCode
    	AND    PKGTYPE <> PKGTX_TYPE_NATUREOFVISIT
		AND   (v_DptCode IS NULL OR DPTCODE = v_DptCode);

		IF v_Count = 0 THEN
			O_ErrCode := -100;
			O_ErrMsg := MSG_ITMPKG_CODE;
			GOTO Return_Error;
		END IF;

		-- LookupPackageCharge
		c_doPackageCharge := NHS_SYS_LookupPackageCharge(i_TransDate, i_ItmCode, v_Slptype, NULL, v_AcmCode, NULL, NULL);
		IF c_doPackageCharge IS NULL THEN
			O_ErrCode := -100;
			O_ErrMsg := MSG_ITMCHARGE_RATE;
			GOTO Return_Error;
		END IF;

		v_KeyCount := 1;
		LOOP
			FETCH c_doPackageCharge into r_doPackageCharge;
			EXIT WHEN c_doPackageCharge%NOTFOUND;

			r_itemCharge.PkgCode := i_PkgCode;
			r_itemCharge.ItmCode := r_doPackageCharge.ItmCode;
			r_itemCharge.StnOAmt := r_doPackageCharge.ItcAmt1;

			IF r_doPackageCharge.CpsId IS NULL THEN
				IF i_StdRate = 'Y' THEN
					r_itemCharge.StnBAmt := r_doPackageCharge.ItcAmt3;
					r_itemCharge.StnCpsFlag := SLIPTX_CPS_STD;
				ELSE
					r_itemCharge.StnBAmt := r_doPackageCharge.ItcAmt4;
					r_itemCharge.StnCpsFlag := SLIPTX_CPS_STA;
				END IF;
			ELSIF r_doPackageCharge.cpspct IS NOT NULL THEN
				IF i_StdRate = 'Y' THEN
					r_itemCharge.StnBAmt := r_doPackageCharge.ItcAmt3;
					r_itemCharge.StnCpsFlag := SLIPTX_CPS_STD_PCT;
				ELSE
					r_itemCharge.StnBAmt := r_doPackageCharge.ItcAmt4;
					r_itemCharge.StnCpsFlag := SLIPTX_CPS_STA_PCT;
				END IF;
			ELSE
				IF i_StdRate = 'Y' THEN
					r_itemCharge.StnBAmt := r_doPackageCharge.ItcAmt1;
					r_itemCharge.StnCpsFlag := SLIPTX_CPS_STD_FIX;
				ELSE
					r_itemCharge.StnBAmt := r_doPackageCharge.ItcAmt2;
					r_itemCharge.StnCpsFlag := SLIPTX_CPS_STA_FIX;
				END IF;
			END IF;

			r_itemCharge.AcmCode := v_AcmCode;
			r_itemCharge.DocCode := v_DocCode;
			r_itemCharge.StnTDate := TO_DATE(i_TransDate, 'DD/MM/YYYY');
			r_itemCharge.StnRlvl := r_doPackageCharge.ItmRlvl;
			r_itemCharge.StnDesc := r_doPackageCharge.ItmName;
			r_itemCharge.GlcCode := NHS_UTL_LookupGLCode(i_TransDate, r_doPackageCharge.ItmCode, v_BedCode, v_SlpType, NULL, NULL, i_ItmCode, v_AcmCode, NULL);
			r_itemCharge.CPSID := v_CPSID;

			t_itemcharge.EXTEND(1);
			t_itemcharge(v_KeyCount) := r_itemCharge;
			v_KeyCount := v_KeyCount + 1;
		END LOOP;

		OPEN OUTCUR FOR
		SELECT PkgCode, ItmCode, StnBAmt, DocCode, TO_CHAR(StnTDate, 'DD/MM/YYYY'), StnDesc, AcmCode, StnCpsFlag, NULL, StnRlvl, CPSID, StnOAmt, 'N'
		FROM   TABLE(t_itemcharge);

		RETURN OUTCUR;
	END IF;

<<Return_Error>>
	OPEN OUTCUR FOR
	SELECT O_ErrCode, O_ErrMsg FROM DUAL;
	RETURN OUTCUR;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN NULL;
END NHS_LIS_PKGCHARGECAPTURE;
/
