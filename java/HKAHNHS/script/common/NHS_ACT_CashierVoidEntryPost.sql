CREATE OR REPLACE FUNCTION "NHS_ACT_CASHIERVOIDENTRYPOST" (
	i_action               IN VARCHAR2,
	i_CashierTransactionID IN VARCHAR2,
	i_SlipNo               IN VARCHAR2,
	i_SlipSeq              IN VARCHAR2,
	-- Extra info --------------------
	i_CashierCode          IN VARCHAR2,
	i_CtnID                IN VARCHAR2,
	i_CardError            IN VARCHAR2,
	i_CardForceYN          IN VARCHAR2,
	i_UserID               IN VARCHAR2,
	-- Card info ---------------------
	i_TxnType              IN VARCHAR2,
	i_TxnEcrRef            IN VARCHAR2,
	i_TxnAmount            IN VARCHAR2,
	i_TxnRespCode          IN VARCHAR2,
	i_TxnRespText          IN VARCHAR2,
	i_TxnDateTime          IN VARCHAR2,
	i_TxnCardType          IN VARCHAR2,
	i_TxnCardNo            IN VARCHAR2,
	i_TxnExpiryDate        IN VARCHAR2,
	i_TxnCardHolder        IN VARCHAR2,
	i_TxnTerminalNo        IN VARCHAR2,
	i_TxnMerchantNo        IN VARCHAR2,
	i_TxnStoreNo           IN VARCHAR2,
	i_TxnTraceNo           IN VARCHAR2,
	i_TxnBatchNo           IN VARCHAR2,
	i_TxnAppCode           IN VARCHAR2,
	i_TxnRefNo             IN VARCHAR2,
	i_TxnRRNo              IN VARCHAR2,
	i_TxnVDate             IN VARCHAR2,
	i_TxnDAccount          IN VARCHAR2,
	i_TxnAResp             IN VARCHAR2,
	-- Output ------------------------
	o_errmsg               OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER := 0;
	v_ReceiptNo CashTx.CtxSno%TYPE;
	v_ArpID ArpTx.ArpID%TYPE;
	v_CtxID NUMBER;
	v_Count NUMBER;

	CARDTX_STS_NORMAL VARCHAR2(1) := 'N';
	MSG_VOID_FAILED VARCHAR2(27) := 'Can''t void the transaction.';
	MSG_CARD_FORCE_VOID VARCHAR2(88) := 'Failed to void the card machine transaction.<br>Continue to void transaction seperately?';
BEGIN
	o_errmsg := MSG_VOID_FAILED;

	-- Initial the transaction information
	SELECT CtxSno INTO v_ReceiptNo FROM CashTx WHERE CtxID = i_CashierTransactionID;

	-- FindArpID
	SELECT COUNT(1) INTO v_Count FROM ArpTx WHERE ArpSts = 'N' AND ArpRecNo = v_ReceiptNo;
	IF v_Count = 1 THEN
		SELECT ArpID INTO v_ArpID FROM ArpTx WHERE ArpSts = 'N' AND ArpRecNo = v_ReceiptNo;
	ELSE
		v_ArpID := NULL;
	END IF;

	IF i_CardError = 'Y' AND i_CardForceYN = 'N' THEN
		o_errcode := -100;
		o_errmsg := MSG_CARD_FORCE_VOID;
		RETURN o_errcode;
	ELSE
		v_CtxID := NHS_ACT_VOIDCASHIERTRANSACTION(i_action, i_CashierTransactionID, i_CtnID, NULL, i_UserID, o_errmsg);
		IF v_ArpID IS NOT NULL THEN
			o_errcode := NHS_ACT_ARPAYMENTCANCEL(i_action, v_ArpID, o_errmsg);
		END IF;
	END IF;

	IF i_CtnID IS NOT NULL THEN
		-- Update Cardtx IF return abnormal Card machine respone code
		-- UpdateTransaction CtnID
		o_errcode := NHS_ACT_UPDATETRANSACTION(NULL, i_CtnID, i_SlipNo, i_SlipSeq, v_ReceiptNo,
			i_TxnType, i_TxnEcrRef, i_TxnAmount, '000000000000', i_TxnRespCode,
			i_TxnRespText, i_TxnDateTime, i_TxnCardType, i_TxnCardNo, i_TxnExpiryDate, i_TxnCardHolder, i_TxnTerminalNo, i_TxnMerchantNo,
			i_TxnTraceNo, i_TxnBatchNo, i_TxnAppCode, i_TxnRRNo, i_TxnStoreNo, i_TxnVDate, i_TxnDAccount, i_TxnAResp, NULL, NULL, NULL, NULL, NULL, i_TxnRefNo, o_errmsg);

		o_errcode := NHS_ACT_CASHIERVOIDENTRYCLEAR(NULL, i_CtnID, o_errmsg);
	END IF;

	RETURN v_CtxID;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	o_errcode := NHS_ACT_CASHIERVOIDENTRYCLEAR(NULL, i_CtnID, o_errmsg);

	RETURN -1;
END NHS_ACT_CASHIERVOIDENTRYPOST;
/
