CREATE OR REPLACE FUNCTION "NHS_LIS_TRANSACTION_DETAIL_C"(V_SLPNO   IN VARCHAR2,
                                                          V_STNTYPE IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE AS
  OUTCUR TYPES.CURSOR_TYPE;
BEGIN
  OPEN OUTCUR FOR
    SELECT SX.STNSEQ,
           SX.PKGCODE,
           XR.STNID,
           SX.ITMCODE,
           SX.ITMTYPE,
           SX.STNDESC || ' ' || SX.STNDESC1 AS STNDESC,
           SX.UNIT,
           SX.IREFNO,
           SX.STNDISC,
           SX.STNNAMT,
           SX.STNBAMT,
           D.DOCCODE,
           TO_CHAR(SX.STNTDATE, 'dd/MM/YYYY'),
           SX.DSCCODE,
           SX.STNSTS,
           SP.SPCNAME,
           SX.USRID,
           SX.ACMCODE,
           SX.STNRLVL,
           TO_CHAR(SX.STNCDATE, 'dd/MM/YYYY'),
           SX.GLCCODE,
           D.DOCFNAME || ' ' || D.DOCGNAME,
           SX.STNID,
           TO_CHAR(SX.STNADOC, 'dd/MM/YYYY'),
           SX.STNXREF,
           XR.XRGID,
           SX.STNTYPE,
           SX.STNCPSFLAG,
           SX.DIXREF,
           SX.STNOAMT,
           SX.STNASCM,
           SX.STNDESC,
           SX.STNDESC1,
           SX.STNDIFLAG
      FROM SLIPTX SX, DOCTOR D, SPEC SP, ITEM I, XREG XR
     WHERE SX.ITMCODE = I.ITMCODE(+)
       AND SX.DOCCODE = D.DOCCODE
       AND D.SPCCODE = SP.SPCCODE
       AND SX.DIXREF = XR.STNID(+)
       AND SX.SLPNO = V_SLPNO
       AND (SX.STNSTS = 'N' OR SX.STNSTS = 'A')
       AND I.ITMCAT = V_STNTYPE
     ORDER BY SX.STNSEQ DESC;
  RETURN OUTCUR;
END NHS_LIS_TRANSACTION_DETAIL_C;
/
