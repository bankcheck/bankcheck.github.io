create or replace
FUNCTION "NHS_CMB_PKGCODE" (
	v_IsSorting IN VARCHAR2,
	v_Criteria  IN VARCHAR2,
    v_uni_search IN VARCHAR2
)
	RETURN Types.CURSOR_type
AS
	OUTCUR TYPES.CURSOR_TYPE;
	StrSql VARCHAR2(500);
BEGIN
	Strsql := 'SELECT PkgCode, PkgName FROM Package ';
	StrSql := StrSql || 'WHERE 1=1';

	If Length(Trim(V_Criteria)) > 0 Then
		StrSql := StrSql || ' AND ' || v_Criteria;
	END IF;
	
	StrSql := StrSql || ' AND upper(PkgCode) like ''%' || upper(v_uni_search) || '%''';

	IF v_IsSorting = 'Y' THEN
		StrSql := StrSql || ' ORDER BY PkgCode';
	END IF;

	OPEN OUTCUR FOR StrSql;
	RETURN OUTCUR;
END NHS_CMB_PKGCODE;
/