<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%
String doccode = request.getParameter("doccode");
String selectFrom = request.getParameter("selectFrom");
//String docname =  request.getParameter("docname");
String docname =  TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "docname"));

if (docname != null) {
	docname.replace("'", "''");
}

ArrayList<ReportableListObject> record = UtilDBWeb.getFunctionResults("HAT_CMB_DOCTOR2", new String[] { selectFrom, docname });
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		if ("Pre-addmission".equals(selectFrom)) {
			%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(doccode)?" selected":"" %>><%=row.getValue(1) %> <%=row.getValue(2) %> <%=row.getValue(3) %></option><%
		} else {
			%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(doccode)?" selected":"" %>><%=row.getValue(1) %> <%=row.getValue(2) %> (<%=row.getValue(0) %>)</option><%
		}
	}
} %>