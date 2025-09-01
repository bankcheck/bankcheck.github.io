package com.hkah.web.db;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpSession;

import com.hkah.config.MessageResources;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class OBBookingDB {

	private static String sqlStr_insertOBBooking = null;
	private static String sqlStr_updateStatus = null;

	public static HashMap<String, String> getStatusSet(HttpSession session) {
		HashMap<String, String> statusHashSet = new HashMap<String, String>();
		statusHashSet.put("O", MessageResources.getMessage(session, "label.open"));
		statusHashSet.put("W", "Waiting Queue");
		statusHashSet.put("T", "Tentatively");
		statusHashSet.put("B", "Confirm");
		statusHashSet.put("X", MessageResources.getMessage(session, "label.cancel"));
		return statusHashSet;
	}

	private static String getNextOBBookingID() {
		String obbookingID = null;
		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList("SELECT MAX(OB_BOOKING_ID) + 1 FROM OB_BOOKINGS");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result
					.get(0);
			obbookingID = reportableListObject.getValue(0);
			if (obbookingID == null || obbookingID.length() == 0)
				return "1";
		}
		return obbookingID;
	}

	public static String add(UserBean userBean) {
		return add(userBean, null);
	}

	public static String add(UserBean userBean, String pbpID) {
		String obbookingID = getNextOBBookingID();
		if (UtilDBWeb.updateQueue(
				sqlStr_insertOBBooking,
				new String[] { obbookingID, pbpID, userBean.getLoginID(), userBean.getLoginID() })) {
			return obbookingID;
		} else {
			return null;
		}
	}

	public static boolean updateStatus(UserBean userBean, String obbookingID, String status) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateStatus,
				new String[] { status, userBean.getLoginID(), obbookingID });
	}

	public static ArrayList<ReportableListObject> get(String obbookingID, String pbpID) {
		return UtilDBWeb.getFunctionResults("OB_BOOKING_GET",  new String[] { obbookingID, pbpID });
	}

	public static ArrayList<ReportableListObject> getList(String edcFrom, String edcTo, String doctorCode, String countryType, String status) {
		return UtilDBWeb.getFunctionResults("OB_BOOKING_LIST", new String[] { edcFrom, edcTo, doctorCode, countryType, status });
	}

	public static ArrayList<ReportableListObject> getQuota(String docCode, String edc) {
		return UtilDBWeb.getFunctionResults("OB_GET_QUOTA_WRAPPER", new String[] { docCode, edc });
	}

	public static ArrayList<ReportableListObject> makeBooking(UserBean userBean, String obbookingID, boolean skipQuotaCheck) {
		return UtilDBWeb.getFunctionResults("OB_BOOKING_CREATE", new String[] { switch2HATSID(userBean.getUserName()), obbookingID, skipQuotaCheck?"Y":"N" });
	}

	public static boolean updateBooking(
			UserBean userBean, String obbookingID, String doctorCode, String patientID,
			String lastName, String firstName, String chineseName,
			String contactNo, String DOBDate, String docType, String docNo,
			String kinLastName, String kinFirstName, String kinChineseName,
			String kinContactNo, String kinDOBDate, String kinDocType, String kinDocNo,
			String checkedDate1, String checkedDate2, String checkedDate3, String checkedDate4, String checkedDate5,
			String labResultReady, String pboRemark) {
		ArrayList<ReportableListObject> record = UtilDBWeb.getFunctionResults("OB_BOOKING_UPDATE",
				new String[] {
				switch2HATSID(userBean.getUserName()), obbookingID,
				doctorCode, patientID,
				lastName, firstName, chineseName,
				contactNo, DOBDate, docType, docNo,
				kinLastName, kinFirstName, kinChineseName,
				kinContactNo, kinDOBDate, kinDocType, kinDocNo,
				checkedDate1, checkedDate2, checkedDate3, checkedDate4, checkedDate5,
				labResultReady, pboRemark});
		if (record.size() > 0) {
			ReportableListObject row = record.get(0);
			if ("U".equals(row.getValue(0))) {
				return true;
			}
		}
		return false;
	}

	public static ArrayList<ReportableListObject> cancelBooking(UserBean userBean, String pbpid, String reason) {
		return UtilDBWeb.getFunctionResults("OB_BOOKING_CANCEL", new String[] { switch2HATSID(userBean.getUserName()), pbpid, reason });
	}

	public static boolean updateEDC(UserBean userBean, String obbookingID, String expectedDeliveryDate) {
		ArrayList<ReportableListObject> record = UtilDBWeb.getFunctionResults("OB_BOOKING_UPDATE_EDC",  new String[] { switch2HATSID(userBean.getUserName()), obbookingID, expectedDeliveryDate });
		if (record.size() > 0) {
			ReportableListObject row = record.get(0);
			if ("U".equals(row.getValue(0))) {
				return true;
			}
		}
		return false;
	}

	public static ArrayList<ReportableListObject> hats2Booking(
			UserBean userBean, String pbpID, String status, String cancelReason) {
		return UtilDBWeb.getFunctionResults("OB_HATS_2_BOOKING_WRAPPER",  new String[] { switch2HATSID(userBean.getUserName()), pbpID, status, cancelReason });
	}

	/**
	 * check whether patient id is exists, true is not exists, false is exists
	 * @param patientID
	 * @return
	 */
	public static boolean checkPatientID(String patientID) {
		ArrayList<ReportableListObject> record = UtilDBWeb.getFunctionResults("OB_CHECK_PATIENT_ID",  new String[] { patientID });
		if (record.size() > 0) {
			ReportableListObject row = record.get(0);
			if ("0".equals(row.getValue(0))) {
				return true;
			}
		}
		return false;
	}

	// TODO: temp switch
	public static String switch2HATSID(String username) {
		if (username.length() <= 10) {
			return username.toUpperCase();
		} else {
			return username.substring(0, 10).toUpperCase();
		}
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO OB_BOOKINGS (");
		sqlStr.append("OB_BOOKING_ID, OB_PBP_ID, OB_CREATED_USER, OB_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?)");
		sqlStr_insertOBBooking = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE OB_BOOKINGS SET OB_BOOKING_STATUS = ?, OB_MODIFIED_DATE = SYSDATE, OB_MODIFIED_USER = ?  WHERE OB_BOOKING_ID = ?");
		sqlStr_updateStatus = sqlStr.toString();
	}
}