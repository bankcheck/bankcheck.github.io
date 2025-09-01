<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>

<%
StringBuffer sqlStr = new StringBuffer();
String religion = request.getParameter("religion");

sqlStr.append("SELECT RELCODE, RELDESC FROM RELIGIOUS@IWEB");

ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());

ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);		
		%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(religion)?" selected":"" %>><%=row.getValue(1) %></option><%
	
	}
}

%>