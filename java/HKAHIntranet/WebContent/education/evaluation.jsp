<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String category = "title.education";
String command = request.getParameter("command");
String step = request.getParameter("step");
String elearningID = request.getParameter("elearningID");
String eventID = request.getParameter("eventID");
String enrollID = request.getParameter("enrollID");
String answer1 = request.getParameter("answer1");
String answer2 = request.getParameter("answer2");
String answer3 = request.getParameter("answer3");
String answer4 = request.getParameter("answer4");
String userID = request.getParameter("userID");
// BUG: cannot read unicode characters for "comment"
// 2010-08-10 by Ricky Leung
String comment = TextUtil.parseStrUTF8(request.getParameter("comment"));

boolean createAction = true;
boolean closeAction = false;

String message = "";
String errorMessage = "";

boolean isLMCCRM = false;
if(userBean.getUserName() != null && CRMClientDB.getClientID(userBean.getUserName())!= null){
		isLMCCRM= true;
}

try {
	if ("1".equals(step)) {
		if (createAction) {
			if(isLMCCRM){
				// store user answer into db
				EvaluationDB.addCRMResultAnswer(userBean, eventID, elearningID, "1", enrollID, "1", answer1, null);
				EvaluationDB.addCRMResultAnswer(userBean, eventID, elearningID, "1", enrollID, "2", answer2, null);
				EvaluationDB.addCRMResultAnswer(userBean, eventID, elearningID, "1", enrollID, "3", answer3, null);
				EvaluationDB.addCRMResultAnswer(userBean, eventID, elearningID, "1", enrollID, "4", answer4, null);
				// free text comment
				EvaluationDB.addCRMResultAnswer(userBean, eventID, elearningID, "1", enrollID, "5", "1", comment);

			}else{
				// store user answer into db
				EvaluationDB.addStaffResultAnswer(userBean, eventID, elearningID, "1", enrollID, "1", answer1, null);
				EvaluationDB.addStaffResultAnswer(userBean, eventID, elearningID, "1", enrollID, "2", answer2, null);
				EvaluationDB.addStaffResultAnswer(userBean, eventID, elearningID, "1", enrollID, "3", answer3, null);
				EvaluationDB.addStaffResultAnswer(userBean, eventID, elearningID, "1", enrollID, "4", answer4, null);
				// free text comment
				EvaluationDB.addStaffResultAnswer(userBean, eventID, elearningID, "1", enrollID, "5", "1", comment);
			}

%>
<jsp:forward page="elearning_test.jsp">
	<jsp:param name="command" value="result"/>
	<jsp:param name="elearningID" value="<%=elearningID %>"/>
	<jsp:param name="eventID" value="<%=eventID %>"/>
	<jsp:param name="enrollID" value="<%=enrollID %>"/>
	<jsp:param name="message" value="Thank you for your evaluation."/>

</jsp:forward>
<%			createAction = false;
		}
	} else if (createAction) {
		comment = "";
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
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="On-line Program Evaluation Form" />
	<jsp:param name="category" value="<%=category %>" />
	<jsp:param name="translate" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<table width="100%" border="0">
<tr><td width="10%">&nbsp;</td><td width="80%">
<form name="form1" action="evaluation.jsp" onsubmit="return submitAction();">
<%
	ArrayList record = EvaluationDB.getAllQuestions("1");
	boolean isAppendColumnHeading = true;
	if (record.size() > 0) {
%>
<P>Please rate today's on-line program on each of the following attributes by putting a check</P>
<P>請就下列各項對今日網上課程作出評價，請在合適位置點一下。</P>
<P/>

<table width="100%" border="0">
<%
		ReportableListObject row = null;
		String questionID = null;
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);

			// special handling for free text questions comments
			if (ConstantsVariable.YES_VALUE.equals(row.getValue(2))) {
%>
	<tr class="smallText">
		<td colspan="7"><%=row.getValue(1) %></td>
	</tr>
	<tr class="smallText">
		<td colspan="7">
<%				if (createAction) { %>
			<textarea name="comment" rows="6" cols="100"><%=comment==null?"":comment %></textarea>
<%				} else { %>
			<%=comment==null?"":comment %>
<%				} %>
		</td>
	</tr>
<%				isAppendColumnHeading = true;
			} else { %>
<%				if (isAppendColumnHeading) { %>
	<tr class="smallText">
		<td class="infoCenterLabel">ATTRIBUTES 特質</td>
		<td class="infoCenterLabel" colspan="6">SCALE 等級</td>
	</tr>
	<tr class="smallText">
		<td class="infoCenterLabel">After completing the on-line program<br><br>當完成課程後</td>
		<td class="infoCenterLabel">Strongly<br>Disagree<br>完全不同意</td>
		<td class="infoCenterLabel">Disagree<br><br>不同意</td>
		<td class="infoCenterLabel">Neutral<br><br>中立</td>
		<td class="infoCenterLabel">Agree<br><br>同意</td>
		<td class="infoCenterLabel">Strongly<br>Agree<br>完全同意</td>
		<td class="infoCenterLabel">N/A<br><br>不適用</td>
	</tr>
<%
					isAppendColumnHeading = false;
				} %>
	<tr class="smallText">
		<td class="infoData"><b><%=row.getValue(1) %></b></td>
<%				if (createAction) { %>
		<td class="infoData" width="10%"><input type="radio" name="answer<%=row.getValue(0) %>" value="1"></td>
		<td class="infoData" width="10%"><input type="radio" name="answer<%=row.getValue(0) %>" value="2"></td>
		<td class="infoData" width="10%"><input type="radio" name="answer<%=row.getValue(0) %>" value="3"></td>
		<td class="infoData" width="10%"><input type="radio" name="answer<%=row.getValue(0) %>" value="4"></td>
		<td class="infoData" width="10%"><input type="radio" name="answer<%=row.getValue(0) %>" value="5"></td>
		<td class="infoData" width="10%"><input type="radio" name="answer<%=row.getValue(0) %>" value="6"></td>
<%				} %>
	</tr>
<%
			} %>

<%		} %>
</table>
<%	} else { %>
<P>Your test is completed. Please press "<bean:message key="button.submit" />".</P>
<P>測驗已經完成，請按「<bean:message key="button.submit" />」。</P>
<P/>

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
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="elearningID" value="<%=elearningID %>"/>
<input type="hidden" name="eventID" value="<%=eventID %>"/>
<input type="hidden" name="enrollID" value="<%=enrollID %>"/>
</form>
</td><td width="10%">&nbsp;</td></tr>
</table>
<script language="javascript">
<!--
	function submitAction() {
		document.form1.command.value = "create";
		document.form1.step.value = "1";
		document.form1.submit();
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>