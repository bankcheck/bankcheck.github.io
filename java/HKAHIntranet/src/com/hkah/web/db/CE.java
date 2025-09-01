/*
 * Created on April 8, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;
import java.util.HashMap;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class CE {
	
	public static HashMap monthHashMap = new HashMap();

	static {
		monthHashMap.put("Jan", "01");
		monthHashMap.put("Feb", "02");
		monthHashMap.put("Mar", "03");
		monthHashMap.put("Apr", "04");
		monthHashMap.put("May", "05");
		monthHashMap.put("Jun", "06");
		monthHashMap.put("Jul", "07");
		monthHashMap.put("Aug", "08");
		monthHashMap.put("Sep", "09");
		monthHashMap.put("Oct", "10");
		monthHashMap.put("Nov", "11");
		monthHashMap.put("Dec", "12");
	}

	private static String sqlStr_insertCEApproval = null;
	private static String sqlStr_updateCEApproval = null;
	
	private static String getNextCEID() {
		String ceID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CE_CONTINUING_EDUCATION_ID) + 1 FROM CE_CONTINUING_EDUCATION");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			ceID = reportableListObject.getValue(0);

			// set 1 for initial
			if (ceID == null || ceID.length() == 0) return "1";
		}
		return ceID;
	}

	/**
	 * Add a CE record
	 * @return CEID
	 */
	public static String add(UserBean userBean,
			String staffID, String courseID, String courseSponsor, String attendanceLocation,
			String fromDate, String toDate, String appliedDays, String fee, 
			String benefitEmployee, String benefitDepartment,String documentID, String approve_staffID) {
		// get next event ID
		String ceID = getNextCEID();

		// try to insert a new record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CE_CONTINUING_EDUCATION (CE_CONTINUING_EDUCATION_ID, CE_SITE_CODE, ");
		sqlStr.append(" 		   CE_STAFF_ID, CE_COURSE_NAME, CE_COURSE_SPONSOR, CE_LOCATION_ATTENDANCE, ");
		sqlStr.append("            CE_FROM_DATE, CE_TO_DATE, CE_APPLIED_HOURS, CE_FEE, CE_BENEFIT_EMPLOYEE, ");
		sqlStr.append(" 		   CE_BENEFIT_DEPARTMENT, CE_APPROVE_MGR_STAFF_ID,	CE_DOCUMENT_ID,");
		sqlStr.append("            CE_CREATED_USER, CE_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, '" + ConstantsServerSide.SITE_CODE + "', ");
		sqlStr.append("?, ?, ?, ?, ");
		sqlStr.append("TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS'), TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS'), TO_NUMBER(?), TO_NUMBER(?), ?, ");
		sqlStr.append("?, ?, ?, ?, ?)");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { ceID, staffID, courseID, courseSponsor, attendanceLocation,
					fromDate + " 00:00:00", toDate + " 23:59:59", appliedDays, fee, benefitEmployee, 
					benefitDepartment, approve_staffID,documentID,
					userBean.getLoginID(), userBean.getLoginID() })) {
			return ceID;
		} else {
			return null;
		}
	}

	/**
	 * approve CE record from manager
	 * @return whether it is successful
	 */
	public static boolean approve_manager(UserBean userBean, String ceID, String approveAdminID ) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CE_CONTINUING_EDUCATION ");
		sqlStr.append("SET    CE_STATUS = 'M',CE_APPROVE_ADMIN_STAFF_ID = ? , CE_APPROVE_MGR_DATE = SYSDATE, ");
		sqlStr.append("       CE_MODIFIED_DATE = SYSDATE, CE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CE_CONTINUING_EDUCATION_ID = ? AND CE_APPROVE_MGR_STAFF_ID = ? AND CE_STATUS = 'O' AND CE_ENABLED = 1");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { approveAdminID, userBean.getLoginID(), ceID, userBean.getStaffID() });
	}

	/**
	 * approve CE record from Director / Persident/ Vice-President
	 * @return whether it is successful
	 */
	public static boolean approve_admin(UserBean userBean, String ceID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CE_CONTINUING_EDUCATION ");
		sqlStr.append("SET    CE_STATUS = 'A', CE_APPROVE_HR_STAFF_ID = '3043', CE_APPROVE_ADMIN_DATE = SYSDATE, ");
		sqlStr.append("       CE_MODIFIED_DATE = SYSDATE, CE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CE_CONTINUING_EDUCATION_ID = ? AND CE_APPROVE_ADMIN_STAFF_ID = ? AND CE_STATUS = 'M' AND CE_ENABLED = 1");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), ceID, userBean.getStaffID() });
	}
	
	/**
	 * approve CE record from hr manager
	 * @return whether it is successful
	 */
	public static boolean approve_hr(UserBean userBean, String ceID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CE_CONTINUING_EDUCATION ");
		sqlStr.append("SET    CE_STATUS = 'H', CE_APPROVE_HR_DATE = SYSDATE, ");
		sqlStr.append("       CE_MODIFIED_DATE = SYSDATE, CE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CE_CONTINUING_EDUCATION_ID = ? AND CE_APPROVE_HR_STAFF_ID = ? AND CE_STATUS = 'A' AND CE_ENABLED = 1");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), ceID, userBean.getStaffID() });
	}

	/**
	 * reject CE record
	 * @return whether it is successful
	 */
	public static boolean reject(UserBean userBean, String ceID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CE_CONTINUING_EDUCATION ");
		sqlStr.append("SET    CE_STATUS = 'R', CE_MODIFIED_DATE = SYSDATE, CE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CE_CONTINUING_EDUCATION_ID = ? AND CE_STATUS in ('O', 'M','A') AND CE_ENABLED = 1");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), ceID });
	}

	/**
	 * cancel CE record
	 * @return whether it is successful
	 */
	public static boolean cancel(UserBean userBean, String ceID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CE_CONTINUING_EDUCATION ");
		sqlStr.append("SET    CE_STATUS = 'C', CE_ENABLED = 0, CE_MODIFIED_DATE = SYSDATE, CE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CE_CONTINUING_EDUCATION_ID = ? AND CE_STATUS = 'O' AND CE_ENABLED = 1");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { userBean.getLoginID(), ceID });
	}

	public static ArrayList getList(UserBean userBean, String deptCode, String date_from, String date_to) {
		// get staff id
		String staffID = userBean.getStaffID();

		// fetch ce list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT L.CE_CONTINUING_EDUCATION_ID, L.CE_STAFF_ID, S.CO_LASTNAME, S.CO_FIRSTNAME, ");
		sqlStr.append("       TO_CHAR(L.CE_FROM_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       L.CE_APPLIED_HOURS, L.CE_STATUS ");
		sqlStr.append("FROM   CE_CONTINUING_EDUCATION L, CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  L.CE_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    L.CE_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    L.CE_ENABLED = 1 ");
		sqlStr.append("AND   (L.CE_STAFF_ID = '");
		sqlStr.append(staffID);
		sqlStr.append("' OR L.CE_APPROVE_MGR_STAFF_ID = '");
		sqlStr.append(staffID);
		sqlStr.append("' OR L.CE_APPROVE_ADMIN_STAFF_ID = '");
		sqlStr.append(staffID);
		sqlStr.append("' OR L.CE_APPROVE_HR_STAFF_ID = '");
		sqlStr.append(staffID);
		sqlStr.append("') ");
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if (date_from != null && date_from.length() == 10) {
			sqlStr.append("AND    L.CE_FROM_DATE >= TO_DATE('");
			sqlStr.append(date_from);
			sqlStr.append("', 'dd/mm/yyyy') ");
		}
		if (date_to != null && date_to.length() == 10) {
			sqlStr.append("AND    L.CE_FROM_DATE <= TO_DATE('");
			sqlStr.append(date_to);
			sqlStr.append("', 'dd/mm/yyyy') ");
		}
		sqlStr.append("ORDER BY L.CE_CONTINUING_EDUCATION_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}


	public static ArrayList get(String ceID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT L.CE_STAFF_ID, S.CO_STAFFNAME, ");
		sqlStr.append("       D.CO_DEPARTMENT_DESC, L.CE_COURSE_NAME, L.CE_COURSE_SPONSOR, L.CE_LOCATION_ATTENDANCE, ");
		sqlStr.append("       TO_CHAR(L.CE_FROM_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(L.CE_TO_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       L.CE_APPLIED_HOURS, L.CE_FEE, L.CE_BENEFIT_EMPLOYEE, L.CE_BENEFIT_DEPARTMENT, L.CE_STATUS, ");
		sqlStr.append("       L.CE_APPROVE_MGR_STAFF_ID, S2.CO_STAFFNAME, ");
		sqlStr.append("       L.CE_APPROVE_ADMIN_STAFF_ID, S3.CO_STAFFNAME, ");
		sqlStr.append("       L.CE_APPROVE_HR_STAFF_ID, S4.CO_STAFFNAME ");
		sqlStr.append("FROM   CE_CONTINUING_EDUCATION L, CO_STAFFS S, CO_DEPARTMENTS D, CO_STAFFS S2, CO_STAFFS S3,CO_STAFFS S4 ");
		sqlStr.append("WHERE  L.CE_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    L.CE_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    L.CE_SITE_CODE = S2.CO_SITE_CODE (+) ");
		sqlStr.append("AND    L.CE_APPROVE_MGR_STAFF_ID = S2.CO_STAFF_ID (+) ");
		sqlStr.append("AND    L.CE_SITE_CODE = S3.CO_SITE_CODE (+) ");
		sqlStr.append("AND    L.CE_APPROVE_ADMIN_STAFF_ID = S3.CO_STAFF_ID (+) ");
		sqlStr.append("AND    L.CE_SITE_CODE = S4.CO_SITE_CODE (+) ");
		sqlStr.append("AND    L.CE_APPROVE_HR_STAFF_ID = S4.CO_STAFF_ID (+) ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    L.CE_ENABLED = 1 ");
		sqlStr.append("AND    L.CE_CONTINUING_EDUCATION_ID = ? ");
		sqlStr.append("ORDER BY CE_CONTINUING_EDUCATION_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ceID });
	}

	private  static String getNextCEApprovedID() {
		String ceApprovedID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CE_APPROVED_TRANS_ID) + 1 FROM CE_APPROVED_TRANS");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			ceApprovedID = reportableListObject.getValue(0);

			// set 1 for initial
			if (ceApprovedID == null || ceApprovedID.length() == 0) return "1";
		}
		return ceApprovedID;
	}

	public static ArrayList getClaimList(String staffID, String deptCode, String year, String isClaimedMoney, String isClaimedHours) {
		// fetch ce approval list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT T.CE_APPROVED_TRANS_ID, T.CE_SITE_CODE, TO_CHAR(T.CE_APPROVED_DATE,'MM'), TO_CHAR(T.CE_APPROVED_DATE,'DD/MM/YYYY'), ");
		sqlStr.append("      T.CE_CATEGORY, T.CE_DEPT_NAME, S.CO_STAFFNAME, ");
		sqlStr.append("      T.CE_STAFF_ID, T.CE_AMOUNT, T.CE_HOURS, T.CE_ACTION_NO,  ");
		sqlStr.append("      T.CE_ATTENDING_DATE, T.CE_COURSE_NAME, T.CE_CLAIMEDMONEY, T.CE_CLAIMEDHOURS, T.CE_HR_REMARK,T.CE_USEDMONEY, T.CE_USEDHOURS  ");
		sqlStr.append("FROM CE_APPROVED_TRANS T, CO_STAFFS S ");
		sqlStr.append("WHERE  T.CE_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    T.CE_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    T.CE_ENABLED = 1 ");
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND   (T.CE_STAFF_ID = '");
			sqlStr.append(staffID+"') ");
		}
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    S.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if (year != null && year.length() > 0) {
			sqlStr.append("AND    TO_CHAR(T.CE_APPROVED_DATE,'YYYY')= '");
			sqlStr.append(year);
			sqlStr.append("' ");
		}
		if (isClaimedMoney == null){
		}else if(isClaimedMoney.equals("2")){	
		}else if (isClaimedMoney != null && isClaimedMoney.length() > 0) {
			sqlStr.append("AND    T.CE_CLAIMEDMONEY= '");
			sqlStr.append(isClaimedMoney);
			sqlStr.append("' ");
		}
		
		if (isClaimedHours == null){
		}else if(isClaimedHours.equals("2")){	
		}else if (isClaimedHours != null && isClaimedHours.length() > 0) {
			sqlStr.append("AND    T.CE_CLAIMEDHOURS= '");
			sqlStr.append(isClaimedHours);
			sqlStr.append("' ");
		}
		sqlStr.append("ORDER BY T.CE_APPROVED_DATE");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	/**
	 * Add a CEApproved record
	 */
	public static boolean addCEApproved(UserBean userBean,
			String siteCode, String category,
			String deptName, String staffID,
			String amount, String hours, 
			String actionNo, String attendingDate,
			String courseName ,String hrRemark ) {
		// get next ceApproved ID
		String ceApprovedID = getNextCEApprovedID();

		return( UtilDBWeb.updateQueue(
				sqlStr_insertCEApproval,
				new String[] { ceApprovedID, siteCode, category,
						       deptName, staffID, amount, hours, actionNo, 
						       attendingDate,courseName,hrRemark} ));
		
	}
	
	public static String[] getCETotal(String staffID, String year) {
		String[] value=new String[] {"0","0"};
		StringBuffer sqlStr = new StringBuffer();

		//Total amount and hours
		sqlStr.append("select (ce_by_amount+ ce_bl_amount), (ce_by_hours+ ce_bl_hours) "); 
		sqlStr.append("from ce_total ");
		sqlStr.append("where ce_staff_id=? " );
		sqlStr.append("and ce_enabled=1 " );
		sqlStr.append("and to_char(ce_b_year,'yyyy')=? ");
           
        ArrayList result = UtilDBWeb.getReportableList(
				sqlStr.toString(),
				new String[] { staffID, year });
		if (result.size() > 0) {
			value=new String[2];
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			value[0] = reportableListObject.getValue(0)==""? "0" :reportableListObject.getValue(0);
			value[1] = reportableListObject.getValue(1)==""? "0" :reportableListObject.getValue(1);		}
		return value;
	}

	public static String[] getCEApproved(String staffID,String year) {
		String[] value=new String[] {"0","0"};
		StringBuffer sqlStr = new StringBuffer();

		//balance amount and hours
		sqlStr.append("select nvl(sum(ce_amount),0), nvl(sum(ce_hours),0) "); 
		sqlStr.append("from ce_approved_trans  ");
		sqlStr.append("where ce_staff_id=? " );
		sqlStr.append("and ce_enabled=1 " );
		sqlStr.append("and to_char(ce_approved_date,'yyyy')=? ");        
        ArrayList result = UtilDBWeb.getReportableList(
				sqlStr.toString(),
				new String[] { staffID,year});
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			value[0] = reportableListObject.getValue(0)==""? "0" :reportableListObject.getValue(0);
			value[1] = reportableListObject.getValue(1)==""? "0" :reportableListObject.getValue(1);

		}	
		return value;
	}
	
	
	public static String getCEUnUsedMoney(String staffID) {
		String  value="0";
		StringBuffer sqlStr = new StringBuffer();

		//balance amount and hours
		sqlStr.append("select sum(ce_amount-ce_usedMoney) "); 
		sqlStr.append("from ce_approved_trans  ");
		sqlStr.append("where ce_staff_id=? " );
		sqlStr.append("and ce_claimedMoney=0 " );
		sqlStr.append("and ce_enabled=1 " );        
        ArrayList result = UtilDBWeb.getReportableList(
				sqlStr.toString(),
				new String[] { staffID });				
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			value = reportableListObject.getValue(0)==""? "0" :reportableListObject.getValue(0);
		}	
		return value;
	}
	public static String getCEUnUsedHours(String staffID) {
		String  value="0";
		StringBuffer sqlStr = new StringBuffer();

		//balance amount and hours
		sqlStr.append("select sum(ce_hours-ce_usedHours) "); 
		sqlStr.append("from ce_approved_trans  ");
		sqlStr.append("where ce_staff_id=? " );
		sqlStr.append("and ce_claimedHours=0 " );	
		sqlStr.append("and ce_enabled=1 " );
       ArrayList result = UtilDBWeb.getReportableList(
				sqlStr.toString(),
				new String[] { staffID });				
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			value = reportableListObject.getValue(0)==""? "0" :reportableListObject.getValue(0);
//			 set 1 for initial

		}	
		return value;
	}
	
	public static boolean isExist(String staffID, String fromDate, String toDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CE_CONTINUING_EDUCATION ");
		sqlStr.append("WHERE  CE_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CE_STAFF_ID = ? ");
		sqlStr.append("AND    CE_FROM_DATE <= TO_DATE(?, 'dd/mm/yyyy') ");
		sqlStr.append("AND    CE_TO_DATE >= TO_DATE(?, 'dd/mm/yyyy') ");
		sqlStr.append("AND    CE_ENABLED = 1");

		return UtilDBWeb.isExist(sqlStr.toString(), new String[] { staffID, fromDate, toDate });
	}
	
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CE_APPROVED_TRANS (CE_APPROVED_TRANS_ID, CE_SITE_CODE,CE_APPROVED_DATE, ");
		sqlStr.append("CE_CATEGORY,CE_DEPT_NAME, CE_STAFF_ID, CE_AMOUNT,CE_HOURS,CE_ACTION_NO, ");
		sqlStr.append("CE_ATTENDING_DATE,CE_COURSE_NAME,CE_HR_REMARK ) "); 
		sqlStr.append("VALUES (?,?,SYSDATE,?,?,?,?,?,?,?,?,?)");
		sqlStr_insertCEApproval = sqlStr.toString();

	}
}