CREATE OR REPLACE FUNCTION "NHS_ACT_VOIDCASHIERTRANSACTION" (
i_action		       IN VARCHAR2,
i_CashierTransactionID IN VARCHAR2,
i_CardTransactionID    IN VARCHAR2,
i_StnType              IN VARCHAR2,
i_UserID               IN VARCHAR2,
o_errmsg	     	   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errCode NUMBER;
	v_noOfRec NUMBER;
	v_CtxID NUMBER;
	v_Cshsid NUMBER;
	v_marid NUMBER;
	v_CshCode VARCHAR2(3);
	rs_cashtx CashTx%ROWTYPE;
	rs_misaddref misaddref%ROWTYPE;

	CASHTX_STS_VOID VARCHAR2(1) := 'V';
	CASHTX_STS_REVERSE VARCHAR2(1) := 'R';
	CARDTX_STS_MANUAL VARCHAR2(1) := 'M';
	CASHIER_COUNT_VOID VARCHAR2(1) := '3';
BEGIN
	IF i_CashierTransactionID IS NULL THEN
        o_errmsg := 'Cashier TransactionID is empty.';
		RETURN o_errcode;
	END IF;

	SELECT COUNT(1) INTO v_noOfRec FROM CashTx WHERE CtxID = TO_NUMBER(i_CashierTransactionID);
	IF v_noOfRec = 0 THEN
		o_errmsg := 'no record found.';
		RETURN o_errcode;
	END IF;

	SELECT * INTO rs_cashtx FROM CashTx WHERE CtxID = TO_NUMBER(i_CashierTransactionID);
	IF rs_cashtx.CtxSts = CASHTX_STS_VOID THEN
		o_errmsg := 'Cash Transaction is already cancelled.';
		RETURN o_errcode;
	END IF;

	-- Update old cashier transaction record to void
	UPDATE CashTx SET CtxSts = CASHTX_STS_VOID, CtxVDate = SYSDATE WHERE CtxID = TO_NUMBER(i_CashierTransactionID);

	-- INSERT new reverse cashier transaction record
	SELECT SEQ_Cashtx.NEXTVAL INTO v_CtxID FROM DUAL;

	SELECT CshSid, CshCode INTO v_Cshsid, v_CshCode FROM Cashier WHERE usrID = i_UserID;

	INSERT INTO CashTx(
		CtxID ,
		CshCode,
		CtxSNO,
		CtxType,
		CtxMeth,
		CtxAmt,
		CtxName,
		CtxDesc,
		CtxCDate,
		CtxTDate,
		CshSid,
		CtxSts,
		CtnID,
		CtxCat,
		SlpNo,
		SteCode
	) VALUES (
		v_CtxID,
		v_CshCode,
		rs_cashtx.CtxSno,
		rs_cashtx.CtxType,
		rs_cashtx.CtxMeth,
		-rs_cashtx.CtxAmt,
		rs_cashtx.CtxName,
		rs_cashtx.CtxDesc,
		NULL,
		TRIM(SYSDATE),
		v_Cshsid,
		CASHTX_STS_REVERSE,
		TO_NUMBER(i_CardTransactionID),
		rs_cashtx.CtxCat,
		rs_cashtx.SlpNo,
		rs_cashtx.SteCode
	);

	o_errCode := NHS_UTL_UPDATEBALANCE(v_CshCode, rs_cashtx.Ctxtype, rs_cashtx.CtxMeth, TO_CHAR(-rs_cashtx.Ctxamt), CASHIER_COUNT_VOID);
	IF o_errCode = -1 THEN
		ROLLBACK;
		RETURN o_errCode;
	END IF;

	IF i_CardTransactionID IS NOT NULL AND TRIM(i_CardTransactionID) != '' THEN
		-- UpdateVoidCardTransaction
		UPDATE CardTx SET CtnSts = CARDTX_STS_MANUAL WHERE CtnID = i_CardTransactionID;
	END IF;

	IF rs_cashtx.CtxMeth = 'Q' and i_StnType = 'R' THEN
		SELECT * INTO rs_misaddref FROM misaddref WHERE tabid = TO_NUMBER(i_CashierTransactionID);

		SELECT SEQ_misaddref.NEXTVAL INTO v_marid FROM dual;

		INSERT INTO misaddref(
			MARID,
			TABNAME,
			TABID,
			MARPAYEE,
			MARADD1,
			MARADD2,
			MARADD3,
			MARREASON,
			COUNTRY
		) VALUES (
			v_marid,
			rs_misaddref.tabname,
			v_CtxID,
			rs_misaddref.marpayee,
			rs_misaddref.maradd1,
			rs_misaddref.maradd2,
			rs_misaddref.maradd3,
			rs_misaddref.marreason,
			rs_misaddref.country
		);
	END IF;

	RETURN v_CtxID;
END NHS_ACT_VOIDCASHIERTRANSACTION;
/
