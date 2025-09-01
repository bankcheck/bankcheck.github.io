<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
/**
* Handle upload file
*/
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
String tabPanelName = ParserUtil.getParameter(request, "tabPanelName");

String haaID = ParserUtil.getParameter(request, "HaaID");
String seq = ParserUtil.getParameter(request, "seq");
String corporationName = ParserUtil.getParameter(request, "corporationName");
String businessType = ParserUtil.getParameter(request, "businessType");
String contractDateFrom = ParserUtil.getParameter(request, "contractDateFrom");
String contractDateTo = ParserUtil.getParameter(request, "contractDateTo");
String enabled = ParserUtil.getParameter(request, "enabled");

String seqTemp = null;
String initDate = ParserUtil.getParameter(request, "initDate");
String completeDate = ParserUtil.getParameter(request, "completeDate");

String siteCode = request.getParameter("siteCode");
String deptCode = request.getParameter("deptCode");
String labNo = request.getParameter("labNo");
String lastName = TextUtil.parseStr(request.getParameter("lastName")).toUpperCase();
String firstName = TextUtil.parseStr(request.getParameter("firstName")).toUpperCase();
String chineseName = TextUtil.parseStrUTF8(request.getParameter("chineseName"));
String sex = request.getParameter("sex");
String phoneNumber = TextUtil.parseStrUTF8(request.getParameter("phoneNumber"));
String mobileNumber = TextUtil.parseStrUTF8(request.getParameter("mobileNumber"));
String hkid = TextUtil.parseStrUTF8(request.getParameter("hkid"));

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

/**
* Handle upload file
*/
if (fileUpload) {
	// create new record
	if ("create".equals(command) && "1".equals(step)) {
		// get project id with dummy data
		haaID = HAACheckListDB.add(userBean);
	}

	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null) {
		/**
		* Create the server upload file path 
		*/
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

		/**
		* Move the files to server upload file location
		*/
		for (int i = 0; i < fileList.length; i++) {
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + fileList[i]
			);
			
			/**
			* Add general document with module code
			*/
			//DocumentDB.add(userBean, "haa", haaID, webUrl, fileList[i]);
		}
	}
}

/**
* Define action type
*/
boolean createAction = false;
boolean updateAction = false;
boolean updateDateAction = false;
boolean deleteAction = false;

/**
* Identify current action
*/
if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("updateDate".equals(command)) {
	updateDateAction = true;
}

/**
* Handle actions
*/
try {
	if ("1".equals(step)) {
		/**
		* Create
		*/
		if (createAction) {
			if (haaID == null) {
				//haaID = getNewIdFromDB();
			}
			boolean doCreateAction = true;
			if (doCreateAction) {
				message = "Corporation created.";
				createAction = false;
			} else {
				errorMessage = "Corporation create fail.";
			}
		/**
		* Update
		*/
		} else if (updateAction) {
			boolean doUpdateAction = true;
			if (doUpdateAction) {
				message = "Corporation updated.";
				updateAction = false;
			} else {
				errorMessage = "Corporation update fail.";
			}
		/**
		* Delete
		*/
		} else if (deleteAction) {
			boolean doDeleteAction = true;
			if (doDeleteAction) {
				message = "Corporation deleted.";
			} else {
				errorMessage = "Corporation delete fail.";
			}
			deleteAction = false;
		/**
		* Other actions
		*/	
		} else if (updateDateAction) {
			boolean doOtherAction = true;
			if (doOtherAction) {
				message = "Corporation deleted.";
			} else {
				errorMessage = "Corporation delete fail.";
			}
			updateDateAction = false;
		}
		
		/**
		* Reset step!!!
		*/	
		step = null;
	}

	/**
	* load data from database
	*/	
	if (!createAction && !"1".equals(step)) {
		if (haaID != null && haaID.length() > 0) {
			ArrayList record = HAACheckListDB.get(userBean, haaID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				corporationName = row.getValue(1);
				businessType = row.getValue(2);
				contractDateFrom = row.getValue(3);
				contractDateTo = row.getValue(4);
				enabled = row.getValue(5);
			}
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

haaID = "1";
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
	<jsp:param name="isHideTitle" value="Y" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<!-- Start of Search panel -->
<form name="search_form" action="<%=tabPanelName %>.jsp" method="post" onsubmit="return submitSearch();" onreset="return clearSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
<%	if (ConstantsServerSide.DEBUG) { %>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Lab No</td>
		<td class="infoData" width="35%" colspan="3">
			<input type="textfield" name="labNo" value="<%=labNo==null?"":labNo %>" maxlength="10" size="25" />
		</td>
	</tr>
<%	} %>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="lastName" value="<%=lastName==null?"":lastName %>" maxlength="30" size="25" />
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="firstName" value="<%=firstName==null?"":firstName %>" maxlength="60" size="25" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="chineseName" value="<%=chineseName==null?"":chineseName %>" maxlength="20" size="25" />
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.sex" /></td>
		<td class="infoData" width="35%">
			<input type="radio" name="sex" value="M"<%="M".equals(sex)?" checked":"" %>><bean:message key="label.male" />
			<input type="radio" name="sex" value="F"<%="F".equals(sex)?" checked":"" %>><bean:message key="label.female" />
			<input type="radio" name="sex" value=""<%=!"M".equals(sex)&&!"F".equals(sex)?" checked":"" %>><bean:message key="label.all" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.homePhone" />/<br><bean:message key="prompt.mobilePhone" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="phoneNumber" value="<%=phoneNumber==null?"":phoneNumber %>" maxlength="20" size="25" />
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.hkid" />/<br><bean:message key="prompt.passport" /></td>
		<td class="infoData" width="35%">
			<input type="textfield" name="hkid" value="<%=hkid==null?"":hkid %>" maxlength="20" size="25" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.ownerSite" /></td>
		<td class="infoData" width="35%">
			<input type="radio" name="siteCode" value="" checked><bean:message key="label.all" /><BR>
			<input type="radio" name="siteCode" value="<%=ConstantsServerSide.SITE_CODE_HKAH %>"<%=ConstantsServerSide.SITE_CODE_HKAH.equals(siteCode)?" checked":"" %>><bean:message key="label.hkah" /><BR>
			<input type="radio" name="siteCode" value="<%=ConstantsServerSide.SITE_CODE_TWAH %>"<%=ConstantsServerSide.SITE_CODE_TWAH.equals(siteCode)?" checked":"" %>><bean:message key="label.twah" />
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.ownerDepartment" /></td>
		<td class="infoData" width="35%">
			<input type="radio" name="deptCode" value="" checked><bean:message key="label.all" /><BR>
			<input type="radio" name="deptCode" value="520"<%="520".equals(deptCode)?" checked":"" %>><bean:message key="department.520" /><BR>
			<input type="radio" name="deptCode" value="660"<%="660".equals(deptCode)?" checked":"" %>><bean:message key="department.660" /><BR>
			<input type="radio" name="deptCode" value="670"<%="670".equals(deptCode)?" checked":"" %>><bean:message key="department.670" /><BR>
			<input type="radio" name="deptCode" value="750"<%="750".equals(deptCode)?" checked":"" %>><bean:message key="department.750" />
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="4" align="center">
			<button type="submit"><bean:message key="button.search" /></button>
			<button type="reset"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>

</form>
<!-- End of Search panel -->

<form name="form1" action="<%=tabPanelName %>.jsp" method="post">
<%	if (!createAction && !updateAction) {%>
<bean:define id="functionLabel"><bean:message key="function.haa.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>

<div id="peopleData"></div>
<display:table id="row" name="requestScope.progress" requestURI="report.jsp?reportCode=reop" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
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

<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="HaaID" value="<%=haaID %>" />
<input type="hidden" name="seq" />
</form>
<script language="javascript">
	// insert neccessary hidden input in all forms
	$('form').append('<input type="hidden" name="reportCode" value="reop" />');

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
</script>