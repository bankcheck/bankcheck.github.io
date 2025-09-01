CREATE OR REPLACE FUNCTION NHS_RPT_RPTREJCHQLST
( v_SDate VARCHAR2,
  v_EDate VARCHAR2,
  v_SteCode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
select * from (
                select
                 sp.slpno, sp.patno, sp.slptype,
                 nvl(pt.patfname,sp.slpfname) || ' ' || nvl(sp.slpgname, pt.patgname) as patname,
                  st.stnnamt, st.usrid,to_char(st.stncdate,'dd/mm/yyyy')stncdate

            from sliptx st, slip sp, patient pt, cashtx ct, sliptx st2
                     where (st.stncdate between to_date(v_SDate, 'dd/mm/yyyy') and to_date(v_EDate, 'dd/mm/yyyy') + 1 )
                             and st.itmcode = 'PAYME'
                             and st.slpno = sp.slpno
                             and sp.patno = pt.patno(+)
                             and sp.stecode = v_SteCode
                             and st.stnxref = ct.ctxid
                             and ct.ctxmeth = 'Q'
                             and st.stnsts = 'U'
                             and st.stntype <>  'P'
                             and st.slpno = st2.slpno
                             and st.stnxref = st2.stnxref
                             and st.stntype = st2.stntype
                             and st2.STNSTS = 'C'
                             and trunc(st.stncdate) > trunc(st2.stncdate)
Union
                  select '' as slpno, '' as patno, '' as slptype, ct.ctxname || '-' || ct.ctxdesc as patname,
                              abs(ct.ctxamt) as stnnamt, c.usrid,
                             to_char(ct.ctxcdate,'dd/mm/yyyy') as stncdate
                       from cashtx ct, cashtx ct2 , cashier c
                       where(ct.ctxcdate between to_date(v_SDate, 'dd/mm/yyyy') and to_date(v_EDate, 'dd/mm/yyyy') + 1 )
                             and ct.slpno is null
                             and ct.ctxtype = 'R'
                             and ct.stecode = v_SteCode
                             and ct.ctxmeth =  'Q'
                             and ct.ctxsts = 'R'
                             and ct.cshcode = c.cshcode
                             and ct.ctxsno = ct2.ctxsno
                             and ct.ctxtype = ct2.ctxtype
                             and ct2.ctxSTS = 'V'
                             and trunc(ct.ctxcdate) > trunc(ct2.ctxcdate))
   order by slptype;
  RETURN outcur;
END NHS_RPT_RPTREJCHQLST;
/
