<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%!
public boolean confirmRoster(String startDate, String endDate, String user,
								String deptCode) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE CO_STAFFS_ROSTER SET ");
	sqlStr.append("CO_MODIFIED_DATE = SYSDATE, ");
	sqlStr.append("CO_MODIFIED_USER = '"+user+"', ");
	sqlStr.append("CO_REQUEST_STATUS = 'CONFIRM' ");
	sqlStr.append("WHERE CO_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
	sqlStr.append("AND   CO_STAFF_DUTY_DATE >= TO_DATE('"+startDate+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("AND   CO_STAFF_DUTY_DATE <= TO_DATE('"+endDate+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("AND   CO_ENABLED = '1' ");
	sqlStr.append("AND   CO_STAFF_ID IN ( ");
	sqlStr.append("SELECT CO_STAFF_ID FROM CO_STAFFS S ");
	sqlStr.append("WHERE CO_DEPARTMENT_CODE = '"+deptCode+"' ");
	sqlStr.append("AND CO_ENABLED = '1') ");
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}
%>

<%
UserBean userBean = new UserBean(request);

String deptCode = request.getParameter("deptCode");
String startYear = request.getParameter("startYear");
String startMonth = request.getParameter("startMonth");
String startDay = request.getParameter("startDay");

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

if (confirmRoster(sdf.format(startCal.getTime()), sdf.format(endCal.getTime()),
		userBean.getStaffID(), deptCode)) {
%>
success
<%
}
else {
%>
fail
<%
}
%>