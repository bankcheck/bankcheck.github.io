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

/* step 1 */
String lastName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "lastName"));
String firstName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "firstName"));
String chineseName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "chineseName"));
String email = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "email"));

String DOBDate = ParserUtil.getParameter(request, "DOBDate");
String travelDocNo = TextUtil.parseStr(ParserUtil.getParameter(request, "travelDocNo")).toUpperCase();
String homePhone = ParserUtil.getParameter(request, "homePhone");
String mobilePhone = ParserUtil.getParameter(request, "mobilePhone");

String attendingDoctor = ParserUtil.getParameter(request, "attendingDoctor");

String insuranceYN = ParserUtil.getParameter(request, "insuranceYN");
String insuranceCompanyID = TextUtil.parseStr(ParserUtil.getParameter(request, "insuranceCompanyID"));
String insuranceCompanyName = TextUtil.parseStr(ParserUtil.getParameter(request, "insuranceCompanyName"));
String insurancePolicyNo = TextUtil.parseStr(ParserUtil.getParameter(request, "insurancePolicyNo"));
String insurancePolicyHolderName = TextUtil.parseStr(ParserUtil.getParameter(request, "insurancePolicyHolderName"));
String insurancePolicyGroup = TextUtil.parseStr(ParserUtil.getParameter(request, "insurancePolicyGroup"));
String insuranceValidThru = TextUtil.parseStr(ParserUtil.getParameter(request, "insuranceValidThru"));

String remark_hkah1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah1"));
String remark_ghc1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc1"));

/* step 2 */
String appointedRoomType = ParserUtil.getParameter(request, "appointedRoomType");
String requestAppointmentDate1 = ParserUtil.getParameter(request, "requestAppointmentDate1");
String requestAppointmentDate2 = ParserUtil.getParameter(request, "requestAppointmentDate2");
String requestAppointmentDate3 = ParserUtil.getParameter(request, "requestAppointmentDate3");
String requestAppointmentDate4 = ParserUtil.getParameter(request, "requestAppointmentDate4");

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
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Step 1. Registration</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="4">Patient Information (Fill in by GHC)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><font color="red">*</font><bean:message key="prompt.lastName" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="lastName" value="<%=lastName==null?"":lastName %>" maxlength="50" size="25">
<%	} else { %>
			<%=lastName==null?"":lastName %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><font color="red">*</font><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="firstName" value="<%=firstName==null?"":firstName %>" maxlength="50" size="25">
<%	} else { %>
			<%=firstName==null?"":firstName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="chineseName" value="<%=chineseName==null?"":chineseName %>" maxlength="30" size="25">
<%	} else { %>
			<%=chineseName==null?"":chineseName %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><font color="red">*</font><bean:message key="prompt.email" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="email" value="<%=email==null?"":email %>" maxlength="30" size="25">
<%	} else { %>
			<%=email==null?"":email %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><font color="red">*</font><bean:message key="prompt.dateOfBirth" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="DOBDate" id="DOBDate" class="datepickerfield" value="<%=DOBDate==null?"":DOBDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else { %>
			<%=DOBDate==null?"":DOBDate %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><font color="red">*</font>Travel Document No.</td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="travelDocNo" value="<%=travelDocNo==null?"":travelDocNo %>" maxlength="50" size="25">
<%	} else { %>
			<%=travelDocNo==null?"":travelDocNo %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.homePhone" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="homePhone" value="<%=homePhone==null?"":homePhone %>" maxlength="50" size="25">
<%	} else { %>
			<%=homePhone==null?"":homePhone %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.mobilePhone" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="mobilePhone" value="<%=mobilePhone==null?"":mobilePhone %>" maxlength="50" size="25">
<%	} else { %>
			<%=mobilePhone==null?"":mobilePhone %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Consent Form</td>
		<td class="infoData" width="80%" colspan="3">
<%	if (isGHC && (createAction || updateAction)) {%>
		<input type="file" name="regForm" size="50" class="multi" maxlength="10">
		<a href="/upload/GHC/Consent for Release of Medical Records Eng.doc">Original Consent Form</a>
<%	} %>
<%	if (!createAction) { %>
		<span id="ghc.regForm_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ghc.regForm" />
	<jsp:param name="keyID" value="<%=clientID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
		</span>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.specialty" /></td>
		<td class="infoData" width="30%">
<%	if (isOB) {
		%><bean:message key="label.ob" /><%
	} else if (isSurgical) {
		%><bean:message key="label.surgical" /><%
	} else if (isHA) {
		%><bean:message key="label.ha" /><%
	} else if (isCardiac) {
		%><bean:message key="label.cardiac" /><%
	} else if (isOncology) {
		%><bean:message key="label.oncology" /><%
	}%>
		</td>
		<td class="infoLabel" width="20%"><font color="red">*</font>Treating Doctor</td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<select name="attendingDoctor" onchange="return changeAttendingDoctor()">
				<option value=""></option>
				<option value="DR. KWAN, TIM LOK HENRY"<%="DR. KWAN, TIM LOK HENRY".equals(attendingDoctor)?" selected":"" %>>DR. KWAN, TIM LOK HENRY</option>
				<option value="DR. KWOK, PO YIN SAMUEL"<%="DR. KWOK, PO YIN SAMUEL".equals(attendingDoctor)?" selected":"" %>>DR. KWOK, PO YIN SAMUEL</option>
			</select>
			<span id="doctorSchedule_indicator">
<%	} else { %>
			<%=attendingDoctor==null?"":attendingDoctor %><br/>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="4">Insurance (Fill in by GHC)</td>
	</tr>
	<tr class="smallText">
		<td class="infoData" width="100%" colspan="4">
			To be filled to obtain pre-authorization through HKAH?
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="radio" name="insuranceYN" value="Y"<%=!"N".equals(insuranceYN)?" checked":"" %> /><img src="../images/tick_green_small.gif" />
			<input type="radio" name="insuranceYN" value="N"<%="N".equals(insuranceYN)?" checked":"" %> /><img src="../images/cross_red_small.gif" />
<%	} else {
			if (ConstantsVariable.YES_VALUE.equals(insuranceYN)) {
				%><img src="../images/tick_green_small.gif" /><%
		} else {
				%><img src="../images/cross_red_small.gif" /><%
		}
	} %> (If <img src="../images/tick_green_small.gif" />, please complete the following information.)
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Insurance Company Name</td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="text" name="insuranceCompanyName" value="<%=insuranceCompanyName==null?"":insuranceCompanyName %>" maxlength="50" size="30" />
<%	} else { %>
			<%=insuranceCompanyName==null?"":insuranceCompanyName.toUpperCase() %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%">Policy No.</td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="text" name="insurancePolicyNo" value="<%=insurancePolicyNo==null?"":insurancePolicyNo %>" maxlength="50" size="30" />
<%	} else { %>
			<%=insurancePolicyNo==null?"":insurancePolicyNo.toUpperCase() %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Policy Holder's Name</td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="text" name="insurancePolicyHolderName" value="<%=insurancePolicyHolderName==null?"":insurancePolicyHolderName %>" maxlength="50" size="30" />
<%	} else { %>
			<%=insurancePolicyHolderName==null?"":insurancePolicyHolderName.toUpperCase() %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%">Other Group or employer' name<br/>(if applicable)</td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="text" name="insurancePolicyGroup" value="<%=insurancePolicyGroup==null?"":insurancePolicyGroup %>" maxlength="50" size="30" />
<%	} else { %>
			<%=insurancePolicyGroup==null?"":insurancePolicyGroup.toUpperCase() %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Valid thru</td>
		<td class="infoData" width="30%" colspan="3">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="insuranceValidThru" class="datepickerfield" id="insuranceValidThru" value="<%=insuranceValidThru==null?"":insuranceValidThru %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else { %>
			<%=insuranceValidThru==null?"":insuranceValidThru.toUpperCase() %>
<%	} %>
		</td>
	</tr>
<%	if (stageInt == 1) { %>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="4">Medical Information (Fill in by GHC)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Room Type</td>
		<td class="infoData" width="30%">
<%		if (isGHC && (createAction || updateAction)) { %>
			<select name="appointedRoomType">
				<option value="PRIVATE"<%="PRIVATE".equals(appointedRoomType)?" selected":""%>>Private</option>
				<option value="SEMI-PRIVATE"<%="SEMI-PRIVATE".equals(appointedRoomType)?" selected":""%>>Semi-Private</option>
			</select>
<%		} else { %>
			<%=appointedRoomType==null?"":appointedRoomType.toUpperCase() %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Daily Room Rate</td>
		<td class="infoData" width="30%">--</td>
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
<%		if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate1" id="requestAppointmentDate1" class="datepickerfield" value="<%=requestAppointmentDate1==null?"":requestAppointmentDate1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate1==null?"":requestAppointmentDate1 %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Planning Date for Surgery<br/>(Choice #3)</td>
		<td class="infoData" width="30%">
<%		if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate3" id="requestAppointmentDate3" class="datepickerfield" value="<%=requestAppointmentDate3==null?"":requestAppointmentDate3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate3==null?"":requestAppointmentDate3 %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Planning Date for Surgery<br/>(Choice #2)</td>
		<td class="infoData" width="30%">
<%		if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate2" id="requestAppointmentDate2" class="datepickerfield" value="<%=requestAppointmentDate2==null?"":requestAppointmentDate2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate2==null?"":requestAppointmentDate2 %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Planning Date for Surgery<br/>(Choice #4)</td>
		<td class="infoData" width="30%">
<%		if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate4" id="requestAppointmentDate4" class="datepickerfield" value="<%=requestAppointmentDate4==null?"":requestAppointmentDate4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate4==null?"":requestAppointmentDate4 %>
<%		} %>
		</td>
	</tr>
<%	} %>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="4">Remarks</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">HKAH <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%		if (!isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_hkah1" rows="3" cols="100"><%=remark_hkah1==null?"":remark_hkah1 %></textarea>
<%		} else { %>
			<%=remark_hkah1==null?"":remark_hkah1 %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">GHC <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%		if (isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_ghc1" rows="3" cols="100"><%=remark_ghc1==null?"":remark_ghc1 %></textarea>
<%		} else { %>
			<%=remark_ghc1==null?"":remark_ghc1 %>
<%		} %>
		</td>
	</tr>
<script language="javascript">
<!--
	$("#form1").validate({
		event: "keyup",
		errorClass: "errormsg",
		rules: {
			lastName: { required: true },
			firstName: { required: true },
			email: { required: true, email:true },
			DOBDate: { required: true, dateISO:true },
			travelDocNo: { required: true },
			insuranceValidThru: { dateISO:true },
			requestAppointmentDate1: { dateISO:true },
			requestAppointmentDate2: { dateISO:true },
			requestAppointmentDate3: { dateISO:true },
			requestAppointmentDate4: { dateISO:true }
		},
		messages: {
			lastName: { required: "<bean:message key="error.lastName.required" />" },
			firstName: { required: "<bean:message key="error.firstName.required" />" },
			email: { required: "<bean:message key="error.email.required" />", email: "<bean:message key="error.email.invalid" />" },
			DOBDate: { required: "<bean:message key="error.dateOfBirth.required" />", dateISO: "<bean:message key="error.dateOfBirth.invalid" />" },
			travelDocNo: { required: "Empty travel document number." },
			insuranceValidThru: { dateISO: "<bean:message key="error.date.invalid" />" },
			requestAppointmentDate1: { dateISO: "<bean:message key="error.date.invalid" />" },
			requestAppointmentDate2: { dateISO: "<bean:message key="error.date.invalid" />" },
			requestAppointmentDate3: { dateISO: "<bean:message key="error.date.invalid" />" },
			requestAppointmentDate4: { dateISO: "<bean:message key="error.date.invalid" />" }
		}
	});

	function submitAction_step1(cmd, stp, conf) {
<%	if (isGHC && (createAction || updateAction)) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.lastName.value == '') {
				alert("<bean:message key="error.lastName.required" />.");
				document.form1.lastName.focus();
				return false;
			}
			if (document.form1.firstName.value == '') {
				alert("<bean:message key="error.firstName.required" />.");
				document.form1.firstName.focus();
				return false;
			}
			if (document.form1.email.value == '') {
				alert("<bean:message key="error.email.required" />.");
				document.form1.email.focus();
				return false;
			}
			if (document.form1.DOBDate.value == '') {
				alert("<bean:message key="error.dateOfBirth.required" />.");
				document.form1.DOBDate.focus();
				return false;
			}
			if (!validDate(document.form1.DOBDate)) {
				alert("<bean:message key="error.dateOfBirth.invalid" />.");
				document.form1.DOBDate.focus();
				return false;
			}
			if (document.form1.travelDocNo.value == '') {
				alert("Empty travel document number.");
				document.form1.travelDocNo.focus();
				return false;
			}
			if (document.form1.attendingDoctor.value == '') {
				alert("Empty Treating Doctor.");
				document.form1.attendingDoctor.focus();
				return false;
			}
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