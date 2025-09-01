CREATE OR REPLACE FUNCTION "NHS_RPT_RPTFEECREDITLST" (
	v_SteCode VARCHAR2,
	v_ItemCode VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	v_stntdate DATE := TRUNC(SYSDATE);
BEGIN
	OPEN outcur FOR
		SELECT
			it.itmcode,
			it.itmname,
			decode(it.itmcname, null, trim(it.itmname), trim(it.itmname) || ' ' || it.itmcname) as itmcname,
			it.dsccode,
			decode(it.itmrlvl,'1','1','2','2','3','3','') as itmrlvl,
			it.itmtype,
			itcg.pkgcode,
			dps.dscdesc,
			itcg.acmcode,
			itcg.glccode,
			itcg.itcamt1,
			itcg.itcamt2,
			itcg.itctype,
			it.dptcode,
			decode(it.itmpoverrd, -1, 'Y', 'N') as itmpoverrd
		FROM item it,
			creditchg itcg,
			dpserv dps
		WHERE  it.itmcode = itcg.itmcode
		AND    it.dsccode = dps.dsccode
		AND    itcg.stecode = v_SteCode
		AND  ( it.itmcode LIKE v_ItemCode OR v_ItemCode IS NULL )
		AND  ( itcg.cicsdt IS NULL OR itcg.cicsdt <= v_stntdate )
		AND  ( itcg.cicedt IS NULL OR itcg.cicedt >= v_stntdate )
		ORDER BY 1, 5, 6, 13, 9, 10;

	RETURN OUTCUR;
END NHS_RPT_RPTFEECREDITLST;
/
