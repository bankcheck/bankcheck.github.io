CREATE OR REPLACE FUNCTION "NHS_RPT_RPTPGMCREDITLST" (
	v_SteCode VARCHAR2,
	v_PkgCode VARCHAR2
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
			st.stename,
			decode(it.itmrlvl, '1', '1', '2', '2', '3', '3', '') as itmrlvl,
			it.itmtype,
			citg.pkgcode,
			cpkg.pkgname,
			cpkg.pkgcname,
			cpkg.dptcode,
			citg.acmcode,
			citg.glccode,
			citg.itcamt1,
			citg.itcamt2,
			citg.itctype,
			decode(cpkg.pkgcname,null,citg.pkgcode || ' - ' || trim(cpkg.pkgname), citg.pkgcode || ' - ' || trim(cpkg.pkgname) || ' ' || cpkg.pkgcname) as package
		FROM item it,
			creditchg citg,
			creditpkg cpkg,
			site st
		WHERE it.itmcode = citg.itmcode
		AND   citg.pkgcode = cpkg.pkgcode
		AND   cpkg.stecode = st.stecode
		AND   cpkg.stecode = v_SteCode
		AND ( it.itmcode like v_PkgCode or v_PkgCode is null or v_PkgCode = '' )
		AND ( citg.cicsdt IS NULL OR citg.cicsdt <= v_stntdate )
		AND ( citg.cicedt IS NULL OR citg.cicedt >= v_stntdate );

	RETURN OUTCUR;
END NHS_RPT_RPTPGMCREDITLST;
/
