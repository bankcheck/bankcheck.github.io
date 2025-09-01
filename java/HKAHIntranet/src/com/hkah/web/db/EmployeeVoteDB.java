package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class EmployeeVoteDB {
	private static String sqlStr_insertAction = null;
	private static String sqlStr_insertQuarterAction = null;
	private static String sqlStr_insertYearAction = null;
	private static String sqlStr_updateAction = null;
	private static String sqlStr_deleteAction = null;
	private static String sqlStr_getStaffListAction = null;
	private static String sqlStr_getEShareNomineeList = null;
	private static String sqlStr_getDeptCodeListAction = null;
	private static String sqlStr_insertEShareAction = null;

	/**
	 * Add an action
	 */
	public static boolean addYear(UserBean userBean,
			String nomineeStaffID, String comments,String module,String quarter,String dependable,String flexible,String hsInitiative,String positive,String compassionate,String sensePercent,String managingPercent,String total, String allowDisplay) {

		// try to insert a new record
		return UtilDBWeb.updateQueue(
				sqlStr_insertYearAction,
				new String[] {
						nomineeStaffID, userBean.getStaffID(),
						comments,
						userBean.getLoginID(), userBean.getLoginID(),module,quarter,dependable,flexible,hsInitiative,positive,compassionate,sensePercent,managingPercent,total,allowDisplay });
	}

	public static boolean addQuarter(UserBean userBean,
			String nomineeStaffID, String comments,String module,String quarter,String dependable,String flexible,String hsInitiative,String positive,String compassionate,String total ) {

		// try to insert a new record
		return UtilDBWeb.updateQueue(
				sqlStr_insertQuarterAction,
				new String[] {
						nomineeStaffID, userBean.getStaffID(),
						comments,
						userBean.getLoginID(), userBean.getLoginID(),module,quarter,dependable,flexible,hsInitiative,positive,compassionate,total });
	}

	public static boolean addEShare(UserBean userBean,
			String nomineeStaffID,String nomiatorEmail,String nominatorTel, String comments, String allowDisplay) {

			String eSHAREID = null;

			ArrayList result = UtilDBWeb.getReportableList(
					"SELECT MAX(HRD_QUARTER) + 1 FROM HRD_EMPLOYEE_VOTE WHERE HRD_MODULE='eSHARE' AND HRD_ENABLED=1 ");
			if (result.size() > 0) {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				eSHAREID = reportableListObject.getValue(0);

				// set 1 for initial
				if (eSHAREID == null || eSHAREID.length() == 0) {
					eSHAREID = "1";
				}
			}


		// try to insert a new record
		return UtilDBWeb.updateQueue(
				sqlStr_insertEShareAction,
				new String[] {
						nomineeStaffID, userBean.getStaffID(),userBean.getDeptCode(),
						eSHAREID,
						nominatorTel,nomiatorEmail,comments,userBean.getStaffID(),userBean.getStaffID(),allowDisplay });
	}

	public static boolean add(UserBean userBean,
			String nomineeStaffID, String comments,String module,String quarter) {

		// try to insert a new record
		return UtilDBWeb.updateQueue(
				sqlStr_insertAction,
				new String[] {
						nomineeStaffID, userBean.getStaffID(),
						comments,
						userBean.getLoginID(), userBean.getLoginID(),module,quarter });
	}

	public static boolean update(UserBean userBean, String staffID,
			String forwardDate, String decision, String finalist, String notSelected, String notRule) {

		// try to insert a new record
		return UtilDBWeb.updateQueue(
				sqlStr_updateAction,
				new String[] {
						forwardDate, decision, finalist, notSelected, notRule,
						userBean.getLoginID(), staffID });
	}

	public static boolean delete(UserBean userBean, String staffID) {

		// try to insert a new record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteAction,
				new String[] { userBean.getLoginID(), staffID });
	}

	public static ArrayList get(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT V.HRD_NOMINATEE_STAFF_ID, S1.CO_STAFFNAME, D1.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       V.HRD_STAFF_ID, S2.CO_STAFFNAME, D2.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       V.HRD_COMMENT_DESC, ");
		sqlStr.append("       TO_CHAR(V.HRD_COMMITTEE_FORWARD_DATE, 'DD/MM/YYYY'), ");
		sqlStr.append("       V.HRD_COMMITTEE_DECISION, V.HRD_FINALIST, ");
		sqlStr.append("       V.HRD_NOT_SELECTED, V.HRD_NOT_RULE, ");
		sqlStr.append("       TO_CHAR(V.HRD_CREATED_DATE, 'DD/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(V.HRD_MODIFIED_DATE, 'DD/MM/YYYY') ");
		sqlStr.append("FROM   HRD_EMPLOYEE_VOTE V, CO_STAFFS S1, CO_STAFFS S2, CO_DEPARTMENTS D1, CO_DEPARTMENTS D2 ");
		sqlStr.append("WHERE  V.HRD_NOMINATEE_STAFF_ID = S1.CO_STAFF_ID ");
		sqlStr.append("AND    S1.CO_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    V.HRD_STAFF_ID = S2.CO_STAFF_ID ");
		sqlStr.append("AND    S2.CO_DEPARTMENT_CODE = D2.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    V.HRD_ENABLED = 1 ");
		sqlStr.append("AND    V.HRD_NOMINATION_YEAR = TO_CHAR(SYSDATE, 'yyyy') ");
		sqlStr.append("AND    V.HRD_STAFF_ID = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { staffID });
	}

	public static ArrayList getList(String deptCode1, String deptCode2, String groupBy) {
		boolean isGrouping = false;
		if (groupBy != null && groupBy.length() > 0) {
			isGrouping = true;
		}

		// fetch summary
		StringBuffer sqlStr = new StringBuffer();
		if (isGrouping) {
			if ("deptCode1".equals(groupBy)) {
				sqlStr.append("SELECT D1.CO_DEPARTMENT_DESC, count(1) ");
			} else if ("deptCode2".equals(groupBy)) {
				sqlStr.append("SELECT D2.CO_DEPARTMENT_DESC, count(1) ");
			} else if ("nominatee".equals(groupBy)) {
				sqlStr.append("SELECT S1.CO_STAFFNAME, count(1) ");
			} else if ("nominating".equals(groupBy)) {
				sqlStr.append("SELECT S2.CO_STAFFNAME, count(1) ");
			}
		} else {
			sqlStr.append("SELECT V.HRD_NOMINATEE_STAFF_ID, S1.CO_STAFFNAME, D1.CO_DEPARTMENT_DESC, ");
			sqlStr.append("       V.HRD_STAFF_ID, S2.CO_STAFFNAME, D2.CO_DEPARTMENT_DESC, ");
			sqlStr.append("       TO_CHAR(V.HRD_MODIFIED_DATE, 'DD/MM/YYYY'), ");
			sqlStr.append("       V.HRD_COMMENT_DESC ");
		}
		sqlStr.append("FROM   HRD_EMPLOYEE_VOTE V, CO_STAFFS S1, CO_STAFFS S2, CO_DEPARTMENTS D1, CO_DEPARTMENTS D2 ");
		sqlStr.append("WHERE  V.HRD_NOMINATEE_STAFF_ID = S1.CO_STAFF_ID ");
		sqlStr.append("AND    S1.CO_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    V.HRD_STAFF_ID = S2.CO_STAFF_ID ");
		sqlStr.append("AND    S2.CO_DEPARTMENT_CODE = D2.CO_DEPARTMENT_CODE ");
		if (deptCode1 != null && deptCode1.length() > 0) {
			sqlStr.append("AND    D1.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode1);
			sqlStr.append("' ");
		}
		if (deptCode2 != null && deptCode2.length() > 0) {
			sqlStr.append("AND    D2.CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode2);
			sqlStr.append("' ");
		}
		sqlStr.append("AND    V.HRD_ENABLED = 1 ");
		sqlStr.append("AND    V.HRD_NOMINATION_YEAR = TO_CHAR(SYSDATE, 'yyyy') ");
		if (isGrouping) {
			if ("deptCode1".equals(groupBy)) {
				sqlStr.append("GROUP BY D1.CO_DEPARTMENT_DESC ");
				sqlStr.append("ORDER BY D1.CO_DEPARTMENT_DESC ");
			} else if ("deptCode2".equals(groupBy)) {
				sqlStr.append("GROUP BY D2.CO_DEPARTMENT_DESC ");
				sqlStr.append("ORDER BY D2.CO_DEPARTMENT_DESC ");
			} else if ("nominatee".equals(groupBy)) {
				sqlStr.append("GROUP BY S1.CO_STAFFNAME ");
				sqlStr.append("ORDER BY S1.CO_STAFFNAME ");
			} else if ("nominating".equals(groupBy)) {
				sqlStr.append("GROUP BY S2.CO_STAFFNAME ");
				sqlStr.append("ORDER BY S2.CO_STAFFNAME ");
			}
		} else {
			sqlStr.append("ORDER BY V.HRD_NOMINATEE_STAFF_ID ");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean verifyStaffID(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("(SELECT 1 ");
		sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    S.CO_STATUS = 'FT' ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE != '880' ");
		sqlStr.append("AND    S.CO_STAFF_ID NOT LIKE '9%' ");
		sqlStr.append("AND    S.CO_STAFF_ID NOT LIKE 'DR%' ");
		sqlStr.append("AND    S.CO_STAFF_ID = ?)  ");
		sqlStr.append("		MINUS");
		sqlStr.append("		(SELECT 1 ");
		sqlStr.append("		 FROM   CO_STAFFS S, CO_DEPARTMENTS D, AC_USER_GROUPS L");
		sqlStr.append("		 WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("		 AND    S.CO_STAFF_ID = L.AC_STAFF_ID");
		sqlStr.append("		 AND    S.CO_ENABLED = L.AC_ENABLED ");
		sqlStr.append("		 AND    L.AC_GROUP_ID = 'nominate.ignore.list' ");
		sqlStr.append("		 AND    S.CO_SITE_CODE = 'hkah'");
		sqlStr.append("		 AND    S.CO_STATUS = 'FT' ");
		sqlStr.append("		 AND    S.CO_DEPARTMENT_CODE != '880'");
		sqlStr.append("		 AND    S.CO_STAFF_ID NOT LIKE '9%'");
		sqlStr.append("		 AND    S.CO_STAFF_ID NOT LIKE 'DR%'");
		sqlStr.append("		 AND    S.CO_STAFF_ID = ?)");

		return UtilDBWeb.isExist(sqlStr.toString(), new String[] { staffID,staffID });
	}

	public static ArrayList getNomineeList(String deptCode) {
		// fetch nominee staff
		if (deptCode == null || deptCode.trim().isEmpty()) {
			deptCode = "-1";
		}
		return UtilDBWeb.getReportableList(sqlStr_getEShareNomineeList, new String[] { deptCode });
	}

	public static ArrayList getDeptCodeList() {
		// fetch dept code
		return UtilDBWeb.getReportableList(sqlStr_getDeptCodeListAction);
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO HRD_EMPLOYEE_VOTE ");
		sqlStr.append("(HRD_NOMINATEE_STAFF_ID, HRD_STAFF_ID, HRD_COMMENT_DESC, ");
		sqlStr.append(" HRD_CREATED_USER, HRD_MODIFIED_USER, HRD_NOMINATION_YEAR,HRD_MODULE,HRD_QUARTER  ) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ");
		sqlStr.append(" ?, ?, TO_CHAR(SYSDATE, 'yyyy'),?,? )");
		sqlStr_insertAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO HRD_EMPLOYEE_VOTE ");
		sqlStr.append("(HRD_NOMINATEE_STAFF_ID, HRD_STAFF_ID, HRD_COMMENT_DESC, ");
		sqlStr.append(" HRD_CREATED_USER, HRD_MODIFIED_USER, HRD_NOMINATION_YEAR,HRD_MODULE,HRD_QUARTER,  ");
		sqlStr.append(" HRD_DEPENDABLE,HRD_FLEXIBLE,HRD_HASINITIATIVE,HRD_POSITIVE,HRD_COMPASSIONATE,HRD_TOTAL) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ");
		sqlStr.append(" ?, ?, TO_CHAR(SYSDATE, 'yyyy'),?,?,?,?,?,?,?,? )");
		sqlStr_insertQuarterAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO HRD_EMPLOYEE_VOTE ");
		sqlStr.append("(HRD_NOMINATEE_STAFF_ID, HRD_STAFF_ID, HRD_COMMENT_DESC, ");
		sqlStr.append(" HRD_CREATED_USER, HRD_MODIFIED_USER, HRD_NOMINATION_YEAR,HRD_MODULE,HRD_QUARTER,  ");
		sqlStr.append(" HRD_DEPENDABLE,HRD_FLEXIBLE,HRD_HASINITIATIVE,HRD_POSITIVE,HRD_COMPASSIONATE,HRD_SENSE,HRD_MANAGING,HRD_TOTAL,HRD_ALLOWDISPLAY) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ");
		sqlStr.append(" ?, ?, TO_CHAR(SYSDATE, 'yyyy'),?,?,?,?,?,?,?,?,?,?,? )");
		sqlStr_insertYearAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO HRD_EMPLOYEE_VOTE ");
		sqlStr.append(" (HRD_NOMINATEE_STAFF_ID,HRD_STAFF_ID,HRD_NOMINATOR_DEPT,  ");
		sqlStr.append(" HRD_NOMINATION_YEAR,HRD_MODULE,HRD_QUARTER, ");
		sqlStr.append(" HRD_NOMINATOR_TEL, HRD_NOMINATOR_EMAIL, HRD_COMMENT_DESC, ");
		sqlStr.append(" HRD_CREATED_USER,HRD_MODIFIED_USER,HRD_ALLOWDISPLAY ");
		sqlStr.append(")");
		sqlStr.append("VALUES( ");
		sqlStr.append("?,?,?,TO_CHAR(SYSDATE, 'yyyy'),'eSHARE',?,?,?,?,?,?,? ");
		sqlStr.append(")");
		sqlStr_insertEShareAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE HRD_EMPLOYEE_VOTE ");
		sqlStr.append("SET    HRD_COMMITTEE_FORWARD_DATE = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append("       HRD_COMMITTEE_DECISION = ?, ");
		sqlStr.append("       HRD_FINALIST = ?, ");
		sqlStr.append("       HRD_NOT_SELECTED = ?, ");
		sqlStr.append("       HRD_NOT_RULE = ?, ");
		sqlStr.append("       HRD_MODIFIED_DATE = SYSDATE, HRD_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  HRD_ENABLED = 1 ");
		sqlStr.append("AND    HRD_STAFF_ID = ? ");
		sqlStr_updateAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE HRD_EMPLOYEE_VOTE ");
		sqlStr.append("SET    HRD_ENABLED = 0, HRD_MODIFIED_DATE = SYSDATE, HRD_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  HRD_ENABLED = 1 ");
		sqlStr.append("AND    HRD_STAFF_ID = ? ");
		sqlStr_deleteAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("(");
		sqlStr.append("SELECT S.CO_DEPARTMENT_CODE, DECODE(S.CO_DEPARTMENT_DESC, null, D.CO_DEPARTMENT_DESC, S.CO_DEPARTMENT_DESC), ");
		sqlStr.append("       S.CO_STAFF_ID, S.CO_STAFFNAME, S.CO_STATUS, ");
		sqlStr.append("       TO_CHAR(S.CO_ANNUAL_INCR, 'MM'), TO_CHAR(S.CO_HIRE_DATE,'MM/YYYY'), TO_CHAR(S.CO_HIRE_DATE,'DD/MM/YYYY'), ");
		sqlStr.append("       S.CO_DISPLAY_NAME ");
		sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    S.CO_STATUS = 'FT' ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE NOT IN ('400', '880') ");
		sqlStr.append("AND    S.CO_STAFF_ID NOT LIKE '9%' ");
		sqlStr.append("AND    S.CO_STAFF_ID NOT LIKE 'DR%' ");
		sqlStr.append("AND    S.CO_STAFF_ID != 'IPD' ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = ? ");
		sqlStr.append(") MINUS (");
		sqlStr.append("SELECT S.CO_DEPARTMENT_CODE, DECODE(S.CO_DEPARTMENT_DESC, null, D.CO_DEPARTMENT_DESC, S.CO_DEPARTMENT_DESC), ");
		sqlStr.append("       S.CO_STAFF_ID, S.CO_STAFFNAME, S.CO_STATUS, ");
		sqlStr.append("       TO_CHAR(S.CO_ANNUAL_INCR, 'MM'), TO_CHAR(S.CO_HIRE_DATE,'MM/YYYY'), TO_CHAR(S.CO_HIRE_DATE,'DD/MM/YYYY'), ");
		sqlStr.append("       S.CO_DISPLAY_NAME ");
		sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D, AC_USER_GROUPS L ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_STAFF_ID = L.AC_STAFF_ID ");
		sqlStr.append("AND    S.CO_ENABLED = L.AC_ENABLED ");
		sqlStr.append("AND    L.AC_GROUP_ID = 'nominate.ignore.list' ");
		sqlStr.append("AND    S.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    S.CO_STATUS = 'FT' ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE NOT IN ('400', '880') ");
		sqlStr.append("AND    S.CO_STAFF_ID NOT LIKE '9%' ");
		sqlStr.append("AND    S.CO_STAFF_ID NOT LIKE 'DR%' ");
		sqlStr.append("AND    S.CO_STAFF_ID != 'IPD' ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = ? ");
		sqlStr.append(")");
		sqlStr.append("ORDER BY CO_STAFFNAME, CO_STAFF_ID");
		sqlStr_getStaffListAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT S.CO_DEPARTMENT_CODE, DECODE(S.CO_DEPARTMENT_DESC, null, D.CO_DEPARTMENT_DESC, S.CO_DEPARTMENT_DESC), ");
		sqlStr.append("       S.CO_STAFF_ID, S.CO_STAFFNAME, S.CO_STATUS, ");
		sqlStr.append("       TO_CHAR(S.CO_ANNUAL_INCR, 'MM'), TO_CHAR(S.CO_HIRE_DATE,'MM/YYYY'), TO_CHAR(S.CO_HIRE_DATE,'DD/MM/YYYY'), ");
		sqlStr.append("       S.CO_DISPLAY_NAME, S.CO_DISPLAY_PHOTO ");
		sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		//sqlStr.append("AND    S.CO_STATUS = 'FT' ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_STAFF_ID NOT LIKE 'DR%' ");
		sqlStr.append("AND    S.CO_MARK_DELETED='N'  ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = ? ");
		sqlStr.append("ORDER BY CO_STAFFNAME, CO_STAFF_ID");
		sqlStr_getEShareNomineeList = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_DEPARTMENT_CODE, CO_DEPARTMENT_DESC ");
		sqlStr.append("FROM   CO_DEPARTMENTS ");
		sqlStr.append("WHERE  CO_DEPARTMENT_CODE IN (");
		sqlStr.append("SELECT DISTINCT A.CO_DEPARTMENT_CODE FROM (");
		sqlStr.append("(");
		sqlStr.append("SELECT S.CO_DEPARTMENT_CODE, S.CO_STAFF_ID ");
		sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    S.CO_STATUS in('FT','FTW') ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE NOT IN ('400', '880') ");
		sqlStr.append("AND    S.CO_STAFF_ID NOT LIKE '9%' ");
		sqlStr.append("AND    S.CO_STAFF_ID NOT LIKE 'DR%' ");
		sqlStr.append("AND    S.CO_STAFF_ID != 'IPD' ");
		sqlStr.append(") MINUS (");
		sqlStr.append("SELECT S.CO_DEPARTMENT_CODE, S.CO_STAFF_ID ");
		sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D, AC_USER_GROUPS L ");
		sqlStr.append("WHERE  S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_STAFF_ID = L.AC_STAFF_ID ");
		sqlStr.append("AND    S.CO_ENABLED = L.AC_ENABLED ");
		sqlStr.append("AND    L.AC_GROUP_ID = 'nominate.ignore.list' ");
		sqlStr.append("AND    S.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    S.CO_STATUS in('FT','FTW') ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE NOT IN ('400', '880') ");
		sqlStr.append("AND    S.CO_STAFF_ID NOT LIKE '9%' ");
		sqlStr.append("AND    S.CO_STAFF_ID NOT LIKE 'DR%' ");
		sqlStr.append("AND    S.CO_STAFF_ID != 'IPD' ");
		sqlStr.append(")) A)");
		sqlStr.append("ORDER BY CO_DEPARTMENT_DESC");
		sqlStr_getDeptCodeListAction = sqlStr.toString();
	}

	public static ArrayList getNomList(String module,String year) {


		StringBuffer sqlStr = new StringBuffer();



		sqlStr.append("SELECT V.HRD_NOMINATION_YEAR, V.HRD_NOMINATEE_STAFF_ID, S1.CO_STAFFNAME, D1.CO_DEPARTMENT_DESC, ");
		sqlStr.append("V.HRD_STAFF_ID, S2.CO_STAFFNAME, D2.CO_DEPARTMENT_DESC, V.HRD_COMMENT_DESC ");
		if(module != null){
			if(module.equals("starOfTheQuarter") || module.equals("yearOfEmp_starOfQuart")){
				sqlStr.append(",V.HRD_DEPENDABLE,V.HRD_FLEXIBLE,V.HRD_HASINITIATIVE,V.HRD_POSITIVE,V.HRD_COMPASSIONATE,V.HRD_TOTAL ");
			}else if(module.equals("yearOfEmployee")){
				sqlStr.append(",V.HRD_DEPENDABLE,V.HRD_FLEXIBLE,V.HRD_HASINITIATIVE,V.HRD_POSITIVE,V.HRD_COMPASSIONATE,V.HRD_SENSE,V.HRD_MANAGING,V.HRD_TOTAL ");
			}
		}
		sqlStr.append(",to_char(V.HRD_CREATED_DATE,'dd/mm/yyyy'),V.HRD_ALLOWDISPLAY, V.HRD_NOMINATOR_EMAIL, V.HRD_NOMINATOR_TEL FROM   HRD_EMPLOYEE_VOTE V, CO_STAFFS S1, CO_STAFFS S2, CO_DEPARTMENTS D1,CO_DEPARTMENTS D2 ");

		sqlStr.append("WHERE  V.HRD_NOMINATEE_STAFF_ID = S1.CO_STAFF_ID ");
		sqlStr.append("AND    S1.CO_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    V.HRD_STAFF_ID = S2.CO_STAFF_ID ");
		sqlStr.append("AND    S2.CO_DEPARTMENT_CODE = D2.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND HRD_ENABLED = '1' ");

		if(module != null){
			if(module.equals("yearOfEmp_starOfQuart")){
				sqlStr.append("AND ('starOfTheQuarter' = V.HRD_MODULE OR 'yearOfEmployee' = V.HRD_MODULE) ");
			}else if(!module.equals("ALL")){
				sqlStr.append("AND '" + module + "' = V.HRD_MODULE ");
			}
		}
		if(year != null && year.length()>0){
			sqlStr.append("AND '" + year + "' = V.HRD_NOMINATION_YEAR ");

		}


		sqlStr.append("ORDER BY V.HRD_CREATED_DATE desc,V.HRD_NOMINATEE_STAFF_ID ");
		System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}



}