<%@ page language="java"  pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.io.*"%>
<%!
	public String showFile(File f, String dirName,String fileName){
		
			StringBuffer outputUrl = new StringBuffer();
			outputUrl.append("<ul>");
			if(!f.isDirectory()){
				outputUrl.append("<li><a href=\"../documentManage/download.jsp?rootFolder="+dirName+"&locationPath=\\"+fileName+"\" target=\"_blank\"><H1 id=\"TS\">"+fileName+"</H1></a>");
				outputUrl.append("</li>");
			}else{
				outputUrl.append("<li><H1 id=\"TS\">"+fileName+"</H1>");
				outputUrl.append(showDirectory(f,dirName+"\\"+fileName));
				outputUrl.append("</li>");
			}
			outputUrl.append("</ul>");
			return outputUrl.toString();
	}

	public String showDirectory(File f1,String dirName){
		StringBuffer outputUrl = new StringBuffer();
		String s[] = f1.list();
		outputUrl.append("<ul class=\"tree\">");
		
		for (int i=s.length-1; i >= 0; i--) {
			File file = new File(dirName + "/" + s[i]);
			if (!file.isHidden()) {
				if(!file.isDirectory()){
					outputUrl.append("<li>");
					outputUrl.append("<a href=\"../documentManage/download.jsp?rootFolder="+dirName+"&locationPath=\\"+s[i]+"\" target=\"_blank\"><H1 id=\"TS\">"+s[i]+"</H1></a>");
					outputUrl.append("</li>");
				}else{
					outputUrl.append("<li><details><summary><H1 style=\"color: black;\" id=\"TS\">"+s[i]+"</H1></summary>");
					outputUrl.append(showDirectory(file,dirName+"\\"+s[i]));
					outputUrl.append("</details></li>");
				}
				System.out.println(dirName+"/"+s[i]);
			}
		}
		outputUrl.append("</ul>");
		return outputUrl.toString();
	}
%>
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
String ctsNo = ParserUtil.getParameter(request, "ctsNo");
String docCode = ParserUtil.getParameter(request, "docCode");
String siteCode = ParserUtil.getParameter(request, "siteCode");
boolean validStatus = false;
if (siteCode == null || "".equals(siteCode)) {
	siteCode = ConstantsServerSide.SITE_CODE;
}

String role = ParserUtil.getParameter(request, "role");
String folderId = CTS.getFolderId(ctsNo);
String docSignLink = "&#92;&#92;160.100.1.10&#92;Signature&#92;"+docCode+".jpg";
String ctsStatus = null;

if (fileUpload) {
	String[] fileList = (String[]) request.getAttribute("filelist");

	if (fileList != null) {
		if (folderId == null || folderId.length() == 0) {
			folderId = CTS.getFolderId(ctsNo);
		}

		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("CTS");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(folderId);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("upload");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("CTS");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(folderId);
		String webUrl = tempStrBuffer.toString();

		for (int i = 0; i < fileList.length; i++) {
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + fileList[i]
			);
			DocumentDB.add(userBean, "cts", folderId, webUrl, fileList[i]);
		}
	}
}
String command = ParserUtil.getParameter(request, "command");
String docfName = ParserUtil.getParameter(request, "docfName");
String docgName = ParserUtil.getParameter(request, "docgName");
String doccName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "doccName"));
String docSex = ParserUtil.getParameter(request, "docSex");
String docAddr1 = ParserUtil.getParameter(request, "docAddr1");
String docAddr2 = ParserUtil.getParameter(request, "docAddr2");
String docAddr3 = ParserUtil.getParameter(request, "docAddr3");
String docAddr4 = ParserUtil.getParameter(request, "docAddr4");
String homeAddr1 = ParserUtil.getParameter(request, "homeAddr1");
String homeAddr2 = ParserUtil.getParameter(request, "homeAddr2");
String homeAddr3 = ParserUtil.getParameter(request, "homeAddr3");
String homeAddr4 = ParserUtil.getParameter(request, "homeAddr4");
String officeTel = ParserUtil.getParameter(request, "officeTel");
String officeFax = ParserUtil.getParameter(request, "officeFax");
String email = ParserUtil.getParameter(request, "email");
String pager = ParserUtil.getParameter(request, "pager");
String mobile = ParserUtil.getParameter(request, "mobile");
String homeTel = ParserUtil.getParameter(request, "homeTel");
String speciality = ParserUtil.getParameter(request, "speciality");
String specName = ParserUtil.getParameter(request, "specName");

String idNo = ParserUtil.getParameter(request, "idNo");
String healthStatus = ParserUtil.getParameter(request, "healthStatus");
String isSurgeon =  ParserUtil.getParameter(request, "isSurgeon");
String readAggr = ParserUtil.getParameter(request, "readAggr");
String insureCarr = ParserUtil.getParameter(request, "insureCarr");
String licNo = ParserUtil.getParameter(request, "licNo");
String licExpDate = ParserUtil.getParameter(request, "licExpDate");
String lnsExpDate = ParserUtil.getParameter(request, "lnsExpDate");
String insureCarrOther = ParserUtil.getParameter(request, "others");
String questId = null;
String questAns = null;
String questSupDtl = null;
String chgSpec = null;
String chgSpecUrl = null;
String ls_uptDate = null;
String ls_uptUser = userBean.getLoginID();
String formId = "F0001";
String forwardPath = null;
int questSize = CTS.getformQuest(formId,ctsNo).size();

boolean updateAction = false;
boolean submitAction = false;
boolean viewAction = false;
boolean checkAction = false;
boolean closeAction = false;
boolean updateSucc = false;

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

if ("save".equals(command)) {
	updateAction = true;
} else if ("submit".equals(command)) {
	submitAction = true;
} else if ("view".equals(command)) {
	viewAction = true;
} else if ("check".equals(command)) {
	checkAction = true;
}

String supportAnswerDetail1 = null;
String supportAnswerDetail2 = null;
String docSmtDate = CTS.getDocSmtDate(ctsNo);
String dirName = null;
String docSignature = null;
if ("twah".equals(siteCode)) {
	supportAnswerDetail1 = "09";
	supportAnswerDetail2 = "10";
	dirName = "\\\\it-fs1\\dept\\VPMA\\Credential renew document\\"+docCode+"-"+docSmtDate;
	docSignature = "\\\\it-fs1\\dept\\Hats\\DoctorSignatures";
} else {
	supportAnswerDetail1 = "08";
	supportAnswerDetail2 = "09";
	dirName = "\\\\hkim\\im\\VPMA\\Credential Renew Document\\"+docCode+"-"+docSmtDate;
	docSignature = "\\\\160.100.1.10\\Signature";
}
File f1 = new File(dirName);

try {
	if (updateAction) {
		ArrayList questList = CTS.getformQuest(formId,ctsNo);

		CTS.createFormQuestion(ctsNo);
		for (int i=0;i<questList.size();i++) {
			ReportableListObject qRow = (ReportableListObject) questList.get(i);
			questId = qRow.getValue(0);
			questAns = ParserUtil.getParameter(request, "radio" + questId);
			if (("Q00" + supportAnswerDetail2).equals(questId)) {
				questSupDtl = ParserUtil.getParameter(request, "ans" + supportAnswerDetail2);
				if ("Y".equals(questAns) || "N".equals(questAns)) {
					CTS.updatFormQuestion(ctsNo, questId, questAns, questSupDtl);
				}
			} else{
				if ("Y".equals(questAns) || "N".equals(questAns)) {
					CTS.updatFormQuestion(ctsNo, questId, questAns);
				}
			}
		}
/*
		if (!"MPS".equals(insureCarr) && !"DPS".equals(insureCarr)) {
			insureCarr = insureCarrOther;
		}
*/
		if (CTS.updateDoc(userBean, ctsNo, docfName, docgName, docSex, null, email, null, null, null, null, doccName, docAddr1, docAddr2, docAddr3, docAddr4, homeAddr1, homeAddr2, homeAddr3, homeAddr4, officeTel, officeFax, pager, mobile, homeTel, isSurgeon, null, healthStatus, insureCarr, licNo, licExpDate, lnsExpDate)) {
			updateSucc = true;
			message = "Record updated.";
//			updateAction = false;
		} else {
			errorMessage = "Record update fail.";
			updateAction = true;
		}

		ArrayList questList1 = CTS.getformQuest(formId,ctsNo);
		request.setAttribute("CTS", questList1);

		if ("admin".equals(role) && "save".equals(command)) {
			command = "check";
		}

	} else if (submitAction) {
		ArrayList questList = CTS.getformQuest(formId,ctsNo);

		CTS.createFormQuestion(ctsNo);
		for (int i=0;i<questList.size();i++) {
			ReportableListObject qRow = (ReportableListObject) questList.get(i);
			questId = qRow.getValue(0);
			questAns = ParserUtil.getParameter(request, "radio"+questId);
			if (("Q00" + supportAnswerDetail2).equals(questId)) {
				questSupDtl = ParserUtil.getParameter(request, "ans" + supportAnswerDetail2);
				if ("Y".equals(questAns) || "N".equals(questAns)) {
					CTS.updatFormQuestion(ctsNo, questId, questAns, questSupDtl);
				}
			} else{
				if ("Y".equals(questAns) || "N".equals(questAns)) {
					CTS.updatFormQuestion(ctsNo, questId, questAns);
				}
			}
		}
/*
		if (!"MPS".equals(insureCarr) && !"DPS".equals(insureCarr)) {
			insureCarr = insureCarrOther;
		}
*/
		System.err.println(new Date() + "[DEBUG]");
		System.err.println("--------------Renewal of Admission privilege (From HKAH-SR)--------------");
		System.err.println("submitAction: "+submitAction);
		System.err.println("ctsNo: "+ctsNo);
		System.err.println("ChineseName: "+doccName);
		System.err.println("-----------------------------------------------------------------------");
		if (CTS.updateDoc(userBean, ctsNo, docfName, docgName, docSex, null, email, null, null, null, null, doccName, docAddr1, docAddr2, docAddr3, docAddr4, homeAddr1, homeAddr2, homeAddr3, homeAddr4, officeTel, officeFax, pager, mobile, homeTel, isSurgeon, "R", healthStatus, insureCarr, licNo, licExpDate, lnsExpDate)) {
			updateSucc = true;
			message = "Record updated.";
			updateAction = false;
		} else {
			errorMessage = "Record update fail.";
			updateAction = true;
		}

		ArrayList questList1 = CTS.getformQuest(formId,ctsNo);
		request.setAttribute("CTS", questList1);

		ArrayList docList = CTS.getDocList(siteCode,"cts",folderId);

		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
		String submitDate = dateFormat.format(calendar.getTime());

		String filePathSrc = null;
		String folderPathSrc = null;
		String folderPathDest1 = null;
		if ("hkah".equals(siteCode)) {
			folderPathDest1 = "\\\\hkim\\im\\VPMA\\Credential Renew Document";
		} else if ("twah".equals(siteCode)) {
			folderPathDest1 = "\\\\it-fs1\\dept\\VPMA\\Credential renew document";
		} else{
			folderPathDest1 = "\\\\hkim\\im\\VPMA\\Credential Renew Document";
		}

		String folderPathDest2 = docCode+"-"+submitDate;

		boolean status;
		status = new File(folderPathDest1+File.separator+folderPathDest2).mkdir();

		if (status) {

			for (int i = 0; i < docList.size(); i++) {
				ReportableListObject row = (ReportableListObject) docList.get(i);
				folderPathSrc = row.getValue(1);
				filePathSrc = row.getValue(2);

				StringBuffer docStrBuffer = new StringBuffer();
				docStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
				docStrBuffer.append(File.separator);
				docStrBuffer.append("CTS");
				docStrBuffer.append(File.separator);
				docStrBuffer.append(folderId);
				docStrBuffer.append(File.separator);
				folderPathSrc = docStrBuffer.toString();

				FileUtil.copyFile(
				folderPathSrc+filePathSrc,
				folderPathDest1+File.separator+folderPathDest2+File.separator+filePathSrc);
			}
		}

		forwardPath = "renewFormPreview.jsp?ctsNo="+ctsNo+"&command=view&siteCode="+siteCode;
	} else if (viewAction) {
		// load data from database
		if (ctsNo != null && ctsNo != null && ctsNo.length() > 0) {
			ArrayList record = CTS.getDocList(ctsNo);
			ReportableListObject row = (ReportableListObject) record.get(0);

			docCode = row.getValue(0);
			docfName = row.getValue(1);
			docgName = row.getValue(2);
			doccName = row.getValue(10);
			docAddr1 = row.getValue(11);
			docAddr2 = row.getValue(12);
			docAddr3 = row.getValue(13);
			docAddr4 = row.getValue(14);
			homeAddr1 = row.getValue(19);
			homeAddr2 = row.getValue(20);
			homeAddr3 = row.getValue(21);
			homeAddr4 = row.getValue(22);
			officeTel = row.getValue(23);
			officeFax = row.getValue(24);
			email = row.getValue(5);
			pager = row.getValue(25);
			mobile = row.getValue(26);
			homeTel = row.getValue(27);
			speciality = row.getValue(4);

			ArrayList specRecord = CTS.getSpecialty(speciality);
			if (specRecord.size() > 0) {
				ReportableListObject rowSpec = (ReportableListObject) specRecord.get(0);
				specName =rowSpec.getValue(1);
			}
			idNo = row.getValue(29);
			docSex = row.getValue(3);
			isSurgeon = row.getValue(8);
			healthStatus = row.getValue(28);
			licNo = row.getValue(31);
			licExpDate = row.getValue(32);
			insureCarr = row.getValue(33);
			lnsExpDate = row.getValue(34);

			ArrayList questList = CTS.getformQuest(formId,ctsNo);

			request.setAttribute("CTS", questList);
		}
	} else if (checkAction) {
		// load data from database
		if (ctsNo != null && ctsNo != null && ctsNo.length() > 0) {
			ArrayList record = CTS.getDocList(ctsNo);
			ReportableListObject row = (ReportableListObject) record.get(0);

			docCode = row.getValue(0);
			docfName = row.getValue(1);
			docgName = row.getValue(2);
			doccName = row.getValue(10);
			docAddr1 = row.getValue(11);
			docAddr2 = row.getValue(12);
			docAddr3 = row.getValue(13);
			docAddr4 = row.getValue(14);
			homeAddr1 = row.getValue(19);
			homeAddr2 = row.getValue(20);
			homeAddr3 = row.getValue(21);
			homeAddr4 = row.getValue(22);
			officeTel = row.getValue(23);
			officeFax = row.getValue(24);
			email = row.getValue(5);
			pager = row.getValue(25);
			mobile = row.getValue(26);
			homeTel = row.getValue(27);
			speciality = row.getValue(4);

			ArrayList specRecord = CTS.getSpecialty(speciality);
			if (specRecord.size() > 0) {
				ReportableListObject rowSpec = (ReportableListObject) specRecord.get(0);
				specName =rowSpec.getValue(1);
			}
			idNo = row.getValue(29);
			docSex = row.getValue(3);
			isSurgeon = row.getValue(8);
			healthStatus = row.getValue(28);
			licNo = row.getValue(31);
			licExpDate = row.getValue(32);
			insureCarr = row.getValue(33);
			lnsExpDate = row.getValue(34);

			ArrayList questList = CTS.getformQuest(formId,ctsNo);
			request.setAttribute("CTS", questList);
		}
	}

	ctsStatus = CTS.getRecordStatus(ctsNo);
	if ("S".equals(ctsStatus)||"X".equals(ctsStatus)||"Y".equals(ctsStatus)||"Z".equals(ctsStatus)||
			"I".equals(ctsStatus)||"L".equals(ctsStatus)||"K".equals(ctsStatus)) {
		validStatus = true;
	} else{
		validStatus = false;
	}

} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) {
	message = "";
}
errorMessage = "";
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
<%} else if (submitAction) { %>
	<script language="javascript">parent.location.href = "<%=forwardPath %>";</script>
<%} else { %>
<style>
ul,ol {
 padding-left: 30px!important;
}
</style>
<body>
<div id=indexWrapper>
<div id=mainFrame>
<div id=Frame>
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="left">
	<tr style="background-color:#FFFFFF">
<%if ("twah".equals(siteCode)) {%>
		<td align="left"><img src="../images/Horizontal_billingual_HKAH_TW.jpg" border="0" width="636" height="110" /></td>
<%} else {%>
		<td align="left"><img src="../images/Horizontal_billingual_HKAH_HK.jpg" border="0" width="648" height="110" /></td>
<%}%>
		<td align="right"><div style="color:#FFFFFF" width="528" height="110"> </div></td>
	</tr>
</table>
<%
//	String title = "function.cts.list";
	String title = "Online Renewal Application Form";
	String suffix = "_2";
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="suffix" value="<%=suffix %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="pageMap" value="N" />
</jsp:include>
<%Map<String, String> tooltipMap = new HashMap<String, String>();
tooltipMap.put("saveBtn", "Click 'Save' to save your changes.");
tooltipMap.put("uploadBtn", "File can view after click the upload button.");
tooltipMap.put("submitBtn", "Click 'Submit' to confirm your renewal application, no changes are allowed after submission.");
%>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" id="form1" enctype="multipart/form-data" action="renewForm.jsp" method="post">
<bean:define id="functionLabel"><bean:message key="function.cts.list" /></bean:define>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0" width="100%">
	<tr class="smallText">
		<td class="infoData2" colspan=6>
			<b><font style="font-size: 11pt;" size="2">This form is intended to update your file so that it will reflect your current status in the next 3 years until further notification made from you in the future.</font></b></br>
			&nbsp;</br>
<%if ("twah".equals(siteCode)) {%>
			<ol>
			<li>Please verify and update the below information if needed</li>
			<li>Fields marked with an (*) are required</li>
			<li>Please attach:</li>
				<ol type="a">
				<li><b>your recent photo;</b></li>
				<li><b>current annual practicing certificate;</b></li>
				<li><b>Medical Professional Indemnity insurance certificate (MPS certificate with receipt);</b></li>
				<li><b>Conscious Sedation (Please provide certificate if you need to apply)</b></li>
				<li><b>supporting certificates for any changes or additions in your privileges of practice.</b></li>
				<li><b>Signature and Initialing Verification** (applicable to those would like to change the current verification)</b></li>
				</ol>
			<li>After you have made your changes, click "Save" or "Submit", you may save your information and submit to us later by clicking "Save"</li>
			<li>Please note after clicking "Submit" button, your information will be updated and no changes are allowed after confirmation</li>
			<li>Should you have any questions, please feel free to contact us via:</li>
			</ol>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Email: carmen.ng@twah.org.hk</br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tel: (852) 2275-6711</br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Fax: (852) 2275-6473</br>
<%} else {%>
			Should you have any questions, please feel free to contact us via:</br>
			Email: medicalaffairs@hkah.org.hk</br>
			Tel: (852) 2835-0581</br>
<%}%>
		</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0 " width="100%">
	<tr class="smallText">
		<td class="infoCenterLabel" width="15%" colspan=7 align="center"><font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform2" /></font></br>Please verify and update the below information if needed. Fields marked with an (*) are required.</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.docPhyCode" /></td>
		<td class="infoData2" width="45%" colspan=3><%=docCode==null?"":docCode %></td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.docIdNO" /></td>
		<td class="infoData2" width="15%"><%=idNo==null?"":idNo %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><font size="4">*</font><bean:message key="prompt.docfName" /></td>
		<td class="infoData2" width="15%">
		<%if (viewAction||updateAction) { %>
			<input type="text" name="docfName" value="<%=docfName==null?"":docfName %>" maxlength="20" size="20"/>
		<%} else { %>
			<input type="text" name="docfName" value="<%=docfName==null?"":docfName %>" maxlength="20" size="20" readonly/>
		<%} %>
		</td>
		<td class="infoLabel" width="15%"><font size="4">*</font><bean:message key="prompt.docgName" /></td>
		<td class="infoData2" width="15%">
		<%if (viewAction||updateAction) { %>
			<input type="text" name="docgName" value="<%=docgName==null?"":docgName %>" maxlength="20" size="20"/>
		<%} else { %>
			<input type="text" name="docgName" value="<%=docgName==null?"":docgName %>" maxlength="20" size="20" readonly/>
		<%} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.doccName" /></td>
		<td class="infoData2" width="15%">
		<%if (viewAction||updateAction) { %>
			<input type="text" name="doccName" value="<%=doccName==null?"":doccName %>" maxlength="15" size="20"/>
		<%} else { %>
			<input type="text" name="doccName" value="<%=doccName==null?"":doccName %>" maxlength="15" size="20" readonly/>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><font size="4">*</font><bean:message key="prompt.docOfficeTel" /></td>
		<td class="infoData2" width="15%">
		<%if (viewAction||updateAction) { %>
			<input type="text" name="officeTel" value="<%=officeTel==null?"":officeTel %>" maxlength="20" size="20"/>
		<%} else { %>
			<input type="text" name="officeTel" value="<%=officeTel==null?"":officeTel %>" maxlength="20" size="20" readonly/>
		<%} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.docOfficeFax" /></td>
		<td class="infoData2" width="15%">
		<%if (viewAction||updateAction) { %>
			<input type="text" name="officeFax" value="<%=officeFax==null?"":officeFax %>" maxlength="20" size="20" />
		<%} else { %>
			<input type="text" name="officeFax" value="<%=officeFax==null?"":officeFax %>" maxlength="20" size="20" readonly/>
		<%} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.docEmail" /></td>
		<td class="infoData2" width="25%">
		<%if (viewAction||updateAction) { %>
			<input type="text" name="email" value="<%=email==null?"":email %>" maxlength="70" size="50"/>
		<%} else { %>
			<input type="text" name="email" value="<%=email==null?"":email %>" maxlength="70" size="50" readonly/>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.docPager" /></td>
		<td class="infoData2" width="15%">
		<%if (viewAction||updateAction) { %>
			<input type="text" name="pager" value="<%=pager==null?"":pager %>" maxlength="20" size="20"/>
		<%} else { %>
			<input type="text" name="pager" value="<%=pager==null?"":pager %>" maxlength="20" size="20" readonly/>
		<%} %>
		</td>
		<td class="infoLabel" width="15%"><font size="4">*</font><bean:message key="prompt.docMobile" /></td>
		<td class="infoData2" width="15%">
		<%if (viewAction||updateAction) { %>
			<input type="text" name="mobile" value="<%=mobile==null?"":mobile %>" maxlength="20" size="20"/>
		<%} else { %>
			<input type="text" name="mobile" value="<%=mobile==null?"":mobile %>" maxlength="20" size="20" readonly/>
		<%} %>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.docHomeTel" /></td>
		<td class="infoData2" width="25%">
		<%if (viewAction||updateAction) { %>
			<input type="text" name="homeTel" value="<%=homeTel==null?"":homeTel %>" maxlength="20" size="20"/>
		<%} else { %>
			<input type="text" name="homeTel" value="<%=homeTel==null?"":homeTel %>" maxlength="20" size="20" readonly/>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%" rowspan=4><font size="4">*</font><bean:message key="prompt.docCorrAddr" /></td>
		<td class="infoData2" width="45%" colspan=3>
		<%if (viewAction||updateAction) { %>
			<input type="text" name="docAddr1" value="<%=docAddr1==null?"":docAddr1 %>" maxlength="40" size="60"/>
		<%} else { %>
			<input type="text" name="docAddr1" value="<%=docAddr1==null?"":docAddr1 %>" maxlength="40" size="60" readonly/>
		<%} %>
		</td>
		<td class="infoLabel" width="15%" rowspan=4><font size="4">*</font><bean:message key="prompt.docHomeAddr" /></td>
		<td class="infoData2" width="25%">
		<%if (viewAction||updateAction) { %>
			<input type="text" name="homeAddr1" value="<%=homeAddr1==null?"":homeAddr1 %>" maxlength="40" size="50"/>
		<%} else { %>
			<input type="text" name="homeAddr1" value="<%=homeAddr1==null?"":homeAddr1 %>" maxlength="40" size="50" readonly/>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoData2" width="45%" colspan=3>
		<%if (viewAction||updateAction) { %>
			<input type="text" name="docAddr2" value="<%=docAddr2==null?"":docAddr2 %>" maxlength="40" size="60"/>
		<%} else { %>
			<input type="text" name="docAddr2" value="<%=docAddr2==null?"":docAddr2 %>" maxlength="40" size="60" readonly/>
		<%} %>
		</td>
		<td class="infoData2" width="25%">
		<%if (viewAction||updateAction) { %>
			<input type="text" name="homeAddr2" value="<%=homeAddr2==null?"":homeAddr2 %>" maxlength="40" size="50"/>
		<%} else { %>
			<input type="text" name="homeAddr2" value="<%=homeAddr2==null?"":homeAddr2 %>" maxlength="40" size="50" readonly/>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoData2" width="45%" colspan=3>
		<%if (viewAction||updateAction) { %>
			<input type="text" name="docAddr3" value="<%=docAddr3==null?"":docAddr3 %>" maxlength="40" size="60"/>
		<%} else { %>
			<input type="text" name="docAddr3" value="<%=docAddr3==null?"":docAddr3 %>" maxlength="40" size="60" readonly/>
		<%} %>
		</td>
		<td class="infoData2" width="25%">
		<%if (viewAction||updateAction) { %>
			<input type="text" name="homeAddr3" value="<%=homeAddr3==null?"":homeAddr3 %>" maxlength="40" size="50"/>
		<%} else { %>
			<input type="text" name="homeAddr3" value="<%=homeAddr3==null?"":homeAddr3 %>" maxlength="40" size="50" readonly/>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoData2" width="45%" colspan=3>
		<%if (viewAction||updateAction) { %>
			<input type="text" name="docAddr4" value="<%=docAddr4==null?"":docAddr4 %>" maxlength="40" size="60"/>
		<%} else { %>
			<input type="text" name="docAddr4" value="<%=docAddr4==null?"":docAddr4 %>" maxlength="40" size="60" readonly/>
		<%} %>
		</td>
		<td class="infoData2" width="25%" >
		<%if (viewAction||updateAction) { %>
			<input type="text" name="homeAddr4" value="<%=homeAddr4==null?"":homeAddr4 %>" maxlength="40" size="50"/>
		<%} else { %>
			<input type="text" name="homeAddr4" value="<%=homeAddr4==null?"":homeAddr4 %>" maxlength="40" size="50" readonly/>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.specialty" /></td>
		<td class="infoData2" width="45%" colspan="6">
			<%=specName==null?"":specName %>
			<br><br><font style="font-size: 10pt;"><i>Any Changes Requested? If YES, attach documentation of training or experience</i></font>
		</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0" width="100%">
	<tr class="smallText">
		<td class="infoCenterLabel" align="center"><font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform4" /></font></br>&nbsp</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0" width="100%">
	<tr><td>
	<display:table id="row" name="requestScope.CTS" export="false">
		<display:column property="fields1" title="&nbsp;" style="width:72%" />
		<display:setProperty name="basic.show.header" value="false" />
		<display:column title="&nbsp;" style="width:27%" >
			<logic:equal name="row" property="fields2" value="Y">
			<%if (viewAction||updateAction||checkAction) {%>
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radio<c:out value="${row.fields0}" />" value="Y" checked="checked" onclick="return showAnswerField9(this)">Yes</input>
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radio<c:out value="${row.fields0}" />" value="N" onclick="return showAnswerField9(this)">No</input>
			<%} else{ %>
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radio<c:out value="${row.fields0}" />" value="Y" checked="checked" disabled="disabled">Yes</input>
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radio<c:out value="${row.fields0}" />" value="N" disabled="disabled">No</input>
			<%} %>
			</logic:equal>
			<logic:equal name="row" property="fields2" value="N">
			<%if (viewAction||updateAction||checkAction) {%>
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radio<c:out value="${row.fields0}" />" value="Y" onclick="return showAnswerField9(this)">Yes</input>
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radio<c:out value="${row.fields0}" />" value="N" checked="checked" onclick="return showAnswerField9(this)">No</input>
			<%} else{ %>
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radio<c:out value="${row.fields0}" />" value="Y" disabled="disabled">Yes</input>
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radio<c:out value="${row.fields0}" />" value="N" checked="checked" disabled="disabled">No</input>
			<%} %>
			</logic:equal>
			<logic:equal name="row" property="fields2" value="0">
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radio<c:out value="${row.fields0}" />" value="Y" onclick="return showAnswerField9(this)">Yes</input>
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radio<c:out value="${row.fields0}" />" value="N" onclick="return showAnswerField9(this)">No</input>
			</logic:equal>
			<logic:equal name="row" property="fields2" value="">
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radio<c:out value="${row.fields0}" />" value="Y" onclick="return showAnswerField9(this)">Yes</input>
				&nbsp;&nbsp;&nbsp;
				<input type="radio" name="radio<c:out value="${row.fields0}" />" value="N" onclick="return showAnswerField9(this)">No</input>
			</logic:equal>
		</display:column>
		<display:column title="&nbsp;" style="width:1%" sortable="false" >
			<input type="hidden" name="supDtl<c:out value="${row.fields0}" />" value="${requestScope.CTS[row_rowNum - 1].fields3}" />
		</display:column>
	</display:table>
	</td></tr>
	<tr>
		<td><span id="show_answerField"></span></td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0 " width="100%">
	<tr class="smallText">
		<td class="infoCenterLabel" align="centre"><font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform5" /></font></br>&nbsp</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0" width="100%">
	<tr class="smallText">
		<td class="infoData2">
			<b>Personal Health Status (Including Alcohol & Drug Dependence)</b>
			<br/><br><font style="font-size: 10pt;"><i>Please declare whether you are having any medical and/or mental condition that may affect in any way your practice of medicine in the Hospital (use separate sheet if necessary).</i></font>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoData2">
		<%if (healthStatus != null && healthStatus.length() > 0) { %>
			<%if (viewAction || updateAction || checkAction) { %>
				<input type=radio name="radioStatus" value="Y" id="radioStatus" checked="checked"/>
			<%} else{ %>
				<input type=radio name="radioStatus" value="Y" id="radioStatus" checked="checked" disabled="disabled"/>
			<%} %>
		<%} else { %>
			<%if (viewAction || updateAction || checkAction) { %>
				<input type=radio name="radioStatus" value="N" id="radioStatus" />
			<%} else{ %>
				<input type=radio name="radioStatus" value="N" id="radioStatus" disabled="disabled"/>
			<%} %>
		<% } %>
			<label for="radioStatus"><bean:message key="label.yes" /></label>
			<%if (viewAction||updateAction||checkAction) { %>
				<textarea class="infoLabe2" name="healthStatus" rows="5" cols="200" align="left"><%=healthStatus==null||"".equals(healthStatus)?"":healthStatus %></textarea><br/>
			<%} else{ %>
				<textarea class="infoLabe2" name="healthStatus" rows="5" cols="200" align="left" readonly="readonly"><%=healthStatus==null?"":healthStatus %></textarea><br/>
			<%} %>
		<%if (healthStatus != null && healthStatus.length() > 0) { %>
			<%if (viewAction || updateAction || checkAction) { %>
				<input type=radio name="radioStatus" value="Y" id="radioStatus"/>
			<%} else{ %>
				<input type=radio name="radioStatus" value="Y" id="radioStatus" disabled="disabled"/>
			<%} %>
		<%} else { %>
			<%if (viewAction||updateAction||checkAction) { %>
				<input type=radio name="radioStatus" value="N" id="radioStatus" checked="checked" />
			<%} else{ %>
				<input type=radio name="radioStatus" value="N" id="radioStatus" checked="checked" disabled="disabled"/>
			<%} %>
		<% } %>
			<label for="radioStatus"><bean:message key="label.no" /> / Nothing to declare</label>
			<br/><br><font style="font-size: 10pt;"><i>(* If you have any thing to declare to the Hospital Administration about your medical/mental condition, you can consider keeping it confidential and put it into an sealed envelope.)</i></font>
		</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0 " width="100%">
	<tr class="smallText">
		<td class="infoCenterLabel" width="15%" colspan=2><font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform12" /></font></br>&nbsp</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0" width="100%">
	<tr class="smallText">
		<td class="infoLabel" width="30%" rowspan="2"><bean:message key="prompt.HKMC" /></td>
		<td class="infoData" width="35%">
			<input type="text" name="licNo" value="<%=licNo==null?"":licNo %>" maxlength="30" size="50"/>
		</td>
		<td class="infoData" width="35%">
			<input type="text" name="licExpDate" id="licExpDate" class="datepickerfield" value="<%=licExpDate==null?"":licExpDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/>
		</td>
	</tr>
	<tr class="smallText">
		<td align="left"><bean:message key="prompt.licNo" /></td>
		<td align="left"><bean:message key="prompt.expiryDateDmy" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%" rowspan="2"><bean:message key="prompt.MICD" /></td>
		<td class="infoData" width="35%">
		<input type="text" name="insureCarr" value="<%=insureCarr==null?"":insureCarr %>" maxlength="30" size="50"/>
		</td>
		<td class="infoData" width="35%">
			<input type="text" name="lnsExpDate" id="lnsExpDate" class="datepickerfield" value="<%=lnsExpDate==null?"":lnsExpDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/>
		</td>
	</tr>
	<tr>
		<td align="left"></td>
		<td align="left"><bean:message key="prompt.expiryDateDmy" /></td>
	</tr>
	<tr>
		<td></td>
		<td><span id="show_inputField"></span></td>
		<td></td>
	</tr>
</table>
<%if (!checkAction) {%>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0 " width="100%">
	<tr class="smallText">
		<td class="infoCenterLabel" width="15%" colspan=2><font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform6" /></br>&nbsp</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0 " width="100%">
<%if ("twah".equals(siteCode)) {%>
	<tr class="smallText">
		<td class="infoData2" width="100%">
			<br/><font style="font-size: 10pt;"><i><b>Attach supporting documents</b><br/>
			&nbsp;<br/>
				<ol type="a">
				<li><b>your recent photo;</b></li>
				<li><b>current annual practicing certificate;</b></li>
				<li><b>Medical Professional Indemnity insurance certificate (MPS certificate with receipt);</b></li>
				<li><b>Conscious Sedation (Please provide certificate if you need to apply)</b></li>
				<li><b>supporting certificates for any changes or additions in your privileges of practice.</b></li>
				<li><b>Signature and Initialing Verification** (applicable to those would like to change the current verification)</b></li>
				</ol>
			</i></font>
		</td>
	</tr>
<%} else {%>
	<tr class="smallText">
		<td class="infoData2" width="100%">
			<br><font style="font-size: 10pt;"><i><b>Download supplementary documents</b><br/>
			&nbsp;<br/>
			1.MPS Pre-Authorization Release Form<br/>
			2.Signature and Initialing Verification (applicable to those has not signed yet and those would like to change the current verification shown below)<br/>
			</i></font>
		</td>
	</tr>
	<tr class="smallText">
		<td width="100%"><b>Click <button onClick="openAction();"><bean:message key="button.here" /></button> to download forms, please sign and attach to below</b></td>
	</tr>
	<tr class="smallText">
		<td class="infoData2" width="100%">
			<br><font style="font-size: 10pt;"><i><b>Attach supporting documents</b><br/>
			&nbsp;<br/>
			(a) Update Curriculum Vitae (C.V.)<br/>
			(b) Copy of current medical professional indemnity insurance certificate<br/>
			(c) Copy of current Annual Practising Certificate<br/>
			(d) Signed The Medical Protection Society Limited (MPS) Pre-Authorization Release Form ** <i>(if applicable)</i><br/>
			(e) Signature and Initialing Verification ** <i>(applicable to those would like to change the current verification)</i><br/>
			(f) Recent Photo (if any)<br/>
			(g) Other additional document(s) if any (e.g. further training certificate)<br/>
			</i></font>
		</td>
	</tr>
<% }%>
</table>
<%} %>
<hr noshade="noshade"/>
<%if ("admin".equals(role) || "view".equals(command) || "save".equals(command)) { %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0 " width="100%">
	<tr class="smallText">
		<td><b>Attach documents from below</b></td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr><td>
		<span id="showDocument_indicator">
<%String keyId = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="cts" />
	<jsp:param name="keyID" value="<%=keyId %>" />
	<jsp:param name="allowRemove" value="Y" />
</jsp:include>
		</span>
		<input type="file" name="file1" size="50" class="multi" maxlength="10"/>
		</td>
	</tr>
	<tr><td>
<%if ("view".equals(command)) { %>
		<%if (validStatus) { %>
			<button title="<%=tooltipMap.get("uploadBtn") %>" onclick="return submitAction('save','<%=ctsNo %>');"><bean:message key="prompt.uploadFile" /></button>
		<%} else{ %>
			<button title="<%=tooltipMap.get("uploadBtn") %>" onclick="return submitAction('save','<%=ctsNo %>');" disabled><bean:message key="prompt.uploadFile" /></button>
		<%} %>
<%} else if ("save".equals(command)) { %>
			<button title="<%=tooltipMap.get("uploadBtn") %>" onclick="return submitAction('save','<%=ctsNo %>');"><bean:message key="prompt.uploadFile" /></button>
<%} %>
		</td>
	</tr>
</table>
<%} %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0 " width="100%">
	<tr class="smallText">
		<td class="infoCenterLabel" width="15%" colspan=2><font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform10" /></br>&nbsp</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0 " width="100%">
	<tr class="smallText">
		<td><b>Current record in our system</b></td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td><img src="<%=docSignature %>\<%=docCode%>.jpg" alt="doc sign" width="200" height="200" onError="this.src='../images/Poster_not_available.jpg';" /></td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0 " width="100%">
	<tr class="smallText">
		<td class="infoCenterLabel" width="15%" colspan=2><font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform7" /></br>&nbsp</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoData2"><font style="font-size: 10pt;" size="3"><i>
			I fully understand that any significant mis-statements in or omissions from this application constitute cause
			for denial of appointment or cause for summary dismissal from the medical/dental staff.
			All information submitted by me in this application is true to my best knowledge and belief.<br>
			<br>In making this application for reappointment to the medical/dental staff of this hospital,
			I acknowledge that I have received and read the by-laws, rules and regulations of the medical staff of this hospital, and code of practice of the Private Hospitals Association (PHA).
			I further agree to abide by such hospital and staff rules and regulations and code of practice of PHA as may be from time to time enacted. Failure to follow the rules and regulations and code of practice may jeopardize my admitting privileges.<br>
			<br>I understand and agree that I, as an applicant for medical/dental staff membership, have the burden of producing adequate information for proper evaluation of my professional competence, character, ethics and other qualifications and for resolving any doubts about such qualifications.<br>
<%if ("twah".equals(siteCode)) {%>
			<br>**Please send copy of annual license to practice in Hong Kong and current valid Malpractice Insurance Certificate with receipt.<br>
<%} %>
			</i></font>
		</td>
	</tr>
	<tr>
		<td bgcolor="#CCCCFF" align="center">
			<%if (checkAction) {%>
				<input type=checkbox name="acceptAgr" value="" checked="checked" disabled="disabled"/>
			<%} else { %>
				<%if ("Y".equals(readAggr)) {%>
					<input type=checkbox name="acceptAgr" value="" checked="checked"/>
				<%} else{ %>
					<input type=checkbox name="acceptAgr" value=""/>
				<%} %>
			<%} %>
			&nbsp;<b>* I hereby accept the above statement of agreement.</b>
		</td>
	</tr>
</table>
<%if ("hkah".equals(siteCode)) {%>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0 " width="100%">
	<tr class="smallText">
		<td class="infoCenterLabel" width="15%" colspan=7 align="center"><font style="font-size: 14pt;" size="2">SUBMIT RENEWAL APPLICATION</font></br>&nbsp</br>
		<font style="font-size: 11pt;" size="1">Click "Save" button to save your updates and make changes later.</font></br>
		<font style="font-size: 11pt;" size="1">Click "Submit" button to confirm information. No changes are allowed after confirmation.</font></br>
	</tr>
</table>
<%}%>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0" align="center" width="100%">
	<tr class="smallText">
		<td align="center">
<%if ("view".equals(command)) { %>
		<%if (validStatus) { %>
			<button title="<%=tooltipMap.get("saveBtn") %>" onclick="return submitAction('save','<%=ctsNo %>');"><bean:message key="button.save" /></button>
			<button title="<%=tooltipMap.get("submitBtn") %>" onclick="return submitAction('submit','<%=ctsNo %>');"><bean:message key="button.submit" /></button>
		<%} else{ %>
			<button title="<%=tooltipMap.get("saveBtn") %>" onclick="return submitAction('save','<%=ctsNo %>');" disabled><bean:message key="button.save" /></button>
			<button title="<%=tooltipMap.get("submitBtn") %>" onclick="return submitAction('submit','<%=ctsNo %>');" disabled><bean:message key="button.submit" /></button>
		<%} %>
<%} else if ("save".equals(command)) { %>
			<button title="<%=tooltipMap.get("saveBtn") %>" onclick="return submitAction('save','<%=ctsNo %>');"><bean:message key="button.save" /></button>
			<button title="<%=tooltipMap.get("submitBtn") %>" onclick="return submitAction('submit','<%=ctsNo %>');"><bean:message key="button.submit" /></button>
<%} else if ("check".equals(command) && ("admin".equals(role) || "approver".equals(role))) { %>
			<button title="<%=tooltipMap.get("saveBtn") %>" onclick="return submitAction('save','<%=ctsNo %>');"><bean:message key="button.save" /></button>
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>
<%} else{ %>
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>
<%} %>
		</td>
	</tr>
</table>
<%
if ("admin".equals(role) || "approver".equals(role)) {
	if (f1.isDirectory()) {
		String s[] = f1.list();
%>
<hr noshade="noshade"/>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0 " width="100%">
	<tr class="smallText">
		<td class="infoLabe2" width="15%" colspan=2><font style="font-size: 11pt;" size="2"><bean:message key="prompt.renewform11" /> (<%=f1 %>)</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="0" border="0">
	<%=showDirectory(f1,dirName)%>
</table>
<%
	} else {
		System.out.println(dirName + " is not a directory");
	}
}
%>
<!--<li><a href="../documentManage/download.jsp?rootFolder=\\hkim\im\VPMA\Credential Renew Document" target="_blank"><H1 id="TS">dd</H1></a></li>-->

<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0 " width="100%">
	<tr class="smallText">
<%if ("twah".equals(siteCode)) { %>
		<td align="right">Revised July 2020</td>
<%} else { %>
		<td align="right">Revised May 2021</td>
<%} %>
	</tr>
</table>
<input type="hidden" name="command" value="<%=command %>"/>
<input type="hidden" name="role" value="<%=role %>"/>
<input type="hidden" name="ctsNo" value="<%=ctsNo %>"/>
<input type="hidden" name="idNo" value="<%=idNo %>"/>
<input type="hidden" name="docCode" value="<%=docCode %>"/>
<input type="hidden" name="docSex" value="<%=docSex %>"/>
<input type="hidden" name="isSurgeon" value="<%=isSurgeon %>"/>
<input type="hidden" name="formId" value="<%=formId %>"/>
<input type="hidden" name="folderId" value="<%=folderId %>"/>
<input type="hidden" name="specName" value="<%=specName %>"/>
<input type="hidden" name="speciality" value="<%=speciality %>"/>
<input type="hidden" name="readAggr" value="<%=readAggr %>"/>
</form>

<script language="javascript">
	$(document).ready(function() {
//		showInputField(document.form1.insureCarr);
		if (document.getElementsByName("radioQ00<%=supportAnswerDetail2 %>")[0]) {
			showAnswerField9(document.getElementsByName("radioQ00<%=supportAnswerDetail2 %>")[0]);
			if (document.getElementsByName("radioQ00<%=supportAnswerDetail2 %>")[0]=='Y') {
				document.form1.ans<%=supportAnswerDetail2 %>.value = document.getElementsByName("supDtlQ00<%=supportAnswerDetail2 %>")[0].value;
			}

		}

		$('th.header').unbind('click');
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


	function closeAction() {
		window.close();
	}

	function openAction() {
			window.open("/upload/CTS/download/Combine%20form%20for%20cts.pdf","_blank");
		return false;
	}

	function questCheck() {
		var table = document.getElementById('row');
		var RowCnt = table.rows.length;

		if (RowCnt > 0) {
			for(var i = 1 ; i<RowCnt; i++) {
				if (document.getElementsByName("radioQ000" + i)[0]) {
					if (!document.getElementsByName("radioQ000" + i)[0].checked && !document.getElementsByName("radioQ000" + i)[1].checked) {
						alert('Please select answer');
						document.getElementsByName("radioQ000" + i)[1].focus();
						return false;
					}
				}
			}
		}

		if (document.getElementsByName("radioQ00<%=supportAnswerDetail2 %>")[0].value=='Y' &&
		   document.getElementsByName("radioQ00<%=supportAnswerDetail2 %>")[0].checked) {
			if (document.form1.ans<%=supportAnswerDetail2 %>.value == '') {
<%if ("twah".equals(siteCode)) { %>
				alert('Please enter reason for Question J');
<%} else { %>
				alert('Please enter reason for Question I');
<%} %>
				document.form1.ans<%=supportAnswerDetail2 %>.focus();
				return false;
			}
		}
	}

	function submitAction(cmd,ctsno) {
		if (document.form1.docfName.value == '') {
			alert('Please enter family name');
			document.form1.docfName.focus();
			return false;
		}
		if (document.form1.docgName.value == '') {
			alert('Please enter given name');
			document.form1.docgName.focus();
			return false;
		}
		if (document.form1.officeTel.value == '') {
			alert('Please enter office telephone NO.');
			document.form1.officeTel.focus();
			return false;
		}
		if (document.form1.mobile.value == '') {
			alert('Please enter mobile NO.');
			document.form1.mobile.focus();
			return false;
		}
		if (document.form1.docAddr1.value == '') {
			alert('Please enter correspondence address');
			document.form1.docAddr1.focus();
			return false;
		}
		if (document.form1.homeAddr1.value == '') {
			alert('Please enter home address');
			document.form1.homeAddr1.focus();
			return false;
		}

		if (cmd=='submit') {
			var radioObj = document.forms["form1"].elements["radioStatus"];

			if (radioObj) {
				if (radioObj[0].checked) {
					if (document.form1.healthStatus.value == '') {
						alert('Please specify health status.');
						document.form1.healthStatus.focus();
						return false;
					};
				} else{
					if (document.form1.healthStatus.value=='If yes, please specify') {
						document.form1.healthStatus.value = '';
					}
				};
			}

			if (document.form1.licNo.value == '') {
				alert('Please enter Hong Kong Medical Council License NO.');
				document.form1.licNo.focus();
				return false;
			}
			if (document.form1.licExpDate.value == '') {
				alert('Please enter Hong Kong Medical Council Expiry Data');
				document.form1.licExpDate.focus();
				return false;
			} else{
				if (!validDate(document.form1.licExpDate)) {
					alert('Invalid Date. (Format:DD/MM/YYYY)');

					return false;
				}
			}
			if (document.form1.insureCarr.value == '') {
				alert('Please enter Malpractice Insurance Carrier Detail');
				document.form1.insureCarr.focus();
				return false;
//			} else{
//				document.form1.insureCarr.value = 'MPS';
			}
			if (document.form1.lnsExpDate.value == '') {
				alert('Please enter Malpractice Insurance Carrier Detail Expiry Date');
				document.form1.lnsExpDate.focus();
				return false;
			} else{
				if (!validDate(document.form1.lnsExpDate)) {
					alert('Invalid Date. (Format:DD/MM/YYYY)');

					return false;
				}
			}

			if (questCheck()==false) {return false;}

			if (document.form1.acceptAgr.checked==false) {
				alert('You must accept the statement of agreement before submission');
				document.form1.acceptAgr.focus();
				return false;
			}

			var r=confirm("Confirm to submit?");
			if (r==true) {
				document.form1.command.value = cmd;
				document.form1.submit();
				return false;
			 } else{
				 return false;
			 }
		} else if (cmd=='save') {
			document.form1.command.value = cmd;
			if (document.form1.acceptAgr.checked==true) {
				document.form1.readAggr.value = 'Y';
			}
			document.form1.submit();
		}
	}

	function removeDocument(mid,did) {
		$.ajax({
			type: "POST",
			url: "../common/document_list.jsp",
			data: "command=delete&moduleCode="+ mid +"&keyID=<%=folderId %>&documentID=" + did + "&allowRemove=Y",
			success: function(values) {
			if (values != '') {
				$("#showDocument_indicator").html(values);
			}//if
			}//success
		});//$.ajax
	}

	function showInputField(inputObj) {
		var did = inputObj.value;
		var insureCarr = '<%=insureCarr %>';

		if (did == 'O') {
			$("#show_inputField").html("<input type='text' name='others' value='"+insureCarr+"' maxlength='30' size='50'/>");
		} else{
			$("#show_inputField").html("");
		}
	}

	function showAnswerField9(inputObj) {
		var did = inputObj.value;
		var answer9 = document.getElementsByName("supDtlQ00<%=supportAnswerDetail2 %>")[0].value;

		if (inputObj.name=='radioQ00<%=supportAnswerDetail2 %>' || inputObj.name=='radioQ00<%=supportAnswerDetail1 %>') {
			if (inputObj.checked && did=='Y') {
				$("#show_answerField").html("<textarea name='ans<%=supportAnswerDetail2 %>' rows='5' cols='200' align='left' >"+answer9+"</textarea>");
			} else{
				$("#show_answerField").html("");
			}
		}
	}
</script>
</div>
</div></div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<style>
.tree{
  --spacing : 1rem;
  --radius  : 6px;
}

.tree li{
  display      : block;
  position     : relative;
  padding-left : calc(2 * var(--spacing) - var(--radius) - 2px);
}

.tree ul{
  margin-left  : calc(var(--radius) - var(--spacing));
  padding-left : 0;
}

.tree ul li{
  border-left : 2px solid #ddd;
}

.tree ul li:last-child{
  border-color : transparent;
}

.tree ul li::before{
  content      : '';
  display      : block;
  position     : absolute;
  top          : calc(var(--spacing) / -2);
  left         : -2px;
  width        : calc(var(--spacing) + 2px);
  height       : calc(var(--spacing) + 1px);
  border       : solid #ddd;
  border-width : 0 0 2px 2px;
}

.tree summary{
  display : block;
  cursor  : pointer;
}

.tree summary::marker,
.tree summary::-webkit-details-marker{
  display : none;
}

.tree summary:focus{
  outline : none;
}

.tree summary:focus-visible{
  outline : 1px dotted #000;
}

.tree li::after,
.tree summary::before{
  content       : '';
  display       : block;
  position      : absolute;
  top           : calc(var(--spacing) / 2 - var(--radius));
  left          : calc(var(--spacing) - var(--radius) - 1px);
  width         : calc(2 * var(--radius));
  height        : calc(2 * var(--radius));
  border-radius : 50%;
  background    : #ddd;
}

.tree summary::before{
  content     : '+';
  z-index     : 1;
  background  : #696;
  color       : #fff;
  line-height : calc(2 * var(--radius) - 1px);
  text-align  : center;
}

.tree details[open] > summary::before{
  content : '−';
}
</style>
<%} %>
</html:html>