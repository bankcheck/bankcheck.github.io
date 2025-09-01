<%@ page import="java.math.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "command");
int stageInt = 1;
try {
	stageInt = Integer.parseInt(ParserUtil.getParameter(request, "stage"));
} catch (Exception e) {}
String specialty = ParserUtil.getParameter(request, "specialty");
String clientID = ParserUtil.getParameter(request, "clientID");

/* step 2 */
String appointedRoomType = ParserUtil.getParameter(request, "appointedRoomType");
String requestAppointmentDate1 = ParserUtil.getParameter(request, "requestAppointmentDate1");
String requestAppointmentDate2 = ParserUtil.getParameter(request, "requestAppointmentDate2");
String requestAppointmentDate3 = ParserUtil.getParameter(request, "requestAppointmentDate3");
String requestAppointmentDate4 = ParserUtil.getParameter(request, "requestAppointmentDate4");
String surgeryInfo = ParserUtil.getParameter(request, "surgeryInfo");
String typeOfDiagnosis = ParserUtil.getParameter(request, "typeOfDiagnosis");
String typeOfAnaesthesia = ParserUtil.getParameter(request, "typeOfAnaesthesia");
String attendingDoctor = ParserUtil.getParameter(request, "attendingDoctor");
String nameOfProcedure = ParserUtil.getParameter(request, "nameOfProcedure");
String onsetDateOfSymptoms = ParserUtil.getParameter(request, "onsetDateOfSymptoms");
String treatmentPlan = ParserUtil.getParameter(request, "treatmentPlan");
String estimatedLengthOfStay = ParserUtil.getParameter(request, "estimatedLengthOfStay");

String surgeonFee = ParserUtil.getParameter(request, "surgeonFee");
String wardRoundFee = ParserUtil.getParameter(request, "wardRoundFee");
String anaesthetistFee = ParserUtil.getParameter(request, "anaesthetistFee");

/* step 3 */
String procedureFee = ParserUtil.getParameter(request, "procedureFee");
String procedureFeeAdditional = ParserUtil.getParameter(request, "procedureFeeAdditional");

String admissionDate = ParserUtil.getDate(request, "admissionDate");
String selectAnotherDate = ParserUtil.getDate(request, "selectAnotherDate");

/* step 4 */
String confirmPatient = ParserUtil.getParameter(request, "confirmPatient");
boolean isConfirmPatient = ConstantsVariable.YES_VALUE.equals(confirmPatient);

String remark_hkah2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah2"));
String remark_ghc2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc2"));

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean addCommentAction = false;
boolean closeAction = false;
boolean letter1Action = false;
boolean letter2Action = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("letter1".equals(command)) {
	letter1Action = true;
} else if ("letter2".equals(command)) {
	letter2Action = true;
} else if ("addComment".equals(command)) {
	addCommentAction = true;
}

String allowRemove = createAction || updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;

boolean isOB = "ob".equals(specialty);
boolean isSurgical = "surgical".equals(specialty);
boolean isHA = "ha".equals(specialty);
boolean isCardiac = "cardiac".equals(specialty);
boolean isOncology = "oncology".equals(specialty);

boolean isGHC = userBean.isAccessible("function.ghc.client.create");
boolean isPhysician = !isGHC && !userBean.isStaff();
boolean isHKAH = !isPhysician && !isGHC;

double dailyRoomRateDouble = 0.0;
if (!createAction && !updateAction) {
	if ("PRIVATE".equals(appointedRoomType)) {
		dailyRoomRateDouble = 2980;
	} else if ("SEMI-PRIVATE".equals(appointedRoomType)) {
		dailyRoomRateDouble = 1680;
	}
}
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Step 2. Physician Information</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle2" colspan="4">Medical Information (Fill in by Physician)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Room Type</td>
		<td class="infoData" width="30%">
<%		if (isPhysician && (createAction || updateAction)) { %>
			<select name="appointedRoomType">
				<option value="PRIVATE"<%="PRIVATE".equals(appointedRoomType)?" selected":""%>>Private</option>
				<option value="SEMI-PRIVATE"<%="SEMI-PRIVATE".equals(appointedRoomType)?" selected":""%>>Semi-Private</option>
			</select>
<%		} else { %>
			<%=appointedRoomType==null?"":appointedRoomType.toUpperCase() %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Daily Room Rate</td>
		<td class="infoData" width="30%">
			$<%=dailyRoomRateDouble == 0 ? "--" : dailyRoomRateDouble %> per day
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoData">&nbsp;</td>
		<td class="infoData" colspan="3">
			<font color="red"><b>(Please do the admission 4 - 24 hours before operation!)</b></font>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Planning Date for Surgery<br/>(Choice #1)</td>
		<td class="infoData" width="30%">
<%		if (isPhysician && stageInt == 2 && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate1" id="requestAppointmentDate1" class="datepickerfield" value="<%=requestAppointmentDate1==null?"":requestAppointmentDate1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate1==null?"":requestAppointmentDate1 %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Planning Date for Surgery<br/>(Choice #3)</td>
		<td class="infoData" width="30%">
<%		if (isPhysician && stageInt == 2 && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate3" id="requestAppointmentDate3" class="datepickerfield" value="<%=requestAppointmentDate3==null?"":requestAppointmentDate3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate3==null?"":requestAppointmentDate3 %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Planning Date for Surgery<br/>(Choice #2)</td>
		<td class="infoData" width="30%">
<%		if (isPhysician && stageInt == 2 && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate2" id="requestAppointmentDate2" class="datepickerfield" value="<%=requestAppointmentDate2==null?"":requestAppointmentDate2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate2==null?"":requestAppointmentDate2 %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Planning Date for Surgery<br/>(Choice #4)</td>
		<td class="infoData" width="30%">
<%		if (isPhysician && stageInt == 2 && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate4" id="requestAppointmentDate4" class="datepickerfield" value="<%=requestAppointmentDate4==null?"":requestAppointmentDate4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate4==null?"":requestAppointmentDate4 %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Surgery Information</td>
		<td class="infoData" width="30%">
<%		if (isPhysician && (createAction || updateAction)) { %>
			<input type="text" name="surgeryInfo" value="<%=surgeryInfo==null?"":surgeryInfo %>" maxlength="50" size="30" />
<%		} else { %>
			<%=surgeryInfo==null?"":surgeryInfo %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Type of Diagnosis</td>
		<td class="infoData" width="30%">
<%		if (isPhysician && (createAction || updateAction)) { %>
			<input type="text" name="typeOfDiagnosis" value="<%=typeOfDiagnosis==null?"":typeOfDiagnosis %>" maxlength="50" size="30" />
<%		} else { %>
			<%=typeOfDiagnosis==null?"":typeOfDiagnosis %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Type of Anaesthesia</td>
		<td class="infoData" width="80%" colspan="3">
<%		if (isPhysician && (createAction || updateAction)) { %>
			<select name="typeOfAnaesthesia">
				<option value="general"<%="general".equals(typeOfAnaesthesia)?" selected":""%>>General Anaesthesia</option>
				<option value="local"<%="local".equals(typeOfAnaesthesia)?" selected":""%>>Local Anaesthesia</option>
			</select>
<%		} else { %>
			<%=typeOfAnaesthesia==null?"":typeOfAnaesthesia %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Name of Procedure</td>
		<td class="infoData" width="30%">
<%		if (isPhysician && (createAction || updateAction)) { %>
			<input type="text" name="nameOfProcedure" value="<%=nameOfProcedure==null?"":nameOfProcedure %>" maxlength="50" size="30" />
<%		} else { %>
			<%=nameOfProcedure==null?"":nameOfProcedure %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Onset Date of Symptoms</td>
		<td class="infoData" width="30%">
<%		if (isPhysician && (createAction || updateAction)) { %>
			<input type="text" name="onsetDateOfSymptoms" id="onsetDateOfSymptoms" class="datepickerfield" value="<%=onsetDateOfSymptoms==null?"":onsetDateOfSymptoms %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=onsetDateOfSymptoms==null?"":onsetDateOfSymptoms %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Treatment Plan</td>
		<td class="infoData" width="30%">
<%		if (isPhysician && (createAction || updateAction)) { %>
			<input type="file" name="treatmentPlan" size="50" class="multi" maxlength="1">
<%		} %>
<%		if (!createAction && treatmentPlan != null && treatmentPlan.length() > 0) { %>
			<a href="/upload/GHC/<%=clientID %>/<%=treatmentPlan %>" target="_blank"><%=treatmentPlan %></a>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Estimated Length of Stay</td>
		<td class="infoData" width="30%">
<%		if (isPhysician && (createAction || updateAction)) { %>
			<input type="text" name="estimatedLengthOfStay" value="<%=estimatedLengthOfStay==null?"":estimatedLengthOfStay %>" maxlength="50" size="30" />
<%		} else { %>
			<%=estimatedLengthOfStay==null?"":estimatedLengthOfStay %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Unavailable Planning Date for Surgery</td>
		<td class="infoData" colspan="3">
<jsp:include page="apply_reject_date.jsp" flush="false">
	<jsp:param name="clientID" value="<%=clientID %>" />
</jsp:include>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle2" colspan="4">Estimation Cost (Fill in by Physician)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Surgeon Fee</td>
		<td class="infoData" width="30%">$
<%		if (isPhysician && (createAction || updateAction)) { %>
			<input type="text" name="surgeonFee" value="<%=surgeonFee==null?"":surgeonFee %>" maxlength="50" size="30" />
<%		} else { %>
			<%=surgeonFee == null ? "--" : surgeonFee %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Ward Round Fee (per day)</td>
		<td class="infoData" width="30%">$
<%		if (isPhysician && (createAction || updateAction)) { %>
			<input type="text" name="wardRoundFee" value="<%=wardRoundFee==null?"":wardRoundFee %>" maxlength="50" size="30" />
<%		} else { %>
			<%=wardRoundFee == null ? "" : wardRoundFee %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Anaesthetist Fee</td>
		<td class="infoData" width="80%" colspan="3">$
<%		if (isPhysician && (createAction || updateAction)) { %>
			<input type="text" name="anaesthetistFee" value="<%=anaesthetistFee==null?"":anaesthetistFee %>" maxlength="50" size="30" />
<%		} else { %>
			<%=anaesthetistFee==null?"":anaesthetistFee %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle3" colspan="4">Hospital Information & Charges (Fill in by HKAH)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Preparation for Surgery File</td>
		<td class="infoData" width="80%" colspan="3">
<%	if (isHKAH && (createAction || updateAction)) { %>
		<input type="file" name="prepareSurgery" size="50" class="multi" maxlength="10">
<%	} %>
<%	if (!createAction) { %>
		<span id="ghc.prepareSurgery_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ghc.prepareSurgery" />
	<jsp:param name="keyID" value="<%=clientID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
		</span>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Admission Date</td>
		<td class="infoData" width="30%">
<%	if (isHKAH && (createAction || updateAction)) { %>
			<input type="textfield" name="admissionDate" id="admissionDate" class="datepickerfield" value="<%=admissionDate==null?"":admissionDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else { %>
			<%=admissionDate==null?"":admissionDate %>
<%	} %>
		</td>
<%	if (isHKAH && (createAction || updateAction)) { %>
		<td class="infoLabel" width="20%">GHC Re-selects date</td>
		<td class="infoData" width="30">
			<input type="checkbox" name="selectAnotherDate" value="Y"<%="Y".equals(selectAnotherDate)?" checked":"" %>><bean:message key="label.yes" />
		</td>
<%	} else {%>
		<td class="infoData" colspan="2">&nbsp;</td>
<%	} %>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Information for Surgery File</td>
		<td class="infoData" width="80%" colspan="3">
<%	if (isHKAH && (createAction || updateAction)) { %>
		<input type="file" name="infoSurgery" size="50" class="multi" maxlength="10">
<%	} %>
<%	if (!createAction) { %>
		<span id="ghc.infoSurgery_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ghc.infoSurgery" />
	<jsp:param name="keyID" value="<%=clientID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
		</span>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Hospital Fee</td>
		<td class="infoData" width="30%" colspan="3">$
<%	if (isHKAH && (createAction || updateAction)) { %>
			<input type="text" name="procedureFee" value="<%=procedureFee==null?"":procedureFee %>" maxlength="50" size="30" />
<%	} else { %>
			<%=procedureFee==null?"":procedureFee %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Patient Confirmed</td>
		<td class="infoData" width="80%" colspan="3">
<%			if (isGHC  || isHKAH &&  (createAction || updateAction)) { %>
			<input type="radio" name="confirmPatient" value="Y"<%=!ConstantsVariable.NO_VALUE.equals(confirmPatient)?" checked":"" %> /><img src="../images/tick_green_small.gif" />
			<input type="radio" name="confirmPatient" value="N"<%=ConstantsVariable.NO_VALUE.equals(confirmPatient)?" checked":"" %> /><img src="../images/cross_red_small.gif" />
<%			} else {
				if (ConstantsVariable.YES_VALUE.equals(confirmPatient)) {
				%><img src="../images/tick_green_small.gif" /><%
				} else {
				%><img src="../images/cross_red_small.gif" /><%
				}
			} %>
		<font color="red"><b>(The application will not proceed to step 3 if not confirmed)</b></font>
		</td>
	</tr>
<%	if (!createAction && !updateAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Generate Estimation Cost</td>
		<td class="infoData" width="80%" colspan="3">
			<button onclick="return submitAction('quotation', 0, 0);" class="btn-click">View</button>
		</td>
	</tr>
<%	} %>
	<tr class="smallText">
		<td class="infoSubTitle2" colspan="4">Remarks</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">HKAH <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%		if (!isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_hkah2" rows="3" cols="100"><%=remark_hkah2==null?"":remark_hkah2 %></textarea>
<%		} else { %>
			<%=remark_hkah2==null?"":remark_hkah2 %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">GHC <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%		if (isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_ghc2" rows="3" cols="100"><%=remark_ghc2==null?"":remark_ghc2 %></textarea>
<%		} else { %>
			<%=remark_ghc2==null?"":remark_ghc2 %>
<%		} %>
		</td>
	</tr>
<script language="javascript">
<!--
	$("#form1").validate({
		event: "keyup",
		errorClass: "errormsg",
		rules: {
			requestAppointmentDate1: { dateISO:true },
			requestAppointmentDate2: { dateISO:true },
			requestAppointmentDate3: { dateISO:true },
			requestAppointmentDate4: { dateISO:true }
		},
		messages: {
			requestAppointmentDate1: { dateISO: "<bean:message key="error.date.invalid" />" },
			requestAppointmentDate2: { dateISO: "<bean:message key="error.date.invalid" />" },
			requestAppointmentDate3: { dateISO: "<bean:message key="error.date.invalid" />" },
			requestAppointmentDate4: { dateISO: "<bean:message key="error.date.invalid" />" }
		}
	});

	function submitAction_step2(cmd, stp, conf) {
<%	if (isPhysician && (createAction || updateAction)) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.requestAppointmentDate1.length > 0 && !validDate(document.form1.requestAppointmentDate1)) {
				alert("<bean:message key="error.date.invalid" /> 1.");
				document.form1.requestAppointmentDate1.focus();
				return false;
			}
			if (document.form1.requestAppointmentDate2.length > 0 && !validDate(document.form1.requestAppointmentDate2)) {
				alert("<bean:message key="error.date.invalid" /> 2.");
				document.form1.requestAppointmentDate2.focus();
				return false;
			}
			if (document.form1.requestAppointmentDate3.length > 0 && !validDate(document.form1.requestAppointmentDate3)) {
				alert("<bean:message key="error.date.invalid" /> 3.");
				document.form1.requestAppointmentDate3.focus();
				return false;
			}
			if (document.form1.requestAppointmentDate4.length > 0 && !validDate(document.form1.requestAppointmentDate4)) {
				alert("<bean:message key="error.date.invalid" /> 4.");
				document.form1.requestAppointmentDate4.focus();
				return false;
			}
		}
<%	} %>
		return true;
	}
-->
</script>