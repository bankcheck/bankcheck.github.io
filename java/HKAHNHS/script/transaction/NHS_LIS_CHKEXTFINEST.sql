create or replace
FUNCTION           "NHS_LIS_CHKEXTFINEST" (
	v_PATNO    IN VARCHAR2,
	v_PATNAME IN VARCHAR2,
	v_docCode IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	sqlStr VARCHAR2(5000);
BEGIN
	sqlStr := 'select PATNO,patname,DOCCODE,q.proccode, p.PROCDESC, DIAGNOSIS, 
        q.LOS,q.acmcode,a.acmname,DRRNDDAYSUMMIN1,DRRNDDAYSUMMAX1, PROFEEMIN,PROFEEMAX,
				ANAESTHETISTFEEMIN, ANAESTHETISTFEEMAX, OTHERMIN1, OTHERMAX1,OTHERMIN2, 
				OTHERMAX2,DRRNDDAYSUMMIN2, DRRNDDAYSUMMAX2, -- RMSUMMIN, RMSUMMAX, 
				OTMIN,OTMAX, OTHERMIN3, OTHERMAX3
				from fin_quotation q, fin_proc p, acm a where
        q.PROCCODE = p.proccode 
        and q.acmcode = a.acmcode and ';
 
	If (V_Patno Is Not Null And Length(V_Patno) > 0 ) Then
		Sqlstr := Sqlstr || ' ( q.patno = '''||V_Patno||'''';
    If (V_Patname Is Not Null And Length(V_Patname) > 0 ) Then
			Sqlstr := Sqlstr || ' OR q.patname like ''%'||V_Patname||'%'' ';
		End If;
    Sqlstr := Sqlstr || ') ';
  Elsif (V_Patname Is Not Null And Length(V_Patname) > 0 ) Then
    Sqlstr := Sqlstr || ' ( q.patname like ''%'||V_Patname||'%'') ';
	END IF;
	
	IF v_docCode is not null  AND LENGTH(TRIM(v_docCode)) > 0 THEN
		if (v_PATNAME is not null AND LENGTH(v_PATNAME) > 0 ) THEN
			sqlStr := sqlStr || ' AND ';
		END IF;
		 sqlStr := sqlStr || 'q.DOCCODE = ''' || v_docCode || ''' ';
	END IF;

  DBMS_OUTPUT.PUT_LINE(sqlStr);
	OPEN OUTCUR FOR sqlStr;
	RETURN OUTCUR;

END NHS_LIS_CHKEXTFINEST;
/
