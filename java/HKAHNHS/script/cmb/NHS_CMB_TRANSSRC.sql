CREATE OR REPLACE FUNCTION "NHS_CMB_TRANSSRC"
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
		SELECT BKSID, BKSDESC
		FROM   BOOKINGSRC
		WHERE  BKSTYPE in ('A', 'I')
--		WHERE  BKSID in ('0', '61', '62', '63', '70', '8', '65')
--		AND    BKSSTS = -1
		ORDER  BY BKSORD;
	RETURN outcur;
END NHS_CMB_TRANSSRC;
/
