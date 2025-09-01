<%@ page language="java"
%><%@ page import="java.io.*"
%><%@ page import="java.util.*"
%><%@ page import="java.net.*"
%><%@ page import="java.nio.*"
%><%@ page import="java.nio.channels.*"
%><%@ page import="jcifs.smb.*"
%><%@ page import="org.apache.commons.lang.StringUtils"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.util.file.SmbFileChannel"
%><%@ page import="com.hkah.util.upload.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"
%><%@ page import="org.apache.commons.io.FileUtils"
%><%@ page import="org.apache.commons.io.FilenameUtils"
%><%@ page import="org.apache.commons.io.comparator.LastModifiedFileComparator"
%><%@ page import="com.hkah.convert.Converter"
%><%@ page import="java.util.regex.Matcher"
%><%@ page import="java.util.regex.Pattern"
%><%!
	/**
	 * Returns the Mime Type of the file, depending on the extension of the filename
	 */
	private String getMimeType(String fName) {
		fName = fName.toLowerCase();
		if (fName.endsWith(".jpg") || fName.endsWith(".jpeg") || fName.endsWith(".jpe")) return "image/jpeg";
		else if (fName.endsWith(".gif")) return "image/gif";
		else if (fName.endsWith(".pdf")) return "application/pdf";
		else if (fName.endsWith(".htm") || fName.endsWith(".html") || fName.endsWith(".shtml")) return "text/html";
		else if (fName.endsWith(".avi")) return "video/x-msvideo";
		else if (fName.endsWith(".mov") || fName.endsWith(".qt")) return "video/quicktime";
		else if (fName.endsWith(".mpg") || fName.endsWith(".mpeg") || fName.endsWith(".mpe")) return "video/mpeg";
		else if (fName.endsWith(".zip")) return "application/zip";
		else if (fName.endsWith(".tiff") || fName.endsWith(".tif")) return "image/tiff";
		else if (fName.endsWith(".rtf")) return "application/rtf";
		else if (fName.endsWith(".mid") || fName.endsWith(".midi")) return "audio/x-midi";
		else if (fName.endsWith(".xl") || fName.endsWith(".xls") || fName.endsWith(".xlv")
				|| fName.endsWith(".xla") || fName.endsWith(".xlb") || fName.endsWith(".xlt")
				|| fName.endsWith(".xlm") || fName.endsWith(".xlk")) return "application/excel";
		else if (fName.endsWith(".doc") || fName.endsWith(".dot")) return "application/msword";
		else if (fName.endsWith(".png")) return "image/png";
		else if (fName.endsWith(".xml")) return "text/xml";
		else if (fName.endsWith(".svg")) return "image/svg+xml";
		else if (fName.endsWith(".mp3")) return "audio/mp3";
		else if (fName.endsWith(".ogg")) return "audio/ogg";
		else return "application/octet-stream; charset=utf-8";
	}

	/**
	 * Returns whether the file is video
	 */
	private boolean isVideo(String fName) {
		fName = fName.toLowerCase();
		return fName.endsWith(".avi") || fName.endsWith(".mov") || fName.endsWith(".qt")
			|| fName.endsWith(".mpg") || fName.endsWith(".mpeg") || fName.endsWith(".mpe")
			|| fName.endsWith(".mp4") || fName.endsWith(".wmv")|| fName.endsWith(".ogg");
	}

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

	public static boolean checkEditPermission(UserBean userBean, String folderName, boolean isPolicy, boolean isDepartmenalSharing, boolean isFdSharing,
			boolean isVPA, boolean isDeptResource) {
		String pathSeparator = "/";
		String policyDeptName = folderName;

		if (policyDeptName != null) {
			policyDeptName = policyDeptName.replaceFirst("\\\\", "");
			int sepIdx = policyDeptName.indexOf(pathSeparator);
			if (sepIdx == 0) {
				policyDeptName = policyDeptName.substring(1, policyDeptName.length());
				sepIdx = policyDeptName.indexOf(pathSeparator);
			}
			if (sepIdx > 0) {
				policyDeptName = policyDeptName.substring(0, sepIdx);
			}
			policyDeptName = policyDeptName.replaceAll(" ", "+");
			policyDeptName = policyDeptName.replaceFirst(pathSeparator, "");
		}

		if (isDepartmenalSharing) {
			String hrCode = ConstantsServerSide.isHKAH()?"710":"HR";
			String hrSuper = "4773";

			if (userBean.isAdmin()) {
				return true;
			}

			File file = new File(folderName);
			if (!userBean.isAccessible("departmental.sharing.admin") && (
					file.getParent() != null && !(file.getParent().indexOf("D_") > -1 ||
					file.getParent().indexOf("(S_") > -1 ||
					file.getParent().indexOf("(G_") > -1))) {
				return false;
			}

			if (folderName != null && folderName.indexOf("(D_") > -1) {
				int dptCodeIndex = folderName.indexOf("(D_");
				String deptCode = folderName.substring(dptCodeIndex, folderName.indexOf(")", dptCodeIndex));
				deptCode = deptCode.substring(3);

				//if (userBean.getDeptCode().equals(deptCode)) {
					String deptHeadID = DepartmentDB.getDeptHeadID(deptCode);
					if (deptHeadID != null && deptHeadID.equals(userBean.getStaffID())) {
						return true;
					}
				//}

				if (hrSuper.equals(userBean.getStaffID()) && hrCode.equals(deptCode)) {
					return true;
				}
			} else if (folderName != null && folderName.indexOf("(S_") > -1) {
				int staffCodeIndex = folderName.indexOf("(S_");
				String staffCode = folderName.substring(staffCodeIndex, folderName.indexOf(")", staffCodeIndex));
				staffCode = staffCode.substring(3);

				if (userBean.getStaffID().equals(staffCode)) {
					return true;
				}
			} else if (folderName != null && folderName.indexOf("(G_") > -1) {
				int grpCodeIndex = folderName.indexOf("(G_");
				String grpCode = folderName.substring(grpCodeIndex, folderName.indexOf(")", grpCodeIndex));
				grpCode = grpCode.substring(3);
				String groupId = AccessControlDB.CUSTOME_GRP_CODE_PREFIX.concat(grpCode);
				if (userBean.isGroupID(groupId)) {
					return true;
				}
			}
			return false;
		} else if (isFdSharing) {
			if (userBean.isAdmin()) {
				return true;
			}

			boolean result = false;
			String folderDesc = null;
			//System.out.println("[download] checkEditPermission folderName="+folderName);

			if (folderName != null && !folderName.isEmpty()) {
				String[] folderNames = folderName.split("/");
				if (folderNames != null &&  folderNames.length > 0) {
					if (folderNames.length > 1) {
						// check top level only
						folderDesc = folderNames[1];
					} else if (folderNames.length > 0) {
						// check top level only
						folderDesc = folderNames[0];
					}
				}
			}

			if (folderDesc != null && userBean.isAccessible(AccessControlDB.getFunctionIDbyDesc(folderDesc))) {
				result = true;
			}

			//System.out.println("   result="+result);
			return result;
		} else if (isVPA) {
			return false;
		} else if (isDeptResource) {
			String thisFunctionId = "function.policy."+policyDeptName+".upload";
			return (userBean.isAccessible("function.documentManagement.upload") ||
					(isDeptResource && userBean.isAccessible(thisFunctionId)));
		} else {
			String thisFunctionId = "function.policy."+policyDeptName+".upload";
			return (userBean.isAccessible("function.documentManagement.upload") ||
					(isPolicy && userBean.isAccessible(thisFunctionId)));
		}
	}

	public static String getFileExtension(String f) {
		String ext = "";
		int i = f.lastIndexOf('.');
		if (i > 0 &&  i < f.length() - 1) {
			ext = f.substring(i + 1);
		}
		return ext;
	}

	private boolean allowUpload(UserBean userBean, String folderName, boolean isPolicy, boolean isDepartmenalSharing, boolean isFdSharing,
			boolean isVPA, boolean isDeptResource, boolean isIC) {
		return userBean.isAdmin() || isPolicy || isDepartmenalSharing || isFdSharing || isDeptResource ||isIC;
	}
%><%
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
	String fdSharingYN = request.getParameter("fdSharingYN");
	String vpaYN = request.getParameter("vpaYN");
	String deptResourceYN = request.getParameter("deptResourceYN");
	dispositionType = dispositionType == null ? "attachment" : dispositionType;
	String formJSP = "download.jsp";
	String subKeyID = request.getParameter("subKeyID");
	String src = request.getParameter("src");
	String embedVideoYN = request.getParameter("embedVideoYN");
	String useSambaYN = request.getParameter("useSambaYN");

	String policyTest = request.getParameter("policyTest");
	System.out.println("0[rootFolder]:"+rootFolder+", [locationPath]:"+locationPath);

	// not allow change rootfolder to local drive
	if (rootFolder != null && rootFolder.indexOf("$") >= 0) {
		%><jsp:forward page="../common/access_deny.jsp" /><%
		throw new Exception();
	}

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
		// Document stored in CO_DOCUMENT_GENERAL
		moduleCode = (String) request.getAttribute("moduleCode");
		keyID = (String) request.getAttribute("keyID");
		policyYN = (String) request.getAttribute("policyYN");
		departmentalPolicyYN = (String) request.getAttribute("departmentalPolicyYN");
		departmentalSharingYN = (String) request.getAttribute("departmentalSharingYN");
		fdSharingYN = (String) request.getAttribute("fdSharingYN");
		vpaYN = (String) request.getAttribute("vpaYN");
		icYN = (String) request.getAttribute("icYN");
		deptResourceYN = (String) request.getAttribute("deptResourceYN");
		dispositionType = (String) request.getAttribute("dispositionType");

		String[] fileList = (String[]) request.getAttribute("filelist");

		// not allow change rootfolder to local drive
		if (rootFolder != null && rootFolder.indexOf("$") >= 0) {
			%><jsp:forward page="../common/access_deny.jsp" /><%
			throw new Exception();
		} else if (allowUpload(userBean, folderName, ConstantsVariable.YES_VALUE.equals(policyYN),
				ConstantsVariable.YES_VALUE.equals(departmentalSharingYN),
				ConstantsVariable.YES_VALUE.equals(fdSharingYN), ConstantsVariable.YES_VALUE.equals(vpaYN),
				ConstantsVariable.YES_VALUE.equals(deptResourceYN),ConstantsVariable.YES_VALUE.equals(icYN))
				&& fileList != null) {
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
	boolean isFdSharing = ConstantsVariable.YES_VALUE.equals(fdSharingYN);
	boolean isVPA = ConstantsVariable.YES_VALUE.equals(vpaYN);
	boolean isDeptResource = ConstantsVariable.YES_VALUE.equals(deptResourceYN);
	boolean isEmbedVideo = ConstantsVariable.YES_VALUE.equals(embedVideoYN);

	boolean isIntranetPath = ConstantsVariable.YES_VALUE.equals(intranetPathYN);
	//if (rootFolder == null && locationPath != null && locationPath.startsWith("\\\\")) {
	//	isIntranetPath = true;
	//}
	boolean useSamba = ConstantsVariable.YES_VALUE.equals(useSambaYN);
	
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
	} else if (isFdSharing) {
		// supply rootFolder in URL
		//rootFolder = "\\\\WWW-SERVER\\Foundation Sharing";
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

	if (documentID != null) {
		if (userBean.isAdmin() || DocumentDB.isAccessable(userBean, documentID) || isPolicy || isIC || isHRPic || isDeptResource) {
			if (moduleCode != null) {
				// fetch document info from CO_DOCUMENT_GENERAL
				// ( SELECT CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC )
				//if("ctsnew".equals(moduleCode)){
				//	record = DocumentDB.getList(userBean, ConstantsServerSide.SITE_CODE.toLowerCase(), moduleCode, keyID, new String[] {documentID}, 0, subKeyID);
				//}else{
					record = DocumentDB.getList(userBean, ConstantsServerSide.SITE_CODE.toLowerCase(), moduleCode, keyID, new String[] {documentID}, 0);
				//}
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
			%><jsp:include page="../portal/index.jsp" flush="false" /><%
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
		if (locationPath == null || fileName == null || (rootFolder != null && rootFolder.indexOf("$") >= 0)) {
			%><jsp:forward page="../common/access_deny.jsp" /><%
			throw new Exception();
		}
		String fullPath = (rootFolder == null ? "" : rootFolder) + locationPath + "/" + fileName;
		try {
			File file = new File(fullPath);
			if (file.isFile()) {
				file.delete();
				message = "Delete file: " + fileName + " success.";
				if (isPolicy) {
					String currentExtension = getFileExtension(fileName);
					String pdfFileName = fileName.replaceFirst(Pattern.quote("." + currentExtension) + "$", Matcher.quoteReplacement(".pdf"));
					String pdfPath = (rootFolder == null ? "" : rootFolder) + locationPath + "/" + pdfFileName;
					if (!"".equals(currentExtension)) {
						File pdfFile = new File(pdfPath);
						if (pdfFile.isFile()) {
							pdfFile.delete();
							message += "<br>Delete PDF file: " + fileName + " success.";
						} else {
							%><jsp:forward page="../common/access_deny.jsp" /><%
							throw new Exception();
						}
					}
				}
			} else {
				if (isIC) {
					file.delete();
				} else {
					%><jsp:forward page="../common/access_deny.jsp" /><%
					throw new Exception();
				}
			}
		} catch (Exception e) {
			errorMessage = "Cannot delete file: " + fileName;
			e.printStackTrace();
		}
	} else if ("rename".equals(command)) {
		// rename file/folder
		if (locationPath == null || fileName == null || newFileName == null || (rootFolder != null && rootFolder.indexOf("$") >= 0)) {
			%><jsp:forward page="../common/access_deny.jsp" /><%
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
				%><jsp:forward page="../common/access_deny.jsp" /><%
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
	
	System.out.println("[download] rootFolder="+rootFolder+"locationPath=" + locationPath);
	
	// open pdf in pdfjs by default
	boolean showPdfJs = locationPath==null?false:locationPath.toLowerCase().endsWith(".pdf");
	String tempSourcePath = rootFolder + locationPath;
	
	// check OS
	String fullPath = (rootFolder == null ? "" : rootFolder) + locationPath;
	File file = null;
	SmbFile smbFile = null;
	if (ServerUtil.isUseSamba(fullPath) || useSamba) {
		useSamba = true;
		smbFile = new SmbFile("smb:" + fullPath.replace("\\", "/"), 
				new NtlmPasswordAuthentication("",CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password")));
	} else {
		file = new File(fullPath);
	}
	
	//System.out.println("[download] 1 rootFolder="+rootFolder+",locationPath="+locationPath+",useSamba="+useSamba+",file.isDirectory()="+file.isDirectory());

	if (locationPath != null
			&& locationPath.trim().length() > 0
			&& ((useSamba && !smbFile.isDirectory()) || (!useSamba && !file.isDirectory()))) {
		String tempFileName = useSamba ? smbFile.getName() : file.getName();
		long fileLength = useSamba ? smbFile.length() : file.length();
		
		//System.out.println("[download] 1b locationPath.endsWith pdf="+locationPath.endsWith(".pdf")+", locationPath.indexOf(portal_document)"+locationPath.indexOf("portal_document"));

		// replace flash player by pdfjs viewer
		//if (locationPath.endsWith(".pdf") && !locationPath.contains("Phone Directory") && !"inapp".equals(src)) {
		if (false) {
			showPdfJs = true;
			response.sendRedirect(response.encodeRedirectURL("../documentManage/pdfjs/web/viewer.jsp?rootFolder=" + URLEncoder.encode(tempSourcePath, "UTF-8") + "&fileName="+URLEncoder.encode(tempFileName, "UTF-8")));
		} else {
			FileInputStream inStream = null;
			SmbFileInputStream smbInStream = null;
			ServletOutputStream outStream = null;
			FileChannel rbc = null;
			WritableByteChannel wbc = null;

//			if (file.length() > 10240000) {
//				throw new Exception ("file size is too big["); file.length() + "]!");
//			}
			DocumentDB.addHitRate(documentID);
			try {
				session.setAttribute("progress-download", 0l);

				// encode non-ascii file name
				String encodedFileName = tempFileName;
				if (encodedFileName != null) {
					encodedFileName = URLEncoder.encode(tempFileName, "UTF-8");
					encodedFileName = encodedFileName.replace("+", " ");
				}
				response.reset();
//				response.setContentType("application/octet-stream; charset=utf-8");
//				response.setContentType(getServletContext().getMimeType(locationPath));
				response.setContentType(getMimeType(locationPath));
				response.setHeader("Content-disposition", dispositionType + "; filename=\"" + encodedFileName + "\"");
				response.setHeader("Content-Length", String.valueOf(fileLength));

				if (isVideo(tempFileName)) {
					if (useSamba) {
						rbc = new SmbFileChannel(smbFile);
						rbc.position(0);
					} else {
						rbc = new FileInputStream(file).getChannel();
						rbc.position(0);
					}
					wbc = Channels.newChannel(response.getOutputStream());

					ByteBuffer bb = ByteBuffer.allocateDirect(11680);

					while (rbc.read(bb) != -1) {
						bb.flip();
						wbc.write(bb);
						bb.clear();
					}
					wbc.close();
					rbc.close();
				} else {
					int byteRead;

					int inStreamAva = 0;
					if (useSamba) {
						smbInStream = new SmbFileInputStream(smbFile);
						inStreamAva = smbInStream.available();
					} else {
						inStream = new FileInputStream(file);
						inStreamAva = inStream.available();
					}
					
					byte []  buf = new byte [ 4 * 1024 ] ; // 4K buffer
					outStream = response.getOutputStream();

					int readCount = 0;
					long progressPerc = 0;
					//while ((byteRead = inStream.read(buf)) != -1) {
					while ((byteRead = (useSamba ? smbInStream.read(buf) : inStream.read(buf))) != -1) {
						outStream.write(buf, 0, byteRead);

						readCount += byteRead;
						progressPerc = Math.round(((double) readCount / inStreamAva) * 100);
						// store the progress % value (0 - 100) in a session attribute 'progress-download'
						session.setAttribute("progress-download", progressPerc);
					}
					outStream.flush();
					outStream.close();
				}
			} catch (Exception e) {
				out.clearBuffer();
				response.setContentType("text/html; charset=big5");
				response.setHeader("Content-disposition", "inline");
				out.println("<HTML><BODY><P>");
				out.println(e.toString());
				out.println("</P></BODY></HTML>");
				
				e.printStackTrace();
			} finally {
				if (inStream != null) {
					try { inStream.close(); } catch (Exception e) {}
				}
				if (smbInStream != null) {
					try { smbInStream.close(); } catch (Exception e) {}
				}
				if (outStream != null) {
					try { outStream.close(); } catch (Exception e) {}
				}
				if (wbc != null) {
					try { wbc.close(); } catch (Exception e) {}
				}
				if (rbc != null) {
					try { rbc.close(); } catch (Exception e) {}
				}
			}
			return;
		}
	} else if (isHRPic || ((userBean.isLogin() || isEmbedVideo) && (userBean.isAdmin() || isPolicy || isIC || isDepartmentalSharing || isFdSharing || isVPA || isDeptResource || isEmbedVideo))) {
		if (locationPath == null) {
			locationPath = "";
		}
%>
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<%		if (ConstantsServerSide.isHKAH() && isDepartmentalPolicy) { %>
<head>
<link rel="stylesheet" href="../js/plupload/js/ajax/libs/jqueryui/1.8.9/themes/base/jquery-ui.css" type="text/css" />
<link rel="stylesheet" href="../js/plupload/js/jquery.ui.plupload/css/jquery.ui.plupload.css" type="text/css" />

<script type="text/javascript" src="../js/plupload/js/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
<script type="text/javascript" src="../js/plupload/js/ajax/libs/jqueryui/1.10.2/jquery-ui.min.js"></script>

<!-- production -->
<script type="text/javascript" src="../js/plupload/js/plupload.full.min.js"></script>
<script type="text/javascript" src="../js/plupload/js/jquery.ui.plupload/jquery.ui.plupload.js"></script>
</head>
<% 		} %>
<style>
#cleanblue {
	width: 600px;
}
</style>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%		if (!isPolicy && !isIC && !isDepartmentalSharing && !isFdSharing && !isVPA&& !isHRPic && !isDeptResource && !isEmbedVideo) { %>

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.documentManagement.list" />
</jsp:include>
<%		} %>
<font color="blue"><%=message%></font>
<font color="red"><%=errorMessage%></font>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<%		if (userBean.isAdmin()) { %>
	<tr class="smallText">
		<td class="portletCaption">Root Folder: <% if (isFdSharing) { %><a href="javascript:moveDirectory('')"><%=rootFolder %></a><% } else { %><%=rootFolder %><% } %></td>
	</tr>
<%		}
		if (isHRPic && (userBean.isAdmin() || "4683".equals(userBean.getStaffID()))) { %>
	<tr class="smallText">
		<td class="portletCaption">
		Hyperlink to this Folder:
		<a href="https://mail.hkah.org.hk/online/documentManage/download.jsp?hrImgYN=Y&locationPath=<%=locationPath %>">
			https://mail.hkah.org.hk/online/documentManage/download.jsp?hrImgYN=Y&locationPath=<%=locationPath %>
		</a></td>
	</tr>
<%		} %>
	<tr class="smallText">
		<td class="portletCaption"><bean:message key="prompt.fileLocation" />:
<%
		String[] path = StringUtils.split(locationPath, "/");
		StringBuffer tempPath = new StringBuffer();

		if (path.length > 0) {
			for (int i = 0; i < path.length - 1; i++) {
				tempPath.setLength(0);
				for (int j = 0; j <= i; j++) {
					tempPath.append("/");
					tempPath.append(path[j]);
				}
%>
		/&nbsp;<a href="javascript:moveDirectory('<%=tempPath.toString() %>')"><%=isDepartmentalSharing?
																						(path[i].indexOf("(D_")>-1?path[i].substring(0, path[i].indexOf("(D_")):
																							((path[i].indexOf("(S_")>-1?path[i].substring(0, path[i].indexOf("(S_")):path[i]))):
																								path[i] %></a>&nbsp;
<%
			}
%>
		/&nbsp;<%=isDepartmentalSharing?
					(path[path.length - 1].indexOf("(D_")>-1?path[path.length - 1].substring(0, path[path.length - 1].indexOf("(D_")):
						((path[path.length - 1].indexOf("(S_")>-1?path[path.length - 1].substring(0, path[path.length - 1].indexOf("(S_")):path[path.length - 1]))):
							path[path.length - 1] %>&nbsp;
<%
		}
%>
		</td>
	</tr>
</table>
<% if (isEmbedVideo) { %>
<div style="margin: 20px;">
	<p>
		<video id="video1" width="960" controls autoplay>
		  <source src="" type="video/mp4">
		Your browser does not support the video tag. Please upgrade latest version of your browser.
		</video>
	</p>
</div>
<% } %>
<form name="form1" action="download.jsp" method="post">
<table cellpadding="0" cellspacing="0"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td width="5%"></td>
<%		if (!isHRPic) { %>
		<td width="55%" align="left"><u><bean:message key="prompt.fileName" /></u></td>
		<td width="10%" align="left"><u><bean:message key="prompt.fileSize" /></u></td>
		<td width="30%" align="left"><u><bean:message key="prompt.modifiedDate" /></u></td>
<%		} %>
	</tr>
	<tr class="smallText">
		<td colspan="4">&nbsp;</td>
	</tr>
<jsp:include page="../common/directory.jsp" flush="false">
	<jsp:param name="rootFolder" value="<%=rootFolder %>" />
	<jsp:param name="locationPath" value="<%=locationPath %>" />
	<jsp:param name="allowSelectFile" value="Y" />
	<jsp:param name="policyYN" value="<%=policyYN %>" />
	<jsp:param name="departmentalPolicyYN" value="<%=departmentalPolicyYN %>" />
	<jsp:param name="departmentalSharingYN" value="<%=departmentalSharingYN %>" />
	<jsp:param name="fdSharingYN" value="<%=fdSharingYN %>" />
	<jsp:param name="icYN" value="<%=icYN %>" />
	<jsp:param name="hrImgYN" value="<%=hrImgYN %>" />
	<jsp:param name="vpaYN" value="<%=vpaYN %>" />
	<jsp:param name="deptResourceYN" value="<%=deptResourceYN %>" />
	<jsp:param name="embedVideoYN" value="<%=embedVideoYN %>" />
</jsp:include>
</table>
<%		if ((userBean.isAdmin() || isIC || isFdSharing) && rootFolder != null) { %><input type="hidden" name="rootFolder" value="<%=rootFolder %>"><%} %>
<input type="hidden" name="locationPath" value="<%=locationPath==null?"":locationPath %>">
<input type="hidden" name="policyYN" value="<%=policyYN==null?"":policyYN %>">
<input type="hidden" name="departmentalPolicyYN" value="<%=departmentalPolicyYN==null?"":departmentalPolicyYN %>">
<input type="hidden" name="icYN" value="<%=icYN %>" />
<input type="hidden" name="hrImgYN" value="<%=hrImgYN %>" />
<input type="hidden" name="departmentalSharingYN" value="<%=departmentalSharingYN==null?"":departmentalSharingYN %>">
<input type="hidden" name="fdSharingYN" value="<%=fdSharingYN==null?"":fdSharingYN %>">
<input type="hidden" name="policyTest" value="<%=policyTest==null?"":policyTest %>">
<input type="hidden" name="vpaYN" value="<%=vpaYN==null?"":vpaYN %>">
<input type="hidden" name="deptResourceYN" value="<%=deptResourceYN==null?"":deptResourceYN %>">
</form>
<script language="javascript">
	function moveDirectory(file) {
		document.form1.action = '<%=formJSP %>';
		document.form1.locationPath.value = file;
		document.form1.submit();
	}

	function downloadFileByFilePath(file) {
		document.form1.action = 'download.jsp';
		document.form1.locationPath.value = file;
		document.form1.submit();
	}
	
	function playVideo(url) {
		   var video = document.getElementById('video1');
		   video.src = '/Swf/' + url;
		   video.play();
	}
</script>
<%
		System.out.println("[DEBUG] download.jsp isFdSharing="+isFdSharing + ", isPolicy="+isPolicy+", locationPath="+locationPath+", checkPermission="+checkEditPermission(userBean, locationPath, isPolicy, isDepartmentalSharing, isFdSharing, isVPA, isDeptResource));
%>

<%		if (userBean.isLogin() && (checkEditPermission(userBean, locationPath, isPolicy, isDepartmentalSharing, isFdSharing, isVPA, isDeptResource) || isIC)) { %>
<form name="DirectoryForm" action="download.jsp" method="post">
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr class="smallText">
		<td align="left">
			<br><img src="../images/addfolder.gif"><bean:message key="prompt.addFolder" /><input type="textfield" name="folderName"><button onclick="return createDirectory();">Create Folder</button>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
<input type="hidden" name="policyYN" value="<%=policyYN %>">
<input type="hidden" name="departmentalPolicyYN" value="<%=departmentalPolicyYN %>">
<input type="hidden" name="icYN" value="<%=icYN %>" />
<input type="hidden" name="rootFolder" value="<%=rootFolder==null?"":rootFolder %>">
<input type="hidden" name="locationPath" value="<%=locationPath==null?"":locationPath %>">
<input type="hidden" name="departmentalSharingYN" value="<%=departmentalSharingYN==null?"":departmentalSharingYN %>">
<input type="hidden" name="fdSharingYN" value="<%=fdSharingYN==null?"":fdSharingYN %>">
<input type="hidden" name="policyTest" value="<%=policyTest==null?"":policyTest %>">
<input type="hidden" name="vpaYN" value="<%=vpaYN==null?"":vpaYN %>">
<input type="hidden" name="deptResourceYN" value="<%=deptResourceYN %>">
</form>
<form id="UploadForm" name="UploadForm" enctype="multipart/form-data" action="download.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0" >
<%		if (ConstantsServerSide.isHKAH() && isDepartmentalPolicy) { %>
	<tr class="smallText">
		<td align="left" colspan="2">
			<div>* Steps for updating policy <a href="#" onclick="return downloadFile('655');">(View User Guide)</a> :</br>
				 1. Select & download policy to computer</br>
				 2. Edit policy & save file using same file name</br>
				 3. Upload the edited policy and old file will be replaced
			</div>

		</td>
	</tr>
	<tr class="smallText">
		<td>
			<div id="uploader" style="width:100%">
				<table style="width:100%">
					<tr class="smallText">
						<td class="infoLabel" width="30%"><bean:message key="prompt.uploadFile" /></td>
						<td class="infoData" width="70%"><input type="file" name="file1" size="50" class="multi" maxlength="5"></td>
					</tr>
					<tr class="smallText">
						<td align="center" colspan="2"><button type="submit">Upload file & Convert PDF</button></td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
<!--
	<tr class="smallText">
		<td align="center" colspan="2">
			<button onclick="return convertPathFileToPdf();" >Convert all to PDF</button>
		</td>
	</tr>
-->
<%		} else { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.uploadFile" /></td>
		<td class="infoData" width="70%"><input type="file" name="file1" size="50" class="multi" maxlength="5"></td>
	</tr>
	<tr class="smallText">
		<td align="center" colspan="2"><button type="submit"><bean:message key="prompt.uploadFile" /></button></td>
	</tr>
<%		} %>
	<tr class="smallText">
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td align="center" colspan="2">*<bean:message key="message.upload.sizelimit" arg0="50M" /></td>
	</tr>
</table>

<input type="hidden" name="policyYN" value="<%=policyYN %>">
<input type="hidden" name="departmentalPolicyYN" value="<%=departmentalPolicyYN %>">
<input type="hidden" name="icYN" value="<%=icYN %>" />
<input type="hidden" name="toPDF" value="N">
<input type="hidden" name="rootFolder" value="<%=rootFolder==null?"":rootFolder %>">
<input type="hidden" name="locationPath" value="<%=locationPath==null?"":locationPath %>">
<input type="hidden" name="departmentalSharingYN" value="<%=departmentalSharingYN==null?"":departmentalSharingYN %>">
<input type="hidden" name="fdSharingYN" value="<%=fdSharingYN==null?"":fdSharingYN %>">
<input type="hidden" name="policyTest" value="<%=policyTest==null?"":policyTest %>">
<input type="hidden" name="vpaYN" value="<%=vpaYN==null?"":vpaYN %>">
<input type="hidden" name="deptResourceYN" value="<%=deptResourceYN %>">
</form>
<form name="deleteForm" action="download.jsp" method="post">
<input type="hidden" name="command" value="delete" />
<input type="hidden" name="policyYN" value="<%=policyYN %>" />
<input type="hidden" name="departmentalPolicyYN" value="<%=departmentalPolicyYN %>">
<input type="hidden" name="fdSharingYN" value="<%=fdSharingYN %>">
<input type="hidden" name="icYN" value="<%=icYN %>" />
<input type="hidden" name="rootFolder" value="<%=rootFolder==null?"":rootFolder %>" />
<input type="hidden" name="locationPath" value="<%=locationPath==null?"":locationPath %>" />
<input type="hidden" name="departmentalSharingYN" value="<%=departmentalSharingYN==null?"":departmentalSharingYN %>">
<input type="hidden" name="policyTest" value="<%=policyTest==null?"":policyTest %>">
<input type="hidden" name="vpaYN" value="<%=vpaYN==null?"":vpaYN %>">
<input type="hidden" name="deptResourceYN" value="<%=deptResourceYN %>">
<input type="hidden" name="fileName" />
<input type="hidden" name="newFileName" />
</form>
<form name="convertPathForm" action="download.jsp" method="post">
<input type="hidden" name="command" value="convertPath" />
<input type="hidden" name="policyYN" value="<%=policyYN %>" />
<input type="hidden" name="departmentalPolicyYN" value="<%=departmentalPolicyYN %>">
<input type="hidden" name="fdSharingYN" value="<%=fdSharingYN %>">
<input type="hidden" name="icYN" value="<%=icYN %>" />
<input type="hidden" name="rootFolder" value="<%=rootFolder==null?"":rootFolder %>" />
<input type="hidden" name="locationPath" value="<%=locationPath==null?"":locationPath %>" />
<input type="hidden" name="departmentalSharingYN" value="<%=departmentalSharingYN==null?"":departmentalSharingYN %>">
<input type="hidden" name="policyTest" value="<%=policyTest==null?"":policyTest %>">
<input type="hidden" name="vpaYN" value="<%=vpaYN==null?"":vpaYN %>">
<input type="hidden" name="deptResourceYN" value="<%=deptResourceYN %>" />
</form>
<script language="javascript">
<%			if (ConstantsServerSide.isHKAH() && isDepartmentalPolicy) { %>
$(function() {

	$("#uploader").plupload({
		// General settings
		runtimes : 'html5,flash,silverlight',
		url : "download.jsp",

		// Maximum file size
		max_file_size : '50mb',

		chunk_size: '50mb',

		// Resize images on clientside if we can
		resize : {
			width : 200,
			height : 200,
			quality : 90,
			crop: true // crop to exact dimensions
		},

		// Specify what files to browse for
		filters : [
			{title : "All", extensions : "*"}
		],

		// Rename files by clicking on their titles
		rename: true,

		// Sort files
		sortable: false,

		// Enable ability to drag'n'drop files onto the widget (currently only HTML5 supports that)
		dragdrop: true,

		// Views to activate
		views: {
			list: true,
			thumbs: true, // Show thumbs
			active: 'thumbs'
		},

		// Flash settings
		flash_swf_url : '../js/plupload/js/Moxie.swf',

		// Silverlight settings
		silverlight_xap_url : '../js/plupload/js/Moxie.xap',
		multipart_params : {
		"policyYN" : $("[name='policyYN']").val(),
		"departmentalPolicyYN" : $("[name='departmentalPolicyYN']").val(),
		"icYN" : $("[name='icYN']").val(),
		"toPDF" : $("[name='toPDF']").val(),
		"rootFolder" : $("[name='rootFolder']").val(),
		"locationPath" : $("[name='locationPath']").val(),
		"departmentalSharingYN" : $("[name='departmentalSharingYN']").val(),
		"fdSharingYN" : $("[name='fdSharingYN']").val(),
		"policyTest" : $("[name='policyTest']").val(),
		"vpaYN" : $("[name='vpaYN']").val(),
		"deptResourceYN" : $("[name='deptResourceYN']").val()
	    },
	    init: {
		UploadComplete: function(up, files) {
			$('#UploadForm').submit();
		}
	    }
	});
});
<%			} %>
	function convertPathFileToPdf() {
		showLoadingBox('body', 500, $(window).scrollTop());
		document.convertPathForm.command.value = 'convertPath';
		document.convertPathForm.submit();
		return false;
	};

	function createDirectory() {
		if (document.DirectoryForm.folderName.value == "") {
			alert("<bean:message key="error.folderName.required" />.");
		} else {
			document.DirectoryForm.submit();
		}
	}

	function deleteAction(fileName) {
		document.deleteForm.fileName.value = fileName;
		document.deleteForm.command.value = 'delete';
		document.deleteForm.submit();
		return true;
	}

	function renameAction(step, fileName, newFileName) {
		if (step == 1) {
			document.deleteForm.fileName.value = fileName;
			document.deleteForm.newFileName.value = newFileName;
			document.deleteForm.command.value = 'rename';
			document.deleteForm.submit();
			return true;
		} else {
			var content = 'Rename <b>' + fileName + '</b> to:<br />' + '<input name="newFileName" value="' + fileName + '" />';
<%			if (ConstantsServerSide.isHKAH() && isDepartmentalPolicy) { %>
			var newFileName = prompt('Rename ' + fileName + ' to:' , fileName);
			if (newFileName != null) {
				var e = "";
				if ("" == newFileName || newFileName == null) {
					e += "Please enter new name<br />";
				}

				if (e == "") {
					submit: renameAction(1, fileName, newFileName);
					return true;
				} else {
					//$('<div class="errorBlock" style="display: none;">'+ e +'</div>').prependTo(m).show('slow');
				}
			} else {
				return false;
			}
<%			} else { %>
//temp disable
			$.prompt(content, {
				buttons: { Ok: true, Cancel: false },
				callback: function(v, m, f) {
					var e = "";
					//m.find('.errorBlock').hide('fast',function() { $(this).remove(); });

					if (v) {
						if ("" == f.newFileName || f.newFileName == null) {
							e += "Please enter new name<br />";
						}

						if (e == "") {
							submit: renameAction(1, fileName, f.newFileName);
							return true;
						} else {
							//$('<div class="errorBlock" style="display: none;">'+ e +'</div>').prependTo(m).show('slow');
						}
					} else {
						return false;
					}
				},
				prefix:'cleanblue'
			});

			$('input[name=newFileName]')
				.attr('length', '100')
				.attr('size', '100')
				.focus()
				.select();

<%			} %>
		}
	}

	function deleteFile(fileName) {
<%			if (ConstantsServerSide.isHKAH() && isDepartmentalPolicy) { %>
		if (confirm('The file '+fileName+' will be deleted.')) {
			submit: deleteAction(fileName);
		return true;
	} else {
		return false;
	}
<%			} else { %>
		//Temp Disable

		$(this).parents(".pane").animate({ backgroundColor: "#fbc7c7" }, "fast")
		.animate({ backgroundColor: "#F9F3F7" }, "slow");
		$.prompt('The file '+fileName+' will be deleted.',{
			buttons: { Ok: true, Cancel: false },
			callback: function(v,m,f) {
				if (v) {
					submit: deleteAction(fileName);
					return true;
				} else {
					return false;
				}
			},
			prefix:'cleanblue'
		});

<%			} %>
	}
	</script>
<%		} %>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
<%
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
		%><jsp:include page="../portal/index.jsp" flush="false" /><%
		return;
	} else {
		%><jsp:forward page="../common/access_deny.jsp" /><%
	}
}
%>