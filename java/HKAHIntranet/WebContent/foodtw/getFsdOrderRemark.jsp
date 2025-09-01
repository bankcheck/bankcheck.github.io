<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%!
	
%>

<%
UserBean userBean = new UserBean(request);
if (userBean == null || !userBean.isLogin()) {
	%>
	<script>
		window.open("../foodtw/index.jsp", "_self");
	</script>
	<%
	return;
}

String isToday = request.getParameter("today");
String patNo = request.getParameter("patNo");
String regID = request.getParameter("regID");
String all = request.getParameter("all");
Calendar cal = Calendar.getInstance();

if(isToday.equals("N")) {
	cal.add(Calendar.DAY_OF_MONTH, 1);
}

SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

ArrayList record = null;
if(all.equals("true")) {
	record = PatientDB.getFoodServiceList(sdf.format(cal.getTime()));
}
else {
	record = PatientDB.getPatientServiceByDate(patNo, regID, sdf.format(cal.getTime()));
}
//PatientDB.getPatientServiceByDate(patNo, regID, sdf.format(cal.getTime()));

if(record.size() > 0) {
	ReportableListObject row = null;
	String cont = "";
	for(int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		cont += row.getValue(1)+"_"+row.getValue(13)+"_"+row.getValue(2)+"_"+row.getValue(4)+"|";
	}
	%>
		<%=cont%>
	<%
}
%>