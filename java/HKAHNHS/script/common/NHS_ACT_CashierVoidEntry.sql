CREATE OR REPLACE FUNCTION "NHS_ACT_CASHIERVOIDENTRY" (
	i_action               IN VARCHAR2,
	i_CashierTransactionID IN VARCHAR2,
	i_CashierCode          IN VARCHAR2,
	i_UserID               IN VARCHAR2,
	o_errmsg               OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER := -1;
	v_SliptxAmt CashTx.CtxAmt%TYPE;
	v_CtxMethod CashTx.CtxMeth%TYPE;
	v_CtxSts CashTx.CtxSts%TYPE;
	v_CshCode CashTx.CshCode%TYPE;
	v_CtxCDate CashTx.CtxCDate%TYPE;
	v_ReceiptNo CashTx.CtxSno%TYPE;
	v_CtnID CashTx.CtnID%TYPE;
	v_TraceNo CardTx.CtnTrace%TYPE;
	v_CardError BOOLEAN := FALSE;
	v_Count NUMBER;
	v_TxType VARCHAR2(1);

	CASHTX_STS_NORMAL VARCHAR2(1) := 'N';
	CASHTX_PAYTYPE_CHEQUE VARCHAR2(1) := 'Q';
	CASHTX_PAYTYPE_OCTOPUS VARCHAR2(1) := 'T';
	CASHTX_PAYTYPE_CUP VARCHAR2(1) := 'U';
	CASHTX_PAYTYPE_QR VARCHAR2(1) := 'R';
	S9090_TXN_OCT_VOID VARCHAR2(1) := '3';
	S9090_TXN_CUP_VOID VARCHAR2(1) := 'd';
	S9090_TXN_QR_VOID VARCHAR2(1) := 'B';
	S9000_TXN_VOID VARCHAR2(1) := '3';

	MSG_CASHIER_CLOSE_NOENTRY VARCHAR2(17) := 'No cashier entry.';
	MSG_VOID_FAILED VARCHAR2(27) := 'Can''t void the transaction.';
BEGIN
	o_errmsg := MSG_VOID_FAILED;

	SELECT COUNT(1) INTO v_Count FROM CashTx WHERE CtxID = i_CashierTransactionID;
	IF v_Count = 0 THEN
		RETURN o_errcode;
	END IF;

	-- Initial the transaction information
	SELECT CtxAmt, CtxMeth, CtxSts, CshCode, CtxCDate, CtxSno, CtnID
	INTO v_SliptxAmt, v_CtxMethod, v_CtxSts, v_CshCode, v_CtxCDate, v_ReceiptNo, v_CtnID
	FROM CashTx WHERE CtxID = i_CashierTransactionID;

	-- Check for the cashier that create the transaction
	-- AND the status of the transaction
	IF v_CtxSts != CASHTX_STS_NORMAL THEN
		RETURN o_errcode;
	END IF;

	IF i_CashierCode IS Null OR v_CshCode != i_CashierCode THEN
		IF v_CtxMethod = CASHTX_PAYTYPE_CHEQUE AND i_CashierCode IS NOT NULL THEN
			If V_Ctxcdate Is Null Then
				o_errmsg := MSG_CASHIER_CLOSE_NOENTRY;
				RETURN o_errcode;
			END IF;
		ELSE
			o_errmsg := MSG_CASHIER_CLOSE_NOENTRY || ' Not the same cashier.';
			RETURN o_errcode;
		END IF;
	END IF;

	-- allow cheque to be reverse even the cashier has been signed off
	v_Count := NHS_ACT_ISCASHIERCLOSED(i_action, i_CashierTransactionID, i_UserID, o_errmsg);
	IF v_Count >= 0 THEN
		o_errmsg := MSG_VOID_FAILED || 'This transaction is not made by the current cashier session.';
		RETURN o_errcode;
	ELSE
		IF v_CtnID IS NOT NULL THEN
			SELECT CtnTrace INTO v_TraceNo FROM CardTx WHERE CtnID = v_CtnID;

			IF v_CtxMethod = CASHTX_PAYTYPE_OCTOPUS THEN
				v_TxType := S9090_TXN_OCT_VOID;
			ELSIF v_CtxMethod = CASHTX_PAYTYPE_CUP THEN
				v_TxType := S9090_TXN_CUP_VOID;
			ELSIF v_CtxMethod = CASHTX_PAYTYPE_QR THEN
				v_TxType := S9090_TXN_QR_VOID;
			ELSE
				v_TxType := S9000_TXN_VOID;
			END IF;
			v_CtnID := NHS_UTL_PRETRANSACTION(i_CashierCode, v_TxType, NULL, 0, NULL);
		ELSE
			v_CtnID := NULL;
		END IF;
	END IF;

	IF v_CtnID IS NOT NULL THEN
		RETURN v_CtnID;
	ELSE
		o_errcode := 0;
		RETURN o_errcode;
	END IF;

	-- should go to NHS_ACT_CASHIERVOIDENTRYPOST on upper level
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_ACT_CASHIERVOIDENTRY;
/
