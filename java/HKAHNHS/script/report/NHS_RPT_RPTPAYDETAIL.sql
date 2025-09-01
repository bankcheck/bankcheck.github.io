create or replace
FUNCTION "NHS_RPT_RPTPAYDETAIL"
(
  v_StartDate VARCHAR2,
  v_EndDate VARCHAR2,
  v_SteCode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
SELECT
  to_char(st.stncdate,'dd/mm/yyyy') AS stncdate, sp.slptype, cx.ctxmeth,  st.glccode, st.stndesc, cd.ctnctype,
  sp.patno, pt.patfname, pt.patgname, sp.slpfname,
  sp.slpgname, st.slpno, st.stnnamt, st.stntdate,
  st.stnsts, to_char(st.stncdate,'dd/mm/yyyy') AS stncdatechar
  , DECODE(sp.slptype,'O','Out Patient','I','In Patient','Day Case') AS typeDesc
from sliptx st, slip sp, patient pt, site sc, cashtx cx, cardtx cd
Where
(st.stncdate >= to_date(v_StartDate, 'dd-mm-yyyy') and st. stncdate < to_date(v_EndDate, 'dd-mm-yyyy') + 1)
and st.stntype = 'S'
and st.slpno= sp.slpno
and sp.stecode= v_SteCode
and sp.patno = pt.patno(+)
and sp.stecode = sc.stecode
and st.stnxref = cx.ctxid
and cx.ctnid = cd.ctnid(+)
UNION
SELECT to_char(st.stncdate,'dd/mm/yyyy') stncdate ,sp.slptype, 'O' as ctxmeth, st.glccode, st.stndesc, '' as ctnctype,
         sp.patno, pt.patfname, pt.patgname, sp.slpfname,
         sp.slpgname, st.slpno,  st.stnnamt, st.stncdate,
         st.stnsts, to_char(st.stncdate,'dd/mm/yyyy') AS stncdatechar,
         DECODE(slptype,'O','Out Patient','I','In Patient','Day Case') AS typeDesc         
from sliptx st, slip sp, patient pt, site sc
Where
(st.stncdate >= to_date(v_StartDate, 'dd-mm-yyyy') and st. stncdate < to_date(v_EndDate, 'dd-mm-yyyy') + 1)
and st.stntype = 'P'
and st.slpno= sp.slpno
and sp.stecode= v_SteCode
AND sp.patno = pt.patno(+)
and sp.stecode = sc.stecode;
  RETURN OUTCUR;
END NHS_RPT_RPTPAYDETAIL;
/