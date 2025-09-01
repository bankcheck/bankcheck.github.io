create or replace
FUNCTION "NHS_ACT_ROPNOTLG" (
  v_action  IN VARCHAR2,
	v_user1 IN OT_LOG.USRID_1%TYPE,
	v_user2 IN OT_LOG.USRID_2%TYPE,
	v_otlid IN OT_LOG.OTLID%TYPE,
	o_errmsg  OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT count(1) INTO v_noOfRec FROM OT_LOG WHERE OTLID = v_otlid;

		IF v_noOfRec > 0 THEN
			UPDATE OT_LOG
				SET
        OTLSTS = 'A',
				USRID_1	= v_user1,
				USRID_2	= v_user2,
        OTLRODATE = SYSDATE
			WHERE OTLID = v_otlid;
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		 END IF;

	RETURN o_errcode;
END NHS_ACT_ROPNOTLG;
/
