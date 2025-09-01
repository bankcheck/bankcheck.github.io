CREATE OR REPLACE FUNCTION NHS_UTL_IsLastActiveSlip(
  a_RegID NUMBER,
  a_SlpNo VARCHAR2)
RETURN Boolean
AS
  v_cnt NUMBER(22,0);
  v_SLIP_STATUS_OPEN VARCHAR2(1) := 'A';
  v_IsLastActiveSlip BOOLEAN := FALSE;
BEGIN
    SELECT COUNT(*) INTO v_cnt FROM SLIP
       WHERE SLPNO <> a_SlpNo AND SLPSTS = v_SLIP_STATUS_OPEN AND REGID = a_RegID;
    If v_cnt IS NULL Or v_cnt <= 0 Then
        v_IsLastActiveSlip := TRUE;
    Else
        v_IsLastActiveSlip := FALSE;
    End If;
  RETURN v_IsLastActiveSlip;

  EXCEPTION
    WHEN OTHERS THEN
      v_IsLastActiveSlip := FALSE;
    RETURN v_IsLastActiveSlip;
END NHS_UTL_IsLastActiveSlip;
/
