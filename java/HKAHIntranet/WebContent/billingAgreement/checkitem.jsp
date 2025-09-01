<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)) {
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
String step = ParserUtil.getParameter(request, "step");

String moduleCode = ParserUtil.getParameter(request, "moduleCode");
String baID = ParserUtil.getParameter(request, "baID");
String renewID = ParserUtil.getParameter(request, "renewID");
String dept = ParserUtil.getParameter(request, "dept");
String deptCodeRequest = ParserUtil.getParameter(request, "deptCodeRequest");
String deptDescRequest = null;
String deptCodeResponse = ParserUtil.getParameter(request, "deptCodeResponse");
String deptDescResponse = null;
String corporationName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "corporationName"));
String businessType = ParserUtil.getParameter(request, "businessType");
String businessNature = ParserUtil.getParameter(request, "businessNature");
String businessInfo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "businessInfo"));
String contractDateFrom = ParserUtil.getParameter(request, "contractDateFrom");
String contractDateTo = ParserUtil.getParameter(request, "contractDateTo");
String optCurrency = ParserUtil.getParameter(request, "optCurrency");
String optAmount = ParserUtil.getParameter(request, "optAmount");
String optUnit = ParserUtil.getParameter(request, "optUnit");
String status = ParserUtil.getParameter(request, "status");
String corporationCode = ParserUtil.getParameter(request, "corporationCode");
String contractRemark = ParserUtil.getParameter(request, "contractRemark");
if ("Write a comment...".equals(contractRemark)) {
	contractRemark = "";
}

String deptTemp = null;
String firstContactDate = ParserUtil.getParameter(request, "firstContactDate");
String updateDate = ParserUtil.getParameter(request, "updateDate");
String progress = ParserUtil.getParameter(request,"progress");

String contingency = ParserUtil.getParameter(request, "contingency");
String[] assoDeptCodeRequestId = (String[]) request.getAttribute("assoDeptCodeRequestId_StringArray");
String[] assoDeptCodeRequest = (String[]) request.getAttribute("assoDeptCodeRequest_StringArray");

String relatedHAAID = ParserUtil.getParameter(request, "relatedHAAID");
//Add new fields
String reminder1 = ParserUtil.getParameter(request, "reminder1");
String reminder2 = ParserUtil.getParameter(request, "reminder2");


String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

//new data for upload file email alert. don leung, 08/11/2022
//insert available site, don leung, 09/11/2022
StringBuffer availableSiteContact = new StringBuffer();	
ArrayList<ReportableListObject> recordSite = UtilDBWeb.getReportableList("SELECT CO_SITE_CODE, CO_SITE_SHORT FROM CO_SITE");
if(recordSite.size() > 0){
	for(int i = 0; i < recordSite.size();i ++){
		ReportableListObject row = (ReportableListObject) recordSite.get(i);
		String site = ParserUtil.getParameter(request, row.getValue(1));
		if(site != null && !"".equals(site)){
			if(availableSiteContact.length() <= 0){
				availableSiteContact.append(site);
			}else{
				availableSiteContact.append("," + site);
			}			
		}
	}
}

String avaliableSite = "";
ArrayList record = null;			


boolean isExternal = false;
String docCode = null;
if ("marketing".equals(moduleCode)) {
	isExternal = false;
	docCode = "bam";
} else {
	isExternal = true;
	docCode = "bae";
}
String docID = "";
String[] file1 = null;
if (fileUpload) {
	// create new record
	if ("create".equals(command) && "1".equals(step)) {
		// get project id with dummy data
		baID = BillingAgreementDB.add(userBean, moduleCode);
	}

	String[] fileList = (String[]) request.getAttribute("filelist");
//Add KPI and Evaluation attachments
	String[] file4 = (String[]) request.getAttribute("file4_StringArray");
	String[] file3 = (String[]) request.getAttribute("file3_StringArray");
////	
	String[] file2 = (String[]) request.getAttribute("file2_StringArray");
	file1 = (String[]) request.getAttribute("file1_StringArray");
	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("Billing Agreement");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(docCode);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(baID);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("upload");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("Billing Agreement");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(docCode);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(baID);
		String webUrl = tempStrBuffer.toString();
//Add KPI
		if (file3 != null) {
			for (int i = 0; i < file3.length; i++) {
				FileUtil.moveFile(
						ConstantsServerSide.UPLOAD_FOLDER + File.separator + file3[i],
						baseUrl + "kpi" + ConstantsVariable.DOT_VALUE + file3[i]);
						DocumentDB.add(userBean, docCode+".kpi", baID, webUrl, "kpi" +ConstantsVariable.DOT_VALUE +file3[i]);
						message = "kpi attached.";
			}
		}
//Add Evaluation
		if (file4 != null) {
			for (int i = 0; i < file4.length; i++) {
				FileUtil.moveFile(
						ConstantsServerSide.UPLOAD_FOLDER + File.separator + file4[i],
						baseUrl + "evaluation" + ConstantsVariable.DOT_VALUE + file4[i]);
						DocumentDB.add(userBean, docCode+".evaluation", baID, webUrl, "evaluation" +ConstantsVariable.DOT_VALUE +file4[i]);
						message = "evaluation attached.";
			}
		}
////
		if (file2 != null) {
			for (int i = 0; i < file2.length; i++) {
				FileUtil.moveFile(
						ConstantsServerSide.UPLOAD_FOLDER + File.separator + file2[i],
						baseUrl + "contingency" + ConstantsVariable.DOT_VALUE + file2[i]);
						DocumentDB.add(userBean, docCode+".contingency", baID, webUrl, "contingency" +ConstantsVariable.DOT_VALUE +file2[i]);
						message = "contingency attached.";
			}
			
		}
		if (file1 != null) {
			for (int i = 0; i < fileList.length; i++) {
				FileUtil.moveFile(
					ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
					baseUrl + fileList[i]
				);
				docID += DocumentDB.add(userBean, docCode, baID, webUrl, fileList[i])+",";
				message = "file attached.";
			}
			
		}
	}
}

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean requestAction = false;
boolean approveAction = false;
boolean updateProgressAction = false;
boolean attachmentAction = false;
boolean closeAction = false;


System.out.println("command="+command+", step="+step);

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("request".equals(command)) {
	requestAction = true;
} else if ("approve".equals(command)) {
	approveAction = true;
} else if ("attachment".equals(command)) {
	attachmentAction = true;
} else if ("updateProgress".equals(command)) {
	updateProgressAction = true;
}

try {
		
	if ("1".equals(step)) {
		if (createAction) {
			// initial create id
			if (baID == null) {
				baID = BillingAgreementDB.add(userBean, moduleCode);
			}

			// call db insert corporation name, business type
			if (BillingAgreementDB.update(userBean, moduleCode, baID,
					deptCodeRequest, deptCodeResponse, corporationName,
					businessType, businessNature, businessInfo,
					contractDateFrom, contractDateTo,
					optCurrency, optAmount, optUnit,
					status, corporationCode, contractRemark,  reminder1, reminder2, availableSiteContact.toString())) {			

				if (isExternal) {
					BillingAgreementDB.sendEMail(userBean, moduleCode, baID, "Add New");
				}

				// save associate request department
				String[] assReqID = null;
				if (assoDeptCodeRequest != null) {
					assReqID = new String[assoDeptCodeRequest.length];
					for (int i = 0; i < assoDeptCodeRequest.length; i++) {
						// create
						assReqID[i] = BillingAgreementDB.insertAssoDept(userBean, moduleCode, baID, assoDeptCodeRequest[i]);
					}
				}

				if (isExternal) {
					BillingAgreementDB.updateApproval(userBean, moduleCode, baID,
							deptCodeRequest, businessInfo, optCurrency, optAmount,
							optUnit, contractRemark, assoDeptCodeRequest, assReqID, "1",
							contractDateFrom, contractDateTo, false);
					message = "External Service Providers Register created.";
				} else {
					message = "Billing agreement created.";
				}

				createAction = false;
			} else {
				if (isExternal) {
					errorMessage = "External Service Providers Register create fail.";
				} else {
					errorMessage = "Billing agreement create fail.";
				}
			}
		} else if (updateAction) {			
			// call db update corporation name, business type			
			
			if (BillingAgreementDB.update(userBean, moduleCode, baID,
					deptCodeRequest, deptCodeResponse, corporationName,
					businessType, businessNature, businessInfo,
					contractDateFrom, contractDateTo,
					optCurrency, optAmount, optUnit,
					status, corporationCode, contractRemark,contingency==null?"":contingency, reminder1, reminder2, availableSiteContact.toString())) {
				
				// delete all first
				BillingAgreementDB.deleteAllChild(userBean, moduleCode, baID);

				// save associate request department
				if (assoDeptCodeRequest != null) {
					for (int i = 0; i < assoDeptCodeRequest.length; i++) {
						if (assoDeptCodeRequestId != null &&
								assoDeptCodeRequestId[i] != null && !assoDeptCodeRequestId[i].isEmpty()) {
							// update
							BillingAgreementDB.updateAssoDept(userBean, moduleCode,
									assoDeptCodeRequestId[i], baID, assoDeptCodeRequest[i]);
						} else {
							// create
							assoDeptCodeRequestId[i] = BillingAgreementDB.insertAssoDept(userBean, moduleCode, baID, assoDeptCodeRequest[i]);							
						}
					}
				}

				if (isExternal) {
					BillingAgreementDB.updateApproval(userBean, moduleCode, baID,
							deptCodeRequest, businessInfo, optCurrency, optAmount,
							optUnit, contractRemark, assoDeptCodeRequest, assoDeptCodeRequestId, renewID,
							contractDateFrom, contractDateTo, true);
					BillingAgreementDB.sendEMail(userBean, moduleCode, baID, "Update Agreement");
					message = "External Service Providers Register updated.";
				} else {
					message = "Billing agreement updated.";
				}

				updateAction = false;
			} else {
				if (isExternal) {
					System.out.println("[checkitem.jsp] external update error: moduleCode=" + moduleCode + " baID=" + baID + 
						" deptCodeRequest=" + deptCodeRequest + " deptCodeResponse=" + deptCodeResponse + " corpName= " + corporationName +		
						" businessType=" + businessType + " businessNature=" + businessNature + " businessInfo=" + businessInfo +
						" contractDateFrom=" + contractDateFrom + " contractDateTo=" + contractDateTo +
						" optCurrency=" + optCurrency + " optAmount=" + optAmount + " optUnit=" + optUnit +
						" status=" + status + " corporationCode=" + corporationCode + " contractRemark=" + contractRemark + 
						" contingency=" + contingency + " reminder1=" + reminder1 + " reminder2=" + reminder2 + " availableSite=" + availableSiteContact.toString());								
					
					errorMessage = "External Service Providers Register update fail.";
				} else {
					errorMessage = "Billing agreement update fail.";
				}
			}
			deleteAction = false;
		} else if (deleteAction) {
			// call db delete
			if (BillingAgreementDB.delete(userBean, moduleCode, baID)) {
				if (isExternal) {
					BillingAgreementDB.sendEMail(userBean, moduleCode, baID, "Delete Agreement");
					message = "External Service Providers Register deleted.";
				} else {
					message = "Billing agreement deleted.";
				}

				deleteAction = false;
			} else {
				if (isExternal) {
					errorMessage = "External Service Providers Register delete fail.";
				} else {
					errorMessage = "Billing agreement delete fail.";
				}
			}
			deleteAction = false;
		} else if (requestAction) {
			// call db update new contract date
			String newRenewID = BillingAgreementDB.addApproval(userBean, moduleCode, baID,
					contractDateFrom, contractDateTo);

			if (newRenewID != null) {

				if (isExternal) {
					BillingAgreementDB.updateApproval(userBean, moduleCode, baID, deptCodeRequest, businessInfo,
							optCurrency, optAmount, optUnit, contractRemark, assoDeptCodeRequest,
							assoDeptCodeRequestId, newRenewID);
					
					BillingAgreementDB.updateReminders(baID, reminder1, reminder2);
										
					if (isExternal) {
						BillingAgreementDB.sendEMail(userBean, moduleCode, baID, "Renew Agreement");
						//message = "External Service Providers Register new contract date is waiting for approval.";
						
						System.out.println("[Billing Agreement] auto approve baID="+baID+", newRenewID="+newRenewID);
						// auto approve
						BillingAgreementDB.confirmApproval(userBean, moduleCode, baID, newRenewID, isExternal);
						message = "External Service Providers Register new contract date is renewed.";
					} else {
						message = "Billing agreement new contract date is waiting for approval.";
					}
				}
				requestAction = false;
			} else {
				if (isExternal) {
					errorMessage = "External Service Providers Register new contract date fail to add.";
				} else {
					errorMessage = "Billing agreement new contract date fail to add.";
				}
			}
		} else if (approveAction) {
			// call db update new contract date
			if (BillingAgreementDB.confirmApproval(userBean, moduleCode, baID, renewID, isExternal)) {
				if (isExternal) {
					message = "External Service Providers Register new contract date is approved.";
				} else {
					message = "Billing agreement new contract date is approved.";
				}

				approveAction = false;
			} else {
				if (isExternal) {
					errorMessage = "External Service Providers Register new contract date fail to approve.";
				} else {
					errorMessage = "Billing agreement new contract date fail to approve.";
				}
			}
		} else if (updateProgressAction) {
			// call db update complete date
			BillingAgreementDB.updateProgress(userBean, baID, dept, progress, firstContactDate);
			updateProgressAction = false;
		}
		step = null;

		if (isExternal && fileUpload) {
			if (docID != null && docID.length() > 0) {
				String[] docIDArray = docID.substring(0, docID.length()-1).split(",");

				for(int i = 0; i < docIDArray.length; i++) {
					BillingAgreementDB.updateDoc(userBean, moduleCode, baID, docIDArray[i], attachmentAction);
				}
			}
		}
	} else if (createAction) {
		deptCodeRequest = userBean.getDeptCode();
		deptCodeResponse = userBean.getDeptCode();
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
						
		if (baID != null && baID.length() > 0) {
			// clear expired file
			//BillingAgreementDB.expiredContract(userBean, baID);

			record = BillingAgreementDB.get(userBean, moduleCode, baID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				corporationName = row.getValue(1);
				businessType = row.getValue(2);
				businessNature = row.getValue(3);
				contractDateFrom = row.getValue(4);
				contractDateTo = row.getValue(5);
				status = row.getValue(6);
				corporationCode = row.getValue(8);
				contractRemark = row.getValue(9);
				deptCodeRequest = row.getValue(10);
				deptDescRequest = row.getValue(11);
				deptCodeResponse = row.getValue(12);
				deptDescResponse = row.getValue(13);
				businessInfo = row.getValue(14);
				optCurrency = row.getValue(15);
				optAmount = row.getValue(16);
				optUnit = row.getValue(17);
				contingency = row.getValue(18);
				reminder1 = row.getValue(19);
				reminder2 = row.getValue(20);
				avaliableSite = row.getValue(22);
				
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}

		if (!isExternal) {
			relatedHAAID = BillingAgreementDB.getRelatedHAAID(corporationName);
		}
	}
	
} catch (Exception e) {
	System.out.println("[checkitem.jsp] DEBUG: Exception");
	e.printStackTrace();
}

//send email for new file has been uploaded, 07/11/2022, don leung
if (file1 != null && !isExternal) {	
	if(recordSite.size() > 0){
		for(int i = 0; i < recordSite.size();i ++){
			ReportableListObject row = (ReportableListObject) recordSite.get(i);
			String site = ParserUtil.getParameter(request, row.getValue(1));
			if(site!= null && !"".equals(site)){
				String siteCode = row.getValue(0).substring(row.getValue(0).lastIndexOf("_") + 1);
				BillingAgreementDB.sendFileEMail(siteCode, record, availableSiteContact.toString());
			}
		}
	}
	
}

// get associate department code request
//ArrayList assoDeptRecord = null;
ArrayList assoDeptRecord = BillingAgreementDB.getChildList(moduleCode, baID);
request.setAttribute("assoDeptRecord", assoDeptRecord);

if (baID != null) {
	if (isExternal) {
		request.setAttribute("progress", BillingAgreementDB.getApprovalList(userBean, moduleCode, baID));
	} else {
		request.setAttribute("progress", BillingAgreementDB.getProgress(userBean, baID));
	}
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction || updateProgressAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else if (requestAction) {
		commandType = "request";
	} else {
		commandType = "view";
	}

	// set submit label
	String title = null;
	String corporateNameLabel = null;
	String businessTypeLabel = null;
	if (isExternal) {
		title = "function.ba.external." + commandType;
		corporateNameLabel = "Company Name";
		//businessTypeLabel = "Nature of Services";
		businessTypeLabel = "Contract Category";
	} else {
		title = "function.ba." + commandType;
		corporateNameLabel = "AR Company Name";
		businessTypeLabel = "Service Type";
	}

	// update command type
	if (updateProgressAction) {
		commandType = "updateProgress";
	}
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<%Map<String, String> tooltipMap = new HashMap<String, String>();
tooltipMap.put("healthAssessment","Link the company to the same Company in Health Assessment");
tooltipMap.put("coTitle","use the same company name in health Assessment if want to link the company to health Assessment");
%>

<form name="form1" enctype="multipart/form-data" action="checkitem.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
<%if (isExternal) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Department/ Cost Centre</td>
		<td class="infoData" width="70%">
<%
	String curAssoDeptCodeRequestId = null;
	String curAssoDeptCodeRequest = null;
%>
<%	if (createAction || updateAction || (isExternal && requestAction)) {	%>
			<select name="deptCodeRequest">
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCodeRequest %>" />
	<jsp:param name="category" value="costCentre" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			</select>
			<div><div class="infoLabelInData">Involved Department(s):</div>
				<button onclick="return false;" class="btn-click addAssoDeptCodeRequest" style="margin: 5px;"><bean:message key="button.add" /></button>
				<display:table id="rowAssoDeptCodeRequest" name="requestScope.assoDeptRecord"
						class="tablesorter" style="width: 400px">
					<display:setProperty name="basic.empty.showtable" value="true" />
						<display:setProperty name="basic.msg.empty_list_row" value="" />
						<display:column title="&nbsp;" media="html" style="width:5%"><c:out value="${rowAssoDeptCodeRequest_rowNum}"/>)</display:column>
						<display:column title="Department" style="width:90%">
<%
	curAssoDeptCodeRequestId = ((ReportableListObject)pageContext.getAttribute("rowAssoDeptCodeRequest")).getFields0();
	curAssoDeptCodeRequest = ((ReportableListObject)pageContext.getAttribute("rowAssoDeptCodeRequest")).getFields10();
%>
						<input type="hidden" name="assoDeptCodeRequestId" value="<%=curAssoDeptCodeRequestId %>" />
						<select name="assoDeptCodeRequest">
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=curAssoDeptCodeRequest %>" />
				<jsp:param name="category" value="costCentre" />
				<jsp:param name="allowAll" value="Y" />
			</jsp:include>
						</select>
					</display:column>
					<display:column title="&nbsp;" media="html" style="width:5%">
						<a href="#" class="removeAssoDeptCodeRequest"><img src="<html:rewrite page="/images/remove-button.gif" />" alt="<bean:message key="button.delete" />" /></a>
					</display:column>
				</display:table>
			</div>
<% 	} else { %>
			<%=deptDescRequest == null ? "" : deptDescRequest%>
			<input type="hidden" name="deptCodeRequest" value="<%=deptCodeRequest %>">
			<div><div class="infoLabelInData">Involved Department(s):</div>
<%
		for (int i = 0; i < assoDeptRecord.size(); i++) {
			ReportableListObject row = (ReportableListObject) assoDeptRecord.get(i);
			curAssoDeptCodeRequestId = row.getValue(0);
			curAssoDeptCodeRequest = row.getValue(11);
%>
				<input type="hidden" name="assoDeptCodeRequestId" value="<%=curAssoDeptCodeRequestId %>" />
				<div><%=curAssoDeptCodeRequest %></div>
<%
		}
%>
			</div>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Responsible Department</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {	%>
			<select name="deptCodeResponse">
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCodeResponse %>" />
	<jsp:param name="category" value="costCentre" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			</select>
<% 	} else { %>
			<%=deptDescResponse == null ? "" : deptDescResponse%>
			<input type="hidden" name="deptCodeResponse" value="<%=deptCodeResponse %>">
<%	} %>
		</td>
	</tr>
<%	} %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%=corporateNameLabel %></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
		<input type="text" title="<%=tooltipMap.get("coTitle") %>" name="corporationName" value="<%=corporationName==null?"":corporationName %>" maxlength="100" size="50">
<%	} else {%>
		<%=corporationName %>
<%	} %>
		</td>
	</tr>
<%if (!isExternal) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">AR Code</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
		<input type="text"  name="corporationCode" value="<%=corporationCode==null?"":corporationCode %>" maxlength="200" size="50">
<%	} else {%>
		<%=corporationCode %>
<%	} %>
		</td>
	</tr>
<%} %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%=businessTypeLabel %></td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
		<select name="businessType">
			<jsp:include page="../ui/serviceTypeCMB.jsp" flush="false">
				<jsp:param name="moduleCode" value="<%=moduleCode %>" />
				<jsp:param name="businessType" value="<%=businessType %>" />
			</jsp:include>
		</select>
<%	} else {%>
<%		if ("IP".equals(businessType)) { %>
			In-Patient
<%		} else if ("OP".equals(businessType)) { %>
			OutPatient
<%		} else if ("Both".equals(businessType)) { %>
			InPatient & OutPatient
<%		} else if (businessType != null) { %>
			<%=businessType %>
<%		} %>
<%	} %>
		</td>
	</tr>
<%if (!isExternal) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Business Nature</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
		<select name="businessNature">
			<option value=""<%="".equals(businessNature)?" selected":"" %>></option>
			<option value="BR"<%="BR".equals(businessNature)?" selected":"" %>>Broker</option>
			<option value="CE"<%="CE".equals(businessNature)?" selected":"" %>>Corporate</option>
			<option value="IC"<%="IC".equals(businessNature)?" selected":"" %>>Insurance Company</option>
			<option value="TPA"<%="TPA".equals(businessNature)?" selected":"" %>>TPA</option>
		</select>
<%	} else {%>
		<%="BR".equals(businessNature)?"Broker":("CE".equals(businessNature)?"Corporate":("IC".equals(businessNature)?"Insurance Company":("TPA".equals(businessNature)?"TPA":""))) %>
<%	} %>
		</td>
	</tr>
<%	if (!createAction) { %>
	<tr class="smallText">
		<td class="infoLabel" title="<%=tooltipMap.get("healthAssessment") %>" width="30%">Connection to Health Assessment Agreement</td>
		<td class="infoData" width="70%">
			<button title="<%=tooltipMap.get("healthAssessment") %>" onclick="return submitAction('viewHAA', 0, 0);" class="btn-click"><bean:message key="button.view" /></button>
		</td>
	</tr>
<%	} %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Case Summary</td>
		<td class="infoData" width="70%">
<%	if (!createAction) {
		String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE; %>
		<span id="showDocument_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="<%=docCode %>" />
	<jsp:param name="keyID" value="<%=baID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
		</span>
<%	}
	if (createAction || updateAction) {%>
		<input type="file" name="file1" size="50" class="multi" maxlength="10">
<%	} %>
		</td>
	</tr>
<%} else { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Contract Content</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction || (isExternal && requestAction)) {%>
		<input type="text" name="businessInfo" value="<%=businessInfo==null?"":businessInfo %>" maxlength="300" size="100">
<%	} else {%>
		<%=businessInfo == null ? "" : businessInfo %>
<%	} %>
		</td>
	</tr>
<%if (isExternal) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Contingency when there is cessation of service</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
		<select name="contingency">
			<option value=""<%="".equals(contingency)?" selected":"" %>></option>
			<option value="Yes"<%="Yes".equals(contingency)?" selected":"" %>>Yes</option>
			<option value="WIP"<%="WIP".equals(contingency)?" selected":"" %>>WIP</option>
			<option value="NA"<%="NA".equals(contingency)?" selected":"" %>>N/A</option>
		</select>
<%	} else {%>
		<%="Yes".equals(contingency)?"Yes":("WIP".equals(contingency)?"WIP":("NA".equals(contingency)?"N/A":"")) %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Contingency Document</td>
		<td class="infoData" width="70%">
<%	if (!createAction) {
		String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE; %>
		<%String fileModuleCode =docCode+".contingency"; %>
		<span id="showDocument_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="<%=fileModuleCode %>" />
	<jsp:param name="keyID" value="<%=baID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
		</span>
<%	}
//	if (createAction || updateAction || requestAction) {%>
		<input type="file" name="file2" size="50" class="multi" maxlength="10">
<%//} %>
		</td>
	</tr>
<%} %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Attachment</td>
		<td class="infoData" width="70%">
<%	if (!createAction && !isExternal) {
		String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE; %>
		<span id="showDocument_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="<%=docCode %>" />
	<jsp:param name="keyID" value="<%=baID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
		</span>
<%	}
//	if (createAction || updateAction || requestAction) {%>
		<input type="file" name="file1" size="50" class="multi" maxlength="10">
<%//} %>
		</td>
	</tr>

<%//20221130 Arran added KPI and Evaluation for external
if (isExternal) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">KPI</td>
		<td class="infoData" width="70%">
<%	if (!createAction) {
		String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE; %>
		<%String fileModuleCode =docCode+".kpi"; %>
		<span id="showDocument_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="<%=fileModuleCode %>" />
	<jsp:param name="keyID" value="<%=baID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
		</span>
<%	} %>		
		<input type="file" name="file3" size="50" class="multi" maxlength="10">
		</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="30%">Evaluation</td>
		<td class="infoData" width="70%">
<%	if (!createAction) {
		String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE; %>
		<%String fileModuleCode =docCode+".evaluation"; %>
		<span id="showDocument_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="<%=fileModuleCode %>" />
	<jsp:param name="keyID" value="<%=baID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
		</span>
<%	} %>			
		<input type="file" name="file4" size="50" class="multi" maxlength="10">
		</td>
	</tr>
<%} 
//20221130 End%>

	<tr class="smallText">
		<td class="infoLabel" width="30%">Amount (Optional)</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction || (isExternal && requestAction)) {%>
			<select name="optCurrency">
				<option value=""<%="".equals(optCurrency)?" selected":"" %>>N/A</option>
				<option value="HKD"<%="HKD".equals(optCurrency)?" selected":"" %>>HKD</option>
				<option value="USD"<%="USD".equals(optCurrency)?" selected":"" %>>USD</option>
			</select>
			<input type="text" name="optAmount" value="<%=optAmount==null?"":optAmount %>" maxlength="10" size="10">
			<select name="optUnit">
				<option value=""<%="".equals(optUnit)?" selected":"" %>>N/A</option>
				<option value="per month"<%="per month".equals(optUnit)?" selected":"" %>>per month</option>
				<option value="per year"<%="per year".equals(optUnit)?" selected":"" %>>per year</option>
				<option value="3 months"<%="3 months".equals(optUnit)?" selected":"" %>>3 months</option>
				<option value="6 months"<%="6 months".equals(optUnit)?" selected":"" %>>6 months</option>
				<option value="1 year"<%="1 year".equals(optUnit)?" selected":"" %>>1 year</option>
				<option value="18 months"<%="18 months".equals(optUnit)?" selected":"" %>>18 months</option>
				<option value="2 years"<%="2 years".equals(optUnit)?" selected":"" %>>2 years</option>
				<option value="3 years"<%="3 years".equals(optUnit)?" selected":"" %>>3 years</option>
			</select>
<%	} else {%>
		<%=optCurrency == null ? "" : optCurrency %>
		<%=optAmount == null ? "" : optAmount %>
		<%=optUnit == null ? "" : optUnit %>
<%	} %>
		</td>
	</tr>
<%} %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Contract Date</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
		<input type="text" name="contractDateFrom" id="contractDateFrom" class="datepickerfield" value="<%=contractDateFrom==null?"":contractDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
		-
		<input type="text" name="contractDateTo" id="contractDateTo" class="datepickerfield" value="<%=contractDateTo==null?"":contractDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
<%	} else {%>
		<%=contractDateFrom==null?"":contractDateFrom %> - <%=contractDateTo==null?"":contractDateTo %>
<%	} %>
		</td>
	</tr>
<%	if (requestAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">New Contract Date</td>
		<td class="infoData" width="70%">
		<input type="text" name="contractDateFrom" id="contractDateFrom" class="datepickerfield" value="<%=contractDateFrom==null?"":contractDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
		-
		<input type="text" name="contractDateTo" id="contractDateTo" class="datepickerfield" value="<%=contractDateTo==null?"":contractDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
		</td>
	</tr>
<%	} %>

<%//20221130 Arran added reminders for external
if (isExternal) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">1st email reminder</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction ) {%>		
		<input type="text" name="reminder1" id="reminder1" class="datepickerfield" value="<%=reminder1==null?"":reminder1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
<%	} else if (requestAction) {%>		
		<input type="text" name="reminder1" id="reminder1" class="datepickerfield" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">		
<%	} else {%>
		<%=reminder1==null?"":reminder1 %>
<%	} %>		
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">2nd email reminder</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction ) {%>		
		<input type="text" name="reminder2" id="reminder2" class="datepickerfield" value="<%=reminder2==null?"":reminder2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
<%	} else if (requestAction) {%>	
		<input type="text" name="reminder2" id="reminder2" class="datepickerfield" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
<%	} else {%>
		<%=reminder2==null?"":reminder2 %>
<%	} %>		
		</td>
	</tr>
<%} 
//20221130 End%>

	<tr class="smallText">
		<td class="infoLabel" width="30%">Status</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
			<select name="status">
				<option value="1"<%="1".equals(status)?" selected":"" %>>Active</option>
				<option value="6"<%="6".equals(status)?" selected":"" %>>Declined</option>
				<option value="2"<%="2".equals(status)?" selected":"" %>>Expired</option>
				<option value="3"<%="3".equals(status)?" selected":"" %>>In Progress</option>
				<option value="4"<%="4".equals(status)?" selected":"" %>>Pending for Signature</option>
				<option value="5"<%="5".equals(status)?" selected":"" %>>Suspended</option>
				<option value="7"<%="7".equals(status)?" selected":"" %>>Terminated</option>
			</select>
<%	} else {%>
		<%="1".equals(status)?"Active":("2".equals(status)?"Expired":("3".equals(status)?"In Progress":("4".equals(status)?"Pending for Signature":("5".equals(status)?"Suspended":("6".equals(status)?"Declined":"Terminated"))))) %>
<%	} %>
		</td>
	</tr>
    <tr class="smallText">
		<td class="infoLabel" width="30%">Remark</td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction || (isExternal && requestAction)) {%>
			<textarea name="contractRemark" rows="6" cols="90"><%=contractRemark == null ? "" : contractRemark %></textarea>
<%		} else {%>
			<%=contractRemark==null?"":contractRemark %>
<%		} %>
		</td>
	</tr>
	<!-- new added checkbox can be selected if the contract is for all sites, don leung, 4/11/2022 -->
	<%
	if((updateAction || createAction) && !isExternal){%>
		<tr class="smallText">
			<td class="infoLabel" width="30%">Sites</td>
			<td class="infoData" width="70%">
			<%			
			String[] siteArray = avaliableSite.split(",");
		    if(recordSite.size() > 0){
		    	for(int i = 0; i < recordSite.size();i ++){
		    		ReportableListObject row = (ReportableListObject) recordSite.get(i);
		    		String siteCode = row.getValue(0);
		    		String siteDesc = row.getValue(1);
					for(int c = 0; c < siteArray.length; c ++){
						if(siteArray[c].equals(siteDesc)){%>						
							<input type="checkbox" id="<%=siteDesc %>" name="<%=siteDesc %>" value="<%=siteDesc %>" checked> <%=siteDesc %>
							<%break;
						}else if(c + 1 == siteArray.length){%>
							<input type="checkbox" id="<%=siteDesc %>" name="<%=siteDesc %>" value="<%=siteDesc %>"> <%=siteDesc %> 
						<%}
					}
		    	}
		    }
			%>

			</td>
		</tr>
	<!-- ****************************************************************************************** -->
	<%}
	%>
	
	
</table>
<%	if (!updateProgressAction) { %>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction || requestAction) { %>
		<button onclick="return submitAction('<%=commandType %>', 1, 0);" class="btn-click"><bean:message key="button.save" /></button>
		<button onclick="return submitAction('view', 0, 0);" class="btn-click"><bean:message key="button.cancel" /></button>
<%	} else { 
		//new add for filter external and not external button, don leung, 05/12/2022
		if(isExternal){%>
			<button onclick="return submitAction('attachment', 1, 0);" class="btn-click">Attachment Only</button>
	<%		if (userBean.isAccessible("function.ba.external.request")) {%>
				<button onclick="return submitAction('request', 0, 0);" class="btn-click"><bean:message key="function.ba.renew.request" /></button>
	<%		} %>
	<%	}
%>
		
<%		if ((!isExternal && userBean.isAccessible("function.ba.update"))
			|| (isExternal && userBean.isAccessible("function.ba.external.update"))) {%>
		<button onclick="return submitAction('update', 0, 0);" class="btn-click"><bean:message key="function.ba.update" /></button>
<%		} %>
<%		if ((!isExternal && userBean.isAccessible("function.ba.delete"))
			|| (isExternal && userBean.isAccessible("function.ba.external.delete"))) {%>
		<button class="btn-delete"><bean:message key="function.ba.delete" /></button>
<%		} %>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<%	} %>
<%	if (!createAction && !updateAction && !requestAction) {%>
<bean:define id="functionLabel"><bean:message key="function.ba.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.progress" export="false" class="tablesorter">
<%		if (isExternal) { %>
	<display:column property="fields7" title="Department/ Cost Centre" style="width:8%"/>
	<display:column property="fields8" title="Involved Department(s)" style="width:15%"/>
	<display:column property="fields9" title="Contract Content" style="width:10%"/>
	<display:column property="fields10" title="Amount (Optional)" style="width:10%"/>
	<display:column property="fields1" title="Contract Date From" style="width:10%"/>
	<display:column property="fields2" title="Contract Date To" style="width:10%"/>
	<display:column property="fields11" title="Remark" style="width:15%"/>
<% if (!isExternal) { %>	
	<display:column property="fields3" title="Approval Date" style="width:10%"/>
	<display:column title="Approval By" style="width:15%">
		<logic:equal name="row" property="fields13" value="">
			<c:out value="${row.fields4}" />
		</logic:equal>
		<logic:notEqual name="row" property="fields13" value="">
			<c:out value="${row.fields13}" />
		</logic:notEqual>
	</display:column>
<% } %>	
	<display:column property="fields5" title="Request Date" style="width:10%"/>
	<display:column title="Request By" style="width:15%">
		<logic:equal name="row" property="fields14" value="">
			<c:out value="${row.fields6}" />
		</logic:equal>
		<logic:notEqual name="row" property="fields14" value="">
			<c:out value="${row.fields14}" />
		</logic:notEqual>
	</display:column>
	<display:column title="Attachment" style="width:15%">
		<jsp:include page="../common/document_list.jsp" flush="false">
			<jsp:param name="moduleCode" value="<%=docCode %>" />
			<jsp:param name="keyID" value="<%=baID %>" />
			<jsp:param name="allowRemove" value="<%=ConstantsVariable.YES_VALUE %>" />
			<jsp:param name="docIDs" value="${row.fields12}" />
			<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
			<jsp:param name="separator" value=";" />
			<jsp:param name="displayAll" value="false" />
		</jsp:include>
	</display:column>
	<!-- auto approve when user update agreement -->
<% if (!isExternal) { %>	
	<display:column title="Approve" style="width:10%">
<%			if (userBean.isAccessible("function.ba.external.approve")) { %>
		<logic:equal name="row" property="fields4" value="">
			<button onclick="return submitApprove('<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.approve" /></button>
		</logic:equal>
<%			} %>
	</display:column>
<% } %>
<%		} else { %>
<%			deptTemp = ((ReportableListObject)pageContext.getAttribute("row")).getFields0();  %>
	<display:column property="fields1" title="Department/ Cost Centre" style="width:10%"/>
	<display:column title="Date of First Contact" style="width:10%" >
<%			if (updateProgressAction && deptTemp.equals(dept)) { %>
		<%firstContactDate = ((ReportableListObject)pageContext.getAttribute("row")).getFields2();  %>
		<input type="text" name="firstContactDate" id="firstContactDate" class="datepickerfield" value="<%=firstContactDate==null?"":firstContactDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
<%			} else { %>
		<c:out value="${row.fields2}" />
<%			} %>
		</display:column>
		<display:column  title="Progress" style="width:40%" >
<%			if (updateProgressAction && deptTemp.equals(dept)) { %>
		<%progress = ((ReportableListObject)pageContext.getAttribute("row")).getFields4(); %>
		<div class="box"><textarea id="cleditor" name="progress" rows="6" cols="90"><%=progress == null ? "" : progress %></textarea></div>
<%			} else{ %>
		<%progress = ((ReportableListObject)pageContext.getAttribute("row")).getFields4(); %>
		<%=progress == null ? "" : progress %>
<%			} %>
		</display:column>
		<display:column title="Updated Date" style="width:10%">
<%			if (updateProgressAction && deptTemp.equals(dept)) { %>
<%				updateDate = ((ReportableListObject)pageContext.getAttribute("row")).getFields3();  %>
		<input type="text" name="updateDate" id="updateDate" class="datepickerfield" value="<%=updateDate==null?"":updateDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
<%			} else { %>
		<c:out value="${row.fields3}" />
<%			} %>
		</display:column>
		<display:column title="Action" style="width:10%">
<%			if (updateProgressAction && deptTemp.equals(dept)) { %>
		<button onclick="return submitAction('<%=commandType %>', 1, '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.save" /></button>
		<button onclick="return submitAction('view', 0, '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.cancel" /></button>
<%			} else { %>
		<button onclick="return submitAction('updateProgress', 0, '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.update" /></button>
<%			}  %>
	</display:column>
<%		} %>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	} %>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="moduleCode" value="<%=moduleCode %>">
<input type="hidden" name="baID" value="<%=baID==null?"":baID %>">
<input type="hidden" name="renewID" value="<%=renewID==null?"":renewID %>">
<input type="hidden" name="relatedHAAID" value="<%=relatedHAAID %>">
<input type="hidden" name="dept">
</form>
<script language="javascript">
$().ready(function() {
   	// Associate response department code

	$('button.addAssoDeptCodeRequest').click(function() {
    	var assoDeptCodeRequestRow = $('div#hiddenAssoDeptCodeRequestRow').html();
    	assoDeptCodeRequestRow = assoDeptCodeRequestRow.replace(/<table>/ig, "")
			.replace(/<\/table>/ig, "").replace(/<tbody>/ig, "").replace(/<\/tbody>/ig, "");

    	if ($.browser.msie) {
    		 $(assoDeptCodeRequestRow).appendTo('#rowAssoDeptCodeRequest');
    	} else {
	    	$('#rowAssoDeptCodeRequest tr:last').after(assoDeptCodeRequestRow);
		}

        $('a.removeAssoDeptCodeRequest').click(function() {
    		$(this).parent().parent().remove();
    	});
    });

    $('a.removeAssoDeptCodeRequest').click(function() {
    	$(this).parent().parent().remove();
    });
});

function removeAssoDeptCodeRow(selectObj) {
	$(selectObj).parent().parent().remove();
}

$('td[title]').qtip({
	   content: $(this).attr('title'),
	   show: 'mouseover',
	   hide: 'mouseout',
	   position: { target: 'mouse' },
	   style: {
		      border: {
		         width: 3,
		         radius: 8,
		         color: '#6699CC',
		         tip: 'leftMiddle'
		      },
		      width: 200
		}
	});

$('input[title]').qtip({
	   content: $(this).attr('title'),
	   show: 'mouseover',
	   hide: 'mouseout',
	   position: { target: 'mouse' },
	   style: {
		      border: {
		         width: 3,
		         radius: 8,
		         color: '#6699CC',
		         tip: 'leftMiddle'
		      },
		      width: 200
		}
	});

$('button[title]').qtip({
	   content: $(this).attr('title'),
	   show: 'mouseover',
	   hide: 'mouseout',
	   position: { target: 'mouse' },
	   style: {
		      border: {
		         width: 3,
		         radius: 8,
		         color: '#6699CC',
		         tip: 'leftMiddle'
		      },
		      width: 200
		}
	});

	function isArray(obj) {
	   if (obj.constructor.toString().indexOf("Array") == -1)
	      return false;
	   else
	      return true;
	}

	function submitAction(cmd, stp, dept) {
		if (stp == 1) {
			if (cmd == 'create' || cmd == 'update') {
				if (document.form1.corporationName.value == '') {
					document.form1.corporationName.focus();
					alert("Please input Corporation Name!");
					return false;
				}
				if (document.form1.contractRemark.value.length > 300) {
					alert("Remarks must be less than 300 characters!");
					return false;
				}
				
//20221028 Arran added checking
			<% if (isExternal) { %>	
				if (document.form1.contractDateFrom.value == '') {
					document.form1.contractDateFrom.focus();
					alert("Please input Contract Date!");
					return false;
				}
				if (!validDate(document.form1.contractDateFrom)) {
					document.form1.contractDateFrom.focus();
					alert("Invalid Contract Date: " + document.form1.contractDateFrom.value);
					return false;
				}				
				if (document.form1.contractDateTo.value == '') {
					document.form1.contractDateTo.focus();
					alert("Please input Contract Date!");
					return false;
				}
				if (!validDate(document.form1.contractDateTo)) {
					document.form1.contractDateTo.focus();
					alert("Invalid Contract Date: " + document.form1.contractDateTo.value);
					return false;
				}	
				if (document.form1.reminder1.value == '') {
					document.form1.reminder1.focus();
					alert("Please input 1st email reminder!");
					return false;
				}
				if (!validDate(document.form1.reminder1)) {
					document.form1.reminder1.focus();
					alert("Invalid 1st email reminder: " + document.form1.reminder1.value);
					return false;
				}				
				if (document.form1.reminder2.value == '') {
					document.form1.reminder2.focus();
					alert("Please input 2nd email reminder!");
					return false;
				}
				if (!validDate(document.form1.reminder2)) {
					document.form1.reminder2.focus();
					alert("Invalid 2nd email reminder: " + document.form1.reminder2.value);
					return false;
				}		
				
				var fmt; 
				fmt = document.form1.reminder1.value.split('/');
				var date1 = fmt[2] + fmt[1] + fmt[0];
				
				fmt = document.form1.reminder2.value.split('/');				
				var date2 = fmt[2] + fmt[1] + fmt[0];				
				
				if (date1 >= date2) {
					document.form1.reminder1.focus();
					alert("1st email reminder must be less than 2nd email reminder!");
					return false;
				}
				
				if (navigator.userAgent.indexOf("MSIE") < 0) {
					var date = new Date();
					var today = date.getFullYear() + String(date.getMonth() + 1).padStart(2, '0') + String(date.getDate()).padStart(2, '0');
					
					if (document.form1.reminder1.value != '<%=reminder1%>') {
						if (today >= date1) {
							document.form1.reminder1.focus();
							alert("1st email reminder must be greater than today date!");
							return false;
						}	
					}
					
					if (document.form1.reminder2.value != '<%=reminder2%>') {
						if (today >= date2) {
							document.form1.reminder2.focus();
							alert("2nd email reminder must be greater than today date!");
							return false;
						}	
					}
				}
			<% } %>					
//20221028 End

				// check valid associate dept code response
			} else if (cmd == 'updateDate') {
				if (document.form1.initDate.value == '') {
					document.form1.initDate.focus();
					alert("Please input initiate date!");
					return false;
				}
			}
		}
		if (cmd == "viewHAA") {
			if (document.form1.relatedHAAID.value > 0) {
				callPopUpWindow("../healthAssessment/checkitem.jsp?command=view&HaaID=" + document.form1.relatedHAAID.value);
				return false;
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.dept.value = dept;
		document.form1.submit();
	}

	function submitApprove(rid) {
		document.form1.command.value = 'approve';
		document.form1.step.value = 1;
		document.form1.renewID.value = rid;
		document.form1.submit();
	}

	// ajax
	var http = createRequestObject();

	function removeDocument(mid, did) {
		http.open('get', '../common/document_list.jsp?command=delete&moduleCode=' + mid + '&keyID=<%=baID %>&documentID=' + did + '&allowRemove=<%=updateAction?"Y":"N" %>&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);
		window.location.reload();
		return false;
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4) {
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById('showDocument_indicator').innerHTML = response;
		}
	}

</script>

</DIV>

</DIV></DIV>
<div id="hiddenAssoDeptCodeRequestRow" style="display:none">
	<table>
		<tr>
			<td style="width:5%"></td>
			<td style="width:90%">
				<input type="hidden" name="assoDeptCodeRequestId" value="" />
				<select name="assoDeptCodeRequest">
	<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
		<jsp:param name="deptCode" value="" />
		<jsp:param name="category" value="costCentre" />
		<jsp:param name="allowAll" value="Y" />
	</jsp:include>
				</select>
			</td>
			<td style="width:5%">
				<a href="#" class="removeAssoDeptCodeRequest"><img src="/intranet/images/remove-button.gif" alt="Delete" /></a>
			</td>
		</tr>
	</table>
</div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>