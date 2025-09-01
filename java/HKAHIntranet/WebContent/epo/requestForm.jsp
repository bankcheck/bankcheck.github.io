<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
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

System.err.println("[requestForm]:");
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
String reqBy = staffID;
String reqByName = StaffDB.getStaffFullName2(staffID);
String reqDate = TextUtil.parseStrUTF8((String) request.getAttribute("reqDate"));
//String reqSiteCode = StaffDB.getStaffSiteCode(userBean.getStaffID());
String reqSiteCode = ConstantsServerSide.SITE_CODE;
String reqDept = TextUtil.parseStrUTF8((String) request.getAttribute("reqDept"));
String reqBugcode = TextUtil.parseStrUTF8((String)request.getAttribute("reqBugcode"));
String reqDesc = TextUtil.parseStrUTF8((String) request.getAttribute("reqDesc"));
String shipTo = TextUtil.parseStrUTF8((String)request.getAttribute("shipTo"));
String reqRmk = TextUtil.parseStrUTF8((String) request.getAttribute("reqRmk"));
String sendAppTo = TextUtil.parseStrUTF8((String) request.getAttribute("sendAppTo"));
String amtID = TextUtil.parseStrUTF8((String) request.getAttribute("amtID"));
String adCouncil = TextUtil.parseStrUTF8((String) request.getAttribute("adCouncil"));
String boardCouncil = TextUtil.parseStrUTF8((String) request.getAttribute("boardCouncil"));
String financeComm = TextUtil.parseStrUTF8((String) request.getAttribute("financeComm"));
String reqStatus = TextUtil.parseStrUTF8((String) request.getAttribute("reqStatus"));
if(reqStatus==null){
	reqStatus = "S";
}
String appGrp = "HKAH";
String reqDeptName = null;
String shipToName = null;
String purRmk = null;
String aprRmk = null;
int approveFlag = 0;
String lstRowIdx = null;
int appRight = 1;
int noOfReq = 0;
/*
if("hkah".equals(reqSiteCode) && 
		("416".equals(reqDept) || "417".equals(reqDept) || "417".equals(reqDept))){
	appGrp = "HKIOC";
}
*/
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

boolean successAddDtl = false;
boolean successUptHdr = false;
boolean successDelDtl = false;
boolean isSamePos = false;
String approvalStaff = null;
String isExistApprovlGroup = null;
 
try {
	lstRowIdx = ParserUtil.getParameter(request, "lstRowIdx");
	if(createAction){
		System.err.println("[requestForm][createAction][sendAppTo]:"+sendAppTo);
/*		
		ArrayList record = EPORequestDB.getDeptHeadList(reqDept);
		if(record.size()>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			deptHead = row.getValue(0);
			ArrayList record1 = ApprovalUserDB.getEpoAppUserList("1", "1", deptHead, null, "HKAH");
			System.err.println("[record size]:"+record1.size()+"[deptHead]:"+deptHead);
			if(record1.size()>0){
				isSamePos = true;
			}
		}
*/
		ArrayList record1 = ApprovalUserDB.getEpoAppUserList("1", "1", sendAppTo, null, appGrp);
		if(record1.size()>0){
			isSamePos = true;
		}
		System.err.println("[amtID]:"+amtID+";[sendAppTo]:"+sendAppTo +";[appGrp]:"+appGrp);
		isExistApprovlGroup = EPORequestDB.isExistApprovlGroup(amtID,sendAppTo,"HKIOC");
		if("1".equals(isExistApprovlGroup) && 
				"hkah".equals(reqSiteCode) && 
						("416".equals(reqDept) || "417".equals(reqDept) || "417".equals(reqDept))){
			reqStatus = "H";
			appGrp = "HKIOC";
			approvalStaff = sendAppTo;
			reqNo = EPORequestDB.addReqHdr(staffID, reqDate, reqSiteCode, reqDept, shipTo, reqDesc, reqBugcode, amtID, reqRmk, sendAppTo, folderID, sysDate, adCouncil, boardCouncil, financeComm, purRmk, reqStatus, appGrp);			
		}else if(isSamePos){
			reqStatus = "H";
			approvalStaff = sendAppTo;
			reqNo = EPORequestDB.addReqHdr(staffID, reqDate, reqSiteCode, reqDept, shipTo, reqDesc, reqBugcode, amtID, reqRmk, sendAppTo, folderID, sysDate, adCouncil, boardCouncil, financeComm, purRmk, reqStatus, appGrp);
/* // comment on 01/08/2018 requested by Andrew Tam

		}else if("360".equals(reqDept)){
			reqStatus = "H";
			sendAppTo = EPORequestDB.getSupervisor(reqDept);
			reqNo = EPORequestDB.addReqHdr(staffID, reqDate, reqSiteCode, reqDept, shipTo, reqDesc, reqBugcode, amtID, reqRmk, sendAppTo, folderID, sysDate, adCouncil, boardCouncil, financeComm, purRmk, reqStatus, appGrp);
*/			
		}else{
			reqStatus = "S";			
			reqNo = EPORequestDB.addReqHdr(staffID, reqDate, reqSiteCode, reqDept, shipTo, reqDesc, reqBugcode, amtID, reqRmk, sendAppTo, folderID, sysDate, adCouncil, boardCouncil, financeComm, purRmk, reqStatus, appGrp);			
		}
System.err.println("[createAction][reqStatus]:"+reqStatus);
		for( int i=0;i<=Integer.parseInt(lstRowIdx);i++) {
			supplier = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "itemSupp[" +i+ "].fields2"));
			itemDesc = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "itemDesc[" +i+ "].fields3"));
			uom = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "itemUnit[" +i+ "].fields7"));
			qty = ParserUtil.getParameter(request, "itemQty[" +i+ "].fields4");
			price = ParserUtil.getParameter(request, "itemPrice[" +i+ "].fields6");
			amount = ParserUtil.getParameter(request, "itemAmountHid["+i+"]");

			successAddDtl = EPORequestDB.addReqDtl(staffID, reqNo, Integer.toString(i+1), supplier, itemDesc, qty, amount, price, uom, itemRmk, sysDate, "0", null);			
			EPORequestDB.addReqDtlLog(userBean, reqNo, Integer.toString(i+1), supplier, itemDesc, qty, amount, price, uom, itemRmk, sysDate, "0", null);
		}
		
		if ((reqNo!=null||reqNo.length()> 0)&&successAddDtl){
			if(EPORequestDB.sendEmail(reqNo, staffID, staffID, approvalStaff, reqDesc, reqStatus, folderID, "1", "1")){
				message = "New Requisition added and email sent to department head.";
				createAction = false;				
			}else{
				message = "New Requisition added but email sent failed";
				createAction = false;				
			}
		} else {
			errorMessage = "Requisition create fail.";
			createAction = false;			
		}
		
		reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
		shipToName = DepartmentDB.getDeptDesc(shipTo);		
	}else if(updateAction){
		isExistApprovlGroup = EPORequestDB.isExistApprovlGroup(amtID,sendAppTo,"HKIOC");
	
		if("1".equals(isExistApprovlGroup) && 
				"hkah".equals(reqSiteCode) && 
						("416".equals(reqDept) || "417".equals(reqDept) || "417".equals(reqDept))){
			reqStatus = "H";
			appGrp = "HKIOC";
			approvalStaff = sendAppTo;
		}
		System.err.println("[appGrp]:"+appGrp+";[reqStatus]:"+reqStatus);
		successUptHdr = EPORequestDB.updateRequestHdr(userBean, reqNo, reqDate, reqSiteCode, reqDept, shipTo, reqDesc, reqBugcode, amtID, reqRmk, null, sysDate, adCouncil, boardCouncil, financeComm, reqStatus);
		successDelDtl = EPORequestDB.delReqDtl(reqNo);
		
		for( int i=0;i<=Integer.parseInt(lstRowIdx);i++) {
			supplier = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "itemSupp[" +i+ "].fields2"));
			itemDesc = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "itemDesc[" +i+ "].fields3"));
			uom = ParserUtil.getParameter(request, "itemUnit[" +i+ "].fields7");
			qty = ParserUtil.getParameter(request, "itemQty[" +i+ "].fields4");
			price = ParserUtil.getParameter(request, "itemPrice[" +i+ "].fields6");
			amount = ParserUtil.getParameter(request, "itemAmountHid["+i+"]");
			if(itemDesc!=null && itemDesc.length()>0){			
				successAddDtl = EPORequestDB.addReqDtl(staffID, reqNo, Integer.toString(i+1), supplier, itemDesc, qty, amount, price, uom, itemRmk, sysDate, "0", null);
				EPORequestDB.addReqDtlLog(userBean, reqNo, Integer.toString(i+1), supplier, itemDesc, qty, amount, price, uom, itemRmk, sysDate, "0", null);
			}
		}
	
		if (successUptHdr && successDelDtl && successAddDtl){
			message = "Requisition update success";
			updateAction = false;			
		} else {
			errorMessage = "Requisition update fail.";
			updateAction = false;			
		}
		
		if("S".equals(reqStatus)){
			ArrayList record1 = EPORequestDB.getDeptHeadList(reqDept);
			if(record1.size()>0){
				ReportableListObject row = (ReportableListObject) record1.get(0);
				deptHead = row.getValue(0);
			}
		}else {
			reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
			shipToName = DepartmentDB.getDeptDesc(shipTo);
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

		reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
		shipToName = DepartmentDB.getDeptDesc(shipTo);		
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
				reqDeptName = DepartmentDB.getDeptDesc(reqDept);				
				reqBugcode = row.getValue(7);
				amtID = row.getValue(8);				
				reqDesc = row.getValue(6);
				shipTo = row.getValue(5);
				shipToName = DepartmentDB.getDeptDesc(shipTo);
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
		}

		if("A".equals(reqStatus)){
			message = "Requisition approved";
			viewAction = false;			
		}else if("R".equals(reqStatus)){
			message = "Requisition rejected";
			viewAction = false;
		}else if("O".equals(reqStatus)){
			message = "Requisition approved and item ordered";
			viewAction = false;
		}else if("C".equals(reqStatus)){
			message = "Requisition cancelled";
			viewAction = false;
		}else if("Z".equals(reqStatus)){
			message = "PO Processing";
			viewAction = false;
		}else if("F".equals(reqStatus)){
			message = "Requisition waiting further approval";
			viewAction = false;				
		}else{
			if("S".equals(reqStatus) || "H".equals(reqStatus)){
				ArrayList record1 = EPORequestDB.getDeptHeadList(reqDept);
				if(record1.size()>0){
					ReportableListObject row = (ReportableListObject) record1.get(0);
					deptHead = row.getValue(0);
				}
			}
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
				reqDeptName = DepartmentDB.getDeptDesc(reqDept);
				reqBugcode = row.getValue(7);
				amtID = row.getValue(8);				
				reqDesc = row.getValue(6);
				shipTo = row.getValue(5);
				shipToName = DepartmentDB.getDeptDesc(shipTo);
				reqStatus = row.getValue(9); 
				reqRmk = row.getValue(10);
				sendAppTo  = row.getValue(11);					
				approveFlag = Integer.parseInt(row.getValue(12));
				adCouncil = row.getValue(14); 	
				boardCouncil = row.getValue(15);
				financeComm = row.getValue(16);
				aprRmk = row.getValue(18);				
			}

			if(EPORequestDB.sendEmail(reqNo, null, staffID, sendAppTo, reqDesc, reqStatus, folderID, "E", "1")){
				message = "Mail resent success";
				emailAction = false;				
			}else{
				errorMessage = "Mail resent failed";
				emailAction = false;				
			}
			
			if("S".equals(reqStatus)){
				ArrayList record1 = EPORequestDB.getDeptHeadList(deptCode);
				if(record1.size()>0){
					ReportableListObject row = (ReportableListObject) record1.get(0);
					deptHead = row.getValue(0);			
				}
			}			
		}
	} else {
		if("S".equals(reqStatus)){
			ArrayList record1 = EPORequestDB.getDeptHeadList(deptCode);
			if(record1.size()>0){
				ReportableListObject row = (ReportableListObject) record1.get(0);
				deptHead = row.getValue(0);			
			}
		}
		errorMessage = "";
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		reqDate = dateFormat.format(calendar.getTime());
	}	
} catch (Exception e) {
	e.printStackTrace();
}

System.out.println("[epo requestForm] reqNo=" + reqNo+ ", reqStatus="+reqStatus + ", login staff ID="+userBean.getStaffID()+", reqDate=" + reqDate);
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
<form name="form1" id="form1" enctype="multipart/form-data" action="requestForm.jsp" method=post onkeypress="return event.keyCode!=13">
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
			<input type="hidden" name="reqBugcode" value="<%=reqBugcode==null?"":reqBugcode %>" />
			<b><%=reqBugcode==null?"":reqBugcode %></b>
		<%} %>		
		</td>		
		<td class="infoLabel" width="20%"><bean:message key="prompt.adCouncil" /></td>
		<td class="infoData2" width="30%">
		<%if("S".equals(reqStatus) || "H".equals(reqStatus)){ %>		
			<input type="textfield" name="adCouncil" value="<%=adCouncil==null?"":adCouncil %>" maxlength="30" size="30" />
		<%}else{ %>
			<b><%=adCouncil==null?"":adCouncil %></b>		
			<input type="hidden" name="adCouncil" value="<%=adCouncil==null?"":adCouncil %>" />		
		<%} %>									
		</td>	
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.financeComm" /></td>
		<td class="infoData2" width="30%">
		<%if("S".equals(reqStatus) || "H".equals(reqStatus)){ %>		
			<input type="textfield" name="financeComm" value="<%=financeComm==null?"":financeComm %>" maxlength="30" size="30"/>
		<%}else{ %>
			<b><%=financeComm==null?"":financeComm %></b>				
			<input type="hidden" name="financeComm" value="<%=financeComm==null?"":financeComm %>"/>		
		<%} %>							
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.boardCouncil" /></td>
		<td class="infoData2" width="30%">
		<%if("S".equals(reqStatus) || "H".equals(reqStatus)){ %>		
			<input type="textfield" name="boardCouncil" value="<%=boardCouncil==null?"":boardCouncil %>" maxlength="30" size="30"/>
		<%}else{ %>
			<b><%=boardCouncil==null?"":boardCouncil %></b>						
			<input type="hidden" name="boardCouncil" value="<%=boardCouncil==null?"":boardCouncil %>"/>
		<%} %>								
		</td>			
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDesc" /></td>
		<td class="infoData2" width="80%" colspan=3>
		<%if("S".equals(reqStatus)){ %>
			<input type="textfield" name="reqDesc" value="<%=reqDesc==null?"":reqDesc %>" maxlength="100" size="80"/>
		<%}else{ %>		
			<input type="hidden" name="reqDesc" value="<%=reqDesc==null?"":reqDesc %>" />
			<b><%=reqDesc==null?"":reqDesc %></b>			
		<%} %>		
		</td>	
	</tr>		
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDate" /></td>
		<td class="infoData2" width="80%" colspan=3>
		<%if("S".equals(reqStatus)){ %>
			<input type="textfield" name="reqDate" id="reqDate" class="datepickerfield" value="<%=reqDate==null?"":reqDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)		
		<%}else{ %>
			<input type="hidden" name="reqDate" value="<%=reqDate==null?"":reqDate %>" />
			<b><%=reqDate==null?"":reqDate %> (DD/MM/YYYY)</b>					
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
		<%if("S".equals(reqStatus)){ %>
			<select name="reqDept" onchange="return getDeptHead(this)">
			<%reqDept = reqDept == null ? deptCode : reqDept; %>
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=reqDept %>" />
				<jsp:param name="allowAll" value="Y" />					
			</jsp:include>
			</select>
		<%}else{ %>
			<input type="hidden" name="reqDept" value="<%=reqDept==null?"":reqDept %>" />
			<b><%=reqDeptName==null?"":reqDeptName %></b>
		<%} %>							
		</td>
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqShipTo" /></td>
		<td class="infoData2" width="80%" colspan=3>
		<%if("S".equals(reqStatus)){ %>
			<select name="shipTo">
			<%shipTo = shipTo == null ? deptCode : shipTo; %>			
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=shipTo %>" />
				<jsp:param name="allowAll" value="Y" />				
			</jsp:include>
			</select>
		<%}else{ %>
			<input type="hidden" name="shipTo" value="<%=shipTo==null?reqDept:shipTo %>" />
			<b><%=shipToName==null?"":shipToName %></b>
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
<%if("S".equals(reqStatus)||"H".equals(reqStatus)){ %>
			<div class=box><textarea id="wysiwyg" name="reqRmk" rows="5" cols="100" align="left"><%=reqRmk==null?"":reqRmk %></textarea></div>
<%}else{ %>
		<%if(reqRmk!=null && reqRmk.length()>0){%>
			<table cellpadding="1" cellspacing="0" border="1" bgcolor="#FFFFFF" width="515">
				<tr><td class="infoLabelNormal"><%=reqRmk==null?"":reqRmk %></td></tr>
			</table>
		<%} %>					
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
		<span id="showStaffID_indicator">						
			<select name="sendAppTo" >			
			<%sendAppTo = sendAppTo == null ? "" : sendAppTo; %>
			<%deptHead = deptHead == null ? "" : deptHead; %>	
			<%System.err.println("[appGrp]:"+appGrp+";[deptHead]:"+deptHead+";[reqNo]"+reqNo); %>
			<jsp:include page="../ui/approvalIDCMB.jsp" flush="false">
				<jsp:param name="deptHead" value="<%=deptHead%>" />
				<jsp:param name="reqNo" value="<%=reqNo %>" />
				<jsp:param name="reqStat" value="<%=reqStatus %>" />
				<jsp:param name="sendAppTo" value="<%=sendAppTo %>" />
				<jsp:param name="appGrp" value="<%=appGrp %>" />
				<jsp:param name="category" value="epo" />								
			</jsp:include>			
			</select>
		</span>
		</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.attachment" /></td>
		<td class="infoData2" align="center">		
		<%if(!"S".equals(reqStatus)){ %>		
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
			<input type="file" name="file1" size="50" class="multi" maxlength="10">			
		<%} %>
		</td>
	</tr>					
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td align="center">
		<%System.err.println("1[serverSiteCode]:"+serverSiteCode+";[reqDept]:"+reqDept); %>
 		<%if(("S".equals(reqStatus)||"H".equals(reqStatus)) && !"admin".equals(staffID)&&(!EPORequestDB.isPurchaser(userBean,appGrp)||(EPORequestDB.isPurchaser(userBean,appGrp)&&"685".equals(reqDept)))&&!EPORequestDB.isVPF(userBean,appGrp)){ %>				
			<button onclick="return submitAction('save','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.save" /></button>
			<%if(reqNo!=null&&reqNo.length()>0){ %>			
				<button onclick="return resendEmail('email','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.resendMail" /></button>
			<%} %>			
		<%}else{
			System.err.println("2[serverSiteCode]:"+serverSiteCode+";[reqDept]:"+reqDept+";[isVPF]:"+EPORequestDB.isVPF(userBean,appGrp));
				if(("S".equals(reqStatus)||"H".equals(reqStatus)) && EPORequestDB.isVPF(userBean,appGrp) && (("hkah".equals(serverSiteCode) && "640".equals(reqDept)) || ("twah".equals(serverSiteCode) && "FNAN".equals(reqDept))) ){ %>
					<button onclick="return submitAction('save','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.save" /></button>
					<button onclick="return resendEmail('email','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.resendMail" /></button>									
				<%} %>
		<%} %>
 		<%if(("S".equals(reqStatus)||"H".equals(reqStatus))&& reqNo!=null && reqNo.length()>0 && !"admin".equals(staffID)&&(!EPORequestDB.isPurchaser(userBean,appGrp)||(EPORequestDB.isPurchaser(userBean,appGrp)&&"685".equals(reqDept)))&&!EPORequestDB.isVPF(userBean,appGrp)){ %>				
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
		var appGrp = null;		
		var amountID = document.getElementById("amountID").value;
		var reqDept = document.form1.reqDept.value;
		var siteCode = '<%=reqSiteCode%>';
		var appGroup = document.form1.appGrp.value;
		var reqStatus = document.form1.reqStatus.value;		
		
		if(cmd=='save'){			
			if (document.form1.reqDesc.value == '') {
				alert('Please enter project/short description');
				document.form1.reqDesc.focus();
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
				if(document.form1.reqBugcode.value == '' && document.form1.adCouncil.value == ''){
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
		}

		if(reqNo!=''){
			var r=confirm("Confirm to save?");			
		}else{
			var r=confirm("Confirm to submit?");			
		}
		
		if (r==true){			
			amountID = document.getElementById("amountID").value;
			document.form1.command.value = cmd;	
			document.form1.reqNo.value = reqNo;
			document.form1.amtID.value = amountID;					
			var abc = checkRowCnt();		
			document.form1.lstRowIdx.value = abc;			
			document.form1.submit();
//			window.opener.refresh();
			return false;	
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
			
			// Oncology Center (415, deptHead=46) staff will enter HKIOC request too!
			/*
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
						appGrp = appGroup;
					}
				}else{alert('null value');}//if
				}//success
			});//$.ajax
			*/
			
			appGrp = 'HKIOC';
		}else{
			appGrp = 'HKAH';			
		}
		return appGrp;
	}

	function getDeptHead(inputObj) {
		var did = inputObj.value;
		var siteCode = '<%=reqSiteCode%>';
		var appGroup = document.form1.appGrp.value;
		var reqStatus = document.form1.reqStatus.value;
		var amountID = document.form1.amountID.value;		
		var appGrp = null;

		appGrp = changeAppGrp(amountID,did,appGroup);
		changeAmtRange(amountID,appGrp,reqStatus);
		
//		if(appGrp=='HKIOC' && did=='1'){
		// reset appGrp
		if('0'==amountID && 'HKAH'==siteCode.toUpperCase() && ('416'==did||'417'==did||'418'==did)){
			appGrp = appGroup;
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
	
	function getChangeApprovalListByVal(amountID) {		
		var appGroup = document.form1.appGrp.value;
		var reqDept = document.form1.reqDept.value;
		var reqStatus = document.form1.reqStatus.value;
//		var amountID = document.form1.amountID.value;
		var appGrp = null;
		appGrp = changeAppGrp(amountID,reqDept,appGroup);
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