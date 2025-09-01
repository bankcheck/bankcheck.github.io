<%@ page import="com.hkah.constant.*"
%><%@ page import="java.io.*"
%><%@ page import="java.util.*"
%><%@ page import="java.net.*"
%><%@ page import="java.nio.*"
%><%@ page import="java.nio.channels.*"
%><%@ page import="org.apache.commons.lang.StringUtils"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.util.upload.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"
%><%@ page import="org.apache.commons.io.FileUtils"
%><%@ page import="org.apache.commons.io.comparator.LastModifiedFileComparator"
%><%@ page import="com.hkah.convert.Converter"
%><%@ page import="java.util.regex.Matcher"
%><%@ page import="java.util.regex.Pattern"
%>
<%!
private File getFileName(File directory, String filePrefix, String fileSuffix, String fileName) {
	File newDirectory = new File(directory.toString() + File.separator + fileName);
	if (!newDirectory.exists()) {
		return null;
	}
	if ((filePrefix == null || filePrefix.length() == 0 || newDirectory.getName().indexOf(filePrefix) >= 0)
			&& (fileSuffix == null || fileSuffix.length() == 0 || newDirectory.getName().indexOf(fileSuffix) > 0)) {
		return newDirectory;
	} else {
		if (newDirectory.isDirectory()) {
			File[] children = newDirectory.listFiles();
			if (children != null) {
				try {
					File latestFileName = null;
					File tempFileName = null;
					for (int i = 0; i < children.length; i++) {
						tempFileName = getFileName(newDirectory, filePrefix, fileSuffix, children[i].getName());
						if (tempFileName != null && (latestFileName == null || LastModifiedFileComparator.LASTMODIFIED_COMPARATOR.compare(latestFileName,tempFileName) < 0)) {
							latestFileName = tempFileName;
						}
					}
					if (latestFileName != null) {
						return latestFileName;
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	return null;
}

public static String getFileExtension(String f) {
    String ext = "";
    int i = f.lastIndexOf('.');
    if (i > 0 &&  i < f.length() - 1) {
      ext = f.substring(i + 1);
    }
    return ext;
  }
%>
<%
boolean isAllowPresentationMode = !"N".equalsIgnoreCase(request.getParameter("allowPresentationMode"));
boolean isAllowOpenFile = !"N".equalsIgnoreCase(request.getParameter("allowOpenFile"));
boolean isAllowPrint = !"N".equalsIgnoreCase(request.getParameter("allowPrint"));
boolean isAllowDownload = !"N".equalsIgnoreCase(request.getParameter("allowDownload"));
String fileForPdfjs = request.getParameter("file");

if (fileForPdfjs == null) {
	ArrayList<ReportableListObject> record = null;
	ReportableListObject row = null;
	
	if (session == null) {
		%><jsp:forward page="../common/access_deny.jsp" /><%
	} else if (!ConstantsServerSide.CORE_SERVER && ConstantsServerSide.LOAD_BALANCE) {
		UserBean userBean = new UserBean(request);
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("http://");
		strBuf.append(ConstantsServerSide.INTRANET_URL);
		strBuf.append("/intranet/documentManage/download.jsp?");
	
		Enumeration parameterList = request.getParameterNames();
		String parameterName = null;
		while( parameterList.hasMoreElements() ) {
			parameterName = parameterList.nextElement().toString();
			strBuf.append(parameterName);
			strBuf.append("=");
			strBuf.append(URLEncoder.encode(request.getParameter(parameterName)));
			strBuf.append("&");
		}
		strBuf.append("sessionID=");
		if (request.getSession() != null) {
			strBuf.append(request.getSession().getId());
		}
		strBuf.append("&staffID=");
		if (userBean != null && userBean.isLogin()) {
			strBuf.append(userBean.getStaffID());
		}
		response.sendRedirect(strBuf.toString());
	} else {
		UserBean userBean = new UserBean(request);
		String command = request.getParameter("command");
		String mmsFileName = request.getParameter("mmsFileName");
		String moduleName = request.getParameter("moduleName");
		String rootFolder = TextUtil.parseStrUTF8(request.getParameter("rootFolder"));
		String locationPath = TextUtil.parseStrUTF8(request.getParameter("locationPath"));
		String documentID = request.getParameter("documentID");
		String folderName = TextUtil.parseStrUTF8(request.getParameter("folderName"));
		String fileName = TextUtil.parseStrUTF8(request.getParameter("fileName"));
		String newFileName = TextUtil.parseStrUTF8(request.getParameter("newFileName"));
		//Document stored in CO_DOCUMENT_GENERAL
		String moduleCode = request.getParameter("moduleCode");
		String keyID = request.getParameter("keyID");
		String policyYN = request.getParameter("policyYN");
		String departmentalPolicyYN = request.getParameter("departmentalPolicyYN");
		String icYN = request.getParameter("icYN");
		String hrImgYN = request.getParameter("hrImgYN");
		String intranetPathYN = request.getParameter("intranetPathYN");
		String dispositionType = request.getParameter("dispositionType");
		String departmentalSharingYN = request.getParameter("departmentalSharingYN");
		String vpaYN = request.getParameter("vpaYN");
		String deptResourceYN = request.getParameter("deptResourceYN");
		dispositionType = dispositionType == null ? "attachment" : dispositionType;
		String formJSP = "download.jsp";
		String subKeyID = request.getParameter("subKeyID");
		String viewer = request.getParameter("viewer");
	
		String policyTest = request.getParameter("policyTest");
		System.out.println("0[locationPath]:"+locationPath);
		// load userbean if load balance is on
		if (ConstantsServerSide.CORE_SERVER && ConstantsServerSide.LOAD_BALANCE) {
			String sessionID = request.getParameter("sessionID");
			String staffID = request.getParameter("staffID");
	
			if ((userBean == null || !userBean.isLogin() || !userBean.getStaffID().equals(staffID)) && sessionID != null && sessionID.length() > 0 && staffID != null && staffID.length() > 0) {
				record = UtilDBWeb.getReportableList("SELECT u.CO_STAFF_ID FROM SSO_SESSION@SSO s, co_users u WHERE s.USER_ID = U.CO_USERNAME AND s.MODULE_CODE = 'hk.portal' AND s.SESSION_ID = ? AND u.CO_STAFF_ID = ? AND s.TIMESTAMP_UPDATE > SYSDATE - 1", new String[] { sessionID, staffID });
				if (record.size() > 0) {
					row = (ReportableListObject) record.get(0);
					userBean = UserDB.getUserBean(request, row.getValue(0));
				}
			}
		}
	
		String message = "";
		String errorMessage = "";
	
		// Check that we have a file upload request
		if (HttpFileUpload.isMultipartContent(request)) {
			Vector uploadMessage = HttpFileUpload.toUploadFolder(
				request,
				ConstantsServerSide.DOCUMENT_FOLDER,
				ConstantsServerSide.TEMP_FOLDER,
				ConstantsServerSide.UPLOAD_FOLDER
			);
	
			rootFolder = TextUtil.parseStrUTF8((String) request.getAttribute("rootFolder"));
			locationPath = TextUtil.parseStrUTF8((String) request.getAttribute("locationPath"));
			documentID = (String) request.getAttribute("documentID");
			folderName = TextUtil.parseStrUTF8((String) request.getAttribute("folderName"));
			fileName = TextUtil.parseStrUTF8((String) request.getAttribute("fileName"));
			//Document stored in CO_DOCUMENT_GENERAL
			moduleCode = (String) request.getAttribute("moduleCode");
			keyID = (String) request.getAttribute("keyID");
			policyYN = (String) request.getAttribute("policyYN");
			departmentalPolicyYN = (String) request.getAttribute("departmentalPolicyYN");
			departmentalSharingYN = (String) request.getAttribute("departmentalSharingYN");
			vpaYN = (String) request.getAttribute("vpaYN");
			icYN = (String) request.getAttribute("icYN");
			deptResourceYN = (String) request.getAttribute("deptResourceYN");
			dispositionType = (String) request.getAttribute("dispositionType");
	
			String[] fileList = (String[]) request.getAttribute("filelist");
			if (fileList != null) {
				for (int i = 0; i < fileList.length; i++) {
					FileUtil.moveFile(
							ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
							rootFolder + locationPath + File.separator + fileList[i]);
					if (ConstantsServerSide.isHKAH() && ConstantsVariable.YES_VALUE.equals(departmentalPolicyYN)) {
						message = message + Converter.convertDoc2Pdf(rootFolder + locationPath + File.separator, fileList[i]);
					}
				}
				message = message + "<br>";
			}
	
			if (uploadMessage.size() > 0) {
				for (int i=0; i<uploadMessage.size(); i++) {
					message += uploadMessage.get(i) + "<br>";
				}
			}
		}
	
		if ("convertPath".equals(command)) {
			 message = Converter.convertPathFile2Pdf(rootFolder + locationPath);
		}
	
		boolean isPolicy = ConstantsVariable.YES_VALUE.equals(policyYN);
		boolean isDepartmentalPolicy = ConstantsVariable.YES_VALUE.equals(departmentalPolicyYN);
		boolean isIC = ConstantsVariable.YES_VALUE.equals(icYN);
		boolean isHRPic = ConstantsVariable.YES_VALUE.equals(hrImgYN);
		boolean isDepartmentalSharing = ConstantsVariable.YES_VALUE.equals(departmentalSharingYN);
		boolean isVPA = ConstantsVariable.YES_VALUE.equals(vpaYN);
		boolean isDeptResource = ConstantsVariable.YES_VALUE.equals(deptResourceYN);
		
		boolean isPdfJsViewer = "pdfjs".equals(viewer);
		boolean isIntranetPath = ConstantsVariable.YES_VALUE.equals(intranetPathYN);
		if (isPolicy && !isIC) {
			if (rootFolder == null || rootFolder.isEmpty()) {
				if (isDepartmentalPolicy) {
					if ("Y".equals(policyTest)) {
						rootFolder = ConstantsServerSide.POLICY_FOLDER + "\\departmental_test";
					} else {
						rootFolder = ConstantsServerSide.POLICY_FOLDER + "\\departmental";
					}
				} else {
					rootFolder = ConstantsServerSide.POLICY_FOLDER;
				}
			}
			formJSP = "policy.jsp";
		} else if (isDepartmentalSharing) {
			if (ConstantsServerSide.isHKAH()) {
				rootFolder = "\\\\WWW-SERVER\\Departmental Sharing";
			}
			else if (ConstantsServerSide.isTWAH()) {
				rootFolder = "\\\\IT-S20\\document\\Intranet\\Portal\\Departmental Sharing";
			}
		} else if (isVPA) {
			rootFolder = "\\\\WWW-SERVER\\";
		} else if (isDeptResource) {
			if (ConstantsServerSide.isHKAH()) {
				rootFolder = "\\\\WWW-SERVER\\POLICY\\departmental_resource";
			}
		} else if (isIntranetPath) {
			rootFolder = "";
		} else if ((rootFolder == null || rootFolder.length() == 0)) {
			rootFolder = ConstantsServerSide.DOCUMENT_FOLDER;
		}
	
		if (isHRPic) {
			rootFolder = "\\\\hknas\\TO IT CHERRY\\";
		}
		locationPath = locationPath == null ? "" : locationPath;
		
		if (documentID != null) {		
			if (userBean.isAdmin() || DocumentDB.isAccessable(userBean, documentID) || isPolicy || isIC || isHRPic || isDeptResource) {
				if (moduleCode != null) {			
					// fetch document info from CO_DOCUMENT_GENERAL
					// ( SELECT CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC )
					record = DocumentDB.getList(userBean, ConstantsServerSide.SITE_CODE.toLowerCase(), moduleCode, keyID, new String[] {documentID}, 0);							
					if (record.size() > 0) {
						row = (ReportableListObject) record.get(0);
						locationPath =  row.getValue(1) + "\\" + row.getValue(2);
						
						if (locationPath.startsWith("\\\\")) {
							rootFolder = "";
						}
					}
				} else {				
					row = DocumentDB.getReportableListObject(documentID);
					if (row != null) {
						locationPath = row.getValue(2);
	
						// is the file located in web folder
						if ("N".equals(row.getValue(3))) {
							rootFolder = "";
						}
	
						// is located with filename
						if ("N".equals(row.getValue(4))) {
							String filePrefix = row.getValue(5);
							String fileSuffix = row.getValue(6);
	
							// special handle for different file name
							if (fileName != null && fileName.length() > 0) {
								locationPath += fileName;
							} else {
								locationPath = getFileName(new File(rootFolder), filePrefix, fileSuffix, locationPath).getPath();
							}
						}
					}
				}
			} else if (!userBean.isLogin()) {			
				StringBuffer strBuf = new StringBuffer();
				strBuf.append(request.getServletPath().substring(1));
				strBuf.append("?");
				Enumeration parameterList = request.getParameterNames();
				String parameterName = null;
				while( parameterList.hasMoreElements() ) {
					parameterName = parameterList.nextElement().toString();
					strBuf.append(parameterName);
					strBuf.append("=");
					strBuf.append(request.getParameter(parameterName));
					strBuf.append("&");
				}
	
				if (strBuf.length() > 0) {
					session.setAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_REFERER, strBuf.toString());
				}
				%><jsp:include page="../../../portal/index.jsp" flush="false" /><%
				return;
			} else {
				%><jsp:forward page="../common/access_deny.jsp" /><%
				return;
			}
		} else if (locationPath != null && folderName != null) {
			// create folder
			File file = new File(rootFolder + locationPath + File.separator + folderName);
			file.mkdir();
		} else if ("delete".equals(command)) {
			// delete file/folder
			if (locationPath == null || fileName == null) {
				throw new Exception();
			}
			String fullPath = (rootFolder == null ? "" : rootFolder) + locationPath + "/" + fileName;
			try {	
				File file = new File(fullPath);
				if (file.isFile()) {
					file.delete();
					message = "Delete file: " + fileName + " success.";
					if(isPolicy){
						 String currentExtension = getFileExtension(fileName);			
						 String pdfFileName = fileName.replaceFirst(Pattern.quote("." + currentExtension) + "$", Matcher.quoteReplacement(".pdf"));
						 String pdfPath = (rootFolder == null ? "" : rootFolder) + locationPath + "/" + pdfFileName;
						if (currentExtension.equals("")){					 
						} else {
							File pdfFile = new File(pdfPath);
							if (pdfFile.isFile()) {
								pdfFile.delete();
								message = message + "<br>Delete PDF file: " + fileName + " success.";
							} else {
								throw new Exception();
							}
						}				
					}
				} else {
					if (isIC) {
						file.delete();
					} else {
						throw new Exception();
					}
				}
			} catch (Exception e) {
				errorMessage = "Cannot delete file: " + fileName;
				e.printStackTrace();
			}
		} else if ("rename".equals(command)) {
			// rename file/folder
			if (locationPath == null || fileName == null || newFileName == null) {
				throw new Exception();
			}
			String fullPath = (rootFolder == null ? "" : rootFolder) + locationPath + "/" + fileName;
			String newFullPath = (rootFolder == null ? "" : rootFolder) + locationPath + "/" + newFileName;
	
			try {
				File file = new File(fullPath);
				File newfile = new File(newFullPath);
	
				if (newfile.exists()) {
					errorMessage = "File/folder with name: " + newFileName + " already exists.";
				}
	
				if (!file.renameTo(newfile)) {
					throw new Exception();
				}
			} catch (Exception e) {
				if (errorMessage.isEmpty()) {
					errorMessage = "Cannot rename file/folder: " + fileName + ". There may have sub-folders or files that are opened by other users.";
				}
				//e.printStackTrace();
			}
		} else if ("mms".equals(moduleName)) {
			locationPath =  "/upload/MMS" + "/" + mmsFileName;
		}
	
		System.out.println("[viewer.jsp] test pdfjs userBean.getLoginID()="+userBean.getLoginID());
		System.out.println("[viewer.jsp] rootFolder + locationPath="+rootFolder + locationPath);
		System.out.println("[viewer.jsp] StringUtils.replace + to ' ' URLEncoder.encode(rootFolder + locationPath)="+StringUtils.replace(URLEncoder.encode(rootFolder + locationPath, "UTF-8"), "+", " "));
		response.sendRedirect(response.encodeRedirectURL("viewer.jsp?file="+StringUtils.replace(URLEncoder.encode(rootFolder + locationPath, "UTF-8"), "+", " ") +
				"&allowPresentationMode="+request.getParameter("allowPresentationMode") +
				"&allowOpenFile="+request.getParameter("allowOpenFile") +
				"&allowPrint="+request.getParameter("allowPrint") +
				"&allowDownload="+request.getParameter("allowDownload")
		));
	}
}
%>
<!DOCTYPE html>
<!--
Copyright 2012 Mozilla Foundation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Adobe CMap resources are covered by their own copyright but the same license:

    Copyright 1990-2015 Adobe Systems Incorporated.

See https://github.com/adobe-type-tools/cmap-resources
-->
<html dir="ltr" mozdisallowselectionprint moznomarginboxes>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <meta name="google" content="notranslate">
    
    <meta name="description" content="™‚">
    
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>PDF.js viewer</title>


    <link rel="stylesheet" href="viewer.css">

    <script src="compatibility.js"></script>
    <script src="typedarray.js"></script>
    <script src="base64-encode-decode.js"></script>
    <script src="base64.js"></script>



<!-- This snippet is used in production (included from viewer.html) -->
<link rel="resource" type="application/l10n" href="locale/locale.properties">
<script src="l10n.js"></script>
<script src="../build/pdf.js"></script>



    <script src="debugger.js"></script>
    <script src="viewer.js"></script>

  </head>

  <body tabindex="1" class="loadingInProgress">
    <div id="outerContainer">

      <div id="sidebarContainer">
        <div id="toolbarSidebar">
          <div class="splitToolbarButton toggled">
            <button id="viewThumbnail" class="toolbarButton group toggled" title="Show Thumbnails" tabindex="2" data-l10n-id="thumbs">
               <span data-l10n-id="thumbs_label">Thumbnails</span>
            </button>
            <button id="viewOutline" class="toolbarButton group" title="Show Document Outline" tabindex="3" data-l10n-id="outline">
               <span data-l10n-id="outline_label">Document Outline</span>
            </button>
            <button id="viewAttachments" class="toolbarButton group" title="Show Attachments" tabindex="4" data-l10n-id="attachments">
               <span data-l10n-id="attachments_label">Attachments</span>
            </button>
          </div>
        </div>
        <div id="sidebarContent">
          <div id="thumbnailView">
          </div>
          <div id="outlineView" class="hidden">
          </div>
          <div id="attachmentsView" class="hidden">
          </div>
        </div>
      </div>  <!-- sidebarContainer -->

      <div id="mainContainer">
        <div class="findbar hidden doorHanger hiddenSmallView" id="findbar">
          <label for="findInput" class="toolbarLabel" data-l10n-id="find_label">Find:</label>
          <input id="findInput" class="toolbarField" tabindex="91">
          <div class="splitToolbarButton">
            <button class="toolbarButton findPrevious" title="" id="findPrevious" tabindex="92" data-l10n-id="find_previous">
              <span data-l10n-id="find_previous_label">Previous</span>
            </button>
            <div class="splitToolbarButtonSeparator"></div>
            <button class="toolbarButton findNext" title="" id="findNext" tabindex="93" data-l10n-id="find_next">
              <span data-l10n-id="find_next_label">Next</span>
            </button>
          </div>
          <input type="checkbox" id="findHighlightAll" class="toolbarField" tabindex="94">
          <label for="findHighlightAll" class="toolbarLabel" data-l10n-id="find_highlight">Highlight all</label>
          <input type="checkbox" id="findMatchCase" class="toolbarField" tabindex="95">
          <label for="findMatchCase" class="toolbarLabel" data-l10n-id="find_match_case_label">Match case</label>
          <span id="findResultsCount" class="toolbarLabel hidden"></span>
          <span id="findMsg" class="toolbarLabel"></span>
        </div>  <!-- findbar -->

        <div id="secondaryToolbar" class="secondaryToolbar hidden doorHangerRight">
          <div id="secondaryToolbarButtonContainer">
            <button id="secondaryPresentationMode" class="secondaryToolbarButton presentationMode visibleLargeView<%=!isAllowPresentationMode ? " hidden" : "" %>" title="Switch to Presentation Mode" tabindex="51" data-l10n-id="presentation_mode">
              <span data-l10n-id="presentation_mode_label">Presentation Mode</span>
            </button>

            <button id="secondaryOpenFile" class="secondaryToolbarButton openFile visibleLargeView<%=!isAllowOpenFile ? " hidden" : "" %>" title="Open File" tabindex="52" data-l10n-id="open_file">
              <span data-l10n-id="open_file_label">Open</span>
            </button>

            <button id="secondaryPrint" class="secondaryToolbarButton print visibleMediumView<%=!isAllowPrint ? " hidden" : "" %>" title="Print" tabindex="53" data-l10n-id="print">
              <span data-l10n-id="print_label">Print</span>
            </button>

            <button id="secondaryDownload" class="secondaryToolbarButton download visibleMediumView<%=!isAllowDownload ? " hidden" : "" %>" title="Download" tabindex="54" data-l10n-id="download">
              <span data-l10n-id="download_label">Download</span>
            </button>

            <a href="#" id="secondaryViewBookmark" class="secondaryToolbarButton bookmark visibleSmallView" title="Current view (copy or open in new window)" tabindex="55" data-l10n-id="bookmark">
              <span data-l10n-id="bookmark_label">Current View</span>
            </a>

            <div class="horizontalToolbarSeparator visibleLargeView"></div>

            <button id="firstPage" class="secondaryToolbarButton firstPage" title="Go to First Page" tabindex="56" data-l10n-id="first_page">
              <span data-l10n-id="first_page_label">Go to First Page</span>
            </button>
            <button id="lastPage" class="secondaryToolbarButton lastPage" title="Go to Last Page" tabindex="57" data-l10n-id="last_page">
              <span data-l10n-id="last_page_label">Go to Last Page</span>
            </button>

            <div class="horizontalToolbarSeparator"></div>

            <button id="pageRotateCw" class="secondaryToolbarButton rotateCw" title="Rotate Clockwise" tabindex="58" data-l10n-id="page_rotate_cw">
              <span data-l10n-id="page_rotate_cw_label">Rotate Clockwise</span>
            </button>
            <button id="pageRotateCcw" class="secondaryToolbarButton rotateCcw" title="Rotate Counterclockwise" tabindex="59" data-l10n-id="page_rotate_ccw">
              <span data-l10n-id="page_rotate_ccw_label">Rotate Counterclockwise</span>
            </button>

            <div class="horizontalToolbarSeparator"></div>

            <button id="toggleHandTool" class="secondaryToolbarButton handTool" title="Enable hand tool" tabindex="60" data-l10n-id="hand_tool_enable">
              <span data-l10n-id="hand_tool_enable_label">Enable hand tool</span>
            </button>

            <div class="horizontalToolbarSeparator"></div>

            <button id="documentProperties" class="secondaryToolbarButton documentProperties" title="Document Propertiesâ€¦" tabindex="61" data-l10n-id="document_properties">
              <span data-l10n-id="document_properties_label">Document Propertiesâ€¦</span>
            </button>
          </div>
        </div>  <!-- secondaryToolbar -->

        <div class="toolbar">
          <div id="toolbarContainer">
            <div id="toolbarViewer">
              <div id="toolbarViewerLeft">
                <button id="sidebarToggle" class="toolbarButton" title="Toggle Sidebar" tabindex="11" data-l10n-id="toggle_sidebar">
                  <span data-l10n-id="toggle_sidebar_label">Toggle Sidebar</span>
                </button>
                <div class="toolbarButtonSpacer"></div>
                <button id="viewFind" class="toolbarButton group hiddenSmallView" title="Find in Document" tabindex="12" data-l10n-id="findbar">
                   <span data-l10n-id="findbar_label">Find</span>
                </button>
                <div class="splitToolbarButton">
                  <button class="toolbarButton pageUp" title="Previous Page" id="previous" tabindex="13" data-l10n-id="previous">
                    <span data-l10n-id="previous_label">Previous</span>
                  </button>
                  <div class="splitToolbarButtonSeparator"></div>
                  <button class="toolbarButton pageDown" title="Next Page" id="next" tabindex="14" data-l10n-id="next">
                    <span data-l10n-id="next_label">Next</span>
                  </button>
                </div>
                <label id="pageNumberLabel" class="toolbarLabel" for="pageNumber" data-l10n-id="page_label">Page: </label>
                <input type="number" id="pageNumber" class="toolbarField pageNumber" value="1" size="4" min="1" tabindex="15">
                <span id="numPages" class="toolbarLabel"></span>
              </div>
              <div id="toolbarViewerRight">
                <button id="presentationMode" class="toolbarButton presentationMode hiddenLargeView<%=!isAllowPresentationMode ? " hidden" : "" %>" title="Switch to Presentation Mode" tabindex="31" data-l10n-id="presentation_mode">
                  <span data-l10n-id="presentation_mode_label">Presentation Mode</span>
                </button>

                <button id="openFile" class="toolbarButton openFile hiddenLargeView<%=!isAllowOpenFile ? " hidden" : "" %>" title="Open File" tabindex="32" data-l10n-id="open_file">
                  <span data-l10n-id="open_file_label">Open</span>
                </button>

                <button id="print" class="toolbarButton print hiddenMediumView<%=!isAllowPrint ? " hidden" : "" %>" title="Print" tabindex="33" data-l10n-id="print">
                  <span data-l10n-id="print_label">Print</span>
                </button>

                <button id="download" class="toolbarButton download hiddenMediumView<%=!isAllowDownload ? " hidden" : "" %>" title="Download" tabindex="34" data-l10n-id="download">
                  <span data-l10n-id="download_label">Download</span>
                </button>
                <a href="#" id="viewBookmark" class="toolbarButton bookmark hiddenSmallView" title="Current view (copy or open in new window)" tabindex="35" data-l10n-id="bookmark">
                  <span data-l10n-id="bookmark_label">Current View</span>
                </a>

                <div class="verticalToolbarSeparator hiddenSmallView"></div>

                <button id="secondaryToolbarToggle" class="toolbarButton" title="Tools" tabindex="36" data-l10n-id="tools">
                  <span data-l10n-id="tools_label">Tools</span>
                </button>
              </div>
              <div class="outerCenter">
                <div class="innerCenter" id="toolbarViewerMiddle">
                  <div class="splitToolbarButton">
                    <button id="zoomOut" class="toolbarButton zoomOut" title="Zoom Out" tabindex="21" data-l10n-id="zoom_out">
                      <span data-l10n-id="zoom_out_label">Zoom Out</span>
                    </button>
                    <div class="splitToolbarButtonSeparator"></div>
                    <button id="zoomIn" class="toolbarButton zoomIn" title="Zoom In" tabindex="22" data-l10n-id="zoom_in">
                      <span data-l10n-id="zoom_in_label">Zoom In</span>
                     </button>
                  </div>
                  <span id="scaleSelectContainer" class="dropdownToolbarButton">
                     <select id="scaleSelect" title="Zoom" tabindex="23" data-l10n-id="zoom">
                      <option id="pageAutoOption" title="" value="auto" selected="selected" data-l10n-id="page_scale_auto">Automatic Zoom</option>
                      <option id="pageActualOption" title="" value="page-actual" data-l10n-id="page_scale_actual">Actual Size</option>
                      <option id="pageFitOption" title="" value="page-fit" data-l10n-id="page_scale_fit">Fit Page</option>
                      <option id="pageWidthOption" title="" value="page-width" data-l10n-id="page_scale_width">Full Width</option>
                      <option id="customScaleOption" title="" value="custom"></option>
                      <option title="" value="0.5" data-l10n-id="page_scale_percent" data-l10n-args='{ "scale": 50 }'>50%</option>
                      <option title="" value="0.75" data-l10n-id="page_scale_percent" data-l10n-args='{ "scale": 75 }'>75%</option>
                      <option title="" value="1" data-l10n-id="page_scale_percent" data-l10n-args='{ "scale": 100 }'>100%</option>
                      <option title="" value="1.25" data-l10n-id="page_scale_percent" data-l10n-args='{ "scale": 125 }'>125%</option>
                      <option title="" value="1.5" data-l10n-id="page_scale_percent" data-l10n-args='{ "scale": 150 }'>150%</option>
                      <option title="" value="2" data-l10n-id="page_scale_percent" data-l10n-args='{ "scale": 200 }'>200%</option>
                      <option title="" value="3" data-l10n-id="page_scale_percent" data-l10n-args='{ "scale": 300 }'>300%</option>
                      <option title="" value="4" data-l10n-id="page_scale_percent" data-l10n-args='{ "scale": 400 }'>400%</option>
                    </select>
                  </span>
                </div>
              </div>
            </div>
            <div id="loadingBar">
              <div class="progress">
                <div class="glimmer">
                </div>
              </div>
            </div>
          </div>
        </div>

        <menu type="context" id="viewerContextMenu">
          <menuitem id="contextFirstPage" label="First Page"
                    data-l10n-id="first_page"></menuitem>
          <menuitem id="contextLastPage" label="Last Page"
                    data-l10n-id="last_page"></menuitem>
          <menuitem id="contextPageRotateCw" label="Rotate Clockwise"
                    data-l10n-id="page_rotate_cw"></menuitem>
          <menuitem id="contextPageRotateCcw" label="Rotate Counter-Clockwise"
                    data-l10n-id="page_rotate_ccw"></menuitem>
        </menu>

        <div id="viewerContainer" tabindex="0">
          <div id="viewer" class="pdfViewer"></div>
        </div>

        <div id="errorWrapper" hidden='true'>
          <div id="errorMessageLeft">
            <span id="errorMessage"></span>
            <button id="errorShowMore" data-l10n-id="error_more_info">
              More Information
            </button>
            <button id="errorShowLess" data-l10n-id="error_less_info" hidden='true'>
              Less Information
            </button>
          </div>
          <div id="errorMessageRight">
            <button id="errorClose" data-l10n-id="error_close">
              Close
            </button>
          </div>
          <div class="clearBoth"></div>
          <textarea id="errorMoreInfo" hidden='true' readonly="readonly"></textarea>
        </div>
      </div> <!-- mainContainer -->

      <div id="overlayContainer" class="hidden">
        <div id="passwordOverlay" class="container hidden">
          <div class="dialog">
            <div class="row">
              <p id="passwordText" data-l10n-id="password_label">Enter the password to open this PDF file:</p>
            </div>
            <div class="row">
              <!-- The type="password" attribute is set via script, to prevent warnings in Firefox for all http:// documents. -->
              <input id="password" class="toolbarField">
            </div>
            <div class="buttonRow">
              <button id="passwordCancel" class="overlayButton"><span data-l10n-id="password_cancel">Cancel</span></button>
              <button id="passwordSubmit" class="overlayButton"><span data-l10n-id="password_ok">OK</span></button>
            </div>
          </div>
        </div>
        <div id="documentPropertiesOverlay" class="container hidden">
          <div class="dialog">
            <div class="row">
              <span data-l10n-id="document_properties_file_name">File name:</span> <p id="fileNameField">-</p>
            </div>
            <div class="row">
              <span data-l10n-id="document_properties_file_size">File size:</span> <p id="fileSizeField">-</p>
            </div>
            <div class="separator"></div>
            <div class="row">
              <span data-l10n-id="document_properties_title">Title:</span> <p id="titleField">-</p>
            </div>
            <div class="row">
              <span data-l10n-id="document_properties_author">Author:</span> <p id="authorField">-</p>
            </div>
            <div class="row">
              <span data-l10n-id="document_properties_subject">Subject:</span> <p id="subjectField">-</p>
            </div>
            <div class="row">
              <span data-l10n-id="document_properties_keywords">Keywords:</span> <p id="keywordsField">-</p>
            </div>
            <div class="row">
              <span data-l10n-id="document_properties_creation_date">Creation Date:</span> <p id="creationDateField">-</p>
            </div>
            <div class="row">
              <span data-l10n-id="document_properties_modification_date">Modification Date:</span> <p id="modificationDateField">-</p>
            </div>
            <div class="row">
              <span data-l10n-id="document_properties_creator">Creator:</span> <p id="creatorField">-</p>
            </div>
            <div class="separator"></div>
            <div class="row">
              <span data-l10n-id="document_properties_producer">PDF Producer:</span> <p id="producerField">-</p>
            </div>
            <div class="row">
              <span data-l10n-id="document_properties_version">PDF Version:</span> <p id="versionField">-</p>
            </div>
            <div class="row">
              <span data-l10n-id="document_properties_page_count">Page Count:</span> <p id="pageCountField">-</p>
            </div>
            <div class="buttonRow">
              <button id="documentPropertiesClose" class="overlayButton"><span data-l10n-id="document_properties_close">Close</span></button>
            </div>
          </div>
        </div>
      </div>  <!-- overlayContainer -->

    </div> <!-- outerContainer -->
    <div id="printContainer"></div>
<div id="mozPrintCallback-shim" hidden>
  <style>
@media print {
  #printContainer div {
    page-break-after: always;
    page-break-inside: avoid;
  }
}
  </style>
  <style scoped>
#mozPrintCallback-shim {
  position: fixed;
  top: 0;
  left: 0;
  height: 100%;
  width: 100%;
  z-index: 9999999;

  display: block;
  text-align: center;
  background-color: rgba(0, 0, 0, 0.5);
}
#mozPrintCallback-shim[hidden] {
  display: none;
}
@media print {
  #mozPrintCallback-shim {
    display: none;
  }
}

#mozPrintCallback-shim .mozPrintCallback-dialog-box {
  display: inline-block;
  margin: -50px auto 0;
  position: relative;
  top: 45%;
  left: 0;
  min-width: 220px;
  max-width: 400px;

  padding: 9px;

  border: 1px solid hsla(0, 0%, 0%, .5);
  border-radius: 2px;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3);

  background-color: #474747;

  color: hsl(0, 0%, 85%);
  font-size: 16px;
  line-height: 20px;
}
#mozPrintCallback-shim .progress-row {
  clear: both;
  padding: 1em 0;
}
#mozPrintCallback-shim progress {
  width: 100%;
}
#mozPrintCallback-shim .relative-progress {
  clear: both;
  float: right;
}
#mozPrintCallback-shim .progress-actions {
  clear: both;
}
  </style>
  <div class="mozPrintCallback-dialog-box">
    <!-- TODO: Localise the following strings -->
    Preparing document for printing...
    <div class="progress-row">
      <progress value="0" max="100"></progress>
      <span class="relative-progress">0%</span>
    </div>
    <div class="progress-actions">
      <input type="button" value="Cancel" class="mozPrintCallback-cancel">
    </div>
  </div>
</div>

  </body>
</html>

