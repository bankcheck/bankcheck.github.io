<%@ page import="au.com.bytecode.opencsv.CSVReader"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.web.db.hibernate.*"%>
<%@ page import="com.hkah.web.db.model.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%!
int getNumOfSuccessImport(List<FsFileCsv> fsFileCsvs) {
	int totalSuccess = 0;
	for (int i = 0; i < fsFileCsvs.size(); i++) {
		FsFileCsv fc = fsFileCsvs.get(i);
		if (fc.isImported())
			totalSuccess++;
	}
	return totalSuccess;
}

String getBatchNoByImportDate(List<FsFileCsv> fsFileCsvs) {
	if (fsFileCsvs != null && !fsFileCsvs.isEmpty()) {
		FsFileCsv fsFileCsv = fsFileCsvs.get(0);
		return ForwardScanningDB.getBatchNoByImportDate(fsFileCsv.getImportDate());
	}
	return null;
}

String getPermFilePath(String batchNo, String fileName) {
	String path = File.separator + "Upload" + File.separator + FsModelHelper.MODULE_UPLOAD_SUBPATH + File.separator + batchNo + File.separator + fileName;
	return path.replace("\\", "\\\\");
}

String getTempFilePath(String subFilePath, String fileName) {
	String path = File.separator + "Upload" + File.separator + FsModelHelper.MODULE_UPLOAD_SUBPATH_TEMP + File.separator + subFilePath + File.separator + fileName;
	return path.replace("\\", "\\\\");
}

public boolean isCsvFilePathPatientCodeValid(String csvFilePath,List<FsFileCsv> fsFileCsvs){	
	boolean success = true;
	String csvFilePatientCode = csvFilePath.substring(csvFilePath.lastIndexOf("\\")+1,csvFilePath.length());
	String[] str = csvFilePatientCode.split("_");
	if (str.length > 1) {
		csvFilePatientCode = str[1];
	}
	
	for(FsFileCsv f : fsFileCsvs){
		if (isHeteroPatNoBatch(csvFilePatientCode)) {
			// bypass patient code validation if the batch is wild card batches
			// csv file name i.e.: INDEX_4738_20130318_887.CSV
		} else if (f.isReferralLab()) {
			// bypass patient code validation if the batch is referral lab forms
			// csv file name i.e.: INDEX_LAB_20130318_887.CSV
		} else {
			// csv file name i.e.: INDEX_471588_01_20130219_971.CSV
			if(!(f.getPatientCode().equals(csvFilePatientCode))){
				success = false;
			}
		}
	}
	return success;
}

public String getErrorMsg(Integer[] codes) {
	String ret = "Validation warning! Import is NOT complete. Please verify the records below before import.";;
	for (int i = 0; i < codes.length; i++) {
		if (codes[i] < 0) {
			ret += "<br />(" + (i+1) + ") " + getInvalidCodeMsg(codes[i]);
		}
	}
	return ret;
}

public String getMsg(Integer[] codes) {
	String ret = "";
	if (codes != null && codes.length > 0) {
		Set<Integer> codeSet = new HashSet<Integer>(Arrays.asList(codes));
		ret = " Beware:";
		int i = 1;
		for (int c : codeSet) {
			if (c > 0) {
				ret += "<br />(" + (i++) + ") " + getInvalidCodeMsg(c);
			}
		}
	}
	return ret;
}

private String getInvalidCodeMsg(int code) {
	String msg = null;
	switch (code) {
		case -1:
			msg = "Please see the highlights in the records.";
		break;
		case -2:
			msg = "More than 1 Patient No. in this batch.";
		break;
		case -3:
			msg = "Form code is not defined. It will not be mapped to any category in the document tree.";
		break;
		case -4:
			msg = "Form (PABD-MBB14) appeared more than once in this batch.";
		break;
		case -5:
			msg = "Form (NUADMFA02) appeared more than once in this patient.";
		break;
		case -6:
			msg = "Form (VPMA-MBB09) appeared in this batch.";
		break;
		case -7:
			msg = "Form (NUAD-MAA01) appeared more than once in a registration.";
		break;
		case -8:
			msg = "Form (PABD-MAA01) appeared more than once in a registration.";
		break;
		case -9:
			msg = "Registration ID does not match admission details (Patient No, Admission Date or Discharge Date).";
		break;
		case -10:
			msg = "Form (NUAD-MLB13) appeared more than once in a registration.";
		break;
		case -11:
			msg = "Form (NUAD-MLC06) appeared more than once in a registration.";
		break;
		case 2:
			msg = "Form (PEDU-MLC15za) is included in this batch.";
		break;
		case 6:
			msg = "Form (VPMA-MBB09) is included in this batch.";
		break;
		case 7:
			msg = "Form (NUAD-MLC11) (Inpatient) is included in this batch.";
		break;
		case 8:
			msg = "Form (SURU-MLC13) is included in this batch.";
		break;
		case 9:
			msg = "Form (OPDU-MOA10) appeared in OP chart.";
		break;
		case 10:
			msg = "Form (OPDU-MOA10/A/B) appeared more than once in an IP registration.";
		break;
		case 11:
			msg = "Form NUAD-MLC07 exists but no NUAD-MLC07h in an episode.";
		break;
		case 12:
			msg = "Form CATH-MEB04 and OPRM-MEA07a both exist in an episode.";
		break;
		default:
			msg = "";
	}
	return msg;
}

private Integer[] preProcessInvalidCode(String fileName, Integer[] invalidCodes) {
	if (fileName == null || invalidCodes == null || invalidCodes.length == 0) {
		return invalidCodes;
	}
	
	// Exampt more than 1 patient no. warning for wild card patient batches
	String[] f = fileName.split("_");
	if (isHeteroPatNoBatch(fileName)) {
		List<Integer> list = new ArrayList<Integer>();
		for (int iCode : invalidCodes) {
			if (iCode != -2) {
				list.add(iCode);
			}
		}
		invalidCodes = list.toArray(new Integer[list.size()]);
	}
	return invalidCodes;
}

private boolean isHeteroPatNoBatch(String fileName) {
	boolean isHeteroPatNoBatch = false;
	try {
		String[] f = fileName.split("_");
		if (f.length > 1) {
			String uploadUser = f[1];
			if (uploadUser.length() < 6) {	// is patno
				isHeteroPatNoBatch = true;
			}
		}
	} catch (Exception e) {}
	return isHeteroPatNoBatch;
}

private String errMsgReplaceApprLabnum(List<FsFileCsv> fsFileCsvs) {
	if (fsFileCsvs == null || fsFileCsvs.isEmpty()) {
		return null;
	}
	
	String ret = "";
	List<String> labnums = new ArrayList<String>();
	for (FsFileCsv c : fsFileCsvs) {
		labnums.add(c.getLabNum());
	}
	
	ArrayList<ReportableListObject> list = ForwardScanningDB.getPrevApprovedHIS(labnums);
	for (int i = 0; i < list.size(); i++) {
		ReportableListObject row = (ReportableListObject) list.get(i);
		String labnum = row.getFields0();
		String patno = row.getFields1();
		if (!ret.isEmpty()) {
			ret += "<br />";
		}
		ret += "Replace HIS (Lab No.:" + labnum + ", Patient No.:" + patno + ") already approved.";
	}
	return ret;
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

UserBean userBean = new UserBean(request);
String pageCategory = (String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_CATEGORY);
String sessionId = session.getId();
String title = "function.fs.import.list";

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String fileMethod = ParserUtil.getParameter(request, "fileMethod");
String filePath = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "filePath"));
String fileIndexPath = ParserUtil.getParameter(request, "fileIndexPath");

String csvFilePath = null;
File csvFile = null;
boolean clearCsvSrc = true;
final String SES_FS_FILE_CSV = "forwardScanning.fsFileCsvs";
final String SES_FS_FILE_CSV_NAME = "forwardScanning.fsFileCsvName";
int totalSuccess = 0;
int totalFail = 0;
String batchNo = null;
String fileName = null;

boolean uploadAndImportAction = false;
boolean importAction = false;
boolean uploadAction = false;
boolean resetAction = false;

boolean importSuccess = false;
boolean uploadSuccess = false;
boolean validationWarning = false;

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
message = (message == null ? "" : message);
errorMessage = (errorMessage == null ? "" : errorMessage);

if ("uploadAndImport".equals(command)) {
	uploadAndImportAction = true;
} else if ("upload".equals(command)) {
	uploadAction = true;
} else if ("import".equals(command)) {
	importAction = true;
} else if ("reset".equals(command)) {
	resetAction = true;
}

FsModelHelper fsModelHelper = FsModelHelper.getInstance();
List<FsFileCsv> fsFileCsvs = null;

try {
	if ("file1".equals(fileMethod) && fileUpload) {
		String[] fileList = (String[]) request.getAttribute("filelist");
		if (fileList != null && fileList.length > 0) {
			csvFilePath = ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[0];
			fileName = fileList[0];
			
			// move to temp folder
			csvFile = FsModelHelper.moveToTempFolder(sessionId, csvFilePath, true);
			csvFilePath = csvFile.getAbsolutePath();
			clearCsvSrc = false;
		}
	} else if("filePath".equals(fileMethod)) {
		// move to temp folder
		csvFile = FsModelHelper.moveToTempFolder(sessionId, csvFilePath, true);
		csvFilePath = csvFile.getAbsolutePath();
		fileName = csvFile.getName();
		clearCsvSrc = false;
	}
	
	if ("1".equals(step)
			&& userBean.getLoginID() != null) {
		if (uploadAndImportAction) {
			// read, only import when no validation warning
			fsFileCsvs = FsModelHelper.loadFileCsv(csvFilePath);
					
			Integer[] invalidCodes = FsModelHelper.invalidCodes(fsFileCsvs);
			Integer[] infoCodes = FsModelHelper.infoCodes(fsFileCsvs);
			invalidCodes = preProcessInvalidCode(fileName, invalidCodes);
			String errMsgLabnum = errMsgReplaceApprLabnum(fsFileCsvs);
			
			if (!errMsgLabnum.isEmpty() || invalidCodes.length > 0) {
				errorMessage = getErrorMsg(invalidCodes);
				errorMessage += errMsgLabnum.isEmpty() ? "" : "<br />" + errMsgLabnum;
				validationWarning = true;
				
				session.setAttribute(SES_FS_FILE_CSV, fsFileCsvs);
				session.setAttribute(SES_FS_FILE_CSV_NAME, fileName);
				uploadAction = true;
				uploadSuccess = true;
			} else {
				boolean isHetero = isHeteroPatNoBatch(fileName);
				if(isHetero || 
						(!isHetero && isCsvFilePathPatientCodeValid(csvFilePath,fsFileCsvs))){
					fsFileCsvs = fsModelHelper.importFsFile(userBean, fsFileCsvs, fileName);
					
					if (fsFileCsvs != null) {
						if (fsFileCsvs.isEmpty()) {
							errorMessage = "No record has been imported.";
						} else {
							totalSuccess = getNumOfSuccessImport(fsFileCsvs);
							totalFail = fsFileCsvs.size() - totalSuccess;
							batchNo = getBatchNoByImportDate(fsFileCsvs);
							FsModelHelper.backupBatchImportFile(sessionId, batchNo);
							
							message = totalSuccess + " records imported.";
							if (totalFail > 0)
								errorMessage =  totalFail + " records failed to import.";
							filePath = null;
							fileMethod = null;
							importSuccess = true;
						}
					} else {
						FsModelHelper.deleteTempImportFile(sessionId);
						errorMessage = "The file path or the uploaded file is invalid. No record has been imported.";
					}
				}else{
					errorMessage = "Patient Code in csv file name and in the content are inconsistent. Please verify the records below before import.";
					validationWarning = true;
					
					session.setAttribute(SES_FS_FILE_CSV, fsFileCsvs);
					session.setAttribute(SES_FS_FILE_CSV_NAME, fileName);
					uploadAction = true;
					uploadSuccess = true;
				}
			}
			if (message != null && message.length() > 0) {
				message += "<br/>";
			}
			message += getMsg(infoCodes);
			uploadAndImportAction = false;
		} else if (uploadAction) {
			// read
			fsFileCsvs = FsModelHelper.loadFileCsv(csvFilePath);
			if (fsFileCsvs != null) {
				if (fsFileCsvs.isEmpty()) {
					FsModelHelper.deleteTempImportFile(sessionId);
					errorMessage = "The file path or the uploaded file is invalid.";
				} else {
					Integer[] invalidCodes = FsModelHelper.invalidCodes(fsFileCsvs);
					Integer[] infoCodes = FsModelHelper.infoCodes(fsFileCsvs);
					invalidCodes = preProcessInvalidCode(fileName, invalidCodes);
					String errMsgLabnum = errMsgReplaceApprLabnum(fsFileCsvs);
					
					if (!errMsgLabnum.isEmpty() || invalidCodes.length > 0) {
						errorMessage = getErrorMsg(invalidCodes);
						errorMessage += "<br />" + errMsgLabnum;
						//message = getMsg(invalidCodes);
						validationWarning = true;
					}
					if (message != null && message.length() > 0) {
						message += "<br/>";
					}
					message += getMsg(infoCodes);
					session.setAttribute(SES_FS_FILE_CSV, fsFileCsvs);
					session.setAttribute(SES_FS_FILE_CSV_NAME, fileName);
					uploadSuccess = true;
				}

			} else {
				session.removeAttribute(SES_FS_FILE_CSV);
				session.removeAttribute(SES_FS_FILE_CSV_NAME);
				FsModelHelper.deleteTempImportFile(sessionId);
				errorMessage = "The file path or the uploaded file is invalid.";
				uploadAction = false;
			}
		} else if (importAction) {
			fsFileCsvs = (ArrayList<FsFileCsv>) session.getAttribute(SES_FS_FILE_CSV);
			fileName = (String) session.getAttribute(SES_FS_FILE_CSV_NAME);
			if (fsFileCsvs != null) {
				if (fsFileCsvs.isEmpty()) {
					errorMessage = "No record has been imported.";
				} else {
					fsFileCsvs = FsModelHelper.importFsFile(userBean, fsFileCsvs, fileName);
					
					totalSuccess = getNumOfSuccessImport(fsFileCsvs);
					totalFail = fsFileCsvs.size() - totalSuccess;
					batchNo = getBatchNoByImportDate(fsFileCsvs);
					FsModelHelper.backupBatchImportFile(sessionId, batchNo);
					Integer[] infoCodes = FsModelHelper.infoCodes(fsFileCsvs);
					
					message = totalSuccess + " records imported.";
					if (totalFail > 0)
						errorMessage =  totalFail + " records failed to import.";
					message += getMsg(infoCodes);
					
					filePath = null;
					fileMethod = null;
					importSuccess = true;
				}
			} else {
				errorMessage = "No record has been imported.";
			}
			
			importAction = false;
		} else if (resetAction) {
			fileMethod = null;
			filePath = null;
			fsFileCsvs = null;
			session.removeAttribute(SES_FS_FILE_CSV);
			session.removeAttribute(SES_FS_FILE_CSV_NAME);
			resetAction = false;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

request.setAttribute("fsFileCsvs", fsFileCsvs);
if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }		
%>
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
<style>
a{color:#036;text-decoration:none;}a:hover{color:#ff3300;text-decoration:none;}
body { margin: 0px; font: 12px Arial, Helvetica, sans-serif; background-color: #ffffff; }
#upload_alert_box { margin: 2px 0 2px 0; padding: 2px; background-color: #ffff99; }
#alert_batches { font-weight: bold; color: #ff0000; }
</style>
<body leftmargin='5' topmargin='5' marginleft='5' marginleft='5' bgcolor='#ffffff'>
<DIV id=indexWrapper>
	<DIV id=mainFrame>
		<DIV id=contentFrame style="min-height:0px;">
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<jsp:include page="back.jsp" flush="false" />
<form name="form1" enctype="multipart/form-data" action="import.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
<% if (!importSuccess) { %>
<% 	if (uploadAction) { %>
		<tr class="smallText">
			<td class="infoLabel" width="30%">File to import (Upload)</td>
			<td class="infoData" width="70%">
				<a href="javascript:void(0);" onclick="downloadImportFile('<%=getTempFilePath(sessionId, csvFile.getName()) %>');"><%=csvFile.getName() %></a>
			</td>
		</tr>
<% 	} else { %>
		<tr class="smallText">
			<td class="infoLabel" width="30%">File to import (Path)</td>
			<td class="infoData" width="70%">
				<table border="0">
					<tr>
						<td>
						<input type="radio" name="fileMethod" value="file1" <%="file1".equals(fileMethod) ? "checked" : "" %> style="display:none;" />
							Upload
						</td>
						<td>
							<input type="file" name="file1" size="100" maxlength="200" onclick="autoCheckRadio(this)" onkeypress="autoCheckRadio(this)" /><br />
						</td>		
					</tr>
					<tr style="display:none;">
						<td>
							<input type="radio" name="fileMethod" value="filePath" <%="filePath".equals(fileMethod) ? "checked" : "" %>/>
							<bean:message key="prompt.document.filePath" />
						</td>
						<td>
							<input type="text" name="filePath"
									value="<%=filePath != null ? filePath : "" %>"
									size="100" maxlength="200"
									onclick="autoCheckRadio(this)" onkeypress="autoCheckRadio(this)" />
						</td>						
					</tr>
					<tr>
						<td colspan="2">
							<div id="upload_alert_box"></div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
<% 	} %>
<% } %>
	</table>
	<div class="pane">
		<table width="100%" border="0">
			<tr class="smallText">
				<td align="center">
<% if (importSuccess) { %>
<button onclick="return submitAction('reset', 0);" class="btn-click">Next Import</button>
<% } else { %>
<% 	if (uploadAction) { 
		if (fsFileCsvs != null && fsFileCsvs.size() > 0) {
%>
					<button name="btn-fs-action" onclick="return submitAction('import', 1);" class="btn-click">Import</button>
<%		} %>
<% 	} else { %>
					<button name="btn-fs-action" onclick="return submitAction('uploadAndImport', 1);" class="btn-click">Read and Import</button>
					<button name="btn-fs-action" onclick="return submitAction('upload', 1);" class="btn-click">Read</button>
<% 	} %>
					&nbsp;&nbsp;
					<button onclick="return submitAction('reset', 0);" class="btn-click">Reset</button>
<% } %>
				</td>
			</tr>
		</table>
	</div>
	<input type="hidden" name="command">
	<input type="hidden" name="step">
</form>
<form name="download_form" action="../documentManage/download.jsp">
	<input type="hidden" name="locationPath" />
</form>
<% if ((importSuccess || uploadSuccess) && fsFileCsvs != null && fsFileCsvs.size() > 0) { %>
<% 		if (importSuccess) { %>
	<div id="importSummaryBox">
		<table cellpadding="0" cellspacing="5" class="contentFrameMenu" border="0">
			<tr class="smallText">
				<td class="infoTitle" colspan="2">Import Summary</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="30%">Batch No</td>
				<td class="infoData" width="70%">
					<%=batchNo == null ? "" : batchNo %>&nbsp;<button onclick="return submitAction('view_importLog', 0, '<%=batchNo %>');" class="btn-click">View Import Log Details</button>
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="30%">Imported CSV file</td>
				<td class="infoData" width="70%">
					
<%
	Map<String, String> paths = FsModelHelper.getImportFileNamePaths(batchNo);
	if (paths != null && !paths.isEmpty()) {
		Set<String> keys = paths.keySet();
		Iterator<String> itr = keys.iterator();
		while (itr.hasNext()) {
			String iFileName = itr.next();
			String iFilePath = paths.get(iFileName);
			iFilePath = iFilePath.replaceAll("\\\\", "\\\\\\\\");
%>
					<a href="javascript:void(0);" onclick="downloadImportFile('<%=iFilePath %>')"><%=iFileName %></a>
<%		} %>
				</span>
<% 	} %>
					
				</td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel" width="30%">Status</td>
				<td class="infoData" width="70%">
					<%=totalSuccess %> record<%=totalSuccess > 1 ? "s have" : " has" %> been imported to the database.
					<br />
					<%=totalFail %> record<%=totalFail > 1 ? "s" : "" %> failed to import.
				</td>
			</tr>
		</table>
	</div>
<% 		} else if (uploadSuccess) { %>
	<p>The following <%=fsFileCsvs.size() %> record<%=fsFileCsvs.size() > 1 ? " are" : " is" %> read. Click <b>Import</b> button to import to the database. Click <b>Reset</b> to cancel.</p>
<% 		} %>
	<bean:define id="functionLabel"><bean:message key="function.fs.import.list" /></bean:define>
	<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
	<display:table id="row" name="requestScope.fsFileCsvs" export="true" class="tablesorter">
<% FsFileCsv fsFileCsv = ((FsFileCsv) pageContext.getAttribute("row")); %>	
		<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
		<display:column title="Patient Code" style="width:10%"  >
<% 
	String styleClass = "";
	if (!fsFileCsv.isPatientCodeValid() || (!isHeteroPatNoBatch(fileName) && fsFileCsv.isDiffPatCodeFromBatch())) {
		styleClass = "warning";
	}
%>	
			<span class="<%=styleClass %>">
				<%=fsFileCsv.getPatientCode() %>
			</span>
		</display:column>
		<display:column property="docCreationDateDisplay" title="Doc Creation Date" style="width:10%" />
		<display:column title="Form Code" style="width:10%" >
<% 
	String styleClass = "";
	if (!fsFileCsv.isFormCodeValid()) {
		styleClass = "warning";
	}
%>	
			<span class="<%=styleClass %>">
				<%=fsFileCsv.getFormCode() %>
			</span>
		</display:column>
		<display:column property="filePath" title="Document Filename with Full Path" style="width:10%" />
		<display:column title="File Doc Type" style="width:10%">
<% 
	String fileDocTypeDesc = FsModelHelper.pattypes.get(fsFileCsv.getFileDocType());
	if (fileDocTypeDesc == null) {
		fileDocTypeDesc = fsFileCsv.getFileDocType();
	}
	String styleClass = "";
	if (!fsFileCsv.isPattypeValid()) {
		styleClass = "warning";
	}
%>	
			<span class="<%=styleClass %>">
				<%=fileDocTypeDesc %>
			</span>
		</display:column>
		<display:column title="Reg ID" style="width:10%" >
<% 
	String regID = fsFileCsv.getRegID();
	String styleClass = "";
	if (!fsFileCsv.isRegIDValid()) {
		styleClass = "warning";
	}
%>			
			<span class="<%=styleClass %>">
				<%=regID%>
			</span>
		</display:column>
		<display:column property="docSeqNo" title="Document Sequence Number" style="width:10%" />
		<display:column  title="Adm Date" style="width:10%" >
		<% 
	String styleClass = "";
	String admissionDate = fsFileCsv.getAdmDateDisplay();
	if (!fsFileCsv.isAdmissionDateValid()) {
		styleClass = "warning";
		admissionDate = "missing";
	}
	if(admissionDate == null){
		admissionDate = "";
	}
%>	
			<span class="<%=styleClass %>">
				<%=admissionDate%>
			</span>
		</display:column>
		<display:column title="Discharge Date" style="width:10%">
		<% 
	String styleClass = "";
	String dischargedDate = fsFileCsv.getDischargeDateDisplay();
	if (!fsFileCsv.isDischargeDateValid()) {
		styleClass = "warning";
		dischargedDate = "missing";
	}
	if(dischargedDate == null){
		dischargedDate = "";
	}
%>	
			<span class="<%=styleClass %>">
				<%=dischargedDate%>
			</span>
		</display:column>
		<display:column property="labNum" title="Lab No." style="width:10%" />
		<display:column title="Imported" style="width:10%" media="html">
<%		
	boolean isImported = ((FsFileCsv) pageContext.getAttribute("row")).isImported(); 
	if(isImported) {
%>		
			<img src="<html:rewrite page="/images/tick_green_small.gif" />" alt="Imported" />
<%  } %>
		</display:column>
		<display:column property="imported" title="Imported" style="width:10%" media="csv excel xml pdf" />
		<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>" />
	</display:table>
<% } else { %>
			<div id="instructionBlock">
				<p>The upload file should be in plain CSV format (See RFC document: <a href="http://www.ietf.org/rfc/rfc4180.txt" target="_blank">Common Format and MIME Type for Comma-Separated Values (CSV) Files</a>)</p>
				<br />
				<p>The first line of the file is header in order:<br />(1) Patient Code, (2) Doc Creation Date, (3) Form Code, (4) Document Filename with Full Path, (5) File Doc Type, (6) Reg ID, (7) Document Sequence Number, (8) Adm Date, (9) Discharge Date, (10) Replace Code, (11) Lab Num</p>
				<br />
				<p>Example of a valid CSV file:</p>
				<img src="<html:rewrite page="/images/forwardScanning/fs_csv_sample.png" />" alt="Example of a valid CSV file" />
			</div>
<% } %>	
		</DIV>
	</DIV>
</DIV>
<script type="text/javascript">
	$(document).ready(function() {
		$('input[name=file1]').change(function(){
			var filename = this.value.replace(/^.*[\\\/]/, '');
			$('#upload_alert_box').load('checkBatchFile.jsp?fileName=' + filename);
		});
	});
	
<% if (validationWarning) { %>
	var validationWarning = true;
<% } else { %>
	var validationWarning = false;
<% } %>
	
	function submitAction(cmd, stp, keyId) {
		if (stp == 1) {
			if (cmd == "import") {
				if (validationWarning) {
					$.prompt('Validation warning. Are you sure to import?',{
						buttons: { Ok: true, Cancel: false },
						callback: function(v,m,f){
							if (v){
								validationWarning = false;
								submitAction(cmd, stp, keyId);
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
			
			if (cmd == "uploadAndImport") {
				if ($('#upload_alert_box').html() != '') {
					$.prompt('Continue to read/import?',{
						buttons: { Ok: true, Cancel: false },
						callback: function(v,m,f){
							if (v){
								$('#upload_alert_box').html('');
								submitAction(cmd, stp, keyId);
								return true;
							} else {
								return false;
							}
						},
						prefix:'cleanblue'
					});
					return false;
				}
				
				var fileMethod = document.forms["form1"].elements["fileMethod"];
				var fileMethodVal;
				var isFileMethodSelected = false;
				for (var i = 0; i < fileMethod.length; i++) {
					if (fileMethod[i].checked) {
						fileMethodVal = fileMethod[i].value;
						isFileMethodSelected = true;
					}
				}
				
				var input = document.forms["form1"].elements[fileMethodVal];
				if (!input || input.value == "") {
					// alert("Please select a file in Upload or input file full path in File path.");
					alert("Please select a file in Upload.");
					return false;
				}
			}
		} else {
			if (cmd == "view_importLog") {
				callPopUpWindow("importLog_list.jsp?command=view&batchNo=" + keyId);
				return false;				
			}
		}
		
		if (cmd == "import" || cmd == "uploadAndImport" || cmd == "upload") {
			// disable button
			$('button[name=btn-fs-action]').attr("disabled", true);
		}
		
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
		showLoadingBox('body', 500, $(window).scrollTop());
	}
	
	function autoCheckRadio(inputObj) {
		var fileMethod = document.forms["form1"].elements["fileMethod"];
		
		if (fileMethod && inputObj) {
			if (inputObj.name == "file1") {
				for (var i = 0; i < fileMethod.length; i++) {
					if (fileMethod[i].value == "file1")
						fileMethod[i].checked = true;
				}
			}
			else if (inputObj.name == "filePath") {
				for (var i = 0; i < fileMethod.length; i++) {
					if (fileMethod[i].value == "filePath")
						fileMethod[i].checked = true;
				}
			}
		}
	}
	
	function downloadImportFile(path) {
		//document.download_form.action = "../documentManage/download.jsp";
		document.download_form.locationPath.value = path;
		document.download_form.submit();
	}
	
	function openImportLogList(batchNo) {
		callPopUpWindow('../forwardScanning/importLog_list.jsp?batchNo='+batchNo);
	}
</script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>
