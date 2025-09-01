<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.jasper.*"%>

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
String ctsNo = ParserUtil.getParameter(request, "ctsNo");	//01 CTS_NO
System.err.println("1111[command]:"+command);
boolean validStatus = false;
String mustLogin = null;
String role = ParserUtil.getParameter(request, "role");

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");
String folderId = CTS.getNewFolderId(ctsNo);
String forwardPath = null;
/*
if (fileUpload) {
	String[] fileList = (String[]) request.getAttribute("filelist");

	if (fileList != null) {
		if(folderId!=null && folderId.length()>0){
			System.err.println("[folderId]"+folderId);			
		}else{
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
*/
boolean createAction = false;
boolean submitAction = false;
boolean checkAction = false;
boolean updateSucc = false;
boolean creating = false;
boolean viewAction = false;
boolean viewRptAction = false;
boolean editAction = false;
boolean updateAction = false;
boolean closeAction = false;

if("view".equals(command)){
	viewAction = true;
}else if("update".equals(command)){
	updateAction = true;	
}else if("submit".equals(command)){
	submitAction = true;	
}		
System.err.println("2222[command]:"+command);

String ctsStatus = ParserUtil.getParameter(request, "ctsStatus");	//01 CTS_STATUS

String docfName = ParserUtil.getParameter(request, "docfName");	//02 DOCFNAME
String docgName = ParserUtil.getParameter(request, "docgName");	//03 DOCGNAME
String doccName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "doccName"));	//04 DOCCNAME
String docSex = ParserUtil.getParameter(request, "docSex");	//05 DOCSEX
String idNo = ParserUtil.getParameter(request, "idNo");	//06 DOCIDNO
String martialStatus = ParserUtil.getParameter(request, "martialStatus");	//07	DOCMSTS
String docSpCode = ParserUtil.getParameter(request, "docSpCode");	//08 SPCCODE
String docAddr1 = ParserUtil.getParameter(request, "docAddr1");	//09 DOCADD1
String docAddr2 = ParserUtil.getParameter(request, "docAddr2");	//10 DOCADD2
String docAddr3 = ParserUtil.getParameter(request, "docAddr3");	//11 DOCADD3
String docAddr4 = ParserUtil.getParameter(request, "docAddr4");	//12 DOCADD3	
String homeAddr1 = ParserUtil.getParameter(request, "homeAddr1");	//13 DOCHOMADD11
String homeAddr2 = ParserUtil.getParameter(request, "homeAddr2");	//14 DOCHOMADD12
String homeAddr3 = ParserUtil.getParameter(request, "homeAddr3");	//15 DOCHOMADD13
String homeAddr4 = ParserUtil.getParameter(request, "homeAddr4");	//16 DOCHOMADD14
String email = ParserUtil.getParameter(request, "email");	//17 DOCEMAIL
String pager = ParserUtil.getParameter(request, "pager");	//18 DOCPTEL
String mobile = ParserUtil.getParameter(request, "mobile");	//19 DOCMTEL
String homeTel = ParserUtil.getParameter(request, "homeTel");	//20 DOCHTEL
String officeTel = ParserUtil.getParameter(request, "officeTel");	//21 DOCOTEL
String officeFax = ParserUtil.getParameter(request, "officeFax");	//22 DOCFAXNO
String docAcademic1 = ParserUtil.getParameter(request, "docAcademic1");	//23 DOCACADEMIC1
String docAcademic2 = ParserUtil.getParameter(request, "docAcademic2");	//24 DOCACADEMIC2
String docDegree1 = ParserUtil.getParameter(request, "docDegree1");	//25 DOCDEGREE1
String docDegree2 = ParserUtil.getParameter(request, "docDegree2");	//26 DOCDEGREE2
String docAcademicDate1 = ParserUtil.getParameter(request, "docAcademicDate1");	//27 DOCACADEMICDATE1
String docAcademicDate2 = ParserUtil.getParameter(request, "docAcademicDate2");	//28 DOCACADEMICDATE1
String docSpecQual = ParserUtil.getParameter(request, "docSpecQual");	//29 DOCSPECQUAL
String docSpecQualSince = ParserUtil.getParameter(request, "docSpecQualSince");	//30 DOCSPECQUALSINCE
String docSpecQualHospital1= ParserUtil.getParameter(request, "docSpecQualHospital1");	//31 DOCSPECQUALHOSPITAL1
String docSpecQualHospital2= ParserUtil.getParameter(request, "docSpecQualHospital2");	//32 DOCSPECQUALHOSPITAL2
String docSpecQualDateFrom1 = ParserUtil.getParameter(request, "docSpecQualDateFrom1");	//33 DOCSPECQUALDATEFROM1
String docSpecQualDateFrom2 = ParserUtil.getParameter(request, "docSpecQualDateFrom2");	//34 DOCSPECQUALDATEFROM2
String docSpecQualDateTo1= ParserUtil.getParameter(request, "docSpecQualDateTo1");	//35 DOCSPECQUALDATETO1
String docSpecQualDateTo2= ParserUtil.getParameter(request, "docSpecQualDateTo2");	//36 DOCSPECQUALDATETO2
String medInfo= ParserUtil.getParameter(request, "medInfo"); //37 MEDINFO
String docPrevPracticeAddr1= ParserUtil.getParameter(request, "docPrevPracticeAddr1");	//38 DOCPREVPRACTICEADDR1
String docPrevPracticeAddr2= ParserUtil.getParameter(request, "docPrevPracticeAddr2");	//39 DOCPREVPRACTICEADDR2
String docPrevPracticeFrom1= ParserUtil.getParameter(request, "docPrevPracticeFrom1");	//40 DOCPREVPRACTICEFROM1
String docPrevPracticeFrom2= ParserUtil.getParameter(request, "docPrevPracticeFrom2");	//41 DOCPREVPRACTICEFROM2
String docPrevPracticeTo1= ParserUtil.getParameter(request, "docPrevPracticeTo1");	//40 DOCPREVPRACTICETO1
String docPrevPracticeTo2= ParserUtil.getParameter(request, "docPrevPracticeTo2");	//42 DOCPREVPRACTICETO2
String docMemProSoc1= ParserUtil.getParameter(request, "docMemProSoc1");	//44 DOCMEMPROSOC1
String docMemProSoc2= ParserUtil.getParameter(request, "docMemProSoc2");	//45 DOCMEMPROSOC2
String docMemProSocStatus1= ParserUtil.getParameter(request, "docMemProSocStatus1");	//46 DOCMEMPROSOCSTATUS1
String docMemProSocStatus2= ParserUtil.getParameter(request, "docMemProSocStatus2");	//47 DOCMEMPROSOCSTATUS2
String docMemProSocYear1= ParserUtil.getParameter(request, "docMemProSocYear1");	//48 DOCMEMPROSOCYEAR1 
String docMemProSocYear2= ParserUtil.getParameter(request, "docMemProSocYear2");	//49 DOCMEMPROSOCYEAR2
String docAcademyOfMed1= ParserUtil.getParameter(request, "docAcademyOfMed1");	//50 DOCACADEMYOFMED1
String docAcademyOfMed2= ParserUtil.getParameter(request, "docAcademyOfMed2");	//51 DOCACADEMYOFMED2
String docAcademyOfMedStatus1= ParserUtil.getParameter(request, "docAcademyOfMedStatus1"); //22 DOCACADEMYOFMEDSTATUS1
String docAcademyOfMedStatus2= ParserUtil.getParameter(request, "docAcademyOfMedStatus2"); //53 DOCACADEMYOFMEDSTATUS2
String docAcademyOfMedYear1= ParserUtil.getParameter(request, "docAcademyOfMedYear1");	//54 DOCACADEMYOFMEDYEAR1
String docAcademyOfMedYear2= ParserUtil.getParameter(request, "docAcademyOfMedYear2");	//55 DOCACADEMYOFMEDYEAR2
String docLicNo1= ParserUtil.getParameter(request, "docLicNo1");	//56 DOCLICNO1
String docLicNo2= ParserUtil.getParameter(request, "docLicNo2");	//57 DOCLICNO2
//String docHealthStatus1= ParserUtil.getParameter(request, "docHealthStatus1");
//String docHealthStatus2= ParserUtil.getParameter(request, "docHealthStatus2");
String docLicExpdate1= ParserUtil.getParameter(request, "docLicExpdate1");	//58 DOCLICEXPDATE1
String docLicExpdate2= ParserUtil.getParameter(request, "docLicExpdate2");	//59 DOCLICEXPDATE1
String docInsureCarr= ParserUtil.getParameter(request, "docInsureCarr");	//60 DOCINSURECARR
String docInsureCarrExpDate= ParserUtil.getParameter(request, "docInsureCarrExpDate");	//61 DOCINSURECARREXPDATE
//String docOtherInfo1= ParserUtil.getParameter(request, "docOtherInfo1");
//String docOtherInfo2= ParserUtil.getParameter(request, "docOtherInfo2");
//String docOtherInfo3= ParserUtil.getParameter(request, "docOtherInfo3");
//String docOtherInfo4= ParserUtil.getParameter(request, "docOtherInfo4");
//String docOtherInfo5= ParserUtil.getParameter(request, "docOtherInfo5");
String docProfRef1= ParserUtil.getParameter(request, "docProfRef1");	//62 DOCPROFREF1
String docProfRef2= ParserUtil.getParameter(request, "docProfRef2");	//63 DOCPROFREF2
String docProfRefContact1= ParserUtil.getParameter(request, "docProfRefContact1"); //64 DOCPROFREFCONTACT1
String docProfRefContact2= ParserUtil.getParameter(request, "docProfRefContact2"); //65 DOCPROFREFCONTACT2

String privilegesId = null;
String[] checkPrivDesc = null;

String checkPriv0= ParserUtil.getParameter(request, "checkPriv0");
String checkPriv1= ParserUtil.getParameter(request, "checkPriv1");
String checkPriv2= ParserUtil.getParameter(request, "checkPriv2");
String checkPriv3= ParserUtil.getParameter(request, "checkPriv3");
String checkPriv4= ParserUtil.getParameter(request, "checkPriv4");
String checkPriv5= ParserUtil.getParameter(request, "checkPriv5");
String checkPriv6= ParserUtil.getParameter(request, "checkPriv6");
String checkPriv7= ParserUtil.getParameter(request, "checkPriv7");
String checkPriv8= ParserUtil.getParameter(request, "checkPriv8");
String checkPriv9= ParserUtil.getParameter(request, "checkPriv9");
String checkPriv10= ParserUtil.getParameter(request, "checkPriv10");
String checkPriv11= ParserUtil.getParameter(request, "checkPriv11");

String formId = "F002A";
String formId2 = "F002B";
String questId = null;
String questId2 = null;
String questAns = null;
String questAns2 = null;
String questSupDtl = null;
String questSupDtl2 = null;

ArrayList questList = null;
ArrayList questList2 = null;

String[] checkPriv = null ;
String siteCode = null;

try {
	ArrayList privList = CTS.getCTSNewPrivileges();		
	int miscItemArraySize = privList.size();
	checkPrivDesc = new String[privList.size()];	
	for( int i=0;i<checkPrivDesc.length;i++) {
		ReportableListObject pRow = (ReportableListObject) privList.get(i);
		privilegesId = pRow.getValue(0);
		checkPrivDesc[i] = pRow.getValue(1);
	}
	
	checkPriv = new String[privList.size()];
	for(int i=0;i<checkPriv.length;i++) {
		 checkPriv[i]= ParserUtil.getParameter(request, "checkPriv"+i);
	}	
	
	if (submitAction) {
		updateSucc = CTS.updateNewCtsStatus(userBean, ctsNo, "R");
		if(updateSucc){
			forwardPath = "newDocByManualPreview.jsp?ctsNo="+ctsNo+"&command=view&siteCode="+siteCode;
			System.err.println("11[forwardPath]:"+forwardPath);			
		}
	}else if(updateAction){		
		forwardPath = "newDocForm.jsp?command=view&ctsNo="+ctsNo;
		System.err.println("22[forwardPath]:"+forwardPath);
	}else if(viewAction){
		if (ctsNo != null && ctsNo != null && ctsNo.length() > 0) {	
			ArrayList record = CTS.getNewCTSDtl(ctsNo);
			ReportableListObject row2 = (ReportableListObject) record.get(0);
			
			ctsStatus = row2.getValue(3);
			docfName = row2.getValue(4);	
			docgName = row2.getValue(5);	
			doccName = row2.getValue(6);	
			docSex = row2.getValue(7);	
			idNo = row2.getValue(8);	
			martialStatus = row2.getValue(9);	
			docSpCode = row2.getValue(10);	
			docAddr1 = row2.getValue(11);	
			docAddr2 = row2.getValue(12);	
			docAddr3 = row2.getValue(13);	
			docAddr4 = row2.getValue(14);	
			homeAddr1 = row2.getValue(15);	
			homeAddr2 = row2.getValue(16);	
			homeAddr3 = row2.getValue(17);	
			homeAddr4 = row2.getValue(18);	
			email = row2.getValue(19);	
			pager = row2.getValue(20);	
			mobile = row2.getValue(21);	
			homeTel = row2.getValue(22);	
			officeTel = row2.getValue(23);	
			officeFax = row2.getValue(24);	
			docAcademic1 = row2.getValue(25);	
			docAcademic2 = row2.getValue(26);	
			docDegree1 = row2.getValue(27);	
			docDegree2 = row2.getValue(28);	
			docAcademicDate1 = row2.getValue(29);	
			docAcademicDate2 = row2.getValue(30);	
			docSpecQual = row2.getValue(31);	
			docSpecQualSince = row2.getValue(32);	
			docSpecQualHospital1 = row2.getValue(33);	
			docSpecQualHospital2 = row2.getValue(34);	
			docSpecQualDateFrom1 = row2.getValue(35);	
			docSpecQualDateFrom2 = row2.getValue(36);	
			docSpecQualDateTo1 = row2.getValue(37);	
			docSpecQualDateTo2 = row2.getValue(38);
			medInfo= row2.getValue(39);
			docPrevPracticeAddr1 = row2.getValue(40);	
			docPrevPracticeAddr2 = row2.getValue(41);	
			docPrevPracticeFrom1 = row2.getValue(42);	
			docPrevPracticeFrom2 = row2.getValue(43);	
			docPrevPracticeTo1 = row2.getValue(44);	
			docPrevPracticeTo2 = row2.getValue(45);	
			docMemProSoc1 = row2.getValue(46);	
			docMemProSoc2 = row2.getValue(47);	
			docMemProSocStatus1 = row2.getValue(48);	
			docMemProSocStatus2 = row2.getValue(49);	
			docMemProSocYear1 = row2.getValue(50);	
			docMemProSocYear2 = row2.getValue(51);	
			docAcademyOfMed1 = row2.getValue(52);	
			docAcademyOfMed2 = row2.getValue(53);	
			docAcademyOfMedStatus1 = row2.getValue(54);	
			docAcademyOfMedStatus2 = row2.getValue(55);	
			docAcademyOfMedYear1 = row2.getValue(56);	
			docAcademyOfMedYear2 = row2.getValue(57);	
			docLicNo1 = row2.getValue(58);
			docLicNo2 = row2.getValue(59);				
			docLicExpdate1 = row2.getValue(60);	
			docLicExpdate2 = row2.getValue(61);	
			docInsureCarr = row2.getValue(62);	
			docInsureCarrExpDate = row2.getValue(63);	
			docProfRef1 = row2.getValue(64);	
			docProfRef2 = row2.getValue(65);	
			docProfRefContact1 = row2.getValue(66);	
			docProfRefContact2 = row2.getValue(67);				
			
//			docCode = row2.getValue(0);			
			questList = CTS.getformQuest(formId,ctsNo);
			request.setAttribute("CTS", questList);			
			
			questList2 = CTS.getformQuest(formId2,ctsNo);
			request.setAttribute("CTS2", questList2);

			ArrayList recordPrivilegesDtl = CTS.getNewPrivilegesDtl(ctsNo);
			for(int i = 0;i<recordPrivilegesDtl.size();i++){
				ReportableListObject pRow1 = (ReportableListObject) recordPrivilegesDtl.get(i);
				checkPriv[i] = pRow1.getValue(1);
			}
		}
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
.person-info-tab td { padding: 2px; }
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
.addFlw, .stepBtn, .nextBtn, .prevBtn {
	cursor: pointer;
}
.alert {
	color: Red!important;
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
div#menu, div#content {
	border: 2px solid;
	border-color: black;
}
div.reportItem {
	cursor: pointer!important;
}

#rowHS {
    width: 100%;
    margin: 10px 0 10px 0 !important;
}

#rowOI {
    width: 100%;
    margin: 10px 0 10px 0 !important;
}

<% if (ConstantsServerSide.isTWAH()) { %>
button.btn-click {
	font-size: 15px;
	font-weight: bold;
}
<%}%>

</style>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/registration/background.css" />" />
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<%Map<String, String> tooltipMap = new HashMap<String, String>();
tooltipMap.put("backBtn","Click 'Back' to go back previous for editing.");
tooltipMap.put("submitBtn","Click 'Submit' to confirm your renewal application, no changes are allowed after submission.");
%>
<%		System.err.println("[submitAction]:"+submitAction); %>
<%		System.err.println("[viewAction]:"+viewAction); %>
<%	if (userBean.isLogin() && closeAction) { %>
		<%if (errorMessage != null) { %>
			<script type="text/javascript">alert('Form Saving Error, please contact IM support');window.close();</script>
		<%} else { %>	
			<%if (submitAction) { %>
				<script type="text/javascript">alert('Form Submitted');window.close();</script>
			<%} else { %>
				<script type="text/javascript">alert('Form Saved');window.close();</script>
			<%} %>
		<%} %>
		<script type="text/javascript">alert('Access Denied !');window.close();</script>
<%} else if(submitAction || updateAction){ %>
<%		System.err.println("33[forwardPath]:"+forwardPath); %>
		<script language="javascript">parent.location.href = "<%=forwardPath %>";</script>		
<%	} else {
%>
<body style="display:none;">
<jsp:include page="cts_header.jsp" flush="false" >
	<jsp:param name="headerTitle" value="Preview"/>
</jsp:include>
<DIV class="wrapper" style="background-color:white;">
<DIV  >
<DIV style="background-color:white;" style="width:100%" >
<div class="normal_area">
<div class="career_form" style="padding: 20px 18px;">
				<%				
				  String title = "Preview new CTS form";				  
				  if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
				  if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
				%>
				<%
					if("1".equals(CTS.checkRecordLock(ctsNo))){
						mustLogin = "N";
					}else{
						mustLogin = "Y";
					}
				%>				
				<jsp:include page="../common/message.jsp" flush="false">
					<jsp:param name="message" value="<%=message %>" />
					<jsp:param name="errorMessage" value="<%=errorMessage %>" />
				</jsp:include>
				
				<%-- Start the form --%>
				<form name="reportForm" id="form1" enctype="multipart/form-data" 
							action="newDocFormPreview.jsp" method="post">												
<table width="800" border="1"  align="center" cellpadding="0" cellspacing="0">
	<tr>
		<td>
					<table cellpadding="0" cellspacing="5" class="contentFrameMenu reportcontent" border="0" width="100%">
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docfName" /></b></font></td>		
							<td height="20" valign="top"><%=docfName==null?"":docfName %></td>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docgName" /></b></font></td>
							<td height="20" valign="top"><%=docgName==null?"":docgName %></td>	
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.doccName" /></b></font></td>
							<td height="20" valign="top"><%=doccName==null?"":doccName %></td>
						</tr>						
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.sex" /></b></font></td>									
							<td height="20" valign="top"><%="F".equals(docSex)?"Female":"Male" %></td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docIdNO" /></b></font></td>
							<td height="20" valign="top"><%=idNo==null?"":idNo %></td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.martialStatus" /></b></font></td>
							<td height="20" valign="top"><%="S".equals(martialStatus)?"Single":"E".equals(martialStatus)?"Engaged":"M".equals(martialStatus)?"Married":"D".equals(martialStatus)?"Divorce":"X".equals(martialStatus)?"Separate":"W".equals(martialStatus)?"Widow":"Z".equals(martialStatus)?"Widower":"O".equals(martialStatus)?"Other":"Other" %></td>														
						</tr>
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docCorrAddr" /></b></font></td>
							<td>
							<table>
								<tr>
									<td height="20" valign="top"><%=docAddr1==null?"":docAddr1 %></td>
								</tr>
								<tr>
									<td height="20" valign="top"><%=docAddr2==null?"":docAddr2 %></td>
								</tr>
								<tr>
									<td height="20" valign="top"><%=docAddr3==null?"":docAddr3 %></td>
								</tr>
								<tr>
									<td height="20" valign="top"><%=docAddr4==null?"":docAddr4 %></td>
								</tr>																								
							</table>
							</td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docHomeAddr" /></b></font></td>
							<td>
							<table>
								<tr>
									<td height="20" valign="top"><%=homeAddr1==null?"":homeAddr1 %></td>
								</tr>
								<tr>
									<td height="20" valign="top"><%=homeAddr2==null?"":homeAddr2 %></td>
								</tr>
								<tr>
									<td height="20" valign="top"><%=homeAddr3==null?"":homeAddr3 %></td>
								</tr>
								<tr>
									<td height="20" valign="top"><%=homeAddr4==null?"":homeAddr4 %></td>
								</tr>																								
							</table>									
							</td>							
						</tr>
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docOfficeTel" /></b></font></td>		
							<td height="20" valign="top"><%=officeTel==null?"":officeTel %></td>									
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docOfficeFax" /></b></font></td>
							<td height="20" valign="top"><%=officeFax==null?"":officeFax %></td>				
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docEmail" /></b></font></td>
							<td height="20" valign="top"><%=email==null?"":email %></td>			
						</tr>
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docPager" /></b></font></td>		
							<td height="20" valign="top"><%=pager==null?"":pager %></td>							
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docMobile" /></b></font></td>
							<td height="20" valign="top"><%=mobile==null?"":mobile %></td>					
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docHomeTel" /></b></font></td>
							<td height="20" valign="top"><%=homeTel==null?"":homeTel %>
							</td>					
						</tr>						
						<tr>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform14" /></font>
							</td>							
						</tr>
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docAcademic1" /></b></font></td>		
							<td height="20" valign="top"><%=docAcademic1==null?"":docAcademic1 %></td>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docDegree" /></b></font></td>
							<td height="20" valign="top"><%=docDegree1==null?"":docDegree1 %></td>	
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docAcademicDate" /></b></font></td>
							<td height="20" valign="top"><%=docAcademicDate1==null?"":docAcademicDate1 %></td>
						</tr>
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docAcademic2" /></b></font></td>		
							<td height="20" valign="top"><%=docAcademic2==null?"":docAcademic2 %></td>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docDegree" /></b></font></td>
							<td height="20" valign="top"><%=docDegree2==null?"":docDegree2 %></td>	
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docAcademicDate" /></b></font></td>
							<td height="20" valign="top"><%=docAcademicDate2==null?"":docAcademicDate2 %></td>
						</tr>						
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.docSpecQual" /></b></font></td>		
							<td height="20" valign="top"><%=docSpecQual==null?"":docSpecQual %></td>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.since" /></b></font></td>
							<td height="20" valign="top"><%=docSpecQualSince==null?"":docSpecQualSince %></td>
						</tr>						
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.hospital" /></b></font></td>		
							<td height="20" valign="top"><%=docSpecQualHospital1==null?"":docSpecQualHospital1 %></td>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.from" /></b></font></td>
							<td height="20" valign="top"><%=docSpecQualDateFrom1==null?"":docSpecQualDateFrom1 %></td>	
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.to" /></b></font></td>
							<td height="20" valign="top"><%=docSpecQualDateTo1==null?"":docSpecQualDateTo1 %></td>
						</tr>
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.hospital" /></b></font></td>		
							<td height="20" valign="top"><%=docSpecQualHospital2==null?"":docSpecQualHospital2%></td>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.from" /></b></font></td>
							<td height="20" valign="top"><%=docSpecQualDateFrom2==null?"":docSpecQualDateFrom2%></td>	
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.to" /></b></font></td>
							<td height="20" valign="top"><%=docSpecQualDateTo2==null?"":docSpecQualDateTo2 %></td>
						</tr>
						<tr>
							<td height="20" valign="top" colspan=6><font size="2"><b><bean:message key="prompt.docCTSNew01" /></b></font></td>
						</tr>
						<tr>															
							<td colspan=6><%=medInfo==null?"":medInfo %></td>
						</tr>												
						<%-- End basicInfo2 --%>												
						<%-- basicInfo2 --%>						
						<tr>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform15" /></font>
							</td>							
						</tr>			
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="adm.Address" /></b></font></td>		
							<td height="20" valign="top" colspan=5><%=docPrevPracticeAddr1==null?"":docPrevPracticeAddr1 %></td>
						</tr>						
						<tr>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.from" /></b></font></td>
							<td height="20" valign="top"><%=docPrevPracticeFrom1==null?"":docPrevPracticeFrom1 %></td>
							<td></td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.to" /></b></font></td>
							<td height="20" valign="top"><%=docPrevPracticeTo1==null?"":docPrevPracticeTo1 %></td>								
							<td></td>
						</tr>
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="adm.Address" /></b></font></td>		
							<td height="20" valign="top" colspan=5><%=docPrevPracticeAddr2==null?"":docPrevPracticeAddr2 %></td>
						</tr>						
						<tr>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.from" /></b></font></td>
							<td height="20" valign="top"><%=docPrevPracticeFrom2==null?"":docPrevPracticeFrom2 %></td>
							<td></td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.to" /></b></font></td>
							<td height="20" valign="top"><%=docPrevPracticeTo2==null?"":docPrevPracticeTo2 %></td>								
							<td></td>
						</tr>
						<tr>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform16" /></font>
							</td>							
						</tr>
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.name" /></b></font></td>		
							<td height="20" valign="top" colspan=5><%=docMemProSoc1==null?"":docMemProSoc1 %></td>
						</tr>						
						<tr>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.memStatus" /></b></font></td>
							<td height="20" valign="top"><%=docMemProSocStatus1==null?"":docMemProSocStatus1 %></td>
							<td></td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.year" /></b></font></td>
							<td height="20" valign="top"><%=docMemProSocYear1==null?"":docMemProSocYear1 %></td>								
							<td></td>
						</tr>
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.name" /></b></font></td>			
							<td height="20" valign="top" colspan="5"><%=docMemProSoc2==null?"":docMemProSoc2 %></td>
						</tr>						
						<tr>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.memStatus" /></b></font></td>
							<td height="20" valign="top"><%=docMemProSocStatus2==null?"":docMemProSocStatus2 %></td>
							<td></td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.year" /></b></font></td>
							<td height="20" valign="top"><%=docMemProSocYear2==null?"":docMemProSocYear2 %></td>								
							<td></td>
						</tr>						
						<tr>
							<td class="infoCenterLabel" width="15%" colspan=7 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform17" /></font>
							</td>							
						</tr>
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.name" /></b></font></td>
							<td height="20" valign="top" colspan="5"><%=docAcademyOfMed1==null?"":docAcademyOfMed1 %></td>
						</tr>						
						<tr>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.memStatus" /></b></font></td>
							<td height="20" valign="top"><%=docAcademyOfMedStatus1==null?"":docAcademyOfMedStatus1 %></td>
							<td></td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.year" /></b></font></td>
							<td height="20" valign="top"><%=docAcademyOfMedYear1==null?"":docAcademyOfMedYear1 %></td>								
							<td></td>
						</tr>
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.name" /></b></font></td>
							<td height="20" valign="top" colspan="5"><%=docAcademyOfMed2==null?"":docAcademyOfMed2 %></td>
						</tr>						
						<tr>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.memStatus" /></b></font></td>
							<td height="20" valign="top"><%=docAcademyOfMedStatus2==null?"":docAcademyOfMedStatus2 %></td>
							<td></td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.year" /></b></font></td>
							<td height="20" valign="top"><%=docAcademyOfMedYear2==null?"":docAcademyOfMedYear2 %></td>							
							<td></td>							
						</tr>
						<tr>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform12" /></font>
							</td>							
						</tr>						
						<tr>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.HKMC_LICNO" /></b></font></td>
							<td height="20" valign="top"><%=docLicNo1==null?"":docLicNo1 %></td>
							<td></td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.issuedDate" /></b></font></td>
							<td height="20" valign="top"><%=docLicExpdate1==null?"":docLicExpdate1 %></td>							
							<td></td>							
						</tr>						
						<tr>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.LICNO" /></b></font></td>
							<td height="20" valign="top"><%=docLicNo2==null?"":docLicNo2 %></td>
							<td></td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.issuedDate" /></b></font></td>
							<td height="20" valign="top"><%=docLicExpdate2==null?"":docLicExpdate2 %></td>							
							<td></td>
						</tr>								
						<%-- End basicInfo2 --%>						
						<%-- basicInfo3 --%>
						<tr>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform5" /></font>
							</td>							
						</tr>
						<tr>
							<td colspan="6">	
							<display:table id="rowHS" name="requestScope.CTS" export="false">
								<display:setProperty name="basic.show.header" value="false" />
								<display:column property="fields1" title="&nbsp;" style="width:90%" sortable="false"/>
								<display:column title="&nbsp;" style="width:10%" sortable="false">
									<logic:equal name="rowHS" property="fields2" value="Y">
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="Y" checked="checked" disabled="disabled">Yes</input>
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="N" disabled="disabled">No</input>							 		
									</logic:equal>
									<logic:equal name="rowHS" property="fields2" value="N">
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="Y" disabled="disabled">Yes</input>
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="N" checked="checked" disabled="disabled">No</input>	
									</logic:equal>
									<logic:equal name="rowHS" property="fields2" value="0">									
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="Y" onclick="return false;">Yes</input>
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="N" onclick="return false;">No</input>	
									</logic:equal>
								</display:column>
								<display:column title="&nbsp;" style="width:0%" sortable="false" >
									<input type="hidden" name="supDtlHS<c:out value="${rowHS.fields0}" />" value="${requestScope.CTS[row_rowNum - 1].fields3}" />		
								</display:column>				
							</display:table>
							</td>	
						</tr>						
						<tr>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform4" /></font>
							</td>							
						</tr>												
						<tr>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.insCarrier" /></b></font></td>
							<td height="20" valign="top"><%=docInsureCarr==null?"":docInsureCarr %></td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.expiryDateDmy" /></b></font></td>
							<td height="20" valign="top"><%=docInsureCarrExpDate==null?"":docInsureCarrExpDate %></td>														
						</tr>
						<tr>
							<td colspan="6">	
							<display:table id="rowOI" name="requestScope.CTS2" export="false">
								<display:setProperty name="basic.show.header" value="false" />
								<display:column property="fields1" title="&nbsp;" style="width:90%" sortable="false"/>
								<display:column title="&nbsp;" style="width:10%" sortable="false">
									<logic:equal name="rowOI" property="fields2" value="Y">
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="Y" checked="checked" disabled="disabled">Yes</input>
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="N" disabled="disabled">No</input>										 		
									</logic:equal>
									<logic:equal name="rowOI" property="fields2" value="N">						
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="Y" disabled="disabled">Yes</input>
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="N" checked="checked" disabled="disabled">No</input>	
									</logic:equal>
									<logic:equal name="rowOI" property="fields2" value="0">									
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="Y" onclick="return false;">Yes</input>
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="N" onclick="return false;">No</input>	
									</logic:equal>
								</display:column>
								<display:column title="&nbsp;" style="width:0%" sortable="false" >
									<input type="hidden" name="supDtlOI<c:out value="${rowOI.fields0}" />" value="${requestScope.CTS[row_rowNum - 1].fields3}" />		
								</display:column>				
							</display:table>
							</td>	
						</tr>																																		
						<%-- End basicInfo3 --%>
						
						<%-- basicInfo3 --%>
						<tr>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.newForm01" /></font>
							</td>							
						</tr>
						<tr>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.sms.op.doctitle" /></b></font></td>
							<td height="20" valign="top"><%=docProfRef1==null?"":docProfRef1 %></td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.addressFaxEmail" /></b></font></td>
							<td height="20" valign="top"><%=docProfRefContact1==null?"":docProfRefContact1 %></td>						
						</tr>
						<tr>		
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.sms.op.doctitle" /></b></font></td>
							<td height="20" valign="top"><%=docProfRef2==null?"":docProfRef2 %></td>
							<td height="20" valign="top"><font size="2"><b><bean:message key="prompt.addressFaxEmail" /></b></font></td>
							<td height="20" valign="top"><%=docProfRefContact2==null?"":docProfRefContact2 %></td>						
						</tr>												
						<tr>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.newForm02" /></font>
							</td>							
						</tr>
						<tr>
							<td colspan=6>
								<table width="100%">
								<tr>		
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv0" <%if ("1".equals(checkPriv[0])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[0] %>							
									</td>
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv10" <%if ("1".equals(checkPriv[10])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[10] %>									
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv1" <%if ("1".equals(checkPriv[1])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[1] %>								
									</td>
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv11" <%if ("1".equals(checkPriv[11])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[11] %>									
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv2" <%if ("1".equals(checkPriv[2])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[2] %>								
									</td>
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv12" <%if ("1".equals(checkPriv[12])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[12] %>									
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv3" <%if ("1".equals(checkPriv[3])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[3] %>								
									</td>
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv13" <%if ("1".equals(checkPriv[13])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[13] %>			
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv4" <%if ("1".equals(checkPriv[4])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[4] %>								
									</td>
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv14" <%if ("1".equals(checkPriv[14])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[14] %>									
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv5" <%if ("1".equals(checkPriv[5])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[5] %>			
									</td>
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv15" <%if ("1".equals(checkPriv[15])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[15] %>			
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv6" <%if ("1".equals(checkPriv[6])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[6] %>			
									</td>
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv16" <%if ("1".equals(checkPriv[16])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[16] %>			
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv7" <%if ("1".equals(checkPriv[7])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[7] %>	
									</td>
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv17" <%if ("1".equals(checkPriv[17])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[17] %>	
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv8" <%if ("1".equals(checkPriv[8])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[8] %>	
									</td>
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv18" <%if ("1".equals(checkPriv[18])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[18] %>	
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv9" <%if ("1".equals(checkPriv[9])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[9] %>	
									</td>
									<td width="50%" align="left">
										<input onclick="return false;" type="checkbox" value ="1" name="checkPriv19" <%if ("1".equals(checkPriv[19])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[19] %>	
									</td>															
								</tr>																																																
								</table>
							</td>							
						</tr>
						<tr>
							<td colspan=6>
<hr noshade="noshade"/>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">	
	<tr>
	<td><bean:message key="prompt.ctsnew.attachment1" /></td>
	<td>
<%System.err.println("[folderId]:"+folderId); %>	
<%String keyId = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId %>" />
	<jsp:param name="allowRemove" value="N" />
	<jsp:param name="subKeyID" value="1" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
	</td>
	</tr>
	<tr>
	<td><bean:message key="prompt.ctsnew.attachment2" /></td>
	<td>	
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId %>" />
	<jsp:param name="allowRemove" value="N" />
	<jsp:param name="subKeyID" value="2" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
	</td>
	</tr>
	<tr>
	<td><bean:message key="prompt.ctsnew.attachment3" /></td>
	<td>	
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId %>" />
	<jsp:param name="allowRemove" value="N" />
	<jsp:param name="subKeyID" value="3" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
	</td>
	</tr>
	<tr>
	<td><bean:message key="prompt.ctsnew.attachment4" /></td>
	<td>	
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId %>" />
	<jsp:param name="allowRemove" value="N" />
	<jsp:param name="subKeyID" value="4" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
	</td>
	</tr>
	<tr>
	<td><bean:message key="prompt.ctsnew.attachment5" /></td>
	<td>	
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId %>" />
	<jsp:param name="allowRemove" value="N" />
	<jsp:param name="subKeyID" value="5" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
	</td>
	</tr>
	<tr>
	<td><bean:message key="prompt.ctsnew.attachment6" /></td>
	<td>	
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId %>" />
	<jsp:param name="allowRemove" value="N" />
	<jsp:param name="subKeyID" value="6" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
	</td>
	</tr>		
	<tr>
	<td><bean:message key="prompt.ctsnew.attachment7" /></td>
	<td>	
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId %>" />
	<jsp:param name="allowRemove" value="N" />
	<jsp:param name="subKeyID" value="7" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
	</td>
	</tr>
	<tr>
	<td><bean:message key="prompt.ctsnew.attachment8" /></td>
	<td>	
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId %>" />
	<jsp:param name="allowRemove" value="N" />
	<jsp:param name="subKeyID" value="8" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
	</td>
	</tr>
	<tr>
	<td><bean:message key="prompt.ctsnew.attachment9" /></td>
	<td>	
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId %>" />
	<jsp:param name="allowRemove" value="N" />
	<jsp:param name="subKeyID" value="9" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
	</td>
	</tr>
	<tr>
	<td><bean:message key="prompt.ctsnew.attachment10" /></td>
	<td>	
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId %>" />
	<jsp:param name="allowRemove" value="N" />
	<jsp:param name="subKeyID" value="10" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
	</td>
	</tr>
	<tr>
	<td><bean:message key="prompt.ctsnew.attachment11" /></td>
	<td>	
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId %>" />
	<jsp:param name="allowRemove" value="N" />
	<jsp:param name="subKeyID" value="11" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
	</td>
	</tr>
	<tr>
	<td><bean:message key="prompt.ctsnew.attachment12" /></td>
	<td>	
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId %>" />
	<jsp:param name="allowRemove" value="N" />
	<jsp:param name="subKeyID" value="12" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
	</td>
	</tr>	
</table>
							</td>
						</tr>

						<tr>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform7" /></font>
							</td>							
						</tr>						
						<tr>
							<td colspan=6>
								<bean:message key="prompt.newForm.content7" />
								<br><br><bean:message key="prompt.newForm.content8" />
								<br><br><bean:message key="prompt.newForm.content9" />
							</td>							
						</tr>						
						<tr>
							<td align="center" colspan=6>
								<input onclick="return false;" type=checkbox name="acceptAgr" value="" checked="true"/>
								&nbsp;<b>* I hereby accept the above statement of agreement.</b>		
							</td>	
						</tr>
						<tr>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.newForm03" /></font>
							</td>							
						</tr>
						<tr>
							<td colspan=6 align="center">
								<table width=100%>
								<tr align="left">
									<td>
										<font style="font-size: 11pt;" size="1">Click "Submit" button to confirm information. No changes are allowed after confirmation.</font></br>							
									</td>
								</tr>
								<tr align="center">
									<td>
										<button title="<%=tooltipMap.get("backBtn") %>" onclick="return submitAction('update','<%=ctsNo %>');"><bean:message key="button.back" /></button>			
										<button title="<%=tooltipMap.get("submitBtn") %>" onclick="return submitAction('submit','<%=ctsNo %>');"><bean:message key="button.submit" /></button>							
									</td>							
								</tr>
								</table>
							</td>													
						</tr>
						<%-- End basicInfo4 --%>										
					</table>
		</td>
	</tr>
</table>										
					<%--prev/next step btn --%>

					<input type="hidden" name="command" value="<%=command%>"/>
					<input type="hidden" name="ctsNo" value="<%=ctsNo%>"/>
					<input type="hidden" name="formId" value="<%=formId %>"/>
					<input type="hidden" name="ctsStatus" value="<%=ctsStatus%>"/>
				</form>
</div>
</div>
</DIV>
</DIV>
<div  class="push"></div>
 <table  width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
</table>
</DIV>				

<script language="javascript">
var editAction = false;
var viewAction = false;
var viewRptAction = false;
var checkList = new Array();
var apis = [];

function windowOnClose() {
	return 'Are you sure to close this page?';
}

$(document).ready(function() {
	//window.addEventListener("beforeunload",windowOnClose);

	$('#status').hide();

	if(document.getElementsByName("radioHSQ0003")[0]){
		showAnswerField9(document.getElementsByName("radioQ0003")[0]);
		if(document.getElementsByName("radioHSQ0009")[0]=='Y'){
			document.form1.ans9.value = document.getElementsByName("supDtlHSQ0003")[0].value;
		}		
		
	}	
	
	$(window).bind('beforeunload', windowOnClose); 
	
	setInterval("animation()",1000);

	var command = $('input[name=command]').val();
	if(command == 'edit') {
		editAction = true;
	}
	else if(command.indexOf('view') > -1) {
		viewAction = true;
	}
	$('input[name=command]').val('');
	
	
	if(viewAction) {
		$('div.reportContent').appendTo('div#content-container');
		initScroll('div#report', true);
	}
	else if(editAction) {
		editAction = true;

		resetDatepicker(true);

		//handleIncludePage();
		resetDatepicker(false);
		//headerEvent();
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

		$('div.reportContent').appendTo('div#content-container');
		initScroll('div#report', true);
		selectReportItemEvent();
		// toy add on 2/3/2015
		makeCheckList();
	}
	else {
//		alert('* CONFIDENTIAL\n* Not part of Patient\'s Medical Record');
	}
	
	$('table').each(function(i, v) {
		if(!($(this).find('tr').length > 0)) {
			$(this).remove();
		}
	});

	$('body').css('display', '');
	referKeyEvent();
	referKeyEventChkbox();
	
});

<%--****************************Scroll****************************--%>
//Modified on 02/04/2012 init scrollbar
function initScroll(target, autoReinitialise) {
	//destroyScroll();
	$(target).find('.scroll-pane').each(function(){
		apis.push($(this).jScrollPane({autoReinitialise:autoReinitialise}).data().jsp);
	});
	return false;
}
//Modified on 02/04/2012 destroy scrollbar
function destroyScroll() {
	if (apis.length) {
		$.each(apis,function(i) {
				this.destroy();
		});
		apis = [];
	}
	return false;
}


<%--**************************/Checking before submit**************************--%>


//Modified on 03/04/2012 handling the report content
function handleReportContent(saveonly) {
	var report = $('div#report');
	var hiddenInput = $('input[name='+$('input[name=selectedIncidentType]').val()+'_value]');
	var hiddenInputVal = hiddenInput.val();
	
	report.find('[optType=checkbox]:checked').each(function(i, v) {		
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#checkbox@#checked@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		if(saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=checkInput]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#checkInput@#'+
							$(this).next().val()+'@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		if(saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=yesNo]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#yesNo@#'+
							$(this).val()+'@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		if(saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=input]').each(function(i, v) {
		if($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('id')+'@#input@#'+
								$(this).val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			if(saveonly == 'N') {
				checkValue($(this).attr('category'));
			}
		}
	});
	report.find('[optType=textarea]').each(function(i, v) {
		if($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('id')+'@#textarea@#'+
								$(this).val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			if(saveonly == 'N') {
				checkValue($(this).attr('category'));
			}
		}
	});
	report.find('[optType=checkboxInput]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#checkboxInput@#'+
							$(this).next().val()+'@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		if(saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=radio]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#radio@#checked@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		if(saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=date]').each(function(i, v) {
		if($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('optid')+'@#date@#'+
								$(this).val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			if(saveonly == 'N') {
				checkValue($(this).attr('category'));
			}
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
			
			if(saveonly == 'N') {
				checkValue($(this).attr('category'));
			}
		}
	});
	report.find('[optType=checkboxDate]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#checkboxDate@#'+
							$(this).next().val()+'@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		checkValue($(this).attr('category'));
	});
	report.find('[optType=upload]').each(function(i, v) {
		if($(this).attr('contentId') || $(this).find('input').val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('id')+'@#upload@#'+
								($(this).attr('contentId')?$(this).attr('docIDs'):$(this).find('input').val())+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			if(saveonly == 'N') {			
				checkValue($(this).attr('category'));
			}
		}
	});
	
	//alert("checkList.length : " + checkList.length);
	if(saveonly == 'N') {
		if(checkList.length > 0) {
			return false;
		}
	}
	
	//alert("hiddenInput : " + hiddenInputVal);
	hiddenInput.val(hiddenInputVal);
	return true;
}
<%--***************************/Handling content before submit***************************--%>



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

function findGrpId(dom) {
	var temp = dom.parent();
	
	while(!$(temp).attr('contentGrpID')) {
		temp = temp.parent();
	} 
	
	return $(temp).attr('contentGrpID');
}

function checkValue(category) {
	if(checkList.length > 0) {
		$.each(checkList, function(i, v) {			
			if(v == category) {
				checkList.splice(i, 1);
				return true;
			}
			else {
				if (v) {			
					//alert("else {, v : " + v);
					var info = v.split(',');
					if(info.length > 1) {										
						$.each(info, function(i2, v2) {
							if(v2 == category) {				
								checkList.splice(i, 1);
								return true;
							}
						});				
					}
				}
			}
		});	
	}else {
		return true;
	}
}

function makeCheckList() {	
	 var must = $('option:selected', $('select[name=incidentClass]')).attr('must');	
	checkList = new Array();
	if(must) {
		var info = must.split(';');
		$.each(info, function(i, v) {
			if(v.length > 0)
				checkList.splice(checkList.length, 0, v);
		});
	}
}

function removeDocument(mid,did) {
	$.ajax({
		type: "POST",
		url: "../common/document_list.jsp",
		data: "command=delete&moduleCode="+ mid +"&keyID=<%=folderId %>&documentID=" + did + "&allowRemove=Y",
		success: function(values){
		if(values != '') {
			$("#showDocument_indicator").html(values);
		}//if
		}//success
	});//$.ajax
}

function submitAction(cmd, ctsNo) {
	var msg = null;	
	if(cmd=='update'){
		$('input[name=command]').val(cmd);
		$('input[name=ctsNo]').val(ctsNo);
		$(window).unbind('beforeunload', windowOnClose);
		
		document.reportForm.submit();
		
		return false;
	}else if(cmd == 'submit') {
		var r=confirm("Confirm to submit?");
		if (r==true){
			msg = 'Submitting..... Please wait.';
			$('input[name=command]').val(cmd);
			$('input[name=ctsNo]').val(ctsNo);		
			
			$(window).unbind('beforeunload', windowOnClose);
			
			document.reportForm.submit();		
			
			$.prompt(msg,{
				prefix:'cleanblue', buttons: { }
			});
			return false;	
		 }else{
			 return false;	
		 }
	}else{
		alert('[cmd]:'+cmd);
		return false;		
	}
}

// Popup window code
function newPopup(url) {
	popupWindow = window.open(
		url,'popUpWindow','height=750,width=750,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes');
}

</script>
			</DIV>
		</DIV>
	</DIV>
	<jsp:include page="../pi/hiddenInvolvePerson.jsp" flush="false"/>
	<jsp:include page="../common/footer.jsp" flush="false" />
	<jsp:include page="cts_footer.jsp" flush="false" />	
</body>
<%
	} 
%>
</html:html>