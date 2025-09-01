<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String moduleCode = request.getParameter("moduleCode");
String keyID = request.getParameter("keyID");
String documentID = request.getParameter("documentID");

if (keyID != null && keyID.length() > 0) {
	ArrayList record = DocumentDB.getList(userBean, moduleCode, keyID);
	ReportableListObject row = null;
	String documentUrl = null;
	String documentDesc = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			documentID = row.getValue(0);
			documentUrl = row.getValue(1);
			documentDesc = row.getValue(2);%>
<a href="<%=documentUrl %>/<%=documentDesc %>" target="_blank"><%=documentDesc %></a><br/>
<%		}
	}
}
%>