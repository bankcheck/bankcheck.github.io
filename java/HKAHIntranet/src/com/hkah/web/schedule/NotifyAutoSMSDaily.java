package com.hkah.web.schedule;

import java.util.ArrayList;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;

public class NotifyAutoSMSDaily extends NotifyAutoSMSBase implements Job {

	//======================================================================
	private static Logger logger = Logger.getLogger(NotifyAutoSMSDaily.class);
	private static String sqlStr_getSchedule = null;

	@Override
	public void execute(JobExecutionContext arg0) {
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr_getSchedule);
		ReportableListObject row = null;
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			doActionHelper(row.getFields0(), row.getFields1(), row.getFields2(), row.getFields3(), row.getFields4(), row.getFields5());
		}

		logger.info("Thread NotifyAutoSMSDailyThread doAction finish");
	}

	private static void doActionHelper(String loginID, String password, String criteriaSQL, String preexcSP, String updateType, String logType) {
		// call procedure
		if (preexcSP != null && preexcSP.length() > 0) {
			UtilDBWeb.executeFunction(preexcSP);
		}

		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(criteriaSQL);
		ReportableListObject row = null;
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			sendSMS(loginID, password, logType, updateType, row.getFields2(), row.getFields3(), row.getFields1(), row.getFields4(), row.getFields0());
		}
	}

	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_LOGIN_ID, CO_PASSWORD_ID, CO_CRITERIA_SQL, CO_PREEXEC_SP, CO_PROEXEC_SQL, CO_LOG_TYPE ");
		sqlStr.append("FROM   CO_AUTO_SMS_DAILY ");
		sqlStr.append("WHERE  CO_ENABLED = '1' ");
		sqlStr.append("AND    CO_START_HOUR <= TO_CHAR(SYSDATE, 'HH24') ");
		sqlStr.append("AND    CO_END_HOUR >= TO_CHAR(SYSDATE, 'HH24') ");
		sqlStr_getSchedule = sqlStr.toString();
	}
}