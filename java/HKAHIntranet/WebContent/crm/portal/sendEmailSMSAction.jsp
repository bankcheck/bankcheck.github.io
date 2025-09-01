<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.mail.UtilMail" %>
<%@ page import="com.hkah.util.sms.UtilSMS" %>

<%!
public class ClientValue{
	String clientID;
	String value;
	String clientName;
	public ClientValue(String clientID,String value, String clientName) {
		this.clientID = clientID;
		this.value = value;
		this.clientName = clientName;
	}
}

public static ArrayList getTeam20ClientsInfo(String team20,String sendType,String[] clientIDs) {
	StringBuffer sqlStr = new StringBuffer();
	if ("sms".equals(sendType)) {
		sqlStr.append("SELECT C.CRM_MOBILE_NUMBER, C.CRM_CLIENT_ID ");
	} else {
		sqlStr.append("SELECT C.CRM_EMAIL, C.CRM_CLIENT_ID ");
	}
	sqlStr.append("FROM  CRM_CLIENTS C ");
	if (team20!=null&&team20.length()>0&&!"all".equals(team20)) {
		sqlStr.append(" , CRM_GROUP G ");
	}
	sqlStr.append("WHERE C.CRM_ENABLED = '1' ");
	if ("sms".equals(sendType)) {
		sqlStr.append("AND   C.CRM_MOBILE_NUMBER  IS NOT NULL ");
	} else {
		sqlStr.append("AND   C.CRM_EMAIL IS NOT NULL ");
	}
	sqlStr.append("AND   C.CRM_ISTEAM20 = 1 ");
	if (team20!=null&&team20.length()>0&&!"all".equals(team20)) {
		sqlStr.append("AND   G.CRM_ENABLED = '1' ");
		sqlStr.append("AND   G.CRM_GROUP_ID = C.CRM_GROUP_ID ");
		sqlStr.append("AND   G.CRM_GROUP_ID = "+team20+" ");
	}

	if (clientIDs != null && clientIDs.length > 0) {
		sqlStr.append("AND (");
		for (int i = 0;i < clientIDs.length; i++) {
			sqlStr.append(" C.CRM_CLIENT_ID = " +clientIDs[i]);
			if (i != clientIDs.length -1) {
				sqlStr.append(" OR ");
			}
		}
		sqlStr.append(") ");
	}

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static ArrayList getEnrolledClients(String eventID,String scheduleID) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT C.CRM_EMAIL, C.CRM_CLIENT_ID ,C.CRM_LASTNAME, C.CRM_FIRSTNAME ");
	sqlStr.append("FROM CO_ENROLLMENT E, CRM_CLIENTS C ");
	sqlStr.append("WHERE TO_CHAR(C.CRM_CLIENT_ID)  = E.CO_USER_ID ");
	sqlStr.append("AND   E.CO_EVENT_ID = '"+eventID+"' ");
	sqlStr.append("AND   E.CO_SCHEDULE_ID = '"+scheduleID+"' ");
	sqlStr.append("AND   E.CO_ENABLED = 1 ");

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
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
String sendBy = request.getParameter("sendBy");
String team20 = request.getParameter("team20");
String cusGroup = request.getParameter("cusGroup");

Enumeration paramNames = request.getParameterNames();
String[] cusClientID = null;
while(paramNames.hasMoreElements()) {
    String paramName = (String)paramNames.nextElement();

    if ("allToClient".equals(paramName)) {
       cusClientID = request.getParameterValues(paramName);
    }
}

String message = "";

message =  TextUtil.parseStrUTF8(
		java.net.URLDecoder.decode(
				request.getParameter("message").replaceAll("%", "%25")));

if (type.equals("sendEmail")) {
	String action =  TextUtil.parseStrUTF8(
			java.net.URLDecoder.decode(
					request.getParameter("action").replaceAll("%", "%25")));

	ArrayList<ClientValue> allEmails = new ArrayList<ClientValue>();
	ArrayList clientsEmailRecord = null;
	if ("cusGroup".equals(sendBy)) {
		clientsEmailRecord = getTeam20ClientsInfo(null,"email",cusClientID);
	} else if ("team20".equals(sendBy)) {
		clientsEmailRecord = getTeam20ClientsInfo(team20,"email",null);
	}
	for (int i = 0;i < clientsEmailRecord.size();i++) {
		ReportableListObject row = (ReportableListObject)clientsEmailRecord.get(i);
		allEmails.add(new ClientValue(row.getValue(1),row.getValue(0),null));
	}

	StringBuffer displayMessage = new StringBuffer();
	displayMessage.append("<hr>");
	displayMessage.append("<div style='font-size:20px;'>Hong Kong Adventist Hospital: Lifestyle Management Center</div>");
	displayMessage.append("<table>");
	displayMessage.append("<tr>");
	displayMessage.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>Title</td>");
	displayMessage.append("<td style='font-size:18px;background-color:#F7ECEC'>");
	displayMessage.append(action);
	displayMessage.append("</td>");
	displayMessage.append("</tr>");
	displayMessage.append("<tr>");
	displayMessage.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>Message</td>");
	displayMessage.append("<td style='font-size:18px;background-color:#F7ECEC'>");
	displayMessage.append(message);
	displayMessage.append("</td>");
	displayMessage.append("</tr>");
	displayMessage.append("</table>");

	boolean emailSuccess = false;
	StringBuffer sendStatus = new StringBuffer();
	for (ClientValue clientEmail : allEmails) {
		emailSuccess = UtilMail.sendMail(ConstantsServerSide.MAIL_ALERT, clientEmail.value,
				 action, displayMessage.toString());
		if (emailSuccess) {
			sendStatus.append("&success="+clientEmail.clientID);
		} else {
			sendStatus.append("&fail="+clientEmail.clientID);
		}
		UtilMail.insertEmailLog(userBean, clientEmail.clientID, "LMC", "EMAIL", emailSuccess, null);
	}
	%><script>
		window.open("sendEmailSMSResult.jsp?type=email<%=sendStatus.toString()%>");
	</script>
<%} else if (type.equals("sendSMS")) {
	ArrayList<ClientValue> allPhoneNumbers = new ArrayList<ClientValue>();

	ArrayList clientsSMSRecord = null;
	if ("cusGroup".equals(sendBy)) {
		clientsSMSRecord = getTeam20ClientsInfo(null,"sms",cusClientID);
	} else if ("team20".equals(sendBy)) {
		clientsSMSRecord = getTeam20ClientsInfo(team20,"sms",null);
	}
	for (int i = 0; i < clientsSMSRecord.size(); i++) {
		ReportableListObject row = (ReportableListObject)clientsSMSRecord.get(i);
		String tempPhoneNumber = row.getValue(0);
		String tempClientID = row.getValue(1);
		try {
			tempPhoneNumber = tempPhoneNumber.replaceAll("\\s","");
			Integer.parseInt(tempPhoneNumber);
			if (tempPhoneNumber.length()>=8) {
				allPhoneNumbers.add(new ClientValue(tempClientID,tempPhoneNumber,null));
			}
		} catch(NumberFormatException ne) {
		}
	}

	String resultID = "";
	StringBuffer sendStatus = new StringBuffer();
	for (ClientValue clientPhoneNumber : allPhoneNumbers) {
		resultID = UtilSMS.sendSMS(userBean, new String[] {clientPhoneNumber.value},
									message,"LMC", clientPhoneNumber.clientID, null, null);
		boolean smsSuccess = false;
		if (resultID!=null && resultID.length()>0) {
			smsSuccess = true;
			sendStatus.append("&success="+clientPhoneNumber.clientID);
		} else {
			sendStatus.append("&fail="+clientPhoneNumber.clientID);
		}
	}
	%><script>
		window.open("sendEmailSMSResult.jsp?type=sms<%=sendStatus.toString()%>");
	</script>
<%} else if (type.equals("sendEventEmail")) {
	String eventEmailTitle =  TextUtil.parseStrUTF8(
			java.net.URLDecoder.decode(
					request.getParameter("eventEmailTitle").replaceAll("%", "%25")));

	String eventEmailMessage =  TextUtil.parseStrUTF8(
			java.net.URLDecoder.decode(
					request.getParameter("eventEmailMessage").replaceAll("%", "%25")));

	String eventID = request.getParameter("eventID");
	String scheduleID = request.getParameter("scheduleID");

	ArrayList<ClientValue> allEmails = new ArrayList<ClientValue>();
	ArrayList clientsEmailRecord = null;

	clientsEmailRecord = getEnrolledClients(eventID,scheduleID);
	for (int i = 0;i < clientsEmailRecord.size();i++) {
		ReportableListObject row = (ReportableListObject)clientsEmailRecord.get(i);
		allEmails.add(new ClientValue(row.getValue(1),row.getValue(0),row.getValue(2) + "," + row.getValue(3)));
	}

	boolean emailSuccess = false;
	StringBuffer sendStatus = new StringBuffer();
	for (ClientValue clientEmail : allEmails) {
		String tempEventEmailMessage = eventEmailMessage.replaceAll("(Client Name)", clientEmail.clientName);

		emailSuccess = UtilMail.sendMail(ConstantsServerSide.MAIL_ALERT, clientEmail.value,
				 eventEmailTitle, tempEventEmailMessage);
		if (emailSuccess) {
			sendStatus.append("&success="+clientEmail.clientID);
		} else {
			sendStatus.append("&fail="+clientEmail.clientID);
		}
		UtilMail.insertEmailLog(userBean, clientEmail.clientID, "LMC", "EMAIL", emailSuccess, null);
	}
	%><script>
		window.open("sendEmailSMSResult.jsp?type=email<%=sendStatus.toString()%>");
	</script>
<%
}
%>