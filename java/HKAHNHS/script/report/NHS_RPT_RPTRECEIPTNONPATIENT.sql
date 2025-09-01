create or replace
FUNCTION      "NHS_RPT_RPTRECEIPTNONPATIENT"
(
  v_ctxId VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
  select
     ct.ctxsno,
     ct.ctxmeth,
     ct.ctxname,
     ctxamt,
     ctxdesc,
     TO_CHAR(CTXTDATE, 'DDMonYYYY ','nls_date_language=ENGLISH') as CTXTDATE,
     nvl(cd.ctntrace ,'') as traceNo,
     TO_CHAR(SYSDATE, 'DD/MON/YYYY HH24:MI','nls_date_language=ENGLISH') AS printDate,
     nvl( cd.ctnctype ,'')
  from
     cashtx ct,
     cardtx cd
  where
     ct.ctnid = cd.ctnid (+)
     and ct.ctxid = v_ctxId;
RETURN OUTCUR;
END NHS_RPT_RPTRECEIPTNONPATIENT;
/
