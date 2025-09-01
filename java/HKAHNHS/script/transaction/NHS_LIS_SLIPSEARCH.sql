CREATE OR REPLACE FUNCTION "NHS_LIS_SLIPSEARCH" (
	v_patno    IN VARCHAR2,
	v_slpno    IN VARCHAR2,
	v_slptype  IN VARCHAR2,
	v_slpsts   IN VARCHAR2,
	v_patfname IN VARCHAR2,
	v_patgname IN VARCHAR2,
	v_doccode  IN VARCHAR2,
	v_dptcode  IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	sqlstr VARCHAR2(2000);
BEGIN
	sqlstr := '
		SELECT
			S.SLPNO,
			S.SLPTYPE,
			S.SLPSTS,
			P.PATNO,
			NVL(S.SLPFNAME, P.PATFNAME) AS PATFNAME,
			NVL(S.SLPGNAME, P.PATGNAME) AS PATGNAME,
			D.DOCCODE,
			D.DOCFNAME,
			D.DOCGNAME,
			I.INPDDATE,
			S.SLPCAMT + S.SLPDAMT + S.SLPPAMT AS SLPNAMT,
			S.USRID,
			I.BEDCODE,
			A.ACMCODE,
			TO_CHAR(R.REGDATE, ''DD/MM/YYYY''),
			s.DptCode,
			s.SlpCAmt - s.SlpDAmt as SlpNAmt
		FROM  SLIP S, REG R, PATIENT P, DOCTOR D, INPAT I, ACM A
		WHERE S.REGID = R.REGID(+)
		AND   S.PATNO = P.PATNO(+)
		AND   S.DOCCODE = D.DOCCODE
		AND   R.INPID = I.INPID(+)
		AND   I.ACMCODE = A.ACMCODE(+)';

	IF v_patno IS NOT NULL THEN
		IF v_patno = 'NULL' THEN
			sqlstr := sqlstr || ' AND s.patno IS NULL';
		ELSE
			sqlstr := sqlstr || ' AND s.patno = ''' || v_patno || '''';
		END IF;
	END IF;

	IF v_slpno IS NOT NULL THEN
		sqlstr := sqlstr || ' AND s.slpno = ''' || v_slpno || '''';
	END IF;

	IF v_slptype IS NOT NULL THEN
		sqlstr := sqlstr || ' AND s.slptype= ''' || v_slptype || '''';
	END IF;

	IF v_slpsts IS NOT NULL THEN
		sqlstr := sqlstr || ' AND s.slpsts = ''' || v_slpsts || '''';
	END IF;

	IF v_patfname IS NOT NULL THEN
		sqlstr := sqlstr || ' AND (s.slpfname = ''' || v_patfname || '''' || ' OR p.patfname = ''' || v_patfname || ''')';
	END IF;

	IF v_patgname IS NOT NULL THEN
		sqlstr := sqlstr || ' AND (s.slpgname = ''' || v_patgname || '''' || ' OR p.patgname = ''' || v_patgname || ''')';
	END IF;

	IF v_doccode IS NOT NULL THEN
		sqlstr := sqlstr || ' AND s.doccode = ''' || v_doccode || '''';
	END IF;

	IF v_dptcode IS NOT NULL THEN
		sqlstr := sqlstr || ' AND s.dptcode = ''' || v_dptcode || '''';
	END IF;

	sqlstr := sqlstr || ' ORDER BY SLPNO DESC';

	OPEN outcur FOR sqlstr;
	RETURN OUTCUR;
END NHS_LIS_SLIPSEARCH;
/
