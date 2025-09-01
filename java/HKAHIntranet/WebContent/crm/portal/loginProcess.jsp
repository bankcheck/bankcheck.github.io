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
	UserBean userBean = UserDB.getUserBean(request, loginID, loginPwd, "guest");
	if (userBean == null) {
		userBean = UserDB.getUserBean(request, loginID, loginPwd, new String[] { "'guest'" });
	}

	if (userBean != null) {
		if(userBean.isAccessible("function.crm.portal.admin") 
				|| (userBean.isGuest()&&CRMClientDB.getClientID(userBean.getLoginID())!=null&&CRMClientDB.getClientID(userBean.getLoginID()).length()>0)) {
			if (!ConstantsVariable.ZERO_VALUE.equals(userBean.getStaffStatus())) {
				// write to cookie
				if (ConstantsVariable.YES_VALUE.equals(savePwd)) {
					userBean.writeToCookie(response);
				}

				%>OK<%
			} else {
				// staff status is expired
				%><bean:message key="error.staffID.expired" /><%
			}
		}
		else {
			%><bean:message key="error.loginPwd.invalid" /><%
			userBean.invalidate(request, response);
		}
	} else {
		// invalid password
		%><bean:message key="error.loginPwd.invalid" /><%
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>