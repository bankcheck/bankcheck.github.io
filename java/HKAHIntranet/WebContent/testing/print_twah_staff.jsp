<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>


<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.db.*"%>
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
<title>conn-twah-mssql</title>
</head>
<body>
Connecting to TWAH MSSQL...<br>
<%
	String run = request.getParameter("run");
	boolean isRun = false;
	if ("1".equals(run)) {
		
		Connection conn = null;
	    String url = "jdbc:sqlserver://";
	    String serverName= "192.168.0.196";
	    String portNumber = "1433";
	    String databaseName= "AHHK";
	    String userName = "TWAH";
	    String password = "twah1234";
	    // Informs the driver to use server a side-cursor, 
	    // which permits more than one active statement 
	    // on a connection.
	    String selectMethod = "cursor"; 
	    
	    String sqlStr_selectTWAHStaff = null;
	    StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT V.STAFF_CODE, V.SURNAME, V.GIVEN_NAME, V.CHRISTIAN_NAME, " +
				"V.DATE_JOINED, V.DEPT_CODE, V.EMAIL_ADDRESS, V.JOB_DESCRIPTION, V.STAFF_STATUS, V.SITE, V2.DEPT_DESCRIPTION, V.JOB_DESCRIPTION ");
		sqlStr.append("FROM   TWAH_INTRANET_VIEW V LEFT JOIN TWAH_INTRANET_VIEW2 V2 ");
		sqlStr.append("ON	  V.DEPT_CODE = V2.DEPT_CODE ");
		sqlStr_selectTWAHStaff = sqlStr.toString();
	    
	    String connUrl = url + serverName + ":" + portNumber + ";databaseName=" + databaseName + ";selectMethod=" + selectMethod + ";";

		try {
           //Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");		sqljdbc.jar
           Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver"); 		// sqljdbc4.jar
           conn = java.sql.DriverManager.getConnection(connUrl, userName, password);
           if (conn != null) {
        	   ArrayList result = UtilDBWeb.getReportableList(conn, sqlStr_selectTWAHStaff);
        	   ReportableListObject rlo = null;
				
        	   if (result.size() > 0) {
        		   // reset all staff status
        		   // UtilDBWeb.updateQueue(sqlStr_resetTWAHStaff);

        		   /*
        		    * Description of the TWAH table fields
//				  STAFF_CODE, 
//				  SURNAME, 
//				  GIVEN_NAME, 
//				  CHRISTIAN_NAME, 
//				  DATE_JOINED,		(format e.g.: 2009-12-01 00:00:00.0 yyyy-MM-dd hh:mm:ss.S)
//				  DEPT_CODE, 
//				  EMAIL_ADDRESS, 
//				  STAFF_STATUS  ('A'=active -> 1, 'L'=leaving next month, 'P'=probation -> 1, 'T'=inactive -> 0, 'N'=joining next month), 
//        		   CO_ENABLED = 0 ('T', 'N')
//        		   CO_ENABLED = 1 ('A', 'L', 'P')
//				  SITE  ('TWAH' = Tsuen Wan Adventist Hospital), 
// 				  DEPT_DESCRIPTION,
//				  JOB_DESCRIPTION
        		    */
				
        		   String staffCode = null;
        		   String surname = null;
        		   String givenName = null;
        		   String christianName = null;
        		   String dateJoined = null;
        		   String deptCode = null;
        		   String emailAddress = null;
        		   String staffStatus = null;
        		   String site = null;
        		   String deptDescription = null;
        		   String jobDescription = null;
        		   
        		   String staffName = null;
        		   String givenNameInShort = null;
        		   String[] givenNameSplit = null; 
        		   
        		   DateFormat dateJoinedFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss.S");
        		   DateFormat coHireDateFormat = new SimpleDateFormat("dd/MM/yyyy");
        		   java.util.Date dateJoinedDate = null;
        		   
        		   String output = "";
        		   
        		   if (result != null) {
%>
Total number of staff in TWAH system: <%=result.size() %><br />
<%
        		   } else {
%>
No result returned.<br />
<%  			   
        		   }
        		   
%>
	<table border="1">
		<thead>
			<td> </td>
			<td>staffCode</td>
			<td>staffName</td>
			<td>surname</td>
			<td>givenName</td>
			<td>christianName</td>
			<td>jobDescription</td>
			<td>deptCode</td>
			<td>deptDescription</td>
			<td>emailAddress</td>
			<td>HireDate</td>
			<td>staffStatus</td>
		</thead>
<%
        		   for (int i = 0; i < result.size(); i++) {
        			   	rlo = (ReportableListObject) result.get(i);
					
						staffCode = rlo.getValue(0);
						surname = TextUtil.parseStr(rlo.getValue(1));
						givenName = TextUtil.parseStr(rlo.getValue(2));
						christianName = TextUtil.parseStr(rlo.getValue(3));
						dateJoined = TextUtil.parseStr(rlo.getValue(4));
	        		    if (dateJoined != null) {
	        		    	dateJoinedDate = dateJoinedFormat.parse(dateJoined);
	        		    }
	        		    deptCode = TextUtil.parseStr(rlo.getValue(5));
						emailAddress = TextUtil.parseStr(rlo.getValue(6));
						staffStatus = TextUtil.parseStr(rlo.getValue(7));
						staffStatus = TextUtil.parseStr(rlo.getValue(8));
						site = TextUtil.parseStr(rlo.getValue(9));
						deptDescription = TextUtil.parseStr(rlo.getValue(10));
						jobDescription = TextUtil.parseStr(rlo.getValue(11));
					
						if ("TWAH".equals(site)) {
							givenNameSplit = (givenName != null) ? givenName.split(" ") : null;
							givenNameInShort = "";
							if (givenNameSplit != null && givenNameSplit.length > 0) {
								for (String name : givenNameSplit) {
									if (name != null) {
										if (!"".equals(givenNameInShort))
											givenNameInShort += " ";
										givenNameInShort += name.substring(0, 1).toUpperCase();
									}
								}
							}
							staffName = (christianName != null && !org.apache.commons.lang.StringUtils.isBlank(christianName) ? christianName.trim() + " " : "") +
										(surname != null && !org.apache.commons.lang.StringUtils.isBlank(surname) ? surname.trim() + " " : "") +
										(givenName != null && !org.apache.commons.lang.StringUtils.isBlank(givenName) ? givenName.trim() + " " : "");

							/*
							output = "id=" + staffCode + ", " + staffName + ", surname=" + surname + ", givenName=" + givenName + ", christianName=" + christianName + 
									", jobDescription=" + jobDescription + ", deptCode=" + deptCode + ", deptDescription=" + deptDescription + ", emailAddress=" + emailAddress + 
									", HireDate=" + coHireDateFormat.format(dateJoinedDate) + ", staffStatus=" + ("T".equals(staffStatus) ? "0" : "1");
							*/

%>
		<tr>
			<td><%=(i+1) %></td>
			<td><%=staffCode %></td>
			<td><%=staffName %></td>
			<td><%=surname %></td>
			<td><%=givenName %></td>
			<td><%=christianName %></td>
			<td><%=jobDescription %></td>
			<td><%=deptCode %></td>
			<td><%=deptDescription %></td>
			<td><%=emailAddress %></td>
			<td><%=coHireDateFormat.format(dateJoinedDate) %></td>
			<td><%=("T".equals(staffStatus) ? "0" : "1") %></td>
		</tr>
<%
						}
        		   }
%>
	</table>
<%
        	   }
           }


		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (conn != null)
				conn.close();
		}
		
		isRun = true;
	}

%>


<%
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