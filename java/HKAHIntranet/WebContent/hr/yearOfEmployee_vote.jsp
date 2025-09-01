<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.mail.UtilMail" %>
<%@ page import="org.apache.struts.Globals" %>
<%
UserBean userBean = new UserBean(request);

String step = request.getParameter("step");
String nomineeStaffName = null;
String nomineeStaffID = request.getParameter("nomineeStaffID");
String nomineeDeptCode = request.getParameter("nomineeDeptCode");
String module = request.getParameter("module");
String quarter = request.getParameter("quarter");
String dependablePercent = request.getParameter("dependablePercent");
String flexiblePercent = request.getParameter("flexiblePercent");
String hsInitiativePercent = request.getParameter("hsInitiativePercent");
String positivePercent = request.getParameter("positivePercent");
String compassionatePercent = request.getParameter("compassionatePercent");
String sensePercent = request.getParameter("sensePercent");
String managingPercent = request.getParameter("managingPercent");
String totalPercent = request.getParameter("totalPercent");
String allowDisplay = request.getParameter("allowDisplay");

if (module == null || "".equals(module)) {
	module = "yearOfEmployee";
}
if (nomineeStaffID != null) {
	nomineeStaffID = TextUtil.parseStrUTF8(nomineeStaffID);
} else {
	nomineeStaffID = "";
}
nomineeDeptCode = nomineeDeptCode == null ? "-1" : nomineeDeptCode;
String nomineeDeptDesc = null;
String comment = TextUtil.parseStrUTF8(request.getParameter("comment"));

boolean createAction = true;

/* silver star template is used for gold star (employee of the year) [from 21 Mar 2013 13:00 by Ricky] */
boolean starOfTheQuarterToYear = "starOfTheQuarter".equals(module);
starOfTheQuarterToYear = true;

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

String language = request.getParameter("language");
Locale locale = Locale.US;
if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else if ("eng".equals(language)) {
	locale = Locale.US;
}
if (language == null) {
	locale = (Locale) session.getAttribute(Globals.LOCALE_KEY);
}

try {
	if ("1".equals(step)) {
		if (createAction) {
			ArrayList record = null;
			if ((record = StaffDB.get(nomineeStaffID)).size() == 0) {
				errorMessage = "error.staffID.invalid";
			} else if (!EmployeeVoteDB.verifyStaffID(nomineeStaffID) && !"starOfTheQuarter".equals(module)) {
				errorMessage = "error.nomineeStaff.rule1";
			} else if (starOfTheQuarterToYear || "starOfTheQuarter".equals(module)) {
				boolean success = false;
				if (starOfTheQuarterToYear) {
					success = EmployeeVoteDB.addYear(userBean, nomineeStaffID, comment,"yearOfEmployee","1",dependablePercent,flexiblePercent,hsInitiativePercent,positivePercent,compassionatePercent,sensePercent,managingPercent,totalPercent, allowDisplay);
				} else {
					success = EmployeeVoteDB.addQuarter(userBean, nomineeStaffID, comment,"starOfTheQuarter".equals(module)?"starOfTheQuarter":"","1",dependablePercent,flexiblePercent,hsInitiativePercent,positivePercent,compassionatePercent,totalPercent);
				}
				if (success) {
					StringBuffer commentStr = new StringBuffer();
					commentStr.append(" Nominator: "+StaffDB.getStaffName(userBean.getStaffID())+ " (Emp No.: " + userBean.getStaffID() + ")<br>");
					commentStr.append(" Department: "+userBean.getDeptDesc() + " (" + userBean.getDeptCode() + ")<br>");
					commentStr.append(" Nominee: "+StaffDB.getStaffName(nomineeStaffID)+ " (Emp No.: " + nomineeStaffID + ")<br>");
					commentStr.append(" Nominee Department: "+DepartmentDB.getDeptDesc(nomineeDeptCode) + " (" + nomineeDeptCode + ")<br>");
					commentStr.append("<table style=\"border: 1px solid gray\"><tr><td>Criteria</td><td>Score</td></tr>");
					commentStr.append("<tr><td>Commitment to Colleagues (25%)</td><td>"+dependablePercent+"</td></tr>");
					commentStr.append("<tr><td>Professional Conduct/Attitude (30%)</td><td>"+flexiblePercent+"</td></tr>");
					commentStr.append("<tr><td>Appearance (5%)</td><td>"+hsInitiativePercent+"</td></tr>");
					commentStr.append("<tr><td>Effective Communication (15%)</td><td>"+positivePercent+"</td></tr>");
					commentStr.append("<tr><td>Professional Development (5%)</td><td>"+compassionatePercent+"</td></tr>");
					commentStr.append("<tr><td>Sense of Ownership (10%)</td><td>"+sensePercent+"</td></tr>");
					commentStr.append("<tr><td>Managing Up (10%)</td><td>"+managingPercent+"</td></tr>");
					commentStr.append("<tr><td><b>Total Score</b></td><td><b>"+totalPercent+"</b></td></tr><table><br>");	
					commentStr.append(" Additional Comments: "+comment+"<br>");
					commentStr.append(" Allow Disclose: "+allowDisplay+"<br>");
	
					String sendFrom = "admin@hkah.org.hk";
					String[] sendTo = new String[]{"jenny.liu@hkah.org.hk", "jolly.tang@hkah.org.hk" };
					String[] sendCc = null;
					String[] sendBcc =  new String[]{"cherry.wong@hkah.org.hk"};
					UtilMail.sendMail( sendFrom, sendTo, sendCc, sendBcc,
							"New Nomination For GOLD STAR (Employee of the Year Nomination) (From: "+StaffDB.getStaffName(userBean.getStaffID())+")", commentStr.toString());
					message = "message.vote.thank";
					createAction = false;
				}else{
					errorMessage = "error.nominatee.onlyOnce";
				}
			} else if (!EmployeeVoteDB.addYear(userBean, nomineeStaffID, comment,"yearOfEmployee","1",dependablePercent,flexiblePercent,hsInitiativePercent,positivePercent,compassionatePercent,sensePercent,managingPercent,totalPercent,allowDisplay)) {
				errorMessage = "error.nominatee.onlyOnce";
			} else {
				message = "message.vote.thank";
				createAction = false;

				// retrieve data
				record = EmployeeVoteDB.get(userBean.getStaffID());
				if (record.size() > 0) {
					ReportableListObject row = (ReportableListObject) record.get(0);
					nomineeStaffID = row.getValue(0);
					nomineeStaffName = row.getValue(1);
					nomineeDeptDesc = row.getValue(2);
				}
			}
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function."+module+"." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="accessControl" value="N"/>

</jsp:include>
</br>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
</jsp:include>
<%if (errorMessage != null && errorMessage.length() > 0) { %>
<div class="ui-widget">
	<div style="border-color:white;background:white;color:red;font-size:20px" class="ui-state-error ui-corner-all" style="padding: 0 .7em;">
		<p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
		<strong>
<%		try { %>
			<bean:message key="<%=errorMessage %>" />
<%		} catch (Exception e) { %>
			<%=errorMessage %>
<%		} %>
		</strong></p>
	</div>
</div>
<%} %>

<table width="100%" border="0">
<%if (createAction) { %>
<tr>
	<td width="10%">&nbsp;</td>
	<td width="80%">
		<table width="100%" border="0">
			<tr>
				<%if (("starOfTheQuarter").equals(module)) {%><td colspan="2" style="text-align: center;"><%=MessageResources.getMessage(locale,"prompt.starOfTheQuarter.title")%><%}else{ %><td colspan="2"><%=MessageResources.getMessage(locale, "prompt.nomineeStaff.title1")%><%} %></td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<%if (!("starOfTheQuarter").equals(module)) {%><td width="10">&nbsp;</td><%}%>
				<td colspan="2"><%if (("starOfTheQuarter").equals(module)) {%><font size="2"><B><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.subtitle1" )%></B></font><%}else{ %><%=MessageResources.getMessage(locale, "prompt.title2")%><%} %></td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<%if (!("starOfTheQuarter").equals(module)) {%>
			<tr>
				<td colspan="2"><U><%=MessageResources.getMessage(locale, "prompt.rules")%></U>:</td>
			</tr>
			<%} %>
			<tr>
				<%if (!("starOfTheQuarter").equals(module)) {%><td valign="top">1.</td><%} %>
				<%if (("starOfTheQuarter").equals(module)) {%><td colspan="2"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule1")%><%}else{ %><td><%=MessageResources.getMessage(locale, "prompt.nomineeStaff.rule1")%><%} %></td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<%if (!("starOfTheQuarter").equals(module)) {%><td width="10">&nbsp;</td><%}%>
				<td colspan="2"><%if (("starOfTheQuarter").equals(module)) {%><font size="2"><B><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.subtitle2" )%></B></font><%}else{ %><%=MessageResources.getMessage(locale, "prompt.title2" )%><%} %></td>
			</tr>
			<tr>
				<%if (!("starOfTheQuarter").equals(module)) {%><td valign="top">2.</td><%} %>
				<%if (("starOfTheQuarter").equals(module)) {%><td colspan="2"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule2" )%><%}else{ %><td><%=MessageResources.getMessage(locale, "prompt.nomineeStaff.rule2" )%><%} %></td>
			</tr>
			<tr>
				<%if (!("starOfTheQuarter").equals(module)) {%><td valign="top">3.</td><%} %>
				<%if (("starOfTheQuarter").equals(module)) {%><td colspan="2"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3" )%><%}else{ %><td><%=MessageResources.getMessage(locale, "prompt.nomineeStaff.rule3" )%><%} %></td>
			</tr>
			<%if (("starOfTheQuarter").equals(module)) {%>
			<tr>
				<td colspan="2" align="center"><b><font size="3"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.nominateSilver" )%></font></b></td>
			</tr>
			<%} %>
			<%if (!("starOfTheQuarter").equals(module)) {%>
				<tr>
					<td valign="top">4.</td>
					<td><%if (("starOfTheQuarter").equals(module)) {%><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule4" )%><%}else{ %><%=MessageResources.getMessage(locale, "prompt.nomineeStaff.rule4" )%><%} %></td>
				</tr>
				<tr>
					<td>5.</td>
					<td><%=MessageResources.getMessage(locale, "prompt.nomineeStaff.rule5" )%></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td>*</td>
					<td><%=MessageResources.getMessage(locale, "prompt.nomineeStaff.remark1" )%></td>
				</tr>
				<tr>
					<td>*</td>
					<td><%=MessageResources.getMessage(locale, "prompt.nomineeStaff.remark2" )%></td>
				</tr>
				<tr>
					<td>*</td>
					<td><%=MessageResources.getMessage(locale, "prompt.nomineeStaff.remark3" )%></td>
				</tr>
				<tr>
					<td>*</td>
					<td><%=MessageResources.getMessage(locale, "prompt.nomineeStaff.remark4" )%></td>
				</tr>
				<tr>
					<td>*</td>
					<td><%=MessageResources.getMessage(locale, "prompt.nomineeStaff.remark5" )%></td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>

			<%} %>
		</table>
	</td>
	<td width="10%">&nbsp;</td>
</tr>
<%} %>
</table>
<form name="form1" action="yearOfEmployee_vote.jsp" onsubmit="return submitAction();" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
<%if (createAction) { %>
	<tr class="smallText">
		<td width="10%">&nbsp;</td>
		<td colspan="3"><b><i><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.nominatingStaff" )%></i></b></td>
	</tr>
	<tr class="smallText">
		<td width="10%">&nbsp;</td>
		<td  width="30%"><b><%=MessageResources.getMessage(locale, "prompt.name" )%>:</b> <%=userBean.getUserName() %></td>
		<td><b><%=MessageResources.getMessage(locale, "prompt.staffID" )%>:</b> <%=userBean.getStaffID() %></td>
		<td><b><%=MessageResources.getMessage(locale, "prompt.department" )%>:</b> <%=userBean.getDeptDesc() %></td>
	</tr>
	<tr class="smallText">
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td width="10%">&nbsp;</td>
		<td colspan="3"><b><i><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.nomineeStaff" )%></i></b></td>
	</tr>
<%} %>
<%if (createAction) { %>
	<tr class="smallText">
		<td width="10%">&nbsp;</td>
		<td><b><%=MessageResources.getMessage(locale, "prompt.department" )%>:</b>
<% String ignoreDeptCode = userBean.getDeptCode() + "," + "880"; %>
			<select name="nomineeDeptCode" onchange="return changeStaffID()">
				<option value="-1"></option>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="ignoreDeptCode" value="<%=ignoreDeptCode %>" />
	<jsp:param name="allowAll" value="Y" />
	<jsp:param name="category" value="nominee" />
</jsp:include>
			</select>
		</td>
		<td><b><%=MessageResources.getMessage(locale, "prompt.name" )%>:</b>
			<span id="showStaffID_indicator">
				<select name="nomineeStaffName" onchange="return changeStaffName()">
					<option value=""></option>
<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=nomineeDeptCode %>" />
	<jsp:param name="value" value="<%=nomineeStaffID %>" />
	<jsp:param name="ignoreCurrentStaffID" value="Y" />
	<jsp:param name="showDeptDesc" value="N" />
	<jsp:param name="category" value="nominee" />
	<jsp:param name="isSilverStar" value="Y" />
	<jsp:param name="hideDoctorForOutpatientNursing" value="Y" />
	<jsp:param name="hideVolunteer" value="Y" />
	<jsp:param name="hideDummyUser" value="Y" />
</jsp:include>
				</select>
			</span>
		</td>
		<td><b><%=MessageResources.getMessage(locale, "prompt.staffID" )%>:</b> <input type="textfield" name="nomineeStaffID" value="<%=nomineeStaffID %>"></td>
	</tr>

<%} else { %>
<!--
	<tr class="smallText">
		<td width="10%">&nbsp;</td>
		<td><b><%=MessageResources.getMessage(locale, "prompt.department" )%>:</b> <%=DepartmentDB.getDeptDesc(nomineeDeptCode) %></td>
		<td><b><%=MessageResources.getMessage(locale, "prompt.name" )%>:</b> <%=StaffDB.getStaffName(nomineeStaffID) %></td>
		<td><b><%=MessageResources.getMessage(locale, "prompt.staffID" )%>:</b> <%=nomineeStaffID %></td>
	</tr>
 -->
<%} %>
<%if (("starOfTheQuarter").equals(module)&&createAction) {%>
	<tr class="smallText">
	<td width="10%">&nbsp;</td>

		<td colspan="3">
			<table border=1 width="90%">
						<tr><td style="font-weight: bold; color: #000000; background-color: #E0E0E0;  vertical-align: center;"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.criteria" )%></td><td style="font-weight: bold; color: #000000; background-color: #E0E0E0; text-align: left; vertical-align: center;"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.desc" )%></td><td style="font-weight: bold; color: #000000; background-color: #E0E0E0; text-align: left; vertical-align: center;"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.maxScore")%></td><td style="font-weight: bold; color: #000000; background-color: #E0E0E0; text-align: left; vertical-align: center;"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.yourScore")%></td></tr>
						<tr><td style="padding:2px"><div style="font-weight: bold;"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3a.name" )%></div>25%</td><td><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3a" )%></td><td >100 </td><td style="padding: 5px;"><input type="text" name="dependablePercent" value="" onkeyup="calculateTotal()" maxlength="10" size="5"/></td></tr>
						<tr><td style="padding:2px"><div style="font-weight: bold;"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3b.name" )%></div>30%</td><td><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3b" )%></td><td style="padding:5px;">100 </td><td style="padding: 5px;"><input type="text" name="flexiblePercent" value="" onkeyup="calculateTotal()"  maxlength="10" size="5"/></td></tr>
						<tr><td style="padding:2px"><div style="font-weight: bold;"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3c.name" )%></div>5%</td><td><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3c" )%></td><td style="padding:5px;">100 </td><td style="padding: 5px;"><input type="text" name="hsInitiativePercent" value="" onkeyup="calculateTotal()"  maxlength="10" size="5"/></td></tr>
						<tr><td style="padding:2px"><div style="font-weight: bold;"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3d.name" )%></div>15%</td><td><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3d" )%></td><td style="padding:5px;">100 </td><td style="padding: 5px;"><input type="text" name="positivePercent" value="" onkeyup="calculateTotal()"  maxlength="10" size="5"/></td></tr>
						<tr><td style="padding:2px"><div style="font-weight: bold;"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3e.name" )%></div>5%</td><td><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3e")%></td><td style="padding:5px;">100 </td><td style="padding: 5px;"><input type="text" name="compassionatePercent" value="" onkeyup="calculateTotal()"  maxlength="10" size="5"/></td></tr>
						<tr><td style="padding:2px"><div style="font-weight: bold;"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3f.name" )%></div>10%</td><td><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3f")%></td><td style="padding:5px;">100 </td><td style="padding: 5px;"><input type="text" name="sensePercent" value="" onkeyup="calculateTotal()"  maxlength="10" size="5"/></td></tr>
						<tr><td style="padding:2px"><div style="font-weight: bold;"><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3g.name" )%></div>10%</td><td><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.rule3g")%></td><td style="padding:5px;">100 </td><td style="padding: 5px;"><input type="text" name="managingPercent" value="" onkeyup="calculateTotal()"  maxlength="10" size="5"/></td></tr>
						<tr><td style="padding:2px">100%</td><td align="right"><b><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.totalscore")%></b></td><td style="padding:5px;">100</td><td style="padding: 5px;"><input type="text" name="totalPercent" value="0" maxlength="10" readonly="readonly" size="5" style="border: 1px solid grey; background: none;"/></td></tr>
			</table>
		</td>
	</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="3"><%if (("starOfTheQuarter").equals(module)) {%>&nbsp;<%}else{ %><%=MessageResources.getMessage(locale, "prompt.nomineeStaff.rule4" )%><%} %></td>
			</tr>
<%} %>
<%if (createAction) { %>
	<tr class="smallText">
		<td width="10%">&nbsp;</td>
		<td colspan="3"><%if (("starOfTheQuarter").equals(module)) {%><b><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.addComment" )%></b><%}else{ %><%=MessageResources.getMessage(locale, "prompt.vote.reason" )%><%} %></td>
	</tr>
<%} %>
	<tr class="smallText">
		<td width="10%">&nbsp;</td>
		<td colspan="3">
<%if (createAction) { %>
			<textarea name="comment" rows="6" cols="150"><%=comment==null?"":comment %></textarea>
<%} else { %>
		<!-- 	<%=comment==null?"":comment %>-->
<%} %>
		</td>
	</tr>
<%if (!createAction) { %>
	 <tr>
	 <td>&nbsp;</td>
	 <td>
 	<button onclick="return closePage();" type='button' class="btn-click">Back to Reward & Recognition</button>
	 </td>
 	</tr>
<%} else { %>
	<tr>
		<td>&nbsp;</td>
		<td colspan="3" style="padding: 10px 0;">
			<%=MessageResources.getMessage(locale, "eshare.allowDisplay" )%>&nbsp;&nbsp;
			<input type="radio" name="allowDisplay" value="Y"><%=MessageResources.getMessage(locale, "label.yes" )%>
		 	<input type="radio" name="allowDisplay" value="N"><%=MessageResources.getMessage(locale, "label.no" )%>
		</td>
	</tr>
<%}  %>
</table>
<%if (createAction) { %>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitAction();" name="submit-vote" class="btn-click"><%=MessageResources.getMessage(locale, "button.submit" )%></button>

			<button onclick="clearInput();" type='button' name="clear-vote" class="btn-click"><%=MessageResources.getMessage(locale, "button.clear" )%></button>
		</td>
	</tr>
<tr>
	<td align="center"><%if (("starOfTheQuarter").equals(module)) {%><%=MessageResources.getMessage(locale, "prompt.starOfTheQuarter.ending" )%><%}else{ %>&nbsp;<%} %></td>

</tr>

</table>
</div>
<%}  %>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="module" value="<%=module %>" />
</form>
<bean:define id="nomineeStaffNameLabel"><%=MessageResources.getMessage(locale, "prompt.name" )%></bean:define>
<bean:define id="nomineeStaffIDLabel"><%=MessageResources.getMessage(locale, "prompt.staffID" )%></bean:define>
<script language="javascript">
<!--//
	function closePage() {
			window.location.replace("../hr/rrteam.jsp");
	}

	function submitAction() {
		var ret = true;
		var showScrollErrMsg = false;
		$('input[name$="Percent"]').each(function() {
			if ($(this).val() =='') {
				showScoreErrMsg = true;
				ret = false;
			}
		});
		if (document.form1.nomineeStaffID.value == '<%=userBean.getStaffID() %>') {
			alert('Sorry, you cannot self-nominate.');
			document.form1.nomineeStaffID.focus();
			ret = false;
		}
		if (document.form1.nomineeStaffID.value == '') {
			alert('<%=MessageResources.getMessage(locale,"errors.required")%> arg0="<%=nomineeStaffIDLabel %>".');
			document.form1.nomineeStaffID.focus();
			ret = false;
		}
		if (document.form1.comment.value == '') {
			alert('<%=MessageResources.getMessage(locale, "error.nominatingReason.empty" )%>.');
			document.form1.comment.focus();
			ret = false;
		}
		if (!$('input[name=allowDisplay]:checked').length > 0) {
			alert('<%=MessageResources.getMessage(locale, "eshare.allowDisplay.required" )%>');
			$('input[name=allowDisplay]').focus();
			ret = false;
		}
		if (ret) {
			// disable button
			$('button[name=submit-vote]').attr("disabled", true);
			$('button[name=clear-vote]').attr("disabled", true);
			showLoadingBox('body', 500, $(window).scrollTop());
			
			document.form1.command.value = "create";
			document.form1.step.value = "1";
			document.form1.submit();
		} else {
			if (showScoreErrMsg)
				alert('<%=MessageResources.getMessage(locale, "error.nominateScore.empty" )%>.');
			return false;
		}
	}

	// ajax
	var http = createRequestObject();

	function clearInput() {
		$('table').find('input[name=dependablePercent]').val('');
		$('table').find('input[name=flexiblePercent]').val('');
		$('table').find('input[name=hsInitiativePercent]').val('');
		$('table').find('input[name=positivePercent]').val('');
		$('table').find('input[name=compassionatePercent]').val('');
		$('table').find('input[name=sensePercent]').val('');
		$('table').find('input[name=managingPercent]').val('');
		$('table').find('select[name=nomineeDeptCode] option:first-child').attr("selected", "selected");
		changeStaffID();
		alculateTotal();
	}

	function changeStaffID() {
		var did = document.form1.nomineeDeptCode.value;
		$.ajax({
			type: "POST",
			url: "../ui/staffIDCMB.jsp",
			data: "deptCode=" + did + "&ignoreCurrentStaffID=Y&showDeptDesc=N&category=nominee&isSilverStar=Y&hideDoctorForOutpatientNursing=Y&hideVolunteer=Y&hideDummyUser=Y",
			success: function(values) {
			if (values != '') {
				$("#showStaffID_indicator").html("<select name='nomineeStaffName' onchange='return changeStaffName();'><option value=''></option>" + values + "</select>");
			}//if
			changeStaffName();
			}//success
		});//$.ajax
	}

	function changeStaffName() {
		document.form1.nomineeStaffID.value = document.form1.nomineeStaffName.value;

		return false;
	}

	function calculateTotal() {

		var dependablePercent = $("input[name=dependablePercent]").val();
		var flexiblePercent = $("input[name=flexiblePercent]").val();
		var hsInitiativePercent = $("input[name=hsInitiativePercent]").val();
		var positivePercent = $("input[name=positivePercent]").val();
		var compassionatePercent = $("input[name=compassionatePercent]").val();
		var sensePercent = $("input[name=sensePercent]").val();
		var managingPercent = $("input[name=managingPercent]").val();

		if (dependablePercent == '') {
			dependablePercent = 0;
		}else{
			dependablePercent = dependablePercent * .25;
		}
		if (flexiblePercent == '') {
			flexiblePercent = 0;
		}else{
			flexiblePercent = flexiblePercent * .3;
		}
		if (hsInitiativePercent == '') {
			hsInitiativePercent = 0;
		}else{
			hsInitiativePercent = hsInitiativePercent * .05;
		}
		if (positivePercent == '') {
			positivePercent = 0;
		}else{
			positivePercent = positivePercent * .15;
		}
		if (compassionatePercent == '') {
			compassionatePercent = 0;
		}else{
			compassionatePercent = compassionatePercent * .05;
		}
		if (sensePercent == '') {
			sensePercent = 0;
		}else{
			sensePercent = sensePercent * .1;
		}
		if (managingPercent == '') {
			managingPercent = 0;
		}else{
			managingPercent = managingPercent * 0.1;
		}


		var total = parseFloat(dependablePercent) + parseFloat(flexiblePercent)
				 + parseFloat(hsInitiativePercent) +  parseFloat(positivePercent)
				 + parseFloat(compassionatePercent) + parseFloat(sensePercent)
				 + parseFloat(managingPercent);

		total = Math.round(total * 100) / 100;

		$("input[name=totalPercent]").val(total);
		}

	// Switch enter to tab
	$.fn.enterToTab = function() {
		$(this).keydown(function(e) {
	        var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
	        if (key == 13) {
	            e.preventDefault();
	            var inputs = $(this).closest('form').find(':input:visible');
	            inputs.eq( inputs.index(this)+ 1 ).focus();
	        }
	    })
	};

	function isNumber(n) {
		  return !isNaN(parseFloat(n)) && isFinite(n);
		}

	$.fn.intOnly = function(limit) {
	    $(this).keydown(function(e) {
	     	jQuery(this).keyup(function () {
	     		if (!isNumber(this.value)) {
	           	 	this.value = this.value.replace(/[^0-9\.]/g,'');
	     		}
	        });

	        var key = e.charCode || e.keyCode || 0;

	        // Numbers 0-9 (including NumLock)
	        var numbers = new Array(57,56,55,54,53,52,51,50,49,48,96,97,98,99,100,101,102,103,104,105);
	        // Navigation keys: Left Arrow, Right Arrow, Home, End, Delete, Backspace, Tab
	        var navigation = new Array(37,39,36,35,46,8,9);
	        if ( jQuery.inArray(key, numbers) > -1) {

	        	if (key==105) {
	        		key = 57;
	        	}else if (key==104) {
	        		key = 56;
	        	}else if (key==103) {
	        		key = 55;
	        	}else if (key==102) {
	        		key = 54;
	        	}else if (key==101) {
	        		key = 53;
	        	}else if (key==100) {
	        		key = 52;
	        	}else if (key==99) {
	        		key = 51;
	        	}else if (key==98) {
	        		key = 50;
	        	}else if (key==97) {
	        		key = 49;
	        	} else if (key==96) {
	        		key = 48;
	        	}

	        	if (parseFloat($(this).val()) == 0) {
	          	 	this.value = this.value.substring(0, this.value.length-2);
	          	 	calculateTotal()
	     		}
	            if (parseFloat($(this).val()+String.fromCharCode(key)) > 100) {
	          	 	this.value = this.value.substring(0, this.value.length-2);
	          	 	calculateTotal()
	     		}
	        	 /*
	        	 var txt = '';
	             if (window.getSelection) {
	                txt = window.getSelection();
	             }else if (document.getSelection) {
	                txt = document.getSelection();
	             }else if (document.selection) {
	                txt = document.selection.createRange().text;
	             }

	        	if (txt.toString().length == 0) {
		        	if (( parseFloat($(this).val()+String.fromCharCode(key))) > 20) {
		        		return false;
		        	}

		            if (limit != "undefined" && $(this).val().length < limit) {

		                return true;
		            } else {
		            	return false;
		            }
	        	}else{
	        		if ( parseFloat($(this).val()) == 20 && txt.toString().length == 1) {
		        		return false;
		        	}
	        		return true;
	        	}*/

	        	return true;
	        } else if ( jQuery.inArray(key, navigation) > -1 ) {

	            return true;
	        }
	        return false;
	    });
	} ;


	$(document).ready(function() {
			$("input[name=dependablePercent]").enterToTab();
			$("input[name=dependablePercent]").intOnly(3);
			$("input[name=flexiblePercent]").enterToTab();
			$("input[name=flexiblePercent]").intOnly(3);
			$("input[name=hsInitiativePercent]").enterToTab();
			$("input[name=hsInitiativePercent]").intOnly(3);
			$("input[name=positivePercent]").enterToTab();
			$("input[name=positivePercent]").intOnly(3);
			$("input[name=compassionatePercent]").enterToTab();
			$("input[name=compassionatePercent]").intOnly(3);
			$("input[name=sensePercent]").enterToTab();
			$("input[name=sensePercent]").intOnly(3);
			$("input[name=managingPercent]").enterToTab();
			$("input[name=managingPercent]").intOnly(3);
			$("input[name=totalPercent]").enterToTab(3);
		});

//-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>