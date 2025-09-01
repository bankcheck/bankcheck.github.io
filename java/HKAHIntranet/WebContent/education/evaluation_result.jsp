<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String elearningID = request.getParameter("elearningID");
String eventID = request.getParameter("eventID");
String enrollID = request.getParameter("enrollID");
String userID = request.getParameter("userID");

ArrayList evaluationQuestion = null;
ArrayList staffEvaluationAnswer = null;

boolean isLMCCRM = false;
if(userBean.getUserName() != null && CRMClientDB.getClientID(userBean.getUserName())!= null){
		isLMCCRM= true;		
}

try {
	evaluationQuestion = EvaluationDB.getAllQuestions("1");
	if(isLMCCRM){
		staffEvaluationAnswer = EvaluationDB.getStaffResultAnswer(eventID, elearningID, "1", enrollID, "guest", userID);
			
	}else{
		staffEvaluationAnswer = EvaluationDB.getStaffResultAnswer(eventID, elearningID, "1", enrollID, "staff", userID);
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
<body>
<div id=indexWrapper>
<div id=mainFrame>
<div id=Frame>
<table width="100%" border="0">
<tr class="smallText">
	<td class="infoTitle" colspan="3">Evaluation Result</td>
</tr>
<tr><td width="10%">&nbsp;</td><td>
<table width="100%" border="0">
<%
	boolean isAppendColumnHeading = true;
	if (evaluationQuestion.size() > 0) {
		ReportableListObject row = null;
		for (int i = 0; i < evaluationQuestion.size(); i++) {
			row = (ReportableListObject) evaluationQuestion.get(i);
			
			// get answer
			ReportableListObject row2 = null;
			String questionID= null; 
			String answer = null;
			boolean found = false;
			for (int j = 0; j < staffEvaluationAnswer.size() && !found; j++) {
				row2 = (ReportableListObject) staffEvaluationAnswer.get(j);
				questionID = row2.getValue(1);
				if (questionID != null && questionID.equals(row.getValue(0))) {
					found = true;
					answer = row2.getValue(2);
				}
			}
			
			if (ConstantsVariable.YES_VALUE.equals(row.getValue(2))) {
%>
	<tr class="smallText">
		<td class="infoData"><%=row.getValue(1) == null ? "" : row.getValue(1) %></td>
		<td class="infoData" colspan="6"><%=(row2 == null || row2.getValue(3) == null)?"":row2.getValue(3) %></td>
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
		<td class="infoData" width="10%" style="text-align: center"><%="1".equals(answer) ? "o" : "" %></td>
		<td class="infoData" width="10%" style="text-align: center"><%="2".equals(answer) ? "o" : "" %></td>
		<td class="infoData" width="10%" style="text-align: center"><%="3".equals(answer) ? "o" : "" %></td>
		<td class="infoData" width="10%" style="text-align: center"><%="4".equals(answer) ? "o" : "" %></td>
		<td class="infoData" width="10%" style="text-align: center"><%="5".equals(answer) ? "o" : "" %></td>
		<td class="infoData" width="10%" style="text-align: center"><%="6".equals(answer) ? "o" : "" %></td>
	</tr>
<%
			}
		}
	} %>
</table>
</td><td width="10%">&nbsp;</td></tr>
</table>
</div>

</div></div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>