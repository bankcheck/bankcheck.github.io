<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%
UserBean userBean = new UserBean(request);

String pageCategory = request.getParameter("category");
String command = request.getParameter("command");
String clientID = request.getParameter("clientID");
String realUserID = request.getParameter("realUserID");
boolean loginAction = false;

if ("switchBack".equals(command)) {
	userBean = UserDB.getUserBeanSkipPassword(request, clientID) ;
}

if ("login".equals(command)) {
	UserBean tempUserBean = UserDB.getUserBeanSkipPassword(request, realUserID);
		
	if(tempUserBean.isAccessible("function.crm.portal.admin")){
		loginAction = true;
	}
		
}

if (loginAction && clientID != null && clientID.length() > 0) {
	
	userBean = UserDB.getUserBeanSkipPassword(request, clientID) ;
}


if (pageCategory != null) {
	session.setAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_CATEGORY, pageCategory);
} else {
	session.setAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_CATEGORY, "crm.portal");
}
String referer = (String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_REFERER);


boolean clientChangedIDPW = true;
ArrayList result = CRMClientDB.isClientIDPWChanged(CRMClientDB.getClientID(userBean.getUserName()));
if(result.size() > 0) {
	ReportableListObject row = (ReportableListObject)result.get(0);
	if(row.getValue(1).equals("0")){
		clientChangedIDPW = false;
	}
}
%>

<html:html xhtml="true" lang="true">
	<jsp:include page="header.jsp"/>
	<body>
		<div id="index_content">
			<table style="width:100%;height:auto">
				<tr>
					<td colspan="2">					
						<jsp:include page="main_banner.jsp" flush="false">
							<jsp:param name="login" value="<%=loginAction%>" />
							<jsp:param name="realUserID" value="<%=realUserID%>" />
							<jsp:param name="clientChangedIDPW" value="<%=clientChangedIDPW%>" />
						</jsp:include>
					</td>
				</tr>
				<%if(userBean != null && userBean.isLogin()) { %>
				<%}else {%>
				<tr>
					<td colspan="2">
						<table style="width:100%;">
							<tr>
								<td>
									<jsp:include page="../../common/left_menu.jsp" flush="false"/>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<%} %>
				<tr>
					<td>					
						<%if(userBean != null && userBean.isLogin()) {%>							
							<iframe name="main_content" src="main_content.jsp?clientChangedIDPW=<%=clientChangedIDPW %>&login=<%=loginAction %>" 
									width="100%" height="720px" frameborder="0" scrolling="auto">
							</iframe>
						<%}else {%>
							<iframe name="login_content" src="index_content.jsp" 
									width="100%" height="628px" frameborder="0" scrolling="auto">
							</iframe>
						<%} %>
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="2" align="right">
						<jsp:include page="footer.jsp" flush="false"/>
					</td>
				</tr>
			</table>
			<%if(userBean != null && userBean.isLogin()) { %>
				<input type="hidden" name="target_frame" value="content"/>
			<%}else {%>
				<input type="hidden" name="target_frame" value="login_content"/>
			<%} %>
		</div>
		<br/>
	</body>
</html:html>

