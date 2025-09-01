<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.web.db.model.*"%>
<%@ page import="com.hkah.web.db.model.FsCombineFiles" %>
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
<%@ page import="org.apache.pdfbox.multipdf.PDFMergerUtility" %>
<%!
private void archiveFilesZip(HttpServletResponse response, String[] ids, String patno, String categoryTitle) {
	byte[] buffer = new byte[1024];
	try{
		ZipOutputStream zos = new ZipOutputStream(response.getOutputStream());
		ArrayList<ReportableListObject> list = ForwardScanningDB.getFilePathsByIds(ids);
		if (list != null) {
			System.out.println(new Date() + " [Forward Scanning] Merge image, size: " + list.size());
			long totalLen = 0l;
			Map<String, Integer> fullPaths = new HashMap<String, Integer>();
			PDFMergerUtility ut = new PDFMergerUtility();
			String tempPath = "C:/WebConfig/temp/"+getArchiveFileName(patno, categoryTitle)+".pdf";
			ut.setDestinationFileName(tempPath);
			
			for (int i = 0; i < list.size(); i++) {
				ReportableListObject row = list.get(i);
				String filePath = row.getFields0();
				File file = new File(filePath);
				ut.addSource(file);
			}
			
			try{					
				ut.mergeDocuments();
			} catch (Exception e){
			}
			
			String fullPath = FilenameUtils.getName(tempPath);
			ZipEntry ze= new ZipEntry(fullPath);
			try {
				File file = new File(tempPath);
				ze.setTime(file.lastModified());
			} catch (Exception e) {
				System.out.println("[Forward Scanning] cannot access file:" + tempPath + ", err:" + e.getMessage());
			}
			
			zos.putNextEntry(ze);
			
			try {
				FileInputStream in = new FileInputStream(tempPath);

				int len;
		    	while ((len = in.read(buffer)) > 0) {
		    		zos.write(buffer, 0, len);
		    		totalLen += len;
		    	}
		    	in.close();
			} catch (Exception fex) {
				System.out.println("[intranet] file_list Cannot access file: " + tempPath + ", ex: " + fex.getMessage());
			}
		}
    	zos.closeEntry();
    	zos.close();
   	} catch (Exception ex) {
    	   ex.printStackTrace();
    }
}

private String getArchiveFileName(String patno, String categoryTitle) {
	String ret = null;
	SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMdd");
	String tsStr = tsFormat.format(new Date());
	ret = "HKAH-" + (ConstantsServerSide.isHKAH() ? "SR" : ConstantsServerSide.isTWAH() ? "TW" : "Other") + " Medical Record - " + (categoryTitle == null || categoryTitle.isEmpty() ? "" : categoryTitle) + (patno == null || patno.isEmpty() ? "" : (" (Patient No. " + patno + ")")) + " - " + tsStr;
	return ret;
}


%>
<%
UserBean userBean = new UserBean(request);
String mode = ParserUtil.getParameter(request, "mode");
String patno = ParserUtil.getParameter(request, "patno");
String command = ParserUtil.getParameter(request, "command"); 
String keyId = ParserUtil.getParameter(request, "keyId"); 
String categoryTitle = ParserUtil.getParameter(request, "categoryTitle");
String[] fileIndexIds = keyId.split(",");

boolean downloadImagesAction = false;
if ("downloadImages".equals(command)) {
	downloadImagesAction = true;
}


if (downloadImagesAction) {
	downloadImagesAction = false;
	command = null;
	
	response.setContentType("application/zip, application/octet-stream");
	response.setHeader("Content-disposition", "attachment; filename=\"" + getArchiveFileName(patno,categoryTitle) + ".zip\"");
	archiveFilesZip(response, fileIndexIds, patno, categoryTitle);
	
	return;
}
%>
