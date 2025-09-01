<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
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

String action = request.getParameter("action");
String courseID = request.getParameter("courseID");
String scheduleID = request.getParameter("scheduleID");
String loginStaffID = request.getParameter("loginStaffID");
loginStaffID = CRMClientDB.getClientID(loginStaffID);

String message = "";
if(action.equals("enroll")) {
	if (userBean.isAccessible("function.crm.portal.admin") || userBean.isAdmin()) {
		message = "Unable to enroll as Admin.";
	} else {
		int returnValue = EnrollmentDB.enroll(userBean, "lmc.crm", courseID, scheduleID, "guest", loginStaffID);
		if (returnValue == 0) {
			message = "Event enrolled.";

			StringBuffer eventContent = new StringBuffer();
			ArrayList eventRecord = ScheduleDB.get("lmc.crm",courseID,scheduleID);
			if (eventRecord.size() > 0) {
				ReportableListObject eventRow = (ReportableListObject)eventRecord.get(0);
				//System.out.println("---------Send Crm Email----------");
				//System.out.println("clientID: "+loginStaffID);
				String clientID = loginStaffID;
				String clientName = "";
				String clientEmail = "";
				ArrayList userRecord =  CRMClientDB.get(loginStaffID);
				if(userRecord.size() >0) {
					ReportableListObject userRow = (ReportableListObject)userRecord.get(0);
					clientName = userRow.getValue(0)+", " + userRow.getValue(1);
					clientEmail = userRow.getValue(29);
				}
				//System.out.println("clientEmail: "+clientEmail);
				String eventName =  eventRow.getValue(2);
				String eventStartDate =  eventRow.getValue(4);
				String eventTime = eventRow.getValue(5);
				String eventLocation =  eventRow.getValue(18);//fetch the location from CO_EVENT_REMARK

				eventContent.append("Dear Sir/Madam,<br/><br/>");
				eventContent.append("You ("+clientName+") are enrolled in "+eventName+" successfully.<br/><br/>");
				eventContent.append("The information of the event is following:<br/>");
				eventContent.append("Event: "+eventName+"<br/>");
				eventContent.append("Date: "+eventStartDate+"<br/>");
				eventContent.append("Time: "+eventTime+"<br/>");
				eventContent.append("Location: "+eventLocation+"<br/>");
				eventContent.append("Best Regards,<br/>");
				eventContent.append("Lifestyle Management Center");

				//System.out.println(eventContent.toString());
				UtilMail.sendMail(
						"lmc@hkah.org.hk",
						clientEmail,
						new String[]{"ricky.leung@hkah.org.hk", "cherry.wong@hkah.org.hk"},
						"Lifestyle Management Center - You have a new event!",
						eventContent.toString());
			}
		} else if (returnValue == -1) {
			message = "Event have already been enrolled.";
		} else if (returnValue == -2) {
			message = "Event is full.";
		} else {
			message = "Fail to enroll for event.";
		}
	}
} else if(action.equals("withdraw")) {
	String enrollID = request.getParameter("enrollID");
	int returnValue = EnrollmentDB.withdraw(userBean, "lmc.crm", courseID, scheduleID, enrollID, "guest", loginStaffID);
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