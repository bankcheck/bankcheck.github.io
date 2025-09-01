<%@ page language="java" contentType="application/json; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.IcGeRespDB"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.util.*" %>

<%
	UserBean userBean = new UserBean(request);
	String command = request.getParameter("command");
	String callback = request.getParameter("callback");
	
//	System.out.println("command..." + command);
	
	JSONObject obj = new JSONObject();
	if (userBean.isAccessible("function.ic.ge_resp." + command) || userBean.isAccessible("function.ic.bld_mrsa_esbl." + command)) {
		String labnum = request.getParameter("labnum");
		
		String organdesc = null;
		String quandesc = null;
		String suscepdesc = null;
		String susceprst = null;
		String textresult = null;
		String daterpt = null;
		String finalreturn = "";
		String finalreturn2 = "";
		String finalreturn3 = "";
		
//		System.out.println("getMicBioInfo..." + labnum);

		// load data from database
		if (labnum != null) {
			ArrayList record = IcGeRespDB.getMicBioOrganByLabNum(userBean, labnum);
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
  					ReportableListObject row = (ReportableListObject) record.get(i);
  					organdesc = row.getValue(0);
  					quandesc = row.getValue(1);
  					finalreturn += organdesc + " " + quandesc + "<br>";
				} 
			}

			ArrayList record2 = IcGeRespDB.getMicBioAntiByLabNum(userBean, labnum);
			if (record2.size() > 0) {
				for (int i = 0; i < record2.size(); i++) {
  					ReportableListObject row = (ReportableListObject) record2.get(i);
  					organdesc = row.getValue(2);
  					suscepdesc = row.getValue(3);
  					susceprst = row.getValue(4);
  					finalreturn2 += organdesc + ", " + suscepdesc + ", " + susceprst + "<br>";
				} 
			}

			ArrayList record3 = IcGeRespDB.getMicBioTextResultByLabNum(userBean, labnum);
			if (record3.size() > 0) {
 				ReportableListObject row = (ReportableListObject) record3.get(0);
  				//textresult = row.getValue(0) + ", " + row.getValue(1);
  				textresult = row.getValue(1);
  				daterpt = row.getValue(2);
 				finalreturn3 += textresult;
			}			

		}
		
		System.out.println("DATERPT " + daterpt);
	
		obj.put("ORGANISM", finalreturn);
		obj.put("ANTIBIOTIC", finalreturn2);
		obj.put("TEXTRESULT", finalreturn3);
		obj.put("DATERPT", daterpt);
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
