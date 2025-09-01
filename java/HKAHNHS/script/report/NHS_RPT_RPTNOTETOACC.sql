create or replace
FUNCTION NHS_RPT_RPTNOTETOACC(
  v_StartDate VARCHAR2,
  v_EndDate VARCHAR2,
  v_SteCode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
select ct.ctxmeth as ctxmeth,
      s.slptype as  slptype,
        'A' as ctxsts,
        s.Patno as patno, decode(s.patno, null, s.Slpfname || ' ' || s.Slpgname, p.Patfname || ' ' || p.Patgname) patname,
                  ct.slpno as slpno, marpayee, maradd1,maradd2, maradd3,country,(-1)*ctxamt ctxamt, marreason,ct.cshcode as usrid
                  from cashtx ct, paycode pc, slip s , misaddref m, patient p
                  where   ct.stecode= v_SteCode
                  and (ct.ctxcdate >= to_date(v_StartDate,'DD/MM/YYYY'))
                  and (ct.ctxcdate < to_date(v_EndDate,'DD/MM/YYYY') + 1)
                  and ct.ctxmeth = pc.paytype
                  and pc.paynotear = -1
                  and ct.Slpno = s.Slpno (+)
                  and ct.ctxid = m.tabid
                  and ct.CTXTYPE =  'P'
                  and ct.ctxmeth =  'Q'
                  and ct.ctxsts<> 'R'
                  and s.patno = p.patno (+)
UNION
select ct.ctxmeth as ctxmeth,
s.slptype as  slptype,
'R' as ctxsts,s.Patno as patno, decode(s.patno, null, s.Slpfname || ' ' || s.Slpgname, p.Patfname || ' ' || p.Patgname) patname,
                  ct.slpno as slpno, marpayee, maradd1,maradd2, maradd3, country,(-1)*ctxamt ctxamt, marreason,ct.cshcode as usrid
                  from cashtx ct, paycode pc, slip s , misaddref m, patient p
                  where   ct.stecode= v_SteCode
                  and (ct.ctxcdate >= to_date(v_StartDate,'DD/MM/YYYY'))
                  and (ct.ctxcdate < to_date(v_EndDate,'DD/MM/YYYY') + 1)
                  and ct.ctxmeth = pc.paytype
                  and pc.paynotear = -1
                  and ct.Slpno = s.Slpno (+)
                  and ct.ctxid = m.tabid
                  and ct.CTXTYPE =   'P'
                  and ct.ctxmeth =   'Q'
                  and ct.ctxsts =  'R'
                  and s.patno = p.patno (+)
                  order by ctxmeth,slptype,ctxsts,patno,patname,slpno;
RETURN outcur;
END NHS_RPT_RPTNOTETOACC;
/
