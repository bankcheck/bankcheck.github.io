CREATE OR REPLACE FUNCTION "NHS_ACT_SLIP" (
	v_action       IN VARCHAR2,
	v_actionType   IN VARCHAR2,
	v_slpno        IN VARCHAR2,
	v_ComputerName IN VARCHAR2,
	v_UsrID        IN VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	v_noOfRec NUMBER;
	v_dpsid	NUMBER;
BEGIN
	o_errcode := 0;
	o_errmsg := 'OK';
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
					NHS_UTL_UPDATESLIPTXSTATUS(v_slpno, 'O', 'X', '', '');

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
				-- status active to close
				UPDATE SLIP SET SLPSTS = 'C' WHERE SLPNO = v_slpno AND SLPSTS = 'A';

				-- UpdateSliptxStatus
				NHS_UTL_UPDATESLIPTXSTATUS(v_slpno, 'X', 'O', '', '');

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

			o_errcode := NHS_ACT_SYSLOG('ADD', 'SlipLog', v_actionType, v_slpno, v_UsrID, v_ComputerName, o_errmsg);
		ELSE
			o_errcode := -1;
			o_errmsg := 'Fail to update due to record not exist.';
		END IF;
	ELSE
		o_errcode := -1;
		o_errmsg := 'parameter error.';
	END IF;
	RETURN o_errcode;
END NHS_ACT_SLIP;
/
