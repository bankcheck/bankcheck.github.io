create or replace
FUNCTION NHS_RPT_RPTOPSLIP
(
  v_EndDate VARCHAR2,
  v_SteCode VARCHAR2,
  v_otp2  VARCHAR2,
  v_filter  VARCHAR2
)
  RETURN TYPES.CURSOR_TYPE
--  return VARCHAR2
AS
  outcur TYPES.cursor_type;
  SLIP_STATUS_OPEN VARCHAR2(1) := 'A';
  sqlStr VARCHAR2(5000);
BEGIN
  DELETE FROM diosliptemp;
  
  INSERT INTO diosliptemp
  select st.slpno, SUM(stnnamt) as netamt , 'N'
  From sliptx st
  Where
  (stncdate is null or stncdate >= to_date(v_EndDate,'DD/MM/YYYY') + 1)
  and stnsts in ('N','A')
  GROUP BY st.slpno
  HAVING SUM(STNNAMT) <> 0;
  
  IF v_otp2 = '1' THEN    
    sqlStr := 'SELECT
    sit.stename,
    s.doccode, s.slpno, s.patno,
    TO_CHAR(r.regdate,''DD/MM/YYYY'') AS regdate,
    p.patfname || '' '' || p.patgname as patname,
    sign(slppamt+slpdamt+slpcamt) as G,
    (slppamt+slpdamt+slpcamt) as amount,
    s.slpRemark, slpsts
    from slip s, reg r, patient p, site sit
    where s.slptype = ''O''
    and s.regid = r.regid (+)
    and (r.regtype = ''O'' or r.regid is null)
    and s.patno = p.patno (+)
    and s.stecode = sit.stecode
    and sit.stecode = '''||v_SteCode||'''';
    IF V_FILTER='1' THEN
    	sqlStr := sqlStr||' AND S.DOCCODE IN (SELECT DOCCODE FROM SPEC S, DOCTOR D WHERE S.SPCCODE=D.SPCCODE AND S.SPCCODE =''DENTIST'' AND DOCSTS = -1)';    
    ELSIF V_FILTER='2' THEN
      SQLSTR := SQLSTR||' AND S.DOCCODE NOT IN (SELECT DOCCODE FROM SPEC S, DOCTOR D WHERE S.SPCCODE=D.SPCCODE AND S.SPCCODE =''DENTIST'' AND DOCSTS = -1)';
    END IF;
    SQLSTR := SQLSTR||' and s.slpsts = '''||SLIP_STATUS_OPEN||
    ''' and s.slpno not in (select slpno from diosliptemp)				
    UNION 	
    select
    sit.stename,
    s.doccode, s.slpno, s.patno,
    TO_CHAR(r.regdate,''DD/MM/YYYY'') AS regdate,
    p.patfname || '' '' || p.patgname as patname,
    sign(slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) as G,
    (slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) as amount,
    s.slpRemark, slpsts
    from slip s, diosliptemp st, reg r, patient p, site sit where 
    s.Slpno = st.Slpno
    and s.slptype = ''O''
    and (r.regtype = ''O'' or r.regid is null)
    and s.regid = r.regid (+)
    and s.patno = p.patno (+)
    and s.stecode = sit.stecode
    AND sit.stecode = '''||v_SteCode ||'''';
    IF V_FILTER='1' THEN
    	sqlStr := sqlStr||' AND S.DOCCODE IN (SELECT DOCCODE FROM SPEC S, DOCTOR D WHERE S.SPCCODE=D.SPCCODE AND S.SPCCODE =''DENTIST'' AND DOCSTS = -1) ';    
    ELSIF v_filter='2' THEN
        sqlStr := sqlStr||' AND S.DOCCODE NOT IN (SELECT DOCCODE FROM SPEC S, DOCTOR D WHERE S.SPCCODE=D.SPCCODE AND S.SPCCODE =''DENTIST'' AND DOCSTS = -1) ';
    END IF;

    sqlStr := sqlStr||'ORDER BY g DESC,slpno ASC';  
  ELSE
    sqlStr := 'select
    sit.stename,
    s.doccode, s.slpno, s.patno,
    TO_CHAR(r.regdate,''DD/MM/YYYY'') AS regdate,
    p.patfname || '' '' || p.patgname as patname,
    sign(slppamt+slpdamt+slpcamt) as G,
    (slppamt+slpdamt+slpcamt) as amount,
    '''' as slpRemark, slpsts
    FROM slip s, reg r, patient p, site sit 
    where s.slptype = ''O''
    and s.regid = r.regid (+)
    and (r.regtype = ''O'' or r.regid is null)
    and s.patno = p.patno (+)
    and s.stecode = sit.stecode
    and sit.stecode = '''||v_SteCode||
    ''' and s.slpsts = '''||SLIP_STATUS_OPEN||
    ''' and s.slpno not in (select slpno from diosliptemp)
    UNION 	
    select
    sit.stename,
    s.doccode, s.slpno, s.patno,
    TO_CHAR(r.regdate,''DD/MM/YYYY'') AS regdate,
    p.patfname || '' '' || p.patgname as patname,
    sign(slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) as G,
    (slppamt+slpdamt+slpcamt - nvl(st.netamt,0)) as amount,
    '''' as slpRemark, slpsts	
    from slip s, diosliptemp st, reg r, patient p, site sit where 
    s.Slpno = st.Slpno
    and s.slptype = ''O''
    and (r.regtype = ''O'' or r.regid is null)
    and s.regid = r.regid (+)
    and s.patno = p.patno (+)
    and s.stecode = sit.stecode
    AND sit.stecode = '''||v_SteCode ||
    ''' order by g desc,slpno asc';  
  END IF;
  
OPEN OUTCUR FOR SQLSTR;
RETURN OUTCUR;
--return sqlStr;
END NHS_RPT_RPTOPSLIP;
/