create or replace
FUNCTION      "NHS_RPT_REMINDERLETTER_HKAH" (V_slpList IN VARCHAR2, V_patno in VARCHAR2, V_slpDtlList in varchar2)
  RETURN TYPES.CURSOR_TYPE
AS
  OUTCUR TYPES.CURSOR_TYPE;
  strslp Varchar2(3000);
  strsql Varchar2(10000);
  finsql Varchar2(20000);
BEGIN
    strslp := V_slpList;
    strsql:='
        select
        replace(p.TITDESC,''.'','''') as title,
        NVL(S.SlpFName, P.PatFName) as patfname,
        NVL(S.SlpGName, P.PatGName) as patgname,
        UPPER(P.patadd1) AS patadd1,
				UPPER(P.patadd2) AS patadd2,
				UPPER(P.patadd3) AS patadd3,
        (select coudesc from country where coucode = p.coucode) as patcountry,
        decode(s.slptype,''O'',''Out-patient'',''In-patient'') as pattype,
        s.slpno as slpno,
        to_char(r.regdate,''DD Mon YYYY'',''nls_date_language=ENGLISH'') as regdate,
        TO_CHAR(I.INPDDATE,''DD Mon YYYY'',''nls_date_language=ENGLISH'') as inpddate
        from patient p ,slip s,reg r,inpat i
        where s.slpno in ('''||replace(strslp,'/',''',''')||''')
        AND S.REGID = R.REGID(+)
        AND   S.PATNO = P.PATNO(+)
        AND   R.INPID = I.INPID(+)
        and p.patno='''||V_PATNO||''' ';
        
    finsql :='
      select sinf.title,sinf.patfname,sinf.patgname,
             sinf.patadd1, sinf.patadd2, sinf.patadd3,sinf.patcountry,
             sinf.pattype, sinf.regdate, sinf.inpddate,
             sdtl.slpno,sdtl.amt
      from ( '||strsql||' ) sinf 
      inner join (' ||v_slpDtlList||' ) sdtl on sinf.slpno = sdtl.slpno ';
      
  OPEN OUTCUR FOR finsql;
  RETURN OUTCUR; 
END NHS_RPT_REMINDERLETTER_HKAH;
/
