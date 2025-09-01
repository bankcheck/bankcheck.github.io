CREATE OR REPLACE FUNCTION NHS_CMB_PayCode (
	v_paytype IN VARCHAR2
)
	RETURN Types.CURSOR_type
AS
	outcur types.cursor_type;
BEGIN
	IF v_paytype = 1 then
		-- payout
		OPEN OUTCUR FOR
			SELECT PayCode, PayDesc, PayType
			FROM   paycode
			WHERE  paycode not in (Select arccode from arcode)
			AND   (paycode = '01'  or paycode = '02' or paycode = '03' or paycode = '07' or paycode = '06' or paycode = '09')
			ORDER BY Paycode;
	ELSIF v_paytype = 2 THEN
		-- receive
		OPEN OUTCUR FOR
			SELECT PayCode, PayDesc, PayType
			FROM   paycode
			WHERE  paycode not IN (SELECT arccode FROM arcode)
			ORDER BY Paycode;
	ELSE
		OPEN OUTCUR FOR
			SELECT PayCode, PayDesc, PayType
			FROM   paycode
			WHERE  1 != 1;
	END IF;

	RETURN OUTCUR;
end NHS_CMB_PayCode;
/
