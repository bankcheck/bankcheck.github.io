-- Cashier.bas / UpdateBalance
CREATE OR REPLACE FUNCTION "NHS_UTL_UPDATEBALANCE"(
	i_CashierCode     IN VARCHAR2,
	i_TransactionType IN VARCHAR2,
	i_PaymentType     IN VARCHAR2,
	i_Amount          IN NUMBER,
	i_CountType       IN VARCHAR2
)
	RETURN NUMBER
AS
	CASHIER_COUNT_RECEIPT VARCHAR2(1) := '1';
	CASHIER_COUNT_REPRINT VARCHAR2(1) := '2';
	CASHIER_COUNT_VOID VARCHAR2(1) := '3';
	CASHTX_TXNTYPE_RECEIVE VARCHAR2(1) := 'R';
	CASHTX_TXNTYPE_PAYOUT VARCHAR2(1) := 'P';
	CASHTX_TXNTYPE_ADVANCEPAYIN VARCHAR2(1) := 'A';
	CASHTX_PAYTYPE_CASH VARCHAR2(1) := 'C';
	CASHTX_PAYTYPE_CHEQUE VARCHAR2(1) := 'Q';
	CASHTX_PAYTYPE_CARD VARCHAR2(1) := 'D';
	CASHTX_PAYTYPE_CUP VARCHAR2(1) := 'U';
	CASHTX_PAYTYPE_QR VARCHAR2(1) := 'R';
	CASHTX_PAYTYPE_OCTOPUS VARCHAR2(1) := 'T';
	CASHTX_PAYTYPE_EPS VARCHAR2(1) := 'E';
	CASHTX_PAYTYPE_AUTOPAY VARCHAR2(1) := 'A';

	v_CshCRCnt NUMBER := 0;
	v_CshRCnt NUMBER := 0;
	v_CshVCnt NUMBER := 0;
	v_CshPayout NUMBER := 0;
	v_CshRec NUMBER := 0;
	v_CshAdv NUMBER := 0;
	v_CshPayIn NUMBER := 0;
	v_CshChqOut NUMBER := 0;
	v_CshChq NUMBER := 0;
	v_CshCardOut NUMBER := 0;
	v_CshCard NUMBER := 0;
	v_CshCUPOut NUMBER := 0;
	v_CshCUPIn NUMBER := 0;
	v_CSHQROut NUMBER := 0;
	v_CSHQRIn NUMBER := 0;
	v_CshOCTOut NUMBER := 0;
	v_CshOCTIn NUMBER := 0;
	v_CshEPS NUMBER := 0;
	v_CshATPOut NUMBER := 0;
	v_CshATP NUMBER := 0;
BEGIN
	IF i_CountType = CASHIER_COUNT_RECEIPT AND i_TransactionType = CASHTX_TXNTYPE_RECEIVE THEN
		v_CshCRCnt := 1;
	ELSIF i_CountType = CASHIER_COUNT_REPRINT THEN
		v_CshRCnt := 1;
	ELSIF i_CountType = CASHIER_COUNT_VOID THEN
		v_CshVCnt := 1;
	END IF;

	IF i_PaymentType = CASHTX_PAYTYPE_CASH THEN
		IF i_TransactionType = CASHTX_TXNTYPE_PAYOUT THEN
			v_CshPayout := i_Amount;
		ELSIF i_TransactionType = CASHTX_TXNTYPE_RECEIVE THEN
			v_CshRec := i_Amount;
		ELSIF i_TransactionType = CASHTX_TXNTYPE_ADVANCEPAYIN THEN
			IF i_Amount >= 0 THEN
				v_CshAdv := i_Amount;
			ELSE
				v_CshPayIn := i_Amount;
			END IF;
		END IF;
	ELSIF i_PaymentType = CASHTX_PAYTYPE_CHEQUE THEN
		IF i_TransactionType = CASHTX_TXNTYPE_PAYOUT THEN
			v_CshChqOut := i_Amount;
		ELSE
			v_CshChq := i_Amount;
		END IF;
	ELSIF i_PaymentType = CASHTX_PAYTYPE_CARD THEN
		IF i_TransactionType = CASHTX_TXNTYPE_PAYOUT THEN
			v_CshCardOut := i_Amount;
		ELSE
			v_CshCard := i_Amount;
		END IF;
	ELSIF i_PaymentType = CASHTX_PAYTYPE_CUP THEN
		IF i_TransactionType = CASHTX_TXNTYPE_PAYOUT THEN
			v_CshCUPOut := i_Amount;
		ELSE
			v_CshCUPIn := i_Amount;
		END IF;
	ELSIF i_PaymentType = CASHTX_PAYTYPE_QR THEN
		IF i_TransactionType = CASHTX_TXNTYPE_PAYOUT THEN
			v_CshQROut := i_Amount;
		ELSE
			v_CshQRIn := i_Amount;
		END IF;
	ELSIF i_PaymentType = CASHTX_PAYTYPE_OCTOPUS THEN
		IF i_TransactionType = CASHTX_TXNTYPE_PAYOUT THEN
			v_CshOCTOut := i_Amount;
		ELSE
			v_CshOCTIn := i_Amount;
		END IF;
	ELSIF i_PaymentType = CASHTX_PAYTYPE_EPS THEN
		v_CshEPS := i_Amount;
	ELSIF i_PaymentType = CASHTX_PAYTYPE_AUTOPAY THEN
		IF i_TransactionType = CASHTX_TXNTYPE_PAYOUT THEN
			v_CshATPOut := i_Amount;
		ELSE
			v_CshATP := i_Amount;
		END IF;
	END IF;

	UPDATE Cashier set
		CshCRCnt = CshCRCnt + v_CshCRCnt,
		CshRCnt = CshRCnt + v_CshRCnt,
		CshVCnt = CshVCnt + v_CshVCnt,
		CshPayout = CshPayout + v_CshPayout,
		CshRec = CshRec + v_CshRec,
		CshAdv = CshAdv + v_CshAdv,
		CshPayIn = CshPayIn + v_CshPayIn,
		CshChqOut = CshChqOut + v_CshChqOut,
		CshChq = CshChq + v_CshChq,
		CshCardOut = CshCardOut + v_CshCardOut,
		CshCard = CshCard + v_CshCard,
		CshCUPOut = CshCUPOut + v_CshCUPOut,
		CshCUPIn = CshCUPIn + v_CshCUPIn,
		CSHQROut = CSHQROut + v_CSHQROut,
		CSHQRIn = CSHQRIn + v_CSHQRIn,
		CshOCTOut = CshOCTOut + v_CshOCTOut,
		CshOCTIn = CshOCTIn + v_CshOCTIn,
		CshEPS = CshEPS + v_CshEPS,
		CshATPOut = CshATPOut + v_CshATPOut,
		CshATP = CshATP + v_CshATP
	WHERE CshCode = i_CashierCode;

	RETURN 1;
EXCEPTION
WHEN OTHERS THEN
	dbms_output.put_line('An ERROR was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);

	RETURN -1;
END NHS_UTL_UPDATEBALANCE;
/
