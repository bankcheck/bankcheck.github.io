
  CREATE OR REPLACE FORCE VIEW "HKAH"."V_IPSTATEMENTWB_WITHU" ("STNTDATE", "STNCDATE", "STNTDATE_C", "SLPNO", "STNSEQ", "STNSTS", "STNBAMT", "STNNAMT", "DESCRIPTION", "ITMCODE", "QTY", "STNTYPE", "ITMTYPE", "STNRLVL", "CDESCCODE") AS 
  SELECT TRUNC(ST.STNTDATE,'DD') STNTDATE,
           TRUNC(ST.STNCDATE,'DD') STNCDATE,
           TRUNC(ST.STNTDATE_C,'DD') STNTDATE_C,
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
      FROM (
        SELECT STXC.STNTDATE AS STNTDATE_C,
        STXU.STNID,
        STXU.SLPNO,
        STXU.STNSEQ,
        STXU.STNSTS,
        STXU.PKGCODE,
        STXU.ITMCODE,
        STXU.ITMTYPE,
        STXU.STNDISC,
        STXU.STNOAMT,
        STXU.STNBAMT,
        STXU.STNNAMT,
        STXU.DOCCODE,
        STXU.ACMCODE,
        STXU.GLCCODE,
        STXU.USRID,
        STXU.STNTDATE,
        STXU.STNCDATE,
        STXU.STNADOC,
        DECODE(STXU.STNSTS,'U',STXC.STNDESC,STXU.STNDESC) AS STNDESC,
        STXU.STNRLVL,
        STXU.STNTYPE,
        STXU.STNXREF,
        STXU.DSCCODE,
        STXU.DIXREF,
        STXU.STNDIDOC,
        STXU.STNDIFLAG,
        STXU.STNCPSFLAG,
        STXU.PCYID,
        STXU.STNASCM,
        STXU.UNIT,
        STXU.PCYID_O,
        STXU.TRANSVER,
        STXU.STNDESC1,
        STXU.CARDRATE,
        STXU.PAYMETHOD,
        STXU.IREFNO
        FROM SLIPTX STXU, SLIPTX STXC
        WHERE STXU.SLPNO = STXC.SLPNO 
        AND STXU.STNSTS IN ('U')
        AND STXU.STNDESC = STXC.STNSEQ) ST, 
      DPSERV DPS, DEPT DP, PACKAGE PK,CREDITPKG CPK
     WHERE ST.DSCCODE = DPS.DSCCODE(+)
       AND SUBSTR(ST.GLCCODE, 1, 4) = DP.DPTCODE(+)
       AND ST.PKGCODE = PK.PKGCODE(+)
       AND ST.PKGCODE = CPK.PKGCODE(+);
/