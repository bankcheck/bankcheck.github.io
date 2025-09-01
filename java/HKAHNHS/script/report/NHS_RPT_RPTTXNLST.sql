CREATE OR REPLACE FUNCTION NHS_RPT_RPTTXNLST
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
                  decode(sp.slptype,'D','Day Case','I','In Patient','Out Patient')slptype,
                  sp.patno,
                  decode(sp.slpfname,null,trim(pt.patfname||' '||pt.patgname),
                  trim(sp.slpfname||' '||sp.slpgname)) patname,
                  st.slpno,st.itmcode, sc.stename,st.stnsts,
                  st.stndesc, st.stnnamt,
                  st.doccode, dr.spccode,to_char(st.stntdate,'dd/mm/yyyy') stntdate, st.usrid

        FROM   doctor dr, sliptx st, slip sp, patient pt, site sc
         WHERE   st.stncdate >= to_date(v_SDate, 'DD-MM-YYYY')
                and st.stncdate< to_date(v_EDate, 'DD-MM-YYYY')+1
                    and st.stntype NOT IN ('S', 'P') and
                     st.slpno = sp.slpno and
                     dr.doccode = st.doccode and
                    sp.stecode= v_SteCode and
                     sp.patno = pt.patno(+) and
                     sp.stecode = sc.stecode and
                     st.itmcode <> 'REF'
                     order by slptype,patno;
  RETURN outcur;
END NHS_RPT_RPTTXNLST;
/
