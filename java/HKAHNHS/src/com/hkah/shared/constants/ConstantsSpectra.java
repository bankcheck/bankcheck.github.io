package com.hkah.shared.constants;

public interface ConstantsSpectra {

	public final static String COMPort = "COM2";
	public final static String COMPortStatus = "9600,n,8,1";
	public final static int S9000TIMEOUT = 120;

	public final static String S9000_TXN_CARD_SALE = "0";
	public final static String S9000_TXN_OFF_SALE = "1";
	public final static String S9000_TXN_REFUND = "2";
	public final static String S9000_TXN_VOID = "3";
	public final static String S9000_TXN_CARD_RET = "4";
	public final static String S9000_TXN_EPS_SALE = "5";
	public final static String S9000_TXN_EPS_RET = "6";
	public final static String S9000_TXN_TOTAL = "7";
	public final static String S9000_TXN_AUTH = "8";
	// to handle CUP payment type in cardtx table
	public final static String S9090_TXN_CUP_SALE = "a";
	public final static String S9090_TXN_CUP_OFF_SALE = "b";
	public final static String S9090_TXN_CUP_RET = "h";
	public final static String S9090_TXN_CUP_REFUND = "l";
	public final static String S9090_TXN_CUP_VOID = "d";
	// to handle QR payment type in cardtx table
	public final static String S9090_TXN_QR_SALE = "A";
	public final static String S9090_TXN_QR_REFUND = "C";
	public final static String S9090_TXN_QR_VOID = "B";
	// To handle OCT payment, not know the exact value, use for temp use
	public final static String S9090_TXN_OCT_SALE = "0";
	public final static String S9090_TXN_OCT_RET = "4";
	public final static String S9090_TXN_OCT_REFUND = "2";
	public final static String S9090_TXN_OCT_VOID = "3";

	public final static String S9000_CARD_VISA = "01";
	public final static String S9000_CARD_MASTER = "02";
	public final static String S9000_CARD_JCB = "03";
	public final static String S9000_CARD_AMEX = "04";
	public final static String S9000_CARD_DINERS = "05";
	public final static String S9000_CARD_EPS = "06";

	public final static String S9000_RST_ACCEPT = "00";
	public final static String S9000_RST_BANK = "01";
	public final static String S9000_RST_REF = "02";
	public final static String S9000_RST_REJECT = "51";
	public final static String S9000_RST_LOST = "41";
	public final static String S9000_RST_STOLE = "43";
	public final static String S9000_RST_BUSY = "BB";
	public final static String S9000_RST_IPTTIMEOUT = "OT";
	public final static String S9000_RST_CANCEL = "CN";
	public final static String S9000_RST_CONNFAIL = "LC";
	public final static String S9000_RST_COMMFAIL = "NC";
	public final static String S9000_RST_RSPTIMEOUT = "TO";

	public final static String S9000_EPS_ACCEPT = "000";
	public final static String S9090_EPS_RSPTIMEOUT = "OT";
	public final static String S9090_EPS_CANCEL = "CN";
}
