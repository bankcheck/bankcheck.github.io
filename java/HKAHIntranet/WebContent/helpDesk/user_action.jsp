<%@ page language="java" contentType="application/json; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.IcGeRespDB"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.util.*" %>

<%
	UserBean userBean = new UserBean(request);
	String userid = request.getParameter("userid");
	String callback = request.getParameter("callback");
	String action = request.getParameter("action");
	
	//System.out.println("DEBUG user_action.jsp action="+action+", userid="+userid);

	JSONObject obj = new JSONObject();
	boolean success = false;
	String message = null;
	if (userBean.isAccessible("function.helpDesk.user.update")) {
		if ("synPw".equals(action)) {
			success = HelpDeskDB.synchronizePortalPassword(userid);
			if (success) {
				message = (userid == null ? "" : "Staff ID: " + userid + " ") + "password synchronization success.";
			} else {
				message = (userid == null ? "" : "Staff ID: " + userid + " ") + "password synchronization failed.";
			}
		} else if ("logout".equals(action)) {
			success = HelpDeskDB.logout(userid);
			if (success) {
				message = (userid == null ? "" : "Staff ID: " + userid + " ") + "status has been changed to logout.";
			} else {
				message = (userid == null ? "" : "Staff ID: " + userid + " ") + "logout failed.";
			}
		}
	} else {
		message = "Invalid access";
	}
	obj.put("result",success);
	obj.put("message",message);
    
	String jsonString = JSONObject.toJSONString(obj);
	if (callback != null) {
		jsonString = callback + "(" + jsonString + ")";
	}

	out.print(jsonString);
    out.flush();
%>
