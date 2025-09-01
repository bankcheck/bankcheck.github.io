<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>

<%
StringBuffer sqlStr = new StringBuffer();
String Type = request.getParameter("Type");
String Value = request.getParameter("Value");
String format = request.getParameter("format");
String selected = request.getParameter("selected");

if("Room".equals(Type)){
sqlStr.append("SELECT ROMCODE FROM ROOM WHERE WRDCODE = '"+Value+"' ORDER BY ROMCODE");
}else if ("Bed".equals(Type)){
sqlStr.append("SELECT BEDCODE FROM BED WHERE ROMCODE = '"+Value+"' AND BEDOFF = -1 ORDER BY BEDCODE");
}
ArrayList record = UtilDBWeb.getReportableListHATS(sqlStr.toString());

//System.out.println(sqlStr.toString());

if(format != null && format.length() > 0) {
	%><table><%
}

ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		if(format != null && format.length() > 0) {
			%><tr><td><input type="checkbox" name="blockBed" value="<%=row.getValue(0)%>"/><%=row.getValue(0)%></td></tr><%
		}
		else {
			%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(selected)?" selected":"" %>><%=row.getValue(0) %></option><%
		}
	}
}

if(format != null && format.length() > 0) {
	%></table><%
}
%>