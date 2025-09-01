<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%!
public class StaffInvolvement{
	String staffID;
	String type;
	String subType;
	String effectiveDate;
	public StaffInvolvement(String staffID,String type, String subType, String effectiveDate) {
		this.staffID = staffID;
		this.type = type;
		this.subType = subType;
		this.effectiveDate = effectiveDate;
	}
}

public boolean isStaffInvolvementSelected(String staffID,String type,String subType,ArrayList<StaffInvolvement> listOfStaffInvolvement) {
	boolean isInvolvementFound = false;
	for(StaffInvolvement si : listOfStaffInvolvement) {
		if (si.staffID.equals(staffID) && si.type.equals(type) && si.subType.equals(subType)) {
			isInvolvementFound = true;
			break;
		}
	}

	return isInvolvementFound;
}

public String getStaffInvolvementEffectiveDate(String staffID,ArrayList<StaffInvolvement> listOfStaffInvolvement) {
	String effectiveDate = "";
	for(StaffInvolvement si : listOfStaffInvolvement) {
		if (si.staffID.equals(staffID) && si.type.equals("memberships") && si.subType.equals("team20Date")) {
			effectiveDate=si.effectiveDate;
		}
	}

	return effectiveDate;
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

String hospitalName=null;
if (ConstantsServerSide.isHKAH()) {
	hospitalName = "Hong Kong Adventist Hospital - Stubbs Road";
}
if (ConstantsServerSide.isTWAH()) {
	hospitalName = "Hong Kong Adventist Hospital - Tsuen Wan";
}


String type = request.getParameter("type");

if (type != null && type.equals("staff")) {
	String staffID = request.getParameter("staffID");

	ArrayList record = ChapStaffDB.getStaffListByID(userBean, staffID);
	if (record.size() != 0) {
		ReportableListObject row = (ReportableListObject)record.get(0);
		staffID = row.getValue(2);
%>
<table border = "0" width='100%'>
	<tbody>
		<tr>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>Hospital Name&nbsp;</td><td class="infoData" style='font-size:14px;'><%=hospitalName%></td>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Department&nbsp;</td><td class="infoData" id='dept' style='font-size:14px;'><%=row.getValue(1)%></td>
		</tr>
		<tr>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Staff ID&nbsp;</td><td class="infoData"  style='font-size:14px;' id='staffID'><%=row.getValue(2)%></td>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>Staff Name&nbsp;</td><td class="infoData" colspan="2"  id='staffName' style='font-size:14px;'><%=row.getValue(3)%></td>
		</tr>
		<tr>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Staff Chinese Name&nbsp;</td><td class="infoData"  style='font-size:14px;' id='staffChineseName'></td>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>Gender&nbsp;</td><td class="infoData" colspan="2"  id='gender' style='font-size:14px;'></td>
		</tr>
		<tr>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Religion&nbsp;</td><td class="infoData"  style='font-size:14px;' id='religion'></td>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>Marital status&nbsp;</td><td class="infoData" colspan="2"  id='maritalStatus' style='font-size:14px;'></td>
		</tr>
		<tr>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Employment date&nbsp;</td><td class="infoData"  style='font-size:14px;' id='employmentDate'></td>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>Termination date&nbsp;</td><td class="infoData" colspan="2"  id='terminationDate' style='font-size:14px;'></td>
		</tr>
		<tr>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Photo&nbsp;</td><td class="infoData" colspan="3" style='font-size:14px;' id='photo'></td>
		</tr>
<%
	ArrayList involvementRecord = ChapStaffDB.getStaffInvolvement(staffID);
	ArrayList<StaffInvolvement> listOfStaffInvolvement = new ArrayList<StaffInvolvement>();
	if (involvementRecord.size() != 0) {
		for(int i = 0;i< involvementRecord.size();i++) {
			ReportableListObject involvementRow = (ReportableListObject)involvementRecord.get(i);
			String tempStaffID = involvementRow.getValue(0);
			String tempType = involvementRow.getValue(1);
			String tempSubType = involvementRow.getValue(2);
			String tempEffectiveDate = involvementRow.getValue(3);

			StaffInvolvement tempStaffInvolvement = new StaffInvolvement(tempStaffID,tempType,tempSubType,tempEffectiveDate);
			listOfStaffInvolvement.add(tempStaffInvolvement);
		}
	}


%>
		<tr>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Memberships&nbsp;</td>
			<td class='infoData' colspan="3">
				<input <%=(isStaffInvolvementSelected(staffID,"memberships","smallGroup",listOfStaffInvolvement)?"CHECKED":"") %> onclick='updateStaffInvolvement("<%=staffID%>","memberships","smallGroup")'  class='' style='width:25px; height:25px;' name='smallGroup' id='smallGroup' type='checkbox' value='smallGroup'/>SmallGroup&nbsp;
				<input <%=(isStaffInvolvementSelected(staffID,"memberships","adventistHealthClub",listOfStaffInvolvement)?"CHECKED":"") %> onclick='updateStaffInvolvement("<%=staffID%>","memberships","adventistHealthClub")'  class='' style='width:25px; height:25px;' name='adventistHealthClub' id='adventistHealthClub' type='checkbox' value='adventistHealthClub'/>Adventist Health Club&nbsp;
				<input <%=(isStaffInvolvementSelected(staffID,"memberships","team20DateCB",listOfStaffInvolvement)?"CHECKED":"") %> onclick='updateStaffInvolvement("<%=staffID%>","memberships","team20DateCB")'  class='' style='width:25px; height:25px;' name='team20DateCB' id='team20DateCB' type='checkbox' value='team20DateCB'/>Team 20

<%
	String effectiveDateDisplay = getStaffInvolvementEffectiveDate(staffID,listOfStaffInvolvement);
%>
				<span name="team20ShowSpan" style="display:none;">
					<span name="team20LabelSpan">
						(<%=(effectiveDateDisplay==null||(effectiveDateDisplay!=null&&effectiveDateDisplay.length()==0)?"<span style='color:red'>Enter Start Date</span>":effectiveDateDisplay)%>)
						<span name="editTeam20DateSpan">
							<button name="editTeam20DateButton"onclick='actionStaffTeam20Date("edit")'
							 class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
							style='text-align:center; height:20px; width:60px;font-size:11px;'>
							Edit
							</button>
							<button name="editTeam20DateButton"onclick='actionStaffTeam20Date("remove","<%=staffID%>","memberships","team20Date")'
							 class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
							style='text-align:center; height:20px; width:60px;font-size:11px;'>
							Remove
							</button>
						</span>
					</span>
<%
	if (effectiveDateDisplay == null || (effectiveDateDisplay!=null&&effectiveDateDisplay.length()==0)) {
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
		effectiveDateDisplay = sdf.format(cal.getTime()).toString();
	} %>

					<span name="team20DateSpan" style='display:none;'>
					(
						<jsp:include page="../ui/dateCMB.jsp" flush="false">
							<jsp:param name="label" value="team20Date" />
							<jsp:param name="yearRange" value="10" />
							<jsp:param name="date" value="<%=effectiveDateDisplay %>" />
							<jsp:param name="showTime" value="N" />
							<jsp:param name="defaultValue" value="N" />
							<jsp:param name="isDetailedTime" value="Y"/>
							<jsp:param name="allowEmpty" value="N"/>
						</jsp:include>
					)
						<span name="saveTeam20DateSpan">
							<button name="saveTeam20DateButton" onclick='actionStaffTeam20Date("save","<%=staffID%>","memberships","team20Date")'
							 class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
							style='text-align:center; height:20px; width:50px;font-size:11px;'>
							Save
							</button>
						</span>
						<span name="cancelTeam20DateSpan">
							<button name="cancelTeam20DateButton" onclick='actionStaffTeam20Date("cancel")'
							 class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
							style='text-align:center; height:20px; width:55px;font-size:11px;'>
							Cancel
							</button>
						</span>
					</span>
				</span>
			</td>
		</tr>

		<tr>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Participation&nbsp;</td>
			<td class='infoData' colspan="3">
				<table>
					<tr>
						<td><input <%=(isStaffInvolvementSelected(staffID,"participation","annualHospitalSpiritualRetreat",listOfStaffInvolvement)?"CHECKED":"") %> onclick='updateStaffInvolvement("<%=staffID%>","participation","annualHospitalSpiritualRetreat")'  class='' style='width:25px; height:25px;' name='annualHospitalSpiritualRetreat' id='annualHospitalSpiritualRetreat' type='checkbox' value='annualHospitalSpiritualRetreat'/>Annual Hospital Spiritual Retreat&nbsp;</td>
						<td><input <%=(isStaffInvolvementSelected(staffID,"participation","periodicCelebrationPrograms",listOfStaffInvolvement)?"CHECKED":"") %> onclick='updateStaffInvolvement("<%=staffID%>","participation","periodicCelebrationPrograms")'  class='' style='width:25px; height:25px;' name='periodicCelebrationPrograms' id='periodicCelebrationPrograms' type='checkbox' value='periodicCelebrationPrograms'/>Periodic Celebration Programs&nbsp;</td>
					</tr>
					<tr>
						<td><input <%=(isStaffInvolvementSelected(staffID,"participation","weeklyDepartmentDevotionals",listOfStaffInvolvement)?"CHECKED":"") %> onclick='updateStaffInvolvement("<%=staffID%>","participation","weeklyDepartmentDevotionals")'  class='' style='width:25px; height:25px;' name='weeklyDepartmentDevotionals'id='weeklyDepartmentDevotionals' type='checkbox' value='weeklyDepartmentDevotionals'/>Weekly Department Devotionals&nbsp;</td>
						<td><input <%=(isStaffInvolvementSelected(staffID,"participation","meetingDevotionals",listOfStaffInvolvement)?"CHECKED":"") %> onclick='updateStaffInvolvement("<%=staffID%>","participation","meetingDevotionals")'  class='' style='width:25px; height:25px;' name='meetingDevotionals' id='meetingDevotionals' type='checkbox' value='meetingDevotionals'/>Meeting Devotionals&nbsp;</td>
						<td><input <%=(isStaffInvolvementSelected(staffID,"participation","dailyDevotionals",listOfStaffInvolvement)?"CHECKED":"") %> onclick='updateStaffInvolvement("<%=staffID%>","participation","dailyDevotionals")'  class='' style='width:25px; height:25px;' name='dailyDevotionals' id='dailyDevotionals' type='checkbox' value='dailyDevotionals'/>Daily Devotionals&nbsp;</td>
					</tr>
					<tr>
						<td><input <%=(isStaffInvolvementSelected(staffID,"participation","dailyBlessingRounds",listOfStaffInvolvement)?"CHECKED":"") %> onclick='updateStaffInvolvement("<%=staffID%>","participation","dailyBlessingRounds")'  class='' style='width:25px; height:25px;' name='dailyBlessingRounds' id='dailyBlessingRounds' type='checkbox' value='dailyBlessingRounds'/>Daily Blessing Rounds&nbsp;</td>
						<td><input <%=(isStaffInvolvementSelected(staffID,"participation","dailyBlessingEmail",listOfStaffInvolvement)?"CHECKED":"") %> onclick='updateStaffInvolvement("<%=staffID%>","participation","dailyBlessingEmail")'  class='' style='width:25px; height:25px;' name='dailyBlessingEmail' id='dailyBlessingEmail' type='checkbox' value='dailyBlessingEmail'/>Daily Blessing Email&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
	</tbody>
</table>
<%
	}
} else {
	String patNo = request.getParameter("patNo");
	String dischargedPatient = request.getParameter("dischargedDate");
	String regType = request.getParameter("regType");

	if ("".equals(dischargedPatient)) {
		dischargedPatient = null;
	} else {
		dischargedPatient = "y";
	}

	ArrayList record = null;
	if ("O".equals(regType)) {
		String packageCode = request.getParameter("packageCode");
		record = PatientDB.getOutPatDetails(patNo, packageCode);
	} else {
		record = PatientDB.getInPatList(patNo, null, null, null, dischargedPatient,false);
	}
	if (record.size() != 0) {
		ReportableListObject row = (ReportableListObject)record.get(0);


%>
<table border = "0" width='100%'>
	<tbody>
		<tr>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>Hospital Name&nbsp;</td><td class="infoData" style='font-size:14px;' id='patHospital'><%=hospitalName%></td>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Doctor&nbsp;</td><td class="infoData" colspan="2"  style='font-size:14px;' id ='patDoctor'><%=row.getValue(23)%></td>
		</tr>
		<tr>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Patient No.&nbsp;</td><td class="infoData"  style='font-size:14px;' id='patNo'><%=row.getValue(7)%></td>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>Admission Date&nbsp;</td><td class="infoData" colspan="2"  style='font-size:14px;' id='admissionDate'><%=row.getValue(24)%></td>
		</tr>
		<tr>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>Patient Name&nbsp;</td><td class="infoData"  style='font-size:14px;' id='patName'><%=row.getValue(9)%></td>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>Patient Chinese Name&nbsp;</td><td class="infoData" colspan="2"  style='font-size:14px;' id='patCName'><%=row.getValue(10)%></td>
		</tr>
		<tr>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Ward&nbsp;</td><td class="infoData"  style='font-size:14px;' id='ward'><%=row.getValue(2)%></td>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Bed&nbsp;</td><td class="infoData" colspan="2"  style='font-size:14px;' id='bed'><%=row.getValue(3)%></td>
		</tr>
		<tr>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>ACM&nbsp;</td><td class="infoData" style='font-size:14px;' id='patACM'><%=row.getValue(22)%></td>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Language&nbsp;</td><td class="infoData" colspan="2"  style='font-size:14px;' id='patLang'><%=row.getValue(20)%></td>
		</tr>
		<tr>
			<td class="infoLabel"  style='text-align:right; font-size:14px;'>Age&nbsp;</td><td class="infoData"  style='font-size:14px;' id='age'><%=row.getValue(11)%></td>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>Sex&nbsp;</td><td class="infoData" colspan="2"  style='font-size:14px;' id='sex'><%=row.getValue(8)%></td>
		</tr>
		<tr >
			<td class="infoLabel"style='text-align:right; font-size:14px;'>Religion&nbsp;</td><td class="infoData"style='font-size:14px;' id='patReligion'><%=row.getValue(21)%></td>
<%
		ArrayList admissionRecord = PatientDB.getPatientAdmissionHistory(patNo,null);
		int admissionHistoryCount = 0;
		String lastTimeAdmission = "";
		String firstTimeAdmission = "";
		if (admissionRecord.size() != 0) {
			for(int i = 0;i< admissionRecord.size();i++) {
				ReportableListObject admissionRow = (ReportableListObject)admissionRecord.get(i);
				admissionHistoryCount = admissionHistoryCount + 1;

				if (i ==0) {
					String[] time= admissionRow.getValue(2).split(" ");
					String[] date = time[0].split("/");
					lastTimeAdmission = date[2];
				}
				if (i == admissionRecord.size() -1) {
					String[] time= admissionRow.getValue(2).split(" ");
					String[] date = time[0].split("/");
					firstTimeAdmission = date[2];
				}
			}
		}
		String visitPeriod = "";
		if (lastTimeAdmission.equals(firstTimeAdmission)) {
			visitPeriod = lastTimeAdmission;
		} else {
			visitPeriod = firstTimeAdmission + "~" + lastTimeAdmission;
		}

		ArrayList patientStatusRecord = PatientDB.getPatientStatus(patNo);
		String emergencyCall = null;
		String attendedWithin1hour = null;
		String visitStatus = "n";
		if ( patientStatusRecord.size() != 0) {
			ReportableListObject tempPatientStatus = (ReportableListObject) patientStatusRecord .get(0);
			emergencyCall = tempPatientStatus.getValue(1);
			attendedWithin1hour = tempPatientStatus.getValue(2);
			visitStatus = tempPatientStatus.getValue(3);
		}
%>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>Admission History&nbsp;</td>
			<td class="infoData" style='font-size:14px;' id="patAdmissionHistory"><%=admissionHistoryCount%> visits (<%=visitPeriod %>)</td>
			<td style='text-align:right'; class="infoData" >
				<img title='Display detailed admission history'  width='24px' src='../images/admissionPage.png' onclick='createSubPanel("<%=patNo%>","admissionHistory")'>
			</td>
		</tr>
<%if (ConstantsServerSide.isHKAH()) { %>
		<tr>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>Emergency Call&nbsp;</td>
			<td colspan="4" class="infoData" >
				<input onclick='updateRemark("<%=patNo %>");'  class='emergency_<%=patNo %>' <%=("e".equals(emergencyCall))?"CHECKED":""%>  style='width:25px; height:25px;' name='emergency_<%=patNo %>' id='emergency_<%=patNo %>' type='checkbox' value='e'/>Emergency&nbsp;
				<input onclick='updateRemark("<%=patNo %>");'  class='attend_<%=patNo %>' <%=("a".equals(attendedWithin1hour))?"CHECKED":""%>  style='width:25px; height:25px;' name='attend_<%=patNo %>' id='attend_<%=patNo %>' type='checkbox' value='a'/>Attended within 1 hour&nbsp;
			</td>
		</tr>
<%	} %>
		<tr>
			<td   class="infoLabel" style='text-align:right; font-size:14px;'>Repeat Visit&nbsp;</td>
			<td colspan="4" class="infoData" >
				<input onclick='setCheckBox("A","<%=patNo %>");'  class='remarkStatus_<%=patNo %>' <%=("a".equals(visitStatus))?"CHECKED":""%>  style='width:25px; height:25px;' name='visit_<%=patNo %>' id='visitA_<%=patNo %>' type='checkbox' value='a'/>Visit Again&nbsp;
				<input onclick='setCheckBox("F","<%=patNo %>");'  class='remarkStatus_<%=patNo %>' <%=("f".equals(visitStatus))?"CHECKED":""%>  style='width:25px; height:25px;' name='visit_<%=patNo %>' id='visitF_<%=patNo %>' type='checkbox' value='f'/>Visit Frequently&nbsp;
				<input onclick='setCheckBox("D","<%=patNo %>");'  class='remarkStatus_<%=patNo %>' <%=("d".equals(visitStatus))?"CHECKED":""%>   style='width:25px; height:25px;' name='visit_<%=patNo %>' id='visitD_<%=patNo %>' type='checkbox' value='d'/>Visit Daily&nbsp;
				<input onclick='setCheckBox("DND","<%=patNo %>");'  class='remarkStatus_<%=patNo %>' <%=("dnd".equals(visitStatus))?"CHECKED":""%>   style='width:25px; height:25px;' name='visit_<%=patNo %>' id='visitDND_<%=patNo %>' type='checkbox' value='dnd'/>Do Not Disturb
			</td>
		</tr>
<%
		ArrayList patientReferralRecord = PatientDB.checkPatientChapReferralWithPatID(patNo);
		String referral="";
		String refNotes = "&nbsp;";
		if (patientReferralRecord.size() != 0) {
			ReportableListObject tempReferral = (ReportableListObject)patientReferralRecord.get(0);
			referral = tempReferral.getValue(0);
			refNotes = refNotes + tempReferral.getValue(3);
		}
%>
		<tr>
			<td  id="refLabelCell" class="infoLabel" style='text-align:right; font-size:14px;'>Refer Patient&nbsp;
				<%=(referral.length() > 0)?"<span style='font-weight: bold;' id='refNotesLabelCell'><br>Refer Notes&nbsp;</span>":""%>
			</td>
			<td id='refCell' colspan="3" class="infoData" >
				<select name="referralStaffID" id="referralStaffID">
					<jsp:include page="../ui/staffIDCMB.jsp">
						<jsp:param value='<%=(ConstantsServerSide.isHKAH()?"660":"CHAP") %>' name="deptCode"/>
						<jsp:param value="Y" name="showFT"/>
						<jsp:param value="Y" name="allowEmpty"/>
						<jsp:param value="<%=referral %>" name="value"/>
					</jsp:include>
				</select>
<%=(referral.length() > 0)?"<span id='refNotesCell'><br>"+refNotes+"</span>":""%>
			</td>
			<td id='refImgCell'style='text-align:right' class="infoData">
				<img title='Refer Patient to selected Chaplain' width='28px' src='../images/referral.png'  onclick="submitReferral(<%=patNo%>,'submit')">
			</td>
			<td>
				<input type="hidden" id="hiddenReferral" value="<%=(referral==null)?"":referral%>">
			</td>
		</tr>
<%
		ArrayList diagnosisRecord =  PatientDB.checkPatientDiagnosisExists(patNo.trim());
		ReportableListObject diagnosisRow = null;
		if (diagnosisRecord.size() != 0) {
			diagnosisRow = (ReportableListObject)diagnosisRecord.get(0);
		}
%>
		<tr>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>Diagnosis&nbsp;</td>
				<td id='displayDiagnosis' colspan="3" class="infoData" >
				<%=(diagnosisRow!=null)?diagnosisRow.getValue(1):"" %>
			</td>
			<td style='text-align:right'; valign='top' class="infoData" >
				<img width='24px' title='Edit diagnosis' onclick='(createSubPanel("<%=patNo %>","diagnosis"));' src='../images/edit1.png'/>
			</td>
		</tr>

		<tr>
			<td class="infoLabel" style='text-align:right; font-size:14px;'>OT Record (Duration)&nbsp;</td>
			<td style='text-align:left' valign='top' class="infoData" >
<%
		ArrayList otRecord = PatientDB.getPatientOTRecord(patNo,"20");
		String otRecordStartDate = "";
		String duration = "";
		if (otRecord.size()>0) {
			ReportableListObject otRow = (ReportableListObject)otRecord.get(0);
			otRecordStartDate = otRow.getValue(0);
			String otRecordEndDate = otRow.getValue(1);

			Calendar otRecordSDate = Calendar.getInstance();
			String[] otRecordSArray = otRecordStartDate.split(" ");
			String[] otRecordSDateArray = otRecordSArray[0].split("/");
			String[] otRecordSTimeArray = otRecordSArray[1].split(":");
			int otRecordSDay = Integer.parseInt(otRecordSDateArray[0]);
			int otRecordSMonth = Integer.parseInt(otRecordSDateArray[1]) -1;
			int otRecordSYear = Integer.parseInt(otRecordSDateArray[2]);
			int otRecordSHour = Integer.parseInt(otRecordSTimeArray[0]);
			int otRecordSMinute = Integer.parseInt(otRecordSTimeArray[1]);

			otRecordSDate.set(otRecordSYear,otRecordSMonth,otRecordSDay,otRecordSHour,otRecordSMinute,0);

			Calendar otRecordEDate = Calendar.getInstance();
			String[] otRecordEArray = otRecordEndDate.split(" ");
			String[] otRecordEDateArray = otRecordEArray[0].split("/");
			String[] otRecordETimeArray = otRecordEArray[1].split(":");
			int otRecordEDay = Integer.parseInt(otRecordEDateArray[0]);
			int otRecordEMonth = Integer.parseInt(otRecordEDateArray[1]) -1;
			int otRecordEYear = Integer.parseInt(otRecordEDateArray[2]);
			int otRecordEHour = Integer.parseInt(otRecordETimeArray[0]);
			int otRecordEMinute = Integer.parseInt(otRecordETimeArray[1]);

			otRecordEDate.set(otRecordEYear,otRecordEMonth,otRecordEDay,otRecordEHour,otRecordEMinute,0);

			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");

			long otRecordSMillisec = otRecordSDate.getTimeInMillis();
			long otRecordEMillisec = otRecordEDate.getTimeInMillis();
			long durationMillisec = otRecordEMillisec - otRecordSMillisec;
			long durationHours = durationMillisec / (1000*60*60);
			long durationMinutes = (durationMillisec % (1000*60*60)) / (1000*60);

			if (durationHours > 0) {
				duration = Long.toString(durationHours) + " Hour," + Long.toString(durationMinutes) + " Min";
			} else {
				duration = Long.toString(durationMinutes) + " Min";
			}
			duration = " (" + duration + ")";
		}
%>
		<%=otRecordStartDate + duration%></td>
			<td style='text-align:left' valign='top' class="infoData" colspan="3">
				<img width='24px' title='OT Record' onclick='(createSubPanel("<%=patNo %>","otRecord"));' src='../images/admissionPage.png'/>
			</td>
		</tr>

		<tr>
			<td colspan="5"  style='text-align:center;  font-size:14px;'>
				<span style="color:green">
				-----------------------------------------------
				<button id='Patient_Contact_Info_Show' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
						style='width:220px;text-align:left; height:30px; font-size:15px;'>
					Show Patient's Contact Info
				</button>
				<button id='Patient_Contact_Info_Hide' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
						style='display:none;width:220px;text-align:left; height:30px; font-size:15px;'>
					Hide Patient's Contact Info
				</button>
				 ----------------------------------------------
				</span>
			</td>
		</tr>

		<tr>
			<td colspan="5">
				<div id='patientContactInfo' style="display:none;">
					<table width='100%' border='0'>
						<tr>
							<td class="infoLabel"  style='text-align:right; width:20%; font-size:14px;'>Home Telephone&nbsp;</td><td class="infoData"style='width:30%;font-size:14px;'><%=row.getValue(28)%></td>
							<td class="infoLabel"  style='text-align:right; width:20%; font-size:14px;'>Mobile phone&nbsp;</td><td class="infoData" style='width:30%;font-size:14px;'><%=row.getValue(30)%></td>
						</tr>
						<tr>
							<td class="infoLabel"  style='text-align:right; font-size:14px;'>Office Telephone&nbsp;</td><td class="infoData" style='font-size:14px;'><%=row.getValue(29)%></td>
							<td class="infoLabel"  style='text-align:right; font-size:14px;'>Address 1&nbsp;</td><td class="infoData" colspan="2"   style='font-size:14px;'><%=row.getValue(25)%></td>
						</tr>
						<tr>
							<td class="infoLabel" style='text-align:right; font-size:14px;'>Address 2&nbsp;</td><td class="infoData" style='font-size:14px;'><%=row.getValue(26)%></td>
							<td class="infoLabel" style='text-align:right; font-size:14px;'>Address 3&nbsp;</td><td class="infoData"  colspan="2"  style='font-size:14px;'><%=row.getValue(27)%></td>
						</tr>
					</table>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan="5"  style='text-align:center;  font-size:14px;'>
				<span style="color:green">
					------------------------------------------
					<button id='Primary_Contact_Info_Show' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='width:280px;text-align:left; height:30px; font-size:15px;'>
						Show Patient's Primary Contact Info
					</button>
					<button id='Primary_Contact_Info_Hide' class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only record'
							style='display:none;width:280px;text-align:left; height:30px; font-size:15px;'>
						Hide Patient's Primary Contact Info
					</button>
					-----------------------------------------
				</span>
			</td>
		</tr>
		<tr>
			<td colspan="5">
				<div id='primaryContactInfo' style="display:none;">
					<table border="0" width="100%">
						<tr>
							<td class="infoLabel" style='text-align:right; width:20%; font-size:14px;'>Name&nbsp;</td><td class="infoData" style='font-size:14px; width:30%;'><%=row.getValue(31)%></td>
							<td class="infoLabel"  style='text-align:right;  width:20%;font-size:14px;'>Relationship&nbsp;</td><td class="infoData" style='font-size:14px;  width:30%;'><%=row.getValue(32)%></td>
						</tr>
						<tr>
							<td class="infoLabel" style='text-align:right; font-size:14px;'>Home Telephone&nbsp;</td><td class="infoData" style='font-size:14px;'><%=row.getValue(33)%></td>
							<td class="infoLabel"  style='text-align:right; font-size:14px;'>Office Telephone&nbsp;</td><td class="infoData" style='font-size:14px;'><%=row.getValue(34)%></td>
						</tr>
					</table>
				</div>
			</td>
		</tr>

		<tr>
			<td width='25%' id='room' style='display:none;font-size:14px;'><%=row.getValue(4)%></td>
			<td width='25%' id='regID' style='display:none;font-size:14px;'><%=row.getValue(5)%></td>
			<td width='25%' id='regType' style='display:none;font-size:14px;'><%=row.getValue(6)%></td>
		</tr>
	</tbody>
</table>
<%
	}
}
%>