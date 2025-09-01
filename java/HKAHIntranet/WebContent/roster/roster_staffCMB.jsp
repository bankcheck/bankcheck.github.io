<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="net.sf.json.*" %>
<%@ page import="java.io.PrintWriter" %>
<%!
public ArrayList getStaffList(String deptCode, String staffID) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT DECODE(S.CO_STATUS, 'FT', '1', 'PT', '0.5', S.CO_STATUS), ");
	sqlStr.append("		R.CO_STAFF_ROLE, S.CO_STAFF_ID, ");
	sqlStr.append("    	DECODE(S.CO_STAFFNAME, NULL, ");
	sqlStr.append("    			S.CO_FIRSTNAME||' '||S.CO_LASTNAME, S.CO_STAFFNAME) ");
	sqlStr.append("FROM CO_STAFFS_ROSTER_POSITION R, CO_STAFFS S ");
	sqlStr.append("WHERE S.CO_STAFF_ID = R.CO_STAFF_ID ");
	sqlStr.append("AND S.CO_ENABLED = '1' ");
	sqlStr.append("AND R.CO_ENABLED = '1' ");
	sqlStr.append("AND S.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
	if (staffID != null && staffID.length() > 0) {
		sqlStr.append("AND S.CO_STAFF_ID = '"+staffID+"' ");
	}
	sqlStr.append("ORDER BY R.CO_STAFF_ROLE DESC, S.CO_STATUS DESC, S.CO_STAFF_ID ");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>

<%
UserBean userBean = new UserBean(request);
String deptCode = request.getParameter("deptCode");
boolean isDeptHead = "true".equals(request.getParameter("isDeptHead"));

//System.out.println(deptCode);
//System.out.println(isDeptHead);
//System.out.println(userBean.getStaffID());

ArrayList record = getStaffList(deptCode, (isDeptHead?null:userBean.getStaffID()));
ReportableListObject row = null;
JSONObject staffJSON = new JSONObject();
JSONArray jsonArray = new JSONArray();
JSONObject rootJSON = new JSONObject();

if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		staffJSON = new JSONObject();
		row = (ReportableListObject) record.get(i);
		
		staffJSON.put("fte", row.getValue(0));
		staffJSON.put("post", row.getValue(1));
		staffJSON.put("empNo", row.getValue(2));
		staffJSON.put("names", row.getValue(3));
		
		jsonArray.add(staffJSON);
	}
	
	rootJSON.put("page", "1");
	rootJSON.put("total", "1");
	rootJSON.put("records", String.valueOf(record.size()));
	rootJSON.put("rows", jsonArray);
	
	response.setContentType("application/json");
	PrintWriter writer = response.getWriter();
	//System.out.println(rootJSON.toString());
	writer.print(request.getParameter("callback")+"("+rootJSON.toString()+ ");");
	writer.close();
}
else {
	rootJSON.put("page", "1");
	rootJSON.put("total", "0");
	rootJSON.put("records", String.valueOf(record.size()));
	rootJSON.put("rows", jsonArray);
	
	response.setContentType("application/json");
	PrintWriter writer = response.getWriter();
	//System.out.println(rootJSON.toString());
	writer.print(request.getParameter("callback")+"("+rootJSON.toString()+ ");");
	writer.close();
}
%>