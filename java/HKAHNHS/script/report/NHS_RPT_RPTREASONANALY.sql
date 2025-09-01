
  CREATE OR REPLACE FUNCTION "NHS_RPT_RPTREASONANALY" (
  v_SteCode VARCHAR2,
  v_SDate VARCHAR2, 
  v_EDate VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
  
SELECT
      sc.stename,
      rs.rsncode,
      rs.rsndesc,
      ds.destype, count(*) as cnt,
      to_date( v_SDate,'dd-mm-yyyy') as DateRangeStart,
      to_date(v_EDate, 'dd-mm-yyyy') as DateRangeEnd
FROM
    inpat ip,
    reg rg,
    sreason sr,
    reason rs,
    dest ds,
    site sc
WHERE
     ip.inpddate>= to_date(v_SDate, 'dd-mm-yyyy')
     and inpddate< to_date(v_EDate, 'dd-mm-yyyy') + 1
     and ip.inpddate is not null
     and ip.inpid = rg.inpid
     and rg.regsts= 'N'
     and rg.stecode=v_SteCode
     and ip.rsncode  = sr.srsncode
     and sr.rsncode = rs.rsncode
     and ip.descode = ds.descode
     and rg.stecode = sc.stecode
GROUP BY
       sc.stename,
       rs.rsncode,
       rs.rsndesc,
       ds.destype;
       
  RETURN outcur;
END NHS_RPT_RPTREASONANALY;
/
 
