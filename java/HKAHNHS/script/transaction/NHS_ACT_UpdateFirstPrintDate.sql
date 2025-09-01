CREATE OR REPLACE FUNCTION "NHS_ACT_UPDATEFIRSTPRINTDATE" (
	v_action IN VARCHAR2,
	v_slpNo  IN VARCHAR2,
	o_errmsg OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	UPDATE Slip
	SET    FirstPrtDt = SYSDATE
	WHERE  SlpNo = v_slpNo
	AND    FirstPrtDt IS NULL;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	o_errcode := -1;
	o_errmsg := 'Fail to insert record.';
	ROLLBACK;

	RETURN o_errcode;
END NHS_ACT_UPDATEFIRSTPRINTDATE;
/
