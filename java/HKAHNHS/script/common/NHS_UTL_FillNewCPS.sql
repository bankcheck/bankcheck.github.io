CREATE OR REPLACE FUNCTION "NHS_UTL_FILLNEWCPS" (
	i_SlpNo       IN VARCHAR2,
	i_PatientType IN VARCHAR2,
	i_OldAcmcode  IN VARCHAR2,
	i_OUTCUR      IN TYPES.CURSOR_TYPE,
	i_NewCPSID    IN VARCHAR2,
	i_NewAcmCode  IN VARCHAR2,
	i_ChangeACM   IN BOOLEAN
)
	RETURN TYPES.CURSOR_TYPE
AS
	SLIP_TYPE_INPATIENT VARCHAR2(1);
	SLIPTX_CPS_STD VARCHAR2(1);
	SLIPTX_CPS_STD_FIX VARCHAR2(1);
	SLIPTX_CPS_STD_PCT VARCHAR2(1);
	SLIPTX_CPS_STA VARCHAR2(1);
	SLIPTX_CPS_STA_FIX VARCHAR2(1);
	SLIPTX_CPS_STA_PCT VARCHAR2(1);
	TYPE_DOCTOR VARCHAR2(1);
	TYPE_HOSPITAL VARCHAR2(1);

	o_errcode NUMBER;
	o_OUTCUR  TYPES.CURSOR_TYPE;

	v_Count    NUMBER;
	v_curCPSID NUMBER;
	v_NewCPSID NUMBER;
	v_ItmRLvl  NUMBER;
	v_Delete   BOOLEAN;
	v_BedCode  BED.BEDCODE%TYPE;
	v_AcmCode  ItemChg.AcmCode%TYPE;
	v_SlpType  Slip.SlpType%TYPE;

	r_ConPceChg NewConPceChange_Obj := NewConPceChange_Obj(0, 0, NULL, NULL, NULL, 0, 0, NULL, NULL, 0, 0, 0, NULL, 0, 0, 0, NULL, 0, NULL, NULL);
	r_ConPceChg2 Sys.NewConPceChange_Rec;
	t_ConPceChg NewConPceChange_Tab := NewConPceChange_Tab();

	memOldCPSID  NUMBER;
	memOldCPSPCT NUMBER;
	memOldRate1  NUMBER;
	memOldRate2  NUMBER;
	memOldRate3  NUMBER;
	memOldRate4  NUMBER;

	memSlpDDisc NUMBER;
	memSlpHDisc NUMBER;
	memSlpSDisc NUMBER;

	memNewCPSID NUMBER;
	memNewCPSPCT NUMBER;
	memNewRate1 NUMBER;
	memNewRate2 NUMBER;
	memNewRate3 NUMBER;
	memNewRate4 NUMBER;

	memStandard BOOLEAN;

	v_TxDate VARCHAR2(10) := TO_CHAR(SYSDATE, 'DD/MM/YYYY');
BEGIN
	SLIP_TYPE_INPATIENT := 'I';
	SLIPTX_CPS_STD := '';         --Standard Rate
	SLIPTX_CPS_STD_FIX := 'F';    --Standard Rate With CPS Fix Amount
	SLIPTX_CPS_STD_PCT := 'P';    --Standard Rate With CPS Percentage Disc
	SLIPTX_CPS_STA := 'S';        --Stat Rate
	SLIPTX_CPS_STA_FIX := 'T';    --Stat Rate With CPS Fix Amount
	SLIPTX_CPS_STA_PCT := 'U';    --Stat Rate With CPS Percentage Disc
	TYPE_DOCTOR := 'D';
	TYPE_HOSPITAL := 'H';

	o_errcode := -1;
	v_NEWCPSID := TO_NUMBER(I_NEWCPSID);

	BEGIN
		SELECT a.CPSID INTO v_curCPSID FROM Slip s, ArCode a WHERE s.SlpNo = i_SlpNo AND s.arccode = a.arccode;
	EXCEPTION
	WHEN OTHERS THEN
		v_curCPSID := NULL;
	END;

	IF i_NewAcmCode IS NOT NULL THEN
		v_NewCPSID := v_curCPSID;
	END IF;

	SELECT COUNT(1) INTO v_Count FROM Slip WHERE SlpNo = i_SlpNo;
	IF v_Count > 0 THEN
		SELECT SLPHDISC, SLPDDISC, SLPSDISC, SlpType INTO memSlpHDisc, memSlpDDisc, memSlpSDisc, v_SlpType FROM Slip WHERE SlpNo = i_SlpNo;
	END IF;

--	dbms_output.put_line('D%[' || memSlpDDisc || ']H%[' || memSlpHDisc || ']S%[' || memSlpSDisc || ']');

	IF i_PatientType = Slip_TYPE_INPATIENT THEN
		SELECT COUNT(1) INTO v_Count FROM inpat i, reg r, Slip s WHERE i.inpid = r.inpid AND r.regid = s.regid AND s.SlpNo = i_SlpNo;
		IF v_Count > 0 THEN
			SELECT i.bedcode INTO v_BedCode FROM inpat i, reg r, Slip s WHERE i.inpid = r.inpid AND r.regid = s.regid AND s.SlpNo = i_SlpNo;
		END IF;
	ELSE
		v_BedCode := '';
	END IF;

	-- special handle for urgent care
	IF v_SlpType = 'O' THEN
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

	IF i_OUTCUR IS NOT NULL THEN
		v_COUNT := 1;
		LOOP
			FETCH i_OUTCUR INTO r_ConPceChg2;
			EXIT WHEN i_OUTCUR%NOTFOUND ;

			v_DELETE := FALSE;
			-- copy value into object
			r_ConPceChg.StnID        := r_ConPceChg2.StnID;
			r_ConPceChg.StnSEQ       := r_ConPceChg2.StnSEQ;
			r_ConPceChg.PkgCode      := r_ConPceChg2.PkgCode;
			r_ConPceChg.ItmCode      := r_ConPceChg2.ItmCode;
			r_ConPceChg.StnDESC      := r_ConPceChg2.StnDESC;
			r_ConPceChg.StnBAMT      := r_ConPceChg2.StnBAMT;
			r_ConPceChg.StnDISC      := r_ConPceChg2.StnDISC;
			r_ConPceChg.StnCPSFlag   := r_ConPceChg2.StnCPSFlag;
			r_ConPceChg.NewCPSFlag   := r_ConPceChg2.NewCPSFlag;
			r_ConPceChg.NewBAmt      := r_ConPceChg2.NewBAmt;
			r_ConPceChg.NewDisc      := r_ConPceChg2.NewDisc;
			r_ConPceChg.Unit         := r_ConPceChg2.Unit;
			r_ConPceChg.ItmType      := r_ConPceChg2.ItmType;
			r_ConPceChg.FirstSTNBAmt := r_ConPceChg2.FirstSTNBAmt;
			r_ConPceChg.OldBAMT      := r_ConPceChg2.OldBAMT;
			r_ConPceChg.OldDisc      := r_ConPceChg2.OldDisc;
			r_ConPceChg.NewAcmCode   := r_ConPceChg2.NewAcmCode;
			r_ConPceChg.NewOAMT      := r_ConPceChg2.NewOAMT;
			r_ConPceChg.NewGLCCODE   := r_ConPceChg2.NewGLCCODE;
			r_ConPceChg.GLCCODE      := r_ConPceChg2.GLCCODE;

			-- Standard or Stat?
			IF r_ConPceChg.StnCPSFlag IS NULL OR
				r_ConPceChg.StnCPSFlag = SlipTX_CPS_STD OR
				r_ConPceChg.StnCPSFlag = SlipTX_CPS_STD_FIX OR
				r_ConPceChg.StnCPSFlag = SlipTX_CPS_STD_PCT THEN
				memStandard := TRUE;
			ELSE
				memStandard := FALSE;
			END IF;

			-- Get Original Parameter
			memOldCPSID := v_curCPSID;

			-- Log 365 ACM Code should use the original one within Sliptx, except chanage ACM Code
			IF v_AcmCode IS NOT NULL THEN
				NHS_SYS_LookupItemCharge(v_TxDate, r_ConPceChg.ItmCode, i_PatientType, v_AcmCode, FALSE, v_ItmRLvl, memOldRate1, memOldRate2, memOldRate3, memOldRate4, memOldCPSID, memOldCPSPCT, r_ConPceChg.PkgCode);
			ELSE
				NHS_SYS_LookupItemCharge(v_TxDate, r_ConPceChg.ItmCode, i_PatientType, r_ConPceChg.NewAcmCode, FALSE, v_ItmRLvl, memOldRate1, memOldRate2, memOldRate3, memOldRate4, memOldCPSID, memOldCPSPCT, r_ConPceChg.PkgCode);
			END IF;

--			dbms_output.put_line('Old R1:[' || memOldRate1 || ']R2:[' || memOldRate2 || ']R3:[' || memOldRate3 || ']R4:[' || memOldRate4 || ']CPSID:[' || memOldCPSID || ']CPSPCT:[' || memOldCPSPCT || ']');

			-- Get New Parameter
			memNewCPSID := v_NewCPSID;

			IF i_NewAcmCode IS NOT NULL THEN
				r_ConPceChg.NewAcmCode := i_NewAcmCode;
			END IF;

			IF v_AcmCode IS NOT NULL THEN
				NHS_SYS_LookupItemCharge(v_TxDate, r_ConPceChg.ItmCode, i_PatientType, v_AcmCode, FALSE, v_ItmRLvl, memNewRate1, memNewRate2, memNewRate3, memNewRate4, memNewCPSID, memNewCPSPCT, r_ConPceChg.PkgCode);
			ELSE
				NHS_SYS_LookupItemCharge(v_TxDate, r_ConPceChg.ItmCode, i_PatientType, r_ConPceChg.NewAcmCode, FALSE, v_ItmRLvl, memNewRate1, memNewRate2, memNewRate3, memNewRate4, memNewCPSID, memNewCPSPCT, r_ConPceChg.PkgCode);
			END IF;

--			dbms_output.put_line('New R1:[' || memNewRate1 || ']R2:[' || memNewRate2 || ']R3:[' || memNewRate3 || ']R4:[' || memNewRate4 || ']CPSID:[' || memNewCPSID || ']CPSPCT:[' || memNewCPSPCT || ']');

			-- When edit the AR code under Transaction Detail, IF the percentage is
			-- changed, the program will change the 'N' record to 'C' AND create two
			-- new records ('U' ||  'N').  The new 'N' record should use the same GL
			-- code as the original 'N' record AND should NOT get it from the current
			-- ward.
			r_ConPceChg.NewGlcCode := r_ConPceChg.Glccode;

			-- New CPS Flag
			IF memStandard THEN
				r_ConPceChg.NewOAmt := memNewRate1;
				IF memNewCPSPCT IS NOT NULL THEN
					r_ConPceChg.NewCPSFlag := SlipTX_CPS_STD_PCT;
				ELSIF memNewCPSID IS NOT NULL THEN
					r_ConPceChg.NewCPSFlag := SlipTX_CPS_STD_FIX;
				ELSE
					r_ConPceChg.NewCPSFlag := SlipTX_CPS_STD;
				END IF;
			ELSE
				r_ConPceChg.NewOAmt := memNewRate2;
				IF memNewCPSPCT IS NOT NULL THEN
					r_ConPceChg.NewCPSFlag := SlipTX_CPS_STA_PCT;
				ELSIF memNewCPSID IS NOT NULL THEN
					r_ConPceChg.NewCPSFlag := SlipTX_CPS_STA_FIX;
				ELSE
					r_ConPceChg.NewCPSFlag := SlipTX_CPS_STA;
				END IF;
			END IF;

			-- Get Original Billing Amount
			IF memOldCPSID IS NULL THEN
				IF memStandard THEN
					r_ConPceChg.OldBAmt := memOldRate1;
				ELSE
					r_ConPceChg.oldBAmt := memOldRate2;
				END IF;
			ELSIF memOldCPSPCT IS NULL THEN
				IF memStandard THEN
					r_ConPceChg.oldBAmt := memOldRate3;
				ELSE
					r_ConPceChg.oldBAmt := memOldRate4;
				END IF;
			ELSE
				IF memStandard THEN
					r_ConPceChg.oldBAmt := memOldRate1;
				ELSE
					r_ConPceChg.oldBAmt := memOldRate2;
				END IF;
			END IF;

			-- Get Original Percentage
			IF r_ConPceChg.ItmType = TYPE_DOCTOR THEN
				r_ConPceChg.oldDisc := memSlpDDisc;
			ELSIF r_ConPceChg.ItmType = TYPE_HOSPITAL THEN
				r_ConPceChg.oldDisc := memSlpHDisc;
			ELSE
				r_ConPceChg.oldDisc := memSlpSDisc;
			END IF;

			r_ConPceChg.NewBAmt := r_ConPceChg.StnBAmt;
			r_ConPceChg.NewDisc := r_ConPceChg.STNDISC;

--			dbms_output.put_line('Old Flag:[' || r_ConPceChg.StnCPSFlag || ']New Flag:[' || r_ConPceChg.NewCPSFlag || ']');

			-- Case 1
			-- Replace the Entry Discount with Contractual Percentage
			IF r_ConPceChg.StnCPSFlag = 'P' AND r_ConPceChg.NewCPSFlag = 'P' THEN
				r_ConPceChg.NewDisc := memNewCPSPCT;
			ELSIF r_ConPceChg.StnCPSFlag = 'U' AND r_ConPceChg.NewCPSFlag = 'U' THEN
				r_ConPceChg.NewDisc := memNewCPSPCT;
			END IF;

			-- Case 2
			-- Replace the Billing Amount with Fixed Price
			IF r_ConPceChg.StnCPSFlag = 'P' AND r_ConPceChg.NewCPSFlag = 'F' THEN
				r_ConPceChg.NewDisc := 0;
				r_ConPceChg.NewBAmt := memNewRate3 * r_ConPceChg.Unit;
			ELSIF r_ConPceChg.StnCPSFlag = 'U' AND r_ConPceChg.NewCPSFlag = 'T' THEN
				r_ConPceChg.NewDisc := 0;
				r_ConPceChg.NewBAmt := memNewRate4 * r_ConPceChg.Unit;
			END IF;

			-- Case 3
			-- Replace the Billing Amount with Fixed Price
			IF r_ConPceChg.StnCPSFlag = 'F' AND r_ConPceChg.NewCPSFlag = 'F' THEN
				r_ConPceChg.NewBAmt := memNewRate3 * r_ConPceChg.Unit;
			ELSIF r_ConPceChg.StnCPSFlag = 'T' AND r_ConPceChg.NewCPSFlag = 'T' THEN
				r_ConPceChg.NewBAmt := memNewRate4 * r_ConPceChg.Unit;
			END IF;

			-- Case 4
			-- Replace the Billing Amount with Original Amount, Replace the Entry Discount with Contractual Percentage
			IF r_ConPceChg.StnCPSFlag = 'F' AND r_ConPceChg.NewCPSFlag = 'P' THEN
				r_ConPceChg.NewBAmt := r_ConPceChg.FirstSTNBAmt;
				r_ConPceChg.NewDisc := memNewCPSPCT;
			ELSIF r_ConPceChg.StnCPSFlag = 'T' AND r_ConPceChg.NewCPSFlag = 'U' THEN
				r_ConPceChg.NewBAmt := r_ConPceChg.FirstSTNBAmt;
				r_ConPceChg.NewDisc := memNewCPSPCT;
			END IF;

			-- Case 5
			-- Replace the Billing Amount with Contractual Fixed Price
			IF r_ConPceChg.StnCPSFlag IS NULL AND r_ConPceChg.NewCPSFlag = 'F' THEN
				r_ConPceChg.NewBAmt := memNewRate3 * r_ConPceChg.Unit;
				r_ConPceChg.NewDisc := 0;
			ELSIF r_ConPceChg.StnCPSFlag = 'S' AND r_ConPceChg.NewCPSFlag = 'T' THEN
				r_ConPceChg.NewBAmt := memNewRate4 * r_ConPceChg.Unit;
				r_ConPceChg.NewDisc := 0;
			END IF;

			-- Case 6
			-- Replace the Entry Discount with Contractual Percentage
			IF r_ConPceChg.StnCPSFlag IS NULL AND r_ConPceChg.NewCPSFlag = 'P' THEN
				r_ConPceChg.NewDisc := memNewCPSPCT;
			ELSIF r_ConPceChg.StnCPSFlag = 'S' AND r_ConPceChg.NewCPSFlag = 'U' THEN
				r_ConPceChg.NewDisc := memNewCPSPCT;
			END IF;

			-- Case 7
			-- Replace the Billing Amount with Original Amount
			IF r_ConPceChg.StnCPSFlag = 'F' AND r_ConPceChg.NewCPSFlag IS NULL THEN
				r_ConPceChg.NewBAmt := r_ConPceChg.FirstSTNBAmt;
				r_ConPceChg.NewDisc := r_ConPceChg.oldDisc;
			ELSIF r_ConPceChg.StnCPSFlag = 'T' AND r_ConPceChg.NewCPSFlag = 'S' THEN
				r_ConPceChg.NewBAmt := r_ConPceChg.FirstSTNBAmt;
				r_ConPceChg.NewDisc := r_ConPceChg.oldDisc;
			END IF;

			-- Case 8
			-- Replace the Entry Discount with the Default Slip Discount
			IF r_ConPceChg.StnCPSFlag = 'P' AND r_ConPceChg.NewCPSFlag IS NULL THEN
				r_ConPceChg.NewDisc := r_ConPceChg.oldDisc;
			ELSIF r_ConPceChg.StnCPSFlag = 'U' AND r_ConPceChg.NewCPSFlag = 'S' THEN
				r_ConPceChg.NewDisc := r_ConPceChg.oldDisc;
			END IF;

			-- Case 9
			-- For change acommodation enhancement
			IF i_ChangeACM THEN
				IF memStandard = False THEN
					 r_ConPceChg.NewOAmt := memNewRate1;
				END IF;

				r_ConPceChg.NewGlcCode := NHS_UTL_LOOKUPGLCODECHGACM(v_TxDate, r_ConPceChg.ItmCode, v_BedCode, 'I', r_ConPceChg.Glccode, FALSE, memNewCPSID, r_ConPceChg.PkgCode, r_ConPceChg.NewAcmCode);
				IF i_OldAcmcode = i_NewAcmCode THEN
					v_Delete := TRUE;
				ELSE
					IF r_ConPceChg.NewCPSFlag IS NULL OR LENGTH(r_ConPceChg.NewCPSFlag) <= 0 THEN
						r_ConPceChg.NewBAmt := memNewRate1 * r_ConPceChg.Unit;
						r_ConPceChg.NewDisc := r_ConPceChg.oldDisc;
					ELSIF r_ConPceChg.NewCPSFlag = 'S' THEN
						r_ConPceChg.NewBAmt := memNewRate2 * r_ConPceChg.Unit;
						r_ConPceChg.NewDisc := r_ConPceChg.oldDisc;
					ELSIF r_ConPceChg.NewCPSFlag = 'F' THEN
						r_ConPceChg.NewBAmt := memNewRate3 * r_ConPceChg.Unit;
						r_ConPceChg.NewDisc := r_ConPceChg.oldDisc;
					ELSIF r_ConPceChg.NewCPSFlag = 'T' THEN
						r_ConPceChg.NewBAmt := memNewRate4 * r_ConPceChg.Unit;
						r_ConPceChg.NewDisc := r_ConPceChg.oldDisc;
					ELSIF r_ConPceChg.NewCPSFlag = 'P' THEN
						r_ConPceChg.NewBAmt := memNewRate1 * r_ConPceChg.Unit;
						r_ConPceChg.NewDisc := memNewCPSPCT;
					ELSIF r_ConPceChg.NewCPSFlag = 'U' THEN
						r_ConPceChg.NewBAmt := memNewRate2 * r_ConPceChg.Unit;
						r_ConPceChg.NewDisc := memNewCPSPCT;
					END IF;
				 END IF;
			END IF;

			-- removeTheSame
			-- If sum of billing amount, discount and CPS Flag is not changed,
			-- Then remove it from the list
			IF r_ConPceChg.StnBAmt = r_ConPceChg.NewBAmt
					AND r_ConPceChg.StnDisc = r_ConPceChg.NewDisc
					AND ((r_ConPceChg.StnCPSFlag = r_ConPceChg.NewCPSFlag)
					OR  (r_ConPceChg.StnCPSFlag IS NULL AND r_ConPceChg.NewCPSFlag IS NULL))
					AND i_ChangeACM = FALSE THEN
				v_Delete := TRUE;
			END IF;

			-- storeBackgroundJob
			IF NOT v_Delete THEN
				t_ConPceChg.EXTEND(1);
				t_ConPceChg(v_Count) := r_ConPceChg;
				v_Count := v_Count + 1;
			END IF;
		END LOOP;
	END IF;

	OPEN o_OUTCUR FOR
  		SELECT * FROM table(t_ConPceChg);
	RETURN o_OUTCUR;

EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN NULL;
END NHS_UTL_FILLNEWCPS;
/
