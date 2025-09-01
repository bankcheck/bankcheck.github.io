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
			"UPDATE PH_TICKET_QUEUE SET PH_CANCELLED_DATE = SYSDATE, PH_STATUS = -1 WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ?",
			new String[] { locid, ticketNo });
	}

	private boolean updateDone(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_COMPLETED_DATE = SYSDATE, PH_STATUS = 0 WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ?",
			new String[] { locid, ticketNo });
	}

	private boolean updatePrescription(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_PRESCRIPTION_DATE = SYSDATE WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ? and PH_PRESCRIPTION_DATE IS NULL",
			new String[] { locid, ticketNo });
	}

	private boolean updateDispensing(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_DISPENSING_DATE = SYSDATE WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ? and PH_DISPENSING_DATE IS NULL",
			new String[] { locid, ticketNo });
	}

	private boolean updateCharged(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_CHARGED_DATE = SYSDATE WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ? and PH_CHARGED_DATE IS NULL",
			new String[] { locid, ticketNo });
	}

	private boolean updateCollection(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_COLLECTION_DATE = SYSDATE WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ? and PH_COLLECTION_DATE IS NULL",
			new String[] { locid, ticketNo });
	}

	private boolean updateRemark(String locid, String ticketNo, String remark) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_REMARK = ? WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ?",
			new String[] { remark, locid, ticketNo });
	}

	private boolean resetPrescription(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_PRESCRIPTION_DATE = '', PH_DISPENSING_DATE = '', PH_CHARGED_DATE = '', PH_COLLECTION_DATE = '', PH_COMPLETED_DATE = '' WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ?",
			new String[] { locid, ticketNo });
	}

	private boolean resetDispensing(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_DISPENSING_DATE = '', PH_CHARGED_DATE = '', PH_COLLECTION_DATE = '', PH_COMPLETED_DATE = '' WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ?",
			new String[] { locid, ticketNo });
	}

	private boolean resetCharged(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_CHARGED_DATE = '', PH_COLLECTION_DATE = '', PH_COMPLETED_DATE = '' WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ?",
			new String[] { locid, ticketNo });
	}

	private boolean resetCollection(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_COLLECTION_DATE = '', PH_COMPLETED_DATE = '' WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ?",
			new String[] { locid, ticketNo });
	}

	private boolean isOnHoldStatus(String locid, String ticketNo) {
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList("SELECT 1 FROM PH_TICKET_QUEUE WHERE PH_LOC_ID = ? AND PH_STATUS = 999 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ?", new String[] { locid, ticketNo });
		ReportableListObject row = null;
		return (record.size() == 1);
	}

	private boolean setOnHoldStatus(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_STATUS = 999 WHERE PH_LOC_ID = ? AND PH_STATUS = 1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ?",
			new String[] { locid, ticketNo });
	}

	private boolean resetOnHoldStatus(String locid, String ticketNo) {
		return UtilDBWeb.updateQueue(
			"UPDATE PH_TICKET_QUEUE SET PH_STATUS = 1 WHERE PH_LOC_ID = ? AND PH_STATUS = 999 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ?",
			new String[] { locid, ticketNo });
	}

	private String getQueue(String locid, String ticketNo) {
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList("SELECT PH_PRESCRIPTION_DATE, PH_DISPENSING_DATE, PH_CHARGED_DATE, PH_COLLECTION_DATE, PH_COMPLETED_DATE, PH_STATUS FROM PH_TICKET_QUEUE WHERE PH_LOC_ID = ? AND PH_STATUS != -1 AND PH_TICKET_DT = TO_CHAR(SYSDATE, 'YYYYMMDD') AND PH_TICKET_QUEUE_ID = ?", new String[] { locid, ticketNo });
		ReportableListObject row = null;
		if (record.size() == 1) {
			row = (ReportableListObject) record.get(0);
			if (row.getValue(3).length() > 0) {
				return "4";
			} else if (row.getValue(2).length() > 0) {
				return "3";
			} else if (row.getValue(1).length() > 0) {
				return "2";
			} else if (row.getValue(0).length() > 0) {
				return "1";
			} else {
				return "0";
			}
		} else {
			return "";
		}
	}
%><%
String locid = request.getParameter("locid");
String queue = request.getParameter("queue");
String ticketNo = request.getParameter("ticketNo");
String patno = request.getParameter("patno");
String remark = request.getParameter("remark");
boolean isPBO = "Y".equals(request.getParameter("isPBO"));

if ((locid == null || locid.length() == 0) && ticketNo != null && ticketNo.length() > 0) {
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
	if (isPBO && isOnHoldStatus(locid, ticketNo)) {
		resetOnHoldStatus(locid, ticketNo);
	}
	out.println("update " + ticketNo + " for fax received [" + updatePrescription(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for pick up [" + updateDispensing(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for ack [" + updateCharged(locid, ticketNo) + "]");
} else if ("4".equals(queue)) {
	out.println("update " + ticketNo + " for fax received [" + updatePrescription(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for pick up [" + updateDispensing(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for ack [" + updateCharged(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for NA [" + updateCollection(locid, ticketNo) + "]");
	out.println("update " + ticketNo + " for done [" + updateDone(locid, ticketNo) + "]");
} else if ("Q".equals(queue)) {
	// check status
	out.print(getQueue(locid, ticketNo));
} else if ("Z1".equals(queue)) {
	resetPrescription(locid, ticketNo);
} else if ("Z2".equals(queue)) {
	if (isPBO) {
		if (isOnHoldStatus(locid, ticketNo)) {
			resetOnHoldStatus(locid, ticketNo);
		}
	} else {
		resetDispensing(locid, ticketNo);
	}
} else if ("Z3".equals(queue)) {
	resetCharged(locid, ticketNo);
} else if ("Z4".equals(queue)) {
	resetCollection(locid, ticketNo);
} else if ("H".equals(queue)) {
	if (isOnHoldStatus(locid, ticketNo)) {
		if (isPBO) {
			out.println("already start processing");
		} else {
			if (resetOnHoldStatus(locid, ticketNo)) {
				out.println("release on hold successful");
			} else {
				out.println("release on hold fail");
			}
		}
	} else {
		if (setOnHoldStatus(locid, ticketNo)) {
			if (isPBO) {
				out.println("start processing successful");
			} else {
				out.println("set on hold successful");
			}
		} else {
			if (isPBO) {
				out.println("fail to start processing");
			} else {
				out.println("set on hold fail");
			}
		}
	}
} else if ("M".equals(queue)) {
	if (updateRemark(locid, ticketNo, remark)) {
		out.println("set remark successful");
	} else {
		out.println("set remark fail");
	}
} else  {
	ticketNo = fetchTicketNo(locid, patno);
	if (ticketNo != null) {
		out.print(ticketNo);
	}
}
%>