<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.crm.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="org.apache.struts.Globals" %>

<%@ page import="java.io.*"%>
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
String command = ParserUtil.getParameter(request, "command");
String clientID = ParserUtil.getParameter(request, "clientID");
String useClientID = ParserUtil.getParameter(request, "useClientID");
String userType =  ParserUtil.getParameter(request, "userType");

String lastName = TextUtil.parseStr(ParserUtil.getParameter(request, "lastName")).toUpperCase();
String firstName = TextUtil.parseStr(ParserUtil.getParameter(request, "firstName")).toUpperCase();
String chineseName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "chineseName"));
String title = ParserUtil.getParameter(request, "title");
String religion = ParserUtil.getParameter(request, "religion");
String sex = ParserUtil.getParameter(request, "sex");

String dob_dd = ParserUtil.getParameter(request, "dob_dd");
String dob_mm = ParserUtil.getParameter(request, "dob_mm");
String dob_yy = ParserUtil.getParameter(request, "dob_yy");
String decease_dd = ParserUtil.getParameter(request, "decease_dd");
String decease_mm = ParserUtil.getParameter(request, "decease_mm");
String decease_yy = ParserUtil.getParameter(request, "decease_yy");
String ageGroup = ParserUtil.getParameter(request, "ageGroup");
String educationLevelID = ParserUtil.getParameter(request, "educationLevelID");
String occupationID = ParserUtil.getParameter(request, "occupationID");
String hkid = TextUtil.parseStr(ParserUtil.getParameter(request, "hkid")).toUpperCase();
String passport = TextUtil.parseStr(ParserUtil.getParameter(request, "passport")).toUpperCase();

String street1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "street1"));
String street2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "street2"));
String street3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "street3"));
String street4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "street4"));
String districtID = ParserUtil.getParameter(request, "districtID");
String areaID = ParserUtil.getParameter(request, "areaID");
String countryID = ParserUtil.getParameter(request, "countryID");
String language = ParserUtil.getParameter(request, "language");

String homeNumber = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "homeNumber"));
String officeNumber = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "officeNumber"));
String mobileNumber = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mobileNumber"));
String faxNumber = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "faxNumber"));

String email = ParserUtil.getParameter(request, "email");
String emergencyContactPerson = ParserUtil.getParameter(request, "emergencyContactPerson");
String emergencyContactNumber = ParserUtil.getParameter(request, "emergencyContactNumber");
String emergencyContactRelationship = ParserUtil.getParameter(request, "emergencyContactRelationship");
String faceBook = ParserUtil.getParameter(request, "faceBook");

String income = ParserUtil.getParameter(request, "income");
String willingPromotion = ParserUtil.getParameter(request, "willingPromotion");
String preferContactMethod = ParserUtil.getParameter(request, "preferContactMethod");

String message = TextUtil.parseStr(ParserUtil.getParameter(request, "message"));
String errorMessage = "";

String clientGroupID = ParserUtil.getParameter(request, "clientGroupID");

String clientPhoto= TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "clientPhoto"));
String prevPhotoName= TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "prevPhotoName"));

String[] fileList = (String[]) request.getAttribute("filelist");
if (fileList != null) {
	StringBuffer tempStrBuffer = new StringBuffer();

	tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
	tempStrBuffer.append(File.separator);
	tempStrBuffer.append("CRM");
	tempStrBuffer.append(File.separator);
	tempStrBuffer.append("client_photo");
	tempStrBuffer.append(File.separator);
	tempStrBuffer.append(clientID);
	tempStrBuffer.append(File.separator);
	String baseUrl = tempStrBuffer.toString();

	tempStrBuffer.setLength(0);

	for (int i = 0; i < fileList.length; i++) {
		//System.out.println(ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i]);
		//System.out.println(baseUrl + fileList[i]);
		FileUtil.moveFile(
			ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
			baseUrl + fileList[i]
		);
	};
}

boolean updateAction = false;
boolean closeAction = false;
boolean viewAction = false;
boolean updateViewAction = false;

Locale locale = (Locale) session.getAttribute(Globals.LOCALE_KEY);

if ("update".equals(command)) {
	updateAction = true;
}else if ("view".equals(command)) {
	viewAction = true;
}else if("updateView".equals(command)){
	viewAction = true;
	updateViewAction = true;
}

try{
	viewAction = true;
	if (viewAction || updateAction) {
		if (userBean != null) {		
			 if (updateAction) {				 
					if (CRMClientDB.update(userBean,
							clientID,
							lastName, firstName,
							chineseName, title, religion, sex,
							dob_yy, dob_mm, dob_dd,
							decease_yy, decease_mm, decease_dd,
							ageGroup, educationLevelID, occupationID, hkid, passport,
							street1, street2, street3, street4, districtID, areaID, countryID,
							language, homeNumber, officeNumber, mobileNumber, faxNumber,
							email, emergencyContactPerson, emergencyContactNumber, emergencyContactRelationship,
							faceBook, income, willingPromotion, preferContactMethod,
							null,(clientPhoto!=null&&clientPhoto.length()>0?clientPhoto:prevPhotoName))) {
						message = "Client updated.";
						updateAction = false;
						
					} else {
						errorMessage = "Client update fail.";
					}
				}			
			
			ArrayList record;
			if("Y".equals(useClientID)){
				record = CRMClientDB.get( clientID,null);
			}else{
				record = CRMClientDB.get(null, userBean.getLoginID());
			}
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				// assign value from database
				lastName = row.getValue(0);
				firstName = row.getValue(1);
				chineseName = row.getValue(2);
				title = row.getValue(3);
				religion = row.getValue(4);
				sex = row.getValue(5);

				dob_yy = row.getValue(6);
				dob_mm = row.getValue(7);
				dob_dd = row.getValue(8);
				decease_yy = row.getValue(9);
				decease_mm = row.getValue(10);
				decease_dd = row.getValue(11);
				ageGroup = row.getValue(12);
				educationLevelID = row.getValue(13);
				occupationID = row.getValue(14);
				hkid = row.getValue(15);
				passport = row.getValue(16);

				street1 = row.getValue(17);
				street2 = row.getValue(18);
				street3 = row.getValue(19);
				street4 = row.getValue(20);
				districtID = row.getValue(21);
				areaID = row.getValue(22);
				countryID = row.getValue(23);
				language = row.getValue(24);

				homeNumber = row.getValue(25);
				officeNumber = row.getValue(26);
				mobileNumber = row.getValue(27);
				faxNumber = row.getValue(28);
				email = row.getValue(29);
				emergencyContactPerson = row.getValue(30);
				emergencyContactNumber = row.getValue(31);
				emergencyContactRelationship = row.getValue(32);

				faceBook = row.getValue(33);
				income = row.getValue(34);
				willingPromotion = row.getValue(35);
				preferContactMethod = row.getValue(36);
				clientGroupID = row.getValue(44);
				clientID = row.getValue(46);
				clientPhoto = row.getValue(48);
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
	if(updateViewAction == true){
		viewAction = true;
		updateAction = true;
	}
}
catch (Exception e) {
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="header.jsp"/>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
	<DIV id=contentFrame style="width:100%;height:100%">
				<jsp:include page="../../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="Basic Information" />
					<jsp:param name="category" value="group.crm" />
					<jsp:param name="keepReferer" value="N" />
					<jsp:param name="isHideTitle" value="Y" />
				</jsp:include>	
				<jsp:include page="title.jsp">
					<jsp:param name="title" value="function.crm.portal.basicInfo"/>
					<jsp:param name="isFunction" value="Y"/>
				</jsp:include>
				
				<font color="blue"><%=message %></font>
				<font color="red"><%=errorMessage %></font>
				<form name="form1" enctype="multipart/form-data"  action="basic_info.jsp" method="post">
					<table cellpadding="0" cellspacing="5"
							class="contentFrameMenu" border="0" style='width:100%'>
						
							
						<tr class="smallText">
							<td align="center" colspan="4">
								<span id="matchTable_indicator"/>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoTitle" colspan="4">
								<bean:message key="label.crm.personalInformation"/>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="label.crm.lastName"/>								
							</td>
							<td class="infoData" width="35%" id="lastName_field">
							<%	if ( updateAction) { %>
								<input type="textfield" name="lastName" value="<%=lastName==null?"":lastName %>" maxlength="30" size="25" onblur="javascript:checkDOBLastName(this);"><span id="lastName_indicator">
							<%	} else { %>
								<%=lastName==null?"":lastName %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="label.crm.firstName" />
							</td>
							<td class="infoData" width="35%">
							<%	if ( updateAction) { %>
								<input type="textfield" name="firstName" value="<%=firstName==null?"":firstName %>" maxlength="60" size="25">
							<%	} else { %>
								<%=firstName==null?"":firstName %>
							<%	} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="label.crm.chineseName" />
							</td>
							<td class="infoData" width="35%">
							<%	if ( updateAction) { %>
								<input type="textfield" name="chineseName" value="<%=chineseName==null?"":chineseName %>" maxlength="20" size="25">
							<%	} else { %>
								<%=chineseName==null?"":chineseName %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="adm.title" />
							</td>
							<td class="infoData" width="35%">
							<%	if ( updateAction) { %>
								<select name="title">
									<jsp:include page="../../ui/parameterCMB.jsp" flush="false">
										<jsp:param name="parameterType" value="title" />
										<jsp:param name="parameterValue" value="<%=title %>" />
									</jsp:include>
								</select>
							<%	} else { %>
										<%=ParameterHelper.getTitleValue(session, title) %>
							<%	} %>
							</td>
						</tr>
						<%--allow view --%>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.religion" />
							</td>
							<td class="infoData" width="35%">
							<%	if (updateAction) { %>
								<select name="religion">
									<jsp:include page="../../ui/parameterCMB.jsp" flush="false">
										<jsp:param name="parameterType" value="religion" />
										<jsp:param name="parameterValue" value="<%=religion %>" />
									</jsp:include>
								</select>
							<%	} else { %>
								<%=ParameterHelper.getReligionValue(session, religion) %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.sex" />
							</td>
							<td class="infoData" width="35%">
							<%	if ( updateAction) { %>
								<select name="sex">
									<jsp:include page="../../ui/sexCMB.jsp" flush="false">
										<jsp:param name="sex" value="<%=sex %>" />
										<jsp:param name="allowEmpty" value="Y" />
									</jsp:include>
								</select>
							<%	} else { %>
									<%if ("M".equals(sex)) { %><bean:message key="label.male" /><%} else if ("F".equals(sex)) { %><bean:message key="label.female" /><%} else { %><bean:message key="label.unknown" /><%} %>
							<%	} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.dateOfBirth" /><br>(DD/MM/YYYY)
							</td>
							<td class="infoData" width="35%" id="dob_field">
							<%	if (updateAction) { %>
								<input type="textfield" name="dob_dd" value="<%=dob_dd==null?"":dob_dd %>" maxlength="2" size="2" onblur="javascript:checkDOBLastName(this);">/
								<input type="textfield" name="dob_mm" value="<%=dob_mm==null?"":dob_mm %>" maxlength="2" size="2" onblur="javascript:checkDOBLastName(this);">/
								<input type="textfield" name="dob_yy" value="<%=dob_yy==null?"":dob_yy %>" maxlength="4" size="4" onblur="javascript:checkDOBLastName(this);">
								<span id="dob_indicator"></span>
							<%	} else { %>
								<%=dob_dd==null||dob_dd.length()==0?"--":dob_dd %>/<%=dob_mm==null||dob_mm.length()==0?"--":dob_mm %>/<%=dob_yy==null||dob_yy.length()==0?"----":dob_yy %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.decease" /><br>(DD/MM/YYYY)
							</td>
							<td class="infoData" width="35%">
							<%	if ( updateAction) { %>
								<input type="textfield" name="decease_dd" value="<%=decease_dd==null?"":decease_dd %>" maxlength="2" size="2">/
								<input type="textfield" name="decease_mm" value="<%=decease_mm==null?"":decease_mm %>" maxlength="2" size="2">/
								<input type="textfield" name="decease_yy" value="<%=decease_yy==null?"":decease_yy %>" maxlength="4" size="4">
							<%	} else { %>
								<%=decease_dd==null||decease_dd.length()==0?"--":decease_dd %>/<%=decease_mm==null||decease_mm.length()==0?"--":decease_mm %>/<%=decease_yy==null||decease_yy.length()==0?"----":decease_yy %>
							<%	} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.ageGroup" />
							</td>
							<td class="infoData" width="35%">
							<%	if (updateAction) { %>
								<select name="ageGroup">
									<jsp:include page="../../ui/parameterCMB.jsp" flush="false">
										<jsp:param name="parameterType" value="ageGroup" />
										<jsp:param name="parameterValue" value="<%=ageGroup %>" />
									</jsp:include>
								</select>
							<%	} else { %>
								<%=ParameterHelper.getAgeGroupValue(session, ageGroup) %>
							<%	} %>	
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.educationLevel" />
							</td>
							<td class="infoData" width="35%">
							<%	if (updateAction) { %>
								<select name="educationLevelID">
									<jsp:include page="../../ui/parameterCMB.jsp" flush="false">
										<jsp:param name="parameterType" value="education" />
										<jsp:param name="parameterValue" value="<%=educationLevelID %>" />
									</jsp:include>
								</select>
							<%	} else { %>
								<%=ParameterHelper.getEducationLevelValue(session, educationLevelID) %>
							<%	} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.occupation" />
							</td>
							<td class="infoData" width="35%">
							<%	if (updateAction) { %>
								<select name="occupationID">
									<jsp:include page="../../ui/parameterCMB.jsp" flush="false">
										<jsp:param name="parameterType" value="occupation" />
										<jsp:param name="parameterValue" value="<%=occupationID %>" />
									</jsp:include>
								</select>
							<%	} else { %>
								<%=ParameterHelper.getOccupationValue(session, occupationID) %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.monthlyIncome" />
							</td>
							<td class="infoData" width="35%">
							<%	if (updateAction) { %>
								<select name="income">
									<jsp:include page="../../ui/parameterCMB.jsp" flush="false">
										<jsp:param name="parameterType" value="income" />
										<jsp:param name="parameterValue" value="<%=income %>" />
									</jsp:include>
								</select>
							<%	} else { %>
								<%=ParameterHelper.getIncomeValue(session, income) %>
							<%	} %>
							</td>
						</tr>
						
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.hkid" />
							</td>
							<td class="infoData" width="35%" id="hkid_field">
							<%	if (updateAction) { %>
								<input type="textfield" name="hkid" value="<%=hkid==null?"":hkid %>" maxlength="20" size="25" onblur="javascript:checkFirstLevel(this);"><span id="hkid_indicator"></span>
							<%	} else { %>
								<%=hkid==null?"":hkid %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.passport" />
							</td>
							<td class="infoData" width="35%">
							<%	if (updateAction) { %>
								<input type="textfield" name="passport" value="<%=passport==null?"":passport %>" maxlength="50" size="25">
							<%	} else { %>
								<%=passport==null?"":passport %>
							<%	} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoTitle" colspan="4">
								<bean:message key="prompt.contact"/>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.street" />
							</td>
							<td class="infoData" width="35%" id="street1_field">
							<%	if (updateAction) { %>
								<input type="textfield" name="street1" value="<%=street1==null?"":street1 %>" maxlength="50" size="25" onblur="javascript:checkAddress(this);"><span id="street1_indicator">
							<%	} else { %>
								<%=street1==null?"":street1 %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.homePhone" />
							</td>
							<td class="infoData" width="35%" id="homeNumber_field">
							<%	if (updateAction) { %>
								<input type="textfield" name="homeNumber" value="<%=homeNumber==null?"":homeNumber %>" maxlength="20" size="25" onblur="javascript:checkFirstLevel(this);"><span id="homeNumber_indicator"></span>
							<%	} else { %>
								<%=homeNumber==null?"":homeNumber %>
							<%	} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">&nbsp;</td>
							<td class="infoData" width="35%" id="street2_field">
							<%	if (updateAction) { %>
								<input type="textfield" name="street2" value="<%=street2==null?"":street2 %>" maxlength="50" size="25" onblur="javascript:checkAddress(this);"><span id="street2_indicator">
							<%	} else { %>
								<%=street2==null?"":street2 %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.officePhone" />
							</td>
							<td class="infoData" width="35%" id="officeNumber_field">
							<%	if (updateAction) { %>
								<input type="textfield" name="officeNumber" value="<%=officeNumber==null?"":officeNumber %>" maxlength="20" size="25" onblur="javascript:checkFirstLevel(this);"><span id="officeNumber_indicator"></span>
							<%	} else { %>
								<%=officeNumber==null?"":officeNumber %>
							<%	} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">&nbsp;</td>
							<td class="infoData" width="35%" id="street3_field">
							<%	if (updateAction) { %>
								<input type="textfield" name="street3" value="<%=street3==null?"":street3 %>" maxlength="50" size="25" onblur="javascript:checkAddress(this);"><span id="street3_indicator">
							<%	} else { %>
								<%=street3==null?"":street3 %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.mobilePhone" />
							</td>
							<td class="infoData" width="35%" id="mobileNumber_field">
							<%	if (updateAction) { %>
								<input type="textfield" name="mobileNumber" value="<%=mobileNumber==null?"":mobileNumber %>" maxlength="20" size="25" onblur="javascript:checkFirstLevel(this);"><span id="mobileNumber_indicator"></span>
							<%	} else { %>
								<%=mobileNumber==null?"":mobileNumber %>
							<%	} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">&nbsp;</td>
							<td class="infoData" width="35%" id="street4_field">
							<%	if (updateAction) { %>
								<input type="textfield" name="street4" value="<%=street4==null?"":street4 %>" maxlength="50" size="25" onblur="javascript:checkAddress(this);"><span id="street4_indicator">
							<%	} else { %>
								<%=street4==null?"":street4 %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.faxPhone" />
							</td>
							<td class="infoData" width="35%" id="faxNumber_field">
							<%	if (updateAction) { %>
								<input type="textfield" name="faxNumber" value="<%=faxNumber==null?"":faxNumber %>" maxlength="20" size="25" onblur="javascript:checkFirstLevel(this);"><span id="faxNumber_indicator"></span>
							<%	} else { %>
								<%=faxNumber==null?"":faxNumber %>
							<%	} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.district" />
							</td>
							<td class="infoData" width="35%">
							<%	if (updateAction) { %>
								<span id="matchDistrict_indicator"/>
							<%	} else { %>
								<%=ParameterHelper.getDistrictValue(session, districtID) %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%"><bean:message key="prompt.email" /></td>
							<td class="infoData" width="35%" id="email_field">
							<%	if (updateAction) { %>
								<input type="textfield" name="email" value="<%=email==null?"":email %>" maxlength="50" size="25" onblur="javascript:checkFirstLevel(this);"><span id="email_indicator"></span>
							<%	} else { %>
								<%=email==null?"":email %>
							<%	} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.area" />
							</td>
							<td class="infoData" width="35%">
							<%	if (updateAction) { %>
								<select name="areaID" onchange="return updateDistrict()">
									<jsp:include page="../../ui/parameterCMB.jsp" flush="false">
										<jsp:param name="parameterType" value="area" />
										<jsp:param name="parameterValue" value="<%=areaID %>" />
									</jsp:include>
								</select>
							<%	} else { %>
								<%=ParameterHelper.getAreaValue(session, areaID) %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.country" />
							</td>
							<td class="infoData" width="35%">
							<%	if (updateAction) { %>
								<select name="countryID">
									<jsp:include page="../../ui/parameterCMB.jsp" flush="false">
										<jsp:param name="parameterType" value="country" />
										<jsp:param name="parameterValue" value="<%=countryID %>" />
									</jsp:include>
								</select>
							<%	} else { %>
								<%=ParameterHelper.getCountryValue(session, countryID) %>
							<%	} %>
							</td>
						</tr>
					
						<%--allow view --%>
						<tr class="smallText">
							<td class="infoTitle" colspan="4">
								<bean:message key="prompt.emergencyContact" />
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.contactPerson" />
							</td>
							<td class="infoData" width="35%">
							<%	if (updateAction) { %>
								<input type="textfield" name="emergencyContactPerson" value="<%=emergencyContactPerson==null?"":emergencyContactPerson %>" maxlength="50" size="25">
							<%	} else { %>
								<%=emergencyContactPerson==null?"":emergencyContactPerson %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.contactNumber" />
							</td>
							<td class="infoData" width="35%">
							<%	if (updateAction) { %>
								<input type="textfield" name="emergencyContactNumber" value="<%=emergencyContactNumber==null?"":emergencyContactNumber %>" maxlength="20" size="25">
							<%	} else { %>
								<%=emergencyContactNumber==null?"":emergencyContactNumber %>
							<%	} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.relationship" />
							</td>
							<td class="infoData" width="85%" colspan="3">
							<%	if (updateAction) { %>
								<input type="textfield" name="emergencyContactRelationship" value="<%=emergencyContactRelationship==null?"":emergencyContactRelationship %>" maxlength="50" size="25">
							<%	} else { %>
								<%=emergencyContactRelationship==null?"":emergencyContactRelationship %>
							<%	} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoTitle" colspan="4">
								<bean:message key="prompt.personalPreference" />
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.acceptPromotion" />
							</td>
							<td class="infoData" width="35%">
							<%	if (updateAction) { %>
								<input type="radio" name="willingPromotion" value="Y"<%="Y".equals(willingPromotion)?" checked":"" %>><bean:message key="label.yes" />
								<input type="radio" name="willingPromotion" value="N"<%="N".equals(willingPromotion)?" checked":"" %>><bean:message key="label.no" />
							<%	} else { %>
								<%if (willingPromotion != null && "Y".equals(willingPromotion)) { %><bean:message key="label.yes" /><%} else { %><bean:message key="label.no" /><%} %>
							<%	} %>
							</td>
							<td class="infoLabel" width="15%"><bean:message key="label.crm.facebook" /></td>
							<td class="infoData" width="35%">
							<%	if (updateAction) { %>
								<input type="textfield" name="faceBook" value="<%=faceBook==null?"":faceBook %>" maxlength="50" size="25">
							<%	} else { %>
								<%=faceBook==null?"":faceBook %>
							<%	} %>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%"><bean:message key="prompt.preferCommunicationMethod" /></td>
							<td class="infoData" width="35%" >
							<%	if (updateAction) { %>
								<select name="preferContactMethod">
									<jsp:include page="../../ui/parameterCMB.jsp" flush="false">
										<jsp:param name="parameterType" value="preferContactMethod" />
										<jsp:param name="parameterValue" value="<%=preferContactMethod %>" />
									</jsp:include>
								</select>
							<%	} else { %>
								<%=ParameterHelper.getPreferContactMethodValue(session, preferContactMethod) %>
							<%	} %>
							</td>
							
							<td class="infoLabel"><bean:message key="label.crm.photo" /></td>
							<td class="infoData" >
					<%	if ( updateAction) { %>
								<input type="file" name="clientPhoto" size="50" class="multi" maxlength="1">
					<%	} %>
					<%	if (!updateAction && clientPhoto != null && clientPhoto.length() > 0) { %>
								<img src="/upload/CRM/client_photo/<%=clientID %>/<%=clientPhoto%>" style="height:150px;"/>
					<%	} %>
							 <br/>(Small Size <100K)</td>
							
						</tr>
					</table>
					
					<div class="pane">
						<table width="100%" border="0">
							<tr class="smallText">
								<td align="center">
						<%		if (updateAction) { %>
									<button onclick="return submitAction('update');" class="btn-click"><bean:message key="button.save" /></button>
									<button onclick="return submitAction('view');" class="btn-click"><bean:message key="button.cancel" /></button>
						<%		} else {
									if(!"caseManager".equals(userType)){
						%>						
									<button onclick="return submitAction('updateView');" class="btn-click">Update</button>
						<%		 	}	
								} %>
								</td>
							</tr>
						</table>
					</div>
					
					<input type="hidden" name="command"/>
					<input type="hidden" name="clientID" value="<%=clientID %>"/>
					<input type="hidden" name="useClientID" value="<%=useClientID %>"/>
					<input type="hidden" name="prevPhotoName" value="<%=clientPhoto %>"/>
				</form>
				<script language="javascript">
				function submitAction(cmd) {						
					if (cmd == 'create' || cmd == 'update') {					
						if (document.form1.lastName.value == '' && document.form1.firstName.value == '' && document.form1.chineseName.value == '') {
							alert("<bean:message key="error.lastFirstOrChineseName.required" />.");
							document.form1.chineseName.focus();
							return false;
						}						
						if (document.form1.email.value != '') {
							var str = document.form1.email.value;
							if (str.indexOf(".") < 2 || str.indexOf("@") < 0) {
								alert("<bean:message key="error.email.required" />.");
								document.form1.email.focus();
								return false;
							}
						}
					}				
					
					document.form1.command.value = cmd;
					
					document.form1.submit();
				}
				</script>		
	</div>
</body>
<%} %>
</html:html>