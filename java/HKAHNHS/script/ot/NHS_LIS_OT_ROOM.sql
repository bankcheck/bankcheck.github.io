CREATE OR REPLACE
FUNCTION NHS_LIS_OT_ROOM (
	v_RMTYPE IN VARCHAR2
)
RETURN
	TYPES.CURSOR_TYPE
--VARCHAR2
AS
	OUTCUR TYPES.CURSOR_TYPE;
	V_PARAM SYSPARAM.PARAM1%TYPE;
	V_ROOMCOUNT NUMBER :=0;
	sqlstr VARCHAR2(2000);  
BEGIN
	SELECT PARAM1 
	INTO v_PARAM
	FROM SYSPARAM 
	WHERE PARCDE = 'OTTABVIEW';
  
	IF v_PARAM IS NULL OR v_PARAM = 'S' THEN 
		sqlstr := 'SELECT otcid, otcdesc, otcord FROM ot_code WHERE otcsts = -1 and otctype = ''RM'' order by otcord';
	ELSE
		IF V_RMTYPE IS NOT NULL THEN
      sqlstr := 'SELECT otcid, otcdesc, otcord FROM ot_code WHERE otcsts = -1 and otcchr_1 = '''||V_RMTYPE||''' and otctype = ''RM'' order by otcord';		
		ELSE
			SELECT COUNT(otcid) 
			INTO v_roomCount
			FROM ot_code 
			WHERE otcsts = -1 
			and otcchr_1 IS NULL 
			and otctype = 'RM' 
			order by otcord;		
			
			IF v_roomCount>0 THEN
				sqlstr := 'SELECT otcid, otcdesc, otcord FROM ot_code WHERE otcsts = -1 and otcchr_1 IS NULL and otctype = ''RM'' order by otcord';					
			ELSE
				sqlstr := 'SELECT ''0'', ''OTHERS'', ''0'' FROM DUAL';					
			END IF;
		END IF;
	END IF;  
	OPEN OUTCUR FOR SQLSTR;
	RETURN OUTCUR;
--RETURN SQLSTR;
END NHS_LIS_OT_ROOM;
/