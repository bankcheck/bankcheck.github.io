CREATE OR REPLACE FUNCTION "NHS_RPT_RPTPGMFEELST" (
	v_stecode VARCHAR2,
	v_pkgcode VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
BEGIN
	OPEN outcur FOR
		select  it.itmcode, it.itmname, it.itmcname, it.dsccode, st.stename,
			it.itmrlvl, it.itmtype, itg.pkgcode, pkg.pkgname, pkg.pkgcname, pkg.dptcode,
			nvl(itg.acmcode,' ') as acmcode, itg.glccode, itg.itcamt1, itg.itcamt2, itg.itctype,
			it.dptcode as DPTCODE3, it.itmpoverrd,
			decode(pkg.pkgcname, null, itg.pkgcode || ' - ' || trim(pkg.pkgname), itg.pkgcode || ' - ' || trim(pkg.pkgname) || ' ' || pkg.pkgcname) as package
		from    item it, itemchg itg, package pkg, site st
		where   it.itmcode = itg.itmcode
		and     itg.pkgcode = pkg.pkgcode
		and     pkg.stecode = st.stecode
		and     pkg.stecode = v_stecode
		and    (pkg.pkgcode like v_pkgcode or v_pkgcode is null or v_pkgcode=' ')
		order by it.itmcode;
	RETURN OUTCUR;
END NHS_RPT_RPTPGMFEELST;
/
