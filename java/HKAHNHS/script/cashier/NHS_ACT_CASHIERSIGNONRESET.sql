CREATE OR REPLACE FUNCTION NHS_ACT_CASHIERSIGNONRESET(
	i_ACTION       IN VARCHAR2,
	i_UserID       IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_errcode NUMBER;
	v_count NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg  := 'OK';

	SELECT COUNT(1) INTO v_count FROM Cashier WHERE UsrID = i_UserID AND CshSts = 'N' AND CshMAC = i_ComputerName;
	IF v_count = 1 THEN
		UPDATE Cashier SET CshSts = 'O' WHERE UsrID = i_UserID AND CshSts = 'N' AND CshMAC = i_ComputerName;
		v_errcode := NHS_ACT_SYSLOG('ADD', 'Cashier Signon', 'Override Signon', i_UserID || ' Override Signon @ ' || i_ComputerName, i_UserID, NULL, o_errmsg);
	ELSE
		o_errcode := -1;
		o_errmsg  := 'The cashier cannot override and login another computer.';
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_errmsg := 'Fail to reset as cashier.';

	RETURN -999;
END NHS_ACT_CASHIERSIGNONRESET;
/
