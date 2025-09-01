<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%!
public static ArrayList listHkahStaff() {
	String sqlStr_selectAccessStaff = 	
		"SELECT [Staff No], hosp_no, [Staff Name], [Dept Code], Status, [Pos1], [Pos2], qual, PosCode1, PosCode2, PosCode3 " +
		"FROM   [Staff List] " + 
		"ORDER BY [Staff No]";
	ArrayList result = null;
	Connection conn = null;
	try {
		Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
		conn = DriverManager.getConnection("jdbc:odbc:stafflist");

		result = UtilDBWeb.getReportableList(conn, sqlStr_selectAccessStaff);
	} catch (Exception e) {
		e.printStackTrace();
		System.out.println("listNonWardSsoAlertStaff.jsp, error = " + e.getMessage());
	}
	return result;
}


%>
<%
	UserBean userBean = new UserBean(request);
	if (userBean == null || !userBean.isAdmin()) {
%>
<jsp:forward page="" /> 
<%
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>List missing sso staffs in Ewell</title>
</head>
<body>
Connecting to HKAH HR System and portal Staff list...<br>
<%
	String run = request.getParameter("run");
	boolean isRun = false;
	if ("1".equals(run)) {
		ArrayList result = listHkahStaff();
        if (result != null) {
        	ArrayList<String> staffIds = new ArrayList<String>();
        	ReportableListObject row = null;
			for (int i = 0; i < result.size(); i++) {
				row = (ReportableListObject) result.get(i);
				String id = row.getValue(0);
				String posCode1 = row.getValue(8);
				String posCode2 = row.getValue(9);
				String posCode3 = row.getValue(10);
				
				if (SsoUserDB.alertPosCode.contains(posCode1) ||
						SsoUserDB.alertPosCode.contains(posCode2) ||
						SsoUserDB.alertPosCode.contains(posCode3)) {
					staffIds.add(id);
				}
			}
        	
	        // get CPLab, CCIC, OPD, OT
	        // 210 200 370 360
	        String staffIdsStr = StringUtils.join(staffIds, "','");
	        StringBuffer sqlStr = new StringBuffer();
	        sqlStr.append("SELECT S.CO_STAFF_ID, S.CO_STAFFNAME, D.CO_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
	        sqlStr.append(" S.CO_POSITION_1, S.CO_POSITION_2 ");
	        sqlStr.append("FROM   CO_STAFFS S, CO_DEPARTMENTS D ");
	        sqlStr.append("WHERE   S.CO_ENABLED > 0 ");
	        sqlStr.append("AND   S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
	        sqlStr.append("AND S.CO_STAFF_ID IN ('" + staffIdsStr + "') ");
	        sqlStr.append("AND S.CO_DEPARTMENT_CODE IN ('200','210','370','360') ");
	        sqlStr.append("ORDER BY D.CO_DEPARTMENT_CODE, S.CO_STAFF_ID");
	        ArrayList result2 = UtilDBWeb.getReportableList(sqlStr.toString());
        	
%>
Total number of staff in non-ward list: <%=result2.size() %><br />

	<table border="1">
		<thead>
			<td>&nbsp;</td>
			<td>staff ID</td>
			<td>staff Name</td>
			<td>Dept Code</td>
			<td>Dept Desc</td>
			<td>Position</td>
		</thead>
<%
					String staffID = null;
					String staffName = null;
					String deptCode = null;
					String deptDesc = null;
					String position1 = null;
					String position2 = null;
					
        		   for (int i = 0; i < result2.size(); i++) {
        			   	row = (ReportableListObject) result2.get(i);
					
        				staffID = row.getValue(0);
        				staffName = row.getValue(1);
        				deptCode = row.getValue(2);
        				deptDesc = row.getValue(3);
        				position1 = row.getValue(4);
        				position2 = row.getValue(5);
					
%>
		<tr>
			<td><%=(i+1) %></td>
			<td><%=staffID == null ? " " : staffID %></td>
			<td><%=staffName == null ? " " : staffName %></td>
			<td><%=deptCode == null ? " " : deptCode %></td>
			<td><%=deptDesc == null ? " " : deptDesc %></td>
			<td><%=position1 == null ? " " : position1 %><%=position2 == null ? "" : (position1 == "" ? "" : ", ") + position2 %></td>
		</tr>
<%
        		   }
%>
	</table>
<%
			isRun = true;

     } else {
%>
No result returned.<br />
<%  			   
     }
	}
	if (isRun) {
%>
	Run success.
<%
	} else {
%>
	stop.
<%
	}
%>
</body>
</html>