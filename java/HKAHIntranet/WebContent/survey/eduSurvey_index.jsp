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
final String EVALUATION_ID = "5";



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
			
			for(int i=0;i<record2.size();i++){
				String[] answers = null;
				String answerFreeText = null;
				ReportableListObject row = null;
				row = (ReportableListObject) record2.get(i);
				if ("Y".equals(row.getFields2())) {
					EvaluationDB.addStaffResultAnswer(userBean,eventID,elearningID,EVALUATION_ID,enrollID,row.getValue(0),"-1",request.getParameter("question" + (i + 1)+"_text"));
				}else{
					answers =  (String[])request.getParameterValues("question" + (i + 1));
					for(int k=0;k<answers.length;k++){
						if("9".equals(answers[k])){
							if(request.getParameter("question" + (i + 1)+"_text")!= null){
								answerFreeText = request.getParameter("question" + (i + 1)+"_text");
							}else{
								answerFreeText = null;
							}
								EvaluationDB.addStaffResultAnswer(userBean,eventID,elearningID,EVALUATION_ID,enrollID,row.getValue(0),answers[k],answerFreeText);							

						 }else{
							 answerFreeText = null;
							 EvaluationDB.addStaffResultAnswer(userBean,eventID,elearningID,EVALUATION_ID,enrollID,row.getValue(0),answers[k],answerFreeText);							

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
<%@ page language="java" contentType="text/html; charset=big5" %>
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
	<jsp:param name="pageTitle" value="Staff Education Needs Assessment Yearly Survey"/>
	<jsp:param name="mustLogin" value="Y" />
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
	<td colspan="2" style="font-size: 18px; height: 25px;text-align: center;font-weight: bold;"><u>Staff Education Needs Assessment Yearly Survey 2011</u><br>年度教育需求評估意見調查</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="80%">
			<P class="intro-header"></P>
			<P class="survey-content" style="font-size:15px;">To ensure continuing improvement of our in-house Educational Programs at HKAH, 
									we would like your input on your learning needs. 
									The result of this survey will set directions for the staff education programs for the year 2010-2011<br>
									為確保本院內部教育方案持續改善，我們熱切期望得到您對學習/課程的意見。
									您們寶貴的意見將有助我們在策劃2011-2012年度教育課程時訂下明確的方向</P>
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td>
		<form name="form1" action="eduSurvey_index.jsp" method="post" onsubmit="return submitAction();">
		<%if(userBean.getStaffID() != null){ %>
		<table>
			<tr>
				<td>Department 部門: <%=userBean.getDeptDesc() %></td>
			</tr>
			<tr>
				<td>Your Post 職位: <%=StaffDB.getPosition(userBean.getStaffID()) %></td>
			</tr>
		</table>
		<%} %>
<%
	ArrayList record = EvaluationDB.getAllQuestions(EVALUATION_ID);
	String checkedAttr = "checked=\"checked\"";
	
	if (record.size() > 0) {
		ReportableListObject row = null;%>
		<table class="part-header-container">
			<%for(int i=0;i<record.size();i++){ 
				row = (ReportableListObject) record.get(i);
			%>					
				<tr><td><%=row.getValue(1) %></td></tr>
				 <%if("Y".equals(row.getValue(2))){ %>
				 			<tr class="infoData">
				 			<td><textarea name="question<%=row.getValue(0)%>_text" rows="2" cols="150"></textarea></td>
				 			</tr>
				 <%}else{ %>
					<%ArrayList recordAns = EvaluationDB.getAllAnswer(EVALUATION_ID,row.getValue(0)); %>
					<%for(int j=0;j<recordAns.size();j++){ 
						ReportableListObject row1 = (ReportableListObject)recordAns.get(j);
					%>	
							<tr class="infoData"><td>
							<input type="checkbox" name="question<%=row.getValue(0)%>" value="<%=row1.getValue(0)%>"/>
							<%=row1.getValue(1) %>
							<%if("Y".equals(row1.getValue(2))){ %>
							<textarea name="question<%=row.getValue(0)%>_text" rows="2" cols="150" onfocus="selectCheckBox('question<%=row.getValue(0)%>_text');return false;"></textarea>
							<%} %>
							</td></tr>
					   <%} %>
				  <%} %>
			<%} %>
		<%} %>		
		</table>
<%	
} 
%>


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
			top.frames['bigcontent'].location.href = '..index.jsp';
		} else {
			window.location.href = '../index.jsp?category=home';
		}
	}
	
	function selectCheckBox(textboxName){
		$("textarea[name="+textboxName+"]").prev().attr('checked',true);
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>

</html:html>