<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.FsModelHelper"%>
<%@ page import="com.hkah.web.db.model.FsFileCsv"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.convert.Converter"%>
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

public FsFileCsv createFsFileCsv(String patno, String categoryID, String reportDate, String filePath) {
	FsFileCsv fsFileCsv = new FsFileCsv();
	fsFileCsv.setPatientCode(patno);
	fsFileCsv.setDocCreationDate(DateTimeUtil.parseDate(reportDate));
	fsFileCsv.setFormCode(ForwardScanningDB.getDefaultFormCodeByCategoryID(categoryID));
	fsFileCsv.setFilePath(filePath);
	fsFileCsv.setFileDocType(FsModelHelper.PAT_TYPE_CODE_OP);
	fsFileCsv.setDocSeqNo(1);
	fsFileCsv.setImportDate(new Date());
	
	StringBuffer paramStr = new StringBuffer();
	String[] headers = FsModelHelper.indexFileHeader;
	int colSize = headers.length;
	for (int i = 0; i < headers.length; i++) {
		// construct query string parameters
		if (paramStr.length() > 0)
			paramStr.append("&");
		paramStr.append(headers[i]);
		paramStr.append("=");
		String val = null;
		switch (i) {
			case 0:
				val = fsFileCsv.getPatientCode();
			break;
			case 1:
				val = fsFileCsv.getDocCreationDateDisplay();
			break;
			case 2:
				val = fsFileCsv.getFormCode();
			break;
			case 3:
				val = fsFileCsv.getFilePath();
			break;
			case 4:
				val = fsFileCsv.getFileDocType();
			break;
			case 5:
				val = fsFileCsv.getRegID();
			break;
			case 6:
				val = fsFileCsv.getDocSeqNo() == null ? null : fsFileCsv.getDocSeqNo().toString();
			break;
			case 7:
				val = fsFileCsv.getAdmDateDisplay();
			break;
			case 8:
				val = fsFileCsv.getDischargeDateDisplay();
			break;
			case 9:
				val = fsFileCsv.getReplaceCode() == null ? null : fsFileCsv.getReplaceCode().toString();
			break;
			case 10:
				val = fsFileCsv.getLabNum();
			break;
			case 11:
				val = fsFileCsv.getStationId();
			break;
			default:
		}
		paramStr.append(val == null || "null".equals(val) ? "" : val);
	}
 	fsFileCsv.setParamStr(paramStr.toString());
	return fsFileCsv;
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

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String userid = ParserUtil.getParameter(request, "user"); 
String patno = ParserUtil.getParameter(request, "patno"); 
String categoryID = ParserUtil.getParameter(request, "categoryID");
String reportDate = ParserUtil.getParameter(request, "reportDate");
String ts = ParserUtil.getParameter(request, "ts");

String prevTs = (String) request.getSession().getAttribute("forwardScanning.ts");
if (prevTs != null && prevTs.equals(ts)) {
	step = null;
}
request.getSession().setAttribute("forwardScanning.ts", ts);

String referer = request.getHeader("referer");
//System.out.println("[file_upload] referer="+referer+", userBean="+userBean+", loginID="+userBean.getLoginID());
boolean fromPortal = "Y".equals(ParserUtil.getParameter(request, "fromPortal")) || (referer != null && referer.contains("/forwardScanning/index.jsp"));
if (fromPortal) {
	userid = userBean.getLoginID();
} else if (userBean == null) {
	userBean.setLoginID(userid);
}

String requestURL = request.getRequestURL().toString();
String servletPath = request.getServletPath();
String treeSubLink = "/common/pat_main.jsp";
String qryStrCategory = "category=fs";
String qryStrPatno = "patno=";
String qryStrViewMode = "viewMode=";
String treeLink = requestURL.replace(servletPath, "") + treeSubLink;
String listLabel = "function.fs.file.upload";

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

// search form
String s_patno = null;
String s_patidno = null;
String s_patsex = null;
String s_patbdateStr = null;
String s_pattel = null;
String s_patfname = null;
String s_patgname = null;
String s_patmname = null;
String s_patcname = null;
String s_scr = null;
String s_ordby = null;

// patient header
String patname = null;
String patcname = null;
String patbdateStr = null;
String patidno = null;
String patsex = null;
ArrayList patList = null;
String filePath = null;
int totalSuccess = 0;
int totalFail = 0;
String batchNo = null;
boolean importSuccess = false;
boolean uploadSuccess = false;
boolean validationWarning = false;

System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [FS file_upload] patno="+patno+", user="+userid);

if (userid != null && !userid.trim().isEmpty()) {
	try {
		if ("1".equals(step)) {
			if (createAction || updateAction) {
				// upload file
				String[] fileList = (String[]) request.getAttribute("filelist");
				if (fileList != null) {
					filePath = ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[0];
				}
				
				System.out.println("[FS file_upload] filePath="+filePath+", categoryID="+categoryID+", reportDate="+reportDate+", userBean.getLoginID="+userBean.getLoginID());
		
				List<FsFileCsv> fsFileCsvs = new ArrayList<FsFileCsv>();
				fsFileCsvs.add(createFsFileCsv(patno, categoryID, reportDate, filePath));
				fsFileCsvs = FsModelHelper.importFsFile(userBean, fsFileCsvs, null);
				
				if (fsFileCsvs != null) {
					if (fsFileCsvs.isEmpty()) {
						errorMessage = "No record has been imported.";
					} else {
						totalSuccess = getNumOfSuccessImport(fsFileCsvs);
						totalFail = fsFileCsvs.size() - totalSuccess;
						batchNo = getBatchNoByImportDate(fsFileCsvs);
						
						if (totalSuccess > 0) {
							message = totalSuccess + " record(s) imported.";
						}
						if (totalFail > 0)
							errorMessage =  totalFail + " record(s) failed to import.";
						filePath = null;
						importSuccess = true;
					}
				} else {
					errorMessage = "The upload file is invalid. No record has been imported.";
				}
			}
		}
	
		// load data from database
		if (patno != null) {
			patList = PatientDB.getPatInfo(patno);
			if (!patList.isEmpty()) {
				ReportableListObject rlo = (ReportableListObject) patList.get(0);
				patname = rlo.getFields3();
				patcname = rlo.getFields4();
				patbdateStr = rlo.getFields17();
				patidno = rlo.getFields2();
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
} else {
	patno = null;
}

boolean isParamValid = true;
if (patList == null || patList.isEmpty() || userid == null) {
	isParamValid = false;
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

%>
<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<meta http-equiv="X-UA-Compatible" content="IE=11" />
<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/w3.hkah.css" />" />

<script src="../documentManage/pdfjs/web/compatibility.js"></script>
<script src="../documentManage/pdfjs/build/pdf.js"></script>
<script src="../documentManage/pdfjs/build/pdf.worker.js"></script>

<head>
<style>
	.sticky {
	  position: fixed;
	  top: 0;
	  width: 100%;
	}

	form[name=search_form] .w3-input {
	    display: inline;
	    width: auto;
	} 
	form[name=search_form] .w3-bar-item {
	    padding-top: 2px;
	    padding-bottom: 2px;
	} 
	.item-input-short {
		width: 400px !important;
	}

	.item-input-long {
		width: 800px !important;
	}
	
	.search_result-tbl-con {
		max-height: 500px;
	}
	
	.search_result-tbl tr.selected {
        background-color: #ffff89 !important;
    }
	
	.itm{font-size: smaller;}
	.itemTabName{font-size: smaller;}
	.bold{font-weight: bold;}
	
	#upload-con {
		margin-top: 20px;
		min-height: 1000px;
	}
	
	#pat_header p {
		display: inline;
	}
	
	#file-index-con {
  		width: 400px;
	}
	
	#pdf-preview-con {
  		overflow-y: auto;
  		/* border: 1px solid green; */
	}

	.pdf-preview {
		margin-bottom: 10px;
		/* border: 1px solid red; */
	}
	
	form label.main {
		font-weight: bold;
	}
	
	button[name=btn-chart-admin] {
		padding: 0 4px;; 
	}
	
	input[name=categoryID] {
	  opacity: 0;
	  position: fixed;
	  width: 0;
	}
	
	.categoryIDs-con label {
	    display: inline-block;
	    background-color: #fff;
	    padding: 5px 20px;
	    margin: 5px 0;
	    border: 2px solid #ccc;
	    border-radius: 4px;
	    cursor: pointer;
	}
	
	.categoryIDs-con label:hover {
		background-color: #e6f2ff;
	}
	
	.categoryIDs-con input[type="radio"]:focus + label {
	    border: 2px #444;
	}
	
	.categoryIDs-con input[type="radio"]:checked + label {
	    background-color: #cce6ff;
	    border: 2px solid #80bfff;
	}
	
	img.ui-datepicker-trigger {
		margin: 0 5px;
		width: 38px;
	}
	
	#overlay {
	  position: fixed; /* Sit on top of the page content */
	  display: none; /* Hidden by default */
	  width: 100%; /* Full width (cover the whole page) */
	  height: 100%; /* Full height (cover the whole page) */
	  top: 0;
	  left: 0;
	  right: 0;
	  bottom: 0;
	  background-color: rgba(0,0,0,0.5); /* Black background with opacity */
	  z-index: 2; /* Specify a stack order in case you're using a different order for other elements */
	  cursor: pointer; /* Add a pointer on hover */
	}
	
	#overlay_text {
	  position: absolute;
	  top: 50%;
	  left: 50%;
	  font-size: 20px;
	  color: white;
	  transform: translate(-50%,-50%);
	  -ms-transform: translate(-50%,-50%);
	}
	
	#loader {
      position: absolute;
	  top: 30%;
	  left: 50%;
	  display: none;
	  z-index: 3;
	  border: 16px solid #f3f3f3;
	  border-radius: 50%;
	  border-top: 16px solid #3498db;
	  width: 120px;
	  height: 120px;
	  -webkit-animation: spin 2s linear infinite; /* Safari */
	  animation: spin 2s linear infinite;
	  
	}
	
	/* Safari */
	@-webkit-keyframes spin {
	  0% { -webkit-transform: rotate(0deg); }
	  100% { -webkit-transform: rotate(360deg); }
	}
	
	@keyframes spin {
	  0% { transform: rotate(0deg); }
	  100% { transform: rotate(360deg); }
	}
</style>
</head>
<body style="background:aliceblue;">
<% if (fromPortal) { %>
<jsp:include page="../common/page_title.jsp">
	<jsp:param name="pageTitle" value="<%= listLabel %>" />
	<jsp:param name="isHideTitle" value="Y" />
</jsp:include>
<% } %>
	<div id="overlay">
	  <div id="overlay_text">
<% if (userBean == null) { %>
<% 	if (userid == null || userid.trim().isEmpty()) { %>
		You don't have permission to upload file.
<% } else if (patno == null || patno.trim().isEmpty()) { %>
		No record for patient no.: <%=patno %>.
<% } else if (patList == null || patList.isEmpty()) { %> 
		No patient selected.
<% 	} %>
<% } %>
	  </div>
	</div>
	<div id="loader"></div>
	<div class="w3-container w3-center ah-pink header">
		<span class="w3-xxlarge bold  ">Medical Records - File upload</span>
	</div>
<% if (fromPortal) { %>
	<jsp:include page="back.jsp" flush="false" />
<% } %>
<div class="w3-container">
	<form name="search_form" action="file_upload.jsp" method="post">
		<div class="w3-panel w3-border">
		  <div class="w3-bar">
		    <div class="w3-bar-item item-input-short">
		    	<label>Patient No.</label>
		    	<input type="text" id="s_patno" name="s_patno" class="w3-input" value="<%=s_patno == null ? "" : s_patno %>" />
		    </div>
		    <div class="w3-bar-item item-input-short">
		    	<label>ID/Passport No.</label>
		    	<input type="text" id="s_patidno" name="s_patidno" class="w3-input" value="<%=s_patidno == null ? "" : s_patidno %>" />
		    </div>
		    <div class="w3-bar-item item-input-short">
		    	<label>Sex</label>
		    	<select class="w3-select w3-input w3-border" id="s_patsex" name="s_patsex">
					<jsp:include page="../ui/hatsPatSexCMB.jsp" flush="true">
						<jsp:param name="allowEmpty" value="Y" />
						<jsp:param name="sex" value="<%=s_patsex %>" />
					</jsp:include>
				</select>
		    	<!-- <input type="text" id="s_patsex" name="s_patsex" class="w3-input" value="<%=s_patsex == null ? "" : s_patsex %>" />-->
		    </div>
		  </div>
		  <div class="w3-bar">
		    <div class="w3-bar-item item-input-short">
		    	<label>Date of Birth</label>
		    	<input type="text" id="s_patbdateStr" name="s_patbdateStr" class="w3-input datepickerfield" value="<%=s_patbdateStr == null ? "" : s_patbdateStr %>" maxlength="10" placeholder="dd/mm/yyyy" />
		    </div>
		   	<div class="w3-bar-item item-input-long">
		    	<label>Home No. / Mobile No. / Office No. / Fax No.</label>
		    	<input type="text" id="s_pattel" name="s_pattel" class="w3-input" value="<%=s_pattel == null ? "" : s_pattel %>" />
		    </div> 
		    
		    <div class="w3-bar-item item-input-long"></div>
		  </div>
		</div>
		
		<div class="w3-panel w3-border">
		  <div class="w3-bar">
		    <div class="w3-bar-item item-input-short">
		    	<label>Family Name</label>
		    	<input type="text" id="s_patfname" name="s_patfname" class="w3-input" value="<%=s_patfname == null ? "" : s_patfname %>" />
		    </div>
		  	<div class="w3-bar-item item-input-short">
		    	<label>Given Name</label>
		    	<input type="text" id="s_patgname" name="s_patgname" class="w3-input" value="<%=s_patgname == null ? "" : s_patgname %>" />
		    </div>
		  	<div class="w3-bar-item item-input-short">
		    	<label>Maiden Name</label>
		    	<input type="text" id="s_patmname" name="s_patmname" class="w3-input" value="<%=s_patmname == null ? "" : s_patmname %>" />
		    </div>
		  </div>
		
		  <div class="w3-bar">
		    <div class="w3-bar-item item-input-short">
		    	<label>Chinese Name</label>
		    	<input type="text" id="s_patcname" name="s_patcname" class="w3-input" value="<%=s_patcname == null ? "" : s_patcname %>" />
		    </div>
		    <div class="w3-bar-item item-input-short">
		    	<label>Search Criteria</label>
		    	<select class="w3-select w3-input w3-border" id="s_scr" name="s_scr">
					<jsp:include page="../ui/hatsPatScrCMB.jsp" flush="true">
						<jsp:param name="scr" value="<%=s_scr %>" />
					</jsp:include>
				</select>
		    	<!-- <input type="text" id="s_scr" name="s_scr" class="w3-input" value="<%=s_scr == null ? "" : s_scr %>" />-->
		    </div>
		    <div class="w3-bar-item item-input-short">
		    	<label>Order By</label>
		    	<select class="w3-select w3-input w3-border" id="s_ordby" name="s_ordby">
					<jsp:include page="../ui/hatsPatOrdbyCMB.jsp" flush="true">
						<jsp:param name="ordby" value="<%=s_ordby %>" />
					</jsp:include>
				</select>
		    	<!-- <input type="text" id="s_ordby" name="s_ordby" class="w3-input" value="<%=s_ordby == null ? "" : s_ordby %>" /> -->
		    </div>
		  </div>
		</div>
		<div class="w3-section w3-center">
			<span class="search-spinning">Searching...</span>
			<button name="btn-search" class="w3-btn w3-blue-grey">Search</button>
			<button name="btn-accept" class="w3-btn w3-blue-grey">Accept</button>
			<button name="btn-clear" class="w3-btn w3-blue-grey">Clear</button>
			<button name="btn-close" class="w3-btn w3-blue-grey">Close</button>
		</div>
		<div class="w3-responsive w3-border w3-section search_result-tbl-con">
			<table class="w3-table-all w3-hoverable search_result-tbl">
				<thead>
					<tr>
					  <th>Alert</th>
					  <th>Patient No.</th>
					  <th>Family Name</th>
					  <th>Given Name</th>
					  <th>Maiden Name</th>
					  <th>Chinese Name</th>
					  <th>Sex</th>
					  <th>Date of Birth</th>
					  <th>Mobile Phone</th>
					  <th>Home Phone</th>
					  <th>ID No.</th>
					  <th>No. of Visit</th>
					  <th>Long Family Name</th>
					  <th>Long Given Name</th>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
		</div>
		<input type="hidden" name="patno" value="<%=patno %>">
	</form>
</div>
<% if (userBean == null) { %>	
	<div class="w3-container w3-small ah-pink w3-right w3-display-topright">
		Updating User: <%=userid == null ? "" : userid %><br/>
	</div>
<% } %>
<div class="w3-container" id="upload-con">
	<div class="w3-bar w3-large" style="background:#DFDFDF;" id="pat_header">
		<div class="w3-bar-item">Patient No.: <button name="btn-chart-admin" class="w3-button w3-white"><%=!isParamValid?"":patno %></button></div>
		<div class="w3-bar-item"><p class="h_patname"><%=patname== null?"":patname %></p></div><div class="w3-bar-item"><p class="h_patcname"><%=patcname== null?"":patcname %></p></div>
		<div class="w3-bar-item">DOB: <p class="h_patbdateStr"><%=patbdateStr== null?"":patbdateStr %></p></div>
		<div class="w3-bar-item w3-right">Doc. No.: <p class="h_patidno"><%=patidno== null?"":patidno %></p></div>
	</div>
	<div class="w3-row">
		<div class="w3-col w3-container w3-white" id="file-index-con">
			<div>
				  <div class="w3-panel w3-pale-green w3-bottombar w3-border-green w3-border msg-con">
				    <p><%=message %></p>
				  </div>
				  <div class="w3-panel w3-pale-red w3-leftbar w3-rightbar w3-border-red errmsg-con">
				    <p><%=errorMessage %></p>
				  </div>
				<form name="form_file_upload" id="form_file_upload" enctype="multipart/form-data" action="file_upload.jsp" method="post">
					<label class="main">Category</label>
					
					<!-- <select class="w3-select w3-border" id="categoryID" name="categoryID">-->
						<jsp:include page="../ui/fsCategoryCMB2.jsp" flush="true">
							<jsp:param name="allowEmpty" value="Y" />
							<jsp:param name="categoryID" value="<%=categoryID %>" />
						</jsp:include>
					<!--</select>-->
					<label class="main">Report / Service Date</label>
					<div class="w3-bar">
						<input type="text" id="reportDate" name="reportDate" class="w3-input datepickerfield w3-bar-item" value="<%=reportDate == null ? "" : reportDate %>" maxlength="10" placeholder="dd/mm/yyyy" />
					</div> 
					<!--<input type="date" id="reportDate" name="reportDate" class="w3-input" value="<%=reportDate == null ? "" : reportDate %>" placeholder="dd/mm/yyyy" />-->
					<label class="main">Document</label>
					<input type="file" id="pdf-file" name="pdf-file" class="w3-input" />
					<div class="w3-section w3-center">
						<button name="btn-save" class="w3-btn w3-blue-grey" type="button">Save & Submit</button>
						<button name="btn-cancel" class="w3-btn w3-blue-grey">Cancel</button>
						<button name="btn-close-upload-con" class="w3-btn w3-blue-grey">Close</button>
					</div>
					<input type="hidden" name="command">
					<input type="hidden" name="step">
					<input type="hidden" name="patno" value="<%=patno %>">
					<input type="hidden" name="user" value="<%=userid %>">
					<input type="hidden" name="viewMode" value="">
					<input type="hidden" name="fromPortal" value="<%=fromPortal ? "Y" : "N" %>">
					<input type="hidden" name="ts" value="<%=(new Date()).getTime() %>">
				</form>
			</div>
		</div>
		<div class="w3-container w3-rest w3-gray" id="pdf-preview-con" style="height: 100%">
			<!--<canvas id="pdf-preview">PDF preview</canvas>-->
		</div>
	</div>
</div>	
</body>
<script>
$(document).ready(function(){
	initSearchTable();
	$("#s_patno").focus();
	$(".msg-con").hide();
	$(".errmsg-con").hide();
	
	/* Selected File has changed */
	document.querySelector("#pdf-file").addEventListener('change', function() {
	    // user selected file
		//console.log(this.val());
	    
	    if (this.files) {
		    var file = this.files[0];
			
		    // allowed MIME types
		    var mime_types = [ 'application/pdf' ];
		    
		    // Validate whether PDF
		    if(mime_types.indexOf(file.type) == -1) {
		        alert("Non-PDF file may not show properly in patient chart.");
		        return;
		    }
	
		    // validate file size
		    if(file.size > 20*1024*1024) {
		        alert('File size is too large(exceeded 20MB). It may not show properly in patient chart.');
		        return;
		    }
		    // validation is successful
	
		    // clear canvas
		    resetPdfPreviw();
		    
		    // object url of PDF 
		    _OBJECT_URL = URL.createObjectURL(file)
	
		    // send the object url of the pdf to the PDF preview function
			showPDF(_OBJECT_URL);
	    }
	});

	$("button[name=btn-chart-admin]").click(function() {
		submitAction('tree');
		return false;
	});
	
	$("button[name=btn-save]").click(function() {
		submitAction('create', 1);
		return false;
	});
	
	$(".search-spinning").hide();
	
	$("button[name=btn-search]").click(function() {
		if (!isSearchFieldsEmpty()) {
			alert("Please enter at least 1 criteria.");
			return false;
		}
		
		$(".search-spinning").show();
		$("button[name=btn-search]").attr("disabled", true);
		$.ajax ({
			url: "getHatsPatSearch.jsp?callback=?",
			type: "POST",
			data: 
				"patno="+$("#s_patno").val().toUpperCase() + "&" +
				"patidno="+$("#s_patidno").val().toUpperCase() + "&" +
				"patsex="+$("#s_patsex").val() + "&" +
				"patbdateStr="+$("#s_patbdateStr").val().toUpperCase() + "&" +
				"pattel="+$("#s_pattel").val().toUpperCase() + "&" +
				"patfname="+$("#s_patfname").val().toUpperCase() + "&" +
				"patgname="+$("#s_patgname").val().toUpperCase() + "&" +
				"patmname="+$("#s_patmname").val().toUpperCase() + "&" +
				"patcname="+$("#s_patcname").val().toUpperCase() + "&" +
				"scr="+$("#s_scr").val() + "&" +
				"ordby="+$("#s_ordby").val()
			,
			dataType: "jsonp",
			cache: false,
			async: true,
			success: function(value){
				$(".search-spinning").hide();
				$("button[name=btn-search]").attr("disabled", false);
				loadSearchResult(value);
			},
			error: function(x, s, e) {
				$(".search-spinning").hide();
				$("button[name=btn-search]").attr("disabled", false);
				alert("Failed to get search result: " + s);
			}
		});
		return false;
	});
	
	$("form[name=form_file_upload] input").change(function() {
		clearMsg();
	});
	
	$("button[name=btn-accept]").click(function() {
		setUploadConPat($(".search_result-tbl .selected"));
		return false;
	});
	
	$("button[name=btn-cancel]").click(function() {
		clearUploadConInput();
		return false;
	});
	
	$("button[name=btn-close]").click(function() {
		closeAction();
		return false;
	});
	
	$("button[name=btn-close-upload-con]").click(function() {
		clearUploadConPat();
		scrollToAnchor("body");
		return false;
	});
	
	$(".btn-category").click(function() {
		return false;
	});
	
	$("#overlay").click(function() {
		$("#overlay").hide();
	});
	<% if (referer == null && !isParamValid) { %>
	$("#overlay").show();
	$("button[name=btn-save]").attr("disabled", true);
	<% } else { %>
	$("#upload-con").hide();
	<% } %>
	
	clearSearchList();
	
	if (window.File && window.FileReader && window.FileList && window.Blob) {
		console.log("support File API");
	} else {
		console.log("Not support File API");
		$("#pdf-preview-con").html("<p class='w3-panel'>This browser does not support PDF preview. Please use IE 10/Chrome 13 or above.<p/>");
	}
	
	keepAlive(1000*60*5);
});

function initSearchTable() {
    $(".search_result-tbl tr").click(function () {
        $(".search_result-tbl .selected").removeClass("selected");
        $(this).addClass("selected");
        $("button[name=btn-accept]").attr("disabled", false);
    });

	$(".search_result-tbl tr").dblclick(function () {
        $(".selected",this).removeClass("selected");
        $(this).addClass("selected");
        setUploadConPat(this);
    });
}

function submitAction(cmd, stp) {
	if (cmd == 'tree') {
		if ($('input[name=patno]').val() == '') {
			alert('No patient no.');
			return false;
		}
		callPopUpWindow(createTreeLink());
		return false;
	} else if (cmd == 'create' || cmd == 'update') {
		/*
		if ($("#categoryID").val() == "") {
			alert("Please select a category.");
			$("#categoryID").focus();
			return false;
		}*/
		if($("input[name=categoryID]:checked").length == 0) {
            alert('Please select one category.');
            return false;
		}
		
		if ($("#reportDate").val() == "") {
			alert("Please input report/service date.");
			$("#reportDate").focus();
			return false;
		}
		if ($("#pdf-file").val() == "") {
			alert("Please choose a file to upload.");
			return false;
		}
	}
	document.form_file_upload.command.value = cmd;
	document.form_file_upload.step.value = stp;
	
	if (window.FormData) {
	    //var form = document.form_file_upload;
	    var formData = new FormData(document.form_file_upload);
	    postSubmit();
	    $.ajax({
	        url:'uploadFileIndex.jsp',
	        type : "POST",
	        data : formData,
	        dataType: "json",
	        contentType: false,
	        cache: false,
	        processData: false,
	        success : function(values) {
	            console.log(values);
	            onSubmitReturn(values);
	        },error: function(x, s, e) {
	            console.log("Failed to submit upload form");
	            alert("Failed to submit upload form");
	            onSubmitReturn();
	        }
	    });
	} else {
		document.form_file_upload.submit();
	}
	return false;
}

function postSubmit() {
	$("button[name=btn-save]").attr("disabled", true);
	$("#overlay").show();
	$("#loader").show();
}

function onSubmitReturn(values) {
	$("button[name=btn-save]").attr("disabled", false);
	$("#overlay").hide();
	$("#loader").hide();
	clearUploadConInput();
	
	if (values != null) {
		console.log("values="+values);
		console.log("message="+values["message"]);
		
		if(values["message"] != null) {
			console.log("values[message]="+values["message"]);
			$(".msg-con").html(values["message"]);
			$(".msg-con").show();
		} else if(values["errorMessage"] != null) {
			console.log("values[errorMessage]="+values["errorMessage"]);
			$(".errmsg-con").html(values["errorMessage"]);
			$(".errmsg-con").show();
		}
		
		/*
		$.each(values, function(i, all) {
			console.log("i="+i);
			if(i == "message") {
				console.log("values[i]="+values[i]);
				$(".msg-con").html(values[i]);
				$(".msg-con").show();
			} else if(i == "errorMessage") {
				$(".errmsg-con").html(values[i]);
				$(".errmsg-con").show();
			}
		});
		*/
	}
}

function closeAction() {
<% if (referer != null) { %>
	if (window.name) {
		location.href = "<%=referer %>";
	} else {
		window.close();
	}
<% } else { %>
	window.close();
<% } %>
}

function clearMsg() {
	$(".msg-con").hide();
	$(".errmsg-con").hide();
}

function setUploadConPat(selectedTr) {
	if (selectedTr) {
		var patno = $(".t_patno",selectedTr).html();
	    $("button[name=btn-chart-admin]").html(patno);
	    $("input[name=patno]").val(patno);
	    $(".h_patname").html($(".t_patfname",selectedTr).html() + " " + $(".t_patgname",selectedTr).html());
	    $(".h_patcname").html($(".t_patcname",selectedTr).html());
	    $(".h_patbdateStr").html($(".t_patbdateStr",selectedTr).html());
	    $(".h_patidno").html($(".t_patidno",selectedTr).html());
	    
	    $("#upload-con").show();
	    scrollToAnchor("#upload-con");
	}
}

function clearUploadConPat() {
    $("button[name=btn-chart-admin]").html("");
    $("input[name=patno]").val("");
    $(".h_patname").html("");
    $(".h_patcname").html("");
    $(".h_patbdateStr").html("");
    $(".h_patidno").html("");
    clearUploadConInput();
    
	$("#upload-con").hide();
}

function clearUploadConInput() {
	//$("select[name=categoryID]").val("");
	$("input[name=categoryID]").attr("checked",'');
	$("input[name=reportDate]").val("");
	$("input[name=pdf-file]").val("");
	$(".msg-con").hide();
	$(".errmsg-con").hide();
	resetPdfPreviw();
}

function scrollToAnchor(id) {
    $('html,body').animate({scrollTop: $(id).offset().top},'slow');
}

function createTreeLink() {
	return "<%=treeLink %>?<%=qryStrCategory %>&<%=qryStrPatno %>" + $('input[name=patno]').val() + "&<%=qryStrViewMode %>" + $('input[name=viewMode]').val();
}

function loadSearchResult(patients) {
	$.each(patients, function(i, all) {
		if(i == "record") {
			if (Object.keys(all).length === 0) {
				alert("No record found.");
			} else {
				clearSearchList();
				$.each(all, function(k, patient) {
					var rowH = "<tr>";
					var rowT = "</tr>";
	                var col = "<td>" + patient["alertcode"] + "</td>";
	                $(".search_result-tbl").append(
	                	"<tr>" +
	                	"<td class=\"t_alertcode\">" + patient["alertcode"] + "</td>" +
	                	"<td class=\"t_patno\">" + patient["patno"] + "</td>" +
	                	"<td class=\"t_patfname\">" + patient["patfname"] + "</td>" +
	                	"<td class=\"t_patgname\">" + patient["patgname"] + "</td>" +
	                	"<td class=\"t_patmname\">" + patient["patmname"] + "</td>" +
	                	"<td class=\"t_patcname\">" + patient["patcname"] + "</td>" +
	                	"<td class=\"t_patsex\">" + patient["patsex"] + "</td>" +
	                	"<td class=\"t_patbdateStr\">" + patient["patbdate"] + "</td>" +
	                	"<td class=\"t_patpager\">" + patient["patpager"] + "</td>" +
	                	"<td class=\"t_pathtel\">" + patient["pathtel"] + "</td>" +
	                	"<td class=\"t_patidno\">" + patient["patidno"] + "</td>" +
	                	"<td class=\"t_patvcnt\">" + patient["patvcnt"] + "</td>" +
	                	"<td class=\"t_patlfname\">" + patient["patlfname"] + "</td>" +
	                	"<td class=\"t_patlgname\">" + patient["patlgname"] + "</td>" +
	                	"</tr>"
	                );
				});
			}
			initSearchTable();
		} else if(i == "errorMessage") {
			alert(patients["errorMessage"]);
		}
	});
}

function isSearchFieldsEmpty() {
	if ($("#s_patno").val().trim() === "" &&
			$("#s_patidno").val().trim() === "" &&
			$("#s_patsex").val().trim() === "" &&
			$("#s_patbdateStr").val().trim() === "" &&
			$("#s_pattel").val().trim() === "" &&
			$("#s_patfname").val().trim() === "" &&
			$("#s_patgname").val().trim() === "" &&
			$("#s_patmname").val().trim() === "" &&
			$("#s_patcname").val().trim() === "") {
		return false;
	} else {
		return true;
	}
	/*
	"patno="+$("#s_patno").val().trim() + "&" +
	"patidno="+$("#s_patidno").val().toUpperCase() + "&" +
	"patsex="+$("#s_patsex").val() + "&" +
	"patbdateStr="+$("#s_patbdateStr").val().toUpperCase() + "&" +
	"pattel="+$("#s_pattel").val().toUpperCase() + "&" +
	"patfname="+$("#s_patfname").val().toUpperCase() + "&" +
	"patgname="+$("#s_patgname").val().toUpperCase() + "&" +
	"patmname="+$("#s_patmname").val().toUpperCase() + "&" +
	"patcname="+$("#s_patcname").val().toUpperCase() + "&" +
	"scr="+$("#s_scr").val() + "&" +
	"ordby="+$("#s_ordby").val()
	*/
}

function clearSearchList() {
	$(".search_result-tbl tbody").html("");
	$("button[name=btn-accept]").attr("disabled", true);
}

//PDF preview
var _PDF_DOC,
	_PDF,
	_CANVAS = document.querySelector('#pdf-preview-con'),
	_OBJECT_URL;
var numPages = 0,
	padding = 16;

function showPDF(pdf_url) {
	PDFJS.getDocument({ url: pdf_url }).then(function(pdf_doc) {
		_PDF_DOC = pdf_doc;
		
     //How many pages it has
     numPages = pdf_doc.numPages;
     currPage = 1;

		// Show the first page
		showPage(currPage);
		//_PDF_DOC.getPage(page_no).then( handlePages );

		// destroy previous object url
 	URL.revokeObjectURL(_OBJECT_URL);
	}).catch(function(error) {
		alert(error.message);
	});;
}

function showPage(page_no) {
	_PDF_DOC.getPage(page_no).then( handlePages );
}

function handlePages(page)
{
	// set the scale of viewport
	var widthOffset;
	if (currPage== 1) {
		widthOffset = padding * 3;
	} else {
		widthOffset = padding * 2;
	}
	var scale_required = (_CANVAS.clientWidth - widthOffset) / page.getViewport(1).width;
	
 //This gives us the page's dimensions at full scale
 var viewport = page.getViewport( scale_required );

 //We'll create a canvas for each page to draw it on
 var canvas = document.createElement( "canvas" );
 canvas.style.display = "block";
 var context = canvas.getContext('2d');
 canvas.height = viewport.height;
 canvas.width = viewport.width;
 //canvas.style.width = '100%';	// responsive
 canvas.className = "pdf-preview";

 //Draw it on the canvas
 page.render({canvasContext: context, viewport: viewport});

 //Add it to the web page
 _CANVAS.appendChild( canvas );

 //Move to next page
 if ( _PDF_DOC !== null && currPage++ < numPages )
 {
 	_PDF_DOC.getPage( currPage ).then( handlePages );
 }
}

function resetPdfPreviw() {
	_CANVAS.innerHTML = "";
	if (_PDF_DOC != null) {
		_PDF_DOC.destroy();
	}
}
</script>
</html:html>