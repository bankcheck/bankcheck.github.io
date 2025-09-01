<%@ page import="java.io.File"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%!
public static ArrayList getClientInfo(String clientID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT C.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME,C.CRM_USERNAME ");
	sqlStr.append("FROM   CRM_CLIENTS C ");	
	sqlStr.append("WHERE  C.CRM_CLIENT_ID = '"+clientID+"' ");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static boolean deleteDocument(
		UserBean userBean, String clientID, String documentID) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("UPDATE CRM_CLIENTS_PROGRESS_DOCUMENT ");
	sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER =  '"+userBean.getLoginID()+"' ");
	sqlStr.append("WHERE  CRM_CLIENT_ID = '"+clientID+"' AND CRM_DOCUMENT_ID = '"+documentID+"' ");
	
	return	UtilDBWeb.updateQueue(sqlStr.toString());
}


public static ArrayList<ReportableListObject> getDocuments(String clientID) {
	// fetch document
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT CD.CRM_DOCUMENT_ID, D.CO_DESCRIPTION ");
	sqlStr.append("FROM   CRM_CLIENTS_PROGRESS_DOCUMENT CD, CO_DOCUMENT D ");
	sqlStr.append("WHERE  CD.CRM_DOCUMENT_ID = D.CO_DOCUMENT_ID ");
	sqlStr.append("AND    CD.CRM_ENABLED = 1 ");	
	sqlStr.append("AND    CD.CRM_CLIENT_ID = ? ");
	sqlStr.append("ORDER BY D.CO_DESCRIPTION");
	
	return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID });
}

public static boolean addDocument(
		UserBean userBean, String clientID, String documentID) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT 1 FROM CRM_CLIENTS_PROGRESS_DOCUMENT WHERE CRM_CLIENT_ID = ? AND CRM_DOCUMENT_ID = ?");	
	if (UtilDBWeb.isExist(sqlStr.toString(), new String[] { clientID, documentID })) {
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_CLIENTS_PROGRESS_DOCUMENT SET CRM_ENABLED = 1, ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = ? AND CRM_DOCUMENT_ID = ?");

		return UtilDBWeb.updateQueue(
			sqlStr.toString(),
			new String[] { userBean.getLoginID(), clientID, documentID} );
	} else {		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CRM_CLIENTS_PROGRESS_DOCUMENT (");
		sqlStr.append("CRM_CLIENT_ID, CRM_DOCUMENT_ID, ");
		sqlStr.append("CRM_CREATED_USER, CRM_MODIFIED_USER) ");
		sqlStr.append("VALUES (?, ?, ?, ?)");		
		return UtilDBWeb.updateQueue(
			sqlStr.toString(),
			new String[] { clientID, documentID, userBean.getLoginID(), userBean.getLoginID() });
	}	
}

private void addUploadedFile(HttpServletRequest request, UserBean userBean, String clientID) {
	String documentSubPath = "Intranet" + File.separator + "Portal" + File.separator + "Documents" + File.separator;
	
	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("CRM");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("progress_note_doc");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(clientID);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("upload");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("CRM");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("progress_note_doc");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(clientID);
		tempStrBuffer.append(File.separator);
		String webUrl = tempStrBuffer.toString();

		for (int i = 0; i < fileList.length; i++) {
			String documentID = DocumentDB.add(userBean, fileList[i], webUrl + fileList[i], null);
			if (documentID != null) {
				FileUtil.moveFile(
					ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
					baseUrl + documentID + File.separator + fileList[i]
				);
			
				DocumentDB.update(documentID, fileList[i], webUrl + documentID + File.separator + fileList[i],
						true, true, null, null, userBean);
				addDocument(userBean, clientID, documentID);
			}
		}
	}
}

private ArrayList getCRMClientLevel(String clientID) {			
	return  UtilDBWeb.getReportableList("SELECT CRM_NS_LEVEL FROM CRM_CLIENTS_NEWSTART WHERE CRM_CLIENT_ID = "+clientID+" AND CRM_NS_LEVEL IS NOT NULL ");
			
}

private boolean updateClientNEWSTARTLevel(String clientID,String updateUser,String level){
	StringBuffer sqlStr = new StringBuffer();
	if(isClientLevelExist(clientID)){			
		sqlStr.append("UPDATE CRM_CLIENTS_NEWSTART ");
		sqlStr.append("SET    CRM_NS_LEVEL = '"+level+"', ");		
		sqlStr.append("CRM_NS_MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("CRM_NS_MODIFIED_USER = '"+updateUser+"' ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = '"+clientID+"' ");
		sqlStr.append("AND    CRM_NS_LEVEL IS NOT NULL ");
	}else{			
		sqlStr.append("INSERT INTO CRM_CLIENTS_NEWSTART(CRM_NS_ID, CRM_CLIENT_ID,CRM_NS_CREATED_USER,CRM_NS_MODIFIED_USER,CRM_NS_ENABLED,CRM_NS_LEVEL) ");
		sqlStr.append("VALUES ("+ getNextNSID()+",'"+clientID+"','"+updateUser+"','"+updateUser+"',1,'"+level+"') ");		
	
	}
	
	return UtilDBWeb.updateQueue(sqlStr.toString()) ;
}

private boolean isClientLevelExist(String clientID) {
	if (clientID != null && clientID.length() > 0) {
		return UtilDBWeb.isExist("SELECT CRM_CLIENT_ID FROM CRM_CLIENTS_NEWSTART WHERE CRM_CLIENT_ID = ? AND CRM_NS_LEVEL IS NOT NULL", new String[] { clientID} );
	} else {
		return false;
	}
}

private static String getNextNSID() {
	String nsID = null;
	
	ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(CRM_NS_ID) + 1 FROM CRM_CLIENTS_NEWSTART");
	
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		nsID = reportableListObject.getValue(0);
		// set 1 for initial		
		
		if (nsID == null || nsID.length() == 0) return "1";
	}

	return nsID;
}

%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String step = request.getParameter("step");
String documentID = request.getParameter("documentID");
String clientID = request.getParameter("clientID");
String level = request.getParameter("level");
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(	
			request,
			ConstantsServerSide.DOCUMENT_FOLDER,
			ConstantsServerSide.TEMP_FOLDER,
			ConstantsServerSide.UPLOAD_FOLDER,
			"UTF-8"
		);
	command = (String) request.getAttribute("command");
	step = (String) request.getAttribute("step");
	clientID = (String) request.getAttribute("clientID");	
	documentID = (String) request.getAttribute("documentID");	
	level = (String) request.getAttribute("level");	
}

boolean updateAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("update".equals(command)) {
	updateAction = true;
} 

try {	
	if ("3".equals(step) && deleteDocument(userBean, clientID, documentID)) {		
		step = "0";
	}else if ("1".equals(step)) {
		if (updateAction) {					
			if(level != null && level.length() > 0){
				updateClientNEWSTARTLevel(clientID,userBean.getLoginID(),level);
			}
			addUploadedFile(request, userBean, clientID);				
			message = "Document modified.";
			updateAction = false;			
		}
	}
	
	ArrayList levelRecord = getCRMClientLevel(clientID);	
	if (levelRecord.size() > 0) {				
		ReportableListObject row = (ReportableListObject) levelRecord.get(0);
		level = row.getValue(0);				
	}else{
		level = "1";
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	if (updateAction) {
		commandType = "update";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.crm.progressNoteDoc." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Progress Note List" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<%
if(clientID != null && clientID.length()>0 && !"null".equals(clientID)){	
	ArrayList clientRecord = getClientInfo(clientID);

	if(clientRecord.size() != 0){	
		ReportableListObject clientRow = (ReportableListObject)clientRecord.get(0);	
%>
<table cellpadding="0" width="100%" cellspacing="5"	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="16%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(1)%></td>
		<td class="infoLabel" width="16%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(2)%></td>
		<td class="infoLabel" width="16%">User Name</td>
		<td class="infoData"  width="16%"><%=clientRow.getValue(3)%></td>
	</tr>
	<tr></tr>	
</table>		
<%
	}
}
%>
<form name="form1" enctype="multipart/form-data" action="progress_note_update.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td colspan = "6"  class="infoTitle" colspan="4">Progress Note List</td>
	</tr>			
	<tr>
		<td colspan="2" style='border-width:1px; border-style:solid;background-color: #FFF6F6; '>									
			<div id='scroll-pane' class='scroll-pane jspScrollable' style='overflow: hidden; padding: 0px; width:100%; height:400px'>
				<table  id='progressNoteTable' border="0" style='border-width:0px;border-spacing:0px;width:100%;'>
					
				</table> 
			</div>										
		</td>
	</tr>	
	<tr class="smallText">
		<td colspan = "6"  class="infoTitle" colspan="4">Insert Progress Note</td>
	</tr>					
	<tr>
		<td style='height:100%' colspan="2" class="infoData">
			<textarea onkeydown="limitText(this.form.progressNote,500);" 
		onkeyup="limitText(this.form.progressNote,500);" name="progressNote"id = "progressNote" style='height:80px;width:100%'></textarea>
		</td>				
	</tr>	
	<tr>
	<td colspan="6" style="float: right"><font size="1">(Maximum characters: 500)</font></td>
	</tr>		 			
	<tr>		
		<td colspan="6" style="text-align:center">
			<button type='button' style="font-size:15px;" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
					 onclick="progressNoteUpdate('save','<%=clientID%>');">Save</button>
		</td>				
	</tr>	
	
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Log Book Data</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Level</td>
		<td class="infoData" width="70%">
<%	if ( updateAction) { %>
		<select name="level">
<%for(int i = 1;i<6;i++){ %>
  <option <%=(level.equals(Integer.toString(i))?"SELECTED":"") %> value="<%=i%>"><%=i %></option>
<%} %>
</select>
<%	} else { %>
		<%=level==null?"":level %>
<%	} %>
		</td>
	</tr>
	
	
	<tr class="smallText">
		<td colspan = "6"  class="infoTitle" colspan="4"><bean:message key="function.crm.progressNoteDoc.list" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel">Documents</td>
		<td class="infoData">
<%	if (updateAction) { %>
			<input type="file" name="file1" size="50" class="multi" maxlength="5">
			<input type="hidden" name="toPDF" value="N">
<%		
	if (updateAction) {
%><br><p><%
			ArrayList record = getDocuments(clientID);
			ReportableListObject row = null;
			if (record.size() > 0) {
				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
%><br><button onclick="return deleteFile('<%=row.getValue(0) %>');"><bean:message key="button.delete" /> <%=row.getValue(1) %></button><%
				}
			}
		}
	} else { %>
<jsp:include page="../helper/viewProgressDocument.jsp" flush="false">
	<jsp:param name="clientID" value="<%=clientID %>" />
</jsp:include>
<%	} %>
		</td>
	</tr>
	
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (updateAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else {%>
			<button onclick="return submitAction('update', 0, '');" class="btn-click"><bean:message key="function.crm.progressNoteDoc.update" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<br>

<input type="hidden" name="command" value="<%=commandType %>">
<input type="hidden" name="step">
<input type="hidden" name="clientID" value="<%=clientID%>">
<input type="hidden" name="documentID">
</form>
<script language="javascript">
	var apis = [];	
	$().ready(function(){
		initScroll('.scroll-pane');
		progressNoteUpdate('view',<%=clientID%>);		
	});
	
	function limitText(limitField,limitNum) {
		if (limitField.value.length > limitNum) {
			limitField.value = limitField.value.substring(0, limitNum);
		}
	}
	
	function initScroll(pane) {
		destroyScroll();		
	$(pane).each(
			function()
			{
				apis.push($(this).jScrollPane({autoReinitialise:false}).data().jsp);
			}
		);
		return false;
	}

	function destroyScroll() {
		if (apis.length) {
			$.each(
				apis,
					function(i) {
					this.destroy();
				}
			);
			apis = [];
		}
		return false;
	}	
	
	function progressNoteUpdate(type,cID,pnID){	
		var clientID = 'clientID='+cID;
		if(type=='save'){			
			var progressNote = 'progressNote=' + encodeURIComponent($('textarea#progressNote').val());			
			var baseUrl ='../crm/progress_note_functions.jsp?action=insert';		
			var url = baseUrl + '&' + clientID + '&' + progressNote;	
			//alert(url)
			$.ajax({
				url: url,
				async: false,
				cache:false,
				success: function(values){					
					if(values) {						
						if(values.indexOf('true') > -1) {
							alert('Record Added Successfully.');	
							$('textarea#progressNote').val('') ;	
							progressNoteUpdate('view',cID);														
							}						
						else {
							alert('Error occured while adding record.');
						}
					}
				},
				error: function() {
					alert('Error occured while adding record.');
					
				}
			});
		}else if(type=='view'){
			var baseUrl ='../crm/progress_note_functions.jsp?action=view&&allowDelete=true';		
			var url = baseUrl + '&' + clientID;	
			//alert(url)
			$.ajax({
				url: url,
				async: false,
				cache:false,
				success: function(values){					
					if(values) {						
						$('#progressNoteTable').html(values);
						apis[0].reinitialise();						
					}
				},
				error: function() {
					alert('Error occured while displaying record.');
					
				}
			});
		}else if(type=='delete'){
			var deleteNote = confirm("Delete Progress Note?");
			   if( deleteNote == true ){	
				var url ='../crm/progress_note_functions.jsp?action=delete&pnID='+pnID;		
					
				//alert(url)
				$.ajax({
					url: url,
					async: false,
					cache:false,
					success: function(values){					
						if(values) {		
							if(values.indexOf('true') > -1) {
							alert('Record deleted Successfully.');							
							progressNoteUpdate('view',cID);	
							}else{
								alert('Error occured while deleting record.');
							}
						}
					},
					error: function() {
						alert('Error occured while deleting record.');
						
					}
				});
			}		
		}
	}

	function submitAction(cmd, stp, qid) {	
		document.form1.command.value = cmd;		
		document.form1.step.value = stp;
		document.form1.submit();
	}

	function deleteFile(did) {		
		document.form1.action = "progress_note_update.jsp";	
		document.form1.documentID.value = did;
		document.form1.step.value = 3;		
		document.form1.submit();
	}

</script>
</DIV>
</DIV>
</DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>