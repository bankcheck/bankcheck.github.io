create or replace
PROCEDURE PROC_AMC_PAT_REF_UPDATE

IS

BEGIN
delete from TMP_AMC_SLIP;
    
INSERT INTO TMP_AMC_SLIP
SELECT A.PATNO, SLPNO, REGID, 'HKAH' AS PATTYPE, PATFNAME, PATGNAME
from slip@IWEB a, patient@IWEB b
where a.patno=b.patno
AND (A.PATREFNO LIKE 'AM%' OR SLPSID=61)
AND EXISTS (SELECT 1 FROM SLIP@IWEB X WHERE X.PATNO=A.PATNO AND X.SLPNO<A.SLPNO);
    
insert into TMP_AMC_SLIP
select a.patno, slpno, regid, 'NEW', patfname, patgname
from slip@iweb a, patient@iweb b
where a.patno=b.patno
and a.patno in (
select patno from slip@iweb a 
where (patrefno like 'AM%' or slpsid=61)
and not exists (select 1 from slip@iweb x where x.patno=a.patno and x.slpno<a.slpno));

insert into TMP_AMC_SLIP
SELECT PATNO, SLPNO, REGID, 'NULL', SLPFNAME, SLPGNAME
FROM SLIP@IWEB A WHERE (PATREFNO LIKE 'AM%' OR SLPSID=61) AND PATNO IS NULL;

DELETE FROM TMP_AMC_SLIP p
  WHERE (P.PATNO, P.SLPNO, P.PATTYPE) IN
(
SELECT T1.PATNO, T1.SLPNO, t1.pattype
FROM TMP_AMC_SLIP t1
WHERE EXISTS (SELECT 1 from TMP_AMC_SLIP t2 Where
       t1.PATNO = t2.PATNO
       AND t1.SLPNO = t2.SLPNO
       AND T1.ROWID <> T2.ROWID)
AND T1.PATTYPE = 'HKAH'
)
;

EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	DBMS_OUTPUT.PUT_LINE('AN ERROR WAS ENCOUNTERED - '||SQLCODE||' -ERROR- '||SQLERRM);
END;