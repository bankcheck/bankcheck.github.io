<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%!
private static String getUploadPath() {
	
	String path = null;
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT CODE_VALUE1 FROM AH_SYS_CODE ");
	sqlStr.append(" WHERE SYS_ID = 'LMS' ");
	sqlStr.append(" AND CODE_TYPE = 'LEAFLET_PATH' ");
	sqlStr.append(" AND CODE_NO = 'default' ");
	sqlStr.append(" AND STATUS = 'V' ");

	ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString());

	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		path = row.getValue(0);
	}
	return path;
}

private static ArrayList getLocation(UserBean userBean, String locCode) {
	
	boolean isAdmin = userBean.isAccessible("function.leaflet.admin");
	String staffId = userBean.getStaffID();
	
	String locName = null;
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT L.LOC_CODE, L.LOC_NAME ");
	sqlStr.append(" FROM LM_LOCATION L ");
	
	if (isAdmin) {
		sqlStr.append(" WHERE LOC_CODE = ? ");
	} else {
		sqlStr.append(" LEFT OUTER JOIN lm_UPLOAD_RIGHT R on L.loc_code = R.loc_code ");
		sqlStr.append(" WHERE (L.LOC_owner = '" + staffId + "'" );
		sqlStr.append(" OR R.STAFF_ID = '" + staffId + "') " );
		sqlStr.append(" AND L.LOC_CODE = ? " );
	} 
	
	return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { locCode });
}

public static ReportableListObject getLeaflet(String leafletCode, String locCode) {
	
	ReportableListObject row = null;
	
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT L.LOC_CODE, L.CAT, L.PRODUCE_BY, TO_CHAR(L.EXP_DATE, 'DD/MM/YYYY'), D.CO_DESCRIPTION, D.CO_LOCATION, D.CO_EXTERNAL_LINK, D.CO_DOCUMENT_ID, L.ENABLE ");
	sqlStr.append(" FROM LM_LEAFLET l LEFT OUTER JOIN co_document d ON l.DOCUMENT_ID = d.CO_DOCUMENT_ID ");
	sqlStr.append(" WHERE l.LEAFLET_CODE = ? ");
	sqlStr.append(" AND l.LOC_CODE = ? ");
	
	ArrayList rec =  UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { leafletCode, locCode });
	
	if (rec.size() > 0) {
		row = (ReportableListObject) rec.get(0);			
	}
	
	return row;
}

public static boolean addLeaflet(UserBean userBean, String leafletCode, String locCode, 
		String cat, String topic, String ExpDate, String produceBy, String file, String external) {
	
	String updateUser = userBean.getStaffID();
	String path = null;
	
	if ("N".equals(external)) {
		StringBuffer tempStrBuffer = new StringBuffer();
		tempStrBuffer.append(getUploadPath());
		String baseUrl = tempStrBuffer.toString();
		
		path = baseUrl + locCode + "-" + leafletCode + file.substring(file.lastIndexOf("."));
		
		FileUtil.moveFile( ConstantsServerSide.UPLOAD_FOLDER + File.separator + file, path );
		
	} else {
		path = file;
	}
	
	if (path == null) {
		path = "https://www.hkah.org.hk/en/main";
		external = "Y";
	}
	
	String docId = DocumentDB.add(userBean, topic, path, null);
	
	if (docId != null) {
		
		StringBuffer insLeaflet = new StringBuffer();
		
		insLeaflet.append("INSERT INTO LM_LEAFLET (LEAFLET_CODE, DOCUMENT_ID, LOC_CODE, CAT, PRODUCE_BY, UPDATE_USER, EXP_DATE) ");
		insLeaflet.append(" VALUES (?, ?, ?, ?, ?, ?, TO_DATE(?, 'DD/MM/YYYY') ) ");
		
		if (UtilDBWeb.updateQueue(
				insLeaflet.toString(),
				new String[] {
					leafletCode, docId, locCode, cat, produceBy,
					updateUser, ExpDate })) {
			
			StringBuffer updDoc = new StringBuffer();
			
			updDoc.append("UPDATE CO_DOCUMENT ");
			updDoc.append(" SET CO_WEB_FOLDER = 'N', ");
			updDoc.append(" 	CO_EXTERNAL_LINK = ? ");
			updDoc.append(" WHERE CO_DOCUMENT_ID = ? ");
			
			UtilDBWeb.updateQueue(
					updDoc.toString(),
				new String[] { external, docId });
			
			return true;
		}
	}
	
	return false;
}

public static boolean updateLeaflet(UserBean userBean, String leafletCode, String locCode,
		String cat, String topic, String ExpDate, String produceBy, String file, String external, String docId, boolean fileUpload ) {
	
	String updateUser = userBean.getStaffID();
	
	String path = null;
	
	if ( (fileUpload) && "N".equals(external) ) {
		StringBuffer tempStrBuffer = new StringBuffer();
		tempStrBuffer.append(getUploadPath());
		String baseUrl = tempStrBuffer.toString();
		
		path = baseUrl + locCode + "-" + leafletCode + file.substring(file.lastIndexOf("."));
		
		FileUtil.moveFile( ConstantsServerSide.UPLOAD_FOLDER + File.separator + file, path );
		
	} else {
		path = file;
	}
		
	if (docId == null) {
		
		if (path == null) {
			path = "https://www.hkah.org.hk/en/main";
			external = "Y";
		}
			
		docId = DocumentDB.add(userBean, topic, path, null);
	}
	
	StringBuffer updLeaflet = new StringBuffer();
		
	updLeaflet.append("UPDATE LM_LEAFLET ");
	updLeaflet.append(" SET DOCUMENT_ID = ?, ");
	updLeaflet.append(" CAT = ?,  ");
	updLeaflet.append(" EXP_DATE = TO_DATE(?, 'DD/MM/YYYY'),  ");
	updLeaflet.append(" PRODUCE_BY = ?,  ");
	updLeaflet.append(" UPDATE_USER = ?,  ");
	updLeaflet.append(" UPDATE_DATE = SYSDATE,  ");
	updLeaflet.append(" NOTIFY_COUNT = 0,  ");
	updLeaflet.append(" NOTIFY_DATE = null  ");
	updLeaflet.append(" WHERE LEAFLET_CODE = ? ");
	updLeaflet.append(" AND LOC_CODE = ? ");
		
	if (UtilDBWeb.updateQueue(
		updLeaflet.toString(),
		new String[] { docId, cat, ExpDate, produceBy, updateUser, leafletCode, locCode })) {
			
		StringBuffer updDoc = new StringBuffer();
		
		updDoc.append("UPDATE CO_DOCUMENT ");
		updDoc.append(" SET CO_WEB_FOLDER = 'N', ");
		updDoc.append(" 	CO_EXTERNAL_LINK = ?, ");
		updDoc.append(" 	CO_DESCRIPTION = ?, ");
		updDoc.append(" 	CO_LOCATION = ?, ");
		updDoc.append(" 	CO_MODIFIED_USER = ?, ");
		updDoc.append(" 	CO_MODIFIED_DATE = SYSDATE ");
		updDoc.append(" WHERE CO_DOCUMENT_ID = ? ");
		
		if (UtilDBWeb.updateQueue(
				updDoc.toString(),
			new String[] { external, topic, path, updateUser, docId })) {
		
			return true;
		}
	}
	
	return false;
}
%>
<%
boolean fileUpload = false;
String filename = null;

if (HttpFileUpload.isMultipartContent(request)) {
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	
	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null && fileList.length > 0) {
		filename = fileList[0];
		fileUpload = true;
	}
}

UserBean userBean = new UserBean(request);
String message = ParserUtil.getParameter(request,"message");
String errorMessage = ParserUtil.getParameter(request,"errorMessage");

String locCode = ParserUtil.getParameter(request, "locCode");
String command = ParserUtil.getParameter(request,"command");
String leafletCode = ParserUtil.getParameter(request,"leafletCode");
String cat = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"cat"));
String topic = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"topic"));
String produceBy = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"produceBy"));
String expiryDate = ParserUtil.getParameter(request,"expiryDate");
String external = ParserUtil.getParameter(request,"external");
String path = ParserUtil.getParameter(request,"path");
String docId = ParserUtil.getParameter(request,"docId");
String url = ParserUtil.getParameter(request,"url");

if ("Y".equals(external)) {
	if ( url.startsWith("http") || url.startsWith("ftp://") )
		path = url;
	else
		path = "http://" + url;
} else if (fileUpload && "N".equals(external)) {
	path = filename;
}

ReportableListObject row = null;

String locName = null;

ArrayList record = getLocation(userBean, locCode);
if (record.size() > 0) {
	ReportableListObject loc = (ReportableListObject) record.get(0);
	locCode = loc.getValue(0);
	locName = loc.getValue(1);

} else {
	locCode = null;
	locName = null;
	leafletCode = null;
	command = "close";
	message = "Error";
	errorMessage = "Cannot access leaflet";		
}

if ("new".equals(command)) {
	
	command = "create";
	
} else if ("edit".equals(command)) {
	
	row = getLeaflet(leafletCode, locCode);
	
	//L.LOC_CODE, L.CAT, L.PRODUCE_BY, TO_CHAR(L.EXP_DATE, 'DD/MM/YYYY'), D.CO_DESCRIPTION, D.CO_LOCATION, D.CO_EXTERNAL_LINK, D.CO_DOCUMENT_ID, L.ENABLE
	if (row != null) {
		locCode = row.getValue(0);
		cat = row.getValue(1);
		produceBy = row.getValue(2);
		expiryDate = row.getValue(3);		
		topic = row.getValue(4);
		path = row.getValue(5);
		external = row.getValue(6);
		docId = row.getValue(7);
		
		if ("Y".equals(external))
			url = path;
				
		command = "update";
	} else {
		command = "close";
	}
	
} else if ("create".equals(command)) {
	
	row = getLeaflet(leafletCode, locCode);
	
	if (row != null) {
		message = "Leaflet code already exists";
		errorMessage = "Leaflet create failed";				
	} else {
		if (path == null) {
			message = "File is empty";
			errorMessage = "Leaflet create failed";				
		} else {
			if (addLeaflet(userBean, leafletCode, locCode, cat, topic, expiryDate, produceBy, path, external)){
				command = "close";
			} else {
				errorMessage = "Leaflet create failed";
			}
		}
	}
	
} else if ("update".equals(command)) {
	if (path == null) {
		message = "File is empty";
		errorMessage = "Leaflet update failed";				
	} else {
		if ( updateLeaflet( userBean, leafletCode, locCode, cat, topic, expiryDate, produceBy, path, external, docId, fileUpload )){
			command = "close";
		} else {
			errorMessage = "Leaflet update failed";
		}
	}
	
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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

<body lang=EN-US style='text-justify-trim:punctuation'>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="PFE Information Administration" />
	<jsp:param name="pageMap" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<h1><%=locName==null?"":locName %></h1>
<form name="form1" id="form1" enctype="multipart/form-data" action="lms_leaflet_entry.jsp" method="post">

<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%">Leaflet Code</td>
		<td class="infoData" width="80%"><input type="textfield" name="leafletCode" id="leafletCode" maxlength="20" value="<%=leafletCode==null?"":leafletCode %>"  required <%="update".equals(command)?"readonly":""%> /></td>	
	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="20%">Category</td>
		<td class="infoData" width="80%"><input type="textfield" name="cat" id="cat"  maxlength="400" size="50" value="<%=cat==null?"":cat %>" />
			<span id="catSpan"></span>
		</td>
	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="20%">Topic</td>
		<td class="infoData" width="80%"><input type="textfield" name="topic" id="topic"  maxlength="100" size="50" value="<%=topic==null?"":topic %>" /></td>	
	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="20%">Next Revision Date</td>
		<td class="infoData" width="80%"><input name="expiryDate" id="expiryDate" type="textfield" class="datepickerfield" maxlength="10" size="10" value="<%=expiryDate==null?"":expiryDate %>" onkeyup="validDate(this)" onblur="validDate(this)" /></td>	
	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="20%">Produce By</td>
		<td class="infoData" width="80%"><input name="produceBy" id="produceBy" type="textfield"  maxlength="50" value="<%=produceBy==null?"":produceBy %>" />
			<span id="produceBySpan"></span>
		</td>	
	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="20%">File</td>
		<td class="infoData" width="80%">		
			<div id=fileLink>
<%
if (path != null) {
	if ("Y".equals(external)){
%>
			<a href="<%=path %>" target="_top"><%=topic %></a>
<%		
	}
	else if ("N".equals(external)) {
%>
			<a href="../documentManage/download.jsp?documentID=<%=docId %>" target="_top"><%=topic %></a>
<%		
	}
}
%>
			</div>
			<table>
			<tr><td class="infoData" width="20%"><input name="external" class="external" type="radio" value="N" <%="N".equals(external)?"checked":""%> /> Upload File: </td>
				<td class="infoData" width="80%"><input type="file" name="file1" id="file1" size="70" /></td>	
			</tr>
			<tr><td class="infoData" width="20%"><input name="external" class="external" type="radio" value="Y" <%="Y".equals(external)?"checked":""%> /> External Link: </td>
				<td class="infoData" width="80%"><input name="url" id="url" type="textfield"  maxlength="200" size="70" value="<%=url==null?"":url %>" /></td>	
			</tr>
			</table>	
		</td>	
	</tr>		
</table>

<center>
<input type="hidden" name="locCode" id="locCode" value="<%=locCode==null?"":locCode %>"/>
<input type="hidden" name="docId" id="docId" value="<%=docId==null?"":docId %>"/>
<input type="hidden" name="path" id="path" value="<%=path==null?"":path %>"/>
<input type="hidden" name="command" id="command" value="<%=command==null?"":command %>"/>
<input type="hidden" name="locName" id="locName" value="<%=locName==null?"":locName %>"/>
<button class="btn-submit"><bean:message key="button.save" /></button>
<button id="close"><bean:message key="button.close" /></button>
</center>

</form>

<script language="javascript">
<!--
//IE compatibility
if (typeof console=="undefined") var console={ log: function(x) {document.getElementById('msg').innerHTML=x} };
 
if(typeof String.prototype.trim !== 'function') {
  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, ''); 
  }
} 

$(document).ready(function(){
	
	if  ( $("#command").val() == "" || $("#command").val() == "close" )  {
		opener.location.reload();
		window.close();
	}
	
	if ($("input[name='external']:checked").val() == "Y") {
		$("#file1").attr({ 'disabled': 'disabled' });
		$("#url").removeAttr('disabled');			
	} else {			
		$("#url").attr({ 'disabled': 'disabled' });
		$("#file1").removeAttr('disabled');
	}	
	
	$("#close").click(function(){
		opener.location.reload();
		window.close();
		return false;
	});
	
	$("#save").click(function(){
		if( $("#leafletCode").val() == null ) {
			alert("Please enter leaflet code");
			return false;
		} else if( $("#topic").val() == null ) {
			alert("Please enter topic");
			return false;
		}
	});
	
	$("input[name='external']").click(function(){			
		if ($("input[name='external']:checked").val() == "Y") {
			
			$("#file1").attr({ 'disabled': 'disabled' });
			$("#url").removeAttr('disabled');	
			
		} else {			
			$("#url").attr({ 'disabled': 'disabled' });
			$("#file1").removeAttr('disabled');
		}		
	});
	
	$("#cat").keyup (function(){
		
		var d = new Date();
		var n = d.getTime();
		
		$.post("getLeafletFldList.jsp",
			{
				fld: "cat",
				code: $("#cat").val(),
				time: n
			},
			function(data, status){
				
				document.getElementById("catSpan").innerHTML = "";
				
				if (status == "success") {	
				
					var i;
					var html = '<br /><select name="selCat" id="selCat" size=5 onchange="setCat()">';
					
					var obj = JSON.parse(data);
					
					for (i in obj) {
						html += '<option value="' + obj[i]["cat"] + '">' + obj[i]["cat"] + '</option>';
					}
					html += "</select>";

					document.getElementById("catSpan").innerHTML = html;
				} else {
					alert(status);
				}
			});					
	});
	
	$("#produceBy").keyup (function(){
		
		var d = new Date();
		var n = d.getTime();
		
		$.post("getLeafletFldList.jsp",
			{
				fld: "produce_By",
				code: $("#produceBy").val(),
				time: n
			},
			function(data, status){
				
				document.getElementById("produceBySpan").innerHTML = "";
				
				if (status == "success") {	
				
					var i;
					var html = '<br /><select name="selProduceBy" id="selProduceBy" size=5 onchange="setProduceBy()">';
					
					var obj = JSON.parse(data);
					
					for (i in obj) {
						html += '<option value="' + obj[i]["produce_By"] + '">' + obj[i]["produce_By"] + '</option>';
					}
					html += "</select>";

					document.getElementById("produceBySpan").innerHTML = html;
				} else {
					alert(status);
				}
			});					
	});
	
});

function setCat() {
	$("#cat").val( $("#selCat").val() );
	document.getElementById("catSpan").innerHTML = "";
}

function setProduceBy() {
	$("#produceBy").val( $("#selProduceBy").val() );
	document.getElementById("produceBySpan").innerHTML = "";
}
-->
</script>
</DIV>
</DIV>
</DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>

</html:html>
