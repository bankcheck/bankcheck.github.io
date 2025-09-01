-- IncrementCashierReceiptNumber
create or replace FUNCTION "NHS_UTL_CASHIERRECEIPTNUMBER"
	RETURN VARCHAR2
AS
	o_NewReceiptNumber VARCHAR2(50);
	v_SiteCode         VARCHAR2(10);
BEGIN
	-- get site code
	v_SiteCode := GET_REAL_STECODE;

	-- IncrementCashierReceiptNumber + Setting
	UPDATE Setting SET Setvalue = Setvalue + 1 WHERE Setting = 'RECEIPT' and SteCode = v_SiteCode;

	SELECT Setvalue - 1 INTO o_NewReceiptNumber FROM Setting WHERE Setting = 'RECEIPT' and SteCode = v_SiteCode;

	o_NewReceiptNumber := SUBSTR(v_SiteCode, 1, 5) || SUBSTR('0000000000' || o_NewReceiptNumber, LENGTH(o_NewReceiptNumber) + 1, 10);

	RETURN o_NewReceiptNumber;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN NULL;
END NHS_UTL_CASHIERRECEIPTNUMBER;
/
