CREATE OR REPLACE FUNCTION "NHS_GET_TXNCALREFITEM" (
	i_PkgCode  IN VARCHAR2,
	i_ItmCode  IN VARCHAR2,
	i_DeptCode IN VARCHAR2,
	i_SlipNo   IN VARCHAR2
)
	RETURN types.CURSOR_TYPE
AS
	OUTCUR types.CURSOR_TYPE;
	v_errcode NUMBER;
	v_errmsg VARCHAR2(1000);
	v_Amount NUMBER := 0;
	v_Count NUMBER;
	v_memItmCode ITEM.ITMCODE%TYPE;
	v_memPkgCode PACKAGE.PKGCODE%TYPE;
	v_criteriaPkgCode VARCHAR2(100);
	v_criteriaItmCode VARCHAR2(100);
	PKGTX_TYPE_NATUREOFVISIT VARCHAR2(1) := 'N';
	SLIPTX_STATUS_NORMAL VARCHAR2(1) := 'N';
	SLIPTX_STATUS_ADJUST VARCHAR2(1) := 'A';
	MSG_ITEM_CODE VARCHAR2(18) := 'Invalid item code.';
	MSG_PKG_CODE VARCHAR2(21) := 'Invalid package code.';
BEGIN
	-- LookUpItmCode
	IF i_ItmCode IS NULL THEN
		v_memItmCode := 'all';
	ELSE
		IF INSTR(i_ItmCode, '%') > 0 THEN
			v_memItmCode := i_ItmCode;
		ELSE
			SELECT ItmCode INTO v_memItmCode
			FROM   Item
			WHERE  ItmCode = i_ItmCode;
		END IF;

		IF v_memItmCode IS NULL THEN
			v_errcode := -300;
			v_errmsg := MSG_ITEM_CODE;
			GOTO SKIP_ALL;
		END IF;
	END IF;

	-- LookUpPkgCode
	IF i_PkgCode IS NULL THEN
		v_memPkgCode := '%';
	ELSE
		-- LookupPackageCode
		SELECT PkgCode INTO v_memPkgCode
		FROM   Package
		WHERE  PkgCode = i_PkgCode
		AND    PkgType <> PKGTX_TYPE_NATUREOFVISIT;

		IF v_memPkgCode IS NULL THEN
			v_errcode := -100;
			v_errmsg := MSG_PKG_CODE;
			GOTO SKIP_ALL;
		END IF;
	END IF;

	IF v_memPkgCode != '%' THEN
		v_criteriaPkgCode := ' AND PkgCode = ''' || v_memPkgCode || '''';
	END IF;

	IF v_memItmCode IS NOT NULL AND v_memItmCode != 'all' THEN
		IF INSTR(i_ItmCode, '%') > 0 THEN
			v_criteriaItmCode := ' AND ItmCode LIKE ''' || v_memItmCode || '''';
		ELSE
			v_criteriaItmCode := ' AND ItmCode = ''' || v_memItmCode || '''';
		END IF;

		IF i_DeptCode IS NULL THEN
			OPEN OUTCUR FOR 'Select SUM(PtnBAmt) FROM PkgTx WHERE Slpno = ''' || i_SlipNo || '''' || v_criteriaPkgCode ||
				v_criteriaItmCode || ' AND PtnSts IN (''' || SLIPTX_STATUS_NORMAL || ''', ''' || SLIPTX_STATUS_ADJUST || ''')';
				LOOP
					FETCH OUTCUR INTO v_Amount;
					EXIT WHEN OUTCUR%NOTFOUND;
				END LOOP;
			CLOSE OUTCUR;
		ELSE
			v_errcode := -200;
			v_errmsg := 'You can only enter Dept Code or Item Code';
			GOTO SKIP_ALL;
		END IF;
	ELSIF i_DeptCode IS NOT NULL Then
		OPEN OUTCUR FOR 'Select SUM(PtnBAmt) FROM PkgTx WHERE Slpno = ''' || i_SlipNo || '''' || v_criteriaPkgCode ||
			' AND SUBSTR(GlcCode, 1, 4) = ''' || i_DeptCode || ''' AND PtnSts IN (''' || SLIPTX_STATUS_NORMAL || ''', ''' || SLIPTX_STATUS_ADJUST || ''')';
			LOOP
				FETCH OUTCUR INTO v_Amount;
				EXIT WHEN OUTCUR%NOTFOUND;
			END LOOP;
		CLOSE OUTCUR;
	ELSE
		v_errcode := -200;
		v_errmsg := 'You can only enter Dept Code or Item Code';
		GOTO SKIP_ALL;
	END IF;

	v_errcode := 0;
	v_errmsg := 'OK';
<<SKIP_ALL>>

	OPEN OUTCUR FOR
	SELECT v_errcode, v_errmsg, v_Amount FROM DUAL;

	RETURN OUTCUR;
EXCEPTION
WHEN OTHERS THEN
	v_errcode := -1;
	v_errmsg := substr(SQLERRM, 1, 200);

	OPEN OUTCUR FOR
	SELECT v_errcode, v_errmsg, v_Amount FROM DUAL;

	RETURN OUTCUR;
END NHS_GET_TXNCALREFITEM;
/
