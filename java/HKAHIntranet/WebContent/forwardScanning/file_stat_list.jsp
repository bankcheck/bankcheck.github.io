<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.web.db.model.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.math.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.displaytag.tags.*"%>
<%@ page import="org.displaytag.util.*"%>
<%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String keyId = ParserUtil.getParameter(request, "keyId");
String[] fileIndexIds = request.getParameterValues("fileIndexIds");

String importDateFrm = ParserUtil.getParameter(request, "importDateFrm");
String importDateTo = ParserUtil.getParameter(request, "importDateTo");
boolean useImportDateTo = "Y".equals(ParserUtil.getParameter(request, "useImportDateTo"));
if (!useImportDateTo) {
	importDateTo = importDateFrm;
}
String batchNo = ParserUtil.getParameter(request, "batchNo");
String patno = ParserUtil.getParameter(request, "patno");
String regId = ParserUtil.getParameter(request, "regId");
String formName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "formName"));
String formCode = ParserUtil.getParameter(request, "formCode");
String pattype = ParserUtil.getParameter(request, "pattype");
String dueDate = ParserUtil.getParameter(request, "dueDate");
String admDateFrom = ParserUtil.getParameter(request, "admDateFrom");
String admDateTo = ParserUtil.getParameter(request, "admDateTo");
String dischargeDateFrom = ParserUtil.getParameter(request, "dischargeDateFrom");
String dischargeDateTo = ParserUtil.getParameter(request, "dischargeDateTo");
String approveStatus = ParserUtil.getParameter(request, "approveStatus");
boolean showAutoImport = "Y".equals(ParserUtil.getParameter(request, "showAutoImport"));
boolean showHIS = "Y".equals(ParserUtil.getParameter(request, "showHIS"));

String listTablePageParaName = (new ParamEncoder("row").encodeParameterName(TableTagParameters.PARAMETER_PAGE));
String listTableCurPage = request.getParameter(listTablePageParaName);
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
String listLabel = "function.fs.file_stat.list";

List<FsFileStat> file_stat_list = FsModelHelper.searchFsFileStat(patno, regId, formName, formCode,
		pattype, dueDate, admDateFrom, admDateTo, dischargeDateFrom, dischargeDateTo, importDateFrm, importDateTo, approveStatus, batchNo,
		true, true, showAutoImport, showHIS);
request.setAttribute("file_stat_list", file_stat_list);
BigDecimal[] statCounts = FsModelHelper.getStatCounts(file_stat_list);
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<style>
.disable_input { background: #a9a9a9; }
</style>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame style="min-height:0px;">
<jsp:include page="../common/page_title.jsp">
	<jsp:param name="pageTitle" value="<%= listLabel %>" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<jsp:include page="back.jsp" flush="false" />
<form name="search_form" action="file_stat_list.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
		<tr class="smallText">
			<td class="infoLabel">Import Date</td>
			<td class="infoData">
				<table>
					<tr>
				<td><span id="lb_importDateFrm">From:</span></td>
				<td><input type="text" name="importDateFrm" id="importDate" class="datepickerfield" value="<%=importDateFrm == null ? "" : importDateFrm %>" maxlength="10" size="10" /></td>
					</tr>
					<tr>
				<td><input type="checkbox" name="useImportDateTo" value="Y"<%=useImportDateTo ? " checked" : "" %>>To:</td>
				<td><input type="text" name="importDateTo" id="importDateTo" class="datepickerfield" value="<%=importDateTo == null ? "" : importDateTo %>" disabled="<%=useImportDateTo ? "" : "disabled" %>" maxlength="10" size="10" /></td>
					</tr>
				</table>
			</td>
			<td class="infoLabel">Batch No</td>
			<td class="infoData"><input type="text" name="batchNo" id="batchNo" value="<%=batchNo == null ? "" : batchNo %>" size="10" /></td>
			<td class="infoData" colspan="2">
				<input type="checkbox" name="showAutoImport" value="Y"<%=showAutoImport ? " checked" : "" %>>Include Auto Import</input>
				<input type="checkbox" name="showHIS" value="Y"<%=showHIS ? " checked" : "" %>>Include Referral Lab (HIS)</input>
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Patient No.</td>
			<td class="infoData"><input type="text" name="patno" id="patno" value="<%=patno == null ? "" : patno %>" maxlength="10" size="10" /></td>
			<td class="infoLabel">Reg. Id</td>
			<td class="infoData"><input type="text" name="regId" id="regId" value="<%=regId == null ? "" : regId %>" maxlength="22" size="10" /></td>
			<td class="infoLabel">Patient Type</td>
			<td class="infoData">
				<select name="pattype" id="pattype">
					<option value=""></option>
					<option value="I"<%="I".equals(pattype) ? " selected=\"selected\"" : "" %>>In-Patient</option>
					<option value="O"<%="O".equals(pattype) ? " selected=\"selected\"" : "" %>>Out-Patient</option>
					<option value="D"<%="D".equals(pattype) ? " selected=\"selected\"" : "" %>>Day Case</option>
				</select>
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Form Code</td>
			<td class="infoData"><input type="text" name="formCode" id="formCode" value="<%=formCode == null ? "" : formCode %>" maxlength="20" size="20" /></td>
			<td class="infoLabel">Form Name</td>
			<td class="infoData" colspan="3"><input type="text" name="formName" id="formName" value="<%=formName == null ? "" : formName %>" maxlength="200" size="70" /></td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Document Date</td>
			<td class="infoData" valign="top">
				<input type="text" name="dueDate" id="dueDate" class="datepickerfield" value="<%=dueDate == null ? "" : dueDate %>" maxlength="10" size="10" />
			</td>
			<td class="infoLabel">Admission Date</td>
			<td class="infoData">
				From 
				<input type="text" name="admDateFrom" id="admDateFrom" class="datepickerfield" value="<%=admDateFrom == null ? "" : admDateFrom %>" maxlength="10" size="10" />
				<br />To 
				<input type="text" name="admDateTo" id="admDateTo" class="datepickerfield" value="<%=admDateTo == null ? "" : admDateTo %>" maxlength="10" size="10" />
			</td>
			<td class="infoLabel">Discharge Date</td>
			<td class="infoData">
				From 
				<input type="text" name="dischargeDateFrom" id="dischargeDateFrom" class="datepickerfield" value="<%=dischargeDateFrom == null ? "" : dischargeDateFrom %>" maxlength="10" size="10" />
				<br />To 
				<input type="text" name="dischargeDateTo" id="dischargeDateTo" class="datepickerfield" value="<%=dischargeDateTo == null ? "" : dischargeDateTo %>" maxlength="10" size="10" />
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Approve Status</td>
			<td class="infoData" colspan="5">
				<input type="radio" name="approveStatus" value="A"<%="A".equals(approveStatus) || approveStatus == null?" checked":"" %> />All
				<input type="radio" name="approveStatus" value="P"<%="P".equals(approveStatus)?" checked":"" %> />Approved
				<input type="radio" name="approveStatus" value="N"<%="N".equals(approveStatus)?" checked":"" %> />Not approve
				<input type="radio" name="approveStatus" value="H"<%="H".equals(approveStatus)?" checked":"" %> />Lab old version (Not show in LIVE mode)
			</td>
		</tr>
		<tr class="smallText">
			<td colspan="6" align="center">
			<button id="btn_search" onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button id="btn_clear" onclick="return clearSearch();"><bean:message key="button.clear" /></button>
			</td>
		</tr>
	</table>
	<input type="hidden" name="command" />
	<input type="hidden" name="step" />
	<input type="hidden" name="<%=listTablePageParaName %>" />
	<input type="hidden" name="fileIndexIds" />
	<input type="hidden" name="keyId" />
</form>
<div id="statSummaryBox">
	<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
		<tr class="smallText">
			<td class="infoTitle" colspan="2">Summary (in this search)</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabe2" width="20%">Total No. of Patient</td>
			<td class="infoData" width="80%">
				<%=statCounts[1] %>
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabe2" width="20%">Total No. of File Index</td>
			<td class="infoData" width="80%">
				<%=statCounts[0] %>
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabe2" width="20%">Total No. of Imported Batch</td>
			<td class="infoData" width="80%">
				<%=statCounts[2] %>
			</td>
		</tr>		
	</table>
</div>
<bean:define id="functionLabel"><bean:message key="<%=listLabel %>" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="file_stat_list.jsp" method="post">
	<display:table id="row" name="requestScope.file_stat_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter"
			decorator="com.hkah.web.displaytag.ForwardScanningDecorator">
		<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
		<display:column property="fsPatno" title="Patient No." style="width:8%" />
		<display:column property="noOfBatch" title="Total Batch" style="width:10%" />
		<display:column property="noOfReg" title="Total Reg" style="width:8%" />
		<display:column property="noOfFileIndexAll" title="Total File" style="width:10%" />
		<display:column property="noOfFileIndexIp" title="Type (IP)" style="width:10%" />
		<display:column property="noOfFileIndexOp" title="Type (OP)" style="width:10%" />
<% if (ConstantsServerSide.isTWAH()) { %>		
		<display:column property="noOfFileIndexDc" title="Type (Day Case)" style="width:10%" />
<% } %>		
		<display:column property="noOfFileIndexOther" title="Type (Others)" style="width:10%" />
		<display:column property="fsFirstImportDateStr" title="Earliest Imp. Date" style="width:10%" />
		<display:column property="fsLatestImportDateStr" title="Latest Imp. Date" style="width:10%" />
		<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>" />
	</display:table>
</form>
<script language="javascript">
	$(document).ready(function() {
		$('input[name=useImportDateTo]').click(function(){
			controlImportDate(this.checked);
		});
		
		controlImportDate(<%=useImportDateTo %>);
	});
	
	function controlImportDate(enabled) {
		if (enabled) {
			$('input[name=importDateTo]').attr("disabled","");
			$('input[name=importDateTo]').removeClass('disable_input');
			$('#lb_importDateFrm').show();
		} else {
			$('input[name=importDateTo]').attr("disabled","disabled");
			$('input[name=importDateTo]').addClass('disable_input');
			$('input[name=importDateTo]').val("");
			$('#lb_importDateFrm').hide();
		}
	}

	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.patno.value = "";
		document.search_form.regId.value = "";
		document.search_form.formCode.value = "";
		document.search_form.formName.value = "";
		document.search_form.dueDate.value = "";
		document.search_form.admDateFrom.value = "";
		document.search_form.admDateTo.value = "";
		document.search_form.dischargeDateFrom.value = "";
		document.search_form.dischargeDateTo.value = "";
		document.search_form.importDateFrm.value = "";
		document.search_form.importDateTo.value = "";
		$('input[name=useImportDateTo]').attr("checked", "");
		controlImportDate(false);
		document.search_form.pattype.value = "";
		return false;
	}
</script></DIV>

</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>