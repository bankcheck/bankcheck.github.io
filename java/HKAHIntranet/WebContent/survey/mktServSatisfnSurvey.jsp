<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.apache.struts.*"%>
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
Locale locale = Locale.US;

if("chi".equals(command)){
	locale = Locale.TRADITIONAL_CHINESE;
	session.setAttribute( Globals.LOCALE_KEY, locale );
}else{
	locale = Locale.US;
	session.setAttribute( Globals.LOCALE_KEY, locale );
}
eventID = "-1";
elearningID = "-1";
final String evaluationId = "7";
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
	System.err.print("inranet: survey/mktServSatisfnSurvey.jsp() insert error (eventID:" + eventID + ",elearningID:"+elearningID+
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
	<jsp:param name="pageTitle" value="function.survey.mktSurvey" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="translate" value="Y" />
	<jsp:param name="keepReferer" value="Y" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<% if (completeAction) { %>
<table width="100%" border="0">

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
		<td width="10%">&nbsp;</td>
		<td width="80%">
			<p class="intro-header"></p>
			<p class="survey-content"><br>
			<%if("chi".equals(command)){%>
			您好！為了提升服務品質，現誠摯希望您回答下列問題，並惠賜卓見。萬分感謝。
			<br><div align="right"><b>港安醫院市場部謹啟</b></div>			
			<%}else{%>
			We are conducting a Marketing Department Service Satisfaction Survey in order to enhance our services. 
			We value your feedback and request your cooperation by answering the following questions. 
			Thank you for your time and participation.
			<%} %>		
			</p>
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr class="separate-text">
		<td colspan="2">
			<div style="text-align:center">			
				<button href="javascript:void(0);"  onclick="return submitAction('eng','0');">English</button>
				<button href="javascript:void(0);"  onclick="return submitAction('chi','0');">中文</button>
			</div>		
		</td>
	</tr> 
	<tr>
		<td width="10%">&nbsp;</td>
		<td>
		<form name="form1" action="mktServSatisfnSurvey.jsp" method="post" onsubmit="return submitAction();">
<%
	ArrayList record = EvaluationDB.getAllQuestions(evaluationId);
	String checkedAttr = "checked=\"checked\"";
	final int PART_1_Q_NUM = 29;
	
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
			String[] diffLangQn = row.getValue(1).split("<C>");	
			if(qNo == 1){
%>	
		<div class="separate-text">
				<%if("chi".equals(command)){%>
					<p>一. 	基本資料</p>
				<%}else{ %>
					<p>A. Basic Information</p>
				<%} %>
		</div>			
<%			}
%>
<%			if (qNo == 4) { 
			qDisplayNo = 1;
%>
	<tr class="separate-text">
		<td colspan="2">
			<div class="slogan-box" style="width:100%;">
				<%if("chi".equals(command)){%>
				<p style="text-align:center;">（1-非常滿意；2-滿意；3-尚可；4-不太滿意；5-不滿意；N/A-無法評價）</p>
				<%}else{ %>
				<p>（1 – Very Satisfied; 2 – Somewhat Satisfied; 3 – Neutral ; 4 – Somewhat Dissatisfied; 5 – Dissatisfied; NA – Not Applicable）</p>
				<%} %>
			</div>
	<div class="separate-text">
			<%if("chi".equals(command)){%>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;二. 服務態度及表現</p>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;就下列事項，您對市場部員工的的滿意度為：</p>
			<%}else{ %>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;B. Service Attitude and performance</p>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;How satisfied were you with the marketing staff in terms of:</p>
			<%} %>
	</div>			
		</td>		
	</tr>
	<tr class="eval-q-box smallText">
		<td style="width: 20px; font-weight: bold;" valign="top">&nbsp;</td>
		<td style="" >&nbsp;</td>

			<td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>NA</td>

	</tr>	
<%			} else if (qNo == 11) { 
				qDisplayNo = 1;
%>
	<tr class="separate-text">
		<td colspan="2">
	<div class="separate-text">
			<%if("chi".equals(command)){%>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;三. 印刷品、活動安排及其他</p>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;您對下列事項的滿意度為：</p>
			<%}else{ %>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;C. Publications, arrangement of events, and others</p>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;How satisfied were you with each of the following?</p>
			<%} %>	
	</div>	
		</td>
	</tr>
	<tr class="eval-q-box smallText">
		<td style="width: 20px; font-weight: bold;" valign="top">&nbsp;</td>
		<td style="" >&nbsp;</td>

				<td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>NA</td>
	</tr>	
<%	} else if (qNo == 21) { 
				qDisplayNo = 1;
%>
	<tr class="separate-text">
		<td colspan="2">
	<div class="separate-text">
			<%if("chi".equals(command)){%>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;四. 整體表現</p>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;1. 您對下列事項的滿意度為:</p>
			<%}else{ %>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;D. Overall</p>
				<p>&nbsp;&nbsp;&nbsp;&nbsp;1. How satisfied were you with each of the following? </p>
			<%} %>		
	</div>
		</td>
	</tr>
	<tr class="eval-q-box smallText">
		<td style="width: 20px; font-weight: bold;" valign="top">&nbsp;</td>
		<td style="" >&nbsp;</td>

				<td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>NA</td>

	</tr>		
<%	}else if (qNo == 27){
%>
	<tr class="eval-q-box smallText">
		<td style="width: 20px; font-weight: bold;" valign="top">&nbsp;</td>
		<td style="" >&nbsp;</td>

				<td>1</td><td>2</td><td>3</td><td>4</td><td>5</td><td>NA</td>

	</tr>	
<%	
	qDisplayNo = 2;
} %>
	<tr class="eval-q-box smallText">
		<td style="width: 20px; font-weight: bold;" valign="top">&nbsp;&nbsp;&nbsp;&nbsp;<%=((qNo != 2)&&!(qNo >20 && qNo <27)&& qNo != 29) ? qDisplayNo + "." :((qNo >20 && qNo <27)?"-" :"")%></td>
		<td style="<%if(qNo == 29){%>font-size:120%;font-weight: bold; <%} %>" ><%="chi".equals(command)?diffLangQn[1]:diffLangQn[0]%></td>
<%if(qNo < 4 || qNo == 10 || qNo == 20 || qNo == 29){%>
	</tr>

	<tr class="eval-ans-box smallText">
	
	<td></td>		
<%} %>

<%
		List aRows = answerMap.get(String.valueOf(qNo));
%>
		
<%			if (qNo >= 1 && qNo <= 3) { %>
<td>
<%				for (int j = 0; j < aRows.size(); j++) {
					ReportableListObject rlo = (ReportableListObject) aRows.get(j);
					String[] diffLangAns = rlo.getValue(2).split("<C>");
%>			
			<p><input type="radio" name="answer<%=row.getValue(0) %>" value="<%=rlo.getValue(1) %>" /><%="chi".equals(command)?diffLangAns[1]:diffLangAns[0]%></p>
<%				} %>
<%			} else if ((qNo >= 4 && qNo <= 9) ||(qNo >= 11 && qNo <= 19)||(qNo >= 21 && qNo <= 28)) { %>	

				<p style="width:200px;">

	<%				for (int j = 0; j < aRows.size(); j++) {
						ReportableListObject rlo = (ReportableListObject) aRows.get(j);
	%>
				<td><input type="radio" name="answer<%=row.getValue(0) %>" value="<%=rlo.getValue(1) %>" /><%="".equals(rlo.getValue(2))?"":rlo.getValue(2) %></td>
	<%				} %>

				</p>
				</div>
<%			}else{ %>
			<td>
			<p><textarea name="answer<%=row.getValue(0) %>" rows="4" cols="140"></textarea></p>
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
			<button onclick="return submitAction('create','1');" class="btn-click">
				<%if("chi".equals(command)){ %>提交<%}else{ %>Submit<%} %>
			</button>
		</td>
	</tr>
</table>
</div>

<table width="100%" border="0">
	<tr class="smallText">
		<td>
			<%if("chi".equals(command)){ %>
				<p class="thankyou">誠摯感謝您對本部門的肯定和支持！如遇上任何技術問題，請聯絡資訊科技部 3651-8759</p>			
			<%}else{ %>		
				<p class="thankyou">Thank you for your time and effort. Should you encounter any technical problems for the survey, please contact IT at 3651-8759.</p>
			<%} %>
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

	function submitAction(act,step) {
		document.form1.command.value = act;
		document.form1.step.value = step;
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