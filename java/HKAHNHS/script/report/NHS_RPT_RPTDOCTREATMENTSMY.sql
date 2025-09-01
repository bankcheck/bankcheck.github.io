
  CREATE OR REPLACE FUNCTION "NHS_RPT_RPTDOCTREATMENTSMY" 
(
  v_SteCode VARCHAR2,
  v_StartDate VARCHAR2,
  v_EndDate varchar2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR   
   select 
    doccode,docfname,docgname,patno,patfname, patgname,
         decode(to_char(sysdate,'yyyy'),to_char(patbdate,'yyyy'),0,
         decode(sign(to_number(to_char(sysdate,'MM'))-to_number(to_char(patbdate,'MM'))),-1,(to_number(to_char(sysdate,'yyyy'))-to_number(to_char(patbdate,'yyyy'))-1),0,
         decode(sign(to_number(to_char(sysdate,'dd'))-to_number(to_char(patbdate,'dd'))),-1,(to_number(to_char(sysdate,'yyyy'))-to_number(to_char(patbdate,'yyyy'))-1),(to_number(to_char(sysdate,'yyyy'))-to_number(to_char(patbdate,'yyyy')))),(to_number(to_char(sysdate,'yyyy'))-to_number(to_char(patbdate,'yyyy'))))) age,to_char(dhsdate,'yyyymmdd') dhsdate,to_char(dhsedate,'yyyymmdd') dhsedate, decode((trunc(dhsedate,'dd')-trunc(dhsdate,'dd')),0,1,(trunc(dhsedate,'dd')-trunc(dhsdate,'dd'))) length,sum(stnnamt) as TotalCharges 
      From 
         ( select 
                d.docfname docfname,d.docgname docgname, dh.DocCode doccode,dh.dhsdate dhsdate,dh.dhsedate dhsedate, dh.PatNo patno,p.patfname patfname, p.patgname patgname,p.patbdate patbdate , st.stnnamt stnnamt
             From 
                 dochist dh,slip s,sliptx st , patient p,doctor d 
             Where
                dh.patno = s.patno 
                 and dh.regid = s.regid 
                 and s.slpno = st.slpno 
                 and sign(dh.dhsdate-to_date(v_EndDate, 'DD/MM/YYYY')-1)+
                DECODE(sign(to_date(v_StartDate, 'DD/MM/YYYY')-dh.dhsedate),1,0,-1)=-2    
                 AND dh.dhsedate IS NOT NULL   
                 AND decode(st.stntype,'S',0,'P',0,'R',0,1)=1
                 and dh.doccode = st.doccode
                 and dh.doccode= d.doccode
                 and dh.patno = p.patno
                 and s.stecode=v_SteCode)
Group By doccode,docfname,docgname,patno,patfname, patgname,patbdate,dhsdate,dhsedate
order by doccode,patno  ;                
  RETURN OUTCUR;
END NHS_RPT_RPTDOCTREATMENTSMY;
/
 
