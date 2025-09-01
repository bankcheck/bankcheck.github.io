<%@ page language="java" contentType="text/html; charset=utf-8" %>
<jsp:include page="../portal/news_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="WHAT'S NEW" />
	<jsp:param name="category" value="top" />
	<jsp:param name="source" value="information" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="skipBrief" value="Y" />
</jsp:include>