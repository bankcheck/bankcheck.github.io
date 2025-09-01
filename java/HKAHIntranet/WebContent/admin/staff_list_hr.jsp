<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%!
private String getSelectStaffSQL() {
	return "SELECT PERSON_CODE,NAME,SURNAME,GIVEN_NAME,CHIN_FULL_NAME,CALLED_NAME,HOSPITAL_NO,DEPT_CODE,DEPT_NAME,POSITION_CODE,POSITION_NAME,FTE,TO_CHAR(DATE_OF_AVAILABILITY, 'DD/MM/YYYY'),TO_CHAR(RESIGNATION_DATE, 'DD/MM/YYYY'),STAFF_TYPE,FORMER_EMP_ID,EMAIL_ADDRESS FROM " + ConstantsServerSide.getSiteShortTermSymbol() + "_PERSONAL_DATA_TABLE" + "@HR_COL ORDER BY PERSON_CODE";
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
<title>Staff List (HR)</title>
</head>
<body>
<div>Connecting to <%=ConstantsServerSide.getSiteShortForm() %> HR Staff List...</div>
<%
	String run = request.getParameter("run");
	boolean isRun = false;
	if ("1".equals(run)) {
			try {
			   ArrayList result = UtilDBWeb.getReportableList(getSelectStaffSQL());
			   ReportableListObject rlo = null;

			   System.out.println("HR COL staff result size="+result.size());
			   if (result.size() > 0) {
				   StringBuffer emailStr = new StringBuffer();

				   String staffCode = null;
				   String staffName = null;
				   String surname = null;
				   String givenName = null;
				   String chinFullName = null;
				   String calledName = null;
				   String hospitalNo = null;
				   String deptCodeHR = null;
				   String deptCode = null;
				   String deptDescription = null;
				   String positionCode = null;
				   String positionName = null;
				   String fte = null;
				   String dateOfAvailability = null;
				   String resignationDate = null;
				   String staffType = null;
				   String formerEmpNo = null;
				   String emailAddress = null;
				   
				   String staffEnabled = null;
				   String staffStatus = null;
				   String givenNameInShort = null;
				   String[] givenNameSplit = null;
				   String jobStatus = null;
				   String displayName = null;

				   DateFormat coHireDateFormat = new SimpleDateFormat("dd/MM/yyyy");
        		   
        		   String output = "";
        		   
        		   if (result != null) {
%>
Total number of staff in <%=ConstantsServerSide.getSiteShortForm() %> HR system: <%=result.size() %><br />
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
			<td>Person Code<br />(Emp ID)</td>
			<td>Name</td>
			<td>Surname</td>
			<td>givenName</td>
			<td>Chinese Full Name</td>
			<td>Called Name</td>
			<td>Hospital No</td>
			<td>Dept Code (HR)</td>
			<td>Dept Code (Portal)</td>
			<td>Dept Name</td>
			<td>Position Code</td>
			<td>Position Name</td>
			<td>FTE</td>
			<td>Date Of Availability</td>
			<td>Resignation Date</td>
			<td>Staff Type</td>
			<td>Former Emp ID</td>
			<td>Email</td>
		</thead>
<%
				int j = 0;
        		   for (int i = 0; i < result.size(); i++) {
        			   j = 0;
        			   	rlo = (ReportableListObject) result.get(i);
					
    					staffCode = rlo.getValue(j++);
    					staffName = rlo.getValue(j++);
    					surname = TextUtil.parseStr(rlo.getValue(j++));
    					givenName = TextUtil.parseStr(rlo.getValue(j++));
    					chinFullName = TextUtil.parseStr(rlo.getValue(j++));
    					calledName = TextUtil.parseStr(rlo.getValue(j++));
    					hospitalNo = TextUtil.parseStr(rlo.getValue(j++));
    					deptCodeHR = TextUtil.parseStr(rlo.getValue(j++));
    					deptCode = DepartmentDB.getPortalDeptCodeByHRDeptCode(deptCodeHR, ConstantsServerSide.SITE_CODE_TWAH, true);
    					deptDescription = TextUtil.parseStr(rlo.getValue(j++));
    					positionCode = TextUtil.parseStr(rlo.getValue(j++));
    					positionName = TextUtil.parseStr(rlo.getValue(j++));
    					fte = TextUtil.parseStr(rlo.getValue(j++));
    					dateOfAvailability = TextUtil.parseStr(rlo.getValue(j++));
    					resignationDate = TextUtil.parseStr(rlo.getValue(j++));
    					staffType = TextUtil.parseStr(rlo.getValue(j++));
    					//staffStatus = hrFTE2Status(fte);
    					formerEmpNo = TextUtil.parseStr(rlo.getValue(j++));
    					emailAddress = TextUtil.parseStr(rlo.getValue(j++));

    				 	givenNameSplit = (givenName != null) ? givenName.split(" ") : null;
    					givenNameInShort = "";
    					if (givenNameSplit != null && givenNameSplit.length > 0) {
    						for (String name : givenNameSplit) {
    							if (name != null && !"".equals(name)) {
    								if (!"".equals(givenNameInShort))
    									givenNameInShort += " ";
    								givenNameInShort += name.length() > 0 ? name.substring(0, 1).toUpperCase() : "";
    							}
    						}
    					}
    					staffEnabled = (resignationDate == null || resignationDate.isEmpty()) ? "1" : (DateTimeUtil.compareTo(resignationDate, DateTimeUtil.getCurrentDate()) == 1 ? "1" : "0");
    					//positionCode = positionCode.replace("P-", "");
    					
    					/*
    					System.out.println("COL:" + staffCode + ", " + displayName + ", " + staffName + ", " + surname + ", " + givenName + ", "  + chinFullName + ", " + calledName + ", " +
    							hospitalNo + ", " + ", " + deptCodeHR + ", " + deptCode + ", " + deptDescription + ", " + 
    							positionCode + ", " + positionName + ", " + fte + ", " + dateOfAvailability + ", " + resignationDate + ", " +
    							staffType + ", " + staffStatus + ", " + formerEmpNo + ", " + emailAddress + ", " + staffEnabled);
    					*/
%>
		<tr>
			<td><%=(i+1) %></td>
			<td><%=staffCode %></td>
			<td><%=staffName %></td>
			<td><%=surname %></td>
			<td><%=givenName %></td>
			<td><%=chinFullName %></td>
			<td><%=calledName %></td>
			<td><%=hospitalNo %></td>
			<td><%=deptCodeHR %></td>
			<td><%=deptCode == null || "null".equals(deptCode)? "" : deptCode %></td>
			<td><%=deptDescription %></td>
			<td><%=positionCode %></td>
			<td><%=positionName %></td>
			<td><%=fte %></td>
			<td><%=dateOfAvailability %></td>
			<td><%=resignationDate %></td>
			<td><%=staffType %></td>
			<td><%=formerEmpNo %></td>
			<td><%=emailAddress %></td>
		</tr>
<%
						//}
        		   }
%>
	</table>
<%
        	   }


		} catch (Exception e) {
			e.printStackTrace();
		}
		
		isRun = true;
	}
%>


<%
	if (isRun) {
%>
	completed.
<%
	} else {
%>
	stop.
<%
	}
%>
</body>
</html>