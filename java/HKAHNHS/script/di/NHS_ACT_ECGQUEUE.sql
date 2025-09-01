create or replace FUNCTION "NHS_ACT_ECGQUEUE" (
	v_action   IN VARCHAR2,
	v_SELECTITEM  IN VARCHAR2,
	o_errmsg   OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
    v_FLAG XREG.XRGECGFLAG%TYPE;
    CURSOR v_XRGID IS 
        SELECT REGEXP_SUBSTR(v_SELECTITEM,'[^;]+', 1, LEVEL) AS TEMP FROM DUAL 
        CONNECT BY REGEXP_SUBSTR(v_SELECTITEM,'[^;]+', 1, LEVEL) IS NOT NULL;      
        
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	IF v_action = 'ADD' THEN
        v_FLAG := 0;
        FOR VAL IN v_XRGID LOOP
        UPDATE XREG 
        SET 
            XRGECGFLAG = v_FLAG,
            XRGSNDDATE = SYSDATE
        WHERE XRGID = VAL.TEMP;
     END LOOP;
    ELSIF v_action = 'DEL' THEN
        v_FLAG := 1;
        FOR VAL IN v_XRGID LOOP
        UPDATE XREG 
        SET 
            XRGECGFLAG = v_FLAG
        WHERE XRGID = VAL.TEMP;
     END LOOP;
    ELSIF v_action = 'MOD' THEN
        v_FLAG := -1;
        FOR VAL IN v_XRGID LOOP
        UPDATE XREG 
        SET 
            XRGECGFLAG = v_FLAG
        WHERE XRGID = VAL.TEMP;
     END LOOP;
	END IF;

	RETURN o_errcode;
END NHS_ACT_ECGQUEUE;