CREATE OR REPLACE FUNCTION "NHS_LIS_TXNSLIPPAYALL_ALL" (
	V_slpno slip.slpno%TYPE
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
		SELECT '',
			C.ITMCODE,
			d.doccode,
			C.STNDESC AS CHGDESC,
			A.ARCCODE,
			DECODE(D.STNTYPE, 'P', A.ATXDESC, P.STNDESC) AS PAYDESC,
			d.spdaamt,
			to_char(d.spdcdate,'dd/MM/yyyy') AS spdcdate,
			d.spdid,
			'',
			'',
			'',
			'',
			'',
			'',
			'',
			'',
			'',
			'',
			d.sphid
		FROM  SLPPAYDTL D, SLIPTX C, ARTX A, SLIPTX P
		WHERE C.SLPNO = v_slpno
		AND   C.STNID = D.STNID
		AND   D.PAYREF = A.ATXID(+)
		AND   D.PAYREF = P.STNID(+)
		AND   D.SPDSTS IN ('N', 'A');
	RETURN OUTCUR;
END NHS_LIS_TXNSLIPPAYALL_ALL;
/
