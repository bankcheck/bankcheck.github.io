create or replace
FUNCTION "NHS_LIS_TRANSACTION_CREDIT"
(V_SLPNO   IN VARCHAR2, V_STNTYPE IN VARCHAR2)
  RETURN TYPES.CURSOR_TYPE
  AS
  OUTCUR TYPES.CURSOR_TYPE;
BEGIN
  OPEN OUTCUR FOR
      Select StnSeq, PkgCode, ItmCode, StnDisc, StnBAmt, DocCode
          ,  to_char(StnTDate,'dd-mm-yyyy') as StnTDate, DscCode, StnSts, StnDesc
      from SlipTx
      where SlpNo=v_slpno
       and (StnSts='N' or StnSts='A')
       and StnType=V_STNTYPE
      order by StnSeq Desc;
  RETURN OUTCUR;
END;
/
