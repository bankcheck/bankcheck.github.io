<%@ page import="com.hkah.web.common.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
UserBean userBean = new UserBean(request);
String progressStatus = request.getParameter("progressStatus");

boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "";
	}
%><option value=""><%=emptyLabel %></option><%
}
%>
<option value="Completed"<%="Completed".equals(progressStatus)?" selected":"" %>>Completed</option>
<option value="Halt"<%="Halt".equals(progressStatus)?" selected":"" %>>Halt</option>
<option value="In Progress"<%="In Progress".equals(progressStatus)?" selected":"" %>>In Progress</option>
<option value="On Schedule"<%="On Schedule".equals(progressStatus)?" selected":"" %>>On Schedule</option>
<option value="Pending"<%="Pending".equals(progressStatus)?" selected":"" %>>Pending</option>


