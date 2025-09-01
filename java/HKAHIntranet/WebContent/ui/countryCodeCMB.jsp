<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>

<option value=""></option>
<%
//20181211 Arran added language
String coucode = request.getParameter("coucode");
String language = request.getParameter("language");
String display = null;

ArrayList record = UtilDBWeb.getFunctionResults("NHS_CMB_COUNTRY", null);
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);

		if ("chi".equals(language) && !row.getValue(2).isEmpty())
			display = row.getValue(2);
		else
			display = row.getValue(1);
		
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(coucode)?" selected":"" %>><%=display %></option><%
	}
}
%>