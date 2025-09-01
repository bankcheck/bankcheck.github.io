<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
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
String patNo = request.getParameter("patNo");
String emergency = request.getParameter("emergency");
String attend = request.getParameter("attend");
String visitStatus = request.getParameter("visitStatus");

if (action != null && action.equals("checkRepeatVisit")) {
	ArrayList record = PatientDB.checkPatientVisitStatusExists(patNo, null);
	if (record.size() == 0) {
%>
	fail
<%
	} else {
		ReportableListObject patientVisitDetails = (ReportableListObject)record.get(0);
		String visitStatusDate = patientVisitDetails.getValue(4);

		ArrayList visitStatusRecord = PatientDB.checkLoggingAfterPatientStatus(patNo,visitStatusDate);
		if (visitStatusRecord.size()==0) {
			String[] aDate = visitStatusDate.split(" ");
			String[] date = aDate[0].split("/");
			String day = date[0];
			String month = date[1];
			String year = date[2];

			String[] time = aDate[1].split(":");
			String hour = time[0];
			String minute = time[1];
			String second = time[2];

			Calendar adDate = Calendar.getInstance();
			Calendar currentDate = Calendar.getInstance();

			adDate.set( Integer.parseInt(year),  Integer.parseInt(month)-1,  Integer.parseInt(day),
						 0,  0, 0) ;


			if (visitStatus.equals("Again")) {
				adDate.add(Calendar.DATE,1);
			} else if (visitStatus.equals("Frequently")) {
				adDate.add(Calendar.DATE,3);
			} else if (visitStatus.equals("Daily")) {
				adDate.add(Calendar.DATE,1);
			}

			if (currentDate.after(adDate)) {

%>
			nolog
<%
			}
		}


	}
} else if (action != null && action.equals("checkRefChapID")) {

	 //SimpleDateFormat sdf =  new SimpleDateFormat("dd/MM/yyyy kk:mm:ss");

	ArrayList record = PatientDB.checkPatientChapReferralWithPatID(patNo);
	if (record.size() == 0) {
%>
		false
<%
	} else {
		ReportableListObject patientRefDetails = (ReportableListObject)record.get(0);
		String refDate = patientRefDetails.getValue(2);

		String[] aDate = refDate.split(" ");
		String[] date = aDate[0].split("/");
		String day = date[0];
		String month = date[1];
		String year = date[2];

		String[] time = aDate[1].split(":");
		String hour = time[0];
		String minute = time[1];
		String second = time[2];

		Calendar adDate = Calendar.getInstance();
		Calendar currentDate = Calendar.getInstance();

		adDate.set( Integer.parseInt(year),  Integer.parseInt(month)-1,  Integer.parseInt(day),
					0,  0, 0) ;
		adDate.add(Calendar.DATE,1);
		if (currentDate.after(adDate)) {

			%>
						nologafteronedayref
			<%

		}
	}
} else {
	ArrayList record = PatientDB.checkPatientVisitStatusExists(patNo,null);
	if (record.size() == 0) {
		%><%=PatientDB.addPatientVisitStatus(userBean, patNo, emergency, attend, visitStatus, "chaplaincy", "I")%><%
	} else {
		%><%=PatientDB.editPatientVisitStatus(userBean, patNo, emergency, attend, visitStatus, "chaplaincy")%><%
	}
}
%>