create or replace
FUNCTION NHS_RPT_RPTIPSTATANALYSIS2006(
  v_SteCode VARCHAR2,
  v_StartDate VARCHAR2,
  v_EndDate VARCHAR2
)
  RETURN Types.cursor_type
AS
  outcur TYPES.cursor_type;
  v_bedCode BED.BEDCODE%TYPE;
BEGIN

  SELECT param1
  into v_bedCode
  FROM sysparam
  where parcde='NurseryBed';

  OPEN outcur FOR
SELECT t1.spccode,t1.spcname,t1.fg,nvl(t2.NOOFDISCHARGED,0) AS NOOFDISCHARGED,nvl(t3.NOOFMID,0) AS NOOFMID,nvl(t4.NOOF24,0) AS NOOF24,nvl(t5.noofdeath,0) AS NOOF_DEATH
from
(SELECT A.SPCCODE,A.SPCNAME,Z1.FG
FROM spec A,(
SELECT 'A' AS FG
FROM DUAL
UNION
SELECT 'B' AS FG
FROM DUAL
UNION
SELECT 'C' AS FG
FROM DUAL) z1) t1,(
SELECT SPCCODE,FG,NOOFDISCHARGED FROM (
-- START UNION t2.1
select d.spccode,'A' as FG,COUNT(*) AS NoOfDischarged
From inpat i, reg r, doctor d,Patient p,bed b
WHERE i.bedcode=b.bedcode
AND i.bedcode NOT LIKE v_bedCode
AND  r.regtype = 'I'
AND r.inpid = i.inpid
AND r.regsts = 'N'
and r.stecode= v_SteCode
and i.inpddate >= to_date(v_StartDate,'DD/MM/YYYY')
AND i.inpddate < to_date(v_EndDate,'DD/MM/YYYY') + 1
AND r.patno=p.patno
AND i.doccode_d = d.doccode
AND i.sdscode IS NOT NULL
and r.regnb=0
GROUP BY d.spccode, 'A'
-- END UNION t2.1
UNION
-- START UNION t2.2
SELECT  spccode,'B' AS FG,COUNT(*) AS NoOfDischarged
FROM (
--START UNION t2.2.1
SELECT d.spccode, r.regid
From inpat i, reg r, doctor d,Patient p,bed b
WHERE i.bedcode=b.bedcode
AND i.bedcode LIKE v_bedCode
AND  r.regtype = 'I'
AND r.inpid = i.inpid
AND r.regsts = 'N'
and r.stecode= v_SteCode
AND i.inpddate >= to_date(v_StartDate,'DD/MM/YYYY')
and i.inpddate < to_date(v_EndDate,'DD/MM/YYYY') + 1
AND r.patno=p.patno
AND i.doccode_d = d.doccode
AND i.sdscode IS NOT NULL
AND trunc(p.PATBDATE)<>trunc(r.regdate)
-- END UNION t2.2.1
) tmp
GROUP BY spccode
-- END UNION t2.2
UNION
-- START UNION t2.3
SELECT spccode,'C' AS FG,COUNT(*) AS NoOfDischarged
FROM (
-- START UNION t2.3.1
SELECT d.spccode, r.regid
From inpat i, reg r, doctor d,Patient p
WHERE r.regtype = 'I'
AND r.inpid = i.inpid
AND r.regsts = 'N'
and r.stecode= v_SteCode
AND i.inpddate >= to_date(v_StartDate,'DD/MM/YYYY')
and i.inpddate < to_date(v_EndDate,'DD/MM/YYYY') + 1
AND r.patno=p.patno
AND i.doccode_d = d.doccode
AND trunc(r.regdate)=trunc(p.PATBDATE)
AND i.sdscode is not null
AND r.regnb=-1
-- END UNION t2.3.1
) tmp
-- END UNION t2.3
GROUP BY spccode)
) t2,(
SELECT spccode,fg,noofmid FROM (
-- START UNION t3.1
select spccode, 'A' as FG,sum(DECODE(cnt, 0, 1, cnt)) as Noofmid
FROM (
-- START UNION t3.1.1
select d.spccode, dh.regid, i.inpddate, dh.dhsdate, dh.dhsedate,
trunc(least(nvl(dh.dhsedate, to_date(v_EndDate,'DD/MM/YYYY')), to_date(v_EndDate,'DD/MM/YYYY'))) 
-  trunc(greatest(to_date(v_StartDate,'DD/MM/YYYY')-1, nvl(dh.dhsdate, to_date(v_StartDate,'DD/MM/YYYY')-1))) as cnt
From dochist dh, doctor d, reg r, inpat i,patient p,bed b
WHERE i.bedcode=b.bedcode
AND i.bedcode NOT LIKE v_bedCode
AND dh.DocCode = d.DocCode
AND dh.regid = r.regid (+)
AND r.regsts = 'N'
and r.stecode= v_SteCode
and dh.dhsdate <= TO_DATE(TO_CHAR(TRUNC(TO_DATE(v_EndDate,'DD/MM/YYYY')),'DD/MM/YYYY')||' 23:59:59','DD/MM/YYYY :HH24:MI:SS')
and (dh.dhsedate is null or dh.dhsedate >= to_date(v_StartDate,'DD/MM/YYYY'))
AND  p.patno=r.patno
and i.inpddate is not null
AND trunc(r.regdate)<>trunc(p.PATBDATE)
AND r.inpid = i.inpid
and (trunc(i.inpddate) >= to_date(v_StartDate,'DD/MM/YYYY'))
and (i.sdscode is not null or (i.sdscode is null
and (trunc(i.inpddate)) > to_date(v_EndDate,'DD/MM/YYYY')))
AND trunc(r.regdate) <> trunc(i.inpddate)
-- END UNION t3.1.1
UNION
-- START UNION t3.1.2
select d.spccode, dh.regid, i.inpddate, dh.dhsdate, dh.dhsedate,
trunc(least(nvl(dh.dhsedate, to_date(v_EndDate,'DD/MM/YYYY')), to_date(v_EndDate,'DD/MM/YYYY'))) 
- trunc(greatest(to_date(v_StartDate,'DD/MM/YYYY')-1, nvl(dh.dhsdate, to_date(v_StartDate,'DD/MM/YYYY')-1))) as cnt
From dochist dh, doctor d, reg r, inpat i,patient p,bed b
WHERE i.bedcode=b.bedcode
AND i.bedcode NOT LIKE v_bedCode
AND dh.DocCode = d.DocCode
AND dh.regid = r.regid (+)
AND r.regsts = 'N'
and r.stecode= v_SteCode
and dh.dhsdate <= TO_DATE(TO_CHAR(TRUNC(TO_DATE(v_EndDate,'DD/MM/YYYY')),'DD/MM/YYYY')||' 23:59:59','DD/MM/YYYY :HH24:MI:SS') 
and (dh.dhsedate is null or dh.dhsedate >= to_date(v_StartDate,'DD/MM/YYYY'))
AND p.patno=r.patno
AND trunc(r.regdate)<>trunc(p.PATBDATE)
AND r.inpid = i.inpid
AND i.inpddate IS NULL
-- START UNION t3.1.2
) temp
where cnt>=0
GROUP BY spccode
-- END UNION t3.1
UNION
-- START UNION t3.2
select spccode, 'B' as FG,sum(DECODE(cnt, 0, 1, cnt)) as Noofmid
FROM (
-- START UNION t3.2.1
select d.spccode, dh.regid, i.inpddate, dh.dhsdate, dh.dhsedate,trunc(least(nvl(dh.dhsedate, to_date(v_EndDate,'DD/MM/YYYY')),to_date(v_EndDate,'DD/MM/YYYY'))) 
- trunc(greatest(to_date(v_StartDate,'DD/MM/YYYY')-1, nvl(dh.dhsdate, to_date(v_StartDate,'DD/MM/YYYY')-1))) as cnt
From dochist dh, doctor d, reg r, inpat i,Patient p,bed b
Where dh.DocCode = d.DocCode
AND dh.regid = r.regid (+)
AND r.regsts = 'N'
and r.stecode= v_SteCode
and dh.dhsdate <= TO_DATE(TO_CHAR(TRUNC(TO_DATE(v_EndDate,'DD/MM/YYYY')),'DD/MM/YYYY')||' 23:59:59','DD/MM/YYYY :HH24:MI:SS')
and (dh.dhsedate is null or dh.dhsedate >= to_date(v_StartDate,'DD/MM/YYYY'))
AND r.inpid = i.inpid
AND i.bedcode=b.bedcode
AND i.bedcode  LIKE v_bedCode
and i.inpddate is  null
AND p.patno=r.patno
AND trunc(r.regdate)<> trunc(p.PATBDATE)
-- END UNION t3.2.1
UNION
-- START UNION t3.2.2
select d.spccode, dh.regid, i.inpddate, dh.dhsdate, dh.dhsedate,
trunc(least(nvl(dh.dhsedate, to_date(v_EndDate,'DD/MM/YYYY')), to_date(v_EndDate,'DD/MM/YYYY'))) 
-trunc(greatest(to_date(v_StartDate,'DD/MM/YYYY')-1, nvl(dh.dhsdate, to_date(v_StartDate,'DD/MM/YYYY')-1))) as cnt
From dochist dh, doctor d, reg r, inpat i,patient p,bed b
WHERE i.bedcode=b.bedcode
AND i.bedcode LIKE v_bedCode
AND dh.DocCode = d.DocCode
AND dh.regid = r.regid (+)
AND r.regsts = 'N'
and r.stecode= v_SteCode
and dh.dhsdate <= TO_DATE(TO_CHAR(TRUNC(TO_DATE(v_EndDate,'DD/MM/YYYY')),'DD/MM/YYYY')||' 23:59:59','DD/MM/YYYY :HH24:MI:SS')
and i.inpddate is not null and  (dh.dhsedate is null or dh.dhsedate >= to_date(v_StartDate,'DD/MM/YYYY'))
and p.patno=r.patno  
and trunc(r.regdate)<>trunc(p.PATBDATE) 
and r.inpid = i.inpid  
and i.inpddate is null
and (((trunc(i.inpddate) > to_date(v_EndDate,'DD/MM/YYYY')) 
		and i.sdscode is null) or (i.sdscode is not null))  
and trunc(r.regdate) <> trunc(i.inpddate)
-- END UNION t3.2.2
UNION
-- START UNION t3.2.3
select d.spccode, dh.regid, i.inpddate, dh.dhsdate, dh.dhsedate,  
trunc(least(nvl(dh.dhsedate, to_date(v_EndDate,'DD/MM/YYYY')), to_date(v_EndDate,'DD/MM/YYYY'))) 
- trunc(greatest(to_date(v_StartDate,'DD/MM/YYYY')-1, nvl(dh.dhsdate, to_date(v_StartDate,'DD/MM/YYYY')-1))) as cnt  
FROM dochist dh, doctor d, reg r, inpat i,patient p,bed b  
WHERE  i.bedcode=b.bedcode 
and  i.bedcode like v_bedCode  
and  dh.DocCode = d.DocCode  
and dh.regid = r.regid (+) 
and r.regsts = 'N' 
and r.stecode= v_SteCode  
and dh.dhsdate <= TO_DATE(TO_CHAR(TRUNC(TO_DATE(v_EndDate,'DD/MM/YYYY')),'DD/MM/YYYY')||' 23:59:59','DD/MM/YYYY :HH24:MI:SS')  
and (dh.dhsedate is null or dh.dhsedate >= to_date(v_StartDate,'DD/MM/YYYY'))  
and  p.patno=r.patno  
and trunc(r.regdate)<>trunc(p.PATBDATE) 
and r.inpid = i.inpid  
and i.inpddate is null
-- END UNION t3.2.3
) temp
where cnt>=0
GROUP BY spccode
-- END UNION t3.2
UNION
-- START UNION t3.3
select spccode, 'C' as FG,sum(DECODE(cnt, 0, 1, cnt)) as Noofmid
FROM (
select d.spccode, dh.regid, i.inpddate, dh.dhsdate, dh.dhsedate,
trunc(least(nvl(dh.dhsedate, to_date(v_EndDate,'DD/MM/YYYY')), to_date(v_EndDate,'DD/MM/YYYY')))
- trunc(greatest(to_date(v_StartDate,'DD/MM/YYYY')-1, nvl(dh.dhsdate, to_date(v_StartDate,'DD/MM/YYYY')-1))) as cnt
From dochist dh, doctor d, reg r, inpat i ,patient p
WHERE dh.DocCode = d.DocCode
AND dh.regid = r.regid (+)
AND r.regsts = 'N'
and r.stecode= v_SteCode
and dh.dhsdate <=  TO_DATE(TO_CHAR(TRUNC(TO_DATE(v_EndDate,'DD/MM/YYYY')),'DD/MM/YYYY')||' 23:59:59','DD/MM/YYYY :HH24:MI:SS')
and (dh.dhsedate is null or dh.dhsedate >= to_date(v_StartDate,'DD/MM/YYYY'))
AND r.inpid = i.inpid
and (i.inpddate is null or  (  (i.sdscode is not null and trunc(r.regdate) <> trunc(i.inpddate) 
	and trunc(i.inpddate) >= to_date(v_StartDate,'DD/MM/YYYY')  or (i.sdscode is null 
	and trunc(r.regdate) <> trunc(i.inpddate) and trunc(i.inpddate) > to_date(v_EndDate,'DD/MM/YYYY') ) )  ) )
AND p.patno=r.patno
and trunc(r.regdate)=trunc(p.PATBDATE)
and r.regnb = -1 
) tmp
where cnt>=0
GROUP BY spccode
-- END UNION t3.3
)
) t3,(
SELECT spccode,fg,noof24 FROM (
-- START UNION t4.1
select  spccode,'A' as FG,COUNT(*) AS NoOf24
From dochist dh,inpat i, reg r, doctor d ,Patient p,bed b
WHERE i.bedcode=b.bedcode
AND i.bedcode NOT LIKE v_bedCode
AND dh.DocCode = d.DocCode
AND dh.regid = r.regid (+)
AND  r.regtype = 'I'
AND r.inpid = i.inpid
AND r.regsts = 'N'
and r.stecode= v_SteCode
and i.inpddate >= to_date(v_StartDate,'DD/MM/YYYY') and i.inpddate < to_date(v_EndDate,'DD/MM/YYYY') + 1
AND trunc(i.inpddate)=trunc(r.regdate)
AND dh.dhsedate >= to_date(v_StartDate,'DD/MM/YYYY')
and dh.dhsdate < TO_DATE(v_EndDate,'DD/MM/YYYY')+1
AND r.patno=p.patno
 and i.inpddate is not null
and (i.sdscode is not null or (i.sdscode is null and (trunc(i.inpddate)) > to_date(v_EndDate,'DD/MM/YYYY')))
and trunc(p.PATBDATE)<>trunc(r.regdate)
GROUP BY d.spccode
-- END UNION t4.1
UNION
-- START UNION t4.2
SELECT  spccode,'B' AS FG,COUNT(*) AS NoOf24
FROM (
-- START UNION t4.2.1
SELECT spccode
From dochist dh,inpat i, reg r, doctor d ,Patient p,bed b
WHERE dh.DocCode = d.DocCode
AND dh.regid = r.regid (+)
AND i.bedcode=b.bedcode
AND i.bedcode LIKE v_bedCode
AND r.regtype = 'I'
AND r.inpid = i.inpid
and r.regsts = 'N'
AND r.stecode= v_SteCode
AND i.inpddate >= to_date(v_StartDate,'DD/MM/YYYY')
and i.inpddate < to_date(v_EndDate,'DD/MM/YYYY') + 1
AND trunc(i.inpddate)=trunc(r.regdate)
AND dh.dhsedate >= to_date(v_StartDate,'DD/MM/YYYY')
and dh.dhsdate < TO_DATE(v_EndDate,'DD/MM/YYYY')+1
AND r.patno=p.patno
and i.inpddate is not null
and (i.sdscode is not null or (i.sdscode is null and (trunc(i.inpddate)) > to_date(v_EndDate,'DD/MM/YYYY')))
AND trunc(p.PATBDATE) <> trunc(r.regdate)
) tmp
GROUP BY spccode, 'B'
-- END UNION t4.2
UNION
-- START UNION t4.3
select  d.spccode,'C' as FG,COUNT(*) AS NoOf24
From dochist dh,inpat i, reg r, doctor d ,Patient p
WHERE dh.DocCode = d.DocCode
AND dh.regid = r.regid (+)
AND r.regtype = 'I'
AND r.inpid = i.inpid
AND r.regsts = 'N'
and r.stecode= v_SteCode
and i.inpddate >= to_date(v_StartDate,'DD/MM/YYYY')
AND i.inpddate < to_date(v_EndDate,'DD/MM/YYYY') + 1
AND trunc(i.inpddate)=trunc(r.regdate)
AND dh.dhsedate >= to_date(v_StartDate,'DD/MM/YYYY')
and dh.dhsdate < TO_DATE(v_EndDate,'DD/MM/YYYY')+1
AND r.patno=p.patno
AND i.sdscode IS NOT NULL
and trunc(p.PATBDATE)=trunc(r.regdate)
and r.regnb=-1
GROUP BY d.spccode
-- END UNION t4.3
)
) t4,(
SELECT spccode,fg,noofdeath FROM (
-- START UNION t5.1
select  d.spccode,'A' as FG,COUNT(*) AS NoOfDEATH
From inpat i, reg r, doctor d,Patient p, bed b
WHERE i.bedcode=b.bedcode
AND i.bedcode NOT LIKE v_bedCode
AND  r.regtype = 'I'
AND r.inpid = i.inpid
AND r.regsts = 'N'
and r.stecode= v_SteCode
AND i.inpddate >= to_date(v_StartDate,'DD/MM/YYYY')
and i.inpddate < to_date(v_EndDate,'DD/MM/YYYY') + 1
and i.descode='DEATH'
AND r.patno=p.patno
AND i.doccode_d = d.doccode
AND i.sdscode IS NOT NULL
and trunc(p.PATBDATE)<>trunc(r.regdate)
GROUP BY d.spccode, 'A'
-- END UNION t5.1
UNION
-- START UNION t5.2
(SELECT  spccode,'B' AS FG,COUNT(*) AS NoOfDEATH
FROM (
-- START UNION t5.2.1
select d.spccode
FROM inpat i, reg r, doctor d ,Patient p,bed b 
Where i.bedcode=b.bedcode 
and i.bedcode like v_bedCode
AND r.regtype = 'I'
AND r.inpid = i.inpid
AND r.regsts = 'N'
and r.stecode= v_SteCode
and i.inpddate >= to_date(v_StartDate,'DD/MM/YYYY')
AND i.inpddate < to_date(v_EndDate,'DD/MM/YYYY') + 1
and i.descode='DEATH'
AND r.patno=p.patno
AND i.doccode_d = d.doccode
AND i.sdscode IS NOT NULL
AND trunc(p.PATBDATE) <> trunc(r.regdate)
-- END UNION t5.2.1
) tmp
group by spccode)
UNION
-- START UNION t5.2.3
select  d.spccode,'C' as FG,COUNT(*) AS NoOfDEATH
From inpat i, reg r, doctor d,Patient p
WHERE r.regtype = 'I'
AND r.inpid = i.inpid
and r.regsts = 'N'
AND r.stecode= v_SteCode
and i.inpddate >= to_date(v_StartDate,'DD/MM/YYYY')
AND i.inpddate < to_date(v_EndDate,'DD/MM/YYYY') + 1
and i.descode='DEATH'
AND r.patno=p.patno
AND i.doccode_d = d.doccode
AND i.sdscode IS NOT NULL
AND trunc(p.PATBDATE)=trunc(r.regdate)
and r.regnb=-1
GROUP BY d.spccode
-- END UNION t5.2.3
)
) t5
WHERE t1.SPCCODE=t2.SPCCODE(+)
AND t1.FG=t2.FG(+)
AND t1.SPCCODE=t3.SPCCODE(+)
and t1.FG=t3.FG(+)
AND t1.SPCCODE=t4.SPCCODE(+)
AND t1.FG=t4.FG(+)
AND t1.SPCCODE=t5.SPCCODE(+)
AND t1.FG=t5.FG(+)
AND (t2.noofdischarged>0  OR  t3.noofmid>0  OR t4.noof24>0  OR  t5.noofdeath>0)
order by t1.FG,t1.SPCCODE,t1.SPCNAME;

RETURN outcur;
END NHS_RPT_RPTIPSTATANALYSIS2006;
/
