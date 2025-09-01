CREATE OR REPLACE FUNCTION NHS_CMB_PayCode2 (
	p_date VARCHAR2
)
	RETURN TypeS.CURSOR_TYPE
AS
	OUTCUR TypeS.CURSOR_TYPE;
	l_date DATE;
	CASHTX_PAYTYPE_OTHER VARCHAR2(1) := 'O';
BEGIN
	l_date := TO_DATE( p_date, 'DD/MM/YYYY HH24:MI:SS' );

	OPEN OUTCUR FOR
		SELECT PayCode, PayDesc, GlcCode, StnType
		FROM
		(
			SELECT PayCode, PayDesc, GlcCode, PayCode || PayDesc as sort, 'PAYCODE' AS StnType
			FROM   PayCode
			WHERE  PayType <> CASHTX_PAYTYPE_OTHER
			UNION
			SELECT p.PayCode, p.PayDesc, p.GlcCode, '' || p.PayCode as sort, 'ARCCODE' AS StnType
			FROM   PayCode p, arcode a
			WHERE  p.PayType = CASHTX_PAYTYPE_OTHER AND  p.PayCode = a.arccode
			AND
			(
				l_date IS NULL OR
				(
					(a.ar_s_date IS NULL OR l_date >= a.ar_s_date )
				AND
					(a.ar_e_date IS NULL OR l_date <= a.ar_e_date )
				)
			)
		)
		ORDER BY StnType DESC, sort;

	RETURN OUTCUR;
END NHS_CMB_PayCode2;
/
