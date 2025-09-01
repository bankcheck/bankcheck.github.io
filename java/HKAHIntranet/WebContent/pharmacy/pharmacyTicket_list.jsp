<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList<ReportableListObject> fetchWard() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PH_LOC_ID, PH_LOC_DESC, PH_LOC_TYPE ");
		sqlStr.append("FROM   PH_LOCATION ");
		sqlStr.append("ORDER BY PH_LOC_TYPE, PH_LOC_ID ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList getReportList1(String[] locid, String ticketStartDate, String ticketEndDate, String ticketStartTime, String ticketEndTime, String ordering) {
		// fetch access_control
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')', ");
		sqlStr.append("       Q.PH_TICKET_QUEUE_ID, ");
		sqlStr.append("       TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy hh24:mi:ss'), ");
		sqlStr.append("       TO_CHAR((Q.PH_PRESCRIPTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((Q.PH_CHARGED_DATE - Q.PH_PRESCRIPTION_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((Q.PH_COLLECTION_DATE - Q.PH_CHARGED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((Q.PH_COMPLETED_DATE - Q.PH_COLLECTION_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((Q.PH_COLLECTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((Q.PH_COMPLETED_DATE - Q.PH_PRESCRIPTION_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       Q.PH_LOC_ID, L.PH_LOC_TYPE ");
		sqlStr.append("FROM   PH_TICKET_QUEUE Q INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID ");
		sqlStr.append("WHERE  Q.PH_CREATED_DATE >= TO_DATE(? || ' 00:00:00', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    Q.PH_CREATED_DATE <= TO_DATE(? || ' 23:59:59', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') >= ? ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') <= ? ");

		sqlStr.append("AND    Q.PH_LOC_ID IN (");
		for (int i = 0; i < locid.length; i++) {
			if (i > 0) {
				sqlStr.append(",");
			}
			sqlStr.append("'");
			sqlStr.append(locid[i]);
			sqlStr.append("'");
		}
		sqlStr.append(") ");

		if ("2".equals(ordering)) {
			sqlStr.append("ORDER BY L.PH_LOC_TYPE, L.PH_LOC_ID, Q.PH_TICKET_DT, Q.PH_TICKET_QUEUE_ID DESC");
		} else {
			sqlStr.append("ORDER BY L.PH_LOC_TYPE, L.PH_LOC_ID, Q.PH_TICKET_DT, Q.PH_TICKET_QUEUE_ID ASC");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime });
	}

	private ArrayList getReportList2(String[] locid, String ticketStartDate, String ticketEndDate, String ticketStartTime, String ticketEndTime, String ordering) {
		// fetch access_control
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')', Q.PH_TICKET_QUEUE_ID, TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy hh24:mi:ss'), ");
		sqlStr.append("       TO_CHAR(Q.PH_PRESCRIPTION_DATE, 'dd/MM/yyyy hh24:mi:ss'),  ");
		sqlStr.append("       TO_CHAR(Q.PH_CHARGED_DATE, 'dd/MM/yyyy hh24:mi:ss'),  ");
		sqlStr.append("       TO_CHAR(Q.PH_COLLECTION_DATE, 'dd/MM/yyyy hh24:mi:ss'),  ");
		sqlStr.append("       TO_CHAR(Q.PH_COMPLETED_DATE, 'dd/MM/yyyy hh24:mi:ss'),  ");
		sqlStr.append("       TO_CHAR((Q.PH_EST_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((Q.PH_COLLECTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       Q.PH_LOC_ID, L.PH_LOC_TYPE ");
		sqlStr.append("FROM   PH_TICKET_QUEUE Q INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID ");
		sqlStr.append("WHERE  Q.PH_CREATED_DATE >= TO_DATE(? || ' 00:00:00', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    Q.PH_CREATED_DATE <= TO_DATE(? || ' 23:59:59', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') >= ? ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') <= ? ");

		sqlStr.append("AND    Q.PH_LOC_ID IN (");
		for (int i = 0; i < locid.length; i++) {
			if (i > 0) {
				sqlStr.append(",");
			}
			sqlStr.append("'");
			sqlStr.append(locid[i]);
			sqlStr.append("'");
		}
		sqlStr.append(") ");

		if ("2".equals(ordering)) {
			sqlStr.append("ORDER BY L.PH_LOC_TYPE, L.PH_LOC_ID, Q.PH_TICKET_DT, Q.PH_TICKET_QUEUE_ID DESC");
		} else {
			sqlStr.append("ORDER BY L.PH_LOC_TYPE, L.PH_LOC_ID, Q.PH_TICKET_DT, Q.PH_TICKET_QUEUE_ID ASC");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime });
	}

	private ArrayList getReportList3(String[] locid, String ticketStartDate, String ticketEndDate, String ticketStartTime, String ticketEndTime, String ordering) {
		// fetch access_control
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')', TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy'), ");
		sqlStr.append("       COUNT(1), ");
		sqlStr.append("       TO_CHAR(MAX(Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR(MIN(Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR(AVG(Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR((SUM(CASE WHEN Q.PH_COLLECTION_DATE < Q.PH_EST_COMPLETED_DATE THEN 1 ELSE 0 END) / COUNT(1) * 100), 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR(PERCENTILE_DISC(0.25) WITHIN GROUP (ORDER BY Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), ");
		sqlStr.append("       TO_CHAR(PERCENTILE_DISC(0.95) WITHIN GROUP (ORDER BY Q.PH_COMPLETED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0') ");
		sqlStr.append("FROM   PH_TICKET_QUEUE Q INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID ");
		sqlStr.append("WHERE  Q.PH_CREATED_DATE >= TO_DATE(? || ' 00:00:00', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    Q.PH_CREATED_DATE <= TO_DATE(? || ' 23:59:59', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') >= ? ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') <= ? ");

		sqlStr.append("AND    Q.PH_LOC_ID IN (");
		for (int i = 0; i < locid.length; i++) {
			if (i > 0) {
				sqlStr.append(",");
			}
			sqlStr.append("'");
			sqlStr.append(locid[i]);
			sqlStr.append("'");
		}
		sqlStr.append(") ");

		sqlStr.append("GROUP BY L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')', Q.PH_TICKET_DT, TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy') ");
		sqlStr.append("ORDER BY L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')', Q.PH_TICKET_DT, TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy') ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime });
	}

	private ArrayList getReportList4(String[] locid, String ticketStartDate, String ticketEndDate, String ticketStartTime, String ticketEndTime, String ordering) {
		// fetch access_control
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')', "); // 0
		sqlStr.append("       Q.PH_TICKET_QUEUE_ID, "); // 1
		sqlStr.append("       TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy hh24:mi:ss'), "); // 2
		sqlStr.append("       TO_CHAR(Q.PH_PRESCRIPTION_DATE, 'dd/MM/yyyy hh24:mi:ss'),  "); // 3
		sqlStr.append("       TO_CHAR(Q.PH_DISPENSING_DATE, 'dd/MM/yyyy hh24:mi:ss'),  "); // 4
		sqlStr.append("       TO_CHAR(Q.PH_CHARGED_DATE, 'dd/MM/yyyy hh24:mi:ss'),  "); // 5
		sqlStr.append("       TO_CHAR((Q.PH_CHARGED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 6
		sqlStr.append("       TO_CHAR((Q.PH_DISPENSING_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 7
		sqlStr.append("       TO_CHAR((Q.PH_DISPENSING_DATE - Q.PH_PRESCRIPTION_DATE) * 1440, 'FM99999999999999990.0'),  "); // 8
		sqlStr.append("       TO_CHAR((Q.PH_PRESCRIPTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 9
		sqlStr.append("       Q.PH_LOC_ID, L.PH_LOC_TYPE, Q.PH_PATNO, "); // 10, 11, 12
		sqlStr.append("       TO_CHAR(Q.PH_COLLECTION_DATE, 'dd/MM/yyyy hh24:mi:ss'),  "); // 13
		sqlStr.append("       TO_CHAR((Q.PH_COLLECTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 14
		sqlStr.append("       Q.PH_REMARK "); // 15
		sqlStr.append("FROM   PH_TICKET_QUEUE Q INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID ");
		sqlStr.append("WHERE  Q.PH_CREATED_DATE >= TO_DATE(? || ' 00:00:00', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    Q.PH_CREATED_DATE <= TO_DATE(? || ' 23:59:59', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') >= ? ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') <= ? ");

		sqlStr.append("AND    Q.PH_LOC_ID IN (");
		for (int i = 0; i < locid.length; i++) {
			if (i > 0) {
				sqlStr.append(",");
			}
			sqlStr.append("'");
			sqlStr.append(locid[i]);
			sqlStr.append("'");
		}
		sqlStr.append(") ");

		if ("2".equals(ordering)) {
			sqlStr.append("ORDER BY L.PH_LOC_TYPE, L.PH_LOC_ID, Q.PH_TICKET_DT, Q.PH_TICKET_QUEUE_ID DESC");
		} else {
			sqlStr.append("ORDER BY L.PH_LOC_TYPE, L.PH_LOC_ID, Q.PH_TICKET_DT, Q.PH_TICKET_QUEUE_ID ASC");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime });
	}

	private ArrayList getReportList5(String[] locid, String ticketStartDate, String ticketEndDate, String ticketStartTime, String ticketEndTime, boolean isAllward, boolean isDateConsolidate, String ordering) {
		// fetch access_control
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		if (isAllward) {
			sqlStr.append("       'All IP', ");
		} else {
			sqlStr.append("       L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')', ");
		}
		if (isDateConsolidate) {
			sqlStr.append("       '");
			sqlStr.append(ticketStartDate);
			sqlStr.append(" ");
			sqlStr.append(ticketStartTime);
			sqlStr.append(" - ");
			sqlStr.append(ticketEndDate);
			sqlStr.append(" ");
			sqlStr.append(ticketEndTime);
			sqlStr.append("', ");
		} else {
			sqlStr.append("       TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy'), ");
		}
		sqlStr.append("       COUNT(1), "); // 2
		sqlStr.append("       TO_CHAR(MAX(Q.PH_CHARGED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 3
		sqlStr.append("       TO_CHAR(MIN(Q.PH_CHARGED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 4
		sqlStr.append("       TO_CHAR(AVG(Q.PH_CHARGED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 5
		sqlStr.append("       TO_CHAR(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY Q.PH_CHARGED_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 6
		sqlStr.append("       TO_CHAR(MAX(Q.PH_DISPENSING_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 7
		sqlStr.append("       TO_CHAR(MIN(Q.PH_DISPENSING_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 8
		sqlStr.append("       TO_CHAR(AVG(Q.PH_DISPENSING_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 9
		sqlStr.append("       TO_CHAR(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY Q.PH_DISPENSING_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 10
		sqlStr.append("       TO_CHAR(MAX(Q.PH_DISPENSING_DATE - Q.PH_PRESCRIPTION_DATE) * 1440, 'FM99999999999999990.0'), "); // 11
		sqlStr.append("       TO_CHAR(MIN(Q.PH_DISPENSING_DATE - Q.PH_PRESCRIPTION_DATE) * 1440, 'FM99999999999999990.0'), "); // 12
		sqlStr.append("       TO_CHAR(AVG(Q.PH_DISPENSING_DATE - Q.PH_PRESCRIPTION_DATE) * 1440, 'FM99999999999999990.0'), "); // 13
		sqlStr.append("       TO_CHAR(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY Q.PH_DISPENSING_DATE - Q.PH_PRESCRIPTION_DATE) * 1440, 'FM99999999999999990.0'), "); // 14
		sqlStr.append("       TO_CHAR(MAX(Q.PH_PRESCRIPTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 15
		sqlStr.append("       TO_CHAR(MIN(Q.PH_PRESCRIPTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 16
		sqlStr.append("       TO_CHAR(AVG(Q.PH_PRESCRIPTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 17
		sqlStr.append("       TO_CHAR(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY Q.PH_PRESCRIPTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 18
		sqlStr.append("       TO_CHAR(MAX(Q.PH_COLLECTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 19
		sqlStr.append("       TO_CHAR(MIN(Q.PH_COLLECTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 20
		sqlStr.append("       TO_CHAR(AVG(Q.PH_COLLECTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0'), "); // 21
		sqlStr.append("       TO_CHAR(PERCENTILE_DISC(0.75) WITHIN GROUP (ORDER BY Q.PH_COLLECTION_DATE - Q.PH_CREATED_DATE) * 1440, 'FM99999999999999990.0') "); // 22
		sqlStr.append("FROM   PH_TICKET_QUEUE Q INNER JOIN PH_LOCATION L ON Q.PH_LOC_ID = L.PH_LOC_ID ");
		sqlStr.append("WHERE  Q.PH_CREATED_DATE >= TO_DATE(? || ' 00:00:00', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    Q.PH_CREATED_DATE <= TO_DATE(? || ' 23:59:59', 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') >= ? ");
		sqlStr.append("AND    TO_CHAR(Q.PH_CREATED_DATE, 'hh24:mi') <= ? ");

		sqlStr.append("AND    Q.PH_LOC_ID IN (");
		for (int i = 0; i < locid.length; i++) {
			if (i > 0) {
				sqlStr.append(",");
			}
			sqlStr.append("'");
			sqlStr.append(locid[i]);
			sqlStr.append("'");
		}
		sqlStr.append(") ");


		if (!isAllward || !isDateConsolidate) {
			sqlStr.append("GROUP BY ");
		}
		if (!isAllward) {
			sqlStr.append("L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')' ");
		}
		if (!isAllward && !isDateConsolidate) {
			sqlStr.append(", ");
		}
		if (!isDateConsolidate) {
			sqlStr.append("Q.PH_TICKET_DT, TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy') ");
		}

		if (!isAllward || !isDateConsolidate) {
			sqlStr.append("ORDER BY ");
		}
		if (!isAllward) {
			sqlStr.append("L.PH_LOC_DESC || ' (' || DECODE(L.PH_LOC_TYPE, 'I', 'IP', 'OP') || ')' ");
		}
		if (!isAllward && !isDateConsolidate) {
			sqlStr.append(", ");
		}
		if (!isDateConsolidate) {
			sqlStr.append("Q.PH_TICKET_DT, TO_CHAR(Q.PH_CREATED_DATE, 'dd/MM/yyyy') ");
		}

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime });
	}
%>
<%
UserBean userBean = new UserBean(request);
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}

TreeMap<String, String> allIPWard = new TreeMap<String, String>();
TreeMap<String, String> allOPWard = new TreeMap<String, String>();
ArrayList<ReportableListObject> record = fetchWard();
ReportableListObject row2 = null;
for (int i = 0; i < record.size(); i++) {
	row2 = (ReportableListObject) record.get(i);
	if ("I".equals(row2.getValue(2))) {
		allIPWard.put(row2.getValue(0), row2.getValue(1));
	} else if ("O".equals(row2.getValue(2))) {
		allOPWard.put(row2.getValue(0), row2.getValue(1));
	}
}

boolean isIP = false;
boolean isOP = false;
String[] locid = request.getParameterValues("locid");
HashSet locidSet = new HashSet();
if (locid != null && locid.length > 0) {
	for (int i = 0; i < locid.length; i++) {
		locidSet.add(locid[i]);
		if (allIPWard.containsKey(locid[i])) {
			isIP = true;
		} else if (allOPWard.containsKey(locid[i])) {
			isOP = true;
		}
	}
}
String ticketStartDate = request.getParameter("ticketStartDate");
String ticketEndDate = request.getParameter("ticketEndDate");
String ticketStartTime = "00:00";
String ticketStartTime_hh = request.getParameter("ticketStartTime_hh");
String ticketStartTime_mi = request.getParameter("ticketStartTime_mi");
if (ticketStartTime_hh != null && ticketStartTime_mi != null) {
	ticketStartTime = ticketStartTime_hh + ":" + ticketStartTime_mi;
}
String ticketEndTime = "23:59";
String ticketEndTime_hh = request.getParameter("ticketEndTime_hh");
String ticketEndTime_mi = request.getParameter("ticketEndTime_mi");
if (ticketEndTime_hh != null && ticketEndTime_mi != null) {
	ticketEndTime = ticketEndTime_hh + ":" + ticketEndTime_mi;
}

String reportType = request.getParameter("reportType");
if (reportType == null) {
	reportType = "1";
}
String ordering = request.getParameter("ordering");
boolean isAllward = "Y".equals(request.getParameter("allward"));
boolean isDateConsolidate = "Y".equals(request.getParameter("dateConsolidate"));

// default search current delivery date
if (ticketStartDate == null || ticketStartDate.length() == 0) {
	ticketStartDate = "01" + DateTimeUtil.getCurrentDate().substring(2);
}
if (ticketEndDate == null || ticketEndDate.length() == 0) {
	ticketEndDate = DateTimeUtil.getCurrentDate();
}

if (locid != null && locid.length > 0) {
	if ("1".equals(reportType)) {
		request.setAttribute("pharmacyTicket_list", getReportList1(locid, ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime, ordering));
	} else if ("2".equals(reportType)) {
		request.setAttribute("pharmacyTicket_list", getReportList2(locid, ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime, ordering));
	} else if ("3".equals(reportType)) {
		request.setAttribute("pharmacyTicket_list", getReportList3(locid, ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime, ordering));
	} else if ("4".equals(reportType) || "6".equals(reportType)) {
		request.setAttribute("pharmacyTicket_list", getReportList4(locid, ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime, ordering));
	} else if ("5".equals(reportType) || "7".equals(reportType)) {
		request.setAttribute("pharmacyTicket_list", getReportList5(locid, ticketStartDate, ticketEndDate, ticketStartTime, ticketEndTime, isAllward, isDateConsolidate, ordering));
	}
} else {
	errorMessage = "No ward is selected.";
}
%><!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/fn.tld" prefix="fn" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Pharmacy Ticket Report" />
	<jsp:param name="category" value="prompt.admin" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" method="get" onsubmit="return submitSearch();" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Report</td>
		<td class="infoData" width="70%">
			<select name="reportType" id="reportType" onchange="return changeReportType(this);">
				<option value="1"<%if ("1".equals(reportType)) {%> selected<%} %>>Report 1 (OP)</option>
				<option value="2"<%if ("2".equals(reportType)) {%> selected<%} %>>Report 2 (OP)</option>
				<option value="3"<%if ("3".equals(reportType)) {%> selected<%} %>>Report 3 (OP)</option>
				<option value="4"<%if ("4".equals(reportType)) {%> selected<%} %>>Report 4 (IP)</option>
				<option value="5"<%if ("5".equals(reportType)) {%> selected<%} %>>Report 5 (IP)</option>
				<option value="6"<%if ("6".equals(reportType)) {%> selected<%} %>>Report 6 (Discharge)</option>
				<option value="7"<%if ("7".equals(reportType)) {%> selected<%} %>>Report 7 (Discharge)</option>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Location</td>
		<td class="infoData" width="70%">
			<span id="location_option">
			<table>
<%if ("1".equals(reportType) || "2".equals(reportType) || "3".equals(reportType)) { %>
			<tr>
				<td colspan="2"><button onclick="return setAllOPWard();">Select All OP Ward</button><button onclick="return unsetAllOPWard();">Unselect All OP Ward</button>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
<%	for(Map.Entry<String, String> entry : allOPWard.entrySet()) { %>
					<input type="checkbox" name="locid" value="<%=entry.getKey() %>"<%if (locidSet.size() == 0 || locidSet.contains(entry.getKey())) {%> checked<%} %>><%=entry.getValue() %><br>
<%	} %>
				</td>
			</tr>
<%} else if ("4".equals(reportType) || "5".equals(reportType)) { %>
			<tr>
				<td colspan="2"><button onclick="return setAllIPWard();">Select All IP Ward</button><button onclick="return unsetAllIPWard();">Unselect All IP Ward</button>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
<%	for(Map.Entry<String, String> entry : allIPWard.entrySet()) { %>
					<input type="checkbox" name="locid" value="<%=entry.getKey() %>"<%if (locidSet.size() == 0 || locidSet.contains(entry.getKey())) {%> checked<%} %>><%=entry.getValue() %><br>
<%	} %>
				</td>
			</tr>
<%} else if ("6".equals(reportType) || "7".equals(reportType)) { %>
			<tr>
				<input type="checkbox" name="locid" value="DIS" checked>Discharge<br>
			</tr>

<%} %>
			</table>
			</span>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Date Period</td>
		<td class="infoData" width="70%">
			<input type="text" name="ticketStartDate" id="ticketStartDate" class="datepickerfield" value="<%=ticketStartDate == null ? "" : ticketStartDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
			-
			<input type="text" name="ticketEndDate" id="ticketEndDate" class="datepickerfield" value="<%=ticketEndDate == null ? "" : ticketEndDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /><br>
			(DD/MM/YYYY) - (DD/MM/YYYY)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Time Period</td>
		<td class="infoData" width="70%">
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="ticketStartTime" />
	<jsp:param name="time" value="<%=ticketStartTime %>" />
	<jsp:param name="interval" value="1" />
</jsp:include>
			-
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="ticketEndTime" />
	<jsp:param name="time" value="<%=ticketEndTime %>" />
	<jsp:param name="interval" value="1" />
</jsp:include>&nbsp;&nbsp;&nbsp;<button onclick="return setAllDay();">All Day</button>
		</td>
	</tr>
</table>
<span id="report5_option">
<%if ("5".equals(reportType)) { %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Consolidate Wards</td>
		<td class="infoData" width="70%">
			<select name="allward">
				<option value="Y"<%if (isAllward) {%> selected<%} %>>Yes</option>
				<option value="N"<%if (!isAllward) {%> selected<%} %>>No</option>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Consolidate Date</td>
		<td class="infoData" width="70%">
			<select name="dateConsolidate">
				<option value="Y"<%if (isDateConsolidate) {%> selected<%} %>>Yes</option>
				<option value="N"<%if (!isDateConsolidate) {%> selected<%} %>>No</option>
			</select>
		</td>
	</tr>
</table>
<%} %>
</span>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td colspan="2" align="center">
			<button type="submit"><bean:message key="button.search" /></button>
			<button type="reset"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>

<span id="report_result">
<%if (locid != null && locid.length > 0) { %>
<bean:define id="functionLabel">Pharmacy Ticket</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<%	if ("1".equals(reportType)) { %>
<display:table id="row" name="requestScope.pharmacyTicket_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Location" style="width:8%" />
	<display:column title="Ticket No." style="width:5%">
		<logic:equal name="row" property="fields12" value="O">
			<c:out value="${row.fields1}" />
		</logic:equal>
		<logic:equal name="row" property="fields12" value="I">
			<c:set var="string" value="${row.fields1}"/>
			<c:out value="${row.fields11}" />-<c:out value="${fn:substring(string, 4, 10)}"/>
		</logic:equal>
	</display:column>
	<display:column property="fields2" title="Start Time" style="width:8%" />
	<display:column title="Start to Point 1 Time (mins)" style="width:8%">
		<logic:equal name="row" property="fields3" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields3" value="">
			<c:out value="${row.fields3}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Scan Point 1 to 2 Time (mins)" style="width:8%">
		<logic:equal name="row" property="fields4" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields4" value="">
			<c:out value="${row.fields4}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Scan Point 2 to 3 Time (mins)" style="width:8%">
		<logic:equal name="row" property="fields5" value="">
				--
		</logic:equal>
		<logic:notEqual name="row" property="fields4" value="">
			<c:out value="${row.fields5}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Scan Point 3 to Completed Time (mins)" style="width:8%">
		<logic:equal name="row" property="fields6" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields6" value="">
			<c:out value="${row.fields6}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Estimated Waiting Time (mins)" style="width:8%">
		<logic:equal name="row" property="fields7" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields7" value="">
			<c:out value="${row.fields7}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Real Waiting Time (mins)" style="width:8%">
		<logic:equal name="row" property="fields8" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields8" value="">
			<c:out value="${row.fields8}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Total Used Time (Up to Scan Point 3) (mins)" style="width:8%">
		<logic:equal name="row" property="fields9" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields9" value="">
			<c:out value="${row.fields9}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Total Used Time (mins)" style="width:8%">
		<logic:equal name="row" property="fields10" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields10" value="">
			<c:out value="${row.fields10}" />
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	} else if ("2".equals(reportType)) { %>
<display:table id="row" name="requestScope.pharmacyTicket_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Location" style="width:8%" />
	<display:column title="Ticket No." style="width:8%">
		<logic:equal name="row" property="fields11" value="O">
			<c:out value="${row.fields1}" />
		</logic:equal>
		<logic:equal name="row" property="fields11" value="I">
			<c:set var="string" value="${row.fields1}"/>
			<c:out value="${row.fields10}" />-<c:out value="${fn:substring(string, 4, 10)}"/>
		</logic:equal>
	</display:column>
	<display:column property="fields2" title="Start Time" style="width:8%" />
	<display:column title="Scan Point 1 Time" style="width:8%">
		<logic:equal name="row" property="fields3" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields3" value="">
			<c:out value="${row.fields3}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Scan Point 2 Time" style="width:8%">
		<logic:equal name="row" property="fields4" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields4" value="">
			<c:out value="${row.fields4}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Scan Point 3 Time" style="width:8%">
		<logic:equal name="row" property="fields5" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields5" value="">
			<c:out value="${row.fields5}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Completed Time" style="width:8%">
		<logic:equal name="row" property="fields6" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields6" value="">
			<c:out value="${row.fields6}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Estimated Waiting Time (mins)" style="width:8%">
		<logic:equal name="row" property="fields7" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields7" value="">
			<c:out value="${row.fields7}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Real Waiting Time (mins)" style="width:8%">
		<logic:equal name="row" property="fields8" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields8" value="">
			<c:out value="${row.fields8}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Total Used Time (mins)" style="width:8%">
		<logic:equal name="row" property="fields9" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields9" value="">
			<c:out value="${row.fields9}" />
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	} else if ("3".equals(reportType)) { %>
<display:table id="row" name="requestScope.pharmacyTicket_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Location" style="width:8%" />
	<display:column property="fields1" title="Date" style="width:8%" />
	<display:column property="fields2" title="Total No. of Tkt" style="width:8%">
		<logic:equal name="row" property="fields2" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields2" value="">
			<c:out value="${row.fields2}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Max (mins)" style="width:8%">
		<logic:equal name="row" property="fields3" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields3" value="">
			<c:out value="${row.fields3}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Min (mins)" style="width:8%">
		<logic:equal name="row" property="fields4" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields4" value="">
			<c:out value="${row.fields4}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Mean (mins)" style="width:8%">
		<logic:equal name="row" property="fields5" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields5" value="">
			<c:out value="${row.fields5}" />
		</logic:notEqual>
	</display:column>
	<display:column title="% within estimated time" style="width:8%">
		<logic:equal name="row" property="fields6" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields6" value="">
			<c:out value="${row.fields6}" />
		</logic:notEqual>
	</display:column>
	<display:column title="25th Percentile (mins)" style="width:8%">
		<logic:equal name="row" property="fields7" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields7" value="">
			<c:out value="${row.fields7}" />
		</logic:notEqual>
	</display:column>
	<display:column title="75th Percentile (mins)" style="width:8%">
		<logic:equal name="row" property="fields8" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields8" value="">
			<c:out value="${row.fields8}" />
		</logic:notEqual>
	</display:column>
	<display:column title="95th Percentile (mins)" style="width:8%">
		<logic:equal name="row" property="fields9" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields9" value="">
			<c:out value="${row.fields9}" />
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	} else if ("4".equals(reportType)) { %>
<display:table id="row" name="requestScope.pharmacyTicket_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Location" style="width:8%" />
	<display:column title="Tkt No." style="width:8%">
		<logic:equal name="row" property="fields11" value="O">
			<c:out value="${row.fields1}" />
		</logic:equal>
		<logic:equal name="row" property="fields11" value="I">
			<c:set var="string" value="${row.fields1}"/>
			<c:out value="${row.fields10}" />-<c:out value="${fn:substring(string, 4, 10)}"/>
		</logic:equal>
	</display:column>
	<display:column property="fields2" title="Generation Time (Date & Time=T1)" style="width:8%" />
	<display:column title="Fax Received
(Date & Time=T2)" style="width:8%">
		<logic:equal name="row" property="fields3" value="">
				--
		</logic:equal>
		<logic:notEqual name="row" property="fields3" value="">
			<c:out value="${row.fields3}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Ready for Pickup /N/A (Date & Time=T3)" style="width:8%">
		<logic:equal name="row" property="fields4" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields4" value="">
			<c:out value="${row.fields4}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Nurse Acknowledged (Date & Time=T4)" style="width:8%">
		<logic:equal name="row" property="fields5" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields5" value="">
			<c:out value="${row.fields5}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Order Completion Time (T5= T4-T1: in mins)" style="width:8%">
		<logic:equal name="row" property="fields6" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields6" value="">
			<c:out value="${row.fields6}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Med Ready Time:(T6=T3-T1: in mins)" style="width:8%">
		<logic:equal name="row" property="fields7" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields7" value="">
			<c:out value="${row.fields7}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Pharmacy Processing Time (T7=T3-T2: in mins)" style="width:8%">
		<logic:equal name="row" property="fields8" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields8" value="">
			<c:out value="${row.fields8}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Fax Receiving Time (T8=T2-T1 in mins)" style="width:8%">
		<logic:equal name="row" property="fields9" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields8" value="">
			<c:out value="${row.fields9}" />
		</logic:notEqual>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	} else if ("5".equals(reportType)) { %>
<display:table id="row" name="requestScope.pharmacyTicket_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Location" style="width:8%" />
	<display:column property="fields1" title="Date" style="width:8%" />
	<display:column property="fields2" title="No. of Tkt" style="width:8%" />
	<display:column title="Max T (in min) (Tkt. No) (Date) T5" style="width:8%">
		<logic:equal name="row" property="fields3" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields3" value="">
			<c:out value="${row.fields3}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Min T (in min) (Tkt. No) (Date) T5" style="width:8%">
		<logic:equal name="row" property="fields4" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields4" value="">
			<c:out value="${row.fields4}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Avg T (in min) T5" style="width:8%">
		<logic:equal name="row" property="fields5" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields5" value="">
			<c:out value="${row.fields5}" />
		</logic:notEqual>
	</display:column>
	<display:column title="75 Percentile (in min) T5" style="width:8%">
		<logic:equal name="row" property="fields6" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields6" value="">
			<c:out value="${row.fields6}" />
		</logic:notEqual>
	</display:column>
	<display:column property="fields7" title="Max T (in min) (Tkt. No) (Date) T6" style="width:8%" />
	<display:column property="fields8" title="Min T (in min) (Tkt. No) (Date) T6" style="width:8%" />
	<display:column property="fields9" title="Avg T (in min) T6" style="width:8%" />
	<display:column property="fields10" title="75 Percentile (in min) T6" style="width:8%" />
	<display:column property="fields11" title="Max T (in min) (Tkt. No) (Date) T7" style="width:8%" />
	<display:column property="fields12" title="Min T (in min) (Tkt. No) (Date) T7" style="width:8%" />
	<display:column property="fields13" title="Avg T (in min) T7" style="width:8%" />
	<display:column property="fields14" title="75 Percentile (in min) T7" style="width:8%" />
	<display:column property="fields15" title="Max T (in min) (Tkt. No) (Date) T8" style="width:8%" />
	<display:column property="fields16" title="Min T (in min) (Tkt. No) (Date) T8" style="width:8%" />
	<display:column property="fields17" title="Avg T (in min) T8" style="width:8%" />
	<display:column property="fields18" title="75 Percentile (in min) T8" style="width:8%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	} else if ("6".equals(reportType)) { %>
<display:table id="row" name="requestScope.pharmacyTicket_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Location" style="width:8%" />
	<display:column title="Tkt No." style="width:8%">
		<c:set var="string" value="${row.fields1}"/>
		<c:out value="${row.fields10}" />-<c:out value="${fn:substring(string, 4, 10)}"/>
	</display:column>
	<display:column property="fields12" title="Patient No." style="width:8%" />
	<display:column property="fields2" title="Generation Time (Date & Time=T1)" style="width:8%" />
	<display:column title="Start Processing (Date & Time=T2)" style="width:8%">
		<logic:equal name="row" property="fields3" value="">
				--
		</logic:equal>
		<logic:notEqual name="row" property="fields3" value="">
			<c:out value="${row.fields3}" />
		</logic:notEqual>
	</display:column>
	<display:column title="To PBO (Date & Time=T3)" style="width:8%">
		<logic:equal name="row" property="fields4" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields4" value="">
			<c:out value="${row.fields4}" />
		</logic:notEqual>
	</display:column>
	<display:column title="PBO To Pharmacy (Date & Time=T4)" style="width:8%">
		<logic:equal name="row" property="fields5" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields5" value="">
			<c:out value="${row.fields5}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Patient Picked Up (Date & Time=T5)" style="width:8%">
		<logic:equal name="row" property="fields13" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields13" value="">
			<c:out value="${row.fields13}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Order Completion Time (T6=T5-T1: in mins)" style="width:8%">
		<logic:equal name="row" property="fields14" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields14" value="">
			<c:out value="${row.fields14}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Med Ready Time:(T7=T3-T1: in mins)" style="width:8%">
		<logic:equal name="row" property="fields7" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields7" value="">
			<c:out value="${row.fields7}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Pharmacy Processing Time (T8=T3-T2: in mins)" style="width:8%">
		<logic:equal name="row" property="fields8" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields8" value="">
			<c:out value="${row.fields8}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Fax Receiving Time (T9=T2-T1 in mins)" style="width:8%">
		<logic:equal name="row" property="fields9" value="">
			--
		</logic:equal>
		<logic:notEqual name="row" property="fields8" value="">
			<c:out value="${row.fields9}" />
		</logic:notEqual>
	</display:column>
	<display:column property="fields15" title="Remarks" style="width:8%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	} else if ("7".equals(reportType)) { %>
<display:table id="row" name="requestScope.pharmacyTicket_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Location" style="width:5%" />
	<display:column property="fields1" title="Date" style="width:5%" />
	<display:column property="fields2" title="No. of Tkt" style="width:5%" />
	<display:column title="Max T (in min) (Tkt. No) (Date) T5" style="width:5%">
		<logic:equal name="row" property="fields19" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields19" value="">
			<c:out value="${row.fields19}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Min T (in min) (Tkt. No) (Date) T5" style="width:5%">
		<logic:equal name="row" property="fields20" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields20" value="">
			<c:out value="${row.fields20}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Avg T (in min) T5" style="width:5%">
		<logic:equal name="row" property="fields21" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields21" value="">
			<c:out value="${row.fields21}" />
		</logic:notEqual>
	</display:column>
	<display:column title="75 Percentile (in min) T5" style="width:5%">
		<logic:equal name="row" property="fields22" value="">
			0.0
		</logic:equal>
		<logic:notEqual name="row" property="fields22" value="">
			<c:out value="${row.fields22}" />
		</logic:notEqual>
	</display:column>
	<display:column property="fields7" title="Max T (in min) (Tkt. No) (Date) T6" style="width:5%" />
	<display:column property="fields8" title="Min T (in min) (Tkt. No) (Date) T6" style="width:5%" />
	<display:column property="fields9" title="Avg T (in min) T6" style="width:5%" />
	<display:column property="fields10" title="75 Percentile (in min) T6" style="width:5%" />
	<display:column property="fields11" title="Max T (in min) (Tkt. No) (Date) T7" style="width:5%" />
	<display:column property="fields12" title="Min T (in min) (Tkt. No) (Date) T7" style="width:5%" />
	<display:column property="fields13" title="Avg T (in min) T7" style="width:5%" />
	<display:column property="fields14" title="75 Percentile (in min) T7" style="width:5%" />
	<display:column property="fields15" title="Max T (in min) (Tkt. No) (Date) T8" style="width:5%" />
	<display:column property="fields16" title="Min T (in min) (Tkt. No) (Date) T8" style="width:5%" />
	<display:column property="fields17" title="Avg T (in min) T8" style="width:5%" />
	<display:column property="fields18" title="75 Percentile (in min) T8" style="width:5%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	}%>
<%}%>
</span>

<script language="javascript">
	function submitSearch() {
		var checkboxes = document.getElementsByName('locid');
		var count = 0;
		for (var j = 0; j < checkboxes.length; j++) {
			if (checkboxes[j].checked) {
				count++;
			}
		}
		if (count == 0) {
			alert('No ward is selected.');
			return false;
		}
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.ticketStartDate.value = "<%=ticketStartDate %>";
		document.search_form.ticketEndDate.value = "<%=ticketEndDate %>";
		unsetAllWard('IP');
		unsetAllWard('OP');
		return setAllDay();
	}

	function setAllDay() {
		document.search_form.ticketStartTime_hh.selectedIndex = "0";
		document.search_form.ticketStartTime_mi.selectedIndex = "0";
		document.search_form.ticketEndTime_hh.selectedIndex = "23";
		document.search_form.ticketEndTime_mi.selectedIndex = "59";
		return false;
	}

	function setAllIPWard() {
		setAllWard('IP');
		return false;
	}

	function setAllOPWard() {
		setAllWard('OP');
		return false;
	}

	function setAllWard(type) {
		var array_ip = [<%for(Map.Entry<String, String> entry : allIPWard.entrySet()) { %>'<%=entry.getKey() %>',<%} %>];
		var array_op = [<%for(Map.Entry<String, String> entry : allOPWard.entrySet()) { %>'<%=entry.getKey() %>',<%} %>];
		var checkboxes = document.getElementsByName('locid');
		for (var j = 0; j < checkboxes.length; j++) {
			checkboxes[j].checked = false;
			if (type == 'IP') {
				for (var i = 0; i < array_ip.length; i++) {
					if (checkboxes[j].value == array_ip[i]) {
						checkboxes[j].checked = true;
					}
				}
			} else {
				for (var i = 0; i < array_op.length; i++) {
					if (checkboxes[j].value == array_op[i]) {
						checkboxes[j].checked = true;
					}
				}
			}
		}
		return false;
	}

	function unsetAllIPWard() {
		unsetAllWard('IP');
		return false;
	}

	function unsetAllOPWard() {
		unsetAllWard('OP');
		return false;
	}

	function unsetAllWard(type) {
		var array_ip = [<%for(Map.Entry<String, String> entry : allIPWard.entrySet()) { %>'<%=entry.getKey() %>',<%} %>];
		var array_op = [<%for(Map.Entry<String, String> entry : allOPWard.entrySet()) { %>'<%=entry.getKey() %>',<%} %>];
		var checkboxes = document.getElementsByName('locid');
		for (var j = 0; j < checkboxes.length; j++) {
			if (type == 'IP') {
				for (var i = 0; i < array_ip.length; i++) {
					if (checkboxes[j].value == array_ip[i]) {
						checkboxes[j].checked = false;
					}
				}
			} else {
				for (var i = 0; i < array_op.length; i++) {
					if (checkboxes[j].value == array_op[i]) {
						checkboxes[j].checked = false;
					}
				}
			}
		}
		return true;
	}

	function changeReportType(combobox) {
		if (combobox.value == '1' || combobox.value == '2' || combobox.value == '3') {
			$("#location_option").html('<table><tr><td colspan="2"><button onclick="return setAllOPWard();">Select All OP Ward</button><button onclick="return unsetAllOPWard();">Unselect All OP Ward</button></tr><tr><td>&nbsp;</td><td><%for(Map.Entry<String, String> entry : allOPWard.entrySet()) { %><input type="checkbox" name="locid" value="<%=entry.getKey() %>" checked><%=entry.getValue() %><br><%} %></td></tr></table>');
		} else if (combobox.value == '4' || combobox.value == '5') {
			$("#location_option").html('<table><tr><td colspan="2"><button onclick="return setAllIPWard();">Select All IP Ward</button><button onclick="return unsetAllIPWard();">Unselect All IP Ward</button></tr><tr><td>&nbsp;</td><td><%for(Map.Entry<String, String> entry : allIPWard.entrySet()) { %><input type="checkbox" name="locid" value="<%=entry.getKey() %>" checked><%=entry.getValue() %><br><%} %></td></tr></table>');
		} else {
			$("#location_option").html('<input type="checkbox" name="locid" value="DIS" checked>Discharge<br>');
		}

		if (combobox.value == '5') {
			$("#report5_option").html('<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0"><tr class="smallText"><td class="infoLabel" width="30%">Consolidate Wards</td><td class="infoData" width="70%"><select name="allward"><option value="Y">Yes</option><option value="N" selected>No</option></select></td></tr><tr class="smallText"><td class="infoLabel" width="30%">Consolidate Date</td><td class="infoData" width="70%"><select name="dateConsolidate"><option value="Y">Yes</option><option value="N" selected>No</option></select></td></tr></table>');
		} else {
			$("#report5_option").html('');
		}
		$("#report_result").html('');
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>