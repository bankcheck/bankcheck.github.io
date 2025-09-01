CREATE OR REPLACE FUNCTION "NHS_UTL_FASTCASHIERENTRY"(
	i_UserID              IN VARCHAR2,
	i_CashierCode         IN VARCHAR2,
	i_TransactionType     IN VARCHAR2,
	i_PayerOrReceiptant   IN VARCHAR2,
	i_PaymentType         IN VARCHAR2,
	i_Amount              IN NUMBER,
	i_Description         IN VARCHAR2,
	i_PaymentCode         IN VARCHAR2,
	i_TransactionDate     IN DATE,
	i_CaptureDate         IN DATE,
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
	-- Output -----------------------
	o_ReturnCtnID         OUT VARCHAR2
)
	RETURN NUMBER
AS
	o_errcode NUMBER;
	o_errmsg VARCHAR2(100);
	o_TransactionID NUMBER;
	v_CtnID NUMBER;
	v_Count NUMBER;
	v_TransactionDate DATE;
	v_CaptureDate DATE;
	v_ReceiptNumber VARCHAR2(20);
	v_PatientTxn VARCHAR2(20);
	v_EcrRef VARCHAR2(20);
	v_SlipNumber VARCHAR2(20);
	v_CtnCtype VARCHAR2(10);
	v_PaymentType VARCHAR2(1);
	v_CardTxType VARCHAR2(1);
	v_CtnSts VARCHAR2(1);

	CASHTX_TXNTYPE_RECEIVE VARCHAR2(1) := 'R';
	CASHTX_PATIENT_RELATED VARCHAR2(1) := 'P';
	CASHTX_NONPATIENT_RELATED VARCHAR2(1) := 'N';
	CARDTX_STS_NORMAL VARCHAR2(1) := 'N';
	CARDTX_STS_MANUAL VARCHAR2(1) := 'M';
	CASHTX_PAYTYPE_CARD VARCHAR2(1) := 'D';
	CASHTX_PAYTYPE_EPS VARCHAR2(1) := 'E';
	CASHTX_PAYTYPE_OCTOPUS VARCHAR2(1) := 'T';
	CASHTX_PAYTYPE_CUP VARCHAR2(1) := 'U';
	CASHTX_PAYTYPE_QR VARCHAR2(1) := 'R';
	S9000_TXN_CARD_SALE VARCHAR2(1) := '0';
	S9000_TXN_EPS_SALE VARCHAR2(1) := '5';
	S9090_TXN_OCT_SALE VARCHAR2(1) := '0';
	S9090_TXN_CUP_SALE VARCHAR2(1) := 'a';
	S9090_TXN_QR_SALE VARCHAR2(1) := 'A';
BEGIN
	v_CtnSts := CARDTX_STS_NORMAL;

	-- set payment type
	IF i_PaymentCode IS NOT NULL THEN
		SELECT PayType INTO v_PaymentType FROM PayCode WHERE PayCode = i_PaymentCode;
	ELSE
		v_PaymentType := i_PaymentType;
	END IF;

	-- set default transaction date if empty
	IF i_TransactionDate IS NOT NULL THEN
		v_TransactionDate := i_TransactionDate;
	ELSE
		v_TransactionDate := SYSDATE;
	END IF;

	-- set default capture date if empty
	IF i_CaptureDate IS NOT NULL THEN
		v_CaptureDate := i_CaptureDate;
	ELSE
		v_CaptureDate := SYSDATE;
	END IF;

	IF i_TransactionType = CASHTX_TXNTYPE_RECEIVE THEN
		IF i_tmpReceiptNumber IS NULL THEN
			v_ReceiptNumber := SUBSTR(i_UserID, 1, 7) || TO_CHAR(SYSDATE, 'HH24:MI:SS');
		ELSE
			v_ReceiptNumber := i_tmpReceiptNumber;
		END IF;
	ELSE
		v_ReceiptNumber := '';
	END IF;

	IF LENGTH(v_ReceiptNumber) > 10 THEN
		v_EcrRef := SUBSTR('000000' || v_ReceiptNumber, LENGTH(v_ReceiptNumber) - 9, 16);
	ELSE
		v_EcrRef := '000000' || v_ReceiptNumber;
	END IF;

	IF i_SlipNo != '-' THEN
		v_PatientTxn := CASHTX_PATIENT_RELATED;
		v_SlipNumber := i_SlipNo;
	ELSE
		v_PatientTxn := CASHTX_NONPATIENT_RELATED;
		v_SlipNumber := '';
	END IF;

	-- If card payment then start operate card machine
	IF v_PaymentType = CASHTX_PAYTYPE_CARD OR v_PaymentType = CASHTX_PAYTYPE_EPS OR v_PaymentType = CASHTX_PAYTYPE_CUP OR v_PaymentType = CASHTX_PAYTYPE_QR THEN
		IF v_PaymentType = CASHTX_PAYTYPE_EPS THEN
			v_CardTxType := S9000_TXN_EPS_SALE;
		ELSIF v_PaymentType = CASHTX_PAYTYPE_CUP THEN
			v_CardTxType := S9090_TXN_CUP_SALE;
		ELSIF v_PaymentType = CASHTX_PAYTYPE_QR THEN
			v_CardTxType := S9090_TXN_QR_SALE;
		ELSE
			v_CardTxType := S9000_TXN_CARD_SALE;
		END IF;

		IF v_SlipNumber IS NOT NULL THEN
			IF i_TxnEcrRef IS NULL THEN
				v_EcrRef := NHS_UTL_GETCARDNEWREF(v_SlipNumber);
			ELSE
				v_EcrRef := i_TxnEcrRef;
			END IF;
		END IF;

		v_CtnID := NHS_UTL_PRETRANSACTION(i_CashierCode, v_CardTxType, v_EcrRef, i_Amount, v_TransactionDate);
		o_ReturnCtnID := v_CtnID;

		IF i_S9000YN != 'Y' THEN
			v_CtnSts := CARDTX_STS_MANUAL;
		END IF;
	ELSIF v_PaymentType = CASHTX_PAYTYPE_OCTOPUS THEN
		v_CardTxType := S9090_TXN_OCT_SALE;

		IF v_SlipNumber IS NOT NULL THEN
			v_EcrRef := NHS_UTL_GETCARDNEWREF(v_SlipNumber);
		END IF;

		v_CtnID := NHS_UTL_PRETRANSACTION(i_CashierCode, v_CardTxType, v_EcrRef, i_Amount, v_TransactionDate);

		v_CtnSts := CARDTX_STS_MANUAL;
	END IF;

	-- update manual
	IF v_CtnSts = CARDTX_STS_MANUAL THEN
		IF i_TxnDateTime IS NOT NULL THEN
			-- Card/Octopus manual input
			v_TransactionDate := TO_DATE(i_TxnDateTime, 'DD/MM/YYYY HH24:MI:SS');
		END IF;

		IF v_PaymentType = CASHTX_PAYTYPE_OCTOPUS THEN
			SELECT COUNT(1) INTO v_Count FROM Cardrate WHERE Paycode = '06';
			IF v_Count > 0 THEN
				SELECT Craname INTO v_CtnCtype FROM Cardrate WHERE Paycode = '06';
			END IF;

			UPDATE CardTx
			SET    CtnSts = v_CtnSts, CtnCType = v_CtnCtype, CtnCno = i_TxnCardNo, Ctntdate = v_TransactionDate
			WHERE  CtnID = v_CtnID;
		ELSE
			UPDATE CardTx
			SET    CtnSts = v_CtnSts, CtnTID = i_TxnTerminalNo, CtnMID = i_TxnMerchantNo, CtnCtype = i_TxnCardType, CtnCno = i_TxnCardNo, CtnBatch = i_TxnBatchNo, CtnTrace = i_TxnTraceNo, CtnRef = i_TxnEcrRef, CtnACode = i_TxnAppCode, RefNo = i_TxnRefNo, Ctntdate = TRIM(v_TransactionDate), Ctnexp = i_TxnExpiryDate
			WHERE  CtnID = v_CtnID;
		END IF;
	END IF;

	-- get next artx id
	SELECT SEQ_CashTx.NEXTVAL INTO o_TransactionID FROM DUAL;

	o_TransactionID := NHS_UTL_ADDCASHIERTRANSACTION(i_CashierCode, o_TransactionID, i_TransactionType, i_PayerOrReceiptant, v_PaymentType,
		i_Amount, i_Description, v_CtnID, v_TransactionDate, v_CaptureDate, v_PatientTxn, v_ReceiptNumber, v_SlipNumber);

	-- Update card transaction record with data from card machine (CASHTX_PAYTYPE_EPS, CASHTX_PAYTYPE_CARD)
	If v_CtnSts = CARDTX_STS_NORMAL AND (v_PaymentType = CASHTX_PAYTYPE_CARD OR v_PaymentType = CASHTX_PAYTYPE_EPS OR v_PaymentType = CASHTX_PAYTYPE_OCTOPUS OR v_PaymentType = CASHTX_PAYTYPE_CUP OR v_PaymentType = CASHTX_PAYTYPE_QR) THEN
		o_errcode := NHS_ACT_UPDATETRANSACTION(NULL, TO_CHAR(v_CtnID), NULL, NULL, NULL,
			i_TxnType, i_TxnEcrRef, i_TxnAmount, '000000000000', i_TxnRespCode,
			i_TxnRespText, i_TxnDateTime, i_TxnCardType, i_TxnCardNo, i_TxnExpiryDate, i_TxnCardHolder, i_TxnTerminalNo, i_TxnMerchantNo,
			i_TxnTraceNo, i_TxnBatchNo, i_TxnAppCode, i_TxnRRNo, i_TxnStoreNo, i_TxnVDate, i_TxnDAccount, i_TxnAResp, NULL, NULL, NULL, NULL, NULL, i_TxnRefNo, o_errmsg);
	END IF;

	RETURN o_TransactionID;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_UTL_FASTCASHIERENTRY;
/
