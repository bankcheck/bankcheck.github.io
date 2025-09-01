<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%!
%>
<%

UserBean userBean = new UserBean(request);
String pirID = request.getParameter("pirid");
String contentID = request.getParameter("contentid");
String contentType = request.getParameter("contentType");

ReportableListObject row = null;
ReportableListObject row2 = null;
String outVal = "";
String ReceiverType = "admin";
String ccList = "";
Boolean IsReponsiblePerson = null;
Boolean IsDHead = null;
String rptSts = null;
String reportStatusDesc = null;
String submitBtnLabel = null;
%>


<html><body>
<img src="../images/pi/RiskAssessmentCodePx1.jpg" alt="Smiley face" height="500" width="750">
</body></html>