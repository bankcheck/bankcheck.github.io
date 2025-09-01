<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.crm.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%!
private String getNextClientUserID(){
	String clientID = null;
	
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT  (COUNT(U.CO_USERNAME) )+1 ");
	sqlStr.append("FROM   CO_USERS");	
	if (!ConstantsServerSide.isHKAH()) {
		sqlStr.append("@"+ConstantsServerSide.SITE_CODE_HKAH);
	}
	sqlStr.append(" U ");
	sqlStr.append("WHERE    U.CO_STAFF_YN = 'N' ");
	sqlStr.append("ORDER BY U.CO_USERNAME ");
		
	ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		clientID = reportableListObject.getValue(0);

		// set 1 for initial
		if (clientID == null || clientID.length() == 0) {
			clientID = "1";
		}
	}
	
	//String formatString = String.format("%%0%dd", 7);	
	//String formattedString = String.format(formatString,Integer.parseInt(clientID));
	String formattedString = "LMC"+clientID;
	return formattedString;
}
%>
<%
UserBean userBean = new UserBean(request);

String module = request.getParameter("module");
boolean isLMCCRM = false;
if(module != null && module.equals("lmc.crm")){
	isLMCCRM= true;
}

String command = request.getParameter("command");
String step = request.getParameter("step");
String originalClientID = null;
String clientID = request.getParameter("clientID");
String clientRelativeID = request.getParameter("clientRelativeID");
if (clientID == null) {
	clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);
}
if (clientRelativeID != null) {
	originalClientID = clientID;
	clientID = clientRelativeID;
}
String relationship = null;
String lastName = TextUtil.parseStr(request.getParameter("lastName")).toUpperCase();
String firstName = TextUtil.parseStr(request.getParameter("firstName")).toUpperCase();
String chineseName = TextUtil.parseStrUTF8(request.getParameter("chineseName"));
String title = request.getParameter("title");
String religion = request.getParameter("religion");
String sex = request.getParameter("sex");
String userID = request.getParameter("userID");
String userSiteCode = request.getParameter("siteCode");

String dob_dd = request.getParameter("dob_dd");
String dob_mm = request.getParameter("dob_mm");
String dob_yy = request.getParameter("dob_yy");
String decease_dd = request.getParameter("decease_dd");
String decease_mm = request.getParameter("decease_mm");
String decease_yy = request.getParameter("decease_yy");
String ageGroup = request.getParameter("ageGroup");
String educationLevelID = request.getParameter("educationLevelID");
String occupationID = request.getParameter("occupationID");
String hkid = TextUtil.parseStr(request.getParameter("hkid")).toUpperCase();
String passport = TextUtil.parseStr(request.getParameter("passport")).toUpperCase();

String street1 = TextUtil.parseStrUTF8(request.getParameter("street1"));
String street2 = TextUtil.parseStrUTF8(request.getParameter("street2"));
String street3 = TextUtil.parseStrUTF8(request.getParameter("street3"));
String street4 = TextUtil.parseStrUTF8(request.getParameter("street4"));
String districtID = request.getParameter("districtID");
String areaID = request.getParameter("areaID");
String countryID = request.getParameter("countryID");
String language = request.getParameter("language");

String homeNumber = TextUtil.parseStrUTF8(request.getParameter("homeNumber"));
String officeNumber = TextUtil.parseStrUTF8(request.getParameter("officeNumber"));
String mobileNumber = TextUtil.parseStrUTF8(request.getParameter("mobileNumber"));
String faxNumber = TextUtil.parseStrUTF8(request.getParameter("faxNumber"));
String remarks = TextUtil.parseStrUTF8(request.getParameter("remarks"));

String email = request.getParameter("email");
String emergencyContactPerson = request.getParameter("emergencyContactPerson");
String emergencyContactNumber = request.getParameter("emergencyContactNumber");
String emergencyContactRelationship = request.getParameter("emergencyContactRelationship");
String faceBook = request.getParameter("faceBook");

String income = request.getParameter("income");
String willingPromotion = request.getParameter("willingPromotion");
String preferContactMethod = request.getParameter("preferContactMethod");
String[] allowView = request.getParameterValues("allowView");

String locationPath = null;
String exportType = request.getParameter("exportType");
String exportColumn = request.getParameter("exportColumn");
String exportRow = request.getParameter("exportRow");

HashSet allowViewSet = new HashSet();
String createdUser = userBean.getLoginID();
String createdDate = null;
String ownerSiteCode = userBean.getSiteCode();
String ownerSiteLabel = null;
String ownerDeptCode = userBean.getDeptCode();
String ownerDeptDesc = userBean.getDeptDesc();
String ownerAllowView = null;
String modifiedUser = null;
String modifiedDate = null;
String medicalType = null;

String selfAllowView = ownerSiteCode + "-" + userBean.getDeptCode();

boolean isAllowView = true;
boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean readOnlyAction = false;
boolean approveAction = false;
boolean printLabelAction = false;
boolean closeAction = false;

boolean success = false;

String message = TextUtil.parseStr(request.getParameter("message"));
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("readOnly".equals(command)) {
	readOnlyAction = true;
} else if ("approve".equals(command)) {
	approveAction = true;
} else if ("printLabel".equals(command)) {
	printLabelAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction) {
			// get new client id
			
			
			clientID = CRMClientDB.add(userBean,
					lastName, firstName,
					chineseName, title, religion, sex,
					dob_yy, dob_mm, dob_dd,
					decease_yy, decease_mm, decease_dd,
					ageGroup, educationLevelID, occupationID, hkid, passport,
					street1, street2, street3, street4, districtID, areaID, countryID,
					language, homeNumber, officeNumber, mobileNumber, faxNumber,
					email, emergencyContactPerson, emergencyContactNumber, emergencyContactRelationship,
					faceBook, income, willingPromotion, preferContactMethod,
					allowView,userID,userSiteCode,isLMCCRM, remarks);
			
			if (clientID != null) {
				message = "Client created.";
				createAction = false;
				step = null;
			} else {
				errorMessage = "Client create fail.";
			}
		} else if (updateAction) {
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
					allowView,null,remarks)) {
				message = "Client updated.";
				updateAction = false;
				step = null;
			} else {
				errorMessage = "Client update fail.";
			}
		} else if (deleteAction) {
			if (CRMClientDB.delete(userBean, clientID)) {
				message = "Client removed.";
				closeAction = true;
				step = null;
			} else {
				errorMessage = "Client remove fail.";
			}
		} else if (printLabelAction) {
			locationPath = CRMClientDB.createPDFAddress(session, userBean, clientID, exportType, exportColumn, exportRow);
			step = null;
		}
	} else if (createAction) {
		clientID = "";
		willingPromotion = "Y";
		// set default assess info
		allowViewSet.add(selfAllowView);
	}

	// load data from database
	if (clientID != null && clientID.length() > 0) {
		ArrayList record;
		if(isLMCCRM){
			record = CRMClientDB.getClientInfo(clientID);
		}else{
			record = CRMClientDB.get(clientID);
		}
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			if (approveAction || (!createAction && !"1".equals(step))) {
				if (clientRelativeID == null) {
					// store client id
					session.setAttribute(ConstantsWebVariable.CLIENT_ID, clientID);
				}
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
				if(isLMCCRM){
					userID = row.getValue(47);
					userSiteCode = row.getValue(48);
				}
				
			}
			ownerSiteCode = row.getValue(37);
			ownerDeptCode = row.getValue(38);
			ownerAllowView = ownerSiteCode + "-" + ownerDeptCode;
			ownerDeptDesc = row.getValue(39);
			createdUser = row.getValue(40);
			createdDate = row.getValue(41);
			modifiedUser = row.getValue(42);
			modifiedDate = row.getValue(43);
			remarks = row.getValue(49);

			if (clientRelativeID != null) {
				record = CRMClientDB.getRelationship(originalClientID, clientRelativeID);
				if (record.size() > 0) {
					row = (ReportableListObject) record.get(0);
					relationship = row.getValue(0);
				}
			}

			// load allow view from database
			if (approveAction || (!createAction && !"1".equals(step))) {
				// retrieve from another table
				record = CRMClientDB.getAccessControl(clientID);
				if (record.size() > 0) {
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						allowViewSet.add(row.getValue(0) + "-" + row.getValue(1));
					}
				}
			}
			// set approve action
			if (approveAction) {
				if (ApprovalUserDB.sendRequest(userBean, "crm", "client", ownerSiteCode, ownerDeptCode, clientID)) {
					message = "Request is submitted.";
					approveAction = false;
					step = null;
				} else {
					errorMessage = "Request is fail to submit.";
				}
			}
			isAllowView = true;
			//isAllowView = allowViewSet.contains(selfAllowView);
		} else {
			closeAction = true;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

// set owner site label
if (ownerSiteCode == null) ownerSiteCode = ConstantsServerSide.SITE_CODE;
ownerSiteLabel = "label." + ownerSiteCode;

if (!closeAction) {
	request.setAttribute("client_membership", CRMClientDB.getMembership(clientID));
	request.setAttribute("client_affiliation", CRMClientDB.getAffiliation(clientID));
	request.setAttribute("client_interestHobby", CRMClientInterest.getList(clientID, "B"));
	request.setAttribute("client_interestHospital", CRMClientInterest.getList(clientID, "S"));
	request.setAttribute("client_medicalIndividual", CRMClientMedical.getList(clientID, "I"));
	request.setAttribute("client_medicalFamily", CRMClientMedical.getList(clientID, "F"));
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
	String pageTitle = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	pageTitle = "function.client." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<%	if (isAllowView && (clientRelativeID != null || (!createAction && !updateAction && !readOnlyAction))) {
if(isLMCCRM){
%>
<jsp:include page="client_info_brief.jsp" flush="false">
	<jsp:param name="tabId" value="1" />	
	<jsp:param name="module" value="lmc.crm" />	
</jsp:include>	
<%
}else{
%>
<jsp:include page="client_info_brief.jsp" flush="false">
	<jsp:param name="tabId" value="1" />	
</jsp:include>
<%}
} %>
<form name="form1" action="client_info.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td align="center" colspan="4"><span id="matchTable_indicator"></td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle" colspan="4"><%if (clientRelativeID != null) { %><bean:message key="prompt.relative" /> - <%} %><bean:message key="function.client.view" /><%=relationship==null?"":" (" + relationship + ")" %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData" width="35%" id="lastName_field">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="lastName" value="<%=lastName==null?"":lastName %>" maxlength="30" size="25" onblur="javascript:checkDOBLastName(this);"><span id="lastName_indicator">
<%	} else { %>
			<%=lastName==null?"":lastName %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="firstName" value="<%=firstName==null?"":firstName %>" maxlength="60" size="25">
<%	} else { %>
			<%=firstName==null?"":firstName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="chineseName" value="<%=chineseName==null?"":chineseName %>" maxlength="20" size="25">
<%	} else { %>
			<%=chineseName==null?"":chineseName %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.title" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="title">
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="title" />
	<jsp:param name="parameterValue" value="<%=title %>" />
</jsp:include>
			</select>
<%	} else { %>
			<%=ParameterHelper.getTitleValue(session, title) %>
<%	} %>
		</td>
	</tr>
<%if (isAllowView) { %>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.religion" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="religion">
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="religion" />
	<jsp:param name="parameterValue" value="<%=religion %>" />
</jsp:include>
			</select>
<%	} else { %>
			<%=ParameterHelper.getReligionValue(session, religion) %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.sex" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="sex">
<jsp:include page="../ui/sexCMB.jsp" flush="false">
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
		<td class="infoLabel" width="15%"><bean:message key="prompt.dateOfBirth" /><br>(DD/MM/YYYY)</td>
		<td class="infoData" width="35%" id="dob_field">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="dob_dd" value="<%=dob_dd==null?"":dob_dd %>" maxlength="2" size="2" onblur="javascript:checkDOBLastName(this);">/
			<input type="textfield" name="dob_mm" value="<%=dob_mm==null?"":dob_mm %>" maxlength="2" size="2" onblur="javascript:checkDOBLastName(this);">/
			<input type="textfield" name="dob_yy" value="<%=dob_yy==null?"":dob_yy %>" maxlength="4" size="4" onblur="javascript:checkDOBLastName(this);">
			<span id="dob_indicator"></span>
<%	} else { %>
			<%=dob_dd==null||dob_dd.length()==0?"--":dob_dd %>/<%=dob_mm==null||dob_mm.length()==0?"--":dob_mm %>/<%=dob_yy==null||dob_yy.length()==0?"----":dob_yy %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.decease" /><br>(DD/MM/YYYY)</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="decease_dd" value="<%=decease_dd==null?"":decease_dd %>" maxlength="2" size="2">/
			<input type="textfield" name="decease_mm" value="<%=decease_mm==null?"":decease_mm %>" maxlength="2" size="2">/
			<input type="textfield" name="decease_yy" value="<%=decease_yy==null?"":decease_yy %>" maxlength="4" size="4">
<%	} else { %>
			<%=decease_dd==null||decease_dd.length()==0?"--":decease_dd %>/<%=decease_mm==null||decease_mm.length()==0?"--":decease_mm %>/<%=decease_yy==null||decease_yy.length()==0?"----":decease_yy %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.ageGroup" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="ageGroup">
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="ageGroup" />
	<jsp:param name="parameterValue" value="<%=ageGroup %>" />
</jsp:include>
			</select>
<%	} else { %>
		<%=ParameterHelper.getAgeGroupValue(session, ageGroup) %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.educationLevel" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="educationLevelID">
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
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
		<td class="infoLabel" width="15%"><bean:message key="prompt.occupation" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="occupationID">
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="occupation" />
	<jsp:param name="parameterValue" value="<%=occupationID %>" />
</jsp:include>
			</select>
<%	} else { %>
			<%=ParameterHelper.getOccupationValue(session, occupationID) %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.monthlyIncome" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="income">
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="income" />
	<jsp:param name="parameterValue" value="<%=income %>" />
</jsp:include>
			</select>
<%	} else { %>
			<%=ParameterHelper.getIncomeValue(session, income) %>
<%	} %>
		</td>
	</tr>
<%} %>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.hkid" /></td>
		<td class="infoData" width="35%" id="hkid_field">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="hkid" value="<%=hkid==null?"":hkid %>" maxlength="20" size="25" onblur="javascript:checkFirstLevel(this);"><span id="hkid_indicator"></span>
<%	} else { %>
			<%=hkid==null?"":hkid %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.passport" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="passport" value="<%=passport==null?"":passport %>" maxlength="50" size="25">
<%	} else { %>
			<%=passport==null?"":passport %>
<%	} %>
		</td>
	</tr>
	
	
<%
if(isLMCCRM){
	
%>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Login Information</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.loginID" /></td>
		<td class="infoData" width="35%">		
<%	

if (createAction) {
	String createUserID = getNextClientUserID();	
	
%>
			<%=createUserID%><html:text style="display:none" property="userID" value="<%=createUserID%>" />
<%	} else { %>
			<%=(userID==null)?"":userID%><input type="hidden" name="userID" value="<%=userID %>">
<%	} %>
		</td>
		<td class="infoLabel" width="30%"><bean:message key="prompt.site" /></td>
		<td class="infoData" width="70%">
<%	if (createAction ) {	
		userSiteCode = ConstantsServerSide.SITE_CODE;		
%>
<jsp:include page="../ui/siteCodeRDB.jsp" flush="false">
	<jsp:param name="allowAll" value="N" />
	<jsp:param name="siteCode" value="<%=userSiteCode %>" />
</jsp:include>
<%	} else { %>

		<%if (ConstantsServerSide.SITE_CODE_HKAH.equals(userSiteCode)) { %><bean:message key="label.hkah" /><%} else if (ConstantsServerSide.SITE_CODE_TWAH.equals(userSiteCode)) {%><bean:message key="label.twah" /><%} else {%><%=""%><%} %>
		<input type="hidden" name="userSiteCode" value="<%=userSiteCode%>">
<%	} %>
		</td>
	</tr>
	<%
}	
	%>
	
	
	<tr class="smallText">
		<td class="infoTitle" colspan="4"><bean:message key="prompt.contact"/></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.street" /></td>
		<td class="infoData" width="35%" id="street1_field">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="street1" value="<%=street1==null?"":street1 %>" maxlength="50" size="25" onblur="javascript:checkAddress(this);"><span id="street1_indicator">
<%	} else { %>
			<%=street1==null?"":street1 %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.homePhone" /></td>
		<td class="infoData" width="35%" id="homeNumber_field">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="homeNumber" value="<%=homeNumber==null?"":homeNumber %>" maxlength="20" size="25" onblur="javascript:checkFirstLevel(this);"><span id="homeNumber_indicator"></span>
<%	} else { %>
			<%=homeNumber==null?"":homeNumber %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">&nbsp;</td>
		<td class="infoData" width="35%" id="street2_field">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="street2" value="<%=street2==null?"":street2 %>" maxlength="50" size="25" onblur="javascript:checkAddress(this);"><span id="street2_indicator">
<%	} else { %>
			<%=street2==null?"":street2 %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.officePhone" /></td>
		<td class="infoData" width="35%" id="officeNumber_field">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="officeNumber" value="<%=officeNumber==null?"":officeNumber %>" maxlength="20" size="25" onblur="javascript:checkFirstLevel(this);"><span id="officeNumber_indicator"></span>
<%	} else { %>
			<%=officeNumber==null?"":officeNumber %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">&nbsp;</td>
		<td class="infoData" width="35%" id="street3_field">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="street3" value="<%=street3==null?"":street3 %>" maxlength="50" size="25" onblur="javascript:checkAddress(this);"><span id="street3_indicator">
<%	} else { %>
			<%=street3==null?"":street3 %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.mobilePhone" /></td>
		<td class="infoData" width="35%" id="mobileNumber_field">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="mobileNumber" value="<%=mobileNumber==null?"":mobileNumber %>" maxlength="20" size="25" onblur="javascript:checkFirstLevel(this);"><span id="mobileNumber_indicator"></span>
<%	} else { %>
			<%=mobileNumber==null?"":mobileNumber %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">&nbsp;</td>
		<td class="infoData" width="35%" id="street4_field">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="street4" value="<%=street4==null?"":street4 %>" maxlength="50" size="25" onblur="javascript:checkAddress(this);"><span id="street4_indicator">
<%	} else { %>
			<%=street4==null?"":street4 %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.faxPhone" /></td>
		<td class="infoData" width="35%" id="faxNumber_field">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="faxNumber" value="<%=faxNumber==null?"":faxNumber %>" maxlength="20" size="25" onblur="javascript:checkFirstLevel(this);"><span id="faxNumber_indicator"></span>
<%	} else { %>
			<%=faxNumber==null?"":faxNumber %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.district" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="matchDistrict_indicator">
<%	} else { %>
			<%=ParameterHelper.getDistrictValue(session, districtID) %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.email" /></td>
		<td class="infoData" width="35%" id="email_field">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="email" value="<%=email==null?"":email %>" maxlength="50" size="25" onblur="javascript:checkFirstLevel(this);"><span id="email_indicator"></span>
<%	} else { %>
			<%=email==null?"":email %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.area" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="areaID" onchange="return updateDistrict()">
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="area" />
	<jsp:param name="parameterValue" value="<%=areaID %>" />
</jsp:include>
			</select>
<%	} else { %>
			<%=ParameterHelper.getAreaValue(session, areaID) %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.country" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<select name="countryID">
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="country" />
	<jsp:param name="parameterValue" value="<%=countryID %>" />
</jsp:include>
			</select>
<%	} else { %>
			<%=ParameterHelper.getCountryValue(session, countryID) %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Remarks</td>
		<td class="infoData" colspan="3">
<%	if (createAction || updateAction) { %>
			<textarea name = "remarks" style='height:50px;width:100%'><%=remarks==null?"":remarks%></textarea>
		 
<%	} else { %>
			<%=remarks==null?"":remarks %>
<%	} %>
		</td>
	</tr>
<%	if (!createAction && !updateAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Print Address Label</td>
		<td class="infoData" width="85%" colspan="3">
			<select name="exportType">
				<option value="">---</option>
				<option value="L7160"<%="L7160".equals(exportType)?" selected":"" %>>Avery L7160</option>
				<option value="8220"<%="8220".equals(exportType)?" selected":"" %>>Herma-8220</option>
			</select>
			&nbsp;&nbsp;Location: Column
			<select name="exportColumn">
				<option value="">---</option>
				<option value="1"<%="1".equals(exportColumn)?" selected":"" %>>1</option>
				<option value="2"<%="2".equals(exportColumn)?" selected":"" %>>2</option>
				<option value="3"<%="3".equals(exportColumn)?" selected":"" %>>3</option>
			</select>
			Row
			<select name="exportRow">
				<option value="">---</option>
				<option value="1"<%="1".equals(exportRow)?" selected":"" %>>1</option>
				<option value="2"<%="2".equals(exportRow)?" selected":"" %>>2</option>
				<option value="3"<%="3".equals(exportRow)?" selected":"" %>>3</option>
				<option value="4"<%="4".equals(exportRow)?" selected":"" %>>4</option>
				<option value="5"<%="5".equals(exportRow)?" selected":"" %>>5</option>
				<option value="6"<%="6".equals(exportRow)?" selected":"" %>>6</option>
				<option value="7"<%="7".equals(exportRow)?" selected":"" %>>7</option>
				<option value="8"<%="8".equals(exportRow)?" selected":"" %>>8</option>
			</select>
			<button onclick="return submitAction('printLabel', 1);" class="btn-click">Generate</button>
		</td>
	</tr>
<%	} %>
<%if (isAllowView) { %>
	<tr class="smallText">
		<td class="infoTitle" colspan="4"><bean:message key="prompt.emergencyContact" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.contactPerson" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="emergencyContactPerson" value="<%=emergencyContactPerson==null?"":emergencyContactPerson %>" maxlength="50" size="25">
<%	} else { %>
			<%=emergencyContactPerson==null?"":emergencyContactPerson %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.contactNumber" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="emergencyContactNumber" value="<%=emergencyContactNumber==null?"":emergencyContactNumber %>" maxlength="20" size="25">
<%	} else { %>
			<%=emergencyContactNumber==null?"":emergencyContactNumber %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.relationship" /></td>
		<td class="infoData" width="85%" colspan="3">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="emergencyContactRelationship" value="<%=emergencyContactRelationship==null?"":emergencyContactRelationship %>" maxlength="50" size="25">
<%	} else { %>
			<%=emergencyContactRelationship==null?"":emergencyContactRelationship %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle" colspan="4"><bean:message key="prompt.personalPreference" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.acceptPromotion" /></td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="radio" name="willingPromotion" value="Y"<%="Y".equals(willingPromotion)?" checked":"" %>><bean:message key="label.yes" />
			<input type="radio" name="willingPromotion" value="N"<%="N".equals(willingPromotion)?" checked":"" %>><bean:message key="label.no" />
<%	} else { %>
		<%if (willingPromotion != null && "Y".equals(willingPromotion)) { %><bean:message key="label.yes" /><%} else { %><bean:message key="label.no" /><%} %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Facebook</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="faceBook" value="<%=faceBook==null?"":faceBook %>" maxlength="50" size="25">
<%	} else { %>
			<%=faceBook==null?"":faceBook %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.preferCommunicationMethod" /></td>
		<td class="infoData" width="85%" colspan="3">
<%	if (createAction || updateAction) { %>
			<select name="preferContactMethod">
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="preferContactMethod" />
	<jsp:param name="parameterValue" value="<%=preferContactMethod %>" />
</jsp:include>
			</select>
<%	} else { %>
			<%=ParameterHelper.getPreferContactMethodValue(session, preferContactMethod) %>
<%	} %>
		</td>
		<td colspan="2">&nbsp;</td>
	</tr>
<%} %>
	<tr class="smallText">
		<td class="infoTitle" colspan="4"><bean:message key="prompt.access"/></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.allowView"/></td>
<%	if (createAction || (updateAction && ownerAllowView.equals(selfAllowView))) { %>
		<td class="infoData" width="35%">
			<input type="checkbox" name="allowView" value="hkah-520"<%=allowViewSet.contains("hkah-520")?" checked":"" %>><bean:message key="department.520" />(<bean:message key="label.hkah" />)<BR>
			<input type="checkbox" name="allowView" value="hkah-660"<%=allowViewSet.contains("hkah-660")?" checked":"" %>><bean:message key="department.660" />(<bean:message key="label.hkah" />)<BR>
			<input type="checkbox" name="allowView" value="hkah-670"<%=allowViewSet.contains("hkah-670")?" checked":"" %>><bean:message key="department.670" />(<bean:message key="label.hkah" />)<BR>
			<input type="checkbox" name="allowView" value="hkah-750"<%=allowViewSet.contains("hkah-750")?" checked":"" %>><bean:message key="department.750" />(<bean:message key="label.hkah" />)
		</td>
		<td class="infoData" width="50%" colspan="2">
			<input type="checkbox" name="allowView" value="twah-520"<%=allowViewSet.contains("twah-520")?" checked":"" %>><bean:message key="department.520" />(<bean:message key="label.twah" />)<BR>
			<input type="checkbox" name="allowView" value="twah-660"<%=allowViewSet.contains("twah-660")?" checked":"" %>><bean:message key="department.660" />(<bean:message key="label.twah" />)<BR>
			<input type="checkbox" name="allowView" value="twah-670"<%=allowViewSet.contains("twah-670")?" checked":"" %>><bean:message key="department.670" />(<bean:message key="label.twah" />)<BR>
			<input type="checkbox" name="allowView" value="twah-750"<%=allowViewSet.contains("twah-750")?" checked":"" %>><bean:message key="department.750" />(<bean:message key="label.twah" />)
		</td>
<%	} else { %>
		<td class="infoData" width="85%" colspan="3">
<%		int index = 0;
		String temp = null;
		String siteCode = null;
		String deptCode = null;
		for (Iterator i = allowViewSet.iterator(); i.hasNext(); ) {
			temp = (String) i.next();
			index = temp.indexOf("-");
			siteCode = "label." + temp.substring(0, index);
			deptCode = temp.substring(index + 1);
			if ("520".equals(deptCode)) {
				%><bean:message key="department.520" /><%
			} else if ("660".equals(deptCode)) {
				%><bean:message key="department.660" /><%
			} else if ("670".equals(deptCode)) {
				%><bean:message key="department.670" /><%
			} else if ("750".equals(deptCode)) {
				%><bean:message key="department.750" /><%
			}
			%>(<bean:message key="<%=siteCode %>" />)<BR><%
		}
	} %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.createdBy"/></td>
		<td class="infoData" width="35%"><%=createdUser==null?"":createdUser %></td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.createdDate" /></td>
		<td class="infoData" width="35%"><%=createdDate==null?"":createdDate %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.lastModifiedBy" /></td>
		<td class="infoData" width="35%"><%=modifiedUser==null?"":modifiedUser %></td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.modifiedDate" /></td>
		<td class="infoData" width="35%"><%=modifiedDate==null?"":modifiedDate %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.ownerSite"/></td>
		<td class="infoData" width="35%"><bean:message key="<%=ownerSiteLabel %>"/></td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.ownerDepartment"/></td>
		<td class="infoData" width="35%"><%=ownerDeptDesc==null?"":ownerDeptDesc %></td>
	</tr>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
</table>
<%	if (!readOnlyAction) { %>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%		if (!isAllowView) { %>
			<bean:message key="message.clientInfo.noAccessRight" /><BR/><P/><BR/>
			<button onclick="return submitAction('approve', 1);" class="btn-click"><bean:message key="button.requestApproval" /> -> <%=ownerDeptDesc %> (<bean:message key="<%=ownerSiteLabel %>"/>)</button>
<%		} else if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=pageTitle %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=pageTitle %>" /></button>
<%		} else {%>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.client.update" /></button>
			<button onclick="return submitAction('delete', 1);" class="btn-click"><bean:message key="function.client.delete" /></button>
<%		} %>
		</td>
	</tr>
</table>
</div>
<%	} %>
<%	if (!createAction && !updateAction && !readOnlyAction && isAllowView) { %>
<table width="100%" border="0">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle"><bean:message key="prompt.membership" /></td>
	</tr>
</table>
<span id="member" />
<bean:define id="functionLabel_membership"><bean:message key="function.membership.list" /></bean:define>
<bean:define id="notFoundMsg_membership"><bean:message key="message.notFound" arg0="<%=functionLabel_membership %>" /></bean:define>
<display:table id="row1" name="requestScope.client_membership" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row1_rowNum")%>)</display:column>
	<display:column property="fields3" titleKey="prompt.joinedDate" style="width:10%" />
	<display:column property="fields4" titleKey="prompt.category" style="width:15%" />
	<display:column property="fields5" titleKey="prompt.memberNumber" style="width:10%" />
	<display:column property="fields6" titleKey="prompt.issuedDate" style="width:10%" />
	<display:column property="fields7" titleKey="prompt.expiryDate" style="width:10%" />
	<display:column titleKey="prompt.paid" style="width:10%">
		<logic:equal name="row1" property="fields8" value="Y">
			<bean:message key="label.yes" />
		</logic:equal>
		<logic:notEqual name="row1" property="fields8" value="Y">
			<bean:message key="label.no" />
		</logic:notEqual>
	</display:column>
	<display:column property="fields9" titleKey="prompt.issuedBy" style="width:10%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction2('view', 0, 'member', '<c:out value="${row1.fields0}" />', '<c:out value="${row1.fields1}" />', '');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg_membership %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction2('create', '', 'member', '', '', '');"><bean:message key="function.membership.create" /></button></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle"><bean:message key="prompt.affiliation" /></td>
	</tr>
</table>
<span id="affiliation" />
<bean:define id="functionLabel_affiliation"><bean:message key="function.affiliation.list" /></bean:define>
<bean:define id="notFoundMsg_affiliation"><bean:message key="message.notFound" arg0="<%=functionLabel_affiliation %>" /></bean:define>
<display:table id="row2" name="requestScope.client_affiliation" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row2_rowNum")%>)</display:column>
	<display:column property="fields1" titleKey="prompt.companyName" style="width:45%" />
	<display:column property="fields2" titleKey="prompt.title" style="width:30%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction2('view', 0, 'affiliation', '<c:out value="${row2.fields0}" />', '', '');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg_affiliation %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitAction2('create', '', 'affiliation', '', '', '');"><bean:message key="function.affiliation.create" /></button>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle"><bean:message key="prompt.interestHobby" /></td>
	</tr>
</table>
<span id="interest" />
<bean:define id="functionLabel_interestHobby"><bean:message key="function.interestHobby.list" /></bean:define>
<bean:define id="notFoundMsg_interestHobby"><bean:message key="message.notFound" arg0="<%=functionLabel_interestHobby %>" /></bean:define>
<display:table id="row3a" name="requestScope.client_interestHobby" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row3a_rowNum")%>)</display:column>
	<display:column titleKey="prompt.interestHobby" style="width:45%">
		<%=ParameterHelper.getHobbyValue(session, ((ReportableListObject)pageContext.getAttribute("row3a")).getFields0()) %>
	</display:column>
	<display:column titleKey="prompt.remarks" style="width:20%">
		<logic:equal name="row3a" property="fields2" value="">
			<bean:message key="label.unknown" />
		</logic:equal>
		<logic:notEqual name="row3a" property="fields2" value="">
			<c:out value="${row3a.fields2}" />
		</logic:notEqual>
	</display:column>
	<display:column property="fields3" titleKey="prompt.modifiedDate" style="width:20%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction2('view', 0, 'interest', 'B', '<c:out value="${row3a.fields0}" />', '<c:out value="${row3a.fields1}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg_interestHobby %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction2('create', '', 'interest', 'B', '', '');"><bean:message key="function.interestHobby.create" /></button></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle"><bean:message key="prompt.interestHospital" /></td>
	</tr>
</table>
<bean:define id="functionLabel_interestHospital"><bean:message key="function.interestHospital.list" /></bean:define>
<bean:define id="notFoundMsg_interestHospital"><bean:message key="message.notFound" arg0="<%=functionLabel_interestHospital %>" /></bean:define>
<display:table id="row3b" name="requestScope.client_interestHospital" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row3b_rowNum")%>)</display:column>
	<display:column titleKey="prompt.interestHospital" style="width:35%">
		<%=ParameterHelper.getHospitalFacilityValue(session, ((ReportableListObject)pageContext.getAttribute("row3b")).getFields0()) %>
	</display:column>
	<display:column titleKey="prompt.remarks" style="width:20%">
		<logic:equal name="row3b" property="fields2" value="">
			<bean:message key="label.unknown" />
		</logic:equal>
		<logic:notEqual name="row3b" property="fields2" value="">
			<c:out value="${row3b.fields2}" />
		</logic:notEqual>
	</display:column>
	<display:column property="fields3" titleKey="prompt.modifiedDate" style="width:20%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction2('view', 0, 'interest', 'S', '<c:out value="${row3b.fields0}" />', '<c:out value="${row3b.fields1}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg_interestHospital %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction2('create', '', 'interest', 'S', '', '');"><bean:message key="function.interestHospital.create" /></button></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle"><bean:message key="prompt.medicalRecordIndividual" /></td>
	</tr>
</table>
<span id="medical" />
<bean:define id="functionLabel_medicalRecordIndividual"><bean:message key="function.medicalRecordIndividual.list" /></bean:define>
<bean:define id="notFoundMsg_medicalRecordIndividual"><bean:message key="message.notFound" arg0="<%=functionLabel_medicalRecordIndividual %>" /></bean:define>
<display:table id="row4a" name="requestScope.client_medicalIndividual" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row4a_rowNum")%>)</display:column>
	<display:column titleKey="prompt.medicalRecordIndividual" style="width:35%">
		<%=ParameterHelper.getMedicalValue(session, ((ReportableListObject)pageContext.getAttribute("row4a")).getFields0()) %>
	</display:column>
	<display:column titleKey="prompt.remarks" style="width:20%">
		<logic:equal name="row4a" property="fields2" value="">
			<bean:message key="label.unknown" />
		</logic:equal>
		<logic:notEqual name="row4a" property="fields2" value="">
			<c:out value="${row4a.fields2}" />
		</logic:notEqual>
	</display:column>
	<display:column property="fields3" titleKey="prompt.modifiedDate" style="width:20%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction2('view', 0, 'medical', 'I', '<c:out value="${row4a.fields0}" />', '<c:out value="${row4a.fields1}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg_medicalRecordIndividual %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction2('create', '', 'medical', 'I', '', '');"><bean:message key="function.medicalRecordIndividual.create" /></button></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle"><bean:message key="prompt.medicalRecordFamily" /></td>
	</tr>
</table>
<bean:define id="functionLabel_medicalRecordFamily"><bean:message key="function.medicalRecordFamily.list" /></bean:define>
<bean:define id="notFoundMsg_medicalRecordFamily"><bean:message key="message.notFound" arg0="<%=functionLabel_medicalRecordFamily %>" /></bean:define>
<display:table id="row4b" name="requestScope.client_medicalFamily" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row4b_rowNum")%>)</display:column>
	<display:column titleKey="prompt.medicalRecordFamily" style="width:35%">
		<%=ParameterHelper.getMedicalValue(session, ((ReportableListObject)pageContext.getAttribute("row4b")).getFields0()) %>
	</display:column>
	<display:column titleKey="prompt.remarks" style="width:20%">
		<logic:equal name="row4b" property="fields2" value="">
			<bean:message key="label.unknown" />
		</logic:equal>
		<logic:notEqual name="row4b" property="fields2" value="">
			<c:out value="${row4b.fields2}" />
		</logic:notEqual>
	</display:column>
	<display:column property="fields3" titleKey="prompt.modifiedDate" style="width:20%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction2('view', 0, 'medical', 'F', '<c:out value="${row4b.fields0}" />', '<c:out value="${row4b.fields1}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg_medicalRecordFamily %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction2('create', '', 'medical', 'F', '', '');"><bean:message key="function.medicalRecordFamily.create" /></button></td>
	</tr>
</table>
<%	} %>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="clientID" value="<%=clientID %>">
<input type="hidden" name="clubID">
<input type="hidden" name="clubSeq">
<input type="hidden" name="affiliationID">
<input type="hidden" name="interestType">
<input type="hidden" name="interestID">
<input type="hidden" name="interestSeq">
<input type="hidden" name="medicalType">
<input type="hidden" name="medicalID">
<input type="hidden" name="medicalSeq">
<input type="hidden" id="module" name="module" value="<%=(isLMCCRM==true)?"lmc.crm":"" %>">	
</form>
<script language="javascript">
<!--
	// ajax
	var http = createRequestObject();
	var divFieldName;
	var divFieldName2;
	var divFieldName3;
	var divMsgName;
	var divMsgName2;
	var divMsgName3;

	function submitAction(cmd, stp) {
		if (cmd == 'printLabel') {
			if (document.form1.exportType.value == '') {
				alert("Please select export type!");
				document.form1.exportType.focus();
				return false;
			}
			if (document.form1.exportColumn.value == '') {
				alert("Please select export column!");
				document.form1.exportColumn.focus();
				return false;
			}
			if (document.form1.exportRow.value == '') {
				alert("Please select export row!");
				document.form1.exportRow.focus();
				return false;
			}
			if (document.form1.exportType.value == '8220' && document.form1.exportColumn.value == '3') {
				alert("Herma-8220 Label can only have two columns!");
				document.form1.exportColumn.focus();
				return false;
			}
			if (document.form1.exportType.value == 'L7160' && document.form1.exportRow.value == '8') {
				alert("Avery L7160 Label can only have seven rows!");
				document.form1.exportRow.focus();
				return false;
			}
		}
<%	if (createAction || updateAction) { %>
			if (cmd == 'create' || cmd == 'update') {
				if (document.form1.lastName.value == '' && document.form1.firstName.value == '' && document.form1.chineseName.value == '') {
					alert("<bean:message key="error.lastFirstOrChineseName.required" />.");
					document.form1.chineseName.focus();
					return false;
				}
//				if (document.form1.homeNumber.value == '' && document.form1.mobileNumber.value == '' && document.form1.email.value == '') {
//					alert("<bean:message key="error.homeOrMobileNumber.required" />.");
//					document.form1.mobileNumber.focus();
//					return false;
//				}
				if (document.form1.email.value != '') {
					var str = document.form1.email.value;
					if (str.indexOf(".") < 2 || str.indexOf("@") < 0) {
						alert("<bean:message key="error.email.required" />.");
						document.form1.email.focus();
						return false;
					}
				}
			}
<%	} %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	function submitAction2(cmd, stp, type, value, value2, value3) {
		if (type == 'affiliation') {
			document.form1.action = "client_affiliation.jsp";
			document.form1.affiliationID.value = value;
		} else if (type == 'member') {
			document.form1.action = "client_membership.jsp";
			document.form1.clubID.value = value;
			document.form1.clubSeq.value = value2;
		} else if (type == 'interest') {
			document.form1.action = "client_interest.jsp";
			document.form1.interestType.value = value;
			document.form1.interestID.value = value2;
			document.form1.interestSeq.value = value3;
		} else if (type == 'medical') {
			document.form1.action = "client_medical.jsp";
			document.form1.medicalType.value = value;
			document.form1.medicalID.value = value2;
			document.form1.medicalSeq.value = value3;
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	function checkFirstLevel(obj) {
		// only check value if not empty
		if (obj.value != "") {
			//make a connection to the server ... specifying that you intend to make a GET request
			//to the server. Specifiy the page name and the URL parameters to send
			http.open('get', 'client_info_verify.jsp?clientID=<%=clientID %>&field=' + obj.name + '&value=' + obj.value + '&timestamp=<%=(new java.util.Date()).getTime() %>');

			divFieldName = obj.name + '_field';
			divMsgName = obj.name + '_indicator';

			//assign a handler for the response
			http.onreadystatechange = processResponse;

			//actually send the request to the server
			http.send(null);
		}
	}

	function checkDOBLastName(obj) {
		// only check value if not empty
		var nameObject = document.forms["form1"].elements["lastName"];
		var dobObject1 = document.forms["form1"].elements["dob_dd"];
		var dobObject2 = document.forms["form1"].elements["dob_mm"];
		var dobObject3 = document.forms["form1"].elements["dob_yy"];

		if (nameObject.value != "" && dobObject1.value != "" && dobObject2.value != "" && dobObject3.value != "") {
			//make a connection to the server ... specifying that you intend to make a GET request
			//to the server. Specifiy the page name and the URL parameters to send
			http.open('get', 'client_info_verify.jsp?clientID=<%=clientID %>&field=dobLastName&lastName=' + nameObject.value + '&dob_dd=' + dobObject1.value + '&dob_mm=' + dobObject2.value + '&dob_yy=' + dobObject3.value + '&timestamp=<%=(new java.util.Date()).getTime() %>');

			if (obj == nameObject) {
				divFieldName = 'lastName_field';
				divFieldName2 = 'dob_field';
				divMsgName = 'lastName_indicator';
				divMsgName2 = 'dob_indicator';
			} else {
				divFieldName = 'dob_field';
				divFieldName2 = 'lastName_field';
				divMsgName = 'dob_indicator';
				divMsgName2 = 'lastName_indicator';
			}

			//assign a handler for the response
			http.onreadystatechange = processResponse;

			//actually send the request to the server
			http.send(null);
		}
	}

	function checkAddress(obj) {
		// only check value if not empty
		var street1Object = document.forms["form1"].elements["street1"];
		var street2Object = document.forms["form1"].elements["street2"];
		var street3Object = document.forms["form1"].elements["street3"];

		if (street1Object.value != "") {
			//make a connection to the server ... specifying that you intend to make a GET request
			//to the server. Specifiy the page name and the URL parameters to send
			http.open('get', 'client_info_verify.jsp?clientID=<%=clientID %>&field=address&street1=' + street1Object.value + '&street2=' + street2Object.value + '&street3=' + street3Object.value + '&timestamp=<%=(new java.util.Date()).getTime() %>');

			if (obj == street1Object) {
				divFieldName = 'street1_field';
				divFieldName2 = 'street2_field';
				divFieldName3 = 'street3_field';
				divMsgName = 'street1_indicator';
				divMsgName2 = 'street2_indicator';
				divMsgName3 = 'street3_indicator';
			} else if (obj == street2Object) {
				divFieldName = 'street2_field';
				divFieldName2 = 'street1_field';
				divFieldName3 = 'street3_field';
				divMsgName = 'street2_indicator';
				divMsgName2 = 'street1_indicator';
				divMsgName3 = 'street3_indicator';
			} else {
				divFieldName = 'street3_field';
				divFieldName2 = 'street1_field';
				divFieldName3 = 'street2_field';
				divMsgName = 'street3_indicator';
				divMsgName2 = 'street1_indicator';
				divMsgName3 = 'street2_indicator';
			}

			//assign a handler for the response
			http.onreadystatechange = processResponse;

			//actually send the request to the server
			http.send(null);
		}
	}

	function updateDistrict(pvalue) {
		var areaID = document.forms["form1"].elements["areaID"].value;

		http.open('get', '../ui/parameterCMB.jsp?parameterType=district&parameterValue=' + pvalue + '&parentID=' + areaID + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponseDistrict;

		//actually send the request to the server
		http.send(null);
	}

	function updateArea(pvalue) {
		var districtID = document.forms["form1"].elements["districtID"].value;

		if (districtID >= 1 && districtID <= 4) {
			document.forms["form1"].elements["areaID"].selectedIndex = 1;
		} else if (districtID >= 5 && districtID <= 9) {
			document.forms["form1"].elements["areaID"].selectedIndex = 2;
		} else if (districtID >= 10 && districtID <= 19) {
			document.forms["form1"].elements["areaID"].selectedIndex = 3;
		} else {
			document.forms["form1"].elements["areaID"].selectedIndex = 0;
		}
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("matchTable_indicator").innerHTML = http.responseText;
			if (response != '') {
				document.getElementById(divMsgName).innerHTML = '<img src="../images/info.gif"><font color="white"><bean:message key="prompt.alreadyExist" /></font>';
				document.getElementById(divFieldName).className = "infoDataWarning";
			} else {
				document.getElementById(divMsgName).innerHTML = '<img src="../images/tick_green_small.gif">';
				document.getElementById(divFieldName).className = "infoData";
				if (divFieldName2 != '' && divMsgName2 != '') {
					document.getElementById(divMsgName2).innerHTML = '<img src="../images/tick_green_small.gif">';
					document.getElementById(divFieldName2).className = "infoData";
					divFieldName2 = '';
					divMsgName2 = '';
				}
				if (divFieldName3 != '' && divMsgName3 != '') {
					document.getElementById(divMsgName3).innerHTML = '<img src="../images/tick_green_small.gif">';
					document.getElementById(divFieldName3).className = "infoData";
					divFieldName3 = '';
					divMsgName3 = '';
				}
			}
		}
	}

	function processResponseDistrict() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("matchDistrict_indicator").innerHTML = '<select name="districtID" onchange="return updateArea()">>' + http.responseText + '</select>';
		}
	}

	function matchView(cid) {
		callPopUpWindow2(document.form1.action + "?command=readOnly&clientID=" + cid);
	}

<%	if (createAction || updateAction) { %>
	updateDistrict('<%=districtID %>');
<%	} %>

<%	if (locationPath != null) { %>
	callPopUpWindow("/intranet/FopServlet?fo=<%=locationPath %>");
<%	} %>
-->
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>