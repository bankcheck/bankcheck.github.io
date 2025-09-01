CREATE OR REPLACE FUNCTION "NHS_ACT_CASHIERVOIDENTRYCLEAR" (
i_action               IN VARCHAR2,
i_CtnID                IN VARCHAR2,
o_errmsg               OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER := 0;
	CARDTX_STS_INITIAL VARCHAR2(1) := 'I';
BEGIN
	o_errmsg := 'OK';

	-- remove temporary cardtx records
	IF i_CtnID IS NOT NULL THEN
		DELETE FROM CardTx WHERE CtnSts = CARDTX_STS_INITIAL AND CtnID = i_CtnID;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_ACT_CASHIERVOIDENTRYCLEAR;
/
