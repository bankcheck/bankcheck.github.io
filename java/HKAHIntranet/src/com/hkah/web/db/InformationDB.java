package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class InformationDB {

	private static String sqlStr_insertInfo = null;
	private static String sqlStr_updateInfo = null;
	private static String sqlStr_deleteInfo = null;
	private static String sqlStr_getInfo = null;
	private static String sqlStr_getdocDETAILS = null;


	private static String getNextinfoID(String infoCategory) {
		String infoID = null;

		// get next scheduled id from db//
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CO_INFORMATION_PAGE_ID) + 1 FROM CO_INFORMATION_PAGE WHERE CO_INFORMATION_CATEGORY = ?",
				new String[] { infoCategory });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			infoID = reportableListObject.getValue(0);

			// set 1 for initial
			if (infoID == null || infoID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return infoID;
	}

	public static String[] getinfoID(String infoCategory, String infoType) {
		// fetch news list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT MAX(CO_INFORMATION_PAGE_ID), CO_INFORMATION_CATEGORY ");
		sqlStr.append("FROM   CO_INFORMATION_PAGE ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		if (infoCategory != null && infoCategory.length() > 0) {
			sqlStr.append("AND    CO_INFORMATION_CATEGORY LIKE '%");
			sqlStr.append(infoCategory);
			sqlStr.append("%' ");
		}
		if (infoCategory != null && infoCategory.length() > 0) {
			sqlStr.append("AND    CO_INFORMATION_TYPE LIKE '%");
			sqlStr.append(infoType);
			sqlStr.append("%' ");
		}
		sqlStr.append("GROUP BY CO_INFORMATION_CATEGORY ");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return new String[] { row.getValue(0), row.getValue(1) };
		}
		return null;
	}

	public static String add(
			UserBean userBean, String infoCategory, String infoType,
			String infoDescription, String funcID, String funcURL,
			String docID, String docURL, String withfolder,
			String latestfile, String showsub, String onlycurrent,
			String showpoint, String showroot, String targetcontent) {

		// get next schedule ID
		String infoID = getNextinfoID(infoCategory);
		System.out.println("it is "+infoID);

		// try to insert a new record
		System.out.println(sqlStr_insertInfo);
		if (UtilDBWeb.updateQueue(
				sqlStr_insertInfo,
				new String[] {
					infoID, infoCategory, infoType, infoDescription,
					funcID, funcURL, docID, docURL,
					withfolder, latestfile, showsub, onlycurrent,
					showpoint, showroot, targetcontent, userBean.getLoginID()
				})) {
			return infoID;
		} else {
			return null;
		}
	}

	public static boolean update(UserBean userBean, String infoID,
			String infoCategory, String infoType, String infoDescription,
			String funcID, String funcURL,
			String docID, String docURL, String withfolder,
			String latestfile, String showsub, String onlycurrent,
			String showpoint, String showroot, String targetcontent) {

		// try to update selected record
		UtilDBWeb.updateQueue(
				sqlStr_updateInfo,
				new String[] {
					infoID, infoCategory,infoType, infoDescription, funcID, funcURL,
					docID, docURL, withfolder, latestfile, showsub,
					onlycurrent, showpoint, showroot, targetcontent,
					userBean.getLoginID(), infoID, infoCategory
				});

			return true;
		}

	public static boolean delete(UserBean userBean,
			String infoID, String infoCategory) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteInfo,
				new String[] { userBean.getLoginID(), infoCategory, infoID });
	}

	public static ArrayList getList(String infoCategory, int noOfMaxRecord){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select p.co_information_page_id, p.co_information_category, p.co_information_type, p.co_description,");
		sqlStr.append(" c.co_information_category_desc, c.co_function_id");
		sqlStr.append(" from co_information_page p left join co_information_category c");
		sqlStr.append(" on p.co_information_category = c.co_information_category");
		if(infoCategory !=null){
			sqlStr.append(" where p.co_information_category = '"+infoCategory+"'"+"and p.CO_ENABLED = 1");
		} else {
			sqlStr.append(" where p.CO_ENABLED = 1");
		}
		sqlStr.append(" order by p.co_information_category,p.co_information_page_id");

		if (noOfMaxRecord > 0) {
			return UtilDBWeb.getReportableList(sqlStr.toString(), noOfMaxRecord);
		} else {
			return UtilDBWeb.getReportableList(sqlStr.toString());
		}
	}

	public static ArrayList getCategorylist() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 	CO_INFORMATION_CATEGORY, CO_INFORMATION_CATEGORY_DESC, CO_FUNCTION_ID ");
		sqlStr.append("FROM 	CO_INFORMATION_CATEGORY ");
		sqlStr.append("WHERE	CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY	CO_INFORMATION_CATEGORY");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList get(String infoID, String infoCategory) {
		// fetch news
		return UtilDBWeb.getReportableList(sqlStr_getInfo, new String[] { infoID, infoCategory });
	}

	public static ArrayList getDOC(String docID) {
		// fetch news
		return UtilDBWeb.getReportableList(sqlStr_getdocDETAILS, new String[] {docID});
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_INFORMATION_PAGE ");
		sqlStr.append("(CO_INFORMATION_PAGE_ID, CO_INFORMATION_CATEGORY, CO_INFORMATION_TYPE, ");
		sqlStr.append("CO_DESCRIPTION, CO_FUNCTION_ID, CO_FUNCTION_URL, ");
		sqlStr.append("CO_DOCUMENT_ID, CO_DOCUMENT_URL, CO_DOCUMENT_WITH_FOLDER, ");
		sqlStr.append("CO_DOCUMENT_LATEST_FILE, CO_DOCUMENT_SHOW_SUB_FOLDER, CO_DOCUMENT_ONLY_CURRENT_YEAR, ");
		sqlStr.append("CO_DOCUMENT_SHOW_POINT_FORM, CO_FOLDER_SHOW_ROOT, CO_TARGET_CONTENT, ");
		sqlStr.append("CO_CREATED_USER, CO_CREATED_DATE ) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ?, ");
		sqlStr.append("?, SYSDATE )");
		sqlStr_insertInfo = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_INFORMATION_PAGE ");
		sqlStr.append("SET    CO_INFORMATION_PAGE_ID = ?, CO_INFORMATION_CATEGORY = ?, ");
		sqlStr.append("       CO_INFORMATION_TYPE = ?, CO_DESCRIPTION = ?, ");
		sqlStr.append("       CO_FUNCTION_ID = ?, CO_FUNCTION_URL = ?, ");
		sqlStr.append("       CO_DOCUMENT_ID = ?, CO_DOCUMENT_URL = ?, ");
		sqlStr.append("       CO_DOCUMENT_WITH_FOLDER = ?, CO_DOCUMENT_LATEST_FILE = ?, ");
		sqlStr.append("       CO_DOCUMENT_SHOW_SUB_FOLDER = ?, CO_DOCUMENT_ONLY_CURRENT_YEAR = ?, ");
		sqlStr.append("       CO_DOCUMENT_SHOW_POINT_FORM = ?, CO_FOLDER_SHOW_ROOT = ?, ");
		sqlStr.append("       CO_TARGET_CONTENT = ?, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_INFORMATION_PAGE_ID = ? ");
		sqlStr.append("AND    CO_INFORMATION_CATEGORY = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_updateInfo = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_INFORMATION_PAGE ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_INFORMATION_CATEGORY = ? ");
		sqlStr.append("AND    CO_INFORMATION_PAGE_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_deleteInfo = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_INFORMATION_PAGE_ID, CO_INFORMATION_CATEGORY, CO_INFORMATION_TYPE, ");
		sqlStr.append("       CO_DESCRIPTION, CO_FUNCTION_ID, CO_FUNCTION_URL, CO_DOCUMENT_ID, CO_DOCUMENT_URL, CO_TARGET_CONTENT ");
		sqlStr.append("FROM   CO_INFORMATION_PAGE ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_INFORMATION_PAGE_ID = ? ");
		sqlStr.append("AND    CO_INFORMATION_CATEGORY = ? ");
		sqlStr_getInfo = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_DESCRIPTION,CO_LOCATION ");
		sqlStr.append("FROM   CO_DOCUMENT ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_DOCUMENT_ID = ? ");
		sqlStr_getdocDETAILS = sqlStr.toString();
	}
}