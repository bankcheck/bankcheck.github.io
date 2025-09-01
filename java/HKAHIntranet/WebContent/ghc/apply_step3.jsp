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

/* step 3 */
String acceptAppointmentDate1 = ParserUtil.getDate(request, "acceptAppointmentDate1");
String acceptAppointmentDate2 = ParserUtil.getDate(request, "acceptAppointmentDate2");
String acceptAppointmentDate3 = ParserUtil.getDate(request, "acceptAppointmentDate3");
String acceptAppointmentDate4 = ParserUtil.getDate(request, "acceptAppointmentDate4");
String acknowledgeAppointmentDate1 = ParserUtil.getDate(request, "acknowledgeAppointmentDate1");
String acknowledgeAppointmentDate2 = ParserUtil.getDate(request, "acknowledgeAppointmentDate2");
String acknowledgeAppointmentDate3 = ParserUtil.getDate(request, "acknowledgeAppointmentDate3");
String acknowledgeAppointmentDate4 = ParserUtil.getDate(request, "acknowledgeAppointmentDate4");

String patientArrivalDate1 = ParserUtil.getDate(request, "patientArrivalDate1");
String flightInfo1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "flightInfo1"));
String transportMethod1 = ParserUtil.getParameter(request, "transportMethod1");
String transportArrangeBy1 = ParserUtil.getParameter(request, "transportArrangeBy1");
String hotalInfo1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "hotalInfo1"));
String hotalArrangeBy1 = ParserUtil.getParameter(request, "hotalArrangeBy1");
String patientReminderDate1 = ParserUtil.getDate(request, "patientReminderDate1");
String patientReminderLetterDate1 = ParserUtil.getParameter(request, "patientReminderLetterDate1");
String patientReminderMethod1 = ParserUtil.getParameter(request, "patientReminderMethod1");
String patientReminderRemark1 = ParserUtil.getParameter(request, "patientReminderRemark1");

String remark_hkah3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah3"));
String remark_ghc3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc3"));

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
}

boolean isOB = "ob".equals(specialty);
boolean isSurgical = "surgical".equals(specialty);
boolean isCardiac = "cardiac".equals(specialty);
boolean isOncology = "oncology".equals(specialty);

boolean stageThree = stageInt == 3;

boolean isGHC = userBean.isAccessible("function.ghc.client.create");
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Step 3. Confirmation and Generate Letter from GHC<%if (isOB) { %> (For Prenatal Check)<%} %></td>
	</tr>
<%	if (isSurgical) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Acceptance of Outpatient Appointment Date</td>
		<td class="infoData" colspan="3">
<%		if (isGHC && stageThree && (createAction || updateAction)) { %>
			<input type="radio" name="acceptAppointmentDate1" value="Y"<%="Y".equals(acceptAppointmentDate1)?" checked":"" %>><bean:message key="label.yes" />
			<input type="radio" name="acceptAppointmentDate1" value="N"<%=!"Y".equals(acceptAppointmentDate1)?" checked":"" %>><bean:message key="label.no" />
<%		} else {
			if ("Y".equals(acceptAppointmentDate1)) {
				%><bean:message key="label.yes" /><%
			} else if ("N".equals(acceptAppointmentDate1)) {
				%><bean:message key="label.no" /><%
			}
		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Acceptance of Operation Date</td>
		<td class="infoData" colspan="3">
<%		if (isGHC && stageThree && (createAction || updateAction)) { %>
			<input type="radio" name="acceptAppointmentDate2" value="Y"<%="Y".equals(acceptAppointmentDate2)?" checked":"" %>><bean:message key="label.yes" />
			<input type="radio" name="acceptAppointmentDate2" value="N"<%=!"Y".equals(acceptAppointmentDate2)?" checked":"" %>><bean:message key="label.no" />
<%		} else {
			if ("Y".equals(acceptAppointmentDate2)) {
				%><bean:message key="label.yes" /><%
			} else if ("N".equals(acceptAppointmentDate2)) {
				%><bean:message key="label.no" /><%
			}
		} %>
		</td>
	</tr>
<%	} else if (isCardiac || isOncology) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Acceptance of Appointment Date at Outpatient</td>
		<td class="infoData" colspan="3">
<%		if (isGHC && stageThree && (createAction || updateAction)) { %>
			<input type="radio" name="acceptAppointmentDate1" value="Y"<%="Y".equals(acceptAppointmentDate1)?" checked":"" %>><bean:message key="label.yes" />
			<input type="radio" name="acceptAppointmentDate1" value="N"<%=!"Y".equals(acceptAppointmentDate1)?" checked":"" %>><bean:message key="label.no" />
<%		} else {
			if ("Y".equals(acceptAppointmentDate1)) {
				%><bean:message key="label.yes" /><%
			} else if ("N".equals(acceptAppointmentDate1)) {
				%><bean:message key="label.no" /><%
			}
		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Acceptance of CCIC Date</td>
		<td class="infoData" colspan="3">
<%		if (isGHC && stageThree && (createAction || updateAction)) { %>
			<input type="radio" name="acceptAppointmentDate2" value="Y"<%="Y".equals(acceptAppointmentDate2)?" checked":"" %>><bean:message key="label.yes" />
			<input type="radio" name="acceptAppointmentDate2" value="N"<%=!"Y".equals(acceptAppointmentDate2)?" checked":"" %>><bean:message key="label.no" />
<%		} else {
			if ("Y".equals(acceptAppointmentDate2)) {
				%><bean:message key="label.yes" /><%
			} else if ("N".equals(acceptAppointmentDate2)) {
				%><bean:message key="label.no" /><%
			}
		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Acceptance of Admission Date</td>
		<td class="infoData" colspan="3">
<%		if (isGHC && stageThree && (createAction || updateAction)) { %>
			<input type="radio" name="acceptAppointmentDate3" value="Y"<%="Y".equals(acceptAppointmentDate3)?" checked":"" %>><bean:message key="label.yes" />
			<input type="radio" name="acceptAppointmentDate3" value="N"<%=!"Y".equals(acceptAppointmentDate3)?" checked":"" %>><bean:message key="label.no" />
<%		} else {
			if ("Y".equals(acceptAppointmentDate3)) {
				%><bean:message key="label.yes" /><%
			} else if ("N".equals(acceptAppointmentDate3)) {
				%><bean:message key="label.no" /><%
			}
		} %>
		</td>
	</tr>
<%	} else { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Acceptance of Appointment Date</td>
		<td class="infoData" colspan="3">
<%		if (isGHC && stageThree && (createAction || updateAction)) { %>
			<input type="radio" name="acceptAppointmentDate1" value="Y"<%="Y".equals(acceptAppointmentDate1)?" checked":"" %>><bean:message key="label.yes" />
			<input type="radio" name="acceptAppointmentDate1" value="N"<%=!"Y".equals(acceptAppointmentDate1)?" checked":"" %>><bean:message key="label.no" />
<%		} else {
			if ("Y".equals(acceptAppointmentDate1)) {
				%><bean:message key="label.yes" /><%
			} else if ("N".equals(acceptAppointmentDate1)) {
				%><bean:message key="label.no" /><%
			}
		} %>
		</td>
	</tr>
<%	} %>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.arrivalDateInHK" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="patientArrivalDate1" id="patientArrivalDate1" class="datepickerfield" value="<%=patientArrivalDate1==null?"":patientArrivalDate1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else { %>
			<%=patientArrivalDate1==null?"":patientArrivalDate1 %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%">Flight Name/No</td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="flightInfo1" id="flightInfo1" value="<%=flightInfo1==null?"":flightInfo1 %>" maxlength="20" size="10">
<%	} else { %>
			<%=flightInfo1==null?"":flightInfo1 %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.transportMethod" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<select name="transportMethod1">
				<option value="byAirplane"<%="byAirplane".equals(transportMethod1)?" selected":"" %>>By Airplane</option>
				<option value="byTrain"<%="byTrain".equals(transportMethod1)?" selected":"" %>>By Train</option>
				<option value="byShip"<%="byShip".equals(transportMethod1)?" selected":"" %>>By Ship</option>
			</select>
<%	} else {
		if ("byAirplane".equals(transportMethod1)) {
			%>By Airplane<%
		} else if ("byTrain".equals(transportMethod1)) {
			%>By Train<%
		} else if ("byShip".equals(transportMethod1)) {
			%>By Ship<%
		}
	} %>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.arrangedBy" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<select name="transportArrangeBy1">
				<option value="patient"<%="patient".equals(transportArrangeBy1)?" selected":"" %>>Arranged by Patient</option>
				<option value="ghc"<%="ghc".equals(transportArrangeBy1)?" selected":"" %>>Arranged by GHC</option>
			</select>
<%	} else {
		if ("patient".equals(transportArrangeBy1)) {
			%>Arranged by Patient<%
		} else if ("ghc".equals(transportArrangeBy1)) {
			%>Arranged by GHC<%
		}
	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.hotel" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="hotalInfo1" value="<%=hotalInfo1==null?"":hotalInfo1 %>" maxlength="30" size="25">
<%	} else { %>
			<%=hotalInfo1==null?"":hotalInfo1 %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.arrangedBy" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<select name="hotalArrangeBy1">
				<option value="patient"<%="patient".equals(hotalArrangeBy1)?" selected":"" %>>Arranged by Patient</option>
			</select>
<%	} else {
		if ("patient".equals(hotalArrangeBy1)) {
			%>Arranged by Patient<%
		} else if ("ghc".equals(hotalArrangeBy1)) {
			%>Arranged by GHC<%
		}
	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Remind Date to Patient</td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="patientReminderDate1" id="patientReminderDate1" class="datepickerfield" value="<%=patientReminderDate1==null?"":patientReminderDate1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else { %>
			<%=patientReminderDate1==null?"":patientReminderDate1 %>
			<button onclick="return submitAction('letter1', 1, 0);" class="btn-click">Generate Letter</button>
<%	} %>
		</td>
		<td class="infoLabel" width="20%">Remind Method</td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<select name="patientReminderMethod1">
				<option value="phone"<%="phone".equals(patientReminderMethod1)?" selected":"" %>>By Phone</option>
				<option value="person"<%="person".equals(patientReminderMethod1)?" selected":"" %>>In Person</option>
			</select>
<%	} else {
		if ("phone".equals(patientReminderMethod1)) {
			%>By Phone<%
		} else if ("person".equals(patientReminderMethod1)) {
			%>In Person<%
		}
	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Remind Remarks</td>
		<td class="infoData" colspan="3">
<%	if (isGHC && (createAction || updateAction)) { %>
			<textarea name="patientReminderRemark1" rows="3" cols="100"><%=patientReminderRemark1==null?"":patientReminderRemark1 %></textarea>
<%	} else { %>
			<%=patientReminderRemark1==null?"":patientReminderRemark1 %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">HKAH <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%	if (!isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_hkah3" rows="3" cols="100"><%=remark_hkah3==null?"":remark_hkah3 %></textarea>
<%	} else { %>
			<%=remark_hkah3==null?"":remark_hkah3 %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">GHC <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%	if (isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_ghc3" rows="3" cols="100"><%=remark_ghc3==null?"":remark_ghc3 %></textarea>
<%	} else { %>
			<%=remark_ghc3==null?"":remark_ghc3 %>
<%	} %>
		</td>
	</tr>
