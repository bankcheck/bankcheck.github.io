<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
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

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request,"step");
String infoCategory = ParserUtil.getParameter(request,"infoCategory");
String infoDesc = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "infoDesc"));
String infoLink = ParserUtil.getParameter(request,"infoLink");
String infoID = ParserUtil.getParameter(request,"infoID");
String infoDate = ParserUtil.getParameter(request,"infoDate");
String survImage = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "survImage"));
String prevSurvImage = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "prevSurvImage"));
String infoName = infoCategory;

if (ConstantsServerSide.isHKAH()) {
	if ("Information".equals(infoCategory)) {
		infoName = "Alert";
	} else if ("Disease".equals(infoCategory)) {
		infoName = "News";
	} 
}
boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}else if ("cancel".equals(command)){%>
	<script type="text/javascript">window.close();</script>
<%}
if (fileUpload) {
	if (createAction && "1".equals(step)) {
		// get news id with dummy data
		infoID = ICPageDB.add(userBean, infoCategory);
	}

	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("Infection Control");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("Surveilance_corner");
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		for (int i = 0; i < fileList.length; i++) {

			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + fileList[i]
			);

			// skip newsTitleImage
			if (!fileList[i].equals(survImage)) {
				tempStrBuffer.append("<a href=\"");
				tempStrBuffer.append("/upload/");
				tempStrBuffer.append("Infection Control");
				tempStrBuffer.append("/");
				tempStrBuffer.append("Surveilance_corner");
				tempStrBuffer.append("/");
				tempStrBuffer.append(fileList[i]);
				tempStrBuffer.append("\">");
				tempStrBuffer.append(fileList[i]);
				tempStrBuffer.append("</a><BR>");
			}
			
			infoDesc = fileList[i];

		}
	}
}

try{
	if ("1".equals(step)) {
		if (createAction) {
			if(infoID == null || infoID == ""){
				infoID = ICPageDB.add(userBean,infoCategory);				
			}
			if(ICPageDB.update(userBean,infoID,infoCategory,infoDesc,infoDate,infoLink)){
				message = infoName+" created.";
				createAction = false;
			}else {
				errorMessage = infoName+" create fail.";
			}
			
		} else if (updateAction) {
			if("Surveilance".equals(infoCategory)){
				if (infoDesc ==  null && prevSurvImage != null && prevSurvImage.length() > 0) {
					infoDesc = prevSurvImage;
				}
			}
			if(ICPageDB.update(userBean,infoID,infoCategory,infoDesc,infoDate,infoLink)){
				message = infoName+" updated.";
				updateAction = false;
			}else {
				errorMessage = infoName+" update fail.";
			}
		} else if (deleteAction) {
			
			if(ICPageDB.delete(userBean,infoID)){
				message = "Information deleted.";
				updateAction = false;
				%><script type="text/javascript">window.close();</script><%
			}else {
				errorMessage = "Information deleted fail.";
			}
			
		}
		step = null;
	}
		
	if (!createAction && !"1".equals(step)) {
		if (infoID != null && infoID.length() > 0) {
			ArrayList record = ICPageDB.get(infoID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				infoCategory = row.getValue(0);
				infoDesc = row.getValue(1);
				infoLink = row.getValue(2);
				infoDate = row.getValue(3);
				survImage = row.getValue(1);
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
	
} catch (Exception e) {
	e.printStackTrace();
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
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
%>
<table border=0 cellspacing=0 cellpadding=0 width="100%">
<tr>
	<td align="center" style="padding:3px;">
	<img src="../images/ic/icTitle.jpg" width="800" height="120" border="0"/>
	</td>
</tr>
</table>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="" />
	<jsp:param name="suffix" value="_4"/>
	<jsp:param name="pageMap" value="N"/>
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" id="form1" enctype="multipart/form-data" action="webinfo_content.jsp" method="post">

<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.category" /></td>
		<td class="infoData" width="70%">
<%		if (createAction || updateAction) { %>
			<select name="infoCategory" id="infoCategory">
			<option value="Calendar" <%="Calendar".equals(infoCategory)?" selected":"" %>>Calendar</option>	
			<%if (ConstantsServerSide.isTWAH()) {%>	
				<option value="Calendar" <%="Calendar".equals(infoCategory)?" selected":"" %>>Calendar</option>	
				<option value="News" <%="News".equals(infoCategory)?" selected":"" %>>News</option>
				<option value="Hot" <%="Hot".equals(infoCategory)?" selected":"" %>>Hot Search</option>
				<option value="notification" <%="notification".equals(infoCategory)?" selected":"" %>>Notification</option>		
				<option value="Disease" <%="Disease".equals(infoCategory)?" selected":"" %>>Infectious Disease</option>
				<option value="Surveilance" <%="Surveilance".equals(infoCategory)?" selected":"" %>>Surveilance</option>
				<option value="notification" <%="notification".equals(infoCategory)?" selected":"" %>>Notification</option>
			<%} else { %>
				<option value="Calendar" <%="Calendar".equals(infoCategory)?" selected":"" %>>Calendar</option>	
				<option value="Information" <%="Information".equals(infoCategory)?" selected":"" %>>Alert</option>
				<option value="Disease" <%="Disease".equals(infoCategory)?" selected":"" %>>News Update</option>
				<option value="Isolation" <%="Isolation".equals(infoCategory)?" selected":"" %>>Isolation</option>		
		
			<%} %>		
			</select>
<%		} else { %>
			<%=infoCategory==null?"":infoName.toUpperCase() %>
<%		} %>
		</td>
	</tr>
<% if(!"Surveilance".equals(infoCategory)){ %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%=infoCategory==null?"":infoName %> Description</td>
		<td class="infoData" width="70%">
		<%	if (createAction || updateAction) { %>
			<input type="textfield" name="infoDesc" value="<%=infoDesc==null?"":infoDesc %>" maxlength="100" size="80">
		<%	} else { %>
					<%=infoDesc==null?"":infoDesc %>
		<%	} %>
		</td>
	</tr>
<%	} %>
<% if(!("Hot".equals(infoCategory))&& !("Disease".equals(infoCategory))&&!"Surveilance".equals(infoCategory)&&!("notification".equals(infoCategory))){ %>	
	<tr class="smallText">
		<td class="infoLabel" width="30%"><%=infoCategory==null?"":infoName %> Date</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) { %>
			<input type="textfield" name="infoDate" id="infoDate" class="datepickerfield" value="<%=infoDate==null?"":infoDate %>" maxlength="16" size="16">
		</td>
<%	} else { %>
			<%=infoDate==null?"N/A":infoDate %>
<%	} %>
	</tr>	
<%} %>
<% if(("Surveilance".equals(infoCategory))){ %>	
	<tr class="smallText">
		<td class="infoLabel" width="30%">Image</td>
		<td class="infoData" width="70%">
		<%	if (createAction || updateAction) { %>
			<input type="file" name="survImage" size="50" class="multi" maxlength="1">
		<%	} 
			if (!createAction){ %>
			<img src="/upload/Infection Control/Surveilance_corner/<%=survImage %>">
		<%	} %>
		</td>
	</tr>		
<%} %>	
<% if(!("Calendar".equals(infoCategory))&&!("notification".equals(infoCategory))){ %>	
	<tr class="smallText">
		<td class="infoLabel" width="30%">Link</td>
		<td class="infoData" width="70%">
		<%	if (createAction || updateAction) { %>
			<input type="textfield" name="infoLink" value="<%=infoLink==null?"":infoLink %>" maxlength="100" size="80">
		<%	} else { %>
					<%=infoLink==null?"":infoLink %>
		<%	} %>
		</td>
	</tr>	
<%} %>	
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <%=infoCategory==null?"":infoName %></button>
			<button onclick="return submitAction('cancel', 0);" class="btn-click"><bean:message key="button.cancel" /> - <%=infoCategory==null?"":infoName %></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click">Update - <%=infoCategory==null?"":infoName %></button>
			<button class="btn-delete">Delete  - <%=infoCategory==null?"":infoName %></button>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command"/>
<input type="hidden" name="step"/>
<input type="hidden" name="prevSurvImage" value="<%=survImage==null?"":survImage %>">
<input type="hidden" name="infoID" value="<%=infoID==null?"":infoID %>"/>
</form>
<script language="javascript">

$("select#infoCategory").change(function(){ 
	window.open ('webinfo_content.jsp?infoCategory='+$(this).val()+'&command=create','_self',false)
});
	function submitAction(cmd, stp) {

		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
</script>
</DIV></DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>