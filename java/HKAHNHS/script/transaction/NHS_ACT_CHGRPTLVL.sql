CREATE OR REPLACE FUNCTION "NHS_ACT_CHGRPTLVL" (
	v_action  IN VARCHAR2,
	v_slpno   IN VARCHAR2,
	v_seq     IN VARCHAR2,
	v_itmcode IN VARCHAR2,
	v_nrptlvl IN VARCHAR2,
	v_pkgcode IN VARCHAR2,
	v_dptcode IN VARCHAR2,
	v_dscode  IN VARCHAR2,
	v_opt     IN VARCHAR2,--0,1,2,3,4
	o_errmsg  OUT VARCHAR2
)
	RETURN  NUMBER
AS
	v_noOfRec NUMBER;
	o_errcode NUMBER;
	sqlbuf varchar2(500);
	TXN_PAYMENT_ITMCODE VARCHAR2(5) := 'PAYME';
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO v_noOfRec FROM sliptx WHERE slpno = v_slpno;
	IF v_noOfRec > 0 THEN
		sqlbuf := 'UPDATE sliptx SET stnrlvl = ' || TO_NUMBER(v_nrptlvl) || ' WHERE slpno = ''' || v_slpno || ''' ';
		IF v_opt = '0' THEN
			sqlbuf := sqlbuf || ' AND stnseq = ' || TO_NUMBER(v_seq);
		END IF;
		IF v_opt = '1' THEN
			IF v_pkgcode IS NULL OR TRIM(v_pkgcode) = '' THEN
				sqlbuf := sqlbuf || '  AND itmcode = ''' || v_itmcode || ''' AND (pkgcode = '''' OR pkgcode IS NULL)';
			ELSE
				sqlbuf := sqlbuf || ' AND itmcode = ''' || v_itmcode || ''' AND pkgcode = ''' || v_pkgcode || '''';
			END IF;
		ELSIF v_opt = '2' THEN
			IF v_pkgcode IS NULL OR TRIM(v_pkgcode) = '' THEN
				sqlbuf := sqlbuf || ' AND ( pkgcode = '''' OR pkgcode IS NULL)';
			ELSE
				sqlbuf := sqlbuf || ' AND pkgcode = ''' || v_pkgcode || '''';
			END IF;
			sqlbuf := sqlbuf || ' AND itmcode <> ''' || TXN_PAYMENT_ITMCODE || '''';
		ELSIF v_opt = '3' THEN
			IF v_pkgcode IS NULL OR TRIM(v_pkgcode) = '' THEN
				sqlbuf := sqlbuf || ' AND dsccode = ''' || v_dscode || ''' AND ( pkgcode = '''' OR pkgcode IS NULL)';
			ELSE
				sqlbuf := sqlbuf || ' AND dsccode = ''' || v_dscode || ''' AND pkgcode = ''' || v_pkgcode || '''';
			END IF;
		ELSIF v_opt = '4' THEN
			sqlbuf := sqlbuf || ' AND SUBSTR(glccode, 1, 4) = ''' || v_dptcode || '''';
		END IF;

		execute immediate sqlbuf;
		IF SQL%ROWCOUNT = 0 THEN
			o_errcode := -1;
			o_errmsg := 'update fail.';
		END IF;
	ELSE
		o_errcode := 0;
		o_errmsg := 'No record found.';
	END IF;
	RETURN o_errcode;
END NHS_ACT_CHGRPTLVL;
/
