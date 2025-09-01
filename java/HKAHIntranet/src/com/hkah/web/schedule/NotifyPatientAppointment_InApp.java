package com.hkah.web.schedule;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Locale;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mobile.UtilMobile;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.mobile.NotifyService;

public class NotifyPatientAppointment_InApp implements Job {

	//======================================================================
	private static Logger logger = Logger.getLogger(NotifyPatientAppointment_InApp.class);
	final static SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

	static HashMap<String, String> inapp_token = new HashMap<String, String>();
	static HashMap<String, String> inapp_MSG_BK = new HashMap<String, String>();

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		sendInAppMsg(false);
	}

	//======================================================================
	public static void sendInAppMsg(boolean ignoreSentDate) {
		// get current day
		Calendar startCal = Calendar.getInstance();
		Calendar endCal = Calendar.getInstance();
		sendInAppMsg(startCal, endCal, ignoreSentDate);
	}

	//======================================================================
	public static void sendInAppMsg(Calendar startCal, boolean ignoreSentDate) {
		// get current day
		sendInAppMsg(startCal, startCal, ignoreSentDate);
	}

	//======================================================================
	public static void sendInAppMsg(Calendar startCal, Calendar endCal, boolean ignoreSentDate) {

		if (!UtilMobile.isSmsScheduleDay(startCal)) {
			return;
		}

		startCal = UtilMobile.getAppointmentDay(startCal, ignoreSentDate);
		endCal = UtilMobile.getAppointmentDay(endCal, ignoreSentDate);

		 org.json.JSONObject resultJSON = new org.json.JSONObject();

		String testToken = NotifyService.getToken(
				getHPStatus("token", "target"),
				getHPStatus("token", "path"),
				getHPStatus("token", "OCPKEY"),
				getHPStatus("token", "AUTH"),
				getHPStatus("token", "USERNAME"),
				getHPStatus("token", "PASSWORD"));

		ArrayList record = UtilDBWeb.getFunctionResultsHATS("NHS_LIS_INAPP_ALERT_WS", new String[] { smf.format(startCal.getTime()), smf.format(endCal.getTime())});
		ReportableListObject row = null;
		String msgResult = null;
		if (record.size() > 0) {
			for(int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);

				try {
					if (testToken != null && !"".equals(testToken)) {
						msgResult = NotifyService.sendMsg(
								getHPStatus("INAPPMSG_BK", "TARGET"),
								getHPStatus("INAPPMSG_BK", "PATH"),
								testToken,
								NotifyService.getMsgJSONString(row.getValue(0), row.getValue(1), row.getValue(3), row.getValue(4), row.getValue(5)));

						logger.info("NotifyService.sendMsg[" + row.getValue(0) + "][" + row.getValue(1) + "][" + row.getValue(3) + "]");

						if (msgResult != null && msgResult.length() > 0) {
							resultJSON = new org.json.JSONObject(msgResult);

							if ((Boolean) resultJSON.get("success")) {
								if (UtilMobile.saveMsgLog((String) resultJSON.get("status"), (String) row.getValue(1), "mobile", "", row.getValue(2), 1)) {
									UtilMobile.updateSuccessTimeAndMsg(row.getValue(1));
								} else {
									UtilMobile.saveMsgLog((String) resultJSON.get("status"), (String) row.getValue(1), "mobile", "", row.getValue(2), 0);
								}
							}
						}
					}
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}

	private static String getHPStatus(String status, String key) {
		String value = null;
		if ("token".equals(status)) {
			if (inapp_token.containsKey(key)) {
				value = inapp_token.get(key); 
			} else {
				value = getHPStatusHelper(status, key);
				inapp_token.put(key,  value);
			}
		} else if ("INAPPMSG_BK".equals(status)) {
			if (inapp_MSG_BK.containsKey(key)) {
				value = inapp_MSG_BK.get(key); 
			} else {
				value = getHPStatusHelper(status, key);
				inapp_MSG_BK.put(key,  value);
			}
		}
		return value;
	}

	private static String getHPStatusHelper(String status, String key) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT HPRMK FROM HPSTATUS@IWEB WHERE HPTYPE = 'MOBILEAPP' AND HPSTATUS = UPPER('");
		sqlStr.append(status);
		sqlStr.append("') AND  HPKEY = UPPER('");
		sqlStr.append(key);
		sqlStr.append("')");

		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return null;
		}
	}
}