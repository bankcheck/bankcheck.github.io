CREATE OR REPLACE FUNCTION "NHS_RPT_RPTPAYOUTVOIDSHT"
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
     ctxamt,
     ctxdesc
  from
     cashtx ct
  Where
    ct.ctxid = v_ctxId;
RETURN OUTCUR;
END NHS_RPT_RPTPAYOUTVOIDSHT;
/
