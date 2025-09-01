<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>

<%
String mktsrccode = request.getParameter("mktSrc");
String language = request.getParameter("language");
String display = null;

ArrayList record = UtilDBWeb.getFunctionResults("NHS_CMB_MKTSRC", new String[] {});
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		
		if ("chi".equals(language) && !row.getValue(2).isEmpty())
			display = row.getValue(2);
		else
			display = row.getValue(1);
%>
<option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(mktsrccode)?" selected":"" %>><%=display %></option>
<%
	}
}
%>