<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.DateFormat"%>
<%@ page import="java.util.Date.*" %>
<%
String staffID = request.getParameter("staffID");
String leaveType = request.getParameter("leaveType");
boolean isSickChange = ConstantsVariable.YES_VALUE.equals(request.getParameter("isSickChange"));
boolean isOnlyShowAL = ConstantsVariable.YES_VALUE.equals(request.getParameter("isOnlyShowAL"));
isOnlyShowAL = false;
UserBean userBean = new UserBean(request);
if(isOnlyShowAL){
	if(StaffDB.isInLastMonthOfTerminationForEL(userBean.getSiteCode(),staffID)){
	%>
		<option value="" ></option>
	<%}else { 
		ArrayList record = ELeaveDB.getLeaveType(staffID);
		ReportableListObject row = null;
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			if("AL".equals(row.getValue(0))){%>
				<option value="AL" >ANNUAL LEAVE</option>
			<%}
		}
	%>	

	<%}
}else if(isSickChange){%>
	<option value="SL" <%="SL".equals(leaveType)?" selected":"" %>>SICK 4/5-DAYS+</option>
	<option value="SN" <%="SN".equals(leaveType)?" selected":"" %>>SICK 2/3 PAID</option>
	<option value="SI" <%="SI".equals(leaveType)?" selected":"" %>>SICK INJURY</option>
	
	
<%}else if(StaffDB.isInProbationForEL(userBean.getSiteCode(),staffID)){
%>
	<option value="NP">NO-PAY-LEAVE</option>
<%
}else if(StaffDB.isInLastMonthOfTerminationForEL(userBean.getSiteCode(),staffID)){
%>
	<option value="BL">BIRTHDAY LEAVE</option>
	<option value="HL">HOLIDAY LEAVE</option>		
<%	
}else{
	ArrayList record = ELeaveDB.getLeaveType(staffID);
	ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			if( (!"SN".equals(row.getValue(0)))&&(!"SI".equals(row.getValue(0)))&&(!"SL".equals(row.getValue(0)))){
				%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(leaveType)?" selected":"" %>><%=row.getValue(1) %></option><%
			}else if("SL".equals(row.getValue(0))){
				%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(leaveType)?" selected":"" %>>Sick / Injury</option><%
			}
		}
	}
}
%>