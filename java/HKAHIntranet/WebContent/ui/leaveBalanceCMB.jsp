<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String leaveType = request.getParameter("leaveType");
UserBean userBean = new UserBean(request);
String staffID = request.getParameter("staffID");


ArrayList recordDate = ELeaveDB.getAsAtDate();
String asAtDate = null;
String asAtMonth = null;
if (recordDate != null && recordDate.size() > 0) {
	ReportableListObject rowDate = (ReportableListObject) recordDate.get(0);
	asAtDate = rowDate.getValue(0);
	asAtMonth = rowDate.getValue(1);
}
ArrayList record = ELeaveDB.getBalanceList(staffID,"9999",leaveType);
ArrayList recordBal = ELeaveDB.getAsAtDateToSysdateUsage(staffID,leaveType,asAtMonth);
String availBal = null;
String usedBal = null;
Double  remainingBal = null;
String balDate = null;

ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(0);
		availBal = row.getValue(1);
		balDate = row.getValue(3);
	}
	if(recordBal.size() >0){
		for(int i =0;i<recordBal.size();i++){
			row = (ReportableListObject) recordBal.get(0);
			usedBal = row.getValue(1);
			
		}		
	}

if(availBal != null){
	remainingBal = Double.parseDouble(availBal)-Double.parseDouble(usedBal==null?"0":usedBal);
}

%>				<table>
				<tr><td>Available Balance: </td><td><%=availBal==null?"0":availBal %></td></tr>
				<tr><td>Used Balance: </td><td><u><%=usedBal==null?"0":usedBal %></u></td></tr>
				<%DecimalFormat df =new java.text.DecimalFormat("#.00"); %>
				<tr><td>Remaining Balance: </td><td><%= remainingBal==null?"0":Double.valueOf(df.format(remainingBal))%></td></tr></table>
				<input type="hidden" name="remainingBalance" value="<%= remainingBal==null?"0":Double.valueOf(df.format(remainingBal))%>"/>
				
<%}else{%>
No Information is found. Please call HR for any enquiry.
<%} %>
