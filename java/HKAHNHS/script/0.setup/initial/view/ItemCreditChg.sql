create or replace view ItemCreditChg as
	select cicid, null itcid, itmcode, pkgcode, acmcode, itctype, glccode, itcamt1, itcamt2, stecode, cpsid, cicdoc, cpspct, cicsdt icsdt, cicedt icedt,
		'CREDITCHG' tab_name from creditchg
	union all
	select null cicid, itcid, itmcode, pkgcode, acmcode, itctype, glccode, itcamt1, itcamt2, stecode, cpsid, null cicdoc, cpspct, itcsdt icsdt, itcedt icedt,
		'ITEMCHG' tab_name from itemchg;
/
