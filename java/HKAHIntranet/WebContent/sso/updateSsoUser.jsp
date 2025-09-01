<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.SsoUserDB"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.web.db.*" %>
<%@ page import="com.hkah.util.mail.UtilMail" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>

<%
	UserBean userBean = new UserBean(request);
	boolean isRun = false;
	boolean success = false;
	String updateOption = "";
	if (userBean.isAdmin()) {
		String run = request.getParameter("run");
		if ("1".equals(run)) {
			updateOption = request.getParameter("update");
			if ("ssouser".equals(updateOption)) {
				SsoUserDB.updateSsoUserFromCIS(userBean);
				isRun = true;
			} else if ("ssousermappingportal".equals(updateOption)) {
				SsoUserDB.updateSsoMappingUserForPortal(userBean);
				isRun = true;	
			} else if ("ssouserid".equals(updateOption)) {
				SsoUserDB.getAllUserFromMasterSystem();
				isRun = true;
			} else if ("ssousermapping".equals(updateOption)) {
				/// SsoUserDB.updateSsoMappingUserFromCIS(userBean);
				isRun = true;
			} else if ("ssouserdetails".equals(updateOption)) {
				SsoUserDB.updateSsoUserDetailsFromHRStaff(userBean);
				isRun = true;
			} else if ("initewelluser".equals(updateOption)) {
				SsoUserDB.initEwellUserFromCIS(userBean);
				isRun = true;
			} else if ("testssoconn".equals(updateOption)) {
				success = SsoUserDB.testConn();
				isRun = true;
			} else if ("ssouserdetails2".equals(updateOption)) {
				List<String> staffId = new ArrayList<String>();
				for (int i = 4707; i <= 4719; i++) {
					SsoUserDB.updateSsoUserDetailsFromHRStaff(userBean, String.valueOf(i));
				}
				isRun = true;
			/*
			} else if ("ewellalert".equals(updateOption)) {
				Map<String, String> alertStaff = new HashMap<String, String>();
				String from = "hk.portal";
				alertStaff.put("4294", from);
				alertStaff.put("1917", from);	// alert 351
				alertStaff.put("M015", from);
				alertStaff.put("3470", from);	// alert 351
				//SsoUserDB.testSendEwellUserAlert(alertStaff, "HKAH");
				//testSendEwellUserAlert(alertStaff, "HKAH");
				isRun = true;
			*/
			}
		}
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
</head>
<body>
SSO User (action: <%=updateOption %>) from other system...
<%
	if (isRun) {
%>
	completed.
<%
	} else {
%>
	stopped.
<%
	}
%>
</body>
</html>