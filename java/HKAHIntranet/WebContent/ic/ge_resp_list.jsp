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
tabPanelName = tabPanelName == null ? "report" : tabPanelName;
String reportCode = ParserUtil.getParameter(request, "reportCode");

String haaID = ParserUtil.getParameter(request, "HaaID");
String caseNum = ParserUtil.getParameter(request, "caseNum");
String corporationName = ParserUtil.getParameter(request, "corporationName");
String businessType = ParserUtil.getParameter(request, "businessType");
String contractDateFrom = ParserUtil.getParameter(request, "contractDateFrom");
String contractDateTo = ParserUtil.getParameter(request, "contractDateTo");
String enabled = ParserUtil.getParameter(request, "enabled");

String caseNumTemp = null;
String initDate = ParserUtil.getParameter(request, "initDate");
String completeDate = ParserUtil.getParameter(request, "completeDate");

String siteCode = request.getParameter("siteCode");
String deptCode = request.getParameter("deptCode");



// bld_mrsa_esbl
String labNo = ParserUtil.getParameter(request, "labNo");
String FromDateIn = ParserUtil.getParameter(request, "FromDateIn");
String ToDateIn = ParserUtil.getParameter(request, "ToDateIn");
String TOCC = ParserUtil.getParameter(request, "TOCC");
String fever38C = ParserUtil.getParameter(request, "fever38C");
String admit_icu = ParserUtil.getParameter(request, "admit_icu");
String hai_cai = ParserUtil.getParameter(request, "hai_cai");
String oahr = ParserUtil.getParameter(request, "oahr");
String remark = ParserUtil.getParameter(request, "remark");
String onset_date = ParserUtil.getParameter(request, "onset_date");
String dv = ParserUtil.getParameter(request, "DV");
String icType = ParserUtil.getParameter(request, "icType");

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
boolean searchAction = false;

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
} else {
	searchAction = true;
}

/**
* Handle actions
*/
try {
	System.out.println("ictype : " + icType);
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
				message = "GE Resp created.";
				createAction = false;
			} else {
				errorMessage = "GE Resp create fail.";
			}
		/**
		* Update
		*/
		} else if (updateAction) {
			boolean doUpdateAction = true;
			if (doUpdateAction) {
				message = "GE Resp updated.";
				updateAction = false;
			} else {
				errorMessage = "GE Resp update fail.";
			}
		/**
		* Delete
		*/
		} else if (deleteAction) {
			boolean doDeleteAction = ICBldMrsaEsblDB.delete(userBean, caseNum);
			if (doDeleteAction) {
				message = "GE Resp deleted.";
			} else {
				errorMessage = "GE Resp delete fail.";
			}
			deleteAction = false;
		/**
		* Other actions
		*/	
		} else if (updateDateAction) {
//		    boolean doOtherAction = ICBldMrsaEsblDB.updateGe_Resp(userBean, caseNum, TOCC, fever38C, onset_date, dv, admit_icu, hai_cai, oahr, remark, caseNum, enabled);
			boolean doOtherAction = false;
			if (doOtherAction) {				
				message = "GE Resp updated";
			} else {
				errorMessage = "GE Resp update fail";
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
/*		if (haaID != null && haaID.length() > 0) {
			ArrayList record = BldMrsaEsblDB.get(userBean, haaID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				corporationName = row.getValue(1);
				businessType = row.getValue(2);
				contractDateFrom = row.getValue(3);
				contractDateTo = row.getValue(4);
				enabled = row.getValue(5);
			}
		}
	*/	
		if (searchAction) {
			if (FromDateIn == null) {
				FromDateIn = DateTimeUtil.getCurrentDate();
			}
			if (ToDateIn == null) {
				ToDateIn = DateTimeUtil.getCurrentDate();
			}	
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

System.out.println("labNo, FromDateIn, ToDateIn, icType : " + labNo + " " + FromDateIn + " " + ToDateIn + " " + icType);
System.out.println(ConstantsServerSide.SITE_CODE);
request.setAttribute("progress", IcGeRespDB.getList(labNo, FromDateIn, ToDateIn, icType ));

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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
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
	title = "function.ic.bld_mrsa_esbl." + commandType;

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
	<tr class="smallText">
		<td class="infoLabel" width="15%">Lab No</td>
		<td class="infoData" width="35%" colspan="3">
			<input type="text" name="labNo" value="<%=labNo==null?"":labNo %>" maxlength="10" size="25" />
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="15%">From Case Date</td>
		<td class="infoData" width="35%" colspan="3">
			<input type="text" name="FromDateIn" id="FromDateIn" class="datepickerfield" value="<%=FromDateIn==null?"":FromDateIn %>" maxlength="10" size="25" />
		</td>
		<td class="infoLabel" width="15%">To Case Date</td>
		<td class="infoData" width="35%" colspan="3">
			<input type="text" name="ToDateIn" id="ToDateIn" class="datepickerfield" value="<%=ToDateIn==null?"":ToDateIn %>" maxlength="10" size="25" />
		</td>
	</tr>	
	
	<tr class="smallText">
		<td colspan="4" align="center">
			<button type="submit"><bean:message key="button.search" /></button>
			<button type="reset"><bean:message key="button.clear" /></button>
			<button onclick="return submitAction('create', '');">Create</button>
		</td>
	</tr>
</table>
</form>
<!-- End of Search panel -->

<form name="form1" action="ge_resp.jsp" method="post">
<%	if (!createAction && !updateAction) {%>
<bean:define id="functionLabel"><bean:message key="function.ic.ge_resp.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>

<div id="peopleData"></div>
<div id="displaytable" style="overflow: auto; width: 2750px;">
<display:table id="row" name="requestScope.progress" requestURI="report.jsp?reportCode=ge_resp" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>">
<%		
	if ((ReportableListObject)pageContext.getAttribute("row") != null)
		caseNumTemp = ((ReportableListObject)pageContext.getAttribute("row")).getFields1();  
%>
	<display:column property="fields1" title="Case Num" />	
	<display:column property="fields2" title="Case Date" />
	<display:column property="fields3" title="Lab Num" />		
	<display:column property="fields4" title="Patient No" />
	<display:column property="fields5" title="Name"  />
	<display:column property="fields6" title="Sex"  />
	<display:column property="fields7" title="Birth Date"  />
	<display:column property="fields8" title="Age"  />
	<display:column property="fields9" title="Month"  />
	<display:column property="fields10" title="Ward"  />
	<display:column property="fields11" title="Room"  />
	<display:column property="fields12" title="Bed"  />		
	<display:column property="fields13" title="Acc. date"  />
	<display:column title="Action">
<%	if (((ReportableListObject)pageContext.getAttribute("row")).getFields2() != "") {  %>
<%		if (updateDateAction && caseNumTemp.equals(caseNum)) { %>
		<button onclick="return submitAction('<%=commandType %>', 1, '<c:out value="${row.fields1}" />');" class="btn-click"><bean:message key="button.save" /></button>
		<button onclick="return submitAction('view', 0, '<c:out value="${row.fields1}" />');" class="btn-click"><bean:message key="button.cancel" /></button>
<%		} else { %>
		<button onclick="return submitAction('updateDate', 0, '<c:out value="${row.fields0}"/>' , '<c:out value="${row.fields1}" />');" class="btn-click"><bean:message key="button.update" /></button>
<%		}  %>
<%	}  %>
	</display:column>	
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</div>
<%	} %>

<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="caseNum" value="<%=caseNum %>" />
<input type="hidden" name="icType" value="<%=icType %>" maxlength="12" size="15" />
</form>
<jsp:include page="../common/header_js_init.jsp" flush="false" />
<script language="javascript">
$(document).ready(function() {
	// insert neccessary hidden input in all forms
	$('form').append('<input type="hidden" name="reportCode" value="<%=icType %>" />');
});

	function submitAction(cmd, stp, sitecode, caseNum) {
//		console.log(cmd + " " + sitecode + " " + caseNum);
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&ICSiteCode=" + sitecode + "&CaseNum=" + caseNum + "&icType=<%=icType %>");
		return false;
	}
	
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
	}
	
</script>