CREATE OR REPLACE FUNCTION "NHS_UTL_ARPAYMENTENTRY" (
	i_UserID          IN VARCHAR2,
	i_Arcode          IN VARCHAR2,
	i_Amount          IN NUMBER,
	i_ReceiptNumber   IN VARCHAR2,
	i_Description     IN VARCHAR2,
	i_TransactionDate IN DATE,
	i_CaptureDate     IN VARCHAR2
)
	RETURN VARCHAR2
AS
	o_ArpID           NUMBER;
	v_TransactionDate DATE;
	v_CaptureDate     DATE;
	v_Description     VARCHAR2(50);
BEGIN
	-- get next ArpTx id
	SELECT SEQ_ArpTx.NEXTVAL INTO o_ArpID FROM DUAL;

	-- set default transaction date if empty
	IF i_TransactionDate IS NOT NULL THEN
		v_TransactionDate := TRIM(i_TransactionDate);
	ELSE
		v_TransactionDate := TRIM(SYSDATE);
	END IF;

	-- set default capture date if empty
	IF i_CaptureDate IS NOT NULL THEN
		v_CaptureDate := i_CaptureDate;
	ELSE
		v_CaptureDate := SYSDATE;
	END IF;

	-- ARPTX_STATUS_NORMAL = 'N', ARTX_TYPE_PAYMENT = 'P'
	INSERT INTO ArpTx (ArpID, ArcCode, ArpOAmt, ArpAAmt, ArpRecNo, ArpTDate, ArpCDate, ArpDesc, ArpSts, UsrID, ArpType)
	VALUES (o_ArpID, i_Arcode, i_Amount, 0, i_ReceiptNumber, v_TransactionDate, v_CaptureDate, i_Description, 'N', i_UserID, 'P');

	-- Update Payer's Balance (UpdateARBalance)
	UPDATE ArCode
	Set    ArcAmt = ArcAmt + 0, ArcUAmt = ArcUAmt + i_Amount
	WHERE  ArcCode = i_Arcode;

	RETURN o_ArpID;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN NULL;
END NHS_UTL_ARPAYMENTENTRY;
/
