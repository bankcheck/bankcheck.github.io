create or replace FUNCTION "NHS_RPT_RPTEDI_AIA_XLS"(V_ALLSLPNO IN VARCHAR2, V_ARCCODE IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE AS
    OUTCUR TYPES.CURSOR_TYPE;
    Outcur2 Types.Cursor_Type;
    outcur3 Types.Cursor_Type;
    V_ALLSLPNORP VARCHAR2(1000);
    V_SLPNOTEMP VARCHAR2(20);
    V_SLPNOTEMP1 VARCHAR2(20);
    SQLSTR VARCHAR2(32767);
    SQLSTR1 VARCHAR2(32767);
    SQLSTR2 VARCHAR2(32767);
    SQLSTR3 VARCHAR2(32767);

BEGIN
  Sqlstr3 := 'Select slpno From Slip Where SLPNO in (''' || Replace(V_Allslpno, '/', ''', ''') || ''')';

  OPEN Outcur2 FOR SQLSTR3;
		LOOP
		FETCH OUTCUR2 INTO V_SLPNOTEMP;
		EXIT WHEN OUTCUR2%NOTFOUND;
      IF V_ALLSLPNORP IS NULL OR LENGTH(V_ALLSLPNORP) = 0 THEN
          V_ALLSLPNORP := ''''||V_SLPNOTEMP||'''';
      ELSE
          V_ALLSLPNORP:= V_ALLSLPNORP||','||''''||V_SLPNOTEMP||'''';
      END IF;
        DBMS_OUTPUT.PUT_LINE('V_SLPNOTEMP = ' || V_SLPNOTEMP);
          Outcur3 := NHS_LIS_GETMERGEDSLIP(V_SLPNOTEMP);
          LOOP
              FETCH OUTCUR3 INTO V_SLPNOTEMP1;
              EXIT WHEN OUTCUR3%NOTFOUND;
              DBMS_OUTPUT.PUT_LINE('V_SLPNOTEMP1 = ' || V_SLPNOTEMP1);
              IF V_ALLSLPNORP IS NULL OR LENGTH(V_ALLSLPNORP) = 0 THEN
                V_ALLSLPNORP := ''''||V_SLPNOTEMP1||'''';
              ELSE
                V_ALLSLPNORP:= V_ALLSLPNORP||','||''''||V_SLPNOTEMP1||'''';
              END IF;
          END LOOP;
          CLOSE OUTCUR3;
    END LOOP;
  CLOSE OUTCUR2;

  
   IF V_ALLSLPNORP IS NOT NULL OR LENGTH(V_ALLSLPNORP) > 0 THEN
    V_ALLSLPNORP := '('||V_ALLSLPNORP||')';
   END IF;
   
   DBMS_OUTPUT.PUT_LINE('V_ALLSLPNORP = ' || V_ALLSLPNORP);

  SQLSTR := 'select 
    S.SLPTYPE as regType,
    ''0000035008'' as proID,
    DECODE(GET_CURRENT_STECODE(),''HKAH'',''Hong Kong Adventist Hospital-Stubbs Road'',''TWAH'',''Hong Kong Adventist Hospital-Tsuen Wan'','''') as proName,
    S.SLPNO as invNo,
    TO_CHAR(NHS_GET_EDIAXDATE(S.SLPNO),''mm/dd/yyyy'') as invdate,
    S.Slpplyno as memid,
    P.PATFNAME ||'' ''||P.PATGNAME as memName,
    TO_CHAR(R.REGDATE,''mm/dd/yyyy'') as incDate,
    NVL(SX.servType,''MS'') as servType,
    NVL(SX.IPDIAGCODE,''00000'') as diagCode,
    DECODE(S.SLPTYPE,''I'',IPDIAGNOSIS,LAYMAN_DIAGNOSIS) as diagDesc,
    '''' as diagCode2,
    '''' as diagDesc2,
    DECODE(NVL(SX.servType,''MS''),''MS'',''A9900'',HPRMK1),
    DESCRIPTION as proDesc,
    amt as preAmt,
    '''' as copay,
    '''' as start_sick,
    '''' as end_sick,
    S.SLPVCHNO as voNo,
    '''' as refProId,
    '''' as refProNA,
    '''' as refNo,
    '''' as refDate,
    '''' as remarks,
    SE.INSPREAUTHNO as refNo2,
    RANK() OVER(PARTITION BY S.SLPNO ORDER BY ROWNUM) AS SEQN,
    SX.aPackage as isAIAPackage,
    SX.IPDIAGCODE
    FROM
    (
        SELECT  SLPNO,
         UNIT,PKGCODE,
         STNRLVL,SUM(STNNAMT) as amt,DESCRIPTION,
         servType,HPRMK1,aPackage,LAYMAN_DIAGNOSIS,IPDIAGNOSIS,IPDIAGCODE
         FROM
        (SELECT 
        STX.SLPNO,STX.STNID,
        STX.ITMCODE,STX.PKGCODE,STX.STNRLVL,
        STX.STNNAMT,STX.DESCRIPTION,STX.DSCCODE, 
        STX.ARCCODE,HS.HPRMK as servType,STX.UNIT,
        HS.HPRMK1,
       DECODE(NHS_GET_COUNTEDIPACKAGE(STX.SLPNO,'''||V_ARCCODE||'''),0,''NA'',''AIA'') as aPackage,
        STX.LAYMAN_DIAGNOSIS,STX.IPDIAGNOSIS, STX.IPDIAGCODE
        FROM
          (SELECT ST.SLPNO,
            ST.STNID,
            ST.ITMCODE,
            (CASE
            WHEN (SELECT COUNT(1) FROM HPSTATUS WHERE ST.PKGCODE IN (SELECT HPSTATUS FROM HPSTATUS WHERE  HPKEY = '''||V_ARCCODE||''' AND HPTYPE = ''EDI'' AND HPRMK1 = ''PACKAGE''  AND HPACTIVE    = -1))> 0
            THEN ST.PKGCODE
            ELSE '''' END) as PKGCODE,
            ST.STNRLVL,
            ST.STNNAMT,
            1 AS unit,
            UPPER(DECODE(
            CASE
              WHEN (SELECT COUNT(1) FROM HPSTATUS WHERE ST.PKGCODE IN (SELECT HPSTATUS FROM HPSTATUS WHERE  HPKEY = '''||V_ARCCODE||''' AND HPTYPE = ''EDI'' AND HPRMK1 = ''PACKAGE'' AND HPACTIVE    = -1))> 0
              THEN 1
              ELSE ST.STNRLVL
            END, 1, DPS.DSCDESC
            ||''  '', 2, DP.DPTNAME
            ||''  '', 3, ST.STNDESC
            || '' ''
            ||ST.STNDESC1
            ||'' '', 4, PK.PKGNAME
            ||CPK.PKGNAME
            ||'' '', 5, PK.PKGNAME
            ||CPK.PKGNAME
            ||'' '', 6, DPS.DSCDESC
            ||'' ''
            ||ST.STNDESC
            ||''  ''
            ||ST.STNDESC1
            ||'' '', 7, PK.PKGNAME
            ||CPK.PKGNAME
            ||'' '')) DESCRIPTION,
            ST.DSCCODE,
            S.ARCCODE,
            OD.LAYMAN_DIAGNOSIS,
            ST.ITMTYPE,
            NHS_GET_IP_DIAGNOSIS(ST.SLPNO,''DIAG'') as IPDIAGNOSIS,
            NHS_GET_IP_DIAGNOSIS(ST.SLPNO,''ICD10'') as IPDIAGCODE
          FROM sliptx ST,
            DPSERV DPS,
            DEPT DP,
            PACKAGE PK,
            CREDITPKG CPK,
            SLIP S,
            REG R,OPD_DOCNOTE@CIS OD
          WHERE ST.DSCCODE               = DPS.DSCCODE(+)
          AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+)
          AND ST.PKGCODE               = PK.PKGCODE(+)
          AND ST.PKGCODE               = CPK.PKGCODE(+)
          AND S.SLPNO                  = ST.SLPNO
          AND ST.SLPNO = R.SLPNO(+)
          AND R.REGID = OD.REGID(+)
          AND R.PATNO = OD.PATNO(+)
          AND STNSTS                  IN (''N'', ''A'')
          AND STNTYPE NOT             IN (''R'',''C'',''S'',''P'') 
    ) STX
  LEFT JOIN HPSTATUS HS ON HS.HPKEY = '''||V_ARCCODE||''' AND HS.HPTYPE   = ''EDI'' AND (DSCCODE = HS.HPSTATUS OR DSCCODE||''_''||ITMTYPE = HS.HPSTATUS) AND HPACTIVE    = -1)
  GROUP BY DESCRIPTION,
   PKGCODE,STNRLVL,
    UNIT,SLPNO,servType,HPRMK1,aPackage,LAYMAN_DIAGNOSIS,IPDIAGNOSIS,IPDIAGCODE ORDER BY PKGCODE) SX, SLIP S, PATIENT P, REG R,SLIP_EXTRA SE 
    where sx.slpno in ';

 SQLSTR1 := ' AND S.PATNO = P.PATNO
              AND SX.SLPNO = S.SLPNO
              AND S.SLPNO = R.SLPNO(+)
              AND S.SlpNo = SE.SlpNo(+)
              order by invno,SEQN,sx.PKGCODE';
              
  DBMS_OUTPUT.PUT_LINE(SQLSTR||V_ALLSLPNORP||SQLSTR1);
  
 OPEN OUTCUR FOR SQLSTR||V_ALLSLPNORP||SQLSTR1;
  RETURN OUTCUR;
END NHS_RPT_RPTEDI_AIA_XLS;
/