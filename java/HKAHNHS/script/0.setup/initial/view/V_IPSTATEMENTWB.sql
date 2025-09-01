
  CREATE OR REPLACE FORCE VIEW "HKAH"."V_IPSTATEMENTWB" ("STNTDATE", "STNCDATE", "STNSDATE", "SLPNO", "STNSEQ", "STNSTS", "STNBAMT", "STNNAMT", "DESCRIPTION", "ITMCODE", "QTY", "STNTYPE", "ITMTYPE", "STNRLVL", "CDESCCODE") AS 
  SELECT TRUNC(ST.STNTDATE,'DD') STNTDATE,
           TRUNC(ST.STNCDATE,'DD') STNCDATE,
           STE.STNSDATE,
           ST.SLPNO,
           ST.STNSEQ,
           ST.STNSTS,
           ST.STNBAMT,
           ST.STNNAMT,
           UPPER(DECODE(ST.STNRLVL,
                  1,
                  DPS.DSCDESC||'  ',
                  2,
                  DP.DPTNAME||'  ',
                  3,
                  ST.STNDESC || ' '||ST.STNDESC1||' ',
                  4,
                  PK.PKGNAME||CPK.PKGNAME||' ',
                  5,
                  PK.PKGNAME||CPK.PKGNAME||' ',
                  6,
                  DPS.DSCDESC||' '||ST.STNDESC||'  '||ST.STNDESC1||' ',
                  7,
                  PK.PKGNAME||CPK.PKGNAME||' ',
                  NULL)) DESCRIPTION,
           ST.ITMCODE,
           ST.UNIT AS QTY,
           ST.STNTYPE, ST.ITMTYPE, ST.STNRLVL,
           DECODE(ST.STNRLVL,
                  1,
                  (
                    SELECT DESCRIPTION
                    FROM DESCRIPTION_MAPPING
                    WHERE TYPE || '.' || ID = 'DEPSERVICE.'||DPS.DSCCODE
                  ),
                  2,
                  (
                    SELECT DESCRIPTION
                    FROM DESCRIPTION_MAPPING
                    WHERE TYPE || '.' || ID = 'DEPARTMENT.'||DP.DPTCODE
                  ),
                  3,
                  (
                    SELECT DESCRIPTION
                    FROM DESCRIPTION_MAPPING
                    WHERE TYPE || '.' || ID =
                              DECODE(ST.STNTYPE,
                                      'S',
                                      'PAYMENTMETHOD.'|| (SELECT CT.CTXMETH
                                                          FROM CASHTX CT, SLIPTX TX
                                                          WHERE CT.CTXID = TX.STNXREF
                                                          AND TX.STNID = ST.STNID),
                                      'R',
                                      'PAYMENTMETHOD.'|| (SELECT CT.CTXMETH
                                                          FROM CASHTX CT, SLIPTX TX
                                                          WHERE CT.CTXID = TX.STNXREF
                                                          AND TX.STNID = ST.STNID),
                                      'ITEM.'||ST.ITMCODE)
                  ),
                  4,
                  (
                    SELECT DESCRIPTION
                    FROM DESCRIPTION_MAPPING
                    WHERE TYPE || '.' || ID = 'PACKAGE.'||PK.PKGCODE
                  ),
                  5,
                  (
                    SELECT DESCRIPTION
                    FROM DESCRIPTION_MAPPING
                    WHERE TYPE || '.' || ID = 'PACKAGE.'||PK.PKGCODE
                  ),
                  6,
                  (
                    (
                      SELECT DESCRIPTION
                      FROM DESCRIPTION_MAPPING
                      WHERE TYPE || '.' || ID = 'DEPSERVICE.'||DPS.DSCCODE
                    )
                    ||' '||
                    (
                      SELECT DESCRIPTION
                      FROM DESCRIPTION_MAPPING
                      WHERE TYPE || '.' || ID =
                              DECODE(ST.STNTYPE,
                                      'S',
                                      'PAYMENTMETHOD.'|| (SELECT CT.CTXMETH
                                                          FROM CASHTX CT, SLIPTX TX
                                                          WHERE CT.CTXID = TX.STNXREF
                                                          AND TX.STNID = ST.STNID),
                                      'R',
                                      'PAYMENTMETHOD.'|| (SELECT CT.CTXMETH
                                                          FROM CASHTX CT, SLIPTX TX
                                                          WHERE CT.CTXID = TX.STNXREF
                                                          AND TX.STNID = ST.STNID),
                                      'ITEM.'||ST.ITMCODE)
                    )
                  ),
                  7,
                  (
                    SELECT DESCRIPTION
                    FROM DESCRIPTION_MAPPING
                    WHERE TYPE || '.' || ID = 'PACKAGE.'||PK.PKGCODE
                  ) ) AS CDESCCODE
      FROM SLIPTX ST, DPSERV DPS, DEPT DP, PACKAGE PK,CREDITPKG CPK, SLIPTX_EXTRA STE
     WHERE ST.DSCCODE = DPS.DSCCODE(+)
       AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+)
       AND ST.PKGCODE = PK.PKGCODE(+)
       AND ST.PKGCODE = CPK.PKGCODE(+)
       AND ST.STNID = STE.STNID(+)
       AND ST.STNSTS IN ('N', 'A', 'C');

       /