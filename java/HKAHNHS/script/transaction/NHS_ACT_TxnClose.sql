CREATE OR REPLACE FUNCTION "NHS_ACT_TXNCLOSE" (
	i_Action       IN VARCHAR2,
	i_SlpNo        IN VARCHAR2,
	i_PatNo        IN VARCHAR2,
	i_ManualYN     IN VARCHAR2,
	i_DischargeYN  IN VARCHAR2,
	i_ComputerName IN VARCHAR2,
	i_UserID       IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_errcode NUMBER;
	v_Count NUMBER;
	v_SlpPayAllCheckValue VARCHAR2(1);
	v_bARLocked BOOLEAN := FALSE;
	v_SaveInfo BOOLEAN;
	v_unlockAR BOOLEAN;
	e_lock_failed EXCEPTION;
	v_ErrMsg VARCHAR2(1000);

	SLIP_PAYMENT_CHECK_NONE VARCHAR2(1) := 'N';
	SLIP_PAYMENT_CHECK_MANUAL VARCHAR2(1) := 'M';
	SLIP_PAYMENT_CHECK_AUTO VARCHAR2(1) := 'A';
	MSG_MANUAL_ALLOCATION_REQUIRED VARCHAR2(50) := 'Manual Allocation for doctor''s share is required!';
BEGIN
	o_errcode := -1;
	o_errmsg := 'OK';

	SELECT COUNT(1) INTO v_Count FROM Slip WHERE SlpNo = i_SlpNo;
	IF v_Count = 0 THEN
		o_errmsg := 'Slip not found.';
		RETURN o_errcode;
	END IF;

	-- refresh balance
	NHS_UTL_UPDATESLIP(i_SlpNo);

	-- check slip balance
	SELECT SlpCAmt + SlpPAmt + SlpDAmt INTO v_Count FROM Slip WHERE SlpNo = i_SlpNo;
	IF v_Count != 0 THEN
		o_errcode := -100;
		o_errmsg := 'Balance <> 0, cannot close the slip.';
		RAISE e_lock_failed;
	END IF;

	-- SlpPayAllCheck
	v_SlpPayAllCheckValue := NHS_UTL_SlpPayAllCheck(i_SlpNo);
	IF v_SlpPayAllCheckValue = SLIP_PAYMENT_CHECK_MANUAL AND i_ManualYN = 'N' THEN
		o_errcode := -200;
		o_errmsg := MSG_MANUAL_ALLOCATION_REQUIRED;
		RETURN o_errcode;
	ELSIF v_SlpPayAllCheckValue = SLIP_PAYMENT_CHECK_AUTO THEN
		IF NHS_UTL_SlpPayAllLockAR(i_SlpNo, i_ComputerName, i_UserID, o_errmsg) THEN
			v_bARLocked := TRUE;
		ELSE
			o_errmsg := 'Fail to lock AR. ' || o_errmsg;
			RAISE e_lock_failed;
		END IF;
	END IF;

	-- Special Commission for Patient Category
	IF NOT NHS_UTL_SCMAUTO(i_SlpNo, o_errmsg) THEN
		o_errmsg := 'Fail to call SCMAuto. ' || o_errmsg;
		RAISE e_lock_failed;
	END IF;

	v_SaveInfo := TRUE;
	SELECT COUNT(1) INTO v_Count
	FROM Reg r, Inpat i
	WHERE r.slpno = i_SlpNo
	AND   r.patno = i_PatNo
	AND   r.regsts = 'N'
	AND   r.regtype = 'I'
	AND   r.inpid = i.inpid
	AND   i.inpddate IS NULL;

	IF v_Count > 0 THEN
		IF i_DischargeYN = 'N' THEN
			o_errcode := -500;
			o_errmsg := 'This In-Patient not yet Discharged, Continue Operation ?';
			RAISE e_lock_failed;
		ELSE
			v_SaveInfo := TRUE;
		END IF;
	ELSE
		v_SaveInfo := TRUE;
	END IF;

	SELECT SlpCAmt + SlpPAmt + SlpDAmt INTO v_Count FROM Slip WHERE SlpNo = i_SlpNo;

	IF v_SaveInfo THEN
		IF v_Count = 0 THEN
			IF v_SlpPayAllCheckValue = SLIP_PAYMENT_CHECK_AUTO THEN
				IF NOT NHS_UTL_SLPPAYALLAUTO(i_SlpNo, SYSDATE, o_errmsg) THEN
					o_errmsg := 'Fail to call SlpPayAllAuto. ' || o_errmsg;
					RAISE e_lock_failed;
				END IF;
			END IF;

			-- CloseSlip
			v_errcode := NHS_ACT_SLIP('MOD', 'close', i_SlpNo, i_ComputerName, i_UserID, v_errmsg);
		END IF;
	END IF;

	IF v_bARLocked THEN
		v_unlockAR := NHS_UTL_SlpPayAllUnLockAR(i_SlpNo, i_ComputerName, i_UserID, v_errmsg);
	END IF;

	o_errcode := 0;
	RETURN o_errcode;
EXCEPTION
WHEN e_lock_failed THEN
	IF v_bARLocked THEN
		v_unlockAR := NHS_UTL_SlpPayAllUnLockAR(i_SlpNo, i_ComputerName, i_UserID, v_errmsg);
	END IF;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	RETURN o_errcode;
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_errmsg := SQLERRM || o_ERRMSG;
	RETURN -999;
END NHS_ACT_TXNCLOSE;
/
