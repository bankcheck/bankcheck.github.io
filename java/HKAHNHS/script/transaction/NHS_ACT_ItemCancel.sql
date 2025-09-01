CREATE OR REPLACE FUNCTION "NHS_ACT_ITEMCANCEL" (
	i_action       IN  VARCHAR2,
	i_UserID       IN  VARCHAR2,
	i_CashierCode  IN  VARCHAR2,
	i_SlpNo        IN  VARCHAR2,
	i_StnID        IN  VARCHAR2,
	---------------------------
	i_IsDIReported IN  VARCHAR2,
	i_IsDIPayed    IN  VARCHAR2,
	i_IsDIPayedDr  IN  VARCHAR2,
	i_Reason       IN  VARCHAR2,
	---------------------------
	i_IsCancelItem IN  VARCHAR2,
	o_errmsg       OUT VARCHAR2
)
	return NUMBER
as
	o_errcode NUMBER := -1;
	v_Count NUMBER;
	v_NetAmt NUMBER := 0;
	v_StnBAmt NUMBER := 0;
	v_StnOAmt NUMBER := 0;
	v_ExamFee NUMBER := 0;
	v_DocShare NUMBER := 0;
	v_UTIME DATE;
	v_SlpNo SlipTx.SlpNo%TYPE;
	v_ItmCode SlipTx.ItmCode%TYPE;
	v_DiXref SlipTx.DiXref%TYPE;
	v_DscCode SlipTx.DscCode%TYPE;
	v_StnDisc SlipTx.StnDisc%TYPE;
	v_StnTDate VARCHAR2(10);
	v_StnType SlipTx.StnType%TYPE;
	v_StnXRef SlipTx.StnXRef%TYPE;
	v_StnID SlipTx.StnID%TYPE;
	v_StnSeq SlipTx.StnSeq%TYPE;
	v_StnSts SlipTx.StnSts%TYPE;
	v_Xrgid xReg.Xrgid%TYPE;
	v_XrgRptFlag xReg.XrgRptFlag%TYPE;
	v_XjbNo xJob.XjbNo%TYPE;
	v_Xjbstaff xJob.Xjbstaff%TYPE;
	v_XRegDate xReg.XRgDate%TYPE;
	v_DocCode Xreport.DocCode%TYPE;
	v_XrpCombine Xreport.XrpCombine%TYPE;
	v_Xrpid Xreport.Xrpid%TYPE;
	v_minXrpid Xreport.Xrpid%TYPE;
	v_Xrddtls XreportDtls.Xrddtls%TYPE;
	v_Staff DocContract.Staff%TYPE;
	v_EchId DocContract.GnlConId%TYPE;
	v_EshID DocContract.SpeconId%TYPE;
	v_EcdPct ExConDtls.EcdPct%TYPE;
	v_EcdFAmt ExConDtls.EcdFAmt%TYPE;
	v_EcdUseFix ExConDtls.EcdUseFix%TYPE;
	v_EcdUseFull ExConDtls.EcdUseFull%TYPE;
	v_PaidToDI VARCHAR2(1);
	v_StnDiDoc VARCHAR2(1);

	SLIPTX_TYPE_DEPOSIT_O VARCHAR2(1) := 'O';
	SLIPTX_TYPE_DEPOSIT_X VARCHAR2(1) := 'X';
	SLIPTX_TYPE_DEPOSIT_I VARCHAR2(1) := 'I';
	SLIPTX_TYPE_PAYMENT_C VARCHAR2(1) := 'S';
	SLIPTX_TYPE_PAYMENT_A VARCHAR2(1) := 'P';
	SLIPTX_TYPE_REFUND VARCHAR2(1) := 'R';
	SLIPTX_STATUS_ADJUST VARCHAR2(1) := 'A';
	SLIPTX_STATUS_NORMAL VARCHAR2(1) := 'N';
	SLIPTX_STATUS_CANCEL VARCHAR2(1) := 'C';
	SLIPTX_STATUS_REVERSE VARCHAR2(1) := 'R';
	SLIPTX_STATUS_USER_REVERSE VARCHAR2(1) := 'U';
	XREG_STATUS_USER_REVERSE VARCHAR2(1) := 'U';
	XAPP_STATUS_CANCEL VARCHAR2(1) := 'C';

	ERROR_DISABLE VARCHAR2(67) := 'This function is disabled due to the failure of the dayend process!';
	MSG_INVALID_SLPNO VARCHAR2(37) := 'Slip No. cannot be found in DataBase.';
	MSG_DOCTOR_CODE VARCHAR2(20) := 'Invalid doctor code.';
	MSG_CANCEL_ITEM VARCHAR2(57) := 'Do you want to cancel the transaction with the item code?';
	MSG_CANCEL_ITEM_SUCCESS VARCHAR2(25) := 'Cancel item successfully.';
	MSG_CANCEL_ITEM_FAIL VARCHAR2(19) := 'Cancel item failed.';
	MSG_CASHIER_CLOSED VARCHAR2(65) := 'Cashier already closed the session, payment can not be cancelled.';
	MSG_CASHIER_CLOSE_NOENTRY VARCHAR2(17) := 'No cashier entry.';
	MSG_AR_CLOSE_NOENTRY VARCHAR2(12) := 'No AR entry.';
BEGIN
	o_errcode := -1;
	o_errmsg := MSG_CANCEL_ITEM_FAIL;

/*
	-- checked already in TransactionDetail
	v_UTIME := NHS_UTL_CANPROCEED(GET_CURRENT_STECODE, 'N');
	IF v_UTIME IS NULL THEN
		o_errmsg := ERROR_DISABLE;
		RETURN o_errcode;
	END IF;
*/

	SELECT COUNT(1) INTO v_Count FROM SlipTx SX LEFT JOIN xReg XR ON SX.DiXref = XR.StnID WHERE SX.SlpNo = i_SlpNo AND SX.StnID = i_StnID;
	IF v_Count = 1 THEN
		SELECT SX.ItmCode, XR.Xrgid, SX.DiXref, SX.DscCode, SX.StnDisc, TO_CHAR(SX.StnTDate, 'dd/mm/yyyy'), SX.StnType, SX.StnXRef, SX.StnID, SX.StnSeq, SX.StnSts
		INTO v_ItmCode, v_Xrgid, v_DiXref, v_DscCode, v_StnDisc, v_StnTDate, v_StnType, v_StnXRef, v_StnID, v_StnSeq, v_StnSts
		FROM SlipTx SX LEFT JOIN xReg XR ON SX.DiXref = XR.StnID WHERE SX.SlpNo = i_SlpNo AND SX.StnID = i_StnID;
	ELSE
		o_errmsg := MSG_INVALID_SLPNO;
		RETURN -1;
	END IF;

	IF v_StnSts = SLIPTX_STATUS_CANCEL OR v_StnSts = SLIPTX_STATUS_REVERSE THEN
		o_errmsg := 'Cancel item is already cancelled.';
		RETURN -1;
	ELSE
		-- try to record lock
		UPDATE SlipTx SET StnSts = v_StnSts WHERE StnID = i_StnID and StnSts = v_StnSts;
		IF SQL%ROWCOUNT = 0 THEN
			o_errmsg := 'Cancel item is already cancelled.';
			RETURN -1;
		END IF;
	END IF;

	IF v_Xrgid IS NOT NULL AND v_Xrgid > 0 THEN
		-- Level 2
		v_PaidToDI := 'N';
		SELECT Sum(DocFee) INTO v_Count FROM DoctorIncomePrinted WHERE DiXref = i_StnID;
		IF v_Count IS NOT NULL AND v_Count > 0 THEN
			v_PaidToDI := 'Y';
		END IF;

		-- bCheckStatus
		BEGIN
			SELECT COUNT(1) INTO v_Count FROM xReg x, SlipTx st WHERE x.StnID = st.DiXref AND x.StnID = v_DiXref;
			IF v_Count = 1 THEN
				SELECT x.XrgRptFlag, DECODE(st.stndidoc, NULL, 0, 1) INTO v_XrgRptFlag, v_StnDiDoc FROM xReg x, SlipTx st WHERE x.StnID = st.DiXref AND x.StnID = v_DiXref;
			ELSE
				o_errmsg := MSG_CANCEL_ITEM_FAIL || ' Some information are missing.';
				RETURN -1;
			END IF;

			IF i_IsDIReported IS NULL OR i_IsDIReported != 'Y' THEN
				o_errmsg := 'DI exam registered, continue(Y/N)?';
				o_errcode := -100;
				RETURN o_errcode;
			END IF;

			IF v_XrgRptFlag = 0 AND (i_IsDIPayed IS NULL OR i_IsDIPayed != 'Y') THEN
				-- DI Exam reported
				o_errmsg := 'DI exam reported, continue(Y/N)?';
				o_errcode := -200;
				RETURN o_errcode;
			END IF;

			IF v_StnDiDoc = 1 AND v_PaidToDI = 'Y' AND (i_IsDIPayedDr IS NULL OR i_IsDIPayedDr != 'Y') THEN
				-- DI Exam paid to DI Doctor
				o_errmsg := 'DI exam paid to DI Doctor, continue(Y/N)?';
				o_errcode := -300;
				RETURN o_errcode;
			END IF;

			IF i_Reason IS NULL THEN
				-- reason can't be empty
				o_errcode := -400;
				return o_errcode;
			END IF;
		END;

		SELECT COUNT(1) INTO v_Count FROM xJob xj, xReg xr WHERE xj.XjbNo = xr.XjbNo and xr.xrgid = v_Xrgid;
		IF v_Count = 0 THEN
			v_Xjbstaff := 0;
		ELSE
			SELECT xj.XjbNo, xj.Xjbstaff, xr.xrgdate INTO v_XjbNo, v_Xjbstaff, v_XRegDate
			FROM xJob xj, xReg xr WHERE xj.XjbNo = xr.XjbNo and xr.xrgid = v_Xrgid;

			IF v_Xjbstaff != 0 THEN
				v_Xjbstaff := -1;
			END IF;
		END IF;

		IF v_XrgRptFlag = 0 THEN
			SELECT COUNT(1) INTO v_Count FROM Xreport x, xReg g WHERE x.XRGID = g.xrgid and g.StnID = i_StnID;
			IF v_Count = 1 THEN
				SELECT x.DocCode INTO v_DocCode FROM Xreport x LEFT JOIN xReg g ON x.XRGID = g.xrgid WHERE g.StnID = i_StnID;
			ELSE
				o_errmsg := MSG_DOCTOR_CODE;
				RETURN -1;
			END IF;
		ELSE
			SELECT COUNT(1) INTO v_Count FROM SysParam WHERE parcde = 'DIRPTDR';
			IF v_Count = 1 THEN
				SELECT param1 INTO v_DocCode FROM SysParam WHERE parcde = 'DIRPTDR';
			ELSE
				o_errmsg := MSG_DOCTOR_CODE;
				RETURN -1;
			END IF;
		END IF;

		SELECT COUNT(1) INTO v_Count FROM SlipTx WHERE DiXref = v_DiXref;
		IF v_Count = 1 THEN
			SELECT SUM(stnnamt), SUM(StnBAmt), SUM(StnOAmt) INTO v_NetAmt, v_StnBAmt, v_StnOAmt FROM SlipTx WHERE DiXref = v_DiXref;
		END IF;

		SELECT COUNT(1) INTO v_Count FROM Exam WHERE ExmCode = v_ItmCode;
		IF v_Count = 1 THEN
			SELECT v_NetAmt - ExmCon INTO v_ExamFee FROM Exam WHERE ExmCode = v_ItmCode;
		END IF;

		-- calCancelDocShare
		BEGIN
			v_DocShare := 0;

			-- Find contract effetive from/to and contract eshid SPECONSET and echid GNLCONSeT
			SELECT COUNT(1) INTO v_Count FROM DocContract
			WHERE DocCode = v_DocCode AND v_XregDate >= ConStartDate AND (v_XregDate <= ConEndDate or ConEndDate IS NULL);
			IF v_Count > 0 THEN
				SELECT MAX(ConID) INTO v_Count FROM DocContract
				WHERE DocCode = v_DocCode AND v_XregDate >= ConStartDate AND (v_XregDate <= ConEndDate or ConEndDate IS NULL);

				SELECT Staff, GnlConId, SpeconId INTO v_Staff, v_EchId, v_EshID FROM DocContract WHERE ConID = v_Count;

				IF v_Staff != -1 OR v_Xjbstaff != -1 THEN
					SELECT COUNT(1) INTO v_Count FROM ExSpecDtls WHERE eshID = v_EshID AND exmCode = v_ItmCode;
					IF v_Count < 1 THEN
						-- getGeneralDocShare
						SELECT COUNT(1) INTO v_Count FROM ExConDtls WHERE echid = v_EchId AND ecccode = v_DscCode;
						IF v_Count >= 0 THEN
							-- check within general contract
							SELECT EcdPct, EcdFAmt, EcdUseFix, EcdUseFull INTO v_EcdPct, v_EcdFAmt, v_EcdUseFix, v_EcdUseFull
							FROM ExConDtls WHERE echid = v_EchId AND ecccode = v_DscCode;
							IF v_EcdUseFull = -1 THEN
								v_DocShare := ROUND(v_ExamFee, 0);
							ELSIF v_ecdUseFix = -1 THEN
								v_DocShare := ROUND(v_EcdFAmt, 0);
							ELSIF v_EcdPct IS NOT NULL AND v_EcdPct IS NOT NULL AND v_EcdPct != 0 THEN
								v_DocShare := ROUND(v_ExamFee * v_EcdPct / 100, 0);
							END IF;
						END IF;
					ELSE
						-- getSpecialDocShare
						SELECT COUNT(1) INTO v_Count FROM ExSpecDtls WHERE eshID = v_EshId AND exmCode = v_ItmCode;
						IF v_Count >= 0 THEN
							-- check within general contract
							SELECT EsdPct, EsdFAmt, EsdUseFix, EsdUseFull INTO v_EcdPct, v_EcdFAmt, v_EcdUseFix, v_EcdUseFull
							FROM ExSpecDtls WHERE eshID = v_EshId AND exmCode = v_ItmCode;
							IF v_EcdUseFull = -1 THEN
								v_DocShare := ROUND(v_ExamFee, 0);
							ELSIF v_ecdUseFix = -1 THEN
								v_DocShare := ROUND(v_EcdFAmt, 0);
							ELSIF v_EcdPct IS NOT NULL AND v_EcdPct IS NOT NULL AND v_EcdPct != 0 THEN
								v_DocShare := ROUND(v_ExamFee * v_EcdPct / 100, 0);
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;
		END;

		-- insert delete exam
--		INSERT INTO Deleted_Exam (StnID, Reason, DrShare, DelUsrId, DelDate, StnBAmt, StnDisc, StnNAmt, StnOAmt, Paid, Refund)
--		VALUES (v_DiXref, i_Reason, v_DocShare, i_UserID, SYSDATE, v_StnBAmt, v_StnDisc, v_NetAmt, v_StnOAmt, v_PaidToDI, 'Y');

		SELECT COUNT(1) INTO v_Count FROM Xreport WHERE XrgId = v_Xrgid;
		IF v_Count = 1 THEN
			SELECT XrpCombine, Xrpid INTO v_XrpCombine, v_Xrpid FROM Xreport WHERE XrgId = v_Xrgid;
			IF v_XrpCombine > 1 THEN
				-- InsertIntoXReportDtls
				BEGIN
					IF v_XrpCombine = v_Xrpid THEN
						SELECT MIN(Xrpid) INTO v_minXrpid FROM Xreport WHERE XrpCombine = v_XrpCombine AND Xrpid <> v_Xrpid;
					ELSE
						v_minXrpid := v_Xrpid;
					END IF;

					SELECT COUNT(1) INTO v_Count FROM XreportDtls WHERE Xrpid = v_XrpCombine;
					IF v_Count = 1 THEN
						SELECT Xrddtls INTO v_Xrddtls FROM XreportDtls WHERE Xrpid = v_XrpCombine;

						INSERT INTO XreportDtls(Xrpid, Xrddtls, Xrdsize, Xwordrpt, Isword)
						SELECT v_minXrpid, v_Xrddtls, Xrdsize, Xwordrpt, Isword FROM XreportDtls WHERE Xrpid = v_XrpCombine;
					END IF;

					IF v_XrpCombine = v_Xrpid THEN
						UPDATE Xreport SET Xrpcombine = v_minXrpid WHERE Xrpcombine = v_XrpCombine AND Xrpid <> v_Xrpid;
					ELSE
						UPDATE Xreport set Xrpcombine = v_minXrpid WHERE Xrpid = v_Xrpid;
					END IF;
				END;

				-- InsertIntoException_report_queue(sXjbNo)
--				IF v_XjbNo > 1 THEN
--					INSERT INTO Exception_Report_Queue(ExrptId, Xjbno, ModIFied, CancelDate)
--					VALUES (SEQ_Exception_Report_Queue.NEXTVAL, v_XjbNo, 'N', SYSDATE);
--				END IF;
			END IF;
		END IF;

		-- Reverse all adjustment first

		-- Delete
		DELETE FROM Xlendret WHERE XrgID = v_Xrgid;

		-- XregAuditSQL (add audit)
		INSERT INTO XregAdj (XraID, StnID, XrgID, XraDate, XraSts, XraONAmt, XraNAmt, Usrid)
		VALUES (SEQ_XregAdj.NEXTVAL, v_DiXref, v_Xrgid, SYSDATE, SLIPTX_STATUS_USER_REVERSE, v_NetAmt, 0, i_UserID);

		-- UpdateXRegSQL (update xReg)
		UPDATE Xreg SET XrgMODFlag = XREG_STATUS_USER_REVERSE WHERE XrgID = v_Xrgid;

		-- Cancel Xappointment IF any
		SELECT COUNT(1) INTO v_Count FROM Xapp WHERE StnID = v_DiXref;
		IF v_Count > 0 THEN
			SELECT XapId INTO v_Count FROM Xapp WHERE StnID = v_DiXref;
			IF v_Count > 0 THEN
				-- Move the appointment to somewhere ELSE , or edit status
				UPDATE Xapp SET XapSts = XAPP_STATUS_CANCEL WHERE Xapid = v_Count;
			END IF;
		END IF;
	ELSE
		-- level 2
		IF i_IsCancelItem IS NULL OR i_IsCancelItem != 'Y' THEN
			o_errmsg := MSG_CANCEL_ITEM;
			o_errcode := -500;
			RETURN o_errcode;
		END IF;
	END IF;

	-- CancelSlipTx
	BEGIN
		IF v_StnType = SLIPTX_TYPE_DEPOSIT_I THEN
			-- Applied:Normal
			SELECT COUNT(1) INTO v_Count FROM Deposit WHERE DpsId = v_StnXRef;
			IF v_Count = 0 THEN
				o_errmsg := MSG_CANCEL_ITEM_FAIL || ' No Deposit is found.';
				ROLLBACK;
				RETURN -1;
			END IF;

			FOR R IN (SELECT StnID FROM SlipTx WHERE SlpNo = i_SlpNo AND StnXRef = v_StnXRef ) LOOP
				o_errcode := NHS_ACT_REVERSEENTRY('ADD', i_SlpNo, R.StnID, '', v_StnTDate, '1', i_UserID, o_errmsg);
				IF o_errcode < 0 THEN
					ROLLBACK;
					RETURN o_errcode;
				END IF;
			END LOOP;

			o_errcode := NHS_ACT_CONFIRMDEPOSIT('MOD', i_SlpNo, v_StnXRef, '', '', o_errmsg);

			SELECT COUNT(1) INTO v_Count FROM Deposit WHERE DPSID = v_StnXRef;
			IF v_Count = 1 THEN
				SELECT SlpNo_S INTO v_SlpNo FROM Deposit WHERE DPSID = v_StnXRef;
				IF v_SlpNo <> i_SlpNo THEN
					o_errmsg := MSG_CANCEL_ITEM_FAIL || ' The deposit is transferred from ' || v_SlpNo || ' instead.';
					ROLLBACK;
					RETURN -1;
				ELSIF v_SlpNo = i_SlpNo THEN
					SELECT SlpNo_T INTO v_SlpNo FROM Deposit WHERE DPSID = v_StnXRef;
					IF v_SlpNo IS NOT NULL THEN
						o_errmsg := MSG_CANCEL_ITEM_FAIL || ' The deposit is transferred to somewhere else.';
						ROLLBACK;
						RETURN -1;
					END IF;
				END IF;

				o_errcode := NHS_ACT_UPDATESlipTxSTATUS(i_action, v_SlpNo, SLIPTX_TYPE_DEPOSIT_O, SLIPTX_TYPE_DEPOSIT_X, '', v_StnXRef, o_errmsg);

				NHS_UTL_UPDATESLIP(v_SlpNo);
			END IF;

			NHS_UTL_UPDATESLIP(i_SlpNo);
		ELSIF v_StnType = SLIPTX_TYPE_DEPOSIT_O THEN
			-- Not applied:Available
			SELECT COUNT(1) INTO v_Count FROM Deposit WHERE DpsId = v_StnXRef;
			IF v_Count = 0 THEN
			ROLLBACK;
			o_errcode := -1;
				o_errmsg := MSG_CANCEL_ITEM_FAIL || ' Deposit not found! ';

				RETURN o_errcode;
			END IF;

			o_errcode := NHS_ACT_REVERSEENTRY('ADD', i_SlpNo, v_StnID, '', v_StnTDate, '1', i_UserID, o_errmsg);
			IF o_errcode < 0 THEN
				ROLLBACK;
				RETURN o_errcode;
			END IF;

			o_errcode := NHS_ACT_DELETEDEPOSIT(i_action, v_StnXRef, o_errmsg);

			NHS_UTL_UPDATESLIP(i_SlpNo);
		ELSIF v_StnType = SLIPTX_TYPE_PAYMENT_A THEN
			o_errcode := NHS_ACT_ARCANCELENTRY('ADD', v_StnXRef, '', i_CashierCode, o_errmsg);

			IF o_errcode >= 0 THEN
				o_errcode := NHS_ACT_REVERSEENTRY('ADD', i_SlpNo, v_StnID, '', v_StnTDate, '1', i_UserID, o_errmsg);
				IF o_errcode < 0 THEN
					ROLLBACK;
					RETURN o_errcode;
				END IF;

				NHS_UTL_UPDATESLIP(i_SlpNo);
			ELSE
				o_errmsg := MSG_CANCEL_ITEM_FAIL || ' ' || MSG_AR_CLOSE_NOENTRY;
				ROLLBACK;
				RETURN -1;
			END IF;
		ELSIF v_StnType = SLIPTX_TYPE_PAYMENT_C OR v_StnType = SLIPTX_TYPE_REFUND THEN
			IF v_StnType = SLIPTX_TYPE_PAYMENT_C THEN
				o_errcode := NHS_ACT_ISCASHIERCLOSED(i_action, v_StnXRef, i_UserID, o_errmsg);
				IF o_errcode >= 0 THEN
					o_errmsg := MSG_CANCEL_ITEM_FAIL || ' ' || MSG_CASHIER_CLOSED;
					ROLLBACK;
					o_errcode := -601;
					RETURN o_errcode;
				END IF;
			END IF;

			-- Handle abnormal card machine respone code
			-- (-602 go to MasterPanel doCashierVoidEntry > NHS_ACT_CASHIERVOIDENTRY >
			-- NHS_ACT_CASHIERVOIDENTRYPOST > NHS_ACT_ITEMCANCELPOST)
			ROLLBACK;
			o_errcode := -602;
			o_errmsg := 'Go to CashierVoidEntry';
			RETURN o_errcode;
/*
			o_errcode := NHS_ACT_CashierVoidEntry('', v_StnXRef, i_CashierCode, i_UserID, o_errmsg);
			IF o_errcode > 0 THEN
				o_errcode := NHS_ACT_REVERSEENTRY('ADD', i_SlpNo, v_StnID, '', v_StnTDate, '1', i_UserID, o_errmsg);
				IF o_errcode < 0 THEN
					ROLLBACK;
					o_errcode := -701;
					RETURN o_errcode;
				END IF;

				NHS_UTL_UPDATESLIP(i_SlpNo);
			ELSE
				o_errmsg := MSG_CANCEL_ITEM_FAIL || ' ' || MSG_CASHIER_CLOSE_NOENTRY;
				ROLLBACK;
				o_errcode := -702;
				RETURN o_errcode;
			END IF;
*/
		ELSE
			-- FindChildSlptx
			IF v_StnSts = SLIPTX_STATUS_NORMAL THEN
				FOR R IN (SELECT StnID FROM SlipTx WHERE DiXref = v_DiXref AND Stnsts = SLIPTX_STATUS_ADJUST ) LOOP
					o_errcode := NHS_ACT_REVERSEENTRY('ADD', i_SlpNo, R.StnID, '', v_StnTDate, '1', i_UserID, o_errmsg);
					IF o_errcode < 0 THEN
						ROLLBACK;
						RETURN -610;
					END IF;
				END LOOP;
			END IF;

			o_errcode := NHS_ACT_REVERSEENTRY('ADD', i_SlpNo, v_StnID, '', v_StnTDate, '1', i_UserID, o_errmsg);
			IF o_errcode < 0 THEN
				ROLLBACK;
				RETURN -611;
			END IF;

			NHS_UTL_UPDATESLIP(i_SlpNo);
		END IF;
	END;

	-- SetTotalCharges (UI)

	o_errcode := 0;
	RETURN o_errcode;

END NHS_ACT_ITEMCANCEL;
/
