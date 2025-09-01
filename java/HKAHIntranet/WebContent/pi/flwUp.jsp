<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%!
	private String parseTextArea(String text) {
		if (text != null && text.length() > 0) {
//			return StringEscapeUtils.escapeHtml(text).replaceAll("(\r\n|\n)", "<br />");
			return StringEscapeUtils.escapeHtml(text);
		} else {
			return "";
		}
	}

	private String parseString(String text) {
		if (text != null && text.length() > 0) {
			return text;
		} else {
			return "";
		}
	}
%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%
UserBean userBean = new UserBean(request);
String pirID = request.getParameter("pirID");
String incident_classification_desc = request.getParameter("incidentType");
String incidentType = request.getParameter("incidentType");
String incidentDesc = request.getParameter("incidentDesc");
String pirDID = request.getParameter("PIR_DID");
//String pageIndex = "flwUp";

ReportableListObject row = null;
ReportableListObject row2 = null;
String outValTemp = "";
String outValTemp2 = "";
String outValTemp3 = "";
String outVal = "";
String semiColon = "";
String ReceiverType = "admin";
String ccList = "";
Boolean IsReponsiblePerson = null;
Boolean IsResponsibleDHead = null;
Boolean IsResponsibleFlwUp = null;
Boolean IsResponsibleUMDM = null;
Boolean IsAddRptPerson = null;
Boolean IsDHead = null;
Boolean IsOshIcn = null;
Boolean IsPharmacy = null;
Boolean IsPIManager = null;
Boolean IsStaffIncident = null;
Boolean IsMedicationIncident = null;
Boolean IsPatientIncident = null;
Boolean IsNursingStaff = null;
String rptSts = null;
String reportStatusDesc = null;
String submitBtnLabel = null;
String RespPerson = null;
String Narrative = null;
String Cause = null;
String ActionDone = null;
String ActionTaken = null;
String Narrative_followup = null;
String Cause_followup = null;
String ActionDone_followup = null;
String ActionTaken_followup = null;
String Narrative_umdm = null;
String Cause_umdm = null;
String ActionDone_umdm = null;
String ActionTaken_umdm = null;
String Rpt_Narrative = null;
String Rpt_Cause = null;
String Rpt_ActionDone = null;
String Rpt_ActionTaken = null;
String editNarrative = null;
String editCause = null;
String editActionDone = null;
String editActionTaken = null;
String editNarrative_followup = null;
String editCause_followup = null;
String editActionDone_followup = null;
String editActionTaken_followup = null;
String editNarrative_umdm = null;
String editCause_umdm = null;
String editActionDone_umdm = null;
String editActionTaken_umdm = null;
String failurecomply = null;
String samedrug = null;
String inappabb = null;
String ordermis = null;
String lasa = null;
String lapses = null;
String equipfailure = null;
String illegalhand = null;
String miscal = null;
String systemflaw = null;
String Inadtrainstaff = null;
String othersfreetext = null;
String othersfreetextedit = null;
String relatedstaff = null;
String sharestaff = null;
String sharestaffdate = null;
String noaffect = null;
String noharm = null;
String tempharm = null;
String permharm = null;
String death = null;
//osh modification 01112018
String slDays = null;
String labDept = null;
String patInv = null;
String labDeptRemark = null;
String rptPolice = null;
String rptIod = null;
//
String Narrative_OSHICN = null;
String Cause_OSHICN = null;
String ActionDone_OSHICN = null;
String ActionTaken_OSHICN = null;
String Narrative_ADMIN = null;
String Cause_ADMIN = null;
String ActionDone_ADMIN = null;
String ActionTaken_ADMIN = null;
String Narrative_PI = null;
String Cause_PI = null;
String ActionDone_PI = null;
String ActionTaken_PI = null;
String contamin = null;
String noncontamin = null;
String bodyfluexp = null;
String adminviewed = null;
String admincomment = null;
// checkbox for follow up action
String staffedu = null;
String staffedutext = null;
String staffdisc = null;
String staffdisctext = null;
String cons = null;
String constext = null;
String shar = null;
String shartext1 = null;
String shartext2 = null;
String revpol = null;
String revpoltext = null;
String revform = null;
String revformtext = null;
String creform = null;
String creformtext = null;
String refer = null;
String refertext = null;
String referdepttext = null;
String others = null;

String parentDesc = null;
String grpID = null;
Boolean hasParentDesc = false;
Boolean isAllowFlwupStatus = false;
Boolean isAllowOshIcnFlwupStatus = false;

if (pirID != null) {
	ArrayList record = PiReportDB.fetchReportBasicInfo(pirID);
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		incident_classification_desc = row.getValue(10);
		rptSts = row.getValue(9);
		reportStatusDesc = PiReportDB.getRptStsDesc(PiReportDB.IsPxDeptCode(row.getValue(32)), incident_classification_desc, row.getValue(8), rptSts);
	}

	IsDHead = PiReportDB.IsDHead(userBean.getStaffID());
	IsReponsiblePerson = PiReportDB.IsRespondsiblePerson(pirID, userBean.getStaffID());
	IsAddRptPerson = PiReportDB.IsAddRptPerson(userBean.getStaffID());
	IsOshIcn = PiReportDB.IsOshIcnPerson(userBean.getStaffID());
	IsPharmacy = PiReportDB.IsSeniorPharmacy(userBean.getStaffID());
	IsStaffIncident = PiReportDB.IsStaffIncident(incident_classification_desc);
	if (ConstantsServerSide.isTWAH() && !IsStaffIncident) { // check if visitor inj but has BBF (option_id 1600)
		IsStaffIncident = PiReportDB.IsVisitorBBF(pirID);
	}
	IsMedicationIncident = PiReportDB.IsMedicationIncident(incident_classification_desc);
	IsPatientIncident = PiReportDB.IsPatientIncident(incident_classification_desc);
	IsPIManager = PiReportDB.IsPIManager(userBean.getStaffID());
	IsResponsibleDHead = PiReportDB.IsResponsibleDepartmentHead(pirID, userBean.getStaffID());
	// for dm/um can edit report follow even submit to admin
	IsResponsibleFlwUp = PiReportDB.IsResponsibleFlwUp(pirID, userBean.getStaffID());
	IsResponsibleUMDM = PiReportDB.IsRespondsibleUMDM(pirID, userBean.getStaffID());
	IsNursingStaff = PiReportDB.IsNursingStaff(userBean.getStaffID());

	// get reporter narrative value
	ArrayList flwUpDialogreportDtl2 = PiReportDB.fetchReportFlwUpDialogReportDtl(pirID, "29");
	for (int j = 0; j < flwUpDialogreportDtl2.size(); j++) {
		row = (ReportableListObject) flwUpDialogreportDtl2.get(j);
		if (flwUpDialogreportDtl2.size() > 0) {
			if ("284".equals(row.getValue(3))) {
				Rpt_Narrative = row.getValue(1);
			}
			else if ("285".equals(row.getValue(3))) {
				Rpt_Cause = row.getValue(1);
			}
			else if ("286".equals(row.getValue(3))) {
				Rpt_ActionDone = row.getValue(1);
			}
			else if ("287".equals(row.getValue(3))) {
				Rpt_ActionTaken = row.getValue(1);
			}
		}
	}

	ArrayList record3 = PiReportDB.fetchReporDheadComment(pirID);
	if (record3.size() > 0) {
		row = (ReportableListObject) record3.get(0);
		pirDID = row.getValue(1);
		Narrative = row.getValue(3);
		Cause = row.getValue(4);
		ActionDone = row.getValue(5);
		ActionTaken = row.getValue(6);

		failurecomply = row.getValue(39);

		samedrug = row.getValue(40);
		inappabb = row.getValue(41);
		ordermis = row.getValue(42);
		lasa = row.getValue(43);
		lapses = row.getValue(44);

		equipfailure = row.getValue(45);
		illegalhand = row.getValue(46);
		miscal = row.getValue(47);
		systemflaw = row.getValue(48);
		Inadtrainstaff = row.getValue(49);

		othersfreetext = row.getValue(50);
		othersfreetextedit = row.getValue(51);
		relatedstaff = row.getValue(52);
		sharestaff = row.getValue(53);
		sharestaffdate = row.getValue(54);

		noaffect = row.getValue(55);
		noharm = row.getValue(56);
		tempharm = row.getValue(57);
		permharm = row.getValue(58);
		death = row.getValue(59);

		Narrative_OSHICN = row.getValue(60);
		Cause_OSHICN = row.getValue(61);
		ActionDone_OSHICN = row.getValue(62);
		ActionTaken_OSHICN = row.getValue(63);
		Narrative_ADMIN = row.getValue(64);
		Cause_ADMIN = row.getValue(65);
		ActionDone_ADMIN = row.getValue(66);
		ActionTaken_ADMIN = row.getValue(67);
		Narrative_PI = row.getValue(68);
		Cause_PI = row.getValue(69);
		ActionDone_PI = row.getValue(70);
		ActionTaken_PI = row.getValue(71);

		contamin = row.getValue(72);
		noncontamin = row.getValue(73);
		bodyfluexp = row.getValue(74);

		adminviewed = row.getValue(75);
		admincomment = row.getValue(76);

		staffedu = row.getValue(77);
		staffedutext = row.getValue(78);
		staffdisc = row.getValue(79);
		staffdisctext = row.getValue(80);
		cons = row.getValue(81);
		constext = row.getValue(82);
		shar = row.getValue(83);
		shartext1 = row.getValue(84);
		shartext2 = row.getValue(85);
		revpol = row.getValue(86);
		revpoltext = row.getValue(87);
		revform = row.getValue(88);
		revformtext = row.getValue(89);
		creform = row.getValue(90);
		creformtext = row.getValue(91);
		refer = row.getValue(92);
		refertext = row.getValue(93);
		referdepttext = row.getValue(94);
		others = row.getValue(95);

		slDays = row.getValue(96);
		labDept = row.getValue(97);
		patInv = row.getValue(98);
		labDeptRemark = row.getValue(99);
		rptPolice = row.getValue(100);
		rptIod = row.getValue(101);

		Narrative_followup = row.getValue(102);
		Cause_followup = row.getValue(103);
		ActionDone_followup = row.getValue(104);
		ActionTaken_followup = row.getValue(105);
		Narrative_umdm = row.getValue(106);
		Cause_umdm = row.getValue(107);
		ActionDone_umdm = row.getValue(108);
		ActionTaken_umdm = row.getValue(109);
	}
}

// set edit narrative textarea value based on rptSts
if (("1".equals(rptSts) || "14".equals(rptSts)|| "11".equals(rptSts) || "12".equals(rptSts)) || (IsResponsibleUMDM && ("2".equals(rptSts)))) {
	if (((IsStaffIncident && !"11".equals(rptSts)) && IsOshIcn) || (IsMedicationIncident && IsPharmacy)) {
		editNarrative = PiReportDB.omitNull(Narrative_OSHICN);
		editCause = PiReportDB.omitNull(Cause_OSHICN);
		editActionDone = PiReportDB.omitNull(ActionDone_OSHICN);
		editActionTaken = PiReportDB.omitNull(ActionTaken_OSHICN);
		isAllowOshIcnFlwupStatus = true;
	}
	else {
		editNarrative = PiReportDB.omitNull(Narrative);
		editCause = PiReportDB.omitNull(Cause);
		editActionDone = PiReportDB.omitNull(ActionDone);
		editActionTaken = PiReportDB.omitNull(ActionTaken);
		editNarrative_followup = PiReportDB.omitNull(Narrative_followup);
		editCause_followup = PiReportDB.omitNull(Cause_followup);
		editActionDone_followup = PiReportDB.omitNull(ActionDone_followup);
		editActionTaken_followup = PiReportDB.omitNull(ActionTaken_followup);
		editNarrative_umdm = PiReportDB.omitNull(Narrative_umdm);
		editCause_umdm = PiReportDB.omitNull(Cause_umdm);
		editActionDone_umdm = PiReportDB.omitNull(ActionDone_umdm);
		editActionTaken_umdm = PiReportDB.omitNull(ActionTaken_umdm);
		isAllowFlwupStatus = true;
	}
}
else if ("2".equals(rptSts)) {
	editNarrative = PiReportDB.omitNull(Narrative_ADMIN);
	editCause = PiReportDB.omitNull(Cause_ADMIN);
	editActionDone = PiReportDB.omitNull(ActionDone_ADMIN);
	editActionTaken = PiReportDB.omitNull(ActionTaken_ADMIN);
}
else if ("3".equals(rptSts)) {
	editNarrative = PiReportDB.omitNull(Narrative_PI);
	editCause = PiReportDB.omitNull(Cause_PI);
	editActionDone = PiReportDB.omitNull(ActionDone_PI);
	editActionTaken = PiReportDB.omitNull(ActionTaken_PI);
}
%>

<%--  Follow up Show Incident Report--%>
<div>

<a href="#" class="IncidentReport" onclick="showhide(0, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', 'Incident Report - <%=incidentDesc%> (<%=reportStatusDesc%>) -', 'Incident Report - <%=incidentDesc%> (<%=reportStatusDesc%>)+');return false;">
	<u><span style="font-size:22px;color:#000000;" id="rr_showhidelink_0" class="visible">Incident Report - <%=incidentDesc%> (<%=reportStatusDesc%>) -</span></u>
</a>
<br/>

<span id="rr_hideobj_0">

<div style="border:1px solid black">
		<font color="blue" size="3"><b>Basic Information</b></font>
		<br/>
		<%if (ConstantsServerSide.isTWAH()) { %>
		<br/>
		<%} %>

<%
	ArrayList flwUpDialogBasicInfo = PiReportDB.fetchReportFlwUpDialogBasicInfo(pirID);
	if (flwUpDialogBasicInfo.size() > 0) {
		String dutyMgrName = null;
		row = (ReportableListObject) flwUpDialogBasicInfo.get(0);
		dutyMgrName = row.getValue(8);
		if (dutyMgrName.isEmpty()) {
			dutyMgrName = "";
		}
		else {
			dutyMgrName = StaffDB.getStaffName(row.getValue(8));
		}
%>
		&nbsp;&nbsp;&nbsp;&nbsp;<font color="green" size="2"><b>Report Person</b></font><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Name : <%=row.getValue(0)%><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Position : <%=row.getValue(1)%><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Department : <%=row.getValue(2)%><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Department Head : <%=StaffDB.getStaffName(row.getValue(7))%><br/>
		<%if (ConstantsServerSide.isHKAH()) { %>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Submitted to Department Head : <%=StaffDB.getStaffName(row.getValue(14))%><br/>
		<%} else { %>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Submitted to Department Head for following up : <%=StaffDB.getStaffName(row.getValue(14))%><br/>
		<%} %>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Submitted to Duty Manager / Deputy Department Head : <%=dutyMgrName%><br/>
		<% if (ConstantsServerSide.isHKAH()) { %>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Near Miss ? <%if ("1".equals(row.getValue(13))) {%><font color="red">Yes</font><%} else { %><font color="green">No</font><%} %><br/>
		<%} %>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Is it a Sentinel Event ? <%if ("1".equals(row.getValue(9))) {%><font color="red">Yes</font><%} else { %><font color="green">No</font><%} %><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=row.getValue(11)%><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;<font color="green" size="2"><b>Incident Information</b></font><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date of Occurrence : <%=row.getValue(3)%><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Time of Occurrence : <%=row.getValue(4)%><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Place of Occurrence : <%=row.getValue(5)%><%if ("Others".equals(row.getValue(5)) || "La Rue".equals(row.getValue(5))) {%><%=" / " + row.getValue(12)%><%}%><br/>
		<br/>
<%
	}
%>

		<font color="blue" size="3"><b>Involving Person</b></font>
		<br/>
		<%if (ConstantsServerSide.isTWAH()) { %>
		<br/>
		<%} %>

		<table border="0">
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td><table border="0">
<%
	ArrayList flwUpDialogInvolvePerson = PiReportDB.fetchReportFlwUpDialogInvlovePerson(pirID, "is_patient");
	if (flwUpDialogInvolvePerson.size() > 0) {
%>
			<tr><td>
				<font color="green" size="2"><b>Involving Person-Patient Info</b></font>
			</td></tr>

			<tr>
				<td>Pat No</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Name</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Sex</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Age</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>DOB</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Physician</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Diagnosis</td>
			</tr>
<%
		for (int i = 0; i < flwUpDialogInvolvePerson.size(); i++) {
			row = (ReportableListObject) flwUpDialogInvolvePerson.get(i);
%>
			<tr>
				<td><%=row.getValue(0)%></td><td></td><td><%=row.getValue(1)%></td><td></td><td><%=row.getValue(2)%></td><td></td><td><%=row.getValue(3)%></td><td></td><td><%=row.getValue(4)%></td><td></td><td><%=row.getValue(5)%></td><td></td><td><%=row.getValue(6)%></td>
			</tr>
<%
		}
	}

	flwUpDialogInvolvePerson = PiReportDB.fetchReportFlwUpDialogInvlovePerson(pirID, "is_staff");
	if (flwUpDialogInvolvePerson.size() > 0) {
%>
			<tr><td>
				<font color="green" size="2"><b>Involving Person-Staff Info</b></font>
			</td></tr>
			<tr><td>Staff No</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Hospital No</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Name</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Position</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Department</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Sex</td></tr>

<%
		for (int i = 0; i < flwUpDialogInvolvePerson.size(); i++) {
			row = (ReportableListObject) flwUpDialogInvolvePerson.get(i);
%>
			<tr>
				<td><%=row.getValue(0)%></td><td></td><td><%=row.getValue(1)%></td><td></td><td><%=row.getValue(2)%></td><td></td><td><%=row.getValue(3)%></td><td></td><td><%=row.getValue(4)%></td><td></td><td><%=row.getValue(5)%></td>
			</tr>
<%
		}
	}

	flwUpDialogInvolvePerson = PiReportDB.fetchReportFlwUpDialogInvlovePerson(pirID, "is_visitor_relative");
	if (flwUpDialogInvolvePerson.size() > 0) {
%>
			<tr><td>
				<font color="green" size="2"><b>Involving Person-Visitor/Relatives Info</b></font>
			</td></tr>
			<tr><td>Hospital No</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Staff No</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Visitor/Relatives Name</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Relationship</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Contact Phone No.</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Contact Address</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Remark</td></tr>
<%
		for (int i = 0; i < flwUpDialogInvolvePerson.size(); i++) {
			row = (ReportableListObject) flwUpDialogInvolvePerson.get(i);
%>
			<tr>
				<td><%=row.getValue(0)%></td><td></td><td><%=row.getValue(1)%></td><td></td><td><%=row.getValue(2)%></td><td></td><td><%=row.getValue(3)%></td><td></td>
				<td><%=row.getValue(5)%></td><td></td><td><%=row.getValue(6)%></td><td></td><td><%=row.getValue(4)%></td>
			</tr>
<%
		}
	}

	flwUpDialogInvolvePerson = PiReportDB.fetchReportFlwUpDialogInvlovePerson(pirID, "is_other");
	if (flwUpDialogInvolvePerson.size() > 0) {
%>
			<tr><td>
				<font color="green" size="2"><b>Involving Person- Others Info</b></font>
			</td></tr>
			<tr><td>Status</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Name</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Contact Phone No.</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Contact Address</td><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Remark</td></tr>
<%
		for (int i = 0; i < flwUpDialogInvolvePerson.size(); i++) {
			row = (ReportableListObject) flwUpDialogInvolvePerson.get(i);
%>
			<tr>
				<td><%=row.getValue(0)%></td><td></td><td><%=row.getValue(1)%></td><td></td><td><%=row.getValue(3)%></td><td></td><td><%=row.getValue(4)%></td><td></td><td><%=row.getValue(2)%></td>
			</tr>
<%
		}
	}
%>
			</table>
			</td></tr>
		</table>

		<br/>

		<font color="blue" size="3"><b>Incident Reporting</b></font>
		<br/>
		<%if (ConstantsServerSide.isTWAH()) { %>
		<br/>
		<%} %>

<%
	ArrayList flwUpDialogreportMst = PiReportDB.fetchReportFlwUpDialogReportMst(pirID);
	if (flwUpDialogreportMst.size() > 0) {
		for (int i = 0; i < flwUpDialogreportMst.size(); i++) {
			row = (ReportableListObject) flwUpDialogreportMst.get(i);
%>

			&nbsp;&nbsp;&nbsp;&nbsp;<font color="green" size="2"><b><%=row.getValue(2)%></b></font><br/>
<%
			// 28-11-2017 for med parent title desc
			parentDesc = "";
			grpID = row.getValue(1);
			//

			ArrayList flwUpDialogreportDtl = PiReportDB.fetchReportFlwUpDialogReportDtl(pirID, grpID);
			for (int j = 0; j < flwUpDialogreportDtl.size(); j++) {
				row = (ReportableListObject) flwUpDialogreportDtl.get(j);
				if (flwUpDialogreportDtl.size() > 0) {
					// 26032018 if aatachment, display "See "Incident Report Content"
					if ("Attachment:".equals(row.getValue(0))) {
						outVal = "See Report Detail";
					} else {
						outVal = row.getValue(1);
					}


					if ("follow_up".equals(row.getValue(2))) {
						semiColon = " ";
%>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=row.getValue(0)%><br/>
					<table border=0>
						<tr>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
							<td style="table-layout:fixed;width:920px"><pre><%=parseTextArea(outVal)%></pre><br/></td></tr>
<%
						if ("284".equals(row.getValue(3)) || ("285".equals(row.getValue(3))) || ("286".equals(row.getValue(3))) || ("287".equals(row.getValue(3)))) {
%>
						<tr>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
							<td>
								<span id="rr_showobj_<%=row.getValue(3)%>" style="display:inline">
								</span>
							</td>
						</tr>
<%
						}
%>
					</table>
<%
					}
					else {
//						semiColon = " : ";

						//28-11-2017 for med parent title desc
						if (PiReportDB.hasParentDesc(grpID)) {
							hasParentDesc = true;
							if (!parentDesc.equals(row.getValue(5))) {
								parentDesc = row.getValue(5);
%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=parentDesc%><br/>
<%
							} else {
//								hasParentDesc = false;
							}
						}

						if (row.getValue(0).indexOf(":") > 0) {
							semiColon = " ";
						}
						else {
							semiColon = " : ";
						}


						if ("checked".equals(outVal)) {
							if (hasParentDesc) {
%>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%
							}
%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=row.getValue(0)%><br/>
<%
						}
						else {
							// show attachment link - 314, 305, 435
							if ("314".equals(row.getValue(3)) || "305".equals(row.getValue(3)) || "435".equals(row.getValue(3))) {
%>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<jsp:include page="../common/document_list.jsp">
							<jsp:param name="moduleCode" value="pireport" />
							<jsp:param name="keyID" value="<%=pirID%>" />
							<jsp:param name="docIDs" value="<%=outVal%>" />
							<jsp:param name="separator" value="" />
						</jsp:include>
<%
							}
							else {
%>
<%
								outValTemp = row.getValue(0);

								if (outValTemp.contains("__")) {
									//outValTemp = "Heart Rate: __ / min";
									outValTemp2 = outValTemp.substring(0, outValTemp.indexOf("__"));
									outValTemp3 = outValTemp.substring(outValTemp.indexOf("_ ") + 1);
%>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=outValTemp2 + semiColon + StringEscapeUtils.escapeHtml(outVal) + outValTemp3%><br/>
<%
								} else {
									if (hasParentDesc) {
%>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%
									}
%>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=row.getValue(0) + semiColon + StringEscapeUtils.escapeHtml(outVal)%><br/>
<%
								}
							}
						}
					}
				}
			}
		}
	}
%>
<br/>

<%if (ConstantsServerSide.isHKAH()) { %>
<font color="blue" size="3"><b>Duty Manager / Deputy Department Head</b></font>
<br/>
<%	if (ConstantsServerSide.isTWAH()) { %>
<br/>
<%	} %>

<table border = "0" style="width:1000px">
<tr>
	<td></td>
	<td>
	<table border="0" style="width:900px">

		<tr><td>
			<font color="green" size="2"><b>INTERIM ACTION TAKEN:</b></font>
		</td></tr>
		<tr><td>
			<table border="0" style="width:900px">
			<tr>
	<%if (IsResponsibleUMDM && isAllowFlwupStatus) { %>
				<td><textarea name="narrative_umdm" rows="7" cols="174"><%=parseString(editNarrative_umdm) %></textarea></td>
	<%} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style="table-layout:fixed;width:900px">
					<pre><%=parseTextArea(Narrative_umdm)%></pre>
					<input type="hidden" name="narrative_umdm" value="<%=parseTextArea(Narrative_umdm)%>">
				</td>
	<%} %>
			</tr>
			</table>
		</td></tr>
	</table>
	</td>
</tr>
</table>
<br/>
<%} %>

<font color="blue" size="3"><b><%if (ConstantsServerSide.isHKAH()) {%>Department Head<%} else {%>Dept Head/Duty Manager<%} %></b></font>
<br/>
<%if (ConstantsServerSide.isTWAH()) { %>
<br/>
<%} %>

<table border="0" style="width:1000px">
<tr>
	<td></td>
	<td>
	<table border="0" style="width:900px">

		<tr><td>
			<font color="green" size="2"><b>NARRATIVE DESCRIPTION OF OCCURENCE:</b></font>
		</td></tr>
		<tr><td>
			<table border="0" style="width:900px">
			<tr>
	<%if ((IsResponsibleDHead || (ConstantsServerSide.isTWAH() && (IsResponsibleUMDM || IsResponsibleFlwUp))) && isAllowFlwupStatus) { %>
				<td><textarea name="narrative" rows="7" cols="174"><%=parseString(editNarrative) %></textarea></td>
	<%} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style="table-layout:fixed;width:900px">
					<pre><%=parseTextArea(Narrative)%></pre>
					<input type="hidden" name="narrative" value="<%=parseTextArea(Narrative)%>">
				</td>
	<%} %>
			</tr>
			</table>
		</td></tr>

		<tr><td>
			<font color="green" size="2"><b>WHAT CAUSED THIS OCCURENCE?:</b></font>
		</td></tr>
		<tr><td>
			<table border="0" style="width:700px">
			<tr>
	<%if ((IsResponsibleDHead || (ConstantsServerSide.isTWAH() && (IsResponsibleUMDM || IsResponsibleFlwUp))) && isAllowFlwupStatus) { %>
				<td><textarea name="cause" rows="7" cols="174"><%=parseString(editCause) %></textarea></td>
	<%} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style="table-layout:fixed;width:900px">
					<pre><%=parseTextArea(Cause)%></pre>
					<input type="hidden" name="cause" value="<%=parseTextArea(Cause)%>">
				</td>
	<%} %>
			</tr>
			</table>
		</td></tr>

		<tr><td>
			<font color="green" size="2"><b>WHAT ACTION(S) SHOULD OR COULD HAVE BEEN DONE TO PREVENT THIS OCCURENCE OR A REPEAT?:</b></font>
		</td></tr>
		<tr><td>
			<table border="0" style="width:700px">
			<tr>
	<%if ((IsResponsibleDHead || (ConstantsServerSide.isTWAH() && (IsResponsibleUMDM || IsResponsibleFlwUp))) && isAllowFlwupStatus) { %>
				<td><textarea name="actiondone" rows="7" cols="174"><%=parseString(editActionDone) %></textarea></td>
	<%} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style="table-layout:fixed;width:900px">
					<pre><%=parseTextArea(ActionDone)%></pre>
					<input type="hidden" name="actiondone" value="<%=parseTextArea(ActionDone)%>">
				</td>
	<%} %>
			</tr>
			</table>
		</td></tr>

		<tr><td>
			<font color="green" size="2"><b>
		<%if (ConstantsServerSide.isHKAH()) {%>
			DEPT HEAD FOLLOW UP:
		<%} else if (ConstantsServerSide.isTWAH()) { %>
			YOUR IMMEDIATE ACTION TAKEN:
		<%} %>
			</b></font>
		</td></tr>
		<tr><td>
		<table border="0">
			<tr><td>
				<table border="0">
		<%if (ConstantsServerSide.isHKAH()) {	%>
			<%if ((IsResponsibleDHead || (ConstantsServerSide.isTWAH() && (IsResponsibleUMDM || IsResponsibleFlwUp))) && isAllowFlwupStatus) { %>

					<tr>
						<td><input type="checkbox" name="staffedu" value="1" <%if ("1".equals(staffedu)) {%>checked<%} %>> Staff education held in
						<input type="text" name="staffedutext" value="<%=staffedutext%>"/> (when? e.g. quarter 3 of 2014 or Feb 2014) </td>
					</tr>
					<tr>
						<td><input type="checkbox" name="staffdisc" value="1" <%if ("1".equals(staffdisc)) {%>checked<%} %>> Staff disciplinary action in
						<input type="text" name="staffdisctext" value="<%=staffdisctext%>"/> (when?) </td>
					</tr>
					<tr>
						<td><input type="checkbox" name="cons" value="1" <%if ("1".equals(cons)) {%>checked<%} %>> Consultation held in
						<input type="text" name="constext" value="<%=constext%>"/> (when?) </td>
					</tr>
					<tr>
						<td><input type="checkbox" name="shar" value="1" <%if ("1".equals(shar)) {%>checked<%} %>> Sharing of incident at
						<input type="text" name="shartext1" value="<%=shartext1%>"/> (meeting or occasion) in
						<input type="text" name="shartext2" value="<%=shartext2%>"/> (when?) </td>
					</tr>
					<tr>
						<td><input type="checkbox" name="revpol" value="1" <%if ("1".equals(revpol)) {%>checked<%} %>> Revision of policy
					</tr>
					<tr>
						<td><input type="checkbox" name="revform" value="1" <%if ("1".equals(revform)) {%>checked<%} %>> Revision of form
					</tr>
					<tr>
						<td><input type="checkbox" name="creform" value="1" <%if ("1".equals(creform)) {%>checked<%} %>> Creation of new form
					</tr>
					<tr>
						<td><input type="checkbox" name="refer" value="1" <%if ("1".equals(refer)) {%>checked<%} %>> Refer to
						<input type="text" name="referdepttext" value="<%=referdepttext%>"/> (which) Department in
						<input type="text" name="refertext" value="<%=refertext%>"/> (when?) </td>
					</tr>
					<tr>
						<td><input type="checkbox" name="others" value="1" <%if ("1".equals(others)) {%>checked<%} %>> Others
					</tr>
			<%} else { %>
				<%if ("1".equals(staffedu)) {	%>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>Staff education held in <%=staffedutext%></td>
					</tr>
				<%} %>
				<% if ("1".equals(staffdisc)) {	%>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>Staff disciplinary action in <%=staffdisctext%></td>
					</tr>
				<%} %>
				<%if ("1".equals(cons)) { %>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>Consultation held in <%=constext%></td>
					</tr>
				<%} %>
				<%if ("1".equals(shar)) { %>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>Sharing of incident at <%=shartext1 + " " %> (meeting or occasion) in <%=shartext2%></td>
					</tr>
				<%} %>
				<%if ("1".equals(revpol)) { %>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>Revision of policy</td>
					</tr>
				<%} %>
				<% if ("1".equals(revform)) { %>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>Revision of form</td>
					</tr>
				<%} %>
				<% if ("1".equals(creform)) { %>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>Creation of new form</td>
					</tr>
				<%} %>
				<% if ("1".equals(refer)) { %>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>Refer to <%=referdepttext + " " %> Department in <%=refertext%></td>
					</tr>
				<%} %>
				<% if ("1".equals(others)) { %>
					<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>Others :</td>
					</tr>
				<%} %>
			<%} %>
		<%} %>
					<tr>
	<%if ((IsResponsibleDHead || (ConstantsServerSide.isTWAH() && (IsResponsibleUMDM || IsResponsibleFlwUp))) && isAllowFlwupStatus) { %>
						<td><textarea name="actiontaken" rows="7" cols="174"><%=parseString(editActionTaken) %></textarea></td>
	<%} else { %>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td style="table-layout:fixed;width:900px">
							<pre><%=parseTextArea(ActionTaken)%></pre>
							<input type="hidden" name="actiontaken" value="<%=parseTextArea(ActionTaken)%>">
						</td>
	<%} %>
					</tr>
				</table>
			</td></tr>
		</table>
	</table>
	</td>
</tr>
</table>
<br/>

<%if (ConstantsServerSide.isHKAH()) { %>
<font color="blue" size="3"><b>Department Head for following up</b></font>
<br/>
<%	if (ConstantsServerSide.isTWAH()) { %>
<br/>
<%	} %>

<table border="0" style="width:1000px">
<tr>
	<td></td>
	<td>
	<table border="0" style="width:900px">

		<tr><td>
			<font color="green" size="2"><b>NARRATIVE DESCRIPTION OF OCCURENCE:</b></font>
		</td></tr>
		<tr><td>
			<table border="0" style="width:900px">
			<tr>
	<%if (IsResponsibleFlwUp && isAllowFlwupStatus) { %>
				<td><textarea name="narrative_followup" rows="7" cols="174"><%=parseString(editNarrative_followup) %></textarea></td>
	<%} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style="table-layout:fixed;width:900px">
					<pre><%=parseTextArea(Narrative_followup)%></pre>
					<input type="hidden" name="narrative_followup" value="<%=parseTextArea(Narrative_followup)%>">
				</td>
	<%} %>
			</tr>
			</table>
		</td></tr>

		<tr><td>
			<font color="green" size="2"><b>WHAT CAUSED THIS OCCURENCE?:</b></font>
		</td></tr>
		<tr><td>
			<table border="0" style="width:700px">
			<tr>
	<%if (IsResponsibleFlwUp && isAllowFlwupStatus) { %>
				<td><textarea name="cause_followup" rows="7" cols="174"><%=parseString(editCause_followup) %></textarea></td>
	<%} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style="table-layout:fixed;width:900px">
					<pre><%=parseTextArea(Cause_followup)%></pre>
					<input type="hidden" name="cause_followup" value="<%=parseTextArea(Cause_followup)%>">
				</td>
	<%} %>
			</tr>
			</table>
		</td></tr>

		<tr><td>
			<font color="green" size="2"><b>WHAT ACTION(S) SHOULD OR COULD HAVE BEEN DONE TO PREVENT THIS OCCURENCE OR A REPEAT?:</b></font>
		</td></tr>
		<tr><td>
			<table border="0" style="width:700px">
			<tr>
	<%if (IsResponsibleFlwUp && isAllowFlwupStatus) { %>
				<td><textarea name="actiondone_followup" rows="7" cols="174"><%=parseString(editActionDone_followup) %></textarea></td>
	<%} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style="table-layout:fixed;width:900px">
					<pre><%=parseTextArea(ActionDone_followup)%></pre>
					<input type="hidden" name="actiondone_followup" value="<%=parseTextArea(ActionDone_followup)%>">
				</td>
	<%} %>
			</tr>
			</table>
		</td></tr>

		<tr><td>
			<font color="green" size="2"><b>
		<%if (ConstantsServerSide.isHKAH()) {%>
			DEPT HEAD FOLLOW UP:
		<%} else if (ConstantsServerSide.isTWAH()) { %>
			YOUR IMMEDIATE ACTION TAKEN:
		<%} %>
			</b></font>
		</td></tr>
		<tr><td>
			<table border="0" style="width:700px">
			<tr>
	<%if (IsResponsibleFlwUp && isAllowFlwupStatus) { %>
				<td><textarea name="actiontaken_followup" rows="7" cols="174"><%=parseString(editActionTaken_followup) %></textarea></td>
	<%} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style="table-layout:fixed;width:900px">
					<pre><%=parseTextArea(ActionTaken_followup)%></pre>
					<input type="hidden" name="actiontaken_followup" value="<%=parseTextArea(ActionTaken_followup)%>">
				</td>
	<%} %>
			</tr>
			</table>
		</td></tr>
	</table>
	</td>
</tr>
</table>
<br/>
<%} %>

<%
if (IsStaffIncident) {
%>
	<font color="blue" size="3"><b>OSH/ICN</b></font>
	<br/>
	<%if (ConstantsServerSide.isTWAH()) { %>
	<br/>
	<%} %>

	<table border = "0" style="width:1000px">
	<tr>
	<td>	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;	</td>
	<td>
		<table border=0>
<%		if (("33".equals(incidentType) || "65".equals(incidentType) || "64".equals(incidentType) || "79".equals(incidentType) || PiReportDB.IsVisitorBBF(pirID)) && IsOshIcn && "1".equals(rptSts)) { %>
			<tr><td valign="top" ><font color="green" size="2"><b>INJURY TYPE:</b></font></td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="contamin" value="1" <%if ("1".equals(contamin)) {%>checked<%} %>> Contaminated Sharp Injury</td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="noncontamin" value="1" <%if ("1".equals(noncontamin)) {%>checked<%} %>> Non-contaminated Sharp Injury</td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="bodyfluexp" value="1" <%if ("1".equals(bodyfluexp)) {%>checked<%} %>> Body Fluid Exposure</td></tr>

			<tr><td valign="top" ><font color="green" size="2"><b>ASSESEMENT OF INJURY:</b></font></td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="noaffect" value="1" <%if ("1".equals(noaffect)) {%>checked<%} %>> No Affect</td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="noharm" value="1" <%if ("1".equals(noharm)) {%>checked<%} %>> Caused No Harm</td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="tempharm" value="1" <%if ("1".equals(tempharm)) {%>checked<%} %>> Caused Temporary Harm</td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="permharm" value="1" <%if ("1".equals(permharm)) {%>checked<%} %>> Caused Permanent Harm</td></tr>
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="death" value="1" <%if ("1".equals(death)) {%>checked<%} %>> Causing Death</td></tr>
			<tr></tr>
			<%if ("79".equals(incidentType)) { %>
			<tr><td>Sick Leave Days :&nbsp;<input type="text" name="slDays" value="<%=slDays%>" size=5/></td></tr>
			<tr>
				<td>Reported to Labour Department
					<input type="radio" name="labDept" value="0" <%if ("0".equals(labDept) || "".equals(labDept)) {%>checked<%} %>>&nbsp;<font color="red">Yes</font>
					<input type="radio" name="labDept" value="1" <%if ("1".equals(labDept)) {%>checked<%} %>>&nbsp;<font color="green">No</font>
				</td>
			</tr>
			<tr>
				<td>Remark :<input type="text" name=labDeptRemark value="<%=labDeptRemark %>" size="150"></td>
			</tr>
				<td>Confused patient involved
					<input type="radio" name="patInv" value="0" <%if ("0".equals(patInv) || "".equals(patInv)) {%>checked<%} %>>&nbsp;<font color="red">Yes</font>
					<input type="radio" name="patInv" value="1" <%if ("1".equals(patInv)) {%>checked<%} %>>&nbsp;<font color="green">No</font>
				</td>
			</tr>
			<tr>
				<td>Reported to Police
					<input type="radio" name="rptPolice" value="0" <%if ("0".equals(rptPolice)) {%>checked<%} %>>&nbsp;<font color="red">Yes</font>
					<input type="radio" name="rptPolice" value="1" <%if ("1".equals(rptPolice)|| "".equals(rptPolice)) {%>checked<%} %>>&nbsp;<font color="green">No</font>
				</td>
			</tr>
			<tr>
				<td>Reported to IOD
					<input type="radio" name="rptIod" value="0" <%if ("0".equals(rptIod)) {%>checked<%} %>>&nbsp;<font color="red">Yes</font>
					<input type="radio" name="rptIod" value="1" <%if ("1".equals(rptIod) || "".equals(rptIod)) {%>checked<%} %>>&nbsp;<font color="green">No</font>
				</td>
			</tr>
			<%} %>
		<%} else { %>
			<tr><td>
				<font color="green" size="2"><b>INJURY TYPE:</b></font>
			</td></tr>
			<tr><td>
				<table border="0">
					<%if ("1".equals(contamin)) {%>
						<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Contaminated Sharp Injury</td></tr>
					<%}%>
					<%if ("1".equals(noncontamin)) {%>
						<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Non-contaminated Sharp Injury</td></tr>
					<%}%>
					<%if ("1".equals(bodyfluexp)) {%>
						<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Body Fluid Exposure</td></tr>
					<%}%>
				</table>
			</td></tr>
			<tr><td>
				<font color="green" size="2"><b>ASSESEMENT OF INJURY:</b></font>
			</td></tr>
			<tr><td>
				<table border="0">
					<%if ("1".equals(noaffect)) {%>
						<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>No Affect</td></tr>
					<%}%>
					<%if ("1".equals(noharm)) {%>
						<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Caused No Harm</td></tr>
					<%}%>
					<%if ("1".equals(tempharm)) {%>
						<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Caused Temporary Harm</td></tr>
					<%}%>
					<%if ("1".equals(permharm)) {%>
						<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Caused Permanent Harm</td></tr>
					<%}%>
					<%if ("1".equals(death)) {%>
						<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td><td>Causing Death</td></tr>
					<%}%>
				</table>
			</td></tr>
			<%if ("79".equals(incidentType)) { %>
			<tr>
				<td>Sick Leave Days : <%=slDays %></td>
			</tr>
			<tr>
				<td>Reported to Labour Department :<%if ("0".equals(labDept)) {%><font color="red">Yes</font><%} else {%><font color="green">No</font><%} %></td>
			</tr>
			<td>Remark : <%=labDeptRemark %>
			</td>
			<tr>
				<td>Confused patient involved :<%if ("0".equals(patInv)) {%><font color="red">Yes</font><%} else {%><font color="green">No</font><%} %></td>
			</tr>
			<tr>
				<td>Report to Police :<%if ("0".equals(rptPolice)) {%><font color="red">Yes</font><%} else {%><font color="green">No</font><%} %></td>
			</tr>
			<tr>
				<td>Report to IOD:<%if ("0".equals(rptIod)) {%><font color="red">Yes</font><%} else {%><font color="green">No</font><%} %></td>
			</tr>
			<%} %>
			<tr>
				<td><input type="hidden" name="contamin" value="<%=contamin%>"/></td>
				<td><input type="hidden" name="noncontamin" value="<%=noncontamin%>"/></td>
				<td><input type="hidden" name="bodyfluexp" value="<%=bodyfluexp%>"/></td>
				<td><input type="hidden" name="noaffect" value="<%=noaffect%>"/></td>
				<td><input type="hidden" name="noharm" value="<%=noharm%>"/></td>
				<td><input type="hidden" name="tempharm" value="<%=tempharm%>"/></td>
				<td><input type="hidden" name="permharm" value="<%=permharm%>"/></td>
				<td><input type="hidden" name="death" value="<%=death%>"/></td>
				<td><input type="hidden" name="slDays" value="<%=slDays%>"/></td>
				<td><input type="hidden" name="labDept" value="<%=labDept%>"/></td>
				<td><input type="hidden" name="labDeptRemark" value="<%=labDeptRemark%>"/></td>
				<td><input type="hidden" name="patInv" value="<%=patInv%>"/></td>
				<td><input type="hidden" name="rptPolice" value="<%=rptPolice%>"/></td>
				<td><input type="hidden" name="rptIod" value="<%=rptIod%>"/></td>
			</tr>
		<%} %>

			<tr><td>
				<font color="green" size="2"><b>NARRATIVE DESCRIPTION OF OCCURENCE:</b></font>
			</td></tr>
			<tr><td>
				<table border="0">
				<tr>
	<%if (isAllowOshIcnFlwupStatus) { %>
					<td><textarea name="narrative" rows="7" cols="174"><%=parseString(editNarrative) %></textarea></td>
	<%} else { %>

					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td style="table-layout:fixed;width:900px"><pre><%=parseTextArea(Narrative_OSHICN)%></pre></td>
	<%} %>
				</tr>
				</table>
			</td></tr>
			<tr><td>
				<font color="green" size="2"><b>WHAT CAUSED THIS OCCURENCE?:</b></font>
			</td></tr>
			<tr><td>
				<table border="0">
				<tr>
	<%if (isAllowOshIcnFlwupStatus) { %>
					<td><textarea name="cause" rows="7" cols="174"><%=parseString(editCause) %></textarea></td>
	<%} else { %>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td style="table-layout:fixed;width:900px"><pre><%=parseTextArea(Cause_OSHICN)%></pre></td>
	<%} %>
				</tr>
				</table>
			</td></tr>
			<tr><td>
				<font color="green" size="2"><b>WHAT ACTION(S) SHOULD OR COULD HAVE BEEN DONE TO PREVENT THIS OCCURENCE OR A REPEAT?:</b></font>
			</td></tr>
			<tr><td>
				<table border="0">
				<tr>
	<%if (isAllowOshIcnFlwupStatus) { %>
					<td><textarea name="actiondone" rows="7" cols="174"><%=parseString(editActionDone) %></textarea></td>
	<%} else { %>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td style="table-layout:fixed;width:900px"><pre><%=parseTextArea(ActionDone_OSHICN)%></pre></td>
	<%} %>
				</tr>
				</table>
			</td></tr>
			<tr><td>
				<font color="green" size="2"><b>YOUR IMMEDIATE ACTION TAKEN:</b></font>
			</td></tr>
			<tr><td>
				<table border="0">
				<tr>
	<%if (isAllowOshIcnFlwupStatus) { %>
					<td><textarea name="actiontaken" rows="7" cols="174"><%=parseString(editActionTaken) %></textarea></td>
	<%} else { %>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td style="table-layout:fixed;width:900px"><pre><%=parseTextArea(ActionTaken_OSHICN)%></pre></td>
	<%} %>
				</tr>
				</table>
			</td></tr>
		</table>
	</td>
	</tr>
	</table>
	<br/>
	<br/>
<%
}

if (IsMedicationIncident) {
%>
	<font color="blue" size="3"><b>Pharmacy</b></font>
	<br/>
	<%if (ConstantsServerSide.isTWAH()) { %>
	<br/>
	<%} %>

	<table border = "0" style="width:1000px">
	<tr>
	<td>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	</td>
	<td>
		<table border="0">
		<tr><td>
			<font color="green" size="2"><b>NARRATIVE DESCRIPTION OF OCCURENCE:</b></font>
		</td></tr>
		<tr><td>
			<table border="0">
			<tr>
	<%if (isAllowOshIcnFlwupStatus) { %>
					<td><textarea name="narrative" rows="7" cols="174"><%=parseString(editNarrative) %></textarea></td>
	<%} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style="table-layout:fixed;width:900px"><pre><%=parseTextArea(Narrative_OSHICN)%></pre></td>
	<%} %>
			</tr>
			</table>
		</td></tr>
		<tr><td>
			<font color="green" size="2"><b>WHAT CAUSED THIS OCCURENCE?:</b></font>
		</td></tr>
		<tr><td>
			<table border="0">
			<tr>
	<%if (isAllowOshIcnFlwupStatus) { %>
				<td><textarea name="cause" rows="7" cols="174"><%=parseString(editCause) %></textarea></td>
	<%} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style="table-layout:fixed;width:900px"><pre><%=parseTextArea(Cause_OSHICN)%></pre></td>
	<%} %>
			</tr>
			</table>
		</td></tr>
		<tr><td>
			<font color="green" size="2"><b>WHAT ACTION(S) SHOULD OR COULD HAVE BEEN DONE TO PREVENT THIS OCCURENCE OR A REPEAT?:</b></font>
		</td></tr>
		<tr><td>
			<table border="0">
			<tr>
	<%if (isAllowOshIcnFlwupStatus) { %>
				<td><textarea name="actiondone" rows="7" cols="174"><%=parseString(editActionDone) %></textarea></td>
	<%} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style="table-layout:fixed;width:900px"><pre><%=parseTextArea(ActionDone_OSHICN)%></pre></td>
	<%} %>
			</tr>
			</table>
		</td></tr>
		<tr><td>
			<font color="green" size="2"><b>YOUR IMMEDIATE ACTION TAKEN:</b></font>
		</td></tr>
		<tr><td>
			<table border="0">
			<tr>
	<%if (isAllowOshIcnFlwupStatus) { %>
				<td><textarea name="actiontaken" rows="7" cols="174"><%=parseString(editActionTaken) %></textarea></td>
	<%} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style="table-layout:fixed;width:900px"><pre><%=parseTextArea(ActionTaken_OSHICN)%></pre></td>
	<%} %>
			</tr>
			</table>
		</td></tr>
		<tr><td>
			<font color="green" size="2"><b>POSSIBLE CAUSE(S) OF MEDICATION INCIDENTS:</b></font><br>
		</td></tr>
		<tr><td>
			<table border=0>
<%
	// show only for medication errors
	if (isAllowOshIcnFlwupStatus && (("52".equals(incidentType) || "62".equals(incidentType)) && ("1".equals(rptSts) || "14".equals(rptSts)))) {
%>
		<tr><td><b>Possible cause(s) of medication incidents</b></td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="failurecomply" value="1" <%if ("1".equals(failurecomply)) {%>checked<%} %>> Failure to comply to established policies and procedures</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="samedrug" value="1" <%if ("1".equals(samedrug)) {%>checked<%} %>> Same drug with different strengths</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="inappabb" value="1" <%if ("1".equals(inappabb)) {%>checked<%} %>> Inappropriate abbreviation</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="ordermis" value="1" <%if ("1".equals(ordermis)) {%>checked<%} %>> Order misinterpreted</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="lasa" value="1" <%if ("1".equals(lasa)) {%>checked<%} %>> LASA (loo-alike-sound-alike drug names)</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="lapses" value="1" <%if ("1".equals(lapses)) {%>checked<%} %>> Lapses in individual performance</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="equipfailure" value="1" <%if ("1".equals(equipfailure)) {%>checked<%} %>> Equipment failure / malfunction (e.g. infusion pump, computer problem)</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="illegalhand" value="1" <%if ("1".equals(illegalhand)) {%>checked<%} %>> Illegible handwriting</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="miscal" value="1" <%if ("1".equals(miscal)) {%>checked<%} %>>  Miscalculation</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="systemflaw" value="1" <%if ("1".equals(systemflaw)) {%>checked<%} %>>  System flaw</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="Inadtrainstaff" value="1" <%if ("1".equals(Inadtrainstaff)) {%>checked<%} %>>  Inadequately trained staff</td></tr>
		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="othersfreetext" value="1" <%if ("1".equals(othersfreetext)) {%>checked<%} %>>  Others : (Free text - amble word counts)
			<input type="textfield" name="othersfreetextedit" value='<%=othersfreetextedit==null?"":othersfreetextedit%>' maxlength="100" size="100"/>
		</td></tr>
		<tr><td>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="relatedstaff" value="1" <%if ("1".equals(relatedstaff)) {%>checked<%} %>> Related staff counseled<br>
		</td></tr>
		<tr><td>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="sharestaff" value="1" <%if ("1".equals(sharestaff)) {%>checked<%} %>> Sharing of the incident to staff to learn from this done on
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="textfield" name="sharestaffdate" id="sharestaffdate" class="datepickerfield notEmpty" value='<%=sharestaffdate==null?"":sharestaffdate%>' maxlength="10" size="16"/>
		</td></tr>
		<tr><td><br></td></tr>
	<%} else { %>
		<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td>
		<%if ("1".equals(failurecomply)){%>
			Failure to comply to established policies and procedures<br>
		<%} %>
		<%if ("1".equals(samedrug)){%>
			Same drug with different strengths<br>
		<%} %>
		<%if ("1".equals(inappabb)){%>
			Inappropriate abbreviation<br>
		<%} %>
		<%if ("1".equals(ordermis)){%>
			Order misinterpreted<br>
		<%} %>
		<%if ("1".equals(lasa)){%>
			LASA (loo-alike-sound-alike drug names)<br>
		<%} %>
		<%if ("1".equals(lapses)){%>
			Lapses in individual performance<br>
		<%} %>
		<%if ("1".equals(equipfailure)){%>
			Equipment failure / malfunction (e.g. infusion pump, computer problem)<br>
		<%} %>
		<%if ("1".equals(illegalhand)){%>
			Illegible handwriting<br>
		<%} %>
		<%if ("1".equals(miscal)){%>
			Miscalculation<br>
		<%} %>
		<%if ("1".equals(systemflaw)){%>
			System flaw<br>
		<%} %>
		<%if ("1".equals(Inadtrainstaff)){%>
			Inadequately trained staff<br>
		<%} %>
		<%if ("1".equals(othersfreetext)){%>
			Others : (Free text - amble word counts) <%=" " + othersfreetextedit %><br>
		<%} %>
		<%if ("1".equals(relatedstaff)){%>
			Related staff counseled<br>
		<%} %>
		<%if ("1".equals(sharestaff)){%>
			Sharing of the incident to staff to learn from this done on <%=" " + sharestaffdate %><br>
		<%} %>
			</td>
			<td><input type="hidden" name="failurecomply" value="<%=failurecomply%>"/></td>
			<td><input type="hidden" name="samedrug" value="<%=samedrug%>"/></td>
			<td><input type="hidden" name="inappabb" value="<%=inappabb%>"/></td>
			<td><input type="hidden" name="ordermis" value="<%=ordermis%>"/></td>
			<td><input type="hidden" name="lasa" value="<%=lasa%>"/></td>
			<td><input type="hidden" name="lapses" value="<%=lapses%>"/></td>
			<td><input type="hidden" name="equipfailure" value="<%=equipfailure%>"/></td>
			<td><input type="hidden" name="illegalhand" value="<%=illegalhand%>"/></td>
			<td><input type="hidden" name="miscal" value="<%=miscal%>"/></td>
			<td><input type="hidden" name="systemflaw" value="<%=systemflaw%>"/></td>
			<td><input type="hidden" name="Inadtrainstaff" value="<%=Inadtrainstaff%>"/></td>
			<td><input type="hidden" name="othersfreetext" value="<%=othersfreetext%>"/></td>
			<td><input type="hidden" name="othersfreetextedit" value="<%=othersfreetextedit%>"/></td>
			<td><input type="hidden" name="relatedstaff" value="<%=relatedstaff%>"/></td>
			<td><input type="hidden" name="sharestaff" value="<%=sharestaff%>"/></td>
			<td><input type="hidden" name="sharestaffdate" value="<%=sharestaffdate%>"/></td>
		</tr>
	<%} %>
			</table>
		</td></tr>
		</table>
	</td></tr>
	</table>
	<br/>
	<br/>
<%
}
%>
<font color="blue" size="3"><b>Administrator</b></font>
<br/>
<%if (ConstantsServerSide.isTWAH()) { %>
<br/>
<%} %>

<table border="0">
<tr>
	<td>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	</td>
	<td>
	<table border="0">
		<tr><td>
		<%if (ConstantsServerSide.isTWAH()) { %>
		<b>
		<%} %>
		ADMIN REVIEWED ?
		<%if (ConstantsServerSide.isTWAH()) { %>
		</b>
		<%} %>
		</td></tr>
		<tr><td>
		<table border="0">
			<tr>
<%	if (IsReponsiblePerson && "2".equals(rptSts)) { %>
				<input type="radio" name="adminviewed" id="avyes" value="1" <%if ("1".equals(adminviewed)) {%>checked<%} %>>Yes
				<input type="radio" name="adminviewed" id="avno" value="0" <%if ("0".equals(adminviewed)) {%>checked<%} %>>No
<%	} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><%if ("1".equals(adminviewed)) {%>Yes<%} else {%>No<%}%></td>
<%	} %>
			</tr>
		</table>
		</td></tr>
		<tr><td>
		<%if (ConstantsServerSide.isTWAH()) { %>
		<b>
		<%} %>
		ADMIN COMMENT ?
		<%if (ConstantsServerSide.isTWAH()) { %>
		</b>
		<%} %>
		</td></tr>
		<tr><td>
		<table border="0">
			<tr>
<%	if (IsReponsiblePerson && "2".equals(rptSts)) { %>
				<input type="radio" name="admincomment" id="acyes" value="1" <%if ("1".equals(admincomment)) {%>checked<%} %>>Yes
				<input type="radio" name="admincomment" id="acno" value="0" <%if ("0".equals(admincomment)) {%>checked<%} %>>No
<%	} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><%if ("1".equals(admincomment)) {%>Yes<%} else {%>No<%}%></td>
<%	} %>
			</tr>
		</table>
		<tr><td>
		<%if (ConstantsServerSide.isTWAH()) { %>
		<b>
		<%} %>
		GENERAL COMMENTS:
		<%if (ConstantsServerSide.isTWAH()) { %>
		</b>
		<%} %>
		</td></tr>
		<tr><td>
		<table border="0">
			<tr>
<%	if (IsReponsiblePerson && "2".equals(rptSts)) { %>
				<td><textarea name="narrative" rows="7" cols="120"><%=parseString(editNarrative) %></textarea></td>
<%	} else { %>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td style="table-layout:fixed;width:900px"><pre><%=parseTextArea(Narrative_ADMIN)%></pre></td>
<%	} %>
			</tr>
		</table>
	</table>
	</td>
</tr>
</table>
<br>
<br/>
<%
	if (userBean.isAdmin() ||
		(IsPIManager && "3".equals(rptSts)) ||
		(ConstantsServerSide.isTWAH() && IsResponsibleUMDM && ("1".equals(rptSts) || "2".equals(rptSts))) ||
		((IsDHead || IsOshIcn || IsPharmacy || IsReponsiblePerson) && ("1".equals(rptSts) || "14".equals(rptSts) || "2".equals(rptSts) || "11".equals(rptSts) || "12".equals(rptSts)))
	) {
%>
	<%--  Follow up Entry--%>
	<table>
<%
		if ((!IsPIManager || IsReponsiblePerson || IsResponsibleUMDM) && ("1".equals(rptSts) || "11".equals(rptSts) || "12".equals(rptSts) || "14".equals(rptSts))) {
			if (ConstantsServerSide.isTWAH()) {
				%><tr><td align="center"><button onclick="return showconfirm('fu_save_flwup_dhead_1', 1);" class="btn-click">Save Only<br>(without submit)</button></td></tr><%
			} else {
				%><tr><td align="center">
					<button onclick="return showconfirm('fu_adm_flwup_comment', 1);" class="btn-click">Save Only</button>
					<button onclick="return showconfirm('fu_submit', 'submit');" class="btn-click">Save and Submit</button>
				</td></tr><%
			}
		}

		if ("2".equals(rptSts) && IsReponsiblePerson && ConstantsServerSide.isHKAH()) {
%>
		<tr><td><b>Further notice : (Ctrl+Left Click to multi select)</b></td></tr>
		<tr>
			<td><select name="toFurtherNoticeID" size="6" multiple id="selectfn">
<%
			// get all sentinel event person
			ArrayList flwUpDialogreportDtl = PiReportDB.fetchReportSentinelEventAllPerson(userBean, "furthernotice");
			// define the static array with no. of person

			for (int j = 0; j < flwUpDialogreportDtl.size(); j++) {
				row = (ReportableListObject) flwUpDialogreportDtl.get(j);
				if (flwUpDialogreportDtl.size() > 0) {
					if (!row.getValue(0).equals(userBean.getStaffID())) {
%>
					<option value="<%=row.getValue(2)%>"<%if (j == 0) {%>selected<%} %>><%=row.getValue(3)%></option>
<%
					}
				}
			}
%>
				</select>
			</td>
		</tr>
		<tr>
			<td><button onclick="return showconfirm('fu_furthernotice', 1);" class="btn-click">Send</button></td>
		</tr>
<%
		}
%>
	</table>
<%
}
%>

</div>

</span>
<span id="rr_showobj_0" style="display:inline"></span>
</div>

<br/>
<div>
<a href="#" class="FollowUpDialog" onclick="showhide(1, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', 'Follow Up Dialog -', 'Follow Up Dialog +');return false;">
	<u><span style="font-size:22px;color:#000000;" id="rr_showhidelink_1" class="visible"></span></u>
</a>
<br/>
<span id="rr_hideobj_1" style="display:none"><div style="border:1px solid black">
<%--  End Follow up Show Incident Report--%>

<%--  Follow up dialog --%>
<table border=1>
<%--  <tr><td>Date</td><td>Message Type</td><td>Status</td><td>From</td><td>To</td><td>Responsible Party</td><td>Due Date</td><td>Completed Date</td><td>Dialogue Content</td><td>Attachment</td></tr> --%>
<tr><td>Date</td><td>Message Type</td><td>Status</td><td>Responsible Party</td><td>From</td><td>To</td><td>Due Date</td><td>Completed Date</td><td>Dialogue Content</td><td>Attachment</td></tr>
<%
ArrayList flwUpDialog = PiReportDB.fetchReportFlwUpDialog(pirID);
if (flwUpDialog.size() > 0) {
%>
<%
	for (int i = 0; i < flwUpDialog.size(); i++) {
		row = (ReportableListObject) flwUpDialog.get(i);
%>

<%
		ArrayList flwUpDialogCCList = PiReportDB.fetchReportFlwUpDialogCCList(pirID, row.getValue(1));
		if (flwUpDialogCCList.size() > 0) {
			for (int j = 0; j < flwUpDialogCCList.size(); j++) {
				row2 = (ReportableListObject) flwUpDialogCCList.get(j);
				if (j == 0) {
					ccList = row2.getValue(1);
				}
				else {
					ccList = ccList + ", " + row2.getValue(1);
				}
			}
		}
		else {
			ccList = "";
		}

		// check double respond party
		if (row.getValue(11).isEmpty()) {
			RespPerson = row.getValue(7);
		}
		else {
			RespPerson = row.getValue(7) + ", " + row.getValue(11);
		}
		if (RespPerson == null) {
			RespPerson = "";
		}

%>
	<tr><td><%=row.getValue(4)%></td><td><%=row.getValue(2)%></td></tr><td><%=row.getValue(9)%></td><td><%=RespPerson%></td><td><%=StaffDB.getStaffName(row.getValue(3))%></td><td><%=ccList%></td><td><%=row.getValue(5)%></td><td><%=row.getValue(6)%></td>
<%
	// try to display larger dialog comment
	String dialogContent;
	dialogContent = row.getValue(8);
	if (dialogContent.length() > 100) {
%>
	<td>
		<%=dialogContent.substring(0, 45)%> <a href="JavaScript:newPopup('flwUpDialogContent.jsp?pirid=<%=pirID%>&contentid=<%=row.getValue(1)%>&contentType=flwupmsg');">more...</a>
	</td>
<%
	}
	else {
%>
	<td>
		<%=dialogContent%>
	</td>
<%
	}
%>



		<td>
			<jsp:include page="../common/document_list.jsp" flush="false">
			<jsp:param name="moduleCode" value="flwup" />
			<jsp:param name="keyID" value="<%=row.getValue(1) %>" />
			</jsp:include>
		</td>
	</tr>
<%
	}
}
%>
</table>
<%--  Follow up Entry--%>
<br/>
<span style="font-size:22px;color:#000000;">
	Follow up message entry (Not included in the incident report)
</span>
<table >
	<tr>
		<td>
			<select name="responseByIDAvailable" id="select1">
				<option value="">--Select Staff--</option>
					<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
						<jsp:param name="value" value="" />
						<jsp:param name="allowAll" value="Y" />
					</jsp:include>
			</select>
		</td>
		<td>

		</td>
		<td>
			<button id="add1"><bean:message key="button.add" /></button>
		</td>
		<td>
			<button id="remove1"><bean:message key="button.delete" /></button>
		</td>
		<td>
			<button onclick="return showconfirm('fu_send', 1);" class="btn-click">Send</button>
		</td>
	</tr>
	<tr>
		<td>
			<select name="toStaffID" size="5" multiple id="select2">
			</select>
		</td>
	</tr>
</table>
<div id=ShowflwUpStaffInfo2></div>
<div id="hiddenFlwUpStaffInfo" style="display:none;">
	<table border="0">
		<tr class="smallText">
			<td colspan="6"></td>
			<td class="" colspan="6"></td>
			<td></td>
			<td></td>
			<td></td>
			<td>
				<img style="cursor: pointer" src="../images/remove-button.gif" alt="Delete" class="removeFlwUpStaffInfo"/>
			</td>
		</tr>
		<tr class="smallText">
			<td colspan="6"></td>
			<td>Staff No</td>
			<td class="infoData" colspan="2">
				<input type="textfield" name="involveStaffNo" value="" maxlength="10" size="20" class="notEmpty referKey" keyType="fu_staff"/>
			</td>
			<td>Name</td>
			<td class="infoData" colspan="5">
				<input type="textfield" name="involveStaffName" value="" maxlength="100" size="70" class="" readonly/>
			</td>
			<td>
				<img style="cursor: pointer" src="../images/plus.gif" width="10" height="10" alt="Add" class="AddFlwUpStaffInfo"/>
			</td>
		</tr>
	</table>
</div>
<br/>
<table border="0">
	<tr>
		<td>Date : <input name='fuCrDate' type='textfield' class='datepickerfield' value="<%=DateTimeUtil.getCurrentDateTime()%>" maxlength="16"></td>
		<td>From : <input name='fuFrom' type='textfield' value="<%=StaffDB.getStaffFullName(userBean.getLoginID())%>" readonly></td>
		<td>Due Date : <input name='fuDueDate' type='textfield' class='datepickerfield'></td>
		<td>Completed Date : <input name='fuCompDate' type='textfield' class='datepickerfield'></td>
	</tr>
</table>

<table>
	<tr><td valign="top" >Dialogue Content : </td><td><textarea name="fuAction" rows="10" cols="174"></textarea></td></tr>
	<tr><td valign="top">Attachment : </td><td><input name='attach' type='file' value='Attachment' size=45 class="multi"></td></tr>
</table>
<br/>

</div></span>
<span id="rr_showobj_1" style="display:inline"></span>
</div>
<%--  END Follow up dialog --%>

<input type="hidden" name="incident_classification_desc" value="<%=incident_classification_desc%>"/>
<input type="hidden" name="rptsts" value="<%=rptSts%>"/>
<input type="hidden" name="respparty" value="<%=""%>"/>

<br>
<br/>
<br/>

<%-- End Follow up Entry--%>

<script language="javascript">

//keepAlive(5000);

	function showconfirm(cmd, stp) {
		$.prompt('Are you sure?',{
			buttons: { Ok: true, Cancel: false },
			callback: function(v,m,f){
				if (v ){
					submitAction2(cmd, stp);
				}
			},
			prefix:'cleanblue'
		});
		return false;
	}

	$().ready(function(){
		// set javascript for the new add comment
		$('#add1').click(function() {
			var options = $('#select1 option:selected');
			if (options.length == 1 && options[0].value != '') {
				return !$('#select1 option:selected').appendTo('#select2');
			} else {
				return false;
			}
		});
		$('#remove1').click(function() {
			return !$('#select2 option:selected').appendTo('#select1');
		});
		removeDuplicateItem('form1', 'responseByIDAvailable', 'toStaffID');
	});

	$(document).ready(function() {
		showInfoFlwUp('staff');
	});

	function submitAction2(cmd, stp) {
		//alert('submitAction2 fu');
		// followup to person\
		var personInfo = '';

		$('.ShowflwUpStaffInfo').each(function(index, value) {
			//alert($(this).children().size());


			if ($(this).children().size() > 0) {
				personInfo = '<input type="hidden" name="fuStaffNo" value="'+
									$(this).find('[name=involveStaffNo]').val()+'||'+
									$(this).find('[name=involveStaffName]').val()
									+((editAction)?('||'+$(this).find('[name=pir_ip_id]').val()):"")
								+'"/>';

				$(personInfo).appendTo('div#ShowflwUpStaffInfo');
			}
		});


		$('#select2 option').each(function(i) {
			$(this).attr("selected", "selected");
		});

		document.form1.command.value = cmd;

		$(window).unbind('beforeunload', windowOnClose);

		document.form1.submit();

		$.prompt('Processing..... Please wait.',{
			buttons: { }, prefix:'cleanblue'
		});
	}

	function showhide(i, hideobj, showobj, showhidelink, hidelink, showlink){
		var showelem = document.getElementById(showobj + i);
		var hideelem = document.getElementById(hideobj + i);
		var linkelem = document.getElementById(showhidelink + i);

		showelem.style.display=showelem.style.display=='none'?'inline':'none';
		hideelem.style.display=hideelem.style.display=='none'?'inline':'none';

		if (hideelem.style.display=='none'){
			linkelem.className="invisible";
			linkelem.innerHTML = showlink;
		} else {
			linkelem.className="visible";
			linkelem.innerHTML = hidelink;
		}
	}

	function removeEventflwup() {
		$('.removeFlwUpStaffInfo').unbind('click');
		$('.removeFlwUpStaffInfo').each(function() {
			$(this).click(function() {
			  if ($('div.ShowflwUpStaffInfo').length > 1) {
				$(this).parent().parent().parent().parent().parent().remove();
			}
			});
		});
	}

	function addEventflwup(target, type){
		$(target).each(function() {
			$(this).unbind('click');
			$(this).click(function() {
				showInfoFlwUp(type);
			});
		});
	}

	function showInfoFlwUp(type){
		var addBtn = '';
		if (type == 'staff'){
				Row = $('div#hiddenFlwUpStaffInfo').html();
				$('<div class="ShowflwUpStaffInfo" style="">'+Row+'</div>').appendTo('div#ShowflwUpStaffInfo');
				addBtn = '.AddFlwUpStaffInfo';
		}
		addEventflwup(addBtn, type);
		removeEventflwup();
		referKeyEvent();
	}

	// Popup window code
	function newPopup(url) {
		popupWindow = window.open(
			url,'popUpWindow','height=700,width=800,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
	}

</script>