<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
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
String keyID = ParserUtil.getParameter(request, "keyID");

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

if (fileUpload) {
/* 	if (createAction && "1".equals(step)) {
		// get news id with dummy data
		newsID = NewsDB.add(userBean, newsCategory);
	} */
	
	String[] fileList = (String[]) request.getAttribute("filelist");
	String site = null;
	if (ConstantsServerSide.isTWAH()) {
		site = "\\\\192.168.0.20\\document\\Upload\\Marketing";
	} else {
		site ="\\\\www-server\\document\\Upload\\Marketing";
	}
	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

	
		for (int i = 0; i < fileList.length; i++) {

			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				site + "\\event"+File.separator+keyID+File.separator + fileList[i]
			);
			DocumentDB.add(userBean,"marketing",keyID,"/Upload/Marketing/event/"+keyID,fileList[i]);

		}
	}
}
%>