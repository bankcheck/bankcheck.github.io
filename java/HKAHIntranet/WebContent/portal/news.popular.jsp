<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.constant.*"%>
<%
String skipColumnTitle = request.getParameter("skipColumnTitle");
String infoCategory = request.getParameter("infoCategory");
String isPEM = "N";
if("PEM".equals(infoCategory)){
isPEM = "Y";
}
if (skipColumnTitle == null || skipColumnTitle.length() == 0) {
	skipColumnTitle = ConstantsVariable.YES_VALUE;
}
String skipBrief = request.getParameter("skipBrief");
if (skipBrief == null || skipBrief.length() == 0) {
	skipBrief = ConstantsVariable.YES_VALUE;
}
%>
<jsp:include page="../portal/news_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="WHAT'S NEW" />
	<jsp:param name="category" value="top" />
	<jsp:param name="skipColumnTitle" value="<%=skipColumnTitle %>" />
	<jsp:param name="skipBrief" value="<%=skipBrief %>" />
	<jsp:param name="isPEM" value="<%=isPEM %>" />
</jsp:include>