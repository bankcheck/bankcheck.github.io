<%@ page language="java" contentType="text/html; charset=big5"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"%><%!
%><%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String pirID = request.getParameter("pirID");
String redoReason = "User Request";
String redoPerson = null;
String fupirflwID = null;
String fuCrDate = null;
String fuDueDate = null;
String fuCompDate = null;
String dutyMgr = null;
String deptHead = null;
String fupirflwpID = null;
String incident_classification = null;
String deptCodeFlwup = null;
String deptCode = null;
String rptSts = null;
String returnMessage = "Submit redo failure";

if (pirID != null && pirID.length() > 0) {
	ArrayList record = PiReportDB.fetchReportBasicInfo(pirID);
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		incident_classification = row.getValue(10);
		deptCodeFlwup = row.getValue(32);
		deptCode = row.getValue(8);
		rptSts = row.getValue(9);
	}

	if (!"0".equals(rptSts)) {
		String ori_rptSts = rptSts;

		boolean IsStaffIncident = PiReportDB.IsStaffIncident(incident_classification);
		boolean IsMedicationIncident = PiReportDB.IsMedicationIncident(incident_classification);
		boolean IsPxIncident = PiReportDB.IsPxDeptCode(deptCodeFlwup);

		rptSts = PiReportDB.getPreviousStatus(pirID);
		out.println("From Status: [" + PiReportDB.getRptStsDesc(IsPxIncident, incident_classification, deptCode, ori_rptSts) + "]");
		out.println("To Status: [" + PiReportDB.getRptStsDesc(IsPxIncident, incident_classification, deptCode, rptSts) + "]");

		redoPerson = PiReportDB.getRespondPerson(pirID, rptSts, ori_rptSts);
		if (redoPerson != null && redoPerson.length() > 0) {
			out.println("Redo Person: [" + StaffDB.getStaffName(redoPerson) + "]");
		}

		if (PiReportDB.updatePIReportStatus(userBean, pirID, rptSts)) {
			if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Redo", fuCrDate, userBean.getStaffID(), fuDueDate, fuCompDate, redoReason, redoPerson, dutyMgr, rptSts)) != null) {

				fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, deptHead);

				// Send the followup msg
				PiReportDB.SendFlwupMsg(userBean, "Submit", incident_classification, pirID, fupirflwID, "");
			}
		}

		String emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());
		String emailToList = StaffDB.getStaffEmail(redoPerson);

		//redo email
		PiReportDB.sendEmailRedo(userBean.getStaffID(), incident_classification, pirID, rptSts, "Redo", emailFromList, emailToList, redoReason);

		out.println("------------------------------");
		returnMessage = "Redo successful.";
	}
}%><%=returnMessage %>