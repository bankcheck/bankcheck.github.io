CREATE OR REPLACE FUNCTION "NHS_UTL_ADDENTRY" (
	a_SlipNo           IN VARCHAR2,
	a_ItemCode         IN VARCHAR2,
	a_ItemType         IN VARCHAR2,
	a_EntryType        IN VARCHAR2,
	a_StnOAmt          IN NUMBER,
	a_StnBAmt          IN NUMBER,
	a_DoctorCode       IN VARCHAR2,
	a_ReportLevel      IN NUMBER,
	a_AccomodationCode IN VARCHAR2,
	a_Discount         IN NUMBER,
	a_PackageCode      IN VARCHAR2,
	a_capturedate      IN DATE,
	a_TransactionDate  IN DATE,
	a_Description      IN VARCHAR2,
	a_Status           IN VARCHAR2,
	a_GlcCode          IN VARCHAR2,
	a_ReferenceID      IN NUMBER,
	a_CashierClosed    IN BOOLEAN := FALSE,
	a_BedCode          IN VARCHAR2,
	a_dixref           IN NUMBER,
	a_flagToDi         IN BOOLEAN := TRUE,
	a_ConPceSetFlag    IN VARCHAR2 := '',
	a_Cpsid            IN NUMBER,
	a_unit             IN NUMBER,
	a_Stndesc1         IN VARCHAR2 := '',
	a_IRefNo           IN VARCHAR2,
	a_vDeptCode        IN VARCHAR2,
	a_userid           IN VARCHAR2
)
	RETURN NUMBER
AS
	v_Count         NUMBER;
	v_stnid         NUMBER(22,0);
	v_stnseq        NUMBER(22,0);
	v_GlcCode       VARCHAR2(8);
	v_ItmType       VARCHAR2(1);
	v_itmlvl        NUMBER(22,0);
	v_BedCode       BED.BEDCODE%TYPE;
	v_DscCode       VARCHAR2(2);
	v_DeptCode      VARCHAR2(10);
	v_PcyID         NUMBER(22,0);
	v_tmpSlpType    VARCHAR2(1);
	v_RegOPCat      Slip.RegOPCat%TYPE;
	v_SlpSts        Slip.SlpSts%TYPE;
	v_lCpsid        NUMBER(22,0);
	v_AcmCode       ACM.ACMCODE%TYPE;
	v_StnSts        VARCHAR2(1);
	v_PkgCode       PACKAGE.PKGCODE%TYPE;
	v_transver      VARCHAR2(50);
	v_StnNAmt       NUMBER(14,4);
	v_StnDisc       NUMBER(14,4);
	v_Discount_type VARCHAR2(1);
	v_DocCode       VARCHAR2(10);
	v_capturedate   DATE;
	v_StnTDate      DATE;
	v_DIXREF        NUMBER(22,0);
	v_StnRlvl       NUMBER(22,0);
	v_StnXRef       NUMBER(22,0);
	v_StnDesc       VARCHAR2(80);
	v_StnDesc1      VARCHAR2(80);
	v_DiDeptCode    VARCHAR2(50);
	v_STNDIFLAG     NUMBER(1,0);
	v_STNCPSFLAG    VARCHAR2(1);
	v_UNIT          NUMBER(10,0);
	v_IRefNo        VARCHAR2(90);

	SLIP_STATUS_OPEN VARCHAR2(1) := 'A';
	SLIPTX_STATUS_NORMAL VARCHAR2(1) := 'N';
	SLIPTX_TYPE_CREDIT VARCHAR2(1) := 'C';
	SLIPTX_TYPE_PAYMENT_C VARCHAR2(1) := 'S';
	SLIPTX_TYPE_PAYMENT_A VARCHAR2(1) := 'P';
	SLIPTX_TYPE_REFUND VARCHAR2(1) := 'R';
	SLIPTX_TYPE_DEBIT VARCHAR2(1) := 'D';
	TYPE_DOCTOR VARCHAR2(1) := 'D';
	TYPE_HOSPITAL VARCHAR2(1) := 'H';
	TYPE_SPECIAL VARCHAR2(1) := 'S';
	TXN_PAYMENT_ITMCODE VARCHAR2(5) := 'PAYME';

	-- DEBUG start
	o_errcode	NUMBER;
	v_syslog_remark	syslog.remark%TYPE;
	O_ERRMSG VARCHAR2(100);

	a_PackageCode2 VARCHAR2(100);
	a_AccomodationCode2 VARCHAR2(100);
	a_AccomodationCode3 VARCHAR2(100);
	-- DEBUG end
BEGIN
	-- amc
	IF a_PackageCode IS NOT NULL AND a_PackageCode <> '?' THEN
		BEGIN
			a_PackageCode2 := TRIM(a_PackageCode);
		EXCEPTION
		WHEN OTHERS THEN
			a_PackageCode2 := null;
		END;
	ELSE
		a_PackageCode2 := null;
	END IF;

	IF a_AccomodationCode IS NOT NULL AND a_AccomodationCode <> '?' THEN
		BEGIN
			a_AccomodationCode2 := TRIM(a_AccomodationCode);
		EXCEPTION
		WHEN OTHERS THEN
			a_AccomodationCode2 := null;
		END;
	ELSE
		a_AccomodationCode2 := null;
	END IF;
	-- amc

	-- get slip type first [ck.20121204]
	SELECT slpType, RegOPCat, SlpSts INTO v_tmpSlpType, v_RegOPCat, v_SlpSts FROM Slip WHERE Slpno = a_SlipNo;
	IF v_SlpSts != SLIP_STATUS_OPEN THEN
		return -1;
	END IF;

	-- Automate Slip Category
	IF a_PackageCode2 IS NOT NULL THEN
		v_Count := NHS_UTL_AUTOSLIPCAT(a_SlipNo, a_PackageCode2);
	ELSIF a_ItemCode IS NOT NULL THEN
		v_Count := NHS_UTL_AUTOSLIPCAT(a_SlipNo, a_ItemCode);
	END IF;

	-- update bedcode only for inpatient. [ck.20121204]
	IF v_tmpSlpType = 'I' and a_BedCode IS NULL THEN
		SELECT i.bedcode INTO v_BedCode
		FROM   Slip s, Reg r, Inpat i
		WHERE  s.slpno = a_SlipNo
		AND    r.regid = s.regid
		AND    r.inpid = i.inpid;
	ELSE
		v_BedCode := a_BedCode;
	END IF;

	IF a_GlcCode IS NULL THEN
		--SELECT slpType INTO v_tmpSlpType FROM Slip WHERE Slpno = a_SlipNo;
		IF a_Cpsid IS NULL THEN
			SELECT COUNT(1) INTO v_Count FROM slip s, arcode a WHERE s.arccode = a.arccode AND s.slpno = a_SlipNo;
			IF v_Count = 1 THEN
				SELECT a.cpsid INTO v_lCpsid FROM slip s, arcode a WHERE s.arccode = a.arccode AND s.slpno = a_SlipNo;
			ELSE
				v_lCpsid := NULL;
			END IF;
		ELSE
			v_lCpsid := a_Cpsid;
		END IF;

		-- special handle for urgent care
		IF v_tmpSlpType = 'O' THEN
			a_AccomodationCode3 := 'ZZ' || v_RegOPCat;
			v_GlcCode := NHS_UTL_LookupGlCode(TO_CHAR(a_TransactionDate, 'DD/MM/YYYY'), a_ItemCode, v_BedCode, v_tmpSlpType, CASE WHEN a_EntryType = SLIPTX_TYPE_CREDIT THEN TRUE ELSE FALSE END, v_lCpsid, a_PackageCode2, a_AccomodationCode3, a_vDeptCode);
			IF v_GlcCode IS NULL THEN
				v_GlcCode := NHS_UTL_LookupGlCode(TO_CHAR(a_TransactionDate, 'DD/MM/YYYY'), a_ItemCode, v_BedCode, v_tmpSlpType, CASE WHEN a_EntryType = SLIPTX_TYPE_CREDIT THEN TRUE ELSE FALSE END, v_lCpsid, a_PackageCode2, a_AccomodationCode2, a_vDeptCode);
			END IF;
		ELSE
			v_GlcCode := NHS_UTL_LookupGlCode(TO_CHAR(a_TransactionDate, 'DD/MM/YYYY'), a_ItemCode, v_BedCode, v_tmpSlpType, CASE WHEN a_EntryType = SLIPTX_TYPE_CREDIT THEN TRUE ELSE FALSE END, v_lCpsid, a_PackageCode2, a_AccomodationCode2, a_vDeptCode);
		END IF;
	ELSE
		v_GlcCode := a_GlcCode;
	END IF;
	-- End of handling a_GlcCode

	IF a_Status IS NULL THEN
		v_StnSts := SLIPTX_STATUS_NORMAL;
	ELSE
		v_StnSts := a_Status;
	END IF;

	IF a_PackageCode2 IS NOT NULL THEN
		v_PkgCode := a_PackageCode2;
	END IF;

	IF a_unit IS NULL THEN
		v_unit := 0;
	ELSE
		v_unit := a_unit;
	END IF;

	v_StnDisc := 0;
	IF a_EntryType = SLIPTX_TYPE_PAYMENT_C OR a_EntryType = SLIPTX_TYPE_PAYMENT_A OR a_EntryType = SLIPTX_TYPE_REFUND THEN
		 v_StnDisc := 0;
		 v_StnNAmt := a_StnBAmt;
	ELSE
		IF a_Discount IS NULL THEN
			SELECT ItmType INTO v_Discount_type FROM Item WHERE ItmCode = a_ItemCode;
			IF v_Discount_type = TYPE_DOCTOR THEN
				SELECT SlpDDisc INTO v_StnDisc FROM Slip WHERE SlpNo = a_SlipNo;
			ELSIF v_Discount_type = TYPE_HOSPITAL THEN
				SELECT SlpHDisc INTO v_StnDisc FROM Slip WHERE SlpNo = a_SlipNo;
			ELSIF v_Discount_type = TYPE_SPECIAL THEN
				SELECT SlpSDisc INTO v_StnDisc FROM Slip WHERE SlpNo = a_SlipNo;
			END IF;
		ELSE
			v_StnDisc := a_Discount;
		END IF;
		v_StnDisc := Round(v_StnDisc, 2);
		IF v_unit > 0 THEN
			IF v_StnDisc > 0 THEN
				v_StnNAmt := Round((a_StnBAmt / v_unit) * (1 - (v_StnDisc / 100) )) * v_unit;
			ELSE
				v_StnNAmt := a_StnBAmt;
			END IF;
		ELSE
			v_StnNAmt := Round(a_StnBAmt * (1 - (v_StnDisc / 100) ));
		END IF;
	END IF;

	v_DocCode := a_DoctorCode;
	IF a_AccomodationCode2 IS NOT NULL AND LENGTH(TRIM(a_AccomodationCode2)) > 0 THEN
		v_AcmCode := a_AccomodationCode2;
	END IF;

	IF a_TransactionDate IS NOT NULL THEN
		v_StnTDate := TRUNC(a_TransactionDate);
	ELSE
		v_StnTDate := TRUNC(SYSDATE);
	END IF;

	IF a_EntryType = SLIPTX_TYPE_CREDIT THEN
		IF a_PackageCode2 IS NULL THEN
			SELECT COUNT(1) INTO v_Count FROM Item WHERE ItmCode = a_ItemCode;
			IF v_Count = 1 THEN
				SELECT ItmType, ItmRlvl INTO v_ItmType, v_itmlvl FROM Item WHERE ItmCode = a_ItemCode;
			END IF;
		ELSE
			SELECT COUNT(1) INTO v_Count FROM CreditPkg WHERE PKGCODE = a_PackageCode2;
			IF v_Count = 1 THEN
				SELECT PKGRLVL INTO v_itmlvl FROM CreditPkg WHERE PKGCODE = a_PackageCode2;
			END IF;
			SELECT COUNT(1) INTO v_Count FROM Item WHERE ItmCode = a_ItemCode;
			IF v_Count = 1 THEN
				SELECT ItmType INTO v_ItmType FROM Item WHERE ItmCode = a_ItemCode;
			END IF;
			IF v_itmlvl IS NULL OR LENGTH(TRIM(v_itmlvl)) = 0 THEN
				SELECT COUNT(1) INTO v_Count FROM Item WHERE ItmCode = a_ItemCode;
				IF v_Count = 1 THEN
					SELECT ItmType, ItmRlvl INTO v_ItmType, v_itmlvl FROM Item WHERE ItmCode = a_ItemCode;
				END IF;
			END IF;
		END IF;
	ELSE
		IF a_PackageCode2 IS NULL THEN
			SELECT COUNT(1) INTO v_Count FROM Item WHERE ItmCode = a_ItemCode;
			IF v_Count = 1 THEN
				SELECT /*+ INDEX(IDX_ITEM_1) */ ItmType, ItmRlvl INTO v_ItmType, v_itmlvl FROM Item WHERE ItmCode = a_ItemCode;
			END IF;
		ELSE
			SELECT COUNT(1) INTO v_Count FROM Package WHERE PKGCODE = a_PackageCode2;
			IF v_Count = 1 THEN
				SELECT PKGRLVL INTO v_itmlvl FROM Package WHERE PKGCODE = a_PackageCode2;
			END IF;
			SELECT COUNT(1) INTO v_Count FROM Item WHERE ItmCode = a_ItemCode;
			IF v_Count = 1 THEN
				SELECT /*+ INDEX(IDX_ITEM_1) */ ItmType INTO v_ItmType FROM Item WHERE ItmCode = a_ItemCode;
			END IF;
			IF v_itmlvl IS NULL OR LENGTH(TRIM(v_itmlvl)) = 0 THEN
				SELECT COUNT(1) INTO v_Count FROM Item WHERE ItmCode = a_ItemCode;
				IF v_Count = 1 THEN
					SELECT /*+ INDEX(IDX_ITEM_1) */ ItmType, ItmRlvl INTO v_ItmType, v_itmlvl FROM Item WHERE ItmCode = a_ItemCode;
				END IF;
			END IF;
		END IF;
	END IF;
	v_StnRlvl := v_itmlvl;

	IF a_ItemCode <> TXN_PAYMENT_ITMCODE THEN
		SELECT dsccode, dptcode INTO v_DscCode, v_DeptCode FROM item WHERE itmcode = a_ItemCode;
	ELSE
		v_StnRlvl := a_ReportLevel;
	END IF;

	IF a_ReferenceID IS NOT NULL THEN
		v_StnXRef := a_ReferenceID;
	END IF;

	IF a_Description IS NOT NULL AND LENGTH(TRIM(a_Description)) > 0 THEN
		IF (length(a_Description) > 80) THEN
			return -997;
		END IF;
		v_StnDesc := a_Description;
	END IF;

	IF a_Stndesc1 IS NOT NULL AND a_Stndesc1 <> '?' THEN
		BEGIN
			v_StnDesc1 := TRIM(a_Stndesc1);
		EXCEPTION
		WHEN OTHERS THEN
			v_StnDesc1 := NULL;
		END;
	ELSE
		v_StnDesc1 := NULL;
	END IF;

	IF a_flagToDi = TRUE THEN
		SELECT param1 INTO v_DiDeptCode FROM sysparam WHERE parcde = 'DIDeptID';
		IF v_DeptCode IS NOT NULL AND LENGTH(TRIM(v_DeptCode)) > 0 AND
			 InStr(v_DiDeptCode, v_DeptCode) > 0 THEN
					v_STNDIFLAG := -1;
		END IF;
	END IF;

	IF a_ConPceSetFlag IS NOT NULL AND a_ConPceSetFlag <> '?' THEN
		BEGIN
			v_STNCPSFLAG := TRIM(a_ConPceSetFlag);
		EXCEPTION
		WHEN OTHERS THEN
			v_STNCPSFLAG := NULL;
		END;
	ELSE
		v_STNCPSFLAG := NULL;
	END IF;

	IF a_EntryType = SLIPTX_TYPE_DEBIT THEN
		SELECT COUNT(1) INTO v_Count
		FROM SLIP S, ITEM I, CMCITM CD, CMCFORM CF
		WHERE	S.SLPNO = a_SlipNo AND
				S.SLPTYPE = CD.ITCTYPE AND
				S.PCYID = CD.PCYID AND
				I.ITMCODE = a_ItemCode AND
				CD.ITMCODE = I.ITMCODE AND
				CD.EFF_DT_FRM <= v_StnTDate AND
				CD.EFF_DT_TO >= v_StnTDate AND
				CD.APPCONTR = CF.CID;

		IF v_Count = 1 THEN
			SELECT CD.PCYID INTO v_PCYID
			FROM SLIP S, ITEM I, CMCITM CD, CMCFORM CF
			WHERE	S.SLPNO = a_SlipNo AND
					S.SLPTYPE = CD.ITCTYPE AND
					S.PCYID = CD.PCYID AND
					I.ITMCODE = a_ItemCode AND
					CD.ITMCODE = I.ITMCODE AND
					CD.EFF_DT_FRM <= v_StnTDate AND
					CD.EFF_DT_TO >= v_StnTDate AND
					CD.APPCONTR = CF.CID;
		ELSE
			v_PCYID := NULL;
		END IF;

		IF v_PCYID IS NULL OR v_PCYID = 0 THEN
			SELECT COUNT(1) INTO v_Count
			FROM SLIP S,ITEM I, DPSERV DS, CMCDPS CD, CMCFORM CF
			WHERE	S.SLPNO = a_SlipNo AND
					S.SLPTYPE = CD.ITCTYPE AND
					S.PCYID = CD.PCYID AND
					I.ITMCODE = a_ItemCode AND
					DS.DSCCODE = I.DSCCODE AND
					CD.DSCCODE = DS.DSCCODE AND
					CD.EFF_DT_FRM <= v_StnTDate AND
					CD.EFF_DT_TO >= v_StnTDate AND
					CD.APPCONTR = CF.CID;

			IF v_Count = 1 THEN
				SELECT CD.PCYID INTO v_PCYID
				FROM SLIP S,ITEM I, DPSERV DS, CMCDPS CD, CMCFORM CF
				WHERE	S.SLPNO = a_SlipNo AND
						S.SLPTYPE = CD.ITCTYPE AND
						S.PCYID = CD.PCYID AND
						I.ITMCODE = a_ItemCode AND
						DS.DSCCODE = I.DSCCODE AND
						CD.DSCCODE = DS.DSCCODE AND
						CD.EFF_DT_FRM <= v_StnTDate AND
						CD.EFF_DT_TO >= v_StnTDate AND
						CD.APPCONTR = CF.CID;
			ELSE
				v_PCYID := NULL;
			END IF;
		END IF;
	END IF;

	BEGIN
		SELECT Param1 INTO v_transver FROM sysparam WHERE parcde = 'MulLangVer';
	EXCEPTION
	WHEN NO_DATA_FOUND THEN
		v_transver := NULL;
	END;

	IF a_IRefNo IS NOT NULL AND a_IRefNo <> '?' THEN
		BEGIN
			v_IRefNo := TRIM(a_IRefNo);
		EXCEPTION
		WHEN OTHERS THEN
			v_IRefNo := NULL;
		END;
	ELSE
		v_IRefNo := NULL;
	END IF;

	v_stnseq := NHS_UTL_IncrementSlipSeq(a_SlipNo);
	IF v_stnseq < 0 THEN
		RETURN v_stnseq;
	END IF;

	SELECT SEQ_SLIPTX.NEXTVAL INTO v_StnID from dual;

	IF a_dixref IS NULL THEN
		v_DIXREF := v_StnID;
	ELSE
		v_DIXREF := a_dixref;
	END IF;

/*
	-- DEBUG start
	begin
		v_syslog_remark := 'STNID=' || v_StnID || ',SLPNO=' || a_SlipNo || ',STNSEQ=' || v_StnSeq ||
			',STNSTS=' || v_StnSts || ',ITMCODE=' || a_ItemCode || ',STNOAMT=' || a_StnOAmt ||
			',STNBAMT=' || a_StnBAmt || ',STNNAMT=' || v_StnNAmt || ',DOCCODE=' || v_DocCode ||
			',GLCCODE=' || v_GlcCode || ',USRID=' || a_userid || ',STNTDATE=' || v_StnTDate ||
			',STNRLVL=' || v_StnRlvl || ',STNTYPE=' || -1 ||
			',a_GlcCode=' || a_GlcCode || ', a_Cpsid=' || a_Cpsid ||
			',a_ItemCode=' || a_ItemCode || ',v_BedCode=' || v_BedCode || ',v_tmpSlpType=' || v_tmpSlpType ||
			',a_EntryType=' || a_EntryType || ',v_lCpsid=' || v_lCpsid || ',a_PackageCode=' || a_PackageCode || ',a_PackageCode2=' || a_PackageCode2 ||
			',a_AccomodationCode=' || a_AccomodationCode || ',a_AccomodationCode2=' || a_AccomodationCode2 || ', a_vDeptCode=' || a_vDeptCode;

		o_errcode := NHS_ACT_SYSLOG('ADD', 'Transction', 'Add Charge', v_syslog_remark, a_userid, NULL, o_errmsg);
		commit;
	end;
	-- DEBUG end
*/

	IF a_capturedate IS NOT NULL THEN
		v_capturedate := SYSDATE;
	ELSE
		v_capturedate := NULL;
	END IF;

	INSERT INTO SLIPTX (
		STNID, SLPNO, STNSEQ, STNSTS, PKGCODE, ITMCODE, ITMTYPE, STNDISC, STNOAMT, STNBAMT,
		STNNAMT, DOCCODE, ACMCODE, GLCCODE, USRID, STNTDATE, STNCDATE, STNADOC, STNDESC, STNRLVL,
		STNTYPE, STNXREF, DSCCODE, DIXREF, STNDIDOC, STNDIFLAG, STNCPSFLAG, PCYID, STNASCM, UNIT,
		PCYID_O, TRANSVER, STNDESC1, CARDRATE, PAYMETHOD, IREFNO
	) VALUES (
		v_StnID, a_SlipNo, v_StnSeq, v_StnSts, v_PkgCode, a_ItemCode, v_ItmType, v_StnDisc, a_StnOAmt, a_StnBAmt,
		v_StnNAmt, v_DocCode, v_AcmCode, v_GlcCode, a_userid, v_StnTDate, v_capturedate, NULL, v_StnDesc, v_StnRlvl,
		a_EntryType, v_StnXRef, v_DscCode, v_DIXREF, NULL, v_STNDIFLAG, v_STNCPSFLAG, v_PCYID, NULL, v_unit,
		-1, v_transver, v_StnDesc1, NULL, NULL, v_IRefNo
	);

	-- sliptx extra
	INSERT INTO SLIPTX_EXTRA(STNID, SLPNO, STNSEQ) VALUES (v_StnID, a_SlipNo, v_StnSeq);

	NHS_UTL_UPDATESLIP( a_SlipNo ) ;

	RETURN v_StnID;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -999;
END NHS_UTL_ADDENTRY;
/
