create or replace
FUNCTION "NHS_RPT_APPLISTING"(V_BKGSDATE IN VARCHAR2,
                                                V_BKGEDATE IN VARCHAR2,
                                                V_BKGCDATE IN VARCHAR2,
                                                V_STECODE  IN VARCHAR2,
                                                V_DOCCODE  IN VARCHAR2,
                                                V_DOCLIST IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
  STRSQL VARCHAR2(2000);
  STRDOC VARCHAR2(100);
  STRBKGCDATE VARCHAR2(100);
BEGIN
  IF V_DOCCODE IS NOT NULL THEN
    STRDOC:= ' AND S.DOCCODE ='||V_DOCCODE||'''';
  ELSE
    STRDOC:='';
  END IF;

  IF V_BKGCDATE IS NOT NULL THEN
    STRBKGCDATE:= ' AND B.BKGCDATE >= TO_DATE('''||V_BKGCDATE||''', ''DD/MM/YYYY HH24:MI'')';
  ELSE
    STRBKGCDATE:='';
  END IF;

   STRSQL:='
    SELECT
           S.DOCCODE,
           D.DOCFNAME ||'' '' ||D.DOCGNAME AS DOCNAME,
           D.docsex||''/''||to_char(floor((sysdate-d.docbdate)/365)) AS SEXAGE,
           p.coucode AS COUNTRY,
           TO_CHAR(B.BKGSDATE, ''DD/MM/YYYY'') AS BKGSDATE,
           TO_CHAR(B.BKGSDATE, ''HH24:MI'') AS ATIME,
           B.PATNO,
           B.BKGPNAME  AS PATNAME,P.PATCNAME,
           B.BKGPTEL,
           to_char(B.BKGSCNT) BKGSCNT,
           TO_CHAR(B.BKGCDATE, ''DD/MM/YYYY HH24:MI'') AS BKGCDATE,
           TO_CHAR(B.BKGCDATE, ''HH24:MI'') AS CTIME,
           B.USRID,
           NVL(P.PATPAGER, '''') AS MOBILE,
           B.BKGRMK,
           P.PATOTEL AS OFFICETEL,
           GET_ALERT_CODE(B.PATNO, '''') AS ALERT,
           SIT.STENAME
      FROM BOOKING@IWEB B, SCHEDULE@IWEB S, DOCTOR@IWEB D, SITE@IWEB SIT, PATIENT@IWEB P
     WHERE B.SCHID = S.SCHID
       AND S.DOCCODE = D.DOCCODE
       AND D.DOCPICKLIST = -1
       AND B.BKGSTS = ''N''
       AND B.STECODE = SIT.STECODE
       AND B.PATNO = P.PATNO(+)
       AND B.STECODE = '''||V_STECODE||'''
       AND B.BKGSDATE >= TO_DATE('''||V_BKGSDATE||''', ''DD/MM/YYYY HH24:MI'')
       AND B.BKGSDATE <= TO_DATE('''||V_BKGEDATE||''', ''DD/MM/YYYY HH24:MI'')'
       ||STRBKGCDATE||STRDOC||'
      AND S.DOCCODE IN ('||V_DOCLIST||')  order by d.doccode '
    ;
  OPEN OUTCUR FOR STRSQL;
  RETURN OUTCUR;
END NHS_RPT_APPLISTING;