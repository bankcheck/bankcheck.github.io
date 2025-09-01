<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%!
public static ArrayList getEventScheduleDate(String eventID,String scheduleID) {
	StringBuffer sqlStr = new StringBuffer();
			

	sqlStr.append("SELECT   TO_CHAR(CO_SCHEDULE_START, 'dd/MM/YYYY') ");
	sqlStr.append("FROM    CO_SCHEDULE ");
	sqlStr.append("where   CO_EVENT_ID = '"+eventID+"' ");
	sqlStr.append("and     CO_MODULE_CODE = 'lmc.crm' ");
	sqlStr.append("and     CO_SCHEDULE_ID = '"+scheduleID+"' ");
	sqlStr.append("AND     CO_ENABLED = 1 ");

	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static boolean updateAttendDate(UserBean userBean, String eventID, String scheduleID, String enrollID,
		String attendDate) {
	
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("UPDATE CO_ENROLLMENT ");
	sqlStr.append("SET    CO_ATTEND_DATE = TO_DATE('"+attendDate+"', 'dd/MM/yyyy'), ");
	sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
	sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
	sqlStr.append("AND    CO_MODULE_CODE = 'lmc.crm' ");
	sqlStr.append("AND    CO_EVENT_ID = '"+eventID+"' ");	
	sqlStr.append("AND    CO_ENROLL_ID = '"+enrollID+"' ");
	sqlStr.append("AND    CO_SCHEDULE_ID = '"+scheduleID+"' ");			
	sqlStr.append("AND    CO_ENABLED = 1");

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.updateQueue(sqlStr.toString());
}

%>
<%
UserBean userBean = new UserBean(request);
if (userBean == null || !userBean.isLogin()) {
	%>
	<script>
		window.open("../index.jsp", "_self");
	</script>
	<%
	return;
}
String type = request.getParameter("type");
if("enroll_workshop".equals(type)){
	String action = request.getParameter("action");
	String module = request.getParameter("module");
	String clientID = request.getParameter("clientID");
	
	String eventID = null;
	String scheduleID = "1";
	if("lmc.pwp".equals(module)){
		eventID = EventDB.getEventID(module, "Attend PWP");	
	}else if("lmc.scr".equals(module)){
		eventID = EventDB.getEventID(module, "Attend Screening");
	}
	String message = "";
	
	if(action.equals("enroll")){
		int returnValue = EnrollmentDB.enroll(userBean, module, eventID, scheduleID, "guest", clientID);
		if (returnValue == 0) {
			message = "Event enrolled.";	
		} else if (returnValue == -1) {
			message = "Event have already been enrolled.";
		} else if (returnValue == -2) {
			message = "Event is full.";
		} else {
			message = "Fail to enroll for event.";
		}
	}else if(action.equals("withdraw")){
		String enrollNo = request.getParameter("enrollNo");
		int returnValue = EnrollmentDB.withdraw(userBean, module, eventID, scheduleID, enrollNo, "guest", clientID);
		if (returnValue == 0) {
			message = "Event withdrawn successfully.";		
		} else if (returnValue == -1) {
			message = "Event have not yet been enrolled.";
		} else {
			message = "Fail to withdraw from event.";
		}		
	}
%>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%=message %>
<%}else if("attend_event".equals(type)){
	String action = request.getParameter("action");
	String eventID = request.getParameter("eventID");
	String enrollNo = request.getParameter("enrollNo");
	String scheduleID = request.getParameter("scheduleID");	
	String message = "";
	
	if(action.equals("attend")){
		ArrayList eventScheduleDateRecord = getEventScheduleDate(eventID, scheduleID);
		String eventScheduleDate = "";
		if(eventScheduleDateRecord.size() != 0 ){	
			ReportableListObject eventScheduleDateRow = (ReportableListObject)eventScheduleDateRecord.get(0);
			eventScheduleDate = eventScheduleDateRow.getValue(0);
		}	
		boolean success = updateAttendDate(userBean, eventID, scheduleID, enrollNo, eventScheduleDate);
		if(success){
			message = "Attend date updated.";	
		}else{
			message = "Failed to update attend date updated";
		}
	}else if(action.equals("withdraw")){
		boolean success = updateAttendDate(userBean, eventID, scheduleID, enrollNo, "");
		if(success){
			message = "Attend date updated.";	
		}else{
			message = "Failed to update attend date updated";
		}
	}
%>

<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%=message %>
<%}%>

