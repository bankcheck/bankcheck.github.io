DROP VIEW SLIPTX_EDI;
COMMIT;

CREATE OR REPLACE FORCE VIEW "SLIPTX_EDI" ("STNTDATE", "SLPNO", "AMOUNT", "DESCRIPTION", "QTY", "STNTYPE", "STNRLVL", "ITMTYPE", "ITMCODE", "PKGCODE", "DOCCODE")
AS
  SELECT TB.STNTDATE STNTDATE,
    TB.SLPNO,
    SUM(TB.STNNAMT) AMOUNT,
    TB.DESCRIPTION,
    TB.QTY AS QTY,
    TB.STNTYPE,
    TB.STNRLVL,
    MIN(Tb.Itmtype) Itmtype,
    tb.itmcode itmcode,
    Tb.Pkgcode,
    TB.doccode
  FROM
    (SELECT TO_DATE(TO_CHAR(ST.STNTDATE, 'DD/MM/YYYY')
      || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') STNTDATE,
      ST.SLPNO,
      ST.STNBAMT,
      ST.STNNAMT,
      UPPER(DECODE(
      CASE
        WHEN PK.PKGCODE IS NULL
        THEN ST.STNRLVL
          --   Else (Decode(St.Itmtype,'H',4,3))
        ELSE (DECODE(ST.ITMTYPE,'H',4,4))
      END, 4, PK.PKGNAME
      ||' ', 5, PK.PKGNAME
      ||' ', 7, PK.PKGNAME
      ||' ', ST.STNDESC
      || ' '
      ||ST.STNDESC1
      ||' ')) DESCRIPTION,
      (
      CASE
        WHEN PK.PKGCODE IS NULL
        THEN St.Unit
        ELSE (DECODE(ST.ITMTYPE,'H',1,1))
      END) AS QTY,
      ST.STNTYPE,
      (
      CASE
        WHEN PK.PKGCODE IS NULL
        THEN ST.ITMTYPE
        ELSE 'D'
      END) AS ITMTYPE,
      ST.STNRLVL,
      (
      CASE
        WHEN PK.PKGCODE IS NULL
        THEN St.Itmcode
          --ELSE (DECODE(ST.ITMTYPE,'H',PK.PKGCODE,'D',ST.ITMCODE))
        ELSE PK.PKGCODE
      END) AS ITMCODE,
      Pk.Pkgcode,
      St.Stnid,
      (
      CASE
        WHEN PK.PKGCODE IS NULL
        THEN ST.DOCCODE
        ELSE S.DOCCODE
      END) AS DOCCODE
    FROM SLIPTX ST,
      SLIP S,
      PACKAGE Pk
    WHERE ST.PKGCODE    = PK.PKGCODE(+)
    AND ST.SLPNO        = S.SLPNO
    AND ST.STNSTS      IN ('N', 'A')
    AND ST.STNTYPE NOT IN ('R','C','S','P')
    ) Tb
  GROUP BY TB.STNTDATE,
    TB.SLPNO,
    TB.DESCRIPTION,
    TB.QTY,
    TB.STNTYPE,
    TB.STNRLVL,
    tb.itmcode,
    Tb.Pkgcode,
    TB.DOCCODE;
/