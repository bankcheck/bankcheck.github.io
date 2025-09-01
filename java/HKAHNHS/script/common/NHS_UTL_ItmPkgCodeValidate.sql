-- Transaction.bas \ ItmPkgCodeValidate
CREATE OR REPLACE FUNCTION NHS_UTL_ITMPKGCODEVALIDATE (
	i_TxMode   IN VARCHAR2,
	i_TxDate   IN VARCHAR2,
	i_SlpNo    IN VARCHAR2,
	i_SlpType  IN VARCHAR2,
	i_ChrgType IN VARCHAR2,
	i_ChrgCode IN VARCHAR2,
	i_DocCode  IN VARCHAR2,
	i_AcmCode  IN VARCHAR2,
	i_Unit     IN NUMBER,
	i_Amount   IN NUMBER,
	i_SlpHDisc IN NUMBER,
	i_SlpDDisc IN NUMBER,
	i_SlpSDisc IN NUMBER,
	i_UserID   IN VARCHAR2,
	o_errmsg   OUT VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
IS
	o_errcode NUMBER := -1;
	o_outcur TYPES.CURSOR_TYPE;
	c_doCharge TYPES.CURSOR_TYPE;
	r_doCharge Sys.LookupCharge_Rec;
	r_itemCharge LookupCharge_Obj := LookupCharge_Obj(NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, 0, NULL);
	t_itemCharge LookupCharge_Tab := LookupCharge_Tab();
	v_KeyCount NUMBER;
	v_stntdate DATE;

	v_ItmCode Item.ItmCode%TYPE;
	v_ItmCat Item.ItmCat%TYPE;
	v_ItmType Item.ItmType%TYPE;
	v_StnDesc Item.ItmName%TYPE;
	v_StnOAmt SlipTx.StnOAmt%TYPE;
	v_StnBAmt SlipTx.StnBAmt%TYPE;
	v_StnCpsFlag SlipTx.StnCpsFlag%TYPE;
	v_SlpCpsid NUMBER;
	v_flagToDi BOOLEAN;
	v_flagToDi2 VARCHAR2(2);
	v_StnDisc Slip.Slphdisc%TYPE;
	v_StnRlvl Item.ItmRLvl%TYPE := 0;
BEGIN
	IF i_TxDate IS NOT NULL THEN
		v_stntdate := TO_DATE(i_TxDate, 'DD/MM/YYYY');
	ELSE
		v_stntdate := TRUNC(SYSDATE);
	END IF;

	-- LookUpItmCode
	o_errcode := NHS_UTL_LOOKUPITMCODE(
		i_TxMode,
		i_TxDate,
		i_SlpNo,
		i_SlpType,
		i_ChrgType,
		i_ChrgCode,
		i_AcmCode,
		i_Unit,
		0,
		i_SlpHDisc,
		i_SlpDDisc,
		i_SlpSDisc,
		i_UserID,
		v_ItmCode,
		v_ItmCat,
		v_ItmType,
		v_StnDesc,
		v_StnOAmt,
		v_StnBAmt,
		v_StnCpsFlag,
		v_SlpCpsid,
		v_flagToDi,
		v_StnDisc,
		v_StnRlvl,
		o_errmsg);

	IF o_errcode >= 0 THEN
		IF v_flagToDi THEN
			v_flagToDi2 := 'Y';
		ELSE
			v_flagToDi2 := 'N';
		END IF;

		IF v_StnOAmt IS NULL THEN
			v_StnOAmt := 0;
		END IF;

		IF v_StnBAmt IS NULL THEN
			v_StnBAmt := 0;
		END IF;

		IF v_StnDisc IS NULL THEN
			v_StnDisc := 0;
		END IF;

		OPEN o_outcur FOR
		SELECT NULL, v_ItmCode, v_ItmCat, v_StnOAmt, v_StnBAmt, v_StnDisc,
			v_stntdate, i_DocCode, v_StnDesc, i_AcmCode, v_flagToDi2,
			v_StnCpsFlag, i_Unit, NULL, NULL, v_StnRlvl, v_ItmType
		FROM DUAL;
	ELSIF i_ChrgCode IS NOT NULL AND i_ChrgCode != 'REF' THEN
		-- LookUpPkgCode
		c_doCharge := NHS_UTL_LOOKUPPKGCODE(i_ChrgCode, 'PKGTX', i_TxMode,
			v_stntdate, i_SlpNo, i_DocCode, i_SlpType, i_ChrgType, i_AcmCode,
			i_Unit, i_SlpHDisc, i_SlpDDisc, i_SlpSDisc, o_errmsg );

		IF c_doCharge IS NOT NULL THEN
			v_KeyCount := 1;
			LOOP
				FETCH c_doCharge INTO r_doCharge;
				EXIT WHEN c_doCharge%NOTFOUND;

				IF r_doCharge.StnDIFlag = -1 THEN
					v_flagToDi2 := 'Y';
				ELSE
					v_flagToDi2 := 'N';
				END IF;

				v_StnOAmt := r_doCharge.StnOAmt;
				IF v_StnOAmt IS NULL THEN
					v_StnOAmt := 0;
				END IF;

				v_StnBAmt := r_doCharge.StnBAmt;
				IF v_StnBAmt IS NULL THEN
					v_StnBAmt := 0;
				END IF;

				v_StnDisc := r_doCharge.StnDisc;
				IF v_StnDisc IS NULL THEN
					v_StnDisc := 0;
				END IF;

				-- reformat output
				r_itemCharge.PkgCode := r_doCharge.PkgCode;
				r_itemCharge.ItmCode := r_doCharge.ItmCode;
				r_itemCharge.ItmCat := r_doCharge.ItmCat;
				r_itemCharge.StnOAmt := v_StnOAmt;
				r_itemCharge.StnBAmt := v_StnBAmt;
				r_itemCharge.StnDisc := v_StnDisc;
				r_itemCharge.StnTDate := v_stntdate;
				r_itemCharge.DocCode := i_DocCode;
				r_itemCharge.StnDesc := r_doCharge.StnDesc;
				r_itemCharge.AcmCode := i_AcmCode;
				r_itemCharge.StnDIFlag := v_flagToDi2;
				r_itemCharge.StnCpsFlag := r_doCharge.StnCpsFlag;
				r_itemCharge.Unit := i_Unit;
				r_itemCharge.StnDesc1 := NULL;
				r_itemCharge.IRefNo := NULL;
				r_itemCharge.StnRlvl := r_doCharge.StnRlvl;
				r_itemCharge.ItmType := r_doCharge.ItmType;
				t_itemCharge.EXTEND(1);
				t_itemCharge(v_KeyCount) := r_itemCharge;
				v_KeyCount := v_KeyCount + 1;
			END LOOP;

			OPEN o_outcur FOR
			SELECT
				PkgCode,
				ItmCode,
				ItmCat,
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
				StnDesc1,
				IRefNo,
				StnRlvl,
				ItmType
			FROM TABLE(t_itemCharge);
		END IF;
	END IF;

	RETURN o_outcur;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;

	RETURN NULL;
END NHS_UTL_ITMPKGCODEVALIDATE;
/
