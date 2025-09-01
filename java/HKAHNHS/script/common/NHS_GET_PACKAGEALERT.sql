CREATE OR REPLACE FUNCTION "NHS_GET_PACKAGEALERT" (
	i_TransactionMode VARCHAR2,
	i_PkgCode         VARCHAR2
)
	RETURN Types.cursor_type
AS
	OUTCUR types.cursor_type;
	v_Count NUMBER;
	v_PkgAlert Package.PkgAlert%TYPE;
	PKGTX_TYPE_NATUREOFVISIT VARCHAR2(1) := 'N';
	TXN_ADD_MODE VARCHAR2(3) := 'ADD';
BEGIN
	IF i_TransactionMode = TXN_ADD_MODE THEN
		SELECT COUNT(1) INTO v_Count FROM Package where PkgCode = i_PkgCode and PkgType != PKGTX_TYPE_NATUREOFVISIT;
		IF v_COUNT = 1 THEN
			SELECT PkgAlert INTO v_PkgAlert FROM Package where PkgCode = i_PkgCode and PkgType != PKGTX_TYPE_NATUREOFVISIT;
		END IF;
	ELSE
		SELECT COUNT(1) INTO v_Count FROM CreditPkg where PkgCode = i_PkgCode and PkgType != PKGTX_TYPE_NATUREOFVISIT;
		IF v_COUNT = 1 THEN
			SELECT PkgAlert INTO v_PkgAlert FROM CreditPkg where PkgCode = i_PkgCode and PkgType != PKGTX_TYPE_NATUREOFVISIT;
		END IF;
	END IF;

	OPEN OUTCUR FOR
	SELECT v_PkgAlert FROM DUAL;
	RETURN OUTCUR;
END NHS_GET_PACKAGEALERT;
/
