CREATE OR REPLACE FUNCTION "NHS_ACT_ENTRY" (
	v_action   IN   VARCHAR2,
	v_slpno    IN  SLIP.SLPNO%TYPE,
	v_pkgcode  IN  VARCHAR2,
	v_itmcode  IN  VARCHAR2,
	v_stat     IN  VARCHAR2 := 'N',
	v_pkgrlvl  IN  VARCHAR2,
	v_doccode  IN  VARCHAR2,
	v_acmcode  IN  VARCHAR2,
	v_stntdate IN  VARCHAR2,
	v_stnoamt  IN  VARCHAR2,
	v_stnbamt  IN  VARCHAR2,
	v_override IN  VARCHAR2 := 'N',
	v_ref_no   IN  VARCHAR2,
	v_cpsid    IN  VARCHAR2,
	v_unit     IN VARCHAR2,
	v_stndesc1 IN VARCHAR2,
	v_stndesc  IN VARCHAR2,
	v_itmtype  IN VARCHAR2,
	v_cperc    IN VARCHAR2,
	v_entry    IN VARCHAR2,
	i_usrid    IN VARCHAR2,
	o_errmsg   OUT VARCHAR2
)
	return NUMBER
as
	rs_slip  slip % rowtype;
	isTrue boolean;
	o_stnid NUMBER;
	o_stnseq NUMBER;
	v_stnbat NUMBER := 0;
	o_errcode NUMBER := 0;
begin
	if v_action = 'ADD' then
		select * into rs_slip from slip where slpno = v_slpno;
		isTrue := NHS_ACT_ADD_ENTRY(
			rs_slip,
			v_pkgcode,
			v_itmcode,
			v_stat,
			to_number(v_pkgrlvl),
			v_doccode,
			v_acmcode,
			to_date(v_stntdate,'dd/MM/yyyy'),
			to_number(v_stnoamt),
			to_number(v_stnbamt),
			v_override,
			v_ref_no,
			to_number(v_cpsid),
			to_number(v_unit),
			v_stndesc1,
			null,
			v_entry,
			v_cperc,
			'N',
			NULL,
			i_usrid,
			o_stnid,
			o_stnseq,
			o_errmsg);
		if isTrue then
			NHS_UTL_UPDATESLIP(v_slpno);
		end if;
	end if;

	if NOT isTrue then
		rollback;
		return -1;
	end if;

	return o_errcode;

end NHS_ACT_ENTRY;
/
