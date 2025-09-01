<%
String category = request.getParameter("category");
%>
<%@ page language="java" contentType="text/xml; charset=utf-8" %>
<?xml version="1.0" encoding="utf-8"?>
<tree id="t0">
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="adminStyle" value="N" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="skipTreeview" value="Y" />
	<jsp:param name="mustLogin" value="N" />
</jsp:include>
</tree>