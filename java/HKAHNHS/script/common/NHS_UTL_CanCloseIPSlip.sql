CREATE OR REPLACE FUNCTION NHS_UTL_CanCloseIPSlip(
  a_RegID NUMBER,
  a_SlpNo VARCHAR2)
RETURN BOOLEAN
AS
  v_cnt NUMBER(22,0);
  v_Cnt2 NUMBER(22,0);
  v_CanCloseIPSlip BOOLEAN := FALSE;
  v_SLIP_STATUS_OPEN VARCHAR2(1) := 'A';
  v_REG_STS_NORMAL VARCHAR2(1) := 'N';
  v_REG_TYPE_INPATIENT VARCHAR2(1) := 'I';
BEGIN
  --check whether the inpat discharged or not!
  SELECT COUNT(*) INTO v_cnt FROM REG R, INPAT I WHERE R.INPID = I.INPID AND I.INPDDATE IS NOT NULL AND R.REGID = a_RegID;

  If  v_Cnt > 0 Then
      --discharged
      v_CanCloseIPSlip := TRUE;
  Else
      --not discharged
      SELECT COUNT(*) INTO v_Cnt2 FROM REG R, SLIP S
              WHERE S.SLPSTS = v_SLIP_STATUS_OPEN
          AND R.REGID = a_RegID
          AND S.REGID = a_RegID
          AND R.REGSTS = v_REG_STS_NORMAL
          AND R.REGTYPE = v_REG_TYPE_INPATIENT;

      If v_Cnt2 IS NULL Or v_Cnt2 <= 1 Then
          v_CanCloseIPSlip := FALSE;
      Else
          v_CanCloseIPSlip := TRUE;
      End If;
  End If;
  RETURN v_CanCloseIPSlip;

  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
      RETURN FALSE;
END NHS_UTL_CanCloseIPSlip;
/
