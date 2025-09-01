
  CREATE OR REPLACE FUNCTION "NHS_RPT_RPTDISDETAIL" (
  v_SteCode VARCHAR2,
  v_StartDate VARCHAR2,
  v_EndDate varchar2,
  v_SckCode varchar2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR   
  SELECT        sk.sckcode, sk.sckdesc,
                 sum(decode(ds.destype,'H',1,0)) as cntHome,
                 sum(decode(ds.destype,'P',1,0)) as cntHospital,
                 sum(decode(ds.destype,'D',1,0)) as cntDeath,
                 sd.SDSCODE, sd.SDSDESC  
                 
        FROM inpat ip, dest ds, sick sk, sdisease sd, reg rg 
        WHERE   ip.inpddate>= to_date(v_StartDate, 'dd-mm-yyyy') 
              and ip.inpddate< to_date(v_EndDate, 'dd-mm-yyyy') + 1 
                  and  ip.inpddate is not null
                  and ip.inpid = rg.inpid 
                  and rg.regsts = 'N' 
                  and rg.stecode= v_SteCode
                  and ip.sdscode  = sd.sdscode 
                  and ip.descode = ds.descode 
                  and sk.sckcode = sd.sckcode 
                  and sd.sckcode = v_SckCode 
                  and sd.SDSNEW = -1
                  GROUP BY  sk.sckcode, sk.sckdesc, sd.SDSCODE, sd.SDSDESC ;                    
  RETURN OUTCUR;
END NHS_RPT_RPTDISDETAIL;
/
 
