create or replace
FUNCTION "NHS_RPT_IPRECEIPTMB_SUB"(V_SLPNO    IN VARCHAR2,
                                                     V_ALLSLPNO IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
  SQLSTR VARCHAR2(32767);
  SQLTMP VARCHAR2(32767);
BEGIN
  SQLTMP := '
   SELECT ''Mother Information'' AS MB,
         ST.STNTDATE AS STNTDATE,
         ST.STNNAMT,
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
         ST.STNRLVL,
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
                  '''') AS CDESCCODE,
          ST.STNTYPE
    FROM SLIPTX ST, DPSERV DPS, DEPT DP, PACKAGE PK, CREDITPKG CPK
   WHERE ST.DSCCODE = DPS.DSCCODE(+)
     AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+)
     AND ST.PKGCODE = PK.PKGCODE(+)
     AND ST.PKGCODE = CPK.PKGCODE(+)
     AND ST.STNSTS IN (''N'', ''A'')
     AND ST.STNTYPE IN (''S'', ''R'')
     AND ST.SLPNO = ''' || V_SLPNO || '''
    UNION
   SELECT ''Baby Information'' AS MB,
         ST.STNTDATE AS STNTDATE,
         ST.STNNAMT,
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
         ST.STNRLVL,
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
                '''') AS CDESCCODE,
          ST.STNTYPE
    FROM SLIPTX ST, DPSERV DPS, DEPT DP, PACKAGE PK, CREDITPKG CPK
   WHERE ST.DSCCODE = DPS.DSCCODE(+)
     AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+)
     AND ST.PKGCODE = PK.PKGCODE(+)
     AND ST.PKGCODE = CPK.PKGCODE(+)
     AND ST.STNSTS IN (''N'', ''A'')
     AND ST.STNTYPE IN (''S'', ''R'')
     AND ST.SLPNO IN (' || V_ALLSLPNO || ') ';

  SQLSTR := '
    SELECT MB, TO_CHAR(STNTDATE, ''DDMONYYYY'', ''nls_date_language=ENGLISH'') AS STNTDATE,
				DESCRIPTION,SUM(STNNAMT) AS AMOUNT, DECODE(STNTYPE,''S'',NULL,''R'',NULL,CDESCCODE) AS CDESCCODE FROM ( ' ||
            SQLTMP ||
            ' ) TB1 WHERE TB1.STNRLVL <> 3
        GROUP BY MB,STNTDATE,DESCRIPTION,CDESCCODE,STNTYPE
    UNION ALL
    SELECT MB, TO_CHAR(STNTDATE, ''DDMONYYYY'', ''nls_date_language=ENGLISH'') AS STNTDATE,
				DESCRIPTION,STNNAMT AS AMOUNT, DECODE(STNTYPE,''S'',NULL,''R'',NULL,CDESCCODE) AS CDESCCODE FROM ( ' ||
            SQLTMP || ' ) TB2 WHERE STNRLVL = 3 ';
  OPEN OUTCUR FOR SQLSTR;
  RETURN OUTCUR;
END NHS_RPT_IPRECEIPTMB_SUB;
/