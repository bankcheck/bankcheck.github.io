/*
 * Created on April 8, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class Budget {

	private static String sqlStr_insertCETotal = null;
	private static String sqlStr_updateCETotal= null;
	private static String sqlStr_deleteCETotal= null;

	private  static String getNextCETotalID() {
		String ceTotalID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CE_Total_ID) + 1 FROM CE_Total");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			ceTotalID = reportableListObject.getValue(0);

			// set 1 for initial
			if (ceTotalID == null || ceTotalID.length() == 0) return "1";
		}
		return ceTotalID;
	}
	public static ArrayList getBudgetList(String ceTotalID) {
		return getBudgetList(ceTotalID, null,null,null);
	}

	public static ArrayList getBudgetList(String staffID, String deptCode, String budgetYear) {
		return getBudgetList(null, staffID,deptCode,budgetYear);
	}

	public static ArrayList getBudgetList(String ceTotalID, String staffID, String deptCode, String budgetYear) {
		// fetch ce Total list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT T.CE_TOTAL_ID, T.CE_SITE_CODE, T.CE_DEPT_ID, T.CE_DEPT_DESC, T.CE_POSITION_DESC,  ");
		sqlStr.append("      T.CE_POSITION_CODE, TO_CHAR(T.CE_HIRE_DATE,'DD/MM/YYYY'),  S.CO_STAFFNAME, ");
		sqlStr.append("      T.CE_STAFF_ID, TO_CHAR(T.CE_B_YEAR,'YYYY'), T.CE_BY_HOURS, T.CE_BY_AMOUNT,T.CE_BL_HOURS,  ");
		sqlStr.append("       T.CE_BL_AMOUNT, T.CE_REMARK  ");
		sqlStr.append("FROM CE_Total T, CO_STAFFS S ");
		sqlStr.append("WHERE  T.CE_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    T.CE_STAFF_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    T.CE_ENABLED = 1 ");
		if (ceTotalID != null && ceTotalID.length() > 0) {
			sqlStr.append("AND   (T.CE_TOTAL_ID = '");
			sqlStr.append(ceTotalID+"') ");
		}
		if (staffID != null && staffID.length() > 0) {
			sqlStr.append("AND   (T.CE_STAFF_ID = '");
			sqlStr.append(staffID+"') ");
		}
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    T.CE_DEPT_ID = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if (budgetYear != null && budgetYear.length() > 0) {
			sqlStr.append("AND    TO_CHAR(T.CE_B_YEAR,'YYYY')= '");
			sqlStr.append(budgetYear);
			sqlStr.append("' ");
		}
		sqlStr.append("ORDER BY T.CE_DEPT_ID, T.CE_STAFF_ID");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	/**
	 * Add a CETotal record
	 */
	public static boolean add(UserBean userBean,
			String siteCode, String deptID, String deptName,
			String positionDesc, String positionCode, String hireDate,
			String staffID, String budgetYear, String BYAmount,
			String BYHours, String BLAmount, String BLHours,String remark) {

		// get next ceTotal ID
		String ceTotalID = getNextCETotalID();

		return( UtilDBWeb.updateQueue(
				sqlStr_insertCETotal,
				new String[] { ceTotalID, siteCode, deptID,
						       deptName, positionDesc, positionCode, hireDate, staffID,
						       "01/01/"+budgetYear, BYAmount, BYHours, BLAmount,BLHours,remark,
						       userBean.getLoginID(), userBean.getLoginID()} ));
	}

	/**
	 * Modify a CETotal
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String staffID,
			String deptCode,
			String deptDesc,
			String positionDesc,
			String positionCode,
			String budgetYearHours,
			String budgetYearAmount,
			String leftBudgetYearHours,
			String leftBudgetYearAmount,
			String remarks) {
		// try to update selected record
		return UtilDBWeb.updateQueue(
				sqlStr_updateCETotal,
				new String[] { deptCode, deptDesc, positionDesc, positionCode, budgetYearHours,
						budgetYearAmount, leftBudgetYearHours, leftBudgetYearAmount,remarks,
						userBean.getLoginID(), userBean.getSiteCode(), staffID });
	}

	public static boolean delete(UserBean userBean,
			String ceTotalID) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteCETotal,
				new String[] { userBean.getLoginID(), ceTotalID } );
	}

	public static boolean isExist(String staffID, String siteCode,String year) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CE_TOTAL");
		sqlStr.append("WHERE  CE_SITE_CODE =? ");
		sqlStr.append("AND    CE_STAFF_ID = ? ");
		sqlStr.append("AND    TO_CHAR(CE_B_YEAR,'YYYY')=? ");
		sqlStr.append("AND    CE_ENABLED = 1");
		return UtilDBWeb.isExist(sqlStr.toString(), new String[] { staffID, siteCode, year });
	}

	public static boolean isExist(String siteCode,String year) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT 1 ");
		sqlStr.append("FROM   CE_TOTAL ");
		sqlStr.append("WHERE  CE_SITE_CODE =? ");
		sqlStr.append("AND    TO_CHAR(CE_B_YEAR,'YYYY')=? ");
		sqlStr.append("AND    CE_ENABLED = 1 ");
		return UtilDBWeb.isExist(sqlStr.toString(), new String[] {siteCode, year });
	}

	public static boolean createBudgetLeftRecords(String siteCode,String currentYear){
		String lastYear=Integer.toString(Integer.parseInt(currentYear)-1);
		StringBuffer sqlStr = new StringBuffer();

			sqlStr.append("insert into ce_total ( CE_TOTAL_ID, CE_SITE_CODE, CE_DEPT_DESC,ce_dept_id,CE_POSITION_DESC,ce_position_code, CE_HIRE_DATE,CE_STAFF_ID,  ");
			sqlStr.append("   CE_B_YEAR,CE_BY_HOURS,CE_BY_AMOUNT,CE_BL_HOURS,CE_BL_AMOUNT,CE_CREATED_USER, CE_MODIFIED_USER)  ");
			sqlStr.append("(select (SELECT MAX(CE_Total_ID) + 1 FROM CE_Total)+rownum,al.ce_site_code, al.ce_dept_desc,'', al.ce_position_desc,'', ");
			sqlStr.append("       al.ce_hire_date, al.ce_staff_id,to_date(?,'dd/mm/yyyy'), ");
			sqlStr.append("       al.ce_by_hours, al.ce_by_amount, ");
			sqlStr.append("       (al.ce_by_amount+ al.ce_bl_amount)-   nvl(bl.amount,0) , ");
			sqlStr.append("                  (al.ce_by_hours+ al.ce_bl_hours)-nvl(bl.hours,0) ,'SYSTEM','SYSTEM'  ");
			sqlStr.append("            from ce_total al ,(select nvl(sum(ct.ce_amount),0) as amount, nvl(sum(ct.ce_hours),0) as hours, ct.ce_staff_id ");
			sqlStr.append("                from ce_approved_trans ct   ");
			sqlStr.append("                where ct.ce_enabled=1 ");
			sqlStr.append("                and to_char(ct.ce_approved_date,'yyyy')=? ");
			sqlStr.append("                group by ct.ce_staff_id) bl ");
			sqlStr.append("            where al.ce_enabled=1  ");
			sqlStr.append("            and al.ce_staff_id=bl.ce_staff_id(+) ");
			sqlStr.append("            and al.ce_site_code=? ");
			sqlStr.append("            and to_char(al.ce_b_year,'yyyy')=? ");
			sqlStr.append("            and al.ce_staff_id  ");
			sqlStr.append("       	   in (	select ta.ce_staff_id  ");
			sqlStr.append("					from ce_total ta, co_staffs st  ");
			sqlStr.append("					where ta.ce_staff_id=st.co_staff_id  ");
			sqlStr.append("					and st.co_enabled=1  ");
			sqlStr.append("					and ta.ce_enabled=1  ");
			sqlStr.append("					and to_char(ta.ce_b_year,'yyyy')=?)) ");

			return( UtilDBWeb.updateQueue(sqlStr.toString() ,new String[] {"01/01/"+ currentYear,lastYear,siteCode,lastYear,lastYear }));
	}

	public static boolean createBudgetRecords(String siteCode,String year){
			boolean isExist=isExist(siteCode,year);
			if(!isExist){
		createEmptyBudgetLeftRecords(siteCode,year);
		createBudgetLeftRecords(siteCode,year);
			}
			return isExist;
		}
	public static boolean createEmptyBudgetLeftRecords(String siteCode,String currentYear){
		String lastYear=Integer.toString(Integer.parseInt(currentYear)-1);


		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("insert into ce_total (  CE_TOTAL_ID, CE_SITE_CODE, CE_DEPT_DESC, ce_dept_id, CE_POSITION_DESC, ce_position_code, CE_HIRE_DATE,CE_STAFF_ID, ");
		sqlStr.append("    CE_B_YEAR,CE_BY_HOURS,CE_BY_AMOUNT,CE_BL_HOURS,CE_BL_AMOUNT,CE_CREATED_USER, CE_MODIFIED_USER)  ");
		sqlStr.append("    (select (SELECT MAX(CE_Total_ID) FROM CE_Total)+rownum,co_site_code, co_department_desc, ");
		sqlStr.append("    co_department_code, '', '', co_hire_date, co_staff_id,to_date(?,'dd/mm/yyyy'), ");
		sqlStr.append("    (SELECT min(ce_by_hours) FROM CE_Total),(SELECT min(ce_by_amount) FROM CE_Total),0,0,'SYSTEM','SYSTEM' ");
		sqlStr.append("            from co_staffs  ");
		sqlStr.append("            where  co_enabled=1 and co_status='FT' and co_site_code=? and co_staff_id ");
		sqlStr.append("            not in ( select ce_staff_id from ce_total where ce_enabled=1 and to_char(ce_b_year,'yyyy')=?))");
		return( UtilDBWeb.updateQueue(sqlStr.toString() ,new String[] { "01/01/"+currentYear,siteCode,lastYear}));
	}



	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CE_Total (CE_Total_ID, CE_SITE_CODE,CE_DEPT_ID, ");
		sqlStr.append("			   CE_DEPT_DESC,CE_POSITION_DESC, CE_POSITION_CODE, CE_HIRE_DATE,CE_STAFF_ID, ");
		sqlStr.append("			   TO_DATE(CE_B_YEAR,'DD,MM,YYYY'), CE_BY_HOURS,CE_BY_AMOUNT, CE_BL_HOURS,CE_BL_AMOUNT,CE_REMARK, ");
		sqlStr.append("            CE_CREATED_USER, CE_MODIFIED_USER) ");
		sqlStr.append("VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
		sqlStr_insertCETotal = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CE_TOTAL ");
		sqlStr.append("SET    CE_DEPT_ID = ?, CE_DEPT_DESC = ?, CE_POSITION_DESC = ?, CE_POSITION_CODE=?, ");
		sqlStr.append("       CE_BY_HOURS = ?, CE_BY_AMOUNT = ?, CE_BL_HOURS = ? ,CE_BL_AMOUNT = ?, CE_REMARK = ?, ");
		sqlStr.append("       CE_MODIFIED_DATE = SYSDATE, CE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CE_SITE_CODE = ? ");
		sqlStr.append("AND    CE_STAFF_ID = ? ");
		sqlStr.append("AND    CE_ENABLED = 1 ");
		sqlStr_updateCETotal = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CE_TOTAL ");
		sqlStr.append("SET    CE_ENABLED = 0, CE_MODIFIED_DATE = SYSDATE, CE_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CE_Total_ID= ?");
		sqlStr.append("AND    CE_ENABLED = 1 ");
		sqlStr_deleteCETotal = sqlStr.toString();
	}

}