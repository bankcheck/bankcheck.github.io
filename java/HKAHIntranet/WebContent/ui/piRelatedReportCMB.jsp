<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String pirID = request.getParameter("pirID");
String relPirID = request.getParameter("relPirID");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "";
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = PiReportDB.getReportList();
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		
		if(!row.getValue(0).equals(pirID)){
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(relPirID)?" selected":"" %>><%=row.getValue(0) %></option><%
		}
	}
}
%>