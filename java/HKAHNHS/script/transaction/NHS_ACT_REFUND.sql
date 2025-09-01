CREATE OR REPLACE FUNCTION "NHS_ACT_REFUND"(
	i_Action              IN VARCHAR2,
	i_UserID              IN VARCHAR2,
	i_CashierCode         IN VARCHAR2,
	i_ComputerName        IN VARCHAR2,
	i_PayCode             IN VARCHAR2,
	i_PayDesc             IN VARCHAR2,
	i_PatientName         IN VARCHAR2,
	i_DoctorCode          IN VARCHAR2,
	i_TransactionDate     IN VARCHAR2,
	i_SlipNo              IN VARCHAR2,
	i_StnBAmt             IN VARCHAR2,
	i_AcmCode             IN VARCHAR2,
	i_BedCode             IN VARCHAR2,
	-- Payee info -------------------
	i_Payee               IN VARCHAR2,
	i_PatAddr1            IN VARCHAR2,
	i_PatAddr2            IN VARCHAR2,
	i_PatAddr3            IN VARCHAR2,
	i_Country             IN VARCHAR2,
	i_Reason              IN VARCHAR2,
	-- S9000 info -------------------
	i_S9000YN             IN VARCHAR2,
	i_tmpReceiptNumber    IN VARCHAR2,
	-- Card info --------------------
	i_TxnType             IN VARCHAR2,
	i_TxnEcrRef           IN VARCHAR2,
	i_TxnAmount           IN VARCHAR2,
	i_TxnRespCode         IN VARCHAR2,
	i_TxnRespText         IN VARCHAR2,
	i_TxnDateTime         IN VARCHAR2,
	i_TxnCardType         IN VARCHAR2,
	i_TxnCardNo           IN VARCHAR2,
	i_TxnExpiryDate       IN VARCHAR2,
	i_TxnCardHolder       IN VARCHAR2,
	i_TxnTerminalNo       IN VARCHAR2,
	i_TxnMerchantNo       IN VARCHAR2,
	i_TxnStoreNo          IN VARCHAR2,
	i_TxnTraceNo          IN VARCHAR2,
	i_TxnBatchNo          IN VARCHAR2,
	i_TxnAppCode          IN VARCHAR2,
	i_TxnRefNo            IN VARCHAR2,
	i_TxnRRNo             IN VARCHAR2,
	i_TxnVDate            IN VARCHAR2,
	i_TxnDAccount         IN VARCHAR2,
	i_TxnAResp            IN VARCHAR2,
	-- Output ----------------------
	o_ErrMsg              OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_ErrCode         NUMBER;
	v_Marid           NUMBER;
	v_TransactionID   NUMBER;
	v_Count           NUMBER;
	v_StnBAmt         NUMBER;
	v_PayType         VARCHAR2(1);
	v_Ctnctype        VARCHAR2(10);
	v_CardType        VARCHAR2(80);
	v_ItmName         VARCHAR2(40);
	v_ItmCName        VARCHAR2(20);
	v_ItmRLvl         VARCHAR2(20);
	v_TransactionDate DATE;

	TYPE_OTHERS VARCHAR2(1) := 'O';
	TXN_REFUND_ITMCODE VARCHAR2(3) := 'REF';
	SLIPTX_TYPE_PAYMENT_C VARCHAR2(1) := 'S';
	SLIPTX_TYPE_REFUND VARCHAR2(1) := 'R';
	CASHTX_PAYCODE_CASH VARCHAR2(2) := '01';
	CASHTX_PAYCODE_CARD VARCHAR2(2) := '02';
	CASHTX_PAYCODE_CHEQUE VARCHAR2(2) := '03';
	CASHTX_PAYCODE_OCTOPUS VARCHAR2(2) := '06';
	CASHTX_PAYCODE_CUP VARCHAR2(2) := '07';
	CASHTX_PAYCODE_QR VARCHAR2(2) := '09';
	CASHTX_TXNTYPE_PAYOUT VARCHAR2(1) := 'P';
	CASHTX_PAYTYPE_CASH VARCHAR2(1) := 'C';
	CASHTX_PAYTYPE_CARD VARCHAR2(1) := 'D';
	CASHTX_PAYTYPE_CHEQUE VARCHAR2(1) := 'Q';
	CASHTX_PAYTYPE_OCTOPUS VARCHAR2(1) := 'T';
	CASHTX_PAYTYPE_CUP VARCHAR2(1) := 'U';
	CASHTX_PAYTYPE_QR VARCHAR2(1) := 'R';
BEGIN
	o_ErrMsg := 'OK';
	o_ErrCode := 0;
	v_StnBAmt := TO_NUMBER(i_StnBAmt);
	v_TransactionDate := TO_DATE(i_TransactionDate, 'DD/MM/YYYY HH24:MI:SS');

	-- record lock
	o_ErrCode := NHS_ACT_RECORDLOCK('ADD', 'Setting', 'ReceiptNo' || i_CashierCode, i_ComputerName, i_UserID, o_ErrMsg);
	IF o_ErrCode < 0 THEN
		o_ErrMsg := 'Other cashier is processing Refund, please try again later!';
		RETURN o_ErrCode;
	END IF;

	SELECT COUNT(1) INTO v_Count FROM Item WHERE ItmCode = TXN_REFUND_ITMCODE;
	IF v_Count = 1 THEN
		SELECT ItmName, ItmCName, ItmRlvl INTO v_ItmName, v_ItmCName, v_ItmRLvl FROM Item WHERE ItmCode = TXN_REFUND_ITMCODE;
	END IF;

	IF i_PayCode = CASHTX_PAYCODE_CHEQUE THEN
		-- write log
		o_ErrCode := NHS_ACT_SYSLOG('ADD', 'Refund', i_PayCode || '-' || CASHTX_PAYTYPE_CHEQUE || '-' || i_StnBAmt, 'PostTransaction - CashierEntry for Cheque', i_UserID, i_ComputerName, o_ErrMsg);

		-- PostTransaction - CashierEntry for Cheque
		v_TransactionID := NHS_UTL_CASHIERENTRY(i_UserID, i_CashierCode, CASHTX_TXNTYPE_PAYOUT, i_PatientName, CASHTX_PAYTYPE_CHEQUE, -1 * v_StnBAmt, i_SlipNo || ' REFUND', NULL, v_TransactionDate, NULL, i_SlipNo, i_S9000YN, i_tmpReceiptNumber, i_TxnType, i_TxnEcrRef, i_TxnAmount, i_TxnRespCode, i_TxnRespText, i_TxnDateTime, i_TxnCardType, i_TxnCardNo, i_TxnExpiryDate, i_TxnCardHolder, i_TxnTerminalNo, i_TxnMerchantNo, i_TxnStoreNo, i_TxnTraceNo, i_TxnBatchNo, i_TxnAppCode, i_TxnRefNo, i_TxnRRNo, i_TxnVDate, i_TxnDAccount, i_TxnAResp);

		-- write log
		o_ErrCode := NHS_ACT_SYSLOG('ADD', 'Refund', i_PayCode || '-' || CASHTX_PAYTYPE_CHEQUE || '-' || i_StnBAmt, 'PostTransaction - AddEntry for Cheque', i_UserID, i_ComputerName, o_ErrMsg);

		-- PostTransaction - AddEntry for Cheque
		v_CardType := v_ItmName || ' by ' || i_PayDesc || ' ' || v_ItmCName;
		o_ErrCode := NHS_UTL_AddEntry(i_SlipNo, TXN_REFUND_ITMCODE, TYPE_OTHERS, SLIPTX_TYPE_REFUND, v_StnBAmt, v_StnBAmt, i_DoctorCode,
			v_ItmRLvl, i_AcmCode, 0, NULL, SYSDATE, v_TransactionDate, v_CardType, NULL, NULL, v_TransactionID, NULL, i_BedCode, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, i_UserID);
		IF o_ErrCode < 0 THEN
			ROLLBACK;
			o_ErrMsg := 'Fail to insert entry!';
			RETURN o_ErrCode;
		END IF;

		-- write log
		o_ErrCode := NHS_ACT_SYSLOG('ADD', 'Refund', i_PayCode || '-' || CASHTX_PAYTYPE_CHEQUE || '-' || i_StnBAmt, 'PostTransaction - UpdateSlip for Cheque', i_UserID, i_ComputerName, o_ErrMsg);

		-- PostTransaction - UpdateSlip for Cheque
		NHS_UTL_UPDATESLIP(i_SlipNo);
	ELSIF i_PayCode = CASHTX_PAYCODE_CARD OR i_PayCode = CASHTX_PAYCODE_OCTOPUS OR i_PayCode = CASHTX_PAYCODE_CUP OR i_Paycode = CASHTX_PAYCODE_QR THEN
		-- write log
		o_ErrCode := NHS_ACT_SYSLOG('ADD', 'Refund', i_PayCode || '-' || v_PayType || '-' || i_StnBAmt, 'PostTransaction - CashierEntry for Credit Card', i_UserID, i_ComputerName, o_ErrMsg);

		-- PostTransaction - CashierEntry for Credit Card
		IF i_PayCode = CASHTX_PAYCODE_CARD THEN
			v_PayType := CASHTX_PAYTYPE_CARD;
		ELSIF i_PayCode = CASHTX_PAYCODE_OCTOPUS THEN
			v_PayType := CASHTX_PAYTYPE_OCTOPUS;
		ELSIF i_PayCode = CASHTX_PAYCODE_CUP THEN
			v_PayType := CASHTX_PAYTYPE_CUP;
		ELSIF i_PayCode = CASHTX_PAYCODE_QR THEN
			v_PayType := CASHTX_PAYTYPE_QR;
		END IF;
		v_TransactionID := NHS_UTL_CASHIERENTRY(i_UserID, i_CashierCode, CASHTX_TXNTYPE_PAYOUT, i_PatientName, v_PayType, -1 * v_StnBAmt, i_SlipNo || ' REFUND', i_PayCode, NULL, NULL, i_SlipNo, i_S9000YN, i_tmpReceiptNumber, i_TxnType, i_TxnEcrRef, i_TxnAmount, i_TxnRespCode, i_TxnRespText, i_TxnDateTime, i_TxnCardType, i_TxnCardNo, i_TxnExpiryDate, i_TxnCardHolder, i_TxnTerminalNo, i_TxnMerchantNo, i_TxnStoreNo, i_TxnTraceNo, i_TxnBatchNo, i_TxnAppCode, i_TxnRefNo, i_TxnRRNo, i_TxnVDate, i_TxnDAccount, i_TxnAResp);

		-- write log
		o_ErrCode := NHS_ACT_SYSLOG('ADD', 'Refund', i_PayCode || '-' || v_PayType || '-' || i_StnBAmt, 'PostTransaction - AddEntry for Credit Card', i_UserID, i_ComputerName, o_ErrMsg);

		-- PostTransaction - AddEntry for Credit Card
		IF v_TransactionID IS NOT NULL AND v_TransactionID > 0 THEN
			SELECT COUNT(1) INTO v_Count FROM cashtx b, cardtx c WHERE b.ctxid = v_TransactionID AND b.ctnid = c.ctnid;
			IF v_Count = 1 THEN
				SELECT c.Ctnctype INTO v_Ctnctype FROM cashtx b, cardtx c WHERE b.ctxid = v_TransactionID AND b.ctnid = c.ctnid;
			END IF;

			SELECT COUNT(1) INTO v_Count FROM cashtx WHERE ctxid = v_TransactionID;
			IF v_Count = 1 THEN
				SELECT ctxtdate INTO v_TransactionDate FROM cashtx WHERE ctxid = v_TransactionID;
			END IF;

			v_CardType := v_ItmName || ' by ' || i_PayDesc || ' ' || CASE WHEN LENGTH(v_ItmCName) = 0 THEN '' ELSE v_ItmCName || ' ' END || '(' || v_Ctnctype || ')';

			o_ErrCode := NHS_UTL_AddEntry(i_SlipNo, TXN_REFUND_ITMCODE, TYPE_OTHERS, SLIPTX_TYPE_REFUND, v_StnBAmt, v_StnBAmt, i_DoctorCode,
				v_ItmRLvl, i_AcmCode, 0, NULL, SYSDATE, v_TransactionDate, v_CardType, NULL, NULL, v_TransactionID, NULL, i_BedCode, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, i_UserID);
			IF o_ErrCode < 0 THEN
				ROLLBACK;
				o_ErrMsg := 'Fail to insert entry!';
				RETURN o_ErrCode;
			END IF;

			-- write log
			o_ErrCode := NHS_ACT_SYSLOG('ADD', 'Refund', i_PayCode || '-' || v_PayType || '-' || i_StnBAmt, 'PostTransaction - UpdateSlip for Credit Card', i_UserID, i_ComputerName, o_ErrMsg);

			-- PostTransaction - UpdateSlip for Credit Card
			NHS_UTL_UPDATESLIP(i_SlipNo);
		ELSE
			ROLLBACK;
			o_ErrMsg := 'Refund failed.';
			RETURN -1;
		END IF;
	ELSIF i_PayCode = CASHTX_PAYCODE_CASH THEN
		-- write log
		o_ErrCode := NHS_ACT_SYSLOG('ADD', 'Refund', i_PayCode || '-' || CASHTX_PAYTYPE_CASH || '-' || i_StnBAmt, 'PostTransaction - CashierEntry for Cash', i_UserID, i_ComputerName, o_ErrMsg);

		-- PostTransaction - CashierEntry for Cash
		v_TransactionID := NHS_UTL_CASHIERENTRY(i_UserID, i_CashierCode, CASHTX_TXNTYPE_PAYOUT, i_PatientName, CASHTX_PAYTYPE_CASH, -1 * v_StnBAmt, i_SlipNo || ' REFUND', NULL, v_TransactionDate, NULL, i_SlipNo, i_S9000YN, i_tmpReceiptNumber, i_TxnType, i_TxnEcrRef, i_TxnAmount, i_TxnRespCode, i_TxnRespText, i_TxnDateTime, i_TxnCardType, i_TxnCardNo, i_TxnExpiryDate, i_TxnCardHolder, i_TxnTerminalNo, i_TxnMerchantNo, i_TxnStoreNo, i_TxnTraceNo, i_TxnBatchNo, i_TxnAppCode, i_TxnRefNo, i_TxnRRNo, i_TxnVDate, i_TxnDAccount, i_TxnAResp);

		-- write log
		o_ErrCode := NHS_ACT_SYSLOG('ADD', 'Refund', i_PayCode || '-' || CASHTX_PAYTYPE_CASH || '-' || i_StnBAmt, 'PostTransaction - AddEntry for Cash', i_UserID, i_ComputerName, o_ErrMsg);

		-- PostTransaction - AddEntry for Cash
		v_CardType := v_ItmName || ' by ' || i_PayDesc || ' ' || v_ItmCName;
		o_ErrCode := NHS_UTL_AddEntry(i_SlipNo, TXN_REFUND_ITMCODE, TYPE_OTHERS, SLIPTX_TYPE_REFUND, v_StnBAmt, v_StnBAmt, i_DoctorCode,
			v_ItmRLvl, i_AcmCode, 0, NULL, SYSDATE, v_TransactionDate, v_CardType, NULL, NULL, v_TransactionID, NULL, i_BedCode, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, i_UserID);
		IF o_ErrCode < 0 THEN
			o_ErrMsg := 'Fail to insert entry!';
			RETURN o_ErrCode;
		END IF;

		-- write log
		o_ErrCode := NHS_ACT_SYSLOG('ADD', 'Refund', i_PayCode || '-' || CASHTX_PAYTYPE_CASH || '-' || i_StnBAmt, 'PostTransaction - UpdateSlip for Cash', i_UserID, i_ComputerName, o_ErrMsg);

		-- PostTransaction - UpdateSlip for Cash
		NHS_UTL_UPDATESLIP(i_SlipNo);
	ELSE
		ROLLBACK;
		o_ErrMsg := 'Refund failed.';
		RETURN -1;
	END IF;

	-- InsertMisAddr
	IF i_PayCode = CASHTX_PAYCODE_CHEQUE AND i_Payee IS NOT NULL THEN
		v_Marid := NHS_UTL_INSERTMISADDR('CASHTX', v_TransactionID, i_Payee, i_PatAddr1, i_PatAddr2, i_PatAddr3, i_Country, i_Reason);
	END IF;

	-- RecordUnlock
	o_ErrCode := NHS_ACT_RECORDUNLOCK('ADD', 'Setting', 'ReceiptNo' || i_CashierCode, i_ComputerName, i_UserID, o_ErrMsg);
	IF o_ErrCode < 0 THEN
		ROLLBACK;
	END IF;

	RETURN o_ErrCode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_ErrMsg := SQLERRM || o_ErrMsg;
	o_ErrCode := NHS_ACT_SYSLOG('ADD', 'Refund', 'Error', o_ErrMsg, i_UserID, i_ComputerName, o_ErrMsg);
	RETURN -999;
END NHS_ACT_REFUND;
/
