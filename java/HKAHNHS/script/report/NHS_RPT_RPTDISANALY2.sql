CREATE OR REPLACE FUNCTION NHS_RPT_RPTDISANALY2 (
  v_SteCode VARCHAR2,
  v_StartDate VARCHAR2,
  v_EndDate VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
SELECT to_date(v_StartDate,'dd-mm-yyyy') as DateRangeStart,
       to_date(v_EndDate, 'dd-mm-yyyy') as DateRangeEnd,
       sc.stename,
       sk.sckcode,
       sk.sckdesc,
       ds.destype,
       count(*) as cnt
FROM   inpat ip,
       dest ds,
       site sc,
       sick sk,
       sdisease sd,
       reg rg
WHERE  ip.inpddate>= to_date(v_StartDate, 'dd-mm-yyyy')
       and inpddate< to_date(v_EndDate, 'dd-mm-yyyy') + 1
       and ip.inpddate is not null
       and ip.inpid = rg.inpid
       and rg.regsts = 'N'
       and rg.stecode= v_SteCode
       and ip.sdscode  = sd.sdscode
       and sk.sckcode = sd.sckcode
       and sk.sckcode not like 'T%'
       and ip.descode = ds.descode
       and rg.stecode = sc.stecode
       and sd.SDSNEW = 0
GROUP BY
      sc.stename,
      sk.sckcode,
      sk.sckdesc,
      ds.destype
ORDER BY sk.sckcode;
RETURN outcur;
END NHS_RPT_RPTDISANALY2;
/
