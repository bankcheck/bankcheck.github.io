<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%!
	private String parseString(String text) {
		if (text != null && text.length() > 0) {
			return text;
		} else {
			return "";
		}
	}
%>
<%
UserBean userBean = new UserBean(request);
String pirID = request.getParameter("pirID");
String pirDID = request.getParameter("PIR_DID");
String incidentType = request.getParameter("incidentType");
String incidentClassification = request.getParameter("incidentType");
String pirPXID = request.getParameter("PIR_PXID");
String piAssInjury = null;
//String pageIndex = "dHead";

ReportableListObject row = null;
ReportableListObject row2 = null;
String outVal = "";
String ReceiverType = "admin";
String ccList = "";
Boolean IsReponsiblePerson = null;
Boolean IsReponsibleUMDM = null;
//Boolean IsDoubleReponsiblePerson = null;
Boolean IsAddRptPerson = null;
Boolean IsDHead = null;
Boolean IsPIManager = null;
Boolean IsSubHead = null;
Boolean showFurtherAction = false;
Boolean IsOshIcn = null;
Boolean IsPharmacy = null;
Boolean IsStaffIncident = null;
Boolean IsPatientIncident = null;
Boolean IsMedicationIncident = null;
String rptSts = null;
String RespPerson = null;
String Narrative = null;
String Cause = null;
String ActionDone = null;
String ActionTaken = null;
String RiskAss = null;
String Mon = null;
String Inv = null;
String Treat = null;
String HighCare = null;
String MonSpec = null;
String InvSpec = null;
String TreatSpec = null;
String HighCareSpec = null;
String PersonFault = null;
String InadeTrain = null;
String NoPrevent = null;
String MachFault = null;
String MisUse = null;
String InadeInstru = null;
String InadeEquip = null;
String PoorQual = null;
String QualDetect = null;
String ExpItem = null;
String InadeMat = null;
String InstNotFollow = null;
String MotNature = null;
String Noise = null;
String DistEnv = null;
String UnvFloor = null;
String Slip = null;
String IM = null;
String Culture = null;
String Leader = null;
String Other = null;
String OtherSpec = null;
String Rpt_Narrative = null;
String Rpt_Cause = null;
String Rpt_ActionDone = null;
String Rpt_ActionTaken = null;
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
//Px
String PxRiskAss = null;
String HighAlert = null;
String BeforeWard = null;
String BeforeOutpat = null;
String AfterWardInv = null;
String AfterWardGiven = null;
String AfterOutpatNottaken = null;
String AfterOutpatTaken = null;
String BeforeDischarge = null;
String AfterDischarge = null;
String BeforeAdmin = null;
String AfterAdmin = null;
String BeforeAdminUnit = null;
String AfterAdminUnit = null;
String causeReaction = null;
// End Px

//pi classification
String nearMiss = null;
String piNearMiss = null;
String piClass  = null;
String inOutPatient = null;
String outcome = null;
String hazardousCondition = null;
String piRemarks = null;

// for NO-->SNO
String staffNOUM = null;
Boolean subHead = false;

//17092018 all inc type use px flow
String deptCodeFlwup = null;
String pxDeptCode = null;
String StatusLabel = null;

if (ConstantsServerSide.isTWAH()) {
	pxDeptCode = "PHAR";
	StatusLabel = "Pending ";
} else {
	pxDeptCode = "380";
	StatusLabel = "Wait for ";
}

Boolean IsPxIncident = PiReportDB.IsPxIncident(pirID);

	ArrayList record = PiReportDB.fetchReporDheadComment(pirID);
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		pirDID = row.getValue(1);
		Narrative = row.getValue(3);
		Cause = row.getValue(4);
		ActionDone = row.getValue(5);
		ActionTaken = row.getValue(6);
		RiskAss = row.getValue(8);
		Mon = row.getValue(9);
		Inv = row.getValue(10);
		Treat = row.getValue(11);
		HighCare = row.getValue(12);
		//
		MonSpec = row.getValue(13);
		InvSpec = row.getValue(14);
		TreatSpec = row.getValue(15);
		HighCareSpec = row.getValue(16);
		//
		PersonFault = row.getValue(17);
		InadeTrain = row.getValue(18);
		NoPrevent = row.getValue(19);
		MachFault = row.getValue(20);
		MisUse = row.getValue(21);
		//
		InadeInstru = row.getValue(22);
		InadeEquip = row.getValue(23);
		PoorQual = row.getValue(24);
		QualDetect = row.getValue(25);
		ExpItem = row.getValue(26);
		//
		InadeMat = row.getValue(27);
		InstNotFollow = row.getValue(28);
		MotNature = row.getValue(29);
		Noise = row.getValue(30);
		DistEnv = row.getValue(31);
		UnvFloor = row.getValue(32);
		Slip = row.getValue(33);
		IM = row.getValue(34);
		Culture = row.getValue(35);
		Leader = row.getValue(36);
		Other = row.getValue(37);
		OtherSpec = row.getValue(38);
		//
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
	}

	ArrayList record2 = PiReportDB.fetchReportBasicInfo(pirID);
	if (record2.size() > 0) {
		row = (ReportableListObject) record2.get(0);
		rptSts = row.getValue(9);
		incidentClassification = row.getValue(10);
		piAssInjury = row.getValue(22);

		nearMiss = row.getValue(27);
		piNearMiss = row.getValue(28);
		piClass = row.getValue(29);
		inOutPatient = row.getValue(36);
		outcome = row.getValue(39);
		hazardousCondition = row.getValue(38);
		piRemarks = row.getValue(40);

		staffNOUM = row.getValue(33);
		// 17092018 all inc type use px flow
		deptCodeFlwup = row.getValue(32);
	}

	subHead = PiReportDB.IsSubHeadCase(PiReportDB.getStaffDeptCode(staffNOUM));
	IsDHead = PiReportDB.IsDHead(userBean.getStaffID());
//	IsDoubleReponsiblePerson = PiReportDB.IsDoubleRespondsiblePerson(pirID, userBean.getLoginID(), rptSts);
	IsReponsiblePerson = PiReportDB.IsRespondsiblePerson(pirID, userBean.getStaffID());
	IsAddRptPerson = PiReportDB.IsAddRptPerson(userBean.getStaffID());
	IsOshIcn = PiReportDB.IsOshIcnPerson(userBean.getStaffID());
	IsPharmacy = PiReportDB.IsSeniorPharmacy(userBean.getStaffID());
	IsPIManager = PiReportDB.IsPIManager(userBean.getStaffID());
	IsSubHead = PiReportDB.IsSubHead(userBean.getStaffID(), pirID);
	IsStaffIncident = PiReportDB.IsStaffIncident(incidentClassification);
	if (ConstantsServerSide.isTWAH() && !IsStaffIncident) { 		// check if visitor inj but has BBF (option_id 1600)
		IsStaffIncident = PiReportDB.IsVisitorBBF(pirID);
	}
	IsPatientIncident = PiReportDB.IsPatientIncident(incidentClassification);
	IsMedicationIncident = PiReportDB.IsMedicationIncident(incidentClassification);
	IsReponsibleUMDM = PiReportDB.IsRespondsibleUMDM(pirID, userBean.getStaffID());

	ArrayList flwUpDialogreportDtl = PiReportDB.fetchReportFlwUpDialogReportDtl(pirID, "29");
	for(int j = 0; j < flwUpDialogreportDtl.size(); j++) {
		row = (ReportableListObject) flwUpDialogreportDtl.get(j);
		if (flwUpDialogreportDtl.size() > 0) {
			if ("284".equals(row.getValue(3))) {
				Rpt_Narrative = row.getValue(1);
			} else if ("285".equals(row.getValue(3))) {
				Rpt_Cause = row.getValue(1);
			} else if ("286".equals(row.getValue(3))) {
				Rpt_ActionDone = row.getValue(1);
			} else if ("287".equals(row.getValue(3))) {
				Rpt_ActionTaken = row.getValue(1);
			}
		}
	}

	ArrayList record3 = PiReportDB.fetchReportPxComment(pirID);
	if (record3.size() > 0) {
		row = (ReportableListObject) record3.get(0);
		pirPXID = row.getValue(1);
		PxRiskAss = row.getValue(2);
		HighAlert = row.getValue(3);
		BeforeWard = row.getValue(4);
		BeforeOutpat = row.getValue(5);
		AfterWardInv = row.getValue(6);
		AfterWardGiven = row.getValue(7);
		AfterOutpatNottaken = row.getValue(8);
		AfterOutpatTaken = row.getValue(9);
		BeforeDischarge = row.getValue(10);
		AfterDischarge = row.getValue(11);
		BeforeAdmin = row.getValue(12);
		AfterAdmin = row.getValue(13);
		BeforeAdminUnit = row.getValue(14);
		AfterAdminUnit = row.getValue(15);
		causeReaction = row.getValue(16);
	}
%>

		<tr><td>Risk rating of this incident :
				<select name="riskass" id="riskass" class="notEmpty" value="2B">
					<option value=""<%if ("".equals(RiskAss)) {%>selected<%} %>></option>
					<%--
					<option value="1A"<%if ("1A".equals(RiskAss)) {%>selected<%} %>>1A</option>
					<option value="1B"<%if ("1B".equals(RiskAss)) {%>selected<%} %>>1B</option>
					<option value="1C"<%if ("1C".equals(RiskAss)) {%>selected<%} %>>1C</option>
					<option value="1D"<%if ("1D".equals(RiskAss)) {%>selected<%} %>>1D</option>
					<option value="1E"<%if ("1E".equals(RiskAss)) {%>selected<%} %>>1E</option>
					<option value="2A"<%if ("2A".equals(RiskAss)) {%>selected<%} %>>2A</option>
					<option value="2B"<%if ("2B".equals(RiskAss)) {%>selected<%} %>>2B</option>
					<option value="2C"<%if ("2C".equals(RiskAss)) {%>selected<%} %>>2C</option>
					<option value="2D"<%if ("2D".equals(RiskAss)) {%>selected<%} %>>2D</option>
					<option value="2E"<%if ("2E".equals(RiskAss)) {%>selected<%} %>>2E</option>
					<option value="3A"<%if ("3A".equals(RiskAss)) {%>selected<%} %>>3A</option>
					<option value="3B"<%if ("3B".equals(RiskAss)) {%>selected<%} %>>3B</option>
					<option value="3C"<%if ("3C".equals(RiskAss)) {%>selected<%} %>>3C</option>
					<option value="3D"<%if ("3D".equals(RiskAss)) {%>selected<%} %>>3D</option>
					<option value="3E"<%if ("3E".equals(RiskAss)) {%>selected<%} %>>3E</option>
					<option value="4A"<%if ("4A".equals(RiskAss)) {%>selected<%} %>>4A</option>
					<option value="4B"<%if ("4B".equals(RiskAss)) {%>selected<%} %>>4B</option>
					<option value="4C"<%if ("4C".equals(RiskAss)) {%>selected<%} %>>4C</option>
					<option value="4D"<%if ("4D".equals(RiskAss)) {%>selected<%} %>>4D</option>
					<option value="4E"<%if ("4E".equals(RiskAss)) {%>selected<%} %>>4E</option>
					--%>
					<option value="E"<%if ("E".equals(RiskAss)) {%>selected<%} %>>E</option>
					<option value="H"<%if ("H".equals(RiskAss)) {%>selected<%} %>>H</option>
					<option value="M"<%if ("M".equals(RiskAss)) {%>selected<%} %>>M</option>
					<option value="L"<%if ("L".equals(RiskAss)) {%>selected<%} %>>L</option>
				</select>
				<a href="riskAssessMatrix.jsp" target="_blank">Risk Assessment Code</a>
				<!-- <a href="javascript:void(0);" onclick="newPopup('riskAssessMatrix.jsp');">Risk Assessment Code</a>-->
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="JavaScript:newPopup('RiskActionPlan.doc');"></a>

<%
	if ((!"5".equals(rptSts) || IsPIManager) && (IsReponsiblePerson || IsReponsibleUMDM)) {
		if (ConstantsServerSide.isHKAH()) {
%>
						<a href="file://www-server/pi/<%=pirID%>/RiskActionPlan.doc" target="_blank">Risk Action Plan (For Risk Rating under “Unacceptable” ONLY)</a>
						<!--a class="topstoryblue" href="footer_pi.jsp?fileloc=/<%=pirID%>/RiskActionPlan.doc" target="_blank"><u>Risk Action Plan (For Risk Rating under “Unacceptable” ONLY)</u></a-->
<%
		} else if (ConstantsServerSide.isTWAH()) {
%>
						<a href="file://192.168.0.20/pi/<%=pirID%>/RiskActionPlan.doc" target="_blank">Risk Action Plan (For Risk Rating under “Unacceptable” ONLY)</a>
						<%--
						To Learn how to write an incident report<br/>
						<a class="topstoryblue" onclick=" downloadFile('482', ''); return false;" href="javascript:void(0);" target="_blank">
							<img src="../images/pi/4.jpg" height="60" width="170" target="_blank"></img>
						</a>
						--%>

<%
		}
	}
%>
			</td>
		</tr>
		<tr></tr>
		<tr></tr>
		<tr>
			<td>
<%
	if (IsPatientIncident) {
%>

				<table>
					<tr>
						<td>
							<b>Severity of patient injury</b>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Does the patient require monitoring ?
						</td>
						<tr>
							<td>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="mon" id="myes" value="1" <%if ("1".equals(Mon)) {%>checked<%} %>>Yes
								(Please specify:<input type="text" name=monspec value="<%=MonSpec %>" size="100">)
								<br>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="mon" id="mno" value="0" <%if ("0".equals(Mon)) {%>checked<%} %>>No
							</td>
						</tr>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Does the patient require investigation?
						</td>
						<tr>
							<td>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="inv" id="iyes" value="1" <%if ("1".equals(Inv)) {%>checked<%} %>>Yes
								(Please specify:<input type="text" name=invspec value="<%=InvSpec %>" size="100">)
								<br>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="inv" id="ino" value="0" <%if ("0".equals(Inv)) {%>checked<%} %>>No
							</td>
						</tr>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Does the patient require treatment?
						</td>
						<tr>
							<td>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="treat" id="tyes" value="1" <%if ("1".equals(Treat)) {%>checked<%} %>>Yes
								(Please specify:<input type="text" name=treatspec value="<%=TreatSpec %>" size="100">)
								<br>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="treat" id="tno" value="0" <%if ("0".equals(Treat)) {%>checked<%} %>>No
							</td>
						</tr>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Does the patient require transfer to a higher care level? e.g. to ICU care immediately
						</td>
						<tr>
							<td>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="highcare" id="hyes" value="1" <%if ("1".equals(HighCare)) {%>checked<%} %>>Yes
								(Please specify:<input type="text" name=highcarespec value="<%=HighCareSpec %>" size="100">)
								<br>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="highcare" id="hno" value="0" <%if ("0".equals(HighCare)) {%>checked<%} %>>No
							</td>
						</tr>
					</tr>
				</table>
<%
	} else {
%>
					<input type="hidden" name="myes" value=""/>
					<input type="hidden" name="monspec" value=""/>
					<input type="hidden" name="mon" value=""/>

					<input type="hidden" name="iyes" value=""/>
					<input type="hidden" name="invspec" value=""/>
					<input type="hidden" name="inv" value=""/>

					<input type="hidden" name="tyes" value=""/>
					<input type="hidden" name="treatspec" value=""/>
					<input type="hidden" name="tno" value=""/>

					<input type="hidden" name="hyes" value=""/>
					<input type="hidden" name="highcarespec" value=""/>
					<input type="hidden" name="hno" value=""/>
<%
	}
%>
			</td>
		</tr>
		<tr>
			<td>
				<table>
					<tr>
						<td>
							<b>Root cause / Contributing Cause (You may tick more than 1 box)</b>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="personfault" value="1" <%if ("1".equals(PersonFault)) {%>checked<%} %>> Human – Personal lapse of staff<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="inadetrain" value="1" <%if ("1".equals(InadeTrain)) {%>checked<%} %>> Human – Inadequate staff training<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="noprevent" value="1" <%if ("1".equals(NoPrevent)) {%>checked<%} %>> Machine/Equipment – No preventive maintenance<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="machfault" value="1" <%if ("1".equals(MachFault)) {%>checked<%} %>> Machine/Equipment - Machine/Equipment faulty<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="misuse" value="1" <%if ("1".equals(MisUse)) {%>checked<%} %>> Machine/Equipment – being misused<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="inadeinstru" value="1" <%if ("1".equals(InadeInstru)) {%>checked<%} %>> Machine/Equipment – Inadequate instructions<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="inadeequip" value="1" <%if ("1".equals(InadeEquip)) {%>checked<%} %>> Machine/Equipment – Inadequate machine/equipment<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="poorqual" value="1" <%if ("1".equals(PoorQual)) {%>checked<%} %>> Material – Poor quality<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="qualdetect" value="1" <%if ("1".equals(QualDetect)) {%>checked<%} %>> Material – Quality defect<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="expitem" value="1" <%if ("1".equals(ExpItem)) {%>checked<%} %>> Material – Expired item<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="inademat" value="1" <%if ("1".equals(InadeMat)) {%>checked<%} %>> Material – Inadequate material<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="instnotfollow" value="1" <%if ("1".equals(InstNotFollow)) {%>checked<%} %>> Method – Instructions not followed<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="motnature" value="1" <%if ("1".equals(MotNature)) {%>checked<%} %>> Environment – Mother Nature<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="noise" value="1" <%if ("1".equals(Noise)) {%>checked<%} %>> Environment – Noisy<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="distenv" value="1" <%if ("1".equals(DistEnv)) {%>checked<%} %>> Environment – Distracting Environment<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="unvfloor" value="1" <%if ("1".equals(UnvFloor)) {%>checked<%} %>> Environment – Uneven floor<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="slip" value="1" <%if ("1".equals(Slip)) {%>checked<%} %>> Environment – Slippery<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="im" value="1" <%if ("1".equals(IM)) {%>checked<%} %>> Information Management<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="culture" value="1" <%if ("1".equals(Culture)) {%>checked<%} %>> Culture<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="leader" value="1" <%if ("1".equals(Leader)) {%>checked<%} %>>  Leadership<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="other" value="1" <%if ("1".equals(Other)) {%>checked<%} %>>  Others
							(Please specify:<input type="text" name=otherspec value="<%=OtherSpec %>" size="100">)
							<br>
						</td>
					</tr>
				</table>
			</td>
		</tr>


<%
	if (IsMedicationIncident) {
		if (!("8".equals(rptSts) && (IsPharmacy || IsPIManager))) {
%>
	<tr><td>
	<table>
		<tr><td><b><u>Pharmacy Section</u></b></td></tr>
		<tr>
			<td>
				<table>
					<tr>
						<td><b>Risk rating of this incident (Pharmacy):</b>
							<select name="pxPxRiskAss" class="notEmpty" value="2B">
								<option value=""<%if ("".equals(PxRiskAss)) {%>selected<%} %>></option>
								<option value="7"<%if ("7".equals(PxRiskAss)) {%>selected<%} %>>7</option>
								<option value="6"<%if ("6".equals(PxRiskAss)) {%>selected<%} %>>6</option>
								<option value="5"<%if ("5".equals(PxRiskAss)) {%>selected<%} %>>5</option>
								<option value="4"<%if ("4".equals(PxRiskAss)) {%>selected<%} %>>4</option>
								<option value="3"<%if ("3".equals(PxRiskAss)) {%>selected<%} %>>3</option>
								<option value="2"<%if ("2".equals(PxRiskAss)) {%>selected<%} %>>2</option>
								<option value="1"<%if ("1".equals(PxRiskAss)) {%>selected<%} %>>1</option>
								<option value="1(ii)"<%if ("1(ii)".equals(PxRiskAss)) {%>selected<%} %>>1(ii)</option>
								<option value="1(i)"<%if ("1(i)".equals(PxRiskAss)) {%>selected<%} %>>1(i)</option>
								<option value="0"<%if ("0".equals(PxRiskAss)) {%>selected<%} %>>0</option>
							</select>
							 <a href="PxAssessMatrix.jsp" target="_blank">Risk Assessment Code</a>
						</td>
					</tr>
					<tr>
						<td>
							<br>
						</td>
					</tr>
<%		if ("530".equals(incidentClassification)) { %>
					<tr>
						<td>
							<b>Classification by cause of reaction</b>
						</td>
						<tr>
							<td>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="causeReaction" id="causeReactionA" value="a" <%if ("a".equals(causeReaction)) {%>checked<%} %>>Type A: Augmented pharmacological effects
												<br>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="causeReaction" id="causeReactionB" value="b" <%if ("b".equals(causeReaction)) {%>checked<%} %>>Type B: Bizarre reactions (immunological-allergic)
							</td>
						</tr>
					</tr>
					<tr>
						<td>
							<br>
						</td>
					</tr>
<%		} %>
					<tr>
						<td>
							<b>Does the patient require monitoring ?</b>
						</td>
						<tr>
							<td>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="HighAlert" id="HighAlert1" value="1" <%if ("1".equals(HighAlert)) {%>checked<%} %>>Yes
												<br>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" name="HighAlert" id="HighAlert0" value="0" <%if ("0".equals(HighAlert)) {%>checked<%} %>>No
							</td>
						</tr>
					</tr>
					<tr>
						<td>
							<br>
						</td>
					</tr>
					<tr>
						<td>
							<b>Dispensary</b>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="BeforeWard" value="1" <%if ("1".equals(BeforeWard)) {%>checked<%} %>> Discovered BEFORE drugs were dispensed to WARDS<br>
						</td>
					<tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="BeforeOutpat" value="1" <%if ("1".equals(BeforeOutpat)) {%>checked<%} %>> Discovered BEFORE drugs were dispensed to OUTPATIENTS<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterWardInv" value="1" <%if ("1".equals(AfterWardInv)) {%>checked<%} %>> Discovered AFTER drugs were dispensed to WARDS / UNITS (intervened)<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterWardGiven" value="1" <%if ("1".equals(AfterWardGiven)) {%>checked<%} %>> Discovered AFTER drugs were dispensed to WARDS / UNITS (given / omitted)<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterOutpatNottaken" value="1" <%if ("1".equals(AfterOutpatNottaken)) {%>checked<%} %>> Discovered AFTER drugs were dispensed to OUTPATIENTS (not taken)<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterOutpatTaken" value="1" <%if ("1".equals(AfterOutpatTaken)) {%>checked<%} %>> Discovered AFTER drugs were dispensed to OUTPATIENTS (taken)<br>
						</td>
					</tr>
					<tr>
						<td>
							<br>
						</td>
					</tr>
					<tr>
						<td>
							<b>Ward</b>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="BeforeDischarge" value="1" <%if ("1".equals(BeforeDischarge)) {%>checked<%} %>> Discovered BEFORE drugs were dispensed to DISCHARGED Patient<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterDischarge" value="1" <%if ("1".equals(AfterDischarge)) {%>checked<%} %>> Discovered AFTER drugs were dispensed to DISCHARGED Patient<br>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="BeforeAdmin" value="1" <%if ("1".equals(BeforeAdmin)) {%>checked<%} %>> Discovered BEFORE drugs were administered to patients<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterAdmin" value="1" <%if ("1".equals(AfterAdmin)) {%>checked<%} %>> Discovered AFTER drugs were administered to patients<br>
						</td>
					</tr>
					<tr>
						<td>
							<br>
						</td>
					</tr>
					<tr>
						<td>
							<b>Units other than wards or dispensary (e.g. endoscopy unit, radiology unit , OPD administration, UC satellite dispensing)</b>
						</td>
					</tr>
					<tr>
						<td>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="BeforeAdminUnit" value="1" <%if ("1".equals(BeforeAdminUnit)) {%>checked<%} %>> Discovered BEFORE drugs were administered to patients<br>
						</td>
					</tr>
					<tr>
						<td  style="color:blue">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="checkbox" name="AfterAdminUnit" value="1" <%if ("1".equals(AfterAdminUnit)) {%>checked<%} %>> Discovered AFTER drugs were administered to patients<br>
						</td>
					</tr>
					<tr>
						<td>
							<br>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							*Items in blue prints are incidents reached the patient; Items in black prints are near misses
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</td></tr>
	<br/>
<%
		}
	} else {
%>
	<tr><td>
	<table>
		<tr><td><input type="hidden" name="pxPxRiskAss" value="<%=PxRiskAss%>"/></td></tr>
		<tr><td><input type="hidden" name="HighAlert" value="<%=HighAlert%>"/></td></tr>
		<tr><td><input type="hidden" name="BeforeWard" value="<%=BeforeWard%>"/></td></tr>
		<tr><td><input type="hidden" name="BeforeOutpat" value="<%=BeforeOutpat%>"/></td></tr>
		<tr><td><input type="hidden" name="AfterWardInv" value="<%=AfterWardInv%>"/></td></tr>
		<tr><td><input type="hidden" name="AfterWardGiven" value="<%=AfterWardGiven%>"/></td></tr>
		<tr><td><input type="hidden" name="AfterOutpatNottaken" value="<%=AfterOutpatNottaken%>"/></td></tr>
		<tr><td><input type="hidden" name="AfterOutpatTaken" value="<%=AfterOutpatTaken%>"/></td></tr>
		<tr><td><input type="hidden" name="BeforeDischarge" value="<%=BeforeDischarge%>"/></td></tr>
		<tr><td><input type="hidden" name="AfterDischarge" value="<%=AfterDischarge%>"/></td></tr>
		<tr><td><input type="hidden" name="BeforeAdmin" value="<%=BeforeAdmin%>"/></td></tr>
		<tr><td><input type="hidden" name="AfterAdmin" value="<%=AfterAdmin%>"/></td></tr>
		<tr><td><input type="hidden" name="BeforeAdminUnit" value="<%=BeforeAdminUnit%>"/></td></tr>
		<tr><td><input type="hidden" name="AfterAdminUnit" value="<%=AfterAdminUnit%>"/></td></tr>
	</table>
	</td></tr>
	<br/>
<%
	}
%>
<%--
	<input type="hidden" name="rptsts" value="<%=rptSts%>"/>
	<input type="hidden" name="respparty" value="<%=""%>"/>
--%>
	</table>
	<br/>

	<input type="hidden" name="incidentType" value="<%=incidentType%>"/>
<%--
	<input type="hidden" name="narrative" value="<%=Narrative%>"/>
	<input type="hidden" name="cause" value="<%=Cause %>"/>
	<input type="hidden" name="actiondone" value="<%=ActionDone %>"/>
	<input type="hidden" name="actiontaken" value="<%=ActionTaken %>"/>
--%>
<%--
	<input type="hidden" name="rptsts" value="<%=rptSts%>"/>
	<input type="hidden" name="respparty" value="<%=""%>"/>
--%>
	<input type="hidden" name="pirdid" value="<%=pirDID%>"/>
<br/>
<%
	// "2".equals(rptSts) || "13".equals(rptSts)
	if (("1".equals(rptSts) || "11".equals(rptSts) || "12".equals(rptSts) || "14".equals(rptSts)) && (IsReponsiblePerson || IsReponsibleUMDM)) {
		if (ConstantsServerSide.isTWAH()) {
			%><button onclick="return showconfirm('fu_save_flwup_dhead_2', 1);" class="btn-click">Save Only<br>(without submit)</button><%
		} else {
			%><button onclick="return showconfirm('fu_adm_comment', 'submit');" class="btn-click">Save Only</button><%
		}
	}
%>
<%--
====================  Workflow Buttons ==================
--%>
<%
	if ("7".equals(rptSts) && IsOshIcn) {
		%><button onclick="return showconfirm('fu_accept_investigate_oshicn', 'accept');" class="btn-click">Accept Investigation</button><%
	} else if ("8".equals(rptSts) && IsPharmacy) {
		%><button onclick="return showconfirm('fu_accept_investigate_pharmacy', 'accept');" class="btn-click">Accept Investigation</button><%
	} else if (IsReponsiblePerson && !"3".equals(rptSts)) {
		if (ConstantsServerSide.isTWAH()
				&& IsMedicationIncident
				&& ("1".equals(rptSts) || "12".equals(rptSts) || "19".equals(rptSts)) && "8".equals(incidentClassification) && "52".equals(incidentType)
				&& "1".equals(nearMiss)
				&& PiReportDB.IsPxIncident(pirID)
				&& !IsDHead
				&& !("12".equals(rptSts) && subHead)) {
			%><button onclick="return showconfirm('fu_px2pi_submit', 'submit');" class="btn-click">Save and Submit to PI Manager</button><%
		} else {
			%><button onclick="return showconfirm('fu_submit', 'submit');" class="btn-click">Save and Submit</button><%
		}
	}

	if ((IsPIManager && !"6".equals(rptSts)) ||
		(IsReponsiblePerson &&
			(
				(IsOshIcn && ("1".equals(rptSts) || "2".equals(rptSts) || "14".equals(rptSts) || "19".equals(rptSts))) ||
				(IsOshIcn && "1".equals(rptSts) && IsStaffIncident) ||
				(!IsOshIcn && ("1".equals(rptSts) || "2".equals(rptSts) || "14".equals(rptSts) || "19".equals(rptSts)) && !IsMedicationIncident && !IsStaffIncident) ||
				(("11".equals(rptSts) || "19".equals(rptSts)) && !IsOshIcn && IsStaffIncident) ||
				(("1".equals(rptSts) || "2".equals(rptSts)|| "12".equals(rptSts) || "19".equals(rptSts) || "14".equals(rptSts)) && ((IsMedicationIncident || IsStaffIncident) && !IsOshIcn)) ||
				("29".equals(rptSts)) // all inc type use px flow
			)
		)

	) {
		if (IsPIManager && !"6".equals(rptSts)) {
%>
		<button onclick="return showconfirm('fu_reject', 'reject');" class="btn-click">Reject</button>
<%
		}
%>
		<br/>
		<br/>
		<br><b>Redo Reason</b><br/>
		<textarea name="redoreason" rows="5" cols="100"></textarea>
		<br/>
<%
		if (IsMedicationIncident && ("1".equals(rptSts) || "19".equals(rptSts)) && IsDHead) {
%>
		<button onclick="return showconfirm('fu_redo_px_dutymanager', 'redo');" class="btn-click">Redo for Senior Pharmaist</button>
<%
		} else {
%>
		<button onclick="return showconfirm('fu_redo', 'redo');" class="btn-click">Redo</button>
<%
		}
%>
		<br/>
		<br/>
<%
	}
%>

<%--
  END -- if icn/osh and also dept head
--%>


<%
	if ("3".equals(rptSts) && IsPIManager) {
%>
		<button onclick="return showconfirm('fu_pi_close', 'close');" class="btn-click">Reporting Process Completed</button>
<%
	}
%>
<%--
	for PI redo button
--%>
<%
	if ("3".equals(rptSts) && IsPIManager && IsReponsiblePerson) {
%>
		<br/>
		<br/>
		<br><b>Redo Reason</b><br/>
		<textarea name="redoreason" rows="5" cols="100"></textarea>
		<br/>
		<button onclick="return showconfirm('fu_redo', 'redo');" class="btn-click">Redo</button>
<%
		if (ConstantsServerSide.isTWAH() && "8".equals(incidentClassification) && "52".equals(incidentType) && "1".equals(nearMiss) && PiReportDB.IsPxIncident(pirID)) {
%>
		<button onclick="return showconfirm('fu_redo_px', 'redo');" class="btn-click">Redo for Pharmacist</button>
<%
		}
%>
		<br/>
		<br/>
<%
	}
%>

<%--
	END for PI redo button
--%>

<%--
	End -- for icn/osn submit button
--%>

<input type="hidden" name="pirpxid" value="<%=pirPXID%>"/>
<input type="hidden" name="respparty" value=""/>

<%--
====================  Dhead Additional Information Form Attachmenet ==================
--%>
<br><br>
<%
	if (((IsPharmacy || IsDHead || IsOshIcn) && ("1".equals(rptSts) || "2".equals(rptSts) || "14".equals(rptSts) || "19".equals(rptSts) || "11".equals(rptSts) || "3".equals(rptSts))) && (IsReponsiblePerson || IsPIManager || IsPharmacy)) {
%>
		<font size="3"><b><u>Additional Information</u></b></font></br>
		Attachment : <input type="file" name="dheadaddform" size="40" maxlength="5" class="multi"/>
		<%
		//String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
		String allowRemove = null;
		if (IsPIManager) {
			allowRemove = ConstantsVariable.NO_VALUE;
		} else {
			allowRemove = ConstantsVariable.YES_VALUE;
		}
		%>
		<span id="DHeadAddForm_indicator">
		<jsp:include page="../common/document_list.jsp" flush="false">
			<jsp:param name="moduleCode" value="DHeadAddForm" />
			<jsp:param name="keyID" value="<%=pirID %>" />
			<jsp:param name="allowRemove" value="<%=allowRemove %>" />
		</jsp:include>
		</span>
		</br>
			<button onclick="return showconfirm('fu_dhead_add_form', '');" class="btn-click">Save the attachment</button>
		</br>
<%
	}
%>
<%--
==================== END -  Dhead Additional Information Form Attachmenet ==================
--%>

<%--
====================  END - Workflow Buttons ==================
--%>

<%--
====================  Post Incident Exam Form Attachmenet ==================
--%>
<%
	if (IsPIManager) {
		// PI Classification - near miss, incident classification
		String responseFromPerson = PiReportDB.fetchReportFlwUpDialogFromPerson(pirID);
		String responseFromDept = null;
		if (responseFromPerson != null) {
			responseFromDept = StaffDB.getDepartmentCode(responseFromPerson);
		}
		String responseToPerson = null;
		String responseToDept = null;
		String[] temp = PiReportDB.getResponsibleParty(pirID);
		if (temp != null && temp.length > 0) {
			responseToPerson = temp[0];
		}
		if (responseToPerson != null) {
			responseToDept = StaffDB.getDepartmentCode(responseToPerson);
		}
%>
<br/><br/>
<table>
<tr>
	<td colspan="3"><font size="3"><b><u>PI Administration</u></b></font></td>
</tr>
<tr>
	<td>Status:</td>
	<td>&nbsp;</td>
	<td>
		<select name="ChgStatus">
			<option value='0'<%=(rptSts!=null && "0".equals(rptSts))?"selected":"" %>><%=StatusLabel%> Reporter resubmit</option>
			<option value='1'<%=(rptSts!=null && "1".equals(rptSts))?"selected":"" %>><%=StatusLabel%> Unit Manager Input/Senior Pharmacist Input</option>
			<option value='19'<%=(rptSts!=null && "19".equals(rptSts))?"selected":"" %>><%=StatusLabel%> <%if (ConstantsServerSide.isHKAH()) {%>Senior UM<%} else {%>SNO<%} %> Input</option>
			<option value='11'<%=(rptSts!=null && "11".equals(rptSts))?"selected":"" %>><%=StatusLabel%> Referring to OSH/ICN</option>
			<option value='7'<%=(rptSts!=null && "7".equals(rptSts))?"selected":"" %>><%=StatusLabel%> OSH/ICN Acceptance</option>
			<option value='12'<%=(rptSts!=null && "12".equals(rptSts))?"selected":"" %>>Refer to Pharmacist/<%=StatusLabel%> Manager Input - Clinical</option>
			<option value='8'<%=(rptSts!=null && "8".equals(rptSts))?"selected":"" %>>Wait for Senior Pharmacist Acceptance</option-->
			<!--option value='1'<%=(rptSts!=null && "1".equals(rptSts))?"selected":"" %>><%=StatusLabel%> Senior Pharmacist Input</option-->
			<option value='14'<%=(rptSts!=null && "14".equals(rptSts))?"selected":"" %>><%=StatusLabel%> Chief Pharmacist Input</option>
			<option value='2'<%=(rptSts!=null && "2".equals(rptSts))?"selected":"" %>><%=StatusLabel%> Administrator</option>
			<option value='3'<%=(rptSts!=null && "3".equals(rptSts))?"selected":"" %>><%=StatusLabel%> PI</option>
			<option value='4'<%=(rptSts!=null && "4".equals(rptSts))?"selected":"" %>><%=StatusLabel%> CEO</option>
			<option value='5'<%=(rptSts!=null && "5".equals(rptSts))?"selected":"" %>>Reporting Process Completed</option>
			<option value='6'<%=(rptSts!=null && "6".equals(rptSts))?"selected":"" %>>Rejected</option>
		</select>
	</td>
</tr>
<tr>
	<td>From Person:</td>
	<td>&nbsp;</td>
	<td>
	 	<select name="deptCode0" onchange="return changeStaffID(this, 'Empty Staff', 'showStaffID_indicator0', 'ChgFrom', '', '')">
			<option value="">--Select Department--</option>
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=responseFromDept %>" />
				<jsp:param name="allowAll" value="Y" />
			</jsp:include>
		</select>
		<span id="showStaffID_indicator0">
		<select name="ChgFrom">
			<option value="">--Empty Staff--</option>
			<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=responseFromDept %>" />
				<jsp:param name="showDeptDesc" value="N" />
				<jsp:param name="value" value="<%=responseFromPerson%>" />
				<jsp:param name="allowAll" value="Y" />
			</jsp:include>
		</select>
		</span>
	</td>
</tr>
<tr>
	<td>Responsible Person:</td>
	<td>&nbsp;</td>
	<td>
	 	<select name="deptCode1" onchange="return changeStaffID(this, 'Empty Staff', 'showStaffID_indicator1', 'ChgRespPerson', '', '')">
			<option value="">--Select Department--</option>
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=responseToDept %>" />
				<jsp:param name="allowAll" value="Y" />
			</jsp:include>
		</select>
		<span id="showStaffID_indicator1">
		<select name="ChgRespPerson">
			<option value="">--Empty Staff--</option>
			<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=responseToDept %>" />
				<jsp:param name="showDeptDesc" value="N" />
				<jsp:param name="value" value="<%=responseToPerson %>" />
				<jsp:param name="allowAll" value="Y" />
			</jsp:include>
		</select>
		</span>
	</td>
</tr>
<tr>
	<td colspan="3">&nbsp;</td>
</tr>
<tr>
	<td colspan="3"><button onclick="return showconfirm('fu_change_status_resp', 1);" class="btn-click">Update status and responsible person</button></td>
</tr>
<tr>
	<td colspan="3"><font color="red">* Only update status and responsible person, no alert email will be sent.</td>
</tr>
<tr>
	<td colspan="3">&nbsp;</td>
</tr>
<tr>
	<td colspan="3"><button onclick="return showconfirm('fu_emailOnly', 1);" class="btn-click">Email to responsible person</button></td>
</tr>
</table>
<br><br>
<table border="0">
<tr>
	<td colspan="7"><font size="3"><b><u>PI Classification</u></b></font></td>
</tr>
<tr>
	<td>Reporter Near Miss :</td>
	<td>&nbsp;</td>
	<td><%if ("0".equals(nearMiss)) {%> <font color="green">No</font> <%} else { %> <font color="red">Yes</font> <%} %></td>
	<td>&nbsp;</td>
	<td>PI Near Miss</td>
	<td>&nbsp;</td>
	<td>
		<select name="pinearmiss">
			<option value=""></option>
			<option value="0" <%if ("0".equals(piNearMiss)) {%>selected<%} %>>No</option>
			<option value="1" <%if ("1".equals(piNearMiss)) {%>selected<%} %>>Yes</option>
	 	</select>
	 </td>
</tr>
<tr>
	<td>Reporter Classification :</td>
	<td>&nbsp;</td>
	<td><font color="blue"><%=PiReportDB.getClassDesc(ConstantsServerSide.SITE_CODE, incidentClassification ) %></font></td>
	<td>&nbsp;</td>
	<td>PI Classification</td>
	<td>&nbsp;</td>
	<td>
		<select name="piclass">
			<jsp:include page="../ui/piClassificationCMB.jsp" flush="false">
				<jsp:param name="isOption" value="Y" />
				<jsp:param name="value" value="<%=piClass%>" />
			</jsp:include>
		 </select>
	 </td>
</tr>
<tr>
	<td colspan="4">&nbsp;</td>
	<td>Inpatient/Outpatient</td>
	<td>&nbsp;</td>
	<td>
		<select name="inoutpat">
			<option value=""></option>
			<option value="I" <%if ("I".equals(inOutPatient)) {%>selected<%} %>>Inpatient</option>
			<option value="O" <%if ("O".equals(inOutPatient)) {%>selected<%} %>>Outpatient</option>
			<option value="N" <%if ("N".equals(inOutPatient)) {%>selected<%} %>>N/A</option>
		</select>
	</td>
</tr>
<tr>
	<td colspan="4">&nbsp;</td>
	<td>Outcome</td>
	<td>&nbsp;</td>
	<td>
		<select name="outcome">
			<option value=""></option>
			<option value="2" <%if ("2".equals(outcome)) {%>selected<%} %>>Adverse Event</option>
			<option value="1" <%if ("1".equals(outcome)) {%>selected<%} %>>No Harm</option>
			<option value="0" <%if ("0".equals(outcome)) {%>selected<%} %>>NA</option>
		</select>
	</td>
</tr>
<tr>
	<td colspan="4">&nbsp;</td>
	<td>PI Hazardous Condition</td>
	<td>&nbsp;</td>
	<td>
		<select name="hazardousCondition">
			<option value=""></option>
			<option value="0" <%if ("0".equals(hazardousCondition)) {%>selected<%} %>>No</option>
			<option value="1" <%if ("1".equals(hazardousCondition)) {%>selected<%} %>>Yes</option>
		</select>
	</td>
</tr>
<tr>
	<td>PI Remarks:</td>
	<td>&nbsp;</td>
	<td colspan="5"><textarea name="piRemarks" rows="7" cols="174"><%=parseString(piRemarks) %></textarea></td>
</tr>
<tr>
	<td colspan="7">&nbsp;</td>
</tr>
<tr>
	<td colspan="7"><button onclick="return showconfirm('fu_pi_class', '');" class="btn-click">Save the classification</button></td>
</tr>
</table>
<br/><br/>
<table>
<tr>
	<td colspan="3"><font size="3"><b><u>Post-incident Doctor Examination Form</u></b></font></td>
</tr>
<tr>
	<td>Attachment :</td>
	<td>&nbsp;</td>
	<td><input type="file" name="postexamform" size="40" maxlength="5" class="multi"/>
<%
		//String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
		String allowRemove = ConstantsVariable.YES_VALUE;
%>
<span id="PostExamForm_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="PostExamForm" />
	<jsp:param name="keyID" value="<%=pirID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
</span>
	</td>
</tr>
<tr>
	<td>Assessment of injury</td>
	<td>&nbsp;</td>
	<td>
		<select name="assinjury">
			<option value=""></option>
			<option value="0" <%if ("0".equals(piAssInjury)) {%>selected<%} %>>0-no affect</option>
			<option value="1" <%if ("1".equals(piAssInjury)) {%>selected<%} %>>1-caused no harm</option>
			<option value="2" <%if ("2".equals(piAssInjury)) {%>selected<%} %>>2-caused temporary harm</option>
			<option value="3" <%if ("3".equals(piAssInjury)) {%>selected<%} %>>3-caused permanent harm</option>
			<option value="4" <%if ("4".equals(piAssInjury)) {%>selected<%} %>>4-caused death</option>
			<option value="5" <%if ("5".equals(piAssInjury)) {%>selected<%} %>>5-NA</option>
		</select>
	</td>
</tr>
<tr>
	<td colspan="3">&nbsp;</td>
</tr>
<tr>
	<td colspan="3"><button onclick="return showconfirm('fu_post_exam_form', '');" class="btn-click">Save the attachment</button></td>
</tr>
</table>
<%
	}
%>
<%--
====================  END - Post Incident Exam Form Attachmenet ==================
--%>


<%--
================== PI Action Request
--%>
<%
	if (IsPIManager) {
		showFurtherAction = true;
	} else {
		if (IsSubHead && ConstantsServerSide.isTWAH()) {
			showFurtherAction = true;
		}
	}
	if (showFurtherAction) {
%>
<br/><br/>
<table>
<tr>
	<td colspan="3"><font size="3"><b><u><%if (IsPIManager) {%>PI Action Request<%} else { %>SNO Action Request<%} %></u></b></font></td>
</tr>
<tr>
	<td>Staff:</td>
	<td>&nbsp;</td>
	<td>
<%
		if (IsPIManager) {
%>
	 	<select name="deptCode2" onchange="return changeStaffID(this, 'Select Staff', 'showStaffID_indicator2', 'actionrequeststaff', '', '')">
<%
		} else {
%>
	 	<select name="deptCode2" onchange="return changeStaffID(this, 'Select Staff', 'showStaffID_indicator2', 'actionrequeststaff', 'Y', 'Y')">
<%
		}
%>
			<option value="">--Select Department--</option>
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="allowAll" value="Y" />
			</jsp:include>
		</select>
		<span id="showStaffID_indicator2">
		<select name="actionrequeststaff">
			<option value="">--Select Staff--</option>
		</select>
		</span>
	</td>
</tr>
<tr>
	<td>Action Request :</td>
	<td>&nbsp;</td>
	<td>
		<select name="actionRequest" class="notEmpty" value="">
			<option value=""></option>
			<option value="1">Provide general comment on the incident</option>
			<option value="2">Provide photocopy of related patient information</option>
			<option value="3">Provide report from related staff in your department</option>
			<option value="4">Provide investigation report on the incident</option>
			<option value="5">Recommend preventive/remedial measures</option>
			<option value="6">Please send the Post Doctor Examination form to PI department</option>
			<option value="7">Others</option>
		</select>
	</td>
</tr>
<tr>
	<td>Completed Date :</td>
	<td>&nbsp;</td>
	<td><input name="compDate" id="compDate" type="textfield" class="datepickerfield"></td>
</tr>
<tr>
	<td colspan="3"><textarea name="requestContent" rows="7" cols="174"></textarea></td>
</tr>
<tr>
	<td colspan="3">&nbsp;</td>
</tr>
<tr>
	<td colspan="3">
<%
		if (IsPIManager) {
%>
	<button onclick="return showconfirm('fu_action_request_send', 'actionrequest');" class="btn-click">Send Action Request</button>
<%
		} else {
%>
	<button onclick="return showconfirm('fu_action_request_send_sno', 'actionrequest');" class="btn-click">Send Action Request</button>
<%
		}
%>
</td></tr>
</table>
<input type="hidden" name="autoReminder" value=""/>
<table border=1>
<tr bgcolor="#D3D3D3"><td>Action Request Date</td><td>Action Request</td><td>Staff</td><td>Completion Date</td><td>Request Content</td><td>Reply Date</td><td>Reply Content</td>
<%
		if (IsPIManager) {
%>
<td>Request Type</td>
<td>Request By</td>
<td>Set Replied</td>
<%
		}

		ArrayList actionRequestDialog = PiReportDB.fetchReportActionRequestUpDialog(pirID, userBean.getStaffID());
		if (actionRequestDialog.size() > 0) {
			for(int i = 0; i < actionRequestDialog.size(); i++) {
				row = (ReportableListObject) actionRequestDialog.get(i);
%>
		<tr bgcolor="#FFF0F5"><td><%=row.getValue(9)%></td><td><%=row.getValue(2)%></td><td><%=StaffDB.getStaffName(row.getValue(4))%></td><td><%=row.getValue(3)%></td>
<%
				// try to display larger dialog comment
				String requestContent;
				requestContent = row.getValue(5);
				if (requestContent.length() > 100) {
%>
		<td>
			<%=requestContent.substring(0, 50)%> <a href="flwUpDialogContent.jsp?pirid=<%=pirID%>&contentid=<%=row.getValue(1)%>&contentType=actionrequest" target="_blank">more...</a>
		</td>
<%
				} else {
%>
		<td>
			<%=requestContent%>
		</td>
<%
				}
%>

		<td><%=row.getValue(8)%></td>

<%
				// try to display larger dialog comment
				String replyContent;
				replyContent = row.getValue(6);
				if (replyContent.length() > 100) {
%>
		<td>
			<%=replyContent.substring(0, 50)%> <a href="flwUpDialogContent.jsp?pirid=<%=pirID%>&contentid=<%=row.getValue(1)%>&contentType=actionreply" target="_blank">more...</a>
		</td>
<%
				} else {
%>
		<td>
			<%=replyContent%>
		</td>
<%
				}

				if (IsPIManager) {
%>
		<td><%=row.getValue(10)%></td>
		<td><%=row.getValue(12)%></td>
		<td><button onclick="return showconfirm('set_noreply', '<%=row.getValue(1)%>');">Set Replied</button></td>
<%
				}
			}
		}
%>
</tr>
</table>
<%
	}
%>

<script language="javascript">

//	keepAlive(5000);

	function validateForm(stp)	{
	var x = "";
<%
	if (!"7".equals(rptSts) || !IsOshIcn) {
%>
		//alert("stp : " + stp);
		if (stp=='submit' || stp=='changeresp') {
			x=document.forms["reportForm"]["riskass"].value;
			if (x==null || x=="") {
				alert("Please enter Risk rating");
				document.forms["reportForm"]["riskass"].focus();
				return false;
			}
			x=document.forms["reportForm"]["personfault"].checked;
			if (x==null || x=="") {
				x=document.forms["reportForm"]["inadetrain"].checked;
				if (x==null || x=="") {
					x=document.forms["reportForm"]["noprevent"].checked;
					if (x==null || x=="") {
						x=document.forms["reportForm"]["machfault"].checked;
						if (x==null || x=="") {
							x=document.forms["reportForm"]["misuse"].checked;
							if (x==null || x=="") {
								x=document.forms["reportForm"]["inadeinstru"].checked;
								if (x==null || x=="") {
									x=document.forms["reportForm"]["inadeequip"].checked;
									if (x==null || x=="") {
										x=document.forms["reportForm"]["poorqual"].checked;
										if (x==null || x=="") {
											x=document.forms["reportForm"]["qualdetect"].checked;
											if (x==null || x=="") {
												x=document.forms["reportForm"]["expitem"].checked;
												if (x==null || x=="") {
													x=document.forms["reportForm"]["inademat"].checked;
													if (x==null || x=="") {
														x=document.forms["reportForm"]["instnotfollow"].checked;
														if (x==null || x=="") {
															x=document.forms["reportForm"]["motnature"].checked;
															if (x==null || x=="") {
																x=document.forms["reportForm"]["noise"].checked;
																if (x==null || x=="") {
																	x=document.forms["reportForm"]["distenv"].checked;
																	if (x==null || x=="") {
																		x=document.forms["reportForm"]["unvfloor"].checked;
																		if (x==null || x=="") {
																			x=document.forms["reportForm"]["slip"].checked;
																			if (x==null || x=="") {
																				x=document.forms["reportForm"]["im"].checked;
																				if (x==null || x=="") {
																					x=document.forms["reportForm"]["culture"].checked;
																					if (x==null || x=="") {
																						x=document.forms["reportForm"]["leader"].checked;
																						if (x==null || x=="") {
																							x=document.forms["reportForm"]["other"].checked;
																							if (x==null || x=="") {
																								x=document.forms["reportForm"]["otherspec"].value;
																								if (x==null || x=="") {
																									alert("Please enter Root cause / Contributing Cause");
																									return false;
																								}
																							}
																						}
																					}
																				}
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		//

		if (stp=='redo') {
			x=document.forms["reportForm"]["redoreason"].value;
			if (x==null || x=="") {
				alert("Please enter Redo Reason");
				return false;
			}
		}

		if (document.forms["reportForm"]["myes"].checked) {
			x=document.forms["reportForm"]["monspec"].value;
			if (x==null || x=="") {
				alert("Please enter Severity of patient injury");
				return false;
			}
//			else {
//				return true;
//			}

		}
		if (document.forms["reportForm"]["iyes"].checked) {
			x=document.forms["reportForm"]["invspec"].value;
			if (x==null || x=="") {
				alert("Please enter Severity of patient injury");
				return false;
			}
//			else {
//				return true;
//			}

		}
		if (document.forms["reportForm"]["tyes"].checked) {
			x=document.forms["reportForm"]["treatspec"].value;
			if (x==null || x=="") {
				alert("Please enter Severity of patient injury");
				return false;
			}
//			else {
//				return true;
//			}

		}
		if (document.forms["reportForm"]["hyes"].checked) {
			x=document.forms["reportForm"]["highcarespec"].value;
			if (x==null || x=="") {
				alert("Please enter Severity of patient injury");
				return false;
			}
//			else {
//				return true;
//			}
		}

		if (stp=='actionrequest') {


			y=document.forms["reportForm"]["actionrequeststaff"].value;
			if (y==null || y=="") {
				alert("Please enter Staff No");
				return false;
			}


			x=document.forms["reportForm"]["actionRequest"].value;
			if (x==null || x=="") {
				alert("Please enter Action Request");
				return false;
			}
		}
<%
	}
%>
		return true;
	}

	function showconfirm(cmd, stp) {
		msg = '';

		if (stp == 'reject') {
			msg = 'Are you sure to reject this report ?';
		} else {
			msg = 'Are you sure to proceed ?';
		}

		$.prompt(msg,{
			buttons: { Ok: true, Cancel: false },
			callback: function(v,m,f){
				if (v ){
					if (validateForm(stp)) {
						submitAction2(cmd, stp);
					}
//					else {
//						alert("Please enter Severity of patient injury");
//					}
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

//		$('#select2 option').each(function(i) {
//			$(this).attr("selected", "selected");
//		});

//		if (window.removeEventListener) {    // all browsers except IE before version 9
//			window.removeEventListener("beforeunload", windowOnClose, false);
//		}

		$(window).unbind('beforeunload', windowOnClose);

		if ($.browser.msie) {
			document.form1.command.value = cmd;
			document.form1.pirPID.value = stp;
			document.form1.submit();
		} else {
			document.forms["reportForm"]["command"].value = cmd;
			document.forms["reportForm"]["pirPID"].value = stp;
			document.forms["reportForm"].submit();
		}

		$.prompt('Processing..... Please wait.',{
			buttons: { }, prefix:'cleanblue'
		});
	}

	function showhide(i, hideobj, showobj, showhidelink, hidelink, showlink){
		var showelem = document.getElementById(showobj + i);
		var hideelem = document.getElementById(hideobj + i);
		var linkelem=document.getElementById(showhidelink + i);

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
		//popupWindow = window.open(
		//	url,'popUpWindow','height=700,width=800,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')


		//return false;
	}

	// ajax
	var http = createRequestObject();

	function removeDocument(mid, did) {

		//alert('Are you sure?');
		$.prompt('Are you sure?',{
			buttons: { Ok: true, Cancel: false },
			callback: function(v,m,f){
				if (v ){
					http.open('get', '../common/document_list.jsp?command=delete&moduleCode=' + mid + '&keyID=<%=pirID %>&documentID=' + did + '&allowRemove=Y&timestamp=<%=(new java.util.Date()).getTime() %>');

					//store module code
					currModuleCode = mid;

					//assign a handler for the response
					http.onreadystatechange = processResponse;

					//actually send the request to the server
					http.send(null);

					return false;
				}
			},
			prefix:'cleanblue'
		});

		return false;
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById(currModuleCode + '_indicator').innerHTML = response;
		}
	}

	function changeStaffID(dept, label, indicator, fieldName, deptHead, subHead) {
		$.ajax({
			type: "POST",
			url: "../ui/staffIDCMB.jsp",
			data: "deptCode=" + dept.value + "&deptHead=" + deptHead + "&subHead=" + subHead + "&showDeptDesc=N&allowAll=Y",
			success: function(values) {
			if (values != '') {
				$("#" + indicator).html("<select name='" + fieldName + "'><option value=''>--" + label + "--</option>" + values + "</select>");
			}//if
			}//success
		});//$.ajax
	}
</script>