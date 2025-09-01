<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);

//store current category
String pageCategory = request.getParameter("category");
String clientChangedIDPW = request.getParameter("clientChangedIDPW");
String login = request.getParameter("login");
boolean loginAction = false;
if("true".equals(login)){
	loginAction = true;
}

if (pageCategory != null) {
	session.setAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_CATEGORY, pageCategory);
} else {
	session.setAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_CATEGORY, "crm.portal");
}
String referer = (String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_REFERER);

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<head>
</head>
<jsp:include page="header.jsp"/>
<%if("false".equals(clientChangedIDPW)&&!loginAction){%>
<frameset border="0" frameborder="0" framespacing="0" cols="1110">	
	<frame name="content" src="clientFirstLogin.jsp" noresize>
	<noframes>
		<P>Please use Internet Explorer or Mozilla!
	</noframes>
</frameset>
<%}else{%>
<frameset border="0" frameborder="0" framespacing="0" cols="220, 900">
	<frame name="menu" src="../../common/left_menu.jsp" noresize>
	<frame name="content" src="portal.jsp" noresize>
	<noframes>
		<P>Please use Internet Explorer or Mozilla!
	</noframes>
</frameset>
<%}%>
</html:html>