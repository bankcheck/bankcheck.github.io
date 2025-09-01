<%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%
UserBean userBean = new UserBean(request);

String command = (String) request.getAttribute("command");
if (command == null) {
	command = request.getParameter("command");
}
String staffID = request.getParameter("staffID");

boolean success = false;
UserBean userBean2 = null;

if ("login".equals(command) && (userBean.isAdmin() || userBean.isGroupID("managerPortal.user"))) {
	if (staffID != null && staffID.length() > 0) {
		userBean2 = UserDB.getUserBeanSkipPasswordByStaffID(request, staffID);
	}
}

if (userBean2 == null) {
	%>0<%
}
%>