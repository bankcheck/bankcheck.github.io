<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
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
String step = ParserUtil.getParameter(request, "step");

String haaID = ParserUtil.getParameter(request, "HaaID");
String seq = ParserUtil.getParameter(request, "seq");
String corporationName = ParserUtil.getParameter(request, "corporationName");
String corporationCode = ParserUtil.getParameter(request, "corporationCode");
String businessType = ParserUtil.getParameter(request, "businessType");
String contractDateFrom = ParserUtil.getParameter(request, "contractDateFrom");
String contractDateTo = ParserUtil.getParameter(request, "contractDateTo");
String enabled = ParserUtil.getParameter(request, "enabled");

String seqTemp = null;
String initDate = ParserUtil.getParameter(request, "initDate");
String completeDate = ParserUtil.getParameter(request, "completeDate");

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

if (fileUpload) {
	// create new record
	if ("create".equals(command) && "1".equals(step)) {
		// get project id with dummy data
		haaID = HAACheckListDB.add(userBean);
	}

	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("Health Assessment");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(haaID);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("upload");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("Health Assessment");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(haaID);
		String webUrl = tempStrBuffer.toString();

		for (int i = 0; i < fileList.length; i++) {
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + fileList[i]
			);
			DocumentDB.add(userBean, "haa", haaID, webUrl, fileList[i]);
		}
	}
}

boolean createAction = false;
boolean updateAction = false;
boolean updateDateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("updateDate".equals(command)) {
	updateDateAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction) {
			// initial create id
			if (haaID == null) {
				haaID = HAACheckListDB.add(userBean);
			}

			// call db insert corporation name, business type
			if (HAACheckListDB.update(userBean, haaID, corporationName, businessType, 
									contractDateFrom, contractDateTo, corporationCode, enabled)) {
				message = "Corporation created.";
				createAction = false;
			} else {
				errorMessage = "Corporation create fail.";
			}
		} else if (updateAction) {
			// call db update corporation name, business type
			if (HAACheckListDB.update(userBean, haaID, corporationName, businessType, contractDateFrom, 
										contractDateTo, corporationCode, enabled)) {
				message = "Corporation updated.";
				updateAction = false;
			} else {
				errorMessage = "Corporation update fail.";
			}
			deleteAction = false;
		} else if (deleteAction) {
			// call db delete
			if (HAACheckListDB.delete(userBean, haaID)) {
				message = "Corporation deleted.";
				deleteAction = false;
			} else {
				errorMessage = "Corporation delete fail.";
			}
			deleteAction = false;
		} else if (updateDateAction) {
			// call db update complete date
			HAACheckListDB.updateDate(userBean, haaID, seq, initDate, completeDate);
			updateDateAction = false;
		}
		step = null;
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (haaID != null && haaID.length() > 0) {
			// clear expired file
			HAACheckListDB.expiredContract(userBean, haaID);

			ArrayList record = HAACheckListDB.get(userBean, haaID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				corporationName = row.getValue(1);
				businessType = row.getValue(2);
				contractDateFrom = row.getValue(3);
				contractDateTo = row.getValue(4);
				corporationCode = row.getValue(5);
				enabled = row.getValue(6);
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

if (haaID != null) {
	request.setAttribute("progress", HAACheckListDB.getProgress(userBean, haaID));
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
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction || updateDateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.haa." + commandType;

	// update command type
	if (updateDateAction) {
		commandType = "updateDate";
	}
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" enctype="multipart/form-data" action="checkitem.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Corporation Name</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
		<input type="text" name="corporationName" value="<%=corporationName==null?"":corporationName %>" maxlength="50" size="50">
<%	} else {%>
		<%=corporationName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">AR Code</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
		<input type="text"  name="corporationCode" value="<%=corporationCode==null?"":corporationCode %>" maxlength="200" size="50">
<%	} else {%>
		<%=corporationCode %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Business Type</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
		<select name="businessType">
			<option value="NB"<%="NB".equals(businessType)?" selected":"" %>>New Business</option>
			<option value="RB"<%="RB".equals(businessType)?" selected":"" %>>Renewal Business</option>
			<option value="PM"<%="PM".equals(businessType)?" selected":"" %>>Promotion</option>
		</select>
<%	} else {%>
		<%="NB".equals(businessType)?"New Business":("RB".equals(businessType)?"Renewal Business":"Promotion") %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Case Summary</td>
		<td class="infoData" width="70%">
<%	if (!createAction) {
		String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE; %>
		<span id="showDocument_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="haa" />
	<jsp:param name="keyID" value="<%=haaID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
		</span>
<%	}
	if (createAction || updateAction) {%>
		<input type="file" name="file1" size="50" class="multi" maxlength="10">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Contract Date</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
		<input type="text" name="contractDateFrom" id="contractDateFrom" class="datepickerfield" value="<%=contractDateFrom==null?"":contractDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
		-
		<input type="text" name="contractDateTo" id="contractDateTo" class="datepickerfield" value="<%=contractDateTo==null?"":contractDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
<%	} else {%>
		<%=contractDateFrom==null?"":contractDateFrom %> - <%=contractDateTo==null?"":contractDateTo %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Status</td>
		<td class="infoData" width="70%">
<%	if (createAction || updateAction) {%>
			<select name="enabled">
				<option value="1"<%="1".equals(enabled)?" selected":"" %>>Normal</option>
				<option value="2"<%="2".equals(enabled)?" selected":"" %>>Archive</option>
			</select>
<%	} else {%>
		<%=ConstantsVariable.TWO_VALUE.equals(enabled)?"Archive":"Normal" %>
<%	} %>
		</td>
	</tr>
</table>
<%	if (!updateDateAction) { %>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
		<% if (userBean.isAccessible("function.haa.create") || userBean.isAccessible("function.haa.update") || userBean.isAccessible("function.haa.delete")) { %><button onclick="return submitAction('<%=commandType %>', 1, 0);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button><%	} %>
		<button onclick="return submitAction('view', 0, 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
		<% if (userBean.isAccessible("function.haa.update")) { %><button onclick="return submitAction('update', 0, 0);" class="btn-click"><bean:message key="function.haa.update" /></button><%	} %>
		<% if (userBean.isAccessible("function.haa.delete")) { %><button onclick="return submitAction('delete', 1, 0);" class="btn-click"><bean:message key="function.haa.delete" /></button><%	} %>
<%	}  %>
		</td>
	</tr>
</table>
</div>
<%	} %>
<%	if (!createAction && !updateAction) {%>
<bean:define id="functionLabel"><bean:message key="function.haa.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.progress" export="false">
<%		seqTemp = ((ReportableListObject)pageContext.getAttribute("row")).getFields0();  %>
	<display:column property="fields1" title="Progress" style="width:30%"/>
	<display:column property="fields2" title="Dept" style="width:10%" />
	<display:column property="fields3" title="Initiate Party" style="width:10%" />
	<display:column title="Initiate Date" style="width:10%">
<%		if (updateDateAction && seqTemp.equals(seq)) { %>
<%		initDate = ((ReportableListObject)pageContext.getAttribute("row")).getFields4();  %>
		<input type="text" name="initDate" id="initDate" class="datepickerfield" value="<%=initDate==null?"":initDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
<%		} else { %>
		<c:out value="${row.fields4}" />
<%		} %>
	</display:column>	
	<display:column property="fields5" title="Responsive Party" style="width:10%; text-align:center" />
	<display:column title="Completed Date" style="width:10%">
<%		if (updateDateAction && seqTemp.equals(seq)) { %>
<%		completeDate = ((ReportableListObject)pageContext.getAttribute("row")).getFields6();  %>
		<input type="text" name="completeDate" id="completeDate" class="datepickerfield" value="<%=completeDate==null?"":completeDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
<%		} else { %>
		<c:out value="${row.fields6}" />
<%		} %>
	</display:column>
	<display:column title="Action" style="width:10%">
<%	if (((ReportableListObject)pageContext.getAttribute("row")).getFields2() != "") {  %>
<%		if (updateDateAction && seqTemp.equals(seq)) { %>
		<button onclick="return submitAction('<%=commandType %>', 1, '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.save" /></button>
		<button onclick="return submitAction('view', 0, '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.cancel" /></button>
<%		} else { %>
		<button onclick="return submitAction('updateDate', 0, '<c:out value="${row.fields0}" />');" class="btn-click"><bean:message key="button.update" /></button>
<%		}  %>
<%	}  %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	} %>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="HaaID" value="<%=haaID %>">
<input type="hidden" name="seq">
</form>
<script language="javascript">
<!--
	function submitAction(cmd, stp, seq) {
		if (stp == 1) {
			if (cmd == 'create' || cmd == 'update') {
				if (document.form1.corporationName.value == '') {
					document.form1.corporationName.focus();
					alert("Please input Corporation Name!");
					return false;
				}
			} else if (cmd == 'updateDate') {
				if (document.form1.initDate.value == '') {
					document.form1.initDate.focus();
					alert("Please input initiate date!");
					return false;
				}
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.seq.value = seq;
		document.form1.submit();
	}

	// ajax
	var http = createRequestObject();

	function removeDocument(mid, did) {
		http.open('get', '../common/document_list.jsp?command=delete&moduleCode=' + mid + '&keyID=<%=haaID %>&documentID=' + did + '&allowRemove=<%=updateAction?"Y":"N" %>&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById('showDocument_indicator').innerHTML = response;
		}
	}
-->
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>