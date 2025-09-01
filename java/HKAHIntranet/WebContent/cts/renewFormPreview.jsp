<%@ page import="java.io.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String ctsNo = null;
String docCode = null;
String docfName = null;
String docgName = null;
String doccName = null;
String idNo = null;
String docAddr1 = null;
String docAddr2 = null;
String docAddr3 = null;
String docAddr4 = null;
String homeAddr1 = null;
String homeAddr2 = null;
String homeAddr3 = null;
String homeAddr4 = null;
String officeTel = null;
String officeFax = null;
String email = null;
String pager = null;
String mobile = null;
String homeTel = null;
String healthStatus = null;
String speciality = null;
String docSex = null;
String isSurgeon = null;
String folderId = null;
String specName = null;
String withAttach = null;
String licNo = null;
String licExpDate = null;
String insureCarr = null;
String lnsExpDate = null;

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

if (fileUpload) {
	String[] fileList = (String[]) request.getAttribute("filelist");

	if (fileList != null) {
		if (folderId!=null && folderId.length()>0) {
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

String[] fileList = null;
String formId = "F0001";
String answer9 = null;
boolean viewAction = false;

Calendar calendar = Calendar.getInstance();
SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy",Locale.ENGLISH);
String sysDate = dateFormat.format(calendar.getTime());
String siteCode = ParserUtil.getParameter(request, "siteCode");
if (siteCode == null || siteCode.length() == 0) {
	siteCode = ConstantsServerSide.SITE_CODE;
}

if ("view".equals(command)) {
	viewAction = true;
}

if (viewAction) {
	ctsNo = ParserUtil.getParameter(request, "ctsNo");
	// load data from database
	if (ctsNo != null && ctsNo != null && ctsNo.length() > 0) {
		ArrayList docRecord = CTS.getDocList(ctsNo);
		ReportableListObject row = (ReportableListObject) docRecord.get(0);

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
		idNo = row.getValue(29);
		docSex = row.getValue(3);
		isSurgeon = row.getValue(8);
		healthStatus = row.getValue(28);
		licNo = row.getValue(31);
		licExpDate = row.getValue(32);
		insureCarr = row.getValue(33);
		lnsExpDate = row.getValue(34);
		folderId = CTS.getFolderId(ctsNo);
	}
} else {
	ctsNo = request.getParameter("ctsNo");
//	command = TextUtil.parseStrUTF8((String) request.getAttribute("command"));
//
	docCode = TextUtil.parseStrUTF8((String) request.getAttribute("docCode"));
	docfName = TextUtil.parseStrUTF8((String) request.getAttribute("docfName"));
	docgName = TextUtil.parseStrUTF8((String) request.getAttribute("docgName"));
	doccName = null;
	idNo = TextUtil.parseStrUTF8((String) request.getAttribute("idNo"));
	docAddr1 = TextUtil.parseStrUTF8((String) request.getAttribute("docAddr1"));
	docAddr2 = TextUtil.parseStrUTF8((String) request.getAttribute("docAddr2"));
	docAddr3 = TextUtil.parseStrUTF8((String) request.getAttribute("docAddr3"));
	docAddr4 = TextUtil.parseStrUTF8((String) request.getAttribute("docAddr4"));
	homeAddr1 = TextUtil.parseStrUTF8((String) request.getAttribute("homeAddr1"));
	homeAddr2 = TextUtil.parseStrUTF8((String) request.getAttribute("homeAddr2"));
	homeAddr3 = TextUtil.parseStrUTF8((String) request.getAttribute("homeAddr3"));
	homeAddr4 = TextUtil.parseStrUTF8((String) request.getAttribute("homeAddr4"));
	officeTel = TextUtil.parseStrUTF8((String) request.getAttribute("officeTel"));
	officeFax = TextUtil.parseStrUTF8((String) request.getAttribute("officeFax"));
	email = TextUtil.parseStrUTF8((String) request.getAttribute("email"));
	pager = TextUtil.parseStrUTF8((String) request.getAttribute("pager"));
	mobile = TextUtil.parseStrUTF8((String) request.getAttribute("mobile"));
	homeTel = TextUtil.parseStrUTF8((String) request.getAttribute("homeTel"));
	healthStatus = TextUtil.parseStrUTF8((String) request.getAttribute("healthStatus"));
	speciality = TextUtil.parseStrUTF8((String) request.getAttribute("speciality"));
	docSex = null;
	isSurgeon = null;
	folderId = TextUtil.parseStrUTF8((String) request.getAttribute("folderId"));
}

ArrayList record = CTS.getSpecialty(speciality);
if (record.size() > 0) {
	ReportableListObject rowSpec = (ReportableListObject) record.get(0);
	specName =rowSpec.getValue(1);
}

String supportAnswerDetail2 = null;
if ("twah".equals(siteCode)) {
	supportAnswerDetail2 = "10";
} else {
	supportAnswerDetail2 = "09";
}
ArrayList questSuppAns = CTS.getSuppAns(formId, ctsNo, "Q00" + supportAnswerDetail2);
if (questSuppAns.size() > 0) {
	ReportableListObject rowSuppAns = (ReportableListObject) questSuppAns.get(0);
	answer9 = rowSuppAns.getValue(0);
}

ArrayList questList = CTS.getformQuest(formId,ctsNo);
request.setAttribute("CTS", questList);


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

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body onload="return loadAlert();">
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<div id="printarea"></div>
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="left">
	<tr style="background-color:#FFFFFF">
<%if ("twah".equals(siteCode)) {%>
		<td align="left"><img src="../images/Horizontal_billingual_HKAH_TW.jpg" border="0" width="636" height="110" /></td>
<%} else {%>
		<td align="left"><img src="../images/Horizontal_billingual_HKAH_HK.jpg" border="0" width="648" height="110" /></td>
<%}%>
		<td align="right"><div style="color:#FFFFFF" width="352" height="73"> </div></td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="150" width="20%" valign="bottom">
			<table width="100%" border="0" align="center" cellpadding="0" cellspacing="1" >
				<tr>
<%if ("twah".equals(siteCode)) {%>
					<td align="left">
						199 Tsuen King Circuit,<br>
						Tsuen Wan, New Territories<br>
						Tel: 2275-6711<br>
						Fax: 2275-6473<br>
					</td>
<%} else {%>
					<td align="left">
						40 Stubbs Road<br>
						Hong Kong<br>
						Tel: 2835-0581<br>
						Fax: 2574-6001<br>
					</td>
<%}%>
				</tr>
				<tr>
<!--
					<td class=infoLabelBlk>April 2008<br>
 -->
				</tr>
			</table>
		</td>
		<td height="150" width="60%">
			<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
<%if ("hkah".equals(siteCode)) {%>
					<td align="center" class=infoTitle1>HONG KONG ADVENTIST HOSPITAL - STUBBS ROAD</td>
<%}else if ("twah".equals(siteCode)) {%>
					<td align="center" class=infoTitle1>HONG KONG ADVENTIST HOSPITAL - TSUEN WAN ADVENTIST HOSPITAL</td>
<%}%>
				</tr>
				<tr>
					<td align="center" class=infoTitle1>MEDICAL/DENTAL STAFF PRIVILEGE RENEWAL</td>
				</tr>
				<tr>
					<td width="60%">
						<table width="100%" border="0" rules=none frame=box align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td align="left">Physician#&nbsp;
<!--
									<input type="textfield" name="physicianNo" maxlength="10" size="10">
 -->
									<%=docCode==null?"":docCode %>
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td align="left">
<!--
								Comments:
 -->
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							</tr>
							<tr>
								<td align="center">
<!--
								For Office Use Only
 -->
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td height="150" width="20%">
<!--
			<table height="100%" width="100%" border="0" rules=none frame=box align="center" cellpadding="0" cellspacing="0" >
				<tr>
					<td align="center">
						<b>PLEASE</b><br>
						<b>ATTACH</b><br>
						<b>RECENT</b><br>
						<b>PHOTO</b><br>
						<b>HERE</b>
					</td>
				</tr>
			</table>
 -->
		</td>
	</tr>
</table>
<hr align="left" size="4" width="800" noshade="noshade"/>
<form name="form1" enctype="multipart/form-data" action="renewFormPreview.jsp" method="get">
<!--
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td class="infoLabelNormal" width="20%"><bean:message key="prompt.renewform1" /></td>
		<td width="80%">
			<table border="0" cellpadding="0" cellspacing="0" width=100%>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="85%">
						<b>This form is for the next three years and is intended to up-date your file</b><br>
						1. This form should be typed if possible.<br>
						2. Use additional sheets(or the back page) for additional space.<br>
						3. Attach photocopies of all documents<br>
					</td>
					<td class=infoLabelBlk align="center" width="15%">
						*Please<br>
						PRINT
					</td>
				</tr>
				<tr><td colspan=2><hr align="right" size="2" width="100%" noshade="noshade"/></td></tr>
			</table>
		</td>
	</tr>
</table>
 -->
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td class="infoLabelNormal" width="20%"><bean:message key="prompt.renewform2" /></td>
		<td width="80%">
			<table border="0" cellpadding="0" cellspacing="0" width=100%>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="65%"><b>Name</b></td>
					<td class="infoDataNoraml" align="left" width="20%"><b>Physician Code#</b></td>
					<td class="infoDataNoraml" align="left" width="15%"><b>HKID#</b></td>
				</tr>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="50%"><%=docgName==null||"".equals(docgName)?"&nbsp;":docgName %>, <%=docfName==null||"".equals(docfName)?"&nbsp;":docfName %><hr/></td>
					<td class="infoDataNoraml" align="left" width="20%"><%=docCode==null||"".equals(docCode)?"&nbsp;":docCode %><hr/></td>
					<td class="infoDataNoraml" align="left" width="15%"><%=idNo==null||"".equals(idNo)?"&nbsp;":idNo %><hr/></td>
				</tr>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" colspan=3><b><bean:message key="prompt.docCorrAddr" /></b></td>
				</tr>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" colspan=3><%=docAddr1==null||"".equals(docAddr1)?"&nbsp;":docAddr1 %><%=docAddr2==null||"".equals(docAddr2)?"&nbsp;":", " %><%=docAddr2==null||"".equals(docAddr2)?"&nbsp;":docAddr2 %><%=docAddr3==null||"".equals(docAddr3)?"&nbsp;":", " %><%=docAddr3==null||"".equals(docAddr3)?"&nbsp;":docAddr3 %><%=docAddr4==null||"".equals(docAddr4)?"&nbsp;":", " %><%=docAddr4==null||"".equals(docAddr4)?"&nbsp;":docAddr4 %><hr/></td>
				</tr>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" colspan=3><b><bean:message key="prompt.docHomeAddr" /></b></td>
				</tr>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" colspan=3><%=homeAddr1==null||"".equals(homeAddr1)?"&nbsp;":homeAddr1 %><%=homeAddr2==null||"".equals(homeAddr2)?"&nbsp;":", " %><%=homeAddr2==null||"".equals(homeAddr2)?"&nbsp;":homeAddr2 %><%=homeAddr3==null||"".equals(homeAddr3)?"&nbsp;":", " %><%=homeAddr3==null||"".equals(homeAddr3)?"&nbsp;":homeAddr3 %><%=homeAddr4==null||"".equals(homeAddr4)?"&nbsp;":", " %><%=homeAddr4==null||"".equals(homeAddr4)?"&nbsp;":homeAddr4 %><hr/></td>
				</tr>
			</table>
			<table border="0" cellpadding="0" cellspacing="0" width=100%>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="33%"><b><bean:message key="prompt.docOfficeTel" /></b></td>
					<td class="infoDataNoraml" align="left" width="33%"><b><bean:message key="prompt.docOfficeFax" /></b></td>
					<td class="infoDataNoraml" align="left" width="34%"><b><bean:message key="prompt.docEmail" /></b></td>
				</tr>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="33%"><%=officeTel==null||"".equals(officeTel)?"&nbsp;":officeTel %><hr/></td>
					<td class="infoDataNoraml" align="left" width="33%"><%=officeFax==null||"".equals(officeFax)?"&nbsp;":officeFax %><hr/></td>
					<td class="infoDataNoraml" align="left" width="34%"><%=email==null||"".equals(email)?"&nbsp;":email %><hr/></td>
				</tr>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="33%"><b><bean:message key="prompt.docPager" /></b></td>
					<td class="infoDataNoraml" align="left" width="33%"><b><bean:message key="prompt.docMobile" /></b></td>
					<td class="infoDataNoraml" align="left" width="34%"><b><bean:message key="prompt.docHomeTel" /></b></td>
				</tr>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="33%"><%=pager==null||"".equals(pager)?"&nbsp;":pager %><hr/></td>
					<td class="infoDataNoraml" align="left" width="33%"><%=mobile==null||"".equals(mobile)?"&nbsp;":mobile %><hr/></td>
					<td class="infoDataNoraml" align="left" width="34%"><%=homeTel==null||"".equals(homeTel)?"&nbsp;":homeTel %><hr/></td>
				</tr>
				<tr><td colspan=3><hr align="right" size="2" width="100%" noshade="noshade"/></td></tr>
			</table>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td class="infoLabelNormal" width="20%"><bean:message key="prompt.renewform3" /></td>
		<td width="80%">
			<table border="0" cellpadding="0" cellspacing="0" width=100%>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" colspan=2>
						Specialty Privilege(s):<u><%=specName==null?"":specName %></u>
					</td>
				</tr>
<!--
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="60%">
					Any Changes Requested
<%if ("Y".equals(withAttach)) {%>
					<input type="checkbox" name="checkBoxAT1" value="Y" id="checkBoxAT1" checked="checked" disabled="disabled"/>
					<label for="radioStatus"><bean:message key="label.yes" /></label>
					<input type="checkbox" name="checkBoxAT2" value="N" id="checkBoxAT2" disabled="disabled"/>
					<label for="radioStatus"><bean:message key="label.no" /></label>
<%}else { %>
					<input type="checkbox" name="checkBoxAT1" value="N" id="checkBoxAT1" disabled="disabled"/>
					<label for="radioStatus"><bean:message key="label.yes" /></label>
					<input type="checkbox" name="checkBoxAT2" value="Y" id="checkBoxAT2" checked="checked" disabled="disabled" />
					<label for="radioStatus"><bean:message key="label.no" /></label>
<%} %>
					</td>
					<td class=infoDataNoraml valign="bottom" align="left" width="40%">
						If YES, attach document action of training or experience<br>
					</td>
				</tr>
 -->
				<tr><td colspan=2><hr align="right" size="2" width="100%" noshade="noshade"/></td></tr>
			</table>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0" width=100%>
	<tr class="smallText">
		<td class="infoLabelNormal" width="20%"><bean:message key="prompt.renewform4" /></td>
		<td width="80%">
			<table border="0" cellpadding="0" cellspacing="0" width=100%>
			<tr><td>
<%
	String radioKey = null;
	String radioValue = null;
%>
			<display:table id="row" name="requestScope.CTS" export="false" class="tablesorter">
				<display:column property="fields1" title="&nbsp;" style="width:85%" />
				<display:column title="&nbsp;" style="width:15%" >
				<logic:equal name="row" property="fields2" value="Y">
					<input type="radio" name="radio<c:out value="${row.fields0}" />" value="Y" checked="checked" disabled="disabled">Yes</input>
					<input type="radio" name="radio<c:out value="${row.fields0}" />" value="N" disabled="disabled">No</input>
				</logic:equal>
				<logic:equal name="row" property="fields2" value="N">
					<input type="radio" name="radio<c:out value="${row.fields0}" />" value="Y" disabled="disabled">Yes</input>
					<input type="radio" name="radio<c:out value="${row.fields0}" />" value="N" checked="checked" disabled="disabled">No</input>
				</logic:equal>
				</display:column>
			</display:table>
			</td></tr>
			<tr>
				<td colspan=2>
				<%if (answer9!=null && answer9.length()>0) { %>
				<textarea name='ans<%=supportAnswerDetail2 %>' rows='5' cols='100' align='left'><%=answer9==null?"":answer9 %></textarea>
				<%}else{ %>
				&nbsp;
				<%} %>
				</td>
			</tr>
			<tr><td colspan=2><hr align="right" size="2" width="100%" noshade="noshade"/></td></tr>
			</table>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td class="infoLabelNormal" width="20%"><bean:message key="prompt.renewform5" /></td>
		<td width="80%">
			<table border="0" cellpadding="0" cellspacing="0" width=100%>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="50%" colspan=2>
						<b>Personal Health Status (Including Alcohol & Drug Dependence)</b><br>
						&nbsp;<br>
						<i>
						Please declare whether you have a physical or mental health condition, including alcohol or drug dependence,
						that affects or likely to affect your ability to perform professional or medical staff duties appropriately in the Hospital.
						</i>
					</td>

				</tr>
<%if (healthStatus!=null && healthStatus.length() > 0) { %>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="10%">
						<input type="checkbox" name="checkBoxH1" value="Y" id="checkboxY" checked="checked" disabled="disabled"/>
						<label for="checkBoxH1"><bean:message key="label.yes" /></label>
					</td>
					<td align="left" width="90%">
						<textarea class="infoLabe2" name="healthStatus" rows="3" cols="100" valign="top" align="left" readonly="readonly"><%=healthStatus==null?"":healthStatus %></textarea>
					</td>
				</tr>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="50%" colspan=2>
						<input type="checkbox" name="checkBoxH2" value="N" id="checkboxN" disabled="disabled"/>
						<label for="checkBoxH2"><bean:message key="label.nothingDeclare" /></label>
					</td>
				</tr>
<%}else { %>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="10%">
						<input type="checkbox" name="checkBoxH1" value="N" id="checkboxY" disabled="disabled"/>
						<label for="checkBoxH1"><bean:message key="label.yes" /></label>
					</td>
					<td align="left" width="90%">
						<textarea class="infoLabe2" name="healthStatus" rows="3" cols="100" align="left" disabled="disabled"><%=healthStatus==null?"":healthStatus %></textarea>
					</td>
				</tr>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" colspan=2>
						<input type="checkbox" name="checkBoxH2" value="Y" id="checkboxN" checked="checked" disabled="disabled"/>
						<label for="checkBoxH2"><bean:message key="label.nothingDeclare" /></label>
					</td>
				</tr>
<%} %>
			<tr><td colspan=2><hr align="right" size="2" width="100%" noshade="noshade"/></td></tr>
			</table>
		</td>
		<td></td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td class="infoLabelNormal" width="20%"><bean:message key="prompt.renewform12" /></td>
		<td width="80%">
			<table border="0" cellpadding="0" cellspacing="0" width=100%>
				<tr class="smallText">
					<td class="infoDataNoraml" width="30%" rowspan=2><bean:message key="prompt.HKMC" /></td>
					<td class="infoDataNoraml" align="left" width="35%">
						<input type="text" name="licNo" value="<%=licNo==null?"":licNo %>" maxlength="30" size="50" readonly="readonly"/>
					</td>
					<td class="infoDataNoraml" width="35%">
						<input type="text" name="licExpDate" id="licExpDate" value="<%=licExpDate==null?"":licExpDate %>" maxlength="20" size="20" readonly="readonly"/>
					</td>
				</tr>
				<tr class="smallText">
					<td align="left"><bean:message key="prompt.licNo" /></td>
					<td align="left"><bean:message key="prompt.expiryDateDmy" /></td>
				</tr>
				<tr class="smallText">
					<td class="infoDataNoraml" width="30%" rowspan=2><bean:message key="prompt.MICD" /></td>
					<td class="infoDataNoraml" align="left" width="35%">
						<input type="text" name="insureCarr" value="<%=insureCarr==null?"":insureCarr %>" maxlength="30" size="50" readonly="readonly"/>
					</td>
					<td class="infoDataNoraml" width="35%">
						<input type="text" name="lnsExpDate" id="lnsExpDate" value="<%=lnsExpDate==null?"":lnsExpDate %>" maxlength="20" size="20" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td align="left"><bean:message key="prompt.insCarrier" /></td>
					<td align="left"><bean:message key="prompt.expiryDateDmy" /></td>
				</tr>
				<tr><td colspan=3><hr align="right" size="2" width="100%" noshade="noshade"/></td></tr>
			</table>
		</td>
	</tr>
</table>
<%if ("hkah".equals(siteCode)) {%>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td class="infoLabelNormal" width="20%"><bean:message key="prompt.attachDoc" /></td>
		<td width="80%">
			<table border="0" cellpadding="0" cellspacing="0" width=100%>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" colspan=2>
			<span id="showDocument_indicator">
				<%String keyId = folderId == null ? "" : folderId; %>
				<jsp:include page="../common/document_list.jsp" flush="false">
					<jsp:param name="moduleCode" value="cts" />
					<jsp:param name="keyID" value="<%=keyId %>" />
					<jsp:param name="allowRemove" value="N" />
				</jsp:include>
			</span>
					</td>
				</tr>
				<tr><td colspan=2><hr align="right" size="2" width="100%" noshade="noshade"/></td></tr>
			</table>
		</td>
	</tr>
</table>
<%}%>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td class="infoLabelNormal" width="20%"><bean:message key="prompt.renewform7" /></td>
		<td width="80%">
			<table border="0" cellpadding="0" cellspacing="0" width=100%>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="50%" colspan=2>
						<i>I fully understand that any significant mis-statements in or omissions from this application constitute cause
						for denial of appointment or cause for summary dismissal from the medical/dental staff.
						All information submitted by me in this application is true to my best knowledge and belief.<br>
						<br>In making this application for reappointment to the medical/dental staff of this hospital,
						I acknowledge that I have received and read the by-laws, rules and regulations of the medical staff of this hospital, and code of practice of the Private Hospitals Association (PHA).
						I further agree to abide by such hospital and staff rules and regulations and code of practice of PHA as may be from time to time enacted.  Failure to follow the rules and regulations and code of practice may jeopardize my admitting privileges.<br>
						<br>I understand and agree that I, as an applicant for medical/dental staff membership, have the burden of producing adequate information for proper evaluation of my professional competence, character, ethics and other qualifications and for resolving any doubts about such qualifications.</i><br>
						<br><input type=checkbox name="acceptAgr" value="" checked="checked" disabled="disabled"/>&nbsp;<b>I hereby accept the above statement of agreement.</b>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br><br><br><br><br><br>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
<%if ("hkah".equals(siteCode)) {%>
		<td align="right">Submitted to Hong Kong Adventist Hospital - Stubbs Road on :&nbsp;<u><%=sysDate %></u></td>
<%}else if ("twah".equals(siteCode)) {%>
		<td align="right">Submitted to Hong Kong Adventist Hospital - Tsuen Wan on :&nbsp;<u><%=sysDate %></u></td>
<%}%>
	</tr>
</table>
<!--
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td class="infoLabelNormal" width="20%"><bean:message key="prompt.renewform7" /></td>
		<td width="80%">
			<i>I fully understand that any significant mis-statements in or omissions from this application constitute cause for
			denial of appointment or cause for summary dismissal from the medical/dental staff. All information submitted by
			me in this application is true to my best knowledge and belief.<br/>
			&nbsp;<br/>
			In making this application for reappointment to the medical/dental staff of this hospital, I acknowledge that I have
			received and read the by-laws, rules and regulations of the medical staff of this hospital, and code of practice of
			the Private Hospitals Association (PHA). I further agree to abide by such hospital and staff rules and regulations
			and code of practice of PHA as may be from time to time enacted. Failure to follow the rules and regulations and
			code of practice may jeopardize my admitting privileges.<br/>
			&nbsp;<br/>
			I understand and agree that I, as an applicant for medical/dental staff membership, have the burden of producing
			adequate information for proper evaluation of my professional competence, character, ethics and other
			qualifications and for resolving and doubts and about such qualifications.</i>
			<br/>
			<br/>
			<br/>
			<br/>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td class="infoLabelNormal" width="20%"><bean:message key="prompt.renewform8" /></td>
		<td width="80%">
			<table border="0" cellpadding="0" cellspacing="0" width=100%>
				<tr><td colspan=3>&nbsp;</td></tr>
				<tr class="smallText">
					<td width="55%"><hr align="left"/></td>
					<td width="20%">&nbsp;</td>
					<td width="25%"><hr align="right"/></td>
				</tr>
				<tr class="smallText">
					<td width="55%" align=center>Signature</td>
					<td width="20%">&nbsp;</td>
					<td width="25%" align=center>Date</td>
				</tr>
				<tr>
					<td colspan=3>&nbsp;</td>
				</tr>
				<tr>
					<td colspan=3>&nbsp;</td>
				</tr>
				<tr>
					<td colspan=3>&nbsp;</td>
				</tr>
				<tr><td colspan=3><hr align="right" size="2" width="100%" noshade="noshade"/></td></tr>
			</table>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td class="infoLabelNormal" width="20%"><bean:message key="prompt.renewform9" /></td>
		<td width="80%">
			<table border="0" cellpadding="0" cellspacing="0" width=100%>
				<tr class="smallText">
					<td align=center>
						<b>Approval Signatures</b>
					</td>
				</tr>
				<tr class="smallText">
					<td align=center>
						<i>(for office use only)</i>
					</td>
				</tr>
				<tr class="smallText">
					<td class="infoDataNoraml" align="left" width="50%" colspan=2>
						<table border="2" rules=none frame=box cellpadding="0" cellspacing="0" width=100%>
							<tr><td colspan=2>&nbsp;</td></tr>
							<tr class="smallText">
								<td>Special Procedures Approval</td>
								<td>Date</td>
							</tr>
							<tr><td colspan=2><hr align="right" size="1" width="100%" noshade="noshade"/></td></tr>
							<tr><td colspan=2>&nbsp;</td></tr>
							<tr><td colspan=2><hr align="right" size="1" width="100%" noshade="noshade"/></td></tr>
							<tr class="smallText">
								<td>Medical Staff</td>
								<td>Date</td>
							</tr>
							<tr><td colspan=2>&nbsp;</td></tr>
							<tr><td colspan=2><hr align="right" size="1" width="100%" noshade="noshade"/></td></tr>
							<tr class="smallText">
								<td>Hospital Board</td>
								<td>Date</td>
							</tr>
							<tr><td colspan=2>&nbsp;</td></tr>
							<tr><td colspan=2>&nbsp;</td></tr>
							<tr><td colspan=2>&nbsp;</td></tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
 -->
<br /><br /><br />
<div class="pane">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td align="center">
<!--
		<%if (!"submit".equals(command)) { %>
			<button class="btn-submit" onclick="backAction();return false;">Modify</button>
			<button class="btn-submit" onclick="submitAction();return false;">Confirm&Print</button>
		<%}%>
 -->
		<button class="btn-submit" onclick="printScreen();return false;">Print</button>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command" value="<%=command==null?"":command %>" />
<input type="hidden" name="docCode" value="<%=docCode==null?"":docCode %>" />
<input type="hidden" name="ctsNo" value="<%=ctsNo==null?"":ctsNo %>" />
<!--
<input type="hidden" name="docfName" value="<%=docfName==null?"":docfName %>" />
<input type="hidden" name="docgName" value="<%=docgName==null?"":docgName %>" />
<input type="hidden" name="idNo" value="<%=idNo==null?"":idNo %>" />
<input type="hidden" name="docAddr1" value="<%=docAddr1==null?"":docAddr1 %>" />
<input type="hidden" name="docAddr2" value="<%=docAddr2==null?"":docAddr2 %>" />
<input type="hidden" name="docAddr3" value="<%=docAddr3==null?"":docAddr3 %>" />
<input type="hidden" name="docAddr4" value="<%=docAddr4==null?"":docAddr4 %>" />
<input type="hidden" name="homeAddr1" value="<%=homeAddr1==null?"":homeAddr1 %>" />
<input type="hidden" name="homeAddr2" value="<%=homeAddr2==null?"":homeAddr2 %>" />
<input type="hidden" name="homeAddr3" value="<%=homeAddr3==null?"":homeAddr3 %>" />
<input type="hidden" name="homeAddr4" value="<%=homeAddr4==null?"":homeAddr4 %>" />
<input type="hidden" name="officeTel" value="<%=officeTel==null?"":officeTel %>" />
<input type="hidden" name="officeFax" value="<%=officeFax==null?"":officeFax %>" />
<input type="hidden" name="email" value="<%=email==null?"":email %>" />
<input type="hidden" name="pager" value="<%=pager==null?"":pager %>" />
<input type="hidden" name="mobile" value="<%=mobile==null?"":mobile %>" />
<input type="hidden" name="homeTel" value="<%=homeTel==null?"":homeTel %>" />
<input type="hidden" name="healthStatus" value="<%=healthStatus==null?"":healthStatus %>" />
<input type="hidden" name="speciality" value="<%=speciality==null?"":speciality %>" />

<%
if (fileList != null && fileList.length > 0) {
		for (int i = 0; i < fileList.length; i++) {
%><input type="hidden" name="client.filelist" value="<%=folderId + ConstantsVariable.UNDERSCORE_VALUE + fileList[i] %>" />
<%
		}
	}
%>
-->
</form>
<script language="javascript">
	function backAction() {
		history.back();
	}

	function loadAlert() {
		var alertMsg = 'Thank you for your submission.<br>You will be informed the outcome once approved.<br>It is suggested that you print the form for your records.<br>Should you have any queries, please feel free to contact us at<br><br>';
<%	if ("twah".equals(siteCode)) {%>
		alertMsg = alertMsg + '(852)2276&ndash;6711/<br>carmen.ng@twah.org.hk';
<%	} else {%>
		alertMsg = alertMsg + '(852)2835&ndash;0581/<br>medicalaffairs@hkah.org.hk';
<%	}%>
		$.prompt(alertMsg,{prefix:'cleanblue'});

		return false;
	}

	function returnAlert() {
		$.prompt('Renewal submitted and sent',{prefix:'cleanblue'});
	}

	function submitAction() {
		var msg = 'Before submitting this form through intranet, please print the copy with your signature and return it Medical Affairs Office, Hong Kong Adventist Hospital - ';

<%	if ("hkah".equals(siteCode)) {%>
			msg = msg + 'Stubbs Road, 40 Stubbs Road, HK';
<%	} else if ("twah".equals(siteCode)) {%>
			msg = msg + 'Tsuen Wan, 199 Tsuen King Circuit, Tsuen Wan, New Territories';
<%	}%>
		$.prompt(msg,{
			buttons: { Ok: true, Cancel: false },
			callback: function(v,m,f) {
				if (v) {
					var OLECMDID = 7;
					// OLECMDID values:
					//* 6 - print
					//* 7 - print preview
					//* 1 - open window
					//* 4 - Save As
					var PROMPT = 1; // 2 DONTPROMPTUSER
					var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=10 HEIGHT=10 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
//					document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
					WebBrowser1.ExecWB(OLECMDID, PROMPT);
					WebBrowser1.outerHTML = "";

 					submit: confirmAction();

					return true;
				} else {
					return false;
				}
			},
			prefix:'cleanblue'
		});
	}

	function printScreen() {
//		WebBrowser1.ExecWB(6, 1);
		window.print();
	}

	function confirmAction() {
//		document.form1.command.value = 'submit';
		document.form1.submit();
	}

<%if ("submit".equals(command)) {
//	if (CTS.updateCtsRecord(userBean, ctsNo, "R", null, null, null)) {
%>
	returnAlert();
<%
//	}
}
%>
</script>
</DIV>
</DIV></DIV>
<!--
<OBJECT ID="WebBrowser1" WIDTH=10 HEIGHT=10 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>
 -->
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>