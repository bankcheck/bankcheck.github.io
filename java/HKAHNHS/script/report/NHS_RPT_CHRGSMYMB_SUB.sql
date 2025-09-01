create or replace
FUNCTION "NHS_RPT_CHRGSMYMB_SUB"(
  V_PSLPNO    IN VARCHAR2,
  V_ALLSLPNO IN VARCHAR2,
  V_SPRNRANGE IN VARCHAR2
)
  RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
  SQLTMP1 VARCHAR2(32767);
  SQLTMP2 VARCHAR2(32767);
  SQLSTR VARCHAR2(32767);
BEGIN
  SQLTMP1 := '
    SELECT ST.STNTDATE STNTDATE, ST.STNBAMT, ST.STNNAMT,
           UPPER(DECODE(ST.STNRLVL, 1, DPS.DSCDESC||''  '', 2, DP.DPTNAME||''  '',
                  3, ST.STNDESC || '' ''||ST.STNDESC1, 4, PK.PKGNAME||CPK.PKGNAME||'' '',
                  5, PK.PKGNAME||CPK.PKGNAME||'' '', 6, DPS.DSCDESC||'' ''||ST.STNDESC||''  ''||ST.STNDESC1,
                  7, PK.PKGNAME||CPK.PKGNAME||'' '', NULL)) DESCRIPTION,
           ST.UNIT AS QTY, DECODE(ST.STNRLVL,5,''D'',4,''W'',ST.ITMTYPE) AS ITMTYPE,
           DECODE(ST.STNRLVL,4,''D'',ST.STNTYPE) STNTYPE, DECODE(ST.STNRLVL,4,NULL,7,NULL,DPS.DSCCODE) AS DSCCODE,
           CASE WHEN ST.STNRLVL=4 THEN NULL  WHEN ST.ITMTYPE<>''D'' OR ITMTYPE IS NULL THEN NULL
           ELSE ST.DOCCODE END AS DOCCODE,
           DECODE(ST.STNRLVL,  1,  ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''DEPSERVICE.''||DPS.DSCCODE),
                  2, ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''DEPARTMENT.''||DP.DPTCODE ),
                  3, ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''ITEM.''||ST.ITMCODE ),
                  4, ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''PACKAGE.''||PK.PKGCODE ),
                  5, ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''PACKAGE.''||PK.PKGCODE ),
                  6, ( ( SELECT DESCRIPTION  FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''DEPSERVICE.''||DPS.DSCCODE )
                        ||'' ''||
                       ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''ITEM.''||ST.ITMCODE ) ),
                  7, ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''PACKAGE.''||PK.PKGCODE ) ) AS CDESCCODE
      FROM SLIPTX ST, DPSERV DPS, DEPT DP, PACKAGE PK,CREDITPKG CPK
     WHERE ST.DSCCODE = DPS.DSCCODE(+) AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+) AND ST.PKGCODE = PK.PKGCODE(+)
       AND ST.PKGCODE = CPK.PKGCODE(+) AND ST.STNSTS IN (''N'', ''A'') AND ST.STNTYPE NOT IN (''S'', ''R'')
       AND ST.SLPNO IN (' || V_PSLPNO || ') ' || V_SPRNRANGE || ' ';
  SQLTMP2 := '
    SELECT ST.STNTDATE STNTDATE, ST.STNBAMT, ST.STNNAMT,
           UPPER(DECODE(ST.STNRLVL, 1, DPS.DSCDESC||''  '', 2, DP.DPTNAME||''  '',
                  3, ST.STNDESC || '' ''||ST.STNDESC1, 4, PK.PKGNAME||CPK.PKGNAME||'' '',
                  5, PK.PKGNAME||CPK.PKGNAME||'' '', 6, DPS.DSCDESC||'' ''||ST.STNDESC||''  ''||ST.STNDESC1,
                  7, PK.PKGNAME||CPK.PKGNAME||'' '', NULL)) DESCRIPTION,
           ST.UNIT AS QTY, DECODE(ST.STNRLVL,5,''D'',4,''W'',ST.ITMTYPE) AS ITMTYPE,
           DECODE(ST.STNRLVL,4,''D'',ST.STNTYPE) STNTYPE, DECODE(ST.STNRLVL,4,NULL,7,NULL,DPS.DSCCODE) AS DSCCODE,
           CASE WHEN ST.STNRLVL=4 THEN NULL ELSE ST.DOCCODE END AS DOCCODE,
           DECODE(ST.STNRLVL,  1,  ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''DEPSERVICE.''||DPS.DSCCODE),
                  2, ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''DEPARTMENT.''||DP.DPTCODE ),
                  3, ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''ITEM.''||ST.ITMCODE ),
                  4, ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''PACKAGE.''||PK.PKGCODE ),
                  5, ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''PACKAGE.''||PK.PKGCODE ),
                  6, ( ( SELECT DESCRIPTION  FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''DEPSERVICE.''||DPS.DSCCODE )
                        ||'' ''||
                       ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''ITEM.''||ST.ITMCODE ) ),
                  7, ( SELECT DESCRIPTION FROM DESCRIPTION_MAPPING WHERE TYPE || ''.'' || ID = ''PACKAGE.''||PK.PKGCODE ) ) AS CDESCCODE
      FROM SLIPTX ST, DPSERV DPS, DEPT DP, PACKAGE PK,CREDITPKG CPK
     WHERE ST.DSCCODE = DPS.DSCCODE(+) AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+)
       AND ST.PKGCODE = PK.PKGCODE(+) AND ST.PKGCODE = CPK.PKGCODE(+)
       AND ST.STNSTS IN (''N'', ''A'') AND ST.STNTYPE NOT IN (''S'', ''R'')
       AND ST.SLPNO IN (' || V_ALLSLPNO || ') ' || V_SPRNRANGE || '
  ';

  SQLSTR := '
    SELECT DESCRIPTION, QTY, AMOUNT, STNTYPE, ITMTYPE, CASE WHEN ITMTYPE<>''D'' THEN NULL
           ELSE DOCCODE END AS DOCCODE, CASE WHEN ITMTYPE<>''D'' THEN NULL
           ELSE DOCNAME END AS DOCNAME, CASE WHEN ITMTYPE<>''D'' THEN NULL
           ELSE DOCCNAME END AS DOCCNAME,
           CDESCCODE
    FROM (
            SELECT DESCRIPTION,QTY,AMOUNT,STNTYPE,ITMTYPE, T.DOCCODE,
                    D.DOCFNAME||'' ''||D.DOCGNAME AS DOCNAME, D.DOCCNAME, CDESCCODE
            FROM (
                  SELECT  SUM(TB.STNBAMT) AMOUNT, TB.DESCRIPTION, 1 AS QTY, STNTYPE, ITMTYPE, DOCCODE, DSCCODE, MAX(CDESCCODE) CDESCCODE
                  FROM (
                          ' ||SQLTMP1 ||'
                          AND ST.STNTYPE <> ''R'' AND ST.STNRLVL NOT IN (3,6)
                          UNION ALL
                          ' ||SQLTMP2 ||'
                          AND ST.STNTYPE <> ''R'' AND ST.STNRLVL NOT IN (3,6)) TB
                  GROUP BY STNTYPE,ITMTYPE,DOCCODE,DSCCODE, DESCRIPTION
                  UNION ALL
                  SELECT SUM(TB2.STNBAMT) AMOUNT, TB2.DESCRIPTION,SUM(QTY) QTY,STNTYPE,ITMTYPE,DOCCODE,DSCCODE, MAX(CDESCCODE) CDESCCODE
                  FROM (
                          ' ||SQLTMP1 ||'
                          AND ST.STNTYPE <> ''R'' AND ST.STNRLVL IN (3,6)
                          UNION ALL
                          ' ||SQLTMP2 ||'
                          AND ST.STNTYPE <> ''R'' AND ST.STNRLVL IN (3,6)) TB2
                  GROUP BY  STNTYPE,ITMTYPE,DOCCODE,DSCCODE, DESCRIPTION
                  UNION ALL

                  SELECT SUM(AMOUNT) AMOUNT, DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, DSCCODE, CDESCCODE
                  FROM (
                        SELECT SUM(TB4.STNNAMT - TB4.STNBAMT) AMOUNT, ''DOCTOR DISCOUNT'' AS DESCRIPTION ,1 AS QTY,
                                ''C'' AS STNTYPE,''D'' AS ITMTYPE,'''' AS DOCCODE,'''' AS DSCCODE, '''' AS CDESCCODE
                        FROM (
                              ' ||SQLTMP1 ||'
                              UNION ALL
                              ' ||SQLTMP2 ||'
                        ) TB4
                        WHERE STNTYPE IN (''D'', ''O'')
                        AND ITMTYPE = ''D''
                        GROUP BY  STNTYPE,ITMTYPE,DOCCODE,DSCCODE, DESCRIPTION
                      )
                  WHERE AMOUNT <> 0
                  GROUP BY  DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, DSCCODE, CDESCCODE

                  UNION ALL

                  SELECT SUM(AMOUNT) AMOUNT, DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, DSCCODE, CDESCCODE
                  FROM (
                        SELECT SUM(TB3.STNNAMT - TB3.STNBAMT) AMOUNT, ''HOSPITAL DISCOUNT'' AS DESCRIPTION ,1 AS QTY,
                                ''C'' AS STNTYPE,''H'' AS ITMTYPE,'''' AS DOCCODE,'''' AS DSCCODE, '''' AS CDESCCODE
                        FROM (
                              ' ||SQLTMP1 ||'
                              UNION ALL
                              ' ||SQLTMP2 ||'
                        ) TB3
                        WHERE STNTYPE IN (''D'', ''O'')
                        AND ITMTYPE = ''H''
                        GROUP BY  STNTYPE,ITMTYPE,DOCCODE,DSCCODE, DESCRIPTION
                      )
                  WHERE AMOUNT <> 0
                  GROUP BY  DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, DSCCODE, CDESCCODE

                  UNION ALL

                  SELECT SUM(AMOUNT) AMOUNT, DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, DSCCODE, CDESCCODE
                  FROM (
                        SELECT SUM(TB6.STNNAMT - TB6.STNBAMT) AMOUNT, ''OTHER DISCOUNT'' AS DESCRIPTION ,1 AS QTY,
                                ''C'' AS STNTYPE,''O'' AS ITMTYPE,'''' AS DOCCODE,'''' AS DSCCODE, '''' AS CDESCCODE
                        FROM (
                              ' ||SQLTMP1 ||'
                              UNION ALL
                              ' ||SQLTMP2 ||'
                        ) TB6
                        WHERE STNTYPE IN (''D'', ''O'')
                        AND ITMTYPE = ''O''
                        GROUP BY  STNTYPE,ITMTYPE,DOCCODE,DSCCODE, DESCRIPTION
                      )
                  WHERE AMOUNT <> 0
                  GROUP BY  DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, DSCCODE, CDESCCODE

                  UNION ALL

                  SELECT SUM(AMOUNT) AMOUNT, DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, DSCCODE, CDESCCODE
                  FROM (
                        SELECT SUM(TB5.STNNAMT - TB5.STNBAMT) AMOUNT, ''SPECIAL DISCOUNT'' AS DESCRIPTION ,1 AS QTY,
                                ''C'' AS STNTYPE,''S'' AS ITMTYPE,'''' AS DOCCODE,'''' AS DSCCODE, '''' AS CDESCCODE
                        FROM (
                              ' ||SQLTMP1 ||'
                              UNION ALL
                              ' ||SQLTMP2 ||'
                        ) TB5
                        WHERE STNTYPE IN (''D'', ''O'')
                        AND ITMTYPE = ''S''
                        GROUP BY  STNTYPE,ITMTYPE,DOCCODE,DSCCODE, DESCRIPTION
                      )
                  WHERE AMOUNT <> 0
                  GROUP BY  DESCRIPTION, QTY, STNTYPE, ITMTYPE, DOCCODE, DSCCODE, CDESCCODE
            ) T,DOCTOR D
            WHERE T.DOCCODE=D.DOCCODE(+)
        )
    ORDER BY DECODE(STNTYPE, ''D'', 1, ''O'', 2, ''R'', 3, ''P'', 4, ''C'', 5, ''S'', 6, ''I'', 7, 8), ITMTYPE, DOCNAME, DESCRIPTION ';

  OPEN OUTCUR FOR SQLSTR;
  RETURN OUTCUR;
END NHS_RPT_CHRGSMYMB_SUB;
/