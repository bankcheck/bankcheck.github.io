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
String patientID = ParserUtil.getParameter(request, "patientID");
String confirmedRoomType = ParserUtil.getParameter(request, "confirmedRoomType");
String admissionDate = ParserUtil.getDate(request, "admissionDate");
String selectAnotherDate = ParserUtil.getDate(request, "selectAnotherDate");
String confirmAppointmentDate1 = ParserUtil.getDate(request, "confirmAppointmentDate1");
String confirmAppointmentDate2 = ParserUtil.getDate(request, "confirmAppointmentDate2");
String confirmAppointmentDate3 = ParserUtil.getDate(request, "confirmAppointmentDate3");
String confirmAppointmentDate4 = ParserUtil.getDate(request, "confirmAppointmentDate4");
String requestAppointmentDate1 = ParserUtil.getParameter(request, "requestAppointmentDate1");
String requestAppointmentDate2 = ParserUtil.getParameter(request, "requestAppointmentDate2");
String requestAppointmentDate3 = ParserUtil.getParameter(request, "requestAppointmentDate3");
String requestAppointmentDate4 = ParserUtil.getParameter(request, "requestAppointmentDate4");

String remark_hkah2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah2"));
String remark_ghc2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc2"));

boolean createAction = false;
boolean updateAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
}

boolean isSurgical = "surgical".equals(specialty);
boolean isCardiac = "cardiac".equals(specialty);
boolean isOncology = "oncology".equals(specialty);

boolean isGHC = userBean.isAccessible("function.ghc.client.create");
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Step 2. Fill in By <%if (isSurgical) {%>Surgeon/PBO<%} else {%>Hospital<%} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.hospitalNo" /></td>
		<td class="infoData" colspan="3">
<%		if (!isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="patientID" value="<%=patientID==null?"":patientID %>" maxlength="50" size="50">
<%		} else { %>
			<%=patientID==null?"":patientID %>
<%		} %>
		</td>
	</tr>
<%	if (isSurgical) {%>
		<td class="infoLabel" width="20%">Confirmed Room Type</td>
		<td class="infoData" width="30%">
<%		if (!isGHC && (createAction || updateAction)) { %>
			<select name="confirmedRoomType">
				<option value="PRIVATE"<%="PRIVATE".equals(confirmedRoomType)?" selected":""%>>PRIVATE</option>
				<option value="SEMI-PRIVATE"<%="SEMI-PRIVATE".equals(confirmedRoomType)?" selected":""%>>SEMI-PRIVATE</option>
				<option value="STANDARD"<%="STANDARD".equals(confirmedRoomType)?" selected":""%>>STANDARD</option>
				<option value="VIP"<%="VIP".equals(confirmedRoomType)?" selected":""%>>VIP</option>
			</select>
<%		} else { %>
			<%=confirmedRoomType==null?"":confirmedRoomType.toUpperCase() %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Surgery Date</td>
		<td class="infoData" width="30%">
<%		if (!isGHC && (createAction || updateAction)) { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="confirmAppointmentDate1" />
	<jsp:param name="date" value="<%=confirmAppointmentDate1 %>" />
	<jsp:param name="showTime" value="Y" />
	<jsp:param name="yearRange" value="10" />
	<jsp:param name="defaultValue" value="N" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
<%		} else {%>
			<%=confirmAppointmentDate1==null?"":confirmAppointmentDate1 %>
<%		} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Admission Date</td>
		<td class="infoData" width="30%">
<%		if (isGHC && (createAction || updateAction)) { %>
			<input type="textfield" name="admissionDate" id="admissionDate" class="datepickerfield" value="<%=admissionDate==null?"":admissionDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else { %>
			<%=admissionDate==null?"":admissionDate %>
<%		} %>
		</td>
		<td class="infoLabel" width="20%">Confirm OT Date</td>
		<td class="infoData" width="30%">
<%		if (!isGHC && (createAction || updateAction)) { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="confirmAppointmentDate2" />
	<jsp:param name="date" value="<%=confirmAppointmentDate2 %>" />
	<jsp:param name="showTime" value="Y" />
	<jsp:param name="yearRange" value="10" />
	<jsp:param name="defaultValue" value="N" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
<%		} else {%>
			<%=confirmAppointmentDate2==null?"":confirmAppointmentDate2 %>
<%		} %></td>
	</tr>
<%	} else if (isCardiac || isOncology) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Confirm Appointment Date at Outpatient</td>
		<td class="infoData" colspan="3">
<%		if (!isGHC && (createAction || updateAction)) { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="confirmAppointmentDate1" />
	<jsp:param name="date" value="<%=confirmAppointmentDate1 %>" />
	<jsp:param name="showTime" value="Y" />
	<jsp:param name="yearRange" value="10" />
	<jsp:param name="defaultValue" value="N" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
<%		} else {%>
			<%=confirmAppointmentDate1==null?"":confirmAppointmentDate1 %>
<%		} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Confirm CCIC Date</td>
		<td class="infoData" colspan="3">
<%		if (!isGHC && (createAction || updateAction)) { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="confirmAppointmentDate2" />
	<jsp:param name="date" value="<%=confirmAppointmentDate2 %>" />
	<jsp:param name="showTime" value="Y" />
	<jsp:param name="yearRange" value="10" />
	<jsp:param name="defaultValue" value="N" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
<%		} else {%>
			<%=confirmAppointmentDate2==null?"":confirmAppointmentDate2 %>
<%		} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Confirm Admission Date</td>
		<td class="infoData" colspan="3">
<%		if (!isGHC && (createAction || updateAction)) { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="confirmAppointmentDate3" />
	<jsp:param name="date" value="<%=confirmAppointmentDate3 %>" />
	<jsp:param name="showTime" value="Y" />
	<jsp:param name="yearRange" value="10" />
	<jsp:param name="defaultValue" value="N" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
<%		} else {%>
			<%=confirmAppointmentDate3==null?"":confirmAppointmentDate3 %>
<%		} %></td>
	</tr>
<%	} else {%>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Confirm Appointment Date</td>
		<td class="infoData" colspan="3">
<%		if (!isGHC && (createAction || updateAction)) { %>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="confirmAppointmentDate1" />
	<jsp:param name="date" value="<%=confirmAppointmentDate1 %>" />
	<jsp:param name="showTime" value="Y" />
	<jsp:param name="yearRange" value="10" />
	<jsp:param name="defaultValue" value="N" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
<%		} else {%>
			<%=confirmAppointmentDate1==null?"":confirmAppointmentDate1 %>
<%		} %></td>
	</tr>
<%	} %>
<%	if (!isGHC && (createAction || updateAction)) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">GHC Re-selects date</td>
		<td class="infoData" colspan="3">
			<input type="checkbox" name="selectAnotherDate" value="Y"<%="Y".equals(selectAnotherDate)?" checked":"" %>><bean:message key="label.yes" />
			<input type="hidden" name="requestAppointmentDate1" value="<%=requestAppointmentDate1 %>">
			<input type="hidden" name="requestAppointmentDate2" value="<%=requestAppointmentDate2 %>">
			<input type="hidden" name="requestAppointmentDate3" value="<%=requestAppointmentDate3 %>">
			<input type="hidden" name="requestAppointmentDate4" value="<%=requestAppointmentDate4 %>">
		</td>
	</tr>
<%	} %>
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