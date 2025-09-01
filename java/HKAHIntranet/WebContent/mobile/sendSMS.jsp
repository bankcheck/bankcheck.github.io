<%@ page import="java.io.IOException"%>
<%@ page import="java.net.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.util.ParserUtil"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.util.sms.UtilSMS"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.PatientDB"%>
<%!
	private static String sqlStr_getSMSReturnMsg = null;

	private static String sqlStr_selectSMSReturnMsg = null;
	private static String sqlStr_insertSMSReturnMsg_Booking4Doctor_Success = null;
	private static String sqlStr_updateSMSReturnMsg_Booking4Doctor_Success = null;
	private static String sqlStr_insertSMSReturnMsg_Booking4Doctor_Sent = null;
	private static String sqlStr_updateSMSReturnMsg_Booking4Doctor_Sent = null;

	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.setLength(0);
		sqlStr.append("SELECT SUCCESS ");
		sqlStr.append("FROM SMS_LOG ");
		sqlStr.append("WHERE MSG_BATCH_ID = ? ");
		sqlStr_getSMSReturnMsg = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM SCHEDULE_EXTRA@IWEB ");
		sqlStr.append("WHERE SCHID = ? ");
		sqlStr_selectSMSReturnMsg = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO SCHEDULE_EXTRA@IWEB ");
		sqlStr.append("(SCHID, DOCSMSSDTOK, DOCSMSRTNMSG, DOCSMSSDT) VALUES (?, ");
		sqlStr.append(" (SELECT SEND_TIME FROM SMS_LOG WHERE MSG_BATCH_ID = ?), ");
		sqlStr.append(" (SELECT RES_MSG FROM SMS_LOG WHERE MSG_BATCH_ID = ?), ");
		sqlStr.append("  SYSDATE) ");
		sqlStr_insertSMSReturnMsg_Booking4Doctor_Success = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE SCHEDULE_EXTRA@IWEB ");
		sqlStr.append("SET DOCSMSSDTOK = (SELECT SEND_TIME FROM SMS_LOG WHERE MSG_BATCH_ID = ?), ");
		sqlStr.append("    DOCSMSRTNMSG = (SELECT RES_MSG FROM SMS_LOG WHERE MSG_BATCH_ID = ?), ");
		sqlStr.append("    DOCSMSSDT = SYSDATE ");
		sqlStr.append("WHERE SCHID = ? ");
		sqlStr_updateSMSReturnMsg_Booking4Doctor_Success = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO SCHEDULE_EXTRA@IWEB ");
		sqlStr.append("(SCHID, DOCSMSSDTOK, DOCSMSRTNMSG, DOCSMSSDT) VALUES (?, '', 'SENT', SYSDATE) ");
		sqlStr_insertSMSReturnMsg_Booking4Doctor_Sent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE SCHEDULE_EXTRA@IWEB ");
		sqlStr.append("SET DOCSMSRTNMSG = 'SENT', ");
		sqlStr.append("    DOCSMSSDT = SYSDATE ");
		sqlStr.append("WHERE SCHID = ? ");
		sqlStr_updateSMSReturnMsg_Booking4Doctor_Sent = sqlStr.toString();
	}

	public static boolean getSuccessOfSMS(String msgId) {
		if (msgId != null && msgId.length() > 0) {
			ArrayList record = UtilDBWeb.getReportableList(sqlStr_getSMSReturnMsg, new String[] {msgId});
			ReportableListObject row = null;

			if (record.size() > 0) {
				row = (ReportableListObject)record.get(0);

				return row.getValue(0).equals("1");
			}
		}
		return false;
	}

	private static boolean updateSuccessTimeAndMsg_Booking4Doctor(String schid, String msgId, boolean success) {
		ArrayList record = UtilDBWeb.getReportableList(sqlStr_selectSMSReturnMsg, new String[] {schid});
		if (record.size() == 0) {
			if (success) {
				return UtilDBWeb.updateQueue(sqlStr_insertSMSReturnMsg_Booking4Doctor_Success, new String[] {schid, msgId, msgId});
			} else {
				return UtilDBWeb.updateQueue(sqlStr_insertSMSReturnMsg_Booking4Doctor_Sent, new String[] {schid});
			}
		} else {
			if (success) {
				return UtilDBWeb.updateQueue(sqlStr_updateSMSReturnMsg_Booking4Doctor_Success, new String[] {schid, msgId, msgId});
			} else {
				return UtilDBWeb.updateQueue(sqlStr_updateSMSReturnMsg_Booking4Doctor_Sent, new String[] {schid});
			}
		}
	}
%>
<%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String schid = ParserUtil.getParameter(request, "schid");
String receiver = ParserUtil.getParameter(request, "receiver");
String content = request.getParameter("content");
if (content != null) {
	content = new String(content.getBytes("ISO-8859-1"), "UTF-8");
}
String SMS_LINK = "http://smsc.xgate.com.hk/smshub/sendsms?";
String SMS_SENDER_ID = "Adventist H";
String SMS_MSG_TYPE = "TEXT";
String SMS_MSG_LANG = "UTF8";
String couCode = "852";

boolean success = true;
boolean forward = false;

if (forward) {
	try {
		if (ConstantsServerSide.isHKAH()) {
			%><%=ServerUtil.connectServer("http://160.100.2.80/intranet/mobile/sendSMS.jsp", "receiver=" + receiver + "&content=" + URLEncoder.encode(content, "UTF-8")) %><%
		} else {
			%><%=ServerUtil.connectServer("http://192.168.0.20/intranet/mobile/sendSMS.jsp", "receiver=" + receiver + "&content=" + URLEncoder.encode(content, "UTF-8")) %><%
		}
	} catch (Exception e) {}
} else {
	Calendar calendar = Calendar.getInstance();
	SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmssSSS");
	String sysDate = dateFormat.format(calendar.getTime());

	if (receiver != null && receiver.length() > 0) {
		if (receiver.indexOf("852") == 0 && receiver.length() == 11) {
			receiver = receiver.substring(3);
		}

		String phoneNo = UtilSMS.getPhoneNo2(receiver, couCode, null, null, null, "MOBILEAPP", UtilSMS.SMS_OUTPAT);
		if (content != null) {
			try {
				String msgId = UtilSMS.sendSMS("MOBILE", new String[] { phoneNo },
						content,
						UtilSMS.SMS_OUTPAT, sysDate , null, "");

				if (schid != null && schid.length() > 0) {
					updateSuccessTimeAndMsg_Booking4Doctor(schid, msgId, getSuccessOfSMS(msgId));
				}
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			//error
			UtilSMS.saveLog("No content", sysDate, UtilSMS.SMS_OUTPAT, "", "MOBILEAPP");
			success = false;
		}
	} else {
		//Fail
		UtilSMS.saveLog("No Receiver", sysDate, UtilSMS.SMS_OUTPAT, "", "MOBILEAPP");
		success = false;
%>

<%		if (!success) { System.err.println("3[receiver]:"+receiver);%>
	<script language="javascript">
		alert('[Fail to send SMS of]:'+receiver);
	</script>
<%		}
	}
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%="<u>The Status of SMS</u><br/>Success:<br/>"+success%>
    </body>
</html>
<%}%>