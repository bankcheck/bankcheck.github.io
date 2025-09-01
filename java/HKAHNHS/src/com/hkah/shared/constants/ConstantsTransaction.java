package com.hkah.shared.constants;

import java.util.logging.Logger;

import com.hkah.client.event.CallbackListener;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

public class ConstantsTransaction {

	public static final String SLIP_STATUS_OPEN = "A";		// Active
	public static final String SLIP_STATUS_CLOSE = "C";		// Closed
	public static final String SLIP_STATUS_REMOVE = "R";	// Removed

	public static final String SLIP_TYPE_INPATIENT = "I";
	public static final String SLIP_TYPE_OUTPATIENT = "O";
	public static final String SLIP_TYPE_DAYCASE = "D";

	public final static String SLIPTX_STATUS_NORMAL = "N";
	public final static String SLIPTX_STATUS_ADJUST  = "A";
	public final static String SLIPTX_STATUS_CANCEL = "C";
	public final static String SLIPTX_STATUS_USER_REVERSE  = "U";
	public final static String SLIPTX_STATUS_REVERSE = "R";
	public final static String SLIPTX_STATUS_TRANSFER = "T";

	public final static String SLIPTX_STATUS_MOVE = "M";	// Pkgtx Status

	public final static String PKGTX_TYPE_NORMAL = "P";	// Normal package
	public final static String PKGTX_TYPE_NATUREOFVISIT = "N";	// Nature of Visit
	public final static String PKGTX_TYPE_BOTH  = "B";	// Both

	public final static String SLIPTX_TYPE_DEBIT = "D";
	public final static String SLIPTX_TYPE_CREDIT  = "C";
	public final static String SLIPTX_TYPE_PAYMENT_C = "S";
	public final static String SLIPTX_TYPE_PAYMENT_A = "P";
	public final static String SLIPTX_TYPE_REFUND = "R";
	public final static String SLIPTX_TYPE_DEPOSIT_I = "I";
	public final static String SLIPTX_TYPE_DEPOSIT_O = "O";
	public final static String SLIPTX_TYPE_DEPOSIT_X  = "X";

	public final static String CASHTX_PAYTYPE_OTHER = "I";
	public final static String CASHTX_PAYTYPE_CUP  = "O";
	public final static String CASHTX_PAYTYPE_OCTOPUS = "D";

	public final static String ITEM_CATEGORY_CREDIT = "C";
	public final static String ITEM_CATEGORY_DEBIT = "D";
	public final static String ITEM_CATEGORY_BOTH = "B";
	public final static String ITEM_CATEGORY_DEPOSIT  = "O";

	public final static String TYPE_DOCTOR = "D";
	public final static String TYPE_HOSPITAL = "H";
	public final static String TYPE_SPECIAL = "S";
	public final static String TYPE_OTHERS = "O";

	public final static int GLCCODE_NORMAL_LENGTH = 4;
	public final static int TXN_SPECIAL_REPORTLEVEL = 4;

	public final static String TXN_PAYMENT_ITMCODE = "PAYME";
	public final static String TXN_REFUND_ITMCODE = "REF";
	public final static String TXN_ADJUST_ITMCODE = "ADJUS";

	public final static int MAX_AMOUNT_LIMIT = 9;

	public final static String TXN_ADD_MODE = "ADD";
	public final static String TXN_ADJUST_MODE = "ADJUST";
	public final static String TXN_TRANSFER_MODE = "TRANSFER";
	public final static String TXN_UPDATE_MODE  = "UPDATE";
	public final static String TXN_CHANGE_MODE = "CHANGE";
	public final static String TXN_CREDITITEM_MODE = "CREDITITEM";
	public final static String TXN_CREDITITEMPER_MODE = "CREDITITEMPER";

	public final static String CREDIT_ITEM_CHARGE_MODE  = "C";
	public final static String ITEM_CHARGE_MODE = "I";
	public final static int DOCTOR_STATUS_ACTIVE = -1;

	public final static String SLIPTX_CPS_STD = "";
	public final static String SLIPTX_CPS_STD_FIX = "F";
	public final static String SLIPTX_CPS_STD_PCT = "P";
	public final static String SLIPTX_CPS_STA = "S";
	public final static String SLIPTX_CPS_STA_FIX = "T";
	public final static String SLIPTX_CPS_STA_PCT = "U";
	protected static Logger logger = Logger.getLogger(ConstantsTransaction.class.getName());

	public static void UpdateCaptureDate(UserInfo userInfo,String UserID,String capturedate) {
		String txCode= "UPDATE";
		String[]para=new String[] {"sliptx","StnCDate=to_date('"+capturedate+"','dd/mm/yyyy hh24:mi:ss')","StnCDate is null and UsrID='"+UserID+"' and StnType='"+SLIPTX_TYPE_PAYMENT_C+"'"};
		logger.info("UpdateCaptureDate SQL=update sliptx set StnCDate=to_date('"+capturedate+"','dd/mm/yyyy hh24:mi:ss') where StnCDate is null and UsrID='"+UserID+"' and StnType='"+SLIPTX_TYPE_PAYMENT_C+"'");
		QueryUtil.executeMasterAction(userInfo, txCode, QueryUtil.ACTION_MODIFY, para,
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					logger.info("UpdateCaptureDate CommitTrans.");
				} else {
					logger.info("UpdateCaptureDate CommitTrans Failed.");
				}
			}
		});
	}

	public static void UpdateSliptxStatus(UserInfo userInfo,String SlipNo,String NewTransactionType,String OldTransactionType,String TransactionID,String DepositID) {
		logger.info("UpdateSliptxStatus");
		String txCode = "UPDATESLIPTXSTATUS";
		String[]para=new String[] {SlipNo,NewTransactionType,OldTransactionType,TransactionID,DepositID};
		QueryUtil.executeMasterAction(userInfo, txCode, QueryUtil.ACTION_APPEND, para, new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
			}
		});
	}

	public static void UpdateSlip(UserInfo userInfo, String SlipNo) {
		logger.info("UpdateSlip");
		QueryUtil.executeMasterAction(userInfo, "UPDATESLIP", QueryUtil.ACTION_MODIFY, new String[] { SlipNo }, new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
			}
		});
	}

	public static int GetNewCPSCases(String fmFlag,String toFlag) {
		int getnewcpscases=0;
		if (("P".equals(fmFlag)&&"P".equals(toFlag))||("U".equals(fmFlag)&&"U".equals(toFlag))) {
			getnewcpscases=1;
		} else if (("P".equals(fmFlag)&&"F".equals(toFlag))||("U".equals(fmFlag)&&"T".equals(toFlag))) {
			getnewcpscases=2;
		} else if (("F".equals(fmFlag)&&"F".equals(toFlag))||("T".equals(fmFlag)&&"T".equals(toFlag))) {
			getnewcpscases=3;
		} else if (("F".equals(fmFlag)&&"P".equals(toFlag))||("T".equals(fmFlag)&&"U".equals(toFlag))) {
			getnewcpscases=4;
		} else if (("".equals(fmFlag)&&"F".equals(toFlag))||("S".equals(fmFlag)&&"T".equals(toFlag))) {
			getnewcpscases=5;
		} else if (("".equals(fmFlag)&&"P".equals(toFlag))||("S".equals(fmFlag)&&"U".equals(toFlag))) {
			getnewcpscases=6;
		} else if (("F".equals(fmFlag)&&"".equals(toFlag))||("T".equals(fmFlag)&&"S".equals(toFlag))) {
			getnewcpscases=7;
		} else if (("P".equals(fmFlag)&&"".equals(toFlag))||("U".equals(fmFlag)&&"S".equals(toFlag))) {
			getnewcpscases=8;
		}
		return getnewcpscases;
	}

	public static String GetDiscName(String ItemType) {
		if (TYPE_DOCTOR.equals(ItemType)) {
			return "SlpDDisc";
		} else if (TYPE_HOSPITAL.equals(ItemType)) {
			return "SlpHDisc";
		} else {
			return "SlpSDisc";
		}
	}

	public static void addPackageEntry(UserInfo userInfo,String SlipNo,String PackageCode,String ItemCode,
			String StnOAmt,String StnBAmt, String DoctorCode,String ReportLevel,String AccomodationCode,
			String capturedate,String TransactionDate,String Description,String Status,String BedCode,
			String dixref,boolean flagToDi,String ConPceSetFlag,String unitAmt,String Stndesc1,String IRefNo,final CallbackListener callbackListener) {
	  QueryUtil.executeMasterAction(
			  userInfo, "ADDPKGENTRY", QueryUtil.ACTION_APPEND,
			  new String[] {
					  SlipNo  ,
					  PackageCode,
					  ItemCode,
					  StnOAmt,
					  StnBAmt,
					  DoctorCode  ,
					  ReportLevel ,
					  AccomodationCode  ,
					  capturedate ,
					  TransactionDate ,
					  Description ,
					  Status      ,
					  BedCode     ,
					  dixref ,
					  flagToDi?"1":"0"    ,//--1-true,0-false
					  ConPceSetFlag,
					  unitAmt,
					  Stndesc1,
					  IRefNo,
					  "1",
					  userInfo.getUserID()
			  },
			  new MessageQueueCallBack() {
				  @Override
				  public void onPostSuccess(MessageQueue mQueue) {
					  if (mQueue.success()) {
						  callbackListener.handleRetBool(mQueue.success(), null, null);
					  }
				  }
			  });
	}
	/**
	 *
	 * @return return 1 if MB,return 2 if not MB,return -1 if cannot perform print report
	 */
}