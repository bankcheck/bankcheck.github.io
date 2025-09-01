CREATE OR REPLACE FUNCTION "NHS_ACT_DEPOSIT" (
	i_DummyACTION         IN VARCHAR2,
	--------------------------------
	i_ACTION              IN VARCHAR2,
	i_Deposit_SlipNo      IN VARCHAR2,
	i_Deposit_DpsID       IN VARCHAR2,
	i_Deposit_ItmCode     IN VARCHAR2,
	i_Slip_SlipNo         IN VARCHAR2,
	i_PaymentMethod       IN VARCHAR2,
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
	--------------------------------
	i_ComputerName        IN VARCHAR2,
	i_CashierCode         IN VARCHAR2,
	i_UserID              IN VARCHAR2,
	o_ErrMsg              OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_ErrCode NUMBER;
	v_Count NUMBER;
	v_DpsAmt NUMBER;
	v_PatFName Slip.Slpfname%TYPE;
	v_PatGName Slip.Slpgname%TYPE;
	v_GlcCode Sliptx.GLCCODE%TYPE;
	v_PatNo SLIP.PATNO%TYPE;
	v_PayType VARCHAR2(1);

	MSG_SLIP_LOCK VARCHAR2(29) := 'Slip is locked by other user.';
	MSG_DEPOSIT_REFUND_FAIL VARCHAR2(22) := 'Deposit refund failed.';

	SLIPTX_TYPE_DEPOSIT_O VARCHAR(1) := 'O';
	SLIPTX_TYPE_DEPOSIT_X VARCHAR(1) := 'X';
	DEPOSIT_STATUS_WRITEOFF VARCHAR(1) := 'W';
	DEPOSIT_STATUS_REFUND VARCHAR(1) := 'R';
	CASHTX_PAYCODE_CASH VARCHAR2(2) := '01';
	CASHTX_PAYCODE_CARD VARCHAR2(2) := '02';
	CASHTX_PAYCODE_CHEQUE VARCHAR2(2) := '03';
	CASHTX_PAYCODE_OCTOPUS VARCHAR2(2) := '06';
	CASHTX_PAYCODE_CUP VARCHAR2(2) := '07';
	CASHTX_PAYCODE_QR VARCHAR2(2) := '09';
	CASHTX_TXNTYPE_PAYOUT VARCHAR(1) := 'P';
	CASHTX_PAYTYPE_CASH VARCHAR(1) := 'C';
	CASHTX_PAYTYPE_CARD VARCHAR(1) := 'D';
	CASHTX_PAYTYPE_CHEQUE VARCHAR(1) := 'Q';
	CASHTX_PAYTYPE_OCTOPUS VARCHAR(1) := 'T';
	CASHTX_PAYTYPE_CUP VARCHAR(1) := 'U';
	CASHTX_PAYTYPE_QR VARCHAR(1) := 'R';
BEGIN
	o_ErrCode := 0;
	o_ErrMsg  := 'OK';

	-- lock slip
	o_ErrCode := NHS_ACT_RECORDLOCK('ADD', 'Slip', i_Deposit_SlipNo, i_ComputerName, i_UserID, o_ErrMsg);
	IF o_ErrCode < 0 THEN
		--o_ErrMsg := MSG_SLIP_LOCK;
		ROLLBACK;
		RETURN o_ErrCode;
	END IF;

	IF i_ACTION = 'TRANSFER' THEN
		-- lock slip
		o_ErrCode := NHS_ACT_RECORDLOCK('ADD', 'Slip', i_Slip_SlipNo, i_ComputerName, i_UserID, o_ErrMsg);
		IF o_ErrCode < 0 THEN
			--o_ErrMsg := MSG_SLIP_LOCK;
			ROLLBACK;
			RETURN o_ErrCode;
		END IF;

		o_ErrCode := NHS_UTL_TRANSFERDEPOSIT(i_Deposit_DpsID, i_Slip_SlipNo, i_Deposit_ItmCode, i_UserID, o_ErrMsg);
		IF o_ErrCode < 0 THEN
			o_ErrMsg := 'Fail to transfer deposit.';
			ROLLBACK;
			RETURN o_ErrCode;
		END IF;

		NHS_UTL_UpdateSliptxStatus(i_Deposit_SlipNo, SLIPTX_TYPE_DEPOSIT_X, SLIPTX_TYPE_DEPOSIT_O, NULL, i_Deposit_DpsID);

		NHS_UTL_UPDATESLIP(i_Deposit_SlipNo);
		NHS_UTL_UPDATESLIP(i_Slip_SlipNo);

		o_ErrCode := NHS_ACT_RECORDUNLOCK('ADD', 'Slip', i_Slip_SlipNo, i_ComputerName, i_UserID, o_ErrMsg);
		IF o_ErrCode < 0 THEN
			ROLLBACK;
			RETURN o_ErrCode;
		END IF;
	ELSIF i_ACTION = 'WRITEOFF' THEN
		-- WriteOffDeposit
		UPDATE DEPOSIT
		SET    DPSSTS = DEPOSIT_STATUS_WRITEOFF, DPSLCDATE = SYSDATE, DPSLTDATE = SYSDATE
		WHERE  DPSID = i_Deposit_DpsID;

		NHS_UTL_UpdateSliptxStatus(i_Deposit_SlipNo, SLIPTX_TYPE_DEPOSIT_X, SLIPTX_TYPE_DEPOSIT_O, NULL, i_Deposit_DpsID);

		NHS_UTL_UPDATESLIP(i_Deposit_SlipNo);
	ELSIF i_ACTION = 'REFUND' THEN
		SELECT COUNT(1) INTO v_Count FROM Sliptx WHERE StnXRef = i_Deposit_DpsID AND Slpno = i_Deposit_SlipNo;
		IF v_Count = 1 THEN
			SELECT GlcCode INTO v_GlcCode FROM Sliptx WHERE StnXRef = i_Deposit_DpsID AND Slpno = i_Deposit_SlipNo;
		END IF;

		-- lock slip
		o_ErrCode := NHS_ACT_RECORDLOCK('ADD', 'Setting', 'ReceiptNo', i_ComputerName, i_UserID, o_ErrMsg);
		IF o_ErrCode < 0 THEN
			--o_ErrMsg := MSG_SLIP_LOCK;
			ROLLBACK;
			RETURN o_ErrCode;
		END IF;

		SELECT S.Slpfname, S.Slpgname, D.Dpsamt INTO v_PatFName, v_PatGName, v_DpsAmt
		FROM   Deposit D, Slip S
		WHERE  D.SLPNO_S = S.SLPNO
		AND    S.SLPNO = i_Deposit_SlipNo
		AND    D.DPSID = i_Deposit_DpsID;

	SELECT PATNO INTO v_PatNo
	FROM   Slip
		WHERE  Slpno = i_Deposit_SlipNo;

	IF V_PATNO IS NOT NULL AND LENGTH(V_PATNO) > 0 THEN
		SELECT PATFNAME, PATGNAME INTO v_PatFName, v_PatGName
		FROM PATIENT
		WHERE PATNO = v_PatNo;
	END IF;
		IF i_PaymentMethod = CASHTX_PAYCODE_CASH THEN
			-- CASH
			o_ErrCode := NHS_UTL_CASHIERENTRY(i_UserID, i_CashierCode, CASHTX_TXNTYPE_PAYOUT, v_PatFName || ' ' || v_PatGName, CASHTX_PAYTYPE_CASH, -1 * v_DpsAmt, v_GlcCode || ' ' || i_Deposit_DpsID, NULL, NULL, NULL, i_Deposit_SlipNo, i_S9000YN, i_tmpReceiptNumber, i_TxnType, i_TxnEcrRef, i_TxnAmount, i_TxnRespCode, i_TxnRespText, i_TxnDateTime, i_TxnCardType, i_TxnCardNo, i_TxnExpiryDate, i_TxnCardHolder, i_TxnTerminalNo, i_TxnMerchantNo, i_TxnStoreNo, i_TxnTraceNo, i_TxnBatchNo, i_TxnAppCode, i_TxnRefNo, i_TxnRRNo, i_TxnVDate, i_TxnDAccount, i_TxnAResp);
		ELSIF i_PaymentMethod = CASHTX_PAYCODE_CHEQUE THEN
			-- CHEQUE
			o_ErrCode := NHS_UTL_CASHIERENTRY(i_UserID, i_CashierCode, CASHTX_TXNTYPE_PAYOUT, v_PatFName || ' ' || v_PatGName, CASHTX_PAYTYPE_CHEQUE, -1 * v_DpsAmt, v_GlcCode || ' ' || i_Deposit_DpsID, NULL, NULL, NULL, i_Deposit_SlipNo, i_S9000YN, i_tmpReceiptNumber, i_TxnType, i_TxnEcrRef, i_TxnAmount, i_TxnRespCode, i_TxnRespText, i_TxnDateTime, i_TxnCardType, i_TxnCardNo, i_TxnExpiryDate, i_TxnCardHolder, i_TxnTerminalNo, i_TxnMerchantNo, i_TxnStoreNo, i_TxnTraceNo, i_TxnBatchNo, i_TxnAppCode, i_TxnRefNo, i_TxnRRNo, i_TxnVDate, i_TxnDAccount, i_TxnAResp);
			IF o_ErrCode >= 0 THEN
				o_ErrCode := NHS_UTL_INSERTMISADDR('CASHTX', o_ErrCode, i_Payee, i_PatAddr1, i_PatAddr2, i_PatAddr3, i_Country, i_Reason);
			END IF;
		ELSIF i_PaymentMethod = CASHTX_PAYCODE_CARD OR i_PaymentMethod = CASHTX_PAYCODE_OCTOPUS OR i_PaymentMethod = CASHTX_PAYCODE_CUP OR i_PaymentMethod = CASHTX_PAYCODE_QR THEN
			IF i_PaymentMethod = CASHTX_PAYCODE_CARD THEN
				-- CREDIT CARD
				v_PayType := CASHTX_PAYTYPE_CARD;
			ELSIF i_PaymentMethod = CASHTX_PAYCODE_OCTOPUS THEN
				-- OCTOPUS
				v_PayType := CASHTX_PAYTYPE_OCTOPUS;
			ELSIF i_PaymentMethod = CASHTX_PAYCODE_CUP THEN
				-- CUP
				v_PayType := CASHTX_PAYTYPE_CUP;
			ELSIF i_PaymentMethod = CASHTX_PAYCODE_QR THEN
				-- QR
				v_PayType := CASHTX_PAYTYPE_QR;
			END IF;
			o_ErrCode := NHS_UTL_CASHIERENTRY(i_UserID, i_CashierCode, CASHTX_TXNTYPE_PAYOUT, v_PatFName || ' ' || v_PatGName, v_PayType, -1 * v_DpsAmt, v_GlcCode || ' ' || i_Deposit_DpsID, i_PaymentMethod, NULL, NULL, i_Deposit_SlipNo, i_S9000YN, i_tmpReceiptNumber, i_TxnType, i_TxnEcrRef, i_TxnAmount, i_TxnRespCode, i_TxnRespText, i_TxnDateTime, i_TxnCardType, i_TxnCardNo, i_TxnExpiryDate, i_TxnCardHolder, i_TxnTerminalNo, i_TxnMerchantNo, i_TxnStoreNo, i_TxnTraceNo, i_TxnBatchNo, i_TxnAppCode, i_TxnRefNo, i_TxnRRNo, i_TxnVDate, i_TxnDAccount, i_TxnAResp);
		ELSE
			o_ErrMsg := 'Invalid payment method.';
			ROLLBACK;
			RETURN o_ErrCode;
		END IF;

		IF o_ErrCode < 0 THEN
			o_ErrMsg := MSG_DEPOSIT_REFUND_FAIL;
			ROLLBACK;
			RETURN o_ErrCode;
		END IF;

		-- RefundDeposit
		UPDATE DEPOSIT
		SET    DPSSTS = DEPOSIT_STATUS_REFUND, DPSLCDATE = SYSDATE, DPSLTDATE = SYSDATE
		WHERE  DPSID = i_Deposit_DpsID;

		NHS_UTL_UpdateSliptxStatus(i_Deposit_SlipNo, SLIPTX_TYPE_DEPOSIT_X, SLIPTX_TYPE_DEPOSIT_O, NULL, i_Deposit_DpsID);

		NHS_UTL_UPDATESLIP(i_Deposit_SlipNo);

		o_ErrCode := NHS_ACT_RECORDUNLOCK('ADD', 'Setting', 'ReceiptNo', i_ComputerName, i_UserID, o_ErrMsg);
		IF o_ErrCode < 0 THEN
			ROLLBACK;
			RETURN o_ErrCode;
		END IF;
	END IF;

	o_ErrCode := NHS_ACT_RECORDUNLOCK('ADD', 'Slip', i_Deposit_SlipNo, i_ComputerName, i_UserID, o_ErrMsg);
	IF o_ErrCode < 0 THEN
		ROLLBACK;
		RETURN o_ErrCode;
	END IF;

	RETURN o_ErrCode;
END NHS_ACT_DEPOSIT;
/
