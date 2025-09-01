<%@ page language="java" contentType="text/html; charset=big5" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.util.db.*" %>
<%@ page import="com.hkah.web.common.*" %>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList<ReportableListObject> fetchProcRange(String procedure, String acmcode) {
		return UtilDBWeb.getFunctionResultsHATS("NHS_GET_PROCRANGE", new String[] { procedure, acmcode });
	}

	private String arrayList2Table(String procedure, String acmcode) {
		StringBuffer strBuf = new StringBuffer();
		ArrayList<ReportableListObject> record = fetchProcRange(procedure, acmcode);
		ReportableListObject row = null;
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				strBuf.append("<td>");
				strBuf.append(row.getValue(0));
				strBuf.append("<input type=\"radio\" name=\"priceRange\" onclick=\"changeRange('");
				strBuf.append(acmcode);
				strBuf.append("','");
				strBuf.append(row.getValue(0));
				strBuf.append("');\"></td>");
			}
		} else {
			strBuf.append("<td align='center' colspan='7'>No Reference Data</td>");
		}
		return strBuf.toString();
	}
%>
<%
String procedure2 = request.getParameter("procedure2");
%>
<br>
<table width="100%" border="0">
	<tr bgcolor='#AAFAA2'>
		<td align="center" width="15%">Room Type</td>
		<td align="center" colspan="8">LOS</td>
	</tr>
	<tr>
		<td>Private</td>
		<%=arrayList2Table(procedure2, "P") %>
	</tr>
	<tr>
		<td>Semi-Private</td>
		<%=arrayList2Table(procedure2, "S") %>
	</tr>
	<tr>
		<td>Standard (3 Beds)</td>
		<%=arrayList2Table(procedure2, "T") %>
	</tr>
</table>