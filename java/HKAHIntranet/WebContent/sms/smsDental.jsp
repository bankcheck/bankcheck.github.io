<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.hibernate.*"%>
<%@ page import="org.apache.poi.ss.usermodel.*"%>
<%@ page import="org.apache.poi.ss.util.*"%>
<%@ page import="org.apache.poi.poifs.filesystem.*"%>
<%@ page import="org.apache.poi.xssf.usermodel.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>

<%@ page import="org.apache.poi.hssf.usermodel.HSSFDateUtil"%>

<%@ page import="org.apache.poi.POIXMLDocument"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.openxml4j.exceptions.InvalidFormatException"%>
<%@ page import="org.apache.poi.openxml4j.opc.OPCPackage"%>
<%@ page import="com.hkah.util.sms.UtilSMS"%>
<%@ page import="org.apache.poi.hssf.record.crypto.Biff8EncryptionKey"%>
<%!
public class PatientValue{	
	String title;
	String firstName;
	String lastName;
	String mobilePhone;
	String nextApptProvider;
	String nextApptDate;
	String nextApptTime;
	
	public PatientValue(String title, String firstName, String lastName, String mobilePhone, 
			String nextApptProvider, String nextApptDate, String nextApptTime){
		this.title = title;
		this.firstName = firstName;
		this.lastName = lastName;
		this.mobilePhone = mobilePhone;
		this.nextApptProvider = nextApptProvider;
		this.nextApptDate = nextApptDate;
		this.nextApptTime = nextApptTime;
	}
}


List<String> textFiles(String directory) {
	  List<String> textFiles = new ArrayList<String>();
	  File dir = new File(directory);
	  for (File file : dir.listFiles()) {
	    if (file.getName().endsWith((".xls"))) {
	      textFiles.add(file.getName());
	    }
	  }
	  return textFiles;
	}


private void copyAndDeleteFile(String orgDir, String copyDir){
	InputStream inStream = null;
	OutputStream outStream = null;
 
    	try{
 
    	    File afile =new File(orgDir);
    	    File bfile =new File(copyDir);
 
    	    inStream = new FileInputStream(afile);
    	    outStream = new FileOutputStream(bfile);
 
    	    byte[] buffer = new byte[1024];
 
    	    int length;
    	    //copy the file content in bytes 
    	    while ((length = inStream.read(buffer)) > 0){
 
    	    	outStream.write(buffer, 0, length);
 
    	    }
 
    	    inStream.close();
    	    outStream.close();
 
    	    //delete the original file
    	    afile.delete();
 
    	}catch(IOException e){
    	    e.printStackTrace();
    	}
}

private static String getNextSMSID() {
	String smsID = null;

	// get next schedule id from db
	ArrayList result = UtilDBWeb.getReportableList(
			"SELECT MAX(DE_SMS_ID) + 1 FROM DE_SMS_INFO");
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		smsID = reportableListObject.getValue(0);

		// set 1 for initial
		if (smsID == null || smsID.length() == 0) return "1";
	}
	return smsID;
}

private static boolean insertSMSRecord(String keyID, String title, String firstName, String lastName, 
		String mobilePhone, String nextApptProvider, String nextApptDate, String nextApptTime, UserBean userBean) {
	return UtilDBWeb.updateQueue(
			"INSERT INTO DE_SMS_INFO (DE_SMS_ID, DE_TITLE, DE_FIRSTNAME, DE_LASTNAME, DE_MOBILE, DE_NEXTAPPTPROVIDER, DE_NEXTAPPTDATE, DE_NEXTAPPTTIME, DE_CREATED_USER) " +
			"VALUES ('" + keyID + "' , '" + title + "' ,  '"+ firstName  + "' , '" + lastName  + "' , '" + mobilePhone + "' , '" + nextApptProvider + "' , '" + nextApptDate + "' , '" + nextApptTime + "' , '" + userBean.getLoginID() + " ')");			 
}
%>
<%
UserBean userBean = new UserBean(request);
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

//String dir = ConstantsServerSide.DOCUMENT_FOLDER + File.separator + "dental" + File.separator;
//String copyDir = ConstantsServerSide.DOCUMENT_FOLDER + File.separator + "dentalCopy" + File.separator;
String dir = "";
String copyDir = "";

ArrayList smsFile = DocumentDB.get("621");
if(smsFile.size() != 0 ){	
	ReportableListObject smsFileDetails = (ReportableListObject)smsFile.get(0);
	dir = smsFileDetails.getValue(2);
}
ArrayList smsFileSent = DocumentDB.get("622");
if(smsFileSent.size() != 0 ){	
	ReportableListObject smsFileSentDetails = (ReportableListObject)smsFileSent.get(0);
	copyDir = smsFileSentDetails.getValue(2);
}



List<String> files = textFiles(dir);

for(String s : files){
	String filePath = dir  + s;
	FileInputStream filesystem = new FileInputStream(filePath); 
	HSSFWorkbook book = new HSSFWorkbook(filesystem);

	if (filePath == null || filePath.isEmpty()) {
		errorMessage = "No document found.";
	} else {			
		Sheet sheet =  book.getSheetAt(0);	
		Iterator<Row> rowIterator = sheet.iterator();
		
		DecimalFormat df = new DecimalFormat("###");
		
		ArrayList<PatientValue> patientValueList = new ArrayList<PatientValue>();
		while(rowIterator.hasNext()) {
			Row row2 = rowIterator.next();		
			Iterator<Cell> cellIterator = row2.cellIterator();
			
			String value = "";		
			int i = 0;
			ArrayList<String> tempValue = new ArrayList<String>();
			
			boolean isAllEmpty = true;
			while(cellIterator.hasNext()) {		
				
				Cell cell = cellIterator.next();	
				
				switch(cell.getCellType()) {
					case Cell.CELL_TYPE_BOOLEAN:					
						value =  Boolean.toString(cell.getBooleanCellValue());
						break;
					case Cell.CELL_TYPE_NUMERIC:
						if (HSSFDateUtil.isCellDateFormatted(cell)) {
							DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
							value = dateFormat.format(cell.getDateCellValue());
						} else {
							value = df.format(cell.getNumericCellValue());
						}
						break;
					case Cell.CELL_TYPE_STRING:
						value = cell.getStringCellValue();
						break;
					case Cell.CELL_TYPE_BLANK:
						value = cell.getStringCellValue();
					
						break;				
				}			
							
				tempValue.add(value);				
				if(value!=null && value.length() > 0){
					isAllEmpty = false;
				}
				i++;
			}
			
			if(isAllEmpty == false){
				if("title".equals(tempValue.get(0).toLowerCase())){
					
				} else {
					patientValueList.add(new PatientValue(tempValue.get(0), tempValue.get(1), tempValue.get(2), tempValue.get(3).replaceAll("\\s+",""),
						tempValue.get(4), tempValue.get(5), tempValue.get(6)));
				}
			}
		}
		
		for(PatientValue p : patientValueList){
			String content = p.title + " " + p.firstName + " " + p.lastName + ": HK Adventist Hospital Dental 牙科 appointment with " + 
					p.nextApptProvider + " on " + p.nextApptDate + " at " + p.nextApptTime + ". For enquiry, please call 請致電  28350500.";

			String keyID = getNextSMSID();
			
			insertSMSRecord(keyID,  p.title, p.firstName, p.lastName, 
					p.mobilePhone, p.nextApptProvider, p.nextApptDate, p.nextApptTime, userBean);	

			UtilSMS.sendSMS(null, new String[] { p.mobilePhone},
					content,
		  			UtilSMS.SMS_DENTAL, keyID, null, "dental");
			
		}
	}
	
	filesystem.close();
	copyAndDeleteFile(dir + s, copyDir + s);
}


	
if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}



%><!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.dental.sms.send" />
</jsp:include>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>