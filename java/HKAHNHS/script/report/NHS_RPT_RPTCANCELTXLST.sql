create or replace
FUNCTION "NHS_RPT_RPTCANCELTXLST"
(
  v_StartDate VARCHAR2,
  v_EndDate VARCHAR2,
  v_SteCode VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN OUTCUR FOR
        SELECT * 
        from (
                SELECT  SC.STENAME, 
                        DECODE(ST.STNSTS, 'U', 'Cancelled Items', 'Transferred Items') STNSTS,
                        DECODE(SP.SLPTYPE, 'O', 'Out Patient', 'I', 'In Patient', 'Day Case') SLPTYPE,
                        TO_CHAR(ST.STNTDATE, 'DD/MM/YYYY') STNTDATE, ST.GLCCODE,
                        SP.SLPFNAME, SP.SLPGNAME, PT.PATFNAME, SP.PATNO, PT.PATGNAME, 
                        ST.SLPNO, ST.ITMCODE, ST.STNDESC,                  
                        (-1 * ST.STNNAMT) AS STNNAMT, ST.USRID               
                FROM  SLIPTX ST, SLIP SP, PATIENT PT, SITE SC
                WHERE (ST.STNCDATE BETWEEN TO_DATE(V_STARTDATE, 'DD/MM/YYYY')
                                       AND TO_DATE(V_ENDDATE, 'DD/MM/YYYY')+1) 
                AND ST.STNSTS = 'T' 
                AND SP.STECODE = V_STECODE 
                AND ST.SLPNO = SP.SLPNO   
                AND SP.STECODE = SC.STECODE 
                AND SP.PATNO = PT.PATNO(+)
                
                UNION ALL
                
                SELECT  SC.STENAME,
                        DECODE(ST.STNSTS, 'U', 'Cancelled Items', 'Transferred Items') STNSTS,   
                        DECODE(SP.SLPTYPE, 'O', 'Out Patient', 'I', 'In Patient', 'Day Case') SLPTYPE,
                        TO_CHAR(ST.STNTDATE, 'DD/MM/YYYY') STNTDATE, ST.GLCCODE,    
                        SP.SLPFNAME, SP.SLPGNAME, PT.PATFNAME, SP.PATNO, PT.PATGNAME,    
                        ST.SLPNO, ST.ITMCODE, B.STNDESC,      
                        (-1 * ST.STNNAMT) AS STNNAMT, ST.USRID 
                FROM  SLIPTX ST, SLIPTX B, SLIP SP, PATIENT PT, SITE SC
                WHERE  (ST.STNCDATE BETWEEN TO_DATE(V_STARTDATE, 'DD/MM/YYYY')
                                    AND TO_DATE(V_ENDDATE, 'DD/MM/YYYY')+1) 
                AND ST.STNSTS = 'U' 
                AND SP.STECODE = V_STECODE 
                AND ST.SLPNO = SP.SLPNO            
                AND ST.SLPNO = B.SLPNO       
                AND ST.STNDESC = B.STNSEQ  
                AND SP.STECODE = SC.STECODE 
                AND SP.PATNO = PT.PATNO(+)
        )
        ORDER BY STNSTS, SLPTYPE, STNTDATE, GLCCODE ,SLPNO;
RETURN OUTCUR;
END NHS_RPT_RPTCANCELTXLST;
/