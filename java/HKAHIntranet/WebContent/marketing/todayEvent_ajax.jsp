<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%!
	private ArrayList<ReportableListObject> fetchQueue() {
		return UtilDBWeb.getFunctionResults("GET_MKTEVENT",
//				new String[]{"22-10-2019","22-10-2019"});
				new String[]{"today","today"});
	}
%><%

int totalRecPerTable = 10;
String table = request.getParameter("table");
int tableInt = 0;
try {
	tableInt = Integer.parseInt(table);
} catch (Exception e) {}

ArrayList<ReportableListObject> record = fetchQueue();
ReportableListObject row = null;
int count = record.size();
int startcount = tableInt * totalRecPerTable;
int endcount = (tableInt + 1) * totalRecPerTable;
String eventDesc = null;
String eventTime = null; 
  if(record.size() > 0){
	if (count > startcount) { %>
		<tr><td width="50%" align="left" valign="top"><table width="100%">
	<%
		for (int i = startcount; i < count && i < endcount; i++) {
			row = (ReportableListObject) record.get(i);
			eventDesc = row.getValue(5)+" - "+row.getValue(3);
			eventTime = row.getValue(15);
	%>
		<tr>
		<td align="left" width="60%" height="100"><font face="arial" color="#AA0066"><p style="font-size:30px"><b><%=eventDesc %></b></p></font></td>
		<td align="left" width="40%" height="100"><font face="arial" color="#A9A9A9"><p style="font-size:25px"><b><%=eventTime %></b></p></font></td>
		</tr>
	
		<%}
		}%>
		</table></td></tr>
<%	}%>	