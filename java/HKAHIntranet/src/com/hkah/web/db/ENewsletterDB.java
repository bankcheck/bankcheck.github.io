package com.hkah.web.db;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class ENewsletterDB {

	private static String sqlStr_insertContent = null;
	private static String sqlStr_insertNewsPaper = null;
	private static String sqlStr_updateContent = null;
	private static String sqlStr_deleteContent = null;

	private static String getNextContentID(String enlID, String patientType, String Dept) {
		String contentID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(ENL_CONTENT_ID) + 1 FROM ENEWSLETTER_CONTENT WHERE ENL_ID = ? AND ENL_PATIENT_TYPE = ? AND ENL_DEPT = ? ",
				new String[] { enlID, patientType,Dept });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			contentID = reportableListObject.getValue(0);

			// set 1 for initial
			if (contentID == null || contentID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return contentID;
	}

	public static String addContent(UserBean userBean,
			String enlID, String Dept, String patientType) {

		// get next schedule ID
		String contentID = getNextContentID(enlID, patientType, Dept);
		System.out.println("[contentID]"+contentID);

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertContent,
				new String[] { enlID, patientType,Dept, contentID,
						userBean.getLoginID(), userBean.getLoginID() })) {
			return contentID;
		} else {
			return null;
		}
	}

	public static boolean updateContent(UserBean userBean,
			String enlID, String patientType, String contentID,
			String Dept, String contentTitle, String contentURL,
			String contentDesc) {

		// try to update selected record
		if (UtilDBWeb.updateQueue(
				sqlStr_updateContent,
				new String[] {
						contentTitle, contentURL, contentDesc, userBean.getLoginID(),
						contentID, Dept,enlID, patientType })) {

			return true;
		} else {
			return false;
		}
	}

	public static boolean deleteContent(UserBean userBean,
			String contentID, String Dept, String enlID, String patientType) {

		// try to delete content
		return UtilDBWeb.updateQueue(
				sqlStr_deleteContent,
				new String[] {
						contentID, Dept, enlID, patientType });
	}

	public static ArrayList getColumnTitle(String enlID, String patientType){

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT ENL_DEPT ");
		sqlStr.append(" FROM ENEWSLETTER_CONTENT ");
		sqlStr.append(" WHERE ENL_ID = "+ enlID );
		sqlStr.append(" AND ENL_PATIENT_TYPE = "+ patientType );
		sqlStr.append(" ORDER BY ENL_DEPT ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getColumnContent(String enlID, String patientType, String Dept){

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ENL_CONTENT_TITLE, ENL_CONTENT_URL ");
		sqlStr.append(" FROM ENEWSLETTER_CONTENT ");
		sqlStr.append(" WHERE ENL_ID = "+enlID);
		sqlStr.append(" AND ENL_PATIENT_TYPE = "+patientType );
		if (Dept != null && Dept.length() > 0) {
		sqlStr.append(" AND ENL_DEPT = '"+Dept+"'" );
		}
		sqlStr.append(" ORDER BY ENL_CONTENT_ID ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getContent(String enlID, String patientType, String Dept, String contentID){

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ENL_CONTENT_TITLE, ENL_CONTENT_URL, ENL_CONTENT_DESC ");
		sqlStr.append(" FROM ENEWSLETTER_CONTENT ");
		sqlStr.append(" WHERE ENL_ID = "+enlID );
		sqlStr.append(" AND ENL_PATIENT_TYPE = "+patientType );
		sqlStr.append(" AND ENL_CONTENT_ID = "+contentID );
		sqlStr.append(" AND ENL_DEPT = '"+Dept+"'" );
		sqlStr.append(" ORDER BY ENL_CONTENT_ID ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getIssue(String patientType){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ENL_ID, ENL_TITLE ");
		sqlStr.append("FROM ENEWSLETTER ");
		sqlStr.append("WHERE ENL_PATIENT_TYPE = "+patientType );
		sqlStr.append("ORDER BY ENL_ID ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getIssueContent(String enlID, String patientType, String Dept){

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ENL_CONTENT_TITLE, ENL_CONTENT_URL, ENL_DEPT, ENL_CONTENT_ID ");
		sqlStr.append(" FROM ENEWSLETTER_CONTENT ");
		sqlStr.append(" WHERE ENL_ID = "+enlID);
		sqlStr.append(" AND ENL_PATIENT_TYPE = "+patientType );
		if (Dept != null && Dept.length() > 0) {
		sqlStr.append(" AND ENL_DEPT = '"+Dept+"'" );
		}
		sqlStr.append(" ORDER BY ENL_CONTENT_ID ");

		System.out.println(sqlStr);

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean generateNewsLetter(String enlID, String patientType, String email) {


		StringBuffer commentStr = new StringBuffer();
		commentStr.append("<table ><tr><td width=\"900\"><img width=850 height=137 src=\"file://www-server/document/Upload/E-Newsletter/header.jpg\" " +
		   "alt=\"Hong Kong Adventist Hospital\"");
		commentStr.append("></table>");
		commentStr.append("<table><tr>");
		commentStr.append("<td width=900 colspan=3 style='background:#990033;padding:0cm 1.4pt 0cm 1.4pt;height:24.75pt'>");
		commentStr.append("<p align=center style='text-align:center;text-indent:6.0pt;'><span  style='font-family:\"Arial Black\";color:white'>E- Newsletter</span></p>");
		commentStr.append("</td></tr>");

		ArrayList result = getColumnTitle(enlID, patientType);
		Map<Integer, String> deptList = new HashMap<Integer, String>();
		if (result.size() > 0) {
		ReportableListObject reportableListObject = null;

		commentStr.append("<tr style='height:15.0pt'>");
		int count = 0;
		for (int i = 0; i < result.size(); i++) {
			reportableListObject = (ReportableListObject) result.get(i);
			String dept = reportableListObject.getValue(0);
			deptList.put(count, dept);
			if(count<3){
			commentStr.append(generateFieldTitle(dept));
			count++;
			}
			if((count%3 == 0)|| i==result.size()-1){
			 commentStr.append("<tr>");
			 for(int k=0;k<count;k++){
			 commentStr.append(generateColumn(deptList.get(k),enlID,patientType));
			 }
			 commentStr.append("</tr><tr>");
			 count=0;

			}
		  }
		}
		commentStr.append("</tr>");
		commentStr.append("</table>");

		UtilMail.sendMail(
				"admission@hkah.org.hk",
				new String[] {email},
				null,
				null,
				"E - Newsletter",
				commentStr.toString());
		return true;
	}

	public static String generateFieldTitle(String FieldDisplay) {

		String commentStr = "";

		commentStr += "<td width=300  valign=top style='background:#CC0066;padding:0cm 1.4pt 0cm 1.4pt;height:15.0pt'>";
		commentStr += "<p align=center style='text-align:center;text-indent:6.0pt;'><span  style='font-family:\"Arial Black\";color:white'>";
		commentStr += FieldDisplay+"</span></p>";
		commentStr += "</td>";
		return commentStr;
	}

	public static String generateFieldContent (String message, String link){

		String commentStr = "<p><span style='font-size:9.0pt;'>";
		commentStr += "<img width=17 height=16 src=\"file://www-server/document/Upload/E-Newsletter/icon.gif\">";
		commentStr += "<a href=\"" + link + "\">";
		commentStr += message;
		commentStr += "</a>";
		commentStr += "</span>";
		commentStr += "</p>";

		return commentStr;

	}

	public static String generateColumn(String Dept,String enlID, String patientType){
		String commentStr = "";
		ArrayList result = getColumnContent(enlID,patientType,Dept);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = null;
			commentStr +="<td width=\"300\" valign=\"top\" style=\"border-top:solid #CC0066 1.0pt;border-left:solid #CC0066 1.0pt;border-right:solid #CC0066 1.0pt;border-bottom:solid #CC0066 1.0pt;padding:0cm 1.4pt 0cm 1.4pt;height:163.6pt\">";
			for (int i = 0; i < result.size(); i++) {
				reportableListObject = (ReportableListObject) result.get(i);
				commentStr += generateFieldContent(reportableListObject.getValue(0), reportableListObject.getValue(1));
			}
			commentStr+=("</tr>");
		}

		return commentStr;

	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO ENEWSLETTER_CONTENT ");
		sqlStr.append("(ENL_ID, ENL_PATIENT_TYPE,ENL_DEPT,ENL_CONTENT_ID,  ");
		sqlStr.append("ENL_CREATED_USER, ENL_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ");
		sqlStr.append("?, ?)");
		sqlStr_insertContent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE ENEWSLETTER_CONTENT ");
		sqlStr.append("SET    ENL_CONTENT_TITLE = ?, ");
		sqlStr.append("       ENL_CONTENT_URL = ?, ENL_CONTENT_DESC = ?,  ");
		sqlStr.append("       ENL_MODIFIED_DATE = SYSDATE, ENL_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  ENL_CONTENT_ID = ? ");
		sqlStr.append("AND    ENL_DEPT = ? ");
		sqlStr.append("AND    ENL_ID = ? ");
		sqlStr.append("AND    ENL_PATIENT_TYPE = ? ");
		sqlStr.append("AND    ENL_ENABLED = 1 ");
		sqlStr_updateContent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM ENEWSLETTER_CONTENT ");
		sqlStr.append("WHERE  ENL_CONTENT_ID = ? ");
		sqlStr.append("AND    ENL_DEPT = ? ");
		sqlStr.append("AND    ENL_ID = ? ");
		sqlStr.append("AND    ENL_PATIENT_TYPE = ? ");
		sqlStr.append("AND    ENL_ENABLED = 1 ");
		sqlStr_deleteContent = sqlStr.toString();
	}
}