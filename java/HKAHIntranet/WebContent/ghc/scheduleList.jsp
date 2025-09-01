<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String[] dateTag = new String[] { "", "SUN", "MON", "TUE", "WED", "THUR", "FRI", "SAT" };
String doctorCode = request.getParameter("doctorCode");

StringBuffer sqlStr = new StringBuffer();
sqlStr.append("SELECT SH.TEMDAY, TO_CHAR(SH.TEMSTIME,'HH24:MI'), TO_CHAR(SH.TEMETIME,'HH24:MI') ");
sqlStr.append("FROM   DOCTOR@HAT DR, TEMPLATE@HAT SH ");
sqlStr.append("WHERE  DR.DOCCODE = SH.DOCCODE ");
sqlStr.append("AND    DR.DOCSTS = -1 ");
sqlStr.append("AND    DR.DOCCODE = ? ");
sqlStr.append("ORDER BY SH.TEMDAY, SH.TEMSTIME ");

ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] { doctorCode });
ReportableListObject row = null;
int temday_curr = -1;

if (record.size() > 0) {
	%><table><%
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		try {
			temday_curr = Integer.parseInt(row.getValue(0));
			if (temday_curr >=0 && temday_curr <= 7) {
				%><tr><td><%=dateTag[temday_curr] %></td><td><%=row.getValue(1) %></td><td>-</td><td><%=row.getValue(2) %></td></tr><%
			}
		} catch (Exception e) {}
	}
	%></table><%
} %>