<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.web.db.model.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.math.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.zip.*"%>
<%@ page import="org.apache.commons.io.FilenameUtils"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.displaytag.tags.*"%>
<%@ page import="org.displaytag.util.*"%>
<%!
private void archiveFilesZip(HttpServletResponse response, String[] ids) {
	byte[] buffer = new byte[1024];
	try{
		ZipOutputStream zos = new ZipOutputStream(response.getOutputStream());
		
		ArrayList<ReportableListObject> list = ForwardScanningDB.getFilePathsByIds(StringUtils.split(ids[0], ","));
		if (list != null) {
			System.out.println(new Date() + " [Forward Scanning] Zipping image, size: " + list.size());
			long totalLen = 0l;
			Map<String, Integer> fullPaths = new HashMap<String, Integer>();
			
			for (int i = 0; i < list.size(); i++) {
				ReportableListObject row = list.get(i);
				String filePath = row.getFields0();
				String folder = row.getFields1();
				
				String fileName = FilenameUtils.getName(filePath);
				String fullPath = (folder == null ? "" : folder) + fileName;
				
				// check duplicate fullPath
				if (fullPaths.containsKey(fullPath)) {
					Integer count = fullPaths.get(fullPath);
					fullPaths.put(fullPath, count + 1); 
					
					// rename
					String newFileName = null;
					String[] temp = fileName.split("\\.");
					if (temp != null && temp.length == 2) {
						temp[0] = temp[0] + "_" + (count + 1);
						newFileName = temp[0] + "." + temp[1];
					} else {
						newFileName = fileName + "_" + (count + 1);
					}
					
					fullPath = (folder == null ? "" : folder) + newFileName;
				} else {
					fullPaths.put(fullPath, 1); 
				}
				//System.out.println("Adding file to zip - " + (i+1) + " : " + fullPath);
				
				ZipEntry ze= new ZipEntry(fullPath);
				try {
					File file = new File(filePath);
					ze.setTime(file.lastModified());
				} catch (Exception e) {
					System.out.println("[Forward Scanning] cannot access file:" + fullPath + ", err:" + e.getMessage());
				}
				
				zos.putNextEntry(ze);
				
				try {
					FileInputStream in = new FileInputStream(filePath);

					int len;
			    	while ((len = in.read(buffer)) > 0) {
			    		zos.write(buffer, 0, len);
			    		totalLen += len;
			    	}
			    	in.close();
				} catch (Exception fex) {
					System.out.println("[intranet] file_list Cannot access file: " + filePath + ", ex: " + fex.getMessage());
				}
			}
			//System.out.println("File len: " + totalLen);
		}
    	zos.closeEntry();
    	zos.close();
   	} catch (Exception ex) {
    	   ex.printStackTrace();
    }
}

private String getArchiveFileName(String patno) {
	String ret = null;
	SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMdd");
	String tsStr = tsFormat.format(new Date());
	ret = "HKAH-" + (ConstantsServerSide.isHKAH() ? "SR" : ConstantsServerSide.isTWAH() ? "TW" : "Other") + " Medical Record" + (patno == null || patno.isEmpty() ? "" : (" (Patient No. " + patno + ")")) + " - " + tsStr;
	return ret;
}
%>
<%
UserBean userBean = new UserBean(request);
String mode = ParserUtil.getParameter(request, "mode");
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String keyId = ParserUtil.getParameter(request, "keyId");
String[] fileIndexIds = request.getParameterValues("fileIndexIds");
String[] mergePdfFileIndexIds = null;

String importDateType = ParserUtil.getParameter(request, "importDateType");
String importDate = ParserUtil.getParameter(request, "importDate");
String importDateFrom = ParserUtil.getParameter(request, "importDateFrom");
String importDateTo = ParserUtil.getParameter(request, "importDateTo");
if (!"R".equals(importDateType)) {
	importDateFrom = importDate;
	importDateTo = importDate;
}
String importBy = ParserUtil.getParameter(request, "importBy");
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
if (approveStatus == null) { approveStatus = "N"; };
boolean showAutoImport = "Y".equals(ParserUtil.getParameter(request, "showAutoImport"));
boolean showHIS = "Y".equals(ParserUtil.getParameter(request, "showHIS"));
String downloadImagesPatno = ParserUtil.getParameter(request, "downloadImagesPatno");

String listTablePageParaName = (new ParamEncoder("row").encodeParameterName(TableTagParameters.PARAMETER_PAGE));
String listTableCurPage = request.getParameter(listTablePageParaName);
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

String listLabel = "function.fs.file.list";
String batchDeleteRemark = "Please enter either<br />(1) Patient No. to delete all file indexes of a patient. You can optionally specify Import Date, or";
String batchDeleteRemark2 = "or (2) Form Code and Import Date to delete file indexes of a particular form type on that day";
String batchDeleteRemark3 = "Both methods can optionally filter by Approve Status.";
boolean canBatchDelete = userBean.isLogin() && userBean.isAccessible("function.fs.file.delete");
Map<String, String> tooltips = new HashMap<String, String>();
tooltips.put("importBy","If more than 1 login IDs, separate them by comma i.e. 4000,4001");
tooltips.put("downloadImagesRemark1","Click 'Search' button to refresh the list before download images if search criteria have been changed.");

boolean deleteAction = false;
boolean batchDeleteAction = false;
boolean approveAction = false;
boolean downloadImagesAction = false;
boolean needsCheckMerge = false;
if ("delete".equals(command)) {
	deleteAction = true;
} else if ("batchDelete".equals(command) && canBatchDelete) {
	batchDeleteAction = true;
} else if ("approve".equals(command)) {
	approveAction = true;
} else if ("downloadImages".equals(command)) {
	downloadImagesAction = true;
}

try {
	if ("1".equals(step)
			&& userBean.getLoginID() != null) {
		if (deleteAction) {
			boolean success = ForwardScanningDB.deleteFsFile(userBean, keyId);
			if (success) {
				message = "Record is deleted.";
				
				needsCheckMerge = true;
				mergePdfFileIndexIds = new String[]{keyId};
			} else {
				errorMessage = "Record delete fail.";
			}
			deleteAction = false;
		} else if (batchDeleteAction) {
			boolean success = ForwardScanningDB.deleteFsFile(userBean, fileIndexIds);
			if (success) {
				message = "Records are deleted.";
				
				needsCheckMerge = true;
				mergePdfFileIndexIds = fileIndexIds;
			} else {
				errorMessage = "No record is deleted.";
			}
			deleteAction = false;
		} else if (approveAction) {
			boolean success = ForwardScanningDB.approveFileIndex(userBean, new String[]{keyId});
			if (success) {
				message = "Approval done.";
				
				needsCheckMerge = true;
				mergePdfFileIndexIds = new String[]{keyId};
			} else {
				errorMessage = "Approve fail.";
			}
			approveAction = false;
		} else if (downloadImagesAction) {
			downloadImagesAction = false;
			command = null;
			
	    	response.setContentType("application/zip, application/octet-stream");
			response.setHeader("Content-disposition", "attachment; filename=\"" + getArchiveFileName(downloadImagesPatno) + ".zip\"");
			archiveFilesZip(response, fileIndexIds);
			
			return;
		}
	}
	
	if(needsCheckMerge){
		List records = ForwardScanningDB.getListOfFsFilesByIds(mergePdfFileIndexIds);
			
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
} catch (Exception e) {
	e.printStackTrace();
}

List<FsFileIndex> file_list = FsModelHelper.searchFsFile(patno, regId, formName, formCode,
		pattype, dueDate, admDateFrom, admDateTo, dischargeDateFrom, dischargeDateTo, importDateFrom, importDateTo, approveStatus, batchNo,
		true, true, showAutoImport, showHIS, importBy);
request.setAttribute("file_list", file_list);
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
<form name="search_form" action="file_list.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
		<tr>
			<td colspan="6"><div id="patmerge_alert_box"></div></td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Import Date</td>
			<td class="infoData">
				<div id="importDateExact">
					<input type="text" name="importDate" class="datepickerfield" value="<%=importDate == null ? "" : importDate %>" maxlength="10" size="10" />
				</div>
				<div id="importDateRange">
					<table cellpadding="0" cellspacing="0" border="0">
						<tr>
							<td>From</td>
							<td><input type="text" name="importDateFrom" class="datepickerfield" value="<%=importDateFrom == null ? "" : importDateFrom %>" maxlength="10" size="10" /></td>
						</tr>
						<tr>
							<td>To</td>
							<td><input type="text" name="importDateTo" class="datepickerfield" value="<%=importDateTo == null ? "" : importDateTo %>" maxlength="10" size="10" /></td>
						</tr>
						<tr>
							<td></td>
							<td>
								<a name="showImportDateToday" href="javascript:void(0)">Today</a>&nbsp;&nbsp;<a name="clearImportDateToday" href="javascript:void(0)">Clear</a>
							</td>							
						</tr>
					</table>
				</div>
				<input type="hidden" name="importDateType" value="R" checked=checked /> 
			</td>
			<td class="infoLabel">Imported By<br />(Login ID)</td>
			<td class="infoData" colspan="3">
				<input type="text" name="importBy" id="importBy" value="<%=importBy == null ? "" : importBy %>" maxlength="200" size="60" title="<%=tooltips.get("importBy") %>" />
				<div style="font:italic;"><%=tooltips.get("importBy") %></div>
			</td>
		</tr>
		
		<tr class="smallText">
			<td class="infoLabel">Batch No</td>
			<td class="infoData"><input type="text" name="batchNo" id="batchNo" value="<%=batchNo == null ? "" : batchNo %>" size="10" /></td>
			<td class="infoData" colspan="4">
				<input type="checkbox" name="showAutoImport" value="Y"<%=showAutoImport ? " checked" : "" %>>Show Auto Import</input>&nbsp;
				<input type="checkbox" name="showHIS" value="Y"<%=showHIS ? " checked" : "" %>>Show Referral Lab (HIS)</input>
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
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>From</td>
						<td><input type="text" name="admDateFrom" id="admDateFrom" class="datepickerfield" value="<%=admDateFrom == null ? "" : admDateFrom %>" maxlength="10" size="10" /></td>
					</tr>
					<tr>
						<td>To</td>
						<td><input type="text" name="admDateTo" id="admDateTo" class="datepickerfield" value="<%=admDateTo == null ? "" : admDateTo %>" maxlength="10" size="10" /></td>
					</tr>
				</table>
			</td>
			<td class="infoLabel">Discharge Date</td>
			<td class="infoData">
				<table cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td>From</td>
						<td><input type="text" name="dischargeDateFrom" id="dischargeDateFrom" class="datepickerfield" value="<%=dischargeDateFrom == null ? "" : dischargeDateFrom %>" maxlength="10" size="10" /></td>
					</tr>
					<tr>
						<td>To</td>
						<td><input type="text" name="dischargeDateTo" id="dischargeDateTo" class="datepickerfield" value="<%=dischargeDateTo == null ? "" : dischargeDateTo %>" maxlength="10" size="10" /></td>
					</tr>
				</table>
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
		<tr class="smallText" id="batch_delete_remark" style="display:none;">
			<td colspan="6">
				* <%=batchDeleteRemark %><br /><%=batchDeleteRemark2 %><br /><%=batchDeleteRemark3 %>
			</td>
		</tr>
		<tr class="smallText" id="download_images_remark1" style="display:none;">
			<td colspan="6">
				* <%=tooltips.get("downloadImagesRemark1") %>
			</td>
		</tr>
		<tr class="smallText">
			<td colspan="6" align="center">
			<button id="btn_search" onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button id="btn_clear" onclick="return clearSearch();"><bean:message key="button.clear" /></button>
<% if (canBatchDelete && !file_list.isEmpty()) { %>
			<button id="btn_batchDelete" onclick="return submitAction2('batchDelete', 2);">Delete All</button>
<% } %>
			<button id="btn_downloadImages" onclick="return submitAction('downloadImages', 1);">Download Images in Zip</button>
			</td>
		</tr>
	</table>
	<input type="hidden" name="mode" value="<%=mode %>" />
	<input type="hidden" name="command" />
	<input type="hidden" name="step" />
	<input type="hidden" name="<%=listTablePageParaName %>" />
	<input type="hidden" name="fileIndexIds" />
	<input type="hidden" name="keyId" />
	<input type="hidden" name="downloadImagesPatno" value="<%=patno %>" />
</form>

<bean:define id="functionLabel"><bean:message key="<%=listLabel %>" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="file_list.jsp" method="post">
	<display:table id="row" name="requestScope.file_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter"
			decorator="com.hkah.web.displaytag.ForwardScanningDecorator">
	<%
		String recordId = null;
		String previewTitle = "";
		FsFileIndex thisFsFileIndex = null;
		if (pageContext.getAttribute("row") != null) {
			thisFsFileIndex = ((FsFileIndex) pageContext.getAttribute("row"));
			if (thisFsFileIndex != null && thisFsFileIndex.getFsFileIndexId() != null) {
				recordId = thisFsFileIndex.getFsFileIndexId().toPlainString();
				FsFileProfile profile = thisFsFileIndex.getFsFileProfile();
				if (profile != null) {
					previewTitle = profile.getFsFormCode() + " ";
				}
				previewTitle += thisFsFileIndex.getFsFormName();
			}
		}
	%>			
		<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
		<display:column style="width:5%" media="html" sortable="false">
			<a href="<%=FsModelHelper.getTempPdfToImagePath(thisFsFileIndex.getFsFilePath(), 1) %>" class="preview" title="<%=previewTitle %>">
				<img src="<html:rewrite page="/images/document_small.gif" />" />
			</a>
		</display:column>
		<display:column property="fsFileIndexId" title="ID" style="width:8%" />
		<display:column property="fsBatchNo" title="Batch No." style="width:8%" />
		<display:column property="fsImportDateDisplay" title="Import Date" style="width:10%" />
		<display:column property="fsImportedBy" title="Imported By" style="width:10%" />
		<display:column property="fsPatno" title="Pat. No." style="width:8%" />
		<display:column property="fsRegid" title="Reg. Id" style="width:10%" />
		<display:column property="formCodeAndRemark" title="Form Code" style="width:10%" />
		<display:column property="fsFormName" title="Form Name" style="width:20%" />
		<display:column property="fsDueDateDisplay" title="Document Date" style="width:10%" />
		<display:column property="fsAdmDateDisplay" title="Admission Date" style="width:10%" />
		<display:column property="fsDischargeDateDisplay" title="Discharge Date" style="width:10%" />
		<display:column title="Approve Status" style="width:10%" media="html">
	<%	if(thisFsFileIndex.isApproved()) { %>		
				<img src="<html:rewrite page="/images/tick_green_small.gif" />" alt="Approved" />
	<%  } else { %>
				<img src="<html:rewrite page="/images/cross_red_small.gif" />" alt="Not approve" />
	<%  } %>
		</display:column>
		<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
			<input type="hidden" name="fileIndexId" value="<%=recordId %>" />
			<button onclick="return submitAction('view', 1, '<%=recordId %>');"><bean:message key='button.view' /></button>
	<% if (userBean.isAccessible("function.fs.file.approve") && !thisFsFileIndex.isApproved()) { %>
				<button onclick="return submitAction('approve', 2, '<%=recordId %>');"><bean:message key='button.approve' /></button>
	<% } %>
		</display:column>
		<display:column property="fsPattype" title="Pat. Type" style="width:5%" />
		<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>" />
	</display:table>
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
				<%if (userBean.isAccessible("function.fs.file.create")) { %><button onclick="return submitAction('create', 0, '');"><bean:message key="button.create" /></button><% } %>
			</td>
		</tr>
	</table>
</form>
<script language="javascript">
//store file index list
<%
	List<String> fsFileIndexIds = new ArrayList<String>();
	if (file_list != null) {
		for (int i = 0; i < file_list.size(); i++) {
			FsFileIndex fsFileIndex = file_list.get(i);
			BigDecimal fsFileIndexId = fsFileIndex.getFsFileIndexId();
			if (fsFileIndexId != null)
				fsFileIndexIds.add(fsFileIndexId.toPlainString());
		}
	}
%>
	var fileIndexIds = [<%=StringUtils.join(fsFileIndexIds, ",") %>];
	
	$(document).ready(function(){
<%  if ("archive".equals(mode)) { %>
		$("#btn_downloadImages").show();
		$('#btn_batchDelete').hide();
		$('#download_images_remark1').show();
<% } else { %>
		$("#btn_downloadImages").hide();
		$('#download_images_remark1').hide();
<% } %>
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
		
		$("a[name=clearImportDateToday]").click(function(){
			$("input[name=importDateFrom]").val('');
			$("input[name=importDateTo]").val('');
		});
		
<% if (file_list.isEmpty()) { %>
			$('#btn_downloadImages').attr("disabled","disabled");
<% } %>

		$('#patno').keyup(function(){
			if ($('#patno').val().length > 5) {
				checkPatMerge($('#patno').val().trim());
			}
		});
		checkPatMerge($('#patno').val().trim());
		
		imagePreview({
			width: 900,
			height: $(window).height(),
			xOffset: -30,
			yOffset: -20
		});
		
		loadAllPdfToImage();
	});
	
	function loadAllPdfToImage() {
		var ids = [];
		$("form[name='form1'] input[name='fileIndexId']").each(function(){
			ids.push($(this).val());
		});
		if (ids.length > 0) {
			// ajax create image
			$.ajax({
				  type: 'POST',
				  url: 'createPdfImage.jsp',
				  data: {fileIndexIds: ids}
			});
		}
	}

	function submitSearch() {
		document.search_form.command.value = "";
		document.search_form.submit();
		showLoadingBox('body', 500, $(window).scrollTop());
		return false;
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
		document.search_form.importDate.value = "";
		document.search_form.pattype.value = "";
		return false;
	}
	
<% if (canBatchDelete) { %>
function enableBatchDeleteMode() {
	$('#regId').attr("disabled","disabled");
	$('#formName').attr("disabled","disabled");
	$('#dueDate').attr("disabled","disabled");
	$('#admDateFrom').attr("disabled","disabled");
	$('#admDateTo').attr("disabled","disabled");
	$('#dischargeDateFrom').attr("disabled","disabled");
	$('#dischargeDateTo').attr("disabled","disabled");
	$('#pattype').attr("disabled","disabled");
	
	$('#regId').addClass('disable_input');
	$('#formName').addClass('disable_input');
	$('#dueDate').addClass('disable_input');
	$('#admDateFrom').addClass('disable_input');
	$('#admDateTo').addClass('disable_input');
	$('#dischargeDateFrom').addClass('disable_input');
	$('#dischargeDateTo').addClass('disable_input');
	$('#pattype').addClass('disable_input');
	
	$('#batch_delete_remark').show();
	
	$('#btn_search').hide();
	$('#btn_clear').hide();
	$('#btn_batchDeleteMode').hide();
<%  if ("archive".equals(mode)) { %>
	$('#btn_batchDelete').hide();
<% } else { %>
	$('#btn_batchDelete').show();
<% } %>
	
	$('#btn_searchMode').show();
}

function disableBatchDeleteMode() {
	$('#regId').removeAttr("disabled");
	$('#formName').removeAttr("disabled");
	$('#dueDate').removeAttr("disabled");
	$('#admDateFrom').removeAttr("disabled");
	$('#admDateTo').removeAttr("disabled");
	$('#dischargeDateFrom').removeAttr("disabled");
	$('#dischargeDateTo').removeAttr("disabled");
	$('#pattype').removeAttr("disabled");
	
	$('#regId').removeClass('disable_input');
	$('#formName').removeClass('disable_input');
	$('#dueDate').removeClass('disable_input');
	$('#admDateFrom').removeClass('disable_input');
	$('#admDateTo').removeClass('disable_input');
	$('#dischargeDateFrom').removeClass('disable_input');
	$('#dischargeDateTo').removeClass('disable_input');
	$('#pattype').removeClass('disable_input');
	
	$('#batch_delete_remark').hide();
	
	$('#btn_search').show();
	$('#btn_clear').show();
	$('#btn_batchDeleteMode').show();
	$('#btn_batchDelete').hide();
	$('#btn_searchMode').hide();
}
	
function submitAction2(cmd, step) {
	if (step == '2') {	
		var promptMsg= 'Confirm to delete file index listed in the table?';
		$.prompt(promptMsg,{
			buttons: { Ok: true, Cancel: false },
			callback: function(v,m,f){
				if (v){
					submitAction2(cmd, 1);
					return true;
				} else {
					return false;
				}
			},
			prefix:'cleanblue'
		});
		
		return false;
	} else {
		document.search_form.command.value = cmd;
		document.search_form.step.value = step;
		document.search_form.fileIndexIds.value = fileIndexIds;
		document.search_form.submit();
		showLoadingBox('body', 500, $(window).scrollTop());
	}
}
<% } %>
	
	function submitAction(cmd, step, keyId) {
		if (step == '2') {			
			if (cmd == 'approve') {
				var promptMsg= 'Confirm to approve?';
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
		}
		
		if (cmd != 'view') {
			document.search_form.command.value = cmd;
			document.search_form.step.value = step;
			document.search_form.keyId.value = keyId;
			document.search_form.fileIndexIds.value = fileIndexIds;
			document.search_form.submit();
			
			if (cmd != 'downloadImages') {
				showLoadingBox('body', 500, $(window).scrollTop());
			}
			return false;
		} else {
			callPopUpWindow("file_detail.jsp?command=" + cmd + "&fileIndexId=" + keyId + "&listTablePageParaName=<%=listTablePageParaName %>" + "&listTableCurPage=<%=listTableCurPage %>");
			return false;
		}
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