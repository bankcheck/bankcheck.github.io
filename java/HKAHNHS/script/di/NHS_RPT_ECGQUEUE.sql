create or replace
FUNCTION "NHS_RPT_ECGQUEUE" ( 
	v_FROMDATE IN VARCHAR2,  --19/04/2018
  v_TODATE IN VARCHAR2
)
	RETURN TYPES.CURSOR_TYPE
  --RETURN string
AS
  sql1 VARCHAR2(5000);
  sql2 VARCHAR2(5000);
  sPAT  VARCHAR2(5000);
  sORP VARCHAR2(5000);
  --
  DI_CHECKTRUE VARCHAR2(2);
  DI_CHECKFALSE VARCHAR2(2);
	OUTCUR TYPES.CURSOR_TYPE;
BEGIN
  DI_CHECKTRUE := '-1';
  DI_CHECKFALSE := '0';

  sPAT := 'select r.xrgid, r.xrgdate, r.xrgsnddate, j.xjbno, j.doccode, j.xjbtloc, j.xjbtlocdesc, tx.stndesc || '' '' || 
          tx.stndesc1 as stndesc, p.patno, p.patfname || '' '' || p.patgname as patname,';
  sORP := 'select r.xrgid, r.xrgdate, r.xrgsnddate, j.xjbno, j.doccode, j.xjbtloc, j.xjbtlocdesc, tx.stndesc || '' '' || tx.stndesc1 as stndesc, 
           p.orpno as patno, p.orpfname || '' '' || p.orpgname as patname,';
  
  sPAT := sPAT || ' d.docfname || '' '' || d.docgname as docname';
  sPAT := sPAT || ' from xjob j, xreg r, patient p, sliptx tx, doctor d where ';
  
  sORP := sORP || ' d.docfname || '' '' || d.docgname as docname';
  sORP := sORP || ' from xjob j, xreg r, outrefpat p, sliptx tx, doctor d where ';
  
  sql2 := 'j.XjbNo = r.XjbNo and r.stnid = tx.stnid and r.xrgecg = ' || DI_CHECKTRUE || ' and r.xrgecgflag = ' || DI_CHECKFALSE;
  
  sql2 := sql2 || ' and r.xrgSndDate >= to_date(''' || v_FROMDATE || ''', ''dd/mm/yyyy'')';
  sql2 := sql2 || ' and r.xrgSndDate < to_date(''' || v_TODATE || ''', ''dd/mm/yyyy'') + 1';
  
  sql2 := sql2 || ' and j.doccode = d.doccode';
  
  sql1 := sPAT || sql2 || ' and j.patno = p.patno union all ' || sORP || sql2 || ' and j.patno = p.orpno';
  
  sql1 := sql1 || ' order by patNo, xjbNo';
  
  OPEN OUTCUR FOR 
    sql1;
  RETURN OUTCUR;
  --RETURN sql1;
END NHS_RPT_ECGQUEUE;