create or replace FUNCTION "NHS_RPT_IPSTATEMENT_SUB1"(
  V_ALLSLPNO IN VARCHAR2,
  V_SPRNRANGE IN VARCHAR2
)
  RETURN TYPES.CURSOR_TYPE AS
  OUTCUR types.CURSOR_TYPE;
  SQLTMP varchar2(20000);
  SQLSTR varchar2(32767);
  SQLSTR2 VARCHAR2(32767);
  TOTALREFUND NUMBER;
  TOTALCHARGE NUMBER;
BEGIN
--TO_DATE(TO_CHAR(ST.STNTDATE, ''DD/MM/YYYY'') || '' 00:00:00'', ''DD/MM/YYYY HH24:MI:SS'')
  SQLTMP := '
    SELECT TO_DATE(TO_CHAR(ST.STNTDATE, ''DD/MM/YYYY'') || '' 00:00:00'', ''DD/MM/YYYY HH24:MI:SS'') STNTDATE,
           ST.STNBAMT,
           ST.STNNAMT,
           UPPER(DECODE(ST.STNRLVL,
                  1,
                  DPS.DSCDESC||''  '',
                  2,
                  DP.DPTNAME||''  '',
                  3,
                  ST.STNDESC || '' ''||ST.STNDESC1||'' '',
                  4,
                  PK.PKGNAME||CPK.PKGNAME||'' '',
                  5,
                  PK.PKGNAME||CPK.PKGNAME||'' '',
                  6,
                  DPS.DSCDESC||'' ''||ST.STNDESC||''  ''||ST.STNDESC1||'' '',
                  7,
                  PK.PKGNAME||CPK.PKGNAME||'' '',
                  NULL)) DESCRIPTION,
           ST.UNIT AS QTY,
           ST.STNTYPE, ST.ITMTYPE, ST.STNRLVL,
           DECODE(ST.STNRLVL,
                  1,NHS_GET_DESCMAPPING(''DEPSERVICE.''||DPS.DSCCODE),
                  2,NHS_GET_DESCMAPPING(''DEPARTMENT.''||DP.DPTCODE),
                  3,NHS_GET_DESCMAPPING(DECODE(ST.STNTYPE,
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
                                      ''ITEM.''||ST.ITMCODE)),
                  4,NHS_GET_DESCMAPPING(''PACKAGE.''||PK.PKGCODE),
                  5,NHS_GET_DESCMAPPING(''PACKAGE.''||PK.PKGCODE),
                  6,(NHS_GET_DESCMAPPING(''DEPSERVICE.''||DPS.DSCCODE)||'' ''||
                     NHS_GET_DESCMAPPING(DECODE(ST.STNTYPE,
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
                                      ''ITEM.''||ST.ITMCODE))),
                  7,NHS_GET_DESCMAPPING(''PACKAGE.''||PK.PKGCODE) ) AS CDESCCODE
      FROM SLIPTX_IPSTATEMENT_CHGRLVL ST, DPSERV DPS, DEPT DP, PACKAGE PK,CREDITPKG CPK
     WHERE ST.DSCCODE = DPS.DSCCODE(+)
       AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+)
       AND ST.PKGCODE = PK.PKGCODE(+)
       AND ST.PKGCODE = CPK.PKGCODE(+)
       AND ST.STNSTS IN (''N'', ''A'')
       AND ST.SLPNO IN (' || V_ALLSLPNO || ') '
       || V_SPRNRANGE || '
  ';

  EXECUTE IMMEDIATE ' SELECT NVL(SUM(STNNAMT),0) FROM ( ' ||SQLTMP ||
                    ' AND STNTYPE=''R'' )' INTO TOTALREFUND;
  EXECUTE IMMEDIATE ' SELECT NVL(SUM(STNNAMT),0) FROM ( ' ||SQLTMP ||
                    ' AND STNTYPE IN (''D'',''O'',''X'') )' INTO TOTALCHARGE;

  SQLSTR := '
    SELECT TO_CHAR(STNTDATE, ''DD/MM/YYYY'') AS STNTDATE,AMOUNT,DESCRIPTION,QTY,
      ' ||TOTALREFUND ||' AS TOTALREFUND,' ||TOTALCHARGE ||' AS TOTALCHARGE,
      DECODE(STNTYPE,''S'',NULL,''R'',NULL,CDESCCODE) AS CDESCCODE,
      DECODE(STNRLVL, 4, 4, 7, 5,
                DECODE(STNTYPE, ''D'',
                      DECODE(ITMTYPE, ''D'', 1, ''H'', 2, ''S'', 3, 99),
                      ''R'', 10, ''P'', 9, ''C'', 8, ''S'', 7, ''I'', 6, ''O'', 6, ''X'', 6, 99)) AS ITEMORDER,
      STNTDATE TDATE
    FROM (
      SELECT TB.STNTDATE STNTDATE, SUM(TB.STNBAMT) AMOUNT, TB.DESCRIPTION,1 AS QTY, TB.STNTYPE, TB.STNRLVL, MIN(TB.ITMTYPE) ITMTYPE,
              MAX(TB.CDESCCODE) CDESCCODE
        FROM (  ' ||SQLTMP ||'
                 AND ST.STNTYPE <> ''R''
                 AND ST.STNRLVL NOT IN (3,6)) TB
        GROUP BY STNTDATE, DESCRIPTION , STNTYPE, STNRLVL
      UNION ALL
      SELECT TB2.STNTDATE STNTDATE, TB2.STNBAMT AMOUNT, TB2.DESCRIPTION, TB2.QTY QTY, TB2.STNTYPE, TB2.STNRLVL,
              TB2.ITMTYPE, TB2.CDESCCODE CDESCCODE
        FROM (  ' ||SQLTMP ||'
                 AND ST.STNTYPE <> ''R''
                 AND ST.STNRLVL IN (3,6)) TB2

      UNION ALL

      SELECT STNTDATE, SUM(AMOUNT) AMOUNT, DESCRIPTION, QTY, STNTYPE, STNRLVL, ITMTYPE, CDESCCODE
      FROM (
              SELECT SUM(TB4.STNNAMT - TB4.STNBAMT) AMOUNT, ''DOCTOR DISCOUNT'' AS DESCRIPTION ,1 AS QTY,
                      ''C'' AS STNTYPE,''D'' AS ITMTYPE, 1 AS STNRLVL, '''' AS CDESCCODE,
                      TO_DATE(''31/12/9999'',''DD/MM/YYYY'') AS STNTDATE
              FROM (
                    ' ||SQLTMP ||'
              ) TB4
              WHERE STNTYPE IN (''D'', ''O'')
              AND ITMTYPE = ''D''
              GROUP BY DESCRIPTION , STNTYPE, STNRLVL, ITMTYPE
      )
      WHERE AMOUNT <> 0
      GROUP BY  STNTDATE, DESCRIPTION , STNTYPE, STNRLVL, STNRLVL, ITMTYPE, CDESCCODE

      UNION ALL

      SELECT STNTDATE, SUM(AMOUNT) AMOUNT, DESCRIPTION, QTY, STNTYPE, STNRLVL, ITMTYPE, CDESCCODE
      FROM (
              SELECT SUM(TB3.STNNAMT - TB3.STNBAMT) AMOUNT, ''HOSPITAL DISCOUNT'' AS DESCRIPTION ,1 AS QTY,
                      ''C'' AS STNTYPE,''H'' AS ITMTYPE, 1 AS STNRLVL, '''' AS CDESCCODE,
                      TO_DATE(''31/12/9999'',''DD/MM/YYYY'') AS STNTDATE
              FROM (
                    ' ||SQLTMP ||'
              ) TB3
              WHERE STNTYPE IN (''D'', ''O'')
              AND ITMTYPE = ''H''
              GROUP BY DESCRIPTION , STNTYPE, STNRLVL, ITMTYPE
      )
      WHERE AMOUNT <> 0
      GROUP BY  STNTDATE, DESCRIPTION , STNTYPE, STNRLVL, STNRLVL, ITMTYPE, CDESCCODE';
    
    SQLSTR2 := '

      UNION ALL

      SELECT TO_DATE(''31/12/9999'',''DD/MM/YYYY'') AS STNTDATE, SUM(AMOUNT) AMOUNT, DESCRIPTION, QTY, STNTYPE, STNRLVL, ITMTYPE, CDESCCODE
      FROM (
              SELECT SUM(TB5.STNNAMT - TB5.STNBAMT) AMOUNT, ''SPECIAL DISCOUNT'' AS DESCRIPTION ,1 AS QTY,
                      ''C'' AS STNTYPE,''S'' AS ITMTYPE, 1 AS STNRLVL, '''' AS CDESCCODE,
                      TO_DATE(''31/12/9999'',''DD/MM/YYYY'') AS STNTDATE
              FROM (
                    ' ||SQLTMP ||'
              ) TB5
              WHERE STNTYPE IN (''D'', ''O'')
              AND ITMTYPE = ''S''
              GROUP BY DESCRIPTION , STNTYPE, STNRLVL, ITMTYPE
      )
      WHERE AMOUNT <> 0
      GROUP BY  STNTDATE, DESCRIPTION , STNTYPE, STNRLVL, STNRLVL, ITMTYPE, CDESCCODE

      UNION ALL

      SELECT TO_DATE(''31/12/9999'',''DD/MM/YYYY'') AS STNTDATE, SUM(AMOUNT) AMOUNT, DESCRIPTION, QTY, STNTYPE, STNRLVL, ITMTYPE, CDESCCODE
      FROM (
              SELECT SUM(TB6.STNNAMT - TB6.STNBAMT) AMOUNT, ''OTHER DISCOUNT'' AS DESCRIPTION ,1 AS QTY,
                      ''C'' AS STNTYPE,''O'' AS ITMTYPE, 1 AS STNRLVL, '''' AS CDESCCODE,
                      TO_DATE(''31/12/9999'',''DD/MM/YYYY'') AS STNTDATE
              FROM (
                    ' ||SQLTMP ||'
              ) TB6
              WHERE STNTYPE IN (''D'', ''O'')
              AND ITMTYPE = ''O''
              GROUP BY DESCRIPTION , STNTYPE, STNRLVL, ITMTYPE
      )
      WHERE AMOUNT <> 0
      GROUP BY  STNTDATE, DESCRIPTION , STNTYPE, STNRLVL, STNRLVL, ITMTYPE, CDESCCODE

    )
    ORDER BY TDATE, ITEMORDER, case when CDESCCODE is null then 1 else 0 end, DESCRIPTION';

  OPEN OUTCUR FOR  SQLSTR||SQLSTR2;
  RETURN OUTCUR;
END NHS_RPT_IPSTATEMENT_SUB1;
/