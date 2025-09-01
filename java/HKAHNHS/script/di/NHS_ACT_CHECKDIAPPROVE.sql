create or replace FUNCTION "NHS_ACT_CHECKDIAPPROVE" (
	i_User_ID	VARCHAR2,
	i_User_Pwd 	VARCHAR2
)
	RETURN Types.cursor_type
AS
	OUTCUR types.cursor_type;
	o_errcode NUMBER;
    v_Count NUMBER;

BEGIN

    SELECT COUNT(*) INTO v_Count
    FROM PUSR
    WHERE USRID = UPPER(i_User_ID)
    AND USRPWD = i_User_Pwd;
	
    IF v_Count = 1 THEN
        OPEN OUTCUR FOR
            SELECT PARAM1 
            FROM SYSPARAM 
            --WHERE PARCDE = 'SIGNATURE';
            WHERE PARCDE = 'TESTSIGN';
    ELSE
        OPEN OUTCUR FOR
            SELECT 1 FROM DUAL WHERE 1 != 1;
    END IF;
	RETURN OUTCUR;
END NHS_ACT_CHECKDIAPPROVE;