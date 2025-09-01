create or replace
FUNCTION "NHS_LIS_APPLISTING_PAT"(
	V_BKGSDATE IN VARCHAR2,
	V_BKGEDATE IN VARCHAR2,
	V_BKGCDATE IN VARCHAR2,
	V_STECODE  IN VARCHAR2,
	V_DOCCODE  IN VARCHAR2,
	V_DOCLIST IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
  Strsql Varchar2(30000);
  Strdoc Varchar2(10000);
  Strdoc1 Varchar2(10000);
    Insql Varchar2(10000);
  STRBKGCDATE VARCHAR2(100);
Begin
  If V_Doclist Is Not Null Then
    Select replace(v_doclist,'/',''',''') Into Insql From Dual;
  Else
      Insql:='';
  end if;
  If Insql Is Not Null Then
    Strdoc:= ' AND S.DOCCODE in('''||Insql||''') ';
  ELSE
    STRDOC:='';
  END IF;
  If V_Doccode Is Not Null Then
    STRDOC1:= ' AND S.DOCCODE ='''||V_DOCCODE||''' ';
  Else
    Strdoc1:='';
  END IF;
  IF V_BKGCDATE IS NOT NULL THEN
    STRBKGCDATE:= ' AND B.BKGCDATE >= TO_DATE('''||V_BKGCDATE||''', ''DD/MM/YYYY HH24:MI'') ';
  ELSE
    STRBKGCDATE:='';
  End If;

   Strsql:='
    SELECT
          distinct b.patno
      FROM BOOKING B, SCHEDULE S, DOCTOR D, SITE SIT
     WHERE B.SCHID = S.SCHID
       AND S.DOCCODE = D.DOCCODE
	   AND B.STECODE = SIT.STECODE
       AND B.BKGSTS = ''N''
	   AND b.patno is not null
       AND B.STECODE = '''||V_STECODE||'''
       AND B.BKGSDATE >= TO_DATE('''||V_BKGSDATE||''', ''DD/MM/YYYY HH24:MI'')
       AND B.BKGSDATE <= TO_DATE('''||V_BKGEDATE||''', ''DD/MM/YYYY HH24:MI'') '
       ||Strbkgcdate||Strdoc||Strdoc1||'  order by b.patno ';
  OPEN OUTCUR FOR STRSQL;
  RETURN OUTCUR;
END NHS_LIS_APPLISTING_PAT;
/