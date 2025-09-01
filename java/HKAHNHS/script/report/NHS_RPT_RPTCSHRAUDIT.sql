create or replace
FUNCTION "NHS_RPT_RPTCSHRAUDIT" (
  v_SteCode VARCHAR2,
  v_StartDate VARCHAR2,
  v_EndDate varchar2,
  v_CashierCode varchar2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
  SELECT
  'Normal' AS TYPE
  ,ct.ctxmeth
  ,cd.ctnctype
  ,ct.ctxtype
  ,ct.ctxsno
  ,ct.ctxname
  ,ct.ctxdesc
  ,ct.ctxamt
  ,to_char(ct.ctxcdate, 'DDMonYYYY','nls_date_language=ENGLISH') ctxcdate
  FROM cardtx cd, cashtx ct, cashier cs, site sit
  WHERE ct.cshcode= v_CashierCode
  and ct.ctxcdate >= to_date(v_StartDate, 'DD/MM/YYYY') and ct.ctxcdate< to_date(v_EndDate, 'DD/MM/YYYY')+1
  and ct.ctxsts IN ('N','V')
  and ct.ctnid = cd.ctnid(+)
  AND ct.cshcode= cs.cshcode
  and cs.stecode = v_SteCode
  and cs.stecode= sit.stecode
  UNION ALL
  SELECT
  'Voided Items' AS TYPE
  ,ct.ctxmeth
  ,cd.ctnctype
  ,ct.ctxtype
  ,ct.ctxsno
  ,ct.ctxname
  ,ct.ctxdesc
  ,ct.ctxamt
  ,to_char(ct.ctxcdate, 'DDMonYYYY','nls_date_language=ENGLISH') ctxcdate
  FROM cardtx cd, cashtx ct, cashier cs, site sit
  WHERE ct.cshcode= v_CashierCode
  and ct.ctxcdate >= to_date(v_StartDate, 'DD/MM/YYYY') and ct.ctxcdate< to_date(v_EndDate, 'DD/MM/YYYY')+1
  and ct.ctxsts= 'R'
  and ct.ctnid = cd.ctnid(+)
  and ct.cshcode= cs.cshcode
  AND cs.stecode = v_SteCode
  AND cs.stecode= sit.stecode
  order by Type,ctxmeth,ctnctype,ctxtype,ctxsno,ctxcdate;
 
  RETURN OUTCUR;
END NHS_RPT_RPTCSHRAUDIT;
/
