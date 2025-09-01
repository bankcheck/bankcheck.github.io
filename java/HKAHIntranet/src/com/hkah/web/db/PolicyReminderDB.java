package com.hkah.web.db;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class PolicyReminderDB {
	private static final String contentUrlFrom = "\"/upload/";
	private static final String contentUrlTo = "\"https://" + ConstantsServerSide.OFFSITE_URL + "/upload/";
	private static final String WEBMASTER_EMAIL = ConstantsServerSide.MAIL_ALERT;
	private static final int DEFAULT_COLUMN_LENGTH = 1000;

	private static String sqlStr_insertPolicyReminder = null;
	private static String sqlStr_updatePolicyReminder = null;
	private static String sqlStr_deletePolicyReminder = null;
	private static String sqlStr_getPolicyReminder = null;
	private static String sqlStr_getPolicyReminderExceptPoster = null;
	private static String sqlStr_getPolicyReminderContent = null;

	private static String sqlStr_updatePolicyReminder_Enabled = null;
	public static Map<String, String> categories = new HashMap<String, String>();
	public static Map<String, String> senders = new HashMap<String, String>();

	private static String getNextPolicyReminderID() {
		String policyreminderID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(PIPRID) + 1 FROM PI_POLICY_REMINDER");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			policyreminderID = reportableListObject.getValue(0);

			// set 1 for initial
			if (policyreminderID == null || policyreminderID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return policyreminderID;
	}

	/**
	 * Add a policyreminder
	 */
	public static String add(UserBean userBean) {

		// get next schedule ID
		String prID = getNextPolicyReminderID();

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertPolicyReminder,
				new String[] { prID, userBean.getLoginID(), userBean.getLoginID() })) {
			return prID;
		} else {
			return null;
		}

	}

	/**
	 * Modify a policyreminder
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean, String prID, String prNo, String prPNAME, String prOWNER, String prEmail, String pr_TO_BE_REVIEWED_DATE, String pr_SUGGESTED_REFERENCE ) {

		// try to update selected record
		if (UtilDBWeb.updateQueue(
				sqlStr_updatePolicyReminder,
				new String[] {
						prNo, prPNAME, prOWNER, prEmail, pr_TO_BE_REVIEWED_DATE, pr_SUGGESTED_REFERENCE, prID })) {

			// delete existing content
//			deleteContent(userBean, policyreminderID, policyreminderCategory);

			// set content
//			addContent(userBean, policyreminderID, policyreminderCategory, processContent(content));

			/*if ("poster".equals(prID)) {
				PolicyReminderDB.updateEnabled(prID, "0");
			}*/
			return true;
		} else {
			return false;
		}
	}


	/**
	 * delete policyreminder
	 */
	public static boolean delete(UserBean userBean,
			String policyreminderID) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deletePolicyReminder,
				new String[] { userBean.getLoginID(), policyreminderID });
	}

	/**
	 * Add a policyreminder
	 */
/*
	private static void addContent(UserBean userBean,
			String policyreminderID, String policyreminderCategory, String[] contents) {

		// try to insert a new record
		for (int i = 0; i < contents.length; i++) {
			UtilDBWeb.updateQueue(
				sqlStr_insertPolicyReminderContent,
				new String[] { policyreminderID, policyreminderCategory, String.valueOf(i + 1),
						contents[i], userBean.getLoginID(), userBean.getLoginID() });
		}
	}
*/

	/**
	 * delete policyreminder content
	 * @return whether it is successful to update the record
	 */
/*
	private static boolean deleteContent(UserBean userBean,
			String policyreminderID, String policyreminderCategory) {

		// try to delete content
		return UtilDBWeb.updateQueue(
				sqlStr_deletePolicyReminderContent,
				new String[] {
						policyreminderID, policyreminderCategory });
	}
*/
/*
	public static ArrayList getList(UserBean userBean, String policyreminderCategory, int noOfMaxRecord) {
		return getList(userBean, policyreminderCategory, null, null, null, 0, noOfMaxRecord, 0,1);
	}

	public static ArrayList getList(UserBean userBean, String policyreminderCategory, String policyreminderType, int noOfMaxRecord) {
		return getList(userBean, policyreminderCategory, policyreminderType, null, null, 0, noOfMaxRecord, 0,1);
	}

	public static ArrayList getList(UserBean userBean, String policyreminderCategory, String policyreminderType, String title, int noOfMaxRecord, int sortBy) {
		return getList(userBean, policyreminderCategory, policyreminderType, null, title, 0, noOfMaxRecord, sortBy,1);
	}

	public static ArrayList getList(UserBean userBean, String policyreminderCategory, String policyreminderType, String policyreminderTypeExcept, int activePolicyReminder, int noOfMaxRecord, int sortBy) {
		return getList(userBean, policyreminderCategory, policyreminderType, policyreminderTypeExcept, null, activePolicyReminder, noOfMaxRecord, sortBy,1);
	}

	public static ArrayList getList(UserBean userBean, String policyreminderCategory, String policyreminderType, String policyreminderTypeExcept, String title, int activePolicyReminder, int noOfMaxRecord, int sortBy) {
		return getList(userBean, policyreminderCategory, policyreminderType, policyreminderTypeExcept, title, activePolicyReminder, noOfMaxRecord, sortBy,1);
	}
*/
	public static ArrayList getTopPolicyReminderList(UserBean userBean) {
		return getPolicyReminderList(userBean, 1);
	}

	public static ArrayList getTopPolicyReminderList(UserBean userBean, String mode) {
		return getPolicyReminderList(userBean, 1);
	}

	public static ArrayList getPopularPolicyReminderList(UserBean userBean) {
		return getPolicyReminderList(userBean, 1);
	}
/*
	public static String[] getPolicyReminderID(String policyreminderCategory, String policyreminderType) {
		// fetch policyreminder list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT MAX(PIPRID) ");
		sqlStr.append("FROM   PI_POLICY_REMINDER ");
		sqlStr.append("WHERE  PIPR_ENABLED = 1 ");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return new String[] { row.getValue(0), row.getValue(1) };
		}
		return null;
	}
*/
	public static ArrayList getPolicyReminderList(UserBean userBean, int sortBy) {
		// fetch policyreminder list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT P.PIPRID, ");
		sqlStr.append("       P.PIPR_NO, ");
		sqlStr.append("       P.PIPR_PNAME, P.PIPR_OWNER, ");
		sqlStr.append("       P.PIPR_EMAIL, ");
		sqlStr.append("       TO_CHAR(P.PIPR_TO_BE_REVIEWED_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       P.PIPR_SUGGESTED_REFERENCE, ");
		sqlStr.append("       TO_CHAR(P.PIPR_CREATED_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       P.PIPR_CREATED_USER, ");
		sqlStr.append("       TO_CHAR(P.PIPR_MODIFIED_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       P.PIPR_MODIFIED_USER, ");
		sqlStr.append("       P.PIPR_ENABLED ");
		sqlStr.append("FROM   PI_POLICY_REMINDER P ");
		sqlStr.append("WHERE  P.PIPR_ENABLED = 1 ");

		if (sortBy == 0) {
			sqlStr.append("ORDER BY P.PIPR_CREATED_DATE DESC");
		}
		if (sortBy == 2) {
			sqlStr.append("ORDER BY P.PIPR_TO_BE_REVIEWED_DATE DESC");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString(), 30);
	}

	public static ArrayList getList(UserBean userBean, String prNo, String prName, int sortBy) {
		// fetch list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT P.PIPRID, ");
		sqlStr.append("       P.PIPR_NO, ");
		sqlStr.append("       P.PIPR_PNAME, P.PIPR_OWNER, ");
		sqlStr.append("       P.PIPR_EMAIL, ");
		sqlStr.append("       TO_CHAR(P.PIPR_TO_BE_REVIEWED_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       P.PIPR_SUGGESTED_REFERENCE, ");
		sqlStr.append("       TO_CHAR(P.PIPR_CREATED_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       P.PIPR_CREATED_USER, ");
		sqlStr.append("       TO_CHAR(P.PIPR_MODIFIED_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       P.PIPR_MODIFIED_USER, ");
		sqlStr.append("       P.PIPR_ENABLED ");
		sqlStr.append("FROM   PI_POLICY_REMINDER P ");
		sqlStr.append("WHERE  P.PIPR_ENABLED = 1 ");

		if (prNo != null && prNo.length() > 0) {
			sqlStr.append("AND    lower(P.PIPR_NO) like lower('%");
			sqlStr.append(prNo);
			sqlStr.append("%') ");
		}

		if (prName != null && prName.length() > 0) {
			sqlStr.append("AND    lower(P.PIPR_PNAME) like lower('%");
			sqlStr.append(prName);
			sqlStr.append("%') ");
		}

		if (sortBy == 1) {
			sqlStr.append("ORDER BY P.PIPR_TO_BE_REVIEWED_DATE ASC");
		} else if (sortBy == 2) {
			sqlStr.append("ORDER BY P.PIPR_TO_BE_REVIEWED_DATE DESC");
		} else {
			sqlStr.append("ORDER BY P.PIPRID ASC");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

/*
	public static ArrayList getList(UserBean userBean, String policyreminderCategory, String policyreminderType, String policyreminderTypeExcept, String title, int activePolicyReminder, int noOfMaxRecord, int sortBy, int enableValue) {
		// fetch leave
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT N.PIPRID, N.PI_POLICY_REMINDER_CATEGORY, N.PI_POLICY_REMINDER_TYPE, ");
		sqlStr.append("       N.PI_TITLE, N.PI_TITLE_URL, N.PI_TITLE_IMAGE, ");
		sqlStr.append("       TO_CHAR(N.PIPR_POST_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       TO_CHAR(N.PI_EXPIRE_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       TO_CHAR(N.PI_EVENT_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       C1.PI_CONTENT, C2.PI_CONTENT, C3.PI_CONTENT, C4.PI_CONTENT, C5.PI_CONTENT, ");
		sqlStr.append("       C6.PI_CONTENT, C7.PI_CONTENT, C8.PI_CONTENT, C9.PI_CONTENT, N.PI_HIT_RATE, ");
		sqlStr.append("       N.PI_LIKED, L.PIPR_ENABLED, ");
		sqlStr.append("       N.PI_POLICY_REMINDER_SENDER, decode(PI_POST_HOMEPAGE, 1, 'Posted', 'Not yet posted'), ");
		//sqlStr.append("       N.PI_POLICY_REMINDER_SENDER, decode(co_expire_date, null, 'Posted', 'Not yet posted'), ");
		sqlStr.append("       FN_PI_POLICY_REMINDER_CONTENT(N.PIPRID) ");
		sqlStr.append("FROM   PI_POLICY_REMINDER N ");
		sqlStr.append("       LEFT JOIN PI_POLICY_REMINDER_CONTENT C1 ON N.PIPRID = C1.PIPRID AND N.PI_POLICY_REMINDER_CATEGORY = C1.PI_POLICY_REMINDER_CATEGORY AND C1.PI_POLICY_REMINDER_CONTENT_ID = 1 ");
		sqlStr.append("       LEFT JOIN PI_POLICY_REMINDER_CONTENT C2 ON N.PIPRID = C2.PIPRID AND N.PI_POLICY_REMINDER_CATEGORY = C2.PI_POLICY_REMINDER_CATEGORY AND C2.PI_POLICY_REMINDER_CONTENT_ID = 2 ");
		sqlStr.append("       LEFT JOIN PI_POLICY_REMINDER_CONTENT C3 ON N.PIPRID = C3.PIPRID AND N.PI_POLICY_REMINDER_CATEGORY = C3.PI_POLICY_REMINDER_CATEGORY AND C3.PI_POLICY_REMINDER_CONTENT_ID = 3 ");
		sqlStr.append("       LEFT JOIN PI_POLICY_REMINDER_CONTENT C4 ON N.PIPRID = C4.PIPRID AND N.PI_POLICY_REMINDER_CATEGORY = C4.PI_POLICY_REMINDER_CATEGORY AND C4.PI_POLICY_REMINDER_CONTENT_ID = 4 ");
		sqlStr.append("       LEFT JOIN PI_POLICY_REMINDER_CONTENT C5 ON N.PIPRID = C5.PIPRID AND N.PI_POLICY_REMINDER_CATEGORY = C5.PI_POLICY_REMINDER_CATEGORY AND C5.PI_POLICY_REMINDER_CONTENT_ID = 5 ");
		sqlStr.append("       LEFT JOIN PI_POLICY_REMINDER_CONTENT C6 ON N.PIPRID = C6.PIPRID AND N.PI_POLICY_REMINDER_CATEGORY = C6.PI_POLICY_REMINDER_CATEGORY AND C6.PI_POLICY_REMINDER_CONTENT_ID = 6 ");
		sqlStr.append("       LEFT JOIN PI_POLICY_REMINDER_CONTENT C7 ON N.PIPRID = C7.PIPRID AND N.PI_POLICY_REMINDER_CATEGORY = C7.PI_POLICY_REMINDER_CATEGORY AND C7.PI_POLICY_REMINDER_CONTENT_ID = 7 ");
		sqlStr.append("       LEFT JOIN PI_POLICY_REMINDER_CONTENT C8 ON N.PIPRID = C8.PIPRID AND N.PI_POLICY_REMINDER_CATEGORY = C8.PI_POLICY_REMINDER_CATEGORY AND C8.PI_POLICY_REMINDER_CONTENT_ID = 8 ");
		sqlStr.append("       LEFT JOIN PI_POLICY_REMINDER_CONTENT C9 ON N.PIPRID = C9.PIPRID AND N.PI_POLICY_REMINDER_CATEGORY = C9.PI_POLICY_REMINDER_CATEGORY AND C9.PI_POLICY_REMINDER_CONTENT_ID = 9 ");
		sqlStr.append("       LEFT JOIN PI_POLICY_REMINDER_LIKE L ON N.PIPRID = L.PIPRID AND N.PI_POLICY_REMINDER_CATEGORY = L.PI_POLICY_REMINDER_CATEGORY AND L.PI_STAFF_ID = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("' ");
		sqlStr.append("WHERE  N.PIPR_ENABLED = '");
		sqlStr.append(enableValue);
		sqlStr.append("' ");
		if (policyreminderCategory != null && policyreminderCategory.length() > 0) {
			sqlStr.append("AND    N.PI_POLICY_REMINDER_CATEGORY = '");
			sqlStr.append(policyreminderCategory);
			sqlStr.append("' ");
		}
		if (policyreminderType != null && policyreminderType.length() > 0) {
			sqlStr.append("AND    N.PI_POLICY_REMINDER_TYPE LIKE '%");
			sqlStr.append(policyreminderType);
			sqlStr.append("%' ");
		}
		if (policyreminderTypeExcept != null && policyreminderTypeExcept.length() > 0) {
			sqlStr.append("AND    N.PI_POLICY_REMINDER_TYPE != '");
			sqlStr.append(policyreminderTypeExcept);
			sqlStr.append("' ");
		}
		if (title != null && title.length() > 0) {
			title = title.toUpperCase();
			sqlStr.append("AND    UPPER(N.PI_TITLE) LIKE '%");
			sqlStr.append(title);
			sqlStr.append("%' ");
		}
		if (activePolicyReminder == 1) {
			sqlStr.append("AND    N.PIPR_POST_DATE <= SYSDATE ");
			sqlStr.append("AND    (N.PI_EXPIRE_DATE IS NULL OR N.PI_EXPIRE_DATE >= SYSDATE) ");
		}
		if (sortBy == 1) {
			sqlStr.append("ORDER BY N.PI_POLICY_REMINDER_CATEGORY, N.PI_POLICY_REMINDER_TYPE, N.PIPR_POST_DATE DESC, N.PI_TITLE");
		} else if (sortBy == 2) {
			sqlStr.append("order by n.co_expire_date desc NULLS FIRST, N.PI_POLICY_REMINDER_CATEGORY, N.PI_POLICY_REMINDER_TYPE, N.PI_TITLE");
		} else {
			sqlStr.append("ORDER BY N.PIPR_POST_DATE DESC, N.PI_POLICY_REMINDER_CATEGORY, N.PI_POLICY_REMINDER_TYPE, N.PI_TITLE");
		}
		//System.out.println(sqlStr.toString());
		if (noOfMaxRecord > 0) {
			return UtilDBWeb.getReportableList(sqlStr.toString(), noOfMaxRecord);
		} else {
			return UtilDBWeb.getReportableList(sqlStr.toString());
		}
	}
*/

	public static ArrayList get(UserBean userBean, String policyreminderID) {
		return get(userBean, policyreminderID, "1");
	}

	public static ArrayList get(UserBean userBean, String policyreminderID, String enabled) {
		// fetch policyreminder
		//return UtilDBWeb.getReportableList(sqlStr_getPolicyReminder, new String[] { userBean.getStaffID(), enabled, policyreminderID });
		return UtilDBWeb.getReportableList(sqlStr_getPolicyReminder, new String[] { enabled, policyreminderID });
	}

	public static ArrayList getPolicyReminderExceptPoster(UserBean userBean, String policyreminderID) {
		// fetch policyreminder
		return UtilDBWeb.getReportableList(sqlStr_getPolicyReminderExceptPoster, new String[] { userBean.getStaffID(), policyreminderID });
	}

	public static ArrayList getContent(String policyreminderID) {
		// fetch policyreminder
		return UtilDBWeb.getReportableList(sqlStr_getPolicyReminderContent, new String[] { policyreminderID });
	}

	public static void updateEnabled (String policyreminderID,String enabled) {
		UtilDBWeb.updateQueue(sqlStr_updatePolicyReminder_Enabled, new String[] { enabled,policyreminderID });
	}

	private static String[] processContent(String content) {
		if (content != null) {
			return TextUtil.split(content, DEFAULT_COLUMN_LENGTH);
		} else {
			return null;
		}
	}

/*
	private static void sendEmail(String policyreminderID, String fromStaffID,
			String policyreminderCategory, String policyreminderType, String policyreminderTitle, String policyreminderTitleImage, String content,
			boolean emailNotifyFromSelf, String emailNotifyToAll, boolean emailNotifyToSelf, boolean emailExclude) {
		String emailSelf = UserDB.getUserEmail(null, fromStaffID);
		// default value
		String emailFrom = WEBMASTER_EMAIL;
		if (emailNotifyFromSelf) {
			if (emailExclude) {
				emailFrom = "terrence.leung@hkah.org.hk";
			} else if (emailSelf != null && emailSelf.length() > 0) {
				emailFrom = emailSelf;
			}
		}

		// append url
		StringBuffer commentStr = new StringBuffer();
		if (policyreminderTitleImage != null && policyreminderTitleImage.length() > 0) {
			commentStr.append("<img src=\"https://");
			commentStr.append(ConstantsServerSide.OFFSITE_URL);
			commentStr.append("/upload/");
			commentStr.append(policyreminderCategory);
			commentStr.append("/");
			commentStr.append(policyreminderID);
			commentStr.append("/");
			commentStr.append(policyreminderTitleImage);
			commentStr.append("\" />");
			commentStr.append("<br />");
		}
		commentStr.append(contentParser(content));
		commentStr.append("<br />");
		commentStr.append("Please click <a href=\"http://");
		commentStr.append(ConstantsServerSide.INTRANET_URL);
		commentStr.append("/intranet/portal/policyreminder_view.jsp?policyreminderID=");
		commentStr.append(policyreminderID);
		commentStr.append("&policyreminderCategory=");
		commentStr.append(policyreminderCategory);
		commentStr.append("\">Intranet</a> or <a href=\"https://");
		commentStr.append(ConstantsServerSide.OFFSITE_URL);
		commentStr.append("/intranet/portal/policyreminder_view.jsp?policyreminderID=");
		commentStr.append(policyreminderID);
		commentStr.append("&policyreminderCategory=");
		commentStr.append(policyreminderCategory);
		commentStr.append("\">Offsite</a> to view the detail.");

		// send email
		if ("poster".equals(policyreminderCategory)) {
			UtilMail.sendMail(
					emailFrom,new String[] { "terrence.leung@hkah.org.hk","chongki.hung@hkah.org.hk",emailFrom },
					null,null, policyreminderTitle+" (Apply for approval(by MKT)) ", commentStr.toString());
			emailNotifyToAll = "N";
			emailNotifyToSelf = true;
			emailSelf = "";
		}
		if (ConstantsVariable.YES_VALUE.equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, ConstantsServerSide.MAIL_ALLSTAFF, policyreminderTitle, commentStr.toString());
		}
		if (emailNotifyToSelf && emailSelf != null && emailSelf.length() > 0) {
			UtilMail.sendMail(emailFrom, emailSelf, policyreminderTitle, commentStr.toString());
		}
		if ("unitManager".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "unitm@hkah.org.hk", policyreminderTitle, commentStr.toString());
		} else if ("adminDept".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "admindept@hkah.org.hk", policyreminderTitle, commentStr.toString());
		} else if ("ancillaryDept".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "ancillarydept@hkah.org.hk", policyreminderTitle, commentStr.toString());
		} else if ("nursingUnit".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "nursingunit@hkah.org.hk", policyreminderTitle, commentStr.toString());
		} else if ("supportDept".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "supportdept@hkah.org.hk", policyreminderTitle, commentStr.toString());
		} else if ("serviceUnit".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "serviceunit@hkah.org.hk", policyreminderTitle, commentStr.toString());
		} else if ("ammed".equals(emailNotifyToAll)) {
			UtilMail.sendMail(emailFrom, "ammedcenter@hkah.org.hk", policyreminderTitle, commentStr.toString());
		}
	}
*/

/*
	public static String getRenovationClass(String status) {
		if ("status1".equals(status)) {
			return "Completed";
		} else if ("status2".equals(status)) {
			return "To be Completed";
		} else if ("status3".equals(status)) {
			return "To Commence";
		} else if ("status4".equals(status)) {
			return "Delay";
		}
		return "";
	}
*/
	private static String contentParser(String content) {
		return TextUtil.replaceAll(content, contentUrlFrom, contentUrlTo);
	}


	// tested ok
	static {
		StringBuffer sqlStr = new StringBuffer();
		//sqlStr.append("INSERT INTO PI_POLICY_REMINDER (PIPRID, PIPR_SUGGESTED_REFERENCE, PIPR_OWNER, PIPR_CREATED_USER, PIPR_MODIFIED_USER) VALUES (?, ?, ?, ?, ?) ");
		//sqlStr.append("INSERT INTO PI_POLICY_REMINDER (PIPRID, PIPR_SUGGESTED_REFERENCE, PIPR_OWNER, PIPR_CREATED_DATE, PIPR_CREATED_USER, PIPR_MODIFIED_DATE, PIPR_MODIFIED_USER) VALUES (?, ?, ?, SYSDATE, ?, SYSDATE, ?) ");
		sqlStr.append("INSERT INTO PI_POLICY_REMINDER (PIPRID, PIPR_CREATED_DATE, PIPR_CREATED_USER, PIPR_MODIFIED_DATE, PIPR_MODIFIED_USER) VALUES (?, SYSDATE, ?, SYSDATE, ?) ");
		sqlStr_insertPolicyReminder = sqlStr.toString();

/*
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO PI_POLICY_REMINDER ");
		sqlStr.append("(PIPRID, ");
		sqlStr.append("PIPR_CREATED_DATE, ");
		sqlStr.append("PIPR_CREATED_USER, ");
		sqlStr.append("PIPR_MODIFIED_DATE, ");
		sqlStr.append("PIPR_MODIFIED_USER, ");
		sqlStr.append("PIPR_ENABLED) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ");
		sqlStr.append("SYSDATE, ");
		sqlStr.append("?, ");
		sqlStr.append("SYSDATE, ");
		sqlStr.append("?, ");
		sqlStr.append("1)");
		sqlStr_insertPolicyReminder = sqlStr.toString();
*/

// previous one
/*	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO PI_POLICY_REMINDER ");
		sqlStr.append("(PIPRID, ");
		sqlStr.append("PIPR_PNAME, PIPR_OWNER, ");
		sqlStr.append("PIPR_TO_BE_REVIEWED_DATE, ");
		sqlStr.append("PIPR_SUGGESTED_REFERENCE, ");
		sqlStr.append("PIPR_POST_DATE, ");
		sqlStr.append("PIPR_CREATED_DATE, ");
		sqlStr.append("PIPR_CREATED_USER, ");
		sqlStr.append("PIPR_MODIFIED_DATE, ");
		sqlStr.append("PIPR_MODIFIED_USER, ");
		sqlStr.append("PIPR_ENABLED) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ");
		sqlStr.append("?, ");
		sqlStr.append("SYSDATE, ");
		sqlStr.append("?, ");
		sqlStr.append("SYSDATE, ");
		sqlStr.append("?, ");
		sqlStr.append("?)");
		sqlStr_insertPolicyReminder = sqlStr.toString();
*/

/*
PIPR_STATUS	NUMBER(2,0)	DEFAULT 0,
CREATE_DATE	DATE DEFAULT SYSDATE,
CREATE_USER	VARCHAR2(30) DEFAULT 'SYSTEM',
MODIFIED_DATE	DATE DEFAULT SYSDATE,
MODIFIED_USER	VARCHAR2(30) DEFAULT 'SYSTEM',
ENABLE	NUMBER(1,0)	DEFAULT 1,
 */

		sqlStr.setLength(0);
		sqlStr.append("UPDATE PI_POLICY_REMINDER ");
		sqlStr.append("SET    	PIPR_NO = ? ");
		sqlStr.append("			,PIPR_PNAME = ? ");
		sqlStr.append("			,PIPR_OWNER = ? ");
		sqlStr.append("			,PIPR_EMAIL = ? ");
		sqlStr.append("       	,PIPR_TO_BE_REVIEWED_DATE = TO_DATE(?, 'dd/MM/yyyy HH24:MI'), ");
		sqlStr.append("       	PIPR_SUGGESTED_REFERENCE = ? ");
		//sqlStr.append("       PI_MODIFIED_DATE = SYSDATE, PI_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  PIPRID = ? ");
		sqlStr.append("AND    PIPR_ENABLED = 1 ");
		sqlStr_updatePolicyReminder = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE PI_POLICY_REMINDER ");
		sqlStr.append("SET    PIPR_ENABLED = 0, PIPR_MODIFIED_DATE = SYSDATE, PIPR_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  PIPRID = ? ");
		sqlStr.append("AND    PIPR_ENABLED = 1 ");
		sqlStr_deletePolicyReminder = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT N.PIPRID, N.PIPR_NO, ");
		sqlStr.append("       N.PIPR_PNAME, ");
		sqlStr.append("       N.PIPR_OWNER, ");
		sqlStr.append("       N.PIPR_EMAIL, ");
		sqlStr.append("       TO_CHAR(N.PIPR_TO_BE_REVIEWED_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       N.PIPR_SUGGESTED_REFERENCE, ");
		sqlStr.append("       TO_CHAR(N.PIPR_CREATED_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       N.PIPR_CREATED_USER, ");
		sqlStr.append("       TO_CHAR(N.PIPR_MODIFIED_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       N.PIPR_MODIFIED_USER, PIPR_ENABLED ");
		sqlStr.append("FROM   PI_POLICY_REMINDER N ");
		sqlStr.append("WHERE  N.PIPR_ENABLED = ? ");
		sqlStr.append("AND    N.PIPRID = ? ");
		sqlStr_getPolicyReminder = sqlStr.toString();

/*		sqlStr.setLength(0);
		sqlStr.append("SELECT N.PIPRID, N.PI_POLICY_REMINDER_CATEGORY, N.PI_POLICY_REMINDER_TYPE, ");
		sqlStr.append("       N.PI_TITLE, N.PI_TITLE_URL, N.PI_TITLE_IMAGE, ");
		sqlStr.append("       TO_CHAR(N.PIPR_POST_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       TO_CHAR(N.PI_EXPIRE_DATE, 'dd/MM/YYYY HH24:MI'), ");
		sqlStr.append("       N.PI_HIT_RATE, N.PI_LIKED, N.PIPR_ENABLED, ");
		sqlStr.append("       N.PI_POLICY_REMINDER_SENDER ");
		sqlStr.append("FROM   PI_POLICY_REMINDER N ");
		sqlStr.append("       LEFT JOIN PI_POLICY_REMINDER_LIKE L ON N.PIPRID = L.PIPRID AND N.PI_POLICY_REMINDER_CATEGORY = L.PI_POLICY_REMINDER_CATEGORY AND L.PI_STAFF_ID = ? ");
		sqlStr.append("WHERE  N.PIPR_ENABLED = 1 ");
		sqlStr.append("AND    N.PI_POLICY_REMINDER_CATEGORY = ? ");
		sqlStr.append("AND    N.PIPRID = ? ");
		sqlStr.append("AND    N.PI_POLICY_REMINDER_CATEGORY NOT IN 'poster' ");
		sqlStr_getPolicyReminderExceptPoster = sqlStr.toString();
*/

		sqlStr.setLength(0);
		sqlStr.append("UPDATE PI_POLICY_REMINDER ");
		sqlStr.append("SET    PIPR_ENABLED = ? ");
		sqlStr.append("WHERE  PIPRID = ? ");
		sqlStr_updatePolicyReminder_Enabled = sqlStr.toString();

/*
		categories.put("accreditation", "Accreditation");
		categories.put("chap", "Chaplaincy");
		categories.put("education", "Education");
		categories.put("executive order", "Executive Order");
		categories.put("physician", "Executive Order - Physician");
		categories.put("vpma", "Executive Order - VPMA");
		categories.put("hospital", "Hospital");
		categories.put("human resources", "Human Resources");
		categories.put("infection control", "Infection Control");
		categories.put("LMC", "LifeStyle Management Centre");
		categories.put("marketing", "Marketing");
		//categories.put("newsletter", "Newsletter");
		//categories.put("newstart", "NEWSTART Health Centre");
		categories.put("nursing", "Nursing");
		categories.put("osh", "OSH/EHS");
		categories.put("poster", "Poster");
		categories.put("pi", "Performance Improvement");
		categories.put("special sharing", "Special Sharing");
		categories.put("lmc.crm", "CRM");
		categories.put("pem", "PEM");
		categories.put("other", "Other");

		senders.put("from ceo", "from CEO");
		senders.put("from vice president for medical affairs", "from Vice President for Medical Affairs");
		senders.put("from vice president for administration", "from Vice President for Administration");
		senders.put("from medical program administrator", "from Medical Program Administrator");
		senders.put("from human resource director", "from Human Resource Director");
		senders.put("from nursing administrator", "from Nursing Administrator");
		senders.put("from vice president for physician services", "from Vice President for Physician Services");
		senders.put("from chief of medical staff", "from Chief of Medical Staff");
		*/
	}
}