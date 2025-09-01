<%@ page import="java.net.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.web.db.model.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
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
String moduleCode = ParserUtil.getParameter(request, "moduleCode");
String listTablePageParaName = ParserUtil.getParameter(request, "listTablePageParaName");
String listTableCurPage = ParserUtil.getParameter(request, "listTableCurPage");

String fileIndexId = ParserUtil.getParameter(request, "fileIndexId");
String fileProfileId = ParserUtil.getParameter(request, "fileProfileId");
String patno = ParserUtil.getParameter(request, "patno");
String regId = ParserUtil.getParameter(request, "regId");
String formName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "formName"));
String formCode = ParserUtil.getParameter(request, "formCode");
String pattype = ParserUtil.getParameter(request, "pattype");
String filePath = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "filePath"));
String admDate = ParserUtil.getParameter(request, "admDate");
String dischargeDate = ParserUtil.getParameter(request, "dischargeDate");
String dueDate = ParserUtil.getParameter(request, "dueDate");
String importDate = ParserUtil.getParameter(request, "importDate");
String seq = ParserUtil.getParameter(request, "seq");
String stnid = ParserUtil.getParameter(request, "stnid");
String key = ParserUtil.getParameter(request, "key");
String labNum = ParserUtil.getParameter(request, "labNum");
String risAccessionNo = ParserUtil.getParameter(request, "risAccessionNo");
String categorySelect = ParserUtil.getParameter(request, "categorySelect");
boolean isApproved = false;
String icdCode = null;
String icdName = null;
boolean isReferralLab = false;

FsModelHelper helper = FsModelHelper.getInstance();
List<FsCategory> fsCategories = null;
FsCategory itemCategory = null;
String itemCategoryId = null;
LinkedHashMap<String, String> catBreadCrumb = null;

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean approveAction = false;
boolean refreshOpenerList = false;
boolean isUpdateFile = false;
boolean needsCheckMerge = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("approve".equals(command)) {
	approveAction = true;
}
try {
	if ("1".equals(step)) {
		if (fileUpload) {
			String[] fileList = (String[]) request.getAttribute("filelist");
			if (fileList != null && fileList.length > 0) {
				String path = null;
				if (filePath != null && filePath.startsWith("\\\\")) {
					path = filePath.substring(0, StringUtils.lastIndexOf(filePath, "\\") + 1);
				} else {
					try {
						URL url = new URL(filePath);
						path = url.getPath();
					} catch (MalformedURLException e) {
						errorMessage = "File path is invalid.";
					}
				}
				
				String newUrl = path + fileList[0];
				FileUtil.moveFile(
						ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[0],
						newUrl);
				
				if (path != null) {
					filePath = newUrl;
					isUpdateFile = true;
				}
			}
		}
		
		if (createAction) {
			// call db insert corporation name, business type
			FsFileIndex fsFileIndex = FsModelHelper.addFsFiles(userBean, patno, regId, 
				formName, formCode, pattype, filePath, admDate, dischargeDate, dueDate, importDate, seq, categorySelect, 
				icdCode, icdName, labNum, stnid, key, risAccessionNo);
			if (fsFileIndex != null) {
				fileIndexId = fsFileIndex.getFsFileIndexId().toPlainString();
				message = "File index created.";
				createAction = false;
				refreshOpenerList = true;
			} else {
				errorMessage = "File index create fail.";
			}
			createAction = false;
		} else if (updateAction) {
			FsFileIndex fsFileIndex = FsModelHelper.updateFsFiles(userBean, fileIndexId, fileProfileId, patno, regId, 
				formName, formCode, pattype, filePath, admDate, dischargeDate, dueDate, importDate, seq, categorySelect, 
				icdCode, icdName, labNum, stnid, key, risAccessionNo);
			if (fsFileIndex != null) {
				String msg = "File index updated.";
				if (isUpdateFile) {
					if (FsModelHelper.revertApprove(userBean, fsFileIndex)) {
						msg += " This record is set to UNAPPROVED because image has been replaced.";
					} else {
						msg += " FAIL to set record to unapprove.";
					}
				}
				message = msg;
				updateAction = false;
				refreshOpenerList = true;
				needsCheckMerge = true;
			} else {
				errorMessage = "File index update fail.";
			}
			updateAction = false;
		} else if (deleteAction) {
			boolean success = ForwardScanningDB.deleteFsFile(userBean, fileIndexId);
			//boolean success = true;
			if (success) {
				message = "File index deleted.";								
				deleteAction = false;
				refreshOpenerList = true;
				needsCheckMerge = true;
			} else {
				errorMessage = "File index delete fail.";
			}
			deleteAction = false;
		} else if (approveAction) {
			boolean success = ForwardScanningDB.approveFileIndex(userBean, new String[]{fileIndexId});
			if (success) {
				message = "Approval done.";
			} else {
				errorMessage = "Approve fail.";
			}
			approveAction = false;
			needsCheckMerge = true;
		}
		step = null;
	}
	
	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (fileIndexId != null && fileIndexId.length() > 0) {
			FsFileIndex fsFileIndex = FsModelHelper.getFsFile(fileIndexId);
			if (fsFileIndex != null) {
				FsFileProfile fsFileProfile = fsFileIndex.getFsFileProfile();
				
				fileIndexId = fsFileIndex.getFsFileIndexId() != null ? fsFileIndex.getFsFileIndexId().toPlainString() : null;
				patno = fsFileIndex.getFsPatno();
				regId = fsFileIndex.getFsRegid();
				formName = fsFileIndex.getFsFormName();
				pattype = fsFileIndex.getFsPattype();
				filePath = fsFileIndex.getFsFilePath();
				admDate = DateTimeUtil.formatDate(fsFileIndex.getFsAdmDate());
				dischargeDate = DateTimeUtil.formatDate(fsFileIndex.getFsDischargeDate());
				dueDate = DateTimeUtil.formatDate(fsFileIndex.getFsDueDate());
				importDate = DateTimeUtil.formatDate(fsFileIndex.getFsImportDate());
				seq = fsFileIndex.getFsSeq();
				stnid = fsFileIndex.getFsFileProfile().getFsStnid();
				labNum = fsFileIndex.getFsLabNum();
				key = fsFileIndex.getFsFileProfile().getFsKey();
				risAccessionNo = fsFileIndex.getFsFileProfile().getFsRisAccessionNo();
				isApproved = fsFileIndex.isApproved();
				if (fsFileProfile != null) {
					fileProfileId = fsFileProfile.getFsFileProfileId() != null ? fsFileProfile.getFsFileProfileId().toPlainString() : null;
					formCode = fsFileProfile.getFsFormCode();
					
					icdCode = fsFileProfile.getFsIcdCode();
					icdName = fsFileProfile.getFsIcdName();
					itemCategory = fsFileIndex.getFsFileProfile().getFsCategory();
					if (itemCategory.getFsCategoryId() != null)
						itemCategoryId = itemCategory.getFsCategoryId().toPlainString();
					isReferralLab = fsFileProfile.isReferralLab();
				}
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
	
	
	fsCategories = helper.getGeneralCategoryList();
	if (!createAction) 
		catBreadCrumb = FsModelHelper.getCategoryBreadCrumb(fsCategories, itemCategoryId);
	
	if(needsCheckMerge){
		List records = ForwardScanningDB.getListOfFsFiles(patno);	
			
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
	// == DEBUG ==
	//helper.printCategoryTree(false);
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
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html>
<jsp:include page="../common/header.jsp"/>
<style>
.highlight {
	color: blue;
}
.normal {
	color: black;
}
.matchedCat {
	font-weight: bold;
	font-size: 120%;
	color: blue;
}
</style>
<% if (refreshOpenerList) { %>
<script type="text/javascript">
if (opener && opener.document.search_form) {
	var form = opener.document.search_form;
	form.elements["<%=listTablePageParaName %>"].value = "<%=listTableCurPage %>";
	form.submit();
}
</script>
<% } %>
<% if (closeAction) { %>
<script type="text/javascript">

window.close();

</script>
<% } else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
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

	// set submit label
	String title = "function.fs.file." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" enctype="multipart/form-data" action="file_detail.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="6">File Index</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="150px">Import Date</td>
		<td class="infoData">
			<%=importDate == null ? "" : importDate %>
		</td>
		<td class="infoLabel" width="150px">Approve Status</td>
		<td class="infoData">
	<%	if(isApproved) { %>		
			<img src="<html:rewrite page="/images/tick_green_small.gif" />" alt="Approved" />
	<%  } else { %>
			<img src="<html:rewrite page="/images/cross_red_small.gif" />" alt="Not approve" />
			<% if (userBean.isAccessible("function.fs.file.approve")) { %><button onclick="return submitAction('approve', 2);"><bean:message key='button.approve' /></button><% } %>
	<%  } %>
		</td>
		<td class="infoLabel" width="150px"></td>
		<td class="infoData"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="150px">Patient No</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="patno" value="<%=patno == null ? "" : patno %>" maxlength="10" size="20" />
<%	} else { %>
			<%=patno == null ? "" : patno %>
<%	} %>
		</td>
		<td class="infoLabel" width="150px">Reg. Id</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="regId" value="<%=regId == null ? "" : regId %>" maxlength="10" size="20" />
<%	} else { %>
			<%=regId == null ? "" : regId %>
<%	} %>
		</td>
		<td class="infoLabel" width="150px">Patient Type</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="pattype" id="pattype" value="<%=pattype == null ? "" : pattype %>" maxlength="5" size="2" />
			<span>I - Inpatient, O - Out-patient, D - Daycase</span>
<%	} else { %>
			<%=FsModelHelper.pattypes.get(pattype) == null ? "" : FsModelHelper.pattypes.get(pattype) %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="150px">Form</td>
		<td class="infoData" colspan="5">
<%	if (createAction || updateAction) { %>
			<div>
				<span class="infoLabelInData">Code: </span>
				<input type="text" name="formCode" value="<%=formCode == null ? "" : formCode %>" maxlength="50" size="20" />
				<span class="infoLabelInData">Name: </span>
				<input type="text" name="formName" value="<%=formName == null ? "" : formName %>" maxlength="200" size="80" />
			</div>
			<div style="margin:2px">
				<span class="italic"> Search: </span>
			<select name="formCode2" style="background: #CCCCCC;">
<jsp:include page="../ui/fsFormCMB.jsp" flush="false">
	<jsp:param name="formCode" value=" " />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			</select>
			</div>
<%	} else { %>
			<%=formCode == null ? "" : formCode %> - <%=formName == null ? "" : formName %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="150px">File Path</td>
		<td class="infoData" colspan="5">
<% String escapeFilePath = URLEncoder.encode((filePath != null ? filePath.replace("\\", "\\\\") : "")); %>
			<input type="hidden" name="filePath" value="<%=filePath == null ? "" : filePath %>" />
<a href="javascript:void(0);" onclick="openFilePreview('<%=escapeFilePath %>')"><%=filePath == null ? "" : filePath %></a>
<%	if (createAction || updateAction) { %>
			<div>
				Replace by: <span id="file1_box"><input type="file" id="file1" name="file1" size="100" maxlength="200" /></span>
				<button onclick="refreshUploader();" class="btn-click"><bean:message key="button.clear" /></button>
			</div>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="150px">Document Date</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="dueDate" value="<%=dueDate == null ? "" : dueDate %>" maxlength="10" size="10"
					class="datepickerfield" onkeyup="validDate(this)" onblur="validDate(this)"/>
<%	} else { %>
			<%=dueDate == null ? "" : dueDate %>
<%	} %>
		</td>
		<td class="infoLabel" width="150px">Admission Date</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="admDate" value="<%=admDate == null ? "" : admDate %>" maxlength="10" size="10"
					class="datepickerfield" onkeyup="validDate(this)" onblur="validDate(this)"/>
<%	} else { %>
			<%=admDate == null ? "" : admDate %>
<%	} %>
		</td>
		<td class="infoLabel" width="150px">Discharge Date</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="dischargeDate" value="<%=dischargeDate == null ? "" : dischargeDate %>" maxlength="10" size="10"
					class="datepickerfield" onkeyup="validDate(this)" onblur="validDate(this)"/>
<%	} else { %>
			<%=dischargeDate == null ? "" : dischargeDate %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="150px">ICD</td>
		<td class="infoData" colspan="3">
			<%=icdCode == null ? "" : icdCode %> - 
			<%=icdName == null ? "" : icdName %>
		</td>
		<td class="infoLabel" width="150px">Order Seq</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="seq" value="<%=seq == null ? "" : seq %>" maxlength="2" size="5" />
<%	} else { %>
			<%=seq == null ? "" : seq %>
<%	} %>
		</td>
	</tr>
	
	<tr class="smallText">
		<td class="infoLabel" width="150px">STNID</td>
		<td class="infoData" colspan="5">
<%	if (createAction || updateAction) { %>
			<input type="text" name="stnid" value="<%=stnid == null ? "" : stnid %>" maxlength="50" size="15" />
<%	} else { %>
			<%=stnid == null ? "" : stnid %>
<%	} %>
		</td>
	</tr>	
	
	
	<tr class="smallText">
		<td class="infoLabel" width="150px">General Key</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="key" value="<%=key == null ? "" : key %>" maxlength="50" size="20" />
<%	} else { %>
			<%=key == null ? "" : key %>
<%	} %>
		</td>
		<td class="infoLabel" width="150px">Lab No.</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="labNum" value="<%=labNum == null ? "" : labNum %>" maxlength="8" size="10" />
<%	} else { %>
			<%=labNum == null ? "" : labNum %>
<%	} %>
		</td>
		<td class="infoLabel" width="150px">RIS Accession No</td>
		<td class="infoData">
<%	if (createAction || updateAction) { %>
			<input type="text" name="risAccessionNo" value="<%=risAccessionNo == null ? "" : risAccessionNo %>" maxlength="64" size="20" />
<%	} else { %>
			<%=risAccessionNo == null ? "" : risAccessionNo %>
<%	} %>
		</td>		
	</tr>
	
	
	<tr class="smallText">
		<td class="infoLabel" width="150px">Category<br />(to which belongs)</td>
		<td class="infoData" colspan="5">
			<ul id="browser" class="filetree">
				<p style="padding: 5px; border: 1px solid grey">
[<%=formCode %>(<%=pattype %>)]: 
<%
	if (catBreadCrumb != null) {
		Set<String> keys = catBreadCrumb.keySet();
		Iterator<String> it = keys.iterator();
		while (it.hasNext()) {
			String catId = it.next();
			String catTitle = catBreadCrumb.get(catId);
%>
	<% if (it.hasNext()) { %>
		<%=catTitle %><span style="font-weight: bold;">&nbsp;&nbsp;&nbsp;&gt;&nbsp;</span>
	<% } else { %>
		<span class="matchedCat"><%=catTitle %></span>
	<% } %>
<%
		}
	} else if (createAction) {
%>
					Select a category below.
<%	} else { %>
					No category matched.
<%	} %>
				</p>
				<%=FsModelHelper.getFsCategoryTreeHTML(fsCategories, itemCategory, createAction || updateAction, catBreadCrumb) %>
			</ul>
		</td>
	</tr>
</table>
<div class="pane">
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
	<%	if (createAction || updateAction || deleteAction) { %>
				<button onclick="return submitAction('<%=commandType %>', 2);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
	<%		if (updateAction || deleteAction) { %>
				<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
	<%		} %>
	<%	} else { %>
				<%if (userBean.isAccessible("function.fs.file.update")) { %><button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.fs.file.update" /></button><%} %>
				<%if (userBean.isAccessible("function.fs.file.delete")) { %><button class="btn-delete"><bean:message key="function.fs.file.delete" /></button><%} %>
	<%	}  %>
			</td>
		</tr>
	</table>
</div>
<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="fileIndexId" value="<%=fileIndexId==null?"":fileIndexId %>" />
<input type="hidden" name="fileProfileId" value="<%=fileProfileId==null?"":fileProfileId %>" />
<input type="hidden" name="importDate" value="<%=importDate == null ? "" : importDate %>" />
<input type="hidden" name="listTablePageParaName" value="<%=listTablePageParaName %>" />
<input type="hidden" name="listTableCurPage" value="<%=listTableCurPage %>" />
<%	if (createAction || updateAction ) { %>
<%  } else { %>
<input type="hidden" name="patno" value="<%=patno==null?"":patno %>" />
<%  } %>
</form>
<script language="javascript">
	$().ready(function(){
		//$('select[name=formCode2]').hyjack_select({ restrictSearch: true });
		//$('select[name=formCode2]').combobox();
		$('select[name=formCode2]').change(function() {
			$('select[name=formCode2] option:selected').each(function () {
                var text = $(this).text();
                var form = text.split(" - ");
                formCode = form[0];
                formName = text.split(' - ').splice(1).join(' - ');
                
                $('input[name=formCode]').val(formCode);
                $('input[name=formName]').val(formName);
                var pattype = $('input[name=pattype]').val();
                
                $.ajax({
        			url: '../forwardScanning/getFsDB.jsp?formCode='+formCode+"&pattype="+pattype,
        			async: true,
        			cache: false,
        			success: function(values){
        				if(values) {        					
        					$('input[name="categorySelect"][value="' + $.trim(values) + '"]').attr("checked","checked");
        				}        				
        			},
        			error: function() {
        				alert('Cannot find mapped category for form ' + formCode + ' (' + pattype + ')');
        			}
        		});
            });
		});

	});

	function submitAction(cmd, stp) {
		if (stp == '2') {
			if (cmd == 'approve') {
				var promptMsg= 'Confirm to approve?';
				$.prompt(promptMsg,{
					buttons: { Ok: true, Cancel: false },
					callback: function(v,m,f){
						if (v){
							submit: submitAction(cmd, 1);
							return true;
						} else {
							return false;
						}
					},
					prefix:'cleanblue'
				});
				return false;
			}
			
			if ($('#file1').val() != '') {
				var otherRemark = '';
				if (<%=isApproved %>) {
					otherRemark = ' The approve status will be REMOVED.';
				}
				$.prompt('Are you sure you want to replace the image? This action is irreversible.' + otherRemark,{
					buttons: { Ok: true, Cancel: false },
					callback: function(v,m,f){
						if (v){
							submit: submitAction(cmd, 1);
							return true;
						} else {
							return false;
						}
					},
					prefix:'cleanblue'
				});
				return false;
			} else {
				submitAction(cmd, 1);
				return false;
			}
		}
		
		if (stp == 1) {
			if (cmd == 'create' || cmd == 'update') {
				
				if (document.form1.patno.value == '') {
					document.form1.patno.focus();
					alert("Please input Patient No.");
					return false;
				}
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
	
	function openFilePreview(filepath) {
		callPopUpWindow('../forwardScanning/preview.jsp?filePath='+filepath);
	}
	
	function refreshUploader(){
		u = document.getElementById('file1_box');
		u.innerHTML="<input type=\"file\" id=\"file1\" name=\"file1\" size=\"100\" maxlength=\"200\" />";
	}

</script>

</DIV>

</DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html>