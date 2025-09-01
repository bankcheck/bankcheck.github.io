create or replace
FUNCTION                "NHS_RPT_IPRECEIPT_SUB"(V_ALLSLPNO IN VARCHAR2,V_SPRNRANGE IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
  SQLSTR VARCHAR2(32767);
BEGIN
  Sqlstr := '
    SELECT TO_CHAR(STNTDATE, ''DDMONYYYY'', ''nls_date_language=ENGLISH'') AS STNTDATE,
			AMOUNT, DESCRIPTION, DECODE(STNTYPE,''S'',NULL,''R'',NULL,CDESCCODE) AS CDESCCODE,
			STNTDATE as STNTDATESORT
    FROM (
      SELECT TB.STNTDATE, SUM(TB.STNNAMT) AMOUNT, TB.STNTYPE, TB.DESCRIPTION, MAX(CDESCCODE) CDESCCODE
        FROM (SELECT ST.STNTDATE AS STNTDATE,
                     ST.STNNAMT, ST.STNTYPE,
                     UPPER(DECODE(ST.STNRLVL,
                                  1,
                                  DPS.DSCDESC||''  '',
                                  2,
                                  DP.DPTNAME||''  '',
                                  3,
                                  ST.STNDESC || '' '' || ST.STNDESC1 || '' '',
                                  4,
                                  PK.PKGNAME||CPK.PKGNAME||'' '',
                                  '''')) DESCRIPTION,
                    DECODE(ST.STNRLVL,
                            1,
                            (
                              SELECT DESCRIPTION
                              FROM DESCRIPTION_MAPPING
                              WHERE TYPE || ''.'' || ID = ''DEPSERVICE.''||DPS.DSCCODE
                            ),
                            2,
                            (
                              SELECT DESCRIPTION
                              FROM DESCRIPTION_MAPPING
                              WHERE TYPE || ''.'' || ID = ''DEPARTMENT.''||DP.DPTCODE
                            ),
                            3,
                            (
                              SELECT DESCRIPTION
                              FROM DESCRIPTION_MAPPING
                              WHERE TYPE || ''.'' || ID =
                                        DECODE(ST.STNTYPE,
                                                ''S'',
                                                ''PAYMENTMETHOD.''|| (SELECT CT.CTXMETH
                                                                    FROM CASHTX CT, SLIPTX TX
                                                                    WHERE CT.CTXID = TX.STNXREF
                                                                    AND TX.STNID = ST.STNID),
                                                ''R'',
                                                ''PAYMENTMETHOD.''|| (SELECT CT.CTXMETH
                                                                    FROM CASHTX CT, SLIPTX TX
                                                                    WHERE CT.CTXID = TX.STNXREF
                                                                    AND TX.STNID = ST.STNID),
                                                ''ITEM.''||ST.ITMCODE)
                            ),
                            4,
                            (
                              SELECT DESCRIPTION
                              FROM DESCRIPTION_MAPPING
                              WHERE TYPE || ''.'' || ID = ''PACKAGE.''||PK.PKGCODE
                            ),
                            '''') AS CDESCCODE
                FROM SLIPTX ST, DPSERV DPS, DEPT DP, PACKAGE PK,CREDITPKG CPK
               WHERE ST.DSCCODE = DPS.DSCCODE(+)
                 AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+)
                 AND ST.PKGCODE = PK.PKGCODE(+)
                 AND ST.PKGCODE = CPK.PKGCODE(+)
                 AND ST.SLPNO IN (' || V_ALLSLPNO || ')
                 AND ST.STNSTS IN (''N'', ''A'')
                 AND ST.STNTYPE IN (''S'', ''R'')
                 AND ST.STNRLVL <> 3' || V_SPRNRANGE || ' ) TB
       GROUP BY TB.STNTDATE, TB.STNTYPE, TB.DESCRIPTION
      UNION ALL
      SELECT *
        FROM (SELECT ST.STNTDATE AS STNTDATE,
                     ST.STNNAMT AS AMOUNT, ST.STNTYPE,
                     ST.STNDESC AS DESCRIPTION,
                     DECODE(ST.STNRLVL,
                            1,
                            (
                              SELECT DESCRIPTION
                              FROM DESCRIPTION_MAPPING
                              WHERE TYPE || ''.'' || ID = ''DEPSERVICE.''||DPS.DSCCODE
                            ),
                            2,
                            (
                              SELECT DESCRIPTION
                              FROM DESCRIPTION_MAPPING
                              WHERE TYPE || ''.'' || ID = ''DEPARTMENT.''||DP.DPTCODE
                            ),
                            3,
                            (
                              SELECT DESCRIPTION
                              FROM DESCRIPTION_MAPPING
                              WHERE TYPE || ''.'' || ID =
                                        DECODE(ST.STNTYPE,
                                                ''S'',
                                                ''PAYMENTMETHOD.''|| (SELECT CT.CTXMETH
                                                                    FROM CASHTX CT, SLIPTX TX
                                                                    WHERE CT.CTXID = TX.STNXREF
                                                                    AND TX.STNID = ST.STNID),
                                                ''R'',
                                                ''PAYMENTMETHOD.''|| (SELECT CT.CTXMETH
                                                                    FROM CASHTX CT, SLIPTX TX
                                                                    WHERE CT.CTXID = TX.STNXREF
                                                                    AND TX.STNID = ST.STNID),
                                                ''ITEM.''||ST.ITMCODE)
                            ),
                            4,
                            (
                              SELECT DESCRIPTION
                              FROM DESCRIPTION_MAPPING
                              WHERE TYPE || ''.'' || ID = ''PACKAGE.''||PK.PKGCODE
                            ),
                            '''') AS CDESCCODE
                FROM SLIPTX ST, DPSERV DPS, DEPT DP, PACKAGE PK
               WHERE ST.DSCCODE = DPS.DSCCODE(+)
                 AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+)
                 AND ST.PKGCODE = PK.PKGCODE(+)
                 AND ST.SLPNO IN (' || V_ALLSLPNO || ')
                 AND ST.STNSTS IN (''N'', ''A'') ';
              If Get_Current_Stecode = 'HKAH' Then      
                 Sqlstr:=Sqlstr||' AND ST.STNTYPE IN (''S'', ''R'', ''I'')';
              Else
                 Sqlstr:=Sqlstr||' AND ST.STNTYPE IN (''S'', ''R'' )'; 
              End If;
                 Sqlstr:=Sqlstr||' AND ST.STNRLVL = 3
                 ' || V_SPRNRANGE || ' ) TB2) order by STNTDATESORT asc ';

  OPEN OUTCUR FOR SQLSTR;
  RETURN OUTCUR;
END NHS_RPT_IPRECEIPT_SUB;
/