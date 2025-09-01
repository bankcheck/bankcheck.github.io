<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>

<%!
public class ClientAnswer{
	String questionaireID;
	String questionaireQID;
	String questionaireAID;
	String questionaireCAID;
	public ClientAnswer(String questionaireID,String questionaireQID,String questionaireAID,String questionaireCAID){
		this.questionaireID = questionaireID;
		this.questionaireQID = questionaireQID;
		this.questionaireAID = questionaireAID;
		this.questionaireCAID = questionaireCAID;
	}
}

public static ArrayList getClientAnswer(String questionaireCAID){
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT CRM_QUESTIONAIRE_ID,CRM_QUESTIONAIRE_QID,CRM_QUESTIONAIRE_AID,CRM_QUESTIONAIRE_CAID ");
	sqlStr.append("FROM   CRM_QUESTIONAIRE_CLIENT_ANSWER ");
	sqlStr.append("WHERE CRM_ENABLED = '1' ");
	sqlStr.append("AND   CRM_QUESTIONAIRE_CAID = '"+questionaireCAID+"' ");
	sqlStr.append("ORDER BY CRM_QUESTIONAIRE_ID , CRM_QUESTIONAIRE_QID "); 
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static boolean insertClientAnswer(UserBean userBean,String questionaireID,String questionaireQID,String questionaireAID,String questionaireCAID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("INSERT INTO CRM_QUESTIONAIRE_CLIENT_ANSWER ");
	sqlStr.append("(CRM_SITE_CODE,CRM_QUESTIONAIRE_ID,CRM_QUESTIONAIRE_QID,CRM_QUESTIONAIRE_AID,CRM_QUESTIONAIRE_CAID, ");
	sqlStr.append("CRM_CLIENT_ID,CRM_CREATED_USER,CRM_MODIFIED_USER)  ");
	sqlStr.append("VALUES ");	
	String clientId = CRMClientDB.getClientID(userBean.getUserName());
	sqlStr.append("('"+ConstantsServerSide.SITE_CODE+"',"+questionaireID+","+questionaireQID+","+questionaireAID+","+questionaireCAID+","+(clientId == null ? "null" : "'" + clientId + "'")+",'"+userBean.getUserName()+"','"+userBean.getUserName()+"')  ");
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
	
}

private static String getNextClientAnswerID() {
	String questionaireCAID = null;

	ArrayList result = UtilDBWeb.getReportableList(
			"SELECT MAX(CRM_QUESTIONAIRE_CAID) + 1 FROM CRM_QUESTIONAIRE_CLIENT_ANSWER");
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		questionaireCAID = reportableListObject.getValue(0);

		// set 1 for initial
		if (questionaireCAID == null || questionaireCAID.length() == 0) return "1";
	}
	return questionaireCAID;
}

private ArrayList getAnswer(String questionaireID,String questionaireQID) {	
	StringBuffer sqlStr = new StringBuffer();	
	sqlStr.append("SELECT CRM_QUESTIONAIRE_ID,CRM_QUESTIONAIRE_QID,CRM_QUESTIONAIRE_AID,CRM_ANSWER ");
	sqlStr.append("FROM CRM_QUESTIONAIRE_ANSWER ");	
	sqlStr.append("WHERE CRM_QUESTIONAIRE_ID='"+questionaireID+"' ");	
	sqlStr.append("AND   CRM_QUESTIONAIRE_QID='"+questionaireQID+"' ");
	sqlStr.append("AND  CRM_ENABLED='1' ");
	sqlStr.append("ORDER BY CRM_QUESTIONAIRE_AID ");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}


private ArrayList getQuestion(String questionaireID) {	
	StringBuffer sqlStr = new StringBuffer();	
	sqlStr.append("SELECT  CRM_QUESTIONAIRE_ID,CRM_QUESTIONAIRE_QID,CRM_QUESTION ");
	sqlStr.append("FROM    CRM_QUESTIONAIRE_QUESTION ");	
	sqlStr.append("WHERE   CRM_ENABLED = '1' ");	
	sqlStr.append("AND     CRM_QUESTIONAIRE_ID = "+questionaireID+" ");
	sqlStr.append("ORDER   BY CRM_QUESTIONAIRE_QID ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getQuestionTopic() {	
	StringBuffer sqlStr = new StringBuffer();	
	sqlStr.append("SELECT  CRM_QUESTIONAIRE_ID,CRM_QUESTIONAIRE_DESC ");
	sqlStr.append("FROM    CRM_QUESTIONAIRE ");	
	sqlStr.append("WHERE   CRM_ENABLED = '1' ");	
	sqlStr.append("ORDER   BY CRM_QUESTIONAIRE_ID");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getCRMClientDoneWeekTest(UserBean userBean,String thisWeekStartOfDate,String thisWeekEndOfDate) {	
	StringBuffer sqlStr = new StringBuffer();	
	sqlStr.append("SELECT * ");
	sqlStr.append("FROM CRM_QUESTIONAIRE_CLIENT_ANSWER ");	
	sqlStr.append("WHERE CRM_CREATED_DATE BETWEEN TO_DATE('"+thisWeekStartOfDate+" 00:00:00' ,'dd/mm/yyyy HH24:MI:SS')  ");	
	sqlStr.append("AND TO_DATE('"+thisWeekEndOfDate+" 23:59:59' , 'dd/mm/yyyy HH24:MI:SS') ");
	sqlStr.append("AND CRM_CLIENT_ID = '"+CRMClientDB.getClientID(userBean.getUserName())+"' ");	
	sqlStr.append("AND CRM_ENABLED = '1' ");
	//System.out.println(sqlStr.toString());
	return  UtilDBWeb.getReportableList(sqlStr.toString());
}

%>
<%
UserBean userBean = new UserBean(request);
SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");

String questionaireCAID = request.getParameter("questionaireCAID"); 
String command = request.getParameter("command");
String clientAnswerDate = request.getParameter("clientAnswerDate");

String message = "";
String errorMessage = "";

Calendar thisWeekStartOfDate = Calendar.getInstance();
thisWeekStartOfDate.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);

Calendar thisWeekEndOfDate = Calendar.getInstance();
thisWeekEndOfDate.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);
boolean clientWeeklyTestDone = false;

if(!"view".equals(command)){
	ArrayList testWeekRecord = getCRMClientDoneWeekTest(userBean,df.format(thisWeekStartOfDate.getTime()),df.format(thisWeekEndOfDate.getTime()));

	if(testWeekRecord.size()>0){
		clientWeeklyTestDone = true;
	}
}

if("view".equals(command)||clientWeeklyTestDone == false){
	if("submit".equals(command)){	
		Enumeration paramNames = request.getParameterNames();
		questionaireCAID = getNextClientAnswerID();	
		boolean insertAnswerSuccess = false;
		while(paramNames.hasMoreElements())
	    {
	        String paramName = (String)paramNames.nextElement();     
	        if(!"command".equals(paramName)){
		        String[] paramValues = request.getParameterValues(paramName);
		        String questionaireID = paramName.split(",")[0];
		        String questionaireQID = paramName.split(",")[1];
		        String questionaireAID = paramValues[0];
		        
		        insertAnswerSuccess = insertClientAnswer(userBean,questionaireID,questionaireQID,questionaireAID,questionaireCAID);
		        
	        }
	    }
		if(insertAnswerSuccess){
			message = "提交成功.";
			command = "view";
		}else{
			errorMessage = "提交失敗.";	
		}
	}
	
	ArrayList<ClientAnswer> listOfClientAnswer = new ArrayList<ClientAnswer>();
	if("view".equals(command)){	
		if(questionaireCAID != null && questionaireCAID.length() > 0){
			ArrayList clientAnsweRecord= getClientAnswer(questionaireCAID);		
			if (clientAnsweRecord.size() > 0) {
				for(int i = 0;i<clientAnsweRecord.size();i++){
					ReportableListObject row = (ReportableListObject) clientAnsweRecord.get(i);
					String tempID = row.getValue(0);
					String tempQID = row.getValue(1);
					String tempAID = row.getValue(2);
					String tempCAID = row.getValue(3);
					
					ClientAnswer temp = new ClientAnswer(tempID,tempQID,tempAID,tempCAID);
					listOfClientAnswer.add(temp);
				}
			}
		}	
	}
	
	boolean viewAction= false;
	if("view".equals(command)){
		viewAction = true;
	}
	
	Calendar clientDate = Calendar.getInstance();
	if(viewAction && clientAnswerDate!=null && clientAnswerDate.length()>0){
		String[] date = clientAnswerDate.split(" ");
		String year = date[0].split("-")[0];
		String month = date[0].split("-")[1];
		String day = date[0].split("-")[2];
		clientDate.set(Integer.parseInt(year), Integer.parseInt(month)-1, Integer.parseInt(day));	
	}
	//must have
	System.out.println(df.format(clientDate.getTime()));
	
	Calendar startOfWeekDate = (Calendar)clientDate.clone();
	startOfWeekDate.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
	
	Calendar endOfWeekDate = (Calendar)clientDate.clone();
	endOfWeekDate.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);
	


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

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<style>
.rowEven{
			background-color: #F5F1EE!important;		
}
</style>
<jsp:include page="../../common/header.jsp"/>
<body>
<center>
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td align="left"><img src="../../images/logo_hkah.gif" border="0" width="261" height="113" /></td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td><font color="blue"><%=message %></font></td>
</tr>
<tr>
	<td><font color="red"><%=errorMessage %></font></td>
</tr>
<tr>
	<td align="center">
		<b class="b1"></b><b class="b2"></b><b class="b3"></b><b class="b4"></b>
		<div class="contentb">
		<form name="form1" action="newstart_test.jsp" method="post">
			<table width="690" border="1" cellpadding="0" cellspacing="0" style="background-color:white;">
			
			<tr>
			<td>
<%
			ArrayList questionTopicRecord = getQuestionTopic();
			if (questionTopicRecord.size() > 0){ 
				for (int i = 0; i < questionTopicRecord.size(); i++) {
					ReportableListObject questionTopicRow = (ReportableListObject) questionTopicRecord.get(i);
					String topic = questionTopicRow.getValue(1);
					String questionaireID = questionTopicRow.getValue(0);
					ArrayList questionRecord = getQuestion(questionaireID);					
					String rowSpan = ""; 
					if(questionRecord.size()>0){						
						rowSpan = Integer.toString(questionRecord.size());
					}
%>	
				<table width="100%" border="0" <%=(i%2==0?"":"class=\"rowEven\"") %>>
<%
				if(i==0){
%>
					<tr style="background-color:#F7ECEC">
					<td style="font-weight:bold;padding:10px;" colspan="4">由 <%=df.format(startOfWeekDate.getTime())%> 至 <%=df.format(endOfWeekDate.getTime())%></td>
					<td style="width:5%">沒有實踐</td>
					<td style="width:5%">一至三次</td>
					<td style="width:5%">四至七次</td>
					<td style="width:5%">每天實踐</td>
					</tr>	
<%
				}
%>				
					<tr>
						<td style="font-weight:bold;font-size:110%" width="15%" rowspan="<%=rowSpan%>">													
						<%=topic%>						
						</td>
						<td rowspan="<%=rowSpan%>" width="3%">&nbsp;</td>
<%						
				if (questionRecord.size() > 0){ 
					for (int j = 0; j < questionRecord.size(); j++) {
						ReportableListObject questionRow = (ReportableListObject) questionRecord.get(j);
						String question = questionRow.getValue(2);
						String questionaireQID = questionRow.getValue(1);
						if(j == 0){	
%>
						<td style="padding:5px;width:1%"><img src='../../images/right_question_icon.png'/></td>
						<td style="text-align:left"><%=question %></td>
<%
							ArrayList answerRecord = getAnswer(questionaireID,questionaireQID);	
							if(answerRecord.size()>0){		
								for(int a = 0; a < answerRecord.size(); a++){
									ReportableListObject answerRow = (ReportableListObject) answerRecord.get(a);
									String questionaireAID = answerRow.getValue(2);							
									
									boolean foundClientAnswer = false;
									if(viewAction){
										for(ClientAnswer ca : listOfClientAnswer){											
											if(ca.questionaireID.equals(questionaireID)&&ca.questionaireQID.equals(questionaireQID)&&ca.questionaireAID.equals(questionaireAID)){
												foundClientAnswer=true;
												break;
											}
										}
									}									
%>						
									<td style="width:5%"><input type="radio" <%=(viewAction)?"DISABLED":"" %> <%=(foundClientAnswer?"CHECKED":"") %> name="<%=questionaireID %>,<%=questionaireQID %>" value="<%=questionaireAID%>" /></td>
<%
								}								
							}
%>						
					</tr>
<%
						}else{
%>
					<tr>
						<td style="padding:5px;width:1%"><img src='../../images/right_question_icon.png'/></td>
						<td style="text-align:left"><%=question%></td>						
<%
							ArrayList answerRecord = getAnswer(questionaireID,questionaireQID);	
							if(answerRecord.size()>0){		
								for(int a = 0; a < answerRecord.size(); a++){
									ReportableListObject answerRow = (ReportableListObject) answerRecord.get(a);
									String questionaireAID = answerRow.getValue(2);
									
									boolean foundClientAnswer = false;
									if(viewAction){
										for(ClientAnswer ca : listOfClientAnswer){											
											if(ca.questionaireID.equals(questionaireID)&&ca.questionaireQID.equals(questionaireQID)&&ca.questionaireAID.equals(questionaireAID)){
												foundClientAnswer=true;
												break;
											}
										}
									}
%>
									<td style="width:5%"><input type="radio" <%=(viewAction)?"DISABLED":"" %> <%=(foundClientAnswer?"CHECKED":"") %> name="<%=questionaireID %>,<%=questionaireQID %>" value="<%=questionaireAID%>" /></td>
<%
								}								
							}
%>						
					</tr>
<%	
						}

					}
				}else{
%>
					</tr>
<%
				}	
%>							
				</table>
<%
				}
			}
%>
			</td>				
			</tr>		
			<tr>
			<td>
<%
		if(!viewAction){
%>
			<button type="button" onclick="submitAction('submit');return false;" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">提交</button>
<%
			}
%>	
			<button onclick="exitForm();return false;" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">離開</button>
			</td>
			</tr>									
			</table>
			<input type="hidden" name="command"/>
		</form>
		
		</div>
		<b class="b4"></b><b class="b3"></b><b class="b2"></b><b class="b1"></b>
	</td>
</tr>
</table>
</center>
<script language="javascript">
	function exitForm(){
		window.close();
	}
	
	function submitAction(cmd) {	
		document.form1.command.value = cmd;
		document.form1.submit();
	}		
</script>
</body>
</html:html>
<%}else{
%>
<script type="text/javascript">
alert('已完成本星期健康測試');
window.close();
</script>
<%
}
%>