<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String infoCategory= request.getParameter("infoCategory");
String value = request.getParameter("value");
boolean allowAll = "Y".equals(request.getParameter("allowAll"));

ArrayList record = null;
ReportableListObject row = null;
String filename = null;
String fileID = null;
String fileURL = null;
record = DocumentDB. getListwithURL();

	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			filename = row.getValue(1);
			fileID = row.getValue(0);
			fileURL = row.getValue(2);


			
%><option title="<%=fileURL %>" value="<%=fileID %>"<%=fileID.equals(value)?" selected":"" %>>
<%=filename %></option>
<%

		}
		}

%>