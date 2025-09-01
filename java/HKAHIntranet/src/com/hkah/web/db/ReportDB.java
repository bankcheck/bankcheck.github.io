package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class ReportDB {
	private static String sqlStr_addReport = null;
	
	private static String sqlStr_deleteReport = null;
	
	private static String sqlStr_getReport = null;
	
	/***********************Get Auto-ID***********************/
	
	private static String getNextReportID() {
		String reportID = null;
		
		ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(CO_REPORT_ID) + 1 FROM CO_REPORT");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			reportID = reportableListObject.getValue(0);

			// set 1 for initial
			if (reportID == null || reportID.length() == 0) return "1";
		}
		return reportID;
	}
	
	/********************************************************/
	
	public static String addReport(UserBean userBean, String reportType, String templateID) {
		String reportID = getNextReportID();
		
		boolean added = UtilDBWeb.updateQueue(sqlStr_addReport, 
						new String[]{ConstantsServerSide.SITE_CODE, reportID, reportType,
							templateID,	userBean.getLoginID(), userBean.getLoginID()});
		
		if(added) {
			return reportID;
		}
		else {
			return null;
		}
	}
	
	public static boolean deleteReport(UserBean userBean, String reportID) {
		
		return UtilDBWeb.updateQueue(sqlStr_deleteReport, 
					new String[]{userBean.getLoginID(), reportID});
	}
	
	public static ArrayList getReport(String reportType, String dateFrom, String dateTo,String patNo,String fName,String gName) {
		String sql = sqlStr_getReport;
		
		if(patNo != null && patNo.length() > 0 ){
			sql += "AND "+ 
				   "(SELECT CO_TEMPLATE_RECORD_VALUE FROM CO_TEMPLATE_RECORD "+
				   "WHERE CO_REPORT_ID = R.CO_REPORT_ID "+
				   "AND   CO_TEMPLATE_CONTENT_ID = '2' "+
				   "AND   ENABLE = '1') LIKE '%"+patNo+"%'";
		}
		if(fName != null && fName.length() > 0 ){
			sql += "AND UPPER("+ 
				   "(SELECT CO_TEMPLATE_RECORD_VALUE FROM CO_TEMPLATE_RECORD "+
				   "WHERE CO_REPORT_ID = R.CO_REPORT_ID "+
				   "AND   CO_TEMPLATE_CONTENT_ID = '3' "+
				   "AND   ENABLE = '1')) "+
				   "LIKE '%'|| UPPER(TRIM('"+fName+"')) || '%'";
		}
		if(gName != null && gName.length() > 0 ){
			sql += "AND UPPER("+ 
				   "(SELECT CO_TEMPLATE_RECORD_VALUE FROM CO_TEMPLATE_RECORD "+
				   "WHERE CO_REPORT_ID = R.CO_REPORT_ID "+
				   "AND   CO_TEMPLATE_CONTENT_ID = '5' "+
				   "AND   ENABLE = '1')) "+
				   "LIKE '%'|| UPPER(TRIM('"+gName+"')) ||'%'";
		}
		
		if(dateFrom != null && dateFrom.length() > 0) {
			sql += "AND R.CREATE_DATE >= TO_DATE('"+dateFrom+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ";
		}
		
		if(dateTo != null && dateTo.length() > 0) {
			sql += "AND R.CREATE_DATE <= TO_DATE('"+dateTo+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') "; 
		}
		
		sql += "ORDER BY R.CO_REPORT_ID DESC ";
				
		return UtilDBWeb.getReportableList(sql, 
					new String[]{reportType, ConstantsServerSide.SITE_CODE});
	}
	
	static {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_REPORT( ");
		sqlStr.append("CO_SITE_CODE, CO_REPORT_ID, CO_REPORT_TYPE, CO_TEMPLATE_ID, ");
		sqlStr.append("CREATE_USER, MODIFIED_USER) ");
		sqlStr.append("VALUES ( ");
		sqlStr.append("?, ?, ?, ?, ?, ?) ");
		sqlStr_addReport = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_REPORT ");
		sqlStr.append("SET ENABLE = '0', ");
		sqlStr.append("MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("MODIFIED_USER = ? ");
		sqlStr.append("WHERE ENABLE = '1' ");
		sqlStr.append("AND CO_REPORT_ID = ? ");
		sqlStr_deleteReport = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT R.CO_SITE_CODE, R.CO_REPORT_ID, R.CO_REPORT_TYPE, R.CO_TEMPLATE_ID, ");
		sqlStr.append("R.CREATE_DATE, TO_CHAR(R.CREATE_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("R.CREATE_USER, R.MODIFIED_DATE, TO_CHAR(R.MODIFIED_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("R.MODIFIED_USER, S.CO_STAFFNAME, R.ENABLE, T.CO_TEMPLATE_NAME, ");
		sqlStr.append("(SELECT CO_TEMPLATE_RECORD_VALUE FROM CO_TEMPLATE_RECORD ");
		sqlStr.append("WHERE CO_REPORT_ID = R.CO_REPORT_ID ");
		sqlStr.append("AND   CO_TEMPLATE_CONTENT_ID = '2' ");
		sqlStr.append("AND   ENABLE = '1') AS PATIENT_NO, ");
		sqlStr.append("(SELECT CO_TEMPLATE_RECORD_VALUE FROM CO_TEMPLATE_RECORD ");
		sqlStr.append("WHERE CO_REPORT_ID = R.CO_REPORT_ID ");
		sqlStr.append("AND   CO_TEMPLATE_CONTENT_ID = '3' ");
		sqlStr.append("AND   ENABLE = '1') AS FAMILY_NAME, ");
		sqlStr.append("(SELECT CO_TEMPLATE_RECORD_VALUE FROM CO_TEMPLATE_RECORD ");
		sqlStr.append("WHERE CO_REPORT_ID = R.CO_REPORT_ID ");
		sqlStr.append("AND   CO_TEMPLATE_CONTENT_ID = '5' ");
		sqlStr.append("AND   ENABLE = '1') AS GIVEN_NAME ");
		sqlStr.append("FROM CO_REPORT R, CO_USERS U, CO_STAFFS S, CO_TEMPLATE T ");
		sqlStr.append("WHERE R.ENABLE = '1' ");
		sqlStr.append("AND U.CO_STAFF_ID = S.CO_STAFF_ID(+) ");
		sqlStr.append("AND U.CO_USERNAME(+) = R.MODIFIED_USER ");
		sqlStr.append("AND R.CO_REPORT_TYPE = ? ");
		sqlStr.append("AND R.CO_SITE_CODE = ? ");
		sqlStr.append("AND T.CO_TEMPLATE_ID = R.CO_TEMPLATE_ID ");
		sqlStr_getReport = sqlStr.toString();
	}
}
