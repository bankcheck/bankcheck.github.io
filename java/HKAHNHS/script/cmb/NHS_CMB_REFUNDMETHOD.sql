CREATE OR REPLACE FUNCTION NHS_CMB_REFUNDMETHOD
	RETURN Types.CURSOR_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN OUTCUR FOR
		SELECT Paycode, PayDesc
		FROM   Paycode
		WHERE  Paycode in ('01', '02', '03', '06', '07', '09')
		ORDER BY paycode;

	RETURN OUTCUR;
end NHS_CMB_REFUNDMETHOD;
/
