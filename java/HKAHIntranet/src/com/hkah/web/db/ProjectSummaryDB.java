package com.hkah.web.db;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class ProjectSummaryDB {
	private static final int DEFAULT_COLUMN_LENGTH = 1000;

	private static String sqlStr_insertAction = null;
	private static String sqlStr_updateAction = null;
	private static String sqlStr_deleteAction = null;

	private static String sqlStr_insertCommentAction = null;
	private static String sqlStr_updateCommentAction = null;
	private static String sqlStr_deleteCommentAction = null;

	private static String sqlStr_updateCommentOnlyAction = null;
	private static String sqlStr_duplicateCommentAction = null;
	private static String sqlStr_getCommentAction = null;
	private static String sqlStr_getCommentHistoryListAction = null;

	private static String sqlStr_insertContactAction = null;
	private static String sqlStr_deleteContactAction = null;
	private static String sqlStr_disableContactAction = null;
	private static String sqlStr_duplicateContactAction = null;
	private static String sqlStr_getContactListAction = null;

	private static String sqlStr_insertContactHistoryAction = null;
	private static String sqlStr_getContactHistoryListAction = null;

	private static String sqlStr_insertCommentHistoryAction = null;

	private static String sqlStr_insertCommentLinkAction = null;
	private static String sqlStr_deleteCommentLinkAction = null;
	private static String sqlStr_getCommentLinkIDAction = null;
	private static String sqlStr_getCommentLinkListAction = null;

	private static String sqlStr_insertContentAction = null;
	private static String sqlStr_deleteCommentContent = null;
	private static String sqlStr_duplicateContentAction = null;
	private static String sqlStr_getContent = null;

	private static String getProjectID() {
		String projectID = null;

		// get next project id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(PMP_PROJECT_ID) + 1 FROM PMP_PROJECTS");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			projectID = reportableListObject.getValue(0);

			// set 1 for initial
			if (projectID == null || projectID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return projectID;
	}

	private static String getNextCommentID(String projectID) {
		String commentID = null;

		// get next comment id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(PMP_COMMENT_ID) + 1 FROM PMP_PROJECT_COMMENTS WHERE PMP_PROJECT_ID = ?",
				new String[] { projectID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			commentID = reportableListObject.getValue(0);

			// set 1 for initial
			if (commentID == null || commentID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return commentID;
	}

	private static String getNextCommentHistoryID(String projectID, String commentID) {
		String commentHistoryID = null;

		// get next comment history id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(PMP_COMMENT_HISTORY_ID) + 1 FROM PMP_PROJECT_COMMENTS WHERE PMP_PROJECT_ID = ? AND PMP_COMMENT_ID = ? ",
				new String[] { projectID, commentID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			commentHistoryID = reportableListObject.getValue(0);

			// set 1 for initial
			if (commentHistoryID == null || commentHistoryID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return commentHistoryID;
	}

	private static String getNextCommentLinkID() {
		String commentLinkID = null;

		// get next comment link id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(PMP_PROJECT_COMMENT_LINK_ID) + 1 FROM PMP_PROJECT_COMMENT_LINKS");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			commentLinkID = reportableListObject.getValue(0);

			// set 1 for initial
			if (commentLinkID == null || commentLinkID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return commentLinkID;
	}

	/**
	 * Add an action
	 */
	public static String add(UserBean userBean) {

		// get next action ID
		String projectID = getProjectID();

		String userType = null;
		String userID = userBean.getStaffID();
		if (userID != null && userID.length() > 0) {
			userType = "staff";
		} else {
			userType = "guest";
			userID = userBean.getUserName();
		}

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertAction,
				new String[] {
						projectID, userType, userID,
						userBean.getLoginID(), userBean.getLoginID() })) {
			return projectID;
		} else {
			return null;
		}
	}

	/**
	 * Modify an action
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String projectID,
			String description, String expectedDate, String actualDate,
			String approval, String budget, String status) {

		// try to update selected record
		if (UtilDBWeb.updateQueue(
				sqlStr_updateAction,
				new String[] {
						description, expectedDate, actualDate,
						approval, budget, status,
						userBean.getLoginID(), projectID})) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean delete(UserBean userBean,
			String projectID) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteAction,
				new String[] { userBean.getLoginID(), projectID } );
	}

	public static ArrayList get(String projectID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT P.PMP_PROJECT_DESC, ");
		sqlStr.append("       P.PMP_REQ_USER_TYPE, P.PMP_REQ_USER_ID, S.CO_STAFFNAME, ");
		sqlStr.append("       TO_CHAR(P.PMP_EXPECT_LAUNCH_DATE, 'DD/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(P.PMP_ACTUAL_LAUNCH_DATE, 'DD/MM/YYYY'), ");
		sqlStr.append("       P.PMP_APPROVAL_REMARKS, P.PMP_BUDEGET_REMARKS, P.PMP_STATUS, ");
		sqlStr.append("       TO_CHAR(P.PMP_MODIFIED_DATE, 'DD/MM/YYYY') ");
		sqlStr.append("FROM   PMP_PROJECTS P, CO_STAFFS S ");
		sqlStr.append("WHERE  P.PMP_REQ_USER_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    P.PMP_ENABLED = 1 ");
		sqlStr.append("AND    P.PMP_PROJECT_ID = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { projectID });
	}

	public static ArrayList getList(UserBean userBean, String status) {
		// fetch summary
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT A.PMP_PROJECT_ID, A.PMP_PROJECT_DESC, ");
		sqlStr.append("       A.PMP_REQ_USER_ID, S.CO_STAFFNAME, ");
		sqlStr.append("       TO_CHAR(A.PMP_EXPECT_LAUNCH_DATE, 'DD/MM/YYYY'), ");
		sqlStr.append("       A.PMP_STATUS, TO_CHAR(A.PMP_MODIFIED_DATE, 'DD/MM/YYYY') ");
		sqlStr.append("FROM   PMP_PROJECTS A, PMP_PROJECT_CONTACTS C, CO_STAFFS S ");
		sqlStr.append("WHERE  A.PMP_PROJECT_ID = C.PMP_PROJECT_ID (+) ");
		sqlStr.append("AND    A.PMP_REQ_USER_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    A.PMP_ENABLED = 1 ");
		if (!userBean.isAdmin()) {
			sqlStr.append("AND   (A.PMP_REQ_USER_ID = ? ");
			sqlStr.append("OR     C.PMP_CONTACT_USER_ID = ?) ");
		}
		if (status != null && status.length() > 0) {
			sqlStr.append("AND    A.PMP_STATUS = '");
			sqlStr.append(status);
			sqlStr.append("' ");
		} else {
			sqlStr.append("AND    A.PMP_STATUS != 'close' ");
		}
		sqlStr.append("GROUP BY A.PMP_PROJECT_ID, A.PMP_PROJECT_DESC, ");
		sqlStr.append("       A.PMP_REQ_USER_ID, S.CO_STAFFNAME, ");
		sqlStr.append("       A.PMP_EXPECT_LAUNCH_DATE, ");
		sqlStr.append("       A.PMP_STATUS, A.PMP_MODIFIED_DATE ");
		sqlStr.append("ORDER BY A.PMP_MODIFIED_DATE DESC");

		if (userBean.isAdmin()) {
			return UtilDBWeb.getReportableList(sqlStr.toString());
		} else {
			return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { userBean.getStaffID(), userBean.getStaffID() });
		}
	}

	/**
	 * Add reply
	 */
	public static boolean addComment(UserBean userBean,
			String projectID, String type, String topic, String comment,
			String involveDeptCode, String involveUserID, String deadline,
			String fromStaffID,
			String[] toStaffID, String toEmailStr,
			String[] ccStaffID, String ccEmailStr,
			String sendEmail) {

		return addComment(userBean,
				projectID, type, topic, comment,
				involveDeptCode, involveUserID, deadline,
				getEmailList(fromStaffID), getEmailList(toStaffID, toEmailStr), getEmailList(ccStaffID, ccEmailStr),
				sendEmail);
	}

	public static boolean addComment(UserBean userBean,
			String projectID, String type, String topic, String comment,
			String involveDeptCode, String involveUserID, String deadline,
			HashMap<String, String> fromEmailList, HashMap<String, String> toEmailList, HashMap<String, String> ccEmailList,
			String sendEmail) {

		// get next action ID
		String commentID = getNextCommentID(projectID);

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertCommentAction,
				new String[] {
						projectID, commentID, type, topic,
						involveDeptCode, involveUserID, deadline, sendEmail.substring(0, 1),
						userBean.getLoginID(), userBean.getLoginID() })) {

			// add comment
			addContent(userBean, projectID, commentID, ConstantsVariable.ZERO_VALUE, processContent(comment));

			// add contact
			addContact(userBean, projectID, commentID, "from", fromEmailList);
			addContact(userBean, projectID, commentID, "to", toEmailList);
			addContact(userBean, projectID, commentID, "cc", ccEmailList);

			if ("YY".equals(sendEmail)) {
				sendEmail(projectID, commentID, getEmailList(userBean.getStaffID()), toEmailList, ccEmailList, topic, comment);
			} else if ("YN".equals(sendEmail)) {
				sendEmail(projectID, commentID, fromEmailList, toEmailList, ccEmailList, topic, comment);
			}
			return true;
		} else {
			return false;
		}
	}

	public static boolean updateComment(UserBean userBean,
			String projectID, String commentID, String type, String topic, String comment,
			String involveDeptCode, String involveUserID, String deadline,
			String fromStaffID,
			String[] toStaffID, String toEmailStr,
			String[] ccStaffID, String ccEmailStr,
			String sendEmail, boolean keepHistory) {

		return updateComment(userBean,
				projectID, commentID, type, topic, comment,
				involveDeptCode, involveUserID, deadline,
				getEmailList(fromStaffID), getEmailList(toStaffID, toEmailStr), getEmailList(ccStaffID, ccEmailStr),
				sendEmail, true, keepHistory);
	}

	public static boolean updateComment(UserBean userBean,
			String projectID, String commentID, String type, String topic, String comment,
			String involveDeptCode, String involveUserID, String deadline,
			HashMap<String, String> fromEmailList, HashMap<String, String> toEmailList, HashMap<String, String> ccEmailList,
			String sendEmail, boolean isUpdateCommentLink, boolean keepHistory) {

		if (keepHistory) {
			// keep comment history
			String commentHistoryID = getNextCommentHistoryID(projectID, commentID);

			if (UtilDBWeb.updateQueue(sqlStr_insertCommentHistoryAction,
					new String[] { commentHistoryID, projectID, commentID })) {

				// duplicate content
				UtilDBWeb.updateQueue(sqlStr_duplicateContentAction,
						new String[] { projectID, commentID, commentHistoryID, projectID, commentID });

				// add contact
				UtilDBWeb.updateQueue(
					sqlStr_insertContactHistoryAction,
					new String[] { commentHistoryID, projectID, commentID });
			}
		}

		// update comment status
		boolean success = false;
		boolean isReplyComment = false;
		if (type != null && topic != null && involveDeptCode != null && deadline != null) {
			if (UtilDBWeb.updateQueue(
					sqlStr_updateCommentAction,
					new String[] {
							type, topic,
							involveDeptCode, involveUserID, deadline, sendEmail.substring(0, 1),
							userBean.getLoginID(),
							projectID, commentID })) {
				// delete existing content
				deleteContent(userBean, projectID, commentID, ConstantsVariable.ZERO_VALUE);

				// add content
				addContent(userBean, projectID, commentID, ConstantsVariable.ZERO_VALUE, processContent(comment));

				success = true;
			}
		} else {
			isReplyComment = true;
			if (UtilDBWeb.updateQueue(
					sqlStr_updateCommentOnlyAction,
					new String[] {
							sendEmail.substring(0, 1), userBean.getLoginID(),
							projectID, commentID })) {

				// delete existing content
				deleteContent(userBean, projectID, commentID, ConstantsVariable.ZERO_VALUE);

				// add content
				addContent(userBean, projectID, commentID, ConstantsVariable.ZERO_VALUE, processContent(comment));

				success = true;
			}
		}

		if (success) {
			if (!isReplyComment) {
				// clear contact
				deleteContact(projectID, commentID);

				// update contact
				addContact(userBean, projectID, commentID, "from", fromEmailList);
				addContact(userBean, projectID, commentID, "to", toEmailList);
				addContact(userBean, projectID, commentID, "cc", ccEmailList);
			}

			// update link
			if (isUpdateCommentLink) {
				updateCommentLink(userBean, projectID, commentID, type, topic, comment,
						involveDeptCode, involveUserID, deadline, fromEmailList, toEmailList, ccEmailList, keepHistory);
			}

			if ("YY".equals(sendEmail)) {
				sendEmail(projectID, commentID, getEmailList(userBean.getStaffID()), toEmailList, ccEmailList, topic, comment);
			} else if ("YN".equals(sendEmail)) {
				sendEmail(projectID, commentID, fromEmailList, toEmailList, ccEmailList, topic, comment);
			}
			return true;
		} else {
			return false;
		}
	}

	public static boolean replyComment(UserBean userBean, String projectID, String commentID,
			String comment, String sendEmail) {

		return updateComment(userBean,
				projectID, commentID, null, null, comment,
				null, null, null,
				null,
				null, null,
				null, null,
				sendEmail, true);
	}

	public static boolean deleteComment(UserBean userBean,
			String projectID, String commentID) {
		return deleteComment(userBean,
				projectID, commentID, true);
	}

	public static boolean deleteComment(UserBean userBean,
			String projectID, String commentID, boolean isDeleteCommentLink) {

		// delete contact
		disableContact(userBean, projectID, commentID);

		// delete comment link
		if (isDeleteCommentLink) {
			deleteCommentLink(userBean, projectID, commentID);
		}

		// delete comment status
		return UtilDBWeb.updateQueue(
				sqlStr_deleteCommentAction,
				new String[] { userBean.getLoginID(), projectID, commentID });
	}

	public static ArrayList getComment(String projectID, String commentID) {
		return UtilDBWeb.getReportableList(sqlStr_getCommentAction, new String[] { projectID, commentID });
	}

	private static HashMap<String, String> getEmailList(String staffID) {
		HashMap<String, String> emailMap = new HashMap<String, String>();
		if (staffID != null && staffID.length() > 0) {
			String tempEmail = UserDB.getUserEmail(null, staffID);
			if (tempEmail != null && tempEmail.length() > 0) {
				emailMap.put(tempEmail, staffID);
			}
		}
		return emailMap;
	};

	private static HashMap<String, String> getEmailList(String[] staffID, String emailStr) {
		HashMap<String, String> emailMap = new HashMap<String, String>();
		if (emailStr != null && emailStr.length() > 0) {
			String tempStaffID = null;
			String[] email = TextUtil.split(emailStr, ConstantsVariable.SEMICOLON_VALUE);
			for (int i = 0; i < email.length; i++) {
				tempStaffID = UserDB.getUserID(email[i]);
				if (tempStaffID != null && tempStaffID.length() > 0) {
					emailMap.put(email[i], tempStaffID);
				} else {
					emailMap.put(email[i], ConstantsVariable.MINUS_VALUE);
				}
			}
		}
		if (staffID != null && staffID.length > 0) {
			String tempEmail = null;
			for (int i = 0; i < staffID.length; i++) {
				tempEmail = UserDB.getUserEmail(null, staffID[i]);
				emailMap.put(tempEmail, staffID[i]);
			}
		}
		return emailMap;
	};

	private static void sendEmail(String projectID, String commentID,
			HashMap<String, String> fromEmailList, HashMap<String, String> toEmailList, HashMap<String, String> ccEmailList,
			String topic, String comment) {

		String fromEmail = null;
		if (fromEmailList != null && fromEmailList.size() > 0) {
			fromEmail = (String) fromEmailList.keySet().iterator().next();
		}
		int count = 0;
		String[] toEmail = null;
		if (toEmailList != null && toEmailList.size() > 0) {
			toEmail = new String[toEmailList.size()];
			count = 0;
			for (Iterator i = toEmailList.keySet().iterator(); i.hasNext();) {
				toEmail[count++] = (String) i.next();
			}
		}
		String[] ccEmail = null;
		if (ccEmailList != null && ccEmailList.size() > 0) {
			ccEmail = new String[ccEmailList.size()];
			count = 0;
			for (Iterator i = ccEmailList.keySet().iterator(); i.hasNext();) {
				ccEmail[count++] = (String) i.next();
			}
		}

		sendEmail(projectID, commentID,
				fromEmail, toEmail, ccEmail,
				topic, comment);
	}

	private static void sendEmail(String projectID, String commentID,
			String fromEmail, String[] toEmail, String[] ccEmail,
			String topic, String comment) {
		// set default email from if empty
		if (fromEmail == null || fromEmail.length() == 0) {
			fromEmail = ConstantsServerSide.MAIL_ADMIN;
		}

		ArrayList record = null;
		ReportableListObject row = null;

		// set default topic if empty
		if (topic == null || topic.length() == 0) {
			record = getComment(projectID, commentID);
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				topic = row.getValue(1);
			}
		}

		record = get(projectID);
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			topic = row.getValue(0) + " - " + topic;
		}

		// append url
		StringBuffer commentStr = new StringBuffer();
		commentStr.append(comment);
		commentStr.append(" <br>Please click <a href=\"http://");
		commentStr.append(ConstantsServerSide.INTRANET_URL);
		commentStr.append("/intranet/pmp/summary.jsp?command=viewComment&projectID=");
		commentStr.append(projectID);
		commentStr.append("&commentID=");
		commentStr.append(commentID);
		commentStr.append("\">Intranet</a> or <a href=\"https://");
		commentStr.append(ConstantsServerSide.OFFSITE_URL);
		commentStr.append("/intranet/pmp/summary.jsp?command=viewComment&projectID=");
		commentStr.append(projectID);
		commentStr.append("&commentID=");
		commentStr.append(commentID);
		commentStr.append("\">Offsite</a> to view the summary.");
		comment = commentStr.toString();

		// send email
		UtilMail.sendMail(
			fromEmail,
			toEmail,
			ccEmail,
			new String[] { fromEmail },
			topic + " (From Intranet Portal - Project Summary)",
			comment);
	}

	public static ArrayList getCommentList(UserBean userBean, String projectID, String commentType) {
		return getCommentList(userBean, projectID, null, null, null, null, commentType, null, "fromdept", "ASC", true);
	}

	public static ArrayList getCommentList(UserBean userBean, String projectID,
			String contactType, String dateRange, String dateFrom, String dateTo, String commentType, String topic, String sortBy, String ordering, boolean active) {
		// fetch action
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.PMP_COMMENT_ID, C.PMP_COMMENT_TYPE, C.PMP_TOPIC_DESC, ");
		sqlStr.append("       CC.PMP_CONTENT, ");
		sqlStr.append("       D1.CO_DEPARTMENT_DESC, S.CO_STAFFNAME, U.CO_USERNAME, ");
		sqlStr.append("       D2.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       TO_CHAR(C.PMP_DEADLINE, 'DD/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(C.PMP_MODIFIED_DATE, 'DD/MM/YYYY HH24:MI') ");
		sqlStr.append("FROM   PMP_PROJECT_COMMENTS C, PMP_PROJECT_COMMENT_TYPES CT, ");
		sqlStr.append("       PMP_PROJECT_CONTACTS T, PMP_PROJECT_COMMENTS_CONTENT CC, ");
		sqlStr.append("       CO_STAFFS S, CO_USERS U, ");
		sqlStr.append("       CO_DEPARTMENTS D1, CO_DEPARTMENTS D2 ");
		sqlStr.append("WHERE  C.PMP_COMMENT_TYPE = CT.PMP_COMMENT_TYPE ");
		sqlStr.append("AND    C.PMP_PROJECT_ID = T.PMP_PROJECT_ID ");
		sqlStr.append("AND    C.PMP_COMMENT_ID = T.PMP_COMMENT_ID ");
		sqlStr.append("AND    T.PMP_CONTACT_TYPE = 'from' ");
		sqlStr.append("AND    T.PMP_CONTACT_USER_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    T.PMP_CONTACT_USER_ID = U.CO_USERNAME (+) ");
		sqlStr.append("AND    C.PMP_INVOLVE_DEPARTMENT_CODE = D2.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    C.PMP_PROJECT_ID = CC.PMP_PROJECT_ID ");
		sqlStr.append("AND    C.PMP_COMMENT_ID = CC.PMP_COMMENT_ID ");
		sqlStr.append("AND    C.PMP_COMMENT_HISTORY_ID = CC.PMP_COMMENT_HISTORY_ID ");
		sqlStr.append("AND    CC.PMP_CONTENT_ID = 1 ");
		sqlStr.append("AND    C.PMP_ENABLED = 1 ");
		sqlStr.append("AND    C.PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    C.PMP_COMMENT_HISTORY_ID = 0 ");

		if (contactType != null && contactType.length() > 0) {
			if ("from".equals(contactType)) {
				sqlStr.append("AND    T.PMP_CONTACT_USER_ID = '");
				sqlStr.append(userBean.getStaffID());
				sqlStr.append("' ");
			} else {
				sqlStr.append("AND    C.PMP_COMMENT_ID IN (SELECT PMP_COMMENT_ID FROM PMP_PROJECT_CONTACTS WHERE PMP_PROJECT_ID = '");
				sqlStr.append(projectID);
				sqlStr.append("' ");
				sqlStr.append("AND    PMP_CONTACT_TYPE = '");
				sqlStr.append(contactType);
				sqlStr.append("' ");
				sqlStr.append("AND    PMP_CONTACT_USER_ID = '");
				sqlStr.append(userBean.getStaffID());
				sqlStr.append("') ");
			}
		}
		if (dateFrom != null && dateFrom.length() > 0) {
			if ("deadline".equals(dateRange)) {
				sqlStr.append("AND    C.PMP_DEADLINE >= TO_DATE('");
			} else {
				sqlStr.append("AND    C.PMP_MODIFIED_DATE >= TO_DATE('");
			}
			sqlStr.append(dateFrom);
			sqlStr.append("', 'DD/MM/YYYY') ");
		}
		if (dateTo != null && dateTo.length() > 0) {
			if ("deadline".equals(dateRange)) {
				sqlStr.append("AND    C.PMP_DEADLINE <= TO_DATE('");
			} else {
				sqlStr.append("AND    C.PMP_MODIFIED_DATE <= TO_DATE('");
			}
			sqlStr.append(dateTo);
			sqlStr.append("', 'DD/MM/YYYY') ");
		}
		if (commentType != null && commentType.length() > 0) {
			sqlStr.append("AND    C.PMP_COMMENT_TYPE = '");
			sqlStr.append(commentType);
			sqlStr.append("' ");
		}
		if (topic != null && topic.length() > 0) {
			sqlStr.append("AND    UPPER(C.PMP_TOPIC_DESC) LIKE '%");
			sqlStr.append(topic.toUpperCase());
			sqlStr.append("%' ");
		}
		if (active) {
			sqlStr.append("AND    C.PMP_COMMENT_TYPE NOT IN ('archive') ");
		} else {
			sqlStr.append("AND    C.PMP_COMMENT_TYPE IN ('archive') ");
		}

		if ("modifiedDate".equals(sortBy)) {
			sqlStr.append("ORDER BY C.PMP_CREATED_DATE");
		} else if ("deadline".equals(sortBy)) {
			sqlStr.append("ORDER BY C.PMP_DEADLINE");
		} else if ("fromdept".equals(sortBy)) {
			sqlStr.append("ORDER BY D1.CO_DEPARTMENT_CODE");
		} else if ("priority".equals(sortBy)) {
			sqlStr.append("ORDER BY CT.PMP_ORDER_SEQUENCE");
		} else {
			sqlStr.append("ORDER BY C.PMP_TOPIC_DESC");
		}

		sqlStr.append(ConstantsVariable.SPACE_VALUE);
		if (ordering != null && ordering.length() > 0) {
			sqlStr.append(ordering);
		}

		if ("fromdept".equals(sortBy)) {
			sqlStr.append(", C.PMP_MODIFIED_DATE DESC, T.PMP_CONTACT_USER_ID");
		} else if ("priority".equals(sortBy)) {
			sqlStr.append(", C.PMP_COMMENT_TYPE, C.PMP_DEADLINE, C.PMP_MODIFIED_DATE, D2.CO_DEPARTMENT_CODE, T.PMP_CONTACT_USER_ID");
		} else {
			sqlStr.append(", D1.CO_DEPARTMENT_CODE, C.PMP_MODIFIED_DATE DESC, T.PMP_CONTACT_USER_ID");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { projectID });
	}

	public static ArrayList getCommentToDoList(UserBean userBean, String projectID, String deptCodeInclude, String deptCodeExclude) {
		if (projectID == null || projectID.trim().isEmpty()) {
			projectID = "-1";
		}

		// fetch action
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT PMP_COMMENT_ID, PMP_COMMENT_TYPE, PMP_TOPIC_DESC, ");
		sqlStr.append("       PMP_CONTENT, ");
		sqlStr.append("       CO_DEPARTMENT_DESC, CO_STAFFNAME, CO_USERNAME, ");
		sqlStr.append("       CO_DEPARTMENT_DESC2, ");
		sqlStr.append("       PMP_DEADLINE, PMP_MODIFIED_DATE, ");
		sqlStr.append("       CO_DEPARTMENT_CODE, PMP_ORDER_SEQUENCE, PMP_CONTACT_USER_ID ");
		sqlStr.append("FROM  (");
		sqlStr.append("SELECT C.PMP_COMMENT_ID, C.PMP_COMMENT_TYPE, C.PMP_TOPIC_DESC, ");
		sqlStr.append("       CC.PMP_CONTENT, ");
		sqlStr.append("       D1.CO_DEPARTMENT_DESC, S.CO_STAFFNAME, U.CO_USERNAME, ");
		sqlStr.append("       NULL CO_DEPARTMENT_DESC2, ");
		sqlStr.append("       TO_CHAR(C.PMP_DEADLINE, 'DD/MM/YYYY') PMP_DEADLINE, ");
		sqlStr.append("       TO_CHAR(C.PMP_MODIFIED_DATE, 'DD/MM/YYYY HH24:MI') PMP_MODIFIED_DATE, ");
		sqlStr.append("       D1.CO_DEPARTMENT_CODE, CT.PMP_ORDER_SEQUENCE, T.PMP_CONTACT_USER_ID ");
		sqlStr.append("FROM   PMP_PROJECT_COMMENTS C, PMP_PROJECT_COMMENT_TYPES CT, ");
		sqlStr.append("       PMP_PROJECT_CONTACTS T, PMP_PROJECT_COMMENTS_CONTENT CC, ");
		sqlStr.append("       CO_STAFFS S, CO_USERS U, ");
		sqlStr.append("       CO_DEPARTMENTS D1 ");
		sqlStr.append("WHERE  C.PMP_COMMENT_TYPE = CT.PMP_COMMENT_TYPE ");
		sqlStr.append("AND    C.PMP_PROJECT_ID = T.PMP_PROJECT_ID ");
		sqlStr.append("AND    C.PMP_COMMENT_ID = T.PMP_COMMENT_ID ");
		sqlStr.append("AND    T.PMP_CONTACT_TYPE = 'to' ");
		sqlStr.append("AND    T.PMP_CONTACT_USER_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    T.PMP_CONTACT_USER_ID = U.CO_USERNAME (+) ");
		sqlStr.append("AND    C.PMP_PROJECT_ID = CC.PMP_PROJECT_ID ");
		sqlStr.append("AND    C.PMP_COMMENT_ID = CC.PMP_COMMENT_ID ");
		sqlStr.append("AND    C.PMP_COMMENT_HISTORY_ID = CC.PMP_COMMENT_HISTORY_ID ");
		sqlStr.append("AND    CC.PMP_CONTENT_ID = 1 ");
		sqlStr.append("AND    C.PMP_INVOLVE_DEPARTMENT_CODE IS NULL ");
		sqlStr.append("AND    C.PMP_COMMENT_TYPE NOT IN ('archive') ");
		sqlStr.append("AND    C.PMP_ENABLED = 1 ");
		sqlStr.append("AND    C.PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    C.PMP_COMMENT_HISTORY_ID = 0 ");

		if (deptCodeInclude != null && deptCodeInclude.length() > 0) {
			sqlStr.append("AND    D1.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCodeInclude);
			sqlStr.append("' ");
		}
		if (deptCodeExclude != null && deptCodeExclude.length() > 0) {
			sqlStr.append("AND    D1.CO_DEPARTMENT_CODE != '");
			sqlStr.append(deptCodeExclude);
			sqlStr.append("' ");
		}

		sqlStr.append(") UNION (");

		sqlStr.append("SELECT C.PMP_COMMENT_ID, C.PMP_COMMENT_TYPE, C.PMP_TOPIC_DESC, ");
		sqlStr.append("       CC.PMP_CONTENT, ");
		sqlStr.append("       D2.CO_DEPARTMENT_DESC, NULL CO_STAFFNAME, NULL CO_USERNAME, ");
		sqlStr.append("       D2.CO_DEPARTMENT_DESC CO_DEPARTMENT_DESC2, ");
		sqlStr.append("       TO_CHAR(C.PMP_DEADLINE, 'DD/MM/YYYY') PMP_DEADLINE, ");
		sqlStr.append("       TO_CHAR(C.PMP_MODIFIED_DATE, 'DD/MM/YYYY HH24:MI') PMP_MODIFIED_DATE, ");
		sqlStr.append("       D2.CO_DEPARTMENT_CODE, CT.PMP_ORDER_SEQUENCE, NULL ");
		sqlStr.append("FROM   PMP_PROJECT_COMMENTS C, PMP_PROJECT_COMMENT_TYPES CT, ");
		sqlStr.append("       CO_DEPARTMENTS D2, PMP_PROJECT_COMMENTS_CONTENT CC ");
		sqlStr.append("WHERE  C.PMP_COMMENT_TYPE = CT.PMP_COMMENT_TYPE ");
		sqlStr.append("AND    C.PMP_INVOLVE_DEPARTMENT_CODE = D2.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    C.PMP_PROJECT_ID = CC.PMP_PROJECT_ID ");
		sqlStr.append("AND    C.PMP_COMMENT_ID = CC.PMP_COMMENT_ID ");
		sqlStr.append("AND    C.PMP_COMMENT_HISTORY_ID = CC.PMP_COMMENT_HISTORY_ID ");
		sqlStr.append("AND    CC.PMP_CONTENT_ID = 1 ");
		sqlStr.append("AND    C.PMP_COMMENT_TYPE NOT IN ('archive') ");
		sqlStr.append("AND    C.PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    C.PMP_ENABLED = 1 ");

		if (deptCodeInclude != null && deptCodeInclude.length() > 0) {
			sqlStr.append("AND    D2.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCodeInclude);
			sqlStr.append("' ");
		}
		if (deptCodeExclude != null && deptCodeExclude.length() > 0) {
			sqlStr.append("AND    D2.CO_DEPARTMENT_CODE != '");
			sqlStr.append(deptCodeExclude);
			sqlStr.append("' ");
		}

		sqlStr.append(") ");

		sqlStr.append("ORDER BY CO_DEPARTMENT_CODE, PMP_ORDER_SEQUENCE, PMP_DEADLINE, PMP_MODIFIED_DATE, PMP_CONTACT_USER_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { projectID, projectID });
	}

	/**
	 * Add an action
	 */
	public static boolean addContact(UserBean userBean,
			String projectID, String commentID,
			String contactType, HashMap<String, String> emailList) {

		if (emailList != null) {
			String staffID = null;
			String email = null;
			for (Iterator i = emailList.keySet().iterator(); i.hasNext();) {
				email = (String) i.next();
				staffID = (String) emailList.get(email);
				UtilDBWeb.updateQueue(
					sqlStr_insertContactAction,
					new String[] {
							projectID, commentID, contactType,
							"staff", staffID, email,
							userBean.getLoginID(), userBean.getLoginID() });
			}
			return true;
		} else {
			return false;
		}
	}

	public static boolean deleteContact(String projectID, String commentID) {
		return UtilDBWeb.updateQueue(
				sqlStr_deleteContactAction,
				new String[] {
						projectID, commentID });
	}

	public static boolean disableContact(UserBean userBean, String projectID, String commentID) {
		return UtilDBWeb.updateQueue(
				sqlStr_disableContactAction,
				new String[] {
						userBean.getLoginID(), projectID, commentID });
	}

	public static ArrayList getContactList(String projectID, String commentID) {
		return UtilDBWeb.getReportableList(sqlStr_getContactListAction, new String[] { projectID, commentID });
	}

	public static ArrayList getCommentHistoryList(UserBean userBean,
			String projectID, String commentID) {
		return UtilDBWeb.getReportableList(sqlStr_getCommentHistoryListAction, new String[] { projectID, commentID });
	}

	public static ArrayList getContactHistoryList(String projectID, String commentID, String historyID) {
		return UtilDBWeb.getReportableList(sqlStr_getContactHistoryListAction, new String[] { projectID, commentID, historyID });
	}

	public static String addCommentLink(UserBean userBean, String projectID, String commentID, String linkProjectID) {
		String commentLinkID = getNextCommentLinkID();
		String linkCommentID = getNextCommentID(linkProjectID);

		// add link to current comment
		if (UtilDBWeb.updateQueue(sqlStr_insertCommentLinkAction,
				new String[] { projectID, commentID, commentLinkID, userBean.getLoginID(), userBean.getLoginID() })) {

			// add link to the project
			UtilDBWeb.updateQueue(sqlStr_insertCommentLinkAction,
					new String[] { linkProjectID, linkCommentID, commentLinkID, userBean.getLoginID(), userBean.getLoginID() });

			// duplicate comment
			UtilDBWeb.updateQueue(sqlStr_duplicateCommentAction,
					new String[] { linkProjectID, linkCommentID, projectID, commentID });

			// duplicate content
			UtilDBWeb.updateQueue(sqlStr_duplicateContentAction,
					new String[] { linkProjectID, linkCommentID, ConstantsVariable.ZERO_VALUE, projectID, commentID });

			// duplicate contact
			UtilDBWeb.updateQueue(sqlStr_duplicateContactAction,
					new String[] { linkProjectID, linkCommentID, projectID, commentID });
		} else {
			commentLinkID = null;
		}
		return commentLinkID;
	}

	public static boolean deleteCommentLink(UserBean userBean, String projectID, String commentID) {
		// delete all the link comment
		ArrayList result = getCommentLinkList(projectID, commentID);
		ReportableListObject rlo = null;
		String linkProjectID = null;
		String linkCommentID = null;
		if (result.size() > 0) {
			for (int i = 0; i < result.size(); i++) {
				rlo = (ReportableListObject) result.get(i);
				linkProjectID = rlo.getValue(0);
				linkCommentID = rlo.getValue(2);
				if (!projectID.equals(linkProjectID)) {
					deleteComment(userBean, linkProjectID, linkCommentID, false);
				}
			}
		}

		// delete the comment link
		return UtilDBWeb.updateQueue(sqlStr_deleteCommentLinkAction, new String[] { userBean.getLoginID(), projectID, commentID });
	}

	private static void updateCommentLink(UserBean userBean,
			String projectID, String commentID, String type, String topic, String comment,
			String involveDeptCode, String involveUserID, String deadline,
			HashMap<String, String> fromEmailList, HashMap<String, String> toEmailList, HashMap<String, String> ccEmailList, boolean keepHistory) {

		ArrayList result = getCommentLinkList(projectID, commentID);
		ReportableListObject rlo = null;
		String linkProjectID = null;
		String linkCommentID = null;
		if (result.size() > 0) {
			for (int i = 0; i < result.size(); i++) {
				rlo = (ReportableListObject) result.get(i);
				linkProjectID = rlo.getValue(0);
				linkCommentID = rlo.getValue(2);
				if (!projectID.equals(linkProjectID)) {
					updateComment(userBean, linkProjectID, linkCommentID, type, topic, comment,
							involveDeptCode, involveUserID, deadline,
							fromEmailList, toEmailList, ccEmailList,
							null, false, keepHistory);
				}
			}
		}
	}

	public static String getCommentLinkID(String projectID, String commentID) {
		ArrayList result = UtilDBWeb.getReportableList(sqlStr_getCommentLinkIDAction, new String[] { projectID, commentID });

		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getValue(0);
		} else {
			return null;
		}
	}

	public static ArrayList getCommentLinkList(String projectID, String commentID) {
		return UtilDBWeb.getReportableList(sqlStr_getCommentLinkListAction, new String[] { projectID, commentID });
	}

	/**
	 * Add content
	 */
	private static void addContent(UserBean userBean,
			String projectID, String commentID, String commentHistoryID, String[] contents) {

		// try to insert a new record
		for (int i = 0; i < contents.length; i++) {
			UtilDBWeb.updateQueue(
				sqlStr_insertContentAction,
				new String[] { projectID, commentID, commentHistoryID,
						String.valueOf(i + 1), contents[i], userBean.getLoginID(), userBean.getLoginID() });
		}
	}

	private static boolean deleteContent(UserBean userBean,
			String projectID, String commentID, String commentHistoryID) {

		// try to delete content
		return UtilDBWeb.updateQueue(
				sqlStr_deleteCommentContent,
				new String[] {
						projectID, commentID, commentHistoryID });
	}

	public static ArrayList getContent(String projectID, String commentID, String commentHistoryID) {
		// fetch news
		return UtilDBWeb.getReportableList(sqlStr_getContent, new String[] { projectID, commentID, commentHistoryID });
	}

	private static String[] processContent(String content) {
		if (content != null) {
			return TextUtil.split(content, DEFAULT_COLUMN_LENGTH);
		} else {
			return null;
		}
	}

	public static ArrayList getUserList(String projectID) {
		// fetch summary
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT S.CO_STAFF_ID, S.CO_STAFFNAME ");
		sqlStr.append("FROM   PMP_PROJECTS A, PMP_PROJECT_CONTACTS C, CO_STAFFS S ");
		sqlStr.append("WHERE  A.PMP_PROJECT_ID = C.PMP_PROJECT_ID (+) ");
		sqlStr.append("AND    C.PMP_CONTACT_USER_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    A.PMP_ENABLED = 1 ");
		sqlStr.append("AND    A.PMP_PROJECT_ID = ? ");
		sqlStr.append("GROUP BY S.CO_STAFF_ID, S.CO_STAFFNAME ");
		sqlStr.append("ORDER BY S.CO_STAFFNAME");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { projectID });
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO PMP_PROJECTS ");
		sqlStr.append("(PMP_PROJECT_ID, PMP_REQ_USER_TYPE, PMP_REQ_USER_ID, ");
		sqlStr.append(" PMP_CREATED_USER, PMP_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ");
		sqlStr.append(" ?, ?)");
		sqlStr_insertAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE PMP_PROJECTS ");
		sqlStr.append("SET    PMP_PROJECT_DESC = ?, ");
		sqlStr.append("       PMP_EXPECT_LAUNCH_DATE = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append("       PMP_ACTUAL_LAUNCH_DATE = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append("       PMP_APPROVAL_REMARKS = ?, ");
		sqlStr.append("       PMP_BUDEGET_REMARKS = ?, ");
		sqlStr.append("       PMP_STATUS = ?, ");
		sqlStr.append("       PMP_MODIFIED_DATE = SYSDATE, PMP_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  PMP_ENABLED = 1 ");
		sqlStr.append("AND    PMP_PROJECT_ID = ? ");
		sqlStr_updateAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE PMP_PROJECTS ");
		sqlStr.append("SET    PMP_ENABLED = 0, PMP_MODIFIED_DATE = SYSDATE, PMP_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  PMP_ENABLED = 1 ");
		sqlStr.append("AND    PMP_PROJECT_ID = ? ");
		sqlStr_deleteAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO PMP_PROJECT_COMMENTS ");
		sqlStr.append("(PMP_PROJECT_ID, PMP_COMMENT_ID, PMP_COMMENT_TYPE, PMP_TOPIC_DESC, ");
		sqlStr.append(" PMP_INVOLVE_DEPARTMENT_CODE, PMP_INVOLVE_USER_ID, PMP_DEADLINE, PMP_EMAIL_NOTIFY, ");
		sqlStr.append(" PMP_CREATED_USER, PMP_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ");
		sqlStr.append(" ?, ?, TO_DATE(?, 'DD/MM/YYYY'), ?, ");
		sqlStr.append(" ?, ?)");
		sqlStr_insertCommentAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE PMP_PROJECT_COMMENTS ");
		sqlStr.append("SET    PMP_COMMENT_TYPE = ?, PMP_TOPIC_DESC = ?, ");
		sqlStr.append("       PMP_INVOLVE_DEPARTMENT_CODE = ?, PMP_INVOLVE_USER_ID = ?, PMP_DEADLINE = TO_DATE(?, 'DD/MM/YYYY'), PMP_EMAIL_NOTIFY = ?, ");
		sqlStr.append("       PMP_MODIFIED_DATE = SYSDATE, PMP_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_HISTORY_ID = 0 ");
		sqlStr_updateCommentAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE PMP_PROJECT_COMMENTS ");
		sqlStr.append("SET    PMP_EMAIL_NOTIFY = ?, ");
		sqlStr.append("       PMP_MODIFIED_DATE = SYSDATE, PMP_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_HISTORY_ID = 0 ");
		sqlStr_updateCommentOnlyAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE PMP_PROJECT_COMMENTS ");
		sqlStr.append("SET    PMP_ENABLED = 0, PMP_MODIFIED_DATE = SYSDATE, PMP_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_HISTORY_ID = 0 ");
		sqlStr_deleteCommentAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO PMP_PROJECT_COMMENTS ");
		sqlStr.append("(PMP_PROJECT_ID, PMP_COMMENT_ID, PMP_COMMENT_TYPE, PMP_TOPIC_DESC, PMP_INVOLVE_DEPARTMENT_CODE, PMP_INVOLVE_USER_ID, PMP_DEADLINE, PMP_EMAIL_NOTIFY, PMP_CREATED_DATE, PMP_CREATED_USER, PMP_MODIFIED_DATE, PMP_MODIFIED_USER) ");
		sqlStr.append("SELECT ?, ?, PMP_COMMENT_TYPE, PMP_TOPIC_DESC, PMP_INVOLVE_DEPARTMENT_CODE, PMP_INVOLVE_USER_ID, PMP_DEADLINE, PMP_EMAIL_NOTIFY, PMP_CREATED_DATE, PMP_CREATED_USER, PMP_MODIFIED_DATE, PMP_MODIFIED_USER ");
		sqlStr.append("FROM   PMP_PROJECT_COMMENTS ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_HISTORY_ID = 0 ");
		sqlStr_duplicateCommentAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT C.PMP_COMMENT_TYPE, C.PMP_TOPIC_DESC, ");
		sqlStr.append("       CC.PMP_CONTENT, ");
		sqlStr.append("       C.PMP_INVOLVE_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       C.PMP_INVOLVE_USER_ID, S1.CO_STAFFNAME, U1.CO_USERNAME, ");
		sqlStr.append("       TO_CHAR(C.PMP_DEADLINE, 'DD/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(C.PMP_MODIFIED_DATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("       S2.CO_STAFFNAME, U2.CO_USERNAME, C.PMP_EMAIL_NOTIFY ");
		sqlStr.append("FROM   PMP_PROJECT_COMMENTS C, CO_DEPARTMENTS D, ");
		sqlStr.append("       PMP_PROJECT_COMMENTS_CONTENT CC, ");
		sqlStr.append("       CO_USERS U1, CO_STAFFS S1, ");
		sqlStr.append("       CO_USERS U2, CO_STAFFS S2 ");
		sqlStr.append("WHERE  C.PMP_INVOLVE_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    C.PMP_INVOLVE_USER_ID = U1.CO_USERNAME (+) ");
		sqlStr.append("AND    C.PMP_MODIFIED_USER = U2.CO_USERNAME (+) ");
		sqlStr.append("AND    U1.CO_STAFF_ID = S1.CO_STAFF_ID (+) ");
		sqlStr.append("AND    U2.CO_STAFF_ID = S2.CO_STAFF_ID (+) ");
		sqlStr.append("AND    C.PMP_PROJECT_ID = CC.PMP_PROJECT_ID ");
		sqlStr.append("AND    C.PMP_COMMENT_ID = CC.PMP_COMMENT_ID ");
		sqlStr.append("AND    C.PMP_COMMENT_HISTORY_ID = CC.PMP_COMMENT_HISTORY_ID ");
		sqlStr.append("AND    CC.PMP_CONTENT_ID = 1 ");
		sqlStr.append("AND    C.PMP_ENABLED = 1 ");
		sqlStr.append("AND    C.PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    C.PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    C.PMP_COMMENT_HISTORY_ID = 0 ");
		sqlStr_getCommentAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT C.PMP_COMMENT_HISTORY_ID, ");
		sqlStr.append("       C.PMP_COMMENT_TYPE, C.PMP_TOPIC_DESC, ");
		sqlStr.append("       CC.PMP_CONTENT, ");
		sqlStr.append("       C.PMP_INVOLVE_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       C.PMP_INVOLVE_USER_ID, S1.CO_STAFFNAME, U1.CO_USERNAME, ");
		sqlStr.append("       TO_CHAR(C.PMP_DEADLINE, 'DD/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(C.PMP_MODIFIED_DATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("       S2.CO_STAFFNAME, U2.CO_USERNAME, C.PMP_EMAIL_NOTIFY ");
		sqlStr.append("FROM   PMP_PROJECT_COMMENTS C, CO_DEPARTMENTS D, ");
		sqlStr.append("       PMP_PROJECT_COMMENTS_CONTENT CC, ");
		sqlStr.append("       CO_USERS U1, CO_STAFFS S1, ");
		sqlStr.append("       CO_USERS U2, CO_STAFFS S2 ");
		sqlStr.append("WHERE  C.PMP_INVOLVE_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    C.PMP_INVOLVE_USER_ID = U1.CO_USERNAME (+) ");
		sqlStr.append("AND    C.PMP_MODIFIED_USER = U2.CO_USERNAME (+) ");
		sqlStr.append("AND    U1.CO_STAFF_ID = S1.CO_STAFF_ID (+) ");
		sqlStr.append("AND    U2.CO_STAFF_ID = S2.CO_STAFF_ID (+) ");
		sqlStr.append("AND    C.PMP_PROJECT_ID = CC.PMP_PROJECT_ID ");
		sqlStr.append("AND    C.PMP_COMMENT_ID = CC.PMP_COMMENT_ID ");
		sqlStr.append("AND    C.PMP_COMMENT_HISTORY_ID = CC.PMP_COMMENT_HISTORY_ID ");
		sqlStr.append("AND    CC.PMP_CONTENT_ID = 1 ");
		sqlStr.append("AND    C.PMP_ENABLED = 1 ");
		sqlStr.append("AND    C.PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    C.PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    C.PMP_COMMENT_HISTORY_ID != 0 ");
		sqlStr.append("ORDER BY C.PMP_COMMENT_HISTORY_ID DESC ");
		sqlStr_getCommentHistoryListAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO PMP_PROJECT_CONTACTS ");
		sqlStr.append("(PMP_PROJECT_ID, PMP_COMMENT_ID, PMP_CONTACT_TYPE, PMP_CONTACT_USER_TYPE, PMP_CONTACT_USER_ID, PMP_CREATED_DATE, PMP_CREATED_USER, PMP_MODIFIED_DATE, PMP_MODIFIED_USER) ");
		sqlStr.append("SELECT ?, ?, PMP_CONTACT_TYPE, PMP_CONTACT_USER_TYPE, PMP_CONTACT_USER_ID, PMP_CREATED_DATE, PMP_CREATED_USER, PMP_MODIFIED_DATE, PMP_MODIFIED_USER ");
		sqlStr.append("FROM   PMP_PROJECT_CONTACTS ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_HISTORY_ID = 0 ");
		sqlStr_duplicateContactAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO PMP_PROJECT_CONTACTS ");
		sqlStr.append("(PMP_PROJECT_ID, PMP_COMMENT_ID, PMP_CONTACT_TYPE, ");
		sqlStr.append(" PMP_CONTACT_USER_TYPE, PMP_CONTACT_USER_ID, PMP_CONTACT_EMAIL, ");
		sqlStr.append(" PMP_CREATED_USER, PMP_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ");
		sqlStr.append(" ?, ?, ?, ");
		sqlStr.append(" ?, ?)");
		sqlStr_insertContactAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE PMP_PROJECT_CONTACTS ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr_deleteContactAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE PMP_PROJECT_CONTACTS ");
		sqlStr.append("SET    PMP_ENABLED = 0, PMP_MODIFIED_DATE = SYSDATE, PMP_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    PMP_ENABLED = 1 ");
		sqlStr_disableContactAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO PMP_PROJECT_COMMENTS ");
		sqlStr.append("(PMP_PROJECT_ID, PMP_COMMENT_ID, PMP_COMMENT_HISTORY_ID, PMP_COMMENT_TYPE, PMP_TOPIC_DESC, PMP_INVOLVE_DEPARTMENT_CODE, PMP_INVOLVE_USER_ID, PMP_DEADLINE, PMP_EMAIL_NOTIFY, PMP_CREATED_DATE, PMP_CREATED_USER, PMP_MODIFIED_DATE, PMP_MODIFIED_USER) ");
		sqlStr.append("SELECT PMP_PROJECT_ID, PMP_COMMENT_ID, ?, PMP_COMMENT_TYPE, PMP_TOPIC_DESC, PMP_INVOLVE_DEPARTMENT_CODE, PMP_INVOLVE_USER_ID, PMP_DEADLINE, PMP_EMAIL_NOTIFY, PMP_CREATED_DATE, PMP_CREATED_USER, PMP_MODIFIED_DATE, PMP_MODIFIED_USER ");
		sqlStr.append("FROM   PMP_PROJECT_COMMENTS ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_HISTORY_ID = 0 ");
		sqlStr_insertCommentHistoryAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT A.PMP_CONTACT_TYPE, ");
		sqlStr.append("       A.PMP_CONTACT_USER_TYPE, A.PMP_CONTACT_USER_ID, ");
		sqlStr.append("       S.CO_STAFFNAME, ");
		sqlStr.append("       S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, A.PMP_CONTACT_EMAIL, U.CO_EMAIL ");
		sqlStr.append("FROM   PMP_PROJECT_CONTACTS A, CO_STAFFS S, CO_DEPARTMENTS D, CO_USERS U ");
		sqlStr.append("WHERE  A.PMP_CONTACT_USER_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    A.PMP_CONTACT_USER_ID = U.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    A.PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    A.PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    A.PMP_COMMENT_HISTORY_ID = 0 ");
		sqlStr.append("AND    A.PMP_ENABLED = 1 ");
		sqlStr.append("ORDER BY S.CO_STAFFNAME, S.CO_STAFF_ID ");
		sqlStr_getContactListAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO PMP_PROJECT_CONTACTS ");
		sqlStr.append("(PMP_PROJECT_ID, PMP_COMMENT_ID, PMP_COMMENT_HISTORY_ID, PMP_CONTACT_TYPE, PMP_CONTACT_USER_TYPE, PMP_CONTACT_USER_ID, PMP_CONTACT_EMAIL, PMP_CREATED_USER, PMP_MODIFIED_USER) ");
		sqlStr.append("SELECT PMP_PROJECT_ID, PMP_COMMENT_ID, ?, PMP_CONTACT_TYPE, PMP_CONTACT_USER_TYPE, PMP_CONTACT_USER_ID, PMP_CONTACT_EMAIL, PMP_CREATED_USER, PMP_MODIFIED_USER ");
		sqlStr.append("FROM   PMP_PROJECT_CONTACTS ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_HISTORY_ID = 0 ");
		sqlStr_insertContactHistoryAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT A.PMP_CONTACT_TYPE, ");
		sqlStr.append("       A.PMP_CONTACT_USER_TYPE, A.PMP_CONTACT_USER_ID, ");
		sqlStr.append("       S.CO_STAFFNAME, ");
		sqlStr.append("       S.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, A.PMP_CONTACT_EMAIL, U.CO_EMAIL ");
		sqlStr.append("FROM   PMP_PROJECT_CONTACTS A, CO_STAFFS S, CO_DEPARTMENTS D, CO_USERS U ");
		sqlStr.append("WHERE  A.PMP_CONTACT_USER_ID = S.CO_STAFF_ID (+) ");
		sqlStr.append("AND    A.PMP_CONTACT_USER_ID = U.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    A.PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    A.PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    A.PMP_COMMENT_HISTORY_ID = ? ");
		sqlStr.append("AND    A.PMP_ENABLED = 1 ");
		sqlStr.append("ORDER BY S.CO_STAFFNAME, S.CO_STAFF_ID ");
		sqlStr_getContactHistoryListAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO PMP_PROJECT_COMMENT_LINKS ");
		sqlStr.append("(PMP_PROJECT_ID, PMP_COMMENT_ID, PMP_PROJECT_COMMENT_LINK_ID, PMP_CREATED_USER, PMP_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?)");
		sqlStr_insertCommentLinkAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE PMP_PROJECT_COMMENT_LINKS ");
		sqlStr.append("SET    PMP_ENABLED = 0, PMP_MODIFIED_DATE = SYSDATE, PMP_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  PMP_PROJECT_COMMENT_LINK_ID IN (");
		sqlStr.append("SELECT PMP_PROJECT_COMMENT_LINK_ID ");
		sqlStr.append("FROM   PMP_PROJECT_COMMENT_LINKS ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_HISTORY_ID = 0 ");
		sqlStr.append("AND    PMP_ENABLED = 1) ");
		sqlStr.append("AND    PMP_ENABLED = 1 ");
		sqlStr_deleteCommentLinkAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT PMP_PROJECT_COMMENT_LINK_ID ");
		sqlStr.append("FROM   PMP_PROJECT_COMMENT_LINKS ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ?) ");
		sqlStr_getCommentLinkIDAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT L.PMP_PROJECT_ID, P.PMP_PROJECT_DESC, L.PMP_COMMENT_ID ");
		sqlStr.append("FROM   PMP_PROJECT_COMMENT_LINKS L, PMP_PROJECTS P ");
		sqlStr.append("WHERE  L.PMP_PROJECT_ID = P.PMP_PROJECT_ID ");
		sqlStr.append("AND    L.PMP_PROJECT_COMMENT_LINK_ID IN (");
		sqlStr.append("SELECT PMP_PROJECT_COMMENT_LINK_ID ");
		sqlStr.append("FROM   PMP_PROJECT_COMMENT_LINKS ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    PMP_ENABLED = 1) ");
		sqlStr.append("AND    L.PMP_ENABLED = 1 ");
		sqlStr_getCommentLinkListAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO PMP_PROJECT_COMMENTS_CONTENT ");
		sqlStr.append("(PMP_PROJECT_ID, PMP_COMMENT_ID, PMP_COMMENT_HISTORY_ID, ");
		sqlStr.append("PMP_CONTENT_ID, PMP_CONTENT, PMP_CREATED_USER, PMP_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?)");
		sqlStr_insertContentAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM PMP_PROJECT_COMMENTS_CONTENT ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_HISTORY_ID = ? ");
		sqlStr.append("AND    PMP_ENABLED = 1 ");
		sqlStr_deleteCommentContent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO PMP_PROJECT_COMMENTS_CONTENT ");
		sqlStr.append("(PMP_PROJECT_ID, PMP_COMMENT_ID, PMP_COMMENT_HISTORY_ID, PMP_CONTENT_ID, PMP_CONTENT, PMP_CREATED_USER, PMP_MODIFIED_DATE, PMP_MODIFIED_USER) ");
		sqlStr.append("SELECT ?, ?, ?, PMP_CONTENT_ID, PMP_CONTENT, PMP_CREATED_USER, PMP_MODIFIED_DATE, PMP_MODIFIED_USER ");
		sqlStr.append("FROM   PMP_PROJECT_COMMENTS_CONTENT ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_HISTORY_ID = 0 ");
		sqlStr_duplicateContentAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT PMP_CONTENT ");
		sqlStr.append("FROM   PMP_PROJECT_COMMENTS_CONTENT ");
		sqlStr.append("WHERE  PMP_PROJECT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_ID = ? ");
		sqlStr.append("AND    PMP_COMMENT_HISTORY_ID = ? ");
		sqlStr.append("AND    PMP_ENABLED = 1 ");
		sqlStr.append("ORDER BY PMP_CONTENT_ID ");
		sqlStr_getContent = sqlStr.toString();
	}
}