<%@ page language="java" contentType="application/json; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.IcGeRespDB"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.util.*" %>

<%
	UserBean userBean = new UserBean(request);
	String command = request.getParameter("command");
	String callback = request.getParameter("callback");

	System.out.println("command..." + command);
	
	JSONObject obj = new JSONObject();
	if (userBean.isAccessible("function.ic.ge_resp." + command) || userBean.isAccessible("function.ic.bld_mrsa_esbl." + command)) {
		String labNum = request.getParameter("labNum");
		
		String hospnum = null;
		String patname = null;
		String patsex = null;
		String patbdate = null;
		String age = null;
		String month = null;
		String ward = null;
		String room_num = null;
		String bed_num = null;
		String date_in = null;	
		
		
		System.out.println("getPatInfo..." + labNum);
		// load data from database
		if (labNum != null) {
			ArrayList record = IcGeRespDB.getPatInfoByLabNum(userBean, labNum);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				hospnum = row.getValue(0);
				patname = row.getValue(1);
				patsex = row.getValue(2);
				patbdate = row.getValue(3);
				age = row.getValue(4);
				month = row.getValue(5);
				ward = row.getValue(6);
				room_num = row.getValue(7);
				bed_num = row.getValue(8);
				date_in = row.getValue(9);				
			}
		}
		
				
		// TESTING data
		// You should call DB java to get the fields value
		obj.put("HospNum",hospnum);
		obj.put("PatName",patname);
		obj.put("PatSex",patsex);
		obj.put("PatBDate",patbdate);
		obj.put("Age",age);
		obj.put("Month",month);
		obj.put("Ward",ward);
		obj.put("RoomNum",room_num);
		obj.put("BedNum",bed_num);
		obj.put("DateIn",date_in);
		
	} else {
		String errorMsg = "Invalid access";
		
		obj.put("errorMsg", errorMsg);
	}
    
	String jsonString = JSONObject.toJSONString(obj);
	if (callback != null) {
		jsonString = callback + "(" + jsonString + ")";
	}
	
	out.print(jsonString);
    out.flush();
%>
