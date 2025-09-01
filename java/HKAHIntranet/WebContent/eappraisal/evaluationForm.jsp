<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.*"%>
<%
UserBean userBean = new UserBean(request);
ArrayList record = EappraisalDB.getQuestionList();
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String evaluationID = ParserUtil.getParameter(request, "evaluationID");
String staffID = ParserUtil.getParameter(request, "staffID");
String evaluationType = ParserUtil.getParameter(request, "evaluationType");
String deptCode = ParserUtil.getParameter(request, "evaluationType");
String staffPosition = ParserUtil.getParameter(request, "staffPosition");

String[] appraiserPoint = (String[]) request.getParameterValues("appraiserPoint");
String[] staffPoint = (String[]) request.getParameterValues("staffPoint");
String staff_total = ParserUtil.getParameter(request, "staff_total");
String appraiser_total = ParserUtil.getParameter(request, "appraiser_total");

String employee_comment = ParserUtil.getParameter(request, "employee_comment");
String appraiser_comment = ParserUtil.getParameter(request, "appraiser_comment");
String perform_objective = ParserUtil.getParameter(request, "perform_objective");

String employeeApprovedDate = ParserUtil.getParameter(request, "employeeApprovedDate");

String appraiserApproved = ParserUtil.getParameter(request, "appraiserApproved");
String appraiserApprovedDate = ParserUtil.getParameter(request, "appraiserApprovedDate");

String supervisorApproved = ParserUtil.getParameter(request, "supervisorApproved");
String supervisorApprovedDate = ParserUtil.getParameter(request, "appraiserApprovedDate");

String[] months = new String [] {
		MessageResources.getMessage(session, "label.january"),
		MessageResources.getMessage(session, "label.february"),
		MessageResources.getMessage(session, "label.march"),
		MessageResources.getMessage(session, "label.april"),
		MessageResources.getMessage(session, "label.may"),
		MessageResources.getMessage(session, "label.june"),
		MessageResources.getMessage(session, "label.july"),
		MessageResources.getMessage(session, "label.august"),
		MessageResources.getMessage(session, "label.september"),
		MessageResources.getMessage(session, "label.october"),
		MessageResources.getMessage(session, "label.november"),
		MessageResources.getMessage(session, "label.december") };


String staffName = null;
String deptDesc = null;
String annualIncr = null;
String hireDate = null;

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean appraiserApproveAction = false;
boolean employeeApproveAction = false;
boolean supervisorApproveAction = false;

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");



if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("appraiserApprove".equals(command)){
	appraiserApproveAction = true;
} else if ("employeeApprove".equals(command)){
	employeeApproveAction = true;
} else if ("supervisorApprove".equals(command)){
	supervisorApproveAction = true;
}


System.out.println("[command]"+command);
try {
	if ("1".equals(step)) {
		if (createAction || updateAction) {
			if("".equals(evaluationID)|| evaluationID == null){
			  evaluationID = EappraisalDB.add(userBean,"2011",deptCode,staffID);
		     } 
			  if(EappraisalDB.update(userBean,"2011",deptCode,
					  				 staffID,evaluationType,appraiserPoint,staffPoint,
					  				staff_total,appraiser_total,appraiser_comment,perform_objective,
					  				employee_comment,evaluationID)){
				  
					if (createAction) {
						message = "Appraisal created.";
						createAction = false;
					} else {
						message = "Appraisal updated.";
						updateAction = false;
					}
					command = null;
					step = null;
				  
			  }else {
						if (createAction) {
						errorMessage = "Appraisal create fail.";
						} else {
						errorMessage = "Appraisal update fail.";
						}
			  }

		}else if(appraiserApproveAction){
			if(EappraisalDB.appraiserApprove(userBean,evaluationID,staffID)){
				message = "Appraiser Approved";
				command = null;
				step = null;
			}else{
				errorMessage = "Appraiser Approval Fail";
			}
		}else if(employeeApproveAction){
			if(EappraisalDB.employeeApprove(userBean,evaluationID)){
				message = "Employee Approved";
				command = null;
				step = null;
			} else{
				errorMessage = "Employee Approval Fail";
			}
			
		}else if(supervisorApproveAction){
			if(EappraisalDB.supervisorApprove(userBean,evaluationID,staffID)){
				message = "Supervisor Approved";
				command = null;
				step = null;
			}else{
				errorMessage = "Supervisor Approval Fail";
			}
		}
	}
	if (!"1".equals(step)) {
		if(staffID != null){
			ArrayList record_staff = StaffDB.get(staffID);
			if (record_staff.size() > 0) {
				ReportableListObject row_staff = (ReportableListObject) record_staff.get(0);
				staffName = row_staff.getValue(3);	
				deptDesc = row_staff.getValue(2);
				annualIncr = row_staff.getValue(5);
				hireDate = row_staff.getValue(6);
				deptCode = row_staff.getValue(1);
					staffPosition = row_staff.getValue(8)+" "+row_staff.getValue(9);
			}
			if(!createAction && (evaluationID != null && !"".equals(evaluationID))){
				ArrayList record_answer = EvaluationDB.getStaffResultAnswer("6306",evaluationID,"4",staffID,"","");
				if (record_answer.size() > 0) {
					for(int i=0;i<record_answer.size();i++){
						ReportableListObject row_answer = (ReportableListObject) record_answer.get(i);
							if("staff".equals(row_answer.getValue(4))){
								if("16".equals(row_answer.getValue(1)) && "16".equals(row_answer.getValue(2))){ //employee comment
									employee_comment = row_answer.getValue(3);
								 }
							} else if ("appraiser".equals(row_answer.getValue(4))){
								
								if("14".equals(row_answer.getValue(1)) && "14".equals(row_answer.getValue(2))){ //appraiser Comment
									appraiser_comment = row_answer.getValue(3);
								} else if("15".equals(row_answer.getValue(1)) && "15".equals(row_answer.getValue(2))){//performance obj									
									perform_objective = row_answer.getValue(3);							    
								}
							}
					 } 
				}
				ArrayList record_evaluation = EappraisalDB.get(evaluationID,userBean,staffID);
				 if(record_evaluation.size() >0){
					ReportableListObject row_evaluation = (ReportableListObject) record_evaluation.get(0);
					evaluationType = row_evaluation.getValue(3);
					appraiser_total = row_evaluation.getValue(5);
					staff_total = row_evaluation.getValue(4);
					appraiserApproved = row_evaluation.getValue(6);
					appraiserApprovedDate = row_evaluation.getValue(7);
					employeeApprovedDate = row_evaluation.getValue(8);
					supervisorApproved = row_evaluation.getValue(9);
					supervisorApprovedDate = row_evaluation.getValue(10);
				 }
			}
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<%@ page language="java" contentType="text/html; charset=big5"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>

<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include> 
<table width="800" border="0" cellpadding="0" cellspacing="0">

	<tr>
		<td align="left"><img src="../images/logo_hkah.gif" border="0" width="261" height="113" /></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>

<form name="form1" action="evaluationForm.jsp" method="post">
<table width="800" cellpadding="0" cellspacing="0" border="1" >
  <tr >
	<td class="infoSubTitle6" colspan="5">EMPLOYEE INFORMATION</td>
  </tr>
  <tr valign="center" pad>
	<td><font size="2">Employee's Name: <br><font size="3"><%=staffName == null?"":staffName%></font></br></font></td>
	<td><font size="2">Job Title: <br><font size="2"><%=staffPosition==null?"":staffPosition %></font></br></font></td>
	<td valign="top"><font size="2">Hire Date: <br><font size="3"><%=hireDate == null?"":hireDate %></font></br></font></td>
	<td><font size="2">Employee No: <br><font size="3"><%=staffID == null?"":staffID %></font></br></font></td>
	<td><font size="2">Evaluation Month: <br><font size="3"><%=annualIncr == null?"":months[(Integer.parseInt(annualIncr) + 11) % 12]%></font></br></font></td>
  </tr>
  <tr valign="center">
	<td><font size="2">Department: <br><font size="3"><%=deptDesc == null?"":deptDesc %></font></br></font></td>
	<%if(updateAction ||createAction){%>
	<td colspan="4"><font size="2" >Type of Evaluation:&nbsp;</font>
		<input type="checkbox" name="evaluationType" value="1" <%if((updateAction&&evaluationType!= null)&&ConstantsVariable.ONE_VALUE.equals(evaluationType)){%>checked<%} %>/>Probationary&nbsp;</font>
		<input type="checkbox" name="evaluationType" value="2" <%if((updateAction&&evaluationType!= null)&&ConstantsVariable.TWO_VALUE.equals(evaluationType)){%>checked<%} %>/>Special Interim&nbsp;</font>
		<input type="checkbox" name="evaluationType" value="3" <%if((updateAction&evaluationType!= null)&&ConstantsVariable.THREE_VALUE.equals(evaluationType)){%>checked<%} %>/>Annual&nbsp;</font>	
	</td>
	<%}else{ %>
	<td colspan="4" valign="top"><font size="2" >Type of Evaluation:&nbsp;</font>
	<%=ConstantsVariable.ONE_VALUE.equals(evaluationType)?"Probationary":(ConstantsVariable.TWO_VALUE.equals(evaluationType)?"Special Interim":(ConstantsVariable.THREE_VALUE.equals(evaluationType)?"Annual":"")) %>
	<%} %>
  </tr>
  <tr>
	<td colspan="5">
		<font size=2>
		In the Interest of conducting more effective evaluations:</br>
		(1) invite self-evaluation by the employee prior to the evaluation conference;</br>
		(2) thoroughly understand the duties and requirements of the positions;</br>
		(3) be as objective as possible - eliminate personal prejudice, bias, and favoritism;</br>
		(4) base judgment on demonstrated performance of set objectives;</br>
		(5) evaluate on the basis of job performance over a period of time, rather than focusing on recent outstanding of adverse behavior;</br>
		(6) involve employee in setting goals for future growth and development;</br> 
		</font>
	</td>
  </tr>
</table>
</br>
<table width="800" cellpadding="0" cellspacing="0" border="1">
  <tr >
	<td colspan="2">
	<table width="800" cellpadding="0" cellspacing="0">
		<tr>
			<td width="8%" class="infoSubTitle1small"><b>SECTION I</b></td>
			<td class="infoSubTitle1small">
			<font size="2">Select the rating most acurately describing the employee's performance based upon the job description for the position, in terms of each applicable factor listed below</font>
			</td>
		</tr>
	</table>
  </tr>
  <tr>
	<td colspan="2" align="center" valign="middle">
	 <font size="1"><b>Performance Levels</b></br>
		A. Performance is exceptional (Point : 5)</br>
		B. Performance exceeds job requirements (Point : 4)</br>
		C. Performance meets job requirements (Point : 3)</br>
		D. Performance Performance barely meets job requirements (Point : 2)</br>
		E. Performance is below job requirements (Point : 1)</br>
	 </font>
	</td>
  </tr>
  <tr>
   <td colspan="2">
    <table width="800" cellpadding="0" cellspacing="0" border="1" >
	  <tr>
	    <td align="right" colspan="2">&nbsp;</td>
  		<td align="right">Employee</td>
		<td align="right"><b>Appraiser</b></td>
 	 </tr>
	<%
	ReportableListObject row = null;
	for (int i = 0; i < record.size(); i++)
	{
	row = (ReportableListObject) record.get(i);
	String tempStaffValue = null;
	String tempAppraiserValue = null;
	if(evaluationID != null && !"".equals(evaluationID)){
		ArrayList record_answer = EvaluationDB.getStaffResultAnswer("6306",evaluationID,"4",staffID,"","",row.getValue(0));
		for(int k=0;k<record_answer.size();k++){
			ReportableListObject row_answer = (ReportableListObject) record_answer.get(k);
			if("staff".equals(row_answer.getValue(4))){
				tempStaffValue = row_answer.getValue(2);
			}else if ("appraiser".equals(row_answer.getValue(4))){
				tempAppraiserValue = row_answer.getValue(2);
			}
		}	
	 }
	%>
      <tr> 
		<td width="5%"><%=row.getFields0() %>.</td>
		<td width="85%"><%=row.getFields1() %></td>
		<td width="5%" align="center">
		<%if((createAction ||updateAction)){ %>
		<select name="staffPoint" onchange="sumPoint('staff_point_','staff_total','staffDisplay');return false;" id="staff_point_<%=row.getFields0() %>" >
			<option value="0" <%if((!createAction && tempStaffValue != null) && ConstantsVariable.ZERO_VALUE.equals(tempStaffValue)){%>selected<%} %>><%=ConstantsVariable.ZERO_VALUE %></option>
			<option value="1" <%if((!createAction && tempStaffValue != null) && ConstantsVariable.ONE_VALUE.equals(tempStaffValue)){%>selected<%} %>><%=ConstantsVariable.ONE_VALUE %></option>
			<option value="2"<%if((!createAction && tempStaffValue != null) && ConstantsVariable.TWO_VALUE.equals(tempStaffValue)){%>selected<%} %>><%=ConstantsVariable.TWO_VALUE %></option>
			<option value="3"<%if((!createAction && tempStaffValue != null) && ConstantsVariable.THREE_VALUE.equals(tempStaffValue)){%>selected<%} %>><%=ConstantsVariable.THREE_VALUE %></option>	
			<option value="4"<%if((!createAction && tempStaffValue != null) && ConstantsVariable.FOUR_VALUE.equals(tempStaffValue)){%>selected<%} %>><%=ConstantsVariable.FOUR_VALUE %></option>	
			<option value="5"<%if((!createAction && tempStaffValue != null) && ConstantsVariable.FIVE_VALUE.equals(tempStaffValue)){%>selected <%} %>><%=ConstantsVariable.FIVE_VALUE %></option>
		</select>	
		<%}else{%><%=tempStaffValue==null?"":tempStaffValue%><%}%>	
		</td>
		<td width="5%" align="center">
		<%if((createAction ||updateAction)){ %>
		<select name="appraiserPoint"  onchange="sumPoint('appraiser_point_','appraiser_total','appraiserDisplay');return false;" id="appraiser_point_<%=row.getFields0() %>">
			<option value="0" <%if((!createAction && tempAppraiserValue != null) && ConstantsVariable.ZERO_VALUE.equals(tempAppraiserValue)){%>selected <%} %>><%=ConstantsVariable.ZERO_VALUE %></option>
			<option value="1" <%if((!createAction && tempAppraiserValue != null) && ConstantsVariable.ONE_VALUE.equals(tempAppraiserValue)){%>selected<%} %>><%=ConstantsVariable.ONE_VALUE %></option>
			<option value="2"<%if((!createAction && tempAppraiserValue != null) && ConstantsVariable.TWO_VALUE.equals(tempAppraiserValue)){%>selected<%} %>><%=ConstantsVariable.TWO_VALUE %></option>
			<option value="3"<%if((!createAction && tempAppraiserValue != null) && ConstantsVariable.THREE_VALUE.equals(tempAppraiserValue)){%>selected<%} %>><%=ConstantsVariable.THREE_VALUE %></option>	
			<option value="4"<%if((!createAction && tempAppraiserValue != null) && ConstantsVariable.FOUR_VALUE.equals(tempAppraiserValue)){%>selected<%} %>><%=ConstantsVariable.FOUR_VALUE %></option>	
			<option value="5"<%if((!createAction && tempAppraiserValue != null) && ConstantsVariable.FIVE_VALUE.equals(tempAppraiserValue)){%>selected<%} %>><%=ConstantsVariable.FIVE_VALUE %></option>
		</select>
		<%}else{%><%=tempAppraiserValue==null?"":tempAppraiserValue%><%}%>			
		</td>
     </tr>
<%} %>
     <tr>
	   <td colspan="2"><b>TOTAL POINTS</b></td>
	   <td align="center">		
	   <%if((createAction ||updateAction)){ %>
	   <input type="textfield" name="staff_total" readonly="readonly"  id="staff_total" value="" maxlength="10" size="2">
	  <%}else{%><%=staff_total==null?"":staff_total%><%}%>
	  </td> 
	  <td align="center">
	  <%if((createAction ||updateAction)){ %>		
	   <input type="textfield" name="appraiser_total"  id="appraiser_total" readonly="readonly" value="" maxlength="10" size="2">
	  <%}else{%><%=appraiser_total==null?"":appraiser_total%><%}%>
	  </td> 
     </tr>	
    </table>
   </td>
  </tr>	
</table>
</br>
<table width="800" cellpadding="0" cellspacing="0" border="1">
  <tr>
    <td>
     <table width="800" cellpadding="0" cellspacing="0">
       <tr>
        <td width="8%" class="infoSubTitle2small"><b>SECTION II</b></td>
        <td class="infoSubTitle2small">SUMMARY APPRAISAL - </td>
        <td class="infoSubTitle2small"><font size="2">Check the level best describing overall evaluation of employee's performance</font></td>
       </tr>
       <tr>
       	 <td colspan="3">
       	 	<table width="800" cellpadding="0" cellspacing="0" >
       	 	 <tr>
       	 	 	<td style="border-right-style:solid;"width="10%">Employee's self evaluation</td>
       	 	 	<td  style="border-right-style:solid; border-bottom-style:dotted;" width="140px"><span id="staffDisplay1" style="width: 140px;float: left;">&nbsp;</span></td>
       	 	 	<td  style="border-right-style:solid; border-bottom-style:dotted;" width="140px"><span id="staffDisplay2" style="width: 140px;float: left;">&nbsp;</span></td>
       	 	    <td  style="border-right-style:solid; border-bottom-style:dotted;" width="140px"><span id="staffDisplay3" style="width: 140px;float: left;">&nbsp;</span></td>
            	<td  style="border-right-style:solid; border-bottom-style:dotted;" width="140px"><span id="staffDisplay4" style="width: 140px;float: left;">&nbsp;</span></td>
       	 	 	<td  style="border-right-style:solid; border-bottom-style:dotted;" width="140px"><span id="staffDisplay5" style="width: 140px;float: left; padding-right:5px">&nbsp;</span></td>
       	 	 </tr>
       	 	 <tr valign="top">
       	 	 <td style="border-right-style:solid;" width="10%">&nbsp;</td>
       	 	 <td style="border-right-style:solid; padding:5px;">is below job requirements (27 points of below)</td>
       	 	 <td style="border-right-style:solid; padding:5px;">barely meets job requirements (28-36 points)</td>
       	 	 <td style="border-right-style:solid; padding:5px;">meets job requirements (37-46 points)</td>
       	 	 <td style="border-right-style:solid; padding:5px;">exceeds job requirements (47-54 points)</td>
       	 	 <td style="border-right-style:solid; padding:5px;">is exceptional (55 points or above)</td>
       	 	 </tr>
       	 	</table>
       	 </td>
    </tr>
     <tr>
       	 <td colspan="3">
       	 	<table width="800" cellpadding="0" cellspacing="0" >
       	 	 <tr>
       	 	 	<td  style="border-right-style:solid;" width="10%">Employee's Overall Performance</td>
       	 	 	<td  style="border-right-style:solid; border-bottom-style:dotted;" width="140px"><span id="appraiserDisplay1" style="width: 140px;float: left;">&nbsp;</span></td>
       	 	 	<td  style="border-right-style:solid; border-bottom-style:dotted;" width="140px"><span id="appraiserDisplay2" style="width: 140px;float: left;">&nbsp;</span></td>
       	 	    <td  style="border-right-style:solid; border-bottom-style:dotted;" width="140px"><span id="appraiserDisplay3" style="width: 140px;float: left;">&nbsp;</span></td>
            	<td  style="border-right-style:solid; border-bottom-style:dotted;" width="140px"><span id="appraiserDisplay4" style="width: 140px;float: left;">&nbsp;</span></td>
       	 	 	<td  style="border-right-style:solid; border-bottom-style:dotted;" width="140px"><span id="appraiserDisplay5" style="width: 140px;float: left; padding-right:5px">&nbsp;</span></td>
       	 	 </tr>
       	 	 <tr valign="top" >
       	 	 <td style="border-right-style:solid;">&nbsp;</td>
       	 	 <td style="border-right-style:solid; padding:5px;">is below job requirements (27 points of below)</td>
       	 	 <td style="border-right-style:solid; padding:5px;">barely meets job requirements (28-36 points)</td>
       	 	 <td style="border-right-style:solid; padding:5px;">meets job requirements (37-46 points)</td>
       	 	 <td style="border-right-style:solid; padding:5px;;">exceeds job requirements (47-54 points)</td>
       	 	 <td style="border-right-style:solid; padding:5px;">is exceptional (55 points or above)</td>
       	 	 </tr>
       	 	</table>
       	 </td>
       </tr>  
      </table>
   </td>   
  </tr>
</table>
<table width="800" cellpadding="0" cellspacing="0" border="1" >
  <tr>
    <td class="infoSubTitle1small">
     <table>
     <tr>
     <td class="infoSubTitle1small"><b>SECTION III - </b></td>
     <td class="infoSubTitle1small"> APPRAISER'S COMMENTS AND OBJECTIVES</td>
     </tr>
     </table>
    </td>
  </tr>
  <tr>
   <td style="padding:5px;"  class="infoCenterLabel2">APPRAISER'S COMMENTS(Use additional sheet if necessary) Attach Training & Devt Record/s if applicable.</td>
  </tr>
  <tr>
  	<td style="padding:8px;" class="divbg">
  	<%if((createAction ||updateAction)){ %>
  	 <div class="box" >
  		<textarea  id="wysiwyg" name=appraiser_comment rows="10" cols="150"><%if(!createAction){ %><%=appraiser_comment==null?"":appraiser_comment %><%} %></textarea>
  	</div>
  	<%}else{%><%=appraiser_comment==null?"":appraiser_comment%><%}%>

  	</td>
  </tr>
  <tr>
   <td class="infoCenterLabel2">PERFORMANCE OBJECTIVES = Goals for further improvements in job performance during the <b>next year</b> in order to meet or exceed standards for the present job or to develop skills. </td>
  </tr>
  <tr>
  	<td style="padding:8px;" class="divbg">
  	<%if((createAction ||updateAction)){ %>
  		<div class="box">
  		<textarea id="wysiwyg1" name=perform_objective rows="10" cols="150"><%if(!createAction){ %><%=perform_objective==null?"":perform_objective %><%} %></textarea>
  		</div>
  	<%}else{%><%=perform_objective==null?"":perform_objective%><%}%>
  	</td>
  </tr>
  <tr>
    <td style="padding:5px;">
    <div class="appraiser_comment" style="width:100%;">
     <%if(evaluationID != null && !"".equals(evaluationID)){ %>	
     	<div class="pane">
    		 <%if((appraiserApproved != null && !"".equals(appraiserApproved)) && (appraiserApprovedDate != null && !"".equals(appraiserApprovedDate))) {%>
			<table width="800" cellpadding="0" cellspacing="0"> 
				<tr>
					<td width="33%"><span class="smallinfolabel"><%=StaffDB.getStaffName(appraiserApproved) %></span></td>
					<td width="33%"><span class="smallinfolabel"><%=StaffDB.getPosition(appraiserApproved) %></span></td>
					<td width="33%"><span  style=" position: relative;" class="smallinfolabel"><%=appraiserApprovedDate %></span></td>
				</tr>
			</table>     			
     		 <%}else{ %>
     			<button onclick="submitAction('appraiserApprove', 1, '');return false;">Appraiser Approve</button>
     		<%} %>
     	</div>
     <%} %>
       <table width="800" cellpadding="0" cellspacing="0"> 
     		<tr>
     			<td width="33%"><span class="smallinfolabel" >APPRAISER APPROVAL</span></td>
     			<td width="33%"><span  style=" position: relative;" class="smallinfolabel">APPRAISER'S TITLE</span></td>
     			<td width="33%"><span  style=" position: relative;" class="smallinfolabel">DATE</span></td>
     		</tr>
       </table>    
    </div>
    </td>
  </tr>

  <tr>
	<td class="infoSubTitle2small">
		<div class="employee_comment" style="width:150;">
	     <span><b>SECTION IV - </b></span>
	     <span><b>EMPLOYEE COMMENTS (Use additional sheet if necessary)</b></span>
       </div>
   </td>
  </tr>
  <tr>
     <td  class="divbg" >
       <%if((createAction ||updateAction)){ %>
        <div style="margin-top: 0px;">
        	<div>
  	     		<textarea id="wysiwyg2" name="employee_comment" rows="9" cols="153"><%if(!createAction){ %><%=employee_comment==null?"":employee_comment %><%} %></textarea>
			</div>
       </div>
       <%}else{%><%=employee_comment==null?"":employee_comment%><%}%>
     </td>
  </tr>
  <tr>
	<td style="padding:5px;">
	<%if(evaluationID != null && !"".equals(evaluationID)){ %>
    	 <div class="pane">
     		<%if(employeeApprovedDate != null && !"".equals(employeeApprovedDate)) {%>
     		<table width="800" cellpadding="0" cellspacing="0"> 
     			<tr>
     				<td width="50%"><span class="smallinfolabel"><%=staffName %></span></td>
     				<td width="50%"><span  style=" position: relative;" class="smallinfolabel"><%=employeeApprovedDate %></span></td>
     			</tr>
     		</table>     			
     		<%}else{ %>
     			<button onclick="submitAction('employeeApprove', 1, '');return false;">Employee Approve</button>
     		<%} %>
     	</div>
    <%} %>
      <table width="800" cellpadding="0" cellspacing="0"> 
      	<tr>
      		<td width="50%"><span  style=" position: relative;" class="smallinfolabel">EMPLOYEE APPROVAL</span></td>
      		<td width="50%"><span  style=" position: relative;" class="smallinfolabel">DATE</span></td>
      	</tr>
      </table>
    </td>
  </tr>
  <tr>
     <td style="padding:5px;">
     <%if(evaluationID != null && !"".equals(evaluationID)){ %>
     	<div class="pane">
     		<%if((!"".equals(supervisorApproved) && supervisorApproved != null) && (!"".equals(supervisorApprovedDate) && supervisorApprovedDate != null)) {%>
     			<table width="800" cellpadding="0" cellspacing="0"> 
     				<tr>
     					<td width="50%"><span class="smallinfolabel"><%=StaffDB.getStaffName(supervisorApproved) %></span></td>
     					<td width="50%"><span  style=" position: relative;" class="smallinfolabel"><%=supervisorApprovedDate %></span></td>
     				</tr>
     			</table>
     		<%}else{ %>
     			<button onclick="submitAction('supervisorApprove', 1, '');return false;">Supervisor Approve</button>
     		<%} %>
     	</div>
     <%} %>
          <table width="800" cellpadding="0" cellspacing="0"> 
     		 <tr>
     			<td width="50%"><span  style=" position: relative;" class="smallinfolabel">APPRAISER'S IMMEDIATE SUPERVISOR'S REVIEW</span></td>
     			<td width="50%"><span  style=" position: relative;"  class="smallinfolabel">DATE</span></td>
     		</tr>
     	 </table>
    </td>
  </tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) {%>
			<button onclick="return submitAction('<%=command%>', 1);" class="btn-click"><bean:message key="button.save" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="button.update" /></button>
			<button class="btn-delete"><bean:message key="button.delete" /></button>
<%	}  %>
		</td>
	</tr>
    <tr><td>&nbsp;</td></tr>
</table>
</div>

<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="evaluationID" value="<%=evaluationID %>">
<input type="hidden" name="staffID" value="<%=staffID %>">
<input type="hidden" name="staff_total" value="<%=staff_total %>">
<input type="hidden" name="appraiser_total" value="<%=appraiser_total %>">
</form>

<script language="javascript">


function submitAction(cmd, stp) {
	
			document.form1.command.value = cmd;
			document.form1.step.value = stp;
			document.form1.submit();

		}
function changeColor(barName,total1){
	if(total1 == 0){
		document.getElementById(barName+1).style.backgroundColor = "";
		document.getElementById(barName+2).style.backgroundColor = "";
		document.getElementById(barName+3).style.backgroundColor = "";
		document.getElementById(barName+4).style.backgroundColor = "";
		document.getElementById(barName+5).style.backgroundColor = "";				
	}else if(total1 <28){	
		document.getElementById(barName+1).style.backgroundColor = "red";
		document.getElementById(barName+2).style.backgroundColor = "";
		document.getElementById(barName+3).style.backgroundColor = "";
		document.getElementById(barName+4).style.backgroundColor = "";
		document.getElementById(barName+5).style.backgroundColor = "";
	}else if(total1< 37){
		document.getElementById(barName+1).style.backgroundColor = "red";
		document.getElementById(barName+2).style.backgroundColor = "red";
		document.getElementById(barName+3).style.backgroundColor = "";
		document.getElementById(barName+4).style.backgroundColor = "";
		document.getElementById(barName+5).style.backgroundColor = "";
	}else if (total1 < 47){
		document.getElementById(barName+1).style.backgroundColor = "red";
		document.getElementById(barName+2).style.backgroundColor = "red";
		document.getElementById(barName+3).style.backgroundColor = "red";
		document.getElementById(barName+4).style.backgroundColor = "";
		document.getElementById(barName+5).style.backgroundColor = "";
	}else if (total1 < 55){
		document.getElementById(barName+1).style.backgroundColor = "red";
		document.getElementById(barName+2).style.backgroundColor = "red";
		document.getElementById(barName+3).style.backgroundColor = "red";
		document.getElementById(barName+4).style.backgroundColor = "red";
		document.getElementById(barName+5).style.backgroundColor = "";
	}else if (total1 >55){
		document.getElementById(barName+1).style.backgroundColor = "red";
		document.getElementById(barName+2).style.backgroundColor = "red";
		document.getElementById(barName+3).style.backgroundColor = "red";
		document.getElementById(barName+4).style.backgroundColor = "red";
		document.getElementById(barName+5).style.backgroundColor = "red";
	
	  return true;
    }
}
 function sumPoint(elementName,totalName,barName){	
	 var total1 = new Number();
		for (var i = 1; i < 14; i++) {
			var textinput = document.getElementById(elementName+i).value;
			 var textinput1 = new Number(textinput);
			total1 += textinput1;			  
		}
		document.getElementById(totalName).value = total1;
		changeColor(barName,total1);	
  return true;
}
 
<%if(updateAction){%>
sumPoint('staff_point_','staff_total','staffDisplay');
sumPoint('appraiser_point_','appraiser_total','appraiserDisplay');
<%}%>
<%if(!createAction){%>
changeColor('staffDisplay',document.form1.staff_total.value);
changeColor('appraiserDisplay',document.form1.appraiser_total.value);
<%}%>
</script>
</DIV>
</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>