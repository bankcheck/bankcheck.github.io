package com.hkah.client.tx.cashier;

import com.hkah.client.MainFrame;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

public class ARs {
	public final static String ARTX_STATUS_NORMAL="N";
	public final static String ARTX_STATUS_CANCEL="C";
	public final static String ARTX_STATUS_REVERSE="R";

	public final static String ARPTX_STATUS_NORMAL="N";
	public final static String ARPTX_STATUS_CANCEL="C";
	public final static String ARPTX_STATUS_REVERSE="R";

	public final static String ARTX_TYPE_CHARGES="C";
	public final static String ARTX_TYPE_PAYMENT="P";
	public final static String ARTX_TYPE_ADJUST="A";

	public final static String AR_ADJUST_MODE="A";
	public final static String AR_CHARGE_MODE="C";

	public final static String AR_DETAIL="DETAIL";
	public final static String AR_CREDIT_ALLOC="CREDALLOC";


	public static void UpdateARTransaction(MainFrame mainFrame, String capturedate) {
		String CapDate="";
		String txCode = "UPDATE";
		String[] para = null;
		MessageQueue mQueue = null;
		if (capturedate == null || capturedate.trim().length() == 0) {
			CapDate = mainFrame.getServerDateTime();
		} else {
			CapDate = capturedate;
		}
		para = new String[] {"ArTx","AtxCDate=to_date('"+CapDate+"','dd/mm/yyyy')","AtxCDate is Null"};
		QueryUtil.executeMasterAction(mainFrame.getUserInfo(), txCode, QueryUtil.ACTION_MODIFY, para);

		para = new String[] {"ArpTx","ArpCDate=to_date('"+CapDate+"','dd/mm/yyyy')","ArpCDate is Null"};
		QueryUtil.executeMasterAction(mainFrame.getUserInfo(), txCode, QueryUtil.ACTION_MODIFY, para);
	}

	public static void FindArpIDReady(String arpid) {}

	public static void FindArpID(UserInfo userInfo,String ReceiptNo) {
		QueryUtil.executeMasterFetch(userInfo, ConstantsTx.LOOKUP_TXCODE,
				new String[] {"arptx","arpid","arpsts = 'N' and arprecno ='"+ReceiptNo+"'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					FindArpIDReady(mQueue.getContentField()[0]);
				} else {
					FindArpIDReady("");
				}
			}
		});
	}

	public static void ARPaymentCancel(UserInfo userInfo,String TransactionID) {
		String txCode="ARPAYMENTCANCEL";
		String[] para = new String[] {TransactionID};
		QueryUtil.executeMasterAction(userInfo, txCode, QueryUtil.ACTION_APPEND, para);
	}

	public static void UpdateCashierAR(UserInfo userInfo,String CashierCode,String ArAmount) {
		String txCode = "UPDATE";
        String[] para = new String[] {"Cashier","CSHOTHER=CSHOTHER+"+ArAmount,"CSHCODE='"+CashierCode+"'"};
        QueryUtil.executeMasterAction(userInfo, txCode, QueryUtil.ACTION_MODIFY, para);
	}

	private static void SetAREntry(UserInfo userInfo,String ARTransactionID,String Status) {
		String txCode = "UPDATE";
        String[] para = new String[] {"ArTx","AtxSts='"+Status+"'","AtxID="+ARTransactionID};
        QueryUtil.executeMasterAction(userInfo, txCode, QueryUtil.ACTION_MODIFY, para);
	}

	private static void UpdateARBalance(UserInfo userInfo,String Arcode,String UnSettledAmount,String UnAllocatedAmount) {
		String txCode = "UPDATE";
        String[] para = new String[] {"ArCode","ArcAmt = ArcAmt + "+UnSettledAmount+",ArcUAmt = ArcUAmt +"+UnAllocatedAmount,"ArcCode='"+Arcode+"'"};
        QueryUtil.executeMasterAction(userInfo, txCode, QueryUtil.ACTION_MODIFY, para);
	}
}