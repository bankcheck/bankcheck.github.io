<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.apache.commons.codec.net.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private final static String alpha[] = new String[] {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j"};

	private String lineWrap(String line) {
		StringBuffer result = new StringBuffer();

		if (line != null) {
			for (int i = 0; i < line.length(); i++) {
				if ("\n".equals(line.substring(i, i + 1))) {
					result.append("<br>");
				} else {
					result.append(line.charAt(i));
				}
			}
		} else {
			result.append(line);
		}

		return result.toString();
	}

	private int getNoOfCorrectAnswer(
			String []questions, String []questionsDesc,
			String [][]answers, String [][]answersDesc,
			String [][]answersCorrect, String [][]answersUser) {
		int correctAnswerNumInt = 0;
		Object[] result = null;
		// fetch each question
		for (int i = 0; i < questions.length; i++) {
			// calculate correct no of question answered
			result = isCorrectAnswer(i, questions, questionsDesc, answers, answersDesc, answersCorrect, answersUser);
			if (((Boolean) result[0]).booleanValue()) {
				correctAnswerNumInt++;
			}
		}
		return correctAnswerNumInt;
	}

	private Object[] isCorrectAnswer(int currentQuestion,
			String []questions, String []questionsDesc,
			String [][]answers, String [][]answersDesc,
			String [][]answersCorrect, String [][]answersUser) {
		// flag to store whether this question is correct
		boolean correctAnswerPerQuestion = false;
		boolean correctAnswer = false;
		boolean userAnswer = false;
		StringBuffer output = new StringBuffer();
		int userAnswerCorrect = 0;

		try {
			// fetch one question
			output.append("<tr class=\"sessionColEven\">");
			output.append("	<td align=\"center\" valign=\"top\">Q" + (currentQuestion + 1) + ")</td>");
			output.append("	<td width=\"90%\"><font color='green'>" + lineWrap(questionsDesc[currentQuestion]) + "</font></td>");
			output.append("	<td align=\"center\">&nbsp;</td>");
			output.append("</tr>");

			// fetch each answer
			for (int i = 0; i < answers[currentQuestion].length; i++) {
				// is current answer correct
				correctAnswer = false;
				userAnswer = false;

				// whether user select this answer
				for (int k = 0; !userAnswer && k < answersUser[currentQuestion].length; k++) {
					if (answers[currentQuestion][i].equals(answersUser[currentQuestion][k])) {
						userAnswer = true;
					}
				}

				// is it correct answer
				for (int j = 0; !correctAnswer && j < answersCorrect[currentQuestion].length; j++) {
					if (answers[currentQuestion][i].equals(answersCorrect[currentQuestion][j])) {
						correctAnswer = true;
						if (userAnswer) userAnswerCorrect++;
					}
				}

				output.append("<tr class=\"sessionColOdd\">");
				output.append("	<td align=\"center\">&nbsp;</td>");
				output.append("	<td width=\"90%\">");
				output.append(alpha[i]);
				output.append(")&nbsp;<font color=\"");
				if (correctAnswer) {
					output.append("blue");
				} else {
					if (userAnswer) {
						output.append("red");
					} else {
						output.append("gray");
					}
				}
				output.append("\">");
				output.append(answersDesc[currentQuestion][i]);
				output.append(correctAnswer?"</font>":"");
				if (userAnswer) {
					if (correctAnswer) {
						output.append("<img src=\"../images/tick_green_small.gif\">");
					} else {
						output.append("<img src=\"../images/cross_red_small.gif\">");
					}
				}
				output.append("</td>");
				output.append("	<td align=\"center\">&nbsp;</td>");
				output.append("</tr>");
			}

			// check how many answers are correct
			correctAnswerPerQuestion = userAnswerCorrect == answersCorrect[currentQuestion].length;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new Object[] { (correctAnswerPerQuestion?Boolean.TRUE:Boolean.FALSE), output.toString() };
	}


%>
<%
int noOfQuestionPerPage = 3;
response.setHeader("Pragma","no-cache");

UserBean userBean = new UserBean(request);
String userID = request.getParameter("userID");

String category = "title.education";
String from = request.getParameter("from");
boolean isPopUp = true;

//boolean isDebug = false;
//boolean isRealDebug = false;

boolean isDebug = false;      
boolean isRealDebug = false;  

int current_mm = DateTimeUtil.getCurrentMonth();

String elearningID = request.getParameter("elearningID");
String command = request.getParameter("command");
String moveTo = request.getParameter("moveTo");
String questionPointer = request.getParameter("questionPointer");
String source = (String)request.getParameter("source");

String eventID = (String) session.getAttribute("elearning.eventID");
String topic = (String) session.getAttribute("elearning.topic");
String topicZh = (String) session.getAttribute("elearning.topicZh");
boolean hasDocument = "1".equals((String) session.getAttribute("elearning.hasDocument"));
String questionNum = (String) session.getAttribute("elearning.questionNum");
String passGrade = (String) session.getAttribute("elearning.passGrade");
String description = (String) session.getAttribute("elearning.description");
String duration = null;
String swfFile = null;

String[] questions = (String[]) session.getAttribute("elearning.questions");
String[] questionsDesc = (String[]) session.getAttribute("elearning.questionsDesc");
String[][] answers = (String[][]) session.getAttribute("elearning.answers");
String[][] answersDesc = (String[][]) session.getAttribute("elearning.answersDesc");
String[][] answersCorrect = (String[][]) session.getAttribute("elearning.answersCorrect");
String[][] answersUser = (String[][]) session.getAttribute("elearning.answersUser");

int questionNumInt = 0;
int passGradeInt = 0;
int documentsNum = 0;
int questionPointerInt = 0;
int correctAnswerNumInt = 0;
Object[] result = null;

List<String> videoPathsEng = new ArrayList<String>();
List<String> videoPathsTChi = new ArrayList<String>();
List<String> videoPaths = new ArrayList<String>();

String message = "";
String errorMessage = "";

boolean testAction = false;
boolean submitAction = false;
boolean resultAction = false;
boolean closeAction = false;

if (elearningID != null && elearningID.length() > 0) {
	if("".equals(command)|| command == null) {
		command = "test";
	}
	if ("test".equals(command)) {
		testAction = true;
	} else if ("submit".equals(command)) {
		submitAction = true;
	} else if ("result".equals(command)) {
		resultAction = true;
	}

	try {
		if (questionNum != null) {
			questionNumInt = Integer.parseInt(questionNum);
		}
		if (passGrade != null) {
			passGradeInt = Integer.parseInt(passGrade);
		}

		if (questionPointer != null) {
			questionPointerInt = Integer.parseInt(questionPointer);
		}

		if (submitAction) {
			// store user input
			for (int i = questionPointerInt; i<questionPointerInt + noOfQuestionPerPage; i++) {
				if (answersCorrect[i] != null && answersCorrect[i].length == 1) {
					answersUser[i] = new String[] { request.getParameter("answer" + i) };
				} else {
					answersUser[i] = request.getParameterValues("answer" + i);
				}
				session.setAttribute("elearning.answersUser", answersUser);
			}

			if (submitAction) {
				correctAnswerNumInt = getNoOfCorrectAnswer(questions, questionsDesc, answers, answersDesc, answersCorrect, answersUser);

				if ((correctAnswerNumInt > 0 && correctAnswerNumInt >= passGradeInt && !userBean.isAdmin())) {
					// save the result
					String startTime = (String) session.getAttribute("elearning.startTime");
					String enrollID = "";%>
					<%
					enrollID = EnrollmentDB.add(userBean, "education", eventID, null, "CIS", userID.toUpperCase(), DateTimeUtil.getCurrentDateTime(), null, startTime);	

					boolean correct = false;
					for (int i = 0; i < questionNumInt; i++) {
						for (int j = 0; j < answersUser[i].length; j++) {
							correct = false;
							// check whether it is correct
							for (int k = 0; !correct && k < answersCorrect[i].length; k++) {
								if (answersCorrect[i][k].equals(answersUser[i][j])) {
									correct = true;
								}
							}

							// set answer = -1 if empty answer
							if (answersUser[i][j] == null) {
								answersUser[i][j] = "-1";
							}

							// store user answer into db
								ELearning.addStaffResultAnswer(userBean, eventID, elearningID, enrollID, questions[i], answersUser[i][j], correct ? ConstantsVariable.ONE_VALUE : ConstantsVariable.ZERO_VALUE,userID.toUpperCase());
						}
					}
					// store user answer into db
						ELearning.addStaffResult(userBean, eventID, elearningID, enrollID, String.valueOf(correctAnswerNumInt),userID.toUpperCase());

%>
						<jsp:forward page="elearning_CIS.jsp">
							<jsp:param name="command" value="result"/>
							<jsp:param name="elearningID" value="<%=elearningID %>"/>
							<jsp:param name="eventID" value="<%=eventID %>"/>
							<jsp:param name="enrollID" value="<%=enrollID %>"/>
						</jsp:forward>
<%
				} else {
					// retry skip count if fail exam
					session.setAttribute("elearning.skipcount", eventID);

					// show result directly if not pass
					submitAction = false;
					resultAction = true;
				}
			} else {

				// allow move page if not finish
				if ("1".equals(moveTo)) {
					questionPointerInt += noOfQuestionPerPage;
				} else if ("-1".equals(moveTo)) {
					questionPointerInt -= noOfQuestionPerPage;
				}
			}
		} else if (!resultAction) {
			ArrayList record;
			// prepare question
				record = ELearning.get(elearningID);
				ReportableListObject row = null;
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				eventID = row.getValue(0);
				topic = row.getValue(1);
				topicZh = row.getValue(9);
				questionNum = row.getValue(2);
				passGrade = row.getValue(3);
				description = row.getValue(10);
				documentsNum = 0;
				try {
					documentsNum = Integer.parseInt(row.getValue(4));
					questionNumInt = Integer.parseInt(questionNum);
				} catch (Exception e) {}

				if (eventID.equals((String) session.getAttribute("elearning.skipcount")) || isDebug || isRealDebug) {
					duration = ConstantsVariable.THREE_VALUE;
				} else {
					duration = row.getValue(5);
				}

				swfFile = row.getValue(6);
				Locale locale = (Locale) session.getAttribute( Globals.LOCALE_KEY);
				if (row.getValue(7) != null && row.getValue(7).length() > 0
						&& (Locale.TRADITIONAL_CHINESE.equals(locale)
						|| Locale.SIMPLIFIED_CHINESE.equals(locale))) {
					// use chinese version
					swfFile = row.getValue(7);
				}

				// get video paths
				ArrayList record2 = ELearning.getVideoList(elearningID);
				ReportableListObject row2 = null;
				String swffileLang = null;
				String videoPath = null;
				for (int i = 0; i < record2.size(); i++) {
					row2 = (ReportableListObject) record2.get(i);
					swffileLang = row2.getValue(1);
					videoPath = row2.getValue(2);
					if ("e".equals(swffileLang)) {
						videoPathsEng.add(videoPath);
					} else if ("z".equals(swffileLang)) {
						videoPathsTChi.add(videoPath);
					}
				}
				if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {
					videoPaths = videoPathsTChi;
				} else {
					videoPaths = videoPathsEng;
				}

				// get number of doc and video
				documentsNum = ELearning.getELearningDocVideoNum(elearningID, swffileLang);
				hasDocument = documentsNum > 0;

				// store in session
				session.setAttribute("elearning.eventID", eventID);
				session.setAttribute("elearning.topic", topic);
				session.setAttribute("elearning.topicZh", topicZh);
				session.setAttribute("elearning.questionNum", questionNum);
				session.setAttribute("elearning.passGrade", passGrade);
				session.setAttribute("elearning.correctAnswerNum", ConstantsVariable.ZERO_VALUE);
				session.setAttribute("elearning.hasDocument", hasDocument?ConstantsVariable.ONE_VALUE:ConstantsVariable.ZERO_VALUE);
				session.setAttribute("elearning.description", description);

				record = ELearning.getAllQuestions(elearningID);
				if (record.size() > 0) {
					boolean correctAnswer = false;
					Random random = new Random();

					HashMap questionsDescHashMap = new HashMap();
					HashMap answersHashMap = new HashMap();
					HashMap answersDescHashMap = new HashMap();
					HashMap answersCorrectHashMap = new HashMap();
					Vector answersVector = null;
					Vector answersDescVector = null;

					String elearningQID = null;
					String elearningAID = null;

					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						elearningQID = row.getValue(0);
						elearningAID = row.getValue(2);
						correctAnswer = "1".equals(row.getValue(4));

						// store question id and description
						questionsDescHashMap.put(elearningQID, row.getValue(1));

						// store answer id and description
						if (answersHashMap.containsKey(elearningQID)) {
							answersVector = (Vector) answersHashMap.get(elearningQID);
							answersDescVector = (Vector) answersDescHashMap.get(elearningQID);
						} else {
							answersVector = new Vector();
							answersDescVector = new Vector();
						}
						answersVector.add(elearningAID);
						answersDescVector.add(row.getValue(3));
						answersHashMap.put(elearningQID, answersVector);
						answersDescHashMap.put(elearningQID, answersDescVector);

						// store correct answer
						if (correctAnswer) {
							if (answersCorrectHashMap.containsKey(elearningQID)) {
								answersVector = (Vector) answersCorrectHashMap.get(elearningQID);
							} else {
								answersVector = new Vector();
							}
							answersVector.add(elearningAID);
							answersCorrectHashMap.put(elearningQID, answersVector);
						}
					}

					// initial session space
					questionPointerInt = 0;
					int totalOfQuestion = answersHashMap.size();
					questions = new String[totalOfQuestion];
					questionsDesc = new String[totalOfQuestion];
					answers = new String[totalOfQuestion][0];
					answersDesc = new String[totalOfQuestion][0];
					answersCorrect = new String[totalOfQuestion][0];
					answersUser = new String[totalOfQuestion][0];

					for (Iterator i = answersHashMap.keySet().iterator(); i.hasNext(); ) {
						// store elearning id
						elearningQID = (String) i.next();
						questions[questionPointerInt] = elearningQID;
						questionsDesc[questionPointerInt] = (String) questionsDescHashMap.get(elearningQID);

						// store answer id and answer
						answersVector = (Vector) answersHashMap.get(elearningQID);
						answers[questionPointerInt] = (String[]) answersVector.toArray(new String[answersVector.size()]);
						answersVector = (Vector) answersDescHashMap.get(elearningQID);
						answersDesc[questionPointerInt] = (String[]) answersVector.toArray(new String[answersVector.size()]);

						// store elearning correct answer
						if (answersCorrectHashMap.containsKey(elearningQID)) {
							answersVector = (Vector) answersCorrectHashMap.get(elearningQID);
							answersCorrect[questionPointerInt] = (String[]) answersVector.toArray(new String[answersVector.size()]);
						}

						questionPointerInt++;
					}

					// try to make the random order questions
					int swapPointer1 = 0;
					int swapPointer2 = 0;
					String questionTemp = null;
					String questionDescTemp = null;
					String[] answersTemp = null;
					String[] answersDescTemp = null;
					String[] answersCorrectTemp = null;
					for (int i = 0; i < totalOfQuestion * 2; i++) {
						swapPointer1 = random.nextInt(totalOfQuestion);
						swapPointer2 = random.nextInt(totalOfQuestion);
						if (swapPointer1 != swapPointer2) {
							questionTemp = questions[swapPointer1];
							questionDescTemp = questionsDesc[swapPointer1];
							answersTemp = answers[swapPointer1];
							answersDescTemp = answersDesc[swapPointer1];
							answersCorrectTemp = answersCorrect[swapPointer1];

							questions[swapPointer1] = questions[swapPointer2];
							questionsDesc[swapPointer1] = questionsDesc[swapPointer2];
							answers[swapPointer1] = answers[swapPointer2];
							answersDesc[swapPointer1] = answersDesc[swapPointer2];
							answersCorrect[swapPointer1] = answersCorrect[swapPointer2];

							questions[swapPointer2] = questionTemp;
							questionsDesc[swapPointer2] = questionDescTemp;
							answers[swapPointer2] = answersTemp;
							answersDesc[swapPointer2] = answersDescTemp;
							answersCorrect[swapPointer2] = answersCorrectTemp;
						}
					}

					// initial empty answer
					for (int i = 0; i < totalOfQuestion; i++) {
//						if (isDebug || isRealDebug) {
//							answersUser[i] = answersCorrect[i];
//						} else {
							answersUser[i] = new String[] { "" };
//						}
					}

					// store everything in the session
					session.setAttribute("elearning.questions", questions);
					session.setAttribute("elearning.questionsDesc", questionsDesc);
					session.setAttribute("elearning.answers", answers);
					session.setAttribute("elearning.answersDesc", answersDesc);
					session.setAttribute("elearning.answersCorrect", answersCorrect);
					session.setAttribute("elearning.answersUser", answersUser);
					session.setAttribute("elearning.startTime", DateTimeUtil.getCurrentDateTime());
					session.setAttribute("elearning.skipcount", null);

					questionPointerInt = 0;
				}
			} else {
				closeAction = true;
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
} else {
	closeAction = true;
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
<style>
body, #indexWrapper, #mainFrame, #contentFrame, table{width:100%!important;}
</style>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/thickbox.css" />" media="screen" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/w3.hkah.css" />" media="screen" />
<body>
<%-- <%if (!isLMCCRM) {%>
<jsp:include page="../common/banner2.jsp"/>
<%} %> --%>
<div id="indexWrapper">
<div id="mainFrame">

<div id="contentFrame"  style=" height:700px">

<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="elearning_CIS.jsp" method="post">
<%if (resultAction) { %>
<table cellpadding="0" cellspacing="0"
	class="generaltable" border="0" style="background-color:#F9F3F7;">
	<tr class="smallText">
		<th align="center">&nbsp;</th>
		<th width="75%" align="center"><bean:message key="prompt.question" />/<bean:message key="prompt.answer" /></th>
		<th align="center">&nbsp;</th>
	</tr>
<%
	// fetch each question
	correctAnswerNumInt = 0;
	for (int i = 0; i < questionNumInt; i++) {
		// calculate correct no of question answered
		result = isCorrectAnswer(i, questions, questionsDesc, answers, answersDesc, answersCorrect, answersUser);
		if (((Boolean) result[0]).booleanValue()) {
			correctAnswerNumInt++;
		}
		out.println(result[1].toString());
	}
%>
</table>
<table width="100%" border="0" style="background-color:#F9F3F7;">
	<tr class="smallText">
		<td align="center"><b>
<%	if (correctAnswerNumInt > 0 && correctAnswerNumInt >= passGradeInt && !userBean.isAdmin()) { %>
			<font color="blue" size="+2">
<%	} else {%>
			<font color="red" size="+2">
<%	}%>
			<bean:message key="message.correctAnswer.total" arg0="<%=String.valueOf(correctAnswerNumInt) %>" /> out of <%=questionNum %></font><b></td>
	<tr>
	<tr class="smallText">
		<td align="center">&nbsp;</td>
	<tr>
<%	if (correctAnswerNumInt > 0 && correctAnswerNumInt >= passGradeInt && !userBean.isAdmin()) { %>
	<tr class="">
		<td align="center">
			<b>You have passed the test!</b>
		</td>
	<tr>
<%	} else {%>
	<tr class="smallText">
		<td align="center" colspan=3>
		<button onclick="movePage('-1');return false;"><bean:message key="message.test.fail" />!</button>
		</td>
	<tr>
<%	}
	// reset all the value
	session.setAttribute("topic", null);
	session.setAttribute("topicZh", null);
	session.setAttribute("questionNum", null);
	session.setAttribute("passGrade", null);
	session.setAttribute("correctAnswer", null);
	session.setAttribute("elearning.questions", null);
	session.setAttribute("elearning.answers", null);
	session.setAttribute("elearning.answersCorrect", null);
	session.setAttribute("elearning.answersUser", null);
	session.setAttribute("elearning.startTime", null);

	command = "";
	questionPointerInt = 0;
%>
</table>
<%} else if (testAction) {%>
<table width="100%" border="0">
	<tr >
		<td align="center" style="line-height: 1.6;"><%=description %></td>
	</tr>
</table>
<table style="background-color:#F9F3F7;">
	<tr class="w3-red">
		<th width="15%">&nbsp;</th>
		<th width="70%" align="center"><bean:message key="prompt.question" /></th>
		<th width="15%">&nbsp;</th>
	</tr>
<%
	// show new question
	try {
		boolean userAnswer = false;
		for (int i=questionPointerInt; i<questionPointerInt + noOfQuestionPerPage && i<questionNumInt; i++) {
			userAnswer = false;
%>
	<tr class="">
		<td align="right" valign="top" style="font-size: 15px; color: green;">Q<%=i + 1 %>)</td>
		<td  style="font-size: 15px; color: green;"><%=lineWrap(questionsDesc[i]) %></td>
	</tr>
	<tr class="">
		<td align="center">&nbsp;</td>
		<td height="">
			<table border="0">
<%
			// fetch each answer
			for (int j=0; j<answers[i].length; j++) {
				// whether user select this answer
				userAnswer = true;

				// fetch user answer
				if (answersUser[i] != null) {
					for (int k=0; k<answersUser[i].length && userAnswer; k++) {
						if (!answers[i][j].equals(answersUser[i][k])) {
							userAnswer = false;
						}
					}
				}
%>
				<tr>
					<td width="5%">
						&nbsp;<span id=result<%=answers[i][j] %>>
<%
				if ((isDebug || isRealDebug) && answersCorrect[questionPointerInt][0].equals(answers[i][j])) {

%>
					<img src="../images/tick_amber_small.gif">
<%
				}
%>
						</span>
					</td>
					<td width="10%">
						<%=alpha[j] %>)&nbsp;
						<input type="<%if (answersCorrect[i].length == 1) {%>radio<%} else { %>checkbox<%} %>" name="answer<%=i %>" value="<%=answers[i][j] %>"<%=(userAnswer || (isRealDebug && answersCorrect[questionPointerInt][0].equals(answers[i][j])))?" checked":""%> >&nbsp;
					</td>
					<td width="90%">
						<%=answersDesc[i][j] %>
					</td>
				</tr>
<%
			} // answer
%>
		</table>
		</td>
		<td align="center">&nbsp;</td>
	</tr>
<%		} //question
	} catch (Exception e) {
		e.printStackTrace();
	}
%>			

</table>
<table width="100%" border="0" style="background-color:#F9F3F7;">
	<tr>
		<td align="center"><%
	if (questionPointerInt > 0) {
%><button onclick="movePage('-1');return false;"><bean:message key='<%=ConstantsServerSide.isTWAH() ? "button.question.previous.twah" : "button.question.previous" %>' /></button><%
	}
	if (questionPointerInt + noOfQuestionPerPage < questionNumInt) {
%><button onclick="movePage('1');return false;"><bean:message key="button.question.next" /></button><%
	} else {
%><button onclick="completePage();return false;" class="w3-button w3-indigo"><bean:message key="button.question.submit" /></button><%
	}
%>
		</td>
	</tr>
</table>
<%} else {%>
<%-- <% if(!"0".equals(questionNum)){ %>
<table width="100%" border="0">
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td align="center"><span id="quizMsg"><%if (!hasDocument) { %><button name="startQuiz" onclick="quiz();"><bean:message key='<%=ConstantsServerSide.isTWAH() ? "button.test.twah" : "button.test" %>' /></button><%} %></span></td>
	</tr>
</table>
<% } %> --%>
<%
	command = "test";
%>
<%} %>
<input type="hidden" name="command" value="<%=command %>">
<input type="hidden" name="elearningID" value="<%=elearningID %>">
<input type="hidden" name="questionPointer" value="<%=questionPointerInt %>">
<input type="hidden" name="from" value="<%=from %>">
<input type="hidden" name="moveTo">
<input type="hidden" name="userID" Value="<%=userID%>">
</form>
<script language="javascript">
<!--//
	// handle start quiz button
<%	if (!testAction && !submitAction && !resultAction && hasDocument) { %>
	var secs = <%=duration %>;
	var wait = secs * 1000;

	function update(num) {
<%
	String readThroughMessageKey = null;
	if (ConstantsServerSide.isTWAH()) {
		readThroughMessageKey = "message.read.through.twah";
	} else {
		readThroughMessageKey = "message.read.through";
	}	%>
		if (num == (wait/1000)) {
			document.getElementById("quizMsg").innerHTML = '<bean:message key="<%=readThroughMessageKey %>" />';
		} else {
			printnr = ((wait / 1000) - num).toString();
			printnrStr = "";
			for (i = 0; i < printnr.length; i++) {
				printnrStr += '<img src="../images/count/' + printnr.substring(i, i + 1) + '.png">';
			}
			document.getElementById("quizMsg").innerHTML = '<bean:message key="<%=readThroughMessageKey %>" /><br/>' + printnrStr + ' <bean:message key="label.seconds" />';
		}
	}

	function timer() {
		document.getElementById("quizMsg").innerHTML = '<button name="startQuiz" onclick="quiz();"><bean:message key='<%=ConstantsServerSide.isTWAH() ? "button.test.twah" : "button.test" %>' /></button>';
		window.setTimeout("quiz()", 3000);
	}

	function startQuiz() {
		for(i = 1; i <= secs; i++) {
			window.setTimeout("update(" + i + ")", i * 1000);
		}
		window.setTimeout("timer()", wait);
	}

	startQuiz();

<%	} %>

	// handle page event
	function movePage(value1) {
		document.form1.action= "elearning_CIS.jsp";
		document.form1.moveTo.value = value1;
		document.form1.command.value = "test";
		document.form1.submit();
	}

	function completePage() {
		document.form1.action= "elearning_CIS.jsp";
		document.form1.command.value = "submit";
		document.form1.submit();
	}

	function quiz() {
		document.form1.action= "elearning_CIS.jsp";
		document.form1.submit();
	}


//-->
</script>
</div>

</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>