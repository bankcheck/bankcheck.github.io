<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%
String path = request.getContextPath();
%>
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>
	<body>
		<img src="<%=path %>/images/maintenance.gif"/>
	</body>
</html:html>