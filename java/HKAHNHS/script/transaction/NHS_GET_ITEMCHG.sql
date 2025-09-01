create or replace FUNCTION "NHS_GET_ITEMCHG" (
	i_Action        IN VARCHAR2,
	i_Slpno         IN VARCHAR2,
	i_SlpType       IN VARCHAR2,
	i_TransDate     IN VARCHAR2,
	i_ItmCode       IN VARCHAR2,
	i_DocCode       IN VARCHAR2,
	i_AcmCode       IN VARCHAR2,
	i_Unit          IN VARCHAR2,
	i_SlpHDisc      IN VARCHAR2,
	i_SlpDDisc      IN VARCHAR2,
	i_SlpSDisc      IN VARCHAR2,
	i_ChkRate       IN VARCHAR2,
	i_UsrID         IN VARCHAR2,
	i_bAmountYN     IN VARCHAR2,
	i_TmpAmount     IN VARCHAR2,
	i_irefno        IN VARCHAR2
)
	RETURN types.cursor_type
AS
	o_outcur types.cursor_type;
	o_outcur1 types.cursor_type;
	o_errmsg VARCHAR2(1000);
	v_Unit SlipTx.Unit%TYPE;
	v_StnOAmt SlipTx.StnOAmt%TYPE;
	v_SlpHDisc Slip.SlpHDisc%TYPE;
	v_slpddisc Slip.SlpDDisc%TYPE;
	v_SlpSDisc Slip.SlpSDisc%TYPE;
	v_Bedcode BED.BEDCODE%TYPE;
	v_chrgtype VARCHAR2(1);
	v_Count NUMBER;
	v_TransDate VARCHAR2(10);

	TYPE ItemChg_Rec IS RECORD (
	-- ItemChg : begin -----------------------------------------------------------
		pkgcode        sliptx.pkgcode%TYPE,
		itmcode        SlipTx.ItmCode%TYPE,
		itmcat         item.itmcat%TYPE,
		stnoamt        sliptx.stnoamt%TYPE,
		stnbamt        sliptx.stnbamt%TYPE,
		StnDisc        Slip.Slphdisc%TYPE,
		stntdate       DATE,
		doccode        sliptx.doccode%TYPE,
		stndesc        sliptx.stndesc%TYPE,
		acmcode        sliptx.acmcode%TYPE,-- in sys.ItemChg_Rec is SlipTx.StnDIFlag%TYPE
		stndiflag      VARCHAR2(2),
		StnCpsFlag     SlipTx.StnCpsFlag%TYPE,
		Unit           SlipTx.Unit%TYPE,
		StnDesc1       SlipTx.StnDesc%TYPE,
		IRefNo         SlipTx.IRefNo%TYPE,
		StnRlvl        SlipTx.StnRlvl%TYPE,
		ItmType        SlipTx.ItmType%TYPE
	-- ItemChg : end -------------------------------------------------------------
	);
	r_docharge ItemChg_Rec;
	r_itemCharge LookupCharge_Obj := LookupCharge_Obj(NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, NULL, 0, NULL);
	t_itemcharge LookupCharge_tab := LookupCharge_tab();
	v_KeyCount NUMBER;
BEGIN
	IF GET_CURRENT_STECODE = 'HKAH' THEN
		IF i_SlpType = 'O' THEN
		    BEGIN
			SELECT TO_CHAR(REGDATE,'DD/MM/YYYY')
			INTO v_TransDate
			FROM REG
			WHERE SLPNO = i_Slpno;
		    EXCEPTION
		    WHEN OTHERS THEN
			v_TransDate := i_TransDate;
		    END;
		    IF v_TransDate IS NULL THEN
			v_TransDate := i_TransDate;
		    END IF;
		ELSE
		    v_TransDate := i_TransDate;
		END IF;
	ELSE
		v_TransDate := i_TransDate;
	END IF;

	v_Unit := TO_NUMBER(i_Unit);

	v_SlpHDisc := TO_NUMBER(i_SlpHDisc);
	IF v_SlpHDisc = 0 THEN
		v_SlpHDisc := NULL;
	END IF;

	v_SlpDDisc := TO_NUMBER(i_SlpDDisc);
	IF v_SlpDDisc = 0 THEN
		v_SlpDDisc := NULL;
	END IF;

	v_SlpSDisc := TO_NUMBER(i_SlpSDisc);
	IF v_SlpSDisc = 0 THEN
		v_SlpSDisc := NULL;
	END IF;

	IF i_ChkRate = '-1' THEN
		v_ChrgType := 'R';
	ELSE
		v_ChrgType := '';
	END IF;

	IF i_SlpType = 'I' THEN
		SELECT COUNT(1) INTO v_Count
		FROM SLIP S
		LEFT JOIN Reg R ON S.Regid = R.Regid
		LEFT JOIN Inpat I ON R.Inpid = I.Inpid
		WHERE S.SlpNo = i_Slpno;
		IF v_Count = 1 THEN
			SELECT I.Bedcode INTO v_Bedcode
			FROM SLIP S
			LEFT JOIN Reg R ON S.Regid = R.Regid
			LEFT JOIN Inpat I ON R.Inpid = I.Inpid
			WHERE S.SlpNo = i_Slpno;
		END IF;
	END IF;

	o_outcur := NHS_UTL_ITMPKGCODEVALIDATE(i_Action, v_TransDate, i_Slpno, i_SlpType,
		v_chrgtype, i_itmcode, i_doccode, i_acmcode, v_unit,
		0, v_SlpHDisc, v_SlpDDisc, v_SlpSDisc, i_UsrID,
		o_errmsg);

	IF o_outcur IS NOT NULL THEN
		v_KeyCount := 1;
		LOOP
			FETCH o_outcur INTO r_docharge;
			EXIT WHEN o_outcur%notfound;

			r_itemcharge.pkgcode := r_docharge.pkgcode;
			r_itemcharge.itmcode := r_docharge.itmcode;
			r_itemcharge.ItmCat := r_docharge.itmcat;

			IF i_bamountYN = 'Y' then
				r_itemcharge.StnOAmt := TO_NUMBER(i_tmpamount);
			ELSE
				r_itemcharge.StnOAmt := r_docharge.stnoamt;
			END IF;

			IF i_bamountYN = 'Y' then
				r_itemcharge.StnBAmt := TO_NUMBER(i_tmpamount);
			ELSE
				r_itemcharge.StnBAmt := r_docharge.stnbamt;
			END IF;

			-- special handle room charge
			IF GET_CURRENT_STECODE = 'HKAH' AND i_SlpType = 'I' AND v_Bedcode IS NOT NULL THEN
				v_Count := 0;

				-- search itemcode + acmcode + bedcode
				IF v_Count = 0 THEN
					SELECT COUNT(1) INTO v_Count
					FROM   HPSTATUS
					WHERE  HPTYPE = 'ROOMCHARGE'
					AND    HPKEY = i_ItmCode || '-' || i_acmcode
					AND    HPSTATUS = v_Bedcode;

					IF v_Count = 1 THEN
						SELECT HPRMK INTO r_itemcharge.StnBAmt
						FROM   HPSTATUS
						WHERE  HPTYPE = 'ROOMCHARGE'
						AND    HPKEY = i_ItmCode || '-' || i_acmcode
						AND    HPSTATUS = v_Bedcode;
					END IF;
				END IF;

				-- search itemcode + bedcode
				IF v_Count = 0 THEN
					SELECT COUNT(1) INTO v_Count
					FROM   HPSTATUS
					WHERE  HPTYPE = 'ROOMCHARGE'
					AND    HPKEY = i_ItmCode
					AND    HPSTATUS = v_Bedcode;

					IF v_Count = 1 THEN
						SELECT HPRMK INTO r_itemcharge.StnBAmt
						FROM   HPSTATUS
						WHERE  HPTYPE = 'ROOMCHARGE'
						AND    HPKEY = i_ItmCode
						AND    HPSTATUS = v_Bedcode;
					END IF;
				END IF;

				-- search itemcode + acmcode
				IF v_Count = 0 THEN
					SELECT COUNT(1) INTO v_Count
					FROM   HPSTATUS
					WHERE  HPTYPE = 'ROOMCHARGE'
					AND    HPKEY = i_ItmCode || '-' || i_acmcode
					AND    HPSTATUS = 'ALL';

					IF v_Count = 1 THEN
						SELECT HPRMK INTO r_itemcharge.StnBAmt
						FROM   HPSTATUS
						WHERE  HPTYPE = 'ROOMCHARGE'
						AND    HPKEY = i_ItmCode || '-' || i_acmcode
						AND    HPSTATUS = 'ALL';
					END IF;
				END IF;

				-- search itemcode
				IF v_Count = 0 THEN
					SELECT COUNT(1) INTO v_Count
					FROM   HPSTATUS
					WHERE  HPTYPE = 'ROOMCHARGE'
					AND    HPKEY = i_ItmCode
					AND    HPSTATUS = 'ALL';

					IF v_Count = 1 THEN
						SELECT HPRMK INTO r_itemcharge.StnBAmt
						FROM   HPSTATUS
						WHERE  HPTYPE = 'ROOMCHARGE'
						AND    HPKEY = i_ItmCode
						AND    HPSTATUS = 'ALL';
					END IF;
				END IF;
			END IF;

			r_itemcharge.StnDisc := r_docharge.stndisc;
			-- special handle discount
			IF GET_CURRENT_STECODE = 'HKAH' AND i_SlpType = 'O' AND r_docharge.itmcode = 'LEAD' AND SYSDATE < TO_DATE('01/01/2016', 'DD/MM/YYYY') THEN
				SELECT COUNT(1) INTO v_Count FROM Slip WHERE Arccode = 'LEAD2' AND Slpno = i_Slpno;
				IF v_Count = 0 THEN
					r_itemcharge.StnDisc := 50;
				END IF;
			END IF;

			r_itemcharge.StnTDate := TO_DATE(v_TransDate, 'DD/MM/YYYY');

			r_itemcharge.DocCode := r_docharge.doccode;
			-- special handle doccode
			IF GET_CURRENT_STECODE = 'HKAH' AND r_docharge.itmcode = 'DFAUD' THEN
				r_itemcharge.DocCode := '999';
			END IF;
			IF GET_CURRENT_STECODE = 'HKAH' AND r_docharge.itmcode = 'DFENT' THEN
				r_itemcharge.DocCode := '7019';
			END IF;

			r_itemcharge.StnDesc := r_docharge.stndesc;
			r_itemcharge.AcmCode := r_docharge.acmcode;
			r_itemcharge.StnDIFlag := r_docharge.stndiflag;
			r_itemcharge.StnCpsFlag := r_docharge.stncpsflag;
			r_itemcharge.Unit := r_docharge.unit;
			r_itemcharge.StnDesc1 := r_docharge.stndesc1;
			r_itemcharge.IRefNo := i_irefno;
			r_itemcharge.StnRlvl := r_docharge.stnrlvl;
			r_itemCharge.ItmType := r_docharge.ItmType;

			t_itemcharge.extend(1);
			t_itemCharge(v_KeyCount) := r_itemCharge;
			v_KeyCount := v_KeyCount + 1;
		END LOOP;
		CLOSE o_outcur;
	END IF;

	OPEN o_outcur1 FOR
		SELECT
			C.PkgCode,
			C.ItmCode,
			C.ItmCat,
			C.StnOAmt,
			C.StnBAmt,
			C.StnDisc,
			v_TransDate,
			C.DocCode,
			D.DOCFNAME || ' ' || D.DOCGNAME,
			C.StnDesc,
			C.AcmCode,
			C.StnDIFlag,
			C.StnCpsFlag,
			C.Unit,
			C.StnDesc1,
			C.IRefNo,
			C.StnRlvl,
			C.ItmType
		FROM TABLE(t_itemcharge) C
		LEFT JOIN DOCTOR D ON C.DocCode = D.DocCode;

	RETURN o_outcur1;
END NHS_GET_ITEMCHG;
/
