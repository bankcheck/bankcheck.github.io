<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
//20181224 Arran added for fitness center booking
String timeslot = request.getParameter("timeslot");

ArrayList record = FitnessDB.getTimeSlot();
ReportableListObject row = null;
	
String slotNo;
String desc;
	
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);

		slotNo = row.getValue(0);
		desc = row.getValue(1) + " - " + row.getValue(2);
%>
<option value="<%=slotNo %>"<%=slotNo.equals(timeslot)?" selected":"" %>><%=desc %></option>
<%
	}
}
%>