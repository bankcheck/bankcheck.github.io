<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.hibernate.*"%>
<%@ page import="org.apache.poi.ss.usermodel.*"%>
<%@ page import="org.apache.poi.ss.util.*"%>
<%
UserBean userBean = new UserBean(request);
String userCat = request.getParameter("userCat");

// constant
String documentID = "405";	//String documentID = "400";
String sheetName = "Comments";

if ("all".equals(userCat)) {
	userCat = "all";
} else if ("phy1".equals(userCat)) {
	userCat = "phy1";
} else if ("phy2".equals(userCat)) {
	userCat = "phy2";
} else {
	userCat = null;
}

// sheet column
Map<String, Integer> qidAidToColIndex = new HashMap<String, Integer>();
qidAidToColIndex.put("7-3", 1);
qidAidToColIndex.put("8-10", 2);
qidAidToColIndex.put("9-8", 3);
qidAidToColIndex.put("10-7", 4);
qidAidToColIndex.put("14-6", 5);

int startRow = 0;

// get document url
ReportableListObject rlo = DocumentDB.getReportableListObject(documentID);
String fileDescription = null;
String location = null;
String filePath = null;
boolean isWebFolder = false;
String fileLastModified = null;
String formattedFileLastModified = "";
if (rlo != null) {
	fileDescription = rlo.getValue(1);
	location = rlo.getValue(2);
	isWebFolder = ConstantsVariable.YES_VALUE.equals(rlo.getValue(3));
	fileLastModified = rlo.getValue(7);
	if (fileLastModified != null && !fileLastModified.isEmpty()) {
		try {
			formattedFileLastModified = DateTimeUtil.formatDateTime(new Date(Long.parseLong(fileLastModified)));
		} catch (Exception e) {
		}
	}
	
	if (isWebFolder) {
		filePath = ConstantsServerSide.DOCUMENT_FOLDER + File.separator + location;
	} else {
		filePath = location;
	}
}

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

String eventID = "-1";
String elearningID = "-1";
String evaluationID = "6";
List result = null;

try {
	result = EvaluationDB.getAllStaffResultAnswer(eventID, elearningID, evaluationID, userCat, null); 
} catch (Exception ex) {
	errorMessage = "Result retreival error.";
}

if (filePath == null || filePath.isEmpty()) {
	errorMessage = "No document found.";
} if (result == null) {
	errorMessage = "No result found.";
} else {
		File file = new File(filePath);
		Workbook wb = SpreadSheetUtil.getWorkbook(filePath);
		Sheet sheet = wb.getSheet(sheetName);
		//Sheet sheet = SpreadSheetUtil.getSheet(filePath, sheetName);
		if (sheet != null) {
			/*
SA.EE_ENROLL_ID, SA.EE_EVALUATION_QID, SA.EE_EVALUATION_AID, A.EE_ANSWER, SA.EE_USER_TYPE, SA.EE_USER_ID, SA.EE_EVALUATION_SITE, SA.EE_EVALUATION_ANSWER_DESC, A.EE_ISFREETEXT ");
			*/
			int curRowIndex = startRow;
			String curEnrollID = null;
			for (int i = 0; i < result.size(); i++) {
				ReportableListObject row = (ReportableListObject) result.get(i);
				String enrollID = row.getValue(0);
				String qID = row.getValue(1);
				String aID = row.getValue(2);
				String aText = row.getValue(3);
				String answerDesc = row.getValue(7);
				String isFreeText = row.getValue(8);
				
				Integer qIDi = null;
				try {
					qIDi = Integer.parseInt(qID);
				} catch (Exception ex) {
					
				}
				if (!enrollID.equals(curEnrollID)) {
					// new record
					curRowIndex++;
					curEnrollID = enrollID;
				}
				
				String answer = answerDesc;
				Integer colIdx = qidAidToColIndex.get(qID + "-" + aID);
				if (colIdx == null)
					colIdx = qidAidToColIndex.get(qID + "-*");
				if (colIdx == null)
					colIdx = qidAidToColIndex.get(qID + "-*-" + answerDesc);
				if (colIdx != null && colIdx >= 0) {
					//System.out.println("DEBUG: setCell("+curRowIndex+","+colIdx+") = " + answer);
					sheet.getRow(curRowIndex).getCell(colIdx).setCellValue(answer);
				}
			}
			
			// Write the output to a file
			/*
		    FileOutputStream fout = new FileOutputStream(application.getRealPath("/") + "Survey report.xlsx");
		    wb.write(fout);
		    fout.close();
		    */
		    
		    // Write to out
		    response.setContentType("application/vnd.ms-excel");
		    response.setHeader("Content-Disposition", "attachment; filename=HKAH Alignment Assessement Survey Report Supp (User Type "+userCat+").xls");
		    OutputStream ouputStream = response.getOutputStream();
		    wb.write(ouputStream);
		    ouputStream.close();
		} else {
			errorMessage = "Cannot read spreadsheet.";
		}
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
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>