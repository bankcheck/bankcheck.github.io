DECLARE
    O_ERRMSG VARCHAR2(200);
    v_Return NUMBER;
    v_AltID VARCHAR2(5);
BEGIN
    FOR R IN (
        	SELECT HPKEY, HPSTATUS FROM HPSTATUS WHERE HPTYPE IN ('BOOK_REFUS')
	)
	LOOP
        SELECT AltID INTO v_AltID FROM Alert WHERE AltCode = 'N' || R.HPSTATUS;
        v_Return := NHS_ACT_PATALERT(
            'ADD',
            v_AltID,
            R.HPKEY,
            'PORTAL',
            NULL,
            NULL,
            O_ERRMSG
        );
DBMS_OUTPUT.PUT_LINE('v_Return = ' || v_Return);
DBMS_OUTPUT.PUT_LINE('O_ERRMSG = ' || O_ERRMSG);
	END LOOP;
END;
/
