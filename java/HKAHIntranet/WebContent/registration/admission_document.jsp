<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%
UserBean userBean = new UserBean(request);

String admissionID = request.getParameter("admissionID");
String documentID = request.getParameter("documentID");

if (admissionID != null && admissionID.length() > 0) {
	ArrayList record = AdmissionDB.getDocumentList(admissionID);
	ReportableListObject row = null;
	String documentDesc = null;
	if (record.size() > 0) {
			%><li><span class="folder">Attachment</span><ul><%
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			documentID = row.getValue(0);
			documentDesc = row.getValue(1);
			%><li><span class="file"><a href="/upload/Admission at ward/<%=admissionID %>/<%=documentDesc %>" target="_blank"><%=documentDesc %></a></li><%
		}	
			%></ul></li><%
	}
}
%>