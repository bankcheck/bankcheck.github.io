create or replace
FUNCTION NHS_RPT_REGMAINLANDMATERPATLST(
  v_SteCode VARCHAR2,
  v_StartDate VARCHAR2,
  v_EndDate VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
SELECT s.slpNo,
       p.patFname|| ' ' || p.patGname AS EName,
       SUBSTR(p.patidno,-4) AS patId,
       to_char(TRUNC(p.patbdate),'DD/MM/YYYY') AS patbdate,
       to_char(s.edc,'DD/MM/YYYY') edc
FROM slip s,
     patient p
Where s.PatNo = p.PatNo
      AND s.firstprtdt>=TO_DATE(v_StartDate,'dd/mm/yyyy')
      AND s.firstprtdt<TO_DATE(v_EndDate,'dd/mm/yyyy')+1
      AND s.steCode=v_SteCode
order by s.edc,EName;      
RETURN outcur;
END NHS_RPT_REGMAINLANDMATERPATLST;
/