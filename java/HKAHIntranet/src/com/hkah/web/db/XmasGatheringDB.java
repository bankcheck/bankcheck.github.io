package com.hkah.web.db;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class XmasGatheringDB {
	
	public static boolean isAllowSpecial(String staffID) {
		if ("04009".equals(staffID)) {	// blue
			return true;
		}
		if ("21126".equals(staffID)) {	// blue
			return true;
		}
		if ("21021".equals(staffID)) {	// blue
			return true;
		}
		if ("4567".equals(staffID)) {	// yellow
			return true;
		}
		if ("4796".equals(staffID)) {	// yellow
			return true;
		}
		if ("5685".equals(staffID)) {	// yellow
			return true;
		}
		if ("5925".equals(staffID)) {	// yellow
			return true;
		}
		if ("5965".equals(staffID)) {	// yellow
			return true;
		}
		if ("5978".equals(staffID)) {	// yellow
			return true;
		}
		return false;
	}
	
	public static boolean isAllow(String staffID) {
		StringBuffer sqlStr = new StringBuffer();

		if (getCurrentEventDate(false) == null) {
			return false;
		}

		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM ");
		sqlStr.append("( ");
		sqlStr.append("SELECT S.CO_STAFF_ID ");
		sqlStr.append("FROM CO_STAFFS S, CO_DEPARTMENTS D ");
		//sqlStr.append("WHERE 1=1 ");
		sqlStr.append("WHERE S.CO_STATUS <> 'CA' ");
		sqlStr.append("AND S.CO_STATUS <> 'UC' ");
		sqlStr.append("AND S.CO_ENABLED = 1 ");
		sqlStr.append("AND S.CO_SITE_CODE = ? ");
		sqlStr.append("AND S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_STAFF_ID NOT LIKE '9%' ");
		sqlStr.append("AND    S.CO_STAFF_ID NOT LIKE 'DR%' ");
		sqlStr.append("AND    S.CO_STAFF_ID != 'IPD' ");
		if(ConstantsServerSide.isHKAH()){		
			sqlStr.append("AND ");
			sqlStr.append("( ");
			sqlStr.append("	( ");
			sqlStr.append("		S.CO_HIRE_DATE IS NOT NULL ");
			sqlStr.append("		AND S.CO_HIRE_DATE <= TO_DATE('");
			//sqlStr.append(getCurrentEventDate(false));
			//sqlStr.append("30/11/2017");
			//sqlStr.append("30/11/2018");
			sqlStr.append("30/11/2019");
			sqlStr.append(" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
			sqlStr.append("	) ");
			sqlStr.append("	OR ");
			sqlStr.append("	( ");
			sqlStr.append("		S.CO_HIRE_DATE IS NULL ");
			sqlStr.append("		AND S.CO_CREATED_DATE <= TO_DATE('");
			//sqlStr.append(getCurrentEventDate(false));
			//sqlStr.append("30/11/2017");
			//sqlStr.append("30/11/2018");
			sqlStr.append("30/11/2019");
			sqlStr.append(" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
			sqlStr.append("	) ");
			sqlStr.append(") ");
		} else {
			sqlStr.append("AND ");
			sqlStr.append("( ");
			sqlStr.append("	( ");
			sqlStr.append("		S.CO_HIRE_DATE IS NOT NULL ");
			sqlStr.append("		AND S.CO_HIRE_DATE <= ADD_MONTHS(TO_DATE('");
			sqlStr.append(getCurrentEventDate(false));
			sqlStr.append(" 23:59:59', 'DD/MM/YYYY HH24:MI:SS'), 0) ");
			sqlStr.append("	) ");
			sqlStr.append("	OR ");
			sqlStr.append("	( ");
			sqlStr.append("		S.CO_HIRE_DATE IS NULL ");
			sqlStr.append("		AND S.CO_CREATED_DATE <= ADD_MONTHS(TO_DATE('");
			sqlStr.append(getCurrentEventDate(false));
			sqlStr.append(" 23:59:59', 'DD/MM/YYYY HH24:MI:SS'), 0) ");
			sqlStr.append("	) ");
			sqlStr.append(") ");
		}
		sqlStr.append("UNION ");
		sqlStr.append("SELECT S.CO_STAFF_ID ");
		sqlStr.append("FROM CO_STAFFS S, AC_USER_GROUPS G, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  S.CO_STAFF_ID = G.AC_STAFF_ID ");
		sqlStr.append("AND    S.CO_ENABLED = G.AC_ENABLED ");
		sqlStr.append("AND    G.AC_GROUP_ID = 'christmas.allow.ca' ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE NOT IN ('400', '880') ");
		sqlStr.append("AND    S.CO_STAFF_ID != 'IPD' ");
		sqlStr.append("MINUS ");
		sqlStr.append("SELECT S.CO_STAFF_ID ");
		sqlStr.append("FROM   CO_STAFFS S, AC_USER_GROUPS G, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  S.CO_STAFF_ID = G.AC_STAFF_ID ");
		sqlStr.append("AND    S.CO_ENABLED = G.AC_ENABLED ");
		sqlStr.append("AND    G.AC_GROUP_ID = 'christmas.notallow.staff' ");
		sqlStr.append("AND    S.CO_ENABLED = 1 ");
		sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE ");
		sqlStr.append("	) SL ");
		sqlStr.append("WHERE SL.CO_STAFF_ID = ? ");

		System.out.println(sqlStr.toString());

		return (UtilDBWeb.isExist(sqlStr.toString(), new String[] { ConstantsServerSide.SITE_CODE, staffID }));
	}

	public static String getCurrentEventDate(boolean nameOfMonth) {
		String eventID = getEventIDByCurrentYear();

		StringBuffer sqlStr = new StringBuffer();

		if (nameOfMonth) {
			sqlStr.append("SELECT TO_CHAR(TO_DATE(CO_EVENT_REMARK2, 'DD/MM/YYYY','NLS_DATE_LANGUAGE = American'), 'Day, DD FMMonth YYYY','NLS_DATE_LANGUAGE = American') ");
		}
		else {
			sqlStr.append("SELECT CO_EVENT_REMARK2 ");
		}
		sqlStr.append("FROM CO_EVENT ");
		sqlStr.append("WHERE CO_EVENT_ID = '"+eventID+"' ");
		sqlStr.append("AND CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");

		ArrayList<ReportableListObject> result =
					UtilDBWeb.getReportableList(sqlStr.toString());

		if (result.size() > 0) {
			ReportableListObject row = result.get(0);

			return row.getValue(0);
		}
		else {
			return null;
		}
	}

	public static String getEventIDByCurrentYear() {
		SimpleDateFormat smf = new SimpleDateFormat("yyyy", Locale.ENGLISH);

		return getEventIDByYear(smf.format(Calendar.getInstance().getTime()));
	}

	public static String getEventIDByYear(String year) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT MAX(CO_EVENT_ID) ");
		sqlStr.append("FROM CO_EVENT ");
		sqlStr.append("WHERE TO_CHAR(CO_CREATED_DATE, 'YYYY') = '"+year+"' ");
		sqlStr.append("AND CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");

		ArrayList<ReportableListObject> result =
							UtilDBWeb.getReportableList(sqlStr.toString());

		if (result.size() > 0) {
			ReportableListObject row = result.get(0);

			return row.getValue(0);
		}
		else {
			return null;
		}
	}

	public static ArrayList getGroupInfo(String eventID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT   CO_EVENT_ID,CO_SCHEDULE_ID,TO_CHAR(CO_SCHEDULE_START, 'DD/MM/YYYY'),TO_CHAR(CO_SCHEDULE_END, 'DD/MM/YYYY'),CO_SCHEDULE_SIZE, ");
		sqlStr.append("(SELECT CO_EVENT_REMARK FROM CO_EVENT WHERE CO_ENABLED = 1 AND   CO_EVENT_ID='"+eventID+"'	AND   CO_MODULE_CODE = 'christmas') ");
		sqlStr.append("FROM     CO_SCHEDULE ");
		sqlStr.append("WHERE    CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND      CO_ENABLED = 1 ");
		sqlStr.append("AND      CO_EVENT_ID = '"+eventID+"' ");
		sqlStr.append("AND		CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
		sqlStr.append("AND      CO_SCHEDULE_ID = '1' ");
		System.out.println("getGroupInfo : " + sqlStr.toString());

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getGroupWaitingCancelID(String eventID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT   CO_EVENT_ID,CO_SCHEDULE_ID,CO_SCHEDULE_DESC ");
		sqlStr.append("FROM     CO_SCHEDULE ");
		sqlStr.append("WHERE    CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND      CO_ENABLED = 1 ");
		sqlStr.append("AND      CO_EVENT_ID = '"+eventID+"' ");
		sqlStr.append("AND		CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
		sqlStr.append("AND      CO_SCHEDULE_DESC IN ('Cancel','Waiting') ");
		sqlStr.append("ORDER    BY CO_SCHEDULE_ID ");
		//System.out.println(sqlStr.toString());

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String getLastEnrolledSize(UserBean userBean, String eventID,
								String scheduleID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CO_ENROLL_NO ");
		sqlStr.append("FROM CO_ENROLLMENT ");
		sqlStr.append("WHERE CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND CO_EVENT_ID = '"+eventID+"' ");
		sqlStr.append("AND CO_SCHEDULE_ID = '"+scheduleID+"' ");
		sqlStr.append("AND CO_ENABLED = '1' ");
		sqlStr.append("AND CO_USER_ID = '"+userBean.getStaffID()+"' ");

		ArrayList<ReportableListObject> result =
								UtilDBWeb.getReportableList(sqlStr.toString());

		if (result.size() > 0) {
			ReportableListObject row = result.get(0);

			return row.getValue(0);
		}
		else {
			return null;
		}
	}

	public static boolean updateScheduleSize(UserBean userBean, String enrollNo,
									String eventID, String scheduleID) {
		String lastSize = getLastEnrolledSize(userBean, eventID, scheduleID);

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_SCHEDULE ");
		sqlStr.append("SET    CO_SCHEDULE_ENROLLED = CO_SCHEDULE_ENROLLED - ? + ?, ");
		sqlStr.append("CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr.append("AND    CO_SCHEDULE_ID = ? ");
		sqlStr.append("AND   (CO_SCHEDULE_SIZE >= CO_SCHEDULE_ENROLLED - ? + ? OR CO_SCHEDULE_SIZE = 0) ");
		sqlStr.append("AND    CO_ENABLED = 1");

		return UtilDBWeb.updateQueue(sqlStr.toString(),
				new String[] { lastSize, enrollNo, userBean.getLoginID(), "christmas",
								eventID, scheduleID, lastSize, enrollNo } );
	}

	public static boolean update(UserBean userBean, String eventID,
							String scheduleID, String enrollID, String enrollNo) {
		if (updateScheduleSize(userBean, enrollNo, eventID, scheduleID)) {
			return EnrollmentDB.update(userBean, "christmas", eventID, scheduleID,
					enrollID, "participant", userBean.getStaffID(), enrollNo);
		}
		return false;
	}

	public static int withdraw(UserBean userBean, String eventID,
								String scheduleID, String enrollID,
								String userID) {
		withdrawFamily(userBean, eventID, scheduleID, enrollID);

		return EnrollmentDB.withdraw(userBean, "christmas", eventID,
					scheduleID, enrollID, "participant",
					userBean.getStaffID());
	}

	public static int withdraw2(UserBean userBean, String eventID,
			String scheduleID, String enrollID,
			String userID) {
		withdrawFamily2(userID, eventID, scheduleID, enrollID);

		return EnrollmentDB.withdraw(userBean, "christmas", eventID,
					scheduleID, enrollID, "participant", userID);
	}

	public static int enroll(UserBean userBean, String eventID,
									String scheduleID, String enrollNo,
									String userID) {
		return EnrollmentDB.enroll(userBean, "christmas", eventID, scheduleID,
						enrollNo, "participant", userID);
	}

	public static int enroll2(UserBean userBean, String eventID,
			String scheduleID, String enrollNo,
			String userID) {
		return EnrollmentDB.enroll(userBean, "christmas", eventID, scheduleID,
		enrollNo, "participant",userID);
	}


	public static int enrollFamily(UserBean userBean, String eventID, String scheduleID,
						String enrollID, String familyTypeID, String occupy, String names, String mealType) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO ");
		sqlStr.append("CO_ENROLLMENT_FAMILY(CO_SITE_CODE, CO_MODULE_CODE, ");
		sqlStr.append("CO_EVENT_ID ,CO_SCHEDULE_ID, CO_ENROLL_ID, ");
		sqlStr.append("CO_FAMILY_TYPE_ID, CO_USER_ID, CO_ENROLL_NO, ");
		sqlStr.append("CO_CREATED_USER, CO_MODIFIED_USER, CO_REMARK, CO_MEAL_TYPE) ");
		sqlStr.append("VALUES ");
		sqlStr.append("('"+ConstantsServerSide.SITE_CODE+"', 'christmas', ");
		sqlStr.append("'"+eventID+"', '"+scheduleID+"', '"+enrollID+"', ");
		sqlStr.append("'"+familyTypeID+"', '"+userBean.getStaffID()+"', ");
		sqlStr.append("'"+occupy+"', '"+userBean.getLoginID()+"', ");
		sqlStr.append("'"+userBean.getLoginID()+"','"+names+"', '"+mealType+"')");

		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return 0;
		}
		else {
			return -1;
		}
	}

	public static int withdrawFamily(UserBean userBean, String eventID,
							String scheduleID, String enrollID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("DELETE FROM CO_ENROLLMENT_FAMILY ");
		sqlStr.append("WHERE CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
		sqlStr.append("AND CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND CO_EVENT_ID = '"+eventID+"' ");
		sqlStr.append("AND CO_SCHEDULE_ID = '"+scheduleID+"' ");
		sqlStr.append("AND CO_ENROLL_ID = '"+enrollID+"' ");
		sqlStr.append("AND CO_USER_ID = '"+userBean.getStaffID()+"' ");

		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return 0;
		}
		else {
			return -1;
		}
	}

	public static int withdrawFamily2(String userID, String eventID,
			String scheduleID, String enrollID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("DELETE FROM CO_ENROLLMENT_FAMILY ");
		sqlStr.append("WHERE CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
		sqlStr.append("AND CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND CO_EVENT_ID = '"+eventID+"' ");
		sqlStr.append("AND CO_SCHEDULE_ID = '"+scheduleID+"' ");
		sqlStr.append("AND CO_ENROLL_ID = '"+enrollID+"' ");
		sqlStr.append("AND CO_USER_ID = '"+userID+"' ");

		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return 0;
		}
		else {
			return -1;
		}
	}

	public static ArrayList getFamilyType() {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT   CO_FAMILYTYPE_ID, CO_FAMILYTYPE_DESC,CO_FAMILYTYPE_DISCOUNT,CO_FAMILYTYPE_DISCOUNT_DESC,CO_COUNT_SEATS ");
		sqlStr.append("FROM     CO_ENROLLMENT_FAMILYTYPE ");
		sqlStr.append("WHERE    CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND      CO_ENABLED = 1 ");
		sqlStr.append("AND 		CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
		sqlStr.append("ORDER BY CO_FAMILYTYPE_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getEnrolledFamilyType(UserBean userBean,
								String eventID, String scheduleID,
								String enrollID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CO_FAMILY_TYPE_ID, CO_ENROLL_NO, CO_REMARK ");
		sqlStr.append("FROM CO_ENROLLMENT_FAMILY ");
		sqlStr.append("WHERE CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
		sqlStr.append("AND CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND CO_EVENT_ID = '"+eventID+"' ");
		sqlStr.append("AND CO_SCHEDULE_ID = '"+scheduleID+"' ");
		sqlStr.append("AND CO_ENROLL_ID = '"+enrollID+"' ");
		sqlStr.append("AND CO_USER_ID = '"+userBean.getStaffID()+"' ");
		sqlStr.append("AND CO_ENABLED = '1' ");
		sqlStr.append("ORDER BY CO_FAMILY_TYPE_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static Map getEnrolledFamily(UserBean userBean, String eventID,
								String scheduleID,String type) {
		ArrayList fmType = getFamilyType();
		String enrollID = getEnrollID(userBean, eventID, scheduleID);

		Map<String, String> enrollMap = new HashMap<String, String>();

		if (fmType.size() > 0 && enrollID != null) {
			ArrayList enrolledFmType = getEnrolledFamilyType(userBean, eventID,
											scheduleID, enrollID);
			for (int i = 0; i < fmType.size(); i++) {
				ReportableListObject row = (ReportableListObject) fmType.get(i);
				if("count".equals(type)){
					enrollMap.put(row.getValue(0), "0");
				}else if("name".equals(type)){
					enrollMap.put(row.getValue(0), "");
				}
			}

			if (enrolledFmType.size() > 0) {
				for (int i = 0; i < enrolledFmType.size(); i++) {
					ReportableListObject row =
									(ReportableListObject) enrolledFmType.get(i);
					if("count".equals(type)){
						enrollMap.put(row.getValue(0), row.getValue(1));
					}else if("name".equals(type)){
						enrollMap.put(row.getValue(0), row.getValue(2));
					}
				}
			}
		}

		return enrollMap;
	}

	public static String getEnrollID(UserBean userBean, String eventID,
								String scheduleID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT MAX(CO_ENROLL_ID) ");
		sqlStr.append("FROM CO_ENROLLMENT ");
		sqlStr.append("WHERE CO_USER_ID = '"+userBean.getStaffID()+"' ");
		sqlStr.append("AND CO_EVENT_ID = '"+eventID+"' ");
		sqlStr.append("AND CO_SCHEDULE_ID = '"+scheduleID+"' ");
		sqlStr.append("AND CO_ENABLED = '1' ");
		sqlStr.append("AND CO_MODULE_CODE = 'christmas' ");
        sqlStr.append("AND CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");

        ArrayList<ReportableListObject> result =
								UtilDBWeb.getReportableList(sqlStr.toString());

        if (result.size() > 0) {
        	ReportableListObject row = result.get(0);

        	return row.getValue(0);
        }
        else {
        	return null;
        }
	}
	
	public static boolean updateMealType(UserBean userBean, String eventID, String scheduleID, String enrollID, String mealType, String busToRestType, String busToHospType) {
		// try to update record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    HAS_FOLLOWUP = '" + mealType + "', ");	
		sqlStr.append("		  CO_REMARK2 = '" + busToRestType + "', ");
		sqlStr.append("		  CO_REMARK3 = '" + busToHospType + "', ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = '" + userBean.getLoginID() + "' ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_EVENT_ID = '" + eventID + "' ");
		sqlStr.append("AND    CO_SCHEDULE_ID = '" + scheduleID + "' ");			
		sqlStr.append("AND    CO_ENROLL_ID = '" + enrollID + "' ");	 	
		sqlStr.append("AND    CO_ENABLED = 1");
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static String getPrice(String eventID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CO_EVENT_REMARK ");
		sqlStr.append("FROM CO_EVENT ");
		sqlStr.append("WHERE CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_EVENT_ID = '"+eventID+"' ");

		ArrayList<ReportableListObject> result =
								UtilDBWeb.getReportableList(sqlStr.toString());

		if (result.size() > 0) {
			ReportableListObject row = result.get(0);

			return row.getValue(0);
		}
		else {
			return null;
		}
	}

	public static String getEnrolledFamilyMembers(UserBean userBean,
							String eventID, String scheduleID, String enrollID,
							String staffID, boolean showMemberName,
							boolean tableFormat) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT FT.CO_FAMILYTYPE_DESC, F.CO_ENROLL_NO,F.CO_REMARK ");
		sqlStr.append("FROM CO_ENROLLMENT_FAMILY F, CO_ENROLLMENT_FAMILYTYPE FT ");
		sqlStr.append("WHERE F.CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
		sqlStr.append("AND F.CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND F.CO_EVENT_ID = '"+eventID+"' ");
		sqlStr.append("AND F.CO_SCHEDULE_ID = '"+scheduleID+"' ");
		sqlStr.append("AND F.CO_ENROLL_ID = '"+enrollID+"' ");
		sqlStr.append("AND F.CO_USER_ID = '"+staffID+"' ");
		sqlStr.append("AND F.CO_ENABLED = '1' ");
		sqlStr.append("AND FT.CO_SITE_CODE = F.CO_SITE_CODE ");
		sqlStr.append("AND FT.CO_MODULE_CODE = F.CO_MODULE_CODE ");
		sqlStr.append("AND FT.CO_FAMILYTYPE_ID = F.CO_FAMILY_TYPE_ID ");
		sqlStr.append("AND FT.CO_ENABLED = '1' ");
		sqlStr.append("ORDER BY FT.CO_FAMILYTYPE_ID ");

		ArrayList<ReportableListObject> result =
								UtilDBWeb.getReportableList(sqlStr.toString());

		//System.out.println(sqlStr.toString());

		if (result.size() > 0) {
			String members = "";
			if (tableFormat) {
				members = "<table>";
			}

			for (int i = 0; i < result.size(); i++) {
				ReportableListObject row = result.get(i);
				if (tableFormat) {
					members += "<tr></tr><tr><td>";
				}
				else {
					members += "<br/>";
				}

				members += row.getValue(0)+(tableFormat?" </td>":"")+
							((showMemberName)?
									(!tableFormat?
									"("+row.getValue(2)+"): ":
									("<td>("+row.getValue(2)+") </td><td>: </td>")):"<td>: </td>")+
							(tableFormat?"<td>"+row.getValue(1)+"</td></tr>":row.getValue(1));
			}
			if (tableFormat) {
				members += "</table>";
			}
			return members;
		}
		else {
			return null;
		}
	}

	public static String getParticipantPrice(UserBean userBean,
							String eventID, String scheduleID, String enrollID,
							String eventPrice, String staffID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT FT.CO_FAMILYTYPE_DISCOUNT, F.CO_ENROLL_NO ");
		sqlStr.append("FROM CO_ENROLLMENT_FAMILY F, CO_ENROLLMENT_FAMILYTYPE FT ");
		sqlStr.append("WHERE F.CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
		sqlStr.append("AND F.CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND F.CO_EVENT_ID = '"+eventID+"' ");
		sqlStr.append("AND F.CO_SCHEDULE_ID = '"+scheduleID+"' ");
		sqlStr.append("AND F.CO_ENROLL_ID = '"+enrollID+"' ");
		sqlStr.append("AND F.CO_USER_ID = '"+staffID+"' ");
		sqlStr.append("AND F.CO_ENABLED = '1' ");
		sqlStr.append("AND FT.CO_SITE_CODE = F.CO_SITE_CODE ");
		sqlStr.append("AND FT.CO_MODULE_CODE = F.CO_MODULE_CODE ");
		sqlStr.append("AND FT.CO_FAMILYTYPE_ID = F.CO_FAMILY_TYPE_ID ");
		sqlStr.append("AND FT.CO_ENABLED = '1' ");
		sqlStr.append("ORDER BY FT.CO_FAMILYTYPE_ID ");

		String groupWaitingID = null;
		String groupCancelID = null;
		ArrayList groupRecord = XmasGatheringDB.getGroupWaitingCancelID(eventID);
		if(groupRecord.size()>0){
			for(int i = 0; i < 2; i++) {
				ReportableListObject groupRow = (ReportableListObject) groupRecord.get(i);
				if(i == 0){
					groupWaitingID = groupRow.getValue(1);
				}else{
					groupCancelID = groupRow.getValue(1);
				}
			}
		}

		boolean isCa = false;
		if (ConstantsServerSide.isTWAH()) {
			ArrayList staffInfo = StaffDB.get(staffID);
			if (staffInfo.size() > 0) {
				ReportableListObject rlo = (ReportableListObject) staffInfo.get(0);
				if (rlo.getValue(4).equals("CAS") &&
						(!groupWaitingID.equals(scheduleID) && !groupCancelID.equals(scheduleID))) {
					isCa = true;
				}
				else {
				}
			}
			else {
			}
		}

		ArrayList<ReportableListObject> result =
								UtilDBWeb.getReportableList(sqlStr.toString());

		if (result.size() > 0) {
			int price = 0;
			for (int i = 0; i < result.size(); i++) {
				ReportableListObject row = result.get(i);
				if (ConstantsServerSide.isTWAH()) {
					if (isCa) {
						price += Integer.parseInt(eventPrice);
					}
					else {
						price += ((Integer.parseInt(eventPrice) * Integer.parseInt(row.getValue(0)))/100) * Integer.parseInt(row.getValue(1));
					}
				}
				else {
					price += ((Integer.parseInt(eventPrice) * Integer.parseInt(row.getValue(0)))/100) * Integer.parseInt(row.getValue(1));
				}
			}

			return String.valueOf(price);
		}
		else {
			return "0";
		}
	}

	public static boolean updateStaffConfirm(UserBean userBean, String eID,
			String sID, String enID) {

		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE CO_ENROLLMENT ");
		sqlStr.append("SET    CO_REMARK = 'confirm',CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER ='"+userBean.getLoginID()+"' ");
		sqlStr.append("WHERE  CO_SITE_CODE = '"+ ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_EVENT_ID  = '"+eID+"' ");
		sqlStr.append("AND    CO_SCHEDULE_ID = '"+sID+"' ");
		sqlStr.append("AND    CO_ENROLL_ID = '"+enID+"' ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
}