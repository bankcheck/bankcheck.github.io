<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%! 
	private String[] splitInfo(String info) {
		int j = 0;
		String currentInfo[] = new String[99];
		for(j = 0; info.toString().indexOf("||") > -1 && j < 10; j++) {
			currentInfo[j] = info.toString()
								.substring(0, info.toString().indexOf("||"));
			
			info = info.toString()
								.substring(info.toString().indexOf("||")+2, 
										info.toString().length());
		}
		currentInfo[j] = info.toString();
		
		return currentInfo;
	}

	private boolean isInteger(String i) {
		try {  
			Integer.parseInt(i);  
		    return true;  
		}  
		catch(Exception e)  
		{  
			return false;  
		}  
	}
%>

<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	fileUpload = true;
}

UserBean userBean = new UserBean(request);
String command = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "command"));
boolean createAction = false;
boolean viewAction = false;
boolean editAction = false;
boolean updateAction = false;
String personName = null;
String rank = null;
String deptCode = null;
String deptDesc = null;
String incident_date = null;
String incident_time_hh = null;
String incident_time_mi = null;
String incident_place = null;
String incident_type = null;
String patientInfo[] = null;
String staffInfo[] = null;
String visitorInfo[] = null;
String otherInfo[] = null;
String pirID = null;
String incident_status = null;
String incident_classification = null;
String incident_classification_desc = null;

if(command != null && command.equals("create")) {
	personName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "reportPersonName"));
	rank = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "reportPersonRank"));
	deptCode = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "deptCode"));
	incident_date = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "occurDate"));
	incident_time_hh = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "timeOfOccurrence_hh"));
	incident_time_mi = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "timeOfOccurrence_mi"));
	incident_place = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "placeOfOccur"));
	incident_type = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "selectedIncidentType"));
	incident_classification = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "incidentClass"));
	
	patientInfo = (String[])request.getAttribute("isPatientInfo_StringArray");
	staffInfo = (String[])request.getAttribute("isStaffInfo_StringArray");
	visitorInfo = (String[])request.getAttribute("isVisitorInfo_StringArray");
	otherInfo = (String[])request.getAttribute("isOtherInfo_StringArray");

	createAction = true;
}
else if(command != null && command.indexOf("view") > -1) {
	pirID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pirID"));
	viewAction = true;
}
else if(command != null && command.equals("edit")) {
	pirID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pirID"));
	editAction = true;
}
else if(command != null && command.equals("update")) {
	pirID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pirID"));
	personName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "reportPersonName"));
	rank = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "reportPersonRank"));
	deptCode = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "deptCode"));
	incident_date = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "occurDate"));
	incident_time_hh = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "timeOfOccurrence_hh"));
	incident_time_mi = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "timeOfOccurrence_mi"));
	incident_place = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "placeOfOccur"));
	incident_type = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "selectedIncidentType"));
	incident_classification = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "incidentClass"));
	
	patientInfo = (String[])request.getAttribute("isPatientInfo_StringArray");
	staffInfo = (String[])request.getAttribute("isStaffInfo_StringArray");
	visitorInfo = (String[])request.getAttribute("isVisitorInfo_StringArray");
	otherInfo = (String[])request.getAttribute("isOtherInfo_StringArray");
	
	updateAction = true;
}

String message = null;
String errorMessage = null;

if(command != null) {
	if(createAction) {
//		if((pirID = PiReportDB.add(userBean, personName, rank, deptCode, incident_date, 
//				incident_time_hh+":"+incident_time_mi, incident_place, incident_type, 
//				incident_classification,null,null, null)) != null){
		if (true) {
			String currentInfo[] = new String[99];
			if(patientInfo != null) {
				for(int i = 0; i < patientInfo.length; i++) {
					patientInfo[i] = TextUtil.parseStrUTF8(patientInfo[i]);
					//System.out.println("patientInfo: "+patientInfo[i]);
					
					currentInfo = splitInfo(patientInfo[i]);
					
					if(PiReportDB.addInvolvePatient(userBean, pirID, currentInfo[0], 
							currentInfo[1], currentInfo[2], 
							currentInfo[3], currentInfo[4], currentInfo[5],
							currentInfo[6])) {
						message = "Succeed in add involving patient";
					}
					else {
						errorMessage = "Error in add involving patient";
					}
				}
			}
			if(staffInfo != null) {
				for(int i = 0; i < staffInfo.length; i++) {
					staffInfo[i] = TextUtil.parseStrUTF8(staffInfo[i]);
					//System.out.println("staffInfo: "+staffInfo[i]);
					
					currentInfo = splitInfo(staffInfo[i]);
					
					if(PiReportDB.addInvolveStaff(userBean, pirID, (currentInfo[0].equals("true")?"1":"0"), 
							currentInfo[1], currentInfo[2], currentInfo[3], currentInfo[4], 
							currentInfo[5], currentInfo[6])) {
						message = "Succeed in add involving staff";
					}
					else {
						errorMessage = "Error in add involving staff";
					}
				}
			}
			if(visitorInfo != null) {
				for(int i = 0; i < visitorInfo.length; i++) {
					visitorInfo[i] = TextUtil.parseStrUTF8(visitorInfo[i]);
					//System.out.println("visitorInfo: "+visitorInfo[i]);
					
					currentInfo = splitInfo(visitorInfo[i]);
					
					if (true) {
					//if(PiReportDB.addInvolveVisitorOrRelatives(userBean, pirID, 
							//(currentInfo[0].equals("true")?"1":"0"), currentInfo[1], 
							//(currentInfo[2].equals("true")?"1":"0"),
							//currentInfo[3], currentInfo[4], currentInfo[5], currentInfo[6])) {
						message = "Succeed in add involving visitor";
					}
					else {
						errorMessage = "Error in add involving visitor";
					}
				}
			}
			if(otherInfo != null) {
				for(int i = 0; i < otherInfo.length; i++) {
					otherInfo[i] = TextUtil.parseStrUTF8(otherInfo[i]);
					//System.out.println("otherInfo: "+otherInfo[i]);
					
					currentInfo = splitInfo(otherInfo[i]);
					
//					if(PiReportDB.addInvolveOther(userBean, pirID, currentInfo[0], currentInfo[1], currentInfo[2])) {
						message = "Succeed in add involving other";
//					}
//					else {
//						errorMessage = "Error in add involving other";
//					}
				}
			}
			
			message = "Succeed in add basic information";
			
			if(incident_type != null) {
				String moduleValue = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, incident_type+"_value"));
				if(moduleValue != null && moduleValue.length() > 0) {
					//System.out.println(moduleValue);
					String value[] = moduleValue.split("&#");
					
					for(int i = 0; i < value.length; i++) {
						String field[] = value[i].split("@#");

						if(field[2].equals("upload")) {
							if(fileUpload) {
								StringBuffer tempStrBuffer = new StringBuffer();
								tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
								tempStrBuffer.append(File.separator);
								tempStrBuffer.append("PIReport");
								tempStrBuffer.append(File.separator);
								tempStrBuffer.append(pirID);
								tempStrBuffer.append(File.separator);
								String baseUrl = tempStrBuffer.toString();

								tempStrBuffer.setLength(0);
								tempStrBuffer.append(File.separator);
								tempStrBuffer.append("upload");
								tempStrBuffer.append(File.separator);
								tempStrBuffer.append("PIReport");
								tempStrBuffer.append(File.separator);
								tempStrBuffer.append(pirID);
								String webUrl = tempStrBuffer.toString();
								
								FileUtil.moveFile(
										ConstantsServerSide.UPLOAD_FOLDER + File.separator + field[3].substring(field[3].lastIndexOf("\\")+1, field[3].length()),
										baseUrl + field[3].substring(field[3].lastIndexOf("\\")+1, field[3].length())
									);
								String documentID = "";
								if((documentID = DocumentDB.add(ConstantsServerSide.SITE_CODE, 
										userBean, "pireport", pirID, webUrl, field[3].substring(field[3].lastIndexOf("\\")+1, field[3].length()))) != null) {
									if(PiReportDB.addReportContent(userBean, pirID, field[1], documentID, field[4], field[0])) {
										message = "Succeed in upload document";
									}
									else {
										errorMessage = "Error in upload document";
									}
								}
								else {
									errorMessage = "Error in upload document";
								}
							}
						}
						else {
							if(PiReportDB.addReportContent(userBean, pirID, field[1], field[3], field[4], field[0])) {
								message = "Succeed in save content";
							}
							else {
								errorMessage = "Error in save content";
							}
						}
					}
				}
			}
			
			if(errorMessage != null && errorMessage.length() > 0) {
				message = null;
			}
			else {
				message = "Succeed in save report";
			}
			
			//PiReportDB.alert(userBean, incident_type, pirID);
			
			createAction = false;
			viewAction = true;
			command = "view";
		}
		else {
			errorMessage = "Error in add report";
		}
		response.sendRedirect("incident_report.jsp?command=view&pirID="+pirID);
	}	
	else if(updateAction) {
		if(pirID != null) {
			//if(PiReportDB.updateReport(userBean, pirID, personName, rank, deptCode, incident_date,
					//incident_time_hh+":"+incident_time_mi, incident_place, incident_type, 
					//incident_classification,null,null)) {
			if (true) {
				String currentInfo[] = new String[99];
				PiReportDB.deleteInvolvePerson(userBean, pirID, null);
				if(patientInfo != null) {
					for(int i = 0; i < patientInfo.length; i++) {
						patientInfo[i] = TextUtil.parseStrUTF8(patientInfo[i]);
						//System.out.println("patientInfo: "+patientInfo[i]);
						
						currentInfo = splitInfo(patientInfo[i]);
						
						if(currentInfo[5] != null && currentInfo[5].length() > 0 && isInteger(currentInfo[5])) {
							if(PiReportDB.updateInvolvePatient(userBean, pirID, currentInfo[7],
									currentInfo[0], currentInfo[1], currentInfo[2],
									currentInfo[3], currentInfo[4],
									currentInfo[5], currentInfo[6])) {
								message = "Succeed in update involving patient";
							}
							else {
								errorMessage = "Error in update involving patient";
							}
						}
						else {
							if(PiReportDB.addInvolvePatient(userBean, pirID, currentInfo[0], 
									currentInfo[1], currentInfo[2], 
									currentInfo[3], currentInfo[4],
									currentInfo[5], currentInfo[6])) {
								message = "Succeed in add involving patient";
							}
							else {
								errorMessage = "Error in add involving patient";
							}
						}
					}
				}
				if(staffInfo != null) {
					for(int i = 0; i < staffInfo.length; i++) {
						staffInfo[i] = TextUtil.parseStrUTF8(staffInfo[i]);
						//System.out.println("staffInfo: "+staffInfo[i]);
						
						currentInfo = splitInfo(staffInfo[i]);

						if(currentInfo[7] != null && currentInfo[7].length() > 0 && isInteger(currentInfo[7])) {
							if(PiReportDB.updateInvolveStaff(userBean, pirID, currentInfo[7],
									(currentInfo[0].equals("true")?"1":"0"), currentInfo[1], 
									currentInfo[2], currentInfo[3], currentInfo[4], 
									currentInfo[5], currentInfo[6])) {
								message = "Succeed in update involving staff";
							}
							else {
								errorMessage = "Error in update involving staff";
							}
						}
						else {
							if(PiReportDB.addInvolveStaff(userBean, pirID, (currentInfo[0].equals("true")?"1":"0"), 
									currentInfo[1], currentInfo[2], currentInfo[3], currentInfo[4], 
									currentInfo[5], currentInfo[6])) {
								message = "Succeed in add involving staff";
							}
							else {
								errorMessage = "Error in add involving staff";
							}
						}
					}
				}
				if(visitorInfo != null) {
					for(int i = 0; i < visitorInfo.length; i++) {
						visitorInfo[i] = TextUtil.parseStrUTF8(visitorInfo[i]);
						//System.out.println("visitorInfo: "+visitorInfo[i]);
						
						currentInfo = splitInfo(visitorInfo[i]);

						if(currentInfo[7] != null && currentInfo[7].length() > 0 && isInteger(currentInfo[7])) {
							if (true) {
							//if(PiReportDB.updateInvolveVisitorOrRelatives(userBean, pirID,
									//currentInfo[7], (currentInfo[0].equals("true")?"1":"0"),
									//currentInfo[1], (currentInfo[2].equals("true")?"1":"0"),
									//currentInfo[3], currentInfo[4], currentInfo[5], currentInfo[6])) {
								message = "Succeed in update involving visitor";
							}
							else {
								errorMessage = "Error in update involving visitor";
							}
						}
						else {
							if (true) {						
							//if(PiReportDB.addInvolveVisitorOrRelatives(userBean, pirID, 
									//(currentInfo[0].equals("true")?"1":"0"), currentInfo[1], 
									//(currentInfo[2].equals("true")?"1":"0"),
									//currentInfo[3], currentInfo[4], currentInfo[5], currentInfo[6])) {
								message = "Succeed in add involving visitor";
							}
							else {
								errorMessage = "Error in add involving visitor";
							}
						}
					}
				}
				if(otherInfo != null) {
					for(int i = 0; i < otherInfo.length; i++) {
						otherInfo[i] = TextUtil.parseStrUTF8(otherInfo[i]);
						//System.out.println("otherInfo: "+otherInfo[i]);
						
						currentInfo = splitInfo(otherInfo[i]);

						if(currentInfo[3] != null && currentInfo[3].length() > 0 && isInteger(currentInfo[3])) {
							if (true) {
							//if(PiReportDB.updateInvolveOther(userBean, pirID, currentInfo[3], currentInfo[0], currentInfo[1], currentInfo[2])) {
								message = "Succeed in update involving other";
							}
							else {
								errorMessage = "Error in update involving other";
							}
						}
						else {
							if (true) {						
							//if(PiReportDB.addInvolveOther(userBean, pirID, currentInfo[0], 
									//currentInfo[1], currentInfo[2])) {
								message = "Succeed in add involving other";
							}
							else {
								errorMessage = "Error in add involving other";
							}
						}
					}
				}
				
				if(incident_type != null) {
					String moduleValue = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, incident_type+"_value"));
					if(moduleValue != null && moduleValue.length() > 0) {
						if(PiReportDB.deleteReportContent(userBean, pirID)) {
							String value[] = moduleValue.split("&#");
							
							for(int i = 0; i < value.length; i++) {
								String field[] = value[i].split("@#");
								//System.out.println(value[i]);
								if(field[2].equals("upload") && field[5].equals("undefined")&& !field[3].equals("undefined")) {
									if(fileUpload) {
										StringBuffer tempStrBuffer = new StringBuffer();
										tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
										tempStrBuffer.append(File.separator);
										tempStrBuffer.append("PIReport");
										tempStrBuffer.append(File.separator);
										tempStrBuffer.append(pirID);
										tempStrBuffer.append(File.separator);
										String baseUrl = tempStrBuffer.toString();
	
										tempStrBuffer.setLength(0);
										tempStrBuffer.append(File.separator);
										tempStrBuffer.append("upload");
										tempStrBuffer.append(File.separator);
										tempStrBuffer.append("PIReport");
										tempStrBuffer.append(File.separator);
										tempStrBuffer.append(pirID);
										String webUrl = tempStrBuffer.toString();
										
										FileUtil.moveFile(
												ConstantsServerSide.UPLOAD_FOLDER + File.separator + field[3].substring(field[3].lastIndexOf("\\")+1, field[3].length()),
												baseUrl + field[3].substring(field[3].lastIndexOf("\\")+1, field[3].length())
											);
										String documentID = "";
										if((documentID = DocumentDB.add(ConstantsServerSide.SITE_CODE, 
												userBean, "pireport", pirID, webUrl, field[3].substring(field[3].lastIndexOf("\\")+1, field[3].length()))) != null) {
											if(PiReportDB.addReportContent(userBean, pirID, field[1], documentID, field[4], field[0])) {
												message = "Succeed in upload document";
											}
											else {
												errorMessage = "Error in upload document";
											}
										}
										else {
											errorMessage = "Error in upload document";
										}
									}
								}
								else {
									if(!field[5].equals("undefined")) {
										if(PiReportDB.updateReportContent(userBean, pirID, field[5], field[3])) {
											message = "Succeed in update content";
										}
										else {
											errorMessage = "Error in update content";
										}
									}
									else {
										if(PiReportDB.addReportContent(userBean, pirID, field[1], field[3], field[4], field[0])) {
											message = "Succeed in save content";
										}
										else {
											errorMessage = "Error in save content";
										}
									}
								}
							}
						}
					}
				}
				
				if(errorMessage != null && errorMessage.length() > 0) {
					message = null;
				}
				else {
					message = "Succeed in update report";
				}
								
				updateAction = false;
				viewAction = true;
				command = "view";
			}
			else {
				errorMessage = "Error in update report";
			}
		}
		response.sendRedirect("incident_report.jsp?command=view&pirID="+pirID);
	}
	if(viewAction || editAction) {
		ArrayList record = PiReportDB.fetchReportBasicInfo(pirID);
		if(record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			
			pirID = row.getValue(0);
			personName = row.getValue(1);
			rank = row.getValue(2);
			deptCode = row.getValue(8);
			deptDesc = row.getValue(3);
			incident_date = row.getValue(4);
			incident_time_hh = row.getValue(5).substring(0, 2);
			incident_time_mi = row.getValue(5).substring(3, 5);
			incident_place = row.getValue(6);
			incident_type = row.getValue(7);
			incident_status = row.getValue(9);
			incident_classification = row.getValue(10);
			incident_classification_desc = row.getValue(11);
		}
		else {
			
		}
	}
}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
	Licensed to the Apache Software Foundation (ASF) under one or more
	contributor license agreements.  See the NOTICE file distributed with
	this work for additional information regarding copyright ownership.
	The ASF liCensus this file to You under the Apache License, Version 2.0
	(the "License"); you may not use this file except in compliance with
	the License.  You may obtain a copy of the License at

		 http://www.apache.org/liCensus/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<style>
div.confidential { 
	float:right;
	color:red;
}
div#report LABEL {
	color: black !important;
	font-weight: bold!important;
}
#incidentTypeForm TD {
	line-height:14pt !important;
}
#report {
	background-color: #CCCCCC;
}
#report .header {
	cursor: pointer;
	background: #D2449D !important;
	border-bottom-color: #E48FC4 !important;
	border-left-color: #E48FC4 !important;
	border-right-color: #E48FC4 !important;
	border-top-color: #E48FC4 !important;
	height:22px;
}
#report .header label {
}
.addFlw {
	cursor: pointer;
}
.alert {
	color: MediumSeaGreen!important;
}
.content-table td {
	border-width:0px!Important;
}
.reply-index td {
	border-width:0px!Important;
}
.selected {
	background: url("../images/ui-bg_highlight-soft_75_ffe45c_1x100.png") repeat-x scroll 50% 50% #F6F6F6 !important;
}
.scroll-pane
{
	width: 100%;
	height: 100%;
	overflow: auto;
}
div#menu {
	border: 2px solid;
	border-color: black;
}
div#content {
	border: 2px solid;
	border-color: black;
}
div.reportItem {
	cursor: pointer!important;
}
</style>
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>

<body>
<jsp:include page="../common/banner2.jsp" />
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
<%
  String title = "";
  if(createAction)
	  title = "function.pi.report.create";
  else if(editAction)
	  title = "function.pi.report.edit";
  else if(viewAction)
	  title = "function.pi.report.view";
  else
	  title = "function.pi.report.create";
  
  if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
  if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="keepReferer" value="Y" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="reportForm" id="form1" enctype="multipart/form-data" action="incident_report.jsp" method="post">

<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0" width="100%">
	<tr>
		<td colspan="2">
			<div class="confidential">
				<p style="font-size:20px"><b><i><u>* CONFIDENTIAL</u></i></b></p><br/>
				<p style="font-size:20px"><b><i><u>* Not part of Patient's Medical Record</u></i></b></p>
			</div>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="2">Reporting Person</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><font color="red">*</font>Name</td>
		<td class="infoData" width="70%">
<%
			if(viewAction) {
%>
				<%=personName==null?"":personName %>
<%
			}else {
%>
			<input type="textfield" name="reportPersonName" value="<%=personName==null?(editAction?"":userBean.getUserName()):personName %>" maxlength="100" size="50" class="notEmpty"/>
<%			} %>
		</td>
	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="30%"><font color="red">*</font>Rank</td>
		<td class="infoData" width="70%">
<%
			if(viewAction) {
%>
				<%=rank==null?"":rank %>
<%
			}else {
%>
			<input type="textfield" name="reportPersonRank" value="<%=rank==null?"":rank %>" maxlength="100" size="50"/>
<%			} %>
		</td>
	</tr>
	<tr class="smallText" id="cp_Department">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%">
<%
			if(viewAction) {
%>
				<%=deptDesc==null?"":deptDesc %>
<%
			}else {
%>
			<select name="deptCode" class="notEmpty">
				<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
					<jsp:param name="deptCode" value='<%=deptCode==null?userBean.getDeptCode():deptCode %>' />
					<jsp:param name="allowAll" value="Y" />
				</jsp:include>
			</select>
<%			} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="2">Incident Information</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Date of Occurrence</td>
		<td class="infoData" width="70%">
<%
			if(viewAction) {
%>
				<%=incident_date==null?"":incident_date %>
<%
			}else {
%>
			<input type="textfield" name="occurDate" id="occurDate" class="datepickerfield notEmpty" 
				value='<%=incident_date==null?"":incident_date %>' maxlength="10" size="16"/>
<%			} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Time of Occurrence</td>
		<td class="infoData" width="70%">
<%
			if(viewAction) {
%>
				<%=(incident_time_hh==null||incident_time_mi==null)?"":(incident_time_hh+":"+incident_time_mi) %>
<%
			}else {
%>
			<jsp:include page="../ui/timeCMB.jsp" flush="false">
				<jsp:param name="label" value="timeOfOccurrence" />
				<jsp:param name="time" value='<%=((incident_time_hh==null||incident_time_mi==null)?"":(incident_time_hh+":"+incident_time_mi)) %>' />
				<jsp:param name="allowEmpty" value="N" />
			</jsp:include>
<%			} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Place of Occurrence</td>
		<td class="infoData" width="70%">
<%
			if(viewAction) {
%>
				<%=incident_place==null?"":incident_place %>
<%
			}else {
%>
			<select name="placeOfOccur" class="notEmpty">
				<jsp:include page="../ui/piLocationCMB.jsp" flush="false">											
					<jsp:param name="type" value="place_of_occurrence" />
					<jsp:param name="value" value="<%=incident_place%>" />
					<jsp:param name="allowEmpty" value="Y" />
				</jsp:include>				
			</select>
<%			} %> 
		</td>
	</tr>
<%
	if(!viewAction) {
%>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="2">Involving Person</td>
	</tr>
	<tr class="smallText">
		<td class="infoData" colspan="2">
			<table width="80%">
			 <tr>
				<td width="20%"><a href="javascript:showInfo('patient');"><img src="../images/plus.gif" width="10" height="10">Patient</a></td>
				<td width="20%"><a href="javascript:showInfo('staff');"><img src="../images/plus.gif" width="10" height="10">Staff</td>
				<td width="20%"><a href="javascript:showInfo('visitor');"><img src="../images/plus.gif" width="10" height="10">Visitor/Relative</td>
				<td width="20%"><a href="javascript:showInfo('other');"><img src="../images/plus.gif" width="10" height="10">Other</td>
			</tr>
		 	</table>
		</td>
	</tr>
<%	} %> 
	<tr class="smallText">
<%
	if(viewAction || editAction) {
%>
		<td colspan="2">
			<jsp:include page="../pi/hiddenInvolvePerson.jsp" flush="false">
				<jsp:param name="action" value='<%=(viewAction)?"view":"edit" %>' />
				<jsp:param name="pirID" value="<%=pirID %>" />
			</jsp:include>
		</td>
<%
	}else {
%>
		<td colspan="2">
			<div id="involvedPartyInfoPatient">
			</div>
			<div id="involvedPartyInfoStaff">
			</div>
			<div id="involvedPartyInfoVisitor">
			</div>
			<div id="involvedPartyInfoOther">
			</div>
		</td>
<%	} %> 
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="2">Incident Classification</td>
	</tr>
	<tr class="smallText">
		<td class="infoData" colspan="2">
			<table width="100%">
				<tr	>
<%	if(viewAction) { %>
					<td>
						<%=incident_classification!=null?incident_classification_desc:"" %>
					</td>
<%	} else { %>
					<jsp:include page="../ui/piClassificationCMB.jsp" flush="false">
						<jsp:param name="value" value="<%=incident_classification %>" />
						<jsp:param name="incidentType" value="<%=incident_type %>" />
					</jsp:include>
<%	} %>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2">
			<div id="incidentTypeForm">
<%
			if(editAction) {
%>
				<jsp:include page="../pi/report_content.jsp" flush="false">
					<jsp:param name="action" value="edit" />
					<jsp:param name="pirID" value="<%=pirID %>" />
					<jsp:param name="incidentType" value="<%=incident_type %>" />
				</jsp:include>
<%
			}
			else if(viewAction) {
%>
				<jsp:include page="../pi/report_content.jsp" flush="false">
					<jsp:param name="action" value="view" />
					<jsp:param name="pirID" value="<%=pirID %>" />
					<jsp:param name="incidentType" value="<%=incident_type %>" />
				</jsp:include>
<%	
			}
%>
			</div>
		</td>
	</tr>
</table>
<input type="hidden" name="command" value="<%=command%>"/>
<input type="hidden" name="selectedIncidentType" value="<%=incident_type%>"/>
<input type="hidden" name="pirID" value="<%=pirID %>"/>
<%	if(viewAction) { %>
	<%-- 
	<jsp:include page="../pi/furtherAction2.jsp" flush="false">
		<jsp:param name="pirID" value="<%=pirID %>" />
		<jsp:param name="status" value="<%=incident_status%>" />
		<jsp:param name="command" value="<%=command%>" />
		<jsp:param name="fileUpload" value="<%=fileUpload%>" />
	</jsp:include>
	--%>
<%	} %> 
</form>
<br/>

<script language="javascript">
var editAction = false;
var viewAction = false;
var checkList = new Array();
var apis = [];

$(document).ready(function() {
	setInterval("animation()",1000);
	selectClassEvent();
	var command = $('input[name=command]').val();
	if(command == 'edit') {
		editAction = true;
	}
	else if(command == 'view') {
		viewAction = true;
	}
	$('input[name=command]').val('');
	
	if(viewAction) {
		//handleIncludePage();
		headerEvent();
		$('#report .header').trigger('click');
	}
	else if(editAction) {
		editAction = true;
		addEvent('.AddInvolvePatientInfo', 'patient');
		resetDatepicker(true);
		addEvent('.AddInvolveStaffInfo', 'staff');
		addEvent('.AddInvolveVisitorInfo', 'visitor');
		addEvent('.AddInvolveOthersInfo', 'other');
		removeEvent();
		//handleIncludePage();
		resetDatepicker(false);
		headerEvent();
		$('#report .content-frame').each(function(i, v){
			if($(this).find('[contentId]').length > 0) {
				$(this).prev().trigger('click');
			}
		});
		$('div #removeImage').each(function(i, v) {
			if($(this).parent().find('[contentId]').length > 0) {
				if(!($(this).parent().find('.copy').length > 0)) {
					$(this).remove();
				}
				else {
					if(!($(this).next().find('tr').length > 0)) {
						$(this).next().remove();
						$(this).remove();
					}
				}
			}
			else {
				$(this).remove();
			}
		});
		involveVisitorInfoEvent();
		referKeyEvent();
	}
	else {
		alert('* CONFIDENTIAL\n* Not part of Patient\'s Medical Record');
	}
	
	$('table').each(function(i, v) {
		if(!($(this).find('tr').length > 0)) {
			$(this).remove();
		}
	});
});

function animation() {
	$('div.confidential').animate( { backgroundColor: 'yellow' }, 500)
    	.animate( { backgroundColor: 'white' }, 500);
}

function resetDatepicker(patient) {
	if(patient) {
		var count = $('.involvedPartyInfoPatient').length;
		$('.involvedPartyInfoPatient:last').find('.datepickerfield').each(function(i, v) {
			$(this).datepicker("destroy");
			$(this).attr('id', count);
			$(this).datepicker({
		    	showOn: "button",
				buttonImage: "../images/calendar.jpg",
				buttonImageOnly: true
			});
		});
	}
	else {
		var currentCount = 0;
		$('#report .datepickerfield').each(function(i, v) {
			$(this).datepicker('destroy');
			currentCount += 1;
			$(this).attr('id', $(this).attr('optid')+currentCount);
			$(this).datepicker({
		    	showOn: "button",
				buttonImage: "../images/calendar.jpg",
				buttonImageOnly: true
			});
		});
	}
}

function headerEvent() {
	$('#report .header').unbind('click');
	$('#report .header').click(function() {
   	 	$(this).next().toggle();
   	 	if($(this).find('div.toggleLabel').html().indexOf('Open') > -1) {
   	 		$(this).find('div.toggleLabel').html('<img src="../images/module-collapse.png"/><b><u>Close</u></b>');
   	 	}
   	 	else {
   	 		$(this).find('div.toggleLabel').html('<img src="../images/module-expand.png"/><b><u>Open</u></b>');
   	 	}
    	return false;
	}).next().hide();
	$('#report .header').find('div.toggleLabel').html('<img src="../images/module-expand.png"/><b><u>Open</u></b>');
}

function removeEvent() {
	$('.removeInvolvePatientInfo').unbind('click');
	$('.removeInvolvePatientInfo').each(function() {
		$(this).click(function() {
			$(this).parent().parent().parent().parent().remove();
		});
	});
}

function involveVisitorInfoEvent() {
	$('input[name=visitorOfPat]').each(function(i, v) {
		$(this).unbind('click');
		$(this).click(function() {
			if($(this).attr('checked')) {
				$(this).parent().parent().find('input[name=involveVisitPatNo]').addClass('notEmpty');
			}
			else {
				$(this).parent().parent().find('input[name=involveVisitPatNo]').removeClass('notEmpty');
			}
		});
	});
	$('input[name=involveVisitPatNo]').each(function(i, v) {
		$(this).unbind('blur');
		$(this).blur(function() {
			if($(this).val().length > 0) {
				$(this).parent().parent().find('input[name=visitorOfPat]').attr('checked', true);
			}
			else {
				$(this).parent().parent().find('input[name=visitorOfPat]').attr('checked', false);
			}
		});
	});
	$('input[name=visitorOfStaff]').each(function(i, v) {
		$(this).unbind('click');
		$(this).click(function() {
			if($(this).attr('checked')) {
				$(this).parent().parent().find('input[name=involveVisitStaffNo]').addClass('notEmpty');
			}
			else {
				$(this).parent().parent().find('input[name=involveVisitStaffNo]').removeClass('notEmpty');
			}
		});
	});
	$('input[name=involveVisitStaffNo]').each(function(i, v) {
		$(this).unbind('blur');
		$(this).blur(function() {
			if($(this).val().length > 0) {
				$(this).parent().parent().find('input[name=visitorOfStaff]').attr('checked', true);
			}
			else {
				$(this).parent().parent().find('input[name=visitorOfStaff]').attr('checked', false);
			}
		});
	});
}

function addEvent(target, type){
	$(target).each(function() {
		$(this).unbind('click');
		$(this).click(function() {
			showInfo(type);
		});
	});
}

function showInfo(type){
	var addBtn = '';
		if (type == 'patient') {
			Row = $('div#hiddenInvolvePatientInfo').html();
			$('<div class="involvedPartyInfoPatient">'+Row+'</div>').appendTo('div#involvedPartyInfoPatient');
			addBtn = '.AddInvolvePatientInfo';
			resetDatepicker(true);
		}
		if(type == 'staff'){
			Row = $('div#hiddenInvolveStaffInfo').html();
			$('<div class="involvedPartyInfoStaff">'+Row+'</div>').appendTo('div#involvedPartyInfoStaff');
			addBtn = '.AddInvolveStaffInfo';
		}
		if(type == 'visitor'){
			Row = $('div#hiddenInvolveVisitorInfo').html();
			$('<div class="involvedPartyInfoVisitor">'+Row+'</div>').appendTo('div#involvedPartyInfoVisitor');
			addBtn = '.AddInvolveVisitorInfo';
			involveVisitorInfoEvent();
		}
		if(type == 'other'){
			Row = $('div#hiddenInvolveOthersInfo').html();
			$('<div class="involvedPartyInfoOther">'+Row+'</div>').appendTo('div#involvedPartyInfoOther');
			addBtn = '.AddInvolveOthersInfo';
		}
		addEvent(addBtn, type);
		removeEvent();
		referKeyEvent();
}

function selectClassEvent() {
	$('input[name=incidentClass]').click(function() {
		 var type = $(this).attr('incidentType');
		 if(editAction) {
			 return;
		 }
		 $('input[name=selectedIncidentType]').val(type);
		 
		 $.ajax({
			 type: "POST",
			 url: "report_content.jsp?incidentType="+type,
			 async: true,
			 cache: false,
			 success: function(values){
				 if(values != '') {
					 $("#incidentTypeForm").html(values).css('display', 'none');
					 headerEvent();
					 resetDatepicker(false);
					 makeCheckList();
					 submitEvent();
					 //$('div.reportContent').appendTo('div#content-container');
					 //initScroll('div#report', false);
					 $("#incidentTypeForm").css('display', '');
					 //selectReportItemEvent();
					 //$('div#report .scroll-pane').data('jsp').reinitialise();
				 }
			 }//success
		 });//$.ajax
	});
}

function selectReportItemEvent() {
	$('div#menu .reportItem').click(function() {
		 $('div#content .jspPane').find('div.reportContent')
		 	.appendTo('div#content-container').css('display', 'none');
		 $('div#content-container').find('div#'+$(this).attr('grpID'))
		 	.appendTo($('div#content .jspPane')).css('display', '');
		 $('div#content div:first').data('jsp').reinitialise();
	 });
}

function mergeInvolePersonInfo() {
	var personInfo = '';
	
	$('.involvedPartyInfoPatient').each(function(index, value) {
		if($(this).children().size() > 0) {
			personInfo = '<input type="hidden" name="isPatientInfo" value="'+
								$(this).find('[name=patHosNo]').val()+'||'+
								$(this).find('[name=patName]').val()+'||'+
								$(this).find('[name=patSex] option:selected').val()+'||'+
								$(this).find('[name=patAge]').val()+'||'+
								$(this).find('[name=patDOB]').val()+'||'+
								$(this).find('[name=attPhy]').val()+'||'+
								$(this).find('[name=diagnosis]').val()
								+((editAction)?('||'+$(this).find('[name=pir_ip_id]').val()):"")
							+'">';	
			
			$(personInfo).appendTo('div#involvedPartyInfoPatient');
		}
	});
	
	$('.involvedPartyInfoStaff').each(function(index, value) {
		if($(this).children().size() > 0) {
			personInfo = '<input type="hidden" name="isStaffInfo" value="'+
								$(this).find('[name=sameAsReport]').attr('checked')+'||'+
								$(this).find('[name=involveStaffNo]').val()+'||'+
								$(this).find('[name=involeStaffHosNo]').val()+'||'+
								$(this).find('[name=involveStaffName]').val()+'||'+
								$(this).find('[name=involveStaffRank]').val()+'||'+
								$(this).find('[name=involveStaffDept] option:selected').val()+'||'+
								$(this).find('[name=involveStaffSex] option:selected').val()
								+((editAction)?('||'+$(this).find('[name=pir_ip_id]').val()):"")
							+'"/>';	
		
			$(personInfo).appendTo('div#involvedPartyInfoStaff');
		}
	});
	
	$('.involvedPartyInfoVisitor').each(function(index, value) {
		if($(this).children().size() > 0) {
			personInfo = '<input type="hidden" name="isVisitorInfo" value="'+
								$(this).find('[name=visitorOfPat]').attr('checked')+'||'+
								$(this).find('[name=involveVisitPatNo]').val()+'||'+
								$(this).find('[name=visitorOfStaff]').attr('checked')+'||'+
								$(this).find('[name=involveVisitStaffNo]').val()+'||'+
								$(this).find('[name=involveVisitorName]').val()+'||'+
								$(this).find('[name=involveVisitorRelationship]').val()+'||'+
								$(this).find('[name=involveVisitorRemark]').val()
								+((editAction)?('||'+$(this).find('[name=pir_ip_id]').val()):"")
							+'"/>';	
							
			$(personInfo).appendTo('div#involvedPartyInfoVisitor');
		}
	});
	
	$('.involvedPartyInfoOther').each(function(index, value) {
		if($(this).children().size() > 0) {
			personInfo = '<input type="hidden" name="isOtherInfo" value="'+
								$(this).find('[name=involveOthersStatus] option:selected').val()+'||'+
								$(this).find('[name=involveOtherName]').val()+'||'+
								$(this).find('[name=involveOtherRemark]').val()
								+((editAction)?('||'+$(this).find('[name=pir_ip_id]').val()):"")
							+'"/>';	
							
			$(personInfo).appendTo('div#involvedPartyInfoOther');
		}
	});
}

function findGrpId(dom) {
	var temp = dom.parent();
	
	while(!$(temp).attr('contentGrpID')) {
		temp = temp.parent();
	} 
	
	return $(temp).attr('contentGrpID');
}

function handleReportContent() {
	var report = $('div#report');
	var hiddenInput = $('input[name='+$('input[name=selectedIncidentType]').val()+'_value]');
	var hiddenInputVal = hiddenInput.val();

	report.find('[optType=checkbox]:checked').each(function(i, v) {		
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#checkbox@#checked@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		checkValue($(this).attr('category'));
	});
	report.find('[optType=checkInput]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#checkInput@#'+
							$(this).next().val()+'@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		checkValue($(this).attr('category'));
	});
	report.find('[optType=yesNo]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#yesNo@#'+
							$(this).val()+'@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		checkValue($(this).attr('category'));
	});
	report.find('[optType=input]').each(function(i, v) {
		if($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('id')+'@#input@#'+
								$(this).val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=textarea]').each(function(i, v) {
		if($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('id')+'@#textarea@#'+
								$(this).val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=checkboxInput]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#checkboxInput@#'+
							$(this).next().val()+'@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		checkValue($(this).attr('category'));
	});
	report.find('[optType=radio]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#radio@#checked@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		checkValue($(this).attr('category'));
	});
	report.find('[optType=date]').each(function(i, v) {
		if($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('optid')+'@#date@#'+
								$(this).val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=datetime]').each(function(i, v) {
		if($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('optid')+'@#datetime@#'+
								$(this).val()+' '+
								$(this).parent().find('select[name='+$(this).attr('optid')+'_hh] option:selected').val()+':'+
								$(this).parent().find('select[name='+$(this).attr('optid')+'_mi] option:selected').val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=upload]').each(function(i, v) {
		if($(this).attr('contentId') || $(this).find('input').val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('id')+'@#upload@#'+
								($(this).attr('contentId')?$(this).attr('docIDs'):$(this).find('input').val())+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			checkValue($(this).attr('category'));
		}
	});
	if(checkList.length > 0) {
		return false;
	}
	
	hiddenInput.val(hiddenInputVal);
	return true;
}

function checkValue(category) {
	if(checkList.length > 0) {
		$.each(checkList, function(i, v) {
			if(v == category) {
				checkList.splice(i, 1);
				return true;
			}
		});
	}else {
		return true;
	}
}

function makeCheckList() {
	var must = $('input[name=incidentClass]:checked').attr('must');
	checkList = new Array();
	if(must) {
		var info = must.split(';');
		$.each(info, function(i, v) {
			if(v.length > 0)
				checkList.splice(checkList.length, 0, v);
		});
	}
}

function delPasteDom(dom) {
	var delDom = $(dom).parent().next();
	
	delDom.remove();
	$(dom).parent().remove();
}

function copyAndPasteDom(dom) {
	var copyDom = $(dom).parent().find('table');
	var currentCount = $(dom).parent().find('table').attr('count');
	
	$('<div style="float:right;" id="removeImage">'+
		'<img src="../images/delete1.png" style="cursor:pointer" onclick="delPasteDom(this)"/>'+
		'</div>').appendTo($(dom).parent().parent());
	
	var grpId = -1;
	
	if($(dom).parent().parent().find('table:last').attr('contentGrpID')) {
		grpId = $(dom).parent().parent().find('table:last').attr('contentGrpID');
	}
	
	copyDom.clone().appendTo($(dom).parent().parent());
	
	$(dom).parent().parent().find('table:last').attr('contentGrpID', parseInt(grpId)+1);
	
	$(dom).parent().parent().find('.datepickerfield').each(function(i, v) {
		$(this).datepicker('destroy');
		currentCount += 1;
		$(this).attr('id', $(this).attr('optid')+currentCount);
		$(this).datepicker({
	    	showOn: "button",
			buttonImage: "../images/calendar.jpg",
			buttonImageOnly: true
		});
	});
}

function goToHeaderEvent() {
	alert("Please fill all required information!");
	headerEvent();
	$('#report .header').find('.alert').html('');
	$.each(checkList, function(i, v) {
		$('#report [grpID='+v+']').trigger('click');
		$('#report [grpID='+v+']').find('.alert').html("<img src='../images/alert_general.gif' style='width:15px; height:15px;'/><b>This information is required.</b>");
	});
	
	$(window).scrollTop($('#report [grpID='+checkList[0]+']').next().position().top);
	makeCheckList();
	return false;
}

function checkRequiredInfo() {
	var hasEmpty = false;
	
	$('form#form1').find('div.alert').remove();
	$('form#form1').find('.notEmpty').each(function(i, v) {
		if(this.tagName.toLowerCase() == 'input') {
			if($(this).val().length <= 0) {
				$(this).after("<div class='alert'><img src='../images/alert_general.gif' style='width:15px; height:15px;'/>This information is required.</div>");
				hasEmpty = true;
			}
		}
		else if(this.tagName.toLowerCase() == 'textarea') {
			if($(this).val().length <= 0) {
				$(this).after("<div class='alert'><img src='../images/alert_general.gif' style='width:15px; height:15px;'/>This information is required.</div>");
				hasEmpty = true;
			}
		}
		else if(this.tagName.toLowerCase() == 'select') {
			if($(this).find('option:selected').val().length <= 0) {
				$(this).after("<div class='alert'><img src='../images/alert_general.gif' style='width:15px; height:15px;'/>This information is required.</div>");
				hasEmpty = true;
			}
		}
	});
	
	return hasEmpty;
}

function initScroll(target, autoReinitialise) {
	//destroyScroll();
	$(target).find('.scroll-pane').each(
			function()
			{
				apis.push($(this).jScrollPane({autoReinitialise:autoReinitialise}).data().jsp);
			}
		);
	return false;
}

function destroyScroll() {
	if (apis.length) {
		$.each(
			apis,
			function(i) {
				this.destroy();
			}
		);
		apis = [];
	}
	return false;
}

function referKeyEvent() {
	$('.referKey').unbind('blur');
	$('.referKey').blur(function() {
		getRelatedInfo($(this).attr('keyType'), $(this).val(), $(this));
	});
}

function getRelatedInfo(type, key, dom) {
	while(!$(dom).is('table')) {
		dom = $(dom).parent();
	}
	
	if(type == 'patient') {
		$.ajax({
			url: "../ui/patientInfoCMB.jsp?callback=?",
			data: "patno="+key,
			dataType: "jsonp",
			cache: false,
			success: function(values){
				$(dom).find('input[name=patName]').val(values['PATNAME']);
				$(dom).find('select[name=patSex]')
					.find('option[value='+values['PATSEX']+']').attr('selected', true);
				$(dom).find('input[name=patAge]').val(values['AGE']);
				$(dom).find('input[name=patDOB]').val(values['PATBDATE']);
			},
			error: function(x, s, e) {
				$(dom).find('input[name=patHosNo]').val('');
				$(dom).find('input[name=patName]').val('');
				$(dom).find('input[name=patAge]').val('');
				$(dom).find('input[name=patDOB]').val('');
				$(dom).find('select[name=patSex]')[0].selectedIndex = 0;
				if(key.length > 0)
					alert("No Such Patient!");
			}
		});
	}
	else if(type == 'staff') {
		$.ajax({
			url: "../ui/staffInfoCMB.jsp?callback=?",
			data: "staffid="+key,
			dataType: "jsonp",
			cache: false,
			success: function(values){
				$(dom).find('input[name=involveStaffNo]').val(key);
				$(dom).find('input[name=involeStaffHosNo]').val(values['PATNO']);
				$(dom).find('select[name=involveStaffSex]')
					.find('option[value='+values['STAFFSEX']+']').attr('selected', true);
				$(dom).find('input[name=involveStaffName]').val(values['STAFFNAME']);
				$(dom).find('select[name=involveStaffDept]')
					.find('option[value='+values['DEPTCODE']+']').attr('selected', true);
			},
			error: function(x, s, e) {
				$(dom).find('input[name=involeStaffHosNo]').val('');
				$(dom).find('input[name=involveStaffName]').val('');
				$(dom).find('select[name=involveStaffSex]')[0].selectedIndex = 0;
				$(dom).find('select[name=involveStaffDept]')[0].selectedIndex = 0;
				$(dom).find('input[name=involveStaffNo]').val('');
				$(dom).find('input[name=sameAsReport]').attr('checked', false);
				if(key.length > 0)
					alert("No Such Staff!");
			}
		});
	}
}

function submitEvent() {
	$('button.reportSubmit').click(function() {
		submitAction($(this).attr('submitType'));
		return false;
	});
}

function submitAction(command) {
	if(command == 'create') {
		if(checkRequiredInfo()) {
			$(window).scrollTop($('div.alert:first').parent().parent().parent().position().top);
			return false;
		}
		if(!handleReportContent()) {
			goToHeaderEvent();
			return false;
		}
		mergeInvolePersonInfo();
	}
	else if(command == 'edit') {
		
	}
	else if(command == 'update') {
		if(checkRequiredInfo()) {
			$(window).scrollTop($('div.alert:first').parent().parent().parent().position().top);
			return false;
		}
		if(!handleReportContent()) {
			goToHeaderEvent();
			return false;
		}
		mergeInvolePersonInfo();
	}
	else if(command.indexOf('view') > -1) {
		handleFlwContent();
	}
	$('input[name=command]').val(command);
	document.reportForm.submit();
	return false;
}
</script>
</DIV></DIV></DIV>
	<jsp:include page="../pi/hiddenInvolvePerson.jsp" flush="false"/>
	<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>