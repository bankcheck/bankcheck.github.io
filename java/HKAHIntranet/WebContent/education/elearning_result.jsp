<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
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
%>
<%
String category = "title.education";
String eventID = request.getParameter("eventID");
String elearningID = request.getParameter("elearningID");
String enrollID = request.getParameter("enrollID");
String staffID = request.getParameter("staffID");

String module = request.getParameter("module");
boolean isLMCCRM = false;
if(module != null && module.equals("lmc.crm")){
	isLMCCRM = true;
}

String staffName = null;
String deptDesc = null;
String topic = null;
String questionNumPerTest = null;
String passGrade = null;
String correctAnswerNum = null;

String message = "";
String errorMessage = "";

boolean closeAction = false;

try {
	if (eventID != null && eventID.length() > 0) {
		ArrayList record;
		if(isLMCCRM){
			record = ELearning.getCRMResult(eventID, elearningID, enrollID, "guest", staffID);

		}else{
			record = ELearning.getStaffResult(eventID, elearningID, enrollID, "staff", staffID);
		}

		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			staffName = row.getValue(0);
			deptDesc = row.getValue(1);
			topic = row.getValue(2);
			questionNumPerTest = row.getValue(3);
			passGrade = row.getValue(4);
			correctAnswerNum = row.getValue(5);

		} else {
			closeAction = true;
		}
	} else {
		closeAction = true;
	}
} catch (Exception e) {
	e.printStackTrace();
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
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/thickbox.css" />" media="screen" />
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%if(isLMCCRM){%>
	<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Online Course Test Result" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<%}else{%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="prompt.eLessonResult" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<%} %>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0" width="750">
	<tr class="smallText">
		<%if(isLMCCRM){%>
			<td class="infoLabel" width="30%">Client Name</td>
			<td class="infoData" width="70%"><%=staffName %></td>
		<%}else{%>
			<td class="infoLabel" width="30%"><bean:message key="prompt.staffName" /></td>
			<td class="infoData" width="70%"><%=staffName %> (<%=deptDesc %>)</td>
		<%} %>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.topic" /></td>
		<td class="infoData" width="70%"><%=topic %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.passGrade" /></td>
		<td class="infoData" width="70%"><%=passGrade %>/<%=questionNumPerTest %></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="0"
	class="generaltable" border="0">
	<tr class="smallText">
		<th align="center">&nbsp;</th>
		<th width="75%" align="center"><bean:message key="prompt.question" />/<bean:message key="prompt.answer" /></th>
		<th align="center">&nbsp;</th>
	</tr>
<%
	int questionPointer = 0;
	int answerPointer = 0;
	ArrayList record;
	if(isLMCCRM){
		record = ELearning.getStaffResultAnswer(eventID, elearningID, enrollID, "guest", staffID);
	}else{
		record = ELearning.getStaffResultAnswer(eventID, elearningID, enrollID, "staff", staffID);
	}
	ArrayList record2 = null;
	ReportableListObject row = null;
	ReportableListObject row2 = null;
	String prev_elearningQID = null;
	String elearningQID = null;
	String elearningAID = null;
	String questionDesc = null;
	String answersDesc = null;
	boolean correctAnswer = false;

	// fetch each question
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		elearningQID = row.getValue(1);
		elearningAID = row.getValue(2);
		correctAnswer = "1".equals(row.getValue(3));

		if (!elearningQID.equals(prev_elearningQID)) {
			// get question description
			record2 = ELearning.getQuestion(elearningID, elearningQID);
			if (record2.size() == 1) {
				row2 = (ReportableListObject) record2.get(0);
				questionDesc = row2.getValue(4);
			} else {
				questionDesc = "";
			}
			prev_elearningQID = elearningQID;
			questionPointer++;
			answerPointer = 0;

%>
	<tr class="sessionColEven">
		<td align="center" valign="top">Q<%=questionPointer %></td>
		<td width="90%"><%=lineWrap(questionDesc) %></td>
		<td align="center">&nbsp;</td>
	</tr>
<%
		} else {
			answerPointer++;
		}

		// get answer description
		record2 = ELearning.getAnswer(elearningID, elearningQID, elearningAID);
		if (record2.size() == 1) {
			row2 = (ReportableListObject) record2.get(0);
			answersDesc = row2.getValue(1);
		} else {
			answersDesc = "";
		}
%>
	<tr class="sessionColOdd">
		<td align="center">&nbsp;</td>
		<td width="90%"><%=alpha[answerPointer] %> ) <%=answersDesc %><%if (correctAnswer) {%><img src="../images/tick_green_small.gif"><%} else { %><img src="../images/cross_red_small.gif"><%} %></td>
		<td align="center">&nbsp;</td>
	</tr>
<%
	}
%>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><b><bean:message key="message.correctAnswer.total" arg0="<%=correctAnswerNum %>" /><b></td>
	<tr>
	<tr class="smallText">
		<td align="center">&nbsp;</td>
	<tr>
</table>

<!-- evaluation result -->
<jsp:include page="evaluation_result.jsp" flush="false">
	<jsp:param name="elearningID" value="<%=elearningID %>"/>
	<jsp:param name="eventID" value="<%=eventID %>"/>
	<jsp:param name="enrollID" value="<%=enrollID %>"/>
	<jsp:param name="userID" value="<%=staffID %>"/>
</jsp:include>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>