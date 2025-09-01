<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.web.db.RadiSharingChecking" %>
<%@ page import="com.hkah.util.*" %>
<%
String sid = request.getParameter("sid");
String aid = request.getParameter("aid");
String isSch = request.getParameter("isSch");
boolean isSchedule = isSch != null && isSch.equals("Y");
String patNo = request.getParameter("patno");
String rptPath = request.getParameter("rp");

boolean result = true;
if (rptPath != null) {
	rptPath = TextUtil.parseStrUTF8(java.net.URLDecoder.decode(rptPath));
	result = RadiSharingChecking.checkRptMsg(patNo, rptPath);
}
else {
	result = RadiSharingChecking.checkRptMsg(sid, aid, isSchedule);
}
%>
<%=result%>