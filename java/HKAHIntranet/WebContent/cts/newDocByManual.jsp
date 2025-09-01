<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.io.*"%>
<%!
	private String parseDateStr(HttpServletRequest request, String label) {
		StringBuffer sqlStr = new StringBuffer();
		String date_yy = request.getParameter(label + "_yy");
		String date_mm = request.getParameter(label + "_mm");
		String date_dd = request.getParameter(label + "_dd");
		String date_hh = request.getParameter(label + "_hh");
		String date_mi = request.getParameter(label + "_mi");

		if (date_yy != null && date_yy.length() > 0
				&& date_mm != null && date_mm.length() > 0
				&& date_dd != null && date_dd.length() > 0) {
			if (date_dd.length() == 1) {
				sqlStr.append("0");
			}
			sqlStr.append(date_dd);
			sqlStr.append("/");
			if (date_mm.length() == 1) {
				sqlStr.append("0");
			}
			sqlStr.append(date_mm);
			sqlStr.append("/");
			sqlStr.append(date_yy);

			if (date_hh != null && date_hh.length() > 0
					&& date_mi != null && date_mi.length() > 0) {
				sqlStr.append(" ");
				sqlStr.append(date_hh);
				sqlStr.append(":");
				sqlStr.append(date_mi);
			}
		}
		return sqlStr.toString();
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
String siteCode = ConstantsServerSide.SITE_CODE;
UserBean userBean = new UserBean(request);
String folderId = null;
String command = ParserUtil.getParameter(request,"command");
String ls_ctsNO = ParserUtil.getParameter(request,"cts_no");
String ls_docCode = ParserUtil.getParameter(request,"docNo");
String ls_fName = ParserUtil.getParameter(request,"docfName");
String ls_gName = ParserUtil.getParameter(request,"docgName");
String ls_docSex = ParserUtil.getParameter(request,"docSex");
String ls_spCode = ParserUtil.getParameter(request,"spCode");
String ls_docEmail = ParserUtil.getParameter(request,"docEmail");
String ls_corrAddr = ParserUtil.getParameter(request,"corrAddr");
String ls_startDate = ParserUtil.getParameter(request,"startDate");
String ls_termDate = ParserUtil.getParameter(request,"termDate");
String ls_initContactDate = ParserUtil.getParameter(request,"initContactDate");
String ls_isSurgeon = ParserUtil.getParameter(request,"isSurgeon");
String ls_ctsDoc = ParserUtil.getParameter(request,"ctsDoc");
String ls_recordType = CTS.getRecordType(ls_ctsNO);
String docLicNo = ParserUtil.getParameter(request,"docLicNo");

System.err.println("1[command]:"+command);
if (fileUpload) {
	String[] fileList = (String[]) request.getAttribute("filelist");
	System.err.println("1[fileList]:"+fileList);
	if (fileList != null) {
		if(folderId!=null && folderId.length()>0){
			System.err.println("1[folderId]"+folderId);
		}else{
			folderId = CTS.getNewFolderId(ls_ctsNO);
		}
		System.err.println("2[folderId]"+folderId);
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

if (ls_isSurgeon==null) {
	ls_isSurgeon = "0";
}
String forwardPath = null;
boolean createAction = false;
boolean updateAction = false;
boolean searchAction = false;
boolean inactAction = false;
boolean closeAction = false;

ArrayList record = null;

String message = "";
String errorMessage = "";
System.err.println("2[command]:"+command);
if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("view".equals(command)&& ls_ctsNO != null && ls_ctsNO.length() > 0) {
	searchAction = true;
} else if ("delete".equals(command)) {
	inactAction = true;
} else if ("search".equals(command)) {
	searchAction = true;
}

System.err.println("[searchAction]:"+searchAction);
try {
	if (createAction) {
		ls_ctsNO = CTS.addNewCts(userBean, ls_fName, ls_gName, ls_docSex, ls_spCode, ls_docEmail, docLicNo);
		if (ls_ctsNO!=null||ls_ctsNO.length()> 0) {
			if (CTS.sendNewCTSEmail(docLicNo, "away", "", ls_ctsNO, "", "S")) {
				message = "New Record added.";
				createAction = false;
				searchAction = true;
			} else {
				message = "New Record added but email send fail!";
			}

			record = CTS.getNewCTSDtl(ls_ctsNO);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				ls_ctsNO = row.getValue(0);
				ls_fName = row.getValue(4);
				ls_gName = row.getValue(5);
				ls_docSex = row.getValue(7);
				ls_spCode = row.getValue(10);
				ls_docEmail = row.getValue(19);
				ls_isSurgeon = row.getValue(68);
				request.setAttribute("cts_log", CTS.getRecordLog(ls_ctsNO));
				System.err.println("[ctsNo]:"+ls_ctsNO+";[command]:view;[siteCode]:"+siteCode+";[message]:"+message);
			}

			forwardPath = "newDocByManualPreview.jsp?ctsNo="+ls_ctsNO+"&command=view&siteCode="+siteCode+"&message="+message;
		} else {
			errorMessage = "Record added fail.";
		}
	} else if (updateAction) {
		if (CTS.updateDoc(userBean, ls_ctsNO, ls_fName, ls_gName, ls_docSex, ls_spCode, ls_docEmail, ls_startDate, ls_termDate, ls_initContactDate, ls_corrAddr, null, null, null, null, null, null, null, null, null, null, null, null, null, null, ls_isSurgeon, null, null, null, null, null, null)) {
			message = "Record updated.";
			updateAction = false;
			searchAction = true;
		} else {
			errorMessage = "Record update fail.";
			updateAction = true;
		}
	} else if (searchAction) {
//		ArrayList record = CTS.getDocList(ls_ctsNO);
System.err.println("[ls_docCode]:"+ls_docCode+";[ls_fName]:"+ls_fName+";[ls_gName]"+ls_gName);
request.setAttribute("cts_log", CTS.getDocList2(ls_docCode, ls_fName, ls_gName));

		record = CTS.getDocList2(ls_docCode, ls_fName, ls_gName);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			ls_docCode = row.getValue(0);
			ls_fName = row.getValue(1);
			ls_gName = row.getValue(2);
			ls_docSex = row.getValue(3);
			ls_spCode = row.getValue(4);
			ls_docEmail = row.getValue(5);
			ls_startDate = row.getValue(6);
			ls_termDate = row.getValue(7);
			ls_isSurgeon = row.getValue(8);
			ls_initContactDate = row.getValue(9);
			ls_corrAddr = row.getValue(10);
			request.setAttribute("cts_log", CTS.get_recordLog(ls_ctsNO));
		}
	} else if ("view1".equals(command)&& ls_docCode != null && ls_docCode.length() > 0) {
		record = CTS.getDocList1(ls_ctsNO);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			ls_docCode = row.getValue(0);
			ls_fName = row.getValue(1);
			ls_gName = row.getValue(2);
			ls_docSex = row.getValue(3);
			ls_spCode = row.getValue(4);
			ls_docEmail = row.getValue(5);
			ls_corrAddr = row.getValue(6);
			ls_startDate = row.getValue(7);
			ls_termDate = row.getValue(8);
			ls_isSurgeon = row.getValue(9);
		}
	} else {
		errorMessage = "";
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
<style type=text/css>
.rounded_edges {
  -moz-border-radius: 15px;
  border-radius: 15px;
  border: 1px solid black;
}
.button_color {
 	background-color: #750F44;
    border: none;
    color: white;
    padding: 15px 32px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 16px;
    margin: 4px 2px;
    border-radius: 15px;
    cursor: pointer;
}
.bigTextCTS { font: 22px Arial, Helvetica, sans-serif; vertical-align: middle }

.focus{border: 1px solid #750F44;outline: none;}
.blur{border: 1px solid #CCCCCC;outline: none;}
</style>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else if(forwardPath!=null){ %>
	<script language="javascript">parent.location.href = "<%=forwardPath %>";</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<div id=indexWrapper>
<div id=mainFrame>
<div id=Frame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Apply Doctor Credentials" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.cts.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" enctype="multipart/form-data"  action="newDocByManual.jsp" method="post">
<br><br>
<table align="center" cellpadding="0" cellspacing="5">
	<tr>
		<td>
		<img src="/intranet/images/twah_portal_logo.gif" alt="Tsuen Wan Adventist Hospital Intranet Portal" style="width:300px;height:80px;" align="center"></img>
		</td>
	</tr>
</table>
<table class="rounded_edges" align="center" cellpadding="0" cellspacing="5">
	<tr>
		<td><br></td>
	</tr>
	<tr class="middleText">
		<td class="middleText"><bean:message key="prompt.HKMC" /></td>
	</tr>
	<tr class="middleText">
	<td>
		<%if ("N".equals(ls_recordType) || ls_recordType==null){%>
			<input type="textfield"  id="docLicNo" name="docLicNo" value="<%=docLicNo==null?"":docLicNo %>" style="height:20px;font-size:14pt;" maxlength="50" size="43" onclick="this.select()"/>
		<%} else {%>
			<input type="textfield" id="docLicNo" name="docLicNo" value="<%=docLicNo==null?"":docLicNo %>" style="height:20px;font-size:14pt;" maxlength="50" size="43" readonly/>
		<%} %>
		</td>
	</tr>
	<tr class="middleText">
		<td class="middleText">*<bean:message key="prompt.docfName" /></td>
	</tr>
	<tr class="middleText">
		<td>
		<%if ("N".equals(ls_recordType) || ls_recordType==null){%>
			<input type="textfield" name="docfName" value="<%=ls_fName==null?"":ls_fName %>" style="height:20px;font-size:14pt;" maxlength="50" size="43" maxlength="100" size="50"/>
		<%} else {%>
			<input type="textfield" name="docfName" value="<%=ls_fName==null?"":ls_fName %>" style="height:20px;font-size:14pt;" maxlength="50" size="43" maxlength="100" size="50" readonly/>
		<%} %>
		</td>
	</tr>
	<tr class="middleText">
		<td class="middleText">*<bean:message key="prompt.docgName" /></td>
	</tr>
	<tr class="middleText">
		<td>
		<%if ("N".equals(ls_recordType) || ls_recordType==null){%>
			<input type="textfield" name="docgName" value="<%=ls_gName==null?"":ls_gName %>" style="height:20px;font-size:14pt;" maxlength="50" size="43" maxlength="100" size="50"/>
		<%} else {%>
			<input type="textfield" name="docgName" value="<%=ls_gName==null?"":ls_gName %>" style="height:20px;font-size:14pt;" maxlength="50" size="43" maxlength="100" size="50" readonly/>
		<%} %>
		</td>
	</tr>
	<tr class="middleText">
		<td class="middleText">*<bean:message key="prompt.docSex" /></td>
	</tr>
	<tr class="middleText">
		<td>
			<select name="docSex">
				<option value="M">Male</option>
				<option value="F"<%="F".equals(ls_docSex)?" selected":"" %>>Female</option>
			</select>
		</td>
	</tr>
	<tr class="middleText">
		<td class="middleText">*<bean:message key="prompt.spCode" /></td>
	</tr>
	<tr class="middleText">
		<td>
			<select name="spCode">
			<jsp:include page="../ui/specCodeCMB.jsp" flush="false">
				<jsp:param name="spCode" value="<%=ls_spCode %>" />
			</jsp:include>
<%--<jsp:param name="ignoreDeptCode" value="880" /> --%>
			</select>
		</td>
	</tr>
	<tr class="middleText">
		<td class="middleText">*<bean:message key="prompt.email" /></td>
	</tr>
	<tr class="middleText">
		<td>
		<%if ("N".equals(ls_recordType) || ls_recordType==null){%>
			<input type="textfield" name="docEmail" value="<%=ls_docEmail==null?"":ls_docEmail %>" style="height:20px;font-size:14pt;" maxlength="50" size="43" maxlength="100" size="50"/>
		<%} else {%>
			<input type="textfield" name="docEmail" value="<%=ls_docEmail==null?"":ls_docEmail %>" style="height:20px;font-size:14pt;" maxlength="50" size="43" maxlength="100" size="50" readonly/>
		<%} %>
		</td>
	</tr>
	<tr class="middleText">
		<td class="middleText"><bean:message key="prompt.isSurgeon" /></td>
	</tr>
	<tr class="middleText">
		<td>
			<input type="checkbox" name="isSurgeon" id="isSurgeon" value="-1" <%="-1".equals(ls_isSurgeon)?" checked=checked":"" %>
			<%="view".equals(command)?" disabled=disabled":"" %>/>
		</td>
	</tr>
	<tr>
		<td align="center">
				<button class="button_color" onclick="submitAction('create');">Quick Apply</button>
				<button class="button_color" onclick="return closeAction();"><bean:message key="button.close" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="command" />
<input type="hidden" name="cts_no" value="<%=ls_ctsNO %>">
</form>
<script language="javascript">
	function closeAction() {
		window.close();
	}

	$().ready(function(){
	    $("input[type=text], input[type=textfield], textarea, select").each(function () {
	        $(this).addClass("blur");
	        $(this).focus(function () {
	            $(this).removeClass("blur").addClass("focus");
	        });
	        $(this).blur(function () {
	            $(this).removeClass("focus").addClass("blur");
	        });
	    });

		$("#docLicNo").css("outline-color","red"); // with id
		$('#initContactDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#startDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#termDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
	});

	function submitAction(cmd) {
		if (cmd=='create'){
			if (document.form1.docLicNo.value == '') {
				alert('Please enter Hong Kong Medical Council Number');
				document.form1.docfName.focus();
				return false;
			}
			if (document.form1.docfName.value == '') {
				alert('Please enter first name');
				document.form1.docfName.focus();
				return false;
			}
			if (document.form1.docgName.value == '') {
				alert('Please enter given name');
				document.form1.docgName.focus();
				return false;
			}
			if (document.form1.docEmail.value == '') {
				alert('Please enter email');
				document.form1.docEmail.focus();
				return false;
			}

			var r=confirm("Confirm to submit?");
			if (r==true){
				document.form1.command.value = cmd;
				document.form1.submit();
				return false;
			 }else{
				 return false;
			 }
		}
	}
/*
	// ajax
	var http = createRequestObject();

	function processResponseAppointmentDate() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("edit_indicator").innerHTML = response;

			$('#flwUpDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
			$('#cfmApptDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		}

	}


	function createClickableRow(){
		$('#row td').each(function(i,v) {
			$(this).click(function(){
			 document.form1.docNo.value = $.trim( $(this).parent('tr').find("td").eq(1).html());
			 document.form1.docfName.value = $.trim( $(this).parent('tr').find("td").eq(2).html());
			 document.form1.docgName.value = $.trim( $(this).parent('tr').find("td").eq(3).html());
			 document.form1.docSex.value = $.trim( $(this).parent('tr').find("td").eq(4).html());
			 document.form1.spCode.value = $.trim( $(this).parent('tr').find("td").eq(5).html());
			 document.form1.docEmail.value = $.trim( $(this).parent('tr').find("td").eq(6).html());
			 document.form1.startDate.value = $.trim( $(this).parent('tr').find("td").eq(7).html());
			 document.form1.termDate.value = $.trim( $(this).parent('tr').find("td").eq(8).html());
			 document.form1.isSurgeon.value = $.trim( $(this).parent('tr').find("td").eq(9).html());
			 document.form1.spCode.value = $.trim( $(this).parent('tr').find("td").eq(10).html());
			 document.form1.ctsDoc.value = $.trim( $(this).parent('tr').find("td").eq(11).html());
			});

		$(this).parent('tr').hover(
		      function () {
		       $(this).find('td').each (function() {
		        $(this).css("background","yellow");
		       });

		      },
		      function () {
		       $(this).find('td').each (function() {
		        $(this).css("background","");
		       });
		      }
		    );
		});


	}


	$(document).ready(function(){
	    createClickableRow();
	});
*/

</script>
</div>

</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>