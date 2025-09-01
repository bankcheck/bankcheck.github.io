<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="net.sf.json.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.hkah.constant.*"%>
<%!
private ArrayList getStaffList(String deptCode, String staffID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT S.CO_STAFF_ID, ");
	sqlStr.append("	   	  DECODE(S.CO_STAFFNAME, NULL,S.CO_FIRSTNAME||' '||S.CO_LASTNAME, S.CO_STAFFNAME), ");
	sqlStr.append("       R.CO_STAFF_ROLE, R.CO_INCHARGE ");
	sqlStr.append("FROM  CO_STAFFS S, CO_STAFFS_ROSTER_POSITION R ");
	sqlStr.append("WHERE S.CO_STAFF_ID = R.CO_STAFF_ID(+) ");
	sqlStr.append("AND S.CO_ENABLED = '1' ");
	sqlStr.append("AND (R.CO_ENABLED = '1' OR R.CO_ENABLED IS NULL) ");
	if (staffID == null || staffID.length() == 0) {
		sqlStr.append("AND S.CO_STAFF_ID IN ( ");
		sqlStr.append(" 	                    SELECT CO_STAFF_ID ");
		sqlStr.append(" 	                    FROM CO_STAFFS ");
		sqlStr.append(" 	                    WHERE CO_ENABLED = '1' ");
		sqlStr.append(" 	                    AND CO_DEPARTMENT_CODE = '"+deptCode+"' ");
		sqlStr.append(" 	                    UNION ");
		sqlStr.append(" 	                    SELECT CO_STAFF_ID ");
		sqlStr.append(" 	                    FROM CO_STAFFS_ROSTER_POSITION ");
		sqlStr.append(" 	                    WHERE CO_ENABLED = '1' ");
		sqlStr.append(" 	                    AND CO_DEPARTMENT_CODE = '"+deptCode+"' ");
		sqlStr.append("              		) ");
	}
	else {
		sqlStr.append("AND S.CO_STAFF_ID = '"+staffID+"' ");
		sqlStr.append("AND R.CO_DEPARTMENT_CODE = '"+deptCode+"' ");
	}
   	sqlStr.append("ORDER BY S.CO_STAFF_ID ");
   	
    //System.out.println(sqlStr.toString());
   	
   	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private boolean addStafftoDept(UserBean userBean, String staffID, String post, 
								String incharge) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("INSERT INTO CO_STAFFS_ROSTER_POSITION ");
	sqlStr.append("(CO_SITE_CODE, CO_STAFF_ID, CO_STAFF_ROLE, ");
	sqlStr.append("CO_DEPARTMENT_CODE, CO_INCHARGE, CO_CREATED_DATE, ");
	sqlStr.append("CO_CREATED_USER) ");
	sqlStr.append("VALUES ('"+ConstantsServerSide.SITE_CODE+"', '"+staffID+"', ");
	sqlStr.append("'"+post+"', '"+userBean.getDeptCode()+"', '"+incharge+"', ");
	sqlStr.append("SYSDATE, '"+userBean.getStaffID()+"') ");
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

private boolean deleteStaff(UserBean userBean, String staffID) {
	StringBuffer sqlStr = new StringBuffer();
	return false;
}
%>

<%
UserBean userBean = new UserBean(request);

String action = request.getParameter("action");

if (action.equals("view")) {
	ArrayList records = getStaffList(userBean.getDeptCode(), null);
	ReportableListObject row = null;
	JSONObject staffJSON = new JSONObject();
	JSONArray jsonArray = new JSONArray();
	JSONObject rootJSON = new JSONObject();
	
	if (records.size() > 0) {
		for (int i = 0; i < records.size(); i++) {
			staffJSON = new JSONObject();
			row = (ReportableListObject) records.get(i);
			
			staffJSON.put("staffID", row.getValue(0));
			staffJSON.put("staffName", row.getValue(1));
			staffJSON.put("post", row.getValue(2));
			staffJSON.put("incharge", row.getValue(3));
			
			jsonArray.add(staffJSON);
		}
		
		rootJSON.put("page", "1");
		rootJSON.put("total", "1");
		rootJSON.put("records", String.valueOf(records.size()));
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
		rootJSON.put("records", String.valueOf(records.size()));
		rootJSON.put("rows", jsonArray);
		
		response.setContentType("application/json");
		PrintWriter writer = response.getWriter();
		//System.out.println(rootJSON.toString());
		writer.print(request.getParameter("callback")+"("+rootJSON.toString()+ ");");
		writer.close();
	}
}
else if (action.equals("add")) {
	String staffID = request.getParameter("staffID");
	String post = request.getParameter("post");
	String incharge = request.getParameter("incharge");
	
	if (incharge.equals("true")) {
		incharge = "Y";
	}
	else {
		incharge = "N";
	}
	
	boolean success = addStafftoDept(userBean, staffID, post, incharge);
	
	%><%=success%><%
}
else if (action.equals("delete")) {
	String staffID = request.getParameter("staffID");
	
	
}
%>