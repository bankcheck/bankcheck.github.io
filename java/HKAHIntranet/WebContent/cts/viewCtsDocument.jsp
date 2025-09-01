<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%!
	public String showFile(File f, String dirName,String fileName){
		
			StringBuffer outputUrl = new StringBuffer();
			outputUrl.append("<ul>");
			if(!f.isDirectory()){
				outputUrl.append("<li><a href=\"../documentManage/download.jsp?locationPath=" + dirName.replace("\\", "/") + "/" + fileName + "&dispositionType=inline&intranetPathYN=Y\" target=\"_blank\"><H1 id=\"TS\">"+fileName+"</H1></a>");
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
					outputUrl.append("<a href=\"../documentManage/download.jsp?locationPath=" + dirName.replace("\\", "/") + "/" + s[i] + "&dispositionType=inline&intranetPathYN=Y\" target=\"_blank\"><H1 id=\"TS\">"+s[i]+"</H1></a>");
					outputUrl.append("</li>");
				}else{
					outputUrl.append("<li><details><summary><H1 style=\"color: black;\" id=\"TS\">"+s[i]+"</H1></summary>");
					outputUrl.append(showDirectory(file,dirName+"/"+s[i]));
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
UserBean userBean = new UserBean(request);

String docCode = request.getParameter("docCode");
String siteCode = ConstantsServerSide.SITE_CODE;
String docName = null;
String ctsNo = null;
String ctsArchiveFile = null;
String dirName = null;
String docSmtDate;

String message = request.getParameter("message");
if (message == null) {
	message = "";	
}
String errorMessage = "";

if (docCode != null) {
	ArrayList record = DoctorDB.getHATSDoctor(docCode);
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		docName = row.getValue(0) + ", " + row.getValue(1);
		ctsArchiveFile = row.getValue(2);
	}
}

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
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Doctor Credential Document" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" method="post"  action="viewCtsDocument.jsp" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="label.find.doctor" /></td>
		<td class="infoData" width="80%">
			<input type="textfield" name="docCode" id="docCode" value="<%=docCode==null?"":docCode %>" maxlength="10" size="10" >
			<%=docName==null?"":docName %>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button type="submit"><bean:message key="button.search" /></button>
		</td>
	</tr>
</table>
</form>



	<hr noshade="noshade"/>
	
	<table cellpadding="10" cellspacing="10" border="0" width = "100%">
<% 
	if (ctsArchiveFile != null) {
		if (!ctsArchiveFile.isEmpty()) {
%>	
	<tr class="bigText">
		<td align="left" width="50%">CTS Archive Record</td>	
		<td width="50%"><ul><li><a href="../documentManage/download.jsp?locationPath=<%=ctsArchiveFile %>&dispositionType=inline&intranetPathYN=Y" target=\"_blank\"><H1 id="TS">View Document</H1></a></li></ul></td>
		<td align="left"></td>
	</tr>
<%
		}
    }
		
	if (docCode != null) {
		
		if ("hkah".equals(siteCode)) {
			dirName = "\\\\hkim\\im\\VPMA\\Credential Renew Document\\"+docCode;
			//dirName = "\\\\160.100.3.29\\moxa\\"+docCode+"-"+docSmtDate;
		}else if ("twah".equals(siteCode)) {
			dirName = "\\\\it-fs1\\dept\\VPMA\\Credential renew document\\"+docCode;
		}else{
			dirName = "\\\\hkim\\im\\VPMA\\Credential Renew Document\\"+docCode;	
		}
		
		File fd = new File(dirName);
		
		if (fd.isDirectory()) {
	   		String s[] = fd.list();
	   		
	   		for (int j=0; j < s.length; j++) {
	      		File f = new File(dirName + "/" + s[j]);
	      		if(!f.isHidden()) {
%>
<tr class="bigText">
<td align="left" width="50%">Supplementary Document</td>		
<td width="50%"><%=showFile(f, dirName, s[j])%></td>
<td align="left"></td>
</tr>
<%	
				}	
			}
		}
		
		ArrayList record = CTS.getRecord(docCode, null, null, null, null);
		if (record.size() > 0) {
			
			for (int i = 0; i < record.size(); i++) {
				
				ReportableListObject row = (ReportableListObject) record.get(i);
								
				ctsNo = row.getValue(0);
				System.out.println("cts:" + ctsNo);
				docSmtDate = CTS.getDocSmtDate(ctsNo);
				
				if ("hkah".equals(siteCode)) {
					dirName = "\\\\hkim\\im\\VPMA\\Credential Renew Document\\"+docCode+"-"+docSmtDate;
				}else if ("twah".equals(siteCode)) {
					dirName = "\\\\it-fs1\\dept\\VPMA\\Credential renew document\\"+docCode+"-"+docSmtDate;
				}else{
					dirName = "\\\\hkim\\im\\VPMA\\Credential Renew Document\\"+docCode+"-"+docSmtDate;	
				}
				
				File f1 = new File(dirName);
				
				if (f1.isDirectory()) {
			   		String s[] = f1.list();
			   		
			   		for (int j=0; j < s.length; j++) {
			      		File f = new File(dirName + "/" + s[j]);
			      		if(!f.isHidden()) {
%>
	<tr class="bigText">
		<td align="left" width="50%"><%=docCode+"-"+docSmtDate %></td>		
		<td width="50%"><%=showFile(f, dirName, s[j])%></td>
		<td align="left"></td>
	</tr>
<%				
						}	
					}
				}
			}
		}
	}
%>
</table>
</DIV>
</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>