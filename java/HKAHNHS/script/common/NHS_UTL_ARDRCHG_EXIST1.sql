create or replace FUNCTION NHS_UTL_ARDRCHG_EXIST1 (
	i_itmcode IN VARCHAR2,
	i_pkgcode IN VARCHAR2,
	i_slpno IN VARCHAR2,
	i_acmcode IN VARCHAR2,
	i_doccode IN VARCHAR2,
	i_transdate IN VARCHAR2,
	i_arccode IN VARCHAR2
)
	RETURN NUMBER
AS
	v_COUNT NUMBER;
	v_ardctype SLIP.SLPTYPE%TYPE;
	v_arccode SLIP.ARCCODE%TYPE;
	v_errcode NUMBER;
	v_errmsg VARCHAR2(1000);
BEGIN
	SELECT SLPTYPE INTO  v_ardctype FROM SLIP WHERE slpno = i_slpno;

--	if (i_arccode is null or i_arccode = '') THEN
--		SELECT ARCCODE INTO v_arccode FROM SLIP WHERE slpno = i_slpno;
--	ELSE
		v_arccode := i_arccode;
--	END IF;

	select count(1) INTO v_count from ardrchg
	where itmcode= i_itmcode
	and ARCCODE = v_arccode
	AND ARDCTYPE = v_ardctype
	AND ((i_pkgcode IS NULL AND PKGCODE IS NULL) OR PKGCODE = i_pkgcode)
	AND ((i_acmcode IS NULL AND ACMCODE IS NULL) OR ACMCODE = i_acmcode)
	AND DOCCODE = i_doccode
	AND ( i_transdate IS NULL OR ARDCSDT <= TO_DATE(i_transdate,'dd/mm/yyyy') OR ARDCSDT IS NULL)
	AND ( i_transdate IS NULL OR ARDCEDT >= TO_DATE(i_transdate,'dd/mm/yyyy') OR ARDCEDT IS NULL);

	v_errcode := NHS_ACT_SYSLOG('ADD', 'ARDRCHG_EXIST', 'i_acmcode:' || i_acmcode, i_slpno, 'IT', 'USER_PC', v_errmsg);

	RETURN v_COUNT;

END NHS_UTL_ARDRCHG_EXIST1;
/
