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
			DocumentDB.add(userBean, "epo", folderID, webUrl, fileList[i]);
		}
	}
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
%>
<%
String deptCode = userBean.getDeptCode();
String reqBy = ParserUtil.getParameter(request, "reqBy");
String poDate = ParserUtil.getParameter(request, "poDate");
String poSiteCode = ParserUtil.getParameter(request, "poSiteCode");
String poDeptCode = ParserUtil.getParameter(request, "poDeptCode");
String budgetCode = ParserUtil.getParameter(request, "budgetCode");
String shipTo = ParserUtil.getParameter(request, "shipTo");
String reqDesc = null;
String reqRmk = null;
String reqStatus = ParserUtil.getParameter(request, "reqStatus");
String purRmk = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "purRmk")); 
String reqDate = null;
String reqBugcode = null;
String adCouncil = null;
String boardCouncil = null;
String financeComm = null;
String lstRowIdx = null;
String reqByName = null;
String existPoNO = null;
String aprRmk = null;
int alreadyOrder = 0;

/*
ArrayList poList = EPORequestDB.existPoListByReq(reqNo);
alreadyOrder = poList.size();
if(alreadyOrder>0){
	for(int z=0;z<=poList.size();z++){
		ReportableListObject row = (ReportableListObject) poList.get(0);
		if(existPoNO!=null && existPoNO.length()>0){
			existPoNO = existPoNO +","+ row.getValue(0);	
		}else{
			existPoNO = row.getValue(0);
		}
		
	}	
}
*/
String apprId = userBean.getStaffID();
Calendar cal = Calendar.getInstance();
SimpleDateFormat dateFmt = new SimpleDateFormat("ddMMyyyyHHmmss");
String sysDate = dateFmt.format(cal.getTime());

boolean createAction = false;
boolean updateAction = false;
boolean viewAction = false;
boolean emailAction = false;
boolean orderAction = false;
boolean poProcAction = false;
boolean pendAction = false;
boolean resendAction = false;
boolean closeAction = false;

if("view".equals(command)){
	viewAction = true;
}else if ("save".equals(command)) {
	updateAction = true;
}else if ("email".equals(command)) {
	emailAction = true;
}else if ("poProc".equals(command)) {
	poProcAction = true;
}else if ("pending".equals(command)) {
	pendAction = true;
}else if ("order".equals(command)) {
	orderAction = true;
}else if ("create".equals(command)) {
	createAction = true;
}else if ("menuSend".equals(command)) {
	resendAction = true;
}

String poNO = null;
String supplier = null;
String itemDesc = null;
String uom = null;
String reqQty = null;
String ordQty = null;
String prevQty = null;
String price = null;
String payAmt = null;
String ordAmt = null;
String netAmt = null;
String amount = null;
String itemRmk = null;
String itemAppFlag = null;
String itemSeq = null;
String outQty = null;
String amtID = null;
boolean successInsertLog = false;
boolean succUptReqHdr = false;
int uptDtlFail = 0;
try {
	lstRowIdx = ParserUtil.getParameter(request, "lstRowIdx");
	
	if(updateAction){		
// load data from database		
	}else if(createAction){		
// load data from database
		HashMap hm = new HashMap();		
		int poCounter = 0;
		int hdrCounter = 0;
		int hdrInsertSucc = 0;
		int dtlInsertSucc = 0;
		int hdrAmtUpdateSucc = 0;
		succUptReqHdr = false;
				
		int noOfRow = 0;
		
		ArrayList record = EPORequestDB.getRequestHdr(reqNo);
		if(record.size()>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			reqDate = row.getValue(1);				
			reqBy = row.getValue(2);
			reqByName = StaffDB.getStaffFullName2(reqBy);	
			poSiteCode = row.getValue(3);				
			poDeptCode = row.getValue(4);
			reqDesc = row.getValue(6);
			shipTo = row.getValue(5);
			amtID = row.getValue(8);				
			reqRmk = row.getValue(10);
			reqBugcode = row.getValue(7);			
			adCouncil = row.getValue(14); 	
			boardCouncil = row.getValue(15);
			financeComm = row.getValue(16);			
			aprRmk = row.getValue(18);			
		}		
		
		for(int i=0;i<=Integer.parseInt(lstRowIdx);i++) {
			if("on".equals(ParserUtil.getParameter(request, "checkOrder["+i+"]"))){
				noOfRow ++;
				poNO = ParserUtil.getParameter(request, "itemPO[" +i+ "]");
				itemSeq = ParserUtil.getParameter(request, "itemSeq[" +i+ "].fields1");			
				supplier = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "itemSupp[" +i+ "].fields2"));
				itemDesc = TextUtil.parseStrUTF8((String) ParserUtil.getParameter(request, "itemDesc[" +i+ "].fields3"));
				uom = ParserUtil.getParameter(request, "itemUnit[" +i+ "].fields7");
				reqQty = ParserUtil.getParameter(request, "itemQty[" +i+ "].fields4");			
				ordQty = ParserUtil.getParameter(request, "poQty[" +i+ "]");
				price = ParserUtil.getParameter(request, "itemPrice[" +i+ "].fields6");
				amount = ParserUtil.getParameter(request, "itemAmountHid["+i+"]");
				netAmt = ParserUtil.getParameter(request, "netAmt["+i+"]");				

				if(hm.containsKey(poNO)){
					poCounter = Integer.parseInt((String) hm.get(poNO));
				}else{				
					if(EPORequestDB.addPoHdr(poNO, reqNo, poDate, poSiteCode, poDeptCode, shipTo, "",
											"", "", "", "", "", "", "", "", "", "", itemRmk, "1", "0", "", "0", "0",
											"0", "", "0", "0", "0", "0", "0", "", "1", userBean.getStaffID(), userBean.getStaffID(), "0", "", "", "0", "", "", folderID,sysDate)){
						hdrInsertSucc++;
					}
					
					hdrCounter++;
					poCounter = 0;
				}
				poCounter++;
				if(EPORequestDB.updateHdrAmount(poNO, amount, amount) && EPORequestDB.addPoDtl(userBean, poNO, reqNo, Integer.toString(poCounter), itemSeq, itemDesc, supplier, "", uom, reqQty, ordQty, price, amount, "", sysDate, netAmt) &&
					EPORequestDB.updateReqDtlRemain(userBean, reqNo, itemSeq, reqQty, ordQty, sysDate)){					
					dtlInsertSucc++;
					hdrAmtUpdateSucc++;
					hm.put(poNO, String.valueOf(itemSeq));
				}
			}				
		}

		EPORequestDB.execProcUptComp("PROC_UPDATE_TO_COMP('"+reqNo+"','"+userBean.getStaffID()+"','"+sysDate+"')");		
				
		if(hdrAmtUpdateSucc==noOfRow && hdrInsertSucc==hdrCounter && noOfRow==dtlInsertSucc){
			String f_rtn = UtilDBWeb.callFunction("F_UPDATE_ORDERED", "",new String[] {reqNo,userBean.getStaffID(),sysDate});			
			if("1".equals(f_rtn)){
				reqStatus = "O";
				if(EPORequestDB.sendEmail(reqNo, reqBy, userBean.getStaffID(), reqBy, reqDesc, reqStatus, folderID, "1", "1")){
					EPORequestDB.addReqLog(userBean, reqNo, reqStatus, sysDate);
					EPORequestDB.updatePurRmk(reqNo,purRmk);
					
					sendMessage = "mail sent success";
					message = "PO detail update success and "+sendMessage;
				}else{
					sendMessage = "mail sent failed";					
					message = "PO detail update success and "+sendMessage;
				}				
			}else{
				reqStatus = "P";				
				succUptReqHdr = EPORequestDB.updateHdrStatus(userBean, reqNo, reqStatus, null, null, null, sysDate, null, null, null, null, null, amtID);
				EPORequestDB.updatePurRmk(reqNo,purRmk);				
				message = "PO detail update success";				
			}
			
			succUptReqHdr = false;			
			createAction = false;			
			orderAction = false;		
		}else{
			errorMessage = "PO detail update fail";			
			createAction = false;			
			orderAction = false;			
		}
	
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		poDate = dateFormat.format(calendar.getTime());
	}else if(orderAction){
		ArrayList record = EPORequestDB.getRequestHdr(reqNo);
		if(record.size()>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			reqDate = row.getValue(1);					
			reqBy = row.getValue(2);
			reqByName = StaffDB.getStaffFullName2(reqBy);					
			poSiteCode = row.getValue(3);				
			poDeptCode = row.getValue(4);
			reqDesc = row.getValue(6);
			shipTo = row.getValue(5);
			reqStatus = row.getValue(9);
			amtID = row.getValue(8);			
			reqRmk = row.getValue(10);
			reqBugcode = row.getValue(7);			
			adCouncil = row.getValue(14);
			boardCouncil = row.getValue(15);
			financeComm = row.getValue(16);
			purRmk = row.getValue(17);
			aprRmk = row.getValue(18);			
		}
				
		errorMessage = "";
		if("O".equals(reqStatus)){
			message = "PO complete ordered";			
		}else if(alreadyOrder>0 && "O".equals(reqStatus)){
			message = "PO partial order";
		}
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		poDate = dateFormat.format(calendar.getTime());
	} else if (poProcAction){
		reqStatus = "Z";
		succUptReqHdr = EPORequestDB.updateHdrStatus(userBean, reqNo, reqStatus, null, null, null, sysDate, null, null, null, null, null, null);
		EPORequestDB.updateDtlModDt(userBean, reqNo);
		
		if (succUptReqHdr){
			message = "PO in process";
		} else {
			errorMessage = "Update status failed";			
		}
		
		ArrayList record = EPORequestDB.getRequestHdr(reqNo);
		if(record.size()>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			reqNo = row.getValue(0);
			reqDate = row.getValue(1);					
			reqBy = row.getValue(2);
			reqByName = StaffDB.getStaffFullName2(reqBy);					
			poSiteCode = row.getValue(3);				
			poDeptCode = row.getValue(4);
			reqDesc = row.getValue(6);
			shipTo = row.getValue(5);
			reqStatus = row.getValue(9);
			amtID = row.getValue(8);			
			reqRmk = row.getValue(10);
			reqBugcode = row.getValue(7);			
			adCouncil = row.getValue(14);
			boardCouncil = row.getValue(15);
			financeComm = row.getValue(16);
			purRmk = row.getValue(17);
			aprRmk = row.getValue(18);			
		}		
		
		succUptReqHdr = false;
	} else if (pendAction){
		reqStatus = "D";
		succUptReqHdr = EPORequestDB.updateHdrStatus(userBean, reqNo, reqStatus, purRmk, null, null, sysDate, null, null, null, null, null, null);
		EPORequestDB.updateDtlModDt(userBean, reqNo);
		
		if (succUptReqHdr){
			message = "PO in pending";
		} else {
			errorMessage = "Update status failed";			
		}
		
		ArrayList record = EPORequestDB.getRequestHdr(reqNo);
		if(record.size()>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			reqNo = row.getValue(0);
			reqDate = row.getValue(1);					
			reqBy = row.getValue(2);
			reqByName = StaffDB.getStaffFullName2(reqBy);					
			poSiteCode = row.getValue(3);				
			poDeptCode = row.getValue(4);
			reqDesc = row.getValue(6);
			shipTo = row.getValue(5);
			reqStatus = row.getValue(9);
			amtID = row.getValue(8);			
			reqRmk = row.getValue(10);
			reqBugcode = row.getValue(7);			
			adCouncil = row.getValue(14);
			boardCouncil = row.getValue(15);
			financeComm = row.getValue(16);
			purRmk = row.getValue(17);
			aprRmk = row.getValue(18);			
		}		
		
		succUptReqHdr = false;		
	} else if (resendAction){		
		ArrayList record = EPORequestDB.getRequestHdr(reqNo);
		if(record.size()>0){
			ReportableListObject row = (ReportableListObject) record.get(0);
			reqNo = row.getValue(0);
			reqDate = row.getValue(1);					
			reqBy = row.getValue(2);
			reqByName = StaffDB.getStaffFullName2(reqBy);					
			poSiteCode = row.getValue(3);				
			poDeptCode = row.getValue(4);
			reqDesc = row.getValue(6);
			shipTo = row.getValue(5);
			reqStatus = row.getValue(9);
			amtID = row.getValue(8);			
			reqRmk = row.getValue(10);
			reqBugcode = row.getValue(7);			
			adCouncil = row.getValue(14);
			boardCouncil = row.getValue(15);
			financeComm = row.getValue(16);
			purRmk = row.getValue(17);
			aprRmk = row.getValue(18);			
		}
		
		if(EPORequestDB.sendEmail(reqNo, reqBy, userBean.getStaffID(), null, reqDesc, reqStatus, folderID, "1", "3")){
			message = "Mail sent success";
		} else {
			errorMessage = "Mail sent failed";			
		}						

	} else {
		errorMessage = "";
		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		poDate = dateFormat.format(calendar.getTime());
	}
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
<form name="form1" id="form1" enctype="multipart/form-data" action="orderDetail.jsp" method=post onkeypress="return event.keyCode!=13">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqNo" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<b><%=reqNo==null?"":reqNo%></b>			
		</td>				
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDesc" /></td>
		<td class="infoData2" width="30%" colspan=3>
			<input type="textfield" name="reqDesc" value="<%=reqDesc==null?"":reqDesc %>" maxlength="100" size="80" disabled="disabled"/>		
		</td>	
	</tr>
<%if("O".equals(reqStatus)) {%>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDate" /></td>
		<td class="infoData2" width="80%" colspan=3>		
			<input type="textfield" name="reqDate" id="reqDate" value="<%=reqDate==null?"":reqDate %>" maxlength="15" size="10" disabled="disabled"/> (DD/MM/YYYY)									
		</td>		
	</tr>			
<%}else{ %>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.poDate" /></td>
		<td class="infoData2" width="30%">		
			<input type="textfield" name="poDate" id="poDate" class="datepickerfield" value="<%=poDate==null?"":poDate %>" maxlength="15" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)									
		</td>	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDate" /></td>
		<td class="infoData2" width="30%">		
			<input type="textfield" name="reqDate" id="reqDate" value="<%=reqDate==null?"":reqDate %>" maxlength="15" size="10" disabled="disabled"/> (DD/MM/YYYY)									
		</td>		
	</tr>
<%} %>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqBy" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="reqBy" id="reqBy" value="<%=reqByName==null?"":reqByName %>" maxlength="20" size="20" disabled="disabled"/>			
		</td>
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.siteCode" /></td>
		<td class="infoData2" width="80%" colspan=3>
			<input type="textfield" name="poSiteCode" id="poSiteCode" value="<%=poSiteCode==null?"":poSiteCode %>" maxlength="20" size="20" disabled="disabled"/>			
		</td>
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqDept" /></td>
		<td class="infoData2" width="30%">	
			<select name="poDeptCode" disabled="disabled">
			<%poDeptCode = poDeptCode == null ? deptCode : poDeptCode; %>
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=poDeptCode %>" />
				<jsp:param name="allowAll" value="Y" />										
			</jsp:include>
			</select>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqShipTo" /></td>
		<td class="infoData2" width="30%">			
			<select name="shipTo" disabled="disabled">
			<%shipTo = shipTo == null ? deptCode : shipTo; %>			
			<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
				<jsp:param name="deptCode" value="<%=shipTo %>" />
				<jsp:param name="allowAll" value="Y" />								
			</jsp:include>
			</select>							
		</td>			
	</tr>
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.reqBugCode" /></td>
		<td class="infoData2" width="30%">
			<input type="textfield" name="reqBugcode" value="<%=reqBugcode==null?"":reqBugcode %>" maxlength="30" size="30" disabled="disabled"/>		
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.adCouncil" /></td>
		<td class="infoData2" width="30%">		
			<input type="textfield" name="adCouncil" value="<%=adCouncil==null?"":adCouncil %>" maxlength="30" size="30" disabled="disabled"/>						
		</td>			
	</tr>
	<tr class="smallText">			
		<td class="infoLabel" width="20%"><bean:message key="prompt.financeComm" /></td>
		<td class="infoData2" width="30%">		
			<input type="textfield" name="financeComm" value="<%=financeComm==null?"":financeComm %>" maxlength="30" size="30" disabled="disabled"/>				
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.boardCouncil" /></td>
		<td class="infoData2" width="30%">		
			<input type="textfield" name="boardCouncil" value="<%=boardCouncil==null?"":boardCouncil %>" maxlength="30" size="30" disabled="disabled"/>					
		</td>			
	</tr>					
</table>
<%reqNo = reqNo == null ? "" : reqNo; %>
<%reqStatus = reqStatus == null ? "" : reqStatus; %>
<%if("A".equals(reqStatus)) {%>
		<span id="edit_indicator"> 
			<jsp:include page="orderDetailItem.jsp" flush="false" >
				<jsp:param name="reqNo" value="<%=reqNo %>" />
				<jsp:param name="reqStatus" value="<%=reqStatus %>" />		
			</jsp:include>
		</span>
<%}else if("P".equals(reqStatus)) { %>
		<span id="edit_indicator"> 
			<jsp:include page="orderedDetailItem.jsp" flush="false" >
				<jsp:param name="reqNo" value="<%=reqNo %>" />
				<jsp:param name="reqStatus" value="<%=reqStatus %>" />		
			</jsp:include>
		</span>
<%}else if("O".equals(reqStatus)) {  %>
		<span id="edit_indicator"> 
			<jsp:include page="compOrderItem.jsp" flush="false" >
				<jsp:param name="reqNo" value="<%=reqNo %>" />
				<jsp:param name="reqStatus" value="<%=reqStatus %>" />
			</jsp:include>
		</span>
<%}else if("Z".equals(reqStatus)) {%>
		<span id="edit_indicator"> 
			<jsp:include page="orderDetailItem.jsp" flush="false" >
				<jsp:param name="reqNo" value="<%=reqNo %>" />
				<jsp:param name="reqStatus" value="<%=reqStatus %>" />		
			</jsp:include>
		</span>
<%}else if("D".equals(reqStatus)) {%>
		<span id="edit_indicator"> 
			<jsp:include page="orderDetailItem.jsp" flush="false" >
				<jsp:param name="reqNo" value="<%=reqNo %>" />
				<jsp:param name="reqStatus" value="<%=reqStatus %>" />		
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
		<%if(aprRmk!=null && aprRmk.length()>0){%>
			<table cellpadding="1" cellspacing="0" border="1" bgcolor="#FFFFFF" width="515">
				<tr><td class="infoLabelNormal"><%=aprRmk==null?"":aprRmk %></td></tr>
			</table>
		<%} %>								
		</td>		
	</tr>	
	<tr class="smallText">
		<td class="infoLabel"><bean:message key="prompt.purRmk" /></td>	
		<td class="infoData2">
		<%if("O".equals(reqStatus)) {  %>
			<%if(purRmk!=null && purRmk.length()>0){%>
				<table cellpadding="1" cellspacing="0" border="1" bgcolor="#FFFFFF" width="515">
					<tr><td class="infoLabelNormal"><%=purRmk==null?"":purRmk %></td></tr>
				</table>
			<%} %>
		<%}else{ %>
			<div class=box><textarea id="wysiwyg" name="purRmk" rows="5" cols="100" align="left"><%=purRmk==null?"":purRmk %></textarea></div>		
		<%} %>								
		</td>		
	</tr>	
<%if(!"O".equals(reqStatus)){ %>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.sAttachment" /></td>
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
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.nAttachment" /></td>
		<td class="infoData2" align="center">		 			
			<input type="file" name="file1" size="50" class="multi" maxlength="10">						
		</td>
	</tr>		
<%}else{ %>
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
<%} %>					
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td align="center">
<%if(!"O".equals(reqStatus)){ %>		
			<button onclick="return submitAction('create','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.save" /></button>			
<%} %>
<%if("A".equals(reqStatus)){ %>
			<button onclick="return submitAction('poProc','<%=reqNo==null?"":reqNo %>');">Check-in</button>
			<button onclick="return submitAction('pending','<%=reqNo==null?"":reqNo %>');">Pending</button>
			<button onclick="return submitAction('menuSend','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.menuSend" /></button>			
<%}else if("Z".equals(reqStatus)){ %>
			<button onclick="return submitAction('pending','<%=reqNo==null?"":reqNo %>');">Pending</button>			
			<button onclick="return submitAction('menuSend','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.menuSend" /></button>			
<%} else if("D".equals(reqStatus)){ %>
			<button onclick="return submitAction('poProc','<%=reqNo==null?"":reqNo %>');">Check-in</button>			
			<button onclick="return submitAction('menuSend','<%=reqNo==null?"":reqNo %>');"><bean:message key="button.menuSend" /></button>
<%} else if("P".equals(reqStatus)){ %>
			<button onclick="return submitAction('pending','<%=reqNo==null?"":reqNo %>');">Pending</button>												
<%} %>
		<button onclick="return closeAction();"><bean:message key="button.close" /></button>
		</td>			
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="reqNo" />
<input type="hidden" name="budgetCode" />
<input type="hidden" name="reqStatus" />
<input type="hidden" name="folderID" value="<%=folderID==null?"":folderID %>"/>
</form>
<script language="javascript">
	$(document).ready(function() {
		window.opener.refresh();
	});

	function closeAction() {
		window.close();
	}
	
	function submitAction(cmd,reqNo) {		
		if(cmd=='poProc'){
			document.form1.command.value = cmd;
			document.form1.reqNo.value = reqNo;						
			document.form1.submit();
			return false;	
		}else if((cmd=='menuSend')){
			document.form1.command.value = cmd;
			document.form1.reqNo.value = reqNo;						
			document.form1.submit();
			return false;	
		}else{
			if(cmd=='create'){
				var chk = checkRowValue();
				if(chk<0){
					return false;
				}else if (chk==0){
					alert('Please input PO information');
					return false;
				}			
			}
	
			var r=confirm("Confirm to submit?");
			if (r==true){
				document.form1.command.value = cmd;
				document.form1.reqNo.value = reqNo;			
				var abc = checkRowCnt();		
				document.form1.lstRowIdx.value = abc;	
				document.form1.submit();
				window.opener.refresh();
				return false;	
			 }else{
				 return false;	
			 }					
		}		  
	}

	function removeDocument(mid,did) {
		var r=confirm("Confirm to remove attachment?");
		if (r==true){
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
		 }else{
			 return false;	
		 }
	}

	function getApproveList(inputObj) {
		var did = inputObj.value;

		$.ajax({
			type: "POST",
			url: "../ui/approvalIDCMB.jsp",
			data: "reqStatus=" + did + "&category=epo",
			success: function(values){
				if(values != '') {
					$("#showStaffID_indicator").html("<select name='sendAppTo'>" + values + "</select>");
				}//if
			}//success
		});//$.ajax
	}			
</script>
</div>
</div></div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>