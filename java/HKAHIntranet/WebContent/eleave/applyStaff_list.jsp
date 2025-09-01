<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.servlet.jsp.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%!

	private boolean checkChange(UserBean userBean, String staffID, String leaveStatus) {
		if(userBean.getStaffID() != null){
			return (leaveStatus == null || "O".equals(leaveStatus))
				&& userBean.getStaffID().equals(staffID);
		}else{
			return false;
		}
	}

	private boolean checkCancelApprovedLeave(UserBean userBean,PageContext pageContext) {
		String leaveStatus = ((ReportableListObject) pageContext.getAttribute("row")).getFields7();
		String staffID = ((ReportableListObject) pageContext.getAttribute("row")).getFields1();
		return ("P".equals(leaveStatus))
			&& userBean.getStaffID().equals(staffID);
	}
	
	private boolean checkChangeSickCategory(UserBean userBean,String leaveStatus, String eleaveID,String leaveType) {
		return ("O".equals(leaveStatus)||"WN".equals(leaveStatus))
			&&("SL".equals(leaveType)||"SI".equals(leaveType)||"SN".equals(leaveType))
			&& ELeaveDB.checkExistApproveEl(eleaveID,userBean.getStaffID(),"sick");
	}	

	private boolean checkChange(UserBean userBean, PageContext pageContext) {
		return checkChange(userBean,
				((ReportableListObject) pageContext.getAttribute("row")).getFields1(),
				((ReportableListObject) pageContext.getAttribute("row")).getFields7()
				);
	}
	
	private boolean checkApproveCancel(UserBean userBean,PageContext pageContext) {
		String leaveStatus = ((ReportableListObject) pageContext.getAttribute("row")).getFields7();
		String staffID = ((ReportableListObject) pageContext.getAttribute("row")).getFields1();
		String eleaveID = ((ReportableListObject) pageContext.getAttribute("row")).getFields0();
		return ("CC".equals(leaveStatus) && ELeaveDB.checkExistApproveEl(eleaveID,userBean.getStaffID())
				);
	}

	private boolean checkApproval(UserBean userBean, String eleaveID, String staffID, String leaveStatus, boolean allowVerify, boolean allowConfirm) {
		String category = null;
		if ("P".equals(leaveStatus)) {
			category = "verify";
		} else if ("V".equals(leaveStatus)) {
			category = "confirm";			
		} else {
			category = "approve";
		}
		return (("O".equals(leaveStatus))
			|| ("P".equals(leaveStatus) && allowVerify)
			|| ("V".equals(leaveStatus) && allowConfirm)|| ("WN".equals(leaveStatus) && allowConfirm))
		&& ((ELeaveDB.checkValidApproveEl(eleaveID, userBean.getStaffID(),category))||(ELeaveDB.checkValidApproveEl(eleaveID, userBean.getStaffID(),"sick")));
	}
	private boolean checkApproval(UserBean userBean, PageContext pageContext, boolean allowVerify, boolean allowConfirm) {
		return checkApproval(userBean,
				((ReportableListObject) pageContext.getAttribute("row")).getFields0(),
				((ReportableListObject) pageContext.getAttribute("row")).getFields1(),
				((ReportableListObject) pageContext.getAttribute("row")).getFields7(),
				allowVerify, allowConfirm
				);
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

HashMap statusHashSet = new HashMap();
statusHashSet.put("O", MessageResources.getMessage(session, "label.waiting.for.approve"));
statusHashSet.put("P", "Approved by Mgr or Dept Head");
statusHashSet.put("V", "Verified by HR");
statusHashSet.put("WN", "Waiting for Next Approval");
statusHashSet.put("H", "Approved by HR");
statusHashSet.put("CC","Waiting for Cancel Approval");
statusHashSet.put("C", MessageResources.getMessage(session, "label.confirmed"));
statusHashSet.put("CA", "Cancel Approved by Mgr");
statusHashSet.put("CH", "Cancel Approved by HR");
statusHashSet.put("R", MessageResources.getMessage(session, "label.rejected"));

UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String command = ParserUtil.getParameter(request,"command");
String step =  ParserUtil.getParameter(request,"step");
String eleaveID = ParserUtil.getParameter(request,"eleaveID");
String allowAll = userBean.isSuperManager() ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
String FTE = ParserUtil.getParameter(request,"FTE");
String staffID = ParserUtil.getParameter(request,"staffID");
if (staffID == null) {
	staffID = userBean.getStaffID();
}
if(FTE==null){
	FTE = ELeaveDB.getELFTE(staffID);
}
String staffName = ParserUtil.getParameter(request,"staffName");
if (staffName == null) {
	staffName = userBean.getUserName();
}	
String deptCode = ParserUtil.getParameter(request,"deptCode");
if (deptCode == null) {
	deptCode = userBean.getDeptCode();
}
String deptDesc = ParserUtil.getParameter(request,"deptDesc");
if (deptDesc == null) {
	deptDesc = userBean.getDeptDesc();
}
String leaveType = ParserUtil.getParameter(request,"leaveType");
String fromDate = ParserUtil.getParameter(request,"fromDate");
String toDate = ParserUtil.getParameter(request,"toDate");
String appliedDate = ParserUtil.getParameter(request,"appliedDate");
String appliedHour = ParserUtil.getParameter(request,"appliedHour");
String appliedHourDec1 = ParserUtil.getParameter(request,"appliedHrDecimal_1");
String appliedHOurDec2 = ParserUtil.getParameter(request,"appliedHrDecimal_2");

String selectedHoliday = ParserUtil.getParameter(request,"selectedHoliday");
String holidayDate = ParserUtil.getParameter(request,"holidayDate");
String requestRemarks = ParserUtil.getParameter(request,"requestRemarks");
String responseRemarks = ParserUtil.getParameter(request,"responseRemarks");
String[] fromDateArray = (String[]) request.getAttribute("fromDateArray_StringArray");
String[] toDateArray = (String[]) request.getAttribute("toDateArray_StringArray");
String[] hrArray = (String[]) request.getAttribute("hrArray_StringArray");
String changeHour = ParserUtil.getParameter(request,"changeHour"); 
String leaveStatus = null;
String leaveStatusDesc = null;
String createDate = DateTimeUtil.getCurrentDate();

String EL_courseName = ParserUtil.getParameter(request,"EL_courseName");
String EL_admAction = ParserUtil.getParameter(request,"EL_admAction");
String ML_expectedDate = ParserUtil.getParameter(request,"ML_expectedDate");
String SL_diagnosis = ParserUtil.getParameter(request,"SL_diagnosis");
String SL_docName = ParserUtil.getParameter(request,"SL_docName");
String leaveDetails = ParserUtil.getParameter(request,"leaveDetails"); 

String[] fileList = (String[]) request.getAttribute("filelist");
String[] file1 = (String[]) request.getAttribute("file1_StringArray"); 

String approvedUserBy = null;
String approvedDateBy = null;
String approvedHRVerifyUserBy = null;
String approvedHRVerifyDateBy = null;
String approvedHRUserBy = null;
String approvedHRDateBy = null;

String modifiedUser = null;
String modifiedDate = null;

String disabledLeaveStaffName = null;
String disabledModifiedDate = null;

boolean createAction = false;
boolean deleteAction = false;
boolean viewAction = false;
boolean approveAction = false;
boolean rejectAction = false;
boolean approveCancelAction = false;
boolean cancelApprovedAction = false;
boolean onLoadCancel = false;
boolean allowVerify = false;
boolean allowConfirm = false;
if(userBean != null){
	allowVerify = userBean.isAccessible("function.eleave.staff.verify");
	allowConfirm = userBean.isAccessible("function.eleave.staff.confirm");
	}

String message = "";
String errorMessage = "";
String docID = "";


if ("create".equals(command)) {
	createAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("view".equals(command)) {
	viewAction = true;
} else if ("approve".equals(command)) {
	approveAction = true;
} else if ("reject".equals(command)) {
	rejectAction = true;
} else if ("cancelApproved".equals(command)){
	cancelApprovedAction = true;
} else if ("approveCancel".equals(command)){
	approveCancelAction = true;
}
if(createAction && ("".equals(leaveType))||leaveType == null){
	leaveType = "AL";
}
try {
	if ("1".equals(step)) {
		System.out.println(command.indexOf("user:"));
		if ("mary".equals(command)) {
			userBean = UserDB.getUserBean(request, "3761");
			userBean.writeToSession(request);
		} else if ("testUser".equals(command)) {
			userBean = UserDB.getUserBean(request, "3819");
			userBean.writeToSession(request);
		} else {
			int appliedHourInt = 0;
			Double tempcombinedDec = null;
			Double appliedHourDuble = null;
			boolean checkMultiple = false;
			
			if("0.00".equals(appliedDate)){
			try {
				appliedHourDuble = Double.parseDouble(appliedHour);
			} catch(Exception e) {}
			appliedDate = String.valueOf(appliedHourDuble / 8);
			}

			if (createAction) {
				

				if(fromDateArray !=null){
					if(fromDateArray.length>0 && toDateArray.length>0 && hrArray.length>0){
						fromDate = fromDateArray[0];
						toDate = toDateArray[0];
						appliedHour = hrArray[0];
						appliedHourDuble = Double.parseDouble(appliedHour);
						appliedDate = String.valueOf(appliedHourDuble / 8);
						checkMultiple = true;					
					}
				}
				Date fromDateDate = DateTimeUtil.parseDate(fromDate);
				Date toDateDate = DateTimeUtil.parseDate(toDate);

				if(!checkMultiple){
					try {
						int appliedHourDec1Int = Integer.parseInt(appliedHourDec1);
						int appliedHourDec2Int = Integer.parseInt(appliedHOurDec2);
						
						if(appliedHourDec1Int == 0 && appliedHourDec2Int == 0){
							appliedHourInt = Integer.parseInt(appliedHour);
							appliedHour = String.valueOf(appliedHourInt);
							appliedDate = String.valueOf((double)appliedHourInt/8);
						}else{
							String combineDecHour = appliedHourDec1 + appliedHOurDec2;
							tempcombinedDec = (Integer.parseInt(combineDecHour) / 100.0);
							appliedHourInt = Integer.parseInt(appliedHour);
							tempcombinedDec = tempcombinedDec + appliedHourInt;
							appliedDate = String.valueOf((double) tempcombinedDec / 8);
							appliedHour = String.valueOf(tempcombinedDec);
						}
						
	
					} catch(Exception e) {}
				}
				
				Map<String, String> detailsMap = new HashMap<String, String>();
				if(leaveDetails!= null && !"".equals(leaveDetails)){
					System.out.println("[leaveDetails]"+leaveDetails);
					String[] leaveDetailsArray =leaveDetails.split("<D>");
					String[] leaveDetailsArray2=new String [10];
					 
					for(int i=0;i<leaveDetailsArray.length;i++){
						leaveDetailsArray2 = leaveDetailsArray[i].split("<N>");
						 detailsMap.put(leaveDetailsArray2[0],leaveDetailsArray2[1]);
					}
					
				}
				if (fromDateDate == null) {
					errorMessage = "Invalid start date."; 
				} else if (toDateDate == null) {
					errorMessage = "Invalid end date.";
				}else {
					
					eleaveID = ELeaveDB.add(userBean, staffID, leaveType,
							fromDate, toDate, appliedDate, appliedHour, requestRemarks,"",detailsMap,holidayDate);
					
					if (fileUpload) {
						fileList = (String[]) request.getAttribute("filelist");
						file1 = (String[]) request.getAttribute("file1_StringArray"); 
						if (fileList != null) {
							StringBuffer tempStrBuffer = new StringBuffer();
							
							tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
							tempStrBuffer.append(File.separator);
							tempStrBuffer.append("E-Leave");
							tempStrBuffer.append(File.separator);
							tempStrBuffer.append(leaveType+"-"+eleaveID);
							tempStrBuffer.append(File.separator);
							String baseUrl = tempStrBuffer.toString();

							tempStrBuffer.setLength(0);
							tempStrBuffer.append(File.separator);
							tempStrBuffer.append("upload");
							tempStrBuffer.append(File.separator);
							tempStrBuffer.append("E-Leave");
							tempStrBuffer.append(File.separator);
							tempStrBuffer.append(leaveType+"-"+eleaveID);
							tempStrBuffer.append(File.separator);
							String webUrl = tempStrBuffer.toString();	
							
							if(file1 != null){
								for (int i = 0; i < fileList.length; i++) {
									FileUtil.moveFile(
										ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
										baseUrl + fileList[i]
									);
									docID += DocumentDB.add(userBean, "EL", eleaveID, webUrl, fileList[i])+",";
						
								}
						}
						}
					}
					
					if(checkMultiple){
						if(eleaveID!=null){
							String parentID = eleaveID; 
							for(int k=1;k<hrArray.length;k++){
								appliedHour = hrArray[k];
								appliedHourDuble = Double.parseDouble(appliedHour);
								appliedDate = String.valueOf(appliedHourDuble / 8);
							 	String tempID = ELeaveDB.add(userBean, staffID, leaveType,
										fromDateArray[k], toDateArray[k], appliedDate, appliedHour, requestRemarks,parentID,detailsMap,holidayDate);
							 	
								if (fileUpload) {
									fileList = (String[]) request.getAttribute("filelist");
									file1 = (String[]) request.getAttribute("file1_StringArray"); 
									if (fileList != null) {
										StringBuffer tempStrBuffer = new StringBuffer();
										
										tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
										tempStrBuffer.append(File.separator);
										tempStrBuffer.append("E-Leave");
										tempStrBuffer.append(File.separator);
										tempStrBuffer.append(leaveType+"-"+eleaveID);
										tempStrBuffer.append(File.separator);
										String baseUrl = tempStrBuffer.toString();

										tempStrBuffer.setLength(0);
										tempStrBuffer.append(File.separator);
										tempStrBuffer.append("upload");
										tempStrBuffer.append(File.separator);
										tempStrBuffer.append("E-Leave");
										tempStrBuffer.append(File.separator);
										tempStrBuffer.append(leaveType+"-"+eleaveID);
										tempStrBuffer.append(File.separator);
										String webUrl = tempStrBuffer.toString();	
										
										if(file1 != null){
											for (int i = 0; i < fileList.length; i++) {
												FileUtil.moveFile(
													ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
													baseUrl + fileList[i]
												);
												docID += DocumentDB.add(userBean, "EL", eleaveID, webUrl, fileList[i])+",";
									
											}
										}
									}
								}							 	
							}
							checkMultiple = false;
						}
					}
					if (eleaveID != null && !checkMultiple) {
						message = "Leave created.";
						createAction = false;
					} else {
						String[] returnResult = ELTypeConstraint.checkleaveType(userBean,eleaveID,leaveType,appliedHour, 
								  detailsMap,fromDate,toDate,holidayDate);
						errorMessage = "Leave create fail: "+returnResult[1];
						createAction = false;
					}
				}
			} else if (deleteAction || approveCancelAction) {
				if(approveCancelAction){
					responseRemarks = "CC";
				}
				String deleteValue = ELeaveDB.delete(userBean, eleaveID, responseRemarks);
				if ("1".equals(deleteValue)) {
					message = "Leave Cancelled.";
					deleteAction = false;
				}else if ("2".equals(deleteValue)){
					message = "Leave waiting for next Approver to cancel.";
					deleteAction = false;
				} else {
					errorMessage = "Leave cancel fail.";
				}
			} else if (approveAction) {
				if (ELeaveDB.update(userBean, eleaveID, appliedDate, appliedHour, "A", responseRemarks,(changeHour==null||changeHour=="")?"":changeHour,leaveType)) {
					message = "Leave approved.";
					approveAction = false;
				} else {
					errorMessage = "Leave approve fail due to already approved or cancelled.";
				}
			} else if (rejectAction) {
				if (ELeaveDB.update(userBean, eleaveID, appliedDate, appliedHour, "R", responseRemarks)) {
					message = "Leave rejected.";
					rejectAction = false;
				} else {
					errorMessage = "Leave reject fail.";
				}
			} else if (cancelApprovedAction){
				if (ELeaveDB.update(userBean, eleaveID, appliedDate, appliedHour, "CC", responseRemarks)) {
					message = "Leave waiting for Manager to approve cancellation";
					cancelApprovedAction = false;
				}else{
					errorMessage = "Apply for cancel approved leave fail.";
				}
			}
		}
	} else if (createAction) {
		eleaveID = "";
		deptDesc = userBean.getDeptDesc();
		fromDate = DateTimeUtil.getCurrentDate();
		toDate = fromDate;
		appliedDate = "1";
		leaveStatus = null;
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (eleaveID != null && eleaveID.length() > 0) {
			ArrayList record = ELeaveDB.get(eleaveID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				staffID = row.getValue(0);
				staffName = row.getValue(1);
				deptDesc = row.getValue(2);
				deptCode = row.getValue(15);
				leaveType = row.getValue(3);
				fromDate = row.getValue(4);
				toDate = row.getValue(5);
				appliedDate = row.getValue(6);
				appliedHour = row.getValue(7);
				requestRemarks = row.getValue(8);
				responseRemarks = row.getValue(9);
				leaveStatus = row.getValue(10);
				holidayDate = row.getValue(11);
				modifiedUser = row.getValue(14);
				modifiedDate = row.getValue(13);

				record = ELeaveDB.getApprovalList(eleaveID);
				if (record.size() > 0) {
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						if ("1".equals(row.getValue(3))) {
							approvedUserBy = row.getValue(1);
							approvedDateBy = row.getValue(2);
						} else if ("2".equals(row.getValue(3))) {
							approvedHRVerifyUserBy = row.getValue(1);
							approvedHRVerifyDateBy = row.getValue(2);
						} else if ("3".equals(row.getValue(3))) {
							approvedHRUserBy = row.getValue(1);
							approvedHRDateBy = row.getValue(2);
						}
					}
				}
		  }else{
		  	onLoadCancel=true;
		  }

		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

boolean allowChange = checkChange(userBean, staffID, leaveStatus);
boolean allowApproval = checkApproval(userBean, eleaveID, staffID, leaveStatus, allowVerify, allowConfirm);
leaveStatusDesc = (String) statusHashSet.get(leaveStatus);
if (leaveStatusDesc == null) {
	leaveStatusDesc = MessageResources.getMessage(session, "label.open");
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }


request.setAttribute("apply_list", ELeaveDB.getList(userBean,""));

%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame>

<%
if(onLoadCancel){
	ArrayList recordDisabled = ELeaveDB.getDisabledLeave(eleaveID);
	if(recordDisabled.size()>0){
		ReportableListObject row1 = null;
		for (int i = 0; i < recordDisabled.size(); i++) {
			row1 = (ReportableListObject) recordDisabled.get(0);	
			disabledLeaveStaffName = StaffDB.getStaffName(UserDB.getStaffID(row1.getValue(12)));
			disabledModifiedDate = row1.getValue(11);
		}
	
	}
%>
<script language="javascript">
$(document).ready(function(){
	var value = "The leave has been cancelled By "+document.form1.disabledLeaveStaffName.value+" on "+document.form1.disabledModifiedDate.value;
	$.prompt(value,{
		buttons: { Ok: true},
		callback: function(v,m,f){
			if (v){										
				
				submit: window.close();
				return false;
			} else {
				submit: window.close();
				return false;
			}
		}
	});	
	
});

</script>
<%
}
	String title = null;
	String commandType = null;
	if (command != null) {
		if (createAction) {
			commandType = "create";
		} else if (deleteAction) {
			commandType = "delete";
		} else {
			commandType = "view";
		}
		// set submit label
		title = "function.eleave.staff." + commandType;
	} else {
		title = "function.eleave.staff.list";
	}
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />

</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="search_form"  enctype="multipart/form-data" action="applyStaff_list.jsp" method="post">
<%if(userBean.isAdmin() || ("720".equals(userBean.getDeptCode()))){%>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
		<td class="infoData" width="70%"> 
			<select name="deptCode">
				<option value="">--- All Departments ---</option>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="allowAll" value="<%=allowAll %>" />
</jsp:include>
			</select>
		</td>
	</tr>

	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
<%} %>
<table cellpadding="0" cellspacing="5" border="0">
		<tr class="smallText">
			<td colspan="2" align="center">
				<button onclick="return openHistory();">View Leave History</button>
			</td>
		</tr>
</table>
</form>
<bean:define id="functionLabel"><bean:message key="function.eleave.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1"  enctype="multipart/form-data" action="applyStaff_list.jsp" method="post">
<%	if ((createAction || viewAction)&&!onLoadCancel) { %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
<%	if (viewAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">E-Leave Ref No</td>
		<td class="infoData" width="30%"><b><%=leaveType%>-<%=eleaveID %></b></td>
	</tr>
		
<%} %>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.name" /></td>
		<%if(createAction){ %>
						<td class="infoData" width="30%"><%=staffName %></td> 

		<%}else{ %>
				<td class="infoData" width="30%"><%=staffName %></td> 
		<%} %>
		<td class="infoLabel" width="20%"><bean:message key="prompt.date" /></td>
		<td class="infoData" width="30%"><%=createDate %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="30%" id="showStaffID"></td>
		<td colspan="2">
			<table>
				<tr class="smallText">
					<td class="infoLabel" width="20%"><bean:message key="prompt.department" /></td>
					<td class="infoData" width="30%"><%=deptDesc %> (<%=deptCode %>)</td>
					<td class="infoLabel" width="20%">Hire Date</td>
					<td class="infoData" width="30%" id="hireDate"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Leave Request from</td>
		<td class="infoData" width="30%">
<%	if (createAction) { %>
			<input type="textfield" name="fromDate" id="fromDate" datePickerClass='leaveDate' class="datepickerfield" value="<%=fromDate==null?"":fromDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
<%	} else { %>
			<%=fromDate==null?"":fromDate %>
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.to" /></td>
		<td class="infoData" width="30%">
<%	if (createAction && !"ML".equals(leaveType)) { %>
			<input type="textfield" name="toDate" id="toDate" datePickerClass='leaveDate' class="datepickerfield" value="<%=toDate==null?"":toDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)">
<%	} else if(!createAction){ %>
			<%=toDate==null?"":toDate %>
<%	} %>
		</td>
	</tr>
<tr class="smallText" id="leaveSectionTR">
<td class="infoLabel" width="20%">Leave Section</td>
<td class="infoData" colspan="3">
<div class="leaveSection" id="leaveSection">
<%if(viewAction && "HL".equals(leaveType)){ %>
	Apply for <%=holidayDate %>
<%} %>
</div>
</td>
</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><%if(createAction){ %>Leave Type<%}else{ %>Leave Type and total Number Working Days<%} %></td>
		<td class="infoData" width="30%">
		
<%	if ((leaveStatus == null || allowApproval)) { %>
<%String isSickChange = checkChangeSickCategory(userBean,leaveStatus,eleaveID,leaveType)?"Y":"N"; %>
	
		<select name="leaveType" id="leaveType" onchange="return changeLeaveType()">
			<jsp:include page="../ui/eleaveTypeCMB.jsp" flush="false">
				<jsp:param name="staffID" value="<%=staffID %>" />
				<jsp:param name="leaveType" value="<%=leaveType %>" />
				<jsp:param name="isSickChange" value="<%=isSickChange %>" />
				<jsp:param name="isOnlyShowAL" value="Y" />	
				
			</jsp:include>
		</select><br/>
		<%if (leaveStatus == null){%>
			<select name="holidayDate" id="holidayDate" style="display: <%="HL".equals(leaveType)?"block":"none" %>" >
				<jsp:include page="../ui/eleaveHolidayCMB.jsp" flush="false">
					<jsp:param name="selectedHoliday" value="<%=holidayDate %>" />
				</jsp:include>
			</select><br/>
		<%	} %>
<%	} else { %>
		<%=ELeaveDB.getLeaveTypeDesc(leaveType) %>
<%	} %>
<%	//if (allowApproval) { %>
<div id="hourSec" style="display:none;">
			<span id="appliedHour_indicator"">
				<select name="appliedHour">
					<jsp:include page="../ui/eleaveHourCMB.jsp" flush="false">
						<jsp:param name="leaveType" value="<%=leaveType %>" />
						<jsp:param name="appliedHour" value="<%=appliedHour %>" />
					</jsp:include>
				</select>
			</span>
			<%out.println("  .  "); %>
			<select name="appliedHrDecimal_1" id="appliedHrDecimal_1"">
				<%for(int i=0;i<10;i++){ %>
				<option value="<%=i%>"><%=i %></option>
				<%} %>
			</select>
			<select name="appliedHrDecimal_2" name="appliedHrDecimal_2"">
				<%for(int i=0;i<10;i++){ %>
				<option value="<%=i%>"><%=i %></option>	
				<%} %>
			</select>			
			<bean:message key="label.hours" />
</div>
<%	if(!createAction){ %>
			<%=appliedDate==null?"":appliedDate %> Days
			(<%=appliedHour==null?"":appliedHour %> <bean:message key="label.hours" />)
<%	} %>
		<td class="infoLabel" width="20%"><bean:message key="prompt.balance" /></td>
		<td class="infoData" width="30%">
<%
		ArrayList record = ELeaveDB.getBalanceList(staffID,"9999",leaveType);
		String tempBal = null;
		String tempUsedBal = null;
		String asAtDate = null;
		String asAtMonth = null;
		Double k =null;
		if (record != null && record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				tempBal = row.getValue(1);
			}

		ArrayList recordDate = ELeaveDB.getAsAtDate();
		if (recordDate != null && recordDate.size() > 0) {
			ReportableListObject rowDate = (ReportableListObject) recordDate.get(0);
			asAtDate = rowDate.getValue(0);
			asAtMonth = rowDate.getValue(1);
		}
		
		ArrayList recordBal = ELeaveDB.getAsAtDateToSysdateUsage(staffID,leaveType,asAtMonth);
		if (recordBal != null && recordBal.size() > 0) {
			ReportableListObject rowBal = (ReportableListObject) recordBal.get(0);
			for (int i = 0; i < recordBal.size(); i++) {
				rowBal = (ReportableListObject) recordBal.get(i);
				tempUsedBal = rowBal.getValue(1);
			}			
		}
			if(tempBal!= null){
			k = Double.parseDouble(tempBal)-Double.parseDouble(tempUsedBal==null?"0":tempUsedBal);
			}
%>
				<table><tr><td>Balance as at <%=asAtDate %></td></tr></table>
				<div class="paneBalance" id="paneBalance">
				<table>
				<tr><td>Available Balance: </td><td><%=tempBal==null?"0":tempBal %></td></tr>
				<tr><td>Used Balance: </td><td><u><%=tempUsedBal==null?"0":tempUsedBal %></u></td></tr>
				<%DecimalFormat df =new java.text.DecimalFormat("#.00"); %>
				<tr><td>Remaining Balance: </td><td><%= k==null?"0":Double.valueOf(df.format(k))%></td></tr>
				<input type="hidden" name="remainingBalance" value="<%= k==null?"0":Double.valueOf(df.format(k))%>"/>
				</table>
			</div>
		<%		} else {
					out.println("No Information is found. Please call HR for any enquiry.");
				} %>
		</td>
	</tr>
	<tr>
		<td colspan="4">
			<div id="LeaveTypeDetails">
			<%if(!createAction){ %>
				<jsp:include page="../eleave/leaveDetails.jsp" flush="false">
					<jsp:param name="leaveID" value="<%=eleaveID %>" />
					<jsp:param name="command" value="view" />	
					<jsp:param name="leaveType" value="<%=leaveType %>" />					
									
				</jsp:include>
			<%} %>
			</div>
		</td>
	</tr>	
<%		if (!createAction) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Imm. Supervisor/Dept. Head</td>
		<td class="infoData" width="30%">
<%		if(approvedHRVerifyUserBy!= null){ %>
		<%=approvedHRVerifyUserBy==null?"N/A":approvedHRVerifyUserBy %> AND
<%} %>
		<%="Rejected".equals(leaveStatusDesc)?(modifiedUser==null?"N/A":modifiedUser):(approvedUserBy==null?"N/A":approvedUserBy) %></td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.approvedDate" />/Rejected Date</td>
		<td class="infoData" width="30%"><%="Rejected".equals(leaveStatusDesc)?(modifiedDate==null?"N/A":modifiedDate):(approvedDateBy==null?"N/A":approvedDateBy) %></td>
	</tr>

<%
		}
%>

	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="80%" colspan="3"><%=leaveStatusDesc %></td>
	</tr>
	
	<tr class="smallText">
		<td class="infoLabel" width="20%"><div id="responseRemark"><bean:message key="prompt.remarks" /><%if (leaveStatus == null) { %><%}else{ %> (Response)<%} %></div></td>
<%			if(leaveStatus == null){ %>	
		<td class="infoData" width="80%" colspan="3"><input type="textfield" name="requestRemarks" value="<%=requestRemarks==null?"":requestRemarks %>" maxlength="100" size="100"></td>
<%			} else if (allowApproval) { %>
		<td class="infoData" width="80%" colspan="3">
		<table>
			<tr>
				<td class="infoData" width="80%" colspan="3">Request Remark: <%=requestRemarks==null?"":requestRemarks %></td>
			</tr>
			<tr>
				<td class="infoData" width="80%" colspan="3"><input type="textfield" name="responseRemarks" value="<%=responseRemarks==null?"":responseRemarks %>" maxlength="100" size="100"></td>
			</tr>
		</table>
<%			} else {%>
		<td class="infoData" width="80%" colspan="3">
			<table>
				<tr>
					<td class="infoData" width="80%" colspan="3">Request Remark: <%=requestRemarks==null?"":requestRemarks %></td>
				</tr>
				<tr>
					<td class="infoData" width="80%" colspan="3" remark="response">Response Remark:<%=responseRemarks==null?"":responseRemarks %></td>
				</tr>
			</table>		
		</td>
<%			} %>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Attachment</td>
		<td class="infoData" width="80%" colspan="3">
		<span id="showDocument_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="EL" />
	<jsp:param name="keyID" value="<%=eleaveID %>" />
	<jsp:param name="allowRemove" value="false" />
</jsp:include>
		</span>
<%
	if (createAction) {%>
		<input type="file" name="file1" size="50" value="<%=file1%>"class="multi" maxlength="10">
<%} %>
		</td>
	</tr>	
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%		if (createAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /></button>
			<button onclick="return submitAction('<%=createAction?"list":"view" %>', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
<%		} else { %>
			<table>
				<tr>
<%		if (allowApproval &&("NS".equals(ELeaveDB.getELeaveProcessStatus(eleaveID))||"UPDATED".equals(ELeaveDB.getELeaveProcessStatus(eleaveID)))) { %>
					<td><button onclick="return submitAction('approve', '1');"><bean:message key="button.approve" /></button></td>
					<td><button onclick="return submitAction('reject', '1');"><bean:message key="button.reject" /></button></td>
<%		} %>
<%		if (allowChange && ("NS".equals(ELeaveDB.getELeaveProcessStatus(eleaveID))||"UPDATED".equals(ELeaveDB.getELeaveProcessStatus(eleaveID)))) { %>
					<td><button class="btn-delete"><bean:message key="function.eleave.staff.cancel" /></button></td>
<%		} %>
					<td><button onclick="return submitAction('list', 0);" class="btn-click"><bean:message key="button.back" /></button></td>
				</tr>
			</table>
<%		} %>
		</td>
	</tr>
</table>
</div>
	<%if(!createAction){ %>
	<input type="hidden" name="appliedHour" value="<%=appliedHour%>"/>
	<input type="hidden" name="appliedDate" value="<%=appliedDate%>"/>
	<%} %>
<%	} else { %>
<input type="hidden" name="appliedHour" />
<input type ="hidden" name="appliedDate"/>
<input type ="hidden" name="leaveType"/>

<display:table id="row" name="requestScope.apply_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column title="Ref.No" style="width:8%">
		<c:out value="${row.fields15}-${row.fields0}" />
	</display:column>
	<display:column property="fields2" titleKey="prompt.name" style="width:15%"/>
	<display:column property="fields14" title="Leave Type" style="width:15%"/>
	<display:column titleKey="prompt.from" style="width:20%">
		<c:out value="${row.fields3}" /> - <c:out value="${row.fields4}" />
	</display:column>
	<display:column titleKey="prompt.appliedDate" style="width:10%">
		 <input type="hidden" name="appliedDate_<%=((ReportableListObject)pageContext.getAttribute("row")).getFields0() %>" 
		 value="<%=((ReportableListObject)pageContext.getAttribute("row")).getFields5().trim() %>"/>
 		 <input type="hidden" name="appliedLeaveType_<%=((ReportableListObject)pageContext.getAttribute("row")).getFields0() %>" 
 		value="<%=((ReportableListObject)pageContext.getAttribute("row")).getFields15().trim() %>"/>
<%		if (checkApproval(userBean, pageContext, allowVerify, allowConfirm) 
		&& "NS".equals(ELeaveDB.getELeaveProcessStatus(((ReportableListObject)pageContext.getAttribute("row")).getFields0()))){ %>
			<input type="textfield" name="appliedHour_<%=((ReportableListObject)pageContext.getAttribute("row")).getFields0() %>" 
			storedValue="<%=((ReportableListObject)pageContext.getAttribute("row")).getFields6().trim() %>" 
			value="<%=((ReportableListObject)pageContext.getAttribute("row")).getFields6().trim() %>" maxlength="4" size="3" />
<%		} else {%>
			<c:out value="${row.fields6}" />
<%		} %>Hours(s)
	</display:column>
	<display:column titleKey="prompt.status" style="width:10%">
		<%=statusHashSet.get(((ReportableListObject)pageContext.getAttribute("row")).getFields7()) %>
	</display:column>
	<display:column property="fields12" titleKey="prompt.modifiedBy" style="width:15%" />
	<display:column property="fields13" titleKey="prompt.modifiedDate" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<table>
			<tr>
			 <td><button onclick="return submitView('view', '0', '<c:out value="${row.fields0}" />');">
			 <bean:message key='button.view' /></button></td>
<%	if (checkApproval(userBean, pageContext, allowVerify, allowConfirm)&& 
		("NS".equals(ELeaveDB.getELeaveProcessStatus(((ReportableListObject)pageContext.getAttribute("row")).getFields0())) ||
		"UPDATED".equals(ELeaveDB.getELeaveProcessStatus(((ReportableListObject)pageContext.getAttribute("row")).getFields0()))) 		
	) { %>
				<td><button onclick="return submitView('approve', '1', '<c:out value="${row.fields0}" />');">
				<bean:message key='button.approve' /></button></td>
				<td><button onclick="return submitView('reject', '1', '<c:out value="${row.fields0}" />');">
				<bean:message key='button.reject' /></button></td>
<%	} else if (checkChange(userBean, pageContext)) {%>
				<td><button onclick="return submitView('delete', '1', '<c:out value="${row.fields0}" />');">
				<bean:message key='button.cancel' /></button></td>
<%	} else if(checkCancelApprovedLeave(userBean,pageContext) && 
		("NS".equals(ELeaveDB.getELeaveProcessStatus(((ReportableListObject)pageContext.getAttribute("row")).getFields0())) ||
		"UPDATED".equals(ELeaveDB.getELeaveProcessStatus(((ReportableListObject)pageContext.getAttribute("row")).getFields0()))) 
		){%>
				<td><button onclick="return submitView('cancelApproved', '1', '<c:out value="${row.fields0}" />');">
				Cancel Approved Leave</button></td>				
<%} else if(checkApproveCancel(userBean,pageContext)){ %>
				<td><button onclick="return submitView('approveCancel', '1', '<c:out value="${row.fields0}" />');">
				<bean:message key='button.approve' /> Cancellation</button></td>				

<%} %>
			</tr>
		</table>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%	} %>
	<%	if (!createAction && !viewAction && !userBean.isAdmin()) { %>
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
				<button onclick="return submitAction('create', '0');"><bean:message key="function.eleave.create" /></button>
			</td>
	</table>
	<%	} %>
<input type="hidden" name="command">
<input type="hidden" name="step"/>
<input type="hidden" name="eleaveID" value="<%=eleaveID == null ? "" : eleaveID %>"/>
<input type="hidden" name="viewedStaffID" value="<%=staffID%>"/>
<input type="hidden" name="hireDate" value="<%=ELeaveDB.getELHireDate(staffID) %>"/>
<input type="hidden" name="changeHour" />
<input type="hidden" name="FTE"  value="<%=FTE%>"/>
<input type="hidden" name="disabledLeaveStaffName"  value="<%=disabledLeaveStaffName%>"/>
<input type="hidden" name="disabledModifiedDate"  value="<%=disabledModifiedDate%>"/>
</form>
<script type="text/javascript" src="date.js"></script>
<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}
	
	function openHistory(){
		callPopUpWindow("leaveHistory.jsp");
		return false;
	}
	
	function clearSearch() {
	}
	
	$("select#testDeptCode").change(
			
			function(){
				$.ajax({
					type: "POST",
					url: "../ui/staffIDCMB.jsp",
					data: "deptCode=" + $("select#testDeptCode").attr("value") + "&showDeptDesc=N&category=eleave",
					success: function(values){
					if(values != '') {
						$("select#staffID").html(values);
					}//if
					}//success
				});//$.ajax				
			}
	);
	
	$("select#leaveType").change(
		function(){
			var appliedHour = document.form1.appliedHour.value;
			<%if("manager".equals(userBean.getUserGroupID())){%>
			var staffID = $("select#staffID").attr("value");			
			<%}else{%>
			var staffID = document.form1.viewedStaffID.value;<%}%>
			
			if($("select#leaveType").attr("value")=='HL'){
				   $("#leaveSectionTR").css("display","none");
				   $("#leaveSection").html('');
				   $("div#hourSec").css("display","block");
					document.forms["form1"].elements["holidayDate"].style.display = "block";
				   $('div#LeaveTypeDetails').html('');
			  }else if($("select#leaveType").attr("value")=='BL'){
				   $("#leaveSectionTR").css("display","none");
				   $("#leaveSection").html('');
				   $("div#hourSec").css("display","block");	
					document.forms["form1"].elements["holidayDate"].style.display = "none";
					$('div#LeaveTypeDetails').html('');
			  }else{
				  $("#leaveSectionTR").css("display","block");
				  $("div#hourSec").css("display","none");
				  if($("select#leaveType").attr("value") == "ML"){
						document.forms["form1"].elements["toDate"].value = "";
						document.forms["form1"].elements["toDate"].disabled = "disabled";	
						document.forms["form1"].elements["holidayDate"].style.display = "none";
						$("#leaveSection").html('');
						$('input[datePickerClass="leaveDate"]').trigger('change');
					}else{
						document.forms["form1"].elements["holidayDate"].style.display = "none";
						document.forms["form1"].elements["toDate"].disabled = "";	
						$('input[datePickerClass="leaveDate"]').trigger('change');
					}
					$('div#LeaveTypeDetails').html('');
						$.ajax({
							type: "POST",
							url: "../eleave/leaveDetails.jsp",
							data: "leaveType=" + $("select#leaveType").attr("value"),
							success: function(values){
								if(values != '') {
									$('div#LeaveTypeDetails').html(values);
									
									  $(".datepickerfield").datepicker('destroy');
									  $('input[datePickerClass="leaveDate"]')
									  .datepicker({ showOn: 'button', buttonImageOnly: true,buttonImage: "../images/calendar.jpg" });
									  $('input[name="ML_expectedDate"]')
									  .datepicker({ showOn: 'button', buttonImageOnly: true,buttonImage: "../images/calendar.jpg" });
									  $('input[datePickerClass="leaveDate"]').unbind('change');
									  $('input[datePickerClass="leaveDate"]').bind('change',dateFieldChange);									  
								}//if
							}//success
						});//$.ajax  
			  }
			$.ajax({
				type: "POST",
				url: "../ui/eleaveHourCMB.jsp",
				data: "leaveType=" + $("select#leaveType").attr("value") + "&appliedHour=" + appliedHour,
				success: function(values){
					if(values != '') {
						$("#appliedHour_indicator").html("<select name='appliedHour'>" + values + "</select>");
					}//if
				}//success
			});//$.ajax
			$.ajax({
				type: "POST",
				url: "../ui/leaveBalanceCMB.jsp",
				data: "leaveType=" + $("select#leaveType").attr("value") + "&staffID=" + staffID,
				success: function(values){
					if(values != '') {
						$("#paneBalance").html(values);
					}//if
				}//success
			});//$.ajax

		}
	);
	
	$(document).ready(function() {
	$("td#hireDate").html(document.form1.hireDate.value);
	$("td#showStaffID").html(document.form1.viewedStaffID.value);
	  $('input[datePickerClass="leaveDate"]').unbind('change');
	  $('input[datePickerClass="leaveDate"]').bind('change',dateFieldChange);
	$('input[datePickerClass="leaveDate"]').trigger('change');
	
	});
	
	function dateFieldChange(){
			var fromDate = $("input[name='fromDate']").attr("value");
			var toDate = $("input[name='toDate']").attr("value");
			if (!isValidDate("fromDate",$("input[name='fromDate']").attr("value"))) {
				return false;
			}else if (!isValidDate("toDate",$("input[name='toDate']").attr("value"))&& 
					document.form1.leaveType.value != 'ML') {
				return false;
			}else{
	
				$.ajax({
					type: "POST",
					url: "../ui/eleaveDateSplitCMB.jsp",
					data: "fromDate=" + fromDate + "&toDate=" + toDate+ 
					"&leaveType="+document.form1.leaveType.value+"&FTE="+document.form1.FTE.value,
					success: function(values){
						if(values != '') {
						 if($("select#leaveType").attr("value")!='BL' 
								&&$("select#leaveType").attr("value")!='HL'){		
						   $("#leaveSection").html(values);
						 }
						}//if
					}//success
				});//$.ajax
						
			}
		 };


	$(".alertBalance").click(function(){
		 var value=$(this).attr("name");
		$(this).parents(".paneBalance").animate({ backgroundColor: "#fbc7c7" }, "fast")
		.animate({ backgroundColor: "#F9F3F7" }, "slow")
		$.prompt(value,{
			buttons: { Close: false },
			prefix:'cleanblue'
		});
	});
	
	$("select#staffID").change(function(){ 


	    var staffID = $(this).val(); 
		var leaveType = document.form1.leaveType.value;
		var fromDate = $("input[name='fromDate']").attr("value");
		var toDate = $("input[name='toDate']").attr("value");
		
		$.ajax({
			type: "POST",
			url: "../ui/eleaveTypeCMB.jsp",
			data: "staffID=" + staffID,
			success: function(values){
				if(values != '') {
					$("select#leaveType").html(values);
				}//if
			}//success
		});//$.ajax
		
			$.ajax({
				type: "POST",
				url: "../ui/leaveBalanceCMB.jsp",
				data: "leaveType=" + leaveType + "&staffID=" + staffID,
				success: function(values){
					if(values != '') {
						$("#paneBalance").html(values);
					}//if
				}//success
			});//$.ajax
			$("td#showStaffID").html(staffID);
			$("td#hireDate").html($("option[value="+staffID+"]").attr("hireDate"));
			document.form1.FTE.value= $("option[value="+staffID+"]").attr("FTE");

			$.ajax({
				type: "POST",
				url: "../ui/eleaveDateSplitCMB.jsp",
				data: "fromDate=" + fromDate + "&toDate=" + toDate
				+ "&leaveType="+document.form1.leaveType.value+"&FTE="+document.form1.FTE.value,
				success: function(values){
					if(values != '') {
						$("#leaveSection").html(values);
					}//if
				}//success
			});//$.ajax			
	    });

		
	
	
	function submitView(cmd, stp, eid) {
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.eleaveID.value = eid;
		if(cmd =='approve'){
		document.form1.appliedHour.value = document.forms["form1"].elements["appliedHour_"+eid].value;
		document.form1.leaveType.value = document.forms["form1"].elements["appliedLeaveType_"+eid].value;	
		var leaveDate = Math.round((parseFloat(document.form1.appliedHour.value)/8)*100)/100;
		document.form1.appliedDate.value = leaveDate;
		var preValue = $('input[name="appliedHour_'+eid+'"]').attr("storedvalue");
			if(preValue !=null){
				document.form1.changeHour.value = preValue;
			}	
		
		}
		
			document.form1.submit();
		}
	
	function isValidDate(field,dateString)
	{
		
		if(dateString == ''){
			return false;
		}
	    // First check for the pattern
	    if(!(/^\d{2}\/\d{2}\/\d{4}$/.test(dateString))){
	    	alert("Please input correct date format(dd/mm/yyyy) in "+ field);
			$("input[name='"+field+"']").focus();
	    	return false;
	    }
	    // Parse the date parts to integers
	    var parts = dateString.split("/");
	    var day = parseInt(parts[0], 10);
	    var month = parseInt(parts[1], 10);
	    var year = parseInt(parts[2], 10);
	    // Check the ranges of month and year
	    if(year < 1000 || year > 3000 || month == 0 || month > 12){
	    	alert("Please input correct year");
			$("input[name='"+field+"']").focus();
	    	return false;
	    }
	    var monthLength = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];

	    // Adjust for leap years
	    if(year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))
	        monthLength[1] = 29;
	    if(day > monthLength[month - 1]){
	    	alert("Please input correct day	");
			$("input[name='"+field+"']").focus();
	    }
	    // Check the range of the day
	    return day > 0 && day <= monthLength[month - 1];
	};
	

	function confirmAction(cmd,stp) {
		document.form1.command.value = cmd;
		document.form1.step.value = stp;	
		document.form1.submit();
	}
	
	function submitAction(cmd, stp) {

		if (stp == 1 && cmd == 'create') {			
			var alertFlag = 'N';
			if(document.form1.leaveType.value == ''){	
				<%	if(StaffDB.isInLastMonthOfTerminationForEL(userBean.getSiteCode(),staffID)){%>
				alert("Staff who is in Probation or in the last month of Employment can not apply Annual Leave");
				<%}else{%>
				alert("No Leave Type Selected");
				<%}%>
				return false;
			} else if (document.form1.fromDate.value == '') {
				alert("Empty Date From.");
				document.form1.fromDate.focus();
				return false;	
			} else if (document.form1.toDate.value == ''&& document.form1.leaveType.value!="ML") {
				alert("Empty Date To.");
				document.form1.toDate.focus();
				return false;
			}else{
				var checkProbationALValid = true;
				<%if(StaffDB.isInProbationForEL(userBean.getSiteCode(),staffID)){%>					
					var fromDateStr = document.form1.fromDate.value.split("/",3);
					var newFromDate = new Date(fromDateStr[1]+"/"+fromDateStr[0]+"/"+fromDateStr[2]);
					var hireDateStr = document.form1.hireDate.value.split("/",3);
					var newhireDate =  new Date(hireDateStr[1]+"/"+hireDateStr[0]+"/"+hireDateStr[2]);
					var threeMonthProbation = new Date();
					threeMonthProbation.setMonth(newhireDate.getMonth()+3);
					threeMonthProbation.setDate(newhireDate.getDate()-1);
					if(threeMonthProbation > newFromDate){
						checkProbationALValid = false;
					}
				<%}%>
				if(checkProbationALValid == false){
					alert("Staff who is in Probation can not apply Annual Leave within Probation");
					return false;
				}
			}
			var detailString ='';	
			$(".leaveDetails").each(
				function(){
			    	
			    	if($(this).attr("value")!= '' && $(this).attr("value")!= null){
			    		detailString += $(this).attr("name")+"<N>"+$(this).attr("value")+"<D>";
			    	}			    	
				}
			);
			$("#ML_expectedDate").each(
					function(){
				    	if($(this).attr("value")!= '' && $(this).attr("value")!= null){
				    		detailString += $(this).attr("name")+"<N>"+$(this).attr("value")+"<D>";
				    	}			    	
					}
			);
			//parse leaveDetails to hidden input to submit
			$('form[name="form1"]').append('<input type="hidden" name="leaveDetails" value="'+detailString+'" />');
			
			//check if end date earlier than from date//
			var fromDateStr = document.form1.fromDate.value.split("/",3);
			var newFromDate = new Date(fromDateStr[1]+"/"+fromDateStr[0]+"/"+fromDateStr[2]);
			var toDateStr = document.form1.toDate.value.split("/",3);
			var newToDate = new Date(toDateStr[1]+"/"+toDateStr[0]+"/"+toDateStr[2]);
			if(newFromDate > newToDate){
				alert("End Date can not be earlier than From Date.");
				return false;
				alertFlag = 'Y'; //dont allow confirmAction
			}
			
			if($("#leaveSection").html() != null || 
					$("#leaveSection").html() != ''){ // parse multiple leave Section in hidden input to submit
				var fromString ='';	
				var toString = '';
				$("td.fromClass").each(			
						function(){
							var today = new Date();
							var sixMonthBF = new Date();
							sixMonthBF.setMonth(sixMonthBF.getMonth()-6);
							var splitStr = $(this).html().split("/",3);
							var newFromDate = new Date(splitStr[1]+"/"+splitStr[0]+"/"+splitStr[2]);
							if(sixMonthBF > newFromDate){
								alert("Can not apply leave more than six months before.");
								alertFlag = 'Y';
								return false;
							}
							$('form[name="form1"]').append('<input type="hidden" name="fromDateArray" value="'+$(this).html()+'" />');	
							fromString += $(this).attr("index")+'('+$(this).html()+')';
						}
					);
				if(alertFlag == 'N'){
				$("td.toClass").each(			
						function(){		
							$('form[name="form1"]').append('<input type="hidden" name="toDateArray" value="'+$(this).html()+'" />');		
						toString += $(this).attr("index")+'('+$(this).html()+')';
						}
					);
				}
				var countTotalHr = 0;
				if(alertFlag == 'N'){
					$(".hrClass").each(			
							function(){									
								var dec1 = $(".dec1Class[	index='"+$(this).attr("index")+"']").attr("value");
								var dec2 = $(".dec2Class[index='"+$(this).attr("index")+"']").attr("value");
								if($(this).attr("value")=='0' && dec1 == '0' && dec2 == '0'){
									alert("Empty Applied Hour1.");
									alertFlag = 'Y';
									return false;
								}
								countTotalHr = countTotalHr+parseFloat($(this).attr("value")+'.'+dec1+dec2);
								if(document.form1.leaveType.value == 'AL' ||
										document.form1.leaveType.value == 'SL' ||
										document.form1.leaveType.value == 'EL'){	
									if(parseFloat(countTotalHr) > parseFloat(document.form1.remainingBalance.value)){
										alert("Total Applied Hour(s) is/are more than remaining  Leave Balance.");
										alertFlag = 'Y';
										return false;
									}
								}
								$('form[name="form1"]').append('<input type="hidden" name="hrArray" value="'+$(this).attr("value")+'.'+dec1+dec2+'" />');		
								
							}
						);
				}
			}		
			$.ajax({ // prompt duplicate leave alert
				type: "POST",
				url: "../ui/leaveAlertCMB.jsp",
				data: "staffID=" + document.form1.viewedStaffID.value + "&fromDate=" + document.form1.fromDate.value+"&endDate="+document.form1.toDate.value,
				success: function(values){	
					if(values != ''&& values.indexOf('<table>')>-1 && alertFlag =='N') {
						$.prompt(values,{
							buttons: { Ok: true, Cancel: false },
							callback: function(v,m,f){
								if (v){										
									
									submit: confirmAction(cmd,stp);
									return true;
								} else {

									$('input[name*="fromDateArray"]').remove();
									$('input[name*="toDateArray"]').remove();
									$('input[name*="hrArray"]').remove();
									return false;
								}
							}
						});
					}else{
						if(alertFlag == 'Y'){
							return false;
						}else{
							confirmAction(cmd,stp);
						};
					};//if
				} //success
			});
		}else if (stp == 1 && cmd == 'reject'){

				var value = "Do you want to proceed without stating a reason?";
				$.prompt(value,{
					buttons: { Yes: true, No: false },
					callback: function(v,m,f){
						if (v){																
							submit: confirmAction(cmd,stp);
						} else {
							$('div#responseRemark').css('background-color','yellow');
							$('div#responseRemark').append('<img src="../images/alert_general.gif"/>');
							return false;
						};
					}
				});	
		}else{
			if(alertFlag == 'Y'){
				return false;
			}else{
				confirmAction(cmd,stp);
			}
		}
		

	}


</script>
</div>
</div>
</div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>