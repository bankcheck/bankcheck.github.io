create or replace
FUNCTION NHS_RPT_RPTIPSLIP
(v_EndDate VARCHAR2,
  v_SteCode VARCHAR2,
  v_otp2  VARCHAR2  
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  DELETE FROM diosliptemp;
  
  INSERT INTO diosliptemp
  select st.slpno, SUM(stnnamt) as netamt , 'N'
  From sliptx st
  Where
  (stncdate is null or stncdate >= to_date(v_EndDate,'DD/MM/YYYY') + 1)
  and stnsts in ('N','A')
  group by st.slpno
  having sum(stnnamt) <> 0;

  IF v_otp2 = '1' THEN
    OPEN outcur FOR
    select
    sit.stename, s.doccode, s.slpno, s.patno, TO_CHAR(r.regdate,'DD/MM/YYYY') AS regdate,
    p.patfname || ' ' || p.patgname AS patname, 
    (slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) as amount, i.bedcode, rm.wrdcode, TO_CHAR(i.inpddate,'DD/MM/YYYY') as ddate,
    max(s.slpRemark) as slpRemark, slpsts,s.arccode
    from
    slip s, diosliptemp st, reg r, patient p, site sit, inpat i, bed b, room rm
    where
    r.regtype = 'I'
    and s.slptype = 'I'
    AND s.slpno = st.slpno (+) AND s.regid = r.regid (+) 
    and s.stecode = v_SteCode
    and s.patno = p.patno (+) and s.stecode = sit.stecode
    and b.romcode = rm.romcode and i.bedcode = b.bedcode
    and i.inpid = r.inpid
    GROUP BY sit.stename, s.doccode, s.slpno, s.patno, TO_CHAR(r.regdate,'DD/MM/YYYY'), p.patfname || ' ' || p.patgname, (slppamt+slpdamt+slpcamt - nvl(st.netamt,0)), i.bedcode, rm.wrdcode, TO_CHAR(i.inpddate,'DD/MM/YYYY'), slpsts, s.arccode
    HAVING NOT ((s.slpsts = 'C' OR s.slpsts = 'R') AND (slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) = 0)
    ORDER BY 
    (DECODE(TO_CHAR(i.inpddate,'DD/MM/YYYY'),NULL,'Current In-Pat','Discharged In-Pat')),
    (CASE WHEN (slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) > 0 THEN 1
         WHEN (slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) = 0 THEN 0
         ELSE -1 
    END),
    (slppamt+slpdamt+slpcamt - nvl(st.netamt,0));
  ELSE
    OPEN outcur FOR
    SELECT
    sit.stename, s.doccode, s.slpno, s.patno, TO_CHAR(r.regdate,'DD/MM/YYYY') AS regdate,
    p.patfname || ' ' || p.patgname AS patname, 
    (slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) as amount, i.bedcode, rm.wrdcode, TO_CHAR(i.inpddate,'DD/MM/YYYY') as ddate,
    '' as slpRemark, slpsts,s.arccode
    from
    slip s, diosliptemp st, reg r, patient p, site sit, inpat i, bed b, room rm
    where
    r.regtype = 'I'
    and s.slptype = 'I'
    AND s.slpno = st.slpno (+) AND s.regid = r.regid (+) 
    and s.stecode = v_SteCode
    and s.patno = p.patno (+) and s.stecode = sit.stecode
    and b.romcode = rm.romcode and i.bedcode = b.bedcode
    and i.inpid = r.inpid
    group by
    (slppamt+slpdamt+slpcamt - nvl(st.netamt,0)),
    s.slpno, s.doccode, r.regdate, p.patfname || ' ' || p.patgname, sit.stename, s.patno
    , s.slpfname, s.slpgname, i.bedcode, rm.wrdcode, i.inpddate , slpsts,s.arccode
    having not ((s.slpsts = 'C' or s.slpsts = 'R') and (slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) = 0)
    ORDER BY 
    (DECODE(TO_CHAR(i.inpddate,'DD/MM/YYYY'),NULL,'Current In-Pat','Discharged In-Pat')),
    (CASE WHEN (slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) > 0 THEN 1
         WHEN (slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) = 0 THEN 0
         ELSE -1 
    END),
    (slppamt+slpdamt+slpcamt - nvl(st.netamt,0));
  END IF;
RETURN outcur;
END NHS_RPT_RPTIPSLIP;
/