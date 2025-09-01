CREATE OR REPLACE FUNCTION "NHS_RPT_RPTCSRREORDER"
(
  v_StartDate VARCHAR2,
  v_EndDate VARCHAR2,
  v_SteCode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
select
       wrdcode,
       itmcode,
       count(*),
       stndesc
from (select
     sTx.StnID,
     w.wrdcode,
     sTx.ItmCode,
     sTx.StnDesc
from SlipTx sTx,
     Slip s,
     bedHist bH,
     bed b,
     Room r,
     Ward w
where s.stecode = v_SteCode
           and sTx.STNCDATE >= to_date(v_StartDate, 'DD/MM/YYYY HH24:MI')
           and sTx.STNCDATE < to_date(v_EndDate, 'DD/MM/YYYY HH24:MI')
           and ((sTx.STNCDATE >= bH.BHSDATE And sTx.STNCDATE <= bH.BHSEDATE) or
               (sTx.STNCDATE >= bH.BHSDATE and bH.BHSEDATE is NULL))
           and sTx.STNSTS = 'N'
           and sTx.DSCCODE = 'CSRDSCCODE'
           and sTx.SLPNO = s.SLPNO
           and s.SLPTYPE = 'I'
           and s.REGID = bH.REGID
           and s.PATNO = bH.PATNO
           and bH.BEDCODE = b.BEDCODE
           and b.ROMCODE = r.ROMCODE
           and r.WRDCODE = w.WRDCODE

        Union
 select sTx.StnID,
        w.wrdcode,
        sTx.ItmCode,
        sTx.StnDesc
from SlipTx sTx,
     reg,
     inpat i,
     bed b,
     Room r,
     Ward w
Where r.stecode = v_SteCode
           and sTx.STNCDATE >= to_date(v_StartDate, 'DD/MM/YYYY HH24:MI')
           and sTx.STNCDATE < to_date(v_EndDate, 'DD/MM/YYYY HH24:MI')
           and sTx.STNSTS = 'N'
           and sTx.DSCCODE = 'CSRDSCCODE'
           and sTx.SLPNO = reg.SLPNO
           and reg.inpid = i.inpid
           and i.BEDCODE = b.BEDCODE
           and b.ROMCODE = r.ROMCODE
           and r.WRDCODE = w.WRDCODE)
 group by wrdcode, itmcode, stndesc
 order by wrdcode, itmcode, stndesc;
 
 RETURN OUTCUR;
END NHS_RPT_RPTCSRREORDER;
/
