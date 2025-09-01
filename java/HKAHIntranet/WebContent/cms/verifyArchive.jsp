<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.web.db.ArchivePdfChecking" %>
<%@ page import="com.hkah.util.*" %>
<%
String fromDate = request.getParameter("fromDate");
String toDate = request.getParameter("toDate");
String labnum =  request.getParameter("labnum");
String testCat =  request.getParameter("testCat");
String result = null;

if ((labnum != null) && (testCat != null)) {
	result = ArchivePdfChecking.checkLabRptByLabnum(labnum, testCat);
} else if ((fromDate != null) && (toDate != null)) {
	result = ArchivePdfChecking.checkLabRptByDateRange(fromDate, toDate);
}
%>
<%=result%>