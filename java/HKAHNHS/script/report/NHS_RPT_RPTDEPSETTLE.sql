create or replace
FUNCTION NHS_RPT_RPTDEPSETTLE(
  v_StartDate VARCHAR2,
  v_EndDate VARCHAR2,
  v_SteCode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
        SELECT sc.stename,decode(dp.dpssts,'T','Transferred','R','Refund','N','Receipt','A','Receipt','Forfeit') as dpssts,
               st.glccode, dp.slpno_s, sp.patno,
               decode(sp.slpfname,null,pt.patfname||' '||pt.patgname,sp.slpfname||' '||sp.slpgname) as patname,
               st.stndesc,
               dp.dpsamt,to_char(dp.dpslcdate, 'DDMonYYYY','nls_date_language=ENGLISH'),
               st.stnid
        FROM   deposit dp, sliptx st, slip sp, patient pt, site sc
        WHERE  dp.dpslcdate BETWEEN to_date(v_StartDate, 'DD/MM/YYYY') and to_date(v_EndDate, 'DD/MM/YYYY')+1 and
               dp.dpssts IN ('T', 'R', 'W', 'N', 'A') and
               dp.dpsid = st.stnxref and
               st.stntype = 'X' and
               st.slpno = sp.slpno and
               sp.patno= pt.patno(+) and
               sp.stecode= v_SteCode and
               sp.stecode= sc.stecode
union
        SELECT sc.stename,'Receipt' as dpssts,
               st.glccode, dp.slpno_s, sp.patno,
               decode(sp.slpfname,null,pt.patfname||' '||pt.patgname,sp.slpfname||' '||sp.slpgname) as patname,
               st.stndesc ,
               dp.dpsamt,to_char(dp.dpslcdate, 'DDMonYYYY','nls_date_language=ENGLISH'),st.stnid
        From   deposit dp, sliptx st, slip sp, patient pt, site sc
        Where  dp.DPSCDATE between to_date(v_StartDate, 'DD/MM/YYYY') and to_date(v_EndDate, 'DD/MM/YYYY')+1 and
               dp.dpssts IN ('T', 'R', 'W') and
               dp.dpsid = st.stnxref and
               st.stntype = 'X' and
               st.slpno = sp.slpno and
               sp.patno= pt.patno(+) and
               sp.stecode= v_SteCode and
               sp.stecode= sc.stecode;
RETURN outcur;
END NHS_RPT_RPTDEPSETTLE;
/