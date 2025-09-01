<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.*"%>

<%! 
	public String getSendDT(String id) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT TO_CHAR(SEND_TIME, 'DD/MM/YYYY HH24:MI') ");
		sqlStr.append("FROM SMS_LOG ");
		sqlStr.append("WHERE MSG_BATCH_ID = '"+id+"' ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		if(record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			
			return row.getValue(0);
		}
		else {
			return "";
		}
	}
%>

<%
UserBean userBean = new UserBean(request);

String phone = request.getParameter("phone");
String lang = request.getParameter("lang");
String admDate = request.getParameter("admDate");
String type = request.getParameter("type");
String preBID = request.getParameter("BPBID");
String template = request.getParameter("template");
String result = "";

if (phone != null && phone.length() > 0 && lang != null && lang.length() > 0 && admDate != null && admDate.length() > 0) {
	result = InPatientPreBookDB.sendSMSToClient(userBean, admDate, lang, phone, type, preBID,template);
	//System.out.println("SMS: "+type+" "+result+" "+(new Date()).toString());
	if (result != null &&result.length() > 0) {
		if(type != null && type.equals("INPAT")) {
			InPatientPreBookDB.updateSentDT("SMS", preBID, result);
		}
		%><blank>SMS Sent to <%=phone %> on <%=getSendDT(result) %>!</blank><%
	} else {
		%><blank>Fail to Send SMS to <%=phone %>!</blank><%
	}
}
%>