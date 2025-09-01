CREATE OR REPLACE FUNCTION "NHS_UTL_ADJUSTENTRY" (
	a_SlipNo          IN VARCHAR2,
	a_TransactionID   IN NUMBER,
	a_Amount          IN NUMBER,
	a_Description     IN VARCHAR2,
	a_TransactionDate IN DATE,
	a_capturedate     IN DATE,
	a_UserID          IN VARCHAR2,
	o_errmsg          OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_stnid NUMBER(22,0);
	rs_SlipTx SlipTx%ROWTYPE;
	v_dummy_date DATE;
	v_dummy_number NUMBER;
	v_SLIPTX_STATUS_ADJUST VARCHAR2(1) := 'A';
BEGIN
	SELECT * INTO rs_SlipTx FROM sliptx WHERE stnid = a_TransactionID;
	SELECT SEQ_SLIPTX.nextval INTO v_stnid FROM dual;

	rs_SlipTx.StnDIDoc := v_dummy_date;
	rs_SlipTx.StnDIFlag := v_dummy_number;
	rs_SlipTx.StnaSCM := v_dummy_date;
	rs_SlipTx.StnADoc := v_dummy_date;
	rs_SlipTx.stnid := v_stnid;
	rs_SlipTx.stndesc := TO_CHAR(rs_SlipTx.stnseq) || ' ' || NVL(a_Description,'');
	rs_SlipTx.stndesc1 := rs_SlipTx.stndesc1;
	rs_SlipTx.stnseq := NHS_UTL_IncrementSlipSeq(a_SlipNo);
	rs_SlipTx.stnoamt := a_Amount;
	rs_SlipTx.stnbamt := a_Amount;
	IF rs_SlipTx.unit > 0 THEN
		IF rs_SlipTx.StnDisc > 0 THEN
			rs_SlipTx.stnnamt := ROUND((rs_SlipTx.StnBAmt / rs_SlipTx.unit) * (1 - (rs_SlipTx.StnDisc / 100))) * rs_SlipTx.unit;
		ELSE
			rs_SlipTx.stnnamt := rs_SlipTx.StnBAmt;
		END IF;
	ELSE
		rs_SlipTx.stnnamt := ROUND(rs_SlipTx.StnBAmt * (1 - (rs_SlipTx.StnDisc / 100)));
	END IF;
	rs_SlipTx.StnTDate := NVL(a_TransactionDate, TRUNC(sysdate));
	rs_SlipTx.StnCDate := NVL(a_capturedate, sysdate);
	rs_SlipTx.stnsts := v_SLIPTX_STATUS_ADJUST;
	rs_SlipTx.UsrID := a_UserID;

	INSERT INTO SLIPTX (
		STNID, SLPNO, STNSEQ, STNSTS, PKGCODE, ITMCODE, ITMTYPE, STNDISC, STNOAMT, STNBAMT,
		STNNAMT, DOCCODE, ACMCODE, GLCCODE, USRID, STNTDATE, STNCDATE, STNADOC, STNDESC, STNRLVL,
		STNTYPE, STNXREF, DSCCODE, DIXREF, STNDIDOC, STNDIFLAG, STNCPSFLAG, PCYID, STNASCM, UNIT,
		PCYID_O, TRANSVER, STNDESC1, CARDRATE, PAYMETHOD, IREFNO
	) VALUES (
		rs_SlipTx.StnID, a_SlipNo, rs_SlipTx.StnSeq, rs_SlipTx.StnSts, rs_SlipTx.PkgCode, rs_SlipTx.ItmCode, rs_SlipTx.ItmType, rs_SlipTx.StnDisc, rs_SlipTx.StnOAmt, rs_SlipTx.StnBAmt,
		rs_SlipTx.StnNAmt, rs_SlipTx.DocCode, rs_SlipTx.AcmCode, rs_SlipTx.GlcCode, rs_SlipTx.UsrID, rs_SlipTx.StnTDate, rs_SlipTx.StnCDate, rs_SlipTx.StnADoc, rs_SlipTx.StnDesc, rs_SlipTx.StnRlvl,
		rs_SlipTx.StnType, rs_SlipTx.StnXRef, rs_SlipTx.DscCode, rs_SlipTx.DIXREF, rs_SlipTx.STNDIDOC, rs_SlipTx.STNDIFLAG, rs_SlipTx.STNCPSFLAG, rs_SlipTx.PCYID, rs_SlipTx.StnaScm, rs_SlipTx.unit,
		rs_SlipTx.PCYID_O, rs_SlipTx.transver, rs_SlipTx.StnDesc1, rs_SlipTx.CARDRATE, rs_SlipTx.PAYMETHOD, rs_SlipTx.IRefNo
	);

	-- sliptx extra
	INSERT INTO SLIPTX_EXTRA(STNID, SLPNO, STNSEQ) VALUES (rs_SlipTx.StnID, a_SlipNo, rs_SlipTx.StnSeq);

	RETURN v_StnID;

EXCEPTION
WHEN OTHERS THEN
	o_errmsg := SQLERRM;
	ROLLBACK;
	RETURN -1;
END NHS_UTL_ADJUSTENTRY;
/
