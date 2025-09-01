<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.Map.*"%>
<%@ page import="java.util.HashMap.*" %>
<%@ page import="java.util.ArrayList.*" %>
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
String step = ParserUtil.getParameter(request, "step");
String conf = ParserUtil.getParameter(request, "conf");
if (conf == null) {
	conf = "1";
}
String stage = ParserUtil.getParameter(request, "stage");

int stageInt = 1;

try {
	stageInt = Integer.parseInt(stage);
} catch (Exception e) {}
boolean isChangeSpecialityMode = "1".equals(ParserUtil.getParameter(request, "changeSpecialityMode"));
String specialty = ParserUtil.getParameter(request, "specialty");
String clientID = ParserUtil.getParameter(request, "clientID");

/* step 1 */
String lastName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "lastName"));
String firstName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "firstName"));
String chineseName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "chineseName"));
String email = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "email"));
String DOBDate = ParserUtil.getParameter(request, "DOBDate");
String travelDocNo = TextUtil.parseStr(ParserUtil.getParameter(request, "travelDocNo")).toUpperCase();

String kinLastName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "kinLastName"));
String kinFirstName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "kinFirstName"));
String kinChineseName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "kinChineseName"));
String kinEmail = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "kinEmail"));
String kinDOBDate = ParserUtil.getParameter(request, "kinDOBDate");
String kinTravelDocNo = TextUtil.parseStr(ParserUtil.getParameter(request, "kinTravelDocNo")).toUpperCase();

String homePhone = ParserUtil.getParameter(request, "homePhone");
String mobilePhone = ParserUtil.getParameter(request, "mobilePhone");
String attendingDoctor = ParserUtil.getParameter(request, "attendingDoctor");
String expectedDeliveryDate = ParserUtil.getParameter(request, "expectedDeliveryDate");
String requestAppointmentDate1 = ParserUtil.getParameter(request, "requestAppointmentDate1");
String requestAppointmentDate2 = ParserUtil.getParameter(request, "requestAppointmentDate2");
String requestAppointmentDate3 = ParserUtil.getParameter(request, "requestAppointmentDate3");
String requestAppointmentDate4 = ParserUtil.getParameter(request, "requestAppointmentDate4");

String insuranceYN = ParserUtil.getParameter(request, "insuranceYN");
String insuranceCompanyID = TextUtil.parseStr(ParserUtil.getParameter(request, "insuranceCompanyID"));
String insuranceCompanyName = TextUtil.parseStr(ParserUtil.getParameter(request, "insuranceCompanyName"));
String insurancePolicyNo = TextUtil.parseStr(ParserUtil.getParameter(request, "insurancePolicyNo"));
String insurancePolicyHolderName = TextUtil.parseStr(ParserUtil.getParameter(request, "insurancePolicyHolderName"));
String insurancePolicyGroup = TextUtil.parseStr(ParserUtil.getParameter(request, "insurancePolicyGroup"));
String insuranceValidThru = TextUtil.parseStr(ParserUtil.getParameter(request, "insuranceValidThru"));

String appointedRoomType = ParserUtil.getParameter(request, "appointedRoomType");
String admissionDate = ParserUtil.getDate(request, "admissionDate");
String surgeryInfo = ParserUtil.getParameter(request, "surgeryInfo");
String typeOfDiagnosis = ParserUtil.getParameter(request, "typeOfDiagnosis");
String typeOfAnaesthesia = ParserUtil.getParameter(request, "typeOfAnaesthesia");
String nameOfProcedure = ParserUtil.getParameter(request, "nameOfProcedure");
String onsetDateOfSymptoms = ParserUtil.getParameter(request, "onsetDateOfSymptoms");
String treatmentPlan = ParserUtil.getParameter(request, "treatmentPlan");
String estimatedLengthOfStay = ParserUtil.getParameter(request, "estimatedLengthOfStay");

String surgeonFee = ParserUtil.getParameter(request, "surgeonFee");
String wardRoundFee = ParserUtil.getParameter(request, "wardRoundFee");
String anaesthetistFee = ParserUtil.getParameter(request, "anaesthetistFee");
String procedureFee = ParserUtil.getParameter(request, "procedureFee");
String procedureFeeAdditional = ParserUtil.getParameter(request, "procedureFeeAdditional");

String confirmPatient = ParserUtil.getParameter(request, "confirmPatient");

String remark_hkah1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah1"));
String remark_ghc1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc1"));

/* step 2 */
String patientID = ParserUtil.getParameter(request, "patientID");
String confirmAppointmentDate1 = ParserUtil.getDate(request, "confirmAppointmentDate1");
String confirmAppointmentDate2 = ParserUtil.getDate(request, "confirmAppointmentDate2");
String confirmAppointmentDate3 = ParserUtil.getDate(request, "confirmAppointmentDate3");
String confirmAppointmentDate4 = ParserUtil.getDate(request, "confirmAppointmentDate4");
String selectAnotherDate = ParserUtil.getDate(request, "selectAnotherDate");
String confirmedRoomType = ParserUtil.getParameter(request, "confirmedRoomType");

String remark_hkah2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah2"));
String remark_ghc2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc2"));

/* step 3 */
String acceptAppointmentDate1 = ParserUtil.getDate(request, "acceptAppointmentDate1");
String acceptAppointmentDate2 = ParserUtil.getDate(request, "acceptAppointmentDate2");
String acceptAppointmentDate3 = ParserUtil.getDate(request, "acceptAppointmentDate3");
String acceptAppointmentDate4 = ParserUtil.getDate(request, "acceptAppointmentDate4");
String acknowledgeAppointmentDate1 = ParserUtil.getDate(request, "acknowledgeAppointmentDate1");
String acknowledgeAppointmentDate2 = ParserUtil.getDate(request, "acknowledgeAppointmentDate2");
String acknowledgeAppointmentDate3 = ParserUtil.getDate(request, "acknowledgeAppointmentDate3");
String acknowledgeAppointmentDate4 = ParserUtil.getDate(request, "acknowledgeAppointmentDate4");

String patientArrivalDate1 = ParserUtil.getDate(request, "patientArrivalDate1");
String flightInfo1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "flightInfo1"));
String transportMethod1 = ParserUtil.getParameter(request, "transportMethod1");
String transportArrangeBy1 = ParserUtil.getParameter(request, "transportArrangeBy1");
String hotalInfo1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "hotalInfo1"));
String hotalArrangeBy1 = ParserUtil.getParameter(request, "hotalArrangeBy1");
String patientReminderDate1 = ParserUtil.getDate(request, "patientReminderDate1");
String patientReminderLetterDate1 = null;
String patientReminderMethod1 = ParserUtil.getParameter(request, "patientReminderMethod1");
String patientReminderRemark1 = ParserUtil.getParameter(request, "patientReminderRemark1");

String remark_hkah3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah3"));
String remark_ghc3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc3"));

/* step 4 */
String confirmDeliveryDate = ParserUtil.getDate(request, "confirmDeliveryDate");
String prebookingConfirmNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "prebookingConfirmNo"));
String paySlipNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "paySlipNo"));
String paySlipDate = ParserUtil.getDate(request, "paySlipDate");
String certIssueDate = ParserUtil.getDate(request, "certIssueDate");

String remark_hkah4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah4"));
String remark_ghc4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc4"));

/* step 5 */
String patientArrivalDate2 = ParserUtil.getDate(request, "patientArrivalDate2");
String flightInfo2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "flightInfo2"));
String transportMethod2 = ParserUtil.getParameter(request, "transportMethod2");
String transportArrangeBy2 = ParserUtil.getParameter(request, "transportArrangeBy2");
String hotalInfo2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "hotalInfo2"));
String hotalArrangeBy2 = ParserUtil.getParameter(request, "hotalArrangeBy2");
String patientReminderDate2 = ParserUtil.getDate(request, "patientReminderDate2");
String patientReminderLetterDate2 = null;
String patientReminderMethod2 = ParserUtil.getParameter(request, "patientReminderMethod2");
String patientReminderRemark2 = ParserUtil.getParameter(request, "patientReminderRemark2");

String remark_hkah5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_hkah5"));
String remark_ghc5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark_ghc5"));

String status = ParserUtil.getParameter(request, "status");
if (status == null) {
	status = "open";
}

//set specialty
boolean isOB = "ob".equals(specialty);
boolean isSurgical = "surgical".equals(specialty);
boolean isHA = "ha".equals(specialty);
boolean isCardiac = "cardiac".equals(specialty);
boolean isOncology = "oncology".equals(specialty);

boolean isConfirmPatient = ConstantsVariable.YES_VALUE.equals(confirmPatient);

boolean isGHC = userBean.isAccessible("function.ghc.client.create");
boolean isPhysician = !isGHC && !userBean.isStaff();
boolean isHKAH = !isPhysician && !isGHC;

String ackDate = null;
String ackUser = null;
String approvalDate = null;
String approvalUser = null;
String createdDate = null;
String createdUser = null;
String modifiedDate = null;
String modifiedUser = null;

String topicDesc = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "topicDesc"));
String requestTo = ParserUtil.getParameter(request, "requestTo");
String comment = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "comment"));
String skipGHC = ParserUtil.getParameter(request, "skipGHC");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean addCommentAction = false;
boolean closeAction = false;
boolean quotationAction = false;
boolean letter1Action = false;
boolean letter2Action = false;
boolean emailAction = false;
boolean ackAction = false;
boolean approvalAction = false;
boolean isConf = "1".equals(conf) || "-1".equals(conf);

String message = null;
String errorMessage = null;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("quotation".equals(command)) {
	quotationAction = true;
} else if ("letter1".equals(command)) {
	letter1Action = true;
} else if ("letter2".equals(command)) {
	letter2Action = true;
} else if ("addComment".equals(command)) {
	addCommentAction = true;
} else if ("email".equals(command)) {
	emailAction = true;
} else if ("ack".equals(command)) {
	ackAction = true;
} else if ("approve".equals(command)) {
	approvalAction = true;
}

if (fileUpload) {
	// create new record
	if (!isChangeSpecialityMode && createAction && "1".equals(step)) {
		// get project id with dummy data
		clientID = GHCClientDB.add(userBean);
	}

	String[] fileList = (String[]) request.getAttribute("filelist");
	String[] regForm = (String []) request.getAttribute("regForm_StringArray");
	String[] prepareSurgery = (String []) request.getAttribute("prepareSurgery_StringArray");
	String[] infoSurgery = (String []) request.getAttribute("infoSurgery_StringArray");

	if (fileList != null) {
		StringBuffer tempStrBuffer = new StringBuffer();

		tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("GHC");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(clientID);
		tempStrBuffer.append(File.separator);
		String baseUrl = tempStrBuffer.toString();

		tempStrBuffer.setLength(0);
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("upload");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append("GHC");
		tempStrBuffer.append(File.separator);
		tempStrBuffer.append(clientID);
		String webUrl = tempStrBuffer.toString();

		boolean skipAttachment = false;
		for (int i = 0; i < fileList.length; i++) {
			skipAttachment = false;

			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
				baseUrl + fileList[i]
			);

			if (fileList[i].equals(treatmentPlan)) {
				// skip treatmentPlan
				skipAttachment = true;
			}
			if (!skipAttachment && regForm != null) {
				for (int j = 0; !skipAttachment && j < regForm.length; j++) {
					if (fileList[i].equals(regForm[j])) {
						// skip registration form
						skipAttachment = true;

						DocumentDB.add(userBean, "ghc.regForm", clientID, webUrl, fileList[i]);
					}
				}
			}
			if (!skipAttachment && prepareSurgery != null) {
				for (int j = 0; !skipAttachment && j < prepareSurgery.length; j++) {
					if (fileList[i].equals(prepareSurgery[j])) {
						// skip prepare surgery
						skipAttachment = true;

						DocumentDB.add(userBean, "ghc.prepareSurgery", clientID, webUrl, fileList[i]);
					}
				}
			}
			if (!skipAttachment && infoSurgery != null) {
				for (int j = 0; !skipAttachment && j < infoSurgery.length; j++) {
					if (fileList[i].equals(infoSurgery[j])) {
						// skip info surgery
						skipAttachment = true;

						DocumentDB.add(userBean, "ghc.infoSurgery", clientID, webUrl, fileList[i]);
					}
				}
			}

			// normal document
			if (!skipAttachment) {
				DocumentDB.add(userBean, "ghc", clientID, webUrl, fileList[i]);
			}
		}
	}
}

if (!isChangeSpecialityMode) {
	try {
		if ("1".equals(step)) {
			if (createAction || updateAction) {
				// get project id with dummy data
				if (createAction && clientID == null) {
					clientID = GHCClientDB.add(userBean);
				}

				if (GHCClientDB.update(userBean,
						clientID, specialty, patientID,
						lastName, firstName, chineseName, 
						email, DOBDate, travelDocNo,
						kinLastName, kinFirstName, kinChineseName, 
						kinEmail, kinDOBDate, kinTravelDocNo,
						homePhone, mobilePhone, attendingDoctor, expectedDeliveryDate,
						requestAppointmentDate1, requestAppointmentDate2,
						requestAppointmentDate3, requestAppointmentDate4,
						selectAnotherDate,
						confirmAppointmentDate1, confirmAppointmentDate2,
						confirmAppointmentDate3, confirmAppointmentDate4,
						acceptAppointmentDate1, acceptAppointmentDate2,
						acceptAppointmentDate3, acceptAppointmentDate4,
						acknowledgeAppointmentDate1, acknowledgeAppointmentDate2,
						acknowledgeAppointmentDate3, acknowledgeAppointmentDate4,
						patientArrivalDate1, flightInfo1, transportMethod1, transportArrangeBy1, hotalInfo1, hotalArrangeBy1,
						patientReminderDate1, patientReminderMethod1, patientReminderRemark1,
						patientArrivalDate2, flightInfo2, transportMethod2, transportArrangeBy2, hotalInfo2, hotalArrangeBy2,
						patientReminderDate2, patientReminderMethod2, patientReminderRemark2,
						confirmDeliveryDate, prebookingConfirmNo, paySlipNo, paySlipDate, certIssueDate,
						insuranceYN, insuranceCompanyID, insuranceCompanyName, insurancePolicyNo,
						insurancePolicyHolderName, insurancePolicyGroup, insuranceValidThru,
						appointedRoomType, admissionDate, surgeryInfo, typeOfDiagnosis, typeOfAnaesthesia,
						nameOfProcedure, onsetDateOfSymptoms, treatmentPlan, estimatedLengthOfStay,
						surgeonFee, wardRoundFee, anaesthetistFee, procedureFee, procedureFeeAdditional,
						confirmPatient, confirmedRoomType,
						remark_hkah1, remark_ghc1,
						remark_hkah2, remark_ghc2,
						remark_hkah3, remark_ghc3,
						remark_hkah4, remark_ghc4,
						remark_hkah5, remark_ghc5,
						String.valueOf(stageInt), conf)) {
					if (isConf) {
						if (stageInt == 0 && "surgical".equals(specialty) && !ConstantsVariable.YES_VALUE.equals(confirmPatient)) {
							if (createAction) {
								message = "client created but the patient is not confirmed yet.";
							} else {
								message = "client updated but the patient is not confirmed yet.";
							}
						} else {
							if (createAction) {
								message = "client created and the system will notify the other parties.";
							} else {
								message = "client updated and the system will notify the other parties.";
							}
						}
					} else {
						if (createAction) {
							message = "client created only. Please choose submit update client when the information is ready to notify the other parties.";
						} else {
							message = "client updated only. Please choose submit update client when the information is ready to notify the other parties.";
						}
					}
					createAction = false;
					updateAction = false;
					step = null;
					command = null;
				} else {
					if (createAction) {
						errorMessage = "client create fail.";
					} else {
						errorMessage = "client update fail.";
					}
				}
			} else if (deleteAction) {
				if (GHCClientDB.delete(userBean, clientID)) {
					message = "client removed.";
					closeAction = true;
					command = null;
					step = null;
				} else {
					errorMessage = "client remove fail.";
				}
			} else if (letter1Action) {
				if (GHCClientDB.updateLetter1(userBean, clientID)) {
					if (isSurgical) {
						GHCClientDB.generateInPatientLetter(userBean, clientID, "letter1");
					} else {
						GHCClientDB.generateAppointmentLetter(userBean, clientID, "letter1");
					}
					command = null;
					step = null;
				} else {
					errorMessage = "generate letter fail.";
				}
			} else if (letter2Action) {
				if (GHCClientDB.updateLetter2(userBean, clientID)) {
					GHCClientDB.generateInPatientLetter(userBean, clientID, "letter2");
					command = null;
					step = null;
				} else {
					errorMessage = "generate letter fail.";
				}
			} else if (addCommentAction) {
				if (GHCClientDB.insertComment(userBean, clientID, topicDesc, requestTo, comment, skipGHC)) {
					message = "comment added.";
					command = null;
					step = null;
				} else {
					errorMessage = "comment add fail.";
				}
				step = null;
			} else if (emailAction){
				if (GHCClientDB.generateInPatientEmail(userBean, clientID)) {
					message = "email sent";
					command = null;
					step = null;
				} else {
					errorMessage = "email fail";
				}
			} else if (ackAction) {
				if (GHCClientDB.acknowledgement(userBean, clientID)) {
					message = "acknowledged";
					command = null;
					step = null;
				} else {
					errorMessage = "acknowledge fail";
				}
			} else if (approvalAction) {
				if (GHCClientDB.approval(userBean, clientID)) {
					message = "approved";
					command = null;
					step = null;
				} else {
					errorMessage = "approve fail";
				}
			}
		} else if (createAction) {
			clientID = "";
			specialty = "ob";
			isOB = true;
			isSurgical = false;
			isHA = false;
			isCardiac = false;
			isOncology = false;
			stageInt = 1;
		}

		// load data from database
		if (!createAction && !"1".equals(step)) {
			if (clientID != null && clientID.length() > 0) {
				ArrayList record = GHCClientDB.get(userBean, clientID);
				if (record.size() > 0) {
					ReportableListObject row = (ReportableListObject) record.get(0);
					patientID = row.getValue(0);
					lastName = row.getValue(1);
					firstName = row.getValue(2);
					chineseName = row.getValue(3);
					email = row.getValue(4);
					DOBDate = row.getValue(5);
					travelDocNo = row.getValue(6);

					kinLastName = row.getValue(7);
					kinFirstName = row.getValue(8);
					kinChineseName = row.getValue(9);
					kinEmail = row.getValue(10);
					kinDOBDate = row.getValue(11);
					kinTravelDocNo = row.getValue(12);

					homePhone = row.getValue(13);
					mobilePhone = row.getValue(14);
					// indicate which specialty is currently using
					specialty = row.getValue(15);
					attendingDoctor = row.getValue(16);
					expectedDeliveryDate = row.getValue(17);
					requestAppointmentDate1 = row.getValue(18);
					requestAppointmentDate2 = row.getValue(19);
					requestAppointmentDate3 = row.getValue(20);
					requestAppointmentDate4 = row.getValue(21);
					confirmAppointmentDate1 = row.getValue(22);
					confirmAppointmentDate2 = row.getValue(23);
					confirmAppointmentDate3 = row.getValue(24);
					confirmAppointmentDate4 = row.getValue(25);

					acceptAppointmentDate1 = row.getValue(26);
					acceptAppointmentDate2 = row.getValue(27);
					acceptAppointmentDate3 = row.getValue(28);
					acceptAppointmentDate4 = row.getValue(29);
					acknowledgeAppointmentDate1 = row.getValue(30);
					acknowledgeAppointmentDate2 = row.getValue(31);
					acknowledgeAppointmentDate3 = row.getValue(32);
					acknowledgeAppointmentDate4 = row.getValue(33);

					patientArrivalDate1 = row.getValue(34);
					flightInfo1 = row.getValue(35);
					transportMethod1 = row.getValue(36);
					transportArrangeBy1 = row.getValue(37);
					hotalInfo1 = row.getValue(38);
					hotalArrangeBy1 = row.getValue(39);
					patientReminderLetterDate1 = row.getValue(40);
					patientReminderDate1 = row.getValue(41);
					patientReminderMethod1 = row.getValue(42);
					patientReminderRemark1 = row.getValue(43);

					patientArrivalDate2 = row.getValue(44);
					flightInfo2 = row.getValue(45);
					transportMethod2 = row.getValue(46);
					transportArrangeBy2 = row.getValue(47);
					hotalInfo2 = row.getValue(48);
					hotalArrangeBy2 = row.getValue(49);
					patientReminderLetterDate2 = row.getValue(50);
					patientReminderDate2 = row.getValue(51);
					patientReminderMethod2 = row.getValue(52);
					patientReminderRemark2 = row.getValue(53);

					confirmDeliveryDate = row.getValue(54);
					prebookingConfirmNo = row.getValue(55);
					paySlipNo = row.getValue(56);
					paySlipDate = row.getValue(57);
					certIssueDate = row.getValue(58);

					insuranceYN = row.getValue(59);
					insuranceCompanyID = row.getValue(60);
					insuranceCompanyName = row.getValue(61);
					insurancePolicyNo = row.getValue(62);
					insurancePolicyHolderName = row.getValue(63);
					insurancePolicyGroup = row.getValue(64);
					insuranceValidThru = row.getValue(65);

					appointedRoomType = row.getValue(66);
					admissionDate = row.getValue(67);
					surgeryInfo = row.getValue(68);
					typeOfDiagnosis = row.getValue(69);
					typeOfAnaesthesia = row.getValue(70);
					nameOfProcedure = row.getValue(71);
					onsetDateOfSymptoms = row.getValue(72);
					treatmentPlan = row.getValue(73);
					estimatedLengthOfStay = row.getValue(74);

					surgeonFee = row.getValue(75);
					wardRoundFee = row.getValue(76);
					anaesthetistFee = row.getValue(77);
					procedureFee = row.getValue(78);
					procedureFeeAdditional = row.getValue(79);

					confirmPatient = row.getValue(80);
					confirmedRoomType = row.getValue(81);

					remark_hkah1 = row.getValue(82);
					remark_hkah2 = row.getValue(83);
					remark_hkah3 = row.getValue(84);
					remark_hkah4 = row.getValue(85);
					remark_hkah5 = row.getValue(86);
					remark_ghc1 = row.getValue(87);
					remark_ghc2 = row.getValue(88);
					remark_ghc3 = row.getValue(89);
					remark_ghc4 = row.getValue(90);
					remark_ghc5 = row.getValue(91);

					// indicate which stage is currently using
					stage = row.getValue(92);
					try {
						stageInt = Integer.parseInt(stage);
					} catch (Exception e) {
						stageInt = 1;
					}
					status = row.getValue(93);
					ackDate = row.getValue(94);
					ackUser = row.getValue(95);
					approvalDate = row.getValue(96);
					approvalUser = row.getValue(97);
					createdDate = row.getValue(98);
					createdUser = row.getValue(99);
					modifiedDate = row.getValue(100);
					modifiedUser = row.getValue(101);

					isSurgical = "surgical".equals(specialty);
					isHA = "ha".equals(specialty);
					isCardiac = "cardiac".equals(specialty);
					isOncology = "oncology".equals(specialty);
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
}

// set next parties
String[] partyArray;
Map<Integer, ArrayList<String>> stepMap = new HashMap<Integer, ArrayList<String>>();
ArrayList<String> step1List = new ArrayList<String>();
ArrayList<String> step2List = new ArrayList<String>();
ArrayList<String> step3List = new ArrayList<String>();
ArrayList<String> step4List = new ArrayList<String>();

if (isSurgical) {
	partyArray = new String[] { "GHC", "Physician", "HKAH", "GHC" };
	stepMap.put(1,step1List);
	stepMap.put(2,step2List);
	stepMap.put(3,step2List);
	stepMap.put(4,step2List);
	step1List.add("GHC");
	step2List.add("HKAH");
	step2List.add("Physician");
	step3List.add("HKAH");
	step4List.add("GHC");
} else {
	partyArray = new String[] { "GHC", "HKAH", "GHC", "HKAH", "GHC" };	
	stepMap.put(1,step1List);
	stepMap.put(2,step2List);
	stepMap.put(3,step3List);
	stepMap.put(4,step4List);
	step1List.add("GHC");
	step2List.add("HKAH");
	step2List.add("Physician");
	step3List.add("HKAH");
	step4List.add("GHC");
}

//GHCClientDB.generateInPatientEmail(userBean, clientID);

String nextParty = null;
String prevParty = null;
try { nextParty = partyArray[stageInt]; } catch (Exception e) {}
try { prevParty = partyArray[stageInt - 2]; } catch (Exception e) {}

// store value into request
request.setAttribute("command", command);
request.setAttribute("stage", String.valueOf(stageInt));
request.setAttribute("specialty", specialty);
request.setAttribute("clientID", clientID);

/* surgery */
request.setAttribute("insuranceYN", insuranceYN);
request.setAttribute("insuranceCompanyID", insuranceCompanyID);
request.setAttribute("insuranceCompanyName", TextUtil.parseStrISO(insuranceCompanyName));
request.setAttribute("insurancePolicyNo", TextUtil.parseStrISO(insurancePolicyNo));
request.setAttribute("insurancePolicyHolderName", TextUtil.parseStrISO(insurancePolicyHolderName));
request.setAttribute("insurancePolicyGroup", TextUtil.parseStrISO(insurancePolicyGroup));
request.setAttribute("insuranceValidThru", insuranceValidThru);
request.setAttribute("appointedRoomType", appointedRoomType);
request.setAttribute("admissionDate", admissionDate);
request.setAttribute("surgeryInfo", surgeryInfo);
request.setAttribute("typeOfDiagnosis", typeOfDiagnosis);
request.setAttribute("typeOfAnaesthesia", typeOfAnaesthesia);
request.setAttribute("nameOfProcedure", nameOfProcedure);
request.setAttribute("onsetDateOfSymptoms", onsetDateOfSymptoms);
request.setAttribute("treatmentPlan", treatmentPlan);
request.setAttribute("estimatedLengthOfStay", estimatedLengthOfStay);
request.setAttribute("surgeonFee", surgeonFee);
request.setAttribute("wardRoundFee", wardRoundFee);
request.setAttribute("anaesthetistFee", anaesthetistFee);
request.setAttribute("procedureFee", procedureFee);
request.setAttribute("procedureFeeAdditional", procedureFeeAdditional);
request.setAttribute("confirmPatient", confirmPatient);
request.setAttribute("confirmedRoomType", confirmedRoomType);

/* step 1 */
request.setAttribute("lastName", TextUtil.parseStrISO(lastName));
request.setAttribute("firstName", TextUtil.parseStrISO(firstName));
request.setAttribute("chineseName", TextUtil.parseStrISO(chineseName));
request.setAttribute("email", email);

request.setAttribute("DOBDate", DOBDate);
request.setAttribute("travelDocNo", travelDocNo);
request.setAttribute("homePhone", homePhone);
request.setAttribute("mobilePhone", mobilePhone);
request.setAttribute("attendingDoctor", attendingDoctor);
request.setAttribute("expectedDeliveryDate", expectedDeliveryDate);
request.setAttribute("requestAppointmentDate1", requestAppointmentDate1);
request.setAttribute("requestAppointmentDate2", requestAppointmentDate2);
request.setAttribute("requestAppointmentDate3", requestAppointmentDate3);
request.setAttribute("requestAppointmentDate4", requestAppointmentDate4);

request.setAttribute("remark_hkah1", TextUtil.parseStrISO(remark_hkah1));
request.setAttribute("remark_ghc1", TextUtil.parseStrISO(remark_ghc1));

/* step 2 */
request.setAttribute("patientID", patientID);
request.setAttribute("confirmAppointmentDate1", confirmAppointmentDate1);
request.setAttribute("confirmAppointmentDate2", confirmAppointmentDate2);
request.setAttribute("confirmAppointmentDate3", confirmAppointmentDate3);
request.setAttribute("confirmAppointmentDate4", confirmAppointmentDate4);
request.setAttribute("selectAnotherDate", selectAnotherDate);
request.setAttribute("confirmedRoomType", confirmedRoomType);

request.setAttribute("remark_hkah2", TextUtil.parseStrISO(remark_hkah2));
request.setAttribute("remark_ghc2", TextUtil.parseStrISO(remark_ghc2));

/* step 3 */
request.setAttribute("acceptAppointmentDate1", acceptAppointmentDate1);
request.setAttribute("acceptAppointmentDate2", acceptAppointmentDate2);
request.setAttribute("acceptAppointmentDate3", acceptAppointmentDate3);
request.setAttribute("acceptAppointmentDate4", acceptAppointmentDate4);
request.setAttribute("acknowledgeAppointmentDate1", acknowledgeAppointmentDate1);
request.setAttribute("acknowledgeAppointmentDate2", acknowledgeAppointmentDate2);
request.setAttribute("acknowledgeAppointmentDate3", acknowledgeAppointmentDate3);
request.setAttribute("acknowledgeAppointmentDate4", acknowledgeAppointmentDate4);

request.setAttribute("patientArrivalDate1", patientArrivalDate1);
request.setAttribute("flightInfo1", flightInfo1);
request.setAttribute("transportMethod1", transportMethod1);
request.setAttribute("transportArrangeBy1", transportArrangeBy1);
request.setAttribute("hotalInfo1", hotalInfo1);
request.setAttribute("hotalArrangeBy1", hotalArrangeBy1);
request.setAttribute("patientReminderDate1", patientReminderDate1);
request.setAttribute("patientReminderLetterDate1", patientReminderLetterDate1);
request.setAttribute("patientReminderMethod1", patientReminderMethod1);
request.setAttribute("patientReminderRemark1", patientReminderRemark1);

request.setAttribute("remark_hkah3", TextUtil.parseStrISO(remark_hkah3));
request.setAttribute("remark_ghc3", TextUtil.parseStrISO(remark_ghc3));

/* step4 */
request.setAttribute("confirmDeliveryDate", confirmDeliveryDate);
request.setAttribute("prebookingConfirmNo", prebookingConfirmNo);
request.setAttribute("paySlipNo", paySlipNo);
request.setAttribute("paySlipDate", paySlipDate);
request.setAttribute("certIssueDate", certIssueDate);

request.setAttribute("remark_hkah4", TextUtil.parseStrISO(remark_hkah4));
request.setAttribute("remark_ghc4", TextUtil.parseStrISO(remark_ghc4));

/* step 5 */
request.setAttribute("patientArrivalDate2", patientArrivalDate2);
request.setAttribute("flightInfo2", flightInfo2);
request.setAttribute("transportMethod2", transportMethod2);
request.setAttribute("transportArrangeBy2", transportArrangeBy2);
request.setAttribute("hotalInfo2", hotalInfo2);
request.setAttribute("hotalArrangeBy2", hotalArrangeBy2);
request.setAttribute("patientReminderDate2", patientReminderDate2);
request.setAttribute("patientReminderLetterDate2", patientReminderLetterDate2);
request.setAttribute("patientReminderMethod2", patientReminderMethod2);
request.setAttribute("patientReminderRemark2", patientReminderRemark2);

request.setAttribute("remark_hkah5", TextUtil.parseStrISO(remark_hkah5));
request.setAttribute("remark_ghc5", TextUtil.parseStrISO(remark_ghc5));

String allowRemove = createAction || updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
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
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=Frame>
<%
	String title = null;
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
	title = "function.ghc.client." + commandType;
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<form name="form1" id="form1" enctype="multipart/form-data" action="apply.jsp" method="post">
<table width="100%">
	<tr>
		<td>
			<ul id="tabList">
<%	if (createAction) { %>
			<li><a href="javascript:changeSpeciality('ob');" tabId="tab1" id="tab1" class="link<%=isOB?"":"Un" %>Selected"><span><bean:message key="label.ob" /></span></a></li>
			<li><a href="javascript:changeSpeciality('surgical');" tabId="tab2" id="tab2" class="link<%=isSurgical?"":"Un" %>Selected"><span><bean:message key="label.surgical" /></span></a></li>
			<li><a href="javascript:changeSpeciality('ha');" tabId="tab3" id="tab3" class="link<%=isHA?"":"Un" %>Selected"><span><bean:message key="label.ha" /></span></a></li>
			<li><a href="javascript:changeSpeciality('cardiac');" tabId="tab4" id="tab4" class="link<%=isCardiac?"":"Un" %>Selected"><span><bean:message key="label.cardiac" /></span></a></li>
			<li><a href="javascript:changeSpeciality('oncology');" tabId="tab5" id="tab5" class="link<%=isOncology?"":"Un" %>Selected"><span><bean:message key="label.oncology" /></span></a></li>
<%	} else if (isOB) { %>
			<li><a href="javascript:void(0);" tabId="tab1" id="tab1" class="linkSelected"><span><bean:message key="label.ob" /></span></a></li>
<%	} else if (isSurgical) { %>
			<li><a href="javascript:void(0);" tabId="tab2" id="tab2" class="linkSelected"><span><bean:message key="label.surgical" /></span></a></li>
<%	} else if (isHA) { %>
			<li><a href="javascript:void(0);" tabId="tab3" id="tab3" class="linkSelected"><span><bean:message key="label.ha" /></span></a></li>
<%	} else if (isCardiac) { %>
			<li><a href="javascript:void(0);" tabId="tab4" id="tab4" class="linkSelected"><span><bean:message key="label.cardiac" /></span></a></li>
<%	} else if (isOncology) { %>
			<li><a href="javascript:void(0);" tabId="tab5" id="tab5" class="linkSelected"><span><bean:message key="label.oncology" /></span></a></li>
<%	} %>
			</ul>
		</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
<%if (quotationAction) { %>
<jsp:include page="quotation.jsp" flush="false" />
<%} else { %>
<!-- Step 1 ======================================================================================================= -->
<%		if (isSurgical) { %>
<jsp:include page="apply_step1_surgery.jsp" flush="false" />
<%		} else { %>
<jsp:include page="apply_step1.jsp" flush="false" />
<%		} %>
<%		if (ackUser == null || ackUser.length() == 0) { %>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Acknowledgement</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Waiting for Acknowledgement</td>
		<td class="infoData" width="80%" colspan="3">
<%			if ("rachel.yeung".equals(userBean.getLoginID())) { %>
				<button onclick="return submitAction('ack', 1, 1);" class="btn-click">Click to Acknowledge</button>
<%			} %>
		</td>
	</tr>
<%		} else if (approvalUser == null || approvalUser.length() == 0) { %>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Approval</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Waiting for Approval</td>
		<td class="infoData" width="80%" colspan="3">
<%			if ("rachel.yeung".equals(userBean.getLoginID())) { %>
				<button onclick="return submitAction('approve', 1, 1);" class="btn-click">Click to Approve</button>
<%			} %>
		</td>
	</tr>
<%		} else { %>
<%			if (stageInt >= 2) { %>
<!-- Step 2 ======================================================================================================= -->
<%				if (isSurgical) { %>
<jsp:include page="apply_step2_surgery.jsp" flush="false" />
<%				} else { %>
<jsp:include page="apply_step2.jsp" flush="false" />
<%				} %>
<%			} %>
<%			if (stageInt >= 3) { %>
<!-- Step 3 ======================================================================================================= -->
<%				if (isSurgical) { %>
<jsp:include page="apply_step3_surgery.jsp" flush="false" />
<%				} else { %>
<jsp:include page="apply_step3.jsp" flush="false" />
<%				} %>
<%			} %>
<%			if (stageInt >= 4) { %>
<!-- Step 4 ======================================================================================================= -->
<%				if (isSurgical) { %>
<jsp:include page="apply_step4_surgery.jsp" flush="false" />
<%				} else if (isOB) { %>
<jsp:include page="apply_step4_ob.jsp" flush="false" />
<%				} %>
<%			} if (stageInt >= 5 && isOB) { %>
<!-- Step 5 ======================================================================================================= -->
<jsp:include page="apply_step5_ob.jsp" flush="false" />
<%			} %>
<%		} %>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Record Infomation</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.createdDate" /></td>
		<td class="infoData" width="30%"><%=createdDate==null?"":createdDate %></td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.status" /></td>
		<td class="infoData" width="30%"><%=status==null?"":status.toUpperCase() %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.modifiedDate" /></td>
		<td class="infoData" width="30%"><%=modifiedDate==null?"":modifiedDate %></td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.lastModifiedBy" /></td>
		<td class="infoData" width="30%"><%=modifiedUser==null?"":modifiedUser %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Acknowledge Date</td>
		<td class="infoData" width="30%"><%=ackDate==null?"":ackDate %></td>
		<td class="infoLabel" width="20%">Acknowledge User</td>
		<td class="infoData" width="30%"><%=ackUser==null?"":ackUser %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Approval Date</td>
		<td class="infoData" width="30%"><%=approvalDate==null?"":approvalDate %></td>
		<td class="infoLabel" width="20%">Approval User</td>
		<td class="infoData" width="30%"><%=approvalUser==null?"":approvalUser %></td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Attachment for HKAH</td>
	</tr>
	<tr class="smallText">
		<td colspan="4">
<%	if (createAction || updateAction) {%>
		<input type="file" name="file1" size="50" class="multi" maxlength="10">
<%	} %>
<%	if (!createAction) { %>
		<span id="ghc_indicator">
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ghc" />
	<jsp:param name="keyID" value="<%=clientID %>" />
	<jsp:param name="allowRemove" value="<%=allowRemove %>" />
</jsp:include>
		</span>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoTitle" colspan="4">Important Infomation</td>
	</tr>
	<tr class="smallText">
		<td colspan="4">
			<ul id="browser" class="filetree">
<jsp:include page="../registration/important_information.jsp" flush="false" />
			</ul>
		</td>
	</tr>
<%} %>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td><font color="red">*</font>Please fill in the form.</td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 1, 0);" class="btn-click">Save Changes</button>
			<button onclick="return submitAction('view', 0, 0);" class="btn-click">Cancel Changes</button>
<%	} else { %>
			<button onclick="return submitAction('update', 0, 0);" class="btn-click"><bean:message key="function.ghc.client.update" /></button>
			<button class="btn-delete"><bean:message key="function.ghc.client.delete" /></button>
<%	}  %>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td align="center">
<%
	ArrayList getAccessUser = stepMap.get(stageInt);
	if ((createAction || updateAction || deleteAction)
		//&& partyArray.length > stageInt
		  && getAccessUser != null
		&& (
//			(isGHC && "GHC".equals(partyArray[stageInt]))
			(isGHC && getAccessUser.contains("GHC"))
//			|| (isPhysician && "Physician".equals(partyArray[stageInt]))
			|| (isPhysician && getAccessUser.contains("Physician"))
//			|| (isHKAH && "HKAH".equals(partyArray[stageInt]))
			|| (isHKAH && getAccessUser.contains("HKAH"))
			)) {
%>
<%		if (nextParty != null) { %>
			<button onclick="return submitAction('<%=commandType %>', 1, 1);" class="btn-click">Submit to <%=nextParty %> (Go to Next Step)</button>
<%		} %>
<%		if (prevParty != null) { %>
			<button onclick="return submitAction('<%=commandType %>', 1, -1);" class="btn-click">Return back to <%=prevParty %> (Go to Previous Step)</button>
<%		} %>
<%	}  %>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
</div>
<%if (!createAction && !updateAction && !deleteAction && !quotationAction) { %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Discussion</td>
	</tr>
	<tr class="smallText">
		<td class="infoData" colspan="2">
			<div id="rr_listing">
				<table border="0" width="100%" cellspacing="0" cellpadding="0">
<jsp:include page="comment_history.jsp" flush="false">
	<jsp:param name="clientID" value="<%=clientID %>" />
</jsp:include>
				</table>
			</div>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Topic</td>
		<td class="infoData" width="70%"><input type="textfield" name="topicDesc" value="" maxlength="100" size="50"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Request To</td>
		<td class="infoData" width="70%">
			<select name="requestTo">
<%	if (isGHC) { %>
				<option value="hkah">HKAH</option>
<%	} else { %>
				<option value="ghc"<%="ghc".equals(requestTo)?" selected":"" %>>GHC</option>
				<option value="ob"<%="ob".equals(requestTo)?" selected":"" %>><bean:message key="label.ob" /></option>
				<option value="surgical"<%="surgical".equals(requestTo)?" selected":"" %>><bean:message key="label.surgical" /></option>
				<option value="ha"<%="ha".equals(requestTo)?" selected":"" %>><bean:message key="label.ha" /></option>
				<option value="cardiac"<%="cardiac".equals(requestTo)?" selected":"" %>><bean:message key="label.cardiac" /></option>
				<option value="oncology"<%="oncology".equals(requestTo)?" selected":"" %>><bean:message key="label.oncology" /></option>
<%	} %>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Comment</td>
		<td class="infoData" width="70%">
			<div class="box"><textarea id="wysiwyg" name="comment" rows="6" cols="100"></textarea></div>
		</td>
	</tr>
<%	if (!isGHC) { %>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Hidden to GHC</td>
		<td class="infoData" width="70%">
			<input type="checkbox" name="skipGHC" value="Y"><bean:message key="label.yes" />
		</td>
	</tr>
<%	} %>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitAction('addComment', 1, 0);" class="btn-click">Submit Comment</button>
		</td>
	</tr>
</table>
</div>
<%} %>
<input type="hidden" name="command" value="<%=commandType %>" />
<input type="hidden" name="step" />
<input type="hidden" name="conf" />
<input type="hidden" name="clientID" value="<%=clientID==null?"":clientID %>" />
<input type="hidden" name="specialty" value="<%=specialty==null?"":specialty %>" />
<input type="hidden" name="changeSpecialityMode" value="0" />
<input type="hidden" name="stage" value="<%=stageInt %>" />
<input type="hidden" name="documentID" />
</form>
<script language="javascript">
<!--
	function changeSpeciality(s) {
		document.form1.specialty.value = s;
		document.form1.changeSpecialityMode.value = 1;
		document.form1.submit();
	}

	function submitAction(cmd, stp, conf) {
		document.form1.action = "apply.jsp";
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.conf.value = conf;

		if (conf == 1) {
			if (submitAction_step<%=stageInt %>(cmd, stp, conf)) {
				$.prompt('The information is about to submit.',{
					buttons: { Ok: true, Cancel: false },
					callback: function(v,m,f){
						if (v){
							submit: confirmAction();
							return true;
						} else {
							return false;
						}
					},
					prefix:'cleanblue'
				});
			}
		} else if (cmd == 'create') {
			if (submitAction_step<%=stageInt %>(cmd, stp, conf)) {
				confirmAction();
			} else {
				return false;
			}
		} else {
			confirmAction();
		}
	}

	function confirmAction(cmd, stp, conf) {
		document.form1.submit();
	}

	// ajax
	var http = createRequestObject();

	function calculateAppointmentDate() {
		var expectedDeliveryDate = document.form1.expectedDeliveryDate.value;
		$.ajax({
			type: "POST",
			url: "calculateAppointmentDateRange.jsp",
			data: "expectedDeliveryDate=" + expectedDeliveryDate,
			success: function(values){
			if(values != '') {
				$("#showAppointmentDate_indicator").html(values);
			}//if
			}//success
		});//$.ajax

		return false;
	}

	function showhide(i, hideobj, showobj, showhidelink, hidelink, showlink){
		var showelem = document.getElementById(showobj + i);
		var hideelem = document.getElementById(hideobj + i);
		var linkelem=document.getElementById(showhidelink + i);

		showelem.style.display=showelem.style.display=='none'?'inline':'none';
		hideelem.style.display=hideelem.style.display=='none'?'inline':'none';

		if (hideelem.style.display=='none'){
			linkelem.className = "invisible";
			linkelem.innerHTML = showlink;
		} else {
			linkelem.className = "visible";
			linkelem.innerHTML = hidelink;
		}
	}

	function removeDocument(mid, did) {
		$.ajax({
			type: "POST",
			url: "../common/document_list.jsp",
			data: "command=delete&moduleCode=" + mid + "&keyID=<%=clientID %>&documentID=" + did + "&allowRemove=<%=updateAction?"Y":"N" %>",
			success: function(values){
			if(values != '') {
				$("#" + mid + "_indicator").html(values);
			}//if
			}//success
		});//$.ajax

		return false;
	}

	function changeAttendingDoctor() {
		var doctorName = document.form1.attendingDoctor.value;
		var doctorCode = '';
		if (doctorName == 'DR. CHAN, YIK MING JOE') {
			doctorCode = '1168';
		} else if (doctorName == 'DR. PANG, MAN WAH SELINA') {
			doctorCode = '1499';
		} else if (doctorName == 'DR. NGAI, SUK WAI CORA') {
			doctorCode = '1256';
		} else if (doctorName == 'DR. LEE, MONICA') {
			doctorCode = '791';
		} else if (doctorName == 'DR. KING, PETER') {
			doctorCode = '197';
		} else if (doctorName == 'DR. TSEUNG VICTOR') {
			doctorCode = '983';
		} else if (doctorName == 'DR. KWAN, TIM LOK HENRY') {
			doctorCode = '1494';
		} else if (doctorName == 'DR. KWOK, PO YIN SAMUEL') {
			doctorCode = '1420';
		}

		if (doctorCode != '') {
			$.ajax({
				type: "POST",
				url: "scheduleList.jsp",
				data: "doctorCode=" + doctorCode,
				success: function(values){
				if(values != '') {
					$("#doctorSchedule_indicator").html(values);
				} else {
					$("#doctorSchedule_indicator").html('');
				}//if
				}//success
			});//$.ajax
		}

		return false;
	}

<%	if (letter1Action) { %>
	callPopUpWindow('/intranet/FopServlet?fo=<%=ConstantsServerSide.UPLOAD_WEB_FOLDER %>/GHC/<%=clientID %>/letter1.fo');
<%	} else if (letter2Action) { %>
	callPopUpWindow('/intranet/FopServlet?fo=<%=ConstantsServerSide.UPLOAD_WEB_FOLDER %>/GHC/<%=clientID %>/letter2.fo');
<%	} %>

<%	if (message != null) { %>
	alert('<%=message %>');
<%	} else if (errorMessage != null) { %>
	alert('<%=errorMessage %>');
<%	} %>
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>