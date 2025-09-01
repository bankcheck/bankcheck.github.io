CREATE OR REPLACE FUNCTION "NHS_CMB_TXNNOSIGN"
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
		SELECT 'H', 'Health Condition' FROM DUAL
		UNION
		SELECT 'L', 'Left / Not approach' FROM DUAL
		UNION
		SELECT 'E', 'Elderly' FROM DUAL
		UNION
		SELECT 'D', 'Deceased' FROM DUAL
		UNION
		SELECT 'O', 'Other' FROM DUAL;
	RETURN OUTCUR;
END NHS_CMB_TXNNOSIGN;
/


