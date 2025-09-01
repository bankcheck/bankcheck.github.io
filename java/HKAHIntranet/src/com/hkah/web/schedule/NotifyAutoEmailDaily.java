package com.hkah.web.schedule;

import java.util.ArrayList;
import java.util.Calendar;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

import com.hkah.util.DateTimeUtil;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;

public class NotifyAutoEmailDaily implements Job {

	//======================================================================
	private static Logger logger = Logger.getLogger(NotifyAutoEmailDaily.class);
	private static String sqlStr_getSchedule = null;
	private static String ZERO_TAG = "{0}";
	private static String ONE_TAG = "{1}";

	@Override
	public void execute(JobExecutionContext arg0) {
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr_getSchedule);
		ReportableListObject row = null;
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			doActionHelper(row.getFields0(), row.getFields1(), row.getFields2(), row.getFields3(), row.getFields4(), row.getFields5(), row.getFields6(), row.getFields7(), row.getFields8(), row.getFields9());
		}
	}

	//======================================================================
	private static String doTableHelper(ReportableListObject row, int rowcount) {
		return doTableHelper(row, rowcount, 0);
	}

	private static String doTableHelper(ReportableListObject row, int rowcount, int startFrom) {
		StringBuffer outStr = new StringBuffer();
		if (row != null) {
			outStr.append("<tr>");
			outStr.append("<td>");
			outStr.append(rowcount);
			outStr.append("</td>");
			for (int i = startFrom; i < row.getSize(); i++) {
				outStr.append("<td>");
				outStr.append(row.getValue(i));
				outStr.append("</td>");
			}
			outStr.append("</tr>");
		}
		return outStr.toString();
	}

	// ======================================================================
	public static void doActionHelper(String alertID, String sqlStr, String tableHeader, String emailHeader, String emailContent, String remark, String showTable, String emailToSqlStr, String groupByContent, String postContent) {
		ArrayList<ReportableListObject> record = null;
		ArrayList<ReportableListObject> record2 = null;
		ReportableListObject row = null;
		String newSqlStr = null;
		String newEmailHeader = null;
		String newEmailContent = null;

		if (emailToSqlStr != null && emailToSqlStr.length() > 0) {
			record2 = UtilDBWeb.getReportableList(emailToSqlStr);
			if (record2.size() > 0) {
				for (int i = 0; i < record2.size(); i++) {
					row = (ReportableListObject) record2.get(i);
					newSqlStr = sqlStr;
					while (newSqlStr.indexOf(ZERO_TAG) >= 0) {
						newSqlStr = TextUtil.replaceAll(newSqlStr, ZERO_TAG, row.getValue(0));
					}

					while (newSqlStr.indexOf(ONE_TAG) >= 0) {
						newSqlStr = TextUtil.replaceAll(newSqlStr, ONE_TAG, row.getValue(1));
					}

					record = UtilDBWeb.getReportableList(newSqlStr);
					if (record.size() > 0) {
						// replace email header with defined tag
						newEmailHeader = replaceTag(emailHeader);

						while (newEmailHeader.indexOf(ZERO_TAG) >= 0) {
							newEmailHeader = TextUtil.replaceAll(newEmailHeader, ZERO_TAG, row.getValue(0));
						}

						while (newEmailHeader.indexOf(ONE_TAG) >= 0) {
							newEmailHeader = TextUtil.replaceAll(newEmailHeader, ONE_TAG, row.getValue(1));
						}

						// replace email content with defined tag
						if (groupByContent != null && groupByContent.length() > 0) {
							newEmailContent = emailContentWithGroupContent(tableHeader, emailContent, remark, showTable, record, groupByContent);
						} else {
							newEmailContent = emailContent(tableHeader, emailContent, remark, showTable, record);
						}

						while (newEmailContent.indexOf(ZERO_TAG) >= 0) {
							newEmailContent = TextUtil.replaceAll(newEmailContent, ZERO_TAG, row.getValue(0));
						}

						while (newEmailContent.indexOf(ONE_TAG) >= 0) {
							newEmailContent = TextUtil.replaceAll(newEmailContent, ONE_TAG, row.getValue(1));
						}

						if (EmailAlertDB.sendEmail(
								alertID,
								newEmailHeader,
								newEmailContent,
								row.getValue(2))) {
							if (postContent != null && postContent.length() > 0) {
								UtilDBWeb.updateQueue(postContent);
							}
						}
					}
				}
			}
		} else {
			record = UtilDBWeb.getReportableList(sqlStr);
			if (record.size() > 0) {
				// replace email header with defined tag
				newEmailHeader = replaceTag(emailHeader);

				 if (EmailAlertDB.sendEmail(
						alertID,
						newEmailHeader,
						emailContent(tableHeader, emailContent, remark, showTable, record))) {
					 if (postContent != null && postContent.length() > 0) {
							UtilDBWeb.updateQueue(postContent);
						}
				 }
			}
		}
		logger.info("Thread NotifyAutoEmailDailyThread doAction finish");
	}

	private static String emailContent(String tableHeader, String emailContent, String remark, String showTable, ArrayList<ReportableListObject> record) {
		ReportableListObject row = null;
		StringBuffer message = new StringBuffer();

		// replace email content with defined tag
		String newEmailContent = replaceTag(emailContent);

		message.append(newEmailContent);
		if (!"N".equals(showTable)) {
			message.append("<br><table border=\"1\"><tr>");
			message.append("<td>#</td>");
			message.append(tableHeader);
			message.append("</tr>");
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				message.append(doTableHelper(row, i + 1));
			}
			message.append("</table>");
		}
		message.append("<br><br>");
		message.append(remark);

		return message.toString();
	}

	private static String emailContentWithGroupContent(String tableHeader, String emailContent, String remark, String showTable, ArrayList<ReportableListObject> record, String groupByContent) {
		ReportableListObject row = null;
		StringBuffer message = new StringBuffer();
		String groupByKey_stored = null;
		String groupByKey_curr = null;
		int count = 0;

		// replace email content with defined tag
		String newEmailContent = replaceTag(emailContent);

		message.append(newEmailContent);
		if (!"N".equals(showTable)) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				groupByKey_curr = row.getFields0();
				if (groupByKey_stored == null || !groupByKey_stored.equals(groupByKey_curr)) {
					groupByKey_stored = groupByKey_curr;
					count = 0;

					if (i > 0) {
						message.append("</table><br>");
					}

					message.append(TextUtil.replaceAll(groupByContent, ZERO_TAG, groupByKey_curr));
					message.append("<br><table border=\"1\"><tr>");
					message.append("<td>#</td>");
					message.append(tableHeader);
					message.append("</tr>");
				}
				count++;
				message.append(doTableHelper(row, count, 1));
			}
			message.append("</table><br>");
		}
		message.append("<br><br>");
		message.append(remark);

		return message.toString();
	}

	private static String replaceTag(String content) {
		String newContent = content;
		if (newContent != null) {
			newContent = TextUtil.replaceAll(newContent, "#DAY#", String.valueOf(DateTimeUtil.getCurrentDay()));
			newContent = TextUtil.replaceAll(newContent, "#MONTH#", String.valueOf(DateTimeUtil.getCurrentMonth()));
			newContent = TextUtil.replaceAll(newContent, "#YEAR#", String.valueOf(DateTimeUtil.getCurrentYear()));
			newContent = TextUtil.replaceAll(newContent, "#DAYBEFOREYESTERDAY#", String.valueOf(DateTimeUtil.getCurrentDate(-2)));
			newContent = TextUtil.replaceAll(newContent, "#YESTERDAY#", String.valueOf(DateTimeUtil.getCurrentDate(-1)));
			newContent = TextUtil.replaceAll(newContent, "#TODAY#", String.valueOf(DateTimeUtil.getCurrentDate()));
			newContent = TextUtil.replaceAll(newContent, "#TOMORROW#", String.valueOf(DateTimeUtil.getCurrentDate(1)));
			newContent = TextUtil.replaceAll(newContent, "#DAYAFTERTOMORROW#", String.valueOf(DateTimeUtil.getCurrentDate(2)));
			
			Calendar lastMonth =  Calendar.getInstance();
			lastMonth.add(Calendar.MONTH, -1);
			newContent = TextUtil.replaceAll(newContent, "#LASTMONTH#", String.valueOf(DateTimeUtil.getCurrentMonthDescription(lastMonth.getTime())));
			newContent = TextUtil.replaceAll(newContent, "#LASTMONTHYEAR#", String.valueOf(DateTimeUtil.getCurrentYear(lastMonth.getTime())));
		}
		return newContent;
	}

	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_ALERT_ID, CO_CRITERIA_SQL, CO_TABLE_HEADER, CO_EMAIL_HEADER, CO_EMAIL_CONTENT, CO_REMARK, CO_SHOW_TABLE, CO_EMAILTO_SQL, CO_GROUPBY_CONTENT, CO_PROEXEC_SQL ");
		sqlStr.append("FROM   CO_AUTO_EMAIL_DAILY ");
		sqlStr.append("WHERE  CO_ENABLED = '1' ");
		sqlStr.append("AND    CO_START_HOUR <= TO_CHAR(SYSDATE, 'HH24') ");
		sqlStr.append("AND    CO_END_HOUR >= TO_CHAR(SYSDATE, 'HH24') ");
		sqlStr.append("ORDER BY CO_AUTO_EMAIL_ID ");
		sqlStr_getSchedule = sqlStr.toString();
	}
}