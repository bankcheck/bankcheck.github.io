CREATE OR REPLACE FUNCTION "NHS_UTL_SLIP" (
  v_action     IN VARCHAR2,
  v_actionType IN VARCHAR2,
  v_RegID 	 IN NUMBER,
  v_slpno      IN VARCHAR2,
  o_errmsg     OUT VARCHAR2
)
  RETURN NUMBER
AS
  o_errcode NUMBER(22,0);
  v_noOfRec NUMBER(22,0);
  v_dpsid   NUMBER(22,0);
  v_rtn BOOLEAN;
  e_general exception;
BEGIN
  o_errcode := 0;
  o_errmsg := '';
  SELECT count(1) INTO v_noOfRec FROM SLIP WHERE slpno = v_slpno;
  IF v_action = 'MOD' THEN
    IF v_noOfRec > 0 THEN
      IF v_actionType = 'open' THEN
        -- status close to open
        UPDATE SLIP SET SLPADOC = '', SLPSTS = 'A', SLPASCM = '' WHERE SLPNO = v_slpno and SLPSTS ='C';

        SELECT count(1) INTO v_noOfRec FROM DEPOSIT WHERE DPSSTS = 'A' and SLPNO_S = v_slpno;
        IF v_noOfRec > 0 then
          SELECT MIN(DPSID) INTO v_dpsid FROM DEPOSIT WHERE DPSSTS = 'A' and SLPNO_S = v_slpno;
        ELSE
          v_dpsid := 0;
        END IF;

        IF v_dpsid IS NOT NULL AND v_dpsid <> 0 THEN
          -- UpdateSliptxStatus
          o_errcode := NHS_ACT_UPDATESLIPTXSTATUS(v_action, v_slpno, 'O', 'X', '', '', o_errmsg);
          Update DEPOSIT set DPSSTS = 'N' where DPSID = v_dpsid;
        end if ;
        -- UpdateSlip
        NHS_UTL_UPDATESLIP(v_slpno);
        -- UnConfirmDeposit
        o_errcode := NHS_SYS_UNCONFIRMDEPOSIT(v_action, v_slpno, o_errmsg);
      ELSIF v_actionType = 'reactive' THEN
        -- status remove to active
        UPDATE SLIP SET SLPSTS = 'A' WHERE SLPNO = v_slpno AND SLPSTS = 'R';
      ElSIF v_actionType = 'close' THEN
        -- check whether can close slip
        v_rtn := NHS_UTL_CanCloseIPSlip(v_RegID,v_slpno);
        IF v_rtn = FALSE THEN
          o_errmsg := 'The slip cannot be closed:' || v_slpno || '.';
          raise e_general;
        END IF;
        -- check is last active slip
        v_rtn := NHS_UTL_IsLastActiveSlip(v_RegID,v_slpno);
        IF v_rtn = FALSE THEN
          o_errmsg := 'Is not last slip:' || v_slpno || '.';
          raise e_general;
        END IF;
        -- status active to close
        UPDATE SLIP SET SLPSTS = 'C' WHERE SLPNO = v_slpno AND SLPSTS = 'A';
        -- UpdateSliptxStatus
        o_errcode := NHS_ACT_UPDATESLIPTXSTATUS(v_action, v_slpno, 'X', 'O', '', '', o_errmsg);
        -- UpdateSlip
        NHS_UTL_UPDATESLIP(v_slpno);
        -- ConfirmDeposit
        o_errcode := NHS_ACT_CONFIRMDEPOSIT(v_action, v_slpno, '', '', '', o_errmsg);

      ELSIF v_actionType = 'cancel' THEN
        -- status active to cancel
        UPDATE SLIP SET SLPSTS = 'R' WHERE SLPNO = v_slpno;
      ElSE
        --ADD NORMAL SQL MOD
        o_errcode :=0;
      END IF;
    ELSE
      o_errcode := -1;
      o_errmsg := 'Fail to update due to record not exist.';
    END IF;
  ELSE
      o_errcode := -1;
      o_errmsg := 'parameter error.';
  END IF;
  RETURN o_errcode;

  EXCEPTION
    WHEN e_general THEN
      dbms_output.put_line('An instance was encountered - ' || o_errmsg);
      RETURN -1;
    WHEN OTHERS THEN
      dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
      RETURN -1;
END NHS_UTL_SLIP;
/
