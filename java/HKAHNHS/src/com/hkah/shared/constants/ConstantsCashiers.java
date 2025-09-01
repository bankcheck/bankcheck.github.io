package com.hkah.shared.constants;

public interface ConstantsCashiers {

	public final static String CASHIER_SIGNON_SEQ = "SEQ_CASHIER_SID";
	public final static String CASHTX_ADVANCE_PAYIN = "Advance and Withdraw Transaction";

	public final static String CASHIER_TYPE_INPATIENT = "I";
	public final static String CASHIER_TYPE_OUTPATIENT = "O";
	public final static String CASHIER_TYPE_DAYCASE = "D";

	public final static String CASHTX_PATIENT_RELATED = "P";
	public final static String CASHTX_NONPATIENT_RELATED = "N";

	public final static String CASHIER_STS_NORMAL = "N";
	public final static String CASHIER_STS_CLOSE = "C";
	public final static String CASHIER_STS_OFF = "O";

	public final static String CASHIER_COUNT_RECEIPT = "1";
	public final static String CASHIER_COUNT_REPRINT = "2";
	public final static String CASHIER_COUNT_VOID = "3";

	public final static String CASHTX_TXNTYPE_PAYOUT = "P";
	public final static String CASHTX_TXNTYPE_RECEIVE = "R";
	public final static String CASHTX_TXNTYPE_ADVANCEPAYIN = "A";

	public final static String CASHTX_PAYTYPE_CASH = "C";
	public final static String CASHTX_PAYTYPE_CHEQUE = "Q";
	public final static String CASHTX_PAYTYPE_CARD = "D";
	public final static String CASHTX_PAYTYPE_EPS = "E";
	public final static String CASHTX_PAYTYPE_AUTOPAY = "A";
	public final static String CASHTX_PAYTYPE_OTHER = "O";
	public final static String CASHTX_PAYTYPE_CUP = "U";
	public final static String CASHTX_PAYTYPE_QR = "R";
	public final static String CASHTX_PAYTYPE_OCTOPUS = "T";

	public final static String CASHTX_STS_NORMAL = "N";
	public final static String CASHTX_STS_REVERSE = "R";
	public final static String CASHTX_STS_VOID = "V";
	public final static String CASHTX_STS_REFUNDED = "F";

	public final static String CARDTX_STS_INITIAL = "I";
	public final static String CARDTX_STS_NORMAL = "N";
	public final static String CARDTX_STS_MANUAL = "M";

	public final static String SET_RECEIPT_NO = "RECEIPT";
	public final static String SYS_PARA_COMPUTERNMAE = "COMPUTERNAME";
}