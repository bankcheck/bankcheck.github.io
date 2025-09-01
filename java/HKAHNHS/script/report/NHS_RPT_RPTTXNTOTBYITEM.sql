CREATE OR REPLACE FUNCTION NHS_RPT_RPTTXNTOTBYITEM
( v_SDate VARCHAR2,
  v_EDate VARCHAR2,
  v_SteCode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
select stename, dept, itmcode, itmname,
          sum(itmcnt) as itmcnt, sum(itmamt) as itmamt
      From (
              SELECT
                             sc.stename, substr(st.glccode, 1,4) as dept, st.itmcode, it.itmname,
                             0 as itmcnt, sum(st.stnnamt) as itmamt
                       FROM  sliptx st, item it, site sc, slip sp
                       WHERE  st.stncdate >= to_date(v_SDate, 'DD/MM/YYYY')
                                  and st.stncdate < to_date(v_EDate, 'DD/MM/YYYY')+1 and
                                  sp.slpno= st.slpno and
                                  st.ItmCode = it.ItmCode and
                                  sp.stecode= v_SteCode and
                                  sp.stecode= sc.stecode and
                                  it.itmcode <> 'REF'
                       GROUP BY sc.stename, substr(st.GlcCode, 1, 4), st.ItmCode, it.ItmName
                  union all
                      SELECT  sc.stename, substr(st.glccode, 1,4) as dept, st.itmcode, it.itmname,
                               sum(st.unit) as itmcnt, 0 as itmamt
                       FROM sliptx st, item it, site sc, slip sp
                        WHERE  st.stncdate >= to_date(v_SDate, 'DD/MM/YYYY')
                                  and st.stncdate < to_date(v_EDate, 'DD/MM/YYYY')+1 and
                                  st.stnsts= 'N' and
                                  sp.slpno= st.slpno and
                                  st.ItmCode = it.ItmCode and
                                  sp.stecode= v_SteCode and
                                  sp.stecode= sc.stecode and
                                  it.itmcode <> 'REF'
                        GROUP BY sc.stename, substr(st.GlcCode, 1, 4), st.ItmCode, it.ItmName
 )
          group by  stename , dept, ItmCode, ItmName
order by dept;
  RETURN outcur;
END NHS_RPT_RPTTXNTOTBYITEM;
/
