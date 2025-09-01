<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.cache.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="org.apache.commons.lang.*"%>

<%
UserBean userBean = new UserBean(request); 

%>  

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>
	h1 {
		font-size:16px;
	}
</style>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
	<jsp:include page="../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="function.rrteam" />
		<jsp:param name="mustLogin" value="N" />
		<jsp:param name="translate" value="Y" />
		<jsp:param name="keepReferer" value="N" />
		<jsp:param name="isHideHeader" value="Y" />
	</jsp:include>
	<br/>
	<h1><b><bean:message key="function.rrteam.content1" /></b></h1><br/><br/>
	<p>
		
		<a href='../admin/eSHARE.jsp' target="_self"><bean:message key="function.rrteam.link1" /></a><br/><br/>
		<a href='../hr/yearOfEmployee_vote.jsp?module=starOfTheQuarter' target="_self"><bean:message key="function.rrteam.link2" /></a><br/><br/>
		<br><B><U>List of Nominees</U></B><br>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="columnTitle" value="List of Nominees" />
	<jsp:param name="category" value="rewardAndRecognition" />
	<jsp:param name="adminStyle" value="Y" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="skipColumnTitle" value="Y" />
</jsp:include>
		
		<%if(userBean.isAccessible("function.rrteam.link3") && userBean.isLogin()){%>
		<br><B><U>Administration</U></B><br>
		<a href='../hr/nominationList.jsp' target="_self"><bean:message key="function.rrteam.link3" /></a>
		<%} %>
	</p>
    <br/><br/><br/>
</DIV>
</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>