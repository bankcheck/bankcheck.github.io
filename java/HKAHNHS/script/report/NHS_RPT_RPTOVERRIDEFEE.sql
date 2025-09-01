create or replace
FUNCTION NHS_RPT_RPTOVERRIDEFEE
 ( v_SDate VARCHAR2,
  v_EDate VARCHAR2,
  v_SteCode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
  SELECT 
--  to_date(v_SDate,'dd-mm-yyyy') as dateRangeStart,
--  to_date(v_EDate, 'dd-mm-yyyy') as DateRangeEnd,
  st.itmcode, it.itmname, st.pkgcode, st.stnsts,
  st.stnbamt, st.stnoamt, st.slpno, st.doccode,
  st.usrid, sc.stename, TO_CHAR(st.stncdate,'DD/MM/YYYY') AS stncdate
  FROM sliptx st, item it, slip sp, site sc
  WHERE (st.stncdate >= to_date(v_SDate, 'dd-mm-yyyy') 
  AND st. stncdate < to_date(v_EDate, 'dd-mm-yyyy') + 1 )
  AND (st.stnsts = 'N' or st.stnsts = 'A')
  AND stnbamt <> stnoamt
  AND st.itmcode = it.itmcode
  AND st.slpno = sp.slpno
  AND sp.stecode= v_SteCode
  AND sp.stecode = sc.stecode
  AND it.itmpoverrd = -1;
                                        
  RETURN outcur;
END NHS_RPT_RPTOVERRIDEFEE;
/