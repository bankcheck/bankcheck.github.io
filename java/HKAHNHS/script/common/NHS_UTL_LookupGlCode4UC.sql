CREATE OR REPLACE FUNCTION NHS_UTL_LookupGlCode4UC (
	a_ItmCode  VARCHAR2,
	a_GlcCode  VARCHAR2
)
	RETURN VARCHAR2
IS
	v_GlcCode CreditChg.GlcCode%TYPE;
	v_Count NUMBER;
BEGIN
	v_GlcCode := a_GlcCode;

	SELECT COUNT(1) INTO v_Count FROM ItemChg WHERE PkgCode IS NULL AND ItmCode = a_ItmCode AND CPSID IS NULL AND ItcType = 'O' AND AcmCode = 'ZZU' AND GlcCode LIKE '375-%';
	IF v_Count = 1 THEN
		SELECT GlcCode INTO v_GlcCode FROM ItemChg WHERE PkgCode IS NULL AND ItmCode = a_ItmCode AND CPSID IS NULL AND ItcType = 'O' AND AcmCode = 'ZZU' AND GlcCode LIKE '375-%';
	END IF;

	RETURN v_GlcCode;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -999;
END NHS_UTL_LookupGlCode4UC;
/
