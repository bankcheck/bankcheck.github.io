CREATE OR REPLACE FUNCTION "NHS_ACT_PAYMENTCAPTURE" (
	i_action              IN VARCHAR2,
	i_UserID              IN VARCHAR2,
	i_CashierCode         IN VARCHAR2,
	i_PayCode             IN VARCHAR2,
	i_StnDesc             IN VARCHAR2,
	i_StnTDate            IN VARCHAR2,
	i_StnBAmt             IN VARCHAR2,
	i_SlipNo              IN VARCHAR2,
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
	-- output -----------------------
	o_errmsg              OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER := -1;
	v_Count NUMBER;
	v_StnBAmt NUMBER;
	v_RtnRefID NUMBER;
	v_StnTDdate DATE;
	v_SliptxStntype VARCHAR2(7);
	v_PayType PayCode.PayType%TYPE;
	v_PayDesc PayCode.PayDesc%TYPE;
	v_PayCDesc PayCode.PayCDesc%TYPE;
	v_GlcCode PayCode.GlcCode%TYPE;

	MSG_PAYAR_CODE VARCHAR2(24) := 'Invalid paycode/arccode.';
	MSG_POSITIVE_AMOUNT VARCHAR2(40) := 'Please enter a positive integer amount.';
	CASHTX_PAYTYPE_OTHER VARCHAR2(1) := 'O';
	TXN_PAYCODE_CODE VARCHAR2(7) := 'PAYCODE';
	TXN_ARCODE_CODE VARCHAR2(7) := 'ARCCODE';
	MSG_PAYMENT_SUCCESS VARCHAR2(27) := 'Payment successfully added.';
	MSG_PAYMENT_FAILED VARCHAR2(27) := 'Payment transaction failed.';
	MSG_PAYMENT_FAILED_DESCLONG VARCHAR2(50) := 'Payment transaction failed: Description Too Long';

BEGIN
	IF i_PayCode IS NOT NULL THEN
		SELECT COUNT(1) INTO v_Count FROM PayCode WHERE PayCode = i_payCode;

		IF v_Count = 0 THEN
			SELECT COUNT(1) INTO v_Count FROM ArCode WHERE ArcCode = i_payCode;

			o_errmsg := 'Arcode does not exist';
			RETURN o_errCode;
		ELSIF v_Count = 1 THEN
			SELECT	PayType, PayDesc, PayCDesc, GlcCode
			INTO	v_PayType, v_PayDesc, v_PayCDesc, v_GlcCode
			FROM	PayCode
			WHERE	PayCode = i_payCode;

			IF v_PayType = CASHTX_PAYTYPE_OTHER THEN
				v_SliptxStntype := TXN_ARCODE_CODE;
			ELSE
				v_SliptxStntype := TXN_PAYCODE_CODE;
			END IF;
		ELSE
			o_errmsg := MSG_PAYAR_CODE;
			RETURN o_errCode;
		END IF;
	ELSE
		o_errmsg := MSG_PAYAR_CODE;
		RETURN o_errCode;
	END IF;

	-- validate transaction date
	BEGIN
		v_StnTDdate := TO_DATE(i_StnTDate, 'DD/MM/YYYY');
	EXCEPTION WHEN OTHERS THEN
		o_errmsg := 'Please enter the transaction date with the format of dd/mm/yyyy.';
		RETURN o_errCode;
	END;

	-- validate amount
	BEGIN
		v_StnBAmt := TO_NUMBER(i_StnBAmt);
		IF v_StnBAmt <= 0 THEN
			o_errmsg := MSG_POSITIVE_AMOUNT;
			RETURN o_errCode;
		END IF;
	EXCEPTION WHEN OTHERS THEN
		o_errmsg := MSG_POSITIVE_AMOUNT;
		RETURN o_errCode;
	END;

	-- PreTransaction
	v_RtnRefID := NHS_UTL_PaymentCapturePostTx(i_UserID, i_CashierCode, i_PayCode, i_StnDesc, v_StnTDdate, v_SlipTxStnType, v_StnBAmt, i_SlipNo, i_S9000YN, i_tmpReceiptNumber,
		i_TxnType, i_TxnEcrRef, i_TxnAmount, i_TxnRespCode, i_TxnRespText, i_TxnDateTime, i_TxnCardType, i_TxnCardNo, i_TxnExpiryDate, i_TxnCardHolder, i_TxnTerminalNo, i_TxnMerchantNo, i_TxnStoreNo, i_TxnTraceNo, i_TxnBatchNo, i_TxnAppCode, i_TxnRefNo, i_TxnRRNo, i_TxnVDate, i_TxnDAccount, i_TxnAResp);

	IF v_RtnRefID IS NOT NULL THEN
	    	IF v_RtnRefID > 0 THEN
			o_errmsg := MSG_PAYMENT_SUCCESS;
			o_errCode := v_RtnRefID;
	    	ELSIF v_RtnRefID = -997 THEN
			o_errmsg := MSG_PAYMENT_FAILED_DESCLONG;
	    	ELSE
			o_errmsg := MSG_PAYMENT_FAILED;
	    	END IF;
	ELSE
		o_errmsg := MSG_PAYMENT_FAILED;
	END IF;

	RETURN o_errcode;
EXCEPTION
WHEN OTHERS THEN
	ROLLBACK;
	o_errMsg := 'Payment transaction failed due to ' || SQLERRM || '.';
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -999;
END NHS_ACT_PAYMENTCAPTURE;
/
