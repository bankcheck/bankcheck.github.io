/*
 * Created on June 24, 2011
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class DepartmentDB {
	private static final String CLINICAL = "CLINICAL";
	public static final String HK_DEPT_CODE_AMC1 = "420";
	public static final String HK_DEPT_CODE_AMC2 = "421";

	public static ArrayList<ReportableListObject> getList() {
		return getList(false);
	}
	
	public static String getDeptDesc(String deptCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_DESC ");
		sqlStr.append("FROM   CO_DEPARTMENTS ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_DEPARTMENT_CODE = ? ");
		
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { deptCode });
		if(record.size()>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return "";
		}
	}
	
	public static String getDeptDescWithCash(String deptCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_DESC ");
		sqlStr.append("FROM (SELECT CO_DEPARTMENT_CODE, CO_DEPARTMENT_DESC, CO_ENABLED FROM CO_DEPARTMENTS UNION SELECT 'CASH','CASH', 1 FROM DUAL) ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_DEPARTMENT_CODE = ? ");
		
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { deptCode });
		if(record.size()>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return "";
		}
	}	

	public static ArrayList<ReportableListObject> getList(boolean orderByDesc) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_CODE, CO_DEPARTMENT_DESC ");
		sqlStr.append("FROM   CO_DEPARTMENTS ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		if (orderByDesc) {
			sqlStr.append("ORDER BY CO_DEPARTMENT_DESC");
		} else {
			sqlStr.append("ORDER BY CO_DEPARTMENT_CODE");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList<ReportableListObject> getCostCentreList(boolean orderByDesc) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_CODE, CO_COST_CENTRE_DESC ");
		sqlStr.append("FROM   CO_DEPARTMENTS ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("	AND   CO_COST_CENTRE_DESC IS NOT NULL ");
		if (orderByDesc) {
			sqlStr.append("ORDER BY CO_COST_CENTRE_DESC");
		} else {
			sqlStr.append("ORDER BY CO_DEPARTMENT_CODE");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean isClincialStaff(UserBean userBean) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_CATEGORY ");
		sqlStr.append("FROM   CO_DEPARTMENTS ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_DEPARTMENT_CODE = ? ");
		
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { userBean.getDeptCode() });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return CLINICAL.equals(row.getValue(0));
		} else {
			return false;
		}
	
	}
	
	public static ArrayList getDeptHead(String deptCode) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT S.CO_STAFF_ID, ");
		sqlStr.append("DECODE(Trim(CO_FIRSTNAME)||', '||Trim(CO_LASTNAME),', ',CO_STAFFNAME,Trim(CO_FIRSTNAME)||', '||Trim(CO_LASTNAME)) ");
		sqlStr.append("FROM CO_DEPARTMENTS D, CO_STAFFS S ");
		sqlStr.append("WHERE S.CO_STAFF_ID = D.CO_DEPARTMENT_HEAD ");
		sqlStr.append("AND S.CO_ENABLED = '1' ");
		sqlStr.append("AND D.CO_ENABLED = '1' ");
		sqlStr.append("AND D.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static String getDeptHeadID(String deptCode) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT S.CO_STAFF_ID, ");
		sqlStr.append("DECODE(Trim(CO_FIRSTNAME)||', '||Trim(CO_LASTNAME),', ',CO_STAFFNAME,Trim(CO_FIRSTNAME)||', '||Trim(CO_LASTNAME)) ");
		sqlStr.append("FROM CO_DEPARTMENTS D, CO_STAFFS S ");
		sqlStr.append("WHERE S.CO_STAFF_ID = D.CO_DEPARTMENT_HEAD ");
		sqlStr.append("AND S.CO_ENABLED = '1' ");
		sqlStr.append("AND D.CO_ENABLED = '1' ");
		sqlStr.append("AND D.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject)record.get(0);
			return row.getValue(0);
		}
		
		return null;
	}
	
	public static boolean isDeptHead(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM CO_DEPARTMENTS D ");
		sqlStr.append("WHERE D.CO_ENABLED = '1' ");
		sqlStr.append("AND D.CO_DEPARTMENT_HEAD = '"+staffID+"' ");
		
		return UtilDBWeb.isExist(sqlStr.toString());
	}
	
	public static ArrayList getDeptHeadList() {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT CD.CO_DEPARTMENT_CODE, CD.CO_DEPARTMENT_DESC, ");
		sqlStr.append("CD.CO_DEPARTMENT_HEAD, ");
		sqlStr.append("DECODE(TRIM(CS.CO_FIRSTNAME)||', '||TRIM(CS.CO_LASTNAME), ");
		sqlStr.append("', ',CS.CO_STAFFNAME, ");
		sqlStr.append("TRIM(CS.CO_FIRSTNAME)||', '||TRIM(CS.CO_LASTNAME)), ");
		sqlStr.append("DECODE(CS.CO_EMAIL, NULL, U.CO_EMAIL, CS.CO_EMAIL) ");
		sqlStr.append("FROM  CO_DEPARTMENTS CD, CO_STAFFS CS, CO_USERS U ");
		sqlStr.append("WHERE CS.CO_STAFF_ID = CD.CO_DEPARTMENT_HEAD ");
		sqlStr.append("AND   CS.CO_SITE_CODE = U.CO_SITE_CODE ");
		sqlStr.append("AND   CS.CO_STAFF_ID = U.CO_STAFF_ID ");
		sqlStr.append("ORDER BY CD.CO_DEPARTMENT_DESC ");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getDeptHeadList(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT CD.CO_DEPARTMENT_CODE, CD.CO_DEPARTMENT_DESC, ");
		sqlStr.append("CD.CO_DEPARTMENT_HEAD, ");
		sqlStr.append("DECODE(TRIM(CS.CO_FIRSTNAME)||', '||TRIM(CS.CO_LASTNAME), ");
		sqlStr.append("', ',CS.CO_STAFFNAME, ");
		sqlStr.append("TRIM(CS.CO_FIRSTNAME)||', '||TRIM(CS.CO_LASTNAME)), ");
		sqlStr.append("DECODE(CS.CO_EMAIL, NULL, U.CO_EMAIL, CS.CO_EMAIL) ");
		sqlStr.append("FROM  CO_DEPARTMENTS CD, CO_STAFFS CS, CO_USERS U ");
		sqlStr.append("WHERE CS.CO_STAFF_ID = CD.CO_DEPARTMENT_HEAD ");
		sqlStr.append("AND   CS.CO_SITE_CODE = U.CO_SITE_CODE ");
		sqlStr.append("AND   CS.CO_STAFF_ID = U.CO_STAFF_ID ");
		sqlStr.append("AND   CD.CO_DEPARTMENT_HEAD = '"+staffID+"' ");
		sqlStr.append("ORDER BY CD.CO_DEPARTMENT_DESC ");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}	
	
	public static String getDeptHeadEmail(String deptCode) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT CD.CO_DEPARTMENT_CODE, CD.CO_DEPARTMENT_DESC, ");
		sqlStr.append("CD.CO_DEPARTMENT_HEAD, ");
		sqlStr.append("DECODE(TRIM(CS.CO_FIRSTNAME)||', '||TRIM(CS.CO_LASTNAME), ");
		sqlStr.append("', ',CS.CO_STAFFNAME, ");
		sqlStr.append("TRIM(CS.CO_FIRSTNAME)||', '||TRIM(CS.CO_LASTNAME)), ");
		sqlStr.append("DECODE(CS.CO_EMAIL, NULL, U.CO_EMAIL, CS.CO_EMAIL) ");
		sqlStr.append("FROM  CO_DEPARTMENTS CD, CO_STAFFS CS, CO_USERS U ");
		sqlStr.append("WHERE CS.CO_STAFF_ID = CD.CO_DEPARTMENT_HEAD ");
		sqlStr.append("AND   CS.CO_SITE_CODE = U.CO_SITE_CODE ");
		sqlStr.append("AND   CS.CO_STAFF_ID = U.CO_STAFF_ID ");
		sqlStr.append("AND	 CD.CO_DEPARTMENT_CODE = ? ");
		sqlStr.append("ORDER BY CD.CO_DEPARTMENT_DESC ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { deptCode });
		
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(4);
		}
		return null;
	}
	
	public static String getPortalDeptCodeByHRDeptCode(String deptCodeHR, String siteCode) {
		return getPortalDeptCodeByHRDeptCode(deptCodeHR, siteCode, false);
	}
	
	public static String getPortalDeptCodeByHRDeptCode(String deptCodeHR, String siteCode, boolean retNullIfNotMatch) {
		String ret = null;
		StringBuffer sqlStr = new StringBuffer();
		String column = null;
		if (ConstantsServerSide.SITE_CODE_HKAH.equals(siteCode)) {
			column = "CO_DEPARTMENT_CODE1 ";
		} else if (ConstantsServerSide.SITE_CODE_TWAH.equals(siteCode)) {
			column = "CO_DEPARTMENT_CODE2 ";
		} 
		
		sqlStr.append("SELECT ");
		sqlStr.append(column);
		sqlStr.append("FROM  CO_DEPARTMENT_MAPPING ");
		sqlStr.append("WHERE CO_DEPARTMENT_CODE_HR = ?");
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{deptCodeHR});
		
		//System.out.println("[DEBUG] DepartmentDB.getPortalDeptCodeByHRDeptCode deptCodeHR="+deptCodeHR+", siteCode="+siteCode + ", column="+column+", record.size="+record.size());
		
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			ret = row.getFields0();
		} else {
			ret = retNullIfNotMatch ? null : deptCodeHR;
		}
		return ret;
	}
	
	public static String getSiteCodeByDept(String deptCode) {
		String ret = null;
		if (HK_DEPT_CODE_AMC1.equals(deptCode)) {
			ret = ConstantsServerSide.SITE_CODE_AMC1;
		} else if (HK_DEPT_CODE_AMC2.equals(deptCode)) {
			ret = ConstantsServerSide.SITE_CODE_AMC2;
		} else {
			ret = ConstantsServerSide.SITE_CODE;
		}
		return ret;
	}
	
	public static ArrayList getJointList(boolean orderByDesc) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 'HK' || CO_DEPARTMENT_CODE, 'HK' || '-' || CO_DEPARTMENT_DESC "); 
		sqlStr.append(" FROM   CO_DEPARTMENTS "); 
		sqlStr.append(" WHERE  CO_ENABLED = 1 ");
		sqlStr.append(" UNION ");
		sqlStr.append(" SELECT 'TW' || CO_DEPARTMENT_CODE, 'TW' || '-' || CO_DEPARTMENT_DESC "); 
		sqlStr.append(" FROM   CO_DEPARTMENTS@TWAH ");
		sqlStr.append(" WHERE  CO_ENABLED = 1 ");
		if (orderByDesc) {
			sqlStr.append("ORDER BY 2 ");
		} else {
			sqlStr.append("ORDER BY 1 ");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean addDept(UserBean userBean, String deptCode, String deptDesc, boolean isHRCode) {
		boolean ret = false;
		boolean isAdd = true;
		StringBuffer sqlStr = new StringBuffer();
		if (isHRCode) {
			sqlStr.append("SELECT 1 FROM ");
			sqlStr.append("CO_DEPARTMENTS ");
			sqlStr.append("WHERE CO_DEPARTMENT_CODE = ?");
			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{deptCode});
			
			if (record.size() > 0) {
				isAdd = false;
			}
		}
		if (isAdd) {
			sqlStr.setLength(0);
			sqlStr.append("INSERT INTO CO_DEPARTMENTS (");
			sqlStr.append("CO_DEPARTMENT_CODE, CO_DEPARTMENT_DESC, CO_CREATED_USER, CO_MODIFIED_USER) ");
			sqlStr.append("VALUES ");
			sqlStr.append("(?, ?, ?, ?) ");

			String username = (userBean == null ? "SYSTEM" : userBean.getLoginID());
			ret = UtilDBWeb.updateQueue(sqlStr.toString( ),
					new String[] { deptCode, deptDesc, username, username});
				
			/*
			if (ret && isHRCode) {
				sqlStr.setLength(0);
				sqlStr.append("INSERT INTO CO_DEPARTMENT_MAPPING (");
				sqlStr.append("CO_DEPARTMENT_CODE1, CO_DEPARTMENT_CODE2, CO_DEPARTMENT_CODE_HR, CO_CREATED_USER, CO_MODIFIED_USER) ");
				sqlStr.append("VALUES ");
				sqlStr.append("(?, ?, ?, ?, ?) ");
				
				UtilDBWeb.updateQueue(sqlStr.toString( ),
						new String[] { deptCode, deptCode, deptCode, username, username});
			}
			*/
		}
		return ret;
	}
	
	public static boolean activateAndUpdateDeptName(UserBean userBean, String deptCode, String deptDesc, boolean isHRCode) {
		String deptCodeColumn = ConstantsServerSide.isHKAH() ? "co_department_code1" : (ConstantsServerSide.isTWAH() ? "co_department_code2" : "co_department_code1");
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_DEPARTMENTS ");
		sqlStr.append("SET CO_DEPARTMENT_DESC = ?, CO_MODIFIED_USER = ?, CO_MODIFIED_DATE = sysdate, CO_ENABLED = 1 ");
		if (isHRCode) {
			sqlStr.append("WHERE CO_DEPARTMENT_CODE in (select " + deptCodeColumn + " from co_department_mapping where co_department_code_hr = ?) ");
		} else {
			sqlStr.append("WHERE CO_DEPARTMENT_CODE = ? ");
		}
		sqlStr.append("AND (co_department_desc <> ? or co_enabled = 0)");

		String username = (userBean == null ? "SYSTEM" : userBean.getLoginID());
		return UtilDBWeb.updateQueue(sqlStr.toString( ),
				new String[] { deptDesc, username, deptCode, deptDesc});
	}
	
	public static boolean isExists(String deptCode, boolean isHRCode) {
		String deptCodeColumn = ConstantsServerSide.isHKAH() ? "co_department_code1" : (ConstantsServerSide.isTWAH() ? "co_department_code2" : "co_department_code1");
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DEPARTMENT_CODE ");
		sqlStr.append("FROM   CO_DEPARTMENTS ");
		if (isHRCode) {
			sqlStr.append("WHERE  CO_DEPARTMENT_CODE in (select " + deptCodeColumn + " from co_department_mapping where co_department_code_hr = ?) ");
		} else {
			sqlStr.append("WHERE  CO_DEPARTMENT_CODE = ? ");
		}
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { deptCode });
		if(record.size()>0){
			return true;
		} else {
			return false;
		}
	}
	
	public static boolean syncDept(String deptCode, String deptDesc, boolean isHRCode) {
		// if deptCode exist, check if deptdesc and enabled need to update
		// if deptCode not exist, add new dept, email to prompt for any mapping to old department
		// ignore sNA
		boolean ret = false;
		boolean sendAlert = false;
		String subSubject = null;
		String subContent = "";
		
		//System.out.println("[DepartmentDB] syncDept deptCode="+deptCode+", deptDesc="+deptDesc);
		if (!"NA".equals(deptCode)) {
			if (isExists(deptCode, isHRCode)) {
				ret = activateAndUpdateDeptName(null, deptCode, deptDesc, isHRCode);
				
				if (ret) {
					sendAlert = true;
					System.out.println("syncDept updated: " + deptCode + (isHRCode ? "(HR Code) " : " ") + deptDesc);
					
					subSubject = "Department " + deptCode + (isHRCode ? "(HR Code) " : " ") + deptDesc + " is updated in Intranet Portal from HR.";
				}
			} else {
				ret = addDept(null, deptCode, deptDesc, isHRCode);
				sendAlert = true;
				
				if (ret) {
					System.out.println("syncDept insert success: " + deptCode + (isHRCode ? "(HR Code) " : " ") + deptDesc);
					
					subSubject = "Department " + deptCode + (isHRCode ? "(HR Code) " : " ") + deptDesc + " is added to Intranet Portal from HR.";
					subContent = "Please add department mapping, category, head, subhead, supervisor.";
				} else {
					System.out.println("syncDept insert failed: " + deptCode + (isHRCode ? "(HR Code) " : " ") + deptDesc);
					
					subSubject = "Department " + deptCode + (isHRCode ? "(HR Code) " : " ") + deptDesc + " failed to add to Intranet Portal from HR.";
				}
			}
			
			if (sendAlert) {
				String subject = "[" + ConstantsServerSide.getSiteShortForm() + "]" + " " + subSubject;
				String content = subSubject + "<br />" + subContent;
				
				EmailAlertDB.sendEmail("admin", subject, content);
			}
		}
		return ret;
	}
	
	
}