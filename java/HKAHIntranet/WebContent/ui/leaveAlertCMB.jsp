<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String staffID = request.getParameter("staffID");
String fromDate = request.getParameter("fromDate");
String endDate = request.getParameter("endDate");


if (staffID != null && fromDate!=null) {
ArrayList recordLeave = ELeaveDB.getListwithSpecificDateAndStaff(fromDate,endDate,staffID);
	if(recordLeave.size()>0){
%>
		<table> 
			<tr><td colspan="8">You have already applied the following leave on the same day</td></tr>
			<tr><td colspan="8">&nbsp;</td></tr>
			<tr><td>Leave Type</td><td>&nbsp;</td><td width="20">Date From</td><td>&nbsp;</td><td width="20">Date To</td><td>&nbsp;</td><td>Applied Hour</td><td>Applied Day(s)</td></tr>
			<% for (int i = 0; i < recordLeave.size(); i++) {
				ReportableListObject rowLeave = (ReportableListObject) recordLeave.get(i);
			%>
				<tr>
					<td><%=rowLeave.getValue(4)%></td>
					<td>&nbsp;</td><td width="20"><%=rowLeave.getValue(0)%></td>
					<td>&nbsp;</td><td width="20"><%=rowLeave.getValue(1)%></td>
					<td>&nbsp;</td><td><%=rowLeave.getValue(3)%></td>
					<td><%=rowLeave.getValue(2)%></td>
				</tr>
			<%}%>
			<tr><td colspan="8">&nbsp;</td></tr>
			<tr><td colspan="8">Do you still want to contiue the application?</td></tr>
		</table>
		
<%	}
}%>