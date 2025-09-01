<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="net.sf.json.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%!
public ArrayList getStaffRosterList(String startDate, String endDate, String deptCode, 
									String staffID) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT S.CO_STAFF_ID, TO_CHAR(R.CO_STAFF_DUTY_DATE, 'DDMMYYYY'), ");
	sqlStr.append("		  R.CO_STAFF_DUTY_CODE ");
	sqlStr.append("FROM CO_STAFFS_ROSTER_POSITION P, CO_STAFFS S, ");
	sqlStr.append("    ( ");
	sqlStr.append("      SELECT * ");
	sqlStr.append("      FROM CO_STAFFS_ROSTER ");
	sqlStr.append("      WHERE CO_ENABLED = '1' ");
	sqlStr.append("      AND   CO_STAFF_DUTY_DATE >= TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("      AND   CO_STAFF_DUTY_DATE <= TO_DATE('"+endDate+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS')) R ");
	sqlStr.append("WHERE S.CO_STAFF_ID = P.CO_STAFF_ID ");
	sqlStr.append("AND S.CO_STAFF_ID = R.CO_STAFF_ID(+) ");
	sqlStr.append("AND S.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
	if (staffID != null && staffID.length() > 0) {
		sqlStr.append("AND S.CO_STAFF_ID = '"+staffID+"' ");
	}
	sqlStr.append("AND S.CO_ENABLED = '1' ");
	sqlStr.append("AND P.CO_ENABLED = '1' ");
	sqlStr.append("ORDER BY P.CO_STAFF_ROLE DESC, S.CO_STATUS DESC, S.CO_STAFF_ID, R.CO_STAFF_DUTY_DATE ");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public String getDayDiff(Calendar cal, String date) {
	Calendar cal2 = Calendar.getInstance();
	cal2.set(Integer.parseInt(date.substring(4)), 
				Integer.parseInt(date.substring(2, 4)) - 1,
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
%>

<%
UserBean userBean = new UserBean(request);
String recordCount = request.getParameter("row");
String deptCode = request.getParameter("deptCode");
String startDate = request.getParameter("startDate");
String endDate = request.getParameter("endDate");
boolean isDeptHead = "true".equals(request.getParameter("isDeptHead"));

ReportableListObject row = null;
JSONObject staffJSON = new JSONObject();
JSONArray jsonArray = new JSONArray();
JSONObject rootJSON = new JSONObject();
Calendar cal = Calendar.getInstance();
Calendar cal2 = Calendar.getInstance();

cal.set(Calendar.MONTH, Integer.parseInt(startDate.substring(2, 4), 10)-1);
cal.set(Calendar.YEAR, Integer.parseInt(startDate.substring(4)));
cal2.set(Calendar.MONTH, Integer.parseInt(endDate.substring(2, 4), 10)-1);
cal2.set(Calendar.YEAR, Integer.parseInt(endDate.substring(4)));
cal.set(Calendar.DATE, 21);
cal2.set(Calendar.DATE, 20);

SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
//System.out.println("Start Date From Parameter: "+startDate);
//System.out.println("Start Date: "+sdf.format(cal.getTime()));
//System.out.println("End Date From Parameter: "+endDate);
//System.out.println("End Date: "+sdf.format(cal2.getTime()));
ArrayList record = getStaffRosterList(sdf.format(cal.getTime()), 
										sdf.format(cal2.getTime()), 
										deptCode,
										(isDeptHead?null:userBean.getStaffID()));

if (record.size() > 0) {
	String curStaff = "";
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		if (!curStaff.equals(row.getValue(0))) {
			if (i != 0) {
				staffJSON.put("hours", "");
				jsonArray.add(staffJSON);
			}
			staffJSON = new JSONObject();
			curStaff = row.getValue(0);
			staffJSON.put("empNo", row.getValue(0));
			if (!row.getValue(1).equals("")) {
				staffJSON.put("day"+getDayDiff(cal, row.getValue(1)), row.getValue(2));
			}
		}
		else {
			if (!row.getValue(1).equals("")) {
				staffJSON.put("day"+getDayDiff(cal, row.getValue(1)), row.getValue(2));
			}
		}
	}
	jsonArray.add(staffJSON);
}
else {
	
}
rootJSON.put("page", "1");
rootJSON.put("total", "1");
rootJSON.put("records", recordCount);
rootJSON.put("rows", jsonArray);

response.setContentType("application/json");
//System.out.println(rootJSON.toString());
PrintWriter writer = response.getWriter();
writer.print(request.getParameter("callback")+"("+rootJSON.toString()+ ");");
writer.close();
%>