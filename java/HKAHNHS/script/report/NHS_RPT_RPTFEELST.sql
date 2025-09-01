create or replace
FUNCTION "NHS_RPT_RPTFEELST"
(
  v_SteCode VARCHAR2,
  v_ItemCode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
   select it.itmcode, it.itmname||' '||nvl(it.itmcname,'') itmname, it.dsccode,
     decode(it.itmrlvl,'1','1','2','2','3','3','') AS itmrlvl,
     it.itmtype, itg.pkgcode, dps.dscdesc, itg.acmcode, itg.glccode, itg.itcamt1,
     itg.itcamt2, itg.itctype, it.dptcode, it.itmpoverrd
     from item it, itemchg itg, dpserv dps
    where it.itmcode = itg.itmcode and it.dsccode = dps.dsccode
    and itg.stecode = v_SteCode
   -- and it.itmcode like decode(sign(length(trim(v_ItemCode))),1,v_ItemCode,'%');
   AND (it.itmcode LIKE v_ItemCode OR v_ItemCode IS NULL)
  ORDER BY 1,4,5,12,8,9;
  RETURN OUTCUR;
END NHS_RPT_RPTFEELST;
/