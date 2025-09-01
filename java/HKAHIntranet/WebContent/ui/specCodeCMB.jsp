<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String ls_specCode = request.getParameter("spCode");
%>
<%
ArrayList record = null;
ReportableListObject row = null;
	record = CTS.getSpecialty(null);
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);	 
%>
			<option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(ls_specCode)?" selected":"" %>>
				<%=row.getValue(1) %>
			</option>
<%
			}
		}
%>