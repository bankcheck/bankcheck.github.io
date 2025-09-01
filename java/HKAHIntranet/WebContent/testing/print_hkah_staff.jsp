<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.db.*"%>
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
		System.out.println("listHkahStaff.jsp, error = " + e.getMessage());
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
<title>List HKAH HR System Staff list</title>
</head>
<body>
Connecting to HKAH HR System Staff list...<br>
<%
	String run = request.getParameter("run");
	boolean isRun = false;
	if ("1".equals(run)) {
		ArrayList result = listHkahStaff();
		ReportableListObject rlo = null;
        if (result != null) {
%>
Total number of staff in HKAH HR Staff system: <%=result.size() %><br />

	<table border="1">
		<thead>
			<td>&nbsp;</td>
			<td>staff ID</td>
			<td>Hosp No</td>
			<td>Staff Name</td>
			<td>Dept Code</td>
			<td>Status</td>
			<td>Position 1</td>
			<td>Position 2</td>
			<td>Qual</td>
			<td>pos1</td>
			<td>pos2</td>
			<td>pos3</td>
		</thead>
<%
					String staffID = null;
					String hospNo = null;
					String staffName = null;
					String deptCode = null;
					String status = null;
					String position1 = null;
					String position2 = null;
					String qual = null;
					String posCode1 = null;
					String posCode2 = null;
					String posCode3 = null;
					
        		   for (int i = 0; i < result.size(); i++) {
        			   	rlo = (ReportableListObject) result.get(i);
					
        				staffID = rlo.getValue(0);
        				hospNo = rlo.getValue(1);
        				staffName = rlo.getValue(2);
        				deptCode = rlo.getValue(3);
        				status = rlo.getValue(4);
        				position1 = rlo.getValue(5);
        				position2 = rlo.getValue(6);
        				qual = rlo.getValue(7);
        				posCode1 = rlo.getValue(8);
        				posCode2 = rlo.getValue(9);
        				posCode3 = rlo.getValue(10);
					
%>
		<tr>
			<td><%=(i+1) %></td>
			<td><%=staffID == null ? " " : staffID %></td>
			<td><%=hospNo == null ? " " : hospNo %></td>
			<td><%=staffName == null ? " " : staffName %></td>
			<td><%=deptCode == null ? " " : deptCode %></td>
			<td><%=status == null ? " " : status %></td>
			<td><%=position1 == null ? " " : position1 %></td>
			<td><%=position2 == null ? " " : position2 %></td>
			<td><%=qual == null ? " " : qual %></td>
			<td><%=posCode1 == null ? " " : posCode1 %></td>
			<td><%=posCode2 == null ? " " : posCode2 %></td>
			<td><%=posCode3 == null ? " " : posCode3 %></td>
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
	method called.
<%
	} else {
%>
	stop.
<%
	}
%>
</body>
</html>