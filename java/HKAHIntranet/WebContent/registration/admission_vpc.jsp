<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
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
if ("".equals(admissionID)) {
	admissionID = (String)session.getAttribute("admissionID");
}
if ("".equals(admissionID)) {
	admissionID = null;
}

System.out.println("[DEBUG] aID=" + admissionID);

String step = ParserUtil.getParameter(request, "step");
String language = ParserUtil.getParameter(request, "language");

String patno = ParserUtil.getParameter(request, "patno");
String newPatno = ParserUtil.getParameter(request, "newPatno");
String expectedAdmissionDate = ParserUtil.getParameter(request, "expectedAdmissionDate");
String expectedAdmissionTime = ParserUtil.getTime(request, "expectedAdmissionTime");
String actualAdmissionDate = ParserUtil.getParameter(request, "actualAdmissionDate");
String actualAdmissionTime = ParserUtil.getTime(request, "actualAdmissionTime");
String admissiondoctor = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "admissiondoctor"));
String remarks = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remarks"));

String patidno = null;
String patidno1 = TextUtil.parseStr(ParserUtil.getParameter(request, "patidno1")).toUpperCase();
String patidno2 = TextUtil.parseStr(ParserUtil.getParameter(request, "patidno2")).toUpperCase();
String patpassport = TextUtil.parseStr(ParserUtil.getParameter(request, "patpassport")).toUpperCase();
String patbdate = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patbdate"));
String patfname = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patfname"));
String patgname = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patgname"));
String titleDesc = ParserUtil.getParameter(request, "titleDesc");
String titleDescOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "titleDescOther"));
String patcname = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patcname"));
String passdocument = null;
String patsex = ParserUtil.getParameter(request, "patsex");
String racedesc = ParserUtil.getParameter(request, "racedesc");
String racedescOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "racedescOther"));
String religion = ParserUtil.getParameter(request, "religion");
String religionOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "religionOther"));
String patmsts = ParserUtil.getParameter(request, "patmsts");
String patmstsOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patmstsOther"));
String mothcode = ParserUtil.getParameter(request, "mothcode");
String mothcodeOther = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mothcodeOther"));
String edulevel = ParserUtil.getParameter(request, "edulevel");
//20181207 Arran added mktsrc
String mktSrc = ParserUtil.getParameter(request, "mktSrc");
String pathtel = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pathtel"));
String patotel = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patotel"));
String patmtel = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patmtel"));
String patftel = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patftel"));
String occupation = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "occupation"));
String patemail = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patemail"));
if (patemail == null || "".equals(patemail)) {
	if (sessionKey != null && !"".equals(sessionKey)) {
		patemail = SessionLoginDB.getSessionEmail(sessionKey);
	}
}
String patadd1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patadd1"));
String patadd2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patadd2"));
String patadd3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patadd3"));
String patadd4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patadd4"));
String coucode = ParserUtil.getParameter(request, "coucode");
String coudesc = null;

String patkfname1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkfname1"));
String patkgname1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkgname1"));
String patkcname1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkcname1"));
String patksex1 = ParserUtil.getParameter(request, "patksex1");
String patkrela1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkrela1"));
String patkhtel1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkhtel1"));
String patkotel1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkotel1"));
String patkmtel1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkmtel1"));
String patkptel1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkptel1"));
String patkemail1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkemail1"));
String patkadd11 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd11"));
String patkadd21 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd21"));
String patkadd31 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd31"));
String patkadd41 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd41"));

String patkfname2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkfname2"));
String patkgname2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkgname2"));
String patkcname2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkcname2"));
String patksex2 = ParserUtil.getParameter(request, "patksex2");
String patkrela2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkrela2"));
String patkhtel2 = ParserUtil.getParameter(request, "patkhtel2");
String patkotel2 = ParserUtil.getParameter(request, "patkotel2");
String patkmtel2 = ParserUtil.getParameter(request, "patkmtel2");
String patkptel2 = ParserUtil.getParameter(request, "patkptel2");
String patkemail2 = ParserUtil.getParameter(request, "patkemail2");
String patkadd12 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd12"));
String patkadd22 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd22"));
String patkadd32 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd32"));
String patkadd42 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patkadd42"));

String ward = ParserUtil.getParameter(request, "ward");
String roomType = ParserUtil.getParameter(request, "roomType");
String hospitalACM = ParserUtil.getParameter(request, "hospitalACM");
String bedNo = ParserUtil.getParameter(request, "bedNo");
String paymentType = ParserUtil.getParameter(request, "paymentType");
String paymentTypeOther = ParserUtil.getParameter(request, "paymentTypeOther");
String creditCardType = ParserUtil.getParameter(request, "creditCardType");
String insuranceRemarks = ParserUtil.getParameter(request, "insuranceRemarks");
String insurancePolicyNo = ParserUtil.getParameter(request, "insurancePolicyNo");
String promotionYN = ParserUtil.getParameter(request, "promotionYN");
String infoForPromotion = ParserUtil.getParameter(request, "infoForPromotion");

String reached = ParserUtil.getParameter(request, "reached");
String registered = ParserUtil.getParameter(request, "registered");
String  firstViewUser = null;
String firstViewDate = null;
String confirmDate = null;
String[] unselectedImtInfo = null;

String paymentStatus = null;
String paymentReceiptNo = null;
String transNo = null;
if (fileUpload) {
	// create new record
	if ("create".equals(command) && "1".equals(step) && admissionID == null) {
		// get admission id with dummy data
		admissionID = AdmissionDB.add(userBean);
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

if (patidno1 != null && patidno1.length() > 0 && patidno2 != null && patidno2.length() > 0) {
	patidno = patidno1 + "(" +patidno2+ ")" ;
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
boolean updateBedNoAction = false;
boolean updateACMAction = false;

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
} else if ("updateBedNo".equals(command)) {
	updateBedNoAction = true;
} else if ("updateACM".equals(command)) {
	updateACMAction = true;
}

// check user right
try {
	if ("1".equals(step)) {
		if (createAction || updateAction) {
			// create new record
			if (createAction && admissionID == null) {
				// get admission id with dummy data
				admissionID = AdmissionDB.add(userBean);
			}

			String newExpectedAdmissionDate = expectedAdmissionDate + " " + expectedAdmissionTime;
			String newActualAdmissionDate = null;

			// for POP - begin
			StringBuffer vpc = new StringBuffer();
			String vpcURL = "https://migs.mastercard.com.au/vpcpay" ;
			Map<String,String> vpcFields = new HashMap<String,String>();
			String secureHash = null;
			String vpc_Amount = "0" ;
			// end

			if (actualAdmissionDate != null && actualAdmissionDate.length() > 0 && actualAdmissionTime != null) {
				newActualAdmissionDate = actualAdmissionDate + " " + actualAdmissionTime;
			}

			if (sessionKey != null) {
				registered = "Email";
			}

			if (AdmissionDB.update(userBean, admissionID, patno,
					patfname, patgname, patcname, titleDesc, titleDescOther,
					patidno, patpassport, passdocument,
					patsex, racedesc, racedescOther, religion, religionOther,
					patbdate, patmsts, patmstsOther, mothcode, mothcodeOther, edulevel,
					pathtel, patotel, patmtel, patftel,
					occupation, patemail,
					patadd1, patadd2, patadd3, patadd4, coucode,
					patkfname1, patkgname1, patkcname1, patksex1, patkrela1,
					patkhtel1, patkotel1, patkmtel1, patkptel1,
					patkemail1, patkadd11, patkadd21, patkadd31, patkadd41,
					patkfname2, patkgname2, patkcname2, patksex2, patkrela2,
					patkhtel2, patkotel2, patkmtel2, patkptel2,
					patkemail2, patkadd12, patkadd22, patkadd32, patkadd42,
					newExpectedAdmissionDate, newActualAdmissionDate,
					admissiondoctor, ward, roomType, bedNo, promotionYN,
					paymentType, paymentTypeOther, creditCardType, insuranceRemarks, insurancePolicyNo,
					remarks, sessionKey, registered, reached, "N".equals(infoForPromotion)?"N":"Y", mktSrc)) {
					System.out.println("DEBUG: admission.jsp(224) createAction = " + createAction);
				if (createAction) {
					// send email notify
					if (unselectedImtInfo != null) {
						for(int i=0;i<unselectedImtInfo.length;i++) {
							AdmissionDB.addunselectImpInfo(userBean,unselectedImtInfo[i],admissionID);
						}
						AdmissionDB.updateHasImtInfo(admissionID);
					}

					// move to admission_update_payment.jsp
					//AdmissionDB.sendEmailNotifyStaff(admissionID,"in");

					// update sessionKey
					if (sessionKey != null && sessionKey.length() > 0) {
						SessionLoginDB.delete(userBean, sessionKey);
					}

					// page forward
					if (admissionID != null && !userBean.isLogin()) {
						// email auto notify client
						System.out.println(new Date() + "[DEBUG] admission.jsp email auto aID=<"+admissionID+
								">, patemail=<" + patemail + ", isAddrVAlid=" + UtilMail.isValidEmailAddress(patemail));

						// // move to admission_update_payment.jsp
						//AdmissionDB.sendEmailAutoNotifyClient(admissionID, patemail, "in");

						// go to payment method page -------------------------------------------------------------------------------------------------------------
						//response.sendRedirect( "admission_client_payment.jsp?admissionID=" + admissionID + "&patidno1=" + patidno1 + "&roomType=" + roomType );
						//
						request.setAttribute("admissionID", admissionID);
						session.setAttribute("admissionID", admissionID);
						request.setAttribute("patidno1", patidno1);
						request.setAttribute("patidno2", patidno2);
						request.setAttribute("patpassport", patpassport);
						request.setAttribute("roomType", roomType);
						request.getRequestDispatcher("admission_client_payment.jsp").forward(request, response);

						//8>
						//<jsp:forward page="online_admission_submit.jsp">
						//			<jsp:param name="language" value="<8=language 8>" />
						//  </jsp:forward>
						//<8
						//}
					}
					message = "admission created.";
				} else {
					message = "admission updated.";
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
						errorMessage = "admission create fail.";
					}
				} else {
					errorMessage = "admission update fail.";
				}
			}
		} else if (deleteAction) {
			System.out.println(new Date() + "[DEBUG] admission.jsp delete aID=<"+admissionID+">");
			if (AdmissionDB.delete(userBean, admissionID)) {
				message = "admission removed.";
			} else {
				errorMessage = "admission remove fail.";
			}
		} else if (createHATSAction) {
			ArrayList record = AdmissionDB.get(admissionID);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				patidno = row.getValue(7);
				patpassport = row.getValue(8);
				patbdate = row.getValue(15);
			}
			if (patidno != null && patidno.length() > 0) {
				record = AdmissionDB.getHATSPatient(null, patidno, patbdate);
			} else if (patpassport != null && patpassport.length() > 0) {
				record = AdmissionDB.getHATSPatient(null, patpassport, patbdate);
			}
			if (record.size() > 0) {
				errorMessage = "patient id and date of birth already exist in HATS.";
			} else {
				if (AdmissionDB.addHATS(userBean, admissionID)) {
					message = "admission created in HATS.";
				} else {
					errorMessage = "HATS is currently busy. Create Entry in HATS Fail.";
				}
			}
		} else if (updateHATSAction) {
			if (AdmissionDB.updateHATS(userBean, admissionID)) {
				message = "admission updated in HATS.";
			} else {
				errorMessage = "admission update fail in HATS.";
			}
		} else if (confirmEmailAction) {
			if (AdmissionDB.sendEmailConfirmClient(userBean, admissionID, "in")) {
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
		} else if (updateBedNoAction) {
			if (newPatno != null && AdmissionDB.updatePatientBedNoOrACM(userBean, bedNo,"",admissionID,patno)) {
				message = "BedNo updated.";
			} else {
				errorMessage = "BedNo is fail to update.";
			}
		} else if (updateACMAction) {
			if (newPatno != null && AdmissionDB.updatePatientBedNoOrACM(userBean,"",hospitalACM,admissionID,patno)) {
				message = "ACM updated.";
			} else {
				errorMessage = "ACM is fail to update.";
			}
		}
		step = null;
	} else {
		expectedAdmissionDate = DateTimeUtil.getCurrentDate();
		coucode = "852";
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		System.out.println(new Date() + "[DEBUG] admission.jsp load aID=<"+admissionID+">");
		if (admissionID != null && admissionID.trim().length() > 0) {
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
				passdocument = row.getValue(9);

				patsex = row.getValue(10);
				racedesc = row.getValue(11);
				racedescOther = row.getValue(12);
				religion = row.getValue(13);
				religionOther = row.getValue(14);

				patbdate = row.getValue(15);
				patmsts = row.getValue(16);
				patmstsOther = row.getValue(98);
				mothcode = row.getValue(17);
				mothcodeOther = row.getValue(18);
				edulevel = row.getValue(19);

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
				patksex1 = row.getValue(35);
				patkrela1 = row.getValue(36);

				patkhtel1 = row.getValue(37);
				patkotel1 = row.getValue(38);
				patkmtel1 = row.getValue(39);
				patkptel1 = row.getValue(40);

				patkemail1 = row.getValue(41);
				patkadd11 = row.getValue(42);
				patkadd21 = row.getValue(43);
				patkadd31 = row.getValue(44);
				patkadd41 = row.getValue(45);

				patkfname2 = row.getValue(46);
				patkgname2 = row.getValue(47);
				patkcname2 = row.getValue(48);
				patksex2 = row.getValue(49);
				patkrela2 = row.getValue(50);

				patkhtel2 = row.getValue(51);
				patkotel2 = row.getValue(52);
				patkmtel2 = row.getValue(53);
				patkptel2 = row.getValue(54);

				patkemail2 = row.getValue(55);
				patkadd12 = row.getValue(56);
				patkadd22 = row.getValue(57);
				patkadd32 = row.getValue(58);
				patkadd42 = row.getValue(59);

				expectedAdmissionDate = row.getValue(60);
				expectedAdmissionTime = row.getValue(61);
				actualAdmissionDate = row.getValue(62);
				actualAdmissionTime = row.getValue(63);
				admissiondoctor = row.getValue(64);
				ward = row.getValue(65);
				roomType = row.getValue(66);
				bedNo = row.getValue(67);
				promotionYN = row.getValue(68);

				paymentType = row.getValue(69);
				paymentTypeOther = row.getValue(70);
				creditCardType = row.getValue(71);
				insuranceRemarks = row.getValue(72);
				insurancePolicyNo = row.getValue(73);
				confirmDate = row.getValue(75);
				remarks = row.getValue(76);
				reached = row.getValue(80);
				registered = row.getValue(81);
				firstViewUser = row.getValue(82);
				firstViewDate = row.getValue(83);
				infoForPromotion = row.getValue(97);
//20181207 Arran added mktsrc
				mktSrc = row.getValue(103);
				// begin : for vpc payment
				paymentStatus = row.getValue(99);
				paymentReceiptNo = row.getValue(101);
				transNo = row.getValue(111) ;
				// end : for vpc payment

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
<jsp:include page="../common/header.jsp">
	<jsp:param name="title" value="Hong Kong Adventist Hospital" />
</jsp:include>
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
	title = "function.admission." + commandType;
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
<a href="javascript:void(0);" onclick="callPopUpWindow('admission_view.jsp?command=print&admissionID=<%=admissionID %>');">Printer Friendly Version</a><br />
<%			} %>
		</td>
	</tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td><font color="red">*</font>Please fill in the form 請填寫有關資料.</td>
	</tr>
</table>
<form name="form1" enctype="multipart/form-data" action="admission.jsp" method="post">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="3">
			<table width="700" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top" colspan="3"><%=MessageResources.getMessageEnglish("label.health.care.advisory") %> <%=MessageResources.getMessageTraditionalChinese("label.health.care.advisory") %> (<a href="javascript:void(0);" onclick="downloadFile('75');return false;" target="_blank">Click here 請按此</a>)</td>
				</tr>
				<tr>
					<td height="20" colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" width="5%">
						<font color="red">*</font>
						<img src="../images/tick_green_small.gif" />
					</td>
					<td valign="top" width="60%">
						I have read this &quot;Health Care Advisory&quot;. I understand and accept that the hospital services will be charged according to my choice of room category. <br />本人已清楚閱讀以上&quot;住院須知&quot;"。本人明白並接受住院收費將根據本人所選擇的房間類別而計算。
					</td>
					<td valign="top" align="center" width="35%"><font color="red">*</font>My room choice is<br />本人選擇房間類別為<br>
<%		if (createAction || updateAction) { %>
						<select name="roomType">
							<option value=""></option>
							<option value="VIP"<%="VIP".toUpperCase().equals(roomType == null ? null : roomType.toUpperCase())?" selected":""%>>VIP 貴賓</option>
							<option value="Private"<%="Private".toUpperCase().equals(roomType == null ? null : roomType.toUpperCase())?" selected":""%>>Private 頭等</option>
							<option value="Semi-Private"<%="Semi-Private".toUpperCase().equals(roomType == null ? null : roomType.toUpperCase())?" selected":""%>>Semi-Private 二等</option>
							<option value="Standard"<%="Standard".toUpperCase().equals(roomType == null ? null : roomType.toUpperCase())?" selected":""%>>Standard 三等</option>
						</select>
<%		} else {
				if ("Private".toUpperCase().equals(roomType == null ? null : roomType.toUpperCase())) {
					%><span class="infoResult">Private 頭等</span><%
				} else if ("Semi-Private".toUpperCase().equals(roomType == null ? null : roomType.toUpperCase())) {
					%><span class="infoResult">Semi-Private 二等</span><%
				} else if ("Standard".toUpperCase().equals(roomType == null ? null : roomType.toUpperCase())) {
					%><span class="infoResult">Standard 三等</span><%
				} else if ("VIP".toUpperCase().equals(roomType == null ? null : roomType.toUpperCase())) {
					%><span class="infoResult">VIP 貴賓</span><%
				}

			} %>
					</td>
				</tr>
			</table>
		</td>
	</tr>
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
			<button onclick="return submitAction('viewHATS', 1);" class="btn-click"><span class="infoResult"><%=patno==null?"":patno %></span></button>
<%		} %>
<%		if (admissionID != null && admissionID.length() > 0) { %>
<%			if (patno == null || patno.length() == 0 || "-1".equals(patno) ) { %>
			<button onclick="return submitAction('createHATS', 1);" class="btn-click" name="btn-createHATS">Generate New Hospital No. to HATS</button><br />
			<font color="red">Possible Hospital No. 可能的醫院編號</font><br />

<table cellpadding="5" class="sample">
<jsp:include page="admission_hats_list.jsp" flush="false">
	<jsp:param name="patidno" value="<%=patidno %>" />
	<jsp:param name="patpassport" value="<%=patpassport %>" />
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
			<button onclick="return checkHATS('');" class="btn-click">Check with HATS</button>
<%				} %>
			<button onclick="return submitAction('updateHATS', 1);" class="btn-click">Update to HATS</button><br />
<%			} %>
<%		} %>
		</td>
	</tr>
  <tr><td>
	<table cellpadding="5" class="sample">
		<jsp:include page="admission_hats_acmBed.jsp" flush="false">
		<jsp:param name="patNo" value="<%=patno %>" />
		<jsp:param name="admNo" value="<%=admissionID %>" />
		<jsp:param name="patientACM" value="<%=roomType %>" />
		<jsp:param name="bedNo" value="<%=bedNo %>" />
		<jsp:param name="admDate" value="<%=expectedAdmissionDate %>" />
		</jsp:include>
	</table>
 </td></tr>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Reached by<br />聯絡自
<%	if (createAction || updateAction) { %>
			<select name="reached">
				<option value=""></option>
				<option value="Email"<%="Email".equals(reached)?" selected":"" %>>Email</option>
				<option value="Phone"<%="Phone".equals(reached)?" selected":"" %>>Phone</option>
				<option value="SMS"<%="SMS".equals(reached)?" selected":"" %>>SMS</option>
				<option value="Upfront"<%="Upfront".equals(reached)?" selected":"" %>>Upfront</option>
			</select>
<%	} else { %>
			<span class="infoResult"><%=reached==null?"":reached %></span>
<%	} %>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
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
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Ward<br />病房
<%	if (createAction || updateAction) { %>
			<select name="ward">
				<option value=""></option>
				<option value="Obstetric"<%="Obstetric".equals(ward)?" selected":"" %>>Obstetric</option>
				<option value="Oncology"<%="Oncology".equals(ward)?" selected":"" %>>Oncology</option>
				<option value="Medical"<%="Medical".equals(ward)?" selected":"" %>>Medical</option>
				<option value="ICU"<%="ICU".equals(ward)?" selected":"" %>>ICU</option>
				<option value="Surgical"<%="Surgical".equals(ward)?" selected":"" %>>Surgical</option>
				<%-- <option value="Integrated"<%="Integrated".equals(ward)?" selected":"" %>>Integrated</option> --%>
				<option value="Pediatric"<%="Pediatric".equals(ward)?" selected":"" %>>Pediatric</option>
				<option value="SSUnit"<%="SSUnit".equals(ward)?" selected":"" %>>Short Stay Unit</option>
				<option value="Medical-Surgical"<%="Medical-Surgical".equals(ward)?" selected":"" %>>Medical-Surgical</option>
				<option value="SCU"<%="SCU".equals(ward)?" selected":"" %>>SCU</option>
		</select>
<%	} else { %>
			<span class="infoResult"><%=ward==null?"":ward %></span>
<%	} %>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Expected admission date & time (DD 日/YYYY 年/ HH 時:MM:分)<br />預定入院日期
<%	if (createAction || updateAction) { %>
			<input type="text" name="expectedAdmissionDate" id="expectedAdmissionDate" class="datepickerfield" value="<%=expectedAdmissionDate==null?"":expectedAdmissionDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="expectedAdmissionTime" />
	<jsp:param name="time" value="<%=expectedAdmissionTime %>" />
</jsp:include>
<%	} else { %>
			<span class="infoResult"><%=expectedAdmissionDate==null?"":expectedAdmissionDate %></span>
			<span class="infoResult"><%=expectedAdmissionTime==null?"":expectedAdmissionTime %></span>
<%	} %>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Admitting Doctor<br />主診醫生
<%	if (createAction || updateAction) { %>
			<input type="text" name="admissiondoctor" value="<%=admissiondoctor==null?"":admissiondoctor %>" maxlength="20" size="25">
<%	} else { %>
			<span class="infoResult"><%=admissiondoctor==null?"":(AdmissionDB.getDocName(admissiondoctor)==null?admissiondoctor:AdmissionDB.getDocName(admissiondoctor)) %></span>
<%	} %>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9" colspan="3">
			Bed No.<br />床位編號
<%	if (createAction || updateAction) { %>
			<input type="text" name="bedNo" value="<%=bedNo==null?"":bedNo %>" maxlength="20" size="25">
<%	} else { %>
			<span class="infoResult"><%=bedNo==null?"":bedNo %></span>
<%	} %>
		</td>
	</tr>
<%	if (!createAction) { %>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" colspan="3" valign="top" bgcolor="#F9F9F9">Remarks<br />註解
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
						<input type="text" name="patidno1" value="<%=patidno1==null?"":patidno1 %>" maxlength="8" size="8" onkeyup="validHKID();" onblur="validHKID()">(<input type="text" name="patidno2" value="<%=patidno2==null?"":patidno2 %>" maxlength="2" size="2" onkeyup="validHKID();" onkeydown="validDOB(event);" onblur="showAdmission();">)
					</td>
				</tr>
				<tr>
					<td>
						<input type="radio" name="patidType" value="passport"<%=patpassport!=null&&patpassport.length()>0?" checked":"" %> onclick="validPassport();">Passport No.<br />護照號碼
						<input type="text" name="patpassport" value="<%=patpassport==null?"":patpassport %>" maxlength="20" size="25" onkeyup="validPassport();">
					</td>
				</tr>
				<tr>
					<td height="20">&nbsp;</td>
				</tr>
				<tr>
					<td>
						Please Attach or Fax Copy of HKID / Passport for Verification Purpose<br />
						<font color="red">**</font>請附上或傳真身份證明或護照文件以作核對<br />
						<input type="file" name="file1" size="30" class="multi" maxlength="5"><br />
						<font color="red">**</font>Fax No 傳真號碼: 36518801
					</td>
				</tr>
			</table>
<%	} else { %>
			Hong Kong I.D. Card<br />香港身份證號碼 <span class="infoResult"><%=patidno1==null?"":patidno1 %>(<%=patidno2==null?"":patidno2 %>)</span><br /><br />
			Passport No.<br />護照號碼 <span class="infoResult"><%=patpassport==null?"":patpassport %></span>
<%	} %>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			<font color="red">*</font>Date of Birth (DD 日/YYYY 年/ HH 時:MM:分)<br />出生日期
<%	if (createAction || updateAction) { %>
			<input type="text" name="patbdate" id="patbdate" class="datepickerfield" value="<%=patbdate==null?"":patbdate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="showAdmission();">
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
				<option value="MR."<%="MR.".equals(titleDesc)?" selected":"" %>>Mr. 先生</option>
				<option value="MRS"<%="MRS".equals(titleDesc)?" selected":"" %>>Mrs. 太太</option>
				<option value="MISS"<%="MISS".equals(titleDesc)?" selected":"" %>>Miss 小姐</option>
				<option value="MS"<%="MS".equals(titleDesc)?" selected":"" %>>Ms. 女士</option>
				<option value="">Others 其他</option>
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
				%><span class="infoResult">Others ¨ä¥L</span><%
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
				<option value="OT"<%="OT".equals(religion)?" selected":"" %>>Others 其他</option>
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
			} else if ("OT".equals(religion)) {
				%><span class="infoResult">Others 其他</span><%
			} else{
				%><span class="infoResult"></span><%
			}
		} %>
			<span id="hats_patmsts" class="alertText"></span><br />
			Others<br />其他 :
<%	if (createAction || updateAction) { %>
			<input type="text" name="patmstsOther" value="<%=patmstsOther==null?"":patmstsOther %>" />
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
			<font color="red">*</font>Ethnic Group<br />種族
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
				<option value="OT"<%="OT".equals(religion)?" selected":"" %>>Others 其他</option>
				<option value="NO"<%="NO".equals(religion)?" selected":"" %>>None 沒有</option>
				<option value="BU"<%="BU".equals(religion)?" selected":"" %>>Buddhism 佛教</option>
				<option value="CA"<%="CA".equals(religion)?" selected":"" %>>Catholic 天主教</option>
				<option value="CH"<%="CH".equals(religion)?" selected":"" %>>Christian 基督教</option>
				<option value="HI"<%="HI".equals(religion)?" selected":"" %>>Hinduism 印度教</option>
				<option value="SH"<%="SH".equals(religion)?" selected":"" %>>Shintoism 日本神道教</option>
				<option value="SD"<%="SD".equals(religion)?" selected":"" %>>SDA 基督復臨安息日教會</option>
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
		} else if ("OT".equals(religion)) {
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
				<option value="Others" <%="Others".equals(edulevel)?" selected":"" %>>Others 其他</option>
				<option value="Primary"<%="Primary".equals(edulevel)?" selected":"" %>>Primary 小學</option>
				<option value="SECONDARY"<%="Secondary".equals(edulevel)?" selected":"" %>>Secondary 中學</option>
				<option value="Tertiary or above"<%="Tertiary or above".equals(edulevel)?" selected":"" %>>Tertiary or above 大專或以上</option>
			</select>
<%	} else { %>
			<span class="infoResult"><%=edulevel==null?"":edulevel %></span>
<%	} %>
			<span id="hats_edulevel" class="alertText"></span>
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
			<font color="red">*</font>Occupation<br />職業
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
			<font color="red">*</font>Contact Telephone Number<br />聯絡電話<br />
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
					<td height="40" valign="top" bgcolor="#F9F9F9">Mobile/Pager No<br />手提號碼/傳呼機號碼
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
			<font color="red">*</font>Sex<br />性別
<%	if (createAction || updateAction) { %>
			<select name="patksex1">
				<option value=""></option>
				<option value="M"<%="M".equals(patksex1)?" selected":"" %>>M 男</option>
				<option value="F"<%="F".equals(patksex1)?" selected":"" %>>F 女</option>
			</select>
<%	} else {
		if ("M".equals(patksex1)) {
			%><span class="infoResult"><bean:message key="label.male" /></span><%
		} else if ("F".equals(patksex1)) {
			%><span class="infoResult"><bean:message key="label.female" /></span><%
		} else {
			%><span class="infoResult"></span><%
		}
	} %>
			<span id="hats_patksex1" class="alertText"></span>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9" colspan=3">
			<font color="red">*</font>Contact Telephone Number<br />聯絡電話<br />
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
					<td height="40" valign="top" bgcolor="#F9F9F9">Mobile<br />手提號碼
<%	if (createAction || updateAction) { %>
						<input type="text" name="patkmtel1" value="<%=patkmtel1==null?"":patkmtel1 %>" maxlength="20" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patkmtel1==null?"":patkmtel1 %></span>
<%	} %>
						<span id="hats_patkmtel1" class="alertText"></span>
					</td>
					<td width="2">&nbsp;</td>
					<td height="40" valign="top" bgcolor="#F9F9F9">Pager No<br />傳呼號碼
<%	if (createAction || updateAction) { %>
						<input type="text" name="patkptel1" value="<%=patkptel1==null?"":patkptel1 %>" maxlength="20" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patkptel1==null?"":patkptel1 %></span>
<%	} %>
						<span id="hats_patkptel1" class="alertText"></span>
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
						<font color="red">*</font>Relationship<br />關係
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
						<input type="radio" name="patkadd41" value="HONG KONG"<%=patkadd41==null||"HONG KONG".equals(patkadd41)?" checked":"" %> />Hong Kong 香港<br />
						<input type="radio" name="patkadd41" value="KOWLOON"<%="KOWLOON".equals(patkadd41)?" checked":"" %> />Kowloon 九龍<br />
						<input type="radio" name="patkadd41" value="NEW TERRITORIES"<%="NEW TERRITORIES".equals(patkadd41)?" checked":"" %> />New Territories 新界
<%	} else { %>
						<span class="infoResult"><%=patkadd11==null?"":patkadd11 %></span>
						<span class="infoResult"><%=patkadd21==null?"":patkadd21 %></span>
						<span class="infoResult"><%=patkadd31==null?"":patkadd31 %></span>
						<span class="infoResult"><%=patkadd41==null?"":patkadd41 %></span>
<%	} %>
						<br /><span id="hats_patkadd11" class="alertText"></span>
						<br /><span id="hats_patkadd21" class="alertText"></span>
						<br /><span id="hats_patkadd31" class="alertText"></span>
					</td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>How did you hear about us 認識本院的途徑:</b> </td>
					<td height="20" valign="top" colspan="4"><%=AdmissionDB.getMktSrcDesc(mktSrc) %></td>
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
		<td height="40" valign="top" bgcolor="#F9F9F9">Sex<br />性別
<%	if (createAction || updateAction) { %>
			<select name="patksex2">
				<option value=""></option>
				<option value="M"<%="M".equals(patksex2)?" selected":"" %>>M 男</option>
				<option value="F"<%="F".equals(patksex2)?" selected":"" %>>F 女</option>
			</select>
<%	} else {
		if ("M".equals(patksex2)) {
			%><span class="infoResult"><bean:message key="label.male" /></span><%
		} else if ("F".equals(patksex2)) {
			%><span class="infoResult"><bean:message key="label.female" /></span><%
		} else {
			%><span class="infoResult"></span><%
		}
	} %>
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
					<td height="40" valign="top" bgcolor="#F9F9F9">Pager No<br />傳呼號碼
<%	if (createAction || updateAction) { %>
						<input type="text" name="patkptel2" value="<%=patkptel2==null?"":patkptel2 %>" maxlength="20" size="25" />
<%	} else { %>
						<span class="infoResult"><%=patkptel2==null?"":patkptel2 %></span>
<%	} %>
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
						<input type="radio" name="patkadd42" value="HONG KONG"<%=patkadd42==null||"HONG KONG".equals(patkadd42)?" checked":"" %> />Hong Kong 香港<br />
						<input type="radio" name="patkadd42" value="KOWLOON"<%="KOWLOON".equals(patkadd42)?" checked":"" %> />Kowloon 九龍<br />
						<input type="radio" name="patkadd42" value="NEW TERRITORIES"<%="NEW TERRITORIES".equals(patkadd42)?" checked":"" %> />New Territories 新界
<%	} else { %>
						<span class="infoResult"><%=patkadd12==null?"":patkadd12 %></span>
						<span class="infoResult"><%=patkadd22==null?"":patkadd22 %></span>
						<span class="infoResult"><%=patkadd32==null?"":patkadd32 %></span>
						<span class="infoResult"><%=patkadd42==null?"":patkadd42 %></span>
<%	} %>
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
					<td class="style1"><font color="white"><strong>Method of Payment 付款方法</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="5">
			*All accounts must either be guaranteed by an insurance company or settled before discharge. Please ensure the insurance or corporate company contracts with this hospital are valid.<br />
			所有賬戶必須由保險公司保證或出院前清付。請確保該保險或企業公司與本院的合約有效。
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="5" height="20">
			<table width="700" border="0" cellspacing="0" cellpadding="0">
				<td valign="top" width="5%">
					<font color="red">*</font>
					<img src="../images/tick_green_small.gif" />
				</td>
				<td valign="top" width="95%">
					I have read and agreed to the terms and conditions detailed on the "Daily Room Rate and Deposit" and then advise on the following (<a href="http://www.hkah.org.hk/new/eng/hospitalization_fi.htm" target="_blank">Click here</a>)<br />
					本人已閱讀及同意"每日房租和預繳按金"並提供以下資料  (<a href="http://www.hkah.org.hk/new/chi/hospitalization_fi.htm" target="_blank">請按此</a>)
				</td>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="20" bgcolor="#F9F9F9">
			<font color="red">*</font>Method of Payment 付款方法
<%	if (createAction || updateAction) { %>
	    	<table width="100%" border="0" cellspacing="1" cellpadding="0">
				<tr>
					<td height="30" bgcolor="#F9F9F9"><input name="paymentType" type="radio" value="CASH"<%=paymentType==null||"CASH".equals(paymentType)?" checked":"" %> />
						Cash 現金

					</td>
					<td height="30" bgcolor="#F9F9F9"><input name="paymentType" type="radio" value="EPS"<%="EPS".equals(paymentType)?" checked":"" %> />
						EPS 易辦事

					</td>
					<td height="30" bgcolor="#F9F9F9"><input name="paymentType" type="radio" value="CREDIT CARD"<%="CREDIT CARD".equals(paymentType)?" checked":"" %> />
						Credit Card 信用卡

						<select name="creditCardType">
							<option value=""></option>
							<option value="Visa"<%="Visa".equals(creditCardType)?" selected":"" %>>Visa</option>
							<option value="Master"<%="Master".equals(creditCardType)?" selected":"" %>>Master</option>
							<option value="JCB"<%="JCB".equals(creditCardType)?" selected":"" %>>JCB</option>
							<option value="Diners"<%="Diners".equals(creditCardType)?" selected":"" %>>Diners</option>
							<option value="AE"<%="AE".equals(creditCardType)?" selected":"" %>>AE</option>
						</select>
					</td>
					<td height="30" bgcolor="#F9F9F9"><input name="paymentType" type="radio" value="CUP CARD"<%="CUP CARD".equals(paymentType)?" checked":"" %> />
						Cup Card 銀聯卡

					</td>
				</tr>
				<tr>
					<td height="5" colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td height="30" bgcolor="#F9F9F9" valign="top"><input name="paymentType" type="radio" value="INSURANCE"<%="INSURANCE".equals(paymentType)?" checked":"" %> />
						Insurance A/C 醫療保險<br />
						Remarks 註解<br />
						<input type="text" name="insuranceRemarks" value="<%=insuranceRemarks==null?"":insuranceRemarks %>" maxlength="100" size="30" /><br />
						Policy No.保險編號<br />
						<input type="text" name="insurancePolicyNo" value="<%=insurancePolicyNo==null?"":insurancePolicyNo %>" maxlength="50" size="30" />
					</td>
					<td height="30" bgcolor="#F9F9F9" valign="top"><input name="paymentType" type="radio" value="CORPORATE"<%="CORPORATE".equals(paymentType)?" checked":"" %> />
						Corporate A/C 公司賬戶

					</td>
					<td height="30" bgcolor="#F9F9F9"><input name="paymentType" type="radio" value="CREDIT CARD AUTH"<%="CREDIT CARD AUTH".equals(paymentType)?" checked":"" %> />
						Credit Card Authorization Form<br />信用卡授權書 (<a href="/upload/Admission at ward/Credit Card Mail Order Authorzation Form.pdf" target="_blank">Click here ½Ð«ö¦¹</a>)
						(for Deposit only只適用於按金)<br /><br />
						Attach or Fax Credit Card copy and Authorization Form<br />
						<font color="red">**</font>請附上或傳真信用卡副本及授權書<br />
						<input type="file" name="file2" size="30" class="multi" maxlength="5"><br />
						<font color="red">**</font>Fax No 傳真號碼: 36518801
					</td>
					<td height="30" bgcolor="#F9F9F9" valign="top"><input name="paymentType" type="radio" value="OTHER"<%="OTHER".equals(paymentType)?" checked":"" %> />
						Others 其他<br /><input type="text" name="paymentTypeOther" value="<%=paymentTypeOther==null?"":paymentTypeOther %>" maxlength="10" size="20" />
					</td>
				</tr>
			</table>
<%	} else {
			if ("CASH".equals(paymentType)) {
				%><span class="infoResult">Cash 現金</span><%
			} else if ("EPS".equals(paymentType)) {
				%><span class="infoResult">EPS 易辦事</span><%
			//} else if ("CREDIT CARD".equals(paymentType)) {
			} else if ("CASH_EPS".equals(paymentType)) {
				%><span class="infoResult">Upon Arrival 於入院當天繳付</span><%
			} else if ("UNION_PAY".equals(paymentType) || "VISA_MASTER".equals(paymentType) || "CREDIT CARD".equals(paymentType) ) {
				%><span class="infoResult">Credit Card 信用卡</span><%
				if (creditCardType != null && creditCardType.length() > 0) {
					%><span class="infoResult"> - <%=creditCardType %></span><%
				}
				// ( begin ) vpc payment
				%><br /><br /><span class="infoResult">&nbsp&nbsp&nbsp Payment Result 付款結果 </span><%
				if ("Y".equals(paymentStatus)) {
					%><span class="infoResult"> - Success 成功</span><br /><%
				} else {
					%><span class="infoResult"> - Failed 失敗</span><br /><%
				}
				%><span class="infoResult">&nbsp&nbsp&nbsp  Credit Card Ref. No. 信用卡 參考号</span><%
				%><span class="infoResult"> - <%=transNo %></span><%
				// ( end )
			} else if ("CUP CARD".equals(paymentType)) {
				%><span class="infoResult">Cup Card 信用卡</span><%
			} else if ("INSURANCE".equals(paymentType)) {
				%><span class="infoResult">Insurance A/C 醫療保險</span><br />
					<%--Remarks 註解 --%>&nbsp;&nbsp;Insurance Company Name 保險公司名稱 : <span class="infoResult"><%=insuranceRemarks==null?"":insuranceRemarks %></span><br />
					<%--Policy No. 保險編號<br /><span class="infoResult"><%=insurancePolicyNo==null?"":insurancePolicyNo %></span>--%><%
			} else if ("CORPORATE".equals(paymentType)) {
				%><span class="infoResult">Corporate A/C 公司賬戶</span><%
			} else if ("CREDIT CARD AUTH".equals(paymentType)) {
				%><span class="infoResult">Credit Card Authorization Form 信用卡授權書</span><%
			} else if ("OTHER".equals(paymentType)) {
				%><span class="infoResult">Others 其他:<%=paymentTypeOther==null?"":paymentTypeOther %></span><%
			}
		} %>
		</td>
	</tr>
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
					<td valign="top">(1)</td><td>The above information given by me is true and correct to the best of my personal knowledge;</td>
				</tr>
				<tr>
					<td valign="top">(2)</td><td>I have read and agreed to the terms and conditions detailed on the "Daily Room Rate and Deposit";</td>
				</tr>
				<tr>
					<td valign="top">(3)</td><td>I have read and agreed to the terms and conditions detailed on the "Health Care Advisory".  I understand and accept that the hospital services will be charge according to my choice of room category;</td>
				</tr>
				<tr>
					<td valign="top">(4)</td><td>I understand that the Hospital is committed to providing healthy menu to patients. To implement the said principal, vegetarian meal is the only choice available in this hospital;</td>
				</tr>
				<tr>
					<td valign="top">(5)</td><td>I receive and acknowledge the terms and conditions detailed on the "Patient Admission" and "Patients' Charter";</td>
				</tr>
				<tr>
					<td valign="top">(6)</td><td>I agree to pay the Hospital¡¦s current rates and charges at the time the services rendered in respect of the facilities used and treatment received by me and all other incidental charges incurred;</td>
				</tr>
				<tr>
					<td valign="top">(7)</td><td>I agree to use solely the medicines provided by the Hospital during the hospitalization;</td>
				</tr>
				<tr>
					<td valign="top">(8)</td><td>I authorize the Hospital to contact my insurer and release my information required regarding my case to the insurance      company for verification of coverage under my insurance policy; and</td>
				</tr>
				<tr>
					<td valign="top">(9)</td><td>I agree to pay any outstanding charges that have not been paid or covered by my insurer.</td>
				</tr>
				<tr>
					<td width="31">&nbsp;</td><td width="669">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">(1)</td><td>本人提供上述的一切資料於本人的個人認知範圍內全屬真實和正確；</td>
				</tr>
				<tr>
					<td valign="top">(2)</td><td>本人已閱讀及同意"每日房租和預繳按金"上的一切條款;</td>
				</tr>
				<tr>
					<td valign="top">(3)</td><td>本人已清楚閱讀及同意"住院須知"上的一切條款。本人明白並接受住院收費將根據本人所選擇的房間類別而計算；</td>
				</tr>
				<tr>
					<td valign="top">(4)</td><td>本人明白醫院致力提供健康膳食給予病人。為履行此目標，醫院膳食部只供應素食餐；</td>
				</tr>
				<tr>
					<td valign="top">(5)</td><td>本人獲悉及接納"入院須知"及"病人權益與責任"上的一切條款；</td>
				</tr>
				<tr>
					<td valign="top">(6)</td><td>本人同意支付一切與本人有關之治療、設施或服務使用，及偶發事故等所需的費用;</td>
				</tr>
				<tr>
					<td valign="top">(7)</td><td>本人同意在留院期間只會使用由醫院供應的藥物;</td>
				</tr>
				<tr>
					<td valign="top">(8)</td><td>本人批准醫院與本人之承保人聯絡並提交與本人有關的病歷資料，以便保險公司作批核保額之覆核程序; 及</td>
				</tr>
				<tr>
					<td valign="top">(9)</td><td>本人同意支付所有額外費用或保險公司所未能承保之費用。</td>
				</tr>
				<tr>
					<td width="31">&nbsp;</td><td width="669">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" colspan="2">
					<ul>
						<li>Patient Admission 入院須知(<a href="javascript:void(0);" onclick="downloadFile('76');return false;" target="_blank">Click here 請按此</a>)</li>
						<li>Patients' Charter 病人權益與責任 (<a href="http://www.hkah.org.hk/new/eng/download/Patient_Charter.pdf" target="_blank">Click here 請按此</a>)</li>
						<li>Why Vegetarian Diet 為什麼要食素 (<a href="http://www.hkah.org.hk/new/eng/download/Why_Vegetarian_Diet.pdf" target="_blank">Click here 請按此</a>)</li>
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
						<input type="checkbox" name="promotionYN" value="Y"<%="Y".equals(promotionYN)?" checked":"" %> />
<%	} else {
			if ("Y".equals(promotionYN)) {
				%><img src="../images/tick_green_small.gif" /><%
			} else {
				%><img src="../images/cross_red_small.gif" /><%
			}
		} %>
					</td>
					<td>We will periodically send you hospital and medical information. If you would like to receive such information, please tick the box.<br />
						我們會為閣下定期寄上本院及醫療資訊。如閣下同意，請於方格上填上剔號。</td>
				</tr>
				<tr>
					<td width="20" valign="top"></td>
					<td><br/><br/>
					<%
						if ("N".equals(infoForPromotion)) {
							%><img src="../images/tick_green_small.gif" /><%
						} else {
							%><img src="../images/cross_red_small.gif" /><%
						}
					%>
					I do not give my consent to the Hospital to use my data for direct marketing of health services and promotion purpose.<br/>
					本人不同意醫院使用本人的個人資料來提供與醫院服務或健康訊息有關的資料。

					</td>
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
<jsp:include page="../registration/important_information.jsp" flush="false">
	<jsp:param name="source" value="registration" />
</jsp:include>
<%if (!createAction) { %>
<jsp:include page="admission_document.jsp" flush="false">
	<jsp:param name="admissionID" value="<%=admissionID %>" />
</jsp:include>
<%} %>
<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="informed consent" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="skipTreeview" value="Y" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
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
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.user.update" /></button>
			<button class="btn-delete"><bean:message key="function.user.delete" /></button>
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
<input type="hidden" name="hospitalACM"/>
<input type="hidden" name="bedNo"/>
<input type="hidden" name="infoForPromotion" value="<%=infoForPromotion%>"/>
<input type="hidden" name="language" value="<%=language%>" />
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
			if (document.form1.roomType.value == '') {
				alert('Empty Room Choice 沒有選擇房間類別.');
				document.form1.roomType.focus();
				return false;
			}
			if (document.form1.expectedAdmissionDate.value == '') {
				alert('Empty Admission Date 沒有輸入入院日期.');
				document.form1.expectedAdmissionDate.focus();
				return false;
			}
			if (!validDate(document.form1.expectedAdmissionDate)) {
				alert('Invalid Admission Date 不正確入院日期.');
				document.form1.expectedAdmissionDate.focus();
				return false;
			}
			if (document.form1.admissiondoctor.value == '') {
				alert('Empty Admission Doctor 沒有輸入主診醫生.');
				document.form1.admissiondoctor.focus();
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
			if (document.form1.patidType[1].checked && document.form1.patpassport.value == '') {
				alert('Empty Passport No. 沒有輸入護照號碼.');
				document.form1.patpassport.focus();
				return false;
			}
			if (document.form1.patsex.value == '') {
				alert('Empty Sex 沒有輸入性別.');
				document.form1.patsex.focus();
				return false;
			}
			if (document.form1.pathtel.value == ''
					&& document.form1.patotel.value == ''
					&& document.form1.patmtel.value == '') {
				alert('Empty Contact Telephone Number 沒有輸入聯絡電話');
				document.form1.pathtel.focus();
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
		} else if (cmd =='updateBedNo') {
			document.form1.command.value = cmd;
			document.form1.step.value = stp;
			document.form1.bedNo.value = pid;
			document.form1.submit();
		} else if (cmd=='updateACM') {
			document.form1.command.value = cmd;
			document.form1.step.value = stp;
			document.form1.hospitalACM.value = pid;
			document.form1.submit();
		} else {
			document.form1.command.value = cmd;
			document.form1.step.value = stp;
			document.form1.newPatno.value = pid;
			if (cmd == 'createHATS') {
				$("button[name=btn-createHATS]").attr("disabled", true);
			}
			document.form1.submit();
		}
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
			patno = document.form1.patno.value;
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

			document.form1.patpassport.value = document.form1.patpassport.value.toUpperCase();
			document.form1.patpassport.focus();
		}
		return false;
	}

	function validDOB(event) {
		if (document.form1.patno.value != '' && event.keyCode == 13) {
			document.form1.patbdate.focus();
		}
	}

	function showAdmission() {
		//preset hidden value
		var patno = document.form1.patno.value;
		var pid1 = document.form1.patidno1.value;
		var pid2 = document.form1.patidno2.value;
		var pid = pid1 + pid2;
		var pp = document.form1.patpassport.value;
		var dob = document.form1.patbdate.value;

		if (patno.length == 0
				&& ((pid1.length > 0 && pid2.length > 0 && pid != '<%=patidno %>') || (pp.length > 0 && pp != '<%=patpassport %>'))
				&& dob.length > 0 && dob != '<%=patbdate %>') {
			http.open('get', 'admission_hats.jsp?command=<%=command %>&patidno=' + pid + '&patpassport=' + pp + '&patbdate=' + dob + '&timestamp=<%=(new java.util.Date()).getTime() %>');

			//assign a handler for the response
			http.onreadystatechange = processResponseAdmission;

			//actually send the request to the server
			http.send(null);
		}
		return false;
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
//-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>
