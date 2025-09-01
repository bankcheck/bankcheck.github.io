CREATE OR REPLACE FUNCTION "NHS_LIS_ITEMCHARGELIST" (
	v_itemcode IN VARCHAR2,
	v_itemset  IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	v_stntdate DATE := TRUNC(SYSDATE);
BEGIN
	OPEN outcur FOR
		SELECT
			' ',
			t.itcid,
			t.itmcode,
			t.ITCTYPE,
			t.PKGCODE,
			p.pkgname,
			t.ACMCODE,
			t.GLCCODE,
			t.ITCAMT1,
			t.ITCAMT2,
			t.CPSID,
			t.CPSPCT
		FROM  ItemChg t, PACKAGE p
		WHERE t.pkgcode = p.pkgcode
		AND   t.itmcode = v_itemcode
		AND ( t.CPSID = v_itemset OR v_itemset IS NULL )
		AND ( t.itcsdt IS NULL OR t.itcsdt <= v_stntdate )
		AND ( t.itcedt IS NULL OR t.itcedt >= v_stntdate )
		ORDER BY t.ItcType, t.PkgCode, t.AcmCode;

	RETURN OUTCUR;
END NHS_LIS_ITEMCHARGELIST;
/
