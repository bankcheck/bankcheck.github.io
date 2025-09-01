CREATE OR REPLACE FUNCTION "NHS_LIS_PKGTRANS" (
	v_slpno IN VARCHAR2,
	v_opt2  IN VARCHAR2
)
	RETURN Types.cursor_type
AS
	outcur types.cursor_type;
	sqlstr VARCHAR2(2000);
BEGIN
	sqlstr:=
		'Select
			'''',
			p.PtnSeq,
			p.PkgCode,
			p.ItmCode,
			p.PtnBAmt,
			p.DocCode,
			TO_CHAR(p.PtnTDate,''dd/MM/yyyy''),
			p.PtnSts,
			p.PtnDesc,
			p.Unit,
			p.IRefNo,
			P.GLCCODE,
			p.PtnRlvl,
			p.PtnOAmt,
			p.PtnID,
			p.SlpNo,
			i.ItmType,
			sp.SpcName,
			p.PtnCDate,
			p.DscCode,
			p.ptndesc1,
			p.PtnDesc || '' '' || p.ptndesc1 AS ptndesc00,
			p.DIXREF,
			p.PTNDIFLAG,
			p.PTNCPSFLAG
	FROM  PkgTx p, Item i, Spec sp, Doctor d
	WHERE p.ItmCode = i.ItmCode
	AND   p.DocCode = d.DocCode
	AND   d.SpcCode = sp.SpcCode';

	IF v_opt2='N' then
		sqlstr := sqlstr||' AND PtnSts in (''N'',''A'')';
  	END if;

	IF v_slpno is not null then
		sqlstr := sqlstr || ' AND slpno = ''' || v_slpno || ''' ORDER BY p.PtnSeq desc';
	END IF;

	OPEN outcur FOR sqlstr;
	RETURN OUTCUR;
END NHS_LIS_PKGTRANS;
/
