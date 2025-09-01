<%@ page import="java.util.*"
%><%@ page import="org.apache.struts.*"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"
%><%@ page import="com.hkah.web.exception.*"
%><%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"
%><%
String loginID = request.getParameter("loginID");
String loginPwd = request.getParameter("loginPwd");
String language = request.getParameter("language");
String savePwd = request.getParameter("savePwd");

try {
	if (loginID == null || loginID.length() == 0) {
		%><bean:message key="error.loginID.required" /><%
		return;
	} else if (loginPwd == null || loginPwd.length() == 0) {
		%><bean:message key="error.loginPwd.required" /><%
		return;
	} 
	
	UserBean userBean = null;
	try {
		userBean = UserDB.login(request, response, loginID, loginPwd, savePwd);
	} catch (NSNOAccessRightinvalidException nse) {
		%><bean:message key="error.nsNOAccessRight.invalid" /><%			
	} catch (NoAccessRightException nare) {
		%><bean:message key="error.staffID.expired" /><%			
	} catch (LoginStaffExpiredException lsee) {
		%><bean:message key="error.staffID.expired" /><%
	} catch (LoginPwdInvalidException lpie) {
		%><bean:message key="error.loginPwd.invalid" /><%
	} catch (LoginException le) {
		%><bean:message key="message.server.error" /><%	
	}

	if (userBean != null) {
		// set language
		Locale locale = null;
		if ("zh_TW".equals(language)) {
			locale = Locale.TRADITIONAL_CHINESE;
		} else if ("zh_CN".equals(language)) {
			locale = Locale.SIMPLIFIED_CHINESE;
		} else if ("ja_JP".equals(language)) {
			locale = Locale.JAPAN;
		} else {
			locale = Locale.US;
		}
		session.setAttribute( Globals.LOCALE_KEY, locale );

		%>OK<%
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>