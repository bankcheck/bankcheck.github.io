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
String staffID = userBean.getStaffID();
String command = ParserUtil.getParameter(request, "command");
String folderID = ParserUtil.getParameter(request, "folderID");
String reqNo = ParserUtil.getParameter(request, "reqNo");
String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

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
String reqBy = null;
String reqByName = StaffDB.getStaffFullName2(staffID);
String reqDate = ParserUtil.getParameter(request, "reqDate");
//String reqSiteCode = StaffDB.getStaffSiteCode(userBean.getStaffID());
String reqSiteCode = ConstantsServerSide.SITE_CODE;
String reqDept = ParserUtil.getParameter(request, "reqDept");
String reqBugcode = ParserUtil.getParameter(request, "reqBugcode");
String reqDesc = TextUtil.parseStrUTF8((String) request.getAttribute("reqDesc"));
String shipTo = ParserUtil.getParameter(request, "shipTo");
String reqRmk = TextUtil.parseStrUTF8((String) request.getAttribute("reqRmk"));
String sendAppTo = ParserUtil.getParameter(request, "sendAppTo");
String amtID = ParserUtil.getParameter(request, "amtID");
String adCouncil = ParserUtil.getParameter(request, "adCouncil");
String boardCouncil = ParserUtil.getParameter(request, "boardCouncil");
String financeComm = ParserUtil.getParameter(request, "financeComm");
String approveCredit = null;
String itemAppFlag = "0";
String reqStatus = "H";
String prevReqStatus = null;
String purRmk = null;
String aprRmk = null;
int approveFlag = 0;
String lstRowIdx = null;
int appRight = 1;
int noOfReq = 0;

Calendar cal = Calendar.getInstance();
SimpleDateFormat dateFmt = new SimpleDateFormat("ddMMyyyyHHmmss");
String sysDate = dateFmt.format(cal.getTime());

boolean createAction = false;
boolean updateAction = false;
boolean viewAction = false;
boolean emailAction = false;
boolean cancelAction = false;
boolean closeAction = false;

if("view".equals(command)){
	viewAction = true;
}else if ("save".equals(command)) {
	if(reqNo != null && reqNo.length() > 0){
		updateAction = true;			
	}else{
		createAction = true;
	}
}else if ("cancel".equals(command)) {
	cancelAction = true;
}else if ("email".equals(command)) {
	emailAction = true;	
}

String supplier = null;
String itemDesc = null;
String uom = null;
String qty = null;
String price = null;
String amount = null;
String itemRmk = null;
String currCred = null;
String deptHead = null;
if("H".equals(reqStatus)){
	deptHead = reqBy;
}
String isExistApprovlGroup = null;
String appGrp = "HKAH";
boolean successAddDtl = false;
boolean successUptHdr = false;
boolean successDelDtl = false;

try {
	lstRowIdx = ParserUtil.getParameter(request, "lstRowIdx");
	
	if(createAction){
		System.err.println("[requestFormDeptH][createAction][sendAppTo]:"+sendAppTo+";[reqStatus]:"+reqStatus);
		isExistApprovlGroup = EPORequestDB.isExistApprovlGroup(amtID,sendAppTo,"HKIOC");
		if("1".equals(isExistApprovlGroup) && 
				"hkah".equals(reqSiteCode) && 
						("416".equals(reqDept) || "417".equals(reqDept) || "417".equals(reqDept))){
			reqStatus = "A";
			appGrp = "HKIOC";
		}
		
		if("HKAH".equals(appGrp) && "1".equals(amtID)){ //allow department head approve order less than $10000
			approveCredit = "1";		
		}
		
		reqNo = EPORequestDB.addReqHdr(staffID, reqDate, reqSiteCode, reqDept, shipTo, reqDesc, reqBugcode, amtID, reqRmk, sendAppTo, folderID, sysDate, adCouncil, boardCouncil, financeComm, purRmk, reqStatus, appGrp);

		if(reqNo!=null && "HKAH".equals(appGrp) && "1".equals(amtID)){ //allow department head approve order less than $10000
			reqStatus = "A";
			successUptHdr = EPORequestDB.updateHdrStatus(userBean, reqNo, reqStatus, reqRmk, sendAppTo, sendAppTo, sysDate, reqBugcode, adCouncil, boardCouncil, financeComm, approveCredit, amtID);
			itemAppFlag = "1";			
		}		

		System.err.println("[requestFormDeptH][createAction][sendAppTo]:"+sendAppTo+";[reqStatus]:"+reqStatus+";[reqNo]:"+reqNo);
		for( int i=0;i<=Integer.parseInt(lstRowIdx);i++) {
			
			supplier = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "itemSupp[" +i+ "].fields2"));
			itemDesc = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "itemDesc[" +i+ "].fields3"));
			uom = ParserUtil.getParameter(request, "itemUnit[" +i+ "].fields7");
			qty = ParserUtil.getParameter(request, "itemQty[" +i+ "].fields4");
			price = ParserUtil.getParameter(request, "itemPrice[" +i+ "].fields6");
			amount = ParserUtil.getParameter(request, "itemAmountHid["+i+"]");
		
			successAddDtl = EPORequestDB.addReqDtl(staffID, reqNo, Integer.toString(i+1), supplier, itemDesc, qty, amount, price, uom, itemRmk, sysDate, itemAppFlag, itemAppFlag=="1"?sendAppTo:null);             			
			EPORequestDB.addReqDtlLog(userBean, reqNo, Integer.toString(i+1), supplier, itemDesc, qty, amount, price, uom, itemRmk, sysDate, itemAppFlag, itemAppFlag=="1"?sendAppTo:null); 
		}

		if ((reqNo!=null||reqNo.length()> 0)&&successAddDtl){
			if("HKAH".equals(appGrp) && "1".equals(amtID) && "A".equals(reqStatus)){
				message = "Requisition approved."; //no email send if department head submit order 	
			}else{
				if(EPORequestDB.sendEmail(reqNo, null, userBean.getStaffID(), sendAppTo, reqDesc, reqStatus, folderID, "1", "1")){
					message = "New Requisition added and email sent to approval staff.";
					createAction = false;				
				}else{
					message = "New Requisition added but email sent failed";
					createAction = false;				
				}				
			}
		} else {
			errorMessage = "Requisition create fail.";
			createAction = false;			
		}
	}else if(updateAction){
		System.err.println("[createAction][sendAppTo]:"+sendAppTo);		
		ArrayList record = EPORequestDB.getRequestHdr(reqNo);
		noOfReq = record.size();
		if(noOfReq>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			reqBy = row.getValue(2);
			prevReqStatus = row.getValue(9);
		}
			
		successUptHdr = EPORequestDB.updateRequestHdr(userBean, reqNo, reqDate, reqSiteCode, reqDept, shipTo, reqDesc, reqBugcode, amtID, reqRmk, sendAppTo, sysDate, adCouncil, boardCouncil, financeComm, reqStatus);
		if(successUptHdr && "HKAH".equals(appGrp) && "1".equals(amtID)){ //allow department head approve order less than $10000
			approveCredit = "1";
			reqStatus = "A";		
			successUptHdr = EPORequestDB.updateHdrStatus(userBean, reqNo, reqStatus, reqRmk, sendAppTo, sendAppTo, sysDate, reqBugcode, adCouncil, boardCouncil, financeComm, approveCredit, amtID);
			itemAppFlag = "1";			
		}		
		
		successDelDtl = EPORequestDB.delReqDtl(reqNo);
		
		for( int i=0;i<=Integer.parseInt(lstRowIdx);i++) {
			supplier = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "itemSupp[" +i+ "].fields2"));
			itemDesc = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "itemDesc[" +i+ "].fields3"));
			uom = ParserUtil.getParameter(request, "itemUnit[" +i+ "].fields7");
			qty = ParserUtil.getParameter(request, "itemQty[" +i+ "].fields4");
			price = ParserUtil.getParameter(request, "itemPrice[" +i+ "].fields6");
			amount = ParserUtil.getParameter(request, "itemAmountHid["+i+"]");
			if(itemDesc!=null && itemDesc.length()>0){			
				successAddDtl = EPORequestDB.addReqDtl(staffID, reqNo, Integer.toString(i+1), supplier, itemDesc, qty, amount, price, uom, itemRmk, sysDate, itemAppFlag, itemAppFlag=="1"?sendAppTo:null);
				EPORequestDB.addReqDtlLog(userBean, reqNo, Integer.toString(i+1), supplier, itemDesc, qty, amount, price, uom, itemRmk, sysDate, itemAppFlag, itemAppFlag=="1"?sendAppTo:null);
			}
		}
			
		if("S".equals(prevReqStatus)){
			if (successUptHdr && successDelDtl && successAddDtl){
				if("HKAH".equals(appGrp) && "1".equals(amtID) && "A".equals(reqStatus)){
					if(EPORequestDB.sendEmail(reqNo, reqBy, userBean.getStaffID(), sendAppTo, reqDesc, reqStatus, folderID, "1", "1")){
						message = "Requisition approved."; //no email send if department head submit order						
					}
				}else{
					if(EPORequestDB.sendEmail(reqNo, null, userBean.getStaffID(), sendAppTo, reqDesc, reqStatus, folderID, "1", "1")){
						message = "Requisition updated and email sent to approval staff.";
						updateAction = false;			
					}else{
						message = "Requisition update but email send failed";
						updateAction = false;				
					}							
				}
			}else{
				errorMessage = "Requisition update fail.";
				updateAction = false;				
			}
		}else{
			if (successUptHdr && successDelDtl && successAddDtl){
				message = "Requisition update success";
				updateAction = false;			
			} else {
				errorMessage = "Requisition update fail.";
				updateAction = false;			
			}			
		}
	}else if(cancelAction){
		reqStatus = "C";
		successUptHdr = EPORequestDB.updateHdrStatus(userBean, reqNo, reqStatus, null, null, null, sysDate, reqBugcode, adCouncil, boardCouncil, financeComm, null, amtID);
		EPORequestDB.updateDtlModDt(userBean, reqNo);
		
		if (successUptHdr){
			message = "Requisition has been cancelled";
		} else {
			errorMessage = "Requisition cancel fail.";			
		}
		
		successUptHdr = false;
		updateAction = false;		
	}else if(viewAction){
// load data from database
		if (reqNo != null && reqNo.length() > 0) {	
			ArrayList record = EPORequestDB.getRequestHdr(reqNo);
			noOfReq = record.size();
			if(noOfReq>0){
				ReportableListObject row = (ReportableListObject) record.get(0);
				reqNo = row.getValue(0);
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
				purRmk = row.getValue(17);
				aprRmk = row.getValue(18);				
			}
			if("S".equals(reqStatus) && sendAppTo!=null && deptHead==null){
				deptHead = sendAppTo;
			}
		}
		if("A".equals(reqStatus)){
			message = "Requisition approved";
			viewAction = false;			
		}else if("R".equals(reqStatus)){
			message = "Requisition rejected";
			viewAction = false;
		}else if("Z".equals(reqStatus)){
			message = "PO Processing";
			viewAction = false;			
		}else if("O".equals(reqStatus)){
			message = "Requisition approved and item ordered";
			viewAction = false;
		}else if("C".equals(reqStatus)){
			message = "Requisition cancelled";
			viewAction = false;						
		}else{
			message = "Requisition waiting approval";
			viewAction = false;			
		}
	}else if(emailAction){		
		if (reqNo != null && reqNo.length() > 0) {	
			ArrayList record = EPORequestDB.getRequestHdr(reqNo);
			if(record.size()>0){
				ReportableListObject row = (ReportableListObject) record.get(0);
				reqNo = row.getValue(0);
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
			System.err.println("[emailAction][reqNo]:"+reqNo);
		}
	} else {
		errorMessage = "";
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		reqDate = dateFormat.format(calendar.getTime());
	}
	
	if("hkah".equals(reqSiteCode) && 
			("416".equals(reqDept) || "417".equals(reqDept) || "417".equals(reqDept))){
		appGrp = "HKIOC";
	}
	System.err.println("start[appGrp]"+appGrp+";[amtID]:"+amtID);
} catch (Exception e) {
	e.printStackTrace();
}

System.out.println("[epo requestFormDeptH] reqNo=" + reqNo+ ", reqStatus="+reqStatus + ", login staff ID="+userBean.getStaffID()+", reqDate=" + reqDate);
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
<!-- 
<script type="text/javascript" src="<html:rewrite page="/js/jquery-1.2.6.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.meio.mask.js"/>" charset="utf-8" ></script>
 -->
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
<form name="form1" id="form1" enctype="multipart/form-data" action="requestFormDeptH.jsp" method=post onkeypress="return event.keyCode!=13">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu1" border="0">
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqNo" /></td>
		<td class="infoData2" width="30%" >
			<b><%=reqNo==null?"":reqNo%></b>			
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqBy" /></td>
		<td class="infoData2" width="30%" >
			<input type="textfield" name="reqBy" id="reqBy" value="<%=reqByName==null?"":reqByName %>" maxlength="20" size="20" disabled="disabled">			
		</td>						
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqBugCode" /></td>
		<td class="infoData2" width="30%">
		<%if("S".equals(reqStatus) || "H".equals(reqStatus)){ %>
			<input type="textfield" name="reqBugcode" value="<%=reqBugcode==null?"":reqBugcode %>" maxlength="30" size="30" onblur="getBudgetDesc()"/>				
		<%}else{ %>		
			<input type="textfield" name="reqBugcode" value="<%=reqBugcode==null?"":reqBugcode %>" maxlength="30" size="30" disabled="disabled"/>
		<%} %>		
		</td>		
		<td class="infoLabel" width="20%"><bean:message key="prompt.adCouncil" /></td>
		<td class="infoData2" width="30%">
		<%if("S".equals(reqStatus) || "H".equals(reqStatus)){ %>		
			<input type="textfield" name="adCouncil" value="<%=adCouncil==null?"":adCouncil %>" maxlength="30" size="30" onblur="getBudgetDesc()"/>
		<%}else{ %>
			<input type="textfield" name="adCouncil" value="<%=adCouncil==null?"":adCouncil %>" maxlength="30" size="30" disabled="disabled"/>		
		<%} %>									
		</td>	
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.financeComm" /></td>
		<td class="infoData2" width="30%">
		<%if("S".equals(reqStatus) || "H".equals(reqStatus)){ %>		
			<input type="textfield" name="financeComm" value="<%=financeComm==null?"":financeComm %>" maxlength="30" size="30"/>
		<%}else{ %>
			<input type="textfield" name="financeComm" value="<%=financeComm==null?"":financeComm %>" maxlength="30" size="30" disabled="disabled"/>		
		<%} %>							
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.boardCouncil" /></td>
		<td class="infoData2" width="30%">
		<%if("S".equals(reqStatus) || "H".equals(reqStatus)){ %>		
			<input type="textfield" name="boardCouncil" value="<%=boardCouncil==null?"":boardCouncil %>" maxlength="30" size="30"/>
		<%}else{ %>
			<input type="textfield" name="boardCouncil" value="<%=boardCouncil==null?"":boardCouncil %>" maxlength="30" size="30" disabled="disabled"/>
		<%} %>								
		</td>			
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDesc" /></td>
		<td class="infoData2" width="80%" colspan=3>
		<%if("S".equals(reqStatus) || "H".equals(reqStatus)){ %>
			<input type="textfield" name="reqDesc" value="<%=StringEscapeUtils.escapeHtml(reqDesc) ==null?"":StringEscapeUtils.escapeHtml(reqDesc) %>" maxlength="100" size="80" >
		<%}else{ %>
			<input type="textfield" name="reqDesc" value="<%=StringEscapeUtils.escapeHtml(reqDesc) ==null?"":StringEscapeUtils.escapeHtml(reqDesc) %>" maxlength="100" size="80" disabled="disabled">			
		<%} %>		
		</td>	
	</tr>		
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDate" /></td>
		<td class="infoData2" width="80%" colspan=3>
		<%if("S".equals(reqStatus) || "H".equals(reqStatus)){ %>
			<input type="textfield" name="reqDate" id="reqDate" class="datepickerfield" value="<%=reqDate==null?"":reqDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)		
		<%}else{ %>
			<input type="textfield" name="reqDate" id="reqDate" value="<%=reqDate==null?"":reqDate %>" maxlength="20" size="20" disabled="disabled"/> (DD/MM/YYYY)					
		<%} %>				
		</td>
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.siteCode" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="reqSiteCode" id="reqSiteCode" value="<%=reqSiteCode==null?"":reqSiteCode %>" maxlength="20" size="20" disabled="disabled">			
		</td>
	</tr>		
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDept" /></td>
		<td class="infoData2" width="80%" colspan=3>
		<%if("S".equals(reqStatus) || "H".equals(reqStatus)){ System.err.println("123[reqStatus]"+reqStatus);%>
			<select name="reqDept" onchange="return getDeptHead(this)">
			<%reqDept = reqDept == null ? deptCode : reqDept; %>
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=reqDept %>" />
				<jsp:param name="allowAll" value="Y" />					
			</jsp:include>
			</select>
		<%}else{ %>	
			<select name="reqDept" disabled>
			<%reqDept = reqDept == null ? deptCode : reqDept; %>			
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=reqDept %>" />
				<jsp:param name="allowAll" value="Y" />								
			</jsp:include>
			</select>
		<%} %>							
		</td>
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqShipTo" /></td>
		<td class="infoData2" width="80%" colspan=3>
		<%if("S".equals(reqStatus) || "H".equals(reqStatus)){ %>
			<select name="shipTo">
			<%shipTo = shipTo == null ? deptCode : shipTo; %>			
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=shipTo %>" />
				<jsp:param name="allowAll" value="Y" />									
			</jsp:include>
			</select>
		<%}else{ %>	
			<select name="shipTo" disabled="disabled">
			<%shipTo = shipTo == null ? deptCode : shipTo; %>					
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=shipTo %>" />
				<jsp:param name="allowAll" value="Y" />													
			</jsp:include>
			</select>
		<%} %>							
		</td>
	</tr>		
</table> 
<%if("F".equals(reqStatus) || "A".equals(reqStatus)){ %>	
	<span id="edit_indicator"> 
		<%reqNo = reqNo == null ? "" : reqNo; %>
		<%reqStatus = reqStatus == null ? "" : reqStatus; %>		
		<jsp:include page="approvedFormItem.jsp" flush="false" >
			<jsp:param name="reqNo" value="<%=reqNo %>" />
			<jsp:param name="reqStatus" value="<%=reqStatus %>" />
			<jsp:param name="alreadyApproval" value="<%=0 %>" />
			<jsp:param name="appGrp" value="<%=appGrp %>" />			
		</jsp:include>
	</span>
<%} else if("O".equals(reqStatus)){ %>
	<span id="edit_indicator">
		<%reqNo = reqNo == null ? "" : reqNo; %>
		<%reqStatus = reqStatus == null ? "" : reqStatus; %>		 
			<jsp:include page="compOrderItem.jsp" flush="false" >
				<jsp:param name="reqNo" value="<%=reqNo %>" />
				<jsp:param name="reqStatus" value="<%=reqStatus %>" />
			</jsp:include>
	</span>		
<%} else if("C".equals(reqStatus)){ %>
	<span id="edit_indicator"> 
		<%reqNo = reqNo == null ? "" : reqNo; %>
		<%reqStatus = reqStatus == null ? "" : reqStatus; %>		
			<jsp:include page="approvedFormItem.jsp" flush="false" >
				<jsp:param name="reqNo" value="<%=reqNo %>" />
				<jsp:param name="reqStatus" value="<%=reqStatus %>" />
				<jsp:param name="appGrp" value="<%=appGrp %>" />				
			</jsp:include>
		</span>	
	</span>		
<%}else{ %>
	<span id="edit_indicator">
		<%reqNo = reqNo == null ? "" : reqNo; %>
		<%reqStatus = reqStatus == null ? "" : reqStatus; %>
		<%amtID = amtID == null ? "0" : amtID; %>			 
		<jsp:include page="requestFormItem.jsp" flush="false" >
			<jsp:param name="reqNo" value="<%=reqNo %>" />
			<jsp:param name="reqStatus" value="<%=reqStatus %>" />
			<jsp:param name="amtID" value="<%=amtID %>" />
			<jsp:param name="appGrp" value="<%=appGrp %>" />				
		</jsp:include>
	</span>
<%} %>
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr>															
		<td>&nbsp;</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.reqRmk" /></td>	
		<td class="infoData2">		
<%if(!"S".equals(reqStatus) && !"H".equals(reqStatus)){ %>
		<%if(reqRmk!=null && reqRmk.length()>0){%>
			<table cellpadding="1" cellspacing="0" border="1" bgcolor="#FFFFFF" width="515">
				<tr><td class="infoLabelNormal"><%=reqRmk==null?"":reqRmk %></td></tr>
			</table>
		<%} %>					
<%}else{ %>
			<div class=box><textarea id="wysiwyg" name="reqRmk" rows="5" cols="100" align="left"><%=reqRmk==null?"":reqRmk %></textarea></div>
<%} %>				
		</td>		
	</tr>
<%if("A".equals(reqStatus) || "P".equals(reqStatus) || "D".equals(reqStatus) || "C".equals(reqStatus) || "O".equals(reqStatus) || "F".equals(reqStatus) || "Z".equals(reqStatus) || "R".equals(reqStatus)){ %>	
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.approverRmk" /></td>	
		<td class="infoData2">
		<%if(aprRmk!=null && aprRmk.length()>0){%>
			<table cellpadding="1" cellspacing="0" border="1" bgcolor="#FFFFFF" width="515">
				<tr><td class="infoLabelNormal"><%=aprRmk==null?"":aprRmk %></td></tr>
			</table>
		<%} %>									
		</td>		
	</tr>
<%} %>	
<%if("P".equals(reqStatus) || "O".equals(reqStatus)){ %>	
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.purRmk" /></td>	
		<td class="infoData2">
		<%if(purRmk!=null && purRmk.length()>0){%>	
			<table cellpadding="1" cellspacing="0" border="1" bgcolor="#FFFFFF" width="515">
				<tr><td class="infoLabelNormal"><%=purRmk==null?"":purRmk %></td></tr>
			</table>
		<%} %>									
		</td>		
	</tr>
<%} %>	
	<tr class="smallText">	
		<%if("S".equals(reqStatus) || "H".equals(reqStatus) || "C".equals(reqStatus) || "F".equals(reqStatus)){ %>
			<td class="infoLabel" width="20%"><bean:message key="prompt.reqAppStaff" />	</td>
		<%}else{ %>
			<td class="infoLabel" width="20%"><bean:message key="prompt.approvalBy" />	</td>
		<%} %>	
		<td class="infoData2" width="80%">
		<div id="showStaffID_indicator">
		<select name="sendAppTo" >
		<%if(sendAppTo == null||sendAppTo.length()==0){ %>
			<option value="" />
		<%sendAppTo = "";} %>
		<%System.err.println("[reqStatus];"+reqStatus+";[sendAppTo]:"+sendAppTo+";[deptHead]:"+deptHead+";[appGrp]:"+appGrp+";[reqDept]:"+reqDept); %>						
		<jsp:include page="../ui/approvalIDCMB.jsp" flush="false">		
			<jsp:param name="reqStat" value="<%=reqStatus %>" />
			<jsp:param name="sendAppTo" value="<%=sendAppTo %>" />
			<jsp:param name="deptHead" value="<%=deptHead %>" />
			<jsp:param name="appGrp" value="<%=appGrp %>" />
			<jsp:param name="amtID" value="<%=amtID %>" />		
			<jsp:param name="category" value="epo" />								
			<jsp:param name="reqDept" value="<%=reqDept %>" />
			<jsp:param name="reqNo" value="<%=reqNo %>" />						
		</jsp:include>			
		</select>
		</div>													
		</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.attachment" /></td>
		<td class="infoData2" align="center">		
		<%if(!"S".equals(reqStatus) && !"H".equals(reqStatus)){ %>		
			<span id="showDocument_indicator">
				<%String keyId = folderID == null ? "" : folderID; %>		
				<jsp:include page="../common/document_list.jsp" flush="false">
					<jsp:param name="moduleCode" value="epo" />
					<jsp:param name="siteCode" value="<%=serverSiteCode %>" />					
					<jsp:param name="keyID" value="<%=keyId %>" />
					<jsp:param name="allowRemove" value="N" />
				</jsp:include>
			</span>
		<%}else{ %>
			<span id="showDocument_indicator">
				<%String keyId = folderID == null ? "" : folderID; %>		
				<jsp:include page="../common/document_list.jsp" flush="false">
					<jsp:param name="moduleCode" value="epo" />
					<jsp:param name="siteCode" value="<%=serverSiteCode %>" />					
					<jsp:param name="keyID" value="<%=keyId %>" />
					<jsp:param name="allowRemove" value="Y" />
				</jsp:include>
			</span>
			<input type="file" name="file1" size="50" class="multi" maxlength="10"/>			
		<%} %>
		</td>
	</tr>					
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td align="center">
		<%System.err.println("[reqDept]:"+reqDept+";[userdept]:"+userBean.getDeptCode()+";[!EPORequestDB.isPurchaser(userBean,appGrp)]:"+!EPORequestDB.isPurchaser(userBean,appGrp)+";[!EPORequestDB.isVPF(userBean,appGrp)]:"+!EPORequestDB.isVPF(userBean,appGrp)+";[deptHead]:"+deptHead+";[staffID]:"+staffID); %>
 		<%if(("S".equals(reqStatus) || "H".equals(reqStatus))&&(!EPORequestDB.isPurchaser(userBean,appGrp)&&!EPORequestDB.isVPF(userBean,appGrp))){ %>				
			<button onclick="return submitAction('save','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.saveSubmit" /></button>
		<%}else{ 			
			if(deptHead!=null&&deptHead.length()>0&&("S".equals(reqStatus)||"H".equals(reqStatus))
					&&(reqDept.equals(userBean.getDeptCode())
							||(EPORequestDB.isVPF(userBean,appGrp)&&staffID.equals(deptHead)))){
		%>
			<button onclick="return submitAction('save','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.saveSubmit" /></button>						
		<%}} %>
		<%if(sendAppTo!=null&&sendAppTo.length()>0&&("S".equals(reqStatus)||"H".equals(reqStatus)||"F".equals(reqStatus))&&(!EPORequestDB.isPurchaser(userBean,appGrp)&&!EPORequestDB.isVPF(userBean,appGrp))){
			if(!("HKAH".equals(appGrp) && "1".equals(amtID) && "S".equals(reqStatus))){ //allow department head approve order less than $10000			
		%>			
			<button onclick="return resendEmail('email','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.resendMail" /></button>
		<%}}else if(sendAppTo!=null&&sendAppTo.length()>0&&("S".equals(reqStatus)||"H".equals(reqStatus)||"F".equals(reqStatus))&&(staffID.equals(deptHead)&&EPORequestDB.isVPF(userBean,appGrp))){	
			if(!("HKAH".equals(appGrp) && "1".equals(amtID))){ //allow department head approve order less than $10000				
		%>
			<button onclick="return resendEmail('email','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.resendMail" /></button>
		<%}} %>				
 		<%if(("S".equals(reqStatus) || "H".equals(reqStatus))&&(!EPORequestDB.isPurchaser(userBean,appGrp)&&!EPORequestDB.isVPF(userBean,appGrp))){ %>				
			<button onclick="return cancelAction('<%=reqNo==null?"":reqNo %>');"><bean:message key="button.cancel" /></button>
		<%}else if(("S".equals(reqStatus) || "H".equals(reqStatus))&&(staffID.equals(deptHead)&&EPORequestDB.isVPF(userBean,appGrp))){	
		%>			
			<button onclick="return cancelAction('<%=reqNo==null?"":reqNo %>');"><bean:message key="button.cancel" /></button>		
		<%} %>
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>						
		</td>			
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="reqNo" value="<%=reqNo==null?"":reqNo %>"/>
<input type="hidden" name="amtID" />
<input type="hidden" name="appGrp" value="<%=appGrp==null?"":appGrp %>"/>
<input type="hidden" name="reqStatus" value="<%=reqStatus==null?"":reqStatus %>"/>
<input type="hidden" name="folderID" value="<%=folderID==null?"":folderID %>"/>
</form>
<script language="javascript">
	$(document).ready(function() {
		window.opener.refresh();
	});

	function closeAction() {
		window.close();
	}

	function cancelAction(reqNo) {
		var r=confirm("Confirm to cancel?");
		if (r==true){
			document.form1.command.value = 'cancel';
			document.form1.reqNo.value = reqNo;	
			document.form1.submit();
			return false;	
		 }else{
			 return false;	
		 }		  
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
		var reqDate = document.form1.reqDate.value;
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
				data: 'p1=11&p2=' + type+'&p3='+code+'&p4='+reqDept+'&p6='+reqDate,
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
		var reqDept = document.form1.reqDept.value;
		var reqDate = document.form1.reqDate.value;
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
				data: 'p1=10&p2=' + type+'&p3='+code+'&p4='+reqNo+'&p5='+reqDept+'&p6='+reqDate,
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
		var amountID = document.getElementById("amountID").value;		
		var reqBugcode = document.form1.reqBugcode.value;			
		var adCouncil = document.form1.adCouncil.value;
		var reqDept = document.form1.reqDept.value;
		var siteCode = '<%=reqSiteCode%>';
		var appGroup = document.form1.appGrp.value;		
		
		if(cmd=='save'){			
			if (document.form1.reqDesc.value == '') {
				alert('Please enter project/short description');
				document.form1.reqDesc.focus();
				return false;
			}
			
			if (document.form1.sendAppTo.value == '') {
				alert('Please select approver');
				document.form1.sendAppTo.focus();
				return false;
			}
						
			if (document.form1.reqDate.value == '') {
				alert('Please enter request date');
				document.form1.reqDate.focus();
				return false;				
			}else{
				if (!validDate(document.form1.reqDate)) {
					alert('Invalid Date. (Format:DD/MM/YYYY)');
					
					return false;
				}
			}

//			appGrp = changeAppGrp(amountID,reqDept,appGroup);			

//			if('HKAH'==appGrp && '1'!=amountID){
				if(reqBugcode == '' && adCouncil == ''){
					document.form1.reqBugcode.focus();				
					alert('Please enter Budget Code or Ad Council NO.');
					return false;			
				}else{				
					var rtnMsg = checkBudgetRemain();
					if(rtnMsg!='true'){
						alert(rtnMsg);
						return false;								
					}
				}
//			}
					
			if (document.form1.reqRmk.value != '') {
				var rmk = document.form1.reqRmk.value;
				if(rmk.length>4000){
					alert('Remarks content length too long');
					document.form1.reqRmk.focus();
					return false;
				}
			}
									
			if(checkRowValue()==false){return false;}
			if(chkAmountId(amountID)==false){return false;}
			if(chkReqApprCode(amountID)==false){return false;}
		}

		
		var r=confirm("Confirm to submit?");
		if (r==true){
			if(reqNo!=null&&reqNo!= ''){
				if(chkReqStatus(reqNo)){
					amountID = document.getElementById("amountID").value;
					document.form1.command.value = cmd;
					document.form1.reqNo.value = reqNo;
					document.form1.amtID.value = amountID;					
					var abc = checkRowCnt();		
					document.form1.lstRowIdx.value = abc;	
					document.form1.submit();
					return false;				
				}else{
					return false;
				}				
			}else{
				amountID = document.getElementById("amountID").value;
				document.form1.command.value = cmd;
				document.form1.reqNo.value = reqNo;
				document.form1.amtID.value = amountID;					
				var abc = checkRowCnt();		
				document.form1.lstRowIdx.value = abc;	
				document.form1.submit();
				return false;
			}
		 }else{
			 return false;	
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
	
	function changeAppGrp(amountID,reqDept,appGroup){
		var siteCode = '<%=reqSiteCode%>';
		var deptHead = '<%=deptHead%>';
		var appGrp = null;

		if('HKAH'==siteCode.toUpperCase() && ('416'==reqDept||'417'==reqDept||'418'==reqDept)){		
			// check isExistApprovlGroup		
			$.ajax({
				type: "POST",
				url: "epo_hidden.jsp",
				data: 'p1=7&p2=' + amountID+'&p3='+deptHead+'&p4=HKIOC',
				async: false,
				success: function(values){				
				if(values != '') {
					if(values.substring(0, 1) == 1)  {
						appGrp = 'HKIOC';
					}else{
						 appGrp = 'HKIOC';
					}
				}else{('null value');}//if
				}//success
			});//$.ajax
			
		}else{
			appGrp = 'HKAH';			
		}
		return appGrp;
	}
	
	function getDeptHead(inputObj) {
		var did = inputObj.value;
		var siteCode = '<%=reqSiteCode%>';
		var appGroup = document.getElementById("appGrp").value;
		var reqStatus = document.form1.reqStatus.value;
		var amountID = document.form1.amountID.value;		
		var appGrp = null;
		
		appGrp = changeAppGrp(amountID,did,appGroup);
		changeAmtRange(amountID,appGrp,reqStatus);
		// reset appGrp
		if('0'==amountID && 'HKAH'==siteCode.toUpperCase() && ('416'==did||'417'==did||'418'==did)){
			appGrp = appGroup; 
		}else if(appGroup!=appGrp){
			document.getElementById("appGrp").value = appGrp;
		}

		$.ajax({
			type: "POST",
			url: "../ui/approvalIDCMB.jsp",
			data: "reqDept=" + did + "&category=epo&reqStat="+reqStatus+"&appGrp="+appGrp+"&amtID="+amountID,
			success: function(values){
				if(values != '') {
					$("#showStaffID_indicator").html("<select name='sendAppTo'>" + values + "</select>");
				}//if
			}//success
		});//$.ajax			
	}
	
	function getChangeApprovalList(inputObj) {
		var did = inputObj.value;				
		var appGroup = document.form1.appGrp.value;
		var reqDept = document.form1.reqDept.value;
		var reqStatus = document.form1.reqStatus.value;
		var amountID = document.form1.amountID.value;
		var appGrp = null;
		appGrp = changeAppGrp(amountID,reqDept,appGroup);
//		if(appGrp=='HKIOC' && did=='1'){					
			$.ajax({
				type: "POST",
				url: "../ui/approvalIDCMB.jsp",
				data: "reqDept=" + reqDept + "&category=epo&appGrp="+appGrp+"&reqStat="+reqStatus+"&amtID="+amountID,
				success: function(values){
					if(values != '') {
						$("#showStaffID_indicator").html("<select name='sendAppTo'>" + values + "</select>");
					}//if
				}//success
			});//$.ajax
		}
//	}
	
	function getChangeApprovalListByVal(amountID) {		
		var appGroup = document.form1.appGrp.value;
		var reqDept = document.form1.reqDept.value;
		var reqStatus = document.form1.reqStatus.value;
//		var amountID = document.form1.amountID.value;
		var appGrp = null;
		appGrp = changeAppGrp(amountID,reqDept,appGroup);
//		if(appGrp=='HKIOC' && amtID=='1'){					
			$.ajax({
				type: "POST",
				url: "../ui/approvalIDCMB.jsp",
				data: "reqDept=" + reqDept + "&category=epo&appGrp="+appGrp+"&reqStat="+reqStatus+"&amtID="+amountID,
				success: function(values){
					if(values != '') {
						$("#showStaffID_indicator").html("<select name='sendAppTo'>" + values + "</select>");
					}//if
				}//success
			});//$.ajax
		}
//	}	
	
	function isExistApprovlGroup(amountID,staffID,appGrp){
		$.ajax({
			type: "POST",
			url: "epo_hidden.jsp",
			data: 'p1=7&p2=' + amountID+'&p3='+staffID+'&p4='+appGrp,
			async: false,
			success: function(values){				
			if(values != '') {			
				if(values.substring(0, 1) == 1) {
					rtnVal = true;
					return false;																													
				}else if (values.substring(0, 1) == 0){
					rtnVal = false;						
					return false;
				}										
			}else{alert('null value');}//if
			}//success
		});//$.ajax	

		return rtnVal;		
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
	
	function chkReqStatus(reqNo){
		var rtnVal = false;
		
		$.ajax({
			type: "POST",
			url: "epo_hidden.jsp",
			data: 'p1=9&p2=' + reqNo,
			async: false,
			success: function(values){				
				if(values != '') {			
					if(values.substring(0, 1) == 'H' ||
					   values.substring(0, 1) == 'S') {
						rtnVal = true;
						return false;																													
					}else {
						alert('Status changed, cannot not save.');
						rtnVal = false;						
						return false;
					}										
				}else{alert('null value');}//if
					rtnVal = false;						
					return false;				
				}//success
		});//$.ajax		
		return rtnVal;	
	}		
	
</script>
<script type="text/javascript" >
/*
(function($){
    // call setMask function on the document.ready event
      $(function(){
        $('input:text').setMask();
      }
    );
  })(jQuery);
  */
</script>
</div>
</div></div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>