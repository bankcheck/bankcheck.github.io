<%@ page import="com.hkah.web.common.UserBean"%>
<%@ page import="com.hkah.util.ParserUtil"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.PatientDB"%>
<%@ page import="com.hkah.web.db.SMSDB"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.util.sms.UtilSMS"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.web.schedule.NotifyPatientAppointment"%>
<%@ page import="com.hkah.web.common.ReportableListObject"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>

<%!
public static ArrayList getRevList(String batchID, String patno){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT S.PATNO, CONCAT (P.PATFNAME, (' '||P.PATGNAME)) PATNAME,");
	sqlStr.append("P.PATADD1, P.PATADD2, P.PATADD3, ");
	sqlStr.append("P.PATPAGER, P.PATEMAIL, S.METHOD ");
	sqlStr.append("FROM SMS_BATCH_LIST S, PATIENT@IWEB P ");
	sqlStr.append("WHERE S.PATNO = P.PATNO ");
	sqlStr.append("AND S.BATCH_ID = '");
	sqlStr.append(batchID);
	sqlStr.append("' ");
	sqlStr.append("AND S.PATNO = '");
	sqlStr.append(patno);
	sqlStr.append("' ");
	sqlStr.append("AND S.METHOD = 'S' ");
	sqlStr.append("ORDER BY P.PATPAGER, P.PATADD1, P.PATADD2, P.PATADD3 ");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String batchID = ParserUtil.getParameter(request, "batchID");
String patno = ParserUtil.getParameter(request, "patno");
String smsCode = ParserUtil.getParameter(request, "smsCode");

System.out.println("BatchID:"+batchID);
System.out.println("Patno:"+patno);
System.out.println("SmsCode:"+smsCode);

ArrayList record = getRevList(batchID, patno);

String content = "";
String lang = "ENG";

boolean success = true;

if (record.size() > 0) {

		ReportableListObject row = (ReportableListObject)record.get(0);
	
		String phoneNo =
			NotifyPatientAppointment.getPhoneNo(row.getValue(5).trim(), null,
					row.getValue(0).trim(), row.getValue(0).trim(), lang, batchID, UtilSMS.SMS_TWMKT, null);

	System.out.println("phoneNo:"+ phoneNo);
		if (phoneNo == null) {
			success = false;
		} else {
			ArrayList result = SMSDB.getMsg(smsCode, null);
			if(result.size() > 0){
				ReportableListObject row1 = (ReportableListObject)result.get(0);
				content = row1.getValue(1);
				content = content.replace("&#13;", "\n");
				System.out.println("Content:[ " + content + " ]");
			}
	
			if (content != null) {				
				
				UtilSMS.sendSMS(userBean, new String[] { phoneNo },
							content,
							UtilSMS.SMS_TWMKT, row.getValue(0).trim(), lang, batchID);
	
				SMSDB.sendMsg(batchID, smsCode, userBean);
	
			} else {
				//error
				UtilSMS.saveLog("Cannot retrieve any sms message",
						row.getValue(0).trim() , UtilSMS.SMS_TWMKT, "", batchID);
				success = false;
			}
		}
} else {
	//Fail
	UtilSMS.saveLog("Cannot find any receiver with this batch",
			null, UtilSMS.SMS_TWMKT, null, batchID);
	success = false;
}

%>
<%=success%>