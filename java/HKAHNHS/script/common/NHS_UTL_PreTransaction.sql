-- Cashier.bas / PreTransaction
CREATE OR REPLACE FUNCTION "NHS_UTL_PRETRANSACTION"(
	i_CashierCode     IN VARCHAR2,
	i_TransactionType IN VARCHAR2,
	i_EcrReference    IN VARCHAR2,
	i_Amount          IN NUMBER,
	i_TransactionDate IN DATE
)
	RETURN NUMBER
AS
	o_CtnID    NUMBER;
	v_SiteCode VARCHAR2(10);
	v_TransactionDate DATE;
	CARDTX_STS_INITIAL VARCHAR2(1) := 'I';
BEGIN
	-- get site code
	v_SiteCode := GET_CURRENT_STECODE;

	-- get next CardTx id
	SELECT SEQ_CardTx.NEXTVAL INTO o_CtnID FROM DUAL;

	IF i_TransactionDate IS NOT NULL THEN
		v_TransactionDate := i_TransactionDate;
	ELSE
		v_TransactionDate := SYSDATE;
	END IF;

	INSERT INTO CardTx (CtnID, CtnSts, CtnType, CtnRef, CtnTAmt, CtnTDate, CshCode, SteCode)
	VALUES (o_CtnID, CARDTX_STS_INITIAL, SUBSTR(i_TransactionType, 1, 1), i_EcrReference, i_Amount, v_TransactionDate, i_CashierCode, v_SiteCode);

	RETURN o_CtnID;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_UTL_PRETRANSACTION;
/
