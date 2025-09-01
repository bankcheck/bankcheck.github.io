<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
public String getDayDiff(Calendar cal, String date) {
	Calendar cal2 = Calendar.getInstance();
	cal2.set(Integer.parseInt(date.substring(6)), 
				Integer.parseInt(date.substring(3, 5)) - 1,
				Integer.parseInt(date.substring(0, 2)));
	long milsecs1= cal.getTimeInMillis();
	long milsecs2 = cal2.getTimeInMillis();
	long diff = milsecs2 - milsecs1;
	long dsecs = diff / 1000;
	long dminutes = diff / (60 * 1000);
	long dhours = diff / (60 * 60 * 1000);
	long ddays = diff / (24 * 60 * 60 * 1000);
	
	return String.valueOf(ddays+1);
}

public boolean updateRoster(String staffID, String dutyDate, String dutyCode,
								String user, boolean isDeptHead, String staffRole) {
	StringBuffer checkSql = new StringBuffer();
	StringBuffer sql = new StringBuffer();
	
	checkSql.append("SELECT CO_STAFF_DUTY_CODE, CO_REQUEST_STATUS ");
	checkSql.append("FROM CO_STAFFS_ROSTER ");
	checkSql.append("WHERE CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
	checkSql.append("AND CO_STAFF_ID = '"+staffID+"' ");
	checkSql.append("AND TO_CHAR(CO_STAFF_DUTY_DATE, 'DD/MM/YYYY') = '"+dutyDate+"' ");
	
	ArrayList record = UtilDBWeb.getReportableList(checkSql.toString());
	if (record.size() > 0) {
		//System.out.println(dutyDate+": "+dutyCode);
		if (dutyCode.length() > 0) {
			ReportableListObject row = null;
			row = (ReportableListObject) record.get(0);
			
			if (!row.getValue(0).trim().equals(dutyCode.trim())) {
				if (isDeptHead) {
					sql.append("UPDATE CO_STAFFS_ROSTER SET ");
					sql.append("CO_ENABLED = '1', ");
					sql.append("CO_STAFF_DUTY_CODE = '"+dutyCode+"', ");
					sql.append("CO_MODIFIED_DATE = SYSDATE, ");
					sql.append("CO_MODIFIED_USER = '"+user+"', ");
					sql.append("CO_REQUEST_STATUS = 'CONFIRM' ");
					sql.append("WHERE CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
					sql.append("AND CO_STAFF_ID = '"+staffID+"' ");
					sql.append("AND TO_CHAR(CO_STAFF_DUTY_DATE, 'DD/MM/YYYY') = '"+dutyDate+"' ");
				}
				else {
					if (row.getValue(1).equals("CONFIRM")) {
						sql.append("UPDATE CO_STAFFS_ROSTER SET ");
						sql.append("CO_ENABLED = '1', ");
						sql.append("CO_STAFF_DUTY_CODE = '"+dutyCode+"', ");
						sql.append("CO_MODIFIED_DATE = SYSDATE, ");
						sql.append("CO_MODIFIED_USER = '"+user+"', ");
						sql.append("CO_REQUEST_STATUS = 'SMOD' ");
						sql.append("WHERE CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
						sql.append("AND CO_STAFF_ID = '"+staffID+"' ");
						sql.append("AND TO_CHAR(CO_STAFF_DUTY_DATE, 'DD/MM/YYYY') = '"+dutyDate+"' ");
					}
					else {
						sql.append("UPDATE CO_STAFFS_ROSTER SET ");
						sql.append("CO_ENABLED = '1', ");
						sql.append("CO_STAFF_DUTY_CODE = '"+dutyCode+"', ");
						sql.append("CO_MODIFIED_DATE = SYSDATE, ");
						sql.append("CO_MODIFIED_USER = '"+user+"', ");
						sql.append("CO_REQUEST_STATUS = 'REQUEST' ");
						sql.append("WHERE CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
						sql.append("AND CO_STAFF_ID = '"+staffID+"' ");
						sql.append("AND TO_CHAR(CO_STAFF_DUTY_DATE, 'DD/MM/YYYY') = '"+dutyDate+"' ");
					}
				}
			}
			else {
				sql.append("UPDATE CO_STAFFS_ROSTER SET ");
				sql.append("CO_ENABLED = '1', ");
				sql.append("CO_MODIFIED_DATE = SYSDATE, ");
				sql.append("CO_MODIFIED_USER = '"+user+"' ");
				sql.append("WHERE CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
				sql.append("AND CO_STAFF_ID = '"+staffID+"' ");
				sql.append("AND TO_CHAR(CO_STAFF_DUTY_DATE, 'DD/MM/YYYY') = '"+dutyDate+"' ");
			}
		}
		else {
			sql.append("UPDATE CO_STAFFS_ROSTER SET ");
			sql.append("CO_ENABLED = '0', ");
			sql.append("CO_MODIFIED_DATE = SYSDATE, ");
			sql.append("CO_MODIFIED_USER = '"+user+"' ");
			sql.append("WHERE CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
			sql.append("AND CO_STAFF_ID = '"+staffID+"' ");
			sql.append("AND TO_CHAR(CO_STAFF_DUTY_DATE, 'DD/MM/YYYY') = '"+dutyDate+"' ");
		}
	}
	else {
		if (dutyCode.length() > 0) {
			if (isDeptHead) {
				sql.append("INSERT INTO CO_STAFFS_ROSTER(CO_SITE_CODE, CO_STAFF_ID, CO_STAFF_ROLE, ");
				sql.append("CO_STAFF_DUTY_DATE, CO_STAFF_DUTY_CODE, CO_REQUEST_STATUS, CO_CREATED_USER, CO_MODIFIED_USER) ");
				sql.append("VALUES('"+ConstantsServerSide.SITE_CODE+"', ");
				sql.append("'"+staffID+"', '"+staffRole+"', TO_DATE('"+dutyDate+"', 'DD/MM/YYYY'), ");
				sql.append("'"+dutyCode+"', 'CONFIRM', '"+user+"', '"+user+"') ");
			}
			else {
				sql.append("INSERT INTO CO_STAFFS_ROSTER(CO_SITE_CODE, CO_STAFF_ID, CO_STAFF_ROLE, ");
				sql.append("CO_STAFF_DUTY_DATE, CO_STAFF_DUTY_CODE, CO_REQUEST_STATUS, CO_CREATED_USER, CO_MODIFIED_USER) ");
				sql.append("VALUES('"+ConstantsServerSide.SITE_CODE+"', ");
				sql.append("'"+staffID+"', '"+staffRole+"', TO_DATE('"+dutyDate+"', 'DD/MM/YYYY'), ");
				sql.append("'"+dutyCode+"', 'REQUEST', '"+user+"', '"+user+"') ");
			}
		}
	}
	
	if (sql.toString().length() > 0) {
		//System.out.println(sql.toString());
		return UtilDBWeb.updateQueue(sql.toString());
	}
	else {
		return true;
	}
}
%>
<%
UserBean userBean = new UserBean(request);
String empNo = request.getParameter("empNo");
String rowid = request.getParameter("id");
String startYear = request.getParameter("startYear");
String startMonth = request.getParameter("startMonth");
String startDay = request.getParameter("startDay");
boolean isDeptHead = "true".equals(request.getParameter("isDeptHead"));
String staffRole = request.getParameter("staffRole");

Calendar startCal = Calendar.getInstance();
Calendar endCal = Calendar.getInstance();
startCal.set(Calendar.YEAR, Integer.parseInt(startYear));
startCal.set(Calendar.MONTH, Integer.parseInt(startMonth));
startCal.set(Calendar.DATE, Integer.parseInt(startDay));

endCal.set(Calendar.YEAR, Integer.parseInt(startYear));
endCal.set(Calendar.MONTH, Integer.parseInt(startMonth));
endCal.set(Calendar.DATE, Integer.parseInt(startDay));
endCal.add(Calendar.MONTH, 1);
endCal.set(Calendar.DATE, 20);

SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

//System.out.println(sdf.format(startCal.getTime()));
//System.out.println(sdf.format(endCal.getTime()));

int dayDiff = Integer.parseInt(getDayDiff(startCal, sdf.format(endCal.getTime())));

String errMsg = "";

for (int i = 1; i <= dayDiff; i++) {
	String dayValue = request.getParameter("day"+String.valueOf(i));
	if (i != 1) {
		startCal.add(Calendar.DATE, 1);
	}
	
	if (!updateRoster(empNo, sdf.format(startCal.getTime()), dayValue, 
						(userBean != null?userBean.getStaffID():""), isDeptHead,
						staffRole)) {
		errMsg += "Fail to update the Duty Record - "+dayValue+" in "+
					sdf.format(startCal.getTime())+"<br/>"; 
	}
}
System.err.println("errMsg :"+errMsg);
%>
<%=errMsg.length()>0?errMsg:"success"%>