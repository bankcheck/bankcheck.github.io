<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>

<%
UserBean userBean = new UserBean(request);
String staffID = request.getParameter("staffID");
String moduleCode = request.getParameter("moduleCode");
String eventID = request.getParameter("eventID");
String scheduleID = request.getParameter("scheduleID");
String url = request.getParameter("url");
boolean success =false;
String result = null;

if (url.contains("NIS Training")) {
	eventID = "1";
	scheduleID = "1";
	moduleCode = "nursing";
	
	result = EnrollmentDB.add(userBean, moduleCode, eventID, scheduleID, "staff", staffID, DateTimeUtil.getCurrentDateTime(), url);
}
%>
