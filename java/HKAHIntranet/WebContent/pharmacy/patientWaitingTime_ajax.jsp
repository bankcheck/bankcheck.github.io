<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%!
	private ArrayList<ReportableListObject> fetchWaitingTime(String locid, String ticketNo) {
		return UtilDBWeb.getReportableList(
			"SELECT ROUND(TO_NUMBER(TO_CHAR((PH_EST_COMPLETED_DATE - PH_CREATED_DATE) * 1440, 'FM99999999999999990.0')) + 0.5, 0) FROM PH_TICKET_QUEUE WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_CREATED_DATE > SYSDATE - 1/12 AND PH_TICKET_DT IN (TO_CHAR(SYSDATE - 1, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'YYYYMMDD')) AND PH_TICKET_QUEUE_ID = ?",
			new String[] { locid, ticketNo });
	}
%><%
String locid = request.getParameter("locid");
if (locid == null || locid.length() == 0) {
	locid = "OW";
}
String ticketNo = request.getParameter("ticketNo");

if (ticketNo != null) {
	ArrayList<ReportableListObject> record = fetchWaitingTime(locid, ticketNo);
	ReportableListObject row = null;

	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		out.print(row.getValue(0));
	}
}
%>