<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>

<%!
public class TopicValue{
	String topicID;
	String topicDesc;
	public TopicValue(String topicID,String topicDesc){
		this.topicID = topicID;
		this.topicDesc = topicDesc;
	}
}

public class QuestionValue{
	String topicID;
	String questionID;
	String questionDesc;
	
	public QuestionValue(String topicID, String questionID, String questionDesc){
		this.topicID = topicID;
		this.questionID = questionID;
		this.questionDesc = questionDesc;
	}
}

public class AnswerValue{
	String topicID;
	String questionID;
	String answerID;
	public AnswerValue(String topicID, String questionID, String answerID){
		this.topicID = topicID;
		this.questionID = questionID;
		this.answerID = answerID;				
	}
}

public class ClientValue{
	String clientID;
	String clientDesc;
	ArrayList<AnswerValue> answerList;
	public ClientValue(String clientID,String clientDesc, ArrayList<AnswerValue> answerList){
		this.clientID = clientID;
		this.clientDesc = clientDesc;
		this.answerList = answerList;
	}
}


private ArrayList getClients() {	
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT    CRM_CLIENT_ID, CRM_LASTNAME || ',' || CRM_FIRSTNAME ");
	sqlStr.append("FROM      CRM_CLIENTS ");
	sqlStr.append("WHERE     CRM_ENABLED = 1 ");	
	sqlStr.append("AND       CRM_ISTEAM20 = 1 ");	
	sqlStr.append("ORDER BY  CRM_LASTNAME, CRM_FIRSTNAME");
	//System.out.println(sqlStr.toString());

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getLogBookTopic() {	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select    CRM_QUESTIONAIRE_ID, CRM_QUESTIONAIRE_DESC ");
	sqlStr.append("from      CRM_QUESTIONAIRE ");
	sqlStr.append("where     CRM_ENABLED = 1 ");
	sqlStr.append("ORDER BY  CRM_QUESTIONAIRE_ID ");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getLogBookQuestion(String topicID){	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select    CRM_QUESTIONAIRE_ID, CRM_QUESTIONAIRE_QID, CRM_QUESTION ");
	sqlStr.append("from      CRM_QUESTIONAIRE_QUESTION ");
	sqlStr.append("where     CRM_ENABLED = 1 ");
	sqlStr.append("AND       CRM_QUESTIONAIRE_ID = '"+topicID+"' ");	
	sqlStr.append("ORDER BY  CRM_QUESTIONAIRE_ID, CRM_QUESTIONAIRE_QID ");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getClientAnswer(String clientID ,String thisWeekStartOfDate,String thisWeekEndOfDate){	
	StringBuffer sqlStr = new StringBuffer();
		
	sqlStr.append("select    CRM_QUESTIONAIRE_ID, CRM_QUESTIONAIRE_QID, CRM_QUESTIONAIRE_AID, CRM_CLIENT_ID "); 
	sqlStr.append("from      CRM_QUESTIONAIRE_CLIENT_ANSWER ");
	sqlStr.append("where     CRM_CLIENT_ID = '"+clientID+"' ");
	sqlStr.append("AND       CRM_ENABLED = 1 ");
	sqlStr.append("AND       CRM_CREATED_DATE BETWEEN TO_DATE('"+thisWeekStartOfDate+" 00:00:00' ,'dd/mm/yyyy HH24:MI:SS')  ");	
	sqlStr.append("AND       TO_DATE('"+thisWeekEndOfDate+" 23:59:59' , 'dd/mm/yyyy HH24:MI:SS') ");	
	sqlStr.append("order by  CRM_QUESTIONAIRE_ID, CRM_QUESTIONAIRE_QID, CRM_QUESTIONAIRE_AID ");
			
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private Calendar getSelectedDate(String select_year, String select_month, String select_day){
	if(select_year != null && select_year.length() > 0   &&
	   select_month != null && select_month.length() > 0 &&
	   select_day != null && select_day.length() > 0){
		Calendar tempDate = Calendar.getInstance();
		tempDate.set(Integer.parseInt(select_year), Integer.parseInt(select_month) - 1, Integer.parseInt(select_day));
		
		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		df.format(tempDate.getTime());

		return tempDate;
	}else{
		return Calendar.getInstance();
	}
}
%>
<%
UserBean userBean = new UserBean(request);
SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");

String select_year = request.getParameter("select_year");
String select_month = request.getParameter("select_month");
String select_day = request.getParameter("select_day");



Calendar thisWeekStartOfDate = getSelectedDate(select_year,select_month,select_day);
String date[] = df.format(thisWeekStartOfDate.getTime()).split("/");
thisWeekStartOfDate.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);

Calendar thisWeekEndOfDate = getSelectedDate(select_year,select_month,select_day);
thisWeekEndOfDate.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);

select_day = date[0];
select_month = date[1];
select_year = date[2];

String message = "";
String errorMessage = "";

ArrayList<TopicValue> topicList = new ArrayList<TopicValue>();
ArrayList<QuestionValue> questionList = new ArrayList<QuestionValue>();
ArrayList<ClientValue> clientList = new ArrayList<ClientValue>();

ArrayList topicRecord = getLogBookTopic();
if (topicRecord.size() > 0) {
	for (int i = 0; i < topicRecord.size(); i++) {
		ReportableListObject topicRow = (ReportableListObject) topicRecord.get(i);
		String topicID = topicRow.getValue(0);
		String topicDesc = topicRow.getValue(1).substring(0,1);
		
		topicList.add(new TopicValue(topicID, topicDesc));
		
	}
}


for(TopicValue tv : topicList){
	ArrayList questionRecord = getLogBookQuestion(tv.topicID);
	if(questionRecord.size() > 0){
		for(int j = 0; j < questionRecord.size(); j++){
			ReportableListObject questionRow = (ReportableListObject) questionRecord.get(j);
			String questionID = questionRow.getValue(1);
			String questionDisplay = "";
			
			if(j==0){
				questionDisplay = tv.topicDesc+"</br>Q"+(j+1);
			}else{
				questionDisplay = "Q"+(j+1);
			}	
						
			questionList.add(new QuestionValue(tv.topicID,questionID, questionDisplay));
		}
	}
}

ArrayList clientsRecord = getClients();
if (clientsRecord.size() > 0) {
	for (int i = 0; i < clientsRecord.size(); i++) {
		ReportableListObject clientRow = (ReportableListObject) clientsRecord.get(i);
		String clientID = clientRow.getValue(0);
		String clientName = clientRow.getValue(1);
		
		ArrayList clientAnswerRecord = getClientAnswer(clientID,df.format(thisWeekStartOfDate.getTime()),df.format(thisWeekEndOfDate.getTime()));
		ArrayList<AnswerValue> answerList = new ArrayList<AnswerValue>();
		if(clientAnswerRecord.size() > 0){
			for(int j = 0; j < clientAnswerRecord.size(); j++){
				ReportableListObject clientAnswerRow = (ReportableListObject) clientAnswerRecord.get(j);
				answerList.add(new AnswerValue(clientAnswerRow.getValue(0),clientAnswerRow.getValue(1),clientAnswerRow.getValue(2)));
			}
		}
		clientList.add(new ClientValue(clientID,clientName,answerList));
	}
}

try {
	//request.setAttribute("client_answer_list", getClientPastResult(userBean));
		

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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="header.jsp"/>
<style>
.rowEven{
			background-color: #F5F1EE!important;		
}
.rowOdd{
			background-color: white!important;		
}
</style>
<body>
<DIV id=contentFrame style="width:100%;height:100%">
<jsp:include page="../../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Log Book Summary" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<div  style="background-color:#32A2F2;color:white;font-size:120%;font-weight:bold;text-align: center;">
Week : 
<%= df.format(thisWeekStartOfDate.getTime()) + " ~ " + df.format(thisWeekEndOfDate.getTime()) %>
</div>
<form name="form1" action="logbook_summary.jsp" method="post">
<table style="border-collapse:collapse;background-color:white;" border="1" cellpadding="0" cellspacing="0">
	<tr style="background-color:#F7ECEC" valign="bottom">
		<td style="font-weight:bold;">Name</td>
<%
for(QuestionValue qv : questionList){
%>
<td style="font-weight:bold;"><%=qv.questionDesc %></td>
<%
}
%>
	</tr>
<%
int i = 0;
for(ClientValue cv : clientList){	
%>
		<tr <%=(i%2==0?"class=\"rowOdd\"":"class=\"rowEven\"") %>>
			<td>
			<%=cv.clientDesc %>
			</td>
			
					
<%
		for(QuestionValue qv : questionList){
			String answerFound = "";
			for(AnswerValue av : cv.answerList){				
				if(av.topicID.equals(qv.topicID) && av.questionID.equals(qv.questionID)){
					 if(av.answerID.equals("1")){
						 answerFound = "A";
					 }else if(av.answerID.equals("2")){
						 answerFound = "B";
					 }else if(av.answerID.equals("3")){
						 answerFound = "C";
					 }else if(av.answerID.equals("4")){
						 answerFound = "D";
					 }
				 
					 break;
				}
			}
%>
			<td><%=answerFound%></td>
<%		
		}
%>		


		</tr>
<%
	i++;
}
%>

</table>
<br/>
<div style="text-align: center;">
	<button type="button" onclick="return switchDate('previous');" 
		class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">		
		Previous Week		
	</button>
	<button type="button" onclick="return switchDate('next');" 
		class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
		Next Week				
	</button>
</div>

<input type="hidden" name="select_year" value="<%=select_year%>">
<input type="hidden" name="select_month" value="<%=select_month%>">
<input type="hidden" name="select_day" value="<%=select_day%>">
</form>
<script language="javascript">
<!--

function switchDate(type) {		
	
	if(type=='previous'){
		document.form1.select_day.value = parseInt(document.form1.select_day.value) - 7;
	}else if(type=='next'){
		document.form1.select_day.value = parseInt(document.form1.select_day.value) + 7;		
	}
	document.form1.submit();
}
		
-->
</script>
</div>

<jsp:include page="../../common/footer.jsp" flush="false" />
</body>
</html:html>