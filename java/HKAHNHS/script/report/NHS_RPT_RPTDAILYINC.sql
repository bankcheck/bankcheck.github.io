CREATE OR REPLACE FUNCTION NHS_RPT_RPTDAILYINC(
  v_StartDate VARCHAR2,
  v_EndDate VARCHAR2,
  v_SteCode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
SELECT   sc.stename, decode(sp.slptype,'O','Out Patient','I' ,'In Patient','Day Case')slptype,
                  st.glccode, gl.glcname, sum(st.stnbamt) as stnbamt,
                  count(*) as num
        FROM  glcode gl, sliptx st, slip sp, site sc
        WHERE st.stncdate >= to_date(v_StartDate, 'dd/mm/yyyy') and st.stncdate < (to_date(v_EndDate,'dd/mm/yyyy') + 1)
                   and st.stntype NOT IN ('S', 'P')
                   and  st.stntype <> 'R'
                   and sp.stecode= v_SteCode
                   and  st.slpno = sp.slpno
                   and  st.glccode = gl.glccode
                   and  sp.stecode = sc.stecode
        GROUP BY st.glccode ,  gl.glcname ,  sc.stename ,  sp.slptype
Union
    SELECT  sc.stename, decode(sp.slptype,'O','Out Patient','I' ,'In Patient','Day Case')slptype,
                  substr(st.glccode, 1,4) as glccode, dp.dptname, sum(st.stnnamt-st.stnbamt) as stnbamt,
                 count(*) as num

        FROM  sliptx st, slip sp, site sc, dept dp

        WHERE
                    st.stncdate >= to_date(v_StartDate, 'dd/mm/yyyy') and st.stncdate < to_date(v_EndDate, 'dd/mm/yyyy') + 1
                   and st.stntype NOT IN ('S', 'P')
                   and sp.stecode= v_SteCode
                   and  st.stnbamt <> st.stnnamt
                    and substr(st.glccode,1,4) = dp.dptcode
                    and st.slpno = sp.slpno
                   and  sp.stecode = sc.stecode
        GROUP BY  sc.stename,sp.slptype,substr(st.glccode, 1,4),dptname;
RETURN outcur;
END NHS_RPT_RPTDAILYINC;
/
