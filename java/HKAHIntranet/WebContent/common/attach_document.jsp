<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String moduleID = request.getParameter("moduleID");
String moduleDirectory = null;
String keyID = request.getParameter("keyID");
String key2ID = request.getParameter("key2ID");
String documentID = request.getParameter("documentID");

if ("pmp".equals(moduleID)) {
	moduleDirectory = "Project Management";
} else {
	moduleDirectory = moduleID;
}

if ("deleteDocument".equals(request.getParameter("command"))) {
	AttachDocumentDB.deleteDocument(userBean, moduleID, keyID, key2ID, documentID);
}

boolean allowRemove = "Y".equals(request.getParameter("allowRemove"));

ArrayList record = AttachDocumentDB.getDocument(moduleID, keyID, key2ID);
ReportableListObject row = null;
String documentDesc = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		documentID = row.getValue(0);
		documentDesc = row.getValue(1);
		if (allowRemove) { %>
			<a href="javascript:void(0);" onclick="removeDocument('<%=key2ID %>','<%=documentID %>');">x</a>
<%	} %>
			<a href="/upload/<%=moduleDirectory %>/<%=keyID %>/<%=documentDesc %>" target="_blank"><%=documentDesc %></a><br/>
<%
	}	
}
%>