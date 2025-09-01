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

/* step 4 */
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
String confirmDeliveryDate = ParserUtil.getDate(request, "confirmDeliveryDate");
String prebookingConfirmNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "prebookingConfirmNo"));
String paySlipNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "paySlipNo"));
String paySlipDate = ParserUtil.getDate(request, "paySlipDate");
String certIssueDate = ParserUtil.getDate(request, "certIssueDate");

String remark_hkah4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah4"));
String remark_ghc4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc4"));

boolean createAction = false;
boolean updateAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
}

boolean stageFour = stageInt == 4;

boolean isGHC = userBean.isAccessible("function.ghc.client.create");
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Step 4. Complete from Hospital</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Confirmed Delivery Date (From OT)</td>
		<td class="infoData" colspan="3">
<%		if (createAction || updateAction) {%>
			<input type="textfield" name="confirmDeliveryDate" id="confirmDeliveryDate" class="datepickerfield" value="<%=confirmDeliveryDate==null?"":confirmDeliveryDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else {%>
			<%=confirmDeliveryDate==null?"":confirmDeliveryDate %>
<%		} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Pre-booking confirmation No.</td>
		<td class="infoData" colspan="3">
<%		if (createAction || updateAction) {%>
			<input type="textfield" name="prebookingConfirmNo" value="<%=prebookingConfirmNo==null?"":prebookingConfirmNo %>" maxlength="50" size="50">
<%		} else {%>
			<%=prebookingConfirmNo==null?"":prebookingConfirmNo %>
<%		} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Pay Slip No.</td>
		<td class="infoData" width="30%">
<%		if (createAction || updateAction) {%>
			<input type="textfield" name="paySlipNo" value="<%=paySlipNo==null?"":paySlipNo %>" maxlength="50" size="50">
<%		} else {%>
			<%=paySlipNo==null?"":paySlipNo %>
<%		} %></td>
		<td class="infoLabel" width="20%">Date Issue</td>
		<td class="infoData" width="30%">
<%		if (createAction || updateAction) {%>
			<input type="textfield" name="paySlipDate" id="paySlipDate" class="datepickerfield" value="<%=paySlipDate==null?"":paySlipDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else {%>
			<%=paySlipDate==null?"":paySlipDate %>
<%		} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Certification Issue Date.</td>
		<td class="infoData" colspan="3">
<%		if (createAction || updateAction) {%>
			<input type="textfield" name="certIssueDate" id="certIssueDate" class="datepickerfield" value="<%=certIssueDate==null?"":certIssueDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%		} else {%>
			<%=certIssueDate==null?"":certIssueDate %>
<%		} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">HKAH <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%		if (!isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_hkah4" rows="3" cols="100"><%=remark_hkah4==null?"":remark_hkah4 %></textarea>
<%		} else { %>
			<%=remark_hkah4==null?"":remark_hkah4 %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">GHC <bean:message key="prompt.remarks" /></td>
		<td class="infoData" colspan="3">
<%		if (isGHC && (createAction || updateAction)) { %>
			<textarea name="remark_ghc4" rows="3" cols="100"><%=remark_ghc4==null?"":remark_ghc4 %></textarea>
<%		} else { %>
			<%=remark_ghc4==null?"":remark_ghc4 %>
<%		} %>
		</td>
	</tr>