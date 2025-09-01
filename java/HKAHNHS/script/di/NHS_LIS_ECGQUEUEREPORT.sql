create or replace
FUNCTION "NHS_LIS_ECGQUEUEREPORT" (
  v_xRegDateFrom  IN VARCHAR2,
  v_xRegDateTo IN VARCHAR2,
  v_reported in varchar2
)
	RETURN TYPES.CURSOR_TYPE
AS
	OUTCUR TYPES.CURSOR_TYPE;
	SqlStr VARCHAR2(5000);
BEGIN
  
  if (v_reported = '0')  then
    SqlStr := 'select j.xjbno, null as new_doccode, null as something, p.patno, p.patfname || '' '' || p.patgname as patname, null as xrpdate, tx.stndesc || '' '' || tx.stndesc1 as stndesc, null as usrid_t, to_char(r.xrgsnddate, ''dd/mm/yyyy''), to_char(r.xrgdate, ''dd/mm/yyyy''), ';
    SqlStr := SqlStr  || 'j.doccode, j.xjbtloc, j.xjbtlocdesc, Decode(P.PMCID,Null,null,0,null,''M'') Merged , ';
    SqlStr := SqlStr  || 'r.xrgid, null as xrpid,  null as old_doccode ';
    SqlStr := SqlStr  || 'from xjob j, xreg r, patient p, sliptx tx ';
    SqlStr := SqlStr  || 'where j.XjbNo = r.XjbNo and r.stnid = tx.stnid and r.xrgecg = -1 and r.xrgecgflag = 0 and xrgid ';
    SqlStr := SqlStr  || 'not in (select xrgid from xreport) ';
    --SqlStr := SqlStr  || 'and r.xrgSndDate >= to_date(''01-01-2017'', ''DD-MM-YYYY'') and r.xrgSndDate < to_date(''30-08-2017'', ''DD-MM-YYYY'') + 1 ';
    SqlStr := SqlStr  || 'and r.xrgSndDate >= to_date(''' || v_xRegDateFrom || ' 000000'', ''DD-MM-YYYY hh24miss'') ';
    SqlStr := SqlStr  || 'and r.xrgSndDate <= to_date(''' || v_xRegDateTo || ' 235959'', ''DD-MM-YYYY hh24miss'') + 1 ';
    SqlStr := SqlStr  || 'and j.patno = p.patno ';
    SqlStr := SqlStr  || 'union ';
    SqlStr := SqlStr  || 'select j.xjbno, null as new_doccode, null as something, p.orpno as patno, p.orpfname || '' '' || p.orpgname as patname, null as xrpdate, tx.stndesc || '' '' || tx.stndesc1 as stndesc, null as usrid_t, to_char(r.xrgsnddate, ''dd/mm/yyyy''), to_char(r.xrgdate, ''dd/mm/yyyy''), ';
    SqlStr := SqlStr  || 'j.doccode, j.xjbtloc, j.xjbtlocdesc, null Merged, ';
    SqlStr := SqlStr  || 'r.xrgid, null as xrpid, null as old_doccode ';
    SqlStr := SqlStr  || 'from xjob j, xreg r, outrefpat p, sliptx tx ';
    SqlStr := SqlStr  || 'where j.XjbNo = r.XjbNo and r.stnid = tx.stnid and r.xrgecg = -1 and r.xrgecgflag = 0 and xrgid ';
    SqlStr := SqlStr  || 'not in (select xrgid from xreport) ';
    --SqlStr := SqlStr  || 'and r.xrgSndDate >= to_date(''01-01-2017'', ''DD-MM-YYYY'') and r.xrgSndDate < to_date(''30-08-2017'', ''DD-MM-YYYY'') + 1 ';
    SqlStr := SqlStr  || 'and r.xrgSndDate >= to_date(''' || v_xRegDateFrom || ' 000000'', ''DD-MM-YYYY hh24miss'') ';
    SqlStr := SqlStr  || 'and r.xrgSndDate <= to_date(''' || v_xRegDateTo || ' 232359'', ''DD-MM-YYYY hh24miss'') + 1 ';
    SqlStr := SqlStr  || 'and j.patno = p.orpno ';
    SqlStr := SqlStr  || 'order by patNo, xjbNo ';
  else
    SqlStr := 'select j.xjbno, rpt.doccode as new_doccode, null as something, p.patno, p.patfname || '' '' || p.patgname as patname, to_char(rpt.xrpdate, ''dd/mm/yyyy''), tx.stndesc || '' '' || tx.stndesc1 as stndesc, rpt.usrid_t, to_char(r.xrgsnddate, ''dd/mm/yyyy''),  to_char(r.xrgdate, ''dd/mm/yyyy''), j.doccode, j.xjbtloc, j.xjbtlocdesc, ';
    SqlStr := SqlStr  || 'Decode(P.PMCID,Null,null,0,null,''M'') Merged , ';
    SqlStr := SqlStr  || 'r.xrgid, rpt.xrpid, rpt.doccode as old_doccode ';
    SqlStr := SqlStr  || 'from xjob j, xreg r, patient p, sliptx tx, xreport rpt ';
    SqlStr := SqlStr  || 'where j.XjbNo = r.XjbNo and r.stnid = tx.stnid and r.xrgecg = -1 and r.xrgecgflag = 0 ';
    SqlStr := SqlStr  || 'and r.xrgid = rpt.xrgid ';
--    SqlStr := SqlStr  || 'and r.xrgSndDate >= to_date(''01-01-2017 000000'', ''DD-MM-YYYY hh24miss'') and r.xrgSndDate < to_date(''30-08-2017 235959'', ''DD-MM-YYYY hh24miss'') + 1 ';
    SqlStr := SqlStr  || 'and r.xrgSndDate >= to_date(''' || v_xRegDateFrom || ' 000000'', ''DD-MM-YYYY hh24miss'') ';
    SqlStr := SqlStr  || 'and r.xrgSndDate <= to_date(''' || v_xRegDateTo || ' 235959'', ''DD-MM-YYYY hh24miss'') + 1 ';
    SqlStr := SqlStr  || 'and j.patno = p.patno ';
    SqlStr := SqlStr  || 'union  ';
    SqlStr := SqlStr  || 'select j.xjbno, rpt.doccode as new_doccode, null as something, p.orpno as patno, p.orpfname || '' '' || p.orpgname as patname, to_char(rpt.xrpdate, ''dd/mm/yyyy''), tx.stndesc || '' '' || tx.stndesc1 as stndesc, rpt.usrid_t, to_char(r.xrgsnddate, ''dd/mm/yyyy''), to_char(r.xrgdate, ''dd/mm/yyyy''), j.doccode, j.xjbtloc, j.xjbtlocdesc, ';
    SqlStr := SqlStr  || 'null Merged, ';
    SqlStr := SqlStr  || 'r.xrgid, rpt.xrpid, rpt.doccode as old_doccode ';
    SqlStr := SqlStr  || 'from xjob j, xreg r, outrefpat p, sliptx tx, xreport rpt ';
    SqlStr := SqlStr  || 'where j.XjbNo = r.XjbNo and r.stnid = tx.stnid and r.xrgecg = -1 and r.xrgecgflag = 0 ';
    SqlStr := SqlStr  || 'and r.xrgid = rpt.xrgid ';
    --SqlStr := SqlStr  || 'and r.xrgSndDate >= to_date(''01-01-2017 000000'', ''DD-MM-YYYY hh24miss'') and r.xrgSndDate < to_date(''30-08-2017 232359'', ''DD-MM-YYYY hh24miss'') + 1 ';
    SqlStr := SqlStr  || 'and r.xrgSndDate >= to_date(''' || v_xRegDateFrom || ' 000000'', ''DD-MM-YYYY hh24miss'') ';
    SqlStr := SqlStr  || 'and r.xrgSndDate <= to_date(''' || v_xRegDateTo || ' 235959'', ''DD-MM-YYYY hh24miss'') + 1 ';
    SqlStr := SqlStr  || 'and j.patno = p.orpno ';
    SqlStr := SqlStr  || 'order by patNo, xjbNo ';
  end if;

 OPEN outcur FOR SqlStr;
   RETURN OUTCUR;

	OPEN OUTCUR FOR SqlStr;
	RETURN OUTCUR;
END NHS_LIS_ECGQUEUEREPORT;