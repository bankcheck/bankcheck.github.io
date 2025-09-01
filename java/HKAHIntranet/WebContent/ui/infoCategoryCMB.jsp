<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
UserBean userBean = new UserBean(request);
String infoCategory= request.getParameter("infoCategory");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
boolean allowAll = "Y".equals(request.getParameter("allowAll"));

if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- Please select ---";
	}
%><option value="EMPTY"><%=emptyLabel %></option><%
}

if (allowAll) {
	String allLabel = request.getParameter("allLabel");
	if (allLabel == null) {
		allLabel = "--- All Category ---";
	}
%><option value=""><%=allLabel %></option><%
}

ArrayList record = null;
ReportableListObject row = null;
record = InformationDB.getCategorylist();

	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
%>
<%if (row.getValue(2) == null || userBean.isAccessible(row.getValue(2))) { %>
<option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(infoCategory)?" selected":"" %>>
<%	try {
	%><bean:message key="<%=row.getValue(2) %>" /><%
	} catch (Exception e) {
		%><%=row.getValue(1) %><%
	}
%>
</option>
<%} %>
<%
			}
		}
%>