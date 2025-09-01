package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class TemplateDB {
	private static String sqlStr_addTemplate = null;
	private static String sqlStr_addTemplateCategory = null;
	private static String sqlStr_addTemplateContent = null;
	private static String sqlStr_addTemplateRecord = null;
	
	private static String sqlStr_updateTemplate = null;
	private static String sqlStr_updateTemplateCategory = null;
	private static String sqlStr_updateTemplateContent = null;
	
	private static String sqlStr_deleteTemplate = null;
	private static String sqlStr_deleteTemplateCategory = null;
	private static String sqlStr_deleteTemplateContent = null;
	private static String sqlStr_deleteTemplateRecord = null;
	
	private static String sqlStr_getTemplate = null;
	private static String sqlStr_getTemplateCategory = null;
	private static String sqlStr_getTemplateContent = null;
	private static String sqlStr_getTemplatePage = null; 
	private static String sqlStr_getTemplateView = null;
	
	/***********************Get Auto-ID***********************/
	
	private static String getNextTemplateID() {
		String templateID = null;

		ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(CO_TEMPLATE_ID) + 1 FROM CO_TEMPLATE");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			templateID = reportableListObject.getValue(0);

			// set 1 for initial
			if (templateID == null || templateID.length() == 0) return "1";
		}
		return templateID;
	}
	
	private static String getNextTemplateCategoryID() {
		String templateCategoryID = null;
		
		ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(CO_TEMPLATE_CATEGORY_ID) + 1 FROM CO_TEMPLATE_CATEGORY");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			templateCategoryID = reportableListObject.getValue(0);

			// set 1 for initial
			if (templateCategoryID == null || templateCategoryID.length() == 0) return "1";
		}
		return templateCategoryID;
	}
	
	private static String getNextTemplateContentID() {
		String templateContentID = null;
		
		ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(CO_TEMPLATE_CONTENT_ID) + 1 FROM CO_TEMPLATE_CONTENT");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			templateContentID = reportableListObject.getValue(0);

			// set 1 for initial
			if (templateContentID == null || templateContentID.length() == 0) return "1";
		}
		return templateContentID;
	}
	
	private static String getNextTemplateRecordID() {
		String templateRecordID = null;
		
		ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(CO_TEMPLATE_RECORD_ID) + 1 FROM CO_TEMPLATE_RECORD");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			templateRecordID = reportableListObject.getValue(0);

			// set 1 for initial
			if (templateRecordID == null || templateRecordID.length() == 0) return "1";
		}
		return templateRecordID;
	}
	
	/********************************************************/
	
	/************************Template************************/
	
	public static String addTemplate(UserBean userBean, String type, String name, 
										String defaultDisplay) {
		String templateID = getNextTemplateID();
		
		boolean added = UtilDBWeb.updateQueue(sqlStr_addTemplate, 
							new String[]{ConstantsServerSide.SITE_CODE, type, templateID,
									name, defaultDisplay, 
									userBean.getLoginID(), userBean.getLoginID()});
		if(added) {
			return templateID;
		}
		else {
			return null;
		}
	}
	
	public static boolean updateTemplate(UserBean userBean, String templateID, 
								String type, String name, String defaultDisplay) {
		return UtilDBWeb.updateQueue(sqlStr_updateTemplate, 
					new String[]{type, name, defaultDisplay, userBean.getLoginID(), templateID});
	}
	
	public static boolean deleteTemplate(UserBean userBean, String templateID) {
		return UtilDBWeb.updateQueue(sqlStr_deleteTemplate,
					new String[]{userBean.getLoginID(), templateID});
	}
	
	public static ArrayList getTemplates() {
		return getTemplate(null, null);
	}
	
	public static ArrayList getTemplateByID(String templateID) {
		return getTemplate(templateID, null);
	}
	
	public static ArrayList getTemplateByType(String type) {
		return getTemplate(null, type);
	}
	
	private static ArrayList getTemplate(String templateID, String type) {
		String sql = sqlStr_getTemplate;
		
		if(templateID != null) {
			sql += "AND T.CO_TEMPLATE_ID = '"+templateID+"' ";
		}
		if(type != null) {
			sql += "AND T.CO_TEMPLATE_TYPE = '"+type+"' ";
		}
		
		//System.out.println(sql);
		return UtilDBWeb.getReportableList(sql);
	}
	
	public static ArrayList getTemplatePages(String templateID) {
		return UtilDBWeb.getReportableList(sqlStr_getTemplatePage, new String[]{templateID});
	}
	
	/*******************************************************/
	
	/*******************Template Category*******************/
	
	public static String addTemplateCategory(UserBean userBean, String templateID, String name,
							String parentID, String col, String isMulti, String order, 
							String page) {
		String templateCategoryID = getNextTemplateCategoryID();
		
		boolean added = UtilDBWeb.updateQueue(sqlStr_addTemplateCategory, 
							new String[]{templateID, templateCategoryID, name, parentID, col,
								isMulti, order, page, 
								userBean.getLoginID(), userBean.getLoginID()});
		
		if(added) {
			return templateCategoryID;
		}
		else {
			return null;
		}
	}
	
	public static boolean updateTemplateCategory(UserBean userBean, String templateCategoryID, 
								String name, String parentID, String col, String isMulti, 
								String order, String page) {
		return UtilDBWeb.updateQueue(sqlStr_updateTemplateCategory, 
					new String[]{name, parentID, col, isMulti, order, page, 
								userBean.getLoginID(),	templateCategoryID});
	}
	
	public static boolean deleteTemplateCategoryByTemplateID(UserBean userBean, 
								String templateID) {
		return deleteTemplateCategory(userBean, templateID, null);
	}
	
	public static boolean deleteTemplateCategoryByTemplateCategoryID(UserBean userBean, 
								String templateCategoryID) {
		return deleteTemplateCategory(userBean, null, templateCategoryID);
	}
	
	private static boolean deleteTemplateCategory(UserBean userBean, String templateID, 
								String templateCategoryID) {
		String sqlStr = sqlStr_deleteTemplateCategory;
		
		if(templateID != null) {
			sqlStr += "AND CO_TEMPLATE_ID = '"+templateID+"' ";
		}
		if(templateCategoryID != null) {
			sqlStr += "AND CO_TEMPLATE_CATEGORY_ID = '"+templateCategoryID+"' ";
		}
		
		return UtilDBWeb.updateQueue(sqlStr, new String[]{userBean.getLoginID()});
	}
	
	public static ArrayList getTemplateCategorys() {
		return getTemplateCategory(null, null, null);
	}
	
	public static ArrayList getTemplateCategoryByTemplateID(String templateID) {
		return getTemplateCategory(templateID, null, null);
	}
	
	public static ArrayList getTemplateCategoryByParentID(String parentID) {
		return getTemplateCategory(null, null, parentID);
	}
	
	public static ArrayList getTemplateCategoryByTemplateCategoryID(String templateCategoryID) {
		return getTemplateCategory(null, templateCategoryID, null);
	}
	
	private static ArrayList getTemplateCategory(String templateID, String templateCategoryID,
									String parentID) {
		String sql = sqlStr_getTemplateCategory;
		
		if(templateID != null) {
			sql += "AND T.CO_TEMPLATE_ID = '"+templateID+"' ";
		}
		if(templateCategoryID != null) {
			sql += "AND T.CO_TEMPLATE_CATEGORY_ID = '"+templateCategoryID+"' ";
		}
		if(parentID != null) {
			sql += "AND T.CO_PARENT_ID = '"+parentID+"' ";
		}
		else {
			sql += "AND T.CO_PARENT_ID IS NULL ";
		}
		sql += "ORDER BY T.CO_ORDER ";
		
		//System.out.println(sql);
		return UtilDBWeb.getReportableList(sql);
	}
	
	public static ArrayList getAllTemplateCategory(String templateID) {
		String sql = sqlStr_getTemplateCategory;
		
		sql += "AND T.CO_TEMPLATE_ID = '"+templateID+"' ";
		sql += "ORDER BY T.CO_ORDER ";
		
		return UtilDBWeb.getReportableList(sql);
	}
	
	/*******************************************************/
	
	/********************Template Content*******************/
	
	public static String addTemplateContent(UserBean userBean, String templateCategoryID, 
								String prompt, String format, String parentID, String remarks,
								String needVal, String valRef, String col, String promptWidth,
								String width, String height, 
								String align, String isMulti, String order, String level, String require) {
		String templateContentID = getNextTemplateContentID();
		
		boolean added = UtilDBWeb.updateQueue(sqlStr_addTemplateContent, 
							new String[]{templateCategoryID, templateContentID, prompt, format,
								parentID, remarks, needVal, valRef, col, promptWidth, 
								width, height, align, isMulti,
								order, level, require, userBean.getLoginID(), userBean.getLoginID()});
		
		if(added) {
			return templateContentID;
		}
		else {
			return null;
		}
	}
	
	public static boolean updateTemplateContent(UserBean userBean, String templateContentID,
								String prompt, String format, String parentID, String remarks,
								String needVal, String valRef, String col, String promptWidth, 
								String width, String height, 
								String align, String isMulti, String order, String level, String require) {
		return UtilDBWeb.updateQueue(sqlStr_updateTemplateContent, 
					new String[]{prompt, format, parentID, remarks, needVal, valRef, col, promptWidth, 
									width, height, align, isMulti, order, level, require, 
									userBean.getLoginID(),
									templateContentID});
	}
	
 	public static boolean deleteTemplateContentByTemplateCategoryID(UserBean userBean, 
								String templateCategoryID) {
		return deleteTemplateContent(userBean, templateCategoryID, null);
	}
	
	public static boolean deleteTemplateContentByTemplateContentID(UserBean userBean, 
								String templateContentID) {
		return deleteTemplateContent(userBean, null, templateContentID);
	}
	
	private static boolean deleteTemplateContent(UserBean userBean, String templateCategoryID, 
								String templateContentID) {
		String sqlStr = sqlStr_deleteTemplateContent;
		
		if(templateCategoryID != null) {
			sqlStr += "AND CO_TEMPLATE_CATEGORY_ID = '"+templateCategoryID+"' ";
		}
		if(templateContentID != null) {
			sqlStr += "AND CO_TEMPLATE_CONTENT_ID = '"+templateContentID+"' ";
		}
		
		return UtilDBWeb.updateQueue(sqlStr, new String[]{userBean.getLoginID()});
	}
	
	public static ArrayList getTemplateContents() {
		return getTemplateContent(null, null, null);
	}
	
	public static ArrayList getTemplateContentByTemplateCategoryID(String templateCategoryID) {
		return getTemplateContent(templateCategoryID, null, null);
	}
	
	public static ArrayList getTemplateContentByParentID(String parentID) {
		return getTemplateContent(null, null, parentID);
	}
	
	public static ArrayList getTemplateContentByTemplateContentID(String templateContentID) {
		return getTemplateContent(null, templateContentID, null);
	}
	
	private static ArrayList getTemplateContent(String templateCategoryID, 
									String templateContentID, String parentID) {
		String sql = sqlStr_getTemplateContent;
		
		if(templateCategoryID != null) {
			sql += "AND T.CO_TEMPLATE_CATEGORY_ID = '"+templateCategoryID+"' ";
		}
		if(templateContentID != null) {
			sql += "AND T.CO_TEMPLATE_CONTENT_ID = '"+templateContentID+"' ";
		}
		if(parentID != null) {
			sql += "AND T.CO_PARENT_ID = '"+parentID+"' ";
		}
		else {
			sql += "AND T.CO_PARENT_ID IS NULL ";
		}
		sql += "ORDER BY T.CO_ORDER ";
		
		//System.out.println(sql);
		return UtilDBWeb.getReportableList(sql);
	}
	
	public static ArrayList getAllTemplateContent(String templateID) {
		String sql = sqlStr_getTemplateContent;
		
		sql += "AND T.CO_TEMPLATE_CATEGORY_ID IN (SELECT CO_TEMPLATE_CATEGORY_ID FROM (";
		sql += sqlStr_getTemplateCategory;
		sql += "AND T.CO_TEMPLATE_ID = '"+templateID+"' ";
		sql += "ORDER BY T.CO_ORDER)) ";
		sql += "ORDER BY T.CO_TEMPLATE_CATEGORY_ID, T.CO_ORDER ";
		
		return UtilDBWeb.getReportableList(sql);
	}
	
	public static boolean hasTemplateContent(String templateCategoryID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM CO_TEMPLATE_CONTENT ");
		sqlStr.append("WHERE CO_TEMPLATE_CATEGORY_ID = '"+templateCategoryID+"' ");
		
		return UtilDBWeb.isExist(sqlStr.toString());
	}
	
	/*******************************************************/
	
	/********************Template Record********************/
	
	public static String addTemplateRecord(UserBean userBean, String reportID, 
								String templateContentID, String group, String value) {
		String templateRecordID = getNextTemplateRecordID();
		
		boolean added = UtilDBWeb.updateQueue(sqlStr_addTemplateRecord, 
								new String[] {reportID, templateContentID, templateRecordID, 
									group, value, userBean.getLoginID(), userBean.getLoginID()});
		
		if(added) {
			return templateRecordID;
		}
		else {
			return null;
		}
	}
	
	public static ArrayList getTemplateRecordAndContent(String reportID, 
								String tempCategoryID, String parentID, String grpID) {	
		String sql = sqlStr_getTemplateView;
		
		if(parentID != null) {
			sql += "AND T.CO_PARENT_ID = '"+parentID+"' ";
		}
		else {
			sql += "AND T.CO_PARENT_ID IS NULL ";
		}
		sql += "ORDER BY T.CO_ORDER, R.CO_TEMPLATE_RECORD_GROUP,R.CO_TEMPLATE_RECORD_ID ";	
		
		return UtilDBWeb.getReportableList(sql, new String[] {reportID, grpID, tempCategoryID});
	}
	
	public static boolean deleteTemplateRecord(UserBean userBean, String reportID) {
		
		return UtilDBWeb.updateQueue(sqlStr_deleteTemplateRecord, 
						new String[]{userBean.getLoginID(), reportID});
	}
	
	/*******************************************************/
	
	static {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_TEMPLATE( ");
		sqlStr.append("CO_SITE_CODE, CO_TEMPLATE_TYPE, CO_TEMPLATE_ID, CO_TEMPLATE_NAME, ");
		sqlStr.append("CO_DEFAULT_DISPLAY, ");
		sqlStr.append("CREATE_USER, MODIFIED_USER) ");
		sqlStr.append("VALUES ( ");
		sqlStr.append("?, ?, ?, ?, ?, ?, ?) ");
		sqlStr_addTemplate = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_TEMPLATE_CATEGORY( ");
		sqlStr.append("CO_TEMPLATE_ID, CO_TEMPLATE_CATEGORY_ID, CO_TEMPLATE_CATEGORY_NAME, ");
		sqlStr.append("CO_PARENT_ID, CO_STYLE_COLUMN, CO_IS_MULTI, CO_ORDER, CO_PAGE, ");
		sqlStr.append("CREATE_USER, MODIFIED_USER) ");
		sqlStr.append("VALUES ( ");
		sqlStr.append("?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ");
		sqlStr_addTemplateCategory = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_TEMPLATE_CONTENT( ");
		sqlStr.append("CO_TEMPLATE_CATEGORY_ID, CO_TEMPLATE_CONTENT_ID, ");
		sqlStr.append("CO_TEMPLATE_CONTENT_PROMPT, CO_TEMPLATE_CONTENT_FORMAT, CO_PARENT_ID, ");
		sqlStr.append("CO_TEMPLATE_CONTENT_REMARKS, CO_NEED_VAL, CO_VAL_REF, CO_STYLE_COLUMN, ");
		sqlStr.append("CO_STYLE_PROMPT_WIDTH, CO_STYLE_WIDTH, CO_STYLE_HEIGHT, CO_STYLE_ALIGN, ");
		sqlStr.append("CO_IS_MULTI, CO_ORDER, CO_LEVEL, CO_REQUIRE, ");
		sqlStr.append("CREATE_USER, MODIFIED_USER) ");
		sqlStr.append("VALUES ( ");
		sqlStr.append("?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ");
		sqlStr_addTemplateContent = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_TEMPLATE_RECORD( ");
		sqlStr.append("CO_REPORT_ID, CO_TEMPLATE_CONTENT_ID, CO_TEMPLATE_RECORD_ID, ");
		sqlStr.append("CO_TEMPLATE_RECORD_GROUP, ");
		sqlStr.append("CO_TEMPLATE_RECORD_VALUE, CREATE_USER, MODIFIED_USER) ");
		sqlStr.append("VALUES ( ");
		sqlStr.append("?, ?, ?, ?, ?, ?, ?) ");
		sqlStr_addTemplateRecord = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_TEMPLATE ");
		sqlStr.append("SET CO_TEMPLATE_TYPE = ?, CO_TEMPLATE_NAME = ?, CO_DEFAULT_DISPLAY = ?, ");
		sqlStr.append("MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? ");
		sqlStr.append("WHERE CO_TEMPLATE_ID = ? ");
		sqlStr_updateTemplate = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_TEMPLATE_CATEGORY ");
		sqlStr.append("SET CO_TEMPLATE_CATEGORY_NAME = ?, CO_PARENT_ID = ?, ");
		sqlStr.append("CO_STYLE_COLUMN = ?, CO_IS_MULTI = ?, CO_ORDER = ?, CO_PAGE = ?, ");
		sqlStr.append("MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? ");
		sqlStr.append("WHERE CO_TEMPLATE_CATEGORY_ID = ? ");
		sqlStr_updateTemplateCategory = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_TEMPLATE_CONTENT ");
		sqlStr.append("SET CO_TEMPLATE_CONTENT_PROMPT = ?, CO_TEMPLATE_CONTENT_FORMAT = ?, ");
		sqlStr.append("CO_PARENT_ID = ?, CO_TEMPLATE_CONTENT_REMARKS = ?, CO_NEED_VAL = ?, ");
		sqlStr.append("CO_VAL_REF = ?, CO_STYLE_COLUMN = ?, CO_STYLE_PROMPT_WIDTH = ?, ");
		sqlStr.append("CO_STYLE_WIDTH = ?, CO_STYLE_HEIGHT = ?, ");
		sqlStr.append("CO_STYLE_ALIGN = ?, CO_IS_MULTI = ?, CO_ORDER = ?, CO_LEVEL = ?, CO_REQUIRE = ?, ");
		sqlStr.append("MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? ");
		sqlStr.append("WHERE CO_TEMPLATE_CONTENT_ID = ? ");
		sqlStr_updateTemplateContent = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_TEMPLATE ");
		sqlStr.append("SET ENABLE = '0', ");
		sqlStr.append("MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("MODIFIED_USER = ? ");
		sqlStr.append("WHERE CO_TEMPLATE_ID = ? ");
		sqlStr_deleteTemplate = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_TEMPLATE_CATEGORY ");
		sqlStr.append("SET ENABLE = '0', ");
		sqlStr.append("MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("MODIFIED_USER = ? ");
		sqlStr.append("WHERE ENABLE = '1' ");
		sqlStr_deleteTemplateCategory = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_TEMPLATE_CONTENT ");
		sqlStr.append("SET ENABLE = '0', ");
		sqlStr.append("MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("MODIFIED_USER = ? ");
		sqlStr.append("WHERE ENABLE = '1' ");
		sqlStr_deleteTemplateContent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT T.CO_SITE_CODE, T.CO_TEMPLATE_TYPE, T.CO_TEMPLATE_ID, ");
		sqlStr.append("T.CO_TEMPLATE_NAME, T.CREATE_DATE, ");
		sqlStr.append("TO_CHAR(T.CREATE_DATE, 'DD/MM/YYYY HH24:MI:SS'), T.CREATE_USER, ");
		sqlStr.append("T.MODIFIED_DATE, TO_CHAR(T.MODIFIED_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("T.MODIFIED_USER, S.CO_STAFFNAME, T.ENABLE, T.CO_DEFAULT_DISPLAY ");
		sqlStr.append("FROM CO_TEMPLATE T, CO_USERS U, CO_STAFFS S ");
		sqlStr.append("WHERE T.ENABLE = '1' ");
		sqlStr.append("AND U.CO_STAFF_ID = S.CO_STAFF_ID(+) ");
		sqlStr.append("AND U.CO_USERNAME(+) = T.MODIFIED_USER ");
		sqlStr_getTemplate = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT T.CO_TEMPLATE_ID, T.CO_TEMPLATE_CATEGORY_ID, ");
		sqlStr.append("T.CO_TEMPLATE_CATEGORY_NAME, T.CO_PARENT_ID, T.CO_STYLE_COLUMN, ");
		sqlStr.append("T.CO_IS_MULTI, T.CO_ORDER, T.CREATE_DATE, ");
		sqlStr.append("TO_CHAR(T.CREATE_DATE, 'DD/MM/YYYY HH24:MI:SS'), T.CREATE_USER, ");
		sqlStr.append("T.MODIFIED_DATE, TO_CHAR(T.MODIFIED_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("T.MODIFIED_USER, S.CO_STAFFNAME, T.ENABLE, T.CO_PAGE ");
		sqlStr.append("FROM CO_TEMPLATE_CATEGORY T, CO_USERS U, CO_STAFFS S ");
		sqlStr.append("WHERE T.ENABLE = '1' ");
		sqlStr.append("AND U.CO_STAFF_ID = S.CO_STAFF_ID(+) ");
		sqlStr.append("AND U.CO_USERNAME(+) = T.MODIFIED_USER ");
		sqlStr_getTemplateCategory = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT T.CO_TEMPLATE_CATEGORY_ID, T.CO_TEMPLATE_CONTENT_ID, ");
		sqlStr.append("T.CO_TEMPLATE_CONTENT_PROMPT, T.CO_TEMPLATE_CONTENT_FORMAT, ");
		sqlStr.append("T.CO_PARENT_ID, T.CO_TEMPLATE_CONTENT_REMARKS, T.CO_NEED_VAL, ");
		sqlStr.append("T.CO_STYLE_COLUMN, T.CO_STYLE_WIDTH, T.CO_STYLE_HEIGHT, ");
		sqlStr.append("T.CO_IS_MULTI, T.CO_ORDER, T.CO_LEVEL, T.CREATE_DATE, ");
		sqlStr.append("TO_CHAR(T.CREATE_DATE, 'DD/MM/YYYY HH24:MI:SS'), T.CREATE_USER, ");
		sqlStr.append("T.MODIFIED_DATE, TO_CHAR(T.MODIFIED_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("T.MODIFIED_USER, S.CO_STAFFNAME, T.ENABLE, T.CO_REQUIRE, T.CO_VAL_REF, ");
		sqlStr.append("T.CO_STYLE_ALIGN, T.CO_STYLE_PROMPT_WIDTH,T.CO_NUM_ONLY ");
		sqlStr.append("FROM CO_TEMPLATE_CONTENT T, CO_USERS U, CO_STAFFS S ");
		sqlStr.append("WHERE T.ENABLE = '1' ");
		sqlStr.append("AND U.CO_STAFF_ID = S.CO_STAFF_ID(+) ");
		sqlStr.append("AND U.CO_USERNAME(+) = T.MODIFIED_USER ");
		sqlStr_getTemplateContent = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT DISTINCT T.CO_PAGE ");
		sqlStr.append("FROM CO_TEMPLATE_CATEGORY T ");
		sqlStr.append("WHERE T.ENABLE = '1' ");
		sqlStr.append("AND T.CO_TEMPLATE_ID = ? ");
		sqlStr.append("ORDER BY T.CO_PAGE ");
		sqlStr_getTemplatePage = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT T.CO_TEMPLATE_CATEGORY_ID, T.CO_TEMPLATE_CONTENT_ID, ");
		sqlStr.append("T.CO_TEMPLATE_CONTENT_PROMPT, T.CO_TEMPLATE_CONTENT_FORMAT, ");
		sqlStr.append("T.CO_PARENT_ID, T.CO_TEMPLATE_CONTENT_REMARKS, T.CO_NEED_VAL, ");
		sqlStr.append("T.CO_STYLE_COLUMN, T.CO_STYLE_WIDTH, T.CO_STYLE_HEIGHT, ");
		sqlStr.append("T.CO_IS_MULTI, T.CO_ORDER, T.CO_LEVEL, T.CREATE_DATE, ");
		sqlStr.append("TO_CHAR(T.CREATE_DATE, 'DD/MM/YYYY HH24:MI:SS'), T.CREATE_USER, ");
		sqlStr.append("T.MODIFIED_DATE, TO_CHAR(T.MODIFIED_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("T.MODIFIED_USER, S.CO_STAFFNAME, T.ENABLE, T.CO_REQUIRE, T.CO_VAL_REF, ");
		sqlStr.append("T.CO_STYLE_ALIGN, T.CO_STYLE_PROMPT_WIDTH, ");
		sqlStr.append("R.CO_REPORT_ID, R.CO_TEMPLATE_RECORD_ID, R.CO_TEMPLATE_RECORD_VALUE, ");
		sqlStr.append("R.CO_TEMPLATE_RECORD_GROUP,T.CO_NUM_ONLY ");
		sqlStr.append("FROM CO_TEMPLATE_CONTENT T, CO_USERS U, CO_STAFFS S, ");
		sqlStr.append("      (SELECT * FROM CO_TEMPLATE_RECORD WHERE CO_REPORT_ID = ? ");
		sqlStr.append("			AND ENABLE = '1' AND CO_TEMPLATE_RECORD_GROUP = ?) R ");
		sqlStr.append("WHERE T.ENABLE = '1' ");
		sqlStr.append("AND U.CO_STAFF_ID = S.CO_STAFF_ID(+) ");
		sqlStr.append("AND U.CO_USERNAME(+) = T.MODIFIED_USER ");
		sqlStr.append("AND T.CO_TEMPLATE_CATEGORY_ID = ? ");
		sqlStr.append("AND R.CO_TEMPLATE_CONTENT_ID(+) = T.CO_TEMPLATE_CONTENT_ID ");
		sqlStr_getTemplateView = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_TEMPLATE_RECORD ");
		sqlStr.append("SET ENABLE = '0', ");
		sqlStr.append("MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("MODIFIED_USER = ? ");
		sqlStr.append("WHERE ENABLE = '1' ");
		sqlStr.append("AND CO_REPORT_ID = ? ");
		sqlStr_deleteTemplateRecord = sqlStr.toString();
	}
}
