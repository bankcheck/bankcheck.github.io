CREATE OR REPLACE FUNCTION NHS_ACT_TelLog (
	i_action      IN VARCHAR2,
	i_status      IN VARCHAR2,
	i_logid       IN VARCHAR2,
	i_UserID      IN VARCHAR2,
	i_SiteCode    IN VARCHAR2,
	i_MovePkgCode IN VARCHAR2,
	i_Override    IN VARCHAR2,
	o_errmsg      OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER := -1;
	v_Count NUMBER;
	v_UtlDate DATE;
	v_ItmCode Item.ItmCode%TYPE;
	v_ItmCat Item.ItmCat%TYPE;
	v_ItmType Item.ItmType%TYPE;
	v_ItmName Item.ItmName%TYPE;
	v_ItmRLvl Item.ItmRLvl%TYPE := 0;
	v_logid TelLog.logid%TYPE;
	v_IRefNo TelLog.irefno%TYPE;
	v_Amount TelLog.amount%TYPE;
	v_Unit TelLog.unit%TYPE;
	v_SlpNo TelLog.SlpNo%TYPE;
	v_ChrgCode TelLog.chargecde%TYPE;
	v_DocCode TelLog.doccode%TYPE;
	v_SlpDocCode TelLog.doccode%TYPE;
	v_AcmCode TelLog.acmcode%TYPE;
	v_TransactionDate TelLog.stntdate%TYPE;
	v_StnDesc1 TelLog.stndesc1%TYPE;
	v_ChrgType TelLog.chrgtype%TYPE;
	v_DeptCode TelLog.deptcode%TYPE;
	v_SlpType Slip.SlpType%TYPE;
	v_BedCode Inpat.BedCode%TYPE;
	v_SlpAcmCode Acm.AcmCode%TYPE;
	v_RegDate Reg.Regdate%TYPE;
	v_StnOAmt SlipTx.StnOAmt%TYPE;
	v_StnBAmt SlipTx.StnBAmt%TYPE;
	v_StnCpsFlag SlipTx.StnCpsFlag%TYPE;
	v_SlpCpsid NUMBER;
	v_flagToDi BOOLEAN;
	v_SlpDisc Slip.Slphdisc%TYPE;
	v_SlpHDisc Slip.Slphdisc%TYPE := 0;
	v_SlpDDisc Slip.Slpddisc%TYPE := 0;
	v_SlpSDisc Slip.Slpsdisc%TYPE := 0;
	v_WrdDptCode TelLog.deptcode%TYPE;

	c_doCharge TYPES.CURSOR_TYPE;

	TXN_ADD_MODE VARCHAR2(3) := 'ADD';
	DOCTOR_STATUS_ACTIVE NUMBER := -1;
	SLIP_TYPE_INPATIENT VARCHAR2(1) := 'I';
	SLIP_STATUS_OPEN VARCHAR2(1) := 'A';
	MSG_ITMCHARGE_RATE VARCHAR2(25) := 'Invalid item charge rate.';
	MSG_MOVE_SUCCEED VARCHAR2(13) := 'Move Succeed.';
	MSG_MOVE_FAIL VARCHAR2(10) := 'Move Fail.';
	ERROR_DISABLE VARCHAR2(67) := 'This function is disabled due to the failure of the dayend process!';
BEGIN
	o_errmsg := 'OK';

	IF i_action = 'MOD' THEN
		SELECT COUNT(1) INTO v_Count FROM TelLog WHERE Status = 'N' AND Logid = i_logid;
		IF v_Count = 0 THEN
			o_errmsg := 'No current log is found.';
			RETURN o_errcode;
		END IF;

		IF i_status = 'D' THEN
			NHS_UTL_DeleteTelLog(i_LogId, i_UserID);
		ELSIF i_status = 'AI2C' THEN
			o_errcode := 0;

			SELECT slpno INTO v_SlpNo
			FROM   tellog
			WHERE  logid = i_logid;

			SELECT COUNT(1) INTO v_Count FROM TelLog WHERE slpNo = v_SlpNo AND Status = 'N' AND Txtype = 'R';
			IF v_Count > 0 THEN
				o_errmsg := 'Move Fail. Please handle pharmacy record manually.';
				o_errcode := -1;
				RETURN o_errcode;
			END IF;

			OPEN c_doCharge FOR
				SELECT logid
				FROM   tellog
				WHERE  slpno  = v_SlpNo
				AND    status = 'N';
			LOOP
				FETCH c_doCharge INTO v_logid;
				EXIT WHEN c_doCharge%NOTFOUND OR o_errcode < 0;

				o_errcode := NHS_ACT_TelLog(i_action, 'I2C', v_logid, i_UserID, i_SiteCode, i_MovePkgCode, i_Override, o_errmsg);
			END LOOP;
		ELSE
			IF i_status = 'I2R' THEN
				v_UtlDate := NHS_UTL_CANPROCEED(i_SiteCode, 'N');
				IF v_UtlDate IS NULL THEN
					o_errmsg := ERROR_DISABLE;
					ROLLBACK;
					RETURN o_errcode;
				END IF;
			END IF;

			SELECT irefno, amount, unit, slpno, chargecde, doccode, acmcode, stntdate, stndesc1, chrgtype, deptcode
			INTO   v_IRefNo, v_Amount, v_Unit, v_SlpNo, v_ChrgCode, v_DocCode, v_AcmCode, v_TransactionDate, v_StnDesc1, v_ChrgType, v_DeptCode
			FROM   tellog
			WHERE  logid  = i_logid;

			IF v_TransactionDate IS NULL THEN
				v_TransactionDate := SYSDATE;
			END IF;

			IF v_ChrgType IS NULL THEN
				v_ChrgType := 'R';
			END IF;

			IF v_Amount IS NULL THEN
				v_Amount := 0;
			END IF;

			-- LookupSlpNo
			BEGIN
				SELECT slptype INTO v_SlpType FROM slip WHERE slpno = v_SlpNo;

				IF v_SlpType = 'I' THEN
					SELECT S.SLPNO, I.BEDCODE, A.AcmCode, R.DOCCODE, R.REGDATE, S.SLPHDISC, S.SLPDDISC, S.SLPSDISC
					INTO   v_SlpNo, v_BedCode, v_SlpAcmCode, v_SlpDocCode, v_RegDate, v_SlpHDisc, v_SlpDDisc, v_SlpSDisc
					FROM   SLIP S, INPAT I, ACM A, REG R, PATIENT P, DOCTOR D
					WHERE  S.SLPNO = v_SlpNo
					AND    S.SLPNO = R.SLPNO
					AND    R.INPID = I.INPID
					AND    A.AcmCode = i.AcmCode
					AND    P.PATNO = S.PATNO
					AND    d.DocCode = R.DocCode
					AND    s.slptype = SLIP_TYPE_INPATIENT
					AND    s.slpsts = SLIP_STATUS_OPEN;
				ELSE
					SELECT S.SLPNO, S.DOCCODE, NULL AS BEDCODE, NULL AS ACMCODE, S.SLPHDISC, S.SLPDDISC, S.SLPSDISC, R.REGDATE
					INTO   v_SlpNo, v_SlpDocCode, v_BedCode, v_SlpAcmCode, v_SlpHDisc, v_SlpDDisc, v_SlpSDisc, v_RegDate
					FROM   SLIP S, REG R
					WHERE  S.REGID = R.REGID(+)
					AND    S.SLPNO = v_SlpNo
					AND    s.slpsts = SLIP_STATUS_OPEN;
				END IF;

				IF v_SlpAcmCode IS NULL THEN
					v_AcmCode := NULL;
				ELSIF v_AcmCode IS NULL THEN
					v_AcmCode := v_SlpAcmCode;
				END IF;

				IF v_DocCode IS NULL THEN
					v_DocCode := v_SlpDocCode;
				END IF;
			EXCEPTION
			WHEN OTHERS THEN
				o_errmsg := 'No current slip is found.';
				ROLLBACK;
				RETURN o_errcode;
			END;

			IF v_ChrgCode IS NULL THEN
				o_errmsg := 'Null Charge Code.';
				ROLLBACK;
				RETURN o_errcode;
			END IF;

			-- LookUpDocCode
			SELECT COUNT(1) INTO v_Count FROM Doctor d, Spec s
			WHERE d.DocCode = v_DocCode AND d.Docsts = DOCTOR_STATUS_ACTIVE AND d.SpcCode = s.SpcCode;
			IF v_Count = 0 THEN
				o_errmsg := 'Invalid inactive doctor';
				ROLLBACK;
				RETURN o_errcode;
			END IF;

			BEGIN
				IF i_status = 'I2C' AND v_RegDate IS NOT NULL AND TO_CHAR(v_TransactionDate, 'yyyymmdd') < TO_CHAR(v_RegDate, 'yyyymmdd') Then
					o_errmsg := 'The Transaction Date (' || TO_CHAR(v_TransactionDate, 'dd/mm/yyyy') || ') is older than Registration Date (' || TO_CHAR(v_RegDate, 'dd/mm/yyyy') || ').';
					ROLLBACK;
					RETURN o_errcode;
				END IF;
			EXCEPTION
			WHEN OTHERS THEN
				o_errmsg := SQLERRM;
				ROLLBACK;
				RETURN o_errcode;
			END;

			BEGIN
				SELECT itmcode INTO v_ItmCode FROM Item WHERE ItmCode = v_ChrgCode;
			EXCEPTION
			WHEN OTHERS THEN
				v_ItmCode := null;
			END;

			IF v_DeptCode IS NULL AND v_BedCode IS NOT NULL THEN
				BEGIN
					SELECT w.DptCode INTO v_WrdDptCode
					FROM Bed b, Room r, Ward w
					WHERE b.BedCode = v_BedCode
					AND b.RomCode = r.RomCode
					AND r.WrdCode = w.WrdCode;

					v_DeptCode := v_WrdDptCode;
				EXCEPTION
				WHEN OTHERS THEN
					v_WrdDptCode := null;
				END;
			END IF;

			IF v_ItmCode IS NOT NULL THEN
				o_errcode := NHS_UTL_LOOKUPITMCODE(TXN_ADD_MODE, TO_CHAR(v_TransactionDate, 'dd/mm/yyyy'), v_SlpNo, v_SlpType,
					v_ChrgType, v_ChrgCode, v_AcmCode, v_Unit,
					v_Amount, v_SlpHDisc, v_SlpDDisc, v_SlpSDisc, i_UserID,
					v_ItmCode, v_ItmCat, v_ItmType, v_ItmName, v_StnOAmt, v_StnBAmt, v_StnCpsFlag,
					v_SlpCpsid, v_flagToDi, v_SlpDisc, v_ItmRLvl, o_errmsg);
			ELSIF v_ChrgCode <> 'REF' THEN
				c_doCharge := NHS_UTL_LOOKUPPKGCODE(v_ChrgCode, 'PKGTX', TXN_ADD_MODE,
					v_TransactionDate, v_SlpNo, v_DocCode, v_SlpType, v_ChrgType, v_AcmCode,
					v_Unit, v_SlpHDisc, v_SlpDDisc, v_SlpSDisc, o_errmsg );
			END IF;

			IF i_status = 'I2R' THEN
				IF v_ItmCode IS NOT NULL THEN
					IF o_errcode < 0 THEN
						o_errmsg := MSG_ITMCHARGE_RATE;
						ROLLBACK;
						RETURN o_errcode;
					END IF;

					IF i_Override = 'N' THEN
						o_errmsg := 'Do you want to move the charge to pkgtx?';
						o_errcode := -100;
						ROLLBACK;
						RETURN o_errcode;
					ELSE
						o_errcode := NHS_UTL_MoveToPkgtx(i_LogId, i_MovePkgCode, v_SlpNo,
							v_ItmCode, v_StnOAmt, v_StnBAmt, v_Unit, v_DocCode, v_ItmRLvl,
							v_AcmCode, v_TransactionDate, v_ItmName,
							v_flagToDi, v_StnCpsFlag, v_StnDesc1, v_IRefNo, v_DeptCode,
							i_UserID, o_errmsg);
						IF o_errcode > 0 THEN
							o_errmsg := MSG_MOVE_SUCCEED;
						ELSE
							o_errmsg := MSG_MOVE_FAIL;
							ROLLBACK;
							RETURN o_errcode;
						END IF;
					END IF;
				ELSIF v_ChrgCode <> 'REF' THEN
					IF c_doCharge IS NULL THEN
						ROLLBACK;
						RETURN o_errcode;
					END IF;

					IF i_Override = 'N' THEN
						o_errmsg := 'Do you want to move the charge to pkgtx?';
						o_errcode := -100;
						ROLLBACK;
						RETURN o_errcode;
					ELSE
						o_errcode := NHS_UTL_MovePkgToPkgtx(i_LogId, i_MovePkgCode, v_SlpNo,
							v_Unit, v_AcmCode, v_TransactionDate, v_StnDesc1,
							v_IRefNo, v_DeptCode, c_doCharge, i_UserID, o_errmsg);

						IF o_errcode > 0 THEN
							o_errmsg := MSG_MOVE_SUCCEED;
						ELSE
							o_errmsg := MSG_MOVE_FAIL;
							ROLLBACK;
							RETURN o_errcode;
						END IF;
					END IF;
				END IF;
			ELSIF i_status = 'I2C' THEN
				IF v_ItmCode IS NOT NULL THEN
					IF o_errcode < 0 THEN
						o_errmsg := MSG_ITMCHARGE_RATE;
						ROLLBACK;
						RETURN o_errcode;
					END IF;

					o_errcode := NHS_UTL_MoveToSliptx(i_LogId, v_DeptCode, v_SlpNo, v_ItmCode,
						v_ItmType, v_StnOAmt, v_StnBAmt, v_Unit, v_DocCode, v_ItmRLvl,
						v_AcmCode, v_SlpDisc, v_TransactionDate, v_ItmName, v_BedCode,
						v_flagToDi, v_StnCpsFlag, v_SlpCpsid, v_StnDesc1, v_IRefNo,
						i_UserID, i_SiteCode, o_errmsg);
					IF o_errcode > 0 THEN
						o_errmsg := MSG_MOVE_SUCCEED;
					ELSE
						o_errmsg := MSG_MOVE_FAIL;
						ROLLBACK;
						RETURN o_errcode;
					END IF;
				ELSIF v_ChrgCode <> 'REF' THEN
					IF c_doCharge IS NULL THEN
						ROLLBACK;
						RETURN o_errcode;
					END IF;

					o_errcode := NHS_UTL_MovePkgToSliptx(i_LogId, v_SlpNo, v_Unit, v_AcmCode,
							v_TransactionDate, v_BedCode, v_StnCpsFlag, v_StnDesc1, v_IRefNo,
							v_DeptCode, c_doCharge, i_UserID, o_errmsg);
					IF o_errcode > 0 THEN
						o_errmsg := MSG_MOVE_SUCCEED;
					ELSE
						o_errmsg := MSG_MOVE_FAIL;
						ROLLBACK;
						RETURN o_errcode;
					END IF;
				END IF;
			END IF;
		END IF;
	ELSE
		o_errmsg := 'update error.';
		ROLLBACK;
		RETURN o_errcode;
	END IF;

	o_errcode := 0;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ERRMSG := SQLERRM || o_ERRMSG;

	RETURN -999;
END NHS_ACT_TelLog;
/
