<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.SsoUserDB"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="java.util.*" %>
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
				for (int i = 4677; i <= 4706; i++) {
					SsoUserDB.updateSsoUserDetailsFromHRStaff(userBean, String.valueOf(i));
				}
				for (int i = 4659; i <= 4675; i++) {
					SsoUserDB.updateSsoUserDetailsFromHRStaff(userBean, String.valueOf(i));
				}
				SsoUserDB.updateSsoUserDetailsFromHRStaff(userBean, String.valueOf(4656));
				for (int i = 4652; i <= 4654; i++) {
					SsoUserDB.updateSsoUserDetailsFromHRStaff(userBean, String.valueOf(i));
				}
				for (int i = 4636; i <= 4650; i++) {
					SsoUserDB.updateSsoUserDetailsFromHRStaff(userBean, String.valueOf(i));
				}
				for (int i = 4632; i <= 4634; i++) {
					SsoUserDB.updateSsoUserDetailsFromHRStaff(userBean, String.valueOf(i));
				}
				for (int i = 4619; i <= 4630; i++) {
					SsoUserDB.updateSsoUserDetailsFromHRStaff(userBean, String.valueOf(i));
				}
				isRun = true;
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
Update SSO User (<%=updateOption %>) from other system...
<%
	if (isRun) {
%>
	completed.
<%
	} else {
%>
	stop.
<%
	}
%><br/>
Success: <%=success %>
</body>
</html>