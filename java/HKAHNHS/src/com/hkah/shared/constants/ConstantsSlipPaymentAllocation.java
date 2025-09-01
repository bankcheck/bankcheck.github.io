package com.hkah.shared.constants;

import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.UserInfo;

public class ConstantsSlipPaymentAllocation {
	public static final String SLIP_PAYMENT_USER_ALLOCATE = "N";//User Allocated
	public static final String SLIP_PAYMENT_AUTO_ALLOCATE = "A";//Auto Allocated

	public static final String SLIP_PAYMENT_CANCEL = "C";//Canceled

	public static final String SLIP_PAYMENT_USER_REVERSE = "U";//Reverse by User
	public static final String SLIP_PAYMENT_REVERSE = "R";//Reverse by System
	public static final String SLIP_PAYMENT_B4_PAID_REVERSE = "X";//Reverse before Paid, not affect Dr.Fee

	public static final String SLIP_PAYMENT_CHECK_NONE = "N";//No need for allocation
	public static final String SLIP_PAYMENT_CHECK_AUTO = "A";//Auto
	public static final String SLIP_PAYMENT_CHECK_MANUAL = "M";//Manual required

	//Message Constant
	public static final String MSG_SPA_ALLOCATED_AMOUNT_EXCESS_CHG = "Allocated amount of excess the amount of the charge.";
	public static final String MSG_SPA_ALLOCATED_AMOUNT_EXCESS_PAY = "Allocated amount of excess the amount of the payment.";
	public static final String MSG_SPA_MANUAL_ALLOCATION_REQUIRED = "Manual Allocation for doctor's share is required!";

	public static final String MSG_SPA_AUTO_MAN_ALL = "Auto allocation abort.\n Slip has been manually allocated.";
	public static final String MSG_SPA_AUTO_SLP_BAL = "Slip balance is not zero.";

	public static final int ERR_SPA_AUTO_MAN_ALL = 1;
	public static final int ERR_SPA_AUTO_SLP_BAL = 2;

	public static final String ITMCODE_PREFIX = "1_";
	public static final String DSCCODE_PREFIX = "2_";
	public static final String PCYID_PREFIX = "3_";
	public static final String PATTYPE_PREFIX = "4_";

	public static final String FIX_INDEX = "F";
	public static final String PCT_INDEX = "P";

	public static final int BUFFER_SIZE =30;

	public static final int STAGE_1 = 10;
	public static final int STAGE_2 = 20;
	public static final int STAGE_25 = 25;
	public static final int STAGE_27 = 27;
	public static final int STAGE_3 = 30;
	public static final int STAGE_4 = 40;
	public static final int STAGE_41 =41;
	public static final int STAGE_42 = 42;
	public static final int STAGE_43 = 43;
	public static final int STAGE_44 = 44;
	public static final int STAGE_45 = 45;
	public static final int STAGE_5 = 50;
	public static final int STAGE_55 = 55;
	public static final int STAGE_6 = 60;
	public static final int STAGE_70 = 70;
	public static final int STAGE_75 = 75;
	public static final int STAGE_8 = 80;
	public static final int STAGE_9 = 90;
	public static final int STAGE_10 = 100;
	public static final int STAGE_11 = 110;

	public static final String REPORT_NAME_DOCFEE="Doctor Fee";
	public static final String REPORT_NAME_SCM="Special Commission";

	private static void SCMUpdateCascadeReverse(UserInfo userInfo,String SlipNo,String PcyID) {
		String txCode="SCMUPDCASCADEREVERSE";
		String[] para=new String[] {SlipNo,PcyID};
		QueryUtil.executeMasterAction(userInfo, txCode, QueryUtil.ACTION_MODIFY, para);// include SlpPayAllSlipTxReverse
	}
}