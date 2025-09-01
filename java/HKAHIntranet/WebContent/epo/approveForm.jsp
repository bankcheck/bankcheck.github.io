<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER,
		"UTF-8"		
	);
	
	fileUpload = true;
}

String serverSiteCode = ConstantsServerSide.SITE_CODE;
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String folderID = ParserUtil.getParameter(request, "folderID");
String reqNo = ParserUtil.getParameter(request, "reqNo");	
String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");
String sendMessage = null;

if (fileUpload) {
	String[] fileList = (String[]) request.getAttribute("filelist");

	if (fileList != null) {
		if(folderID!=null && folderID.length()>0){
			System.err.println("[folderID]:"+folderID);				
		}else{
			folderID = EPORequestDB.getFolderId();
		}
		
		StringBuffer tempStrBuffer = new StringBuffer();
		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("epo");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(folderID);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("upload");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("epo");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(folderID);
		String webUrl = tempStrBuffer.toString();

		for (int i = 0; i < fileList.length; i++) {
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + fileList[i]
			);
			DocumentDB.add(serverSiteCode, userBean, "epo", folderID, webUrl, fileList[i]);
		}
	}
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
%>
<%
String deptCode = userBean.getDeptCode();
String reqBy = ParserUtil.getParameter(request, "reqBy");
String reqDate = ParserUtil.getParameter(request, "reqDate");
String reqSiteCode = ParserUtil.getParameter(request, "reqSiteCode");
String reqDept = ParserUtil.getParameter(request, "reqDept");
String reqBugcode = ParserUtil.getParameter(request, "reqBugcode");
String reqDesc = null;
String shipTo = ParserUtil.getParameter(request, "shipTo");
String reqRmk = null;
String aprRmk = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "aprRmk")); 
String reqStatus = ParserUtil.getParameter(request, "reqStatus");
String sendAppTo = ParserUtil.getParameter(request, "sendAppTo");
String amtID = ParserUtil.getParameter(request, "amtID");
String adCouncil = ParserUtil.getParameter(request, "adCouncil");
String boardCouncil = ParserUtil.getParameter(request, "boardCouncil");
String financeComm = ParserUtil.getParameter(request, "financeComm");
String appGrp = ParserUtil.getParameter(request, "appGrp");
System.err.println("0.0[appGrp]:"+appGrp);
if(appGrp == null){
	appGrp = "HKAH";
}
System.err.println("0[appGrp]:"+appGrp);
String approveCredit = null;
String lstRowIdx = null;
String reqByName = null;
String reqStat = null;
String secondApprover = null;
String isExistApprovlGroup = null;

int approveFlag = 0;
int appRight = 1;
int remainCredit = 0;
int alreadyApproval = 0;
String apprId = userBean.getStaffID();

Calendar calendar = Calendar.getInstance();
SimpleDateFormat dateFormat = new SimpleDateFormat("ddMMyyyyHHmmss");
String sysDate = dateFormat.format(calendar.getTime());

boolean updateAction = false;
boolean viewAction = false;
boolean emailAction = false;
boolean closeAction = false;
boolean pendAction = false;

if("view".equals(command)){
	viewAction = true;
}else if ("save".equals(command)) {
	updateAction = true;
}else if ("email".equals(command)) {
	emailAction = true;
}else if ("pend".equals(command)) {
	pendAction = true;	
}

String supplier = null;
String itemDesc = null;
String uom = null;
String qty = null;
String prevQty = null;
String price = null;
String amount = null;
String itemRmk = null;
String itemAppFlag = null;
String itemSeq = null;
String counterNotice = null;
boolean successUptHdr = false;
boolean successInsertLog = false;
int uptDtlFail = 0;
ArrayList record1 = null;


try {
	lstRowIdx = ParserUtil.getParameter(request, "lstRowIdx");
	
	if(updateAction){
		System.err.println("[approveForm][appGrp]:"+appGrp);		
		if("HKAH".equals(appGrp)){
			record1 = ApprovalUserDB.getEpoAppUserList("1", "5", apprId, null, "HKAH");
			if(record1.size()>0){
				ReportableListObject row2 = (ReportableListObject) record1.get(0);
				secondApprover = row2.getValue(0);				
			}		
			
			if(apprId.equals(secondApprover)){
				approveCredit = EPORequestDB.getUseCredit("1","5",apprId,"HKAH");
			}else{
				approveCredit = EPORequestDB.getUseCredit("1","1",apprId,"HKAH");
			}			
		}else{
			approveCredit = EPORequestDB.getUseCredit("1","1",apprId,appGrp);
			System.err.println("[approveCredit]:"+approveCredit);
		}

		
		if(apprId.equals(sendAppTo) && (("H".equals(reqStatus)) || ("F".equals(reqStatus)))){
			reqStatus = "A";
		}
		
		successUptHdr = EPORequestDB.updateHdrStatus(userBean, reqNo, reqStatus, reqRmk, sendAppTo, apprId, sysDate, reqBugcode, adCouncil, boardCouncil, financeComm, approveCredit, amtID);
				
		EPORequestDB.updateApprRmk(reqNo,aprRmk);
		
		for(int i=0;i<=Integer.parseInt(lstRowIdx);i++) {
			if(ParserUtil.getParameter(request, "itemApproval["+i+"].fields13")!=null &&
				ParserUtil.getParameter(request, "itemApproval["+i+"].fields13").length()>0){
				supplier = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "itemSupp[" +i+ "].fields2"));
				itemDesc = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "itemDesc[" +i+ "].fields3"));
				uom = ParserUtil.getParameter(request, "itemUnit[" +i+ "].fields7");				
				qty = ParserUtil.getParameter(request, "itemQty[" +i+ "].fields4");				
				price = ParserUtil.getParameter(request, "itemPrice[" +i+ "].fields6");					
				itemAppFlag = ParserUtil.getParameter(request, "itemApproval["+i+"].fields13");		
				itemSeq = ParserUtil.getParameter(request, "itemSeq["+i+"].fields1");
				
				if(EPORequestDB.updateItemDtl(userBean, reqNo, itemSeq, itemAppFlag, qty, price, sysDate)<0){
					uptDtlFail ++;
				}
				EPORequestDB.addReqDtlLog(userBean, reqNo, Integer.toString(i+1), supplier, itemDesc, qty, amount, price, uom, itemRmk, sysDate, itemAppFlag, itemAppFlag=="1"?sendAppTo:null);
			}

		}

		if (reqNo!=null && reqNo.length()>0) {	
			ArrayList record = EPORequestDB.getRequestHdr(reqNo);
			if(record.size()>0){
				ReportableListObject row = (ReportableListObject) record.get(0);
				reqDate = row.getValue(1);
				reqBy = row.getValue(2);
				reqByName = StaffDB.getStaffFullName2(reqBy);
				reqSiteCode = row.getValue(3);				
				reqDept = row.getValue(4);
				reqBugcode = row.getValue(7);
				amtID = row.getValue(8);				
				reqDesc = row.getValue(6);
				shipTo = row.getValue(5);
				reqRmk = row.getValue(10); 	
				sendAppTo = row.getValue(11); 				
				approveFlag = Integer.parseInt(row.getValue(12));
				adCouncil = row.getValue(14); 	
				boardCouncil = row.getValue(15);
				financeComm = row.getValue(16);
				aprRmk = row.getValue(18);
			}		
		}
		
//		if("R".equals(reqStatus)||"A".equals(reqStatus)){
//			sendAppTo = reqBy;
//		}

		if("A".equals(reqStatus)){
			if(EPORequestDB.sendEmail(reqNo, reqBy, userBean.getStaffID(), sendAppTo, reqDesc, reqStatus, folderID, "1", "1")){
				System.err.println("abcd[reqStatus]:"+reqStatus);
				if((reqBugcode!=null && reqBugcode.length()>0) ||
					(adCouncil!=null && adCouncil.length()>0) ||
					(boardCouncil!=null && boardCouncil.length()>0) ||
					(financeComm!=null && financeComm.length()>0)){
					System.err.println("abcde[reqStatus]:"+reqStatus);
//					if(EPORequestDB.sendEmail(reqNo, null, userBean.getStaffID(), sendAppTo, reqDesc, reqStatus, folderID, "1", "2")){
						if(!apprId.equals(secondApprover)){
							if(EPORequestDB.sendEmail(reqNo, reqBy, userBean.getStaffID(), null, reqDesc, reqStatus, folderID, "1", "3")){
								sendMessage = "mail sent success";							
							}else{
								sendMessage = "mail sent failed(Counter Sent Mail)";		
							}									
						}else{
							sendMessage = "mail sent success";
						}
//					}else{
//						sendMessage = "mail sent failed(To Purchasing)";
//					}
/*
				}else{
// cancel alert to purchase
					if(EPORequestDB.sendEmail(reqNo, null, userBean.getStaffID(), sendAppTo, reqDesc, reqStatus, folderID, "1", "2")){
						sendMessage = "mail sent success";
					}else{
						sendMessage = "mail sent failed(To Purchasing)";
					}
				}
*/
				System.err.println("0.000[sendMessage]:"+sendMessage);
			}else{
				sendMessage = "mail sent success";
			}
				System.err.println("0.00[sendMessage]:"+sendMessage);
			}else{
				sendMessage = "mail sent failed(To Requestor)";
			}
			System.err.println("0.0[sendMessage]:"+sendMessage);
			ArrayList record = EPORequestDB.getRequestHdr(reqNo);

			if(record.size()>0){
				ReportableListObject row = (ReportableListObject) record.get(0);
				reqNo = row.getValue(0);
				reqDate = row.getValue(1);
				reqBy = row.getValue(2);
				reqSiteCode = row.getValue(3);				
				reqByName = StaffDB.getStaffFullName2(reqBy);			
				reqDept = row.getValue(4);
				reqBugcode = row.getValue(7);
				amtID = row.getValue(8);				
				reqDesc = row.getValue(6);
				shipTo = row.getValue(5);
				reqStatus = row.getValue(9);				
				reqRmk = row.getValue(10);
				sendAppTo = row.getValue(11); 				
				approveFlag = Integer.parseInt(row.getValue(12));
				adCouncil = row.getValue(14); 	
				boardCouncil = row.getValue(15);
				financeComm = row.getValue(16);
				aprRmk = row.getValue(18);				
			}
			System.err.println("0[sendMessage]:"+sendMessage);
		}else if("F".equals(reqStatus)){
			if(EPORequestDB.sendEmail(reqNo, null, userBean.getStaffID(), sendAppTo, reqDesc, reqStatus, folderID, "1", "1")&&
					EPORequestDB.sendEmail(reqNo, reqBy, userBean.getStaffID(), sendAppTo, reqDesc, reqStatus, folderID, "1", "1")){
					sendMessage = "mail sent success";
			}else{
				sendMessage = "mail sent failed";				
			}

			ArrayList record = EPORequestDB.getRequestHdr(reqNo);			
			
			if(record.size()>0){
				ReportableListObject row = (ReportableListObject) record.get(0);
				reqNo = row.getValue(0);
				reqDate = row.getValue(1);
				reqBy = row.getValue(2);
				reqSiteCode = row.getValue(3);				
				reqByName = StaffDB.getStaffFullName2(reqBy);			
				reqDept = row.getValue(4);
				reqBugcode = row.getValue(7);
				amtID = row.getValue(8);				
				reqDesc = row.getValue(6);
				shipTo = row.getValue(5);
				reqStatus = row.getValue(9);				
				reqRmk = row.getValue(10);
				sendAppTo = row.getValue(11); 				
				approveFlag = Integer.parseInt(row.getValue(12));
				adCouncil = row.getValue(14); 	
				boardCouncil = row.getValue(15);
				financeComm = row.getValue(16);
				aprRmk = row.getValue(18);				
			}			
			System.err.println("1[sendMessage]:"+sendMessage);
		}else{
			if(EPORequestDB.sendEmail(reqNo, reqBy, userBean.getStaffID(), sendAppTo, reqDesc, reqStatus, folderID, "1", "1")){
				sendMessage = "mail sent success";
			}else{
				sendMessage = "mail sent failed";
			}
			System.err.println("2[sendMessage]:"+sendMessage);
		}	

		if(successUptHdr&&uptDtlFail==0){
			if("R".equals(reqStatus)){
				message = "Requisition rejected and "+sendMessage;
			}else if("F".equals(reqStatus)) {
				message = "Requisition approved and "+sendMessage;			
			}else if("A".equals(reqStatus)) {
				message = "Requisition approved and "+sendMessage;
			}
			updateAction = false;			
		}else{
			errorMessage = "Requisition update fail.";
			updateAction = false;			
		}
		if(apprId.equals(secondApprover)){
			remainCredit = Integer.parseInt(EPORequestDB.finalApprover(reqNo,"1","5",amtID,apprId));			
		}else{
			remainCredit = Integer.parseInt(EPORequestDB.finalApprover(reqNo,"1","1",amtID,apprId));			
		}

		alreadyApproval = Integer.parseInt(EPORequestDB.countOfApproval(reqNo, apprId));
		System.err.println("1[alreadyApproval]:"+alreadyApproval+";[remainCredit]:"+remainCredit);
	}else if(viewAction){		
// load data from database
		if (reqNo != null && reqNo.length() > 0) {	
			ArrayList record = EPORequestDB.getRequestHdr(reqNo);

			if(record.size()>0){
				ReportableListObject row = (ReportableListObject) record.get(0);
				reqNo = row.getValue(0);
				reqDate = row.getValue(1);
				reqBy = row.getValue(2);
				reqSiteCode = row.getValue(3);				
				reqByName = StaffDB.getStaffFullName2(reqBy);			
				reqDept = row.getValue(4);
				reqBugcode = row.getValue(7);
				amtID = row.getValue(8);				
				reqDesc = row.getValue(6);
				shipTo = row.getValue(5);
				reqStatus = row.getValue(9);				
				reqRmk = row.getValue(10);
				sendAppTo = row.getValue(11); 				
				approveFlag = Integer.parseInt(row.getValue(12));
				adCouncil = row.getValue(14); 	
				boardCouncil = row.getValue(15);
				financeComm = row.getValue(16);
				aprRmk = row.getValue(18);				
			}		
		}
		if("hkah".equals(reqSiteCode) && 
				("416".equals(reqDept) || "417".equals(reqDept) || "418".equals(reqDept))){
			appGrp = "HKIOC";
		}

		System.err.println("[reqSiteCode]:"+reqSiteCode+";[reqDept]:"+reqDept+"[appGrp]:"+appGrp+";[apprId]:"+apprId+";[amtID]:"+amtID);	
		if("A".equals(reqStatus)){
			message = "Requisition Approved";		
		}else if("R".equals(reqStatus)){
			message = "Requisition Rejected";
		}else if("D".equals(reqStatus)){
			message = "Requisition in pending";				
		}else{
			message = "Requisition waiting approval";			
		}
		remainCredit = Integer.parseInt(EPORequestDB.finalApprover(reqNo,"1","1",amtID,apprId));
		alreadyApproval = Integer.parseInt(EPORequestDB.countOfApproval(reqNo, apprId));
		System.err.println("2[alreadyApproval]:"+alreadyApproval+";[remainCredit]:"+remainCredit);
		if(remainCredit<0){
			record1 = ApprovalUserDB.getEpoAppUserList("1", "5", null, null, "HKAH");
			if(record1.size()>0){
				ReportableListObject row2 = (ReportableListObject) record1.get(0);
				secondApprover = row2.getValue(0);
				if(apprId.equals(secondApprover) && ("H".equals(reqStatus))){
					reqStatus = "F";
				}				
			}			
		}
	}else if(pendAction){
		ArrayList record = EPORequestDB.getRequestHdr(reqNo);
		if(record.size()>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			reqDate = row.getValue(1);
			reqBy = row.getValue(2);
			reqByName = StaffDB.getStaffFullName2(reqBy);
			reqSiteCode = row.getValue(3);				
			reqDept = row.getValue(4);
			reqBugcode = row.getValue(7);
			amtID = row.getValue(8);			
			reqDesc = row.getValue(6);
			shipTo = row.getValue(5);				
			reqRmk = row.getValue(10); 				
			approveFlag = Integer.parseInt(row.getValue(12));
			adCouncil = row.getValue(14); 	
			boardCouncil = row.getValue(15);
			financeComm = row.getValue(16);
			aprRmk = row.getValue(18);			
		}		
		reqStatus = "D";
		if(EPORequestDB.updateHdrStatus(userBean, reqNo, reqStatus, null, null, null, sysDate, reqBugcode, adCouncil, boardCouncil, financeComm, approveCredit, amtID)){
			EPORequestDB.updateApprRmk(reqNo,aprRmk);
			if(EPORequestDB.sendEmail(reqNo, reqBy, userBean.getStaffID(), userBean.getStaffID(), reqDesc, reqStatus, folderID, "1", "1")){
				sendMessage = "success";
			}else{
				sendMessage = "failed";
			}
			message = "Requisition change pending status success and sent mail to requester "+sendMessage;
		}else{
			errorMessage = "Requisition change pending status failed, please contact IT department.";			
		}
		remainCredit = Integer.parseInt(EPORequestDB.finalApprover(reqNo,"1","1",amtID,apprId));
		alreadyApproval = Integer.parseInt(EPORequestDB.countOfApproval(reqNo, apprId));		
	}else if(emailAction){		
		if (reqNo != null && reqNo.length() > 0) {	
			ArrayList record = EPORequestDB.getRequestHdr(reqNo);
			if(record.size()>0){
				ReportableListObject row = (ReportableListObject) record.get(0);
				reqDate = row.getValue(1);
				reqBy = row.getValue(2);
				reqByName = StaffDB.getStaffFullName2(reqBy);
				reqSiteCode = row.getValue(3);				
				reqDept = row.getValue(4);
				reqBugcode = row.getValue(7);
				amtID = row.getValue(8);				
				reqDesc = row.getValue(6);
				shipTo = row.getValue(5);
				reqStatus = row.getValue(9);				
				reqRmk = row.getValue(10); 
				sendAppTo  = row.getValue(11);				
				approveFlag = Integer.parseInt(row.getValue(12));
				adCouncil = row.getValue(14); 	
				boardCouncil = row.getValue(15);
				financeComm = row.getValue(16);
				aprRmk = row.getValue(18);				
			}
			if(EPORequestDB.sendEmail(reqNo, null, userBean.getStaffID(), sendAppTo, reqDesc, reqStatus, folderID, "E", "1")){
				message = "Mail resent success";
				emailAction = false;				
			}else{
				errorMessage = "Mail resent failed";
				emailAction = false;				
			}			
		}
		remainCredit = Integer.parseInt(EPORequestDB.finalApprover(reqNo, "1", "1", amtID, apprId));
		alreadyApproval = Integer.parseInt(EPORequestDB.countOfApproval(reqNo, apprId));			
	} else {
		errorMessage = "";		
	}

	if("hkah".equals(reqSiteCode) && 
			("416".equals(reqDept) || "417".equals(reqDept) || "418".equals(reqDept))){
		appGrp = "HKIOC";
	}
	System.err.println("1[appGrp]:"+appGrp);
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<%if ("hkah".equals(serverSiteCode)) {%>
				<img src="../images/hkah_portal_logo.gif" border="0" width="302" height="81" />			
			<%}else{%>
				<img src="../images/twah_portal_logo.gif" border="0" width="302" height="81" />			
			<%} %>		
		</td>
	</tr>
</table>
<jsp:include page="../common/banner2.jsp"/>
<div id=indexWrapper>
<div id=mainFrame>
<div id=Frame>
<%
	String title = "function.epo.list"; 
	String suffix = "_2";
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="suffix" value="<%=suffix %>" />	
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.epo.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" id="form1" enctype="multipart/form-data" action="approveForm.jsp" method=post onkeypress="return event.keyCode!=13">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu1" border="0">
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqNo" /></td>
		<td class="infoData2" width="30%"><b><%=reqNo==null?"":reqNo%></b></td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqBy" /></td>
		<td class="infoData2" width="30%">
			<input type="textfield" name="reqBy" id="reqBy" value="<%=reqByName==null?"":reqByName %>" maxlength="20" size="20" disabled="disabled">			
		</td>					
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqBugCode" /></td>
		<td class="infoData2" width="30%">
		<%if("A".equals(reqStatus)||"R".equals(reqStatus)||alreadyApproval>0){ %>				
			<input type="textfield" name="reqBugcode" value="<%=reqBugcode==null?"":reqBugcode %>" maxlength="30" size="30" disabled="disabled"/>
		<%}else{ %>
			<input type="textfield" name="reqBugcode" value="<%=reqBugcode==null?"":reqBugcode %>" maxlength="30" size="30"/>		
		<%} %>							
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.adCouncil" /></td>
		<td class="infoData2" width="30%">
		<%if("A".equals(reqStatus)||"R".equals(reqStatus)||alreadyApproval>0){ %>		
			<input type="textfield" name="adCouncil" value="<%=adCouncil==null?"":adCouncil %>" maxlength="30" size="30" disabled="disabled"/>
		<%}else{ %>
			<input type="textfield" name="adCouncil" value="<%=adCouncil==null?"":adCouncil %>" maxlength="30" size="30" />		
		<%} %>						
		</td>			
	</tr>
	<tr class="smallText">			
		<td class="infoLabel" width="20%"><bean:message key="prompt.financeComm" /></td>
		<td class="infoData2" width="30%">
		<%if("A".equals(reqStatus)||"R".equals(reqStatus)||alreadyApproval>0){ %>		
			<input type="textfield" name="financeComm" value="<%=financeComm==null?"":financeComm %>" maxlength="30" size="30" disabled="disabled"/>
		<%}else{ %>
			<input type="textfield" name="financeComm" value="<%=financeComm==null?"":financeComm %>" maxlength="30" size="30" />		
		<%} %>						
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.boardCouncil" /></td>
		<td class="infoData2" width="30%">
		<%if("A".equals(reqStatus)||"R".equals(reqStatus)||alreadyApproval>0){ %>		
			<input type="textfield" name="boardCouncil" value="<%=boardCouncil==null?"":boardCouncil %>" maxlength="30" size="30" disabled="disabled"/>
		<%}else{ %>
			<input type="textfield" name="boardCouncil" value="<%=boardCouncil==null?"":boardCouncil %>" maxlength="30" size="30" />		
		<%} %>					
		</td>			
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDate" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="reqDate" id="reqDate" value="<%=reqDate==null?"":reqDate %>" maxlength="10" size="10" disabled="disabled"> (DD/MM/YYYY)				
		</td>
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDesc" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="reqDesc" value="<%=StringEscapeUtils.escapeHtml(reqDesc) ==null?"":StringEscapeUtils.escapeHtml(reqDesc) %>" maxlength="100" size="80" disabled="disabled">		
		</td>	
	</tr>					
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.siteCode" /></td>
		<td class="infoData2" width="30%">
			<input type="textfield" name="reqSiteCode" id="reqSiteCode" value="<%=reqSiteCode==null?"":reqSiteCode %>" maxlength="20" size="20" disabled="disabled">			
		</td>		
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDept" /></td>
		<td class="infoData2" width="30%">
			<select name="reqDept" disabled="disabled">
			<%reqDept = reqDept == null ? deptCode : reqDept; %>				
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">			
				<jsp:param name="deptCode" value="<%=reqDept %>" />
				<jsp:param name="allowAll" value="Y" />												
			</jsp:include>
			</select>
		</td>	
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqShipTo" /></td>
		<td class="infoData2" width="80%" colspan=3>		
			<select name="shipTo" disabled="disabled">
			<%shipTo = shipTo == null ? deptCode : shipTo; %>				
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=shipTo %>" />
				<jsp:param name="allowAll" value="Y" />									
			</jsp:include>
			</select>							
		</td>
	</tr>				
</table>
<span id="edit_indicator">
	<%reqNo = reqNo == null ? "" : reqNo; %>
	<%reqStatus = reqStatus == null ? "" : reqStatus; %>
	<%amtID = amtID == null ? "0" : amtID; %>
	<%System.err.println("[approveForm][appGrp]:"+appGrp); %>
	<jsp:include page="approveFormItem.jsp" flush="false" >
		<jsp:param name="reqNo" value="<%=reqNo %>" />
		<jsp:param name="reqStatus" value="<%=reqStatus %>" />
		<jsp:param name="alreadyApproval" value="<%=alreadyApproval %>" />
		<jsp:param name="amtID" value="<%=amtID %>" />
		<jsp:param name="appGrp" value="<%=appGrp %>" />								
	</jsp:include>
</span>
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr>															
		<td>&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.reqRmk" /></td>	
		<td class="infoData2">
		<%if(reqRmk!=null && reqRmk.length()>0){%>		
			<table cellpadding="1" cellspacing="0" border="1" bgcolor="#FFFFFF" width="515">
				<tr><td class="infoLabelNormal"><%=reqRmk==null?"":reqRmk %></td></tr>
			</table>
		<%} %>			
		</td>		
	</tr>	
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.approverRmk" /></td>	
		<td class="infoData2">
<%if("A".equals(reqStatus)||"R".equals(reqStatus)||alreadyApproval>0){ %>
	<%if(aprRmk!=null && aprRmk.length()>0){%>
			<table cellpadding="1" cellspacing="0" border="1" bgcolor="#FFFFFF" width="515">
				<tr><td class="infoLabelNormal"><%=aprRmk==null?"":aprRmk %></td></tr>
			</table>			
	<%} %>
<%}else{ %>
			<div class=box><textarea id="wysiwyg" name="aprRmk" rows="5" cols="100" align="left"><%=aprRmk==null?"":aprRmk %></textarea></div>			
<%} %>								
		</td>		
	</tr>
	<tr class="smallText">	
		<td class="infoLabel"><bean:message key="prompt.approvalAction" /></td>	
		<td class="infoData2">
<% System.err.println("[remainCredit]:"+remainCredit+";[alreadyApproval]:"+alreadyApproval+";[reqStatus]:"+reqStatus);%>				
<%if(remainCredit>=0){ %>
	<%if("A".equals(reqStatus)||"R".equals(reqStatus)||alreadyApproval>0){ %>
		<%if("H".equals(reqStatus)&&alreadyApproval>0){ %>
			<select name="reqStatus" >			
				<option value="A" <%="A".equals(reqStatus)?" selected":""%>>Final Approval</option>
				<option value="R" <%="R".equals(reqStatus)?" selected":""%>>Rejected</option>
			</select>						
		<%}else{ %>
			<select name="reqStatus" onchange="return getApproveList(this)" disabled="disabled">			
				<option value="A" <%="A".equals(reqStatus)?" selected":""%>>Final Approval</option>
				<option value="F" <%="F".equals(reqStatus)?" selected":""%>>Further Approval</option>					
				<option value="R" <%="R".equals(reqStatus)?" selected":""%>>Rejected</option>
<!-- 				
				<option value="D" <%="D".equals(reqStatus)?" selected":""%>>Pending</option>
 -->												
			</select>
		<%} %>			
	<%}else{ %>
			<select name="reqStatus" onchange="return getApproveList(this)">			
				<option value="A" <%="A".equals(reqStatus)?" selected":""%>>Final Approval</option>
				<option value="R" <%="R".equals(reqStatus)?" selected":""%>>Rejected</option>
			</select>	
	<%} %>			
<%}else{ %>
	<%if("A".equals(reqStatus)||"R".equals(reqStatus)||alreadyApproval>0){ %>
			<select name="reqStatus" onchange="return getApproveList(this)" disabled="disabled">			
				<option value="A" <%="S".equals(reqStatus)?" selected":""%>>Final Approval</option>
				<option value="F" <%="F".equals(reqStatus)?" selected":""%>>Further Approval</option>									
				<option value="R" <%="R".equals(reqStatus)?" selected":""%>>Rejected</option>
<!-- 				
				<option value="D" <%="D".equals(reqStatus)?" selected":""%>>Pending</option>
 -->								
			</select>
	<%}else if("F".equals(reqStatus)){ %>
			<select name="reqStatus" onchange="return getApproveList(this)">			
				<option value="A" <%="A".equals(reqStatus)?" selected":""%>>Final Approval</option>
				<option value="R" <%="R".equals(reqStatus)?" selected":""%>>Rejected</option>
			</select>					
	<%}else { %>
		<%if("D".equals(reqStatus) && viewAction){ %>
			<select name="reqStatus" onchange="return getApproveList(this)">			
				<option value="A" <%="S".equals(reqStatus)?" selected":""%>>Final Approval</option>
				<option value="F" <%="F".equals(reqStatus)?" selected":""%>>Further Approval</option>									
				<option value="R" <%="R".equals(reqStatus)?" selected":""%>>Rejected</option>				
			</select>		
		<%}else{ %>
			<% if(secondApprover!=null && secondApprover.length()>0){}%>
			<select name="reqStatus" onchange="return getApproveList(this)">
				<option value="F" <%="F".equals(reqStatus)?" selected":""%>>Further Approval</option>									
				<option value="R" <%="R".equals(reqStatus)?" selected":""%>>Rejected</option>
<!-- 				
				<option value="D" <%="D".equals(reqStatus)?" selected":""%>>Pending</option>
 -->								
			</select>		
		<%} %>
	<%} %>
<%} %>			
		</td>		
	</tr>
	<tr class="smallText">		
		<%if("S".equals(reqStatus) || "H".equals(reqStatus) || "C".equals(reqStatus) || "F".equals(reqStatus)){ %>
			<td class="infoLabel"><bean:message key="prompt.reqAppStaff" />	</td>
		<%}else{ %>
			<td class="infoLabel"><bean:message key="prompt.approvalBy" />	</td>
		<%} %>
		<td class="infoData2">		
<%if(remainCredit<0){ %>
	<%if("A".equals(reqStatus)){ System.err.println("0[showStaffID_indicator][sendAppTo]:"+sendAppTo);%>
		<input type="hidden" name="sendAppTo" />
	<%}else if("F".equals(reqStatus)){ System.err.println("1[showStaffID_indicator][sendAppTo]:"+sendAppTo);%>		
		<%if(alreadyApproval>0){ %>
			<span id="showStaffID_indicator">
				<select name="sendAppTo">
				<%if(sendAppTo == null||sendAppTo.length()==0){ %>
					<option value="" />
				<%sendAppTo = "";} %>							
				<jsp:include page="../ui/approvalIDCMB.jsp" flush="false">		
					<jsp:param name="reqStat" value="<%=reqStatus %>" />
					<jsp:param name="category" value="epo" />
					<jsp:param name="sendAppTo" value="<%=sendAppTo %>" />
					<jsp:param name="appGrp" value="<%=appGrp %>" />							
				</jsp:include>			
				</select>				
			</span>
		<%}else { System.err.println("2[showStaffID_indicator][sendAppTo]:"+sendAppTo);%>		
			<input type="hidden" name="sendAppTo" />
		<%} %>					
	<%}else if("R".equals(reqStatus)){ %>
		<input type="hidden" name="sendAppTo" />
	<%}else { System.err.println("3[showStaffID_indicator][sendAppTo]:"+sendAppTo+"[secondApprover]:"+secondApprover);%>
		<%if("D".equals(reqStatus)){ %>		
			<%if(viewAction){ %>
				<span id="showStaffID_indicator">
					<select name="sendAppTo" >
					<%reqStat = "S".equals(reqStatus)||"H".equals(reqStatus) ? "A" : reqStatus; %>																	
					<jsp:include page="../ui/approvalIDCMB.jsp" flush="false">		
						<jsp:param name="reqStat" value="<%=reqStat %>" />
						<jsp:param name="category" value="epo" />
						<jsp:param name="appGrp" value="<%=appGrp %>" />							
					</jsp:include>			
					</select>				
				</span>			
			<%}else{ %>						
				<input type="hidden" name="sendAppTo" />
			<%} %>			
		<%}else{ %>
			<%if(secondApprover != null||sendAppTo.length()>0){
				sendAppTo = secondApprover;	
			}%>			
			<span id="showStaffID_indicator">
				<select name="sendAppTo">
<!--				<option value="" />-->
				<%reqStat = "S".equals(reqStatus)||"H".equals(reqStatus) ? reqStatus : reqStatus; %>
				<jsp:include page="../ui/approvalIDCMB.jsp" flush="false">		
					<jsp:param name="reqStat" value="<%=reqStat %>" />
					<jsp:param name="category" value="epo" />
					<jsp:param name="sendAppTo" value="<%=sendAppTo %>" />
					<jsp:param name="appGrp" value="<%=appGrp %>" />									
				</jsp:include>			
				</select>				
			</span>		
		<%} %>
	<%} %>
<%}else{ %>
	<%if(alreadyApproval>0){ %>		
		<span id="showStaffID_indicator">
			<select name="sendAppTo">
			<%if(sendAppTo == null||sendAppTo.length()==0){ %>
				<option value="" />
			<%sendAppTo = "";} %>										
			<jsp:include page="../ui/approvalIDCMB.jsp" flush="false">		
				<jsp:param name="reqStat" value="<%=reqStatus %>" />
				<jsp:param name="category" value="epo" />
				<jsp:param name="reqNo" value="<%=reqNo %>" />				
				<jsp:param name="sendAppTo" value="<%=sendAppTo %>" />
				<jsp:param name="appGrp" value="<%=appGrp %>" />								
			</jsp:include>			
			</select>				
		</span>
	<%}else{ %>	
		<input type="hidden" name="sendAppTo" />	
	<%} %>
<%} %>			
		</td>		
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.attachment" /></td>
		<td class="infoData2" align="center">					
		<span id="showDocument_indicator">
			<%String keyId = folderID == null ? "" : folderID; %>		
			<jsp:include page="../common/document_list.jsp" flush="false">
				<jsp:param name="moduleCode" value="epo" />
				<jsp:param name="siteCode" value="<%=serverSiteCode %>" />
				<jsp:param name="keyID" value="<%=keyId %>" />
				<jsp:param name="allowRemove" value="N" />
			</jsp:include>
		</span>
		</td>
	</tr>						
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td align="center">
<%if(!"A".equals(reqStatus)&&!"R".equals(reqStatus)&&(!"F".equals(reqStatus)||alreadyApproval==0)){ %>			
			<button onclick="return submitAction('save','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.approveReject" /></button>
<%} %>
<%if("F".equals(reqStatus)&&alreadyApproval>0){ %>			
			<button onclick="return resendEmail('email','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.resendMail" /></button>
<%} %>
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>
		</td>			
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="reqNo" />
<input type="hidden" name="amtID" />
<input type="hidden" name="appGrp" value="<%=appGrp==null?"":appGrp %>"/>
<input type="hidden" name="folderID" value="<%=folderID==null?"":folderID %>"/>
</form>
<script language="javascript">
	$(document).ready(function() {	
		window.opener.refresh();
	});

	function closeAction() {
		window.close();
	}

	
	function resendEmail(cmd,reqNo) {
		var r=confirm("Resend alert email again?");
		if (r==true){
			document.form1.command.value = cmd;
			document.form1.reqNo.value = reqNo;			
			document.form1.submit();
			return false;	
		 }else{
			 return false;	
		 }				  
	}
	
	function getBudgetDesc(){
		var reqDesc = document.form1.reqDesc.value;
		var reqBugcode = document.form1.reqBugcode.value;		
		var adCouncil = document.form1.adCouncil.value;
		var reqNo = document.form1.reqNo.value;
		var reqDept = document.form1.reqDept.value;			
		var code = null;
		var type = null;
		var rtnmsg = null;
		
		if((reqBugcode!='' || adCouncil!='')){
			if(reqBugcode!=''){
				type = 'BC';
				code = reqBugcode;
			}else if(adCouncil!=''){
				type = 'AC';
				code = adCouncil;				
			}else{
				code = 'no value';
			}			
		
			$.ajax({
				type: "POST",
				url: "epo_hidden.jsp",
				data: 'p1=11&p2=' + type+'&p3='+code+'&p4='+reqDept,
				async: false,
				success: function(values){				
				if(values != '') {
					if(values.substring(0, 2) == '-1')  {
						if(type == 'BC'){
							document.form1.reqBugcode.focus();
							alert('No such Budget Code or is expired');							
							return false;							
						}else{
							document.form1.adCouncil.focus();
							alert('No such Ad Council NO. or is expired');	
							return false;							
						}						
					}else{
						if(reqDesc==''){
							document.form1.reqDesc.value = values;												
						} 
						return false;
					}
				}else{
					alert('null value');
					return false;					
					}//if
				}//success
			});//$.ajax	
		}
		return rtnmsg;
	}	
	
	function checkBudgetRemain(){
		var list = document.getElementById('resList');
		var rowCount=list.rows.length;
		var lastRowIndex = rowCount - 2;			
		var totalAmount = document.getElementsByName("itemTotalAmount["+ lastRowIndex +"].fields5")[0].value;
		var reqBugcode = document.form1.reqBugcode.value;
		var adCouncil = document.form1.adCouncil.value;
		var reqNo = document.form1.reqNo.value;		
		var code = null;
		var type = null;
		var rtnmsg = null;
		
		if(reqBugcode!='' || adCouncil!=''){
			if(reqBugcode!=''){
				type = 'BC';
				code = reqBugcode;
			}else if(adCouncil!=''){
				type = 'AC';
				code = adCouncil;				
			}else{
				code = 'no value';
			}
		
			$.ajax({
				type: "POST",
				url: "epo_hidden.jsp",
				data: 'p1=10&p2=' + type+'&p3='+code+'&p4='+reqNo+'&p5='+reqDept,
				async: false,
				success: function(values){				
				if(values != '') {
					if(values.substring(0, 1) == 'F')  {
						if(type == 'BC'){
							document.form1.reqBugcode.focus();							
							rtnmsg ='No such Budget Code or is expired';								
						}else{
							document.form1.adCouncil.focus();							
							rtnmsg = 'No such Ad Council NO. or is expired';							
						}						
					}else{
						if(parseFloat(values)-parseFloat(totalAmount)<0){
							if(reqBugcode!=null){
								rtnmsg = 'Not enought budget to order, Budget Code '+reqBugcode+' is $'+totalAmount+' over.';
							}else if(adCouncil!=null){
								rtnmsg = 'Not enought budget to order, Ad Council NO. '+adCouncil+' is $'+totalAmount+' over.';				
							}							
						}else{							
							rtnmsg = 'true';							
						}
					}
				}else{
					rtnmsg = 'null value';
					}//if
				}//success
			});//$.ajax			
		}else{
			rtnmsg = 'Please enter Budget Code or Ad Council NO.';
		}
		return rtnmsg;
	}
	
	function submitAction(cmd,reqNo) {
		var approveFlag = document.form1.reqStatus.value;		
		var amountID = document.getElementById("amountID").value;
		
		if(approveFlag=='D'){
			var r=confirm("Confirm to submit?");
			if (r==true){
				document.form1.amtID.value = amountID;								
				document.form1.command.value = 'pend';
				document.form1.reqNo.value = reqNo;					
				document.form1.submit();
				return false;	
			 }else{
				 return false;	
			 }			
		}else{
			if(cmd=='save'){			
				if(checkRowValue()==false){return false;}			
				if(checkRowApproval(approveFlag)==false){return false;}				
				if(chkAmountId(amountID)==false){return false;}
				var remainCredit = '<%=remainCredit %>';
				if(chkReqApprCode(amountID)==false){
						return false;
				}		
			}

			if(approveFlag=='F'){
				if (document.form1.sendAppTo.value == '') {
					alert('Please select approver');
					document.form1.sendAppTo.focus();
					return false;
				}
			}			

			var r=confirm("Confirm to submit?");
			if (r==true){
				document.form1.amtID.value = amountID;				
				document.form1.command.value = cmd;
				document.form1.reqNo.value = reqNo;			
				var abc = checkRowCnt();		
				document.form1.lstRowIdx.value = abc;	
				document.form1.submit();
//				opener.document.location.reload();				
				return false;	
			 }else{
				 return false;	
			 }			
		}				  
	}

	function removeDocument(mid,did) {		
		$.ajax({
			type: "POST",
			url: "../common/document_list.jsp",
			data: "command=delete&moduleCode="+ mid +"&keyID=<%=folderID %>&documentID=" + did + "&allowRemove=Y",
			success: function(values){
				if(values != '') {
					$("#showDocument_indicator").html(values);
				}//if
			}//success
		});//$.ajax
	}

	function getApproveList(inputObj) {
		var did = inputObj.value;
		$.ajax({
			type: "POST",
			url: "../ui/approvalIDCMB.jsp",
			data: "reqStat=" + did + "&category=epo",
			success: function(values){
				if(values != '') {
					$("#showStaffID_indicator").html("<select name='sendAppTo'>" + values + "</select>");
				}//if
			}//success
		});//$.ajax			
	}


	function trim(stringToTrim) {
		return stringToTrim.replace(/^\s+|\s+$/g,"");
	}
	
	function chkReqApprCode(amtID){
		var rtnVal = false;
		var adCouncil = document.form1.adCouncil.value; 
		var boardCouncil = document.form1.boardCouncil.value; 
		var financeComm = document.form1.financeComm.value;
		var reqBugcode = document.form1.reqBugcode.value;	 		
		
		$.ajax({
			type: "POST",
			url: "epo_hidden.jsp",
			data: 'p1=5&p2=' + amtID,
			async: false,
			success: function(values){
			if(values != '') {
				var rtnValue = trim(values);
				switch(rtnValue)
				{						
				case '0':
					rtnVal = true;
				  	break;						
				case '1':	
					if(reqBugcode==null || reqBugcode=='' ){
						if(adCouncil==null || adCouncil==''){
							alert('Please enter administrative council NO. or budget Code');
							document.form1.adCouncil.focus();
							rtnVal = false;															  						  
						}else{
							rtnVal = true;						
						}
					}else{
						rtnVal = true;
					}
				  	break;
				case '2':
					if(reqBugcode==null || reqBugcode=='' ){					
						if(financeComm==null || financeComm==''){
							alert('Please enter finance committee NO. or budget Code');
							document.form1.financeComm.focus();						
							rtnVal = false;
						}else{
							rtnVal = true;						
						}
					}else{
						rtnVal = true;
					}
				  break;
				case '3':
					if(reqBugcode==null || reqBugcode=='' ){					
						if(boardCouncil==null || boardCouncil==''){
							alert('Please enter board meeting NO. or budget Code');
							document.form1.boardCouncil.focus();						
							rtnVal = false;																	  
						}else{
							rtnVal = true;						
						}
					}else{
						rtnVal = true;
					}
				  break;
				}													
			}else{
				rtnVal = false;				
			}//if					
			}//success
		});//$.ajax		
		return rtnVal;	
	}			
</script>
</div>
</div></div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>