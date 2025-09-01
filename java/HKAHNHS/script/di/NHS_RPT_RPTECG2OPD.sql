create or replace FUNCTION NHS_RPT_RPTECG2OPD (
  v_FromDate VARCHAR2,
  v_ToDate VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR

  select to_char(r.xrgid) xrgid, to_char(r.xrgdate, 'DD/MM/YYYY') xrgdate, to_char(r.xrgsnddate, 'DD/MM/YYYY') xrgsnddate, j.xjbno, j.doccode, j.xjbtloc, j.xjbtlocdesc, tx.stndesc || ' ' || tx.stndesc1 as stndesc,
     p.patno, p.patfname || ' ' || p.patgname as patname, d.docfname || ' ' || d.docgname as docname from xjob j, xreg r, patient p, sliptx tx, doctor d where
    j.XjbNo = r.XjbNo
        and r.stnid = tx.stnid
        and r.xrgecg = -1
        and r.xrgecgflag = 0
        and r.xrgSndDate >= to_date(v_FromDate, 'DD/MM/YYYY')
        and r.xrgSndDate < to_date(v_ToDate, 'DD/MM/YYYY') + 1
        and j.doccode = d.doccode
    and j.patno = p.patno

	union all

	select to_char(r.xrgid) xrgid, to_char(r.xrgdate, 'DD/MM/YYYY') xrgdate, to_char(r.xrgsnddate, 'DD/MM/YYYY') xrgsnddate, j.xjbno, j.doccode, j.xjbtloc, j.xjbtlocdesc, tx.stndesc || ' ' || tx.stndesc1 as stndesc,
	     p.orpno as patno, p.orpfname || ' ' || p.orpgname as patname, d.docfname || ' ' || d.docgname as docname from xjob j, xreg r, outrefpat p, sliptx tx, doctor d where
	    j.XjbNo = r.XjbNo
	        and r.stnid = tx.stnid
	        and r.xrgecg = -1
	        and r.xrgecgflag = 0
	        and r.xrgSndDate >= to_date(v_FromDate, 'DD/MM/YYYY')
	        and r.xrgSndDate < to_date(v_ToDate, 'DD/MM/YYYY') + 1
	        and j.doccode = d.doccode
	    and j.patno = p.orpno
	order by patNo, xjbNo;

RETURN outcur;
END NHS_RPT_RPTECG2OPD;