<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
private static String getMessage(Locale locale, String key) {
	String result = null;
	try {
		result = ResourceBundle.getBundle("MessageResources", locale).getString(key);
	} catch (Exception e) {
		result = key;
	}
	return result;
}
%>
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
String userCat = request.getParameter("userCat");
boolean devMode = "Y".equals(request.getParameter("devMode"));

eventID = "-1";
elearningID = "-1";
final String evaluationId = "6";
final String sessionKey = "evaluation_" + evaluationId;

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
String[][] answersText = null;
int maxAnsNum = 10;
try {
	int numOfQuestionInt = Integer.valueOf(numOfQuestion);
	answersText = new String[numOfQuestionInt][];
	for (int i = 0; i < numOfQuestionInt; i++) {
		answersText[i] = new String[maxAnsNum];
		for (int j = 0; j < maxAnsNum; j++) {
			answersText[i][j] = request.getParameter("answer" + (i + 1) + "-" + (j + 1));
			
			if (answersText[i][j] != null) {
				answersText[i][j] = TextUtil.parseStrUTF8(answersText[i][j]);
			}
		}
	}
} catch (Exception e) {
}
Map<String, List<ReportableListObject>> answerMap = null;

boolean createAction = false;
boolean completeAction = false;
boolean closeAction = false;

if ("create".equals(command)) {
	createAction = true;
}

String message = "";
String errorMessage = "";

try {
	if ("1".equals(step)) {
		if (createAction) {
			if (devMode) {
				createAction = false;
				completeAction = true;
			} else {
				// store user answer into db

				// get enrollID 
				ArrayList record = EvaluationDB.getNextEnrollID(eventID, evaluationId);
				if (record.size() > 0) {
					ReportableListObject row = null;
					row = (ReportableListObject) record.get(0);
					enrollID = row.getValue(0);
				}
				if (enrollID == null || enrollID.length() == 0 || "null".equals(enrollID)) {
					enrollID = "1";
				}
				
				// get question info
				ArrayList record2 = EvaluationDB.getAllQuestions(evaluationId);
				
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
							
							if (!EvaluationDB.addAnonymousResultAnswer(siteCode, eventID, elearningID, evaluationId, enrollID, String.valueOf(i + 1), answerID, answerFreeText, evaluationSite, userCat)) {
								throw new Exception();
							}
						}
					}
				}
				
				if (answersText != null && answersText.length > 0) {
					ReportableListObject row = null;
					String answerFreeText = null;
					String answerID = null;
					for (int i = 0; i < answersText.length; i++) {
						if (answersText[i] != null) {
							for (int j = 0; j < answersText[i].length; j++) {
								answerFreeText = answersText[i][j];
								if (answerFreeText != null && !"".equals(answerFreeText)) {
									if (!EvaluationDB.addAnonymousResultAnswer(siteCode, eventID, elearningID, evaluationId, enrollID, String.valueOf(i + 1), Integer.toString(j + 1), answerFreeText, evaluationSite, userCat)) {
										throw new Exception();
									}
								}
							}
						}
					}
				}
				
				createAction = false;
				completeAction = true;
				request.getSession().setAttribute(sessionKey, true);
			}
		}
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (evaluationId != null) {
			answerMap = new HashMap<String, List<ReportableListObject>>();
			ArrayList record = EvaluationDB.getAllAnswer(evaluationId);
			
			for (int i = 0; i < record.size(); i++) {
				ReportableListObject row = (ReportableListObject) record.get(i);
				String questionId = row.getValue(0);
				//String answerId = row.getValue(1);
				//String answerDesc = row.getValue(2);
				//String isFreeText = row.getValue(3);
				List row2 = answerMap.get(questionId);
				if (row2 == null) {
					row2 = new ArrayList<ReportableListObject>();
				}
				row2.add(row);
				answerMap.put(questionId, row2);
			}
		}
	}

} catch (Exception e) {
	e.printStackTrace();
	System.err.print("inranet: survey/organizationAssess.jsp() insert error (eventID:" + eventID + ",elearningID:"+elearningID+
			",evaluationId:"+evaluationId+",enrollID:"+enrollID+" )");
	errorMessage = "Sorry, survey submission is not success. Please try again.";
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
h2.survey-title { font-size: 150%; font-weight: bold; text-align: center; height: 20px; margin: 5px 0; }
.intro-header { font-size: 120%; font-weight: bold; text-decoration: underline; margin: 10px 0; }
.part-header-container {  margin: 10px 0; width: 100%; }
.part-header { font-size: 120%; font-weight: bold; margin: 10px 0; }
.thankyou { font-size: 120%; text-align: center; margin: 10px 0; }
.survey-content { font-size: 120%; margin: 10px 0; font-weight: bold; }
.radio { width: 10%; }
.subheader { font-size: 80%; font-weight: bold; }
.eval-q-box { padding: px 0;}
.eval-ans-box p { margin: 5px 20px 0 0; }
.eval-ans-box div.float p { display:inline; width: 100px; }
.eval-ans-box input { margin-right: 5px; }
.eval-ans-box input.numeric-priority { width: 20px; }
.separate-text p { margin: 10px 0; font-size: 110%; font-weight: bold; }
.slogan-box { border: 1px solid #000; padding: 10px; margin: 10px 0;}
.margin-row { height: 10px; }
</style>
<body>
<div id=indexWrapper>
<div id=mainFrame>
<div id=Frame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Survey - Organizational Assessment" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="translate" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<% if (completeAction) { %>
<table width="100%" border="0">
	<tr>
		<td colspan="2" valign="middle">
			<h2 class="survey-title">Survey - Organizational Assessment</h2>
		</td>
	</tr>
	<tr>
		<td>
			<p class="thankyou">Thank you. Survey submitted successfully.</p>
		</td>
	</tr>
<tr><td style="text-align: center;">
<!-- <button onclick="javascript:backToHomePage();" class="btn-click">Back to Home Page</button> -->
<button onclick="javascript:window.close();" class="btn-click">Close</button>
</td></tr>
</table>
<% } else { %>
<table width="100%" border="0">
	<tr>
		<td colspan="2" valign="middle">
			<h2 class="survey-title">Survey - Organizational Assessment</h2>
		</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="80%">
			<p class="intro-header"></p>
			<p class="survey-content">This <u>21-question ‘Survey – Focusing on Organizational Assessment’</u> helps to diagnose exactly where the organization stands in regard to understanding the external environment and how leaders and doctors feel about certain key components critical to the success of any organization.</p>
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td>
		<form name="form1" action="organizationAssess.jsp" method="post" onsubmit="return submitAction();">
<%
	ArrayList record = EvaluationDB.getAllQuestions(evaluationId);
	String checkedAttr = "checked=\"checked\"";
	final int PART_1_Q_NUM = 22;
	
	if (record.size() > 0) {
		int qCounter = 0;
		ReportableListObject row = null;
%>

<!-- Customize -->
<table width="100%" border="0">
<%
		int qDisplayNo = 0;
		for (int i = qCounter; i < qCounter + PART_1_Q_NUM; i++) {
			int qNo = i + 1;
			if (i != 1)
				qDisplayNo++;
			row = (ReportableListObject) record.get(i);
%>
<%			if (qNo == 4) { %>
	<tr class="separate-text">
		<td colspan="2">
			<div class="slogan-box">
				<p align="center">Adventist Health Mission Statement</p> 
				<p>The mission of ADVENTIST HEALTH is to provide premier ethical leadership and multidisciplinary teamwork to plan, establish, and manage a comprehensive range of healthcare services that promote a total healing environment and lifestyle as a private not-for-profit Christian business organization for Hong Kong, China, and Asia, with values consistent with the philosophy, teachings and practices of the Seventh-Day Adventist Church.</p>
			</div>
		</td>
	</tr>
<%			} else if (qNo == 15) { %>
	<tr class="separate-text">
		<td colspan="2">
			<p>For questions 14 - 16, if you do not supervise any staff, you may key in '0'.</p>
		</td>
	</tr>
<%			} else if (qNo == 18) { %>
	<tr class="separate-text">
		<td colspan="2">
			<p> </p>
		</td>
	</tr>
<%			} %>
	<tr class="eval-q-box smallText">
		<td style="width: 20px; font-weight: bold;" valign="top"><%=qNo != 2 ? qDisplayNo + "." : ""%></td>
		<td style="font-weight: bold;"><%=row.getValue(1) %></td>
	</tr>
	<tr class="eval-ans-box smallText">
<%
		List aRows = answerMap.get(String.valueOf(qNo));
%>
		<td></td>
		<td>
<%			if (qNo >= 1 && qNo <= 3) { %>
<%				for (int j = 0; j < aRows.size(); j++) {
					ReportableListObject rlo = (ReportableListObject) aRows.get(j);
%>
			<p><input type="radio" name="answer<%=row.getValue(0) %>" value="<%=rlo.getValue(1) %>" /><%=rlo.getValue(2) %></p>
<%				} %>
<%			} else if ((qNo >= 4 && qNo <= 6) || (qNo >= 19 && qNo <= 22) || (qNo >= 11 && qNo <= 13) || qNo == 18) { %>
			<div class="float">
<%				for (int j = 0; j < aRows.size(); j++) {
					ReportableListObject rlo = (ReportableListObject) aRows.get(j);
%>
			<p><input type="radio" name="answer<%=row.getValue(0) %>" value="<%=rlo.getValue(1) %>" /><%=rlo.getValue(2) %></p>
<%				} %>
			</div>
<%			} else if (qNo == 7) { %>
			<div class="float">
<%				for (int j = 0; j < aRows.size(); j++) {
					ReportableListObject rlo = (ReportableListObject) aRows.get(j);
					if (String.valueOf(2).equals(rlo.getValue(1))) {
%>
				<p><input type="radio" name="answer<%=row.getValue(0) %>" value="<%=rlo.getValue(1) %>" /><%=rlo.getValue(2) %>
<%					} else if (String.valueOf(3).equals(rlo.getValue(1))) { %>				
				&nbsp;<%=rlo.getValue(2) %><textarea name="answer<%=row.getValue(0) %>-3" rows="2" cols="100"></textarea> )</p>
<%					} else { %>
				<p><input type="radio" name="answer<%=row.getValue(0) %>" value="<%=rlo.getValue(1) %>" /><%=rlo.getValue(2) %></p>
<%					} %>
<%				} %>
			</div>
<%			} else if (qNo == 8) { %>
<%				for (int j = 0; j < aRows.size(); j++) {
					ReportableListObject rlo = (ReportableListObject) aRows.get(j);
					if (String.valueOf(9).equals(rlo.getValue(1))) {
%>
				<p><input type="text" name="answer<%=row.getValue(0) %>-<%=rlo.getValue(1) %>" class="numeric-priority" /><%=rlo.getValue(2) %>
<%					} else if (String.valueOf(10).equals(rlo.getValue(1))) { %>				
				&nbsp;<%=rlo.getValue(2) %><textarea name="answer<%=row.getValue(0) %>-<%=rlo.getValue(1) %>" rows="2" cols="100"></textarea></p>
<%					} else { %>
				<p><input type="text" name="answer<%=row.getValue(0) %>-<%=rlo.getValue(1) %>" class="numeric-priority" /><%=rlo.getValue(2) %></p>
<%					} %>
<%				} %>
<%			} else if (qNo == 9) { %>
<%				for (int j = 0; j < aRows.size(); j++) {
					ReportableListObject rlo = (ReportableListObject) aRows.get(j);
					if (String.valueOf(7).equals(rlo.getValue(1))) {
%>
				<p><input type="text" name="answer<%=row.getValue(0) %>-<%=rlo.getValue(1) %>" class="numeric-priority" /><%=rlo.getValue(2) %>
<%					} else if (String.valueOf(8).equals(rlo.getValue(1))) { %>				
				&nbsp;<%=rlo.getValue(2) %><textarea name="answer<%=row.getValue(0) %>-<%=rlo.getValue(1) %>" rows="2" cols="100"></textarea></p>
<%					} else { %>
				<p><input type="text" name="answer<%=row.getValue(0) %>-<%=rlo.getValue(1) %>" class="numeric-priority" /><%=rlo.getValue(2) %></p>
<%					} %>
<%				} %>
<%			} else if (qNo == 10) { %>
<%				for (int j = 0; j < aRows.size(); j++) {
					ReportableListObject rlo = (ReportableListObject) aRows.get(j);
					if (String.valueOf(6).equals(rlo.getValue(1))) {
%>
				<p><input type="text" name="answer<%=row.getValue(0) %>-<%=rlo.getValue(1) %>" class="numeric-priority" /><%=rlo.getValue(2) %>
<%					} else if (String.valueOf(7).equals(rlo.getValue(1))) { %>				
				&nbsp;<%=rlo.getValue(2) %><textarea name="answer<%=row.getValue(0) %>-<%=rlo.getValue(1) %>" rows="2" cols="100"></textarea></p>
<%					} else { %>
				<p><input type="text" name="answer<%=row.getValue(0) %>-<%=rlo.getValue(1) %>" class="numeric-priority" /><%=rlo.getValue(2) %></p>
<%					} %>
<%				} %>
<%			} else if (qNo == 14) { %>
			<div class="float">
<%				for (int j = 0; j < aRows.size(); j++) {
					ReportableListObject rlo = (ReportableListObject) aRows.get(j);
					if (String.valueOf(6).equals(rlo.getValue(1))) {
%>
				<div style="margin: 10px 0;">
					<p><%=rlo.getValue(2) %> <textarea name="answer<%=row.getValue(0) %>-<%=rlo.getValue(1) %>" rows="2" cols="100"></textarea></p>
				</div>
<%					} else { %>
				<p><input type="radio" name="answer<%=row.getValue(0) %>" value="<%=rlo.getValue(1) %>" /><%=rlo.getValue(2) %></p>
<%					} %>
<%				} %>
			</div>
<%			} else if (qNo >= 15 && qNo <= 17) { %>
<%				for (int j = 0; j < aRows.size(); j++) {
					ReportableListObject rlo = (ReportableListObject) aRows.get(j);
%>
			<p><textarea name="answer<%=row.getValue(0) %>-<%=rlo.getValue(1) %>" rows="1" cols="10"></textarea></p>
<%				} %>
<%			} %>
		</td>
	</tr>
	<tr class="margin-row"></tr>
<%	
		}
		qCounter += PART_1_Q_NUM;
%>

</table>
<%	} %>

<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitAction();" class="btn-click">
				<bean:message key="button.submit" />
			</button>
		</td>
	</tr>
</table>
</div>

<table width="100%" border="0">
	<tr class="smallText">
		<td>
			<p class="thankyou">Thank you for your time and effort. Should you encounter any technical problems for the survey, please contact IT at 2835-0606.</p>
		</td>
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="elearningID" value="<%=elearningID %>"/>
<input type="hidden" name="eventID" value="<%=eventID %>"/>
<input type="hidden" name="enrollID" value="<%=enrollID %>"/>
<input type="hidden" name="numOfQuestion" value="<%=record.size() %>" />
<input type="hidden" name="userCat" value="<%=userCat %>"/>
</form>
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
</table>
<%} %>
<script language="javascript">
<!--
$(document).ready(function(){
	$('input.numeric-priority').keypress(function(e) {
	 // get key pressed
	 var c = String.fromCharCode(e.which);
	 var value = this.value;
	 var name = this.name;
	 var basename;
	 var dupValue = false;
	 if (name) {
		 var substr = name.split('-');
		 if (substr[0])
			 basename = substr[0];
	 }
	 $('input[name^='+basename+']').each(function(index, e) {
		 if (c == e.value)
			 dupValue = true;
	 });
	 
	 // var d = e.keyCode? e.keyCode : e.charCode; // this seems to catch arrow and delete better than jQuery's way (e.which)
	 // match against allowed set and fail if no match
	 var allowed = '123';
	 var allowedLen = 1;
	 var exceedLen = value.length >= allowedLen;
	 if ((e.which != 8 && allowed.indexOf(c) < 0) || exceedLen || dupValue) return false; // d !== 37 && d != 39 && d != 46 && 
	 // just replace spaces in the preview
	 //window.setTimeout(function() {$('#preview').text($('#name').val().replace(/ /g, '-'));}, 1);
	});
});

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
</div>

</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>