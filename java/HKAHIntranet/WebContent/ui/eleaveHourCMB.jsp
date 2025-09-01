<%
String leaveType = request.getParameter("leaveType");
String appliedHour = request.getParameter("appliedHour").trim();
int appliedHourInt = 0;

try {
	appliedHourInt = Integer.parseInt(appliedHour);
} catch (Exception e) {}

if ("BL".equals(leaveType)) {
	%><option value="8"<%=appliedHourInt==8?" selected":"" %>>8</option><%
} else if ("HL".equals(leaveType)) {
	%><option value="4"<%=appliedHourInt==4?" selected":"" %>>4</option><%
	%><option value="8"<%=appliedHourInt==8?" selected":"" %>>8</option><%
} else {
	for (int i = 0; i <= 240; i++) {
		%><option value="<%=i %>"<%=i==appliedHourInt?" selected":"" %>><%=i %></option><%
	}
}
%>