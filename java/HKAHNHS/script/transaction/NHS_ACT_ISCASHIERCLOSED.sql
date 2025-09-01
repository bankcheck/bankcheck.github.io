CREATE OR REPLACE FUNCTION "NHS_ACT_ISCASHIERCLOSED" (
	i_action               IN VARCHAR2,
	i_CashierTransactionID IN VARCHAR2,
	i_usrid                IN VARCHAR2,
	o_errmsg               OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER := 0;
	v_noOfRec NUMBER;
	v_CurrentSignOnID NUMBER;
	v_TxnSignOnID NUMBER;
BEGIN
	SELECT COUNT(1) INTO v_noOfRec FROM Cashier WHERE UsrID = i_usrid;

	IF v_noOfRec > 0 THEN
		IF NHS_UTL_ISCHEQUETRANSACTION(TO_NUMBER(i_CashierTransactionID)) >= 0 THEN
			o_errcode := -1;
			o_errmsg := 'Within Cheque Transaction Buffer.';
			RETURN o_errcode;
		END IF;

		SELECT CshSID INTO v_CurrentSignOnID FROM Cashier WHERE UsrID = i_usrid;
		SELECT CshSID INTO v_TxnSignOnID FROM CashTx WHERE CtxID = i_CashierTransactionID;

		IF v_CurrentSignOnID > v_TxnSignOnID then
			o_errcode := 1;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Cashier is opened.';
		END IF;
	ELSE
		o_errcode := -1;
		o_errmsg := 'Not a cashier.';
	END IF;

	RETURN o_errcode;
END NHS_ACT_ISCASHIERCLOSED;
/
