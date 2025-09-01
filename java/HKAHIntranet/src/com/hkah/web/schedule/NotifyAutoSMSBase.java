package com.hkah.web.schedule;

import java.io.IOException;
import java.util.ArrayList;

import com.hkah.util.PasswordUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.sms.UtilSMS;
import com.hkah.web.common.ReportableListObject;

public class NotifyAutoSMSBase {
	//======================================================================
	private static String sqlStr_getSMSReturnMsg = null;

	private static String sqlStr_updateSMSReturnMsg_Booking4Patient_Success = null;
	private static String sqlStr_updateSMSReturnMsg_Booking4Patient_Sent = null;
	private static String sqlStr_updateSMSReturnMsg_Booking4Doctor_Success = null;
	private static String sqlStr_updateSMSReturnMsg_Booking4Doctor_Sent = null;
	private static String sqlStr_updateSMSReturnMsg_PatientActivity_Success = null;
	private static String sqlStr_updateSMSReturnMsg_PatientActivity_Sent = null;

	public static String UPDATE_TABLE_BOOKING4PATIENT = "BOOKING4PATIENT";
	public static String UPDATE_TABLE_BOOKING4DOCTOR = "BOOKING4DOCTOR";
	public static String UPDATE_TABLE_PATIENTACTIVITY = "PATIENTACTIVITY";

	// ======================================================================
	protected static void sendSMS(String loginID, String password, String logType, String updateType,
			String phoneNo, String countryCode, String patNo, String message, String bkgID) {
		try {
			String password_decrypted = PasswordUtil.cisDecryption(password);
			String phoneNo_new = UtilSMS.getPhoneNo2(phoneNo, countryCode, patNo, null, null, null, logType);
			String msgId = UtilSMS.sendSMS(loginID, password_decrypted, null, phoneNo_new, message, logType);

			// call procedure
			if (updateType != null && updateType.length() > 0) {
				boolean success = getSuccessOfSMS(msgId);

				if (UPDATE_TABLE_BOOKING4PATIENT.equals(updateType)) {
					updateSuccessTimeAndMsg_Booking4Patient(bkgID, msgId, success);
				} else if (UPDATE_TABLE_BOOKING4DOCTOR.equals(updateType)) {
					updateSuccessTimeAndMsg_Booking4Doctor(bkgID, msgId, success);
				} else if (UPDATE_TABLE_PATIENTACTIVITY.equals(updateType)) {
					updateSuccessTimeAndMsg_PatientActivity(bkgID, patNo, msgId, success);
				}
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private static boolean getSuccessOfSMS(String msgId) {
		ArrayList record = UtilDBWeb.getReportableList(sqlStr_getSMSReturnMsg, new String[] {msgId});
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject)record.get(0);

			return row.getValue(0).equals("1");
		} else {
			return false;
		}
	}

	private static boolean updateSuccessTimeAndMsg_Booking4Patient(String bkgid, String msgId, boolean success) {
		if (success) {
			return UtilDBWeb.updateQueue(sqlStr_updateSMSReturnMsg_Booking4Patient_Success, new String[] {msgId, msgId, bkgid});
		} else {
			return UtilDBWeb.updateQueue(sqlStr_updateSMSReturnMsg_Booking4Patient_Sent, new String[] {bkgid});
		}
	}

	private static boolean updateSuccessTimeAndMsg_Booking4Doctor(String bkgid, String msgId, boolean success) {
		if (success) {
			return UtilDBWeb.updateQueue(sqlStr_updateSMSReturnMsg_Booking4Doctor_Success, new String[] {msgId, msgId, bkgid});
		} else {
			return UtilDBWeb.updateQueue(sqlStr_updateSMSReturnMsg_Booking4Doctor_Sent, new String[] {bkgid});
		}
	}

	private static boolean updateSuccessTimeAndMsg_PatientActivity(String bkgid, String patNo, String msgId, boolean success) {
		if (success) {
			return UtilDBWeb.updateQueue(sqlStr_updateSMSReturnMsg_PatientActivity_Success, new String[] {msgId, msgId, bkgid, patNo});
		} else {
			return UtilDBWeb.updateQueue(sqlStr_updateSMSReturnMsg_PatientActivity_Sent, new String[] {bkgid, patNo});
		}
	}

	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.setLength(0);
		sqlStr.append("SELECT SUCCESS ");
		sqlStr.append("FROM SMS_LOG ");
		sqlStr.append("WHERE MSG_BATCH_ID = ? ");
		sqlStr_getSMSReturnMsg = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BOOKING@IWEB ");
		sqlStr.append("SET SMSSDTOK = (SELECT SEND_TIME FROM SMS_LOG WHERE MSG_BATCH_ID = ?), ");
		sqlStr.append("    SMSRTNMSG = (SELECT RES_MSG FROM SMS_LOG WHERE MSG_BATCH_ID = ?), ");
		sqlStr.append("    SMSSDT = SYSDATE ");
		sqlStr.append("WHERE BKGID = ? ");
		sqlStr_updateSMSReturnMsg_Booking4Patient_Success = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BOOKING@IWEB ");
		sqlStr.append("SET SMSSDTOK = 'SENT', ");
		sqlStr.append("    SMSSDT = SYSDATE ");
		sqlStr.append("WHERE BKGID = ? ");
		sqlStr_updateSMSReturnMsg_Booking4Patient_Sent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BOOKING_EXTRA@IWEB ");
		sqlStr.append("SET DOCSMSSDTOK = (SELECT SEND_TIME FROM SMS_LOG WHERE MSG_BATCH_ID = ?), ");
		sqlStr.append("    DOCSMSRTNMSG = (SELECT RES_MSG FROM SMS_LOG WHERE MSG_BATCH_ID = ?), ");
		sqlStr.append("    DOCSMSSDT = SYSDATE ");
		sqlStr.append("WHERE BKGID = ? ");
		sqlStr_updateSMSReturnMsg_Booking4Doctor_Success = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BOOKING_EXTRA@IWEB ");
		sqlStr.append("SET DOCSMSSDTOK = 'SENT', ");
		sqlStr.append("    DOCSMSSDT = SYSDATE ");
		sqlStr.append("WHERE BKGID = ? ");
		sqlStr_updateSMSReturnMsg_Booking4Doctor_Sent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE PATIENT_ACTIVITY_LOG@IWEB ");
		sqlStr.append("SET REMARK = (SELECT RES_MSG FROM SMS_LOG WHERE MSG_BATCH_ID = ?), ");
		sqlStr.append("    ACTION_DATE = (SELECT SEND_TIME FROM SMS_LOG WHERE MSG_BATCH_ID = ?), ");
		sqlStr.append("    ACTION_USER = 'SYSTEM' ");
		sqlStr.append("WHERE MODULE || '-' || ACTION_TYPE = ? ");
		sqlStr.append("AND   PATNO = ? ");
		sqlStr_updateSMSReturnMsg_PatientActivity_Success = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE PATIENT_ACTIVITY_LOG@IWEB ");
		sqlStr.append("SET REMARK = 'SENT', ");
		sqlStr.append("    ACTION_DATE = SYSDATE, ");
		sqlStr.append("    ACTION_USER = 'SYSTEM' ");
		sqlStr.append("WHERE MODULE || '-' || ACTION_TYPE = ? ");
		sqlStr.append("AND   PATNO = ? ");
		sqlStr_updateSMSReturnMsg_PatientActivity_Sent = sqlStr.toString();
	}
}
