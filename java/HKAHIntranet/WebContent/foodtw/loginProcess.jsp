<%@ page import="java.util.*"
%><%@ page import="org.apache.struts.*"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"
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

	// accept either username or staff id to login
	UserBean userBean = UserDB.getUserBean(request, loginID, loginPwd);

	// check from
	if (userBean == null
			&& UserDB.isCISUser(loginID, PasswordUtil.cisEncryption(loginPwd))) {
		// check user from CIS
		userBean = UserDB.getUserBean(request, loginID);
	}

	// create user id if necessary
	if (StaffDB.isExist(loginID) && !UserDB.isExistByStaffID(loginID)) {
		UserDB.add(ConstantsServerSide.SITE_CODE, loginID, PasswordUtil.cisEncryption("123456"), loginID);
		// retrieve again
		userBean = UserDB.getUserBean(request, loginID, loginPwd);
	}

	if (userBean != null) {
		if (!ConstantsVariable.ZERO_VALUE.equals(userBean.getStaffStatus())) {
			// write to cookie
			if (ConstantsVariable.YES_VALUE.equals(savePwd)) {
				userBean.writeToCookie(response);
			}

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
		} else {
			// staff status is expired
			%><bean:message key="error.staffID.expired" /><%
		}
	} else {
		// invalid password
		%><bean:message key="error.loginPwd.invalid" /><%
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>