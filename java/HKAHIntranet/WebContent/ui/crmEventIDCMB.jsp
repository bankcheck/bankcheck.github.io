<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String eventID = request.getParameter("eventID");
String selectID = request.getParameter("selectID");
String selectName = request.getParameter("selectName");
String onChangeName = request.getParameter("onChangeName");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));



%>
<select id="<%=selectID==null?"":selectID%>" name="<%=selectName==null?"":selectName%>" onchange="<%=onChangeName==null?"":onChangeName%>(this)">		
<%

if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "";
	}
%><option value=""><%=emptyLabel %></option><%
}
StringBuffer sqlStr = new StringBuffer();
ArrayList record = ScheduleDB.getList("lmc.crm", null, null);
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
				
		String eventTitle = row.getValue(3);
		String eventDate = row.getValue(8);
		String eventTime = row.getValue(9);
		String eventLocation = row.getValue(12);
		String eventScheduleID = row.getValue(7);
		
%>
<option value="<%=row.getValue(2) %>"<%=row.getValue(2).equals(eventID)?" selected":"" %>><%=row.getValue(3) %></option>

<%
		sqlStr.append("<input type='hidden' name='event_eventTitle_"+row.getValue(2)+"' value='"+eventTitle+"' />");
		sqlStr.append("<input type='hidden' name='event_eventDate_"+row.getValue(2)+"' value='"+eventDate+"' />");
		sqlStr.append("<input type='hidden' name='event_eventTime_"+row.getValue(2)+"' value='"+eventTime+"' />");
		sqlStr.append("<input type='hidden' name='event_eventLocation_"+row.getValue(2)+"' value='"+eventLocation+"' />");
		sqlStr.append("<input type='hidden' name='event_eventID_"+row.getValue(2)+"' value='"+row.getValue(2)+"' />");
		sqlStr.append("<input type='hidden' name='event_scheduleID_"+row.getValue(2)+"' value='"+eventScheduleID+"' />");
	}
}
%>
</select>
<%=sqlStr.toString() %>
