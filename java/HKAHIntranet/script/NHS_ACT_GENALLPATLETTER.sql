create or replace
FUNCTION NHS_ACT_GENALLPATLETTER (  
	V_SYSTEMDATE IN VARCHAR2,
  o_errmsg		OUT VARCHAR2)
	RETURN NUMBER
AS
	V_PATNO PATIENT.PATNO@IWEB%TYPE;
	V_BEDCODE INPAT.BEDCODE@IWEB%TYPE;
	V_REGDATE REG.REGDATE@IWEB%TYPE;
	V_SLPNO SLIP.SLPNO@IWEB%TYPE;
	V_PATNO1 PATIENT.PATNO@IWEB%TYPE;
	V_SLPNO1 SLIP.SLPNO@IWEB%TYPE;
	V_PATNAME1 VARCHAR2(81);
	V_PATFNAME1 PATIENT.PATFNAME@IWEB%TYPE;
	v_BEDCODE1 inpat.BEDCODE@IWEB%TYPE;
	V_TITDESC1 VARCHAR2(10);
	V_REGDATE1 REG.REGDATE@IWEB%TYPE;
	V_SLPTYPE1 SLIP.SLPTYPE@IWEB%TYPE;
	V_ARCODE1 SLIP.ARCCODE@IWEB%TYPE;
	V_OUTAMT1 SLIP.SLPPAMT@IWEB%TYPE;
	V_PATNO2 PATIENT.PATNO@IWEB%TYPE;
	v_slpno2 slip.SLPNO@IWEB%TYPE;
	V_PATNAME2 VARCHAR2(81);
	V_PATFNAME2 PATIENT.PATFNAME@IWEB%TYPE;
	v_BEDCODE2 inpat.BEDCODE@IWEB%TYPE;
	v_TITDESC2 VARCHAR2(10);
	V_REGDATE2 REG.REGDATE@IWEB%TYPE;
	V_SLPTYPE2 SLIP.SLPTYPE@IWEB%TYPE;
	V_ARCODE2 SLIP.ARCCODE@IWEB%TYPE;
	v_OutAmt2 slip.SLPPAMT@IWEB%TYPE;  
	TMPARCODE BOOLEAN := FALSE;
  VBUFFERDAYS NUMBER;
  VPREDAYS NUMBER;
  vOutAmt FLOAT(126);
	V_NOOFREC NUMBER;
  V_YEAR NUMBER;
  V_DAYS NUMBER;
  TMPRS_CNT NUMBER;
  VTMPSQL_CNT NUMBER;
  VTMPSQL0_CNT NUMBER;
  VTMPSQL1_CNT NUMBER;
  V_CNT_PATEXTRA NUMBER;
  V_REGID reg.REGID@IWEB%TYPE;
  V_SYSDATE DATE;
  O_ERRCODE NUMBER;
  RTN_CODE NUMBER;
  INSERT_CNT NUMBER;
  LI_INPATCNT NUMBER;  
  SCLREPORTPATH VARCHAR2(1000);
  V_TRACK_NO VARCHAR2(1000);
  
  PATH_NOTFOUND_ERR EXCEPTION;

/*

SELECT A.PATNO,B.BEDCODE,C.REGDATE,C.SLPNO
from patient a,inpat b,reg c,slip d
WHERE C.PATNO = A.PATNO
AND B.INPID = C.INPID
AND D.REGID = C.REGID
And b.inpddate Is Null
AND  C.REGSTS <> 'C' AND D.SLPSTS<>'R'
AND D.SLPSTS<>'C'
AND (A.LASTPRTDATE IS NULL  OR (V_sysdate- TO_NUMBER(vBufferDays) -1 >= A.LASTPRTDATE AND A.LASTPRTDATE IS NOT NULL) )
GROUP BY A.PATNO,B.BEDCODE,C.REGDATE,C.SLPNO
order by b.bedcode;

CURSOR c_patList IS
SELECT A.PATNO,B.BEDCODE,C.REGDATE,C.SLPNO
from patient@IWEB a,inpat@IWEB b,reg@IWEB c,slip@IWEB d, HKAH.PATIENT_EXTRA@IWEB PE
WHERE C.PATNO = A.PATNO
AND B.INPID = C.INPID
AND D.REGID = C.REGID
AND A.PATNO = PE.PATNO
And b.inpddate Is Null
AND  C.REGSTS <> 'C' AND D.SLPSTS<>'R'
AND D.SLPSTS<>'C'
AND (PE.LASTPRTDATE2 IS NULL OR (V_sysdate- TO_NUMBER(vBufferDays) -1 >= PE.LASTPRTDATE2 AND PE.LASTPRTDATE2 IS NOT NULL) )
GROUP BY A.PATNO,B.BEDCODE,C.REGDATE,C.SLPNO
order by b.bedcode;
*/

CURSOR c_patList IS
SELECT A.PATNO,B.BEDCODE,C.REGDATE,C.SLPNO
FROM PATIENT@IWEB A JOIN REG@IWEB C ON C.PATNO = A.PATNO AND C.REGSTS <> 'C' 
JOIN INPAT@IWEB B ON B.INPID = C.INPID AND B.INPDDATE IS NULL
JOIN SLIP@IWEB D ON D.REGID = C.REGID AND D.SLPSTS <> 'R' AND D.SLPSTS <> 'C'
left outer join PATIENT_EXTRA@IWEB PE on A.PATNO = PE.PATNO
WHERE DECODE( PE.PATNO , null, A.LASTPRTDATE, PE.LASTPRTDATE2 ) IS NULL OR ( V_sysdate - TO_NUMBER(vBufferDays) -1 >= DECODE( PE.PATNO , null, A.LASTPRTDATE, PE.LASTPRTDATE2 )
AND DECODE( PE.PATNO , null, A.LASTPRTDATE, PE.LASTPRTDATE2 ) IS NOT NULL)
GROUP BY A.PATNO,B.BEDCODE,C.REGDATE,C.SLPNO
order by b.bedcode;

CURSOR c_DayEndSts IS
SELECT PATNO,BEDCODE,REGDATE,SLPNO 
from HKAH.DAYENDSTS@IWEB 
order by  bedcode;

CURSOR c_tmpRs IS
select distinct patno,slpno,PATNAME,PATFNAME,BEDCODE,TITDESC,regdate,slptype,arcode,OutAmt
from (
(SELECT A.PATNO,D.SLPNO,A.PATFNAME||' '||A.PATGNAME AS PATNAME,A.PATFNAME,'' AS BEDCODE,A.TITDESC,C.REGDATE,D.SLPTYPE,'' AS ARCODE,SUM(NVL(E.STNNAMT,0)) AS OUTAMT
from patient@IWEB a,reg@IWEB c,slip@IWEB d,sliptx@IWEB e
where c.patno=a.patno  
and d.regid=c.regid 
and d.slpno=e.slpno 
and trunc(e.stncdate)<=trunc(V_sysdate)-1 
and d.slptype in ('D','O')  
and d.arccode is null 
and c.regsts<>'C' 
and d.slpsts<>'R' 
and d.slpsts<>'C'
and a.patno= v_patno
group by a.patno,d.slpno,a.PATFNAME||' '||a.PATGNAME,a.PATFNAME, a.TITDESC,c.regdate,d.slptype
Having Sum(nvl(stnnamt, 0)) > 0
) 
Union
(select a.patno,d.slpno,a.PATFNAME||' '||a.PATGNAME as PATNAME,a.PATFNAME,'' as BEDCODE,a.TITDESC,to_date(null,'dd/mm/yyyy') as regdate,d.slptype,'' as arcode,
SUM(NVL(E.STNNAMT,0)) AS OUTAMT
from patient@IWEB a,slip@IWEB d,sliptx@IWEB e
WHERE D.PATNO=A.PATNO  
AND D.SLPNO=E.SLPNO 
AND TRUNC(E.STNCDATE)<=TRUNC(V_sysdate)-1 
and d.slptype in ('D','O')
AND D.ARCCODE IS NULL 
AND D.SLPSTS<>'R' 
AND D.SLPSTS<>'C'  
and d.regid is null
and a.patno= v_patno
group by  a.patno,d.slpno,a.PATFNAME||' '||a.PATGNAME,a.PATFNAME, a.TITDESC,to_date(null,'dd/mm/yyyy'),d.slptype
Having Sum(nvl(stnnamt, 0)) > 0
) 
Union
(SELECT A.PATNO,D.SLPNO,A.PATFNAME||' '||A.PATGNAME AS PATNAME,A.PATFNAME,'' AS BEDCODE,A.TITDESC,C.REGDATE,D.SLPTYPE,'' AS ARCODE,SUM(NVL(E.STNNAMT,0)) AS OUTAMT
from patient@IWEB a,inpat@IWEB b,reg@IWEB c,slip@IWEB d,sliptx@IWEB e 
where c.patno=a.patno  
and b.inpddate is not null 
AND B.INPID=C.INPID 
and d.regid=c.regid  
and d.slpno=e.slpno 
and trunc(e.stncdate)<=trunc(V_sysdate)-1 
and c.regsts<>'C'  
and d.slpsts<>'R'   
and  d.slpsts<>'C' 
and d.arccode is null 
and a.patno= v_patno
group by a.patno,d.slpno,a.PATFNAME||' '||a.PATGNAME,a.PATFNAME, a.TITDESC,c.regdate,d.slptype
Having Sum(nvl(stnnamt, 0)) > 0
) 
Union
(SELECT A.PATNO,D.SLPNO,A.PATFNAME||' '||A.PATGNAME AS PATNAME,A.PATFNAME,B.BEDCODE,A.TITDESC,C.REGDATE,D.SLPTYPE,D.ARCCODE AS ARCODE,SUM(NVL(E.STNNAMT,0)) AS OUTAMT 
from patient@IWEB a,inpat@IWEB b,reg@IWEB c,slip@IWEB d,sliptx@IWEB e
where c.patno=a.patno 
and b.inpddate is null 
and b.inpid=c.inpid 
and d.regid=c.regid 
and d.slpno=e.slpno 
and trunc(e.stncdate)<=trunc(V_sysdate)-1 
and c.regsts <> 'C' 
AND D.SLPSTS<>'R' 
and d.slpsts<>'C' 
AND D.ARCCODE IS NULL 
and V_sysdate-c.regdate-1>=TO_NUMBER(vPreDays)
and a.patno= v_patno
group by a.patno,d.slpno,a.PATFNAME||' '||a.PATGNAME,a.PATFNAME,b.BEDCODE, a.TITDESC,c.regdate,d.slptype,d.arccode )
union
(select z2.patno,z2.slpno,z4.PATFNAME||' '||z4.PATGNAME as PATNAME,z4.PATFNAME,z3.BEDCODE,z4.TITDESC,z1.regdate,z2.slptype,z2.arccode as arcode, sum(nvl(z5.stnnamt,0)) as OutAmt 
from (
	SELECT R.REGID 
	from patient@IWEB a,slip@IWEB d, inpat@IWEB i, reg@IWEB r,sliptx@IWEB e  
	Where a.patno=r.patno and
	d.RegID = r.RegID 
	And r.inpid = i.inpid  
	and d.slpno=e.slpno 
	and trunc(e.stncdate)<=trunc(V_sysdate)-1  
	and r.regsts <> 'C'
	AND A.patno=D.patno 
	And i.inpddate Is Null  
	and d.arccode is null 
	and d.slpsts <> 'R' 
	and d.slpsts<>'C'  
	and a.patno= v_patno
	GROUP BY R.REGID
	HAVING SUM(NVL(E.STNNAMT,0))> TO_NUMBER(VOUTAMT)) Z ,
	reg@IWEB z1,slip@IWEB z2, inpat@IWEB z3,patient@IWEB z4,sliptx@IWEB z5
where z.regid=z1.regid 
and z1.inpid=z3.inpid  
and z3.inpddate Is Null 
and z2.slpsts <> 'R'  
and z2.slpsts<>'C' 
and z2.regid=z1.regid 
and z1.patno=z2.patno 
and z1.patno=z4.patno 
and z2.slpno=z5.slpno 
and trunc(z5.stncdate)<=trunc(V_sysdate)-1  
and z1.regsts <> 'C' 
group by z2.patno,z2.slpno,z4.PATFNAME||' '||z4.PATGNAME,z4.PATFNAME,z3.BEDCODE,z4.TITDESC,z1.regdate,z2.slptype,z2.arccode
)) 
order by slpno asc;

BEGIN
  V_TRACK_NO := '0000';
	O_ERRCODE := 0;
  o_errmsg := 'OK';
  V_SYSDATE := TO_DATE(V_SYSTEMDATE||' '||'00:00:01','DD/MM/YYYY HH24:MI:SS');
  
	select Param1
	INTO VBUFFERDAYS 
	from SysParam@IWEB 
	where Parcde = 'IPBufDAY';

	select Param1
	INTO VOUTAMT 
	FROM SYSPARAM@IWEB 
	where Parcde = 'IPOTAMT';

	select Param1
	INTO VPREDAYS 
	from SysParam@IWEB 
	WHERE PARCDE = 'IPADDAY';
             DBMS_OUTPUT.PUT_LINE('[vPreDays]:'||VPREDAYS);
	DELETE FROM DAYENDSTS@IWEB;
           DBMS_OUTPUT.PUT_LINE('[DAYENDSTS]');
	OPEN c_patList;
	LOOP
	FETCH C_PATLIST INTO V_PATNO, V_BEDCODE, V_REGDATE, V_SLPNO;
	EXIT WHEN C_PATLIST%NOTFOUND;
    V_TRACK_NO := '0001';
		SELECT COUNT(PATNO) 
		INTO V_CNT_PATEXTRA
		FROM PATIENT_EXTRA@IWEB
		WHERE PATNO = v_patno;
		
		IF V_CNT_PATEXTRA = 0 THEN    
			INSERT INTO PATIENT_EXTRA@IWEB(
				PATNO,
				LASTPRTDATE2
			) VALUES (
				V_PATNO,
				(SELECT LASTPRTDATE FROM PATIENT@IWEB WHERE PATNO = v_patno)
			);
      
      INSERT INTO SYSLOG (MODULE,ACTION,REMARK,USERID,SYSTIME,PCNAME) 
      VALUES (
      'PORTAL',
      'NHS_ACT_GENALLPATLETTER',
      '[V_SYSDATE]:'||V_SYSDATE||';[v_patno]:'||V_PATNO||';[V_TRACK_NO]:'||V_TRACK_NO,
      'SYSTEM',
      SYSDATE,
      NULL);      
		END IF;
	
		IF v_REGDATE IS NOT NULL THEN
			v_year := to_char(v_REGDATE, 'yyyy');
			v_days := to_char(v_REGDATE, 'ddd');
			v_days := lpad(v_days,3,'0');
			v_SLPNO :=v_year || v_days || '0000';
		ELSE			
			v_SLPNO := NULL;
		END IF;

		INSERT INTO DAYENDSTS@IWEB (PATNO,BedCode,RegDate,SlpNo) VALUES (v_patno,v_BEDCODE,v_REGDATE,v_SLPNO);	
	END LOOP;
	CLOSE C_PATLIST;
	
	DELETE FROM DAYENDSLIPF@IWEB;
--	delete from DayEndSlipS@IWEB;
	
	v_patno := NULL;
	v_BEDCODE := NULL;
	v_REGDATE := NULL;
	V_SLPNO := NULL;

	OPEN c_DayEndSts;
	LOOP
	FETCH c_DayEndSts INTO v_patno, v_BEDCODE, v_REGDATE, v_SLPNO;
	EXIT WHEN C_DAYENDSTS%NOTFOUND;
    TMPRS_CNT := 0;
    V_TRACK_NO := '0002';   
    INSERT INTO SYSLOG (MODULE,ACTION,REMARK,USERID,SYSTIME,PCNAME) 
    VALUES (
    'PORTAL',
    'NHS_ACT_GENALLPATLETTER',
    '[V_SYSDATE]:'||V_SYSDATE||';[v_patno]:'||V_PATNO||';[V_TRACK_NO]:'||V_TRACK_NO,
    'SYSTEM',
    SYSDATE,
    NULL);    
    
		OPEN c_tmpRs;
		LOOP
		FETCH c_tmpRs INTO v_patno1,v_slpno1,v_PATNAME1,v_PATFNAME1,v_BEDCODE1,v_TITDESC1,v_regdate1,v_slptype1,v_arcode1,v_OutAmt1;
		EXIT WHEN C_TMPRS%NOTFOUND;
      TMPRS_CNT := TMPRS_CNT+1;
      V_TRACK_NO := '0003';      
      INSERT INTO SYSLOG (MODULE,ACTION,REMARK,USERID,SYSTIME,PCNAME) 
      VALUES (
      'PORTAL',
      'NHS_ACT_GENALLPATLETTER',
      '[V_SYSDATE]:'||V_SYSDATE||';[v_patno]:'||V_PATNO||';[V_TRACK_NO]:'||V_TRACK_NO,
      'SYSTEM',
      SYSDATE,
      NULL);
			IF V_ARCODE1 IS NULL THEN
				tmpArCode := True;
				EXIT WHEN tmpArCode;
			END IF;
		END LOOP;
    CLOSE c_tmpRs;
    
    DBMS_OUTPUT.PUT_LINE('[TMPRS_CNT]:'||TMPRS_CNT||';[c_DayEndSts][v_patno]:'||v_patno);    
    
    IF TMPRS_CNT > 0 THEN
      IF TMPARCODE = TRUE THEN -- NO ARCODE: TRUE
        SELECT COUNT(REGID)
        INTO VTMPSQL_CNT        
        FROM (
        SELECT R.REGID
        FROM PATIENT@IWEB A,SLIP@IWEB D, INPAT@IWEB I, REG@IWEB R,SLIPTX@IWEB E  
        WHERE A.PATNO=R.PATNO 
        AND D.REGID = R.REGID 
        AND R.INPID = I.INPID  
        AND D.SLPNO=E.SLPNO(+) 
        AND DECODE(TRUNC(E.STNCDATE),NULL,TRUNC(V_sysdate)-1,TRUNC(E.STNCDATE))<=TRUNC(V_sysdate)-1  
        and r.regsts <> 'C'
        AND A.patno=D.patno 
        And i.inpddate Is Null  
        and d.arccode is null 
        AND D.SLPSTS <> 'R'  
        and V_sysdate-r.regdate-1 < TO_NUMBER(vPreDays)
        AND D.SLPSTS<>'C'  
        and  a.patno= v_patno1
        GROUP BY R.REGID
        having sum(nvl(e.stnnamt,0))<= TO_NUMBER(vOutAmt))
        ;
        DBMS_OUTPUT.PUT_LINE('2.1[v_patno1]:'||v_patno1||';[VTMPSQL_CNT]:'||VTMPSQL_CNT);
        
        V_TRACK_NO := '0004';      
        INSERT INTO SYSLOG (MODULE,ACTION,REMARK,USERID,SYSTIME,PCNAME) 
        VALUES (
        'PORTAL',
        'NHS_ACT_GENALLPATLETTER',
        '[V_SYSDATE]:'||V_SYSDATE||';[v_patno]:'||V_PATNO||';[V_TRACK_NO]:'||V_TRACK_NO,
        'SYSTEM',
        SYSDATE,
        NULL);        

        IF VTMPSQL_CNT>0 THEN
          BEGIN
            DBMS_OUTPUT.PUT_LINE('[VTMPSQL_CNT][V_sysdate]:'||to_char(V_sysdate,'dd/mm/yyyy hh24:mi:ss')||';[v_SLPNO]:'||v_SLPNO||';[v_regdate]:'||to_char(v_regdate,'dd/mm/yyyy hh24:mi:ss')||';[v_patno]:'||v_patno);           
            SELECT COUNT (DISTINCT PATNO)
            INTO vtmpSql1_CNT 
            FROM ((SELECT A.PATNO,D.SLPNO,A.PATFNAME||' '||A.PATGNAME AS PATNAME,A.PATFNAME,'' AS BEDCODE,A.TITDESC,C.REGDATE,D.SLPTYPE,'' AS ARCODE, SUM(NVL(E.STNNAMT,0)) AS OUTAMT
            from patient@IWEB a,reg@IWEB c,slip@IWEB d,sliptx@IWEB e
            WHERE C.PATNO=A.PATNO  
            AND D.REGID=C.REGID 
            AND D.SLPNO=E.SLPNO 
            AND TRUNC(E.STNCDATE)<=TRUNC(V_sysdate) 
            and d.slptype in ('D','O')
            AND D.ARCCODE IS NULL 
            AND C.REGSTS <> 'C' 
            AND D.SLPSTS<>'R' 
            AND D.SLPSTS<>'C'
            and a.patno= v_patno
            and trunc(c.regdate) < trunc(v_regdate)
            group by a.patno,d.slpno,a.PATFNAME||' '||a.PATGNAME,a.PATFNAME, a.TITDESC,c.regdate,d.slptype
            Having Sum(nvl(stnnamt, 0)) > 0
            ) UNION
            (SELECT A.PATNO,D.SLPNO,A.PATFNAME||' '||A.PATGNAME AS PATNAME,A.PATFNAME,'' AS BEDCODE,A.TITDESC,TO_DATE(NULL,'dd/mm/yyyy') AS REGDATE,D.SLPTYPE,'' AS ARCODE,SUM(NVL(E.STNNAMT,0)) AS OUTAMT
            from patient@IWEB a,slip@IWEB d,sliptx@IWEB e
            WHERE D.PATNO=A.PATNO  
            AND D.SLPNO=E.SLPNO 
            AND TRUNC(E.STNCDATE)<=TRUNC(V_sysdate) 
            and d.slptype in ('D','O')
            AND D.ARCCODE IS NULL 
            AND D.SLPSTS<>'R' 
            AND D.SLPSTS<>'C'  
            and d.regid is null
            and a.patno= v_patno
            and to_number(substr(d.slpno,1,7))< to_number(substr(v_SLPNO,1,7))
            group by a.patno,d.slpno,a.PATFNAME||' '||a.PATGNAME,a.PATFNAME, a.TITDESC,to_date(null,'dd/mm/yyyy'),d.slptype
            Having Sum(nvl(stnnamt, 0)) > 0
            ) Union
            (select a.patno,d.slpno,a.PATFNAME||' '||a.PATGNAME as PATNAME,a.PATFNAME,'' as BEDCODE,a.TITDESC,c.regdate,d.slptype,'' as arcode,
            SUM(NVL(E.STNNAMT,0)) AS OUTAMT
            from patient@IWEB a,inpat@IWEB b,reg@IWEB c,slip@IWEB d,sliptx@IWEB e 
            WHERE C.PATNO=A.PATNO  
            AND B.INPDDATE IS NOT NULL 
            AND B.INPID=C.INPID 
            AND D.REGID=C.REGID  
            AND D.SLPNO=E.SLPNO 
            AND TRUNC(E.STNCDATE)<=TRUNC(V_sysdate) 
            AND C.REGSTS <> 'C'  
            AND D.SLPSTS<>'R'  
            and  d.slpsts<>'C' 
            AND D.ARCCODE IS NULL 
            and a.patno= v_patno
            and trunc(c.regdate) < trunc(v_regdate)
            group by a.patno,d.slpno,a.PATFNAME||' '||a.PATGNAME,a.PATFNAME, a.TITDESC,c.regdate,d.slptype
            HAVING SUM(NVL(STNNAMT, 0)) > 0
            ));
            
            V_TRACK_NO := '0005';      
            INSERT INTO SYSLOG (MODULE,ACTION,REMARK,USERID,SYSTIME,PCNAME) 
            VALUES (
            'PORTAL',
            'NHS_ACT_GENALLPATLETTER',
            '[V_SYSDATE]:'||V_SYSDATE||';[v_patno]:'||V_PATNO||';[V_TRACK_NO]:'||V_TRACK_NO,
            'SYSTEM',
            SYSDATE,
            NULL);            
            DBMS_OUTPUT.PUT_LINE('3.0[v_patno1]:'||V_PATNO1||';[vtmpSql1_CNT]:'||vtmpSql1_CNT);
          EXCEPTION
          WHEN OTHERS THEN
            VTMPSQL1_CNT := 0;
            DBMS_OUTPUT.PUT_LINE('3.1[v_patno1]:'||V_PATNO1||';[vtmpSql1_CNT]:'||vtmpSql1_CNT);
          END;
                          
          IF VTMPSQL1_CNT > 0 THEN
            V_PATNO1 := NULL;
            V_SLPNO1 := NULL;
            V_PATNAME1 := NULL;
            V_PATFNAME1 := NULL;
            V_BEDCODE1 := NULL;
            V_TITDESC1 := NULL;
            V_REGDATE1 := NULL;
            V_SLPTYPE1 := NULL;
            V_ARCODE1 := NULL;
            v_OutAmt1 := NULL;

            tmpRs_cnt := 0;            
            OPEN c_tmpRs;
            LOOP
            FETCH c_tmpRs INTO v_patno1,v_slpno1,v_PATNAME1,v_PATFNAME1,v_BEDCODE1,v_TITDESC1,v_regdate1,v_slptype1,v_arcode1,v_OutAmt1;
            EXIT WHEN C_TMPRS%NOTFOUND;
              tmpRs_cnt := tmpRs_cnt+1; 
            
              INSERT INTO DAYENDSLIPF@IWEB (
              PATNO,SLPNO,PATNAME,PATFNAME,BEDCODE,TITDESC,REGDATE,SLPTYPE,ARCODE,OUTAMT,PRINTDATE) VALUES(
              v_patno1,v_slpno1,v_PATNAME1,v_PATFNAME1,v_BEDCODE1,v_TITDESC1,v_regdate1,v_slptype1,v_arcode1,v_OutAmt1,V_sysdate);
              
              V_TRACK_NO := '0006';      
              INSERT INTO SYSLOG (MODULE,ACTION,REMARK,USERID,SYSTIME,PCNAME) 
              VALUES (
              'PORTAL',
              'NHS_ACT_GENALLPATLETTER',
              '[V_SYSDATE]:'||V_SYSDATE||';[v_patno]:'||V_PATNO||';[V_TRACK_NO]:'||V_TRACK_NO,
              'SYSTEM',
              SYSDATE,
              NULL);              
            END LOOP;
            CLOSE C_TMPRS;
            
            IF TMPRS_CNT>0 THEN  
                RTN_CODE :=NHS_ACT_GENPATLETTER(V_PATNO ,VOUTAMT, NULL, VPREDAYS, 0, 0, V_REGDATE, V_SLPNO, V_SYSDATE); 
                DBMS_OUTPUT.PUT_LINE('[NHS_ACT_GENPATLETTER][TMPRS_CNT]:'||TMPRS_CNT||'[VTMPSQL1_CNT]'||VTMPSQL1_CNT||'[RTN_CODE]:'||RTN_CODE);
                
                IF RTN_CODE = 1 THEN
                  INSERT_CNT := INSERT_CNT+1;
                END IF;
                DBMS_OUTPUT.PUT_LINE('[NHS_ACT_GENPATLETTER][1TMPRS_CNT]'||TMPRS_CNT||'[VTMPSQL0_CNT]:'||VTMPSQL0_CNT||';[RTN_CODE]:'||RTN_CODE||';[INSERT_CNT]:'||INSERT_CNT);                
                
                V_TRACK_NO := '0007';      
                INSERT INTO SYSLOG (MODULE,ACTION,REMARK,USERID,SYSTIME,PCNAME) 
                VALUES (
                'PORTAL',
                'NHS_ACT_GENALLPATLETTER',
                '[V_SYSDATE]:'||V_SYSDATE||';[v_patno]:'||V_PATNO||';[V_TRACK_NO]:'||V_TRACK_NO,
                'SYSTEM',
                SYSDATE,
                NULL);                
            END IF;
          END IF;
        ELSE
          BEGIN        
            SELECT COUNT(R.REGID)
            INTO VTMPSQL0_CNT
            FROM PATIENT@IWEB A,SLIP@IWEB D, INPAT@IWEB I, REG@IWEB R,SLIPTX@IWEB E  
            WHERE A.PATNO=R.PATNO 
            AND D.REGID = R.REGID 
            AND R.INPID = I.INPID  
            AND D.SLPNO=E.SLPNO(+)  
            and r.regsts <> 'C'
            AND A.PATNO=D.PATNO 
            AND I.INPDDATE IS NULL  
            AND D.ARCCODE IS NOT NULL 
            AND D.SLPSTS <> 'R'  
            and V_sysdate-r.regdate-1 < TO_NUMBER(vPreDays)
            and d.slpsts<>'C'  
            AND A.PATNO= V_PATNO1
            group by r.regid;
            DBMS_OUTPUT.PUT_LINE('4.0[v_patno1]:'||V_PATNO1||';[VTMPSQL0_CNT]:'||VTMPSQL0_CNT);
          EXCEPTION
          WHEN OTHERS THEN
            VTMPSQL0_CNT := 0;
            DBMS_OUTPUT.PUT_LINE('4.1[v_patno1]:'||V_PATNO1||';[VTMPSQL0_CNT]:'||VTMPSQL0_CNT);
          END;

          IF VTMPSQL0_CNT=0 THEN
            V_PATNO1 := NULL;
            V_SLPNO1 := NULL;
            V_PATNAME1 := NULL;
            V_PATFNAME1 := NULL;
            V_BEDCODE1 := NULL;
            V_TITDESC1 := NULL;
            V_REGDATE1 := NULL;
            V_SLPTYPE1 := NULL;
            V_ARCODE1 := NULL;
            v_OutAmt1 := NULL;
 
            tmpRs_cnt := 0;           
            OPEN c_tmpRs;
            LOOP
            FETCH c_tmpRs INTO v_patno1,v_slpno1,v_PATNAME1,v_PATFNAME1,v_BEDCODE1,v_TITDESC1,v_regdate1,v_slptype1,v_arcode1,v_OutAmt1;
            EXIT WHEN C_TMPRS%NOTFOUND;
              tmpRs_cnt := tmpRs_cnt+1;            
            
              INSERT INTO DAYENDSLIPF@IWEB (
              PATNO,SLPNO,PATNAME,PATFNAME,BEDCODE,TITDESC,REGDATE,SLPTYPE,ARCODE,OUTAMT,PRINTDATE) VALUES(
              v_patno1,v_slpno1,v_PATNAME1,v_PATFNAME1,v_BEDCODE1,v_TITDESC1,v_regdate1,v_slptype1,v_arcode1,v_OutAmt1,V_sysdate);
            END LOOP;
            CLOSE C_TMPRS;

            IF TMPRS_CNT>0 THEN 
              RTN_CODE :=NHS_ACT_GENPATLETTER(V_PATNO ,VOUTAMT, NULL, VPREDAYS, 0, 0, V_REGDATE, V_SLPNO, V_SYSDATE); 
              
                IF RTN_CODE = 1 THEN
                  INSERT_CNT := INSERT_CNT+1;
                END IF;
                DBMS_OUTPUT.PUT_LINE('[NHS_ACT_GENPATLETTER][2TMPRS_CNT]'||TMPRS_CNT||'[VTMPSQL0_CNT]:'||VTMPSQL0_CNT||';[RTN_CODE]:'||RTN_CODE||';[INSERT_CNT]:'||INSERT_CNT);
                
                V_TRACK_NO := '0007.1';      
                INSERT INTO SYSLOG (MODULE,ACTION,REMARK,USERID,SYSTIME,PCNAME) 
                VALUES (
                'PORTAL',
                'NHS_ACT_GENALLPATLETTER',
                '[V_SYSDATE]:'||V_SYSDATE||';[v_patno]:'||V_PATNO||';[V_TRACK_NO]:'||V_TRACK_NO,
                'SYSTEM',
                SYSDATE,
                NULL);                
            END IF;
          END IF;
        END IF;
      END IF;
    END IF;
    
      IF INSERT_CNT>0 THEN
        SELECT COUNT(SLPNO)
        INTO LI_INPATCNT
        FROM DAYENDSLIPS@IWEB
        WHERE PRINTDATE = V_SYSDATE
        AND PATNO = V_PATNO
        AND SLPTYPE = 'I';
  
        IF LI_INPATCNT>0 THEN
          UPDATE PATIENT_EXTRA@IWEB
          SET LASTPRTDATE2 = V_SYSDATE
          WHERE PATNO = V_PATNO;
          DBMS_OUTPUT.PUT_LINE('[UPDATE PATIENT_EXTRA.LASTPRTDATE2]:'||V_PATNO);
          INSERT_CNT:=0;
          
          V_TRACK_NO := '0008';      
          INSERT INTO SYSLOG (MODULE,ACTION,REMARK,USERID,SYSTIME,PCNAME) 
          VALUES (
          'PORTAL',
          'NHS_ACT_GENALLPATLETTER',
          '[V_SYSDATE]:'||V_SYSDATE||';[v_patno]:'||V_PATNO||';[V_TRACK_NO]:'||V_TRACK_NO,
          'SYSTEM',
          SYSDATE,
          NULL);          
        END IF;
      END IF;    
    
	END LOOP;
	CLOSE C_DAYENDSTS;
  
  COMMIT;
   DBMS_OUTPUT.PUT_LINE('NHS_ACT_GENALLPATLETTER gen completed');
   RETURN O_ERRCODE;
  EXCEPTION  
WHEN OTHERS THEN
ROLLBACK;
  o_errmsg := 'An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM;
DBMS_OUTPUT.PUT_LINE('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
   RETURN -1;
END;
/