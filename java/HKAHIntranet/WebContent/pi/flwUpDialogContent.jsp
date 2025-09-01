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
String Content = null;
%>


<html><body>
<%
ArrayList flwUpDialogContent;
if ("flwupmsg".equals(contentType)) {	
	flwUpDialogContent = PiReportDB.fetchReportFlwUpDialogContent(pirID, contentID);
	if(flwUpDialogContent.size() > 0) {
		row = (ReportableListObject) flwUpDialogContent.get(0);
		Content = row.getValue(0);
	}
}
else if ("addrpt".equals(contentType)) {	
	flwUpDialogContent = PiReportDB.fetchReportFlwUpDialogAddRptContent(pirID, contentID);
	if(flwUpDialogContent.size() > 0) {
		row = (ReportableListObject) flwUpDialogContent.get(0);
		Content = row.getValue(0);
	}	
}
else if ("actionrequest".equals(contentType)) {	
	flwUpDialogContent = PiReportDB.fetchReportActionRequestUpDialogContent(pirID, contentID);
	if(flwUpDialogContent.size() > 0) {
		row = (ReportableListObject) flwUpDialogContent.get(0);
		Content = row.getValue(0);
	}
}
else if ("actionreply".equals(contentType)) {	
	flwUpDialogContent = PiReportDB.fetchReportActionRequestUpDialogContent(pirID, contentID);
	if(flwUpDialogContent.size() > 0) {
		row = (ReportableListObject) flwUpDialogContent.get(0);
		Content = row.getValue(1);
	}
}
%>
	<textarea readonly name="MsgContent" rows="40" cols="90"><%=Content%></textarea>
</body></html>