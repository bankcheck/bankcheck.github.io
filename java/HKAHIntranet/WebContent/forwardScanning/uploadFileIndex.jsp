<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.json.*" %>
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

String message = null;
String errorMessage = null;

UserBean userBean = new UserBean(request);
if (userBean == null || !userBean.isAccessible("function.fs.file.upload")) {
	errorMessage = "No upload file access right.";
	
	JSONObject returnJSON = new JSONObject();
	returnJSON.put("message", message);
	returnJSON.put("errorMessage", errorMessage);

	response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");
	out.print(request.getParameter("callback")+"("+returnJSON.toString()+ ");");
	out.flush();
}

String command = ParserUtil.getParameter(request, "command");
String patno = ParserUtil.getParameter(request, "patno"); 
String categoryID = ParserUtil.getParameter(request, "categoryID");
String reportDate = ParserUtil.getParameter(request, "reportDate");

System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + "[uploadFileIndex] debug patno="+patno+", fileUpload="+fileUpload+", command="+command+", loginID="+userBean.getLoginID());

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

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
String filePath = null;
int totalSuccess = 0;
int totalFail = 0;
String batchNo = null;
boolean importSuccess = false;
boolean uploadSuccess = false;
boolean validationWarning = false;

try {
	if (createAction || updateAction) {
		// upload file
		String[] fileList = (String[]) request.getAttribute("filelist");
		if (fileList != null) {
			filePath = ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[0];
		}
		
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
} catch (Exception e) {
	e.printStackTrace();
	errorMessage = e.getMessage();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

JSONObject returnJSON = new JSONObject();
returnJSON.put("message", message);
returnJSON.put("errorMessage", errorMessage);

//System.out.println("[uploadFileIndex] message="+message+", errorMessage="+errorMessage);

response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
out.print(request.getParameter("callback")+"("+returnJSON.toString()+ ");");
out.flush();
%>