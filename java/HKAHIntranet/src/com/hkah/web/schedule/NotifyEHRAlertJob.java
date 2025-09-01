package com.hkah.web.schedule;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;

public class NotifyEHRAlertJob implements Job {

	// ======================================================================
	private static Logger logger = Logger.getLogger(NotifyEHRAlertJob.class);
	private static Map<String, String> batchStatusTypes = new HashMap<String, String>();
	private static final String EHR_DATE_UPLOAD_ALERT_CODE = "EHRASENDD";
	private static final String EHR_DATE_UPLOAD_ALERT_FORMAT_DB = "YYYYMMDDHH24MISSFF3";
	private static final String EHR_DATE_UPLOAD_ALERT_FORMAT_JAVA = "yyyyMMddHHmmssSSS";

	static {
		batchStatusTypes.put("ehr.laam.ex", "Exception");
		batchStatusTypes.put("ehr.laam.err", "Error");
		batchStatusTypes.put("ehr.laam.pend", "Pending");
		batchStatusTypes.put("ehr.laam.proc", "Processed");
	}

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		logger.info("[NotifyEHRAlertThread] doAction");
		String currentDateTime = (new SimpleDateFormat(EHR_DATE_UPLOAD_ALERT_FORMAT_JAVA)).format(new Date());
		String lastSendDateTime = getLastSendDateTime();
		if (lastSendDateTime == null) {
			// start from current date time
			lastSendDateTime = currentDateTime;
		}

		StringBuffer header = new StringBuffer();
		header.append(
				"<table border='1' style='background-color: white;border-collapse: collapse;text-align:center; border: 1px solid black;'>");
		header.append("<tr>");
		header.append("<td>Data Domain</td>");
		header.append("<td>Create Date Time</td>");
		header.append("<td>Receiving Date Time </td>");
		header.append("<td>Batch ID</td>");
		header.append("<td>Message Control ID</td>");
		header.append("<td>Upload Mode</td>");
		header.append("<td>Batch Status</td>");
		header.append("<td>Status Description</td>");
		header.append("<td>Parital Status</td>");
		header.append("</tr>");

		Iterator<String> itr = batchStatusTypes.keySet().iterator();
		while (itr.hasNext()) {
			String moduleCode = itr.next();
			String desc = batchStatusTypes.get(moduleCode);
			ArrayList<ReportableListObject> batchRecords = getBatchRecords(lastSendDateTime, moduleCode);
			List<String[]> sendLogs = new ArrayList<String[]>();

			logger.debug("[NotifyEHRAlertThread] Get " + moduleCode + " list, size=" + batchRecords.size());

			if (batchRecords.size() > 0) {
				StringBuffer batchIDs = new StringBuffer();

				StringBuffer content = new StringBuffer();
				content.append("Batch Report (" + desc + "):<br />");
				content.append(header.toString());
				for (int i = 0; i < batchRecords.size(); i++) {
					ReportableListObject batchRow = (ReportableListObject) batchRecords.get(i);
					content.append("<tr>");
					content.append("<td>" + batchRow.getValue(0) + "</td>");
					content.append("<td>" + batchRow.getValue(1) + "</td>");
					content.append("<td>" + batchRow.getValue(2) + "</td>");
					content.append("<td>" + batchRow.getValue(3) + "</td>");
					content.append("<td>" + batchRow.getValue(4) + "</td>");
					content.append("<td>" + batchRow.getValue(5) + "</td>");
					content.append("<td>" + batchRow.getValue(6) + "</td>");
					content.append("<td>" + batchRow.getValue(7) + "</td>");
					content.append("<td>" + batchRow.getValue(8) + "</td>");
					content.append("</tr>");

					if (batchIDs.length() > 0) {
						batchIDs.append(", ");
					}
					batchIDs.append("'" + batchRow.getValue(3) + "'");

					String[] sendLog = new String[4];
					sendLog[0] = moduleCode;
					sendLog[1] = batchRow.getValue(3);
					sendLog[2] = null;
					sendLog[3] = null;
					sendLogs.add(sendLog);
				}
				content.append("</table>");

				if ("ehr.laam.ex".equals(moduleCode)) {
					ArrayList<ReportableListObject> exRecords = getExceptionRecords(batchIDs.toString());
					if (!exRecords.isEmpty()) {
						content.append("<br /><br />Exception Details:");
						content.append(
								"<table border='1' style='background-color: white;border-collapse: collapse;text-align:center; border: 1px solid black;'>");
						content.append("<tr>");
						content.append("<td>Data Domain</td>");
						content.append("<td>Batch ID</td>");
						content.append("<td>Message Control ID</td>");
						content.append("<td>Upload File Name</td>");
						content.append("<td>Exception Category</td>");
						content.append("<td>Error Code</td>");
						content.append("<td>Error Description</td>");
						content.append("<td>Record Key</td>");
						content.append("<td>Ehr No</td>");
						content.append("<td>Data Field</td>");
						content.append("</tr>");

						for (int i = 0; i < exRecords.size(); i++) {
							ReportableListObject exRow = (ReportableListObject) exRecords.get(i);
							content.append("<tr>");
							content.append("<td>" + exRow.getValue(0) + "</td>");
							content.append("<td>" + exRow.getValue(1) + "</td>");
							content.append("<td>" + exRow.getValue(2) + "</td>");
							content.append("<td>" + exRow.getValue(3) + "</td>");
							content.append("<td>" + exRow.getValue(4) + "</td>");
							content.append("<td>" + exRow.getValue(5) + "</td>");
							content.append("<td>" + exRow.getValue(6) + "</td>");
							content.append("<td>" + exRow.getValue(7) + "</td>");
							content.append("<td>" + exRow.getValue(8) + "</td>");
							content.append("<td>" + exRow.getValue(9) + "</td>");
							content.append("</tr>");
						}
						content.append("</table>");
					}
				}

				String title = "[" + ConstantsServerSide.SITE_CODE.toUpperCase() + " "
						+ (ConstantsServerSide.DEBUG ? "UAT " : "PROD") + " eHR] ";
				title += "eHR data upload batch alert (" + desc + ")";
				boolean emailSuccess = EmailAlertDB.sendEmail(moduleCode, title, content.toString());
				if (emailSuccess) {
					logger.info("[NotifyEHRAlertThread] EHR Batch alert (" + desc + ") sent, record size="
							+ batchRecords.size());
				}

			}
		}
		updateSendLog(currentDateTime);
	}

	// ======================================================================
	private static String getLastSendDateTime() {
		String dateTime = null;

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PARAM1, PARAM2 ");
		sqlStr.append("FROM SYSPARAM@hat ");
		sqlStr.append("WHERE PARCDE = ?");

		// logger.debug("[NotifyEHRAlertThread] getExceptionRecords
		// sql="+sqlStr.toString());
		ArrayList<ReportableListObject> list = UtilDBWeb.getReportableListCIS(sqlStr.toString(),
				new String[] { EHR_DATE_UPLOAD_ALERT_CODE });
		if (list != null && !list.isEmpty()) {
			ReportableListObject row = list.get(0);
			dateTime = row.getFields0();
		}
		// logger.debug("[NotifyEHRAlertThread] getLastSendDateTime
		// dateTime="+dateTime);
		return dateTime;
	}

	private static ArrayList getBatchRecords(String lastSendDateTime, String mode) {
		// logger.debug("[NotifyEHRAlertThread] getBatchRecords
		// lastSendDateTime="+lastSendDateTime+", mode="+mode);

		String statusStr = null;
		boolean allStatus = false;
		if ("ehr.laam.ex".equals(mode)) {
			statusStr = "'F', 'X'";
		} else if ("ehr.laam.err".equals(mode)) {
			statusStr = "'E'";
		} else if ("ehr.laam.pend".equals(mode)) {
			statusStr = "'P'";
		} else if ("ehr.laam.proc".equals(mode)) {
			statusStr = "'U', 'I'";
		} else {
			// all
			allStatus = true;
		}

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DATA_DOMAIN, CREATE_DATETIME, RECEIVING_DATETIME, BATCH_ID, MESSAGE_CONTROL_ID, ");
		sqlStr.append("       UPLOAD_MODE, BATCH_STATUS, STATUS_DESCRIPTION, PARTIAL_STATUS ");
		sqlStr.append("FROM   LAAM_BATCH_STATUS_VIEW@ehr ");
		sqlStr.append("where  create_datetime > TO_TIMESTAMP('" + lastSendDateTime + "', '"
				+ EHR_DATE_UPLOAD_ALERT_FORMAT_DB + "') ");
		if (!allStatus) {
			sqlStr.append("and    batch_status in (" + statusStr + ") ");
		}
		sqlStr.append("order by CREATE_DATETIME desc");

		// logger.debug("[NotifyEHRAlertThread] getBatchRecords sql=
		// "+sqlStr.toString());
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	private static ArrayList getExceptionRecords(String batchIDs) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DATA_DOMAIN,           ");
		sqlStr.append("  BATCH_ID,                   ");
		sqlStr.append("  MESSAGE_CONTROL_ID,         ");
		sqlStr.append("  UPLOAD_FILE_NAME,           ");
		sqlStr.append("  EXCEPTION_CATEGORY,         ");
		sqlStr.append("  ERROR_CODE,                 ");
		sqlStr.append("  ERROR_DESCRIPTION,          ");
		sqlStr.append("  RECORD_KEY,                 ");
		sqlStr.append("  EHR_NO,                     ");
		sqlStr.append("  DATA_FIELD                  ");
		sqlStr.append("FROM LAAM_BATCH_EXCEPTION_VIEW@ehr ");
		sqlStr.append("WHERE BATCH_ID IN (" + batchIDs + ") ");
		sqlStr.append("ORDER BY BATCH_ID DESC 		 ");

		// logger.debug("[NotifyEHRAlertThread] getExceptionRecords
		// sql="+sqlStr.toString());
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	private static void updateSendLog(String sendDateTime) {
		// logger.debug("[testEhrAlert] updateSendLog sendDateTime=" + sendDateTime);
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM SYSPARAM@hat ");
		sqlStr.append("WHERE ");
		sqlStr.append("PARCDE = ?");
		if (!UtilDBWeb.isExistCIS(sqlStr.toString(), new String[] { EHR_DATE_UPLOAD_ALERT_CODE })) {
			sqlStr.setLength(0);
			sqlStr.append("INSERT INTO SYSPARAM@hat ");
			sqlStr.append("(PARCDE, PARAM1, PARAM2, PARDESC) ");
			sqlStr.append("VALUES ");
			sqlStr.append("(?, ?, ?, ?)");

			boolean ret = UtilDBWeb.updateQueueCIS(sqlStr.toString(), new String[] { EHR_DATE_UPLOAD_ALERT_CODE,
					sendDateTime, EHR_DATE_UPLOAD_ALERT_FORMAT_DB, "Last data upload log sent" });
			if (ret) {
				logger.debug(" insert " + EHR_DATE_UPLOAD_ALERT_CODE + " success");
			} else {
				logger.debug(" insert " + EHR_DATE_UPLOAD_ALERT_CODE + " fail");
			}
		} else {
			sqlStr.setLength(0);
			sqlStr.append("UPDATE SYSPARAM@hat ");
			sqlStr.append("SET PARAM1 = ? ");
			sqlStr.append("WHERE ");
			sqlStr.append("PARCDE = ?");

			boolean ret = UtilDBWeb.updateQueueCIS(sqlStr.toString(),
					new String[] { sendDateTime, EHR_DATE_UPLOAD_ALERT_CODE });
			if (ret) {
				logger.debug(" update " + EHR_DATE_UPLOAD_ALERT_CODE + " success");
			} else {
				logger.debug(" update " + EHR_DATE_UPLOAD_ALERT_CODE + " fail");
			}
		}
	}
}