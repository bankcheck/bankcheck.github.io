/*
 * Created on April 14, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.FileUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class DocumentDB {

	private static String sqlStr_insertDocument = null;
	private static String sqlStr_insertDocumentGeneral = null;
	private static String sqlStr_insertDocumentEnrollment = null;
	private static String sqlStr_updateDocument = null;

	private static String sqlStr_deleteDocumentGeneral = null;
	private static String sqlStr_deleteAllDocumentGeneral = null;

	private static final String CURRENT_YEAR = "$CURRENT_YEAR";
	private static final String PREVIOUS_YEAR = "$PREVIOUS_YEAR";

	private static final String EMAIL_MODULE_CODE = "inactive.doc.links";
	private static final String EMAIL_TOPIC = "Intranet Portal alert - inactive document links";

	private static String getNextDocumentID() {
		String documentID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CO_DOCUMENT_ID) + 1 FROM CO_DOCUMENT");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			documentID = reportableListObject.getValue(0);

			// set 1 for initial
			if (documentID == null || documentID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return documentID;
	}

	private static String getNextDocumentID(String siteCode, String moduleCode, String keyID) {
		String documentID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CO_DOCUMENT_ID) + 1 FROM CO_DOCUMENT_GENERAL WHERE CO_SITE_CODE = ? AND CO_MODULE_CODE = ? AND CO_KEY_ID = ?",
				new String[] { siteCode, moduleCode, keyID } );
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			documentID = reportableListObject.getValue(0);

			// set 1 for initial
			if (documentID == null || documentID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return documentID;
	}

	public static String addHitRate(String docID){
		String dochitRate = null;

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_DOCUMENT ");
		sqlStr.append("SET    CO_HIT_RATE = CO_HIT_RATE + 1 ");
		sqlStr.append("WHERE  CO_DOCUMENT_ID =  "+docID);
		sqlStr.append(" AND    CO_ENABLED = 1 ");

		boolean updateSuccess = UtilDBWeb.updateQueue(sqlStr.toString());

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_HIT_RATE FROM CO_DOCUMENT ");
		sqlStr.append("WHERE  CO_DOCUMENT_ID =  "+docID);
		sqlStr.append(" AND    CO_ENABLED = 1 ");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());

		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			dochitRate = reportableListObject.getValue(0);
		}
		return dochitRate;
	}

	public static String showHitRate(String docID){
		String dochitRate=null;

		StringBuffer sqlStr = new StringBuffer();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_HIT_RATE FROM CO_DOCUMENT ");
		sqlStr.append("WHERE  CO_DOCUMENT_ID =  "+docID);
		sqlStr.append(" AND    CO_ENABLED = 1 ");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());

		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			dochitRate = reportableListObject.getValue(0);
		}
		return dochitRate;
	}

	public static String add(
			UserBean userBean, String description, String location, String documentType) {
		// get next document ID
		String documentID = getNextDocumentID();

		// try to insert document record
		if (!UtilDBWeb.updateQueue(
				sqlStr_insertDocument,
				new String[] { documentID, description, location,
					userBean.getLoginID(), userBean.getLoginID() })) {
			documentID = null;
		}
		return documentID;
	}

	public static String add(
			UserBean userBean, String moduleCode, String keyID, String directory, String documentDesc) {
		return add(null, userBean, moduleCode, keyID, directory, documentDesc);
	}

	public static String add(
			String a_siteCode, UserBean userBean, String moduleCode, String keyID, String directory, String documentDesc) {
		return add(a_siteCode, userBean, moduleCode, keyID, directory, false, null, documentDesc);
	}

	public static String add(
			String a_siteCode, UserBean userBean, String moduleCode, String keyID,
			String directory, boolean addDocumentIdToDirectory, String fileSeparator, String documentDesc) {
		String siteCode = ConstantsServerSide.SITE_CODE;

		// get next document ID
		String documentID = getNextDocumentID(siteCode, moduleCode, keyID);

		// add sub folder named with this documentID
		if (addDocumentIdToDirectory) {
			directory += fileSeparator + documentID;
		}

		// try to insert document record
		if (!UtilDBWeb.updateQueue(
				sqlStr_insertDocumentGeneral,
				new String[] { siteCode, moduleCode, keyID, documentID, directory, documentDesc,
					userBean.getLoginID(), userBean.getLoginID() })) {
			documentID = null;
		}
		return documentID;
	}

	public static String addEnrollDoc(
			UserBean userBean, String moduleCode, String eventID, String scheduleID, String enrollID,
			String description, String location, String documentType) {
		// get next document ID
		String documentID = add(userBean, description, location, documentType);

		if (documentID != null) {
			// try to insert document record
			if (!UtilDBWeb.updateQueue(
					sqlStr_insertDocumentEnrollment,
					new String[] { moduleCode, eventID, scheduleID, enrollID, documentID,
						userBean.getLoginID(), userBean.getLoginID() })) {
				documentID = null;
			}
		}
		return documentID;
	}

	public static boolean update(String documentID, String desc, String location,
			boolean isWebFolder, boolean isLocationWithFilename, String filePrefix, String fileSuffix,
			UserBean userBean) {
		return UtilDBWeb.updateQueue(sqlStr_updateDocument,
				new String[] { desc, location,
				isWebFolder ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE,
				isLocationWithFilename ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE,
				filePrefix,
				fileSuffix,
				userBean.getLoginID(),
				documentID
		});
	}

	public static boolean delete(UserBean userBean, String moduleCode, String keyID, String documentID) {
		return delete(null, userBean, moduleCode, keyID, documentID);
	}

	public static boolean delete(String a_siteCode, UserBean userBean, String moduleCode, String keyID, String documentID) {
		String siteCode = null;
		if (a_siteCode == null) {
			siteCode = userBean.getSiteCode();
			if (siteCode == null) {
				// set default site code
				siteCode = ConstantsServerSide.SITE_CODE;
			}
		} else {
			siteCode = a_siteCode;
		}

		return UtilDBWeb.updateQueue(sqlStr_deleteDocumentGeneral,
				new String[] { userBean.getLoginID(), siteCode, moduleCode, keyID, documentID });
	}

	public static boolean delete(UserBean userBean, String moduleCode, String keyID) {
		return delete(null, userBean, moduleCode, keyID);
	}

	public static boolean delete(String a_siteCode, UserBean userBean, String moduleCode, String keyID) {
		String siteCode = null;
		if (a_siteCode == null) {
			siteCode = userBean.getSiteCode();
			if (siteCode == null) {
				// set default site code
				siteCode = ConstantsServerSide.SITE_CODE;
			}
		} else {
			siteCode = a_siteCode;
		}

		return UtilDBWeb.updateQueue(sqlStr_deleteAllDocumentGeneral,
				new String[] { userBean.getLoginID(), siteCode, moduleCode, keyID });
	}

	public static ArrayList getList() {
		// fetch document
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DOCUMENT_ID, CO_DESCRIPTION ");
		sqlStr.append("FROM   CO_DOCUMENT ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY CO_DESCRIPTION");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getListwithURL() {
		// fetch document
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION ");
		sqlStr.append("FROM   CO_DOCUMENT ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY CO_DESCRIPTION");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getList(UserBean userBean, String moduleCode, String keyID) {
		return getList(userBean, null, moduleCode, keyID);
	}

	public static ArrayList getList(UserBean userBean, String a_siteCode, String moduleCode, String keyID) {
		return getList(userBean, a_siteCode, moduleCode, keyID, null, 0);
	}

	public static ArrayList getList(UserBean userBean, String a_siteCode, String moduleCode,
									String keyID, String[] documentID, int order) {
		String siteCode = null;
		List<String> params = new ArrayList<String>();
		if (a_siteCode == null) {
				// set default site code
				siteCode = ConstantsServerSide.SITE_CODE;
		} else {
			siteCode = a_siteCode;
		}

		// fetch document
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC ");
		sqlStr.append("FROM   CO_DOCUMENT_GENERAL ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_KEY_ID = ? ");
		params.add(siteCode);
		params.add(moduleCode);
		params.add(keyID);
		if (documentID != null) {
			sqlStr.append("AND    (");
			for(int i = 0; i < documentID.length; i++) {
				if(i > 0) {
					sqlStr.append(" OR ");
				}
				sqlStr.append("CO_DOCUMENT_ID = ? ");
				params.add(documentID[i]);
			}
			sqlStr.append(" ) ");
		}
		sqlStr.append("AND    CO_ENABLED = 1 ");
		if(order == 0)
			sqlStr.append("ORDER BY CO_DOCUMENT_DESC ");
		else {
			sqlStr.append("ORDER BY CO_DOCUMENT_ID ");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString(), params.toArray(new String[]{}));
	}

	public static ArrayList get(String documentID) {
		// fetch document
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, CO_WEB_FOLDER, ");
		sqlStr.append("       CO_LOCATION_WITH_FILENAME, CO_FILE_PREFIX, CO_FILE_SUFFIX, ");
		sqlStr.append("       CO_FILE_LAST_MODIFIED, CO_EXTERNAL_LINK ");
		sqlStr.append("FROM   CO_DOCUMENT ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_DOCUMENT_ID = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { documentID });
	}

	public static String getURL(String documentID) {
		ArrayList record = get(documentID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);

			return row.getValue(2);
		}
		return null;
	}

	public static boolean checkUpdateWithTwoMth(String documentID) {
		StringBuffer sqlStr = new StringBuffer();
		Integer monthDiff = -1;
		sqlStr.append("SELECT CO_DOCUMENT_ID,");
		sqlStr.append(" Co_Modified_Date,round(MONTHS_BETWEEN(sysdate,co_modified_date)) ");
		sqlStr.append("FROM   CO_DOCUMENT ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_DOCUMENT_ID = ? ");
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { documentID });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			 monthDiff = Integer.parseInt(row.getValue(2));
		}
		if(monthDiff <=2 && monthDiff >-1){
			return true;
		}else{
			return false;
		}
	}

	public static ReportableListObject getReportableListObject(String documentID) {
		ArrayList record = get(documentID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			try {
				String locationPath = row.getValue(2);
				int index1 = -1;
				int index2 = -1;
				if ((index1 = locationPath.indexOf(CURRENT_YEAR)) >= 0
						|| (index2 = locationPath.indexOf(PREVIOUS_YEAR)) >= 0) {
					int currentYear = DateTimeUtil.getCurrentYear();
					if (index1 >= 0) {
						while ((index1 = locationPath.indexOf(CURRENT_YEAR)) >= 0) {
							locationPath = locationPath.substring(0, index1) + currentYear + locationPath.substring(index1 + CURRENT_YEAR.length());
						}
					} else {
						while ((index2 = locationPath.indexOf(PREVIOUS_YEAR)) >= 0) {
							locationPath = locationPath.substring(0, index2) + (currentYear - 1) + locationPath.substring(index2 + PREVIOUS_YEAR.length());
						}
					}
					row.setValue(2, locationPath);
				}
			} catch (Exception e) { }

			return row;
		} else {
			return null;
		}
	}

	public static ArrayList getAccessable(UserBean userBean) {
		// fetch document
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("( ");
		sqlStr.append("SELECT AC_DOCUMENT_ID ");
		sqlStr.append("FROM   AC_DOCUMENT_ACCESS ");
		sqlStr.append("WHERE  AC_ENABLED = 1 ");
		sqlStr.append("AND   ((AC_SITE_CODE = ? AND AC_STAFF_ID = ?) OR AC_GROUP_ID = ?) ");

		sqlStr.append(") UNION ( ");

		sqlStr.append("SELECT D.AC_DOCUMENT_ID ");
		sqlStr.append("FROM   AC_DOCUMENT_ACCESS D, CO_GROUPS G, AC_USER_GROUPS UG ");
		sqlStr.append("WHERE  D.AC_ENABLED = 1 ");
		sqlStr.append("AND    D.AC_GROUP_ID = G.CO_GROUP_ID ");
		sqlStr.append("AND    G.CO_GROUP_ID = UG.AC_GROUP_ID ");
		sqlStr.append("AND    UG.AC_SITE_CODE = ? ");
		sqlStr.append("AND    UG.AC_STAFF_ID = ? ");
		sqlStr.append(") ");

		return UtilDBWeb.getReportableList(sqlStr.toString(),
				new String[] { userBean.getSiteCode(), userBean.getStaffID(), userBean.isStaff()?"staff":"guest", userBean.getSiteCode(), userBean.getStaffID() });
	}

	public static boolean isAccessable(UserBean userBean, String documentID) {
		// fetch document
		if (UtilDBWeb.isExist("SELECT 1 FROM AC_DOCUMENT_ACCESS WHERE AC_ENABLED = 1 AND AC_DOCUMENT_ID = ? ",
				new String[] { documentID }) && !userBean.isAdmin()) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("( ");
			sqlStr.append("SELECT AC_DOCUMENT_ID ");
			sqlStr.append("FROM   AC_DOCUMENT_ACCESS ");
			sqlStr.append("WHERE  AC_ENABLED = 1 ");
			sqlStr.append("AND    AC_DOCUMENT_ID = ? ");
			sqlStr.append("AND   ((AC_SITE_CODE = ? AND AC_STAFF_ID = ?) OR AC_GROUP_ID = ?) ");

			sqlStr.append(") UNION ( ");

			sqlStr.append("SELECT D.AC_DOCUMENT_ID ");
			sqlStr.append("FROM   AC_DOCUMENT_ACCESS D, CO_GROUPS G, AC_USER_GROUPS UG ");
			sqlStr.append("WHERE  D.AC_ENABLED = 1 ");
			sqlStr.append("AND    D.AC_DOCUMENT_ID = ? ");
			sqlStr.append("AND    D.AC_GROUP_ID = G.CO_GROUP_ID ");
			sqlStr.append("AND    G.CO_GROUP_ID = UG.AC_GROUP_ID ");
			sqlStr.append("AND    UG.AC_SITE_CODE = ? ");
			sqlStr.append("AND    UG.AC_STAFF_ID = ? ");
			sqlStr.append(") ");

			return UtilDBWeb.isExist(sqlStr.toString(),
					new String[] { documentID, userBean.getSiteCode(), userBean.getStaffID(), userBean.isStaff()?"staff":"guest", documentID, userBean.getSiteCode(), userBean.getStaffID() });
		} else {
			return true;
		}
	}

	public static ArrayList getELearningDoc(String elearningID) {
		// fetch document
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ED.EE_DOCUMENT_ID, D.CO_DESCRIPTION, D.CO_LOCATION ");
		sqlStr.append("FROM   EE_ELEARNING_DOCUMENT ED, CO_DOCUMENT D ");
		sqlStr.append("WHERE  ED.EE_DOCUMENT_ID = D.CO_DOCUMENT_ID ");
		sqlStr.append("AND    ED.EE_ENABLED = 1 ");
		sqlStr.append("AND    ED.EE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    ED.EE_ELEARNING_ID = ? ");
		sqlStr.append("ORDER BY D.CO_DOCUMENT_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { elearningID });
	}

	public static ArrayList getEnrollDoc(String moduleCode, String eventID, String enrollID) {
		// fetch document
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.CO_DOCUMENT_ID, D.CO_DESCRIPTION, D.CO_LOCATION ");
		sqlStr.append("FROM   CO_ENROLLMENT EE, CO_ENROLLMENT_DOCUMENT ED, CO_DOCUMENT D ");
		sqlStr.append("WHERE  EE.CO_SITE_CODE = ED.CO_SITE_CODE ");
		sqlStr.append("AND    EE.CO_MODULE_CODE = ED.CO_MODULE_CODE ");
		sqlStr.append("AND    EE.CO_EVENT_ID = ED.CO_EVENT_ID ");
		sqlStr.append("AND    EE.CO_SITE_CODE = ED.CO_SITE_CODE ");
		sqlStr.append("AND    ED.CO_DOCUMENT_ID = D.CO_DOCUMENT_ID ");
		sqlStr.append("AND    EE.CO_MODULE_CODE = ? ");
		sqlStr.append("AND    EE.CO_EVENT_ID = ? ");
		sqlStr.append("AND    EE.CO_ENROLL_ID = ? ");
		sqlStr.append("AND    EE.CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY D.CO_DESCRIPTION");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode, eventID, enrollID });
	}

	public static ArrayList getCRMProgressDoc(String clientID) {
		// fetch document
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CD.CRM_DOCUMENT_ID, D.CO_DESCRIPTION, D.CO_LOCATION ");
		sqlStr.append("FROM   CRM_CLIENTS_PROGRESS_DOCUMENT CD, CO_DOCUMENT D ");
		sqlStr.append("WHERE  CD.CRM_DOCUMENT_ID = D.CO_DOCUMENT_ID ");
		sqlStr.append("AND    CD.CRM_ENABLED = 1 ");
		sqlStr.append("AND    CD.CRM_CLIENT_ID = ? ");
		sqlStr.append("ORDER BY D.CO_DOCUMENT_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID });
	}

	public static String checkDocumentLinkActive() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.CO_DOCUMENT_ID, D.CO_DESCRIPTION, D.CO_LOCATION, ");
		sqlStr.append("		  D.CO_WEB_FOLDER, D.CO_LOCATION_WITH_FILENAME, ");
		sqlStr.append("		  D.CO_FILE_PREFIX, D.CO_FILE_SUFFIX, D.CO_FILE_LAST_MODIFIED, ");
		sqlStr.append("		  p.co_information_page_id, p.co_information_category ");
		sqlStr.append("FROM   CO_DOCUMENT D ");
		sqlStr.append("	LEFT JOIN	CO_INFORMATION_PAGE P ");
		sqlStr.append("		ON		D.CO_DOCUMENT_ID = P.CO_DOCUMENT_ID ");
		sqlStr.append("WHERE  D.CO_ENABLED = 1 ");
		sqlStr.append("	AND   P.co_information_page_id is null OR (P.co_information_page_id is not null and P.CO_ENABLED = 1) ");
		sqlStr.append("ORDER BY	D.CO_DOCUMENT_ID");

		StringBuffer outStr = new StringBuffer();
		List result = UtilDBWeb.getReportableList(sqlStr.toString());
		List inactiveList = new ArrayList();
		if (result != null) {
			for (int i = 0; i < result.size(); i++) {
				ReportableListObject rlo = (ReportableListObject) result.get(i);
				String documentId = rlo.getValue(0);
				String location = rlo.getValue(2);
				String webFolder = rlo.getValue(3);
				String locationWithFilename = rlo.getValue(4);

				outStr.append("Co Document ID " + documentId + ", ");
				if (ConstantsVariable.NO_VALUE.equals(webFolder)) {
					// (1) i.e. \\hkim\im\...
					if (location.startsWith("\\\\")) {
						if (ConstantsVariable.YES_VALUE.equals(locationWithFilename)) {
							if (!FileUtil.isExist(location)) {
								outStr.append("File not exist. Notify admin by email." + "<br />");
								inactiveList.add(rlo);
							} else {
								outStr.append("Active." + "<br />");
							}
						} else {
							File folder = new File(location);
							if (folder.isDirectory()) {
								if (FileUtil.isExist(location)) {
									outStr.append("File/directory exist." + "<br />");
								} else {
									outStr.append("Valid directory." + "<br />");
								}
							} else {
								outStr.append("Directory not found." + "<br />");
								//inactiveList.add(rlo);
							}
						}

					} else if (location.startsWith("http")) {
						outStr.append("is web link." + "<br />");
					}
				} else {
					String path = ConstantsServerSide.DOCUMENT_FOLDER + location;
					if (ConstantsVariable.YES_VALUE.equals(locationWithFilename)) {
						if (!FileUtil.isExist(path)) {
							outStr.append("File not exist. Notify admin by email." + "<br />");
							inactiveList.add(rlo);
						} else {
							outStr.append("Active." + "<br />");	// valid
						}
					} else {
						File folder = new File(location);
						if (folder.isDirectory()) {
							if (FileUtil.isExist(location)) {
								outStr.append("File/directory exist." + "<br />");	// valid
							} else {
								outStr.append("Valid directory." + "<br />");	// valid
							}
						} else {
							outStr.append("Directory not found." + "<br />");
							//inactiveList.add(rlo);
						}
					}
				}
			}
		}

		documentInvalidMailNotify(inactiveList);

		return outStr.toString();
	}

	private static String documentInvalidMailTable(ReportableListObject row) {
		StringBuffer outStr = new StringBuffer();
		if (row != null) {
			outStr.append("<tr><td>");
			outStr.append(row.getValue(0));
			outStr.append("</td><td>");
			outStr.append(row.getValue(1));
			outStr.append("</td><td>");
			outStr.append(row.getValue(2));
			outStr.append("</td><td>");
			outStr.append(row.getValue(8));
			outStr.append("</td><td>");
			outStr.append(row.getValue(9));
			outStr.append("</td></tr>");
		}
		return outStr.toString();
	}

	private static boolean documentInvalidMailNotify(List result) {
		boolean mailSent = false;
		StringBuffer message = new StringBuffer();
		if (result != null && !result.isEmpty()) {
			message.append("<p>List of inactive document link(s). Please check.</p>");
			message.append("<table border=\"1\">");
			message.append("<tr><td>Document ID</td><td>Description</td><td>Location</td><td>CO_INFORMATION_PAGE_ID</td><td>CO_INFORMATION_CATEGORY</td></tr>");
			for (int i = 0; i < result.size(); i++) {
				message.append(documentInvalidMailTable((ReportableListObject) result.get(i)));
			}
			message.append("</table>");

			mailSent = EmailAlertDB.sendEmail(
					EMAIL_MODULE_CODE,
					EMAIL_TOPIC,
					message.toString());
		}

		return mailSent;
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_DOCUMENT (");
		sqlStr.append("CO_DOCUMENT_ID, CO_DESCRIPTION, CO_LOCATION, ");
		sqlStr.append("CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES (?, ?, ?, ?, ?)");
		sqlStr_insertDocument = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_DOCUMENT ");
		sqlStr.append("SET    CO_DESCRIPTION = ?, CO_LOCATION = ?, CO_WEB_FOLDER = ?, CO_LOCATION_WITH_FILENAME = ?, CO_FILE_PREFIX = ?, CO_FILE_SUFFIX = ?, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_DOCUMENT_ID = ?");
		sqlStr_updateDocument = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_DOCUMENT_GENERAL (");
		sqlStr.append("CO_SITE_CODE, CO_MODULE_CODE, CO_KEY_ID, CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC, ");
		sqlStr.append("CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
		sqlStr_insertDocumentGeneral = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_ENROLLMENT_DOCUMENT (");
		sqlStr.append("CO_SITE_CODE, CO_MODULE_CODE, CO_EVENT_ID, CO_SCHEDULE_ID, CO_ENROLL_ID, CO_DOCUMENT_ID, ");
		sqlStr.append("CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?, ?, ?)");
		sqlStr_insertDocumentEnrollment = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_DOCUMENT_GENERAL ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_KEY_ID = ? ");
		sqlStr.append("AND    CO_DOCUMENT_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_deleteDocumentGeneral = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_DOCUMENT_GENERAL ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_KEY_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_deleteAllDocumentGeneral = sqlStr.toString();
	}
}