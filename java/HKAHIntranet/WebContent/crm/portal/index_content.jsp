<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);

//store current category
String pageCategory = request.getParameter("category");
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
<jsp:include page="header.jsp">
	<jsp:param name="checkLogin" value="N"/>
</jsp:include>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/crm.login.css" />"/>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/crm.photo.gallery.css" />"/>
 
<body style="background-color: #e6e6e6!important;">
	<table>
		<tr style="height:380px;">
			<td valign="top">
				<jsp:include page="photoGallery.jsp"/>
			</td>
			<td style="width:400px;">
				<jsp:include page="login.jsp"/>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<table style="width:100%;">
					<tr>
						<td style="width:100%;float:left;">
							<div class="infoBox">
								<div class="infoHead"><bean:message key="label.crm.news" /></div>
								<div class="infoContent5">
									 <marquee direction="up" speed="slow" style="width:100%;background-color:white" 
											onmouseover="stop()" onmouseout="start()"> 
										<div  style="width:100%;background-color:white" >
											<form name="form1" method="post">
												<jsp:include page="../../crm/portal/news_helper.jsp" flush="false">
													<jsp:param name="columnTitle" value="" />
													<jsp:param name="category" value="lmc.crm" />
													<jsp:param name="type" value="news" />
												</jsp:include>
											</form>
										</div>
									</marquee>  
								</div>
							</div>
						</td>
					
					</tr>
				</table>
			</td>
		</tr>
	</table>
</body>
</html:html>
<script>
	$(document).ready(function() {
		setFooterLinkTarget();
	})
</script>