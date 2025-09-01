package com.hkah.web.db;

import java.util.ArrayList;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class FitnessDB {
	
	public static ArrayList get(String date, String timeslot, String booknum) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT MEMBER_ID, FULLNAME, GENDER, TRAINER, REMARK ");
		sqlStr.append(" FROM FC_BOOKING ");
		sqlStr.append(" WHERE BOOKDATE = ? AND TIMESLOT = ? AND BOOKNUM = ?");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { date, timeslot, booknum });
	}
	
	public static ArrayList getBookingList(String date, String timeslot) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT BOOKNUM, MEMBER_ID, FULLNAME, GENDER, TRAINER, REMARK ");
		sqlStr.append(" FROM FC_BOOKING ");
		sqlStr.append(" WHERE BOOKDATE = ? AND TIMESLOT = ? ");
		sqlStr.append(" ORDER BY BOOKNUM ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { date, timeslot });
	}
	
	public static String getTimeRange(String timeslot) {
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT STARTTIME || ' - ' || ENDTIME ");
		sqlStr.append(" FROM FC_TIMESLOT ");
		sqlStr.append(" WHERE TIMESLOT = ? ");
		
		ArrayList record =  UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { timeslot });

		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return null;
		}
	}

	public static ArrayList getTimeSlot() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TIMESLOT, STARTTIME, ENDTIME ");
		sqlStr.append(" FROM FC_TIMESLOT ");
		sqlStr.append(" WHERE ACTIVE = 1 ");
		sqlStr.append(" ORDER BY DISP_ORDER ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { });
	}
	
	public static String getAvailable(String date, String timeslot) {
		return getAvailable(date, timeslot, null);
	}
	
	public static String getAvailable(String date, String timeslot, String staffID) {
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT FC_CHK_AVAILABLE2(?, ?, ?) ");
		sqlStr.append(" FROM DUAL ");
		ArrayList record =  UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {date, timeslot, staffID});

		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return null;
		}
	}
	
	public static String getCount(String date, String timeslot) {
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT FC_GET_COUNT(?, ?) ");
		sqlStr.append(" FROM DUAL ");
		ArrayList record =  UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {date, timeslot});

		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return null;
		}
	}
	
	public static String reserve(UserBean userBean, String memberID, String date, String timeslot, String name, String gender, String trainer, String remark) {
		return UtilDBWeb.callFunction("FC_ADD_BOOKING", null, new String[] {memberID, date, timeslot, name, gender, trainer, remark, userBean.getStaffID()});
	}
	
	public static boolean update(UserBean userBean, String date, String timeslot, String booknum, String memberID, String name, String gender, String trainer, String remark) {
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE FC_BOOKING SET MEMBER_ID = ?, ");
		sqlStr.append(" FULLNAME = ?, ");
		sqlStr.append(" GENDER = ?, ");
		sqlStr.append(" TRAINER = ?, ");
		sqlStr.append(" REMARK = ?, ");
		sqlStr.append(" UPDATE_USER = ?, ");
		sqlStr.append(" UPDATE_DATE = SYSDATE ");
		sqlStr.append(" WHERE BOOKDATE = ? ");
		sqlStr.append(" AND TIMESLOT = ? ");
		sqlStr.append(" AND BOOKNUM = ? ");
				
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {
					memberID, name, gender, trainer, remark, userBean.getStaffID(),
					date, timeslot, booknum })) {
			return true;
		} else {
			return false;
		}

	}	
	
	public static String cancelByBooknum(String booknum, String date, String timeslot) {
		return UtilDBWeb.callFunction("FC_CANCEL_BOOKING", null, new String[] {booknum, date, timeslot });
	}
	
	public static String cancelByStaffID(String staffID, String date, String timeslot) {
		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT BOOKNUM FROM FC_BOOKING "); 
		sqlStr.append("	WHERE MEMBER_ID = ? "); 
		sqlStr.append("	AND BOOKDATE = ? "); 
		sqlStr.append("	AND TIMESLOT = ? ");
		
		ArrayList record =  UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {staffID, date, timeslot});

		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			String booknum = row.getValue(0);
			String message = cancelByBooknum(booknum, date, timeslot);
			
			if ("success".equals(message)) {
				return "message.booking.cancel";
			} else {
				return message;
			}
			
		} else {
			return "Invalid booking";
		}
		
	}
	
	public static ArrayList getConfigList(boolean showall) {
		StringBuffer sqlStr = new StringBuffer();

		if (showall) {
			sqlStr.append("SELECT C.RULENUM, TO_CHAR(C.START_DATE, 'DD/MM/YYYY'), C.RULE_TYPE, DECODE(C.TIMESLOT, 0, 'All-day', T.STARTTIME || ' - ' || T.ENDTIME), C.DESCRIPTION, C.CAPACITY, TO_CHAR(C.END_DATE, 'DD/MM/YYYY'), C.ACTIVE ");
			sqlStr.append(" FROM FC_CONFIG C LEFT OUTER JOIN FC_TIMESLOT T ON C.TIMESLOT = T.TIMESLOT ");
			sqlStr.append(" ORDER BY C.RULENUM DESC ");
		} else {
			sqlStr.append("SELECT C.RULENUM, TO_CHAR(C.START_DATE, 'DD/MM/YYYY'), C.RULE_TYPE, DECODE(C.TIMESLOT, 0, 'All-day', T.STARTTIME || ' - ' || T.ENDTIME), C.DESCRIPTION, C.CAPACITY, TO_CHAR(C.END_DATE, 'DD/MM/YYYY'), C.ACTIVE ");
			sqlStr.append(" FROM FC_CONFIG C LEFT OUTER JOIN FC_TIMESLOT T ON C.TIMESLOT = T.TIMESLOT ");
			sqlStr.append(" WHERE C.ACTIVE = 1 ");
			//sqlStr.append(" AND C.START_DATE <= SYSDATE ");
			//sqlStr.append(" AND NVL(C.END_DATE, SYSDATE) <= SYSDATE ");
			sqlStr.append(" ORDER BY C.RULENUM DESC ");
		}
		
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { });
	}
	
	public static ArrayList getConfig(String ruleNum) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT TO_CHAR(START_DATE, 'DD/MM/YYYY'), RULE_TYPE, TIMESLOT, DESCRIPTION, CAPACITY, TO_CHAR(END_DATE, 'DD/MM/YYYY'), active ");
			sqlStr.append(" FROM FC_CONFIG ");
			sqlStr.append(" WHERE RULENUM = ? ");
		
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ruleNum });
	}
	
	public static boolean addConfig(UserBean userBean, String startDate, String type, String timeslot, String desc, String capacity, String endDate) {
		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append(" INSERT INTO FC_CONFIG (RULENUM, TIMESLOT, CAPACITY, DESCRIPTION, START_DATE, END_DATE, RULE_TYPE, ACTIVE, CREATE_USER, CREATE_DATE) ");
		sqlStr.append(" SELECT MAX(RULENUM) + 1, ?, ?, ? ,TO_DATE(?, 'DD/MM/YYYY'),TO_DATE(?, 'DD/MM/YYYY'), ?, 1, ?, SYSDATE ");
		sqlStr.append(" FROM FC_CONFIG ");
				
		return (UtilDBWeb.updateQueue( sqlStr.toString(), 
				new String[] { timeslot, capacity, desc, startDate, endDate, type, userBean.getStaffID() }));
	} 
	
	public static boolean updateConfig(UserBean userBean, String ruleNum, String startDate, String type, String timeslot, String desc, String capacity, String endDate, String active) {
		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE FC_CONFIG SET ");
		sqlStr.append(" RULE_TYPE = ?, ");
		sqlStr.append(" TIMESLOT = ?, ");
		sqlStr.append(" DESCRIPTION = ?, ");
		sqlStr.append(" CAPACITY = ?, ");
		sqlStr.append(" START_DATE = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append(" END_DATE = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append(" ACTIVE = TO_NUMBER(?), ");
		sqlStr.append(" UPDATE_USER = ?, ");
		sqlStr.append(" UPDATE_DATE = SYSDATE ");
		sqlStr.append(" WHERE RULENUM = ? ");
				
		return (UtilDBWeb.updateQueue( sqlStr.toString(), 
				new String[] { type, timeslot, desc, capacity, startDate, endDate, active, userBean.getStaffID(), ruleNum }));
	} 
	
	public static boolean setActive(UserBean userBean, String rulenum, boolean enable) {
		
		StringBuffer sqlStr = new StringBuffer();
		if (enable) {
			sqlStr.append("UPDATE FC_CONFIG SET ACTIVE = 1, ");
			sqlStr.append(" UPDATE_USER = ?, ");
			sqlStr.append(" UPDATE_DATE = SYSDATE ");
			sqlStr.append(" WHERE RULENUM = ? ");
		} else {
			sqlStr.append("UPDATE FC_CONFIG SET ACTIVE = 0, ");
			sqlStr.append(" UPDATE_USER = ?, ");
			sqlStr.append(" UPDATE_DATE = SYSDATE ");
			sqlStr.append(" WHERE RULENUM = ? ");			
		}
				
		return (UtilDBWeb.updateQueue( sqlStr.toString(), 
				new String[] { userBean.getStaffID(), rulenum }));
	} 
	
	public static ArrayList getMember(String memberID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT TO_CHAR(ACTIVE_DATE, 'DD/MM/YYYY'), TO_CHAR(END_DATE, 'DD/MM/YYYY')");
		sqlStr.append(" FROM FC_MEMBERSHIP ");
		sqlStr.append(" WHERE MEMBER_ID = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { memberID });
	}
	
	public static boolean addMember(UserBean userBean, String memberID, String activeDate, String endDate) {
		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append(" INSERT INTO FC_MEMBERSHIP (MEMBER_ID, ACTIVE_DATE, END_DATE, CREATE_USER, CREATE_DATE) ");
		sqlStr.append("  VALUES (?,TO_DATE(?, 'DD/MM/YYYY'), TO_DATE(?, 'DD/MM/YYYY'), ?, SYSDATE) ");
				
		return (UtilDBWeb.updateQueue( sqlStr.toString(), 
				new String[] { memberID, activeDate, endDate, userBean.getStaffID() }));
	} 
	
	public static boolean updateMember(UserBean userBean, String memberID, String activeDate, String endDate) {
		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE FC_MEMBERSHIP SET ");
		sqlStr.append(" ACTIVE_DATE = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append(" END_DATE = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append(" UPDATE_USER = ?, ");
		sqlStr.append(" UPDATE_DATE = SYSDATE ");
		sqlStr.append(" WHERE MEMBER_ID = ? ");
				
		return (UtilDBWeb.updateQueue( sqlStr.toString(), 
				new String[] { activeDate, endDate, userBean.getStaffID(), memberID }));
	} 

}