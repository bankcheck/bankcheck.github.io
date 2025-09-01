CREATE OR REPLACE FUNCTION "NHS_ACT_CASHIERVALIDVOID" (
	i_action      IN VARCHAR2,
	i_ctxid       IN VARCHAR2,
	i_cashierCode IN VARCHAR2,
	i_payCode     IN VARCHAR2,
	o_errmsg      OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER := -1;
	v_CshCode CashTx.CshCode%TYPE;
	v_PayDesc PayCode.PayDesc%TYPE;
	v_PayDesc_CHEQUE PayCode.PayDesc%TYPE;
	v_PayDesc_EPS PayCode.PayDesc%TYPE;
	v_CtxCat CashTx.CtxCat%TYPE;
	v_CtxSNo CashTx.CtxSNo%TYPE;
	v_CtxSts CashTx.CtxSts%TYPE;
	v_ArpaAmt ArpTx.ArpaAmt%TYPE;
	v_Count NUMBER := 0;

	CASHTX_PATIENT_RELATED VARCHAR2(1) := 'P';
	CASHTX_STS_NORMAL VARCHAR2(1) := 'N';
	MSG_DIFFERENT_CASHIER VARCHAR2(47) := 'Can''t void transaction made by another cashier.';
	MSG_PATIENT_TRANSACTION VARCHAR2(43) := 'Can''t void the patient related transaction.';
	MSG_CANCELLED_CASHTX VARCHAR2(46) := 'The selected transaction is already cancelled.';
	MSG_NOT_EPS VARCHAR2(22) := 'EPS can not be voided.';
BEGIN
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO v_Count
	FROM   CashTx C, PayCode P
	WHERE  C.CtxMeth = P.PayType
	AND    C.CshCode >= CHR(0)
	AND    C.CtxId = i_ctxid
	AND    P.PayCode = i_payCode;

	IF v_Count = 1 THEN
		SELECT C.CtxSNo, C.CshCode, P.PayDesc, C.CtxCat, C.CtxSts
		INTO   v_CtxSNo, v_CshCode, v_PayDesc, v_CtxCat, v_CtxSts
		FROM   CashTx C, PayCode P
		WHERE  C.CtxMeth = P.PayType
		AND    C.CshCode >= CHR(0)
		AND    C.CtxId = i_ctxid
		AND    P.PayCode = i_payCode;
	ELSE
		RETURN -1;
	END IF;

	-- get cheque description
	SELECT COUNT(1) INTO v_Count FROM PayCode WHERE PayCode = '03';
	IF v_Count = 1 THEN
		SELECT PayDesc INTO v_PayDesc_CHEQUE FROM PayCode WHERE PayCode = '03';
	END IF;

	-- get EPS description
	SELECT COUNT(1) INTO v_Count FROM PayCode WHERE PayCode = '04';
	IF v_Count = 1 THEN
		SELECT PayDesc INTO v_PayDesc_EPS FROM PayCode WHERE PayCode = '04';
	END IF;

	-- get allocated amount
	SELECT COUNT(1) INTO v_Count FROM ArpTx WHERE arprecno = v_CtxSNo;
	IF v_Count = 1 THEN
		SELECT ArpaAmt INTO v_ArpaAmt FROM ArpTx WHERE arprecno = v_CtxSNo;
	END IF;

	IF i_cashierCode != v_CshCode AND v_PayDesc != v_PayDesc_CHEQUE THEN
		o_errmsg := MSG_DIFFERENT_CASHIER;
	ELSIF v_CtxCat = CASHTX_PATIENT_RELATED THEN
		o_errmsg := MSG_PATIENT_TRANSACTION;
	ELSIF v_CtxSts != CASHTX_STS_NORMAL THEN
		o_errmsg := MSG_CANCELLED_CASHTX;
	ELSIF v_CTXSNO IS NOT NULL AND v_ArpaAmt != 0 THEN
		o_errmsg := 'Allocated Amount!';
	ELSIF v_Paydesc = v_PayDesc_EPS THEN
		o_errmsg := MSG_NOT_EPS;
	ELSE
		o_errcode := 0;
	END IF;

	RETURN o_errcode;
END NHS_ACT_CASHIERVALIDVOID;
/
