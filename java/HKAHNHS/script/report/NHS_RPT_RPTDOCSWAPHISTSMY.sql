
  CREATE OR REPLACE FUNCTION "NHS_RPT_RPTDOCSWAPHISTSMY" (
  v_SteCode VARCHAR2,
  v_StartDate VARCHAR2,
  v_EndDate varchar2
)
  RETURN Types.cursor_type
AS
  outcur types.cursor_type;
BEGIN
  OPEN outcur FOR   
    select   i.doccode_a as doccode, d.docfname, d.docgname,  
               count(regid) as adm, 0 as tot, 0 as day, 0 as dshg, 0 as Rec, 0 as Tran  
             From  
               reg r, inpat i, doctor d  
             Where  
               r.regid in (  
                           select  
                               r.RegID  
                           From  
                               dochist dh, reg r  
                           Where  
                               dh.dhsdate > = to_date(v_StartDate,'DD/MM/YYYY')  
                               and dh.dhsdate < to_date(v_EndDate,'DD/MM/YYYY') + 1  
                               and dh.dhssts = 'N'  
                               and dh.regid = r.regid  
                               and r.regtype = 'I'  
                               and r.regsts = 'N'  
                           ) 
               and r.stecode = v_SteCode  
               and r.inpid = i.inpid  
               and i.doccode_a = d.doccode  
             Group By  
               i.DocCode_a , d.DocFName, d.DocGname  
   union 
             select  
              dh.doccode,d.docfname,d.docgname,  
               0 as adm, count(dh.dhsid) as tot, sum(trunc(dh.dhsedate) - trunc(dh.dhsdate) ) as day, 0 as dshg, 0 as Rec, 0 as Tran   
             From  
               dochist dh, reg r, doctor d  
             Where  
               dh.dhsdate > = to_date (v_StartDate,'DD/MM/YYYY')  
               and dh.dhsedate < to_date (v_EndDate,'DD/MM/YYYY') + 1  
               and dh.dhsedate is not null  
               and dh.regid = r.regid  
               and r.regtype = 'I'  
               and r.regsts = 'N'  
               and r.stecode = v_SteCode  
               and dh.doccode = d.doccode  
             Group By  
               dh.DocCode , d.DocFName, d.DocGname  
 Union 
             select  
              dh.doccode, d.docfname, d.docgname,  
               0 as adm, count(dh.dhsid) as tot, sum(to_date (v_EndDate,'DD/MM/YYYY') - trunc(dh.dhsdate)) as day, 0 as dshg, 0 as Rec, 0 as Tran   
             From  
               dochist dh, reg r, doctor d  
             Where  
               dh.dhsdate > = to_date (v_StartDate,'DD/MM/YYYY')  
               and dh.dhsdate <  to_date (v_EndDate,'DD/MM/YYYY') + 1  
               and dh.dhsedate is null  
               and dh.regid = r.regid  
               and r.regtype = 'I'  
               and r.regsts = 'N'  
               and r.stecode = v_SteCode  
               and dh.doccode = d.doccode  
             Group By  
                dh.DocCode , d.DocFName, d.DocGname  
Union 
             select  
               dh.doccode, d.docfname, d.docgname,  
               0 as adm, count(dh.dhsid) as tot, sum(to_date(v_EndDate,'DD/MM/YYYY') - trunc(dh.dhsdate)) as day, 0 as dshg, 0 as Rec, 0 as Tran   
             From  
               dochist dh, reg r, doctor d  
             Where  
               dh.dhsdate > = to_date (v_StartDate,'DD/MM/YYYY')  
               and dh.dhsdate < to_date (v_EndDate,'DD/MM/YYYY') + 1  
               and dh.dhsedate >= to_date (v_EndDate,'DD/MM/YYYY') + 1  
               and dh.dhsedate is not null  
               and dh.regid = r.regid  
               and r.regtype = 'I'  
               and r.regsts = 'N'  
               and  r.stecode = v_SteCode  
               and dh.doccode = d.doccode  
             Group By  
            dh.DocCode , d.DocFName, d.DocGname  
  Union 
             select  
                dh.doccode, d.docfname, d.docgname,  
               0 as adm, count(dh.dhsid) as tot, sum( trunc(dh.dhsedate) - to_date(v_StartDate,'DD/MM/YYYY')) as day, 0 as dshg, 0 as Rec, 0 as Tran   
             From  
               dochist dh, reg r,doctor d  
             Where  
               dh.dhsdate < to_date (v_StartDate,'DD/MM/YYYY')  
               and dh.dhsedate >= to_date (v_StartDate,'DD/MM/YYYY')  
               and dh.dhsedate < to_date (v_EndDate,'DD/MM/YYYY') + 1  
               and dh.dhsedate is not null  
               and dh.regid = r.regid  
               and r.regtype = 'I'  
               and r.regsts = 'N'  
             and r.stecode = v_SteCode  
               and dh.doccode = d.doccode  
             Group By   
               dh.DocCode , d.DocFName, d.DocGname  
 Union 
             select  
              dh.doccode, d.docfname, d.docgname,  
               0 as adm, count(dh.dhsid) as tot , sum(to_date(v_EndDate,'DD/MM/YYYY') - to_date(v_StartDate,'DD/MM/YYYY')) as day, 0 as dshg, 0 as Rec, 0 as Tran   
             From  
               dochist dh, reg r, doctor d  
             Where  
               dh.dhsdate < to_date (v_StartDate,'DD/MM/YYYY')  
               and dh.dhsedate is null  
               and dh.regid = r.regid  
               and r.regtype = 'I'  
               and r.regsts = 'N'  
               and r.stecode = v_SteCode  
               and dh.doccode = d.doccode  
             Group By  
                dh.DocCode , d.DocFName, d.DocGname  
Union 
             select  
               dh.doccode, d.docfname, d.docgname,  
               0 as adm, count(dh.dhsid) as tot, sum(to_date(v_EndDate,'DD/MM/YYYY') - to_date(v_StartDate,'DD/MM/YYYY') ) as day, 0 as dshg, 0 as Rec, 0 as Tran   
             From  
               dochist dh, reg r, doctor d  
             Where  
               dh.dhsdate < to_date (v_StartDate,'DD/MM/YYYY')  
               and dh.dhsedate >  to_date (v_EndDate,'DD/MM/YYYY')  
               and dh.dhsedate is not null  
               and dh.regid = r.regid  
               and r.regtype = 'I'  
               and r.regsts = 'N'  
               and r.stecode = v_SteCode  
               and dh.doccode = d.doccode  
             Group By  
              dh.DocCode , d.DocFName, d.DocGname  
 Union 
             select  
              dh.doccode, d.docfname, d.docgname,  
               0 as adm, 0 as total, 0 as Day  ,count(dh.dhsid) as dshg, 0 as Rec, 0 as Tran  
             From  
               dochist dh, reg r, inpat i, doctor d  
             Where  
               dh.dhsedate > to_date(v_StartDate,'DD/MM/YYYY')  
               and dh.dhsedate < to_date(v_EndDate,'DD/MM/YYYY') + 1  
               and dh.dhsedate is not null  
               and dh.regid = r.regid  
               and r.regtype = 'I'  
               and r.regsts = 'N'  
              and r.stecode = v_SteCode  
               and r.inpid = i.inpid  
               and i.inpddate is not null  
               and i.inpddate > to_date(v_StartDate,'DD/MM/YYYY')  
               and i.inpddate < to_date(v_EndDate,'DD/MM/YYYY') + 1  
               and dh.doccode = i.doccode_d  
               and dh.doccode = d.doccode  
             Group By 
               dh.DocCode , d.DocFName, d.DocGname  
union 
             select  
                  dh.doccode, d.docfname, d.docgname,  
               0 as adm, 0 as tot, 0 as day, 0 as dshg ,count(*) as Rec, 0 as Tran  
             From
               (select  
                   dh2.dhsid  
               From  
                   dochist dh1, dochist dh2  
               Where  
                   dh1.dhsdate > = to_date(v_StartDate,'DD/MM/YYYY')  
                   and dh1.dhsdate < to_date(v_EndDate,'DD/MM/YYYY') + 1  
                   and dh1.regid = dh2.regid  
                   and dh1.dhsid < dh2.dhsid    
                   and dh2.dhsdate > = to_date(v_StartDate,'DD/MM/YYYY')  
                   and dh2.dhsdate < to_date(v_EndDate,'DD/MM/YYYY') + 1 
               Group By  
                   dh2.dhsid  
               )a, dochist dh, reg r, inpat i, doctor d 
             Where  
               dh.dhsid = a.dhsid  
               and r.regtype = 'I'  
               and r.regsts = 'N'  
               and dh.regid = r.regid  
               and r.inpid = i.inpid  
               and r.stecode = v_SteCode  
               and r.doccode = d.doccode  
             Group By  
               dh.DocCode , d.DocFName, d.DocGname  
union 
             select  
               dh.doccode, d.docfname, d.docgname,  
               0 as adm, 0 as tot, 0 as day, 0 as dshg ,0 as Rec, count(*) as tran  
             From 
               (select  
                   dh1.dhsid  
               From  
                   dochist dh1, dochist dh2  
               Where  
                   dh1.dhsdate > = to_date(v_StartDate,'DD/MM/YYYY')  
                   and dh1.dhsdate < to_date(v_EndDate,'DD/MM/YYYY') + 1 
                   and dh1.regid = dh2.regid  
                   and dh1.dhsid < dh2.dhsid  
               Group By  
                   dh1.dhsid  
               )a, dochist dh, reg r, inpat i, doctor d  
             Where  
               dh.dhsid = a.dhsid  
               and r.regtype = 'I'  
               and r.regsts = 'N'  
               and dh.regid = r.regid  
               and r.inpid = i.inpid  
               and r.stecode = v_SteCode  
               and r.doccode = d.doccode 
             Group By  
                dh.DocCode , d.DocFName, d.DocGname ;               
  RETURN OUTCUR;
END NHS_RPT_RPTDOCSWAPHISTSMY;
/
 
