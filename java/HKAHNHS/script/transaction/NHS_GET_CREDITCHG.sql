CREATE OR REPLACE FUNCTION "NHS_GET_CREDITCHG" (
	v_slpno    IN VARCHAR2,
	v_itemcode IN VARCHAR2,
	v_acmcode  IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur Types.cursor_type;
	v_pkgcode VARCHAR2(20);
	v_itctype VARCHAR2(20);
	v_cpsid VARCHAR2(20);
	v_regid NUMBER;
BEGIN
--	dbms_output.put_line('v_slpno>>>>'||v_slpno);
	select S.slptype, S.regid into v_itctype, v_regid from slip S where S.Slpno = v_slpno;
	if v_regid is null or v_regid = 0 then
		v_pkgcode:='';
	else
		select pkgcode into v_pkgcode from reg where regid=v_regid;
	end if;

	select A.cpsid into v_cpsid from slip S,arcode A where S.arccode = A.arccode(+) and S.Slpno = v_slpno;

	outcur := NHS_GET_CHG('C', v_pkgcode, v_itemcode, v_itctype, v_acmcode, v_cpsid);
	RETURN outcur;
end NHS_GET_CREDITCHG;
/
