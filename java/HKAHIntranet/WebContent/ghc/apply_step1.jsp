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

String kinLastName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "kinLastName"));
String kinFirstName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "kinFirstName"));
String kinChineseName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "kinChineseName"));
String kinEmail = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "kinEmail"));
String kinDOBDate = ParserUtil.getParameter(request, "kinDOBDate");
String kinTravelDocNo = TextUtil.parseStr(ParserUtil.getParameter(request, "kinTravelDocNo")).toUpperCase();

String homePhone = ParserUtil.getParameter(request, "homePhone");
String mobilePhone = ParserUtil.getParameter(request, "mobilePhone");
String attendingDoctor = ParserUtil.getParameter(request, "attendingDoctor");
String expectedDeliveryDate = ParserUtil.getParameter(request, "expectedDeliveryDate");

String requestAppointmentDate1 = ParserUtil.getParameter(request, "requestAppointmentDate1");
String requestAppointmentDate2 = ParserUtil.getParameter(request, "requestAppointmentDate2");
String requestAppointmentDate3 = ParserUtil.getParameter(request, "requestAppointmentDate3");
String requestAppointmentDate4 = ParserUtil.getParameter(request, "requestAppointmentDate4");
String appointedRoomType = ParserUtil.getParameter(request, "appointedRoomType");
String insuranceCompanyName = TextUtil.parseStr(ParserUtil.getParameter(request, "insuranceCompanyName"));
String insurancePolicyNo = TextUtil.parseStr(ParserUtil.getParameter(request, "insurancePolicyNo"));
String confirmPatient = ParserUtil.getParameter(request, "confirmPatient");

String remark_hkah1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah1"));
String remark_ghc1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc1"));

boolean createAction = false;
boolean updateAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
}

String allowRemove = createAction || updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;

boolean isOB = "ob".equals(specialty);
boolean isSurgical = "surgical".equals(specialty);
boolean isHA = "ha".equals(specialty);
boolean isCardiac = "cardiac".equals(specialty);
boolean isOncology = "oncology".equals(specialty);

boolean stageOne = stageInt == 1;

boolean isGHC = userBean.isAccessible("function.ghc.client.create");
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Step 1. Fill in By GHC</td>
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
<%	if (isOB) { %>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="4">Baby's Father Information (Fill in by GHC)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData" width="30%">
<%		if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="kinLastName" value="<%=kinLastName==null?"":kinLastName %>" maxlength="50" size="25">
<%		} else { %>
			<%=kinLastName==null?"":kinLastName %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="30%">
<%		if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="kinFirstName" value="<%=kinFirstName==null?"":kinFirstName %>" maxlength="50" size="25">
<%		} else { %>
			<%=kinFirstName==null?"":kinFirstName %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData" width="30%">
<%		if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="kinChineseName" value="<%=kinChineseName==null?"":kinChineseName %>" maxlength="30" size="25">
<%		} else { %>
			<%=kinChineseName==null?"":kinChineseName %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.email" /></td>
		<td class="infoData" width="30%">
<%		if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="kinEmail" value="<%=kinEmail==null?"":kinEmail %>" maxlength="30" size="25">
<%		} else { %>
			<%=kinEmail==null?"":kinEmail %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><font color="red">*</font><bean:message key="prompt.dateOfBirth" /></td>
		<td class="infoData" width="30%">
<%		if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="kinDOBDate" id="kinDOBDate" class="datepickerfield" value="<%=kinDOBDate==null?"":kinDOBDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=kinDOBDate==null?"":kinDOBDate %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Travel Document No.</td>
		<td class="infoData" width="30%">
<%		if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="kinTravelDocNo" value="<%=kinTravelDocNo==null?"":kinTravelDocNo %>" maxlength="50" size="25">
<%		} else { %>
			<%=kinTravelDocNo==null?"":kinTravelDocNo %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="4">Other Information (Fill in by GHC)</td>
	</tr>
<%	} %>
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
		<td class="infoLabel" width="20%">Registration Form</td>
		<td class="infoData" width="80%" colspan="3">
<%	if (createAction || updateAction) {%>
		<input type="file" name="regForm" size="50" class="multi" maxlength="10">
<%	} %>
<%	if (!createAction) { %>
		<span id="regForm_indicator">
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
<%			if (isOB) {
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
		<td class="infoLabel" width="20%"><font color="red">*</font><bean:message key="prompt.attendingDoctor" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && stageOne && (createAction || updateAction)) { %>
			<select name="attendingDoctor" onchange="return changeAttendingDoctor()">
				<option value=""></option>
<%		if (isOB) { %>
				<option value="DR. CHAN, YIK MING JOE"<%="DR. CHAN, YIK MING JOE".equals(attendingDoctor)?" selected":"" %>>DR. CHAN, YIK MING JOE</option>
				<!--option value="DR. CHOW, CHUN HING STEPHANINE"<%="DR. CHOW, CHUN HING STEPHANINE".equals(attendingDoctor)?" selected":"" %>>DR. CHOW, CHUN HING STEPHANINE</option-->
				<option value="DR. PANG, MAN WAH SELINA"<%="DR. PANG, MAN WAH SELINA".equals(attendingDoctor)?" selected":"" %>>DR. PANG, MAN WAH SELINA</option>
				<!--option value="DR. TSAI, YUAN MIAO ALBERT"<%="DR. TSAI, YUAN MIAO ALBERT".equals(attendingDoctor)?" selected":"" %>>DR. TSAI, YUAN MIAO ALBERT</option-->
				<!--option value="DR. STEVENSON, ROBERT"<%="DR. STEVENSON, ROBERT".equals(attendingDoctor)?" selected":"" %>>DR. STEVENSON, ROBERT</option-->
				<option value="DR. NGAI, SUK WAI CORA"<%="DR. NGAI, SUK WAI CORA".equals(attendingDoctor)?" selected":"" %>>DR. NGAI, SUK WAI CORA</option>
<%		} else if (isHA) { %>
				<option value="DR. LEE, MONICA"<%="DR. LEE, MONICA".equals(attendingDoctor)?" selected":"" %>>DR. LEE, MONICA</option>
				<option value="DR. KING, PETER"<%="DR. KING, PETER".equals(attendingDoctor)?" selected":"" %>>DR. KING, PETER</option>
				<option value="DR. PEI, GLORIA"<%="DR. PEI, GLORIA".equals(attendingDoctor)?" selected":"" %>>DR. PEI, GLORIA</option>
<%		} else if (isCardiac) { %>
				<option value="DR. KING, PETER"<%="DR. KING, PETER".equals(attendingDoctor)?" selected":"" %>>DR. KING, PETER</option>
<%		} else if (isOncology) { %>
				<option value="DR. TSEUNG VICTOR"<%="DR. TSEUNG VICTOR".equals(attendingDoctor)?" selected":"" %>>DR. TSEUNG VICTOR</option>
<%		} %>
			</select>
			<span id="doctorSchedule_indicator">
<%	} else { %>
			<%=attendingDoctor==null?"":attendingDoctor %><br/>
<%	} %>
		</td>
	</tr>
<%	if (isOB) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Expected Confinement Date</td>
		<td class="infoData" colspan="3">
<%		if (isGHC && stageOne && (createAction || updateAction)) { %>
			<input type="textfield" name="expectedDeliveryDate" id="expectedDeliveryDate" class="datepickerfield" value="<%=expectedDeliveryDate==null?"":expectedDeliveryDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=expectedDeliveryDate==null?"":expectedDeliveryDate %>
<%		} %>
		<font color="red"><b>(Suggest pre-natal check to be 20 weeks or before)</b></font></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Suggested Appointment Date Range</td>
		<td class="infoData" colspan="3">
			<span id="showAppointmentDate_indicator">
<jsp:include page="calculateAppointmentDateRange.jsp" flush="false">
	<jsp:param name="expectedDeliveryDate" value="<%=expectedDeliveryDate %>" />
</jsp:include>
			</span></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Rejected Appointment Date</td>
		<td class="infoData" colspan="3">
<jsp:include page="apply_reject_date.jsp" flush="false">
	<jsp:param name="clientID" value="<%=clientID %>" />
</jsp:include>
		</td>
	</tr>
<%	} %>
<%	if (isCardiac || isOncology) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Request Appointment at Outpatient</td>
		<td class="infoData" colspan="3">
<%		if (isGHC && stageOne && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate1" id="requestAppointmentDate1" class="datepickerfield" value="<%=requestAppointmentDate1==null?"":requestAppointmentDate1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate1==null?"":requestAppointmentDate1 %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Request CCIC Date</td>
		<td class="infoData" colspan="3">
<%		if (isGHC && stageOne && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate2" id="requestAppointmentDate2" class="datepickerfield" value="<%=requestAppointmentDate2==null?"":requestAppointmentDate2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate2==null?"":requestAppointmentDate2 %>
<%		} %>
		</td>
	</tr>
	<tr>
		<td class="infoLabel" width="20%">Request Admission Date</td>
		<td class="infoData" colspan="3">
<%		if (isGHC && stageOne && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate3" id="requestAppointmentDate3" class="datepickerfield" value="<%=requestAppointmentDate3==null?"":requestAppointmentDate3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate3==null?"":requestAppointmentDate3 %>
<%		} %>
		</td>
	</tr>
<%	} else if (!isSurgical) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Request Appointment Date<br/>(Choice #1)</td>
		<td class="infoData" width="30%">
<%		if (isGHC && stageOne && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate1" id="requestAppointmentDate1" class="datepickerfield" value="<%=requestAppointmentDate1==null?"":requestAppointmentDate1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate1==null?"":requestAppointmentDate1 %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Request Appointment Date<br/>(Choice #3)</td>
		<td class="infoData" width="30%">
<%		if (isGHC && stageOne && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate3" id="requestAppointmentDate3" class="datepickerfield" value="<%=requestAppointmentDate3==null?"":requestAppointmentDate3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate3==null?"":requestAppointmentDate3 %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Request Appointment Date<br/>(Choice #2)</td>
		<td class="infoData" width="30%">
<%		if (isGHC && stageOne && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate2" id="requestAppointmentDate2" class="datepickerfield" value="<%=requestAppointmentDate2==null?"":requestAppointmentDate2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate2==null?"":requestAppointmentDate2 %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Request Appointment Date<br/>(Choice #4)</td>
		<td class="infoData" width="30%">
<%		if (isGHC && stageOne && (createAction || updateAction)) { %>
			<input type="textfield" name="requestAppointmentDate4" id="requestAppointmentDate4" class="datepickerfield" value="<%=requestAppointmentDate4==null?"":requestAppointmentDate4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=requestAppointmentDate4==null?"":requestAppointmentDate4 %>
<%		} %>
		</td>
	</tr>
<%	} %>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.document" /></td>
		<td class="infoData" width="80%" colspan="3">
			<span id="showGHCDocument_indicator">
<%		if (!createAction) { %>
<jsp:include page="../common/attach_document.jsp" flush="false">
	<jsp:param name="moduleID" value="ghc" />
	<jsp:param name="keyID" value="<%=clientID %>" />
	<jsp:param name="key2ID" value="0" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
<%		} %>
			</span>
<%		if (createAction || updateAction) { %>
			<input type="file" name="file1" size="50" class="multi" maxlength="10">
<%		} %>
		</td>
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
			kinDOBDate: { required: false, dateISO:true }
		},
		messages: {
			lastName: { required: "<bean:message key="error.lastName.required" />" },
			firstName: { required: "<bean:message key="error.firstName.required" />" },
			email: { required: "<bean:message key="error.email.required" />", email: "<bean:message key="error.email.invalid" />" },
			DOBDate: { required: "<bean:message key="error.dateOfBirth.required" />", dateISO: "<bean:message key="error.dateOfBirth.invalid" />" },
			travelDocNo: { required: "Empty travel document number." },
			kinDOBDate: { required: "<bean:message key="error.dateOfBirth.required" />", dateISO: "<bean:message key="error.dateOfBirth.invalid" />" }
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
<%		if (isOB) { %>
			if (!validDate(document.form1.kinDOBDate)) {
				alert("<bean:message key="error.dateOfBirth.invalid" />.");
				document.form1.kinDOBDate.focus();
				return false;
			}
<%		} %>
			if (document.form1.attendingDoctor.value == '') {
				alert("Empty Attending Doctor.");
				document.form1.attendingDoctor.focus();
				return false;
			}
		}
<%	} %>
		return true;
	}
-->
</script>