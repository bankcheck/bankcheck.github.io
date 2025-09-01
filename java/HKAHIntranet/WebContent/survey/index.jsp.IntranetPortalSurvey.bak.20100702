<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String step = request.getParameter("step");
String elearningID = request.getParameter("elearningID");
String eventID = request.getParameter("eventID");
String enrollID = request.getParameter("enrollID");
String evaluationSite = request.getParameter("evaluationSite");
String numOfQuestion = request.getParameter("numOfQuestion");
String siteCode = ConstantsServerSide.SITE_CODE;
final String EVALUATION_ID = "3";

String[] answers = null;
try {
	int numOfQuestionInt = Integer.valueOf(numOfQuestion);
	answers = new String[numOfQuestionInt];
	for (int i = 0; i < numOfQuestionInt; i++) {
		answers[i] = request.getParameter("answer" + (i + 1));
		if (answers[i] != null) {
			answers[i] = TextUtil.parseStrUTF8(answers[i]);
		}
	}
} catch (Exception e) {
}

boolean createAction = true;
boolean completeAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

try {
	if ("1".equals(step)) {
		if (createAction) {
			// store user answer into db
			eventID = "-1";
			elearningID = "-1";
			// get enrollID 
			ArrayList record = EvaluationDB.getNextEnrollID(eventID, EVALUATION_ID);
			if (record.size() > 0) {
				ReportableListObject row = null;
				row = (ReportableListObject) record.get(0);
				enrollID = row.getValue(0);
			}
			if (enrollID == null || enrollID.length() == 0 || "null".equals(enrollID)) {
				enrollID = "1";
			}
			
			// get question info
			ArrayList record2 = EvaluationDB.getAllQuestions(EVALUATION_ID);
			
			if (answers != null && answers.length > 0) {
				ReportableListObject row = null;
				String answerFreeText = null;
				String answerID = null;
				for (int i = 0; i < answers.length; i++) {
					if (answers[i] != null) {
						row = (ReportableListObject) record2.get(i);
						if ("Y".equals(row.getFields2())) {
							answerFreeText = answers[i];
							answerID = "-1";
						} else {
							answerFreeText = null;
							answerID = answers[i];
						}
						
						if (!EvaluationDB.addAnonymousResultAnswer(siteCode, eventID, elearningID, EVALUATION_ID, enrollID, String.valueOf(i + 1), answerID, answerFreeText, evaluationSite)) {
							throw new Exception();
						}
					}
				}
			}
			
			createAction = false;
			completeAction = true;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
	errorMessage = "Sorry, survey submission not success. Please try again.";
	completeAction = false;
}
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
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<style>
h1.survey-title { font-size: 170%; text-align: center; }
h2.survey-title { font-size: 130%; font-weight: bold; text-align: center; }
.intro-header { font-size: 120%; font-weight: bold; text-decoration: underline; margin: 10px 0; }
.part-header-container {  margin: 10px 0; width: 100%; }
.part-header { font-size: 120%; font-weight: bold; margin: 10px 0; }
.thankyou { font-size: 120%; text-align: center; margin: 10px 0; }
.survey-content { margin: 10px 0; }
.radio { width: 10%; }
.subheader { font-size: 80%; font-weight: bold; }
</style>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Survey on Intranet Portal" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="translate" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<% if (completeAction) { %>
<table width="100%" border="0">
<tr><td>
<P class="thankyou">The survey is submitted successfully. Thank you for your time and effort.</P></td>
</tr>
<tr><td style="text-align: center;">
<button onclick="javascript:backToHomePage();" class="btn-click">Back to Home Page</button>
</td></tr>
</table>
<% } else { %>
<table width="100%" border="0">
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="80%">
			<P class="intro-header"></P>
			<P class="survey-content">To improve our intranet portal, we are conducting a satisfaction survey. Please share with us your experience with the Intranet Portal. We greatly value your feed back and all survey responses will remain anonymous. Thank you in advance for your participation.</P>
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td>
		<form name="form1" action="index.jsp" method="post" onsubmit="return submitAction();">
<%
	ArrayList record = EvaluationDB.getAllQuestions(EVALUATION_ID);
	String checkedAttr = "checked=\"checked\"";
	final int PART_1_Q_NUM = 8;
	final int PART_2_Q_NUM = 1;
	final int PART_3_Q_NUM = 30;
	final int PART_4_Q_NUM = 30;
	final int PART_5_Q_NUM = 1;
	final int PART_6_Q_NUM = 1;
	
	if (record.size() > 0) {
		int qCounter = 0;
		ReportableListObject row = null;
%>

<!-- 1. Overall -->
<table cellpadding="0" cellspacing="0" border="0" class="part-header-container">
	<tr valign="top">
		<td class="part-header" style="width: 2%">1.</td>
		<td class="part-header">Rating of overall Intranet Portal<br /> (1 – Outstanding; 2 – Very Good; 3 – Good; 4 – Fair; 5 – Poor; 6 – Unable to rate)</td>
	</tr>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td class="infoCenterLabel"></td>
		<td class="infoCenterLabel">1</td>
		<td class="infoCenterLabel">2</td>
		<td class="infoCenterLabel">3</td>
		<td class="infoCenterLabel">4</td>
		<td class="infoCenterLabel">5</td>
		<td class="infoCenterLabel">6</td>
	</tr>
<%
		for (int i = qCounter; i < qCounter + PART_1_Q_NUM; i++) {
			row = (ReportableListObject) record.get(i);
%>
	<tr class="smallText">
		<td class="infoData"><span id="prompt-answer<%=row.getValue(0) %>"><%=row.getValue(1) %></span></td>
<%			if (createAction) { %>
<%
			String value1Checked = null;
			String value2Checked = null;
			String value3Checked = null;
			String value4Checked = null;
			String value5Checked = null;
			String value6Checked = null;
			value1Checked = ("1".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value2Checked = ("2".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value3Checked = ("3".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value4Checked = ("4".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value5Checked = ("5".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value6Checked = ("6".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
%>
		<td class="infoData radio" style="text-align: center;" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="1" <%=value1Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="2" <%=value2Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="3" <%=value3Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="4" <%=value4Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="5" <%=value5Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="6" <%=value6Checked %> /></td>
<%			} %>
	</tr>
<%	
		}
		qCounter += PART_1_Q_NUM;
%>
</table>
<!-- 1. END -->	
	
<!-- 2. Share 2 things -->
<%
	row = (ReportableListObject) record.get(qCounter++);
%>
<table cellpadding="0" cellspacing="0" border="0" class="part-header-container">
	<tr valign="top">
		<td class="part-header" style="width: 2%">2.</td>
		<td class="part-header"><%=row.getValue(1) %></td>
	</tr>
</table>
<textarea name="answer<%=row.getValue(0) %>" rows="2" cols="150"></textarea>
<!-- 2. END -->	

	
<!-- 3. Most frequently used -->
<table cellpadding="0" cellspacing="0" border="0" class="part-header-container">
	<tr valign="top">
		<td class="part-header" style="width: 2%">3.</td>
		<td class="part-header">Most frequently used sections<p class="subheader">(1 – Once daily; 2 –Two or more times everyday; 3 – Once every week; 4 – Once every two weeks; 5 – Once a month; 6 – Unable to rate)</p></td>
	</tr>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td class="infoCenterLabel"></td>
		<td class="infoCenterLabel">1</td>
		<td class="infoCenterLabel">2</td>
		<td class="infoCenterLabel">3</td>
		<td class="infoCenterLabel">4</td>
		<td class="infoCenterLabel">5</td>
		<td class="infoCenterLabel">6</td>
	</tr>
<%
		for (int i = qCounter; i < qCounter + PART_3_Q_NUM; i++) {
			row = (ReportableListObject) record.get(i);
%>
<%				if ("Accreditation".equals(row.getValue(1))) { %>
	<tr>
		<td colspan="7">
			<table width="100%" border="0" style="margin: 10px 0;">
				<tr>
					<td class="part-header" style="width: 2%"></td>
					<td class="part-header">
						<p class="subheader">(1 – Once daily; 2 –Two or more times everyday; 3 – Once every week; 4 – Once every two weeks; 5 – Once a month; 6 – Unable to rate)</p>
					<td>
				</tr>
			</table>
		</td>
	</td>
	<tr class="smallText">
		<td class="infoCenterLabel"></td>
		<td class="infoCenterLabel">1</td>
		<td class="infoCenterLabel">2</td>
		<td class="infoCenterLabel">3</td>
		<td class="infoCenterLabel">4</td>
		<td class="infoCenterLabel">5</td>
		<td class="infoCenterLabel">6</td>
	</tr>
<%				}	 %>
	<tr class="smallText">
		<td class="infoData"><span id="prompt-answer<%=row.getValue(0) %>"><%=row.getValue(1) %></span></td>
<%			if (createAction) { %>
<%
			String value1Checked = null;
			String value2Checked = null;
			String value3Checked = null;
			String value4Checked = null;
			String value5Checked = null;
			String value6Checked = null;
			value1Checked = ("1".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value2Checked = ("2".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value3Checked = ("3".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value4Checked = ("4".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value5Checked = ("5".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value6Checked = ("6".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
%>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="1" <%=value1Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="2" <%=value2Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="3" <%=value3Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="4" <%=value4Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="5" <%=value5Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="6" <%=value6Checked %> /></td>
<%			} %>
	</tr>
<%	
		}
		qCounter += PART_3_Q_NUM;
%>
</table>
<!-- 3. END -->

<!-- 4. Rating of selected section-->
<table cellpadding="0" cellspacing="0" border="0" class="part-header-container">
	<tr valign="top">
		<td class="part-header" style="width: 2%">4.</td>
		<td class="part-header">Rating of selected section<br /> (1 – Outstanding; 2 – Very Good; 3 – Good; 4 – Fair; 5 – Poor; 6 – Unable to rate)</td>
	</tr>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td class="infoCenterLabel"></td>
		<td class="infoCenterLabel">1</td>
		<td class="infoCenterLabel">2</td>
		<td class="infoCenterLabel">3</td>
		<td class="infoCenterLabel">4</td>
		<td class="infoCenterLabel">5</td>
		<td class="infoCenterLabel">6</td>
	</tr>
<%
		for (int i = qCounter; i < qCounter + PART_4_Q_NUM; i++) {
			row = (ReportableListObject) record.get(i);
%>
<%				if ("Accreditation".equals(row.getValue(1))) { %>
	<tr>
		<td colspan="7">
			<table width="100%" border="0" style="margin: 10px 0;">
				<tr>
					<td class="part-header" style="width: 2%"></td>
					<td class="part-header">
						(1 – Outstanding; 2 – Very Good; 3 – Good; 4 – Fair; 5 – Poor; 6 – Unable to rate)
					<td>
				</tr>
			</table>
		</td>
	</td>
	<tr class="smallText">
		<td class="infoCenterLabel"></td>
		<td class="infoCenterLabel">1</td>
		<td class="infoCenterLabel">2</td>
		<td class="infoCenterLabel">3</td>
		<td class="infoCenterLabel">4</td>
		<td class="infoCenterLabel">5</td>
		<td class="infoCenterLabel">6</td>
	</tr>
<%				}	 %>
	<tr class="smallText">
		<td class="infoData"><span id="prompt-answer<%=row.getValue(0) %>"><%=row.getValue(1) %></span></td>
<%			if (createAction) { %>
<%
			String value1Checked = null;
			String value2Checked = null;
			String value3Checked = null;
			String value4Checked = null;
			String value5Checked = null;
			String value6Checked = null;
			value1Checked = ("1".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value2Checked = ("2".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value3Checked = ("3".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value4Checked = ("4".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value5Checked = ("5".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
			value6Checked = ("6".equals(request.getParameter("answer" + row.getValue(0)))) ? checkedAttr : "";
%>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="1" <%=value1Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="2" <%=value2Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="3" <%=value3Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="4" <%=value4Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="5" <%=value5Checked %> /></td>
		<td class="infoData radio" style="text-align: center;"><input type="radio" name="answer<%=row.getValue(0) %>" value="6" <%=value6Checked %> /></td>
<%			} %>
	</tr>
<%	
		}
		qCounter += PART_4_Q_NUM;
%>
</table>
<!-- 4. END -->	
	
<!-- 5. Suggestions -->
<%
	row = (ReportableListObject) record.get(qCounter++);
%>
<table cellpadding="0" cellspacing="0" border="0" class="part-header-container">
	<tr valign="top">
		<td class="part-header" style="width: 2%">5.</td>
		<td class="part-header"><%=row.getValue(1) %></td>
	</tr>
</table>
<textarea name="answer<%=row.getValue(0) %>" rows="2" cols="150"></textarea>
<!-- 5. END -->	

<!-- 6. Information suggested -->
<%
	row = (ReportableListObject) record.get(qCounter++);
%>
<table cellpadding="0" cellspacing="0" border="0" class="part-header-container">
	<tr valign="top">
		<td class="part-header" style="width: 2%">6.</td>
		<td class="part-header"><%=row.getValue(1) %></td>
	</tr>
</table>
<textarea name="answer<%=row.getValue(0) %>" rows="2" cols="150"></textarea>
<!-- 6. END -->	

<%	} %>


<%if (createAction) { %>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitAction();" class="btn-click"><bean:message key="button.submit" /></button>
		</td>
	</tr>
</table>
</div>
<%}  %>

<table width="100%" border="0">
	<tr class="smallText">
		<td><p class="thankyou">Thank you for your time and effort.</p></td>
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="elearningID" value="<%=elearningID %>"/>
<input type="hidden" name="eventID" value="<%=eventID %>"/>
<input type="hidden" name="enrollID" value="<%=enrollID %>"/>
<input type="hidden" name="numOfQuestion" value="<%=record.size() %>" />
</form>
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
</table>
<%} %>
<script language="javascript">
<!--
	
	function submitAction() {
		document.form1.command.value = "create";
		document.form1.step.value = "1";
		document.form1.submit();
	}
	
	function backToHomePage() {
		if (top.frames['bigcontent']) {
			top.frames['bigcontent'].location.href = '../common/leftright_portal.jsp?category=home';
		} else {
			window.location.href = '../index.jsp?category=home';
		}
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>