package com.hkah.web.schedule;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

import org.quartz.Job;
import org.quartz.JobExecutionContext;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;

public class NotifyAutoEmail implements Job {

	//======================================================================
	private static String sqlStr_getEmailTask = null;
	private static String sqlStr_getEmailTaskList = null;

	private static String sqlStr_updateEmailTask = null;
	private static String sqlStr_updateEmailTaskList = null;
	private static String sqlStr_updateAllProcessingTask = null;

//	private static String TASK_NORMAL = "N";
	private static String TASK_SUCCESS = "S";
	private static String TASK_FAILURE = "F";

	private static String TASK_LIST_NORMAL = "N";
	private static String TASK_LIST_FINISH = "F";
//	private static String TASK_LIST_PROCESS = "P";

	private static String[] VARIABLE_NAME = new String[] { "PATNO", "RECV_NAME" };

	@Override
	public void execute(JobExecutionContext arg0) {
		ArrayList task = getTask();

		if (task.size() > 0) {
			updateAllProcessingTask();//UPDATE TASKS THAT ARE PROCESSING

			ReportableListObject taskRow = null;
			for (int i = 0; i < task.size(); i++) {
				taskRow = (ReportableListObject) task.get(i);

				String autoID = taskRow.getValue(1);
				String emailFrom = taskRow.getValue(5);
				int limit = Integer.parseInt(taskRow.getValue(3));
				String taskEmailCC = taskRow.getValue(7);
				String taskEmailBCC = taskRow.getValue(8);
				String subject = taskRow.getValue(9);
				String contentURL = taskRow.getValue(10);
				String replyTo = taskRow.getValue(6);
				String content = getContentHTML(contentURL);
				String emailFromName = taskRow.getValue(17);

				ArrayList taskList = getTaskList(autoID);

				if (taskList.size() > 0) {
					ReportableListObject taskListRow = null;
					int endIndex = (limit < taskList.size()?limit:taskList.size());

					for(int j = 0; j < endIndex; j++) {
						taskListRow = (ReportableListObject) taskList.get(j);

						String emailTo = taskListRow.getValue(3);
						String taskListEmailCC = taskListRow.getValue(4);
						String taskListEmailBCC = taskListRow.getValue(5);
						String autoListID = taskListRow.getValue(2);
						ArrayList emailCC = new ArrayList();
						ArrayList emailBCC = new ArrayList();
						String patNo = taskListRow.getValue(6);
						String recvName = taskListRow.getValue(9)+" "+taskListRow.getValue(8) +
												" " + taskListRow.getValue(7);

						HashMap varValue = new HashMap();
						varValue.put(VARIABLE_NAME[0], patNo);
						varValue.put(VARIABLE_NAME[1], recvName);

						if (!UtilMail.isValidEmailAddress(emailFrom)) {
							updateTaskList(autoID, autoListID, TASK_FAILURE,
											"Email(From) is invaild.");
						} else if (!UtilMail.isValidEmailAddress(emailTo)) {
							updateTaskList(autoID, autoListID, TASK_FAILURE,
											"Email(To) is invaild.");
						} else if (replyTo != null && replyTo.length() > 0 &&
								!UtilMail.isValidEmailAddress(replyTo)) {
							updateTaskList(autoID, autoListID, TASK_FAILURE,
											"Email(Reply To) is invaild.");
						} else {
							if (UtilMail.isValidEmailAddress(taskEmailCC)) {
								emailCC.add(taskEmailCC);
							}
							if (UtilMail.isValidEmailAddress(taskListEmailCC)) {
								emailCC.add(taskListEmailCC);
							}
							if (UtilMail.isValidEmailAddress(taskEmailBCC)) {
								emailBCC.add(taskEmailBCC);
							}
							if (UtilMail.isValidEmailAddress(taskListEmailBCC)) {
								emailBCC.add(taskListEmailBCC);
							}

							String[] ccArray = new String[emailCC.size()];
							for (int k = 0; k < emailCC.size(); k++) {
								ccArray[k] = (String) emailCC.get(k);
							}

							String[] bccArray = new String[emailBCC.size()];
							for (int k = 0; k < emailBCC.size(); k++) {
								bccArray[k] = (String) emailBCC.get(k);
							}

							try {
								boolean success =
									UtilMail.sendMail(
										emailFrom, new String[]{ emailTo },
										ccArray,
										bccArray,
										(replyTo.length()>0?new String[] { replyTo }:null),
										genSubject(subject, varValue),
										genContent(content, varValue),
										false, emailFromName);

								if (success) {
									updateTaskList(autoID, autoListID, TASK_SUCCESS, null);
								} else {
									updateTaskList(autoID, autoListID, TASK_FAILURE,
													"Failure to send email.");
								}
							} catch(Exception e) {
								updateTaskList(autoID, autoListID, TASK_FAILURE,
										e.getMessage()
										.substring(0, (e.getMessage().length()>1000?999:e.getMessage().length())));
							}
						}
					}
				}

				if (limit > taskList.size()) {
					updateTask(autoID, TASK_LIST_FINISH);
				} else {
					updateTask(autoID, TASK_LIST_NORMAL);
				}
			}
		}
	}

	// ======================================================================
	private static ArrayList getTask() {
		return  UtilDBWeb.getReportableList(sqlStr_getEmailTask,
							new String[]{ConstantsServerSide.SITE_CODE});
	}

	// ======================================================================
	private static ArrayList getTaskList(String autoID) {
		return  UtilDBWeb.getReportableList(sqlStr_getEmailTaskList,
							new String[]{ConstantsServerSide.SITE_CODE, autoID});
	}

	private static boolean updateTaskList(String autoID, String autoListID,
									String status, String errorMsg) {
		if (status.equals(TASK_FAILURE)) {
			UtilMail.insertEmailLog(null, autoListID, "AUTO_EMAIL", "EMAIL", false, errorMsg);
		} else if (status.equals(TASK_SUCCESS)) {
			UtilMail.insertEmailLog(null, autoListID, "AUTO_EMAIL", "EMAIL", true, errorMsg);
		}

		return UtilDBWeb.updateQueue(sqlStr_updateEmailTaskList,
					new String[] {status, "SYSTEM", autoID, autoListID,
							ConstantsServerSide.SITE_CODE});
	}

	// ======================================================================
	private static boolean updateTask(String autoID, String status) {
		return UtilDBWeb.updateQueue(sqlStr_updateEmailTask,
						new String[] {status, "SYSTEM", autoID,
								ConstantsServerSide.SITE_CODE});
	}

	// ======================================================================
	private static boolean updateAllProcessingTask() {
		return UtilDBWeb.updateQueue(sqlStr_updateAllProcessingTask,
				new String[] {"P", "SYSTEM", ConstantsServerSide.SITE_CODE});
	}

	// ======================================================================
	private static String genSubject(String oriSubject, HashMap varValue) {
		String subject = oriSubject;

		for (String vName : VARIABLE_NAME) {
			subject = replaceVar(vName, subject, varValue);
		}

		return subject;
	}

	// ======================================================================
	private static String genContent(String oriContent, HashMap varValue) {
		String content = oriContent;

		for (String vName : VARIABLE_NAME) {
			content = replaceVar(vName, content, varValue);
		}

		return content;
	}

	// ======================================================================
	private static String replaceVar(String vName, String str, HashMap varValue) {
		while(str.indexOf("["+vName+"]") > -1) {
			String firstPart = str.substring(0, str.indexOf("["+vName+"]"));
			String secondPart = str.substring(str.indexOf("["+vName+"]")+("["+vName+"]").length());

			str = firstPart + varValue.get(vName) +secondPart;
		}
		return str;
	}

	// ======================================================================
	private static String getContentHTML(String contentURL) {
		URL url;
		HttpURLConnection conn;
		BufferedReader rd;
		String line;
		String result = "";
		try {
			url = new URL(contentURL);
			conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Content-Type", "text/html; charset=UTF-8");
			rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF8"));
			while ((line = rd.readLine()) != null) {
				result += line;
			}
			rd.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_AUTO_EMAIL ");
		sqlStr.append("SET CO_STATUS = ?, MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("MODIFIED_USER = ? ");
		sqlStr.append("WHERE CO_SITE_CODE = ? ");
		sqlStr.append("AND   CO_STATUS = 'N' ");
		sqlStr.append("AND   ENABLE = '1' ");
		sqlStr.append("AND   CO_START_DATE <= SYSDATE ");
		sqlStr.append("AND   (SYSDATE - MODIFIED_DATE) * 24 * 60 > CO_TIME_GAP ");
		sqlStr_updateAllProcessingTask = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_AUTO_EMAIL ");
		sqlStr.append("SET CO_STATUS = ?, MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("MODIFIED_USER = ? ");
		sqlStr.append("WHERE CO_AUTO_ID = ? ");
		sqlStr.append("AND CO_SITE_CODE = ? ");
		sqlStr_updateEmailTask = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_AUTO_EMAIL_LIST ");
		sqlStr.append("SET CO_STATUS = ?, MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("MODIFIED_USER = ? ");
		sqlStr.append("WHERE CO_AUTO_ID = ? ");
		sqlStr.append("AND CO_AUTO_LIST_ID = ? ");
		sqlStr.append("AND CO_SITE_CODE = ? ");
		sqlStr_updateEmailTaskList = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_SITE_CODE, CO_AUTO_ID, ");
		sqlStr.append("TO_CHAR(CO_START_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("CO_RECV_NO_EACHTIME, CO_TIME_GAP, CO_EMAIL_FROM, ");
		sqlStr.append("CO_EMAIL_REPLYTO, CO_EMAIL_CC, CO_EMAIL_BCC, ");
		sqlStr.append("CO_EMAIL_SUBJECT, CO_EMAIL_CONTENT_URL, CO_STATUS, ");
		sqlStr.append("TO_CHAR(CREATE_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("CREATE_USER, TO_CHAR(MODIFIED_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("MODIFIED_USER, ENABLE, CO_EMAIL_FROM_NAME ");
		sqlStr.append("FROM  CO_AUTO_EMAIL ");
		sqlStr.append("WHERE CO_SITE_CODE = ? ");
		sqlStr.append("AND   CO_STATUS = 'N' ");
		sqlStr.append("AND   ENABLE = '1' ");
		sqlStr.append("AND   CO_START_DATE <= SYSDATE ");
		sqlStr.append("AND   (SYSDATE - MODIFIED_DATE) * 24 * 60 > CO_TIME_GAP ");
		sqlStr.append("ORDER BY CO_AUTO_ID ");
		sqlStr_getEmailTask = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_SITE_CODE, CO_AUTO_ID, CO_AUTO_LIST_ID, ");
		sqlStr.append("CO_EMAIL_TO, CO_EMAIL_CC, CO_EMAIL_BCC, CO_RECV_PATNO, ");
		sqlStr.append("CO_RECV_FIRSTNAME, CO_RECV_LASTNAME, CO_RECV_TITDESC, CO_STATUS, ");
		sqlStr.append("TO_CHAR(CREATE_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("CREATE_USER, TO_CHAR(MODIFIED_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("MODIFIED_USER, ENABLE ");
		sqlStr.append("FROM CO_AUTO_EMAIL_LIST ");
		sqlStr.append("WHERE CO_SITE_CODE = ? ");
		sqlStr.append("AND   CO_STATUS = 'N' ");
		sqlStr.append("AND   ENABLE = '1' ");
		sqlStr.append("AND   CO_AUTO_ID = ? ");
		sqlStr.append("ORDER BY CO_AUTO_LIST_ID ");
		sqlStr_getEmailTaskList = sqlStr.toString();
	}
}