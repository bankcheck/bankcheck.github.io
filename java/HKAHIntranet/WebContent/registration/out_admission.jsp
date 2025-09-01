<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
boolean fileUpload = false;
if (HttpFileUpload.isMultipartContent(request)) {
	HttpFileUpload.toUploadFolder(
		request,
		ConstantsServerSide.DOCUMENT_FOLDER,
		ConstantsServerSide.TEMP_FOLDER,
		ConstantsServerSide.UPLOAD_FOLDER
	);
	fileUpload = true;
}

UserBean userBean = new UserBean(request);
String sessionKey = ParserUtil.getParameter(request, "session");

String command = ParserUtil.getParameter(request, "command");
String admissionID = ParserUtil.getParameter(request, "admissionID");
String step = ParserUtil.getParameter(request, "step");
String language = ParserUtil.getParameter(request, "language");
//start
String patno = ParserUtil.getParameter(request,"patno");
String newPatno = ParserUtil.getParameter(request, "newPatno");

String appointmentDate = ParserUtil.getParameter(request, "appointmentDate");
String appointmentTime = ParserUtil.getTime(request, "appointmentTime");
String actualAppointmentDate = ParserUtil.getParameter(request, "actualAppointmentDate");
String actualAppointmentTime = ParserUtil.getTime(request, "actualAppointmentTime");
String attendDoctor = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "attendDoctor"));

String patidno = null;
String patidno1 = TextUtil.parseStr(ParserUtil.getParameter(request,"patidno1")).toUpperCase();
String patidno2 = TextUtil.parseStr(ParserUtil.getParameter(request,"patidno2")).toUpperCase();
String patpassport = TextUtil.parseStr(ParserUtil.getParameter(request,"patpassport")).toUpperCase();
String pattraveldoc = TextUtil.parseStr(ParserUtil.getParameter(request,"pattraveldoc")).toUpperCase();
String patbdate = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patbdate"));
String patfname = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patfname"))==null?"":TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patfname")).toUpperCase();
String patgname = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patgname"))==null?"":TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patgname")).toUpperCase();
String titleDesc = ParserUtil.getParameter(request,"titleDesc");
String titleDescOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"titleDescOther"));
String patcname = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patcname"));
String patsex = ParserUtil.getParameter(request,"patsex");
String racedesc = ParserUtil.getParameter(request,"racedesc");
String racedescOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"racedescOther"));
String religion = ParserUtil.getParameter(request,"religion");
String religionOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"religionOther"));
String patmsts = ParserUtil.getParameter(request,"patmsts");
String patmstsOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patmstsOther"));
String mothcode = ParserUtil.getParameter(request,"mothcode");
String edulevel = ParserUtil.getParameter(request,"edulevel");
String edulevelOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"edulevelOther"));
String pathtel = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"pathtel"));
String patotel = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patotel"));
String patmtel = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patmtel"));
String patftel = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patftel"));
String occupation = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"occupation"));
String patemail = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patemail"));
if (patemail == null || "".equals(patemail)) {
	if (sessionKey != null && !"".equals(sessionKey)) {
		patemail = SessionLoginDB.getSessionEmail(sessionKey);
	}
}
String patadd1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patadd1"));
String patadd2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patadd2"));
String patadd3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patadd3"));
String patadd4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patadd4"));
String coucode = ParserUtil.getParameter(request,"coucode");
String coudesc = null;

String patkfname1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkfname1"));
String patkgname1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkgname1"));
String patkcname1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkcname1"));
String patkrela1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkrela1"));
String patkhtel1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkhtel1"));
String patkotel1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkotel1"));
String patkmtel1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkmtel1"));
String patkemail1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkemail1"));
String patkadd11 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkadd11"));
String patkadd21 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkadd21"));
String patkadd31 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkadd31"));
String patkadd41 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkadd41"));
String patkTitleDesc1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkTitleDesc1"));
String patkTitleDescOther1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkTitleDescOther1"));
String patkcoucode1 = ParserUtil.getParameter(request,"patkcoucode1");
String patkcoudesc1 = null;

String patkfname2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkfname2"));
String patkgname2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkgname2"));
String patkcname2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkcname2"));
String patkrela2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkrela2"));
String patkhtel2 = ParserUtil.getParameter(request,"patkhtel2");
String patkotel2 = ParserUtil.getParameter(request,"patkotel2");
String patkmtel2 = ParserUtil.getParameter(request,"patkmtel2");
String patkemail2 = ParserUtil.getParameter(request,"patkemail2");
String patkadd12 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkadd12"));
String patkadd22 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkadd22"));
String patkadd32 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkadd32"));
String patkadd42 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkadd42"));
String patkTitleDesc2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkTitleDesc2"));
String patkTitleDescOther2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patkTitleDescOther2"));
String patkcoucode2 = ParserUtil.getParameter(request,"patkcoucode2");
String patkcoudesc2 = null;

String patHowInfo = ParserUtil.getParameter(request,"patHowInfo");
String patHowInfoOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request,"patHowInfoOther"));

String promotionYN = ParserUtil.getParameter(request,"promotionYN");

String reached = ParserUtil.getParameter(request, "reached");
String registered = ParserUtil.getParameter(request, "registered");
String  firstViewUser = null;
String firstViewDate = null;
String confirmDate = null;
String remarks = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remarks"));
String[] unselectedImtInfo = null;
//end

String hatCompleted = null;
if (fileUpload) {
	// create new record
	if ("create".equals(command) && "1".equals(step)) {
		// get admission id with dummy data
		admissionID = AdmissionDB.addOutPatient(userBean);
	}



	StringBuffer tempStrBuffer = new StringBuffer();
	tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
	tempStrBuffer.append(File.separator);
	tempStrBuffer.append("Admission at ward");
	tempStrBuffer.append(File.separator);
	tempStrBuffer.append(admissionID);
	tempStrBuffer.append(File.separator);
	String baseUrl = tempStrBuffer.toString();

	// upload from admission page
	String[] fileList = (String[]) request.getAttribute("filelist");
	if (fileList != null && fileList.length > 0) {
		for (int i = 0; i < fileList.length; i++) {
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + fileList[i]
			);
			AdmissionDB.insertDocument(userBean, admissionID, fileList[i]);
		}
	}

	// upload from client page
	fileList = (String[]) request.getAttribute("client.filelist_StringArray");
	if (fileList != null && fileList.length > 0) {
		for (int i = 0; i < fileList.length; i++) {
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + fileList[i]
			);
			AdmissionDB.insertDocument(userBean, admissionID, fileList[i]);
		}
	}
}

if (patidno1 != null && patidno2 != null) {
	patidno = patidno1 + patidno2;
}

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean createHATSAction = false;
boolean updateHATSAction = false;
boolean confirmEmailAction = false;
boolean updatePatNoAction = false;
boolean closeAction = false;
boolean forwardAction = false;
boolean updateCompleteAction = false;

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");
unselectedImtInfo = (String[]) request.getAttribute("unselectedInfo_StringArray");

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("createHATS".equals(command)) {
	createHATSAction = true;
} else if ("updateHATS".equals(command)) {
	updateHATSAction = true;
} else if ("confirmEmail".equals(command)) {
	confirmEmailAction = true;
} else if ("updatePatNo".equals(command)) {
	updatePatNoAction = true;
} else if("updateComplete".equals(command)){
	updateCompleteAction = true;
}

// check user right
try {
	if ("1".equals(step)) {
		if (createAction || updateAction) {
			// create new record
			if (createAction && admissionID == null) {
				// get admission id with dummy data
				admissionID = AdmissionDB.addOutPatient(userBean);
			}
			
			String newExpectedAppointmentDate = appointmentDate + " " + appointmentTime;
			String newActualAppointmentDate = null;
			if (actualAppointmentDate != null && actualAppointmentDate.length() > 0 && actualAppointmentTime != null) {
				newActualAppointmentDate = actualAppointmentDate + " " + actualAppointmentTime;
			}
				
			if (sessionKey != null) {
				registered = "Email";
			}
			
			if(patno != null && "null".equals(patno)){
				patno = null;
			}
			if (AdmissionDB.updateOutPatient(userBean, admissionID, patno,
					patfname, patgname, patcname, titleDesc, titleDescOther,
					patidno, patpassport, pattraveldoc,
					patsex, racedesc, racedescOther, religion, religionOther,
					patbdate, patmsts, patmstsOther, mothcode, edulevel, edulevelOther,
					pathtel, patotel, patmtel, patftel,
					occupation, patemail,
					patadd1, patadd2, patadd3, patadd4, coucode,
					patkfname1, patkgname1, patkcname1, patkrela1,
					patkhtel1, patkotel1, patkmtel1, 
					patkemail1, patkadd11, patkadd21, patkadd31, patkadd41,
					patkTitleDesc1 ,patkTitleDescOther1, patkcoucode1,
					patkfname2, patkgname2, patkcname2,  patkrela2,
					patkhtel2, patkotel2, patkmtel2,
					patkemail2, patkadd12, patkadd22, patkadd32, patkadd42,
					patkTitleDesc2 ,patkTitleDescOther2, patkcoucode2,
					promotionYN,remarks, sessionKey, registered, reached, 
					newExpectedAppointmentDate, newActualAppointmentDate, attendDoctor, patHowInfo, patHowInfoOther)) {
					System.out.println("DEBUG: out_admission.jsp(224) createAction = " + createAction);
				if (createAction) {
					// send email notify
					if (unselectedImtInfo != null) {
						for(int i=0;i<unselectedImtInfo.length;i++) {
							AdmissionDB.addunselectImpInfo(userBean,unselectedImtInfo[i],admissionID);
						}
						AdmissionDB.updateHasImtInfo(admissionID);
					}

					AdmissionDB.sendEmailNotifyStaff(admissionID,"out");

					// update sessionKey
					if (sessionKey != null && sessionKey.length() > 0) {
						SessionLoginDB.delete(userBean, sessionKey);
					}

					// page forward
					if (admissionID != null && !userBean.isLogin()) {
						// email auto notify client
						AdmissionDB.sendEmailAutoNotifyClient(admissionID, patemail, "out");

						%><jsp:forward page="online_admission_submit.jsp">
									<jsp:param name="language" value="<%=language %>" />
									<jsp:param name="admissionID" value="<%=admissionID %>" />
									<jsp:param name="type" value="OPD" />
						  </jsp:forward>
						<%
					}
					message = "Out Patient Registration created.";
				} else {
					message = "Out Patient Registration updated.";
				}
				createAction = false;
				updateAction = false;
				command = null;
			} else {
				if (createAction) {
					// page forward
					if (admissionID != null && !userBean.isLogin()) {
						forwardAction = true;
						message = "Fail to register online, please try again!";
					} else {
						errorMessage = "Out Patient Registration create fail.";
					}
				} else {
					errorMessage = "Out Patient Registration update fail.";
				}
			}
		} else if (deleteAction) {
			if (AdmissionDB.delete(userBean, admissionID)) {
				message = "Out Patient Registration removed.";
			} else {
				errorMessage = "Out Patient Registration remove fail.";
			}
		} else if (createHATSAction) {
			ArrayList record = AdmissionDB.get(admissionID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				patidno = row.getValue(7);
				patpassport = row.getValue(8);
				pattraveldoc = row.getValue(9);
				patbdate = row.getValue(15);
			}
			if (patidno != null && patidno.length() > 0) {
				record = AdmissionDB.getHATSPatient(null, patidno, patbdate);
			} else if (patpassport != null && patpassport.length() > 0) {
				record = AdmissionDB.getHATSPatient(null, patpassport, patbdate);
			} else if (pattraveldoc != null && pattraveldoc.length() > 0){
				record = AdmissionDB.getHATSPatient(null, pattraveldoc, patbdate);
			}
			if (record.size() > 0) {
				errorMessage = "patient id and date of birth already exist in HATS.";
			} else {
				if (AdmissionDB.addHATS(userBean, admissionID)) {
					message = "Out Patient Registration created in HATS.";
				} else {
					errorMessage = "HATS is currently busy. Create Entry in HATS Fail.";
				}
			}
		} else if (updateHATSAction) {
			if (AdmissionDB.updateHATS(userBean, admissionID)) {
				message = "Out Patient Registration updated in HATS.";
			} else {
				errorMessage = "Out Patient Registration update fail in HATS.";
			}
		} else if (confirmEmailAction) {
			if (AdmissionDB.sendEmailConfirmClient(userBean, admissionID, "out")) {
				message = "confirm email sent to client.";
			} else {
				errorMessage = "confirm email fail to send to client.";
			}
		} else if (updatePatNoAction) {
			if (newPatno != null && AdmissionDB.updatePatNo(userBean, newPatno, admissionID)) {
				message = "patient number is updated.";
			} else {
				errorMessage = "patient number is fail to update.";
			}
		} else if (updateCompleteAction) {
			if (AdmissionDB.updateCompleteToHATSPatient(userBean, admissionID)) {				
				message = "Out Patient Registration completed.";
			} else {
				errorMessage = "Out Patient Registration fail to complete.";
			}
		}
		step = null;
	} else {
		
		coucode = "852";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (admissionID != null && admissionID.length() > 0) {
			ArrayList record = AdmissionDB.get(admissionID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				
				patno = row.getValue(1);
				patfname = row.getValue(2);
				patgname = row.getValue(3);
				patcname = row.getValue(4);
				titleDesc = row.getValue(5);
				titleDescOther = row.getValue(6);

				patidno = row.getValue(7);
				if (patidno.length() > 7) {
					int tempIDLastNo = patidno.length() - 1;
					patidno1 = patidno.substring(0, tempIDLastNo);
					patidno2 = patidno.substring(tempIDLastNo);
				} else {
					patidno1 = patidno;
					patidno2 = "";
				}
				patpassport = row.getValue(8);				
				pattraveldoc = row.getValue(9);
				
				patsex = row.getValue(10);
				racedesc = row.getValue(11);
				racedescOther = row.getValue(12);
				religion = row.getValue(13);
				religionOther = row.getValue(14);

				patbdate = row.getValue(15);
				patmsts = row.getValue(16);
				patmstsOther = row.getValue(88);
				mothcode = row.getValue(17);
				
				edulevel = row.getValue(19);
				edulevelOther = row.getValue(89);
				pathtel = row.getValue(20);
				patotel = row.getValue(21);
				patmtel = row.getValue(22);
				patftel = row.getValue(23);

				occupation = row.getValue(24);
				patemail = row.getValue(25);
				patadd1 = row.getValue(26);
				patadd2 = row.getValue(27);
				patadd3 = row.getValue(28);
				patadd4 = row.getValue(29);
				coucode = row.getValue(30);
				coudesc = row.getValue(31);

				patkfname1 = row.getValue(32);
				patkgname1 = row.getValue(33);
				patkcname1 = row.getValue(34);				
				patkrela1 = row.getValue(36);
				patkhtel1 = row.getValue(37);
				patkotel1 = row.getValue(38);
				patkmtel1 = row.getValue(39);
				patkemail1 = row.getValue(41);
				patkadd11 = row.getValue(42);
				patkadd21 = row.getValue(43);
				patkadd31 = row.getValue(44);
				patkadd41 = row.getValue(45);
				patkcoucode1 = row.getValue(84);
				patkcoudesc1 = row.getValue(85);
				patkTitleDesc1 = row.getValue(90);				
				patkTitleDescOther1 = row.getValue(91);
				
				patkfname2 = row.getValue(46);
				patkgname2 = row.getValue(47);
				patkcname2 = row.getValue(48);				
				patkrela2 = row.getValue(50);
				patkhtel2 = row.getValue(51);
				patkotel2 = row.getValue(52);
				patkmtel2 = row.getValue(53);				
				patkemail2 = row.getValue(55);
				patkadd12 = row.getValue(56);
				patkadd22 = row.getValue(57);
				patkadd32 = row.getValue(58);
				patkadd42 = row.getValue(59);
				patkcoucode2 = row.getValue(86);
				patkcoudesc2 = row.getValue(87);
				patkTitleDesc2 = row.getValue(92);
				patkTitleDescOther2 = row.getValue(93);
				
				appointmentDate = row.getValue(60);
				appointmentTime = row.getValue(61);
				actualAppointmentDate = row.getValue(62);
				actualAppointmentTime = row.getValue(63);
				attendDoctor = row.getValue(64);
				
				promotionYN = row.getValue(68);
				confirmDate = row.getValue(75);
				remarks = row.getValue(76);
				reached = row.getValue(80);
				registered = row.getValue(81);
				firstViewUser = row.getValue(82);
				firstViewDate = row.getValue(83);
				
				hatCompleted = row.getValue(94);
				
				patHowInfo = row.getValue(95);
				patHowInfoOther = row.getValue(96);

				if (firstViewUser ==null || "".equals(firstViewUser)) {
					if (!"".equals(userBean.getStaffID())|| userBean.getStaffID()!=null) {
						AdmissionDB.updateHATFirstUserDate(userBean,admissionID);
					}
				} else if ("admin".equals(firstViewUser) || "SYSTEM".equals(firstViewUser)) {
					AdmissionDB.updateHATFirstUserDate(userBean,admissionID);
				}
				
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

// set null to empty
if (admissionID == null) { admissionID = ConstantsVariable.EMPTY_VALUE; };

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<style type="text/css">
table.sample {
	border-width: 1px;
	border-spacing: 2px;
	border-style: outset;
	border-color: gray;
	border-collapse: collapse;
}
table.sample th {
	border-width: 1px;
	padding: 1px;
	border-style: inset;
	border-color: gray;
	background-color: white;
	-moz-border-radius: ;
}
table.sample td {
	border-width: 1px;
	padding: 3px;
	border-style: inset;
	border-color: gray;
	background-color: white;
	-moz-border-radius: ;
}
</style>
<jsp:include page="../common/header.jsp"/>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else if (forwardAction) { %>
<script language="javascript">
<!--//
	alert("<%=message %>");
	javascript:history.go(-1);
//-->
</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.out.registration." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td align="right">
<%			if (!createAction && !updateAction) { %>
<a href="javascript:void(0);" onclick="return printReceipt('pdfAction', '<%=admissionID %>');">Printer Friendly Version</a><br />
<%			} %>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td><font color="red">*</font>Please fill in the form 請填寫有關資料.</td>
	</tr>
</table>
<form name="form1" enctype="multipart/form-data" action="out_admission.jsp" method="post">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3" height="25" bgcolor="#AA3D01">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="white"><strong>Hospital Information 醫院資料</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr >
		<td height="40" valign="top" bgcolor="#F9F9F9" colspan="3">Hospital No. (Office Use Only 辦公室專用)<br />醫院編號
<%		if (createAction || updateAction) { %>
			<input type="text" name="patno" value="<%=patno==null?"":patno %>" maxlength="10" size="20" onblur="checkPatNo(this);">
<%		} else { %>
			<button type='button' onclick="return submitAction('viewHATS', 1);" class="btn-click"><span class="infoResult"><%=patno==null?"":patno %></span></button>
<%		} %>
<%		if (admissionID != null && admissionID.length() > 0) { %>
<%			if (patno == null || patno.length() == 0 || "-1".equals(patno) ) { %>
			<button type='button' onclick="return submitAction('createHATS', 1);" class="btn-click">Generate New Hospital No. to HATS</button><br />
			<font color="red">Possible Hospital No. 可能的醫院編號</font><br />

<table cellpadding="5" class="sample">
<jsp:include page="out_admission_hats_list.jsp" flush="false">
	<jsp:param name="patidno" value="<%=patidno %>" />
	<jsp:param name="patpassport" value="<%=patpassport %>" />
	<jsp:param name="pattraveldoc" value="<%=pattraveldoc %>" />
	<jsp:param name="patbdate" value="<%=patbdate %>" />
	<jsp:param name="patFName" value="<%=patfname %>" />
	<jsp:param name="patGName" value="<%=patgname %>" />
	<jsp:param name="pathtel" value="<%=pathtel %>" />
	<jsp:param name="patmtel" value="<%=patmtel %>" />
	<jsp:param name="patemail" value="<%=patemail %>" />
</jsp:include>
</table>

<%			} else { %>
<%				if (createAction || updateAction) { %>
			<button type='button' onclick="return checkHATS('');" class="btn-click">Check with HATS</button>
<%				} %>
			<button type='button' onclick="return submitAction('updateHATS', 1);" class="btn-click">Update to HATS</button>
<%			} %>


<%		} %>

<%			if("1".equals(hatCompleted)){%>
				<div style='float:right'>Completed</div>			
<%			}else{%>
				<button style='float:right;' type='button' onclick="return submitAction('updateComplete', 1);" class="btn-click">Complete</button>				
<%			}	%>					
		</td>		
	</tr>
	
	
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Appointment date & time (DD 日/MM 月/YYYY 年/HH 時: MM 分)<br />預約日期
<%	if (createAction || updateAction) { %>
			<input type="text" name="appointmentDate" id="appointmentDate" class="datepickerfield" value="<%=appointmentDate==null?"":appointmentDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="appointmentTime" />
	<jsp:param name="time" value="<%=appointmentTime %>" />
</jsp:include>
<%	} else { %>
			<span class="infoResult"><%=appointmentDate==null?"":appointmentDate %></span>
			<span class="infoResult"><%=appointmentTime==null?"":appointmentTime %></span>
<%	} %>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Attending Doctor<br />主診醫生
<%	if (createAction || updateAction) { %>			
			<select name="attendDoctor">
				<option value=""></option>
				<jsp:include page="../ui/docCodeCMB.jsp" flush="false">
					<jsp:param name="selectFrom" value="Pre-addmission" />
					<jsp:param name="doccode" value="<%=attendDoctor %>" />
				</jsp:include>
			</select>
<%	} else { %>
			<span class="infoResult"><%=attendDoctor==null?"":(AdmissionDB.getDocName(attendDoctor)==null?attendDoctor:AdmissionDB.getDocName(attendDoctor)) %></span>
<%	} %>
		</td>
	</tr>
	
	
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Registered by<br />註冊自
<%	if (createAction || updateAction) { %>
			<select name="registered">
				<option value=""></option>
				<option value="Email"<%="Email".equals(registered)?" selected":"" %>>Email</option>
				<option value="Phone"<%="Phone".equals(registered)?" selected":"" %>>Phone</option>
				<option value="Web"<%="Web".equals(registered)?" selected":"" %>>Web</option>
			</select>
<%	} else { %>
			<span class="infoResult"><%=registered==null?"":registered %></span>
<%	} %>
		</td>
	</tr>	
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	
<%	if (!createAction) { %>
	<tr>
		<td height="40" colspan="3" valign="top" bgcolor="#F9F9F9">Remarks<br />註解&nbsp;&nbsp;eg.Check I.D.
<%		if (createAction || updateAction) { %>
			<div class="box"><textarea id="wysiwyg" name="remarks" rows="3" cols="120"><%=remarks==null?"":remarks %></textarea></div>
<%		} else { %>
			<span class="infoResult"><%=remarks==null?"":remarks %></span><br />

			<button onclick="return submitAction('confirmEmail', 1);" class="btn-click">Send Confirm Email to Client</button>
			<%=confirmDate==null||confirmDate.length()==0?"":" Submit Email @ " + confirmDate %>

<%		} %>
		</td>
	</tr>
<%	} %>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="6" height="25" bgcolor="#AA3D01">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="white"><strong>Personal Information 個人資料</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9">
			<font color="red">*</font>
<%	if (createAction || updateAction) { %>
			<table width="100%">
				<tr>
					<td>
						<input type="radio" name="patidType" value="hkid"<%=patpassport==null||patpassport.length()==0?" checked":"" %> onclick="validHKID();">Hong Kong I.D. Card<br />香港身份證號碼
						<input type="text" name="patidno1" value="<%=patidno1==null?"":patidno1 %>" maxlength="8" size="8" onkeyup="validHKID();" onblur="validHKID()">(<input type="text" name="patidno2" value="<%=patidno2==null?"":patidno2 %>" maxlength="2" size="2" onkeyup="validHKID();" onkeydown="validDOB(event);">)
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" name="patidType" value="passport"<%=patpassport!=null&&patpassport.length()>0?" checked":"" %> onclick="validPassport();">Passport No.<br />護照號碼
						<input type="text" name="patpassport" value="<%=patpassport==null?"":patpassport %>" maxlength="20" size="25" onkeyup="validPassport();">
					</td>					
				</tr>
				<tr>
					<td>
						<input type="radio" name="patidType" value="traveldoc"<%=pattraveldoc!=null&&pattraveldoc.length()>0?" checked":"" %> onclick="validTravelDoc()"><div id="traveldoc">Travel Document No.<br />旅遊證件號碼 
						<input type="text" name="pattraveldoc" value="<%=pattraveldoc==null?"":pattraveldoc %>" maxlength="20" size="25" onkeyup="validTravelDoc()">				
					</td>
				</tr>
				<tr>
					<td height="20">&nbsp;</td>
				</tr>
				<tr>
					<td>
						Please Attach or Fax Copy of HKID / Passport / Travel Document for Verification Purpose<br />
						<font color="red">**</font>請附上或傳真身份證明/護照文件/旅遊證件以作核對<br />
						<input type="file" name="file1" size="30" class="multi" maxlength="5"><br />
						<font color="red">**</font>Fax No 傳真號碼: 36518801
					</td>
				</tr>
			</table>
<%	} else { %>
			Hong Kong I.D. Card<br />香港身份證號碼 <span class="infoResult"><%=patidno1==null?"":patidno1 %>(<%=patidno2==null?"":patidno2 %>)</span><br /><br />
			Passport No.<br />護照號碼 <span class="infoResult"><%=patpassport==null?"":patpassport %></span><br /><br />
			Travel Document No.<br />旅遊證件號碼<span class="infoResult"><%=pattraveldoc==null?"":pattraveldoc %></span>
<%	} %>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Date of Birth (DD 日/MM 月/YYYY 年)<br />出生日期
<%	if (createAction || updateAction) { %>
			<input type="text" name="patbdate" id="patbdate" class="datepickerfield" value="<%=patbdate==null?"":patbdate %>" maxlength="10" size="10" onkeyup="validDate(this)" ">
<%	} else { %>
			<span class="infoResult"><%=patbdate==null?"":patbdate %></span>
<%	} %>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Family Name as on I.D. Card/Passport<br />姓 (英文)
<%	if (createAction || updateAction) { %>
			<input type="text" name="patfname" value="<%=patfname==null?"":patfname %>" maxlength="20" size="20">
<%	} else { %>
			<span class="infoResult"><%=patfname==null?"":patfname %></span>
<%	} %>
			<span id="hats_patfname" class="alertText"></span>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Given Name as on I.D. Card/Passport<br />名 (英文)
<%	if (createAction || updateAction) { %>
			<input type="text" name="patgname" value="<%=patgname==null?"":patgname %>" maxlength="20" size="20">
<%	} else { %>
			<span class="infoResult"><%=patgname==null?"":patgname %></span>
<%	} %>
			<span id="hats_patgname" class="alertText"></span>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Title<br />稱謂
<%	if (createAction || updateAction) { %>
			<select name="titleDesc">
				<option value=""></option>
				<option value="MR"<%="MR".equals(titleDesc)?" selected":"" %>>Mr. 先生</option>
				<option value="MRS"<%="MRS".equals(titleDesc)?" selected":"" %>>Mrs. 太太</option>
				<option value="MISS"<%="MISS".equals(titleDesc)?" selected":"" %>>Miss 小姐</option>
				<option value="MS"<%="MS".equals(titleDesc)?" selected":"" %>>Ms. 女士</option>
				<option value="Others"<%="Others".equals(titleDesc)?" selected":"" %>>Others 其他</option>
			</select>
<%	} else { %>
			<span class="infoResult"><%=titleDesc==null?"":titleDesc %></span>
<%	} %>
			<span id="hats_titleDesc" class="alertText"></span><br />
			Others<br />其他 :
<%	if (createAction || updateAction) { %>
			<input type="text" name="titleDescOther" value="<%=titleDescOther==null?"":titleDescOther %>" maxlength="10" size="20">
<%	} else { %>
			<span class="infoResult"><%=titleDescOther==null?"":titleDescOther %></span>
<%	} %>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">Chinese Name<br />中文姓名
<%	if (createAction || updateAction) { %>
			<input type="text" name="patcname" value="<%=patcname==null?"":patcname %>" maxlength="20" size="25">
<%	} else { %>
			<span class="infoResult"><%=patcname==null?"":patcname %></span>
<%	} %>
			<span id="hats_patcname" class="alertText"></span>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Sex<br />性別
<%	if (createAction || updateAction) { %>
			<select name="patsex">
				<option value=""></option>
				<option value="M"<%="M".equals(patsex)?" selected":"" %>>M 男</option>
				<option value="F"<%="F".equals(patsex)?" selected":"" %>>F 女</option>
			</select>
<%	} else {
			if ("M".equals(patsex)) {
				%><span class="infoResult"><bean:message key="label.male" /></span><%
			} else if ("F".equals(patsex)) {
				%><span class="infoResult"><bean:message key="label.female" /></span><%
			} else {
				%><span class="infoResult">Others 其他 </span><%
			}
		} %>
			<span id="hats_patsex" class="alertText"></span>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Marital Status<br />婚姻狀況
<%	if (createAction || updateAction) { %>
			<select name="patmsts">
				<option value=""></option>
				<option value="S"<%="S".equals(patmsts)?" selected":"" %>>Single 未婚</option>
				<option value="M"<%="M".equals(patmsts)?" selected":"" %>>Married 己婚</option>
				<option value="D"<%="D".equals(patmsts)?" selected":"" %>>Divorce 離婚</option>
				<option value="X"<%="X".equals(patmsts)?" selected":"" %>>Separate 分居</option>
			</select>
<%	} else {
			if ("S".equals(patmsts)) {
				%><span class="infoResult">Single 未婚</span><%
			} else if ("M".equals(patmsts)) {
				%><span class="infoResult">Married 己婚</span><%
			} else if ("D".equals(patmsts)) {
				%><span class="infoResult">Divorce離婚 </span><%
			} else if ("X".equals(patmsts)) {
				%><span class="infoResult">Separate 分居</span><%
			} else {
				%><span class="infoResult"></span><%
			}
		} %>
			<span id="hats_patmsts" class="alertText"></span><br/>
		Others<br />其他 :
<%	if (createAction || updateAction) { %>
			<input type="text" name="patmstsOther" value="<%=patmstsOther==null?"":patmstsOther %>" maxlength="10" size="20">
<%	} else { %>
			<span class="infoResult"><%=patmstsOther==null?"":patmstsOther %></span>
<%	} %>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Ethnic Group<br />種族
<%	if (createAction || updateAction) { %>
			<select name="racedesc">
				<option value=""></option>
<jsp:include page="../ui/raceDescCMB.jsp" flush="false">
	<jsp:param name="racedesc" value="<%=racedesc %>" />
</jsp:include>
			</select>
<%	} else { %>
			<span class="infoResult"><%=racedesc==null?"":racedesc %></span>
<%	} %>
			<span id="hats_racedesc" class="alertText"></span><br />
			Others<br />其他 :
<%	if (createAction || updateAction) { %>
			<input type="text" name="racedescOther" value="<%=racedescOther==null?"":racedescOther %>" maxlength="10" size="20" />
<%	} else { %>
			<span class="infoResult"><%=racedescOther==null?"":racedescOther %></span>
<%	} %>
			<span id="hats_racedesc" class="alertText"></span>
			<br />(For hospital statistic purpose 作為醫院統計用)
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Religion<br />宗教
<%	if (createAction || updateAction) { %>
			<select name="religion">
				<option value=""></option>				
				<option value="NO"<%="NO".equals(religion)?" selected":"" %>>None 沒有</option>
				<option value="BU"<%="BU".equals(religion)?" selected":"" %>>Buddhism 佛教</option>
				<option value="CA"<%="CA".equals(religion)?" selected":"" %>>Catholic 天主教</option>
				<option value="CH"<%="CH".equals(religion)?" selected":"" %>>Christian 基督教</option>
				<option value="HI"<%="HI".equals(religion)?" selected":"" %>>Hinduism 印度教</option>
				<option value="SH"<%="SH".equals(religion)?" selected":"" %>>Shintoism 日本神道教</option>
				<option value="SD"<%="SD".equals(religion)?" selected":"" %>>SDA 基督復臨安息日教會</option>
				<option value="Others"<%="Others".equals(religion)?" selected":"" %>>Others 其他</option>
			</select>
<%	} else {
		if ("NO".equals(religion)) {
			%><span class="infoResult">None 沒有</span><%
		} else if ("BU".equals(religion)) {
			%><span class="infoResult">Buddhism 佛教</span><%
		} else if ("CA".equals(religion)) {
			%><span class="infoResult">Catholic天主教</span><%
		} else if ("CH".equals(religion)) {
			%><span class="infoResult">Christian基督教</span><%
		} else if ("HI".equals(religion)) {
			%><span class="infoResult">Hinduism 印度教</span><%
		} else if ("SH".equals(religion)) {
			%><span class="infoResult">Shintoism 日本神道教</span><%
		} else if ("SD".equals(religion)) {
			%><span class="infoResult">SDA 基督復臨安息日教會</span><%
		} else if ("Others".equals(religion)) {
			%><span class="infoResult">Others 其他</span><%
		} else{
			%><span class="infoResult"></span><%
		}
	}
%>
			<span id="hats_religion" class="alertText"></span><br />
			Others<br />其他 :
<%	if (createAction || updateAction) { %>
			<input type="text" name="religionOther" value="<%=religionOther==null?"":religionOther %>" />
<%	} else { %>
			<span class="infoResult"><%=religionOther==null?"":religionOther %></span>
<%	} %>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Education Level<br />教育程度
<%	if (createAction || updateAction) { %>
			<select name="edulevel">
			<option value=""></option>
				<option value="Primary"<%="Primary".equals(edulevel)?" selected":"" %>>Primary 小學</option>
				<option value="Secondary"<%="Secondary".equals(edulevel)?" selected":"" %>>Secondary 中學</option>
				<option value="Tertiary or above"<%="Tertiary or above".equals(edulevel)?" selected":"" %>>Tertiary or above 大專或以上</option>
				<option value="Others"<%="Others".equals(edulevel)?" selected":"" %>>Others 其他</option>
			</select>
<%	} else { %>
			<span class="infoResult"><%=edulevel==null?"":edulevel %></span>
<%	} %>
			<span id="hats_edulevel" class="alertText"></span><br />
			Others<br />其他 :
<%	if (createAction || updateAction) { %>
			<input type="text" name="edulevelOther" value="<%=edulevelOther==null?"":edulevelOther %>" />
<%	} else { %>
			<span class="infoResult"><%=edulevelOther==null?"":edulevelOther %></span>
<%	} %>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="2" colspan="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Written Language<br />語言
<%	if (createAction || updateAction) { %>
			<select name="mothcode">
				<option value=""></option>
				<option value="ENG"<%="ENG".equals(mothcode)?" selected":"" %>>English 英語</option>
				<option value="TRC"<%="TRC".equals(mothcode)?" selected":"" %>> Traditional Chinese  繁體中文</option>
				<option value="SMC"<%="SMC".equals(mothcode)?" selected":"" %>> Simplified Chinese  簡体中文</option>
				<option value="JAP"<%="JAP".equals(mothcode)?" selected":"" %>>Japanese 日本語</option>
			</select>
<%	} else {
		if ("ENG".equals(mothcode)) {
			%><span class="infoResult">English 英語</span><%
		} else if ("TRC".equals(mothcode)) {
			%><span class="infoResult"> Traditional Chinese  繁體中文</span><%
		} else if ("SMC".equals(mothcode)) {
			%><span class="infoResult"> Simplified Chinese  簡体中文</span><%
		} else if ("JAP".equals(mothcode)) {
			%><span class="infoResult">Japanese 日本語</span><%
		} else if ("".equals(mothcode)) {
			%><span class="infoResult"></span><%
		}
	}
%>

		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Occupation<br />職業
<%	if (createAction || updateAction) { %>
			<input name="occupation" type="text" value="<%=occupation==null?"":occupation %>" maxlength="20" size="25" />
<%	} else { %>
			<span class="infoResult"><%=occupation==null?"":occupation %></span>
<%	} %>
			<span id="hats_occupation" class="alertText"></span>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="5" bgcolor="#F9F9F9">
			Contact Telephone Number<br />聯絡電話<br />
			<table width=100%">
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9">Home<br />住宅
<%	if (createAction || updateAction) { %>
						<input name="pathtel" type="text" value="<%=pathtel==null?"":pathtel %>" maxlength="20" size="25" />
<%	} else { %>
						<span class="infoResult"><%=pathtel==null?"":pathtel %></span>
<%	} %>
						<span id="hats_pathtel" class="alertText"></span>
					</td>
					<td width="2">&nbsp;</td>
					<td height="40" valign="top" bgcolor="#F9F9F9">Office<br />辦公室
<%	if (createAction || updateAction) { %>
						<input name="patotel" type="text" value="<%=patotel==null?"":patotel %>" maxlength="20" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patotel==null?"":patotel %></span>
<%	} %>
						<span id="hats_patotel" class="alertText"></span>
					</td>
				</tr>
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9"><font color="red">*</font>Mobile/Pager No<br />手提號碼/傳呼機號碼
<%	if (createAction || updateAction) { %>
						<input name="patmtel" type="text" value="<%=patmtel==null?"":patmtel %>" maxlength="20" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patmtel==null?"":patmtel %></span>
<%	} %>
						<span id="hats_patmtel" class="alertText"></span>
					</td>
					<td width="2">&nbsp;</td>
					<td height="40" valign="top" bgcolor="#F9F9F9">Fax No<br /> 傳真號碼
<%	if (createAction || updateAction) { %>
						<input name="patftel" type="text" value="<%=patftel==null?"":patftel %>" maxlength="20" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patftel==null?"":patftel %></span>
<%	} %>
						<span id="hats_patftel" class="alertText"></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="5">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9">
						<font color="red">*</font>Email Address<br />電郵地址
<%	if (createAction || updateAction) { %>
						<input name="patemail" type="text" value="<%=patemail==null?"":patemail %>" maxlength="50" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patemail==null?"":patemail %></span>
<%	} %>
						<span id="hats_patemail" class="alertText"></span>
					</td>
					<td width="2%" valign="top">&nbsp;</td>
					<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9">
						<font color="red">*</font>Address<br />地址<br />
<%	if (createAction || updateAction) { %>
						<input type="text" name="patadd1" value="<%=patadd1==null?"":patadd1 %>" maxlength="40" size="50">Rm/Flat 室/Floor 層/Block/Bldg 大廈<br />
						<input type="text" name="patadd2" value="<%=patadd2==null?"":patadd2 %>" maxlength="40" size="50">Road 道路/Street 街道<br />
						<input type="text" name="patadd3" value="<%=patadd3==null?"":patadd3 %>" maxlength="40" size="50">District 區域<br />
						<select name="coucode">
<jsp:include page="../ui/countryCodeCMB.jsp" flush="false">
	<jsp:param name="coucode" value="<%=coucode %>" />
</jsp:include>
						</select>Country 國家
<%	} else { %>
						<span class="infoResult"><%=patadd1==null?"":patadd1 %></span>
						<span class="infoResult"><%=patadd2==null?"":patadd2 %></span>
						<span class="infoResult"><%=patadd3==null?"":patadd3 %></span>
						<span class="infoResult"><%=coudesc==null?"":coudesc %></span>
<%	} %>
						<br /><span id="hats_patadd1" class="alertText"></span>
						<br /><span id="hats_patadd2" class="alertText"></span>
						<br /><span id="hats_patadd3" class="alertText"></span>
						<br /><span id="hats_coucode" class="alertText"></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25" bgcolor="#AA3D01">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="white"><strong>Emergency Contact Person Information 緊急聯絡人資料 (1)</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Family Name<br />姓 (英文)
<%	if (createAction || updateAction) { %>
			<input type="text" name="patkfname1" value="<%=patkfname1==null?"":patkfname1 %>" maxlength="20" size="25">
<%	} else { %>
			<span class="infoResult"><%=patkfname1==null?"":patkfname1 %></span>
<%	} %>
			<span id="hats_patkfname1" class="alertText"></span>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Given Name<br />名 (英文)
<%	if (createAction || updateAction) { %>
			<input type="text" name="patkgname1" value="<%=patkgname1==null?"":patkgname1 %>" maxlength="20" size="25">
<%	} else { %>
			<span class="infoResult"><%=patkgname1==null?"":patkgname1 %></span>
<%	} %>
			<span id="hats_patkgname1" class="alertText"></span>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">Chinese Name<br />中文姓名
<%	if (createAction || updateAction) { %>
			<input type="text" name="patkcname1" value="<%=patkcname1==null?"":patkcname1 %>" maxlength="20" size="25">
<%	} else { %>
			<span class="infoResult"><%=patkcname1==null?"":patkcname1 %></span>
<%	} %>
			<span id="hats_patkcname1" class="alertText"></span>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">
				<font color="red">*</font>Title<br />稱謂
<%	if (createAction || updateAction) { %>
			<select name="patkTitleDesc1">
				<option value=""></option>
				<option value="MR"<%="MR".equals(patkTitleDesc1)?" selected":"" %>>Mr. 先生</option>
				<option value="MRS"<%="MRS".equals(patkTitleDesc1)?" selected":"" %>>Mrs. 太太</option>
				<option value="MISS"<%="MISS".equals(patkTitleDesc1)?" selected":"" %>>Miss 小姐</option>
				<option value="MS"<%="MS".equals(patkTitleDesc1)?" selected":"" %>>Ms. 女士</option>
				<option value="Others"<%="Others".equals(patkTitleDesc1)?" selected":"" %>>Others 其他</option>
			</select>
<%	} else { %>
			<span class="infoResult"><%=patkTitleDesc1==null?"":patkTitleDesc1 %></span>
<%	} %>
			<span id="hats_patkTitleDesc1" class="alertText"></span><br />
			Others<br />其他 :
<%	if (createAction || updateAction) { %>
			<input type="text" name="patkTitleDescOther1" value="<%=patkTitleDescOther1==null?"":patkTitleDescOther1 %>" maxlength="10" size="20">
<%	} else { %>
			<span class="infoResult"><%=patkTitleDescOther1==null?"":patkTitleDescOther1 %></span>
<%	} %>
			<span id="hats_patkTitleDesc1" class="alertText"></span>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9" colspan=3">
			Contact Telephone Number<br />聯絡電話<br />
			<table width=100%">
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9">Home<br />住宅
<%	if (createAction || updateAction) { %>
						<input type="text" name="patkhtel1" value="<%=patkhtel1==null?"":patkhtel1 %>" maxlength="20" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patkhtel1==null?"":patkhtel1 %></span>
<%	} %>
						<span id="hats_patkhtel1" class="alertText"></span>
					</td>
					<td width="2">&nbsp;</td>
					<td height="40" valign="top" bgcolor="#F9F9F9">Office.<br />辦公室
<%	if (createAction || updateAction) { %>
						<input type="text" name="patkotel1" value="<%=patkotel1==null?"":patkotel1 %>" maxlength="20" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patkotel1==null?"":patkotel1 %></span>
<%	} %>
						<span id="hats_patkotel1" class="alertText"></span>
					</td>
				</tr>
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9"><font color="red">*</font>Mobile<br />手提號碼
<%	if (createAction || updateAction) { %>
						<input type="text" name="patkmtel1" value="<%=patkmtel1==null?"":patkmtel1 %>" maxlength="20" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patkmtel1==null?"":patkmtel1 %></span>
<%	} %>
						<span id="hats_patkmtel1" class="alertText"></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" valign="top" bgcolor="#F9F9F9">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td height="40" valign="top">
						Relationship<br />關係
<%	if (createAction || updateAction) { %>
						<input type="text" name="patkrela1" value="<%=patkrela1==null?"":patkrela1 %>" maxlength="20" size="25">
<%	} else { %>
						<span class="infoResult"><%=patkrela1==null?"":patkrela1 %></span>
<%	} %>
						<span id="hats_patkrela1" class="alertText"></span>
						<br /><br /><br />
						Email Address<br />電郵地址
<%	if (createAction || updateAction) { %>
						<input type="text" name="patkemail1" value="<%=patkemail1==null?"":patkemail1 %>" maxlength="50" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patkemail1==null?"":patkemail1 %></span>
<%	} %>
						<span id="hats_patkemail1" class="alertText"></span>
					</td>
			</table>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td height="20" valign="top" bgcolor="#F9F9F9" colspan="3">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td width="2%" valign="top">&nbsp;</td>
					<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9">
						Address<br />地址<br />
<%	if (createAction || updateAction) { %>
						<input type="text" name="patkadd11" value="<%=patkadd11==null?"":patkadd11 %>" maxlength="40" size="50">Rm/Flat 室/Floor  層/Block/Bldg 大廈<br />
						<input type="text" name="patkadd21" value="<%=patkadd21==null?"":patkadd21 %>" maxlength="40" size="50">Road 道路/Street 街道<br />
						<input type="text" name="patkadd31" value="<%=patkadd31==null?"":patkadd31 %>" maxlength="40" size="50">District 區域<br />
						<select name="patkcoucode1">
							<jsp:include page="../ui/countryCodeCMB.jsp" flush="false">
								<jsp:param name="coucode" value="<%=patkcoucode1 %>" />
							</jsp:include>
						</select>
<%	} else { %>
						<span class="infoResult"><%=patkadd11==null?"":patkadd11 %></span>
						<span class="infoResult"><%=patkadd21==null?"":patkadd21 %></span>
						<span class="infoResult"><%=patkadd31==null?"":patkadd31 %></span>
						<span class="infoResult"><%=patkcoudesc1==null?"":patkcoudesc1 %></span>
<%	} %>
					</td>
						<br /><span id="hats_patkadd11" class="alertText"></span>
						<br /><span id="hats_patkadd21" class="alertText"></span>
						<br /><span id="hats_patkadd31" class="alertText"></span>						
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25" bgcolor="#AA3D01">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="white"><strong>Emergency Contact Person Information 緊急聯絡人資料 (2)</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">Family Name<br />姓 (英文)
<%	if (createAction || updateAction) { %>
			<input type="text" name="patkfname2" value="<%=patkfname2==null?"":patkfname2 %>" maxlength="20" size="25">
<%	} else { %>
			<span class="infoResult"><%=patkfname2==null?"":patkfname2 %></span>
<%	} %>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">Given Name<br />名 (英文)
<%	if (createAction || updateAction) { %>
			<input type="text" name="patkgname2" value="<%=patkgname2==null?"":patkgname2 %>" maxlength="20" size="25">
<%	} else { %>
			<span class="infoResult"><%=patkgname2==null?"":patkgname2 %></span>
<%	} %>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">Chinese Name<br />名 (英文)
<%	if (createAction || updateAction) { %>
			<input type="text" name="patkcname2" value="<%=patkcname2==null?"":patkcname2 %>" maxlength="20" size="25">
<%	} else { %>
			<span class="infoResult"><%=patkcname2==null?"":patkcname2 %></span>
<%	} %>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">
				Title<br />稱謂
<%	if (createAction || updateAction) { %>
			<select name="patkTitleDesc2">
				<option value=""></option>
				<option value="MR"<%="MR".equals(patkTitleDesc2)?" selected":"" %>>Mr. 先生</option>
				<option value="MRS"<%="MRS".equals(patkTitleDesc2)?" selected":"" %>>Mrs. 太太</option>
				<option value="MISS"<%="MISS".equals(patkTitleDesc2)?" selected":"" %>>Miss 小姐</option>
				<option value="MS"<%="MS".equals(patkTitleDesc2)?" selected":"" %>>Ms. 女士</option>
				<option value="Others"<%="Others".equals(patkTitleDesc2)?" selected":"" %>>Others 其他</option>
			</select>
<%	} else { %>
			<span class="infoResult"><%=patkTitleDesc2==null?"":patkTitleDesc2 %></span>
<%	} %>
			<span id="hats_patkTitleDesc2" class="alertText"></span><br />
			Others<br />其他 :
<%	if (createAction || updateAction) { %>
			<input type="text" name="patkTitleDescOther2" value="<%=patkTitleDescOther2==null?"":patkTitleDescOther2 %>" maxlength="10" size="20">
<%	} else { %>
			<span class="infoResult"><%=patkTitleDescOther2==null?"":patkTitleDescOther2 %></span>
<%	} %>
			<span id="hats_patkTitleDesc2" class="alertText"></span>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9" colspan=3">
			Contact Telephone Number<br />聯絡電話<br />
			<table width=100%">
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9">Home<br />住宅
<%	if (createAction || updateAction) { %>
						<input type="text" name="patkhtel2" value="<%=patkhtel2==null?"":patkhtel2 %>" maxlength="20" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patkhtel2==null?"":patkhtel2 %></span>
<%	} %>
					</td>
					<td width="2" valign="top">&nbsp;</td>
					<td height="40" valign="top" bgcolor="#F9F9F9">Office.<br />辦公室
<%	if (createAction || updateAction) { %>
						<input type="text" name="patkotel2" value="<%=patkotel2==null?"":patkotel2 %>" maxlength="20" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patkotel2==null?"":patkotel2 %></span>
<%	} %>
					</td>
				</tr>
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9">Mobile<br />手提號碼
<%	if (createAction || updateAction) { %>
						<input type="text" name="patkmtel2" value="<%=patkmtel2==null?"":patkmtel2 %>" maxlength="20" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patkmtel2==null?"":patkmtel2 %></span>
<%	} %>
					</td>
					<td width="2" valign="top">&nbsp;</td>					
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" valign="top" bgcolor="#F9F9F9">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td height="40" valign="top">
						Relationship<br />關係

<%	if (createAction || updateAction) { %>
						<input type="text" name="patkrela2" value="<%=patkrela2==null?"":patkrela2 %>" maxlength="20" size="25">
<%	} else { %>
						<span class="infoResult"><%=patkrela2==null?"":patkrela2 %></span>
<%	} %>
						<br /><br /><br />
						Email Address<br />電郵地址

<%	if (createAction || updateAction) { %>
						<input type="text" name="patkemail2" value="<%=patkemail2==null?"":patkemail2 %>" maxlength="50" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patkemail2==null?"":patkemail2 %></span>
<%	} %>
					</td>
				</tr>
			</table>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td height="20" valign="top" bgcolor="#F9F9F9" colspan="3">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9">
						Address<br />地址<br>
<%	if (createAction || updateAction) { %>
						<input type="text" name="patkadd12" value="<%=patkadd12==null?"":patkadd12 %>" maxlength="40" size="50">Rm/Flat 室/Floor 層/Block/Bldg 大廈<br />
						<input type="text" name="patkadd22" value="<%=patkadd22==null?"":patkadd22 %>" maxlength="40" size="50">Road 道路/Street 街道<br />
						<input type="text" name="patkadd32" value="<%=patkadd32==null?"":patkadd32 %>" maxlength="40" size="50">District 區域<br />
						<select name="patkcoucode2">
							<jsp:include page="../ui/countryCodeCMB.jsp" flush="false">
								<jsp:param name="coucode" value="<%=patkcoucode2 %>" />
							</jsp:include>
						</select>
<%	} else { %>
						<span class="infoResult"><%=patkadd12==null?"":patkadd12 %></span>
						<span class="infoResult"><%=patkadd22==null?"":patkadd22 %></span>
						<span class="infoResult"><%=patkadd32==null?"":patkadd32 %></span>
						<span class="infoResult"><%=patkcoudesc2==null?"":patkcoudesc2 %></span>
<%	} %>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	
</table>


<table width="800" border="0" cellpadding="0" cellspacing="0">	
	<tr >
		<td height="25" colspan="4" bgcolor="#AA3D01">
		<table  width="686" border="0" align="center" cellpadding="0"
			cellspacing="0">
			<tr>
				<td class="style1"><font color="white"><strong>How did you hear about us 認識本院的途徑</strong></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td height="20">&nbsp;</td>
	</tr>		
	<tr>	
		<td height="40" valign="top" bgcolor="#F9F9F9">
<%	if (createAction || updateAction) { %>
			<table>
			<tr>
				<font color="red">*</font>
				<td height="40" valign="top" bgcolor="#F9F9F9">
					<input type="radio" name="patHowInfo" value="enews" <%="enews".equals(patHowInfo)?" checked":"" %>>E-newsletter 電子報
				</td>
				<td height="40" valign="top" bgcolor="#F9F9F9">
					<input type="radio" name="patHowInfo" value="friend" <%="friend".equals(patHowInfo)?" checked":"" %>>Friends / Relatives 親友介紹
				</td>
				<td height="40" valign="top" bgcolor="#F9F9F9">
					<input type="radio" name="patHowInfo" value="web" <%="web".equals(patHowInfo)?" checked":"" %>>Hospital website 醫院網站		
				</td>
				<td height="40" valign="top" bgcolor="#F9F9F9">
					<input type="radio" name="patHowInfo" value="news" <%="news".equals(patHowInfo)?" checked":"" %>>Newspaper / Magazine 報章 / 雜誌			
				</td>		
			</tr>
			<tr>
				<td colspan="4" height="40" valign="top" bgcolor="#F9F9F9">
					<input type="radio" name="patHowInfo" value="other" <%="other".equals(patHowInfo)?" checked":"" %>>Other 其他			
					<input type="text" name="patHowInfoOther" class="uppercase" onkeyup="checkHowInfoOther()" value="<%=patHowInfoOther==null?"":patHowInfoOther %>" maxlength="10" size="20">
				</td>
			</tr>			
			</table>
			
<%	} else { 
	String patHowInfoDisplay = "";
	
	if(patHowInfo != null && patHowInfo.length() > 0){
		if("enews".equals(patHowInfo)){
			patHowInfoDisplay = "E-newsletter 電子報 ";
		}else if("friend".equals(patHowInfo)){
			patHowInfoDisplay = "Friends / Relatives 親友介紹 ";
		}else if("web".equals(patHowInfo)){
			patHowInfoDisplay = "Hospital website 醫院網站 ";
		}else if("news".equals(patHowInfo)){
			patHowInfoDisplay = "Newspaper / Magazine 報章 / 雜誌";
		}else if("other".equals(patHowInfo)){
			patHowInfoDisplay = "Other 其他";
		}
	}
%>
			<span class="infoResult">
				<%=patHowInfoDisplay==null?"":patHowInfoDisplay %>
				<%if(("other").equals(patHowInfo)){ %>
					</br>
					<%=patHowInfoOther==null?"":patHowInfoOther %>
				<%} %>
			</span>
			
<%	} %>
		</td>		
	</tr>	
</table>


<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25" bgcolor="#AA3D01">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="white"><strong>Patient's Agreement 病人協議</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<table width="700" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top">1.</td><td>All information given by me is true and correct to the best of my personal knowledge.</td>
				</tr>
				<tr>
					<td valign="top">2.</td><td>I acknowledge the fact that patients treated or admitted to Hong Kong Adventist Hospital ("the Hospital") are under the direct care, supervision and responsibility of their attending physician. I am informed and recognize that all physicians, specialists, surgeons and independent contractors providing services to patients are not employees or agents of the Hospital.</td>
				</tr>
				<tr>
					<td valign="top">3.</td><td>I consent to diagnostic imaging, laboratory and physiotherapy procedures which may include, but not limited to, blood drawing, medical or surgical treatment, and other Hospital’s services rendered under the general/special instructions of the attending physician.</td>
				</tr>
				<tr>
					<td valign="top">4.</td><td>I agree to pay the Hospital’s current rates and charges at the time the services rendered in respect of the facilities used and treatment received by me and all other incidental charges incurred.</td>
				</tr>
				<tr>
					<td valign="top">5.</td><td>I hereby authorize the Hospital to contact and release/disclose/share all my personal data (including but not limited to medical record) to/with my insurer, its agent or broker for activities pertaining to my insurance claim, or any accreditation institutions / organizations / company involved in accreditation of the Hospital.</td>
				</tr>
				<tr>
					<td valign="top">6.</td><td>I agree to pay any outstanding charges that have not been paid or covered by my insurer.</td>
				</tr>	
				<tr>
					<td valign="top">7.</td><td>I agree Clauses 1 to 6 shall remain valid and effective unless specifically revoked by me in writing.</td>
				</tr>	
				<tr>
					<td valign="top">8.</td><td>I give my consent herein to the Hospital to send its direct marketing and health promotion materials in relation to its services to me by post, SMS, fax, electronic mail or other means of communication or making telephone calls via my address, telephone numbers, fax number and email address provided by me to the Hospital.</td>
				</tr>			
				<tr>
					<td width="31">&nbsp;</td><td width="669">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">1.</td><td>所有由本人提供的資料在本人的個人認知範圍內皆屬實和正確。</td>
				</tr>
				<tr>
					<td valign="top">2.</td><td>本人知悉在香港港安醫院（「醫院」）接受治療或留院之病人，均直接由主診醫生照顧、監護及負責。本人知悉及知道，所有為病人服務的醫生、專家、外科醫生及獨立承包商均不屬醫院僱員及代理。</td>
				</tr>
				<tr>
					<td valign="top">3.</td><td>本人同意在主診醫生的一般/特殊指令下，接受診斷成像、實驗室檢驗及物理治療等程序，當中可能包括但不限於抽血、藥物或手術治療及來自其他醫院提供之服務等。</td>
				</tr>
				<tr>
					<td valign="top">4.</td><td>本人同意支付所有由醫院提供予本人的治療、設施和服務的規定費用，及偶發事故所帶來的收費。</td>
				</tr>
				<tr>
					<td valign="top">5.</td><td>本人在此授權醫院就本人的保險索償事宜與本人的承保人或其附屬之仲介人或經紀人聯繫，及向其提交 / 披露 / 分享或索取所有與本人有關的個人資料 ( 包括但不限於醫療紀錄 )，及授權醫院提交 / 披露 / 分享所有與本人有關的個人資料 ( 包括但不限於醫療紀錄 ) 予參與評審醫院的任何認可機構 / 組織 / 公司。</td>
				</tr>
				<tr>
					<td valign="top">6.</td><td>本人同意支付所有額外費用或保險公司所未能承保的費用。</td>
				</tr>		
				<tr>
					<td valign="top">7.</td><td>本人同意此協議第一至六條將持續有效，直至本人以書面方式，明確要求取消此協議。</td>
				</tr>		
				<tr>
					<td valign="top">8.</td><td>本人同意醫院可以藉郵件、短訊、圖文傳真、電子郵件或其他形式的傳訊，或通過電話通話，向本人提供與醫院服務或健康訊息有關的資料。</td>
				</tr>								
				<tr>
					<td width="31">&nbsp;</td><td width="669">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" colspan="2">
					<ul>						
						<li>Patients' Charter 病人權益與責任 (<a href="http://www.hkah.org.hk/new/eng/download/Patient_Charter.pdf" target="_blank">Click here 請按此</a>)</li>
						<li>Fee range 收費範圍 (<a href="http://www.hkah.org.hk/new/eng/out-patient_popup.php" target="_blank">Click here</a><a href="http://www.hkah.org.hk/new/chi/out-patient_popup.php" target="_blank"> 請按此</a>)</li>
					</ul></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25" bgcolor="#AA3D01">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="white"><strong>Signee's Acknowledgement 簽署人同意書</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<table width="700" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top">&nbsp;</td>
					<td>I, the undersigned, accept full responsibility for the settlement of all expenses incurred by the patient.<br/>
						本簽署人全權負責支付以上病人之一切費用。</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">
<%	if (createAction || updateAction) { %>
						<input type="checkbox" name="promotionYN" value="N"<%="N".equals(promotionYN)?" checked":"" %> />
<%	} else {
			if ("N".equals(promotionYN)) {
				%><img src="../images/tick_green_small.gif" /><%
			} else {
				%><img src="../images/cross_red_small.gif" /><%
			}
		} %>
					</td>
					<td>I do not give my consent to the Hospital to use my data for direct marketing of health services and promotion purpose.</br> 本人不同意醫院使用本人的個人資料來提供與醫院服務或健康訊息有關的資料。</td>
				</tr>
			</table>
		<br /></td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25" bgcolor="#AA3D01">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="white"><strong>Other Information 其他資料</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="5">
			<ul id="browser" class="filetree">
<jsp:include page="../registration/out_important_information.jsp" flush="false">
	<jsp:param name="source" value="registration" />
</jsp:include>		
<%if (!createAction) { %>
<jsp:include page="admission_document.jsp" flush="false">
	<jsp:param name="admissionID" value="<%=admissionID %>" />
</jsp:include>
<%} %>
			</ul>
		</td>
	</tr>
</table>
<br /><br /><br />
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td><font color="red">***</font>If there is any inconsistency or ambiguity between the English version and the Chinese version, the English version shall prevail.<br />中英文版本如有歧異，概以英文版本為準。</td>
	</tr>
</table>
<div class="pane">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td align="center">
<%		if (createAction) { %>
			<input type="button" onclick="return submitAction('create', 1);" value="I Agree and submit the information" />
<%		} else if (updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
<%			if (updateAction || deleteAction) { %>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%			} %>
<%		} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click">Edit</button>
			<button class="btn-delete">Delete Booking</button>
<%		}  %>
		</td>
	</tr>
</table>
</div>
<input type="hidden" name="command"/>
<input type="hidden" name="step"/>
<input type="hidden" name="admissionID" value="<%=admissionID %>"/>
<input type="hidden" name="newPatno"/>
<input type="hidden" name="patno" value="<%=patno%>"/>
<span id="showAdmission_indicator">
<jsp:include page="admission_hats.jsp" flush="false">
	<jsp:param name="command" value="<%=command %>" />
	<jsp:param name="admissionID" value="<%=admissionID %>" />
</jsp:include>
</span>
</form>
<script language="javascript">
<!--//
	function submitAction(cmd, stp, pid) {
		if (stp == 1 && (cmd == 'create' || cmd == 'update')) {
			if (document.form1.appointmentDate.value == '') {
				alert('Empty Appointment Date 沒有輸入預約日期.');
				document.form1.appointmentDate.focus();
				return false;
			}
			if (!validDate(document.form1.appointmentDate)) {
				alert('Invalid Appointment Date 不正確預約日期.');
				document.form1.appointmentDate.focus();
				return false;
			}
			if ($('select[name=attendDoctor] :selected').text() == '' ){
				alert('Empty Attending Doctor 沒有輸入主診醫生');
				document.form1.attendDoctor.focus();
				return false;
			}
			
			if (document.form1.patidType[0].checked) {
				if (document.form1.patidno1.value == '') {
					alert('Empty Hong Kong I.D. Card 沒有輸入香港身份證號碼.');
					document.form1.patidno1.focus();
					return false;
				}
				if (document.form1.patidno2.value == '') {
					alert('Empty Hong Kong I.D. Card 沒有輸入香港身份證號碼.');
					document.form1.patidno2.focus();
					return false;
				}
				if (document.form1.patidno1.value.length < 7) {
					alert('Invalid Hong Kong I.D. Card 不正確香港身份證號碼.');
					document.form1.patidno1.focus();
					return false;
				}
			}
			if (document.form1.patidType[1].checked && document.form1.patpassport.value == '') {
				alert('Empty Passport No. 沒有輸入護照號碼.');
				document.form1.patpassport.focus();
				return false;
			}
			if (document.form1.patidType[2].checked && document.form1.pattraveldoc.value == '') {
				alert('Empty Travel Document No. 沒有輸入旅遊證件號碼.');
				document.form1.pattraveldoc.focus();
				return false;
			}
			if (document.form1.patbdate.value == '') {
				alert('Empty Date of Birth 沒有輸入出生日期.');
				document.form1.patbdate.focus();
				return false;
			}
			if (!validDate(document.form1.patbdate)) {
				alert('Invalid Date of Birth 不正確出生日期.');
				document.form1.patbdate.focus();
				return false;
			}
			if (document.form1.patfname.value == '') {
				alert('Empty Family Name 沒有輸入姓氏');
				document.form1.patfname.focus();
				return false;
			}
			if (document.form1.patgname.value == '') {
				alert('Empty Given Name 沒有輸入名稱.');
				document.form1.patgname.focus();
				return false;
			}
			if (document.form1.titleDesc.value == '' && document.form1.titleDescOther.value == '') {
				alert('Empty Title 沒有輸入稱謂.');
				document.form1.titleDesc.focus();
				return false;
			}			
			if (document.form1.patsex.value == '') {
				alert('Empty Sex 沒有輸入性別.');
				document.form1.patsex.focus();
				return false;
			}
			if ($('select[name=patmsts] :selected').text() == '' && document.form1.patmstsOther.value == ''){
				alert('Empty Marital Status 沒有輸入婚姻狀況');
				document.form1.patmsts.focus();
				return false;
			}
			if ($('select[name=religion] :selected').text() == '' && document.form1.religionOther.value == ''){
				alert('Empty Religion 沒有輸入信仰');
				document.form1.religion.focus();
				return false;
			}
			if ($('select[name=racedesc] :selected').text() == '' && document.form1.racedescOther.value == ''){				
				alert('Empty Religion 沒有輸入信仰');
				document.form1.racedesc.focus();
				return false;
			}
			if ($('select[name=mothcode] :selected').text() == ''){
				alert('Empty Correspondence Language 沒有輸入通訊語言');
				document.form1.mothcode.focus();
				return false;
			}
			if ($('select[name=edulevel] :selected').text() == '' && document.form1.edulevelOther.value == ''){
				alert('Empty Education Level 沒有輸入教育程度');
				document.form1.edulevel.focus();
				return false;
			}
			if (document.form1.patmtel.value == '') {
				alert('Empty Mobile Phone Number 沒有輸入流動電話');
				document.form1.patmtel.focus();
				return false;
			}
			if (document.form1.patemail.value == '') {
				alert('Empty Email Address 沒有輸入電郵地址');
				document.form1.patemail.focus();
				return false;
			}
			if ($('select[name=coucode] :selected').text() == '' && document.form1.patadd1.value == ''
				&& document.form1.patadd2.value == '' && document.form1.patadd3.value == ''){				
				alert('Empty Address 沒有輸入地址');
				document.form1.patadd1.focus();
				return false;
			}		
			if (document.form1.patkfname1.value == '') {								
				alert('Surname in English (Emergency Contact Person) 姓 (英文) (緊急聯絡人)');
				document.form1.patkfname1.focus();
				return false;	
			}	
			if (document.form1.patkgname1.value == '') {							
				alert('Given Names in English (Emergency Contact Person) 名 (英文) (緊急聯絡人)');
				document.form1.patkgname1.focus();
				return false;	
				
			}	
			if ($('select[name=patkTitleDesc1] :selected').text() == '' && document.form1.patkTitleDescOther1.value == ''){
				alert('Title (Emergency Contact Person) 稱謂 (緊急聯絡人)');
				document.form1.patkTitleDesc1.focus();
				return false;					
			}
			if (document.form1.patkmtel1.value == '') {
				alert('Mobile Phone (Emergency Contact Person) 流動電話 (緊急聯絡人)');
				document.form1.patkmtel1.focus();
				return false;					
			}	
			if ($('input[name=patHowInfo]:checked').length <= 0) {
				alert('How did you hear about us 認識本院的途徑 ');
				document.form1.patHowInfo.focus();
				return false;
			}
		}

		if (cmd == 'updateHATS') {
			$.prompt('Confirm Update HATS?',{
				buttons: { Ok: true, Cancel: false },
				callback: function(v,m,f) {
					if (v) {
						submit: confirmAction();
						return true;
					} else {
						return false;
					}
				},
				prefix:'cleanblue'
			});
		} else if (cmd =='viewHATS') {
			callPopUpWindow("../common/gwt2hats.jsp?moduleCode=patient.view&patno=" + document.form1.patno.value);
			return false;
		} else {
			if($('input[name="promotionYN"]').attr('checked')){
				$('input[name="promotionYN"]').val('N');
			}else{
				$('input[name="promotionYN"]').val('Y');	
				$('input[name="promotionYN"]').attr('checked', true);
			}
			document.form1.command.value = cmd;
			document.form1.step.value = stp;
			document.form1.newPatno.value = pid;
			document.form1.submit();
		}
		
		return false;
	}

	function confirmAction() {
		document.form1.command.value = 'updateHATS';
		document.form1.step.value = '1';
		document.form1.submit();
	}

	// ajax
	var http = createRequestObject();

	function checkPatNo(obj) {
		//preset hidden value
		var patno = obj.value;
		var pid1 = document.form1.patidno1.value;
		var pid2 = document.form1.patidno2.value;
		var pp = document.form1.patpassport.value;
		var dob = document.form1.patbdate.value;

		if (patno.length > 0
				&& pid1.length == 0 && pid2.length == 0 && pp.length == 0 && dob.length == 0) {
			http.open('get', 'admission_hats.jsp?command=<%=command %>&patno=' + patno + '&timestamp=<%=(new java.util.Date()).getTime() %>');

			//assign a handler for the response
			http.onreadystatechange = processResponseAdmission;

			//actually send the request to the server
			http.send(null);
		}
		return false;
	}

	function checkHATS(patno) {
		if (patno == '') {
			patno = $('input[name=patno]').val();
		}
		
		if (patno.length > 0) {
			http.open('get', 'admission_hats.jsp?command=<%=command %>&patno=' + patno + '&timestamp=<%=(new java.util.Date()).getTime() %>');

			//assign a handler for the response
			http.onreadystatechange = processResponseCompare;

			//actually send the request to the server
			http.send(null);
		}
		return false;
	}


	function validHKID() {
		if (document.form1.patidno1.value != '') {
			document.form1.patidType[0].checked = true;
			document.form1.patpassport.value = '';
			document.form1.pattraveldoc.value = '';

			var hkid1 = document.form1.patidno1.value;
			var hkid2 = document.form1.patidno2.value;
			document.form1.patidno1.value = hkid1.toUpperCase();
			document.form1.patidno2.value = hkid2.toUpperCase();
		}
		return false;
	}

	function validPassport() {
		if (document.form1.patpassport.value != '') {
			document.form1.patidType[1].checked = true;
			document.form1.patidno1.value = '';
			document.form1.patidno2.value = '';
			document.form1.pattraveldoc.value = '';
			document.form1.patpassport.value = document.form1.patpassport.value.toUpperCase();
			document.form1.patpassport.focus();
		}
		return false;
	}
	
	
	function validTravelDoc() {
		if (document.form1.pattraveldoc.value != '') {
			document.form1.patidType[2].checked = true;
			document.form1.patidno1.value = '';
			document.form1.patidno2.value = '';
			document.form1.patpassport.value = '';

			document.form1.pattraveldoc.value = document.form1.pattraveldoc.value.toUpperCase();
			document.form1.pattraveldoc.focus();
		}
		return false;
	}

	function validDOB(event) {
		if (document.form1.patno.value != '' && event.keyCode == 13) {
			document.form1.patbdate.focus();
		}
	}
	
	function checkHowInfoOther(){
		document.form1.patHowInfo[4].checked = true;
	}

	function processResponseAdmission() {
		//check if the response has been received from the server
		if (http.readyState == 4) {
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("showAdmission_indicator").innerHTML = response;

			// retrieve patno
			if (response.substring(0, 1) == 1) {
				alert('Retrieve Info取得資料!');
				document.form1.patno.value = document.form1.hats_patno.value;
//				document.form1.patidno1.value = document.form1.hats_patidno1.value;
//				document.form1.patidno2.value = document.form1.hats_patidno2.value;
//				document.form1.patpassport.value = document.form1.hats_patpassport.value;
//				document.form1.patbdate.value = document.form1.hats_patbdate.value;
				if (document.form1.patfname.value == '') document.form1.patfname.value = document.form1.hats_patfname.value;
				if (document.form1.patgname.value == '') document.form1.patgname.value = document.form1.hats_patgname.value;
				if (document.form1.titleDesc.value == '') document.form1.titleDesc.value = document.form1.hats_titleDesc.value;
				if (document.form1.patcname.value == '') document.form1.patcname.value = document.form1.hats_patcname.value;
				if (document.form1.patsex.value == '') document.form1.patsex.value = document.form1.hats_patsex.value;
				if (document.form1.racedesc.value == '') document.form1.racedesc.value = document.form1.hats_racedesc.value;
				if (document.form1.religion.value == '') document.form1.religion.value = document.form1.hats_religion.value;
				if (document.form1.patmsts.value == '') document.form1.patmsts.value = document.form1.hats_patmsts.value;
				if (document.form1.mothcode.value == '') document.form1.mothcode.value = document.form1.hats_mothcode.value;
				if (document.form1.edulevel.value == '') document.form1.edulevel.value = document.form1.hats_edulevel.value;
				if (document.form1.pathtel.value == '') document.form1.pathtel.value = document.form1.hats_pathtel.value;
				if (document.form1.patotel.value == '') document.form1.patotel.value = document.form1.hats_patotel.value;
				if (document.form1.patmtel.value == '') document.form1.patmtel.value = document.form1.hats_patmtel.value;
				if (document.form1.patftel.value == '') document.form1.patftel.value = document.form1.hats_patftel.value;
				if (document.form1.occupation.value == '') document.form1.occupation.value = document.form1.hats_occupation.value;
				if (document.form1.patemail.value == '') document.form1.patemail.value = document.form1.hats_patemail.value;
				if (document.form1.patadd1.value == '') document.form1.patadd1.value = document.form1.hats_patadd1.value;
				if (document.form1.patadd2.value == '') document.form1.patadd2.value = document.form1.hats_patadd2.value;
				if (document.form1.patadd3.value == '') document.form1.patadd3.value = document.form1.hats_patadd3.value;
				if (document.form1.coucode.value == '') document.form1.coucode.value = document.form1.hats_coucode.value;
				if (document.form1.patkfname1.value == '') document.form1.patkfname1.value = document.form1.hats_patkfname1.value;
				if (document.form1.patkgname1.value == '') document.form1.patkgname1.value = document.form1.hats_patkgname1.value;
				if (document.form1.patkrela1.value == '') document.form1.patkrela1.value = document.form1.hats_patkrela1.value;
				if (document.form1.patkhtel1.value == '') document.form1.patkhtel1.value = document.form1.hats_patkhtel1.value;
				if (document.form1.patkotel1.value == '') document.form1.patkotel1.value = document.form1.hats_patkotel1.value;
				if (document.form1.patkmtel1.value == '') document.form1.patkmtel1.value = document.form1.hats_patkmtel1.value;
				if (document.form1.patkptel1.value == '') document.form1.patkptel1.value = document.form1.hats_patkptel1.value;
				if (document.form1.patkemail1.value == '') document.form1.patkemail1.value = document.form1.hats_patkemail1.value;
				if (document.form1.patkadd11.value == '') document.form1.patkadd11.value = document.form1.hats_patkadd11.value;
				if (document.form1.patkadd21.value == '') document.form1.patkadd21.value = document.form1.hats_patkadd21.value;
				if (document.form1.patkadd31.value == '') document.form1.patkadd31.value = document.form1.hats_patkadd31.value;
			}
		}
	}

	function processResponseCompare() {
		//check if the response has been received from the server
		if (http.readyState == 4) {
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("showAdmission_indicator").innerHTML = response;

			// retrieve patno
			if (response.substring(0, 1) == 1) {
				alert('Verify from HATS!');
				document.form1.patno.value = document.form1.hats_patno.value;
//				document.form1.patidno1.value = document.form1.hats_patidno1.value;
//				document.form1.patidno2.value = document.form1.hats_patidno2.value;
//				document.form1.patpassport.value = document.form1.hats_patpassport.value;
//				document.form1.patbdate.value = document.form1.hats_patbdate.value;
				if (document.form1.patfname.value != document.form1.hats_patfname.value) document.getElementById("hats_patfname").innerHTML = document.form1.hats_patfname.value;
				if (document.form1.patgname.value != document.form1.hats_patgname.value) document.getElementById("hats_patgname").innerHTML = document.form1.hats_patgname.value;
				if (document.form1.titleDesc.value != document.form1.hats_titleDesc.value) document.getElementById("hats_titleDesc").innerHTML = document.form1.hats_titleDesc.value;
				if (document.form1.patcname.value != document.form1.hats_patcname.value) document.getElementById("hats_patcname").innerHTML = document.form1.hats_patcname.value;
				if (document.form1.patsex.value != document.form1.hats_patsex.value) document.getElementById("hats_patsex").innerHTML = document.form1.hats_patsex.value;
				if (document.form1.racedesc.value != document.form1.hats_racedesc.value) document.getElementById("hats_racedesc").innerHTML = document.form1.hats_racedesc.value;
				if (document.form1.religion.value != document.form1.hats_religion.value) document.getElementById("hats_religion").innerHTML = document.form1.hats_religion.value;
				if (document.form1.patmsts.value != document.form1.hats_patmsts.value) document.getElementById("hats_patmsts").innerHTML = document.form1.hats_patmsts.value;
				if (document.form1.mothcode.value != document.form1.hats_mothcode.value) document.getElementById("hats_mothcode").innerHTML = document.form1.hats_mothcode.value;
				if (document.form1.edulevel.value != document.form1.hats_edulevel.value) document.getElementById("hats_edulevel").innerHTML = document.form1.hats_edulevel.value;			
				if (document.form1.pathtel.value != document.form1.hats_pathtel.value) document.getElementById("hats_pathtel").innerHTML = document.form1.hats_pathtel.value;
				if (document.form1.patotel.value != document.form1.hats_patotel.value) document.getElementById("hats_patotel").innerHTML = document.form1.hats_patotel.value;
				if (document.form1.patmtel.value != document.form1.hats_patmtel.value) document.getElementById("hats_patmtel").innerHTML = document.form1.hats_patmtel.value;
				if (document.form1.patftel.value != document.form1.hats_patftel.value) document.getElementById("hats_patftel").innerHTML = document.form1.hats_patftel.value;
				if (document.form1.occupation.value != document.form1.hats_occupation.value) document.getElementById("hats_occupation").innerHTML = document.form1.hats_occupation.value;
				if (document.form1.patemail.value != document.form1.hats_patemail.value) document.getElementById("hats_patemail").innerHTML = document.form1.hats_patemail.value;
				if (document.form1.patadd1.value != document.form1.hats_patadd1.value) document.getElementById("hats_patadd1").innerHTML = document.form1.hats_patadd1.value;
				if (document.form1.patadd2.value != document.form1.hats_patadd2.value) document.getElementById("hats_patadd2").innerHTML = document.form1.hats_patadd2.value;
				if (document.form1.patadd3.value != document.form1.hats_patadd3.value) document.getElementById("hats_patadd3").innerHTML = document.form1.hats_patadd3.value;
				if (document.form1.coucode.value != document.form1.hats_coucode.value) document.getElementById("hats_coucode").innerHTML = document.form1.hats_coucode.value;
				if (document.form1.patkfname1.value != document.form1.hats_patkfname1.value) document.getElementById("hats_patkfname1").innerHTML = document.form1.hats_patkfname1.value;
				if (document.form1.patkgname1.value != document.form1.hats_patkgname1.value) document.getElementById("hats_patkgname1").innerHTML = document.form1.hats_patkgname1.value;
				if (document.form1.patkrela1.value != document.form1.hats_patkrela1.value) document.getElementById("hats_patkrela1").innerHTML = document.form1.hats_patkrela1.value;
				if (document.form1.patkhtel1.value != document.form1.hats_patkhtel1.value) document.getElementById("hats_patkhtel1").innerHTML = document.form1.hats_patkhtel1.value;
				if (document.form1.patkotel1.value != document.form1.hats_patkotel1.value) document.getElementById("hats_patkotel1").innerHTML = document.form1.hats_patkotel1.value;
				if (document.form1.patkmtel1.value != document.form1.hats_patkmtel1.value) document.getElementById("hats_patkmtel1").innerHTML = document.form1.hats_patkmtel1.value;
				if (document.form1.patkptel1.value != document.form1.hats_patkptel1.value) document.getElementById("hats_patkptel1").innerHTML = document.form1.hats_patkptel1.value;
				if (document.form1.patkemail1.value != document.form1.hats_patkemail1.value) document.getElementById("hats_patkemail1").innerHTML = document.form1.hats_patkemail1.value;
				if (document.form1.patkadd11.value != document.form1.hats_patkadd11.value) document.getElementById("hats_patkadd11").innerHTML = document.form1.hats_patkadd11.value;
				if (document.form1.patkadd21.value != document.form1.hats_patkadd21.value) document.getElementById("hats_patkadd21").innerHTML = document.form1.hats_patkadd21.value;
				if (document.form1.patkadd31.value != document.form1.hats_patkadd31.value) document.getElementById("hats_patkadd31").innerHTML = document.form1.hats_patkadd31.value;
			}
		}
	}
	
	function printReceipt(action,admissionID) {		
		if(action == 'pdfAction') {					
			callPopUpWindow("out_admission_print.jsp?command="+action+"&admissionID="+admissionID);
		}	
	}
//-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>

