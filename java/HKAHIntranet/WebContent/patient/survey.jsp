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
	String surveyID;
	String questionID;
	String answerID;
	String clientAnswerID;
	public ClientAnswer(String surveyID,String questionID,String answerID,String clientAnswerID){
		this.surveyID = surveyID;
		this.questionID = questionID;
		this.answerID = answerID;
		this.clientAnswerID = clientAnswerID;
	}
}


public static ArrayList getClientAnswer(String questionClientAnswerID){
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("select    EE_ENROLL_ID , EE_EVALUATION_ID, EE_EVALUATION_QID , EE_EVALUATION_AID , EE_USER_ID , EE_MODIFIED_USER , EE_EVALUATION_ANSWER_DESC ");
	sqlStr.append("from      EE_EVALUATION_STAFF_ANSWER ");
	sqlStr.append("where     EE_ENABLED = '1' ");
	sqlStr.append("and       EE_MODULE_CODE = 'survey' ");
	sqlStr.append("AND       EE_ENROLL_ID = '"+questionClientAnswerID+"' ");
	sqlStr.append("ORDER BY  EE_EVALUATION_QID");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static boolean insertClientAnswer(String type,UserBean userBean,String surveyID,
		String questionID,String questionaClientAnswerID, String answerID, 
		String staffID, String patientID,String comment) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("insert into EE_EVALUATION_STAFF_ANSWER ");
	sqlStr.append("(EE_SITE_CODE, EE_MODULE_CODE, EE_EVENT_ID, EE_ENROLL_ID, EE_ELEARNING_ID, EE_EVALUATION_ID, EE_EVALUATION_QID, EE_EVALUATION_AID, ");
	sqlStr.append("EE_USER_TYPE, EE_USER_ID ");
	if ("textarea".equals(type)) {
		answerID = "-1";
		sqlStr.append(", EE_EVALUATION_ANSWER_DESC ");
	}
	if (staffID != null && staffID.length() > 0) {
		sqlStr.append(", EE_CREATED_USER, EE_MODIFIED_USER) ");
	}
	else {
		sqlStr.append(") ");
	}
	sqlStr.append("VALUES ('"+ConstantsServerSide.SITE_CODE+"','survey','-1','"+questionaClientAnswerID+"',-1,'"+surveyID+"','"+questionID+"','"+answerID+"','patient','"+patientID+"' ");
	if ("textarea".equals(type)) {
		sqlStr.append(", '"+comment+"' ");
	}
	if (staffID != null && staffID.length() > 0) {
		sqlStr.append(",'"+staffID+"','"+staffID+"') ");
	}
	else {
		sqlStr.append(") ");
	}	
	//System.out.println(sqlStr.toString());	
	return UtilDBWeb.updateQueue(sqlStr.toString());	
}

private static String getNextClientAnswerID(String surveyID) {
	String questionClientAnswerID = null;

	ArrayList result = UtilDBWeb.getReportableList(
			"SELECT MAX(EE_ENROLL_ID) + 1 FROM EE_EVALUATION_STAFF_ANSWER WHERE EE_MODULE_CODE = 'survey' AND EE_EVALUATION_ID = '"+surveyID+"' ");
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		questionClientAnswerID = reportableListObject.getValue(0);

		// set 1 for initial
		if (questionClientAnswerID == null || questionClientAnswerID.length() == 0) return "1";
	}
	return questionClientAnswerID;
}

private ArrayList getQuestion(String surveyID) {	
	StringBuffer sqlStr = new StringBuffer();	
	
	sqlStr.append("SELECT  EE_EVALUATION_ID, EE_EVALUATION_QID, EE_QUESTION, EE_IS_FREE_TEXT ");
	sqlStr.append("FROM    EE_EVALUATION_QUESTION ");
	sqlStr.append("WHERE   EE_EVALUATION_ID = '"+surveyID+"' ");
	sqlStr.append("AND     EE_ENABLED = 1 ");
	sqlStr.append("ORDER BY  EE_EVALUATION_QID");
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}


%>
<%
UserBean userBean = new UserBean(request);
SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");

String surveyID = request.getParameter("surveyID");
String staffID = (String)session.getAttribute("staffID");
String patientID = request.getParameter("patientID");
String patientName = request.getParameter("patientName");
String surveyType = request.getParameter("surveyType");
String dischargeType = request.getParameter("dischargeType");
//System.out.println(surveyID);
if(dischargeType != null && "null".equals(dischargeType)){
	dischargeType = "";
}

String questionClientAnswerID = request.getParameter("questionClientAnswerID"); 
String command = request.getParameter("command");
String clientAnswerDate = request.getParameter("clientAnswerDate");

String message = "";
String errorMessage = "";

String surveyTypeString = "";
String surveyTypeStringCH = "";
if("admission".equals(surveyType)){
	surveyTypeString = "Admission";
	surveyTypeStringCH = "入院";
}else if("discharge".equals(surveyType)){
	surveyTypeString = "Discharge";
	surveyTypeStringCH = "出院";
}
	boolean insertAnswerSuccess = false;
	if("submit".equals(command)){	
		Enumeration paramNames = request.getParameterNames();
		questionClientAnswerID = getNextClientAnswerID(surveyID);	
	
		if (dischargeType != null && dischargeType.length() > 0) {
			insertClientAnswer("textarea",userBean,surveyID,"1",questionClientAnswerID,"-1",staffID,patientID,
					dischargeType);
		}
		while(paramNames.hasMoreElements())
	    {
	        String paramName = (String)paramNames.nextElement(); 	       
	        if(paramName.contains("clientAnswer_")){	        	
		        String[] paramValues = request.getParameterValues(paramName);
		        String questionID  = paramName.split("_")[1];
		        String answerID = paramValues[0];
		        String type = "radio";
		        
		        insertAnswerSuccess = insertClientAnswer(type,userBean,surveyID,questionID,questionClientAnswerID,answerID,staffID,patientID,null);		        
	        }else if(paramName.contains("clientAnswerComment_")){
	        	String[] paramValues = request.getParameterValues(paramName);
		        String questionID  = paramName.split("_")[1];
		        String comment = TextUtil.parseStrUTF8(java.net.URLDecoder.decode(paramValues[0], "UTF-8")).replaceAll("'", "''");
		        //System.out.println(comment);
		        String type = "textarea";
		        
		        insertAnswerSuccess = insertClientAnswer(type,userBean,surveyID,questionID,questionClientAnswerID,comment,staffID,patientID,comment);		        
	        }
	    }
		if(insertAnswerSuccess){
			message = "Submit Successfully.";
			command = "view";
		}else{
			errorMessage = "Error occured while submitting.";	
		}
	}
	
	ArrayList<ClientAnswer> listOfClientAnswer = new ArrayList<ClientAnswer>();

	if("view".equals(command)){	
		if(questionClientAnswerID != null && questionClientAnswerID.length() > 0){
			ArrayList clientAnsweRecord= getClientAnswer(questionClientAnswerID);		
			
			if (clientAnsweRecord.size() > 0) {
				for(int i = 0;i<clientAnsweRecord.size();i++){
					ReportableListObject row = (ReportableListObject) clientAnsweRecord.get(i);					
					String tempSurveyID = row.getValue(1);
					String tempQuestionID = row.getValue(2);
					String tempAnswerID = row.getValue(3);
					String tempClientAnswerID = row.getValue(0);
					String tempComment = row.getValue(6);
					
					ClientAnswer temp = null;
					if("-1".equals(tempAnswerID)){
						temp = new ClientAnswer(tempSurveyID,tempQuestionID,tempComment,tempClientAnswerID);
					}else{					
						temp = new ClientAnswer(tempSurveyID,tempQuestionID,tempAnswerID,tempClientAnswerID);
					}
					listOfClientAnswer.add(temp);
				}
			}
			
		}	
	}
	
	boolean viewAction= false;
	if("view".equals(command)){
		viewAction = true;
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

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<jsp:include page="header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>

<style>
.rowEven{
			background-color: #F5F1EE!important;		
}
td .ansCell {
	width:17%;
	align:center;
}

</style>
<body>
<div id="overlay" class="ui-widget-overlay" style="display:none"></div>
<div id="alertDialog" style="width:300px; height:auto; position:absolute; z-index:1005; display:none;"
	class="ui-dialog ui-widget ui-widget-content ui-corner-all">
	<div align="left" class = "ui-widget-header"><label class="text">Information</label></div>
	<div align="left"><label id="alertMsg" class="text"></label></div>
	<div>&nbsp;</div>
	<div align="right">
		<button id="closeAlert" class = "ui-button ui-widget ui-state-default ui-corner-all">
			<label class="text">Close 關閉</label>
		</button>
	</div>
</div>

<center>
<table width="800" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td  style="font-weight:bold;font-size:230%;text-align: center;"><b>Patient Satisfaction Survey 病人服務意見調查</b></td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td style="text-align:left;font-size:130%;">At Hong Kong Adventist Hospital, we strive to provide you the best patient experience. To achieve the aim,
	    we would like to conduct a patient satisfaction survey to understand your needs and your perception of <%=surveyTypeString%>
	    process. Your feedback would be critical to us in serving you better.</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td style="text-align:left;font-size:130%;">
		香港港安醫院一向以提供最佳的醫療服務和設施為宗旨，尤其重視每位病人的感受和需要。
		為此，本院誠邀閣下填寫這份問卷，讓我們知道您對是次<%=surveyTypeStringCH %>服務的感想。
		您的寶貴意見，是我們繼續進步的動力。
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td colspan="2"><font color="blue"><%=message %></font></td>
</tr>
<tr>
	<td colspan="2"><font color="red"><%=errorMessage %></font></td>
</tr>

<tr>
	<td align="center" colspan="2">
		<b class="b1"></b><b class="b2"></b><b class="b3"></b><b class="b4"></b>
		<div class="contentb" style="width:810px">
		<form name="form1" action="survey.jsp" method="post" accept-charset=UTF-8">
			<table width="800" border="1" cellpadding="0" cellspacing="0" style="font-size:130%;background-color:white;">
			
			<tr>
			<td>
			<table width="100%" border="0" >
				<tr style="width:100%">
					<td align="left" colspan = "6" style="font-size:130%;font-weight:bold;">How would you rate our <%=surveyTypeString %> Staff?</td>
				</tr>
				<tr>
				</tr>
				<tr style="width:100%">
					<td align="left" colspan = "6" style="font-size:130%;font-weight:bold;">請評價是次<%=surveyTypeStringCH %>服務:</td>
				</tr>
				<tr>
				<td>&nbsp;</td>
				</tr>
				<tr style="width:100%">		
					<td align="left" style="font-weight:bold;text-align:left;" colspan="3">
						Patient Number<br/>病歷號碼: 
						<input name="patientID" type="input" <%=(viewAction)?"DISABLED":"" %> 
								value="<%=(patientID==null)?"":patientID %>" 
								maxlength="6" size="auto" 
								style="float:right; width:240px"/>
					</td>
					<td colspan="1" align="left" style="font-weight:bold;text-align:left;">
						Patient Name<br/>病人名稱: 
					</td>
					<td colspan="2">
						<span id="patName"><%=(patientName==null?"":patientName) %></span>
					</td>
				</tr>
				<tr style="background-color:#F7ECEC">
					<td></td>
					<td class="ansCell" align="center">Excellent<br/>卓越</td>
					<td class="ansCell" align="center">Very Good<br/>非常好</td>
					<td class="ansCell" align="center">Good<br/>好</td>
					<td class="ansCell" align="center">Could Be Better<br/>需改進</td>
					<td class="ansCell" align="center">Poor<br/>差</td>
				</tr>	
<%
			ArrayList questionRecord = getQuestion(surveyID);
			if (questionRecord.size() > 0){ 
				for (int i = 1; i < questionRecord.size(); i++) {
					ReportableListObject questionTopicRow = (ReportableListObject) questionRecord.get(i);
					String question = questionTopicRow.getValue(2);
					String questionID = questionTopicRow.getValue(1);
					String isFreeText = questionTopicRow.getValue(3);
					
					
%>			
					<tr <%=(i%2==0?"":"class=\"rowEven\"") %>>						
						<td style="text-align:left;<%=(i==questionRecord.size()-2?"font-weight:bold;":"") %>" ><%=question%></td>	
<%						
						for(int j = 0; j < 5; j ++){
							boolean foundClientAnswer = false;					
							String foundClientComment = "";
							
							/*
							
							for(ClientAnswer ca : listOfClientAnswer){	
								if("Y".equals(isFreeText)){
									if(ca.surveyID.equals(surveyID)&&ca.questionID.equals(questionID)){
										foundClientComment = ca.answerID;
										foundClientAnswer=true;									
										break;
									}
								}else{
									if(ca.surveyID.equals(surveyID)&&ca.questionID.equals(questionID)&&ca.answerID.equals(Integer.toString(j+1))){
										foundClientAnswer=true;									
										break;
									}
								}
							}
							
							*/
							
							if("Y".equals(isFreeText)){
%>
								<td colspan="5" ><textarea class='textarea' <%=(viewAction)?"DISABLED":"" %> name="clientAnswerComment_<%=questionID %>" rows="4" style="width:100%"><%=foundClientComment%></textarea></td>
<%							
								break;
							}else{
%>
								<td align="center"><input type="radio" <%=(viewAction)?"DISABLED":"" %> <%=(foundClientAnswer?"CHECKED":"") %>  name="clientAnswer_<%=questionID %>" value="<%=j+1 %>" /></td>	
<%	
							}
						}
%>
					</tr>		
<%
				}
			}
%>	
			</table>
			</td>				
			</tr>		
			<tr>
			<td align="center">
<%
		if(!viewAction){
%>
			<button type="button" onclick="submitAction('submit');return false;" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Submit 遞交</button>
<%
			}
%>	
			</td>
			</tr>									
			</table>
			<input type="hidden" name="command"/>
			<input type="hidden" name="surveyID" value="<%=surveyID%>"/>	
			<input type="hidden" name="questionClientAnswerID" value="<%=questionClientAnswerID%>"/>
			<input type="hidden" name="surveyType" value="<%=surveyType%>"/>
			<input type="hidden" name="dischargeType" value="<%=dischargeType%>"/>
			<input type="hidden" name="patientName"/>
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
	
	function toggleAlert() {
		$('div#alertDialog').css('top', $(window).height()/2 - $('div#alertDialog').height()/2 + $(document).scrollTop())
							.css('left', $(window).width()/2 - $('div#alertDialog').width()/2);
		$('div#overlay').css('height', $(document).height());
		$('div#overlay').css('width', $(document).width());
		$('div#alertDialog').toggle();
		$('div#overlay').toggle();
	}
	
	function submitAction(cmd) {		
		var success = true;
		if ($.trim($('input[name=patientID]').val())) {
			$('input[name=patientID]').val($.trim($('input[name=patientID]').val()));			
		}else{
			$('label#alertMsg').html('Patient ID cannot be empty.<br/>請輸入病歷號碼。');
			toggleAlert();
			$('input[name=patientID]').focus();
			success = false;
			return false;
		}
		
		if($('input[name=patientID]').val().length < 6 || 
				isNaN($('input[name=patientID]').val())){
			$('label#alertMsg').html('Invaild Patient ID.<br/>病歷號碼不正確。');
			$('span#patName').html('');
			toggleAlert();
			$('input[name=patientID]').focus();
			success = false;
			return false;
		}
		
		var radio_groups = {};
		$(":radio").each(function(){
		    radio_groups[this.name] = true;
		  
		});
		for(group in radio_groups){
		    if_checked = !!$(":radio[name="+group+"]:checked").length;
		    
		    if(!if_checked){
		    	$('label#alertMsg').html('All questions needs to be answered before submitting.<br/>請回答所有問題。');
		    	toggleAlert();
		    	success = false;
		    	return;
		    }
		}
			
		if(success){
			document.form1.command.value = cmd;
			/*
			var command = "command="+$('input[name=command]').val();
			var surveyID = "surveyID="+$('input[name=surveyID]').val();
			var questionClientAnswerID = "questionClientAnswerID="+$('input[name=questionClientAnswerID]').val();
			var surveyType = "surveyType="+$('input[name=surveyType]').val();
			var dischargeType = "dischargeType="+$('input[name=dischargeType]').val();
			var patientID = "patientID="+$('input[name=patientID]').val();
			
			var clientRadioAnswer = "";
			for(group in radio_groups){
				clientRadioAnswer += group + "=" + $(':radio[name='+group+']:checked').val() + "&";
			}
			
			var clientTextareaAnswer = "";
			$('.textarea').each(function(){
			   clientTextareaAnswer += $(this).attr('name') + "=" + encodeURIComponent($(this).val()) + "&";			   
			});
					
			window.location.replace("../patient/survey.jsp?"+command+"&"+surveyID+"&"+questionClientAnswerID+"&"+
									surveyType+"&"+dischargeType+"&"+patientID+"&"+clientRadioAnswer+clientTextareaAnswer);
			*/
			
			//$('.textarea').each(function(){
				//$(this).val(encodeURIComponent($(this).val()));
			//});
			
			$('.textarea').val($('.textarea').val().replace(/\%/g, "%25").replace(/\+/g, "%2B"));
			
			document.form1.submit();
		}
	}		
	
	function patientFieldOnBlur() {
		$('input[name=patientID]').blur(function() {
			var patno = $(this).val();
			$.ajax({
				async: false,
				cache: false,
				url: '../ui/patientInfoCMB.jsp?callback=?',
				data: 'patno='+patno,
				dataType: "jsonp",
				success: function (data, textStatus, jqXHR) {
							$('span#patName').html(data['PATNAME']+' '+data['PATCNAME']);	
							$('input[name=patientName]').val(data['PATNAME']+' '+data['PATCNAME']);
						 },
				error: function(x, s, e) {
							$('span#patName').html('');
					   }
			});
		});
	}
	
	$(document).ready(function() {
		var post = ($('input[name=surveyType]').val()=="admission"?
							"Admission Staff: ":"Discharge Staff: ");
		$('label#postLabel').html(post);
		patientFieldOnBlur();
		
		$('button#closeAlert').click(function() {
			$('div#alertDialog').hide();
			$('div#overlay').hide();
		});
		
		<%if(insertAnswerSuccess){%>
			$('label#alertMsg').html('Thank you for your comment! <br/>多謝你的意見!');
			toggleAlert();
		<%}%>
	});
	
	
</script>
<jsp:include page="footer.jsp" flush="false" />
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
 