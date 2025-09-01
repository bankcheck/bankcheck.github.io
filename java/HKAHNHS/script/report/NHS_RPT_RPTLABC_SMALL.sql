CREATE OR REPLACE FUNCTION "NHS_RPT_RPTLABC_SMALL" (
	v_typeBCnt       VARCHAR2, --2 union
	v_typeCCntOrigin VARCHAR2, --3 mrlbl
	v_typeDCnt       VARCHAR2, --4 wbLbl
	v_patno          VARCHAR2
)
	RETURN types.cursor_type
AS
	outcur types.cursor_type;
	rid NUMBER(2);
	b NUMBER(2);
	sqlstr VARCHAR2(10000);
	prtCnt NUMBER(3);
	totalLbl VARCHAR2(20);
	typeACnt VARCHAR2(10); --commonLblCnt
	typeDCnt2 VARCHAR2(10);
	typeAStart NUMBER(3);
	typeBStart NUMBER(3);
	typeCStart NUMBER(3);
	typeDStart NUMBER(3);
	prtType VARCHAR(30);
	medIDCnt NUMBER(3);
	typeCCnt VARCHAR(10);
	mrLblContent VARCHAR(50);
	mrVol VARCHAR(10);
	mrLblChkDgt VARCHAR2(4);
	isCheckDigit VARCHAR2(4);

BEGIN
	prtCnt := 1;
	mrLblContent := '';
	rid := 1;
	sqlstr := '( ';
	totalLbl := '52';
	isCheckDigit := '';

	SELECT param1 INTO isCheckDigit
	FROM   sysparam
	WHERE  parcde = 'ChkDigit';

	SELECT COUNT(1) into medIDCnt
	FROM   MEDRECHDR A, MEDRECDTL B
	WHERE  A.MRHID = B.MRHID
	AND    B.MRDSTS = 'C'
	AND    TRUNC(B.MRDDDATE) = TRUNC(SYSDATE)
	AND    A.PATNO = v_patno;

	IF medIDCnt = 0 THEN
		typeCCnt := 0;
	ELSE
		SELECT max(mrhvollab) into mrVol from medrechdr where patno = v_patno;
		typeCCnt := v_typeCCntOrigin;
		mrLblContent := '-C/'||v_patno||'/'||mrVol;
		mrLblChkDgt := TO_CHAR(NHS_GEN_CHECKDIGIT(mrLblContent));

		IF isCheckDigit = 'YES' THEN
			mrLblContent := '-C/'||v_patno||'/'||mrVol||mrLblChkDgt;
		END IF;

		mrLblContent := mrLblContent||'#';
	END IF;

	--totalnum-unionlblnum-mrlblnum
	IF (totalLbl - v_typeBCnt - typeCCnt) < v_typeDCnt THEN
		typeDCnt2 := TO_CHAR(totalLbl - v_typeBCnt - typeCCnt);
	ELSE
		typeDCnt2 := v_typeDCnt;
	END IF;

	typeACnt := totallbl - v_typeBCnt - typeCCnt - v_typeDCnt;

	IF typeACnt < 0 THEN
		typeACnt := 1;
	END IF;

	typeAStart := 1;
	typeBStart := typeAStart + typeACnt;
	typeCStart := typeBStart + v_typeBCnt;
	typeDStart := typeCStart + typeCCnt;

	IF typeCCnt = 0 THEN
		typeCStart := 0;
	END IF;
	dbms_output.put_line('typeDStart'||typeDStart);

	FOR b in 1..totalLbl LOOP
		IF prtCnt = typeAStart THEN
			prtType := '''A''';
		ELSIF prtCnt = typeBStart THEN
			prtType := '''B''';
		ELSIF prtCnt = typeCStart THEN
			prtType := '''C''';
		ELSIF prtCnt = typeDStart THEN
			prtType := '''D''';
		END IF;

		IF MOD(b,4) = 1 THEN
			IF prtCnt <> totalLbl THEN
				sqlstr := sqlstr || 'select '||rid||' as rid, '||prtType||' as isTwoD_1, ';
				rid:=rid+1;
			END IF;
		ELSIF MOD(b,4) = 0 THEN
			sqlstr := sqlstr ||prtType||' as isTwoD_4,'||''''||mrLblContent||''''||' as mrLblContent from dual ';
			IF prtCnt <> totalLbl THEN
				sqlstr := sqlstr || ' union ';
			END IF;
		ELSE
			sqlstr := sqlstr ||prtType||' as isTwoD_'||mod(b,4)||', ';
		END IF;
		prtCnt := prtCnt + 1;
	END LOOP;
	sqlstr := sqlstr || ' )order by rid ';
	dbms_output.put_line(SQLSTR);

	OPEN outcur FOR SQLSTR;
	RETURN OUTCUR;
end NHS_RPT_RPTLABC_SMALL;
/
