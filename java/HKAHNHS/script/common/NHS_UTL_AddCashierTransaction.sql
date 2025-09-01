-- Cashier.bas / AddCashierTransaction
CREATE OR REPLACE FUNCTION "NHS_UTL_ADDCASHIERTRANSACTION" (
	i_CashierCode       IN VARCHAR2,
	i_TransactionID     IN VARCHAR2,
	i_TransactionType   IN VARCHAR2,
	i_PayerOrReceiptant IN VARCHAR2,
	i_PaymentType       IN VARCHAR2,
	i_Amount            IN NUMBER,
	i_Description       IN VARCHAR2,
	i_CtnID             IN VARCHAR2,
	i_TransactionDate   IN DATE,
	i_CaptureDate       IN DATE,
	i_PatientTxn        IN VARCHAR2,
	i_ReceiptNumber     IN VARCHAR2,
	i_SlipNumber        IN VARCHAR2
)
	RETURN VARCHAR2
AS
	v_SiteCode VARCHAR2(10);
	v_CshSID NUMBER;
	v_UpdateBalance NUMBER;
	v_CtxName CashTx.CtxName%TYPE;
	CASHTX_STS_NORMAL VARCHAR2(1) := 'N';
	CASHTX_TXNTYPE_RECEIVE VARCHAR2(1) := 'R';
	CASHIER_COUNT_RECEIPT VARCHAR2(1) := '1';
BEGIN
	-- get site code
	v_SiteCode := GET_CURRENT_STECODE;

	IF LENGTH(i_PayerOrReceiptant) > 80 THEN
		v_CtxName := SUBSTR(i_PayerOrReceiptant, 1, 80);
	ELSE
		v_CtxName := i_PayerOrReceiptant;
	END IF;

	SELECT CshSID INTO v_CshSID FROM Cashier WHERE CshCode = i_CashierCode;

	INSERT INTO CashTx (CtxID, CshCode, CtxType, CtxMeth, CtxAmt, CtxName, CtxDesc, CtxCDate, CtxTDate, CshSID, CtxSts, CtnID, CtxCat, SteCode, SlpNo)
	VALUES (i_TransactionID, i_CashierCode, SUBSTR(i_TransactionType, 1, 1), i_PaymentType, i_Amount, v_CtxName, i_Description, NULL, TRIM(i_TransactionDate), v_CshSID, CASHTX_STS_NORMAL, i_CtnID, i_PatientTxn, v_SiteCode, i_SlipNumber);

	-- Receive Payment
	IF i_TransactionType = CASHTX_TXNTYPE_RECEIVE THEN
		UPDATE CashTx
		SET    CtxSNo = i_ReceiptNumber
		WHERE  CtxID  = i_TransactionID;
	END IF;

	-- Receipt Issued
	v_UpdateBalance := NHS_UTL_UPDATEBALANCE(i_CashierCode, i_TransactionType, i_PaymentType, i_Amount, CASHIER_COUNT_RECEIPT);

	RETURN i_TransactionID;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN NULL;
END NHS_UTL_ADDCASHIERTRANSACTION;
/
