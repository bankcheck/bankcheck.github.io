CREATE OR REPLACE FUNCTION NHS_RPT_RPTDRSWAPPAT (
  v_SteCode VARCHAR2,
  v_StartDate VARCHAR2,
  v_EndDate VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
 SELECT distinct to_date(v_StartDate,'dd-mm-yyyy') as DATERANGESTART,
       to_date(v_EndDate, 'dd-mm-yyyy') as DATERANGEEND,
       dh.patno,
       p.patfname,
       p.patgname,
       r.slpno,
       to_char(dh.dhsdate,'dd/mm/yyyy') dhsdate,
       to_char(dh.dhsedate,'dd/mm/yyyy') dhsedate,
       decode(trunc(dh.dhsedate) - trunc(dh.dhsdate),0,1,trunc(dh.dhsedate) - trunc(dh.dhsdate)) as CDay,
       dh.doccode,
       sc.stename,
       d.DocFName,
       d.DocGname
From   dochist dh,
       patient p,
       reg r,
       doctor d,
       site sc,
(select f.dhsid as fid,
        t.dhsid as tid
 From   dochist f,
        dochist t
 Where  f.dhsdate >= to_date(v_StartDate,'dd/mm/yyyy')
        and f.dhsdate < to_date(v_EndDate,'dd/mm/yyyy') + 1
        and f.dhsedate = t.dhsdate
        and f.regid = t.regid
        and t.dhssts = 'C') tmp
Where (dh.dhsid = tmp.fid or dh.dhsid = tmp.tid)
      AND r.stecode= v_SteCode
      AND r.stecode = sc.stecode
      AND dh.regid = r.regid
      AND dh.patno = p.patno
      AND dh.doccode = d.doccode
order by dh.patno;

RETURN outcur;
END NHS_RPT_RPTDRSWAPPAT;
/
