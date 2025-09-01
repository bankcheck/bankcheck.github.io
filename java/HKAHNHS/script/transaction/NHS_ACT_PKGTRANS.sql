CREATE OR REPLACE FUNCTION "NHS_ACT_PKGTRANS" (
	v_action         IN VARCHAR2,
	v_slpno          IN VARCHAR2,
	v_slptype        IN VARCHAR2,
	v_pkgcode        IN VARCHAR2,
	v_itmcode        IN VARCHAR2,
	v_oAmount        IN VARCHAR2,
	v_bAmount        IN VARCHAR2,
	v_doccode        IN VARCHAR2,
	v_ptnrlvl        IN VARCHAR2,
	v_acmcode        IN VARCHAR2,
	v_ptncdate       IN VARCHAR2,
	v_ptntdate       IN VARCHAR2,
	v_description    IN VARCHAR2,
	v_stnsts         IN VARCHAR2,
	v_cashierClosed  IN VARCHAR2,
	v_bedcode        IN VARCHAR2,
	v_dixref         IN VARCHAR2,
	v_flagToDi       IN VARCHAR2,
	v_ConPceSetFlag  IN VARCHAR2,
	v_unitAmt        IN VARCHAR2,
	v_stndesc        IN VARCHAR2,
	v_irefno         IN VARCHAR2,
	i_UsrID          IN VARCHAR2,
	o_errmsg		 OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	o_errcode := NHS_UTL_AddPackageEntry(
			v_slpno,
			v_pkgcode,
			v_itmcode,
			TO_NUMBER(v_oAmount),
			TO_NUMBER(v_bAmount),
			v_doccode,
			TO_NUMBER(v_ptnrlvl),
			v_acmcode,
			TO_DATE(v_ptncdate, 'DD/MM/YYYY HH24:MI:SS'),
			TO_DATE(v_ptntdate, 'DD/MM/YYYY HH24:MI:SS'),
			v_description,
			v_stnsts,
			v_bedcode,
			TO_NUMBER(v_dixref),
			v_flagToDi = 1,
			v_ConPceSetFlag,
			TO_NUMBER(v_unitAmt),
			v_stndesc,
			v_irefno,
			NULL,
			NULL,
			TRUE,
			i_UsrID
		);

	RETURN o_errcode;
EXCEPTION WHEN OTHERS THEN
	ROLLBACK;
	o_errcode := -1;
	o_errmsg := SQLERRM;
	RETURN o_errcode;
END NHS_ACT_PKGTRANS;
/
