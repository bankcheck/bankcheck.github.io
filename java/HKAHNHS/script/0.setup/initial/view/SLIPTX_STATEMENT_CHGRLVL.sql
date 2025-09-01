    CREATE OR REPLACE FORCE VIEW "HKAH"."SLIPTX_IPSTATEMENT_CHGRLVL" ("SLPNO", "STNID", "STNXREF", "STNTYPE", "STNTDATE", "STNBAMT", "STNNAMT", "STNRLVL", "STNDESC", "STNDESC1", "STNSTS", "UNIT", "ITMTYPE", "DSCCODE", "PKGCODE", "GLCCODE", "ITMCODE", "DOCCODE") AS 
  SELECT STX.SLPNO ,
    STX.Stnid ,
    Stx.Stnxref ,
    Stx.Stntype ,
    STX.STNTDATE,
    STX.Stnbamt ,
    STX.Stnnamt ,
    to_number(NHS_GET_ARCSLPRLVL(S.ARCCODE,S.SLPTYPE,STX.STNRLVL,STX.DSCCODE,STX.PKGCODE)) AS STNRLVL,
    STX.Stndesc ,
    STX.Stndesc1,
    STX.STNSTS ,
    STX.Unit ,
    STX.Itmtype ,
    STX.Dsccode ,
    Stx.Pkgcode ,
    Stx.Glccode,
    STX.ITMCODE,
    STX.DOCCODE
  FROM SLIPTX STX,
    SLIP S
  WHERE Stx.Slpno = S.Slpno
  And Stx.Stnsts In ('N', 'A');