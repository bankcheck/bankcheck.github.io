<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String amtID = request.getParameter("amountID");
String appGrp = request.getParameter("appGrp");
ArrayList record = null;

record = EPORequestDB.getAmountList(amtID,appGrp);
ReportableListObject row = null;
String userID = null;
String userName = null;

if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%>
		<option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(amtID)?" selected":"" %>><%=row.getValue(1) %></option><%
	}
}
%>