create or replace view ItemCreditPkg as
	select pkgcode, pkgname, pkgcname, pkgrlvl, dptcode, stecode, pkgtype, pkgalert, 'CREDITPKG' tab_name from creditpkg
	union all
	select pkgcode, pkgname, pkgcname, pkgrlvl, dptcode, stecode, pkgtype, pkgalert, 'PACKAGE' tab_name from package ;
/
