<%@ page language="java" contentType="text/html; charset=utf-8" %><%@
page import="java.util.*"%><%@
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@
page import="com.hkah.web.db.*"%><%!
	private String fetchTicketNo(String locid, String patno) {
		return UtilDBWeb.callFunction("HAT_ACT_PHARMACYTICKETNO", "ADD", new String[] { locid, patno==null?"":patno, "" });
	}

	private String fetchLocID(String locPrefix) {
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList("SELECT PH_LOC_ID FROM PH_LOCATION WHERE PH_LOC_TYPE = 'I' AND PH_LOC_PREFIX = ?", new String[] { locPrefix });
		ReportableListObject row = null;
		if (record.size() == 1) {
			row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return "";
		}
	}

	private boolean updateCancel(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_CANCELLED_DATE = SYSDATE, PH_STATUS = -1 WHERE PH_LOC_ID = ? AND PH_STATUS != -1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ?",
			new String[] { locid, ticketNo });
	}

	private boolean updateDone(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_COMPLETED_DATE = SYSDATE, PH_STATUS = 0 WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ?",
			new String[] { locid, ticketNo });
	}

	private boolean updatePrescription(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_PRESCRIPTION_DATE = SYSDATE WHERE PH_LOC_ID = ? AND PH_STATUS != -1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ? and PH_PRESCRIPTION_DATE IS NULL",
			new String[] { locid, ticketNo });
	}

	private boolean updateDispensing(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_DISPENSING_DATE = SYSDATE WHERE PH_LOC_ID = ? AND PH_STATUS != -1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ? and PH_DISPENSING_DATE IS NULL",
			new String[] { locid, ticketNo });
	}

	private boolean updateCharged(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_CHARGED_DATE = SYSDATE WHERE PH_LOC_ID = ? AND PH_STATUS != -1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ? and PH_CHARGED_DATE IS NULL",
			new String[] { locid, ticketNo });
	}

	private boolean updateCollection(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_COLLECTION_DATE = SYSDATE WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ? and PH_COLLECTION_DATE IS NULL",
			new String[] { locid, ticketNo });
	}
%><%
String locid = request.getParameter("locid");
String queue = request.getParameter("queue");
String ticketNo = request.getParameter("ticketNo");
String patno = request.getParameter("patno");

if (locid == null || locid.length() == 0) {
	locid = fetchLocID(ticketNo.substring(0, 1));
}

if ("-1".equals(queue)) {
	out.println("update " + ticketNo + " for cancel [" + updateCancel(locid, ticketNo) + "]");
} else if ("0".equals(queue)) {
	out.println("update " + ticketNo + " for done [" + updateDone(locid, ticketNo) + "]");
} else if ("1".equals(queue)) {
	out.println("update " + ticketNo + " for fax received [" + updatePrescription(locid, ticketNo) + "]");
} else if ("2".equals(queue)) {
	out.println("update " + ticketNo + " for fax received [" + updatePrescription(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for pick up [" + updateDispensing(locid, ticketNo) + "]");
} else if ("3".equals(queue)) {
	out.println("update " + ticketNo + " for ack [" + updateCharged(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for done [" + updateDone(locid, ticketNo) + "]");
} else if ("4".equals(queue)) {
	out.println("update " + ticketNo + " for fax received [" + updatePrescription(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for pick up [" + updateDispensing(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for NA [" + updateCollection(locid, ticketNo) + "]");
//	out.println("update " + ticketNo + " for done [" + updateDone(locid, ticketNo) + "]");
} else  {
	ticketNo = fetchTicketNo(locid, patno);
	if (ticketNo != null) {
		out.print(ticketNo);
	}
}
%>