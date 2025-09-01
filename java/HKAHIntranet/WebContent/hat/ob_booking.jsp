<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
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

HashMap<String, String> statusHashSet = OBBookingDB.getStatusSet(session);
HashMap<String, String> documentTypeSet = new HashMap<String, String>();
documentTypeSet.put("9", "Hong Kong ID");
documentTypeSet.put("9Y", "Hong Kong Permanent ID");
documentTypeSet.put("C", "China Passport");
documentTypeSet.put("D", "Others");
documentTypeSet.put("L", "China Two-way Permit (通行証)");
documentTypeSet.put("X", "Macau SAR ID");

UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();

String source = ParserUtil.getParameter(request, "source");
boolean isDoctor = ("doctor".equals(source) || userBean.isDoctor()) && userBean.isAccessible("function.obbooking.doctor");
boolean isAdmin = "admin".equals(source) && userBean.isAccessible("function.obbooking.administration");
boolean isUpdateEDC = userBean.isAccessible("function.obbooking.updateEDC");
//boolean isOverride = userBean.isAccessible("function.obbooking.override");
boolean isOverride = isAdmin;

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String obbookingID = ParserUtil.getParameter(request, "obbookingID");
String pbpID = ParserUtil.getParameter(request, "pbpID");

String doctorCode = ParserUtil.getParameter(request, "doctorCode");
String doctorName = null;
String patientID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patientID"));
String lastName = ParserUtil.getParameter(request, "lastName");
if (lastName != null) lastName = TextUtil.parseStrUTF8(lastName).toUpperCase();
String firstName = ParserUtil.getParameter(request, "firstName");
if (firstName != null) firstName = TextUtil.parseStrUTF8(firstName).toUpperCase();
String chineseName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "chineseName"));
String contactNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "contactNo"));
String DOBDate = ParserUtil.getParameter(request, "DOBDate");
String docType = TextUtil.parseStr(ParserUtil.getParameter(request, "docType"));
String docNo = ParserUtil.getParameter(request, "docNo");
if (docNo != null) docNo = TextUtil.parseStr(docNo).toUpperCase();
String estimateDeliveryDate = null;
String expectedDeliveryDate = ParserUtil.getParameter(request, "expectedDeliveryDate");
String edcCount = null;
String pboRemark = ParserUtil.getParameter(request, "pboRemark");

String kinLastName = ParserUtil.getParameter(request, "kinLastName");
if (kinLastName != null) kinLastName = TextUtil.parseStrUTF8(kinLastName).toUpperCase();
String kinFirstName = ParserUtil.getParameter(request, "kinFirstName");
if (kinFirstName != null) kinFirstName = TextUtil.parseStrUTF8(kinFirstName).toUpperCase();
String kinChineseName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "kinChineseName"));
String kinContactNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "kinContactNo"));
String kinDOBDate = ParserUtil.getParameter(request, "kinDOBDate");
String kinDocType = TextUtil.parseStr(ParserUtil.getParameter(request, "kinDocType"));
String kinDocNo = ParserUtil.getParameter(request, "kinDocNo");
if (kinDocNo != null) kinDocNo = TextUtil.parseStr(kinDocNo).toUpperCase();

String checkedDate1 = ParserUtil.getParameter(request, "checkedDate1");
String checkedDate2 = ParserUtil.getParameter(request, "checkedDate2");
String checkedDate3 = ParserUtil.getParameter(request, "checkedDate3");
String checkedDate4 = ParserUtil.getParameter(request, "checkedDate4");
String checkedDate5 = ParserUtil.getParameter(request, "checkedDate5");
String labResultReady = ParserUtil.getParameter(request, "labResultReady");
String reason = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "reason"));
String expiryDate = null;
String status = ParserUtil.getParameter(request, "status");
if (status == null) {
	status = "O";
}
String returnStatus = null;

int dailyQuota = -1;
int monthQuota = -1;
int monthMLQuota = -1;
int monthHKQuota = -1;
int periodQuota = -1;

boolean createAction = false;
boolean updateAction = false;
boolean updateEDCAction = false;
boolean deleteAction = false;
boolean attachAction = false;
boolean cancelAction = false;
boolean closeAction = false;

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

if (fileUpload) {
	// create new record
	if ("create".equals(command) && "1".equals(step)) {
		// get project id with dummy data
		obbookingID = OBBookingDB.add(userBean);
	}

	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("OB Booking");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(obbookingID);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("upload");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("OB Booking");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(obbookingID);
		String webUrl = tempStrBuffer.toString();

		for (int i = 0; i < fileList.length; i++) {
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + fileList[i]
			);
			DocumentDB.add(userBean, "obbooking", obbookingID, webUrl, fileList[i]);
		}
	}
}

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("updateEDC".equals(command) && isUpdateEDC) {
	updateEDCAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("attach".equals(command)) {
	attachAction = true;
}

ArrayList<ReportableListObject> record = null;
ArrayList<ReportableListObject> waitingQueue = null;
ReportableListObject row = null;

try {
	if (createAction && !OBBookingDB.checkPatientID(docNo)) {
		errorMessage = "OB Booking create fail due to ID already applied.";
		step = null;
	} else if ("1".equals(step)) {
		if (createAction) {
			// get obbooking id with dummy data
			obbookingID = OBBookingDB.add(userBean);

			// update booking information
			if (OBBookingDB.updateBooking(userBean,
					obbookingID, doctorCode, patientID,
					lastName, firstName, chineseName,
					contactNo, DOBDate, docType, docNo,
					kinLastName, kinFirstName, kinChineseName,
					kinContactNo, kinDOBDate, kinDocType, kinDocNo,
					checkedDate1, checkedDate2, checkedDate3, checkedDate4, checkedDate5,
					labResultReady, pboRemark)) {

				// update edc for first time
				OBBookingDB.updateEDC(userBean, obbookingID, expectedDeliveryDate);

				// make booking
				record = OBBookingDB.makeBooking(userBean, obbookingID, isOverride);
				if (record.size() > 0) {
					row = record.get(0);
					returnStatus = row.getValue(0);
					errorMessage = row.getValue(1);

					if ("B".equals(returnStatus)) {
						message = "Please notify patient to pay deposit with 2 weeks from the confirmation date.";
						status = "B";
						errorMessage = null;
					}
				}
				createAction = false;
				step = null;
			} else {
				errorMessage = "OB Booking create fail.";
			}
		} else if (updateAction) {
			// only available in HATS
			if ("".equals(obbookingID) && !"".equals(pbpID)) {
				// create dummy obbookingID if booking is already in hats
				obbookingID = OBBookingDB.add(userBean, pbpID);
				OBBookingDB.updateStatus(userBean, obbookingID, "B");
				OBBookingDB.updateEDC(userBean, obbookingID, expectedDeliveryDate);
			}

			if (OBBookingDB.updateBooking(userBean,
					obbookingID, doctorCode, patientID,
					lastName, firstName, chineseName,
					contactNo, DOBDate, docType, docNo,
					kinLastName, kinFirstName, kinChineseName,
					kinContactNo, kinDOBDate, kinDocType, kinDocNo,
					checkedDate1, checkedDate2, checkedDate3, checkedDate4, checkedDate5,
					labResultReady, pboRemark)) {

				updateAction = false;
				step = null;
			} else {
				errorMessage = "OB Booking update fail.";
			}
		} else if (updateEDCAction) {
			// only available in HATS
			if ("".equals(obbookingID) && !"".equals(pbpID)) {
				// create dummy obbookingID
				record = OBBookingDB.hats2Booking(userBean, pbpID, "B", null);
				if (record.size() > 0) {
					row = record.get(0);
					obbookingID = row.getValue(0);
				}
			}

			if (obbookingID != null && obbookingID.length() > 0
					&& OBBookingDB.updateEDC(userBean, obbookingID, expectedDeliveryDate)) {
				updateEDCAction = false;
				step = null;
			} else {
				errorMessage = "OB Booking update EDC fail.";
			}
		} else if (deleteAction) {
			// cancel booking
			record = OBBookingDB.cancelBooking(userBean, pbpID, reason);

			if (record.size() > 0) {
				row = record.get(0);
				obbookingID = row.getValue(0);
				returnStatus = row.getValue(1);
				errorMessage = row.getValue(2);

				if ("X".equals(returnStatus)) {
					message = "ob booking is cancelled.";
					if ("Others".equals(response)) {
						message += " Please contact HKAH – Patient Business Department at 3651-8900 for enquiry";
					} else {
						message += " Please issue document as attachment for refund";
					}
					errorMessage = null;

					deleteAction = false;
					step = null;
				}
			} else {
				errorMessage = "OB Booking remove fail.";
			}
		}
	} else if (createAction) {
		if (step == null) {
			obbookingID = "";
			if (isDoctor) {
				if (userBean.isStaff() || userBean.isAdmin()) {
					// default user
					doctorCode = "";
					doctorName = "";
				} else {
					if (userBean.getStaffID() != null && userBean.getStaffID().indexOf("DR") == 0) {
						doctorCode = userBean.getStaffID().substring(2);
					} else {
						doctorCode = userBean.getStaffID();
					}
					doctorName = userBean.getUserName();
				}
			}
			patientID = "";
			lastName = "";
			firstName = "";
			chineseName = "";
			contactNo = "";
			DOBDate = "";
			docType = null;
			docNo = "";
			expectedDeliveryDate = "";
			kinLastName = "";
			kinFirstName = "";
			kinChineseName = "";
			kinContactNo = "";
			kinDOBDate = "";
			kinDocType = null;
			kinDocNo = "";
			checkedDate1 = "";
			checkedDate2 = "";
			checkedDate3 = "";
			checkedDate4 = "";
			checkedDate5 = "";
			labResultReady = "Y";
			pboRemark = "";
			status = "O";
		} else if ("0".equals(step) && !"".equals(expectedDeliveryDate)) {
			// check quota
			record = OBBookingDB.getQuota(doctorCode, expectedDeliveryDate);
			if (record.size() > 0) {
				row = record.get(0);
				try { dailyQuota = Integer.parseInt(row.getValue(0)); } catch (Exception e) {}
				try { monthQuota = Integer.parseInt(row.getValue(1)); } catch (Exception e) {}
				try { periodQuota = Integer.parseInt(row.getValue(2)); } catch (Exception e) {}
				try { monthMLQuota = Integer.parseInt(row.getValue(3)); } catch (Exception e) {}
				try { monthHKQuota = Integer.parseInt(row.getValue(6)); } catch (Exception e) {}
			}

			if (dailyQuota <= 0) {
				errorMessage = "Hospital daily quota is fulled, waiting list booking will be created after submit.";
			} else if ((("C".equals(docType) || "L".equals(docType) || "X".equals(docType)) && monthMLQuota <= 0)
					|| (("9".equals(docType) || "D".equals(docType)) && monthHKQuota + monthMLQuota <= 0)) {
				errorMessage = "Doctor monthly quota is fulled, waiting list booking will be created after submit.";
			} else if (monthQuota <= 0) {
				errorMessage = "Hospital monthly quota is fulled, waiting list booking will be created after submit.";
			} else if (periodQuota <= 0) {
				errorMessage = "Period quota is fulled, waiting list booking will be created after submit.";
			}
		}
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (obbookingID != null && obbookingID.length() > 0
			|| pbpID != null && pbpID.length() > 0) {
			record = OBBookingDB.get(obbookingID, pbpID);
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				int i = 0;
				obbookingID = row.getValue(i++);
				pbpID = row.getValue(i++);
				doctorCode = row.getValue(i++);
				doctorName = row.getValue(i++);
				patientID = row.getValue(i++);
				lastName = row.getValue(i++);
				firstName = row.getValue(i++);
				chineseName = row.getValue(i++);
				contactNo = row.getValue(i++);
				DOBDate = row.getValue(i++);
				docType = row.getValue(i++);
				docNo = row.getValue(i++);
				estimateDeliveryDate = row.getValue(i++);
				expectedDeliveryDate = row.getValue(i++);
				kinLastName = row.getValue(i++);
				kinFirstName = row.getValue(i++);
				kinChineseName = row.getValue(i++);
				kinContactNo = row.getValue(i++);
				kinDOBDate = row.getValue(i++);
				kinDocType = row.getValue(i++);
				kinDocNo = row.getValue(i++);
				checkedDate1 = row.getValue(i++);
				checkedDate2 = row.getValue(i++);
				checkedDate3 = row.getValue(i++);
				checkedDate4 = row.getValue(i++);
				checkedDate5 = row.getValue(i++);
				labResultReady = row.getValue(i++);
				reason = row.getValue(i++);
				expiryDate = row.getValue(i++);
				status = row.getValue(i++);
				edcCount = row.getValue(i++);
				pboRemark = row.getValue(i++);
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
boolean isAllowCancel = userBean.isAccessible("function.obbooking.delete");

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
if ("".equals(step)) { step = null; }
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction || updateEDCAction || attachAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.obbooking." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" <%if (cancelAction || attachAction) { %>enctype="multipart/form-data" <%} %>action="ob_booking.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%">Doctor</td>
		<td class="infoData" width="30%">
<%	if (createAction) { %>
			<select name="doctorCode" onChange="return checkEDC(document.form1.expectedDeliveryDate);" <% if (step != null || isDoctor) { %>disabled="disabled"<%} %>>
<jsp:include page="../ui/docCodeCMB.jsp" flush="false">
	<jsp:param name="selectFrom" value="obbooking" />
	<jsp:param name="doccode" value="<%=doctorCode %>" />
</jsp:include>
			</select>
<% 		if (step != null || isDoctor) { %>
			<input type="hidden" name="doctorCode" value="<%=doctorCode==null?"":doctorCode %>"/>
<%		} %>
<%	} else { %>
			<%=doctorName==null?doctorCode:doctorName %>
			<input type="hidden" name="doctorCode" value="<%=doctorCode==null?"":doctorCode %>"/>
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><font color="red">*</font>Expected Confinement Date</td>
		<td class="infoData" width="30%">
<%	if ((createAction && step == null) || updateEDCAction) { %>
			<input type="textfield" name="expectedDeliveryDate" id="expectedDeliveryDate" value="<%=expectedDeliveryDate==null?"":expectedDeliveryDate %>" maxlength="10" size="10" onkeyup="checkEDC(this)" onblur="checkEDC(this)"> (DD/MM/YYYY)<br/>
			<span id="showQuota_indicator">
<%	} else { %>
			<%=expectedDeliveryDate==null?"":expectedDeliveryDate %><%if (updateAction) { %>  ( <font color="red">Not allow to change</font> )<%} %>
			<input type="hidden" name="expectedDeliveryDate" value="<%=expectedDeliveryDate %>">
<%	} %>
<%	if (estimateDeliveryDate != null && estimateDeliveryDate.length() > 0) { %>
			<br/>( Estimated EDC: <b><%=estimateDeliveryDate %></b> )
<%	} %>
<%	if (edcCount != null && edcCount.length() > 0 && !"0".equals(edcCount)) { %>
			<br/>( Modified Count: <b><%=edcCount %></b> )
<%	} %>
<%	if (isUpdateEDC && !createAction && !updateAction && !deleteAction && !updateEDCAction) { %>
			<button onclick="return submitAction('updateEDC', 0);" class="btn-click">Update EDC</button>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="4">Patient's Information</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.patientNo" /></td>
		<td class="infoData" width="80%" colspan="3">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="patientID" class="touppercase" value="<%=patientID==null?"":patientID %>" maxlength="10" size="25" onblur="checkPatientNo(this);">
<%	} else { %>
			<%=patientID==null?"":patientID %>
			<input type="hidden" name="patientID" value="<%=patientID %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><font color="red">*</font><bean:message key="prompt.lastName" /></td>
		<td class="infoData" width="30%">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="lastName" class="touppercase" value="<%=lastName==null?"":lastName %>" maxlength="20" size="25">
<%	} else { %>
			<%=lastName==null?"":lastName %>
			<input type="hidden" name="lastName" value="<%=lastName %>">
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><font color="red">*</font><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="30%">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="firstName" class="touppercase" value="<%=firstName==null?"":firstName %>" maxlength="20" size="25">
<%	} else { %>
			<%=firstName==null?"":firstName %>
			<input type="hidden" name="firstName" value="<%=firstName %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData" width="30%">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="chineseName" value="<%=chineseName==null?"":chineseName %>" maxlength="30" size="25">
<%	} else { %>
			<%=chineseName==null?"":chineseName %>
			<input type="hidden" name="chineseName" value="<%=chineseName %>">
<%	} %>
		</td>
		<td class="infoLabel" width="20%">Contact No.</td>
		<td class="infoData" width="30%">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="contactNo" class="touppercase" value="<%=contactNo==null?"":contactNo %>" maxlength="15" size="25">
<%	} else { %>
			<%=contactNo==null?"":contactNo %>
			<input type="hidden" name="contactNo" value="<%=contactNo %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><font color="red">*</font><bean:message key="prompt.dateOfBirth" /></td>
		<td class="infoData" width="50%" colspan="3">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="DOBDate" id="DOBDate" class="datepickerfield" value="<%=DOBDate==null?"":DOBDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else { %>
			<%=DOBDate==null?"":DOBDate %>
			<input type="hidden" name="DOBDate" value="<%=DOBDate %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><font color="red">*</font>Document Type</td>
		<td class="infoData" width="30%">
<%	if ((createAction && step == null) || (updateAction && !"C".equals(docType) && !"L".equals(docType) && !"X".equals(docType))) { %>
			<input type="radio" name="docType" value="9"<%if ("9".equals(docType)) { %> checked<%} %>><%=documentTypeSet.get("9") %></input><br/>
			<input type="radio" name="docType" value="C"<%if ("C".equals(docType)) { %> checked<%} %>><%=documentTypeSet.get("C") %></input><br/>
			<input type="radio" name="docType" value="L"<%if ("L".equals(docType)) { %> checked<%} %>><%=documentTypeSet.get("L") %></input><br/>
			<input type="radio" name="docType" value="X"<%if ("X".equals(docType)) { %> checked<%} %>><%=documentTypeSet.get("X") %></input><br/>
			<input type="radio" name="docType" value="D"<%if ("D".equals(docType)) { %> checked<%} %>><%=documentTypeSet.get("D") %></input>
<%	} else if (updateAction && ("C".equals(docType) || "L".equals(docType) || "X".equals(docType))) { %>
			<%=documentTypeSet.get("9") %><br/>
			<input type="radio" name="docType" value="C"<%if ("C".equals(docType)) { %> checked<%} %>><%=documentTypeSet.get("C") %></input><br/>
			<input type="radio" name="docType" value="L"<%if ("L".equals(docType)) { %> checked<%} %>><%=documentTypeSet.get("L") %></input><br/>
			<input type="radio" name="docType" value="X"<%if ("X".equals(docType)) { %> checked<%} %>><%=documentTypeSet.get("X") %></input><br/>
			<%=documentTypeSet.get("D") %>
<%	} else { %>
			<%=docType == null || docType.length() == 0 ? "Empty" : documentTypeSet.get(docType) %><%if (updateAction) { %> ( <font color="red">Not allow to change</font> )<%} %>
			<input type="hidden" name="docType" value="<%=docType %>">
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><font color="red">*</font>Identify/Passport No.</td>
		<td class="infoData" width="30%" valign="top">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="docNo" class="touppercase" value="<%=docNo==null?"":docNo %>" maxlength="20" size="25"<%if (createAction) {%> onblur="checkPatientID(this);"<%} %>><span id="verifyPatientID_indicator"></span> (max 20 characters)
<%	} else { %>
			<%=docNo==null?"":docNo %>
			<input type="hidden" name="docNo" value="<%=docNo %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="4">Baby's Father Information</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.lastName" /></td>
		<td class="infoData" width="30%">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="kinLastName" class="touppercase" value="<%=kinLastName==null?"":kinLastName %>" maxlength="20" size="25">
<%	} else { %>
			<%=kinLastName==null?"":kinLastName %>
			<input type="hidden" name="kinLastName" value="<%=kinLastName %>">
<%	} %>
		</td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.firstName" /></td>
		<td class="infoData" width="30%">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="kinFirstName" class="touppercase" value="<%=kinFirstName==null?"":kinFirstName %>" maxlength="20" size="25">
<%	} else { %>
			<%=kinFirstName==null?"":kinFirstName %>
			<input type="hidden" name="kinFirstName" value="<%=kinFirstName %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.chineseName" /></td>
		<td class="infoData" width="30%">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="kinChineseName" value="<%=kinChineseName==null?"":kinChineseName %>" maxlength="30" size="25">
<%	} else { %>
			<%=kinChineseName==null?"":kinChineseName %>
			<input type="hidden" name="kinChineseName" value="<%=kinChineseName %>">
<%	} %>
		</td>
		<td class="infoLabel" width="20%">Contact No.</td>
		<td class="infoData" width="30%">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="kinContactNo" class="touppercase" value="<%=kinContactNo==null?"":kinContactNo %>" maxlength="15" size="25">
<%	} else { %>
			<%=kinContactNo==null?"":kinContactNo %>
			<input type="hidden" name="kinContactNo" value="<%=kinContactNo %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.dateOfBirth" /></td>
		<td class="infoData" width="50%" colspan="3">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="kinDOBDate" id="kinDOBDate" class="datepickerfield" value="<%=kinDOBDate==null?"":kinDOBDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else { %>
			<%=kinDOBDate==null?"":kinDOBDate %>
			<input type="hidden" name="kinDOBDate" value="<%=kinDOBDate %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Document Type</td>
		<td class="infoData" width="30%">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="radio" name="kinDocType" value="9Y"<%if ("9Y".equals(kinDocType)) { %> checked<%} %>><%=documentTypeSet.get("9Y") %></input><br/>
			<input type="radio" name="kinDocType" value="9"<%if ("9".equals(kinDocType)) { %> checked<%} %>><%=documentTypeSet.get("9") %></input><br/>
			<input type="radio" name="kinDocType" value="C"<%if ("C".equals(kinDocType)) { %> checked<%} %>><%=documentTypeSet.get("C") %></input><br/>
			<input type="radio" name="kinDocType" value="L"<%if ("L".equals(kinDocType)) { %> checked<%} %>><%=documentTypeSet.get("L") %></input><br/>
			<input type="radio" name="kinDocType" value="D"<%if ("D".equals(kinDocType)) { %> checked<%} %>><%=documentTypeSet.get("D") %></input>
<%	} else { %>
			<%=kinDocType == null || kinDocType.length() == 0 ? "Empty" : documentTypeSet.get(kinDocType) %>
			<input type="hidden" name="kinDocType" value="<%=kinDocType %>">
<%	} %>
		</td>
		<td class="infoLabel" width="20%">Identify/Passport No.</td>
		<td class="infoData" width="30%" valign="top">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="kinDocNo" class="touppercase" value="<%=kinDocNo==null?"":kinDocNo %>" maxlength="25" size="25"> (max 25 characters)
<%	} else { %>
			<%=kinDocNo==null?"":kinDocNo %>
			<input type="hidden" name="kinDocNo" value="<%=kinDocNo %>">
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoSubTitle1" colspan="4">Other Information</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><font color="red">*</font>Prenatal Check Date</td>
		<td class="infoData" width="30%">
<%	if ((createAction && step == null) || updateAction) { %>
			#1 <input type="textfield" name="checkedDate1" id="checkedDate1" class="datepickerfield" value="<%=checkedDate1==null?"":checkedDate1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)<br/>
			#2 <input type="textfield" name="checkedDate2" id="checkedDate2" class="datepickerfield" value="<%=checkedDate2==null?"":checkedDate2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)<br/>
			#3 <input type="textfield" name="checkedDate3" id="checkedDate3" class="datepickerfield" value="<%=checkedDate3==null?"":checkedDate3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)<br/>
			#4 <input type="textfield" name="checkedDate4" id="checkedDate4" class="datepickerfield" value="<%=checkedDate4==null?"":checkedDate4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)<br/>
			#5 <input type="textfield" name="checkedDate5" id="checkedDate5" class="datepickerfield" value="<%=checkedDate5==null?"":checkedDate5 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
<%	} else { %>
			#1 <%=checkedDate1==null||checkedDate1.length()==0?"Empty":checkedDate1 %><br/>
			#2 <%=checkedDate2==null||checkedDate2.length()==0?"Empty":checkedDate2 %><br/>
			#3 <%=checkedDate3==null||checkedDate3.length()==0?"Empty":checkedDate3 %><br/>
			#4 <%=checkedDate4==null||checkedDate4.length()==0?"Empty":checkedDate4 %><br/>
			#5 <%=checkedDate5==null||checkedDate5.length()==0?"Empty":checkedDate5 %>
			<input type="hidden" name="checkedDate1" value="<%=checkedDate1 %>">
			<input type="hidden" name="checkedDate2" value="<%=checkedDate2 %>">
			<input type="hidden" name="checkedDate3" value="<%=checkedDate3 %>">
			<input type="hidden" name="checkedDate4" value="<%=checkedDate4 %>">
			<input type="hidden" name="checkedDate5" value="<%=checkedDate5 %>">
<%	} %>
		</td>
		<td class="infoLabel" width="20%">Lab Result Ready (Yes/No)</td>
		<td class="infoData" width="30%" valign="top">
<%	if ((createAction && step == null) || updateAction) { %>
			<input type="radio" name="labResultReady" value="Y"<%if ("Y".equals(labResultReady)) { %> checked<%} %>>Yes</input>
			<input type="radio" name="labResultReady" value="N"<%if ("N".equals(labResultReady)) { %> checked<%} %>>No</input>
<%	} else { %>
			<%="Y".equals(labResultReady)?"Yes":"No" %>
			<input type="hidden" name="labResultReady" value="<%=labResultReady %>">
<%	} %>
		</td>
	</tr>
<%	if (!isDoctor) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.remarks" /></td>
		<td class="infoData" width="50%" colspan="3">
<%		if ((createAction && step == null) || updateAction) { %>
			<input type="textfield" name="pboRemark" class="touppercase" value="<%=pboRemark==null?"":pboRemark %>" maxlength="50" size="107">
<%		} else { %>
			<%=pboRemark==null?"":pboRemark %>
			<input type="hidden" name="pboRemark" value="<%=pboRemark==null?"":pboRemark %>">
<%		} %>
		</td>
	</tr>
<%	} else { %>
		<input type="hidden" name="pboRemark" value="">
<%	} %>
<%	if (deleteAction || "X".equals(status)) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Cancel Reason</td>
		<td class="infoData" width="80%" colspan="3">
<%	if (deleteAction) { %>
			<select name="reason">
				<option value="Miscarriage">Miscarriage</option>
				<option value="Early Birth">Early Birth</option>
				<option vlaue="others">Others</option>
			</select>
<%	} else { %>
			<%=reason==null?"":reason %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.attachment" /></td>
		<td class="infoData" width="80%" colspan="3">
<%		if (deleteAction || attachAction) {%>
		<input type="file" name="regForm" size="50" class="multi" maxlength="10">
<%		} %>
		<span id="showDocument_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="obbooking" />
	<jsp:param name="keyID" value="<%=obbookingID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
		</span>
		</td>
	</tr>
<%	} %>
<%	if (expiryDate != null && expiryDate.length() > 0) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Tentative Expiry Booking</td>
		<td class="infoData" width="80%" colspan="3"><%=expiryDate %></td>
	</tr>
<%	} %>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="80%" colspan="3">
			<%=(String) statusHashSet.get(status) %>
			<input type="hidden" name="status" value="<%=status %>">
		</td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction || attachAction || updateEDCAction) { %>
<%		if (createAction) { %>
<%			if (step == null) { %>
			<button onclick="return submitAction('create', 0);" class="btn-click">Preview OB Booking</button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
<%			} else { %>
<%				if (errorMessage != null && errorMessage.length() > 0) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click">Submit Waiting List Booking</button>
<%				} else { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click">Submit OB Booking</button>
<%				} %>
			<button onclick="return submitAction('create', '');" class="btn-click">Edit</button>
<%			} %>
<%		} else if (updateEDCAction) { %>
			<button onclick="return submitAction('updateEDC', 1);" class="btn-click">Update EDC</button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
<%		} else { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
<%		} %>
<%	} else if ("B".equals(status) || "T".equals(status) || "W".equals(status)) { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="button.update" /></button>
<!--
<%		if (isAllowCancel) { %>
<%			if ("B".equals(status)) { %>
			<button onclick="return submitAction('delete', 0);" class="btn-click">Cancel OB Booking</button>
<%			} else if ("W".equals(status)) { %>
			<button class="btn-delete">Cancel Waiting List Booking</button>
<%			}  %>
<%		}  %>
-->
<%		if ("B".equals(status)) { %>
			<button onclick="return confirmationLetter();" class="btn-click">Confirmation Letter</button>
<%		}  %>
<%	} else if ("X".equals(status)) { %>
			<button onclick="return submitAction('attach', 0);" class="btn-click"><bean:message key="prompt.attachment" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command"/>
<input type="hidden" name="step"/>
<input type="hidden" name="obbookingID" value="<%=obbookingID==null?"":obbookingID %>"/>
<input type="hidden" name="pbpID" value="<%=pbpID==null?"":pbpID %>"/>
<input type="hidden" name="doctorName" value="<%=doctorName==null?"":doctorName %>"/>
<input type="hidden" name="source" value="<%=source %>">
<span id="showAdmission_indicator"></span>
</form>
<script language="javascript">
<!--
	var isPatientIDOK = 'OK';
	var oldPatNo = '';

	$(document).ready(function() {
		$('#expectedDeliveryDate').datepicker({
			dateFormat: 'dd/mm/yy',
			showOn: "button",
			buttonImage: "../images/calendar.jpg",
			buttonImageOnly: true,
			onSelect: function(dateText, inst) {
				$("#ui-datepicker-div").hide();
				checkEDC(document.form1.expectedDeliveryDate);
			}
		});
	});

	function submitAction(cmd, stp) {
<%	if (step == null && (createAction || updateAction)) { %>
		if (cmd == 'create') {
			checkPatientID(document.form1.docNo);

			if (document.form1.expectedDeliveryDate.value == '') {
				alert("Empty expected confinement date.");
				document.form1.expectedDeliveryDate.focus();
				return false;
			}
		}
		if (cmd == 'create' || cmd == 'update') {
			if (!validDate(document.form1.expectedDeliveryDate)) {
				alert("Invalid expected confinement date.");
				document.form1.expectedDeliveryDate.focus();
				return false;
			}
			if (document.form1.expectedDeliveryDate.value.substring(6, 10) < '<%=DateTimeUtil.getCurrentYear() %>') {
				alert("Cannot back date expected confinement date.");
				document.form1.docType[0].focus();
				return false;
			}
			if (document.form1.lastName.value == '') {
				alert("<bean:message key="error.lastName.required" />.");
				document.form1.lastName.focus();
				return false;
			}
			if (document.form1.firstName.value == '') {
				alert("<bean:message key="error.firstName.required" />.");
				document.form1.firstName.focus();
				return false;
			}
			if (document.form1.DOBDate.value == '') {
				alert("<bean:message key="error.dateOfBirth.required" />.");
				document.form1.DOBDate.focus();
				return false;
			}
			if (!validDate(document.form1.DOBDate)) {
				alert("<bean:message key="error.dateOfBirth.invalid" />.");
				document.form1.DOBDate.focus();
				return false;
			}
			if (!document.form1.docType[0].checked && !document.form1.docType[1].checked
					&& !document.form1.docType[2].checked && !document.form1.docType[3].checked && !document.form1.docType[4].checked) {
				alert("Empty Document Type.");
				document.form1.docType[0].focus();
				return false;
			}
			if (document.form1.expectedDeliveryDate.value.length == 10 && eval(document.form1.expectedDeliveryDate.value.substring(6, 10)) > 2012) {
				if (
						(document.form1.docType[1].checked || document.form1.docType[2].checked || document.form1.docType[3].checked)
						&&
						(document.form1.kinDocType[2].checked || document.form1.kinDocType[3].checked)
					) {
					alert("Sorry, baby's father must have Hong Kong ID for China/Macau patient.\nPlease contact hotline at 3651 8740 if your have any question.");
					document.form1.docType[0].focus();
					return false;
				}
			}
			if (document.form1.docNo.value == '') {
				alert("Empty Identify/Passport No.");
				document.form1.docNo.focus();
				return false;
			}
			if (isPatientIDOK != 'OK') {
				alert("Identify/Passport No. is already used in other booking");
				document.form1.docNo.focus();
				return false;
			}
			if (document.form1.checkedDate1.value == '') {
				alert("Empty Prenatal Check Date.");
				document.form1.checkedDate1.focus();
				return false;
			}
		}
<%	} %>
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}

	function checkEDC(obj) {
		$("#showQuota_indicator").html("Loading..");

		if (validDate(obj)) {
			$.ajax({
				type: "POST",
				url: "ob_booking_quota.jsp",
<%	if (isDoctor) { %>
				data: 'doctorCode=<%=doctorCode %>&expectedDeliveryDate=' + obj.value,

<%	} else { %>
				data: 'doctorCode=' + document.form1.doctorCode.value + '&expectedDeliveryDate=' + obj.value,
<%	} %>
				async: false,
				success: function(values){
//				if (values != '') {
					$("#showQuota_indicator").html(values);
//				}//if
				}//success
			});//$.ajax
			return true;
		} else {
			$("#showQuota_indicator").html("Invalid EDC");

			return false;
		}
	}

	function confirmationLetter() {
		callPopUpWindow("ob_booking_letter.jsp?pbpID=<%=pbpID %>");
		return false;
	}

	function removeDocument(did) {
		$.ajax({
			type: "POST",
			url: "../common/document_list.jsp",
			data: "command=delete&moduleCode=obbooking&keyID=<%=obbookingID %>&documentID=" + did + "&allowRemove=<%=allowRemove %>",
			success: function(values){
			if(values != '') {
				$("#showDocument_indicator").html(values);
			}//if
			}//success
		});//$.ajax
	}

	function checkPatientNo(obj) {
		var patno = obj.value;

		if (patno.length > 0 && patno != oldPatNo) {
			oldPatNo = patno;
			$.ajax({
				type: "POST",
				url: "../registration/admission_hats.jsp",
				data: "patno=" + patno,
				success: function(values){
				if(values != '') {
					$("#showAdmission_indicator").html(values);
					// retrieve patno
					if (values.substring(0, 1) == 1) {
						alert('Retrieve Info取得資料!');
						document.form1.lastName.value = document.form1.hats_patfname.value;
						document.form1.firstName.value = document.form1.hats_patgname.value;
						document.form1.chineseName.value = document.form1.hats_patcname.value;
						document.form1.contactNo.value = document.form1.hats_patmtel.value;
						document.form1.DOBDate.value = document.form1.hats_patbdate.value;
						document.form1.docNo.value = document.form1.hats_patidno.value;
						document.form1.kinLastName.value = document.form1.hats_patkfname1.value;
						document.form1.kinFirstName.value = document.form1.hats_patkgname1.value;
						document.form1.kinContactNo.value = document.form1.hats_patkmtel1.value;
					}
				}//if
				}//success
			});//$.ajax
		}
		return false;
	}

	function checkPatientID(obj) {
		var patid = obj.value;

		if (patid.length > 0) {
			$.ajax({
				type: "POST",
				url: "ob_check_id.jsp",
				data: "patientID=" + patid,
				success: function(values){
				if(values != '') {
					isPatientIDOK = values;
					if(values == 'OK') {
						$("#verifyPatientID_indicator").html("<img src='../images/tick_green_small.gif'>");
					} else {
						$("#verifyPatientID_indicator").html("<img src='../images/cross_red_small.gif'>");
					}
				}//if
				}//success
			});//$.ajax
		}
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>