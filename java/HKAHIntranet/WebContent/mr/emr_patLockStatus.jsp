<%@ page language="java" contentType="application/json; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.IcGeRespDB"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.util.*" %>

<%
	UserBean userBean = new UserBean(request);
	String callback = request.getParameter("callback");
	String action = request.getParameter("action");
	String patno = request.getParameter("patno");
	
	JSONObject obj = new JSONObject();
	JSONObject recordObj = new JSONObject();
	boolean success = false;
	String message = null;
	
	if (action == null) {
		message = "No action specified";
	} else if ("lockStatus".equals(action)) {
		if (userBean.isAccessible("function.mr.emracc.view")) {
			if (patno == null || patno.trim().isEmpty()) {
				message = "Please provide Patient No.";
			} else {
				ArrayList record = PatientDB.getPatLockStatus(patno);
				ReportableListObject row = null;
				
				String patfname = null;
				String patgname = null;
				String lockDate = null;
				String unlockDate = null;
				String islocked = null;
				
				if (record.size() > 0) {
					row = (ReportableListObject) record.get(0);
					
					recordObj.put("patno", row.getValue(0));
					recordObj.put("patname", row.getValue(1) + " " + row.getValue(2));
					recordObj.put("lockDate", row.getValue(3));
					recordObj.put("unlockDate", row.getValue(4));
					recordObj.put("islocked", row.getValue(5));
					recordObj.put("seqno", row.getValue(6));
					success = true;
				} else {
					message = "No patient found";
				}
			}
		} else {
			message = "You do not have access to view patient record lock status.";
		}
	}
	
	obj.put("result",success);
	if (success) {
		obj.put("object",recordObj);
	} else {
		obj.put("message",message);
	}
    
	String jsonString = JSONObject.toJSONString(obj);
	if (callback != null) {
		jsonString = callback + "(" + jsonString + ")";
	}
	
	out.print(jsonString);
    out.flush();
%>