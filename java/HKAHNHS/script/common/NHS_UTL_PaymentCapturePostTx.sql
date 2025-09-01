CREATE OR REPLACE FUNCTION "NHS_UTL_PAYMENTCAPTUREPOSTTX" (
	i_UserID              IN VARCHAR2,
	i_CashierCode         IN VARCHAR2,
	i_PayCode             IN VARCHAR2,
	i_StnDesc             IN VARCHAR2,
	i_StnTDate            IN DATE,
	i_SlipTxStnType       IN VARCHAR2,
	i_Amount              IN NUMBER,
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
	i_TxnAResp            IN VARCHAR2
)
	RETURN VARCHAR2
AS
	v_TransactionDate DATE;
	v_CaptureDate DATE;
	v_tmpReceiptNumber VARCHAR2(20);
	v_PaymentType VARCHAR2(1);
	v_Reference VARCHAR2(100);
	v_Desc VARCHAR2(100);
	v_NewReceiptNumber VARCHAR2(20);
	v_newEcrRef VARCHAR2(20);
	v_EcrRef VARCHAR2(20);
	v_RtnRefID NUMBER;
	v_CtnID NUMBER;
	v_SliptxRefID NUMBER;
	v_Count NUMBER;
	v_CtnCType CardTx.CtnCType%TYPE;
	v_CtnTrace CardTx.CtnTrace%TYPE;
	v_ReceiptNo CashTx.CtxSNo%TYPE;
	v_PatientNo Slip.PatNo%TYPE;
	v_PatientName VARCHAR2(81);
	v_DoctorCode Slip.DocCode%TYPE;
	v_AcmCode InPat.AcmCode%TYPE;
	v_BedCode InPat.BedCode%TYPE;
	v_PayDesc PayCode.PayDesc%TYPE;
	v_GlcCode PayCode.GlcCode%TYPE;
	TXN_PAYCODE_CODE VARCHAR2(7) := 'PAYCODE';
	TXN_ARCODE_CODE VARCHAR2(7) := 'ARCCODE';
	TXN_PAYMENT_ITMCODE VARCHAR2(5) := 'PAYME';
	TYPE_OTHERS VARCHAR(1) := 'O';
	SLIPTX_TYPE_PAYMENT_C VARCHAR2(1) := 'S';
	SLIPTX_TYPE_PAYMENT_A VARCHAR2(1) := 'P';
	ARTX_TYPE_CHARGES VARCHAR2(1) := 'C';
	CASHTX_PAYCODE_CARD VARCHAR2(2) := '02';
	CASHTX_PAYCODE_EPS VARCHAR2(2) := '04';
	CASHTX_PAYCODE_OCTOPUS VARCHAR2(2) := '06';
	CASHTX_PAYCODE_CUP VARCHAR2(2) := '07';
	CASHTX_PAYCODE_QR VARCHAR2(2) := '09';
	CASHTX_PAYTYPE_CASH VARCHAR2(1) := 'C';
	CASHTX_PAYTYPE_CARD VARCHAR2(1) := 'D';
	CASHTX_PAYTYPE_EPS VARCHAR2(1) := 'E';
	CASHTX_PAYTYPE_CUP VARCHAR2(1) := 'U';
	CASHTX_PAYTYPE_QR VARCHAR2(1) := 'R';
	CASHTX_TXNTYPE_RECEIVE VARCHAR2(1) := 'R';
BEGIN
	-- get pay description and glc code
	SELECT COUNT(1) INTO v_Count FROM PayCode WHERE PayCode = i_PayCode;
	IF v_Count = 1 THEN
		SELECT PayDesc, GlcCode INTO v_PayDesc, v_GlcCode FROM PayCode WHERE PayCode = i_PayCode;
	END IF;

	IF i_SlipNo IS NOT NULL THEN
		SELECT COUNT(1) INTO v_Count FROM Slip S LEFT JOIN Reg R ON S.RegID = R.RegID LEFT JOIN Inpat I ON R.Inpid = I.Inpid WHERE S.SlpNo = i_SlipNo;
		IF v_Count = 1 THEN
			SELECT S.Patno, NVL(S.SlpFName, P.PatFName) || ' ' || NVL(S.SlpGName, P.PatGName), S.DocCode, I.AcmCode, I.BedCode
			INTO   v_PatientNo, v_PatientName, v_DoctorCode, v_AcmCode, v_BedCode
			FROM   Slip S LEFT JOIN Reg R ON S.RegID = R.RegID LEFT JOIN Inpat I ON R.Inpid = I.Inpid LEFT JOIN Patient P ON S.Patno = P.Patno
			WHERE  S.SlpNo = i_SlipNo;
		END IF;
	END IF;

	IF i_tmpReceiptNumber IS NULL THEN
		v_tmpReceiptNumber := SUBSTR(i_UserID, 1, 7) || TO_CHAR(SYSDATE, 'HH24:MI:SS');
	ELSE
		v_tmpReceiptNumber := i_tmpReceiptNumber;
	END IF;

	IF i_SlipTxStnType = TXN_ARCODE_CODE THEN
		v_CaptureDate := SYSDATE;
		v_PaymentType := SLIPTX_TYPE_PAYMENT_A;
		IF i_StnDesc IS NULL THEN
			v_Reference := v_PayDesc;
		ELSE
			v_Reference := i_StnDesc;
		END IF;
		v_RtnRefID := NHS_UTL_ARENTRY(i_UserID, ARTX_TYPE_CHARGES, i_PayCode, i_Amount, v_Reference, v_PatientNo, i_SlipNo, '', i_StnTDate, v_CaptureDate, '');

		-- UpdateCashierAR
		UPDATE Cashier SET CSHOTHER = CSHOTHER + i_Amount WHERE CSHCODE = i_CashierCode;

		v_Desc := i_PayCode || ' - ' || v_PayDesc;
		IF i_StnDesc IS NOT NULL THEN
			v_Desc := v_Desc || ' ' || i_StnDesc;
		END IF;
	ELSIF i_SlipTxStnType = TXN_PAYCODE_CODE THEN
		v_PaymentType := SLIPTX_TYPE_PAYMENT_C;
		IF i_StnDesc IS NOT NULL THEN
			v_Reference := i_StnDesc;
		ELSE
			v_Reference := v_PayDesc;
		END IF;
		v_RtnRefID := NHS_UTL_FASTCASHIERENTRY(i_UserID, i_CashierCode, CASHTX_TXNTYPE_RECEIVE, v_PatientName, CASHTX_PAYTYPE_CASH, i_Amount, v_Reference, i_PayCode, i_StnTDate, '', i_SlipNo, i_S9000YN, v_tmpReceiptNumber,
			i_TxnType, i_TxnEcrRef, i_TxnAmount, i_TxnRespCode, i_TxnRespText, i_TxnDateTime, i_TxnCardType, i_TxnCardNo, i_TxnExpiryDate, i_TxnCardHolder, i_TxnTerminalNo, i_TxnMerchantNo, i_TxnStoreNo, i_TxnTraceNo, i_TxnBatchNo, i_TxnAppCode, i_TxnRefNo, i_TxnRRNo, i_TxnVDate, i_TxnDAccount, i_TxnAResp, v_CtnID);

		SELECT COUNT(1) INTO v_Count FROM CashTx WHERE CTXID = v_RtnRefID;
		IF v_Count = 1 THEN
			SELECT CTXSNO INTO v_ReceiptNo FROM CashTx WHERE CTXID = v_RtnRefID;
		END IF;

		v_Desc := v_ReceiptNo || ' ' || v_PayDesc;
		IF i_StnDesc IS NOT NULL THEN
			v_Desc := v_Desc || ' ' || i_StnDesc;
		END IF;

		v_CaptureDate := NULL;

		IF v_RtnRefID IS NOT NULL THEN
			IF i_PayCode = CASHTX_PAYTYPE_CARD OR i_PayCode = CASHTX_PAYCODE_OCTOPUS OR i_PayCode = CASHTX_PAYCODE_CUP OR i_PayCode = CASHTX_PAYCODE_QR THEN
				-- Credit Card or OCTOPUS or CUP or QR
				SELECT COUNT(1) INTO v_Count FROM CashTx b, CardTx c WHERE b.CtxID = v_RtnRefID AND b.CtnID = c.CtnID;
				IF v_Count = 1 THEN
					SELECT c.CtnCType INTO v_CtnCType FROM CashTx b, CardTx c WHERE b.CtxID = v_RtnRefID AND b.CtnID = c.CtnID;
				ELSE
					v_CtnCType := NULL;
				END IF;

				v_Desc := v_ReceiptNo || ' ' || v_PayDesc || '(' || v_CtnCType || ')';
				IF i_StnDesc IS NOT NULL THEN
					v_Desc := v_Desc || ' ' || i_StnDesc;
				END IF;
			ELSIF i_PayCode = CASHTX_PAYCODE_EPS THEN
				-- EPS
				v_CtnCType := v_PayDesc;

				v_Desc := v_ReceiptNo || ' ' || v_PayDesc || '(' || v_CtnCType || ')';
				IF i_StnDesc IS NOT NULL THEN
					v_Desc := v_Desc || ' ' || i_StnDesc;
				END IF;

				SELECT COUNT(1) INTO v_Count FROM CashTx ct, CardTx cd WHERE ct.CtxID = v_RtnRefID AND ct.CtnID = cd.CtnID;
				IF v_Count = 1 THEN
					SELECT cd.CtnTrace INTO v_CtnTrace FROM CashTx ct, CardTx cd WHERE ct.CtxID = v_RtnRefID AND ct.CtnID = cd.CtnID;

					IF v_CtnTrace IS NOT NULL THEN
						v_Desc := v_Desc || 'ISN#' || v_CtnTrace;
					END IF;
				END IF;
			END IF;
		END IF;
	END IF;

	IF v_RtnRefID IS NOT NULL THEN
		IF i_SlipTxStnType = TXN_ARCODE_CODE THEN
			SELECT COUNT(1) INTO v_Count FROM ArTx WHERE ATxID = v_RtnRefID;
			IF v_Count = 1 THEN
				SELECT ATxTDATE INTO v_TransactionDate FROM ArTx WHERE ATxID = v_RtnRefID;
			END IF;
		ELSE
			SELECT COUNT(1) INTO v_Count FROM CashTx WHERE CTxID = v_RtnRefID;
			IF v_Count = 1 THEN
				SELECT CTxTDATE INTO v_TransactionDate FROM CashTx WHERE CTxID = v_RtnRefID;
			END IF;
		END IF;

		v_SliptxRefID := NHS_UTL_AddEntry(i_SlipNo, TXN_PAYMENT_ITMCODE, TYPE_OTHERS, v_PaymentType, i_Amount * -1, i_Amount * -1, v_DoctorCode,
			3, v_AcmCode, 0, NULL, v_CaptureDate, v_TransactionDate, v_Desc, NULL, v_GlcCode, v_RtnRefID, NULL, v_BedCode, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, i_UserID);
		IF v_SliptxRefID < 0 THEN
			ROLLBACK;
			RETURN v_SliptxRefID;
		END IF;

		NHS_UTL_UPDATESLIP(i_SlipNo);
		IF i_SlipTxStnType = TXN_ARCODE_CODE THEN
			UPDATE Artx SET AtxRefID = v_SliptxRefID WHERE AtxID = v_RtnRefID;
		END IF;
	END IF;

	IF v_RtnRefID IS NOT NULL THEN
		-- UpdateAllReceiptNumber
		IF i_SlipTxStnType = TXN_PAYCODE_CODE THEN
			-- Get the Real Receipt number
			-- IncrementCashierReceiptNumber + Setting
			v_NewReceiptNumber := NHS_UTL_CASHIERRECEIPTNUMBER;

			-- THEN Updating the transaction
			v_PaymentType := CASHTX_PAYTYPE_CASH;
			IF i_PayCode IS NOT NULL THEN
				SELECT COUNT(1) INTO v_Count FROM PayCode WHERE PayCode = i_PayCode;
				IF v_Count = 1 THEN
					SELECT PayType INTO v_PaymentType FROM PayCode WHERE PayCode = i_PayCode;
				ELSE
					v_PaymentType := '';
				END IF;
			END IF;

			IF LENGTH(v_NewReceiptNumber) > 10 THEN
				v_newEcrRef := SUBSTR('000000' || v_NewReceiptNumber, LENGTH(v_NewReceiptNumber) - 9, 16);
			ELSE
				v_newEcrRef := '000000' || v_NewReceiptNumber;
			END IF;

			IF LENGTH(v_tmpReceiptNumber) > 10 THEN
				v_EcrRef := SUBSTR('000000' || v_tmpReceiptNumber, LENGTH(v_tmpReceiptNumber) - 9, 16);
			ELSE
				v_EcrRef := '000000' || v_tmpReceiptNumber;
			END IF;

			IF v_PaymentType = CASHTX_PAYTYPE_CARD Or v_PaymentType = CASHTX_PAYTYPE_EPS Or v_PaymentType = CASHTX_PAYTYPE_CUP Or v_PaymentType = CASHTX_PAYTYPE_QR THEN
				-- UpdateCardtxEntry
				UPDATE CardTx SET CtnRef = v_newEcrRef WHERE CtnID = v_CtnID;
			END IF;

			IF v_RtnRefID IS NOT NULL THEN
				-- UpdateCashtx RtnRefID, v_NewReceiptNumber
				UPDATE CashTx SET CtxSNo = v_NewReceiptNumber WHERE CtxID = v_RtnRefID;
			END IF;

			IF v_RtnRefID IS NOT NULL THEN
				v_Desc := v_NewReceiptNumber || ' ' || v_PayDesc;
				IF i_StnDesc IS NOT NULL THEN
					v_Desc := v_Desc || ' ' || i_StnDesc;
				END IF;

				IF i_PayCode = CASHTX_PAYCODE_CARD OR i_PayCode = CASHTX_PAYCODE_OCTOPUS OR i_PayCode = CASHTX_PAYCODE_CUP OR i_PayCode = CASHTX_PAYCODE_QR THEN
					-- Credit Card or OCTOPUS or CUP or QR
					SELECT COUNT(1) INTO v_Count FROM CashTx b, CardTx c WHERE b.CtxID = v_RtnRefID AND b.CtnID = c.CtnID;
					IF v_Count = 1 THEN
						SELECT c.CtnCType INTO v_CtnCType FROM CashTx b, CardTx c WHERE b.CtxID = v_RtnRefID AND b.CtnID = c.CtnID;
					ELSE
						v_CtnCType := NULL;
					END IF;

					v_Desc := v_NewReceiptNumber || ' ' || v_PayDesc || '(' || v_CtnCType || ')';
					IF i_StnDesc IS NOT NULL THEN
						v_Desc := v_Desc || ' ' || i_StnDesc;
					END IF;
				ELSIF i_PayCode = CASHTX_PAYCODE_EPS THEN
					-- EPS
					v_CtnCType := v_PayDesc;

					v_Desc := v_NewReceiptNumber || ' ' || v_PayDesc || '(' || v_CtnCType || ')';
					IF i_StnDesc IS NOT NULL THEN
						v_Desc := v_Desc || ' ' || i_StnDesc;
					END IF;

					SELECT COUNT(1) INTO v_Count FROM CashTx ct, CardTx cd WHERE ct.CtxID = v_RtnRefID AND ct.CtnID = cd.CtnID;
					IF v_Count = 1 THEN
						SELECT cd.CtnTrace INTO v_CtnTrace FROM CashTx ct, CardTx cd WHERE ct.CtxID = v_RtnRefID AND ct.CtnID = cd.CtnID;

						IF v_CtnTrace IS NOT NULL THEN
							v_Desc := v_Desc || 'ISN#' || v_CtnTrace;
						END IF;
					END IF;
				END IF;

				-- UpdateSliptx SliptxRefID, Desc
				UPDATE SlipTx SET StnDesc = v_Desc WHERE Stnid = v_SliptxRefID;
			END IF;
		END IF;
	END IF;

	RETURN v_SliptxRefID;

END NHS_UTL_PAYMENTCAPTUREPOSTTX;
/
