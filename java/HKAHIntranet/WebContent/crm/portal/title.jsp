<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%
String title = request.getParameter("title");
String isFunction = request.getParameter("isFunction");
%>
<html:html xhtml="true" lang="true">
	<jsp:include page="header.jsp"/>
	<body>
		<div class="shadowBox">
			<div class="titleShadow">
				<%if("Y".equals(isFunction)){ %>
					<p><bean:message key="<%=title %>" /></p>
			 		<p class="shadow"><bean:message key="<%=title %>" /></p>
				<%} else { %>
			 		<p><%=title %></p>
			 		<p class="shadow"><%=title %></p>
			 	<%} %>
			</div>
		</div>
		<br/>
	</body>
</html:html>
