<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%
	String reqNo = request.getParameter("reqNo");
	String reqName = null;
	String reqDept = null;
	
	ArrayList record = null;
	record = RequestDB.get(reqNo);
	
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		reqName = row.getValue(7);
		reqDept = row.getValue(3);
	}
%>
{ "reqName":"<%=reqName%>", "reqDept":"<%=reqDept%>" }