
  CREATE OR REPLACE FUNCTION "NHS_RPT_RPTLOCCENSUS" (
  v_SteCode VARCHAR2,
  v_SDate VARCHAR2, 
  v_EDate VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR
select 
t1.loccode,t1.dstcode,t1.locname,t1.dstname,t1.regtype,t1.NoOfPat,t1.DistinctNoOfPat,t2.SumOfIP,t2.SumOfOP,t2.SumOfDayCase
from
      (SELECT    
               p.loccode ,l.dstcode ,l.locname ,dst.dstname ,r.regtype ,
                count(r.regid) as NoOfPat ,
                count(distinct r.patno) as DistinctNoOfPat 
      FROM 
               patient p, reg r, location l, district dst 
      WHERE 
               r.regdate>= to_date(v_SDate, 'dd-mm-yyyy') 
             and r.regdate < to_date(v_EDate,'dd-mm-yyyy') + 1 
             AND r.stecode=v_SteCode
             AND r.regsts='N'  
             AND r.patno= p.patno (+) 
             AND p.loccode= l.loccode 
             AND l.dstcode= dst.dstcode  
             GROUP BY p.loccode ,l.dstcode ,l.locname ,dst.dstname ,r.regtype ) t1, 
             (select 
sum(decode(regtype,'I',NoOfPat,0)) SumOfIP,
sum(decode(regtype,'O',distinctnoofpat,0)) SumOfOP,sum(decode(regtype,'D',NoOfPat,0)) SumOfDayCase
from
      (SELECT    
               p.loccode ,l.dstcode ,l.locname ,dst.dstname ,r.regtype ,
                count(r.regid) as NoOfPat ,
                count(distinct r.patno) as DistinctNoOfPat 
      FROM 
               patient p, reg r, location l, district dst 
      WHERE 
               r.regdate>= to_date(v_SDate, 'dd-mm-yyyy') 
             and r.regdate < to_date(v_EDate,'dd-mm-yyyy') + 1 
             AND r.stecode= v_SteCode
             AND r.regsts='N'  
             AND r.patno= p.patno (+) 
             AND p.loccode= l.loccode 
             AND l.dstcode= dst.dstcode  
             GROUP BY p.loccode ,l.dstcode ,l.locname ,dst.dstname ,r.regtype )) t2
             order by t1.dstname,t1.locname;
                   
  RETURN OUTCUR;
END NHS_RPT_RPTLOCCENSUS;
/
 
