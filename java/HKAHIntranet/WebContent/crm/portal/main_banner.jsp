<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.web.common.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
UserBean userBean = new UserBean(request);
String realUserID = request.getParameter("realUserID");
String login = request.getParameter("login");
String clientChangedIDPW = request.getParameter("clientChangedIDPW");
boolean loginAction = false;
if("true".equals(login)){
	loginAction = true;
}

String userInfo = null;
if (userBean.isLogin()) {
	
	StringBuffer strbuff = new StringBuffer();
	
		strbuff.append(userBean.getUserName());

		StringBuffer desc = new StringBuffer();		
		desc.append((userBean.getDeptDesc() == null || "".equals(userBean.getDeptDesc())?"":userBean.getDeptDesc()));
		if (desc.length() > 0) {
			strbuff.append(" (");
			strbuff.append(desc);
			strbuff.append(")");
		}

		if (loginAction) {
				strbuff.append(" [ <a onclick=\"changeLoginID('switchBack','"+realUserID+"');\" href='javascript: void(0)'>Switch back to "+realUserID+"</a> ]");			
		}
	
	userInfo = strbuff.toString();
} else {
	userInfo = "";
}

%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="header.jsp">
	<jsp:param name="checkLogin" value="N"/>
</jsp:include>
<body>
	<table border="0" style="width:100%">
		<tr>
			<td style="width:100%; border:1px solid black;">
				<div id="banner_logo">
					<img src="../../images/service_lmc_06.jpg" style="width:100%;height:180px"/>
				</div>
			</td>
		</tr>
		<tr>
		<td>				
				
					<table style="margin-top:-45px;position:relative;" border="0">
						<tr>
							<td>
							<span style="float:right">	
							      <html:link page="/crm/portal/language.jsp?language=en" target="_top"><html:img page="/images/lang_en.gif" align="top" /></html:link>
							|     <html:link page="/crm/portal/language.jsp?language=zh_TW" target="_top"><html:img page="/images/lang_zh_TW.gif" align="top" /></html:link>				
							<%-- ENG | ���| ��� --%>
							<%if(userBean != null && userBean.isLogin()) { %>	
								<%if(!"false".equals(clientChangedIDPW)||loginAction) { %>
								| <html:link page="/crm/portal/changePwd.jsp" target="content">
									<html:img page="/images/forget.gif" width="17" height="17" align="top" alt="Logout" />
									<bean:message key="prompt.change.password" />
								</html:link>
								<%} %>
								 | 
								<html:link page="/crm/portal/logout.jsp" target="_top">
									<html:img page="/images/Lock.gif" width="17" height="17" align="top" alt="Logout" />
									<bean:message key="prompt.logout" />
								</html:link>
								
							<%} %>		
							&nbsp;			
							</span>
							</td>
						</tr>					
						<tr>
							<td>
							<span style="float:right">		
							<bean:message key="message.welcome" arg0="<%=userInfo %>" />
							</span>
							</td>
						</tr>
					</table>
			
			</td>
		</tr>
	</table>
	<form name="changeLoginIDForm" action="index.jsp" method="post">
	<input type="hidden" name="command"/>
	<input type="hidden" name="clientID"/>
	</form>	
	
	<script>
		$(document).ready(function() {
			$('div#user_option').css('margin-left', '-'+($('div#user_option').width()+15));
		});
		
		function changeLoginID(cmd,cid){				
			if( cid.length === 0 ) {
				alert('Unable to login without Login ID.');
			}else{
				document.changeLoginIDForm.command.value = cmd;
				document.changeLoginIDForm.clientID.value = cid;				
				document.changeLoginIDForm.submit();
			}
			return false;
		}
	</script>
<!--  
	<div id="header">
		<table>
			<tr>
				<td>
					<div style="float:right">
						<html:link page="/crm/portal/changePwd.jsp" target="content">
							<html:img page="/images/forget.gif" width="17" height="17" align="top" alt="Logout" />
							<bean:message key="prompt.change.password" />
						</html:link>
						|
						<html:link page="/crm/portal/logout.jsp" target="_top">
							<html:img page="/images/Lock.gif" width="17" height="17" align="top" alt="Logout" />
							<bean:message key="prompt.logout" />
						</html:link>
					</div>
				</td>
			</tr>
		</table>
		<table>
			<tr>
				<td style="width:180px">
					<html:link page="/crm/portal/main_content.jsp?category=crm.portal" target="bottom">
						<div id="logo"></div>
					</html:link>
				</td>
				<td>
					<label><b>CRM Portal</b></label>
				</td>
			</tr>
		</table>
	</div>
-->
</body>
</html:html>