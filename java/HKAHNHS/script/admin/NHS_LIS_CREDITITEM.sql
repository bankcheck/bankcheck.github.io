CREATE OR REPLACE FUNCTION "NHS_LIS_CREDITITEM" (
	v_itemcode in varchar2,
	v_itemset in varchar2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	v_stntdate DATE := TRUNC(SYSDATE);
BEGIN
	OPEN outcur FOR
		SELECT
			' ',
			c.cicid,
			c.itmcode,
			c.ITCTYPE,
			c.PKGCODE,
			p.pkgname,
			c.ACMCODE,
			c.GLCCODE,
			c.ITCAMT1,
			c.ITCAMT2,
			c.CPSID,
			c.CPSPCT
		FROM  CreditChg c, CreditPkg p
		WHERE c.pkgcode = p.pkgcode
		AND   c.itmcode = v_itemcode
		AND ( c.CPSID = v_itemset or v_itemset is null )
		AND ( c.cicsdt IS NULL OR c.cicsdt <= v_stntdate )
		AND ( c.cicedt IS NULL OR c.cicedt >= v_stntdate )
		ORDER BY c.ItcType, c.PkgCode, c.AcmCode;
	RETURN OUTCUR;
END NHS_LIS_CREDITITEM;
/
