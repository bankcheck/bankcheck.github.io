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
public static List<ReportableListObject> listHkahStaffYonYou() {
	String staffViewUserName = "sync_person_view_4IT";
	String staffViewPassword = "P@ssw0rd4ITSync";
	String staffViewTableName = "sync_person_view_4IT";
	String staffViewCols = "[Person_Code],[Name],[Surname],[Given_Name],[Chin_Full_Name],[Called_Name],"
			+ "[Hospital_No],[Dept_Code],[Dept_Name],[Position_Code],[Position_Name],[FTE],"
			+ "[Date_of_Availability],[Resignation_Date]";
	String staffViewOrderByCols = "[Person_Code]";
	
	List<ReportableListObject> result = null;
	try {
		result = StaffDB.getSqlServerReportableListObject(
				staffViewUserName, staffViewPassword, staffViewCols, staffViewTableName, null, staffViewOrderByCols);
		ReportableListObject rlo = null;

		if (result.size() > 0) {
			// DO NOT reset all staff status
			//UtilDBWeb.updateQueue(sqlStr_resetStaff, new String[] { ConstantsServerSide.SITE_CODE });
			
			String staffID = null;
			String name = null;
			String surname = null;
			String givenName = null;
			String chinFullName = null;
			String calledName = null;
			String hospitalNo = null;
			String deptCode = null;
			String deptName = null;
			String positionCode = null;
			String positionName = null;
			String fte = null;
			String dateOfAvailability = null;
			String resignationDate = null;
			
			List<String> hrStaffIDs = new ArrayList<String>();
			Map<String, String> staffPortalDeptCodes = new HashMap<String, String>();
			Map<String, String> staffHRDeptCodes = new HashMap<String, String>();

			for (int i = 0; i < result.size(); i++) {
				rlo = (ReportableListObject) result.get(i);

				staffID = rlo.getValue(0);
				name = rlo.getValue(1);
				surname = rlo.getValue(2);
				givenName = rlo.getValue(3);
				chinFullName = rlo.getValue(4);
				calledName = rlo.getValue(5);
				hospitalNo = rlo.getValue(6);
				deptCode = rlo.getValue(7);
				deptName = rlo.getValue(8);
				positionCode = rlo.getValue(9);
				positionName = rlo.getValue(10);
				fte = rlo.getValue(11);
				dateOfAvailability = rlo.getValue(12);
				resignationDate = rlo.getValue(13);
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
		System.out.println("[print_hkah_staff_2018] listHkahStaff error = " + e.getMessage());
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
		List<ReportableListObject> result = listHkahStaffYonYou();
		ReportableListObject rlo = null;
        if (result != null) {
%>
Total number of staff in HKAH HR Staff system: <%=result.size() %><br />

	<table border="1">
		<thead>
			<td>&nbsp;</td>
			<td>Person_Code</td>
			<td>Name</td>
			<td>Surname</td>
			<td>Given_Name</td>
			<td>Chin_Full_Name</td>
			<td>Called_Name</td>
			<td>Hospital_No</td>
			<td>Dept_Code</td>
			<td>Dept_Name</td>
			<td>Position_Code</td>
			<td>Position_Name</td>
			<td>FTE</td>
			<td>Date_of_Availability</td>
			<td>Resignation_Date</td>
		</thead>
<%
					String staffID = null;
					String name = null;
					String surname = null;
					String givenName = null;
					String chinFullName = null;
					String calledName = null;
					String hospitalNo = null;
					String deptCode = null;
					String deptName = null;
					String positionCode = null;
					String positionName = null;
					String fte = null;
					String dateOfAvailability = null;
					String resignationDate = null;
					
        		   for (int i = 0; i < result.size(); i++) {
        			   	rlo = (ReportableListObject) result.get(i);
					
        				staffID = rlo.getValue(0);
        				name = rlo.getValue(1);
        				surname = rlo.getValue(2);
        				givenName = rlo.getValue(3);
        				chinFullName = rlo.getValue(4);
        				calledName = rlo.getValue(5);
        				hospitalNo = rlo.getValue(6);
        				deptCode = rlo.getValue(7);
        				deptName = rlo.getValue(8);
        				positionCode = rlo.getValue(9);
        				positionName = rlo.getValue(10);
        				fte = rlo.getValue(11);
        				dateOfAvailability = rlo.getValue(12);
        				resignationDate = rlo.getValue(13);
%>
		<tr>
			<td><%=(i+1) %></td>
			<td><%=staffID == null ? " " : staffID %></td>
			<td><%=name == null ? " " : name %></td>
			<td><%=surname == null ? " " : surname %></td>
			<td><%=givenName == null ? " " : givenName %></td>
			<td><%=chinFullName == null ? " " : chinFullName %></td>
			<td><%=calledName == null ? " " : calledName %></td>
			<td><%=hospitalNo == null ? " " : hospitalNo %></td>
			<td><%=deptCode == null ? " " : deptCode %></td>
			<td><%=deptName == null ? " " : deptName %></td>
			<td><%=positionCode == null ? " " : positionCode %></td>
			<td><%=positionName == null ? " " : positionName %></td>
			<td><%=fte == null ? " " : fte %></td>
			<td><%=dateOfAvailability == null ? " " : dateOfAvailability %></td>
			<td><%=resignationDate == null ? " " : resignationDate %></td>
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