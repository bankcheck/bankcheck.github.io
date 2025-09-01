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
	
	//System.out.println("DEBUG synPassword.jsp");

	JSONObject obj = new JSONObject();
	boolean success = false;
	String message = null;
	if (userBean.isAccessible("function.helpDesk.user.update")) {
		success = HelpDeskDB.synchronizePortalPassword(userid);
		if (success) {
			message = (userid == null ? "" : "Staff ID: " + userid + " ") + "Password synchronization finish.";
		} else {
			message = (userid == null ? "" : "Staff ID: " + userid + " ") + "Password synchronization failed.";
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
	
	//System.out.println(" jsonString="+jsonString);
	
	out.print(jsonString);
    out.flush();
%>
