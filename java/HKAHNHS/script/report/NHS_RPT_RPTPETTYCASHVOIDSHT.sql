CREATE OR REPLACE FUNCTION "NHS_RPT_RPTPETTYCASHVOIDSHT"
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
     ct.ctxname,
     pc.paydesc,
     pc.paycdesc,
     ctxamt,
     ctxdesc
  from
     cashtx ct,
     paycode pc
  Where
     ct.ctxid= v_ctxId
     and ct.ctxmeth = pc.paytype;
RETURN OUTCUR;
END NHS_RPT_RPTPETTYCASHVOIDSHT;
/
