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

	private boolean updateCancel(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_CANCELLED_DATE = SYSDATE, PH_STATUS = -1 WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_CREATED_DATE > SYSDATE - 1/12 AND PH_TICKET_DT IN (TO_CHAR(SYSDATE - 1, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'YYYYMMDD')) AND PH_TICKET_QUEUE_ID = ?",
			new String[] { locid, ticketNo });
	}

	private boolean updateDone(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_COMPLETED_DATE = SYSDATE, PH_STATUS = 0 WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_CREATED_DATE > SYSDATE - 1/12 AND PH_TICKET_DT IN (TO_CHAR(SYSDATE - 1, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'YYYYMMDD')) AND PH_TICKET_QUEUE_ID = ?",
			new String[] { locid, ticketNo });
	}

	private boolean updatePrescription(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_PRESCRIPTION_DATE = SYSDATE WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_CREATED_DATE > SYSDATE - 1/12 AND PH_TICKET_DT IN (TO_CHAR(SYSDATE - 1, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'YYYYMMDD')) AND PH_TICKET_QUEUE_ID = ? and PH_PRESCRIPTION_DATE IS NULL",
			new String[] { locid, ticketNo });
	}

	private boolean updateDispensing(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_DISPENSING_DATE = SYSDATE WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_CREATED_DATE > SYSDATE - 1/12 AND PH_TICKET_DT IN (TO_CHAR(SYSDATE - 1, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'YYYYMMDD')) AND PH_TICKET_QUEUE_ID = ? and PH_DISPENSING_DATE IS NULL",
			new String[] { locid, ticketNo });
	}

	private boolean updateCharged(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_CHARGED_DATE = SYSDATE WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_CREATED_DATE > SYSDATE - 1/12 AND PH_TICKET_DT IN (TO_CHAR(SYSDATE - 1, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'YYYYMMDD')) AND PH_TICKET_QUEUE_ID = ? and PH_CHARGED_DATE IS NULL",
			new String[] { locid, ticketNo });
	}

	private boolean updateCollection(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_COLLECTION_DATE = SYSDATE WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_CREATED_DATE > SYSDATE - 1/12 AND PH_TICKET_DT IN (TO_CHAR(SYSDATE - 1, 'YYYYMMDD'), TO_CHAR(SYSDATE, 'YYYYMMDD')) AND PH_TICKET_QUEUE_ID = ? and PH_CHARGED_DATE IS NOT NULL and PH_COLLECTION_DATE IS NULL",
			new String[] { locid, ticketNo });
	}
%><%
String locid = request.getParameter("locid");
if (locid == null || locid.length() == 0) {
	locid = "OW";
}
String queue = request.getParameter("queue");
String ticketNo = request.getParameter("ticketNo");
String patno = request.getParameter("patno");

if ("-1".equals(queue)) {
	out.println("update " + ticketNo + " for cancel [" + updateCancel(locid, ticketNo) + "]");
} else if ("0".equals(queue)) {
	out.println("update " + ticketNo + " for done [" + updateDone(locid, ticketNo) + "]");
} else if ("1".equals(queue)) {
	out.println("update " + ticketNo + " for prescription [" + updatePrescription(locid, ticketNo) + "]");
} else if ("2".equals(queue)) {
	out.println("update " + ticketNo + " for prescription [" + updatePrescription(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for dispensing [" + updateDispensing(locid, ticketNo) + "]");
} else if ("3".equals(queue)) {
	out.println("update " + ticketNo + " for prescription [" + updatePrescription(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for dispensing [" + updateDispensing(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for charged [" + updateCharged(locid, ticketNo) + "]");
} else if ("4".equals(queue)) {
//	out.println("update " + ticketNo + " for prescription [" + updatePrescription(locid, ticketNo) + "]");
//	out.println("update " + ticketNo + " for dispensing [" + updateDispensing(locid, ticketNo) + "]");
//	out.println("update " + ticketNo + " for charged [" + updateCharged(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for collection [" + updateCollection(locid, ticketNo) + "]");
} else  {
	ticketNo = fetchTicketNo(locid, patno);
	if (ticketNo != null) {
		out.print(ticketNo);
	}
}
%>