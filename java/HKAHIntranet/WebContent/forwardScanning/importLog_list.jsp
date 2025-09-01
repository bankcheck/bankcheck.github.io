<%@ page import="java.math.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.web.db.model.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.displaytag.tags.*"%>
<%@ page import="org.displaytag.util.*"%>
<%@ page import="java.io.File"%>
<%!
public String getNotApproveCountMsg(List results) {
	if (results == null || results.isEmpty()) {
		return "";
	}
	String ret = "<br />Number of charts still waiting for approval:";
	for (int i = 0; i < results.size(); i++) {
		ReportableListObject rlo = (ReportableListObject) results.get(i);
		String patno = rlo.getValue(0);
		String count = rlo.getValue(1);
		boolean moreThan0 = false;
		try {
			if (Integer.parseInt(count) > 0) {
				moreThan0 = true;
			}
		} catch (Exception e) {}
			
		ret += "<br />" + (moreThan0 ? "<span class='alertText'>" : "") + "Patient No.: " + 
			patno + " (" + count + ")" + (moreThan0 ? "</span>" : "");
	}
	return ret;
}
%>
<%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String keyId = ParserUtil.getParameter(request, "keyId");

String importDateType = ParserUtil.getParameter(request, "importDateType");
String importDate = ParserUtil.getParameter(request, "importDate");
String importDateFrom = ParserUtil.getParameter(request, "importDateFrom");
String importDateTo = ParserUtil.getParameter(request, "importDateTo");
if (!"R".equals(importDateType)) {
	importDateFrom = importDate;
	importDateTo = importDate;
}
String batchNo = ParserUtil.getParameter(request, "batchNo");
String encodedParams = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "encodedParams"));
String importBy = ParserUtil.getParameter(request, "importBy");
if (importBy == null && ConstantsServerSide.isHKAH()) {
	importBy = "src0";
}
String recordType = ParserUtil.getParameter(request, "recordType");
String approveStatus = ParserUtil.getParameter(request, "approveStatus");
if (approveStatus == null) {
	approveStatus = "N";
}
String patno = ParserUtil.getParameter(request, "patno");

Boolean isShowSuccessRecord = null;
String[] fileIndexIds = request.getParameterValues("fileIndexIds");
/*
System.out.println("DEBUG: fsFileIndexes = [");
if (fileIndexIds != null) {
	for (String index : fileIndexIds) {
		System.out.print("," + index + ",");
	}
	System.out.println("]");
}
*/
String listTablePageParaName = (new ParamEncoder("row").encodeParameterName(TableTagParameters.PARAMETER_PAGE));
String listTableCurPage = request.getParameter(listTablePageParaName);
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

String listLabel = "function.fs.importLog.list";

Map<String, String> tooltips = new HashMap<String, String>();
tooltips.put("importBy","If more than one IDs, separate them by comma e.g. src04123,src05000");

boolean approveAction = false;
if ("approve".equals(command) || "approveAll".equals(command)) {
	approveAction = true;
}

try {
	if ("1".equals(step)
			&& userBean.getLoginID() != null) {
		if (approveAction) {			
			boolean success = ForwardScanningDB.approveFileIndex(userBean, fileIndexIds);
			//boolean success = false;
			if (success) {
				message = "Approve success.";
				message += getNotApproveCountMsg(ForwardScanningDB.getNotApproveCount(fileIndexIds));
			} else {
				errorMessage = "Approve fail.";
			}			
			approveAction = false;
			
			 Set<String> listOfPatNo = new TreeSet<String>();			 
			
			if("hkah".equals(ConstantsServerSide.SITE_CODE.toLowerCase())){
				ArrayList record = ForwardScanningDB.getFileIndexDetails(fileIndexIds);	
				if(record.size() != 0){			
					for(int r = 0; r < record.size(); r++){
						ReportableListObject row = (ReportableListObject)record.get(r);
						listOfPatNo.add(row.getValue(1));
						
					}
				}
				
				for(String tempPatNo : listOfPatNo){
					List records = ForwardScanningDB.getListOfFsFiles(tempPatNo);	
					
					StringBuffer sqlStr = new StringBuffer();
					if(records.size() != 0){			
						for(int r = 0; r < records.size(); r++){
							ReportableListObject row = (ReportableListObject)records.get(r);
							if( r == 0){
								sqlStr.append(row.getValue(0));
							} else {
								sqlStr.append(","+row.getValue(0));
							}
						}
						String[] array = new String[1];
						array[0] = sqlStr.toString();
						FsModelHelper.mergePdfFiles(ForwardScanningDB.getFileIndexDetails(array));								
					}	
				}
			}			
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

FsModelHelper helper = FsModelHelper.getInstance();
List<FsImportLog> importLog_list = helper.searchFsImportLog(importDateFrom, importDateTo, batchNo, encodedParams, importBy, recordType, approveStatus,patno);
request.setAttribute("importLog_list", importLog_list);

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
#patmerge_alert_box {
	padding: 5px;
	background: #ffff99;
	border: 1px solid #f0c36d;
	border-radius: 2px;
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
	box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

div.scroll {
    background-color: #E6E6E6;
    height: 200px;
    overflow: scroll;
}
</style>
<body>
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame style="min-height:0px;">
<jsp:include page="../common/page_title.jsp">
	<jsp:param name="pageTitle" value="<%= listLabel %>" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<jsp:include page="back.jsp" flush="false" />
<form name="search_form" action="importLog_list.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0" >
		<tr>
			<td colspan="2"><div id="patmerge_alert_box"></div></td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Patient No.</td>
			<td class="infoData">
				<input type="text" name="patno" id="patno" value="<%=patno == null ? "" : patno %>" maxlength="10" size="10" />
				<span style="width: 20px;"></span>
				<input type="checkbox" name="batchType" value="Y" /> show Referral Lab (HIS) batches only
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Import Date</td>
			<td class="infoData">
				<div id="importDateExact">
					<input type="text" name="importDate" class="datepickerfield" value="<%=importDate == null ? "" : importDate %>" maxlength="10" size="10" />
				</div>
				<div id="importDateRange">
					From 
					<input type="text" name="importDateFrom" class="datepickerfield" value="<%=importDateFrom == null ? "" : importDateFrom %>" maxlength="10" size="10" />
					To 
					<input type="text" name="importDateTo" class="datepickerfield" value="<%=importDateTo == null ? "" : importDateTo %>" maxlength="10" size="10" />
					&nbsp;<a name="showImportDateToday" href="javascript:void(0)">show today only</a>
				</div>
				<input type="hidden" name="importDateType" value="R" checked=checked /> 
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Batch No</td>
			<td class="infoData">
				<input type="text" name="batchNo" id="batchNo" value="<%=batchNo == null ? "" : batchNo %>" maxlength="20" size="10" />
<%
	Map<String, String> paths = FsModelHelper.getImportFileNamePaths(batchNo);
	if (paths != null && !paths.isEmpty()) {
%>
				<span>Imported file (Batch No: <%=batchNo == null ? "" : batchNo %>): 
<%
		Set<String> keys = paths.keySet();
		Iterator<String> itr = keys.iterator();
		while (itr.hasNext()) {
			String fileName = itr.next();
			String filePath = paths.get(fileName);
			filePath = filePath.replace("\\", "\\\\");
%>
					<a href="javascript:void(0);" onclick="downloadImportFile('<%=filePath %>')"><%=fileName %></a>
<%		} %>
				</span>
<% 	} %>

			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Any file index value</td>
			<td class="infoData">
				<input type="text" name="encodedParams" id="encodedParams" value="<%=encodedParams == null ? "" : encodedParams %>" maxlength="200" size="60" />
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Imported By (Login ID)</td>
			<td class="infoData">
				<input type="text" name="importBy" id="importBy" value="<%=importBy == null ? "" : importBy %>" maxlength="200" size="60" title="<%=tooltips.get("importBy") %>" />
				<div style="font:italic;"><%=tooltips.get("importBy") %></div>
			</td>
		</tr>			
		<tr class="smallText">
			<td class="infoLabel">Import Status</td>
			<td class="infoData">
				<input type="radio" name="recordType" value="A"<%="A".equals(recordType) || recordType == null?" checked":"" %> />All
				<input type="radio" name="recordType" value="S"<%="S".equals(recordType)?" checked":"" %> />Success
				<input type="radio" name="recordType" value="F"<%="F".equals(recordType)?" checked":"" %> />Fail
				<input type="radio" name="recordType" value="H"<%="H".equals(recordType)?" checked":"" %> />Handled
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Approve Status</td>
			<td class="infoData">
				<input type="radio" name="approveStatus" value="A"<%="A".equals(approveStatus) || approveStatus == null?" checked":"" %> />All
				<input type="radio" name="approveStatus" value="P"<%="P".equals(approveStatus)?" checked":"" %> />Approved
				<input type="radio" name="approveStatus" value="N"<%="N".equals(approveStatus)?" checked":"" %> />Not approve
				<input type="radio" name="approveStatus" value="I"<%="I".equals(approveStatus)?" checked":"" %> />File Invalid
			</td>
		</tr>
		<tr class="smallText">
			<td colspan="2" align="center">
				<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
				<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
<% if (userBean.isAccessible("function.fs.file.approve")) { %>
				<button onclick="return submitAction('approveAll', 0);" style="margin-left: 20px" <%=importLog_list.isEmpty() ? "disabled" : "" %>>Approve All</button>
<% } %>				
			</td>
		</tr>
	</table>
	<input type="hidden" name="<%=listTablePageParaName %>" />
	<input type="hidden" name="command" />
	<input type="hidden" name="step" />
	<input type="hidden" name="fileIndexIds" />
</form>
<form name="download_form" action="../documentManage/download.jsp">
	<input type="hidden" name="locationPath" />
</form>
<div style="margin: 10 0;">
Number of distinct patient in this list: <span id="patno_count" style="font-weight: bold;"></span>
</div>
<bean:define id="functionLabel"><bean:message key="<%=listLabel %>" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<%
	Map<String, Integer> patnosMap = new HashMap<String, Integer>();
%>
<form name="form1" action="importLog_list.jsp" method="post">
	<display:table id="row" name="requestScope.importLog_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter"
			decorator="com.hkah.web.displaytag.ForwardScanningDecorator">
	<%
		String recordId = null;
		String fileIndexId = null;
		FsImportLog thisFsImportLog = null;
		if (pageContext.getAttribute("row") != null) {
			thisFsImportLog = ((FsImportLog) pageContext.getAttribute("row"));
			if (thisFsImportLog != null && thisFsImportLog.getFsImportLogId() != null) {
				recordId = thisFsImportLog.getFsImportLogId().toPlainString();
				if (thisFsImportLog.getFsFileIndexId() != null)
					fileIndexId = thisFsImportLog.getFsFileIndexId().toPlainString();
				
				String encParam = thisFsImportLog.getFsEncodedParams();
				String[] params = encParam.split("&");
				String key = null;
				String value = null;
				String[] pair = null;
				for (String param : params) {
					if (param != null) {
						pair = param.split("=");
						if (pair != null && pair.length > 0) {
							key = pair[0];
							if(pair.length > 1) {
								value = pair[1];
							}
							if (FsModelHelper.indexFileHeader[0].equals(key)) {
								if (!patnosMap.containsKey(value)) {
									patnosMap.put(value, 1);
								} else {
									Integer count = patnosMap.get(value);
									patnosMap.put(value, count+1);
								}
							}
						}
					}
				}
			}
		}
	%>
		<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
		<display:column property="fsImportLogId" title="Log ID" style="width:5%" />
		<display:column property="fsBatchNo" title="Batch No." style="width:5%" />
		<display:column property="fsImportDateDisplay" title="Import Date" style="width:10%" />
		<display:column property="fsCreatedUser" title="Import By" style="width:10%" />
		<display:column property="fsEncodedParams" title="Import Values" media="csv excel xml pdf" />
		<display:column title="Import Values" style="width:50%;" media="html">
			<textarea name="encodedParams" rows="2" cols="100" readonly="readonly"><c:out value="${row.fsEncodedParams}" /></textarea>
		</display:column>
		<display:column title="Import Status" style="width:10%" media="html">
<%	if(thisFsImportLog.isImported()) { %>		
			<img src="<html:rewrite page="/images/tick_green_small.gif" />" alt="Success" />
			<!-- <button onclick="return submitAction('view_file', 1, '<%=fileIndexId %>');">View Entry</button>-->
<%  } else { %>
			<img src="<html:rewrite page="/images/cross_red_small.gif" />" alt="Fail" />
<%		if(thisFsImportLog.isHandled()) { %>	
			<div>(<img src="<html:rewrite page="/images/tick_amber_small.gif" />" alt="Handled" /> Handled)</div>
<% 		} %>		
<%  } %>
		</display:column>
		<display:column title="Approve Status" style="width:10%" media="html">
<%	if(!thisFsImportLog.isCorrFsFileIndexEnabled()) { %>
	File Invalid
<%  } else { %>
	<%	if(thisFsImportLog.isApproved()) { %>		
				<img src="<html:rewrite page="/images/tick_green_small.gif" />" alt="Approved" />
	<%  } else { %>
				<img src="<html:rewrite page="/images/cross_red_small.gif" />" alt="Not approve" />
	<%  } %>
<%  } %>	
		</display:column>
		<display:column property="imported" title="Imported" style="width:10%" media="csv excel xml pdf" />
		<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center;">
			<button onclick="return submitAction('view', 1, '<%=recordId %>');"><bean:message key='button.view' /></button>
<% if (userBean.isAccessible("function.fs.file.approve") && thisFsImportLog.canApprove()) { %>
			<button onclick="return submitAction('approve', 0, '<%=thisFsImportLog.getFsFileIndexId().toPlainString() %>');"><bean:message key='button.approve' /></button>
<% } %>
		</display:column>
		<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>" />
	</display:table>
	<input type="hidden" name="command" />
	<input type="hidden" name="step" />
	<input type="hidden" name="keyId" />
</form>
<script language="javascript">
//store file index list
<%
	List<String> fsFileIndexIds = new ArrayList<String>();
	if (importLog_list != null) {
		for (int i = 0; i < importLog_list.size(); i++) {
			FsImportLog fsImportLog = importLog_list.get(i);
			BigDecimal fsFileIndexId = fsImportLog.getFsFileIndexId();
			if (fsImportLog.canApprove() && fsFileIndexId != null)
				fsFileIndexIds.add(fsFileIndexId.toPlainString());
		}
	}
%>
	var patnosCount = [];
<%
StringBuffer patnosCountStr = new StringBuffer();
Iterator<String> itr = patnosMap.keySet().iterator();
	while (itr.hasNext()) {
		String key = itr.next();
		Integer count = patnosMap.get(key);
%>
	patnosCount['<%=key %>'] = '<%=count.toString() %>';
<%
	}

%>
	var fileIndexIds = [<%=StringUtils.join(fsFileIndexIds, ",") %>];
	
	$(document).ready(function(){
		$("input[name=batchType]").click(function(){
			if (this.checked) {
				$("input[name=encodedParams]").val("HIS");
			} else {
				if ($("input[name=encodedParams]").val() == 'HIS') {
					$("input[name=encodedParams]").val("");
				}
			}
		});
		
		$("#importDateRange").show();
		$("#importDateExact").hide();
		$("a[name=showImportDateToday]").click(function(){
			var d = new Date();
			var c_date = d.getDate();
			var c_month = d.getMonth() + 1;
			if (c_month < 10) {
				c_month = '0' + c_month;
			}
			var c_year = d.getFullYear();
			var c_dateStr = c_date + '/' + c_month + '/' + c_year;
			
			$("input[name=importDateFrom]").val(c_dateStr);
			$("input[name=importDateTo]").val(c_dateStr);
		});
		
		$('#patno').keyup(function(){
			if ($('#patno').val().length > 5) {
				checkPatMerge($('#patno').val().trim());
			}
		});
		checkPatMerge($('#patno').val().trim());
	});

	function submitSearch() {
		document.search_form.submit();
		showLoadingBox('body', 500, $(window).scrollTop());
		return false;
	}

	function clearSearch() {
		document.search_form.importDate.value = "";
		document.search_form.importDateFrom.value = "";
		document.search_form.importDateTo.value = "";
		//document.search_form.importDateType.checked = false;
		document.search_form.importBy.value = "";
		document.search_form.batchNo.value = "";
		document.search_form.batchType.checked = false;
		document.search_form.encodedParams.value = "";
		checkRadioByObj(document.search_form.recordType, 'A');
		checkRadioByObj(document.search_form.approveStatus, 'A');
		
		return false;
	}
	
	function submitAction(cmd, step, keyId) {
		if (cmd == 'approve' || cmd == 'approveAll') {
			if (step == 0) {
				var promptMsg;
				if (cmd == 'approve') {
					promptMsg = 'Confirm to approve?';
				} else if (cmd == 'approveAll') {
					promptMsg = 'Confirm to approve ALL item(s) in the list table(valid item only)?';
<% if("hkah".equals(ConstantsServerSide.SITE_CODE.toLowerCase())){ %>
					promptMsg += '<br />This action will also merge pdf files.';
<% } %>
					if (Object.getOwnPropertyNames(patnosCount).length > 2) {
						
						promptMsg += '<br /><br /><span style="color: #ff0000">Warning: Approve list contains MORE THAN 1 patient charts, number of patients: <%=patnosMap.size() %></span>';
						promptMsg += '<div class="scroll">';
						for (var propt in patnosCount){
							if (propt == null || propt == 'null') {
								patno = 'empty patno';
							} else {
								patno = propt;
							}
							promptMsg += patno + ' (' + patnosCount[propt] + ')<br />';
					     }
						promptMsg += '</div>';
					}
				}
				$.prompt(promptMsg,{
					buttons: { Ok: true, Cancel: false },
					callback: function(v,m,f){
						if (v){
							submit: submitAction(cmd, 1, keyId);
							return true;
						} else {
							return false;
						}
					},
					prefix:'cleanblue'
				});
				return false;
			}
			
			document.search_form.command.value = cmd;
			document.search_form.step.value = step;
			if (cmd == 'approve') {
				document.search_form.fileIndexIds.value = keyId;
			} else {
				document.search_form.fileIndexIds.value = fileIndexIds;
			}
			document.search_form.submit();
			showLoadingBox('body', 500, $(window).scrollTop());
			return true;
		} else if (cmd == 'view') {
			callPopUpWindow("importLog_detail.jsp?command=view&importLogId=" + keyId + "&listTablePageParaName=<%=listTablePageParaName %>" + "&listTableCurPage=<%=listTableCurPage %>");
			return false;			
		} else if (cmd == 'view_file') {
			callPopUpWindow("file_detail.jsp?command=view&fileIndexId=" + keyId);
			return false;			
		} else {
			document.form1.command.value = cmd;
			document.form1.step.value = step;
			document.form1.keyId.value = keyId;
			document.form1.submit();
			showLoadingBox('body', 500, $(window).scrollTop());
			return true;
		}
	}
	
	function downloadImportFile(path) {
		//document.download_form.action = "../documentManage/download.jsp";
		document.download_form.locationPath.value = path;
		document.download_form.submit();
	}
	
	function checkPatMerge(fmPatno) {
		$('#patmerge_alert_box').load('checkPatMerge.jsp?action=getToPatno&fmPatno=' + fmPatno + '&ts=' + (new Date().getTime()), 
				function( response, status, xhr ) {
			if (status == 'success') {
				$('#patmerge_alert_box').html( response );
				if (response.trim() == '') {
					$('#patmerge_alert_box').hide();
				} else {
					$('#patmerge_alert_box').show();
				}
				
			} else if ( status == "error" ) {
			    var msg = "Check patient merge error: ";
			    $( "#error" ).html( msg + xhr.status + " " + xhr.statusText );
			  }
			});
		
		$('#patmerge_alert_box').load('checkPatMerge.jsp?action=getFmPatno&fmPatno=' + fmPatno + '&ts=' + (new Date().getTime()), 
				function( response, status, xhr ) {
			if (status == 'success') {
				$('#patmerge_alert_box').html( response );
				if (response.trim() == '') {
					$('#patmerge_alert_box').hide();
				} else {
					$('#patmerge_alert_box').show();
				}
				
			} else if ( status == "error" ) {
			    var msg = "Check patient merge error: ";
			    $( "#error" ).html( msg + xhr.status + " " + xhr.statusText );
			  }
		});
	}
</script></DIV>

</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>