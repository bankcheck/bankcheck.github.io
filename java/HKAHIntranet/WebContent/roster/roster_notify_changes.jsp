<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
UserBean userBean =  new UserBean(request);

String recvStaff = request.getParameter("recvStaff");
boolean isDeptHead = request.getParameter("isDeptHead").equals("true");
String startYear = request.getParameter("startYear");
String startMonth = request.getParameter("startMonth");
String startDay = request.getParameter("startDay");

Calendar startCal = Calendar.getInstance();
Calendar endCal = Calendar.getInstance();
startCal.set(Calendar.YEAR, Integer.parseInt(startYear));
startCal.set(Calendar.MONTH, Integer.parseInt(startMonth));
startCal.set(Calendar.DATE, Integer.parseInt(startDay));

endCal.set(Calendar.YEAR, Integer.parseInt(startYear));
endCal.set(Calendar.MONTH, Integer.parseInt(startMonth));
endCal.set(Calendar.DATE, Integer.parseInt(startDay));
endCal.add(Calendar.MONTH, 1);
endCal.set(Calendar.DATE, 20);

SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

String successMsg = "";
String failMsg = "";

if (recvStaff != null && recvStaff.length() > 0) {
	String[] recvStaffs = recvStaff.split("_");
	String subject = "";
	String content = "";

	if (recvStaffs.length > 0) {
		String[] emailTo = new String[recvStaffs.length];
		String[] staffStatus = new String[recvStaffs.length];

		for (int i = 0; i < recvStaffs.length; i++) {
			//System.out.println("Staff: "+recvStaffs[i]);
			String email = "andrew.lau@hkah.org.hk";//StaffDB.getStaffEmail(recvStaffs[i]);

			if (email != null && email.length() > 0) {
				emailTo[i] = email;
				staffStatus[i] = "Success";
			} else {
				staffStatus[i] = "Fail";
			}
		}
		if (isDeptHead) {
			subject = "Roster - Modified your record.";
			content = "Your records in the period of "+sdf.format(startCal.getTime())+
						" - "+ sdf.format(endCal.getTime())+
						" are modified by "+StaffDB.getStaffFullName2(userBean.getStaffID());
		} else {
			subject = "Roster - Request the modification of record";
			content = StaffDB.getStaffFullName2(userBean.getStaffID()) +
						" is modified the records in the period of "+
						sdf.format(startCal.getTime())+ " - "+ sdf.format(endCal.getTime());

		}

		if (UtilMail.sendMail("alert@hkah.org.hk", emailTo, subject, content)) {
			for (int i = 0; i < recvStaffs.length; i++) {
				if (staffStatus[i] == "Success") {
					successMsg += "("+recvStaffs[i]+") " +
								StaffDB.getStaffFullName2(recvStaffs[i])+"<br/>";

					UtilMail.insertEmailLog(userBean, recvStaffs[i], "ROSTER", "EMAIL", true, null);
				} else {
					failMsg += "("+recvStaffs[i]+") " +
								StaffDB.getStaffFullName2(recvStaffs[i])+"<br/>";

					UtilMail.insertEmailLog(userBean, recvStaffs[i], "ROSTER", "EMAIL", false, null);
				}
			}
		} else {
			for (int i = 0; i < recvStaffs.length; i++) {
				failMsg += "("+recvStaffs[i]+") " +
							StaffDB.getStaffFullName2(recvStaffs[i])+"<br/>";
			}
		}
	}
}
%>
<%="<u>The Status of Email</u><br/>Success:<br/>"+successMsg+"<br/>Fail:<br/>"+failMsg%>