package com.hkah.web.db;

import java.util.ArrayList;
import java.util.Vector;

import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class CorporatePlanGoalDB {
	private static String sqlStr_insertGoal = null;
	private static String sqlStr_deleteGoal = null;
	private static String sqlStr_getGoal = null;
	private static String sqlStr_getGoals = null;

	private static String sqlStr_approveGoal = null;
	private static String sqlStr_rejectGoal = null;
	private static String sqlStr_approveTotalCost = null;
	private static String sqlStr_approveEquipmentCost = null;
	private static String sqlStr_approveRecruitmentCost = null;
	private static String sqlStr_approveFTE = null;
	private static String sqlStr_approveRenovationCost = null;
	// Goal
	private static String getNextGoalID(String siteCode, String fiscalYear, String deptCode ,String planID) {
		String goalID = null;

		// get next goalID from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(DS_GOAL_ID) + 1 FROM DS_GOAL WHERE DS_SITE_CODE = ? AND DS_FINANCIAL_YEAR = ? AND DS_DEPARTMENT_CODE = ? AND DS_PLAN_ID = ?",
				new String[] { siteCode, fiscalYear, deptCode, planID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			goalID = reportableListObject.getValue(0);

			// set 1 for initial
			if (goalID == null || goalID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return goalID;
	}
	
	private static String getNextGoalOrder(String siteCode, String fiscalYear, String deptCode ,String planID) {
		String goalOrder = null;

		// get next goalID from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(DS_GOAL_ORDER) + 1 FROM DS_GOAL WHERE DS_SITE_CODE = ? AND DS_FINANCIAL_YEAR = ? AND DS_DEPARTMENT_CODE = ? AND DS_PLAN_ID = ? AND DS_ENABLED = 1",
				new String[] { siteCode, fiscalYear, deptCode, planID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			goalOrder = reportableListObject.getValue(0);

			// set 1 for initial
			if (goalOrder == null || goalOrder.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return goalOrder;
	}
	/**
	 * Add a Goal
	 */
	public static String add(UserBean userBean,
			String fiscalYear, String deptCode, String planID,
			String description,
			String corpObjective, String corpObjectiveOther, String focus, String focusOther,
			String totalCost, String equipmentCost, String recruitmentCost, String FTE) {

		// get next schedule ID
		String goalID = getNextGoalID(userBean.getSiteCode(), fiscalYear, deptCode, planID);
		String goalOrder = getNextGoalOrder(userBean.getSiteCode(), fiscalYear, deptCode, planID);

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertGoal,
				new String[] {
						userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID,
						description,
						corpObjective, corpObjectiveOther, focus, focusOther, 
						totalCost, equipmentCost, recruitmentCost, FTE,
						userBean.getLoginID(), userBean.getLoginID(),goalOrder })) {
			return goalID;
		} else {
			return null;
		}
	}
	/**
	 * Update a Goal Order
	 * @return whether it is successful to update the record
	 */
	public static boolean updateOrder(UserBean userBean,String fiscalYear, String deptCode, String planID, String direction, String goalOrder){
		
		StringBuffer sqlStr = new StringBuffer();
		String targetGoalID = null;
		Integer orderChange  = 0;
		
		
		if("up".equals(direction)){
			orderChange = Integer.parseInt(goalOrder)-1;
		}else if ("down".equals(direction)){
			orderChange = Integer.parseInt(goalOrder)+1;
		}
		
		sqlStr.append("SELECT DS_GOAL_ID FROM DS_GOAL ");
			sqlStr.append("WHERE DS_SITE_CODE = ? " );
			sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
			sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
			sqlStr.append("AND    DS_PLAN_ID = ? ");
			sqlStr.append("AND    DS_GOAL_ORDER = ?");
			sqlStr.append("AND 	  DS_ENABLED = 1" );
			
		
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(),new String[] {userBean.getSiteCode(), fiscalYear, deptCode, planID,orderChange.toString() });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			targetGoalID = reportableListObject.getValue(0);
			
		}
		if(targetGoalID != null || result.size() > 0){
		sqlStr.setLength(0);
		sqlStr.append(" UPDATE DS_GOAL ");
		sqlStr.append(" SET DS_GOAL_ORDER = ? ");
		sqlStr.append("WHERE DS_SITE_CODE = ? " );
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ORDER = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		
		UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {orderChange.toString(),userBean.getSiteCode(),fiscalYear,deptCode, planID, goalOrder } );
		
		sqlStr.setLength(0);
		sqlStr.append(" UPDATE DS_GOAL ");
		sqlStr.append(" SET DS_GOAL_ORDER = ?  ");
		sqlStr.append("WHERE DS_SITE_CODE = ? " );
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {goalOrder,userBean.getSiteCode(),fiscalYear,deptCode, planID, targetGoalID } );
		}
		return false;
	}
	
	
	
	/**
	 * Modify a Goal
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID,
			String description,
			String corpObjective, String corpObjectiveOther, String focus, String focusOther,
			String totalCost, String equipmentCost, String recruitmentCost, String FTE, String renovationCost,
			String totalCostActual, String equipmentCostActual, String recruitmentCostActual, String FTEActual,String renovationCostActual,
			String totalCostRemark,String totalCostApprovedRemark, String totalCostActualRemark, 
			String recruitmentCostRemark, String recruitmentCostApprovedRemark,String recruitmentCostActualRemark, 
			String FTERemark, String FTEApprovedRemark, String FTEActualRemark, 
			String equipmentCostRemark, String equipmentCostApprovedRemark, String equipmentCostActualRemark,
			String renovationCostRemark, String renovationCostApprovedRemark, String renovationCostActualRemark ) {

		Vector fieldValue = new Vector();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE DS_GOAL ");
		sqlStr.append("SET    DS_MODIFIED_DATE = SYSDATE, ");
		if (description != null) {
			sqlStr.append("       DS_DESC = ?, ");
			fieldValue.add(description);
		}
		if (corpObjective != null) {
			sqlStr.append("       DS_CORP_OBJECTIVE = ?, ");
			fieldValue.add(corpObjective);
		}
		if (corpObjectiveOther != null) {
			sqlStr.append("       DS_CORP_OBJECTIVE_OTHER = ?, ");
			fieldValue.add(corpObjectiveOther);
		}
		if (focus != null) {
			sqlStr.append("       DS_FOCUS = ?, ");
			fieldValue.add(focus);
		}
		if (focusOther != null) {
			sqlStr.append("       DS_FOCUS_OTHER = ?, ");
			fieldValue.add(focusOther);
		}
		if (totalCost != null) {
			sqlStr.append("       DS_TOTAL = ?, ");
			fieldValue.add(totalCost);
		}
		if (equipmentCost != null) {
			sqlStr.append("       DS_EQUIPMENT = ?, ");
			fieldValue.add(equipmentCost);
		}
		if (recruitmentCost != null) {
			sqlStr.append("       DS_RECRUIT = ?, ");
			fieldValue.add(recruitmentCost);
		}
		if (renovationCost != null) {
			sqlStr.append("       DS_RENOVATION = ?, ");
			fieldValue.add(renovationCost);
		}
		if (FTE != null) {
			sqlStr.append("       DS_FTE = ?, ");
			fieldValue.add(FTE);
		}
		if (totalCostActual != null) {
			sqlStr.append("       DS_TOTAL_ACTUAL = ?, ");
			fieldValue.add(totalCostActual);
		}
		if (equipmentCostActual != null) {
			sqlStr.append("       DS_EQUIPMENT_ACTUAL = ?, ");
			fieldValue.add(equipmentCostActual);
		}
		if (recruitmentCostActual != null) {
			sqlStr.append("       DS_RECRUIT_ACTUAL = ?, ");
			fieldValue.add(recruitmentCostActual);
		}
		if (FTEActual != null) {
			sqlStr.append("       DS_FTE_ACTUAL = ?, ");
			fieldValue.add(FTEActual);
		}
		if (renovationCostActual != null) {
			sqlStr.append("       DS_RENOVATION_ACTUAL = ?, ");
			fieldValue.add(renovationCostActual);
		}
		if(totalCostRemark != null ){
			sqlStr.append("		DS_TOTAL_REMARK = ?, ");
			fieldValue.add(totalCostRemark);
		}
		if(totalCostApprovedRemark != null ){
			sqlStr.append("		DS_TOTAL_APPROVED_REMARK = ?, ");
			fieldValue.add(totalCostApprovedRemark);
		}
		if(totalCostActualRemark != null ){
			sqlStr.append("		DS_TOTAL_ACTUAL_REMARK = ?, ");
			fieldValue.add(totalCostActualRemark);
		}
		if(equipmentCostRemark != null){
			sqlStr.append("		DS_EQUIPMENT_REMARK = ?, ");
			fieldValue.add(equipmentCostRemark);
		}
		if(equipmentCostApprovedRemark != null){
			sqlStr.append("		DS_EQUIPMENT_APPROVED_REMARK = ?, ");
			fieldValue.add(equipmentCostApprovedRemark);
		}
		if(equipmentCostActualRemark != null){
			sqlStr.append("		DS_EQUIPMENT_ACTUAL_REMARK = ?, ");
			fieldValue.add(equipmentCostActualRemark);
		}
		if(recruitmentCostRemark != null ){
			sqlStr.append("		DS_RECRUIT_REMARK = ?, ");
			fieldValue.add(recruitmentCostRemark);
		}
		if(recruitmentCostApprovedRemark != null ){
			sqlStr.append("		DS_RECRUIT_APPROVED_REMARK = ?, ");
			fieldValue.add(recruitmentCostApprovedRemark);
		}	
		if(recruitmentCostActualRemark != null ){
			sqlStr.append("		DS_RECRUIT_ACTUAL_REMARK = ?, ");
			fieldValue.add(recruitmentCostActualRemark);
		}		
		if(FTERemark != null ){
			sqlStr.append("		DS_FTE_REMARK = ?, ");
			fieldValue.add(FTERemark);
		}
		if(FTEApprovedRemark != null ){
			sqlStr.append("		DS_FTE_APPROVED_REMARK = ?, ");
			fieldValue.add(FTEApprovedRemark);
		}
		if(FTEActualRemark != null ){
			sqlStr.append("		DS_FTE_ACTUAL_REMARK = ?, ");
			fieldValue.add(FTEActualRemark);
		}
		if(renovationCostRemark != null ){
			sqlStr.append("		DS_RENOVATION_REMARK = ?, ");
			fieldValue.add(renovationCostRemark);
		}
		if(renovationCostApprovedRemark != null ){
			sqlStr.append("		DS_RENOVATION_APPROVED_REMARK = ?, ");
			fieldValue.add(renovationCostApprovedRemark);
		}
		if(renovationCostActualRemark != null ){
			sqlStr.append("		DS_RENOVATION_ACTUAL_REMARK = ?, ");
			fieldValue.add(renovationCostActualRemark);
		}		
		sqlStr.append("		  DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		fieldValue.add(userBean.getLoginID());
		fieldValue.add(userBean.getSiteCode());
		fieldValue.add(fiscalYear);
		fieldValue.add(deptCode);
		fieldValue.add(planID);
		fieldValue.add(goalID);

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				(String[]) fieldValue.toArray(new String[fieldValue.size()]) );
	}

	/**
	 * delete Goal
	 */
	public static boolean delete(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID) {
		// try to delete selected record
		String deleteGoalOrder = null;
		if ( UtilDBWeb.updateQueue(
				sqlStr_deleteGoal,
				new String[] { userBean.getLoginID(), userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID }))
		    {
					ArrayList result = UtilDBWeb.getReportableList(
					"SELECT DS_GOAL_ORDER FROM DS_GOAL WHERE DS_SITE_CODE = ? AND DS_FINANCIAL_YEAR = ? AND DS_DEPARTMENT_CODE = ? AND DS_PLAN_ID = ? AND DS_GOAL_ID = ? ",
					new String[] {userBean.getSiteCode(),fiscalYear, deptCode, planID,goalID });
					if(result.size()>0){
						ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
						deleteGoalOrder = reportableListObject.getValue(0);
					}
					
					ArrayList result1 = UtilDBWeb.getReportableList(
							"SELECT DS_GOAL_ID FROM DS_GOAL WHERE DS_SITE_CODE = ? AND DS_FINANCIAL_YEAR = ? AND DS_DEPARTMENT_CODE = ? AND DS_PLAN_ID = ? AND DS_GOAL_ORDER > "+deleteGoalOrder+" AND DS_ENABLED = 1 ORDER BY DS_GOAL_ORDER ",
							new String[] {userBean.getSiteCode(),fiscalYear, deptCode, planID});
						    int j = Integer.parseInt(deleteGoalOrder);
					
						if (result1.size() > 0) {
							for(int i =0; i<result1.size();i++)
							{	 
								ReportableListObject reportableListObject = (ReportableListObject) result1.get(i);
								UtilDBWeb.updateQueue(
								"UPDATE DS_GOAL SET DS_GOAL_ORDER = "+j+" WHERE DS_SITE_CODE = ? AND    DS_FINANCIAL_YEAR = ? AND    DS_DEPARTMENT_CODE = ? AND    DS_PLAN_ID = ? AND    DS_GOAL_ID = ? AND DS_ENABLED = 1",
								new String[] {userBean.getSiteCode(),fiscalYear,deptCode, planID, reportableListObject.getValue(0) } );
								j++;
							}
						}
			return true;
		    }
		else{
			return false;
		}
		
	}
	
	public static ArrayList get(UserBean userBean, String fiscalYear, String deptCode, String planID, String goalID) {
		// fetch plan
		return UtilDBWeb.getReportableList(
				sqlStr_getGoal,
				new String[] { userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID});
	}
	
	public static ArrayList getList(UserBean userBean,
			String fiscalYear, String deptCode, String planID) {
		// fetch plan
		return UtilDBWeb.getReportableList(
				sqlStr_getGoals,
				new String[] { userBean.getSiteCode(), fiscalYear, deptCode, planID});
	}
	
	/**
	 * approval
	 */
	public static boolean approve(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID) {

		// update approval
		return UtilDBWeb.updateQueue(
				sqlStr_approveGoal,
				new String[] { userBean.getLoginID(), userBean.getLoginID(),
						userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID });
	}

	public static boolean reject(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID) {

		// update approval
		return UtilDBWeb.updateQueue(
				sqlStr_rejectGoal,
				new String[] { userBean.getLoginID(),
						userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID });
	}

	public static boolean approveTotalCost(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID, String totalCostApproved) {

		// update approval
		return UtilDBWeb.updateQueue(
				sqlStr_approveTotalCost,
				new String[] { totalCostApproved, userBean.getLoginID(), userBean.getLoginID(),
						userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID });
	}

	public static boolean approveEquipmentCost(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID, String equipmentCostApproved) {

		// update approval
		return UtilDBWeb.updateQueue(
				sqlStr_approveEquipmentCost,
				new String[] { equipmentCostApproved, userBean.getLoginID(), userBean.getLoginID(),
						userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID });
	}

	public static boolean approveRecruitmentCost(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID, String recruitmentCostApproved) {

		// update approval
		return UtilDBWeb.updateQueue(
				sqlStr_approveRecruitmentCost,
				new String[] { recruitmentCostApproved, userBean.getLoginID(), userBean.getLoginID(),
						userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID });
	}

	public static boolean approveFTE(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID, String FTEApproved) {

		// update approval
		return UtilDBWeb.updateQueue(
				sqlStr_approveFTE,
				new String[] { FTEApproved, userBean.getLoginID(), userBean.getLoginID(),
						userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID });
	}
	
	public static boolean approveRenovationCost(UserBean userBean,
			String fiscalYear, String deptCode, String planID, String goalID, String renovationCostApproved) {

		// update approval
		return UtilDBWeb.updateQueue(
				sqlStr_approveRenovationCost,
				new String[] { renovationCostApproved, userBean.getLoginID(), userBean.getLoginID(),
						userBean.getSiteCode(), fiscalYear, deptCode, planID, goalID });
	}
	
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO DS_GOAL ");
		sqlStr.append("(DS_SITE_CODE, DS_FINANCIAL_YEAR, DS_DEPARTMENT_CODE, DS_PLAN_ID, DS_GOAL_ID, ");
		sqlStr.append("DS_DESC, ");
		sqlStr.append("DS_CORP_OBJECTIVE, DS_CORP_OBJECTIVE_OTHER, DS_FOCUS, DS_FOCUS_OTHER, ");
		sqlStr.append("DS_TOTAL, DS_EQUIPMENT, DS_RECRUIT, DS_FTE, ");
		sqlStr.append("DS_CREATED_USER, DS_MODIFIED_USER, DS_GOAL_ORDER ) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?,");
		sqlStr.append("?, ");
		sqlStr.append("?, ?, ?, ?,");
		sqlStr.append("?, ?, ?, ?,");
		sqlStr.append("?, ?, ? )");
		sqlStr_insertGoal = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_GOAL ");
		sqlStr.append("SET    DS_ENABLED = 0, DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_deleteGoal = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT G.DS_FINANCIAL_YEAR, G.DS_PLAN_ID, G.DS_GOAL_ID, ");
		sqlStr.append("       G.DS_DESC, ");
		sqlStr.append("       G.DS_CORP_OBJECTIVE, G.DS_CORP_OBJECTIVE_OTHER, G.DS_FOCUS, G.DS_FOCUS_OTHER, ");
		sqlStr.append("       G.DS_APPROVED, TO_CHAR(G.DS_APPROVED_DATE, 'dd/MM/YYYY'), G.DS_APPROVED_BY, ");
		sqlStr.append("       U.CO_FIRSTNAME || ' ' || U.CO_LASTNAME, ");
		// total cost
		sqlStr.append("       G.DS_TOTAL, G.DS_TOTAL_APPROVED, TO_CHAR(G.DS_TOTAL_APPROVAL_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       U1.CO_FIRSTNAME || ' ' || U1.CO_LASTNAME, G.DS_TOTAL_ACTUAL, ");
		// equipment cost
		sqlStr.append("       G.DS_EQUIPMENT, G.DS_EQUIPMENT_APPROVED, TO_CHAR(G.DS_EQUIPMENT_APPROVAL_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       U2.CO_FIRSTNAME || ' ' || U2.CO_LASTNAME, G.DS_EQUIPMENT_ACTUAL, ");
		// recruit cost
		sqlStr.append("       G.DS_RECRUIT, G.DS_RECRUIT_APPROVED, TO_CHAR(G.DS_RECRUIT_APPROVAL_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       U3.CO_FIRSTNAME || ' ' || U3.CO_LASTNAME, G.DS_RECRUIT_ACTUAL, ");
		// FTE
		sqlStr.append("       G.DS_FTE, G.DS_FTE_APPROVED, TO_CHAR(G.DS_FTE_APPROVAL_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       U4.CO_FIRSTNAME || ' ' || U4.CO_LASTNAME, G.DS_FTE_ACTUAL, ");
		//Remarks
		sqlStr.append("		  G.DS_TOTAL_REMARK, G.DS_TOTAL_APPROVED_REMARK, G.DS_TOTAL_ACTUAL_REMARK, ");
		sqlStr.append("		  G.DS_EQUIPMENT_REMARK, G.DS_EQUIPMENT_APPROVED_REMARK, G.DS_EQUIPMENT_ACTUAL_REMARK, ");
		sqlStr.append("		  G.DS_RECRUIT_REMARK, G.DS_RECRUIT_APPROVED_REMARK, G.DS_RECRUIT_ACTUAL_REMARK, ");
		sqlStr.append("		  G.DS_RENOVATION_REMARK, G.DS_RENOVATION_APPROVED_REMARK, G.DS_RENOVATION_ACTUAL_REMARK, ");	
		
		//renovation
		sqlStr.append("       G.DS_RENOVATION, G.DS_RENOVATION_APPROVED, TO_CHAR(G.DS_RENOVATION_APPROVAL_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       U5.CO_FIRSTNAME || ' ' || U5.CO_LASTNAME, G.DS_RENOVATION_ACTUAL ");
		
		sqlStr.append("FROM   DS_GOAL G, CO_USERS U, ");
		sqlStr.append("       CO_USERS U1, CO_USERS U2, CO_USERS U3, CO_USERS U4, CO_USERS U5 ");
		sqlStr.append("WHERE  G.DS_SITE_CODE = U.CO_SITE_CODE (+) ");
		sqlStr.append("AND	  G.DS_APPROVED_BY = U.CO_USERNAME (+) ");
		sqlStr.append("AND    G.DS_SITE_CODE = U1.CO_SITE_CODE (+) ");
		sqlStr.append("AND	  G.DS_TOTAL_APPROVAL_USER_ID = U1.CO_USERNAME (+) ");
		sqlStr.append("AND    G.DS_SITE_CODE = U2.CO_SITE_CODE (+) ");
		sqlStr.append("AND	  G.DS_EQUIPMENT_APPROVAL_USER_ID = U2.CO_USERNAME (+) ");
		sqlStr.append("AND    G.DS_SITE_CODE = U3.CO_SITE_CODE (+) ");
		sqlStr.append("AND	  G.DS_RECRUIT_APPROVAL_USER_ID = U3.CO_USERNAME (+) ");
		sqlStr.append("AND    G.DS_SITE_CODE = U4.CO_SITE_CODE (+) ");
		sqlStr.append("AND	  G.DS_FTE_APPROVAL_USER_ID = U4.CO_USERNAME (+) ");
		sqlStr.append("AND    G.DS_SITE_CODE = U5.CO_SITE_CODE (+) ");
		sqlStr.append("AND	  G.DS_RENOVATION_APPROVAL_USER_ID = U5.CO_USERNAME (+) ");
		sqlStr.append("AND    G.DS_SITE_CODE = ? ");
		sqlStr.append("AND    G.DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    G.DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    G.DS_PLAN_ID = ? ");
		sqlStr.append("AND    G.DS_GOAL_ID = ? ");
		sqlStr.append("AND	  G.DS_ENABLED = 1 ");
		sqlStr_getGoal = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT G.DS_FINANCIAL_YEAR, G.DS_PLAN_ID, G.DS_GOAL_ID, ");
		sqlStr.append("       G.DS_DESC, ");
		sqlStr.append("       G.DS_CORP_OBJECTIVE, G.DS_CORP_OBJECTIVE_OTHER, G.DS_FOCUS, G.DS_FOCUS_OTHER, ");
		sqlStr.append("       G.DS_APPROVED, TO_CHAR(G.DS_APPROVED_DATE, 'dd/MM/YYYY'), G.DS_APPROVED_BY, ");
		sqlStr.append("       U.CO_FIRSTNAME || ' ' || U.CO_LASTNAME, G.DS_GOAL_ORDER ");
		sqlStr.append("FROM   DS_GOAL G LEFT JOIN CO_USERS U ");
		sqlStr.append("ON	  G.DS_SITE_CODE = U.CO_SITE_CODE ");
		sqlStr.append("AND	  G.DS_APPROVED_BY = U.CO_USERNAME ");
		sqlStr.append("WHERE  G.DS_ENABLED = 1 ");
		sqlStr.append("AND    G.DS_SITE_CODE = ? ");
		sqlStr.append("AND    G.DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    G.DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    G.DS_PLAN_ID = ? ");
		sqlStr.append("ORDER BY	G.DS_GOAL_ORDER");
		sqlStr_getGoals = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_GOAL ");
		sqlStr.append("SET    DS_APPROVED = 'Y', DS_APPROVED_DATE = SYSDATE, DS_APPROVED_BY = ?, ");
		sqlStr.append("		  DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr.append("AND    DS_APPROVED = 'N' ");
		sqlStr_approveGoal = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_GOAL ");
		sqlStr.append("SET    DS_APPROVED = 'N', DS_APPROVED_DATE = '', DS_APPROVED_BY = '', ");
		sqlStr.append("		  DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr.append("AND    DS_APPROVED = 'Y' ");
		sqlStr_rejectGoal = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_GOAL ");
		sqlStr.append("SET    DS_TOTAL_APPROVED = ?, DS_TOTAL_APPROVAL_DATE = SYSDATE, DS_TOTAL_APPROVAL_USER_ID = ?, ");
		sqlStr.append("	      DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_approveTotalCost = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_GOAL ");
		sqlStr.append("SET    DS_EQUIPMENT_APPROVED = ?, DS_EQUIPMENT_APPROVAL_DATE = SYSDATE, DS_EQUIPMENT_APPROVAL_USER_ID = ?, ");
		sqlStr.append("		  DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_approveEquipmentCost = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_GOAL ");
		sqlStr.append("SET    DS_RECRUIT_APPROVED = ?, DS_RECRUIT_APPROVAL_DATE = SYSDATE, DS_RECRUIT_APPROVAL_USER_ID = ?, ");
		sqlStr.append("		  DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_approveRecruitmentCost = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_GOAL ");
		sqlStr.append("SET    DS_FTE_APPROVED = ?, DS_FTE_APPROVAL_DATE = SYSDATE, DS_FTE_APPROVAL_USER_ID = ?, ");
		sqlStr.append("		  DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_approveFTE = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE DS_GOAL ");
		sqlStr.append("SET    DS_RENOVATION_APPROVED = ?, DS_RENOVATION_APPROVAL_DATE = SYSDATE, DS_RENOVATION_APPROVAL_USER_ID = ?, ");
		sqlStr.append("		  DS_MODIFIED_DATE = SYSDATE, DS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DS_SITE_CODE = ? ");
		sqlStr.append("AND    DS_FINANCIAL_YEAR = ? ");
		sqlStr.append("AND    DS_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    DS_PLAN_ID = ? ");
		sqlStr.append("AND    DS_GOAL_ID = ? ");
		sqlStr.append("AND    DS_ENABLED = 1 ");
		sqlStr_approveRenovationCost = sqlStr.toString();
	}
}