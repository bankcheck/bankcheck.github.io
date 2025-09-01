/*
 * Created on April 9, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ChapStaffDB {
	
	public static ArrayList getStaffListWithParam(UserBean userBean,String staffID,String staffName,String deptCode){
		return getStaffList(userBean,staffID,staffName,deptCode);
	}
	
	public static ArrayList getStaffListByID(UserBean userBean,String staffID){
		return getStaffList(userBean,staffID,null,null);
	}

	public static ArrayList getStaffList(UserBean userBean,String staffID,String staffName,String deptCode) {
		String siteCode = ConstantsServerSide.SITE_CODE;
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT S.CO_SITE_CODE, D.CO_DEPARTMENT_DESC, S.CO_STAFF_ID, S.CO_STAFFNAME ");
		sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		if (siteCode != null && siteCode.length() > 0) {
			sqlStr.append("AND    S.CO_SITE_CODE = '" + siteCode + "' ");
		}
		if (deptCode != null && deptCode.length() > 0) {
			if(!deptCode.equals("ALL"))
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '" + deptCode + "' ");
		}
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND    S.CO_STAFF_ID = '" + staffID + "' ");
		}
		if (staffName != null && staffName.length() > 0){
			sqlStr.append("AND UPPER(TRIM(S.CO_STAFFNAME )) LIKE UPPER('%"+ staffName + "%') ");
		}
		sqlStr.append("ORDER BY S.CO_DEPARTMENT_CODE, S.CO_STAFFNAME");
		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
		
	private static String getNextStaffServiceID() {
		String ssID = null;

		ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(PSID) + 1 FROM PAT_SERVICES");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			ssID = reportableListObject.getValue(0);

			// set 1 for initial
			if (ssID == null || ssID.length() == 0) return "1";
		}
		return ssID;
	}
	
	public static boolean addChaplaincyService(UserBean userBean, String patNo, String patName,
			String status, String remark,
			String serCategory, String serItem, String effectiveDate,String effectiveTime) {

	return addStaffService(userBean, "chaplaincy", patNo, patName,
			status, remark, serCategory, serItem,effectiveDate, effectiveTime);
	}

	private static boolean addStaffService(UserBean userBean, String serType,
			String patNo, String patName,
			String status, String remark, String serCategory, String serItem,
			String effectiveDate, String effectiveTime) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO PAT_SERVICES( ");
		sqlStr.append("CO_SITE_CODE, PSID, PATNO, PATIENT_NAME, ");
		sqlStr.append("SERVICE_TYPE, SERVICE_CATEGORY, SERVICE_ITEM, STATUS, REMARK, ");
		sqlStr.append("EFFECTIVE_DATE, CREATE_USER, MODIFIED_USER, ISSTAFF) ");
		sqlStr.append("VALUES ( ");
		sqlStr.append("'" + ConstantsServerSide.SITE_CODE + "', '"
				+ getNextStaffServiceID() + "' ");
		if (patNo != null && patNo.length() > 0) {
			sqlStr.append(", '" + patNo + "' ");
		} else {
			sqlStr.append(", NULL ");
		}

		if (patName != null && patName.length() > 0) {
			sqlStr.append(", '" + patName.replaceAll("'", "''") + "' ");
		} else {
			sqlStr.append(", NULL ");
		}		

		if (serType != null && serType.length() > 0) {
			sqlStr.append(", '" + serType + "' ");
		} else {
			sqlStr.append(", NULL ");
		}

		if (serCategory != null && serCategory.length() > 0) {
			sqlStr.append(", '" + serCategory + "' ");
		} else {
			sqlStr.append(", NULL ");
		}

		if (serItem != null && serItem.length() > 0) {
			sqlStr.append(", '" + serItem + "' ");
		} else {
			sqlStr.append(", NULL ");
		}

		if (status != null && status.length() > 0) {
			sqlStr.append(", '" + status + "' ");
		} else {
			sqlStr.append(", NULL ");
		}

		if (remark != null && remark.length() > 0) {
			sqlStr.append(", '" + remark.replaceAll("'", "''") + "' ");
		} else {
			sqlStr.append(", NULL ");
		}

		if (effectiveDate != null && effectiveDate.length() > 0) {
			if (effectiveTime != null && effectiveTime.length() > 0) {
				sqlStr.append(", TO_DATE('" + effectiveDate + " "
						+ effectiveTime + "', 'DD/MM/YYYY HH24:MI') ");
			} else {
				sqlStr.append(", TO_DATE('"
						+ effectiveDate
						+ " ' ||TO_CHAR(SYSDATE, 'HH24:MI'), 'DD/MM/YYYY HH24:MI') ");
			}
		} else {
			sqlStr.append(", SYSDATE ");
		}

		sqlStr.append(", '" + userBean.getLoginID() + "', '"
				+ userBean.getLoginID() + "',1) ");

		// System.out.println(sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	
	public static ArrayList checkStaffInvolvement(String staffID,String type,String subType){
		StringBuffer sqlStr = new StringBuffer();
				
		sqlStr.append("SELECT * ");	
		sqlStr.append("FROM CO_STAFF_INVOLVEMENT ");
		sqlStr.append("WHERE CO_STAFF_ID = '"+staffID+"' ");
		sqlStr.append("AND CO_STAFF_INVOLVE_TYPE = '"+type+"' ");
		sqlStr.append("AND CO_STAFF_INVOLVE = '"+subType+"' ");
		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean addStaffInvolvement(UserBean userBean,String staffID,String type,String subType){
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("INSERT INTO CO_STAFF_INVOLVEMENT( CO_SITE_CODE, CO_STAFF_ID , CO_STAFF_INVOLVE_TYPE , CO_STAFF_INVOLVE,CO_CREATED_USER,CO_MODIFIED_USER)");	
		sqlStr.append("VALUES ( ");
		sqlStr.append("'"+ConstantsServerSide.SITE_CODE+"', '"+staffID+"' ");		
		sqlStr.append(", '"+type+"', '"+subType+"' ");
		sqlStr.append(", '"+userBean.getLoginID()+"', '"+userBean.getLoginID()+"') ");
		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	public static boolean editStaffInvolvement(UserBean userBean,String staffID,String type,String subType,boolean isChecked){	
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE CO_STAFF_INVOLVEMENT ");
		if(isChecked){
			sqlStr.append("SET CO_ENABLED = '1', ");
		}else{
			sqlStr.append("SET CO_ENABLED = '0', ");
		}
			
		sqlStr.append("CO_MODIFIED_DATE=SYSDATE, ");
		sqlStr.append("CO_MODIFIED_USER='" + userBean.getLoginID() + "' ");
		sqlStr.append("WHERE CO_STAFF_ID = '" + staffID + "' ");
		sqlStr.append("AND CO_STAFF_INVOLVE_TYPE = '"+type+"' ");		
		sqlStr.append("AND CO_STAFF_INVOLVE = '"+subType+"' ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	public static ArrayList getStaffInvolvement(String staffID){
		StringBuffer sqlStr = new StringBuffer();
				
		sqlStr.append("SELECT CO_STAFF_ID , CO_STAFF_INVOLVE_TYPE , CO_STAFF_INVOLVE , TO_CHAR(CO_EFFECTIVE_DATE, 'DD/MM/YYYY') ");	
		sqlStr.append("FROM CO_STAFF_INVOLVEMENT ");
		sqlStr.append("WHERE CO_STAFF_ID = '"+staffID+"' ");
		sqlStr.append("AND CO_ENABLED = 1 ");
		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean addStaffTeam20Date(UserBean userBean,String staffID,String type,String subType,String team20Date){
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("INSERT INTO CO_STAFF_INVOLVEMENT( CO_SITE_CODE, CO_STAFF_ID,CO_STAFF_INVOLVE_TYPE , CO_STAFF_INVOLVE,CO_CREATED_USER,CO_MODIFIED_USER,CO_EFFECTIVE_DATE)");	
		sqlStr.append("VALUES ( ");
		sqlStr.append("'"+ConstantsServerSide.SITE_CODE+"', '"+staffID+"' ");	
		sqlStr.append(", '"+type+"', '"+subType+"' ");
		sqlStr.append(", '"+userBean.getLoginID()+"', '"+userBean.getLoginID()+"', TO_DATE('"+team20Date+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS')) ");
		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	public static boolean editStaffTeam20Date(UserBean userBean,String staffID,String type,String subType,String team20Date){	
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE CO_STAFF_INVOLVEMENT ");		
		sqlStr.append("SET CO_EFFECTIVE_DATE = TO_DATE('"+team20Date+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("CO_MODIFIED_DATE=SYSDATE, ");
		sqlStr.append("CO_MODIFIED_USER='" + userBean.getLoginID() + "', ");
		sqlStr.append("CO_ENABLED='1' ");
		sqlStr.append("WHERE CO_STAFF_ID = '" + staffID + "' ");
		sqlStr.append("AND CO_STAFF_INVOLVE_TYPE = '"+type+"' ");		
		sqlStr.append("AND CO_STAFF_INVOLVE = '"+subType+"' ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
}