<%@ page language="java"
%><%@ page import="java.io.*"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.util.upload.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*";
%><%
UserBean userBean = new UserBean(request);

String rootFolder = "c:\\ceFiles";
String documentID ="";
String locationPath ="/data";
//String documentID = request.getParameter("documentID");
String folderName = request.getParameter("folderName");
if (folderName==null){
// folderName=request.getParameter("staffID");
folderName="3738";
}

String message = "";
String errorMessage = "";
	

// Check that we have a file upload request
if (HttpFileUpload.isMultipartContent(request)){
System.err.println("file upload is called");
	Vector uploadMessage = HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.UPLOAD_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	if (uploadMessage.size() > 0) {
		for (int i=0; i<uploadMessage.size(); i++) {
			message += uploadMessage.get(i) + "<br>";
		}
	}
	//locationPath = (String) request.getAttribute("locationPath");
	//	documentID = (String) request.getAttribute("documentID");
	//	folderName = (String) request.getAttribute("folderName");
	//	if (folderName==null){
	 //folderName=staffID;

}

String[] fileList = (String[]) request.getAttribute("filelist");

/*if (documentID != null) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT CO_LOCATION FROM CO_DOCUMENT WHERE CO_DOCUMENT_ID = ?");

	ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { documentID });
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		locationPath = row.getValue(0);
	}
} else 
*/

if (fileList!=null){
try {

File dir=null;

for (int i=0; i< fileList.length; i++){
	//move files to the specific location.  
	// File (or directory) to be moved
  	File file = new File(ConstantsServerSide.UPLOAD_FOLDER+ File.separator +fileList[i]);
  	System.err.println("fileName:"+file.toString());	
  
    if (folderName != null) {   	
   		// Create a destination directory 
   		File root=new File(rootFolder);
   		if(!root.exists()) root.mkdir();
   		 
  		dir = new File(rootFolder+ File.separator + folderName);
        System.err.println("destination directory :"+dir.toString());
		if (!dir.exists()){
    		dir.mkdir();
		}
    }
    
	// Move file to new directory
	File destFile=new File(dir, file.getName());
	boolean success = file.renameTo(destFile);
	if (success) {
		System.err.println(file.toString()+" was successfully moved to "+destFile.toString());	

		documentID=DocumentDB.add(userBean, "CE uploadFile", destFile.toString(), "pdf");
		if (documentID!=null){
			System.err.println("DocumentID :"+documentID);
				
		}else{
			System.err.println("Fail to add document file.");	
		}
			
	}else{
		System.err.println(file.toString()+" was not successfully moved .");	
	}	
	// File was not successfully moved
  }

} catch( Exception e){
	System.err.println("exception: "+e.toString());
}

}

%>

<form name="UploadForm" enctype="multipart/form-data" action="downloader.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.uploadFile" /></td>
		<td class="infoData" width="70%"><input type="file" name="file1" size="50" class="multi" maxlength="5"></td>
	</tr>
	<tr class="smallText">
		<td align="center" colspan="2"><button type="submit"><bean:message key="prompt.uploadFile" /></button></td>
	</tr>

</table>
<input type="hidden" name="toPDF" value="N">
<input type="hidden" name="documentID" value="<%=documentID %>">
</form>
<script language="javascript">
	function createDirectory() {
		if (document.DirectoryForm.folderName.value == "") {
			alert("<bean:message key="error.folderName.required" />.");
		} else {
			document.DirectoryForm.submit();
		}
	}
</script>

