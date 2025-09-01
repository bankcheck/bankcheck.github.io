CREATE OR REPLACE FUNCTION "NHS_ACT_PAYMENTANDRECEIPT"(
	i_ACTION              IN VARCHAR2,
	i_UserID              IN VARCHAR2,
	i_CashierCode         IN VARCHAR2,
	i_PayType             IN VARCHAR2,
	i_PayCode             IN VARCHAR2,
	i_PayDesc             IN VARCHAR2,
	i_ArcCode             IN VARCHAR2,
	i_ArDesc              IN VARCHAR2,
	i_PayerReceiptient    IN VARCHAR2,
	i_Reference           IN VARCHAR2,
	i_Amount              IN VARCHAR2,
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
	-- Output -----------------------
	o_errmsg              OUT VARCHAR2
)
	RETURN NUMBER
AS
	v_LastID           NUMBER;
	v_RtnRefID         NUMBER;
	v_ArpID            NUMBER;
	v_CtnID            NUMBER;
	v_Amount           NUMBER;
	v_Serial           NUMBER;
	v_CtxID            NUMBER;
	v_Count            NUMBER;
	v_Marid            NUMBER;
	v_PaymentType      VARCHAR2(1);
	v_UserID           VARCHAR2(7);
	v_tmpReceiptNumber VARCHAR2(20);
	v_NewReceiptNumber VARCHAR2(20);
	v_newEcrRef        VARCHAR2(16);
	v_TranDate         DATE;

	CASHTX_TXNTYPE_PAYOUT VARCHAR2(1) := 'P';
	CASHTX_TXNTYPE_RECEIVE VARCHAR2(1) := 'R';
	CASHTX_TXNTYPE_ADVANCEPAYIN VARCHAR2(1) := 'A';
	CASHTX_PAYTYPE_CASH VARCHAR2(1) := 'C';
	CASHTX_PAYTYPE_CARD VARCHAR2(1) := 'D';
	CASHTX_PAYTYPE_EPS VARCHAR2(1) := 'E';
	CASHTX_PAYTYPE_CUP VARCHAR2(1) := 'U';
	CASHTX_PAYTYPE_QR VARCHAR2(1) := 'R';
	CASHTX_ADVANCE_PAYIN VARCHAR2(32) := 'Advance and Withdraw Transaction';
	ARTX_TYPE_CHARGES VARCHAR2(1) := 'C';
BEGIN
	o_errmsg := 'OK';

	v_LastID := -1;
	v_UserID := SUBSTR(i_UserID, 1, 7);

	IF i_ArcCode IS NOT NULL THEN
		SELECT COUNT(1) INTO v_Count FROM Arcode WHERE ArcCode = i_ArcCode;
		IF v_Count = 0 THEN
			o_errmsg  := 'Arcode does not exist.';
			RETURN v_LastID;
		END IF;
	END IF;

	BEGIN
		v_Amount := TO_NUMBER(i_Amount);
	EXCEPTION WHEN OTHERS THEN
		o_errmsg  := 'Invalid amount.';
		RETURN v_LastID;
	END;

	IF i_PayType != '3' AND i_PayCode IS NULL THEN
		o_errmsg  := 'Method Code is empty.';
		RETURN v_LastID;
	END IF;

	-- get payment type
	SELECT COUNT(1) INTO v_Count FROM PayCode WHERE PayCode = i_PayCode;
	IF v_Count = 1 THEN
		SELECT PayType INTO v_PaymentType FROM PayCode WHERE PayCode = i_PayCode;
	END IF;

	-- PostTransaction
	IF i_PayType = '1' THEN
		v_LastID := NHS_UTL_CASHIERENTRY(i_UserID, i_CashierCode, CASHTX_TXNTYPE_PAYOUT, i_PayerReceiptient, CASHTX_PAYTYPE_CASH, v_Amount, i_Reference, i_PayCode, '', '', '-', i_S9000YN, v_tmpReceiptNumber,
			i_TxnType, i_TxnEcrRef, i_TxnAmount, i_TxnRespCode, i_TxnRespText, i_TxnDateTime, i_TxnCardType, i_TxnCardNo, i_TxnExpiryDate, i_TxnCardHolder, i_TxnTerminalNo, i_TxnMerchantNo, i_TxnStoreNo, i_TxnTraceNo, i_TxnBatchNo, i_TxnAppCode, i_TxnRefNo, i_TxnRRNo, i_TxnVDate, i_TxnDAccount, i_TxnAResp);
	ELSIF i_PayType = '2' THEN
		v_LastID := NHS_UTL_FASTCASHIERENTRY(i_UserID, i_CashierCode, CASHTX_TXNTYPE_RECEIVE, i_PayerReceiptient, v_PaymentType, v_Amount, i_Reference, i_PayCode, '', '', '-', i_S9000YN, v_tmpReceiptNumber,
			i_TxnType, i_TxnEcrRef, i_TxnAmount, i_TxnRespCode, i_TxnRespText, i_TxnDateTime, i_TxnCardType, i_TxnCardNo, i_TxnExpiryDate, i_TxnCardHolder, i_TxnTerminalNo, i_TxnMerchantNo, i_TxnStoreNo, i_TxnTraceNo, i_TxnBatchNo, i_TxnAppCode, i_TxnRefNo, i_TxnRRNo, i_TxnVDate, i_TxnDAccount, i_TxnAResp, v_CtnID);
		IF v_LastID IS NOT NULL THEN
			SELECT CtxID INTO v_CtxID FROM CashTx WHERE CtxID = v_LastID;
			-- GenerateReceiptNo
			v_Serial := v_CtxID;
		END IF;
	ELSIF i_PayType = '3' THEN
		v_LastID := NHS_UTL_CASHIERENTRY(i_UserID, i_CashierCode, CASHTX_TXNTYPE_ADVANCEPAYIN, i_CashierCode, CASHTX_PAYTYPE_CASH, v_Amount, CASHTX_ADVANCE_PAYIN, '', '', '', '-', i_S9000YN, v_tmpReceiptNumber,
			i_TxnType, i_TxnEcrRef, i_TxnAmount, i_TxnRespCode, i_TxnRespText, i_TxnDateTime, i_TxnCardType, i_TxnCardNo, i_TxnExpiryDate, i_TxnCardHolder, i_TxnTerminalNo, i_TxnMerchantNo, i_TxnStoreNo, i_TxnTraceNo, i_TxnBatchNo, i_TxnAppCode, i_TxnRefNo, i_TxnRRNo, i_TxnVDate, i_TxnDAccount, i_TxnAResp);
	END IF;

	-- MSG_CASHTX_FAILED
	IF v_LastID < 0 THEN
		o_errmsg  := 'Transaction Failed';
		ROLLBACK;
		RETURN v_LastID;
	END IF;

	IF i_PayCode IS NOT NULL AND i_ArcCode IS NOT NULL THEN
		SELECT Ctxtdate INTO v_TranDate FROM Cashtx WHERE ctxid = v_LastID;
		IF i_PayType = '1' THEN
			v_RtnRefID := NHS_UTL_ARENTRY(i_UserID, ARTX_TYPE_CHARGES, i_ArcCode, v_Amount * -1, i_Reference, '', '', '', v_TranDate, '', '');
		ELSE
			v_ArpID := NHS_UTL_ARPAYMENTENTRY(i_UserID, i_ArcCode, v_Amount * -1, TO_CHAR(v_Serial), i_Reference, v_TranDate, '');
		END IF;
	END IF;

	-- UpdateAllReceiptNumber
	IF i_PayType = '2' THEN
		-- Get the Real Receipt number
		-- IncrementCashierReceiptNumber + Setting
		v_NewReceiptNumber := NHS_UTL_CASHIERRECEIPTNUMBER;

		-- Then Updating the transaction
		IF v_PaymentType = CASHTX_PAYTYPE_CARD OR v_PaymentType = CASHTX_PAYTYPE_EPS OR v_PaymentType = CASHTX_PAYTYPE_CUP OR v_PaymentType = CASHTX_PAYTYPE_QR THEN
			IF LENGTH(v_NewReceiptNumber) > 10 THEN
				v_newEcrRef := SUBSTR('000000' || v_NewReceiptNumber, LENGTH(v_NewReceiptNumber) - 9, 16);
			ELSE
				v_newEcrRef := '000000' || v_NewReceiptNumber;
			END IF;

			-- UpdateCardtxEntry
			UPDATE Cardtx SET CtnRef = v_newEcrRef WHERE CtnID = v_CtnID;
		END IF;

		-- UpdateCashtx
		UPDATE Cashtx SET CtxSNo = v_NewReceiptNumber WHERE Ctxid = v_LastID;

		IF i_PayCode IS NOT NULL AND i_ArcCode IS NOT NULL THEN
			-- UpdateArptx
			UPDATE Arptx SET ArpRecNo = v_NewReceiptNumber WHERE Arpid = v_ArpID;
		END IF;
	END IF;

	-- InsertMisAddr (PayCode = ChequeCode)
	IF i_PayType = '1' AND i_PayCode = '03' THEN
		v_Marid := NHS_UTL_INSERTMISADDR('CASHTX', v_LastID, i_Payee, i_PatAddr1, i_PatAddr2, i_PatAddr3, i_Country, i_Reason);
	END IF;

	RETURN v_LastID;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
	o_errmsg := 'Transaction Failed.<br><font color=red>Error Code:' || SQLCODE || '</font>';

	RETURN -999;
END NHS_ACT_PAYMENTANDRECEIPT;
/
