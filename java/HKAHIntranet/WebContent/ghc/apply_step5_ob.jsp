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

/* step 5 */
String patientArrivalDate2 = ParserUtil.getDate(request, "patientArrivalDate2");
String flightInfo2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "flightInfo2"));
String transportMethod2 = ParserUtil.getParameter(request, "transportMethod2");
String transportArrangeBy2 = ParserUtil.getParameter(request, "transportArrangeBy2");
String hotalInfo2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "hotalInfo2"));
String hotalArrangeBy2 = ParserUtil.getParameter(request, "hotalArrangeBy2");
String patientReminderDate2 = ParserUtil.getDate(request, "patientReminderDate2");
String patientReminderLetterDate2 = null;
String patientReminderMethod2 = ParserUtil.getParameter(request, "patientReminderMethod2");
String patientReminderRemark2 = ParserUtil.getParameter(request, "patientReminderRemark2");

String remark_hkah5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah5"));
String remark_ghc5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc5"));

boolean createAction = false;
boolean updateAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
}

boolean stageFive = stageInt == 5;

boolean isGHC = userBean.isAccessible("function.ghc.client.create");
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Step 5. Confirmation from GHC (Delivery)</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.arrivalDateInHK" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="patientArrivalDate2" id="patientArrivalDate2" class="datepickerfield" value="<%=patientArrivalDate2==null?"":patientArrivalDate2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else { %>
			<%=patientArrivalDate2==null?"":patientArrivalDate2 %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%">Flight Name/No</td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="flightInfo2" id="flightInfo2" value="<%=flightInfo2==null?"":flightInfo2 %>" maxlength="20" size="10">
<%	} else { %>
			<%=flightInfo2==null?"":flightInfo2 %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.transportMethod" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<select name="transportMethod2">
				<option value="byAirplane"<%="byAirplane".equals(transportMethod2)?" selected":"" %>>By Airplane</option>
				<option value="byTrain"<%="byTrain".equals(transportMethod2)?" selected":"" %>>By Train</option>
				<option value="byShip"<%="byShip".equals(transportMethod2)?" selected":"" %>>By Ship</option>
			</select>
<%	} else {
		if ("byAirplane".equals(transportMethod2)) {
			%>By Airplane<%
		} else if ("byTrain".equals(transportMethod2)) {
				%>By Train<%
		} else if ("byShip".equals(transportMethod2)) {
				%>By Ship<%
		}
	} %>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.arrangedBy" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<select name="transportArrangeBy2">
				<option value="patient"<%="patient".equals(transportArrangeBy2)?" selected":"" %>>Arranged by Patient</option>
				<option value="ghc"<%="ghc".equals(transportArrangeBy2)?" selected":"" %>>Arranged by GHC</option>
			</select>
<%	} else {
		if ("patient".equals(transportArrangeBy2)) {
			%>Arranged by Patient<%
		} else if ("ghc".equals(transportArrangeBy2)) {
			%>Arranged by GHC<%
		}
	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.hotel" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="hotalInfo2" value="<%=hotalInfo2==null?"":hotalInfo2 %>" maxlength="30" size="25">
<%	} else { %>
			<%=hotalInfo2==null?"":hotalInfo2 %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.arrangedBy" /></td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<select name="hotalArrangeBy2">
				<option value="patient"<%="patient".equals(hotalArrangeBy2)?" selected":"" %>>Arranged by Patient</option>
			</select>
<%	} else {
		if ("patient".equals(hotalArrangeBy2)) {
			%>Arranged by Patient<%
		} else if ("ghc".equals(hotalArrangeBy2)) {
			%>Arranged by GHC<%
		}
	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Remind Date to Patient</td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="patientReminderDate2" id="patientReminderDate2" class="datepickerfield" value="<%=patientReminderDate2==null?"":patientReminderDate2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else { %>
			<%=patientReminderDate2==null?"":patientReminderDate2 %>
			<button onclick="return submitAction('letter2', 1, 0);" class="btn-click">Generate Letter</button>
<%	} %>
			<a href="javascript:downloadFile('36')">Reminder Letter</a>
		</td>
		<td class="infoLabel" width="20%">Remind Method</td>
		<td class="infoData" width="30%">
<%	if (isGHC && (createAction || updateAction)) { %>
			<select name="patientReminderMethod2">
				<option value="phone"<%="phone".equals(patientReminderMethod2)?" selected":"" %>>By Phone</option>
				<option value="person"<%="person".equals(patientReminderMethod2)?" selected":"" %>>In Person</option>
			</select>
<%	} else {
		if ("phone".equals(patientReminderMethod2)) {
			%>By Phone<%
		} else if ("person".equals(patientReminderMethod2)) {
			%>In Person<%
		}
	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Remind Remarks</td>
		<td class="infoData" colspan="3">
<%	if (isGHC && (createAction || updateAction)) { %>
			<textarea name="patientReminderRemark2" rows="3" cols="100"><%=patientReminderRemark2==null?"":patientReminderRemark2 %></textarea>
<%	} else { %>
			<%=patientReminderRemark2==null?"":patientReminderRemark2 %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">HKAH <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%	if (!isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_hkah5" rows="3" cols="100"><%=remark_hkah5==null?"":remark_hkah5 %></textarea>
<%	} else { %>
			<%=remark_hkah5==null?"":remark_hkah5 %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">GHC <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%	if (isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_ghc5" rows="3" cols="100"><%=remark_ghc5==null?"":remark_ghc5 %></textarea>
<%	} else { %>
			<%=remark_ghc5==null?"":remark_ghc5 %>
<%	} %>
		</td>
	</tr>