CREATE OR REPLACE FUNCTION NHS_RPT_RPTOUTSTDGDEPOSII(
  v_stecode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
 SELECT
      dp.slpno_s,
      dp.dpsamt,
      to_char(dp.dpscdate,'dd/mm/yyyy')dpscdate,
      dp.dpssts,
      s.patno,
      decode(s.slpfname,null,p.patfname||' '||p.patgname,s.slpfname||' '||s.slpgname) as slpfname,
      s.slpgname,
      st.stndesc,
      st.glccode,
      p.patfname,
      p.patgname,
      sit.stename
FROM
    deposit dp,
    slip s,
    sliptx st,
    patient p,
    site sit
WHERE
     dp.dpssts IN ('A', 'N')
     and dp.dpsid = st.stnxref
     and dp.slpno_s= s.slpno
     and st.slpno = s.slpno
     and s.stecode= v_stecode
     and s.patno= p.patno
     and s.stecode= sit.stecode;
RETURN OUTCUR;
END NHS_RPT_RPTOUTSTDGDEPOSII;
/
