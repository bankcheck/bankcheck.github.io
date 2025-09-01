<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String moduleCode = request.getParameter("moduleCode");
String deptCode = request.getParameter("deptCode");
String eventID = request.getParameter("eventID");
String eventCategory = request.getParameter("eventCategory");
String eventType = request.getParameter("eventType");
boolean accessControl = "Y".equals(request.getParameter("accessControl"));
boolean allowAll = "Y".equals(request.getParameter("allowAll"));

// if not admin, use login dept code as default dept code
if (!userBean.isAdmin() && (deptCode == null || deptCode.length() == 0)) {
	deptCode = userBean.getDeptCode();
}
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "--- All Courses ---";
	}
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = null;
if("foodOrder".equals(moduleCode)){
	if (eventID != null && eventID.length() > 0) {
		if(allowAll){
			record = EventDB.getList(moduleCode, deptCode, null, eventCategory, eventType);		
		}else{
			record = EventDB.getListById(moduleCode, eventID);
		}

	}else{
		record = EventDB.getList(moduleCode, deptCode, null, eventCategory, eventType);		
	}
}else{
	record = EventDB.getList(moduleCode, deptCode, null, eventCategory, eventType);	
}
ReportableListObject row = null;
String bookingRoomTypePrefix = "function.meetingRoom.type.";
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		
		boolean showOption = true;
		if (accessControl) {
			if ("booking".equals(moduleCode)) {
				String thisEventID = row.getValue(0);
				if (userBean.isAccessible(bookingRoomTypePrefix + "all") || 
						userBean.isAccessible(bookingRoomTypePrefix + thisEventID)) {
					showOption = true;
				} else {
					showOption = false;
				}
			}
		}
		
		if (showOption) {
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(eventID)?" selected":"" %>><%=row.getValue(1) %></option><%
		}
	}
}
%>