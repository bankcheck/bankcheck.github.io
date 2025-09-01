create or replace
FUNCTION "NHS_RPT_RPTARAGINGSMY" (
  v_SyDate VARCHAR2,
  v_ArCode VARCHAR2,
  v_SteCode varchar2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN OUTCUR FOR
  SELECT ARCCODE, ARCNAME, PTYPE, SUM(CUR) AS CUR, SUM(DAY30) AS DAY30, SUM(DAY60) AS DAY60, SUM(DAY90) AS DAY90, SUM(DAY120) AS DAY120
  FROM (
  SELECT
  at.arccode, am.arcname, at.patno as pnum ,
  decode(at.patno, null,sp.slpfname,pt.patfname) as fname ,
  decode(at.patno,null,sp.slpgname,pt.patgname) as gname ,
  AT.SLPNO AS REF, AT.ATXCDATE ,
  (CASE WHEN
  (TO_DATE(v_SyDate, 'dd/mm/yyyy') - AT.ATXCDATE) < 30
  then
  AT.ATXAMT - AT.ATXSAMT 
  ELSE
  0 END) AS CUR, 
  (CASE WHEN
  (TO_DATE(v_SyDate, 'dd/mm/yyyy') - AT.ATXCDATE) >= 30 AND 
  (TO_DATE(v_SyDate, 'dd/mm/yyyy') - AT.ATXCDATE) < 60
  then
  AT.ATXAMT - AT.ATXSAMT 
  ELSE
  0 END) AS DAY30, 
  (CASE WHEN
  (TO_DATE(v_SyDate, 'dd/mm/yyyy') - AT.ATXCDATE) >= 60 AND 
  (TO_DATE(v_SyDate, 'dd/mm/yyyy') - AT.ATXCDATE) < 90
  then
  AT.ATXAMT - AT.ATXSAMT 
  ELSE
  0 END) AS day60,
  (CASE WHEN
  (TO_DATE(v_SyDate, 'dd/mm/yyyy') - AT.ATXCDATE) >= 90 AND 
  (TO_DATE(v_SyDate, 'dd/mm/yyyy') - AT.ATXCDATE) < 120
  then
  AT.ATXAMT - AT.ATXSAMT 
  ELSE
  0 END) AS DAY90,
  (CASE WHEN
  (TO_DATE(v_SyDate, 'dd/mm/yyyy') - AT.ATXCDATE) >= 120
  then
  AT.ATXAMT - AT.ATXSAMT 
  ELSE
  0 END) AS day120,
  SC.STENAME, SP.SLPTYPE AS PTYPE ,
  to_date(v_SyDate, 'dd/mm/yyyy') - at.atxcdate as age  
  FROM 
  SITE SC, ARTX AT, ARCODE AM, SLIP SP, PATIENT PT 
  WHERE (AM.ARCCODE= V_ARCODE OR V_ARCODE IS NULL)
  AND am.stecode= v_SteCode 
  AND at.arccode = am.arccode 
  AND at.atxsts = 'N' 
  AND at.atxamt - at.atxsamt <> 0 
  AND at.slpno = sp.slpno(+) 
  AND AM.STECODE = SC.STECODE 
  AND AT.PATNO = PT.PATNO(+)
  )
  GROUP BY ARCCODE, ARCNAME, PTYPE
  ORDER BY ARCCODE, PTYPE;
RETURN OUTCUR;
END NHS_RPT_RPTARAGINGSMY;
/