<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>;
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%

HashMap statusDesc = new HashMap();
statusDesc.put("I", MessageResources.getMessage(session, "label.open"));
statusDesc.put("O", MessageResources.getMessage(session, "label.waiting.for.approve"));
statusDesc.put("M", MessageResources.getMessage(session, "label.waiting.for.confirm"));
statusDesc.put("A", MessageResources.getMessage(session, "label.waiting.for.confirm"));
statusDesc.put("H", MessageResources.getMessage(session, "label.confirmed"));
statusDesc.put("R", MessageResources.getMessage(session, "label.rejected"));
statusDesc.put("C", MessageResources.getMessage(session, "label.cancelled"));

UserBean userBean = new UserBean(request);




String loginID = userBean.getLoginID();
String loginStaffID = userBean.getStaffID();

String command = request.getParameter("command");
if (command==null) command="create";
String step = request.getParameter("step");
if(step==null || step.equals("undefined")){
   step="0";
}


String ceID = request.getParameter("ceID");
String staffID = request.getParameter("staffID");
if (staffID == null) {
	staffID = loginStaffID;
}
String staffName = request.getParameter("staffName");
if (staffName == null) {
	staffName = userBean.getUserName();
}

String deptDesc = request.getParameter("deptDesc");
String courseID = request.getParameter("courseID");
String deptName = request.getParameter("deptName");
String courseName = request.getParameter("courseName");
String uploaded="";



String courseSponsor = request.getParameter("courseSponsor");
String attendanceLocation=request.getParameter("attendanceLocation");
String fromDate = request.getParameter("fromDate_dd") + "/" +
	request.getParameter("fromDate_mm") + "/" +
	request.getParameter("fromDate_yy");
String toDate = request.getParameter("toDate_dd") + "/" +
	request.getParameter("toDate_mm") + "/" +
	request.getParameter("toDate_yy");

String attendDate=request.getParameter("attendDate");
String appliedHours = request.getParameter("appliedHours");
String fee=request.getParameter("fee");
String benefitEmployee = request.getParameter("benefitEmployee");
String benefitDepartment = request.getParameter("benefitDepartment");
String ceStatus = request.getParameter("ceStatus");
String approve_MGRstaffID = request.getParameter("approve_MGRstaffID");
String approve_MGRstaffName = null;
String approve_HRstaffID = request.getParameter("approve_HRstaffID");
String approve_HRstaffName = null;
String approve_ADMINstaffID = request.getParameter("approve_ADMINstaffID");
String approve_ADMINstaffName = null;


String showHeader = request.getParameter("show_header");


// for HR use
String approvedHours=request.getParameter("approvedHours");
if(approvedHours==null) approvedHours="0";
String actionNum=request.getParameter("actionNum");
if(actionNum==null) actionNum="";
String approvedExpense=request.getParameter("approvedExpense");
if(approvedExpense==null) approvedExpense="0";
String currentYear = (new SimpleDateFormat("yyyy")).format(new java.util.Date());



// upload ce files
String rootFolder = "c:\\ceFiles";
String documentID =request.getParameter("documentID");
String folderName = loginStaffID;

System.err.println("----documentID["+documentID);
//System.err.println("foldername:"+folderName);
// Check that we have a file upload request
if (HttpFileUpload.isMultipartContent(request)){
	HttpFileUpload.toUploadFolder(
			request,
			ConstantsServerSide.DOCUMENT_FOLDER,
			ConstantsServerSide.TEMP_FOLDER,
			ConstantsServerSide.UPLOAD_FOLDER
		);

	command = ParserUtil.getParameter(request, "command");
	step = ParserUtil.getParameter(request, "step");
	command="create";
	step="0";
	documentID =ParserUtil.getParameter(request, "documentID");

//	command = request.getParameter("command");
//	step = request.getParameter("step");

//	documentID =request.getParameter("documentID");
/*	System.err.println(" &&&&&&&&&&&&&&&command["+command+"]step["+step);

		Vector uploadMessage = HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.UPLOAD_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	   );
*/
String[] fileList = (String[]) request.getParameterValues("filelist");
if (fileList!=null){
	try {
		File dir = null;

		for (int i=0; i< fileList.length; i++){
			// get source files and path
	  		File file = new File(ConstantsServerSide.UPLOAD_FOLDER+ File.separator +fileList[i]);
	  		System.err.println("fileName:"+file.toString());

	    	if (folderName != null) {
	    		File root=new File(rootFolder);
	    		if (!root.exists()){
	    			root.mkdir();
	    	}
	   		// Create a destination directory
	  		dir = new File(rootFolder+ File.separator + folderName);
	        System.err.println("destination directory :"+dir.toString());
			if (!dir.exists()){
	    			dir.mkdir();
				}
	    	}

			// Move file to new directory
			File destFile=new File(dir, file.getName());
			System.err.println("destination directory :"+dir.toString()+ File.separator +file.getName());
			boolean success = file.renameTo(destFile);
			if (success) {
				System.err.println(file.toString()+" was successfully moved to "+destFile.toString());
				documentID=DocumentDB.add(userBean, "CE uploadFile", destFile.toString(), "pdf");
				if (documentID!=null){
					System.err.println("DocumentID :"+documentID);
					if(documentID!=null){
						uploaded="Yes";
					}
				}else{
					System.err.println("Fail to add document file.");
				}
			}else{
				System.err.println(file.toString()+" was not successfully moved .");
			}
	  	}

	} catch( Exception e){
			System.err.println("exception: "+e.toString());
	}
}else{
	 System.err.println("fileList is null!");
}

}

boolean createAction = false;
boolean updateAction = false;
boolean approveAction = false;
boolean rejectAction = false;
boolean cancelAction = false;
boolean confirmAction = false;
boolean closeAction = false;
boolean show_header = !"N".equals(showHeader);

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("cancel".equals(command)) {
	cancelAction = true;
} else if ("approve".equals(command)) {
	approveAction = true;
} else if ("reject".equals(command)) {
	rejectAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
}else if ("confirm".equals(command)) {
	confirmAction = true;
}



boolean counter=false;
try {

	if ("1".equals(step)) {
    	if (createAction && counter ) {
 // 	if (createAction && StaffDB.atLeastOneYearAndFullTime(staffID,fromDate) ) {

			errorMessage ="Continuing Education create fail. Because you haven't worked for at least 1 year." ;
			System.err.println(errorMessage);
			step = "0";

		} else {


			long dateDiff = 0;
			if (createAction) {
				Date fromDateDate = DateTimeUtil.parseDate(fromDate);
				Date toDateDate = DateTimeUtil.parseDate(toDate);
//				dateDiff = (toDateDate.getTime() - fromDateDate.getTime()) / (1000 * 60 * 60);
//				if (dateDiff > 7) {
//					dateDiff = dateDiff / 24 * 7;
//				}
//				appliedHours = String.valueOf((toDateDate.getTime() - fromDateDate.getTime()) / (1000 * 60 * 60 * 24) + 1);
			}
			if (createAction && dateDiff < 0) {
				errorMessage = MessageResources.getMessage(session, "error.dateRate.required");
			} else if (createAction) {
				if (CE.isExist(staffID, fromDate, toDate)) {
					errorMessage = "Continuing Education create fail due to duplicate date range.";

					// set default value
					deptDesc = userBean.getDeptDesc();
					ceStatus = "I";
				} else {
					//move files to the specific location.  /ceData/staffID/time as file Name


					// File (or directory) to be moved
    				//File file = new File("filename");
      				// Destination directory
    			//	File dir = new File("/ceData/"+staffID);

    				// Move file to new directory
    				//boolean success = file.renameTo(new File(dir, file.getName()));
    				//if (!success) {
        				// File was not successfully moved
    			//	}

					ceID = CE.add(userBean, staffID, courseID, courseSponsor, attendanceLocation,
							fromDate, toDate, appliedHours, fee, benefitEmployee, benefitDepartment, documentID, approve_MGRstaffID);
					if (ceID != null) {
						createAction = false;
						step = "0";
						message = "Continuing Education created.";

						// insert todo list for manager
						StringBuffer sqlStr = new StringBuffer();
						sqlStr.append("INSERT INTO CO_TODO (CO_SITE_CODE, CO_TODO_ID, CO_TASK_ID,");
						sqlStr.append(" CO_JOB_ID, CO_USERNAME, CO_CREATED_USER, CO_MODIFIED_USER) ");
						sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', (SELECT COUNT(1) + 1 FROM CO_TODO),  ?, ");
//						sqlStr.append(" ?, ?, ?, ?)");
						sqlStr.append(" ?,(SELECT CO_USERNAME FROM CO_USERS WHERE CO_STAFF_ID= ?), ?, ?)");
						if( UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { "4", ceID, approve_MGRstaffID, loginID, loginID } )){
							System.err.println("add TODO LIST for Manager is ok");
						} else {
							System.err.println("add todo list for Manager is failed");
						}
					} else {
						errorMessage = "Continuing Education create fail.";
						// set default value
						deptDesc = userBean.getDeptDesc();
						ceStatus = "I";
					}

				}
			} else if (approveAction) {
				if(ceStatus.equals("O")){
					if (CE.approve_manager(userBean, ceID,approve_ADMINstaffID)) {
						approveAction = false;
						step = "0";
						message = "Continuing Education approved by Manager.";

						// insert todo list for Administrator
						StringBuffer sqlStr = new StringBuffer();
						sqlStr.append("INSERT INTO CO_TODO (CO_SITE_CODE, CO_TODO_ID, CO_TASK_ID,");
						sqlStr.append(" CO_JOB_ID, CO_USERNAME, CO_CREATED_USER, CO_MODIFIED_USER) ");
						sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', (SELECT COUNT(1) + 1 FROM CO_TODO),  ?, ");
						sqlStr.append(" ?,(SELECT CO_USERNAME FROM CO_USERS WHERE CO_STAFF_ID= ?), ?, ?)");
						if( UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { "4", ceID, approve_ADMINstaffID, loginID, loginID } )){
							System.err.println("add TODO LIST for Administrator is ok");
						} else {
							System.err.println("add todo list for Administrator is failed");
						}


					} else {
						errorMessage = "Continuing Education approval fail.";
					}
				}else{
					if (CE.approve_admin(userBean, ceID)) {
						approveAction = false;
						step = "0";
						message = "Continuing Education approved by Administrator.";

						// insert todo list for HR manager
						StringBuffer sqlStr = new StringBuffer();
						sqlStr.append("INSERT INTO CO_TODO (CO_SITE_CODE, CO_TODO_ID, CO_TASK_ID,");
						sqlStr.append(" CO_JOB_ID, CO_USERNAME, CO_CREATED_USER, CO_MODIFIED_USER) ");
						sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', (SELECT COUNT(1) + 1 FROM CO_TODO),  ?, ");
						sqlStr.append(" ?,(SELECT CO_USERNAME FROM CO_USERS WHERE CO_STAFF_ID= ?), ?, ?)");
						if( UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { "4", ceID, "3043", loginID, loginID } )){
							System.err.println("add TODO LIST for HR Manager is ok");
						} else {
							System.err.println("add todo list for HR Manager is failed");
						}

				String email=UserDB.getUserEmail(ConstantsServerSide.SITE_CODE,approve_ADMINstaffID);
						// send email to remind administrator
						UtilMail.sendMail(
						"kwongsing.kam@hkah.org.hk",
						//email,
						"kwongsing.kam@hkah.org.hk",   // administrator's email
						"Waiting for approval of Continuing Education",
						"Intranet portal : http://www-server/intranet/  or https://mail.hkah.org.hk/intranet ");

					} else {
						errorMessage = "Continuing Education approval fail.";
					}
				}
			} else if (confirmAction) {
				if (CE.approve_hr(userBean, ceID)) {
					confirmAction = false;
						step = "0";
					 message = "Continuing Education confirmed by HR .";
					System.err.println("approved action:["+StaffDB.getCategory(staffID)+"]["+deptName+"]["+
					approvedHours+"]["+actionNum+"]["+approvedExpense+"]["+attendDate+"]["+
				courseName+"]");
					if(CE.addCEApproved(userBean,ConstantsServerSide.SITE_CODE,StaffDB.getCategory(staffID),
						deptName,staffID,approvedExpense,
			        	approvedHours,actionNum,attendDate,courseName,"")){
		              	System.err.println("Add a CE approved record is ok.");
		             	 message = "Continuing Education confirmed by HR and CE approval record is added.";


					} else {
						errorMessage = "and Add a CE approved record is failed.";
						System.err.println("and Add a CE approved record is failed.");
					}
				} else {
					errorMessage = "Continuing Education confirm action fail.";
				}

			} else if (rejectAction) {
				if (CE.reject(userBean, ceID)) {
					rejectAction = false;
					step = "0";
					message = "Continuing Education rejected.";
				} else {
					errorMessage = "Continuing Education reject fail.";
				}
			} else if (cancelAction) {
				if (CE.cancel(userBean, ceID)) {
					closeAction = true;
					step = "0";
					message = "Continuing Education cancelled.";
				} else {
					errorMessage = "Continuing Education cancel fail.";
				}
			}
		}
	} else if (createAction) {
		ceID = "";
		courseID = "";
		deptDesc = userBean.getDeptDesc();
		courseSponsor="";
		fromDate = (new SimpleDateFormat("dd/MM/yyyy")).format(new java.util.Date());
		toDate = fromDate;
		appliedHours = "0";
		fee="";
		attendanceLocation="";
		benefitEmployee = "";
		benefitDepartment="";
		approve_MGRstaffID = userBean.getDeptCode();
		ceStatus = "I";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (ceID != null && ceID.length() > 0) {
			ArrayList record = CE.get(ceID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				staffID = row.getValue(0);
				staffName = row.getValue(1);
				deptDesc = row.getValue(2);
				deptName=deptDesc;
				courseID = row.getValue(3);
				courseName=courseID;
				courseSponsor = row.getValue(4);
				attendanceLocation= row.getValue(5);
				fromDate = row.getValue(6);
				toDate = row.getValue(7);
				appliedHours = row.getValue(8);
				fee = row.getValue(9);
				benefitEmployee = row.getValue(10);
				benefitDepartment=row.getValue(11);
				ceStatus = row.getValue(12);
				approve_MGRstaffID = row.getValue(13);
				approve_MGRstaffName = row.getValue(14);
				approve_ADMINstaffID = row.getValue(15);
				approve_ADMINstaffName = row.getValue(16);
				approve_HRstaffID = row.getValue(17);
				approve_HRstaffName = row.getValue(18);
				attendDate=fromDate+"-"+toDate;
//				appliedDateInt = Integer.parseInt(appliedDate);
//				appliedHourInt = appliedDateInt % 7;
//				appliedDateInt = (appliedDateInt - appliedHourInt) / 7;
			} else {
			//	closeAction = true;
				System.err.println(" close  action 1");
			}
		} else {
			//closeAction = true;
			System.err.println(" close  action 2");
		}
	}
} catch (Exception e) {
	e.printStackTrace();
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
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<%if (show_header) { %><jsp:include page="../common/banner2.jsp"/><%} %>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (approveAction) {
		commandType = "approve";
	} else if (rejectAction) {
		commandType = "reject";
	} else if (cancelAction) {
		commandType = "cancel";
	}else if (confirmAction) {
		commandType = "confirm";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.ce." + commandType;

	if (show_header) {
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="education" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<%	} else { %>
<table width="100%" border="0">
	<tr><td>&nbsp;</td></tr>
	<tr class="smallText">
		<td class="portletCaption"><bean:message key="<%=title %>" /></td>
	</tr>
</table>
<%	} %>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>

<form name="form1"   action="ce.jsp" method="post">
<br />
<table cellpadding="0" cellspacing="0"
	class="tablesorter" border="0">
	<thead>
	<tr class="smallText">
		<th class="{sorter: false}"> CE Current Balance </th>
		<th class="{sorter: false}"> CE Unclaimed Record </th>
		<th class="{sorter: false}">&nbsp;</th>
	</tr>
	</thead>
	<tbody>
<%
	boolean success = true;
	String [] totalCE=CE.getCETotal(staffID,currentYear);
	String[] approved=CE.getCEApproved(staffID,currentYear);

	String unUsedCEMoney=CE.getCEUnUsedMoney(staffID);
	String unUsedCEHours=CE.getCEUnUsedHours(staffID);
	long leftAmount=0;   //available current year Amount and Hours
	long leftHours=0;
	long approveAmount=0;
	long approveHours=0;
	//double aDouble = Double.parseDouble(aString);
	approveAmount=Integer.parseInt(approved[0]);
	approveHours=Integer.parseInt(approved[1]);

	//String approveAmount=Double.parseDouble(approved[0]);

	//System.err.println(" $, T :"+totalCE[0]+" ---"+totalCE[1]);
	// check total CE and balance
	if (totalCE == null) {
		success=false;
	}else{
		leftAmount=Integer.parseInt(totalCE[0])-approveAmount;
		leftHours=Integer.parseInt(totalCE[1])-approveHours;
	}
	if(success){
	%>

	<tr>
		<td align="center">$  <%=leftAmount %> ( <%=leftHours %> hrs ) </td>
		<td align="center">$  <%=unUsedCEMoney %> ( <%=unUsedCEHours %> hrs ) </td>
		<td align="center"></td>
	</tr>
<%
			success = true;
		}

	if (!success) {
%>
	<tr class="smallText">
		<td align="center" colspan="8"> Not record found in Continuing Education List <%=currentYear %>
			</td>
	</tr>
<%
	}
%>
</table>
<br />
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="70%"><%=staffID %> (<%=staffName %>)</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%">Department</td>
		<td class="infoData" width="70%"><%=deptDesc %></td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%">Name of Course</td>
	<%		if (createAction) {%>
		<td class="infoData" width="70%"><input type="textfield" name="courseID" value="<%=courseID %>" maxlength="200" size="50"></td>
	<%		} else {%>
		<td class="infoData" width="70%"><%=courseID %></td>
	<%		} %>
	</tr>
<%	if (createAction || updateAction) {%>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.uploadFile" /></td>
		<td class="infoData" width="70%"><input type="file" name="file1" size="50" class="multi" maxlength="5"></td>
	</tr>
	<tr class="smallText">
		<td align="center" colspan="2"><button type="submit"><bean:message key="prompt.uploadFile" /></button></td>
	</tr>


<% } %>

<tr class="smallText">
		<td class="infoLabel" width="30%">Uploaded File:</td>
	<%		if (createAction) {%>
		<td class="infoData" width="70%"><input type="textfield" name="uploadedFile" value="<%=uploaded %>" maxlength="5" size="5"></td>
	<%		} %>
	</tr>


	<tr class="smallText">
		<td class="infoLabel" width="30%">Sponsor / organzier of Course</td>
	<%		if (createAction) {%>
		<td class="infoData" width="70%"><input type="textfield" name="courseSponsor" value="<%=courseSponsor %>" maxlength="20" size="70"></td>
	<%		} else {%>
		<td class="infoData" width="70%"><%=courseSponsor %></td>
	<%		} %>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%">Location of Attendance</td>
	<%		if (createAction) {%>
		<td class="infoData" width="70%"><input type="textfield" name="attendanceLocation" value="<%=attendanceLocation %>" maxlength="20" size="50"></td>
	<%		} else {%>
		<td class="infoData" width="70%"><%=attendanceLocation %></td>
	<%		} %>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.from" /></td>
		<td class="infoData" width="70%">
<%		if (createAction) {%>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="fromDate" />
	<jsp:param name="date" value="<%=fromDate %>" />
	<jsp:param name="showTime" value="N" />
</jsp:include>
<%		} else {%>
		<%=fromDate %>
<%		} %>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.to" /></td>
		<td class="infoData" width="70%">
<%		if (createAction) {%>
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="toDate" />
	<jsp:param name="date" value="<%=toDate %>" />
	<jsp:param name="showTime" value="N" />
</jsp:include>
<%		} else {%>
		<%=toDate %>
<%		} %>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%">hours requested</td>
	<%		if (createAction) {%>
		<td class="infoData" width="70%"><input type="textfield" name="appliedHours" value="<%=appliedHours %>" maxlength="5" size="10"></td>
	<%		} else {%>
		<td class="infoData" width="70%"><%=appliedHours %></td>
	<%		} %>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%">Course Fee / tutition</td>
	<%		if (createAction) {%>
		<td class="infoData" width="70%"><input type="textfield" name="fee" value="<%=fee %>" maxlength="50" size="50"></td>
	<%		} else {%>
		<td class="infoData" width="70%"><%=fee %></td>
	<%		} %>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%">Benefit of Course to Employee</td>
	<%		if (createAction) {%>
		<td class="infoData" width="70%"><input type="textfield" name="benefitEmployee" value="<%=benefitEmployee %>" maxlength="100" size="50"></td>
	<%		} else {%>
		<td class="infoData" width="70%"><%=benefitEmployee %></td>
	<%		} %>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%">Benefit of Course to Department</td>
	<%		if (createAction) {%>
		<td class="infoData" width="70%"><input type="textfield" name="benefitDepartment" value="<%=benefitDepartment %>" maxlength="100" size="50"></td>
	<%		} else {%>
		<td class="infoData" width="70%"><%=benefitDepartment %></td>
	<%		} %>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.sendApprovalTo" /></td>
		<td class="infoData" width="70%">

<%      if("O".equals(ceStatus) && userBean.isManager() && userBean.getStaffID().equals(approve_MGRstaffID)){ %>
				<select name="approve_ADMINstaffID">
				<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
					<jsp:param name="ignoreCurrentStaffID" value="Y" />
					<jsp:param name="value" value="<%=approve_ADMINstaffID %>" />
					<jsp:param name="level" value="4" />
				</jsp:include>
			</select>
<%		}else if(createAction) {%>
			<select name="approve_MGRstaffID">
				<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
					<jsp:param name="ignoreCurrentStaffID" value="Y" />
					<jsp:param name="value" value="<%=approve_MGRstaffID %>" />
					<jsp:param name="level" value="6" />
				</jsp:include>
			</select>

<%		} else {
			if (ceStatus.equals("A") || ceStatus.equals("H")) {
			%><%=approve_HRstaffName %><%
			}else if( ceStatus.equals("M") ){
			%><%=approve_ADMINstaffName %><%
			} else {
			%><%=approve_MGRstaffName %><%
			}
		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="70%"><%=statusDesc.get(ceStatus) %></td>
	</tr>



<%		if ("A".equals(ceStatus) && userBean.isHRManager() && userBean.getStaffID().equals(approve_HRstaffID)) {%>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Approved Hours</td>
		<td class="infoData" width="70%"><input type="textfield" name="approvedHours" value="<%=approvedHours %>" maxlength="8" size="20"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Action Number</td>
		<td class="infoData" width="70%"><input type="textfield" name="actionNum" value="<%=actionNum%>" maxlength="10" size="10"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Approved Expense:</td>
		<td class="infoData" width="70%"><input type="textfield" name="approvedExpense" value="<%=approvedExpense %>" maxlength="10" size="20"></td>
	</tr>

<%		} %>

	<tr class="smallText">
		<td align="center" colspan="2">
<%		 if ("O".equals(ceStatus)) { %>
<%			if (userBean.isManager() && userBean.getStaffID().equals(approve_MGRstaffID)) {  %>
			<button onclick="return submitAction('approve', 1);"><bean:message key="button.approve" /></button>
			<button onclick="return submitAction('reject', 1);"><bean:message key="button.reject" /></button>
<%			} else if (userBean.getStaffID().equals(staffID)) { %>
			<button onclick="return submitAction('cancel', 1);"><bean:message key="function.ce.cancel" /></button>
<%			}  %>
<%		} else if ("M".equals(ceStatus) && userBean.isOfficeAdministrator() && userBean.getStaffID().equals(approve_ADMINstaffID)) { %>
			<button onclick="return submitAction('approve', 1);"><bean:message key="button.confirm" /></button>
			<button onclick="return submitAction('reject', 1);"><bean:message key="button.reject" /></button>

<%		} else if ("A".equals(ceStatus) && userBean.isHRManager() && userBean.getStaffID().equals(approve_HRstaffID)) { %>
			<button onclick="return submitAction('confirm', 1);"><bean:message key="button.confirm" /></button>
			<button onclick="return submitAction('reject', 1);"><bean:message key="button.reject" /></button>
<%		} else if (createAction || cancelAction || approveAction || rejectAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);"><bean:message key='button.save' /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('cancel', 1);"><bean:message key='button.cancel' /> - <bean:message key="<%=title %>" /></button>
<%		}  %>

		</td>
	</tr>
</table>
<input type="hidden" name="command">
<input type="hidden" name="step">
<input type="hidden" name="staffID" value="<%=staffID %>">
<input type="hidden" name="ceID" value="<%=ceID %>">
<input type="hidden" name="ceStatus" value="<%=ceStatus %>">
<input type="hidden" name="deptName" value="<%=deptName %>">
<input type="hidden" name="courseName" value="<%=courseName %>">
<input type="hidden" name="attendDate" value="<%=attendDate %>">
<input type="hidden" name="toPDF" value="N">
</form>
<script language="javascript">
	function submitAction(cmd, stp) {
<%if (createAction) { %>
		if (cmd == 'create' || cmd == 'update') {
	    	if (document.form1.courseID.value == '') {
				alert("Missing CourseID field");
				document.form1.courseID.focus();
				return false;
			}
/*			if (document.form1.uploadedFile.value == '') {
				alert("Missing upload file.");
				document.form1.file.focus();
				return false;
			}
*/
			if (document.form1.courseSponsor.value == '') {
				alert("Missing Sponsor/ Orgainizer of Course field");
				document.form1.courseSponsor.focus();
				return false;
			}
			if (document.form1.attendanceLocation.value == '') {
				alert("Missing Location of Attendance field");
				document.form1.attendanceLocation.focus();
				return false;
			}
			if (isNaN(document.form1.appliedHours.value)){
				alert("Invilad Requested Hours. ");
				document.form1.appliedHours.focus();
				return false;
			}
			if ( (document.form1.appliedHours.value < 0 || document.form1.appliedHours.value > <%=leftHours %>)) {
				alert("Requested Hours must be between 0 and <%=leftHours %>");
				document.form1.appliedHours.focus();
				return false;
			}
			if (isNaN(document.form1.fee.value)){
				alert("Invilad course fee/ tutition.");
				document.form1.fee.focus();
				return false;
			}
			if ( (document.form1.fee.value < 0 || document.form1.fee.value > <%=leftAmount %>)) {
				alert("Course Fee/ tutition must be between 0 and <%=leftAmount %>");
				document.form1.fee.focus();
				return false;
			}

			if (document.form1.benefitEmployee.value == '') {
				alert("Missing benefit Course to employee field");
				document.form1.benefitEmployee.focus();
				return false;
			}
			if (document.form1.benefitDepartment.value == '') {
				alert("Missing benefit Course to department field");
				document.form1.benefitDepartment.focus();
				return false;
			}
		}
<%} %>
  <% 	if (confirmAction && "M".equals(ceStatus) && userBean.isHRManager() && userBean.getStaffID().equals(approve_HRstaffID)) {%>
			if (document.form1.actionNum.value == '') {
				alert("Missing Action Number field");
				document.form1.actionNum.focus();
				return false;
			}
   <%} %>


		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%	} %>
</html:html>