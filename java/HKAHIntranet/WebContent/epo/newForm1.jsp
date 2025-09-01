<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.jasper.*"%>

<%! 
	private String[] splitInfo(String info) {
		int j = 0;
		String currentInfo[] = new String[99];
		for(j = 0; info.toString().indexOf("||") > -1 && j < 10; j++) {
			currentInfo[j] = info.toString()
								.substring(0, info.toString().indexOf("||"));
			
			info = info.toString()
								.substring(info.toString().indexOf("||")+2, 
										info.toString().length());
		}
		currentInfo[j] = info.toString();
		
		return currentInfo;
	}

	private boolean isInteger(String i) {
		try {  
			Integer.parseInt(i);
		    return true;
		}  
		catch(Exception e)  
		{  
			return false;
		}  
	}
	
	
	private boolean AttachmentUpload(UserBean userBean, String[] fileList, String fupirflwID) {
		if (fileList != null) {
			//System.out.println(fileList);
		
			StringBuffer tempStrBuffer = new StringBuffer();
	
			tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("PIReport");
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("Flwup");
			tempStrBuffer.append(File.separator);									
			tempStrBuffer.append(fupirflwID);
			tempStrBuffer.append(File.separator);
			String baseUrl = tempStrBuffer.toString();
	
			tempStrBuffer.setLength(0);
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("upload");
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("PIReport");
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("Flwup");
			tempStrBuffer.append(File.separator);									
			tempStrBuffer.append(fupirflwID);
			String webUrl = tempStrBuffer.toString();
	
			for (int j = 0; j < fileList.length; j++) {
	
				FileUtil.moveFile(
					ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[j],
					baseUrl + fileList[j]
				);						
				DocumentDB.add(userBean, "flwup", fupirflwID, webUrl, fileList[j]);
			}
		}

		return true;
	}	

	private boolean AttachmentUploadPostExamForm(UserBean userBean, String[] fileList, String pirID) {
		if (fileList != null) {
			//System.out.println(fileList);
		
			StringBuffer tempStrBuffer = new StringBuffer();
	
			tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("PIReport");
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("PostExamForm");
			tempStrBuffer.append(File.separator);									
			tempStrBuffer.append(pirID);
			tempStrBuffer.append(File.separator);
			String baseUrl = tempStrBuffer.toString();
	
			tempStrBuffer.setLength(0);
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("upload");
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("PIReport");
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("PostExamForm");
			tempStrBuffer.append(File.separator);									
			tempStrBuffer.append(pirID);
			String webUrl = tempStrBuffer.toString();
	
			for (int j = 0; j < fileList.length; j++) {
	
				FileUtil.moveFile(
					ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[j],
					baseUrl + fileList[j]
				);						
				DocumentDB.add(userBean, "PostExamForm", pirID, webUrl, fileList[j]);
			}
		}

		return true;
	}	

	private boolean AttachmentUploadDHeadAddExamForm(UserBean userBean, String[] fileList, String pirID) {
		if (fileList != null) {
			//System.out.println(fileList);
		
			StringBuffer tempStrBuffer = new StringBuffer();
	
			tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("PIReport");
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("DHeadAddForm");
			tempStrBuffer.append(File.separator);									
			tempStrBuffer.append(pirID);
			tempStrBuffer.append(File.separator);
			String baseUrl = tempStrBuffer.toString();
	
			tempStrBuffer.setLength(0);
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("upload");
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("PIReport");
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("DHeadAddForm");
			tempStrBuffer.append(File.separator);									
			tempStrBuffer.append(pirID);
			String webUrl = tempStrBuffer.toString();
	
			for (int j = 0; j < fileList.length; j++) {
	
				FileUtil.moveFile(
					ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[j],
					baseUrl + fileList[j]
				);						
				DocumentDB.add(userBean, "DHeadAddForm", pirID, webUrl, fileList[j]);
			}
		}

		return true;
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

//for Toy mode 
String Toy = "Prod";
//String Toy = "Toy";

UserBean userBean = new UserBean(request);
String command = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "command"));
boolean createAction = false;
boolean creating = false;
boolean viewAction = false;
boolean viewRptAction = false;
boolean editAction = false;
boolean updateAction = false;
boolean fuSendAction = false;
boolean fuRejectAction = false;
boolean fuSubmitAction = false;
boolean fuPICloseAction = false;
boolean fuChgRespPersonAction = false;
boolean fuActionInvestigateActionOshIcn = false;
boolean fuActionInvestigateActionPharmacy = false;
boolean fuRedoAction = false;
boolean fuChgRespPersonActionOSH_ICN = false;
boolean fuChgRespPersonActionPharmacy = false;
boolean fuChgRespPersonActionOthers = false;
boolean closeAccessDeniedAction = false;
boolean closeAction = false;
boolean fuAddRpt = false;
boolean fuAdmCmt = false;
boolean fuAdmFUCmt = false;
boolean fuFUDHCmt = false;
boolean fuPxCmt = false;
boolean fuFurtherNotice = false;
boolean fuRedoPxDutyManagerAction = false;
boolean fuSubmitPxAction = false;
boolean fuSendActionRequestAction = false;
boolean fuSendActionRequestReminderAction = false;
boolean fuPostExamForm = false;
boolean fuDHeadAddForm = false;
ReportableListObject row = null;
String pageIndex = null;
String personName = null;
String rank = null;
String deptCode = null;
String deptDesc = null;
String deptHead = null;
String deptHeadName = null;
String dutyMgr = null;
String dutyMgrName = null;
String sentinelEvent = null;
String sentinelID = null;
String sentinelDesc = null;
String incident_date = null;
String incident_time_hh = null;
String incident_time_mi = null;
String incident_place = null;
String incident_place_freetext = null;
String incident_type = null;
String incident_type_pi = null;
String patientInfo[] = null;
String staffInfo[] = null;
String visitorInfo[] = null;
String otherInfo[] = null;
String pirID = null;
String incident_status = null;
String incident_classification = null;
String incident_classification_desc = null;
String incident_classification_desc_pi = null;
String relPirID = null;
String followUp = null;
// followup dialog
ReportableListObject rowRtn = null;
String fuFrom = null;
String fuTo = null;
String fuCrDate = null;
String fuDueDate = null;
String fuCompDate = null;
String fuAction = null;
String respParty = null;
String fupirflwID = null;
String fupirflwpID = null;
String fuaddrptID = null;
String fustaffInfo[] = null;
String rptSts = null;
String[] toStaffID = null;
String chgRespPerson = null;
String chgRespPersonICN = null;
String chgRespPersonOSH = null;
String chgRespPersonOthers = null;
String AddRpt = null;
// dept head add follow up comment
String piDID = null;
String Narrative = null;
String Cause = null; 
String ActionDone = null;
String ActionTaken = null;
String RiskAss = null;
String Mon = null;
String Inv = null;
String Treat = null;
String HighCare = null;
String MonSpec = null;
String InvSpec = null;
String TreatSpec = null;
String HighCareSpec = null;
String PersonFault = null;
String InadeTrain = null;
String NoPrevent = null;
String MachFault = null;
String MisUse = null;
String InadeInstru = null;
String InadeEquip = null;
String PoorQual = null;
String QualDetect = null;
String ExpItem = null;
String InadeMat = null;
String InstNotFollow = null;
String MotNature = null;
String Noise = null;
String DistEnv = null;
String UnvFloor = null;
String Slip = null;
String IM = null;
String Culture = null;
String Leader = null;
String Other = null;
String OtherSpec = null;
Boolean IsDHead = null;
Boolean IsDutyMgr = null;
Boolean IsAdmin = null;
Boolean IsReponsiblePerson = null;
Boolean IsOshIcn = null;
Boolean IsPharmacy = null;
Boolean IsOshIcnOrPharmacy = false;
Boolean IsPIManager = null;
Boolean IsStaffIncident = null;
Boolean IsMedicationIncident = null;
Boolean IsPatientIncident = null;
Boolean IsStaffOrMedicationIncident = false;
Boolean IsActionRequestStaff = true;
Boolean subHead = false; // nurse cases Reporter-->NO-->SNO--->PI
//
String failurecomply = null;
String samedrug = null;
String inappabb = null;
String ordermis = null;
String lasa = null;
String lapses = null;
String equipfailure = null;
String illegalhand = null;
String miscal = null;
String systemflaw = null;
String Inadtrainstaff = null;
String othersfreetext = null;
String othersfreetextedit = null;
String relatedstaff = null;
String sharestaff = null;
String sharestaffdate = null;
String noaffect = null;
String noharm = null;
String tempharm = null;
String permharm = null;
String death = null;
String contamin = null;
String noncontamin = null;
String bodyfluexp = null;
String adminviewed = null;
String admincomment = null;

// Px Comment
String pirPXID = null;
Boolean IsPx = null;
String PxRiskAss = null;
String HighAlert = null;
String BeforeWard = null;
String BeforeOutpat = null;
String AfterWardInv = null;
String AfterWardGiven = null;
String AfterOutpatNottaken = null;
String AfterOutpatTaken = null;
String BeforeDischarge = null;
String AfterDischarge = null;
String BeforeAdmin = null;
String AfterAdmin = null;
String BeforeAdminUnit = null;
String AfterAdminUnit = null;
// redo
String redoReason = null;
// Notify Email
String emailFromList = null;
String emailToList = null;
//
String actionRequest = null;
String compDate = null;
String requestContent = null;
String autoReminder = null;
String actionrequeststaff = null;
//
String piAssInjury = null;
// for checking action request staff
String pirPIID = null;
// px submit medication and adr
String deptHeadTemp = null;
String dutyMgrTemp = null;
String pxdeptHead = null;
String pxdutyMgr = null;
String pxNurse = null;
String pxNurseName = null;
//near miss incident
String nearMiss = null;
boolean pxcreateAction = false;
boolean pxupdateAction = false;
Boolean IsPharmacyStaff = false;
Boolean IsNursingStaff = false;
boolean createActionSaveOnly = false;
boolean updateActionSaveOnly = false;
boolean CanEditReport = false;
boolean fuPIClass = false;
String piNearMiss = null;
String piClass = null;
//checkbox for follow up action
String staffedu = null;
String staffedutext = null;
String staffdisc = null;
String staffdisctext = null;
String cons = null;
String constext = null;
String shar = null;
String shartext1 = null;
String shartext2 = null;
String revpol = null;
String revpoltext = null;
String revform = null;
String revformtext = null;
String creform = null;
String creformtext = null;
String refer = null;
String refertext = null;
String referdepttext = null;
String others = null;
Boolean IsNeverSubmitted = false;
String staffNOUM = null;

String docfName = ParserUtil.getParameter(request, "docfName");
String docgName = ParserUtil.getParameter(request, "docgName");
String doccName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "doccName"));
String idNo = ParserUtil.getParameter(request, "idNo");
String docSex = ParserUtil.getParameter(request, "docSex");
String martialStatus = ParserUtil.getParameter(request, "martialStatus");
String docAddr1 = ParserUtil.getParameter(request, "docAddr1");
String docAddr2 = ParserUtil.getParameter(request, "docAddr2");
String docAddr3 = ParserUtil.getParameter(request, "docAddr3");
String docAddr4 = ParserUtil.getParameter(request, "docAddr4");	
String homeAddr1 = ParserUtil.getParameter(request, "homeAddr1");
String homeAddr2 = ParserUtil.getParameter(request, "homeAddr2");	
String homeAddr3 = ParserUtil.getParameter(request, "homeAddr3");
String homeAddr4 = ParserUtil.getParameter(request, "homeAddr4");
String officeTel = ParserUtil.getParameter(request, "officeTel");	
String officeFax = ParserUtil.getParameter(request, "officeFax");
String email = ParserUtil.getParameter(request, "email");
String pager = ParserUtil.getParameter(request, "pager");
String mobile = ParserUtil.getParameter(request, "mobile");	
String homeTel = ParserUtil.getParameter(request, "homeTel");
String docAcademic1 = ParserUtil.getParameter(request, "docAcademic1");
String docDegree1 = ParserUtil.getParameter(request, "docDegree1");
String docAcademicDate1 = ParserUtil.getParameter(request, "docAcademicDate1");
String docAcademic2 = ParserUtil.getParameter(request, "docAcademic2");
String docDegree2 = ParserUtil.getParameter(request, "docDegree2");
String docAcademicDate2 = ParserUtil.getParameter(request, "docAcademicDate2");
String docSpecQual = ParserUtil.getParameter(request, "docSpecQual");
String docSpecQualSince = ParserUtil.getParameter(request, "docSpecQualSince1");
String docSpecQualHospital1= ParserUtil.getParameter(request, "docSpecQualHospital1");
String docSpecQualDateFrom1 = ParserUtil.getParameter(request, "docSpecQualDateFrom1");
String docSpecQualDateTo1= ParserUtil.getParameter(request, "docSpecQualDateTo1");
String docSpecQualHospital2= ParserUtil.getParameter(request, "docSpecQualHospital2");
String docSpecQualDateFrom2 = ParserUtil.getParameter(request, "docSpecQualDateFrom2");
String docSpecQualDateTo2= ParserUtil.getParameter(request, "docSpecQualDateTo2");
String medInfo01= ParserUtil.getParameter(request, "medInfo01");
String docPrevPracticeAddr1= ParserUtil.getParameter(request, "docPrevPracticeAddr1");
String docPrevPracticeFrom1= ParserUtil.getParameter(request, "docPrevPracticeFrom1");
String docPrevPracticeTo1= ParserUtil.getParameter(request, "docPrevPracticeTo1");
String docPrevPracticeAddr2= ParserUtil.getParameter(request, "docPrevPracticeAddr2");
String docPrevPracticeFrom2= ParserUtil.getParameter(request, "docPrevPracticeFrom2");
String docPrevPracticeTo2= ParserUtil.getParameter(request, "docPrevPracticeTo2");
String docMemProSoc1= ParserUtil.getParameter(request, "docMemProSoc1");
String docMemProSoc2= ParserUtil.getParameter(request, "docMemProSoc2");
String docMemProSocStatus1= ParserUtil.getParameter(request, "docMemProSocStatus1");
String docMemProSocYear1= ParserUtil.getParameter(request, "docMemProSocYear1");
String docMemProSocStatus2= ParserUtil.getParameter(request, "docMemProSocStatus2");
String docMemProSocYear2= ParserUtil.getParameter(request, "docMemProSocYear2");
String docAcademyOfMed1= ParserUtil.getParameter(request, "docAcademyOfMed1");
String docAcademyOfMedStatus1= ParserUtil.getParameter(request, "docAcademyOfMedStatus1");
String docAcademyOfMedYear1= ParserUtil.getParameter(request, "docAcademyOfMedYear1");
String docAcademyOfMed2= ParserUtil.getParameter(request, "docAcademyOfMed2");
String docAcademyOfMedStatus2= ParserUtil.getParameter(request, "docAcademyOfMedStatus2");
String docAcademyOfMedYear2= ParserUtil.getParameter(request, "docAcademyOfMedYear2");
String docLicNo1= ParserUtil.getParameter(request, "docLicNo1");
String docLicExpdate1= ParserUtil.getParameter(request, "docLicExpdate1");
String docLicNo2= ParserUtil.getParameter(request, "docLicNo2");
String docLicExpdate2= ParserUtil.getParameter(request, "docLicExpdate2");
String docHealthStatus1= ParserUtil.getParameter(request, "docHealthStatus1");
String docHealthStatus2= ParserUtil.getParameter(request, "docHealthStatus2");
String docInsureCarr= ParserUtil.getParameter(request, "docInsureCarr");
String docInsureCarrExpDate= ParserUtil.getParameter(request, "docInsureCarrExpDate");
String docOtherInfo1= ParserUtil.getParameter(request, "docOtherInfo1");
String docOtherInfo2= ParserUtil.getParameter(request, "docOtherInfo2");
String docOtherInfo3= ParserUtil.getParameter(request, "docOtherInfo3");
String docOtherInfo4= ParserUtil.getParameter(request, "docOtherInfo4");
String docOtherInfo5= ParserUtil.getParameter(request, "docOtherInfo5");
String docProfRef1= ParserUtil.getParameter(request, "docProfRef1");
String docProfRef2= ParserUtil.getParameter(request, "docProfRef2");
String docProfRefContact1= ParserUtil.getParameter(request, "docProfRefContact1");
String docProfRefContact2= ParserUtil.getParameter(request, "docProfRefContact2");

if(command != null && (command.equals("create") || command.equals("create_px2") || command.equals("create_saveonly"))) {
	personName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "reportPersonName"));
	rank = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "reportPersonRank"));
	deptCode = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "deptCode"));
	incident_date = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "occurDate"));
	incident_time_hh = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "timeOfOccurrence_hh"));
	incident_time_mi = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "timeOfOccurrence_mi"));
	incident_place = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "placeOfOccur"));
	incident_place_freetext = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "placeOfOccur_freetext"));
	incident_type = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "selectedIncidentType"));
	incident_classification = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "incidentClass"));
	incident_classification_desc = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "incident_classification_desc"));
	relPirID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "relPirID"));
	
	patientInfo = (String[])request.getAttribute("isPatientInfo_StringArray");
	staffInfo = (String[])request.getAttribute("isStaffInfo_StringArray");
	visitorInfo = (String[])request.getAttribute("isVisitorInfo_StringArray");
	otherInfo = (String[])request.getAttribute("isOtherInfo_StringArray");
	
	deptHead = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "deptHead"));
	deptHeadName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "deptHeadName"));		

	dutyMgr = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "dutyMgr"));
	
	sentinelEvent = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sentinel"));
	if ("1".equals(sentinelEvent)) {
		sentinelID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sentinelname"));	
	} 
	else {
		sentinelID = "0";
	}
	if (command.equals("create_px2")) {
		pxcreateAction = true;
		pxdeptHead = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "deptHead"));
		pxdutyMgr = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "dutyMgr"));		
		pxNurse = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pxNurseMain"));
	}
	nearMiss = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "nearMiss"));
	
	if (command.equals("create_saveonly")) {
		createActionSaveOnly = true;	
	}	
	createAction = true;
}
else if(command != null && command.indexOf("view") > -1) {
	pirID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pirID"));
	pirPIID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pirPIID"));
	viewAction = true;
}
else if(command != null && command.equals("edit")) {
	pirID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pirID"));
	editAction = true;
}
else if(command != null && (command.equals("update") || command.equals("update_saveonly") || command.equals("update_px2"))) {
	pirID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pirID"));
	personName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "reportPersonName"));
	rank = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "reportPersonRank"));
	deptCode = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "deptCode"));
	incident_date = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "occurDate"));
	incident_time_hh = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "timeOfOccurrence_hh"));
	incident_time_mi = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "timeOfOccurrence_mi"));
	incident_place = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "placeOfOccur"));
	incident_place_freetext = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "placeOfOccur_freetext"));
	incident_type = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "selectedIncidentType"));
	incident_classification = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "incidentClass"));
	incident_classification_desc = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "incident_classification_desc"));
	relPirID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "relPirID"));
	
	patientInfo = (String[])request.getAttribute("isPatientInfo_StringArray");
	staffInfo = (String[])request.getAttribute("isStaffInfo_StringArray");
	visitorInfo = (String[])request.getAttribute("isVisitorInfo_StringArray");
	otherInfo = (String[])request.getAttribute("isOtherInfo_StringArray");
	
	deptHead = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "deptHead"));
	deptHeadName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "deptHeadName"));		

	dutyMgr = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "dutyMgr"));
	
	sentinelEvent = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sentinel"));
	if ("1".equals(sentinelEvent)) {
		sentinelID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sentinelname"));	
	} 
	else {
		sentinelID = "0";
	}
	if (command.equals("update_px2")) {
		pxdeptHead = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "deptHead"));
		pxdutyMgr = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "dutyMgr"));
		pxNurse = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pxNurse"));
		if (!"".equals(pxdeptHead)) {
			pxupdateAction = true;
		}
	} else {
		pxdeptHead = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pxdeptHead"));
		pxdutyMgr = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pxdutyMgr"));
		pxNurse = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "pxNurse"));
	}
	
	nearMiss = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "nearMiss"));
	
	if (command.equals("update_saveonly")) {
		updateActionSaveOnly = true;	
	}	
	updateAction = true;
}
else {
	incident_date = DateTimeUtil.getCurrentDateTime().substring(0, 10);
	sentinelEvent = "0";
	sentinelID = "0";
	nearMiss = "0";
	creating = true;
}

//System.out.println("just get param, pageIndex : " + pageIndex);

String message = null;
String errorMessage = null;

if(command != null && !command.equals("create") && !command.equals("create_px2") && !command.equals("create_saveonly")) {
	//for new tab

}
if (command != null) { 
	// check if not rptsts = 0 and not the reporter
	if (command.equals("edit")) {
		if (!"0".equals(rptSts) || (!CanEditReport)) {
			closeAccessDeniedAction = true;
		}
	}
}

%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
	Licensed to the Apache Software Foundation (ASF) under one or more
	contributor license agreements.  See the NOTICE file distributed with
	this work for additional information regarding copyright ownership.
	The ASF liCensus this file to You under the Apache License, Version 2.0
	(the "License"); you may not use this file except in compliance with
	the License.  You may obtain a copy of the License at

		 http://www.apache.org/liCensus/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<style>
div.confidential { 
	float:right;
	color:red;
}
div#report LABEL {
	color: black !important;
	font-weight: bold!important;
}
#incidentTypeForm TD {
	line-height:14pt !important;
}
#report {
	background-color: #CCCCCC;
}
#report .header {
	cursor: pointer;
	background: #D2449D !important;
	border-bottom-color: #E48FC4 !important;
	border-left-color: #E48FC4 !important;
	border-right-color: #E48FC4 !important;
	border-top-color: #E48FC4 !important;
	height:22px;
}
#report .header label {
}
.addFlw, .stepBtn, .nextBtn, .prevBtn {
	cursor: pointer;
}
.alert {
	color: Red!important;
}
.content-table td {
	border-width:0px!Important;
}
.reply-index td {
	border-width:0px!Important;
}
.selected {
	background: url("../images/ui-bg_highlight-soft_75_ffe45c_1x100.png") repeat-x scroll 50% 50% #F6F6F6 !important;
}
.scroll-pane
{
	width: 100%;
	height: 100%;
	overflow: auto;
}
div#menu, div#content {
	border: 2px solid;
	border-color: black;
}
div.reportItem {
	cursor: pointer!important;
}
<% if (ConstantsServerSide.isTWAH()) { %>
button.btn-click {
	font-size: 15px;
	font-weight: bold;
}
<%}%>

</style>
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<%	if (userBean.isLogin() && closeAction) { %>
		<%if (errorMessage != null) { %>
			<script type="text/javascript">alert('Form Saving Error, please contact IM support');window.close();</script>
		<%} else { %>	
			<%if (createActionSaveOnly || updateActionSaveOnly) { %>
				<script type="text/javascript">alert('Form Saved');window.close();</script>
			<%} else { %>
				<script type="text/javascript">alert('Form Submitted');window.close();</script>
			<%} %>
		<%} %>
<%  }	
	else if (userBean.isLogin() && closeAccessDeniedAction && !userBean.isAdmin()) {
		System.out.println("if " + userBean.isLogin() + " " + closeAccessDeniedAction + " " + !userBean.isAdmin()); 
%>
		<script type="text/javascript">alert('Access Denied !');window.close();</script>
<%	} else { 
		System.out.println("else " + userBean.isLogin() + " " + closeAccessDeniedAction + " " + !userBean.isAdmin());
%>
<body style="display:none;">
	<jsp:include page="../common/banner2.jsp" />
	<div id="indexWrapper">
		<div id="mainFrame">
			<div id="Frame">
				<%				
				  String title = "";			
				  if(createAction)
					  title = "Create New CTS Application";
				  else if(editAction)
					  title = "Edit CTS form";
				  else if(viewAction)
					  title = "View CTS form";
				  else
					  title = "Create New CTS Application";
				  
				  if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
				  if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
				%>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="<%=title %>" />
					<jsp:param name="keepReferer" value="Y" />
				</jsp:include>
				
				<jsp:include page="../common/message.jsp" flush="false">
					<jsp:param name="message" value="<%=message %>" />
					<jsp:param name="errorMessage" value="<%=errorMessage %>" />
				</jsp:include>
				
				<%-- Start the form --%>
				<form name="reportForm" id="form1" enctype="multipart/form-data" 
							action="newForm1.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0" width="100%">				
	<tr class="smallText">
		<td class="infoData2" colspan=6>
			<b><font style="font-size: 11pt;" size="2">This form is intended to update your file so that it will reflect your current status in the next 3 years until further notification made from you in the future.</font></b></br>
			&nbsp;</br>
<%if ("hkah".equals(ConstantsServerSide.SITE_CODE)) {%>
			Should you have any questions, please feel free to contact us via:</br>
			Email: medicalaffairs@hkah.org.hk</br>
			Tel: (852)2835-0570/(852)2835-0581</br>			
<%}else if ("twah".equals(ConstantsServerSide.SITE_CODE)) {%>			
			<ol>
			<li>Please verify and update the below information if needed</li>
			<li>Fields marked with an (*) are required</li>
			<li>Please attach:</li>
				<ol type="a">							
				<li><b>Copy of your current MPS malpractice coverage certificate including the receipt</b></li>
				<li><b>Copy of current annual practicing certificate</b></li>
				<li>recent passport photo (optional)</li>
				<li>Other additional document(s) (e.g. further training certificate)</li>					
				</ol>
			<li>After you have made your changes, click "Save" or "Submit", you may save your information and submit to us later by clicking "Save"</li>		
			<li>Please note after clicking "Submit" button, your information will be updated and no changes are allowed after confirmation</li>
			<li>Should you have any questions, please feel free to contact us via:</li>						
			</ol>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Email: carmen.ng@twah.org.hk</br>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Tel: (852)3616-6837/(852)2276-7706</br>
<%}%>	
		</td>
	</tr>	
</table>							

					<%-- Step Flow --%>
					<%
						if(viewAction) {
					%>					
						<div style="width:98%; padding-left:5px" align='center'>
							<table>
								<tr>
									<td width="20%">
										<div type='basicInfo1' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:210px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Step 1
										</div>
									</td>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>
									<td width="20%">
										<div type='basicInfo2' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:210px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Step 2
										</div>
									</td>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>
									<td width="20%">
										<div type='basicInfo3' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:210px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Step 3
										</div>
									</td>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>									
									<td width="20%">
										<div type='basicInfo4' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:210px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Step 4
										</div>
									</td>																											
								</tr>
							</table>
						</div>
					<%
						}
						else {
					%>
						<div style="width:100%" align='center'>
							<table>
								<tr>
									<td width="20%">
										<div type='basicInfo1' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:250px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Step 1
										</div>
									</td>
									<td width="5%">
									</td>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>
									<td width="5%">
									</td>
									<td width="20%">
										<div type='basicInfo2' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:250px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Step 2
										</div>
									</td>
									<td width="5%">
									</td>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>
									<td width="5%">
									</td>
									<td width="20%">
										<div type='basicInfo3' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:250px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Step 3
										</div>
									</td>
									<td width="5%">
									</td>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>
									<td width="5%">
									</td>
									<td width="20%">
										<div type='basicInfo4' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:250px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Step 4
										</div>
									</td>									
								</tr>
							</table>
						</div>
					<%
						}
					%>
					<%-- End Step Flow --%>

					<table cellpadding="0" cellspacing="5" class="contentFrameMenu reportcontent" border="0" width="100%">	
						<%-- Basic Information --%>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoCenterLabel" colspan=6 align="center">
							<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform2" /></font>
							</br>Please verify and update the below information if needed. Fields marked with an (*) are required.
							</td>
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4">*</font><bean:message key="prompt.docfName" /></td>		
							<td class="infoData2" width="15%">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docfName" value="<%=docfName==null?"":docfName %>" maxlength="20" size="20"/>
							<%}else { %>
								<input type="text" name="docfName" value="<%=docfName==null?"":docfName %>" maxlength="20" size="20" readonly/>		
							<%} %>			
							</td>		
							<td class="infoLabel" width="15%"><font size="4">*</font><bean:message key="prompt.docgName" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docgName" value="<%=docgName==null?"":docgName %>" maxlength="20" size="20"/>
							<%}else { %>
								<input type="text" name="docgName" value="<%=docgName==null?"":docgName %>" maxlength="20" size="20" readonly/>
							<%} %>			
							</td>	
							<td class="infoLabel" width="15%"><bean:message key="prompt.doccName" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="doccName" value="<%=doccName==null?"":doccName %>" maxlength="15" size="20"/>
							<%}else { %>
								<input type="text" name="doccName" value="<%=doccName==null?"":doccName %>" maxlength="15" size="20" readonly/>		
							<%} %>			
							</td>
						</tr>						
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><bean:message key="prompt.sex" /></td>		
							<td class="infoData2" width="15%"><%=docSex==null?"":docSex %></td>		
							<td class="infoLabel" width="15%"><bean:message key="prompt.docIdNO" /></td>
							<td class="infoData2" width="15%"><%=idNo==null?"":idNo %></td>
							<td class="infoLabel" width="15%"><bean:message key="prompt.martialStatus" /></td>
							<td class="infoData2" width="25%"><%=martialStatus==null?"":martialStatus %></td>							
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.docCorrAddr" /></td>
							<td class="infoData2" width="30%" colspan=2>
							<table>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="docAddr1" value="<%=docAddr1==null?"":docAddr1 %>" maxlength="40" size="60"/>
									<%}else { %>
										<input type="text" name="docAddr1" value="<%=docAddr1==null?"":docAddr1 %>" maxlength="40" size="60" readonly/>		
									<%} %>			
									</td>
								</tr>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="docAddr2" value="<%=docAddr2==null?"":docAddr2 %>" maxlength="40" size="60"/>
									<%}else { %>
										<input type="text" name="docAddr2" value="<%=docAddr2==null?"":docAddr2 %>" maxlength="40" size="60" readonly/>		
									<%} %>			
									</td>
								</tr>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="docAddr3" value="<%=docAddr3==null?"":docAddr3 %>" maxlength="40" size="60"/>
									<%}else { %>
										<input type="text" name="docAddr3" value="<%=docAddr3==null?"":docAddr3 %>" maxlength="40" size="60" readonly/>		
									<%} %>			
									</td>
								</tr>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="docAddr4" value="<%=docAddr4==null?"":docAddr4 %>" maxlength="40" size="60"/>
									<%}else { %>
										<input type="text" name="docAddr4" value="<%=docAddr4==null?"":docAddr4 %>" maxlength="40" size="60" readonly/>		
									<%} %>			
									</td>
								</tr>																								
							</table>
							</td>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.docHomeAddr" /></td>
							<td class="infoData2" width="40%" colspan=2>
							<table>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="homeAddr1" value="<%=homeAddr1==null?"":homeAddr1 %>" maxlength="40" size="50"/>
									<%}else { %>
										<input type="text" name="homeAddr1" value="<%=homeAddr1==null?"":homeAddr1 %>" maxlength="40" size="50" readonly/>	
									<%} %>									
									</td>
								</tr>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="homeAddr2" value="<%=homeAddr2==null?"":homeAddr2 %>" maxlength="40" size="50"/>
									<%}else { %>
										<input type="text" name="homeAddr2" value="<%=homeAddr2==null?"":homeAddr2 %>" maxlength="40" size="50" readonly/>	
									<%} %>									
									</td>
								</tr>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="homeAddr3" value="<%=homeAddr3==null?"":homeAddr3 %>" maxlength="40" size="50"/>
									<%}else { %>
										<input type="text" name="homeAddr3" value="<%=homeAddr3==null?"":homeAddr3 %>" maxlength="40" size="50" readonly/>	
									<%} %>									
									</td>
								</tr>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="homeAddr4" value="<%=homeAddr4==null?"":homeAddr4 %>" maxlength="40" size="50"/>
									<%}else { %>
										<input type="text" name="homeAddr4" value="<%=homeAddr4==null?"":homeAddr4 %>" maxlength="40" size="50" readonly/>	
									<%} %>									
									</td>
								</tr>																								
							</table>									
							</td>							
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform14" /></font>
							</td>							
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.docAcademic1" /></td>		
							<td class="infoData2" width="15%">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docAcademic1" value="<%=docAcademic1==null?"":docAcademic1 %>" maxlength="20" size="20"/>
							<%}else { %>
								<input type="text" name="docAcademic1" value="<%=docAcademic1==null?"":docAcademic1 %>" maxlength="20" size="20" readonly/>		
							<%} %>			
							</td>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.docDegree" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docDegree1" value="<%=docDegree1==null?"":docDegree1 %>" maxlength="20" size="20"/>
							<%}else { %>
								<input type="text" name="docDegree1" value="<%=docDegree1==null?"":docDegree1 %>" maxlength="20" size="20" readonly/>
							<%} %>			
							</td>	
							<td class="infoLabel" width="15%"><bean:message key="prompt.docAcademicDate" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docAcademicDate1" value="<%=docAcademicDate1==null?"":docAcademicDate1 %>" maxlength="15" size="20"/>
							<%}else { %>
								<input type="text" name="docAcademicDate1" value="<%=docAcademicDate1==null?"":docAcademicDate1 %>" maxlength="15" size="20" readonly/>		
							<%} %>			
							</td>
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4">*</font><bean:message key="prompt.docAcademic2" /></td>		
							<td class="infoData2" width="15%">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docAcademic2" value="<%=docAcademic2==null?"":docAcademic2 %>" maxlength="20" size="20"/>
							<%}else { %>
								<input type="text" name="docAcademic2" value="<%=docAcademic2==null?"":docAcademic2 %>" maxlength="20" size="20" readonly/>		
							<%} %>			
							</td>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.docDegree" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docDegree2" value="<%=docDegree2==null?"":docDegree2 %>" maxlength="20" size="20"/>
							<%}else { %>
								<input type="text" name="docDegree2" value="<%=docDegree2==null?"":docDegree2 %>" maxlength="20" size="20" readonly/>
							<%} %>			
							</td>	
							<td class="infoLabel" width="15%"><bean:message key="prompt.docAcademicDate" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docAcademicDate2" value="<%=docAcademicDate2==null?"":docAcademicDate2 %>" maxlength="15" size="20"/>
							<%}else { %>
								<input type="text" name="docAcademicDate2" value="<%=docAcademicDate2==null?"":docAcademicDate2 %>" maxlength="15" size="20" readonly/>		
							<%} %>			
							</td>
						</tr>						
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.docSpecQual" /></td>		
							<td class="infoData2" width="45%" colspan=3>	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docSpecQual" value="<%=docSpecQual==null?"":docSpecQual %>" maxlength="20" size="20"/>
							<%}else { %>
								<input type="text" name="docSpecQual" value="<%=docSpecQual==null?"":docSpecQual %>" maxlength="20" size="20" readonly/>		
							<%} %>			
							</td>		
							<td class="infoLabel" width="15%"><font size="4">*</font><bean:message key="prompt.since" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docSpecQualSince" value="<%=docSpecQualSince==null?"":docSpecQualSince %>" maxlength="20" size="20"/>
							<%}else { %>
								<input type="text" name="docSpecQualSince" value="<%=docSpecQualSince==null?"":docSpecQualSince %>" maxlength="20" size="20" readonly/>
							<%} %>			
							</td>
						</tr>						
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.hospital" /></td>		
							<td class="infoData2" width="15%">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docSpecQualHospital1" value="<%=docSpecQualHospital1==null?"":docSpecQualHospital1 %>" maxlength="20" size="20"/>
							<%}else { %>
								<input type="text" name="docSpecQualHospital1" value="<%=docSpecQualHospital1==null?"":docSpecQualHospital1 %>" maxlength="20" size="20" readonly/>		
							<%} %>			
							</td>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.from" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="textfield" name="docSpecQualDateFrom1" id="docSpecQualDateFrom1" class="datepickerfield notEmpty" value="<%=docSpecQualDateFrom1==null?"":docSpecQualDateFrom1 %>" maxlength="10" size="16"/>
							<%}else { %>
								<input type="textfield" name="docSpecQualDateFrom1" id="docSpecQualDateFrom1" class="datepickerfield notEmpty" value="<%=docSpecQualDateFrom1==null?"":docSpecQualDateFrom1 %>" maxlength="10" size="16" readonly/>
							<%} %>			
							</td>	
							<td class="infoLabel" width="15%"><bean:message key="prompt.to" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>		
								<input type="textfield" name="docSpecQualDateTo1" id="docSpecQualDateTo1" class="datepickerfield notEmpty" value="<%=docSpecQualDateTo1==null?"":docSpecQualDateTo1 %>" maxlength="10" size="16"/>								
							<%}else { %>
								<input type="textfield" name="docSpecQualDateTo1" id="docSpecQualDateTo1" class="datepickerfield notEmpty" value="<%=docSpecQualDateTo1==null?"":docSpecQualDateTo1 %>" maxlength="10" size="16" readonly/>		
							<%} %>			
							</td>
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.hospital" /></td>		
							<td class="infoData2" width="15%">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docSpecQualHospital2" value="<%=docSpecQualHospital2==null?"":docSpecQualHospital2 %>" maxlength="20" size="20"/>
							<%}else { %>
								<input type="text" name="docSpecQualHospital2" value="<%=docSpecQualHospital2==null?"":docSpecQualHospital2 %>" maxlength="20" size="20" readonly/>		
							<%} %>			
							</td>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.from" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="textfield" name="docSpecQualDateFrom2" id="docSpecQualDateFrom2" class="datepickerfield notEmpty" value="<%=docSpecQualDateFrom2==null?"":docSpecQualDateFrom2 %>" maxlength="10" size="16"/>								
							<%}else { %>
								<input type="textfield" name="docSpecQualDateFrom2" id="docSpecQualDateFrom2" class="datepickerfield notEmpty" value="<%=docSpecQualDateFrom2==null?"":docSpecQualDateFrom2 %>" maxlength="10" size="16" readonly/>
							<%} %>			
							</td>	
							<td class="infoLabel" width="15%"><bean:message key="prompt.to" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>
								<input type="textfield" name="docSpecQualDateTo2" id="docSpecQualDateTo2" class="datepickerfield notEmpty" value="<%=docSpecQualDateTo2==null?"":docSpecQualDateTo2 %>" maxlength="10" size="16"/>
							<%}else { %>
								<input type="textfield" name="docSpecQualDateTo2" id="docSpecQualDateTo2" class="datepickerfield notEmpty" value="<%=docSpecQualDateTo2==null?"":docSpecQualDateTo2 %>" maxlength="10" size="16" readonly/>		
							<%} %>			
							</td>
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.docCTSNew01" /></td>		
							<td class="infoData2" width="85%" colspan=5>	
								<textarea name="medInfo01" rows="6" cols="113" style="font-size:18px;"><%=medInfo01==null?"":medInfo01 %></textarea>		
							</td>
						</tr>												
						<%-- End basicInfo2 --%>												
						<%-- basicInfo2 --%>						
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform15" /></font>
							</td>							
						</tr>
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoData2" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.docPrevPractice1" /></font>
							</td>							
						</tr>				
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="adm.Address" /></td>		
							<td class="infoData2" width="85%" colspan="5">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docPrevPracticeAddr1" value="<%=docPrevPracticeAddr1==null?"":docPrevPracticeAddr1 %>" maxlength="150" size="150"/>
							<%}else { %>
								<input type="text" name="docPrevPracticeAddr1" value="<%=docPrevPracticeAddr1==null?"":docPrevPracticeAddr1 %>" maxlength="150" size="150" readonly/>		
							<%} %>			
							</td>
						</tr>						
						<tr class="smallText basicInfo2" type='basicInfo2'>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.from" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="textfield" name="docPrevPracticeFrom1" id="docPrevPracticeFrom1" class="datepickerfield notEmpty" value="<%=docPrevPracticeFrom1==null?"":docPrevPracticeFrom1 %>" maxlength="10" size="16"/>
							<%}else { %>
								<input type="textfield" name="docPrevPracticeFrom1" id="docPrevPracticeFrom1" class="datepickerfield notEmpty" value="<%=docPrevPracticeFrom1==null?"":docPrevPracticeFrom1 %>" maxlength="10" size="16" readonly/>
							<%} %>			
							</td>
							<td class="infoData2" width="15%"></td>
							<td class="infoLabel" width="15%"><bean:message key="prompt.to" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>
								<input type="textfield" name="docPrevPracticeTo1" id="docPrevPracticeTo1" class="datepickerfield notEmpty" value="<%=docPrevPracticeTo1==null?"":docPrevPracticeTo1 %>" maxlength="10" size="16"/>
							<%}else { %>
								<input type="textfield" name="docPrevPracticeTo1" id="docPrevPracticeTo1" class="datepickerfield notEmpty" value="<%=docPrevPracticeTo1==null?"":docPrevPracticeTo1 %>" maxlength="10" size="16" readonly/>		
							<%} %>			
							</td>								
							<td class="infoData2" width="25%"></td>
						</tr>
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="adm.Address" /></td>		
							<td class="infoData2" width="85%" colspan="5">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docPrevPracticeAddr2" value="<%=docPrevPracticeAddr2==null?"":docPrevPracticeAddr2 %>" maxlength="150" size="150"/>
							<%}else { %>
								<input type="text" name="docPrevPracticeAddr2" value="<%=docPrevPracticeAddr2==null?"":docPrevPracticeAddr2 %>" maxlength="150" size="150" readonly/>		
							<%} %>			
							</td>
						</tr>						
						<tr class="smallText basicInfo2" type='basicInfo2'>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.from" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="textfield" name="docPrevPracticeFrom2" id="docPrevPracticeFrom2" class="datepickerfield notEmpty" value="<%=docPrevPracticeFrom2==null?"":docPrevPracticeFrom2 %>" maxlength="10" size="16"/>
							<%}else { %>
								<input type="textfield" name="docPrevPracticeFrom2" id="docPrevPracticeFrom2" class="datepickerfield notEmpty" value="<%=docPrevPracticeFrom2==null?"":docPrevPracticeFrom2 %>" maxlength="10" size="16" readonly/>
							<%} %>			
							</td>
							<td class="infoData2" width="15%"></td>
							<td class="infoLabel" width="15%"><bean:message key="prompt.to" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="textfield" name="docPrevPracticeTo2" id="docPrevPracticeTo2" class="datepickerfield notEmpty" value="<%=docPrevPracticeTo2==null?"":docPrevPracticeTo2 %>" maxlength="10" size="16"/>
							<%}else { %>
								<input type="textfield" name="docPrevPracticeTo2" id="docPrevPracticeTo2" class="datepickerfield notEmpty" value="<%=docPrevPracticeTo2==null?"":docPrevPracticeTo2 %>" maxlength="10" size="16" readonly/>		
							<%} %>			
							</td>								
							<td class="infoData2" width="25%"></td>
						</tr>
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform16" /></font>
							</td>							
						</tr>
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.name" /></td>		
							<td class="infoData2" width="85%" colspan="5">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docMemProSoc1" value="<%=docMemProSoc1==null?"":docMemProSoc1 %>" maxlength="150" size="150"/>
							<%}else { %>
								<input type="text" name="docMemProSoc1" value="<%=docMemProSoc1==null?"":docMemProSoc1 %>" maxlength="150" size="150" readonly/>		
							<%} %>			
							</td>
						</tr>						
						<tr class="smallText basicInfo2" type='basicInfo2'>		
							<td class="infoLabel" width="15%"><font size="4">*</font><bean:message key="prompt.memStatus" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docMemProSocStatus1" value="<%=docMemProSocStatus1==null?"":docMemProSocStatus1 %>" maxlength="50" size="30"/>
							<%}else { %>
								<input type="text" name="docMemProSocStatus1" value="<%=docMemProSocStatus1==null?"":docMemProSocStatus1 %>" maxlength="50" size="30" readonly/>
							<%} %>			
							</td>
							<td class="infoData2" width="15%"></td>
							<td class="infoLabel" width="15%"><bean:message key="prompt.year" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docMemProSocYear1" value="<%=docMemProSocYear1==null?"":docMemProSocYear1 %>" maxlength="4" size="10"/>
							<%}else { %>
								<input type="text" name="docMemProSocYear1" value="<%=docMemProSocYear1==null?"":docMemProSocYear1 %>" maxlength="4" size="10" readonly/>
							<%} %>			
							</td>								
							<td class="infoData2" width="25%"></td>
						</tr>
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.name" /></td>		
							<td class="infoData2" width="85%" colspan="5">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docMemProSoc2" value="<%=docMemProSoc2==null?"":docMemProSoc2 %>" maxlength="150" size="150"/>
							<%}else { %>
								<input type="text" name="docMemProSoc2" value="<%=docMemProSoc2==null?"":docMemProSoc2 %>" maxlength="150" size="150" readonly/>		
							<%} %>			
							</td>
						</tr>						
						<tr class="smallText basicInfo2" type='basicInfo2'>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.memStatus" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docMemProSocStatus2" value="<%=docMemProSocStatus2==null?"":docMemProSocStatus2 %>" maxlength="50" size="30"/>
							<%}else { %>
								<input type="text" name="docMemProSocStatus2" value="<%=docMemProSocStatus2==null?"":docMemProSocStatus2 %>" maxlength="50" size="30" readonly/>
							<%} %>			
							</td>
							<td class="infoData2" width="15%"></td>
							<td class="infoLabel" width="15%"><bean:message key="prompt.year" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docMemProSocYear2" value="<%=docMemProSocYear2==null?"":docMemProSocYear2 %>" maxlength="4" size="10"/>
							<%}else { %>
								<input type="text" name="docMemProSocYear2" value="<%=docMemProSocYear2==null?"":docMemProSocYear2 %>" maxlength="4" size="10" readonly/>
							<%} %>			
							</td>								
							<td class="infoData2" width="25%"></td>
						</tr>						
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoCenterLabel" width="15%" colspan=7 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform17" /></font>
							</td>							
						</tr>
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.name" /></td>		
							<td class="infoData2" width="85%" colspan="5">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docAcademyOfMed1" value="<%=docAcademyOfMed1==null?"":docAcademyOfMed1 %>" maxlength="150" size="150"/>
							<%}else { %>
								<input type="text" name="docAcademyOfMed1" value="<%=docAcademyOfMed1==null?"":docAcademyOfMed1 %>" maxlength="150" size="150" readonly/>		
							<%} %>			
							</td>
						</tr>						
						<tr class="smallText basicInfo2" type='basicInfo2'>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.memStatus" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docAcademyOfMedStatus1" value="<%=docAcademyOfMedStatus1==null?"":docAcademyOfMedStatus1 %>" maxlength="50" size="30"/>
							<%}else { %>
								<input type="text" name="docAcademyOfMedStatus1" value="<%=docAcademyOfMedStatus1==null?"":docAcademyOfMedStatus1 %>" maxlength="50" size="30" readonly/>
							<%} %>			
							</td>
							<td class="infoData2" width="15%"></td>
							<td class="infoLabel" width="15%"><bean:message key="prompt.year" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docAcademyOfMedYear1" value="<%=docAcademyOfMedYear1==null?"":docAcademyOfMedYear1 %>" maxlength="4" size="10"/>
							<%}else { %>
								<input type="text" name="docAcademyOfMedYear1" value="<%=docAcademyOfMedYear1==null?"":docAcademyOfMedYear1 %>" maxlength="4" size="10" readonly/>
							<%} %>			
							</td>								
							<td class="infoData2" width="25%"></td>
						</tr>
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.name" /></td>		
							<td class="infoData2" width="85%" colspan="5">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docAcademyOfMed2" value="<%=docAcademyOfMed2==null?"":docAcademyOfMed2 %>" maxlength="150" size="150"/>
							<%}else { %>
								<input type="text" name="docAcademyOfMed2" value="<%=docAcademyOfMed2==null?"":docAcademyOfMed2 %>" maxlength="150" size="150" readonly/>		
							<%} %>			
							</td>
						</tr>						
						<tr class="smallText basicInfo2" type='basicInfo2'>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.memStatus" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docAcademyOfMedStatus2" value="<%=docAcademyOfMedStatus2==null?"":docAcademyOfMedStatus2 %>" maxlength="50" size="30"/>
							<%}else { %>
								<input type="text" name="docAcademyOfMedStatus2" value="<%=docAcademyOfMedStatus2==null?"":docAcademyOfMedStatus2 %>" maxlength="50" size="30" readonly/>
							<%} %>			
							</td>
							<td class="infoData2" width="15%"></td>
							<td class="infoLabel" width="15%"><bean:message key="prompt.year" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docAcademyOfMedYear2" value="<%=docAcademyOfMedYear2==null?"":docAcademyOfMedYear2 %>" maxlength="4" size="10"/>
							<%}else { %>
								<input type="text" name="docAcademyOfMedYear2" value="<%=docAcademyOfMedYear2==null?"":docAcademyOfMedYear2 %>" maxlength="4" size="10" readonly/>
							<%} %>			
							</td>							
							<td class="infoData2" width="25%"></td>							
						</tr>
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform12" /></font>
							</td>							
						</tr>						
						<tr class="smallText basicInfo2" type='basicInfo2'>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.HKMC_LICNO" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docLicNo1" value="<%=docLicNo1==null?"":docLicNo1 %>" maxlength="50" size="30"/>
							<%}else { %>
								<input type="text" name="docLicNo1" value="<%=docLicNo1==null?"":docLicNo1 %>" maxlength="50" size="30" readonly/>
							<%} %>			
							</td>
							<td class="infoData2" width="15%"></td>
							<td class="infoLabel" width="15%"><bean:message key="prompt.issuedDate" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="textfield" name="docLicExpdate1" id="docLicExpdate1" class="datepickerfield notEmpty" value="<%=docLicExpdate1==null?"":docLicExpdate1 %>" maxlength="10" size="16"/>
							<%}else { %>
								<input type="textfield" name="docLicExpdate1" id="docLicExpdate1" class="datepickerfield notEmpty" value="<%=docLicExpdate1==null?"":docLicExpdate1 %>" maxlength="10" size="16" readonly/>		
							<%} %>										
							</td>							
							<td class="infoData2" width="25%"></td>							
						</tr>						
						<tr class="smallText basicInfo2" type='basicInfo2'>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.LICNO" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docLicNo2" value="<%=docLicNo2==null?"":docLicNo2 %>" maxlength="50" size="30"/>
							<%}else { %>
								<input type="text" name="docLicNo2" value="<%=docLicNo2==null?"":docLicNo2 %>" maxlength="50" size="30" readonly/>
							<%} %>			
							</td>
							<td class="infoData2" width="15%"></td>
							<td class="infoLabel" width="15%"><bean:message key="prompt.issuedDate" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="textfield" name="docLicExpdate2" id="docLicExpdate2" class="datepickerfield notEmpty" value="<%=docLicExpdate2==null?"":docLicExpdate2 %>" maxlength="10" size="16"/>
							<%}else { %>
								<input type="textfield" name="docLicExpdate2" id="docLicExpdate2" class="datepickerfield notEmpty" value="<%=docLicExpdate2==null?"":docLicExpdate2 %>" maxlength="10" size="16" readonly/>		
							<%} %>										
							</td>							
							<td class="infoData2" width="25%"></td>
						</tr>								
						<%-- End basicInfo2 --%>						
						<%-- basicInfo3 --%>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform5" /></font>
							</td>							
						</tr>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoData2" colspan=6>
								<bean:message key="prompt.newForm.content1" />
							</td>							
						</tr>								
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoData2" width="75%" colspan="5"><font size="4"></font><bean:message key="prompt.newForm.question1" /></td>		
							<td class="infoData2" width="25%">	
							<%if (docHealthStatus1!= null && "Y".equals(docHealthStatus1)) { %>
								<%if(viewAction||updateAction){ %>			
									<input type=checkbox name="docHealthStatusYes1" value="Y" id="docHealthStatusYes1" checked="checked" />Yes&nbsp
									<input type=checkbox name="docHealthStatusNo1" value="N" id="docHealthStatusNo1"/>NO									
								<%}else{ %>
									<input type=checkbox name="docHealthStatusYes1" value="Y" id="docHealthStatusYes1" checked="checked" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docHealthStatusNo1" value="N" id="docHealthStatusNo1" disabled="disabled"/>NO									
								<%} %>
							<%} else if(docHealthStatus1!= null && "N".equals(docHealthStatus1)){ %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docHealthStatusYes1" value="N" id="docHealthStatusYes1"/>Yes&nbsp
									<input type=checkbox name="docHealthStatusNo1" value="Y" id="docHealthStatusNo1" checked="checked" />NO									
								<%}else{ %>
									<input type=checkbox name="docHealthStatusYes" value="N" id="docHealthStatusYes1" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docHealthStatusNo" value="Y" id="docHealthStatusNo1" checked="checked" disabled="disabled"/>NO	
								<%} %>
							<% } else { %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docHealthStatusYes1" value="N" id="docHealthStatusYes1"/>Yes&nbsp
									<input type=checkbox name="docHealthStatusNo1" value="N" id="docHealthStatusNo1"/>NO									
								<%}else{ %>
									<input type=checkbox name="docHealthStatusYes1" value="N" id="docHealthStatusYes1" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docHealthStatusNo1" value="N" id="docHealthStatusNo1" disabled="disabled"/>NO	
								<%} %>							
							<% }%>			
							</td>	
						</tr>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoData2" width="75%" colspan="5"><font size="4"></font><bean:message key="prompt.newForm.question2" /></td>		
							<td class="infoData2" width="25%">	
							<%if (docHealthStatus2!= null && "Y".equals(docHealthStatus2)) { %>
								<%if(viewAction||updateAction){ %>			
									<input type=checkbox name="docHealthStatusYes2" value="Y" id="docHealthStatusYes2" checked="checked" />Yes&nbsp
									<input type=checkbox name="docHealthStatusNo2" value="N" id="docHealthStatusNo2"/>NO									
								<%}else{ %>
									<input type=checkbox name="docHealthStatusYes2" value="Y" id="docHealthStatusYes2" checked="checked" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docHealthStatusNo2" value="N" id="docHealthStatusNo2" disabled="disabled"/>NO									
								<%} %>
							<%} else if(docHealthStatus2!= null && "N".equals(docHealthStatus2)){ %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docHealthStatusYes2" value="N" id="docHealthStatusYes2"/>Yes&nbsp
									<input type=checkbox name="docHealthStatusNo2" value="Y" id="docHealthStatusNo2" checked="checked" />NO									
								<%}else{ %>
									<input type=checkbox name="docHealthStatusYes2" value="N" id="docHealthStatusYes2" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docHealthStatusNo2" value="Y" id="docHealthStatusNo2" checked="checked" disabled="disabled"/>NO	
								<%} %>
							<% } else { %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docHealthStatusYes2" value="N" id="docHealthStatusYes2"/>Yes&nbsp
									<input type=checkbox name="docHealthStatusNo" value="N" id="docHealthStatusNo2"/>NO									
								<%}else{ %>
									<input type=checkbox name="docHealthStatusYes2" value="N" id="docHealthStatusYes2" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docHealthStatusNo2" value="N" id="docHealthStatusNo2" disabled="disabled"/>NO	
								<%} %>							
							<% }%>			
							</td>	
						</tr>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoData2" width="75%" colspan="5"><font size="4"></font><bean:message key="prompt.newForm.question2" /></td>		
							<td class="infoData2" width="25%">	
							<%if (docHealthStatus2!= null && "Y".equals(docHealthStatus2)) { %>
								<%if(viewAction||updateAction){ %>			
									<input type=checkbox name="docHealthStatusYes2" value="Y" id="docHealthStatusYes2" checked="checked" />Yes&nbsp
									<input type=checkbox name="docHealthStatusNo2" value="N" id="docHealthStatusNo2"/>NO									
								<%}else{ %>
									<input type=checkbox name="docHealthStatusYes2" value="Y" id="docHealthStatusYes2" checked="checked" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docHealthStatusNo2" value="N" id="docHealthStatusNo2" disabled="disabled"/>NO									
								<%} %>
							<%} else if(docHealthStatus2!= null && "N".equals(docHealthStatus2)){ %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docHealthStatusYes2" value="N" id="docHealthStatusYes2"/>Yes&nbsp
									<input type=checkbox name="docHealthStatusNo2" value="Y" id="docHealthStatusNo2" checked="checked" />NO									
								<%}else{ %>
									<input type=checkbox name="docHealthStatusYes2" value="N" id="docHealthStatusYes2" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docHealthStatusNo2" value="Y" id="docHealthStatusNo2" checked="checked" disabled="disabled"/>NO	
								<%} %>
							<% } else { %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docHealthStatusYes2" value="N" id="docHealthStatusYes2"/>Yes&nbsp
									<input type=checkbox name="docHealthStatusNo" value="N" id="docHealthStatusNo2"/>NO									
								<%}else{ %>
									<input type=checkbox name="docHealthStatusYes2" value="N" id="docHealthStatusYes2" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docHealthStatusNo2" value="N" id="docHealthStatusNo2" disabled="disabled"/>NO	
								<%} %>							
							<% }%>			
							</td>	
						</tr>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform4" /></font>
							</td>							
						</tr>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoData2" colspan=6>
								<b><bean:message key="prompt.newForm.content3" /></b>
							</td>							
						</tr>						
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.insCarrier" /></td>
							<td class="infoData2" width="45%" colspan=3>
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docInsureCarr" value="<%=docInsureCarr==null?"":docInsureCarr %>" maxlength="50" size="50"/>
							<%}else { %>
								<input type="text" name="docInsureCarr" value="<%=docInsureCarr==null?"":docInsureCarr %>" maxlength="50" size="50" readonly/>
							<%} %>			
							</td>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.expiryDateDmy" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>
								<input type="textfield" name="docInsureCarrExpDate" id="docInsureCarrExpDate" class="datepickerfield notEmpty" value="<%=docInsureCarrExpDate==null?"":docInsureCarrExpDate %>" maxlength="10" size="16"/>
							<%}else { %>
								<input type="textfield" name="docInsureCarrExpDate" id="docInsureCarrExpDate" class="datepickerfield notEmpty" value="<%=docInsureCarrExpDate==null?"":docInsureCarrExpDate %>" maxlength="10" size="16" readonly/>		
							<%} %>			
							</td>														
						</tr>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoData2" colspan=6>
								<b><bean:message key="prompt.newForm.content4" /></b>
							</td>							
						</tr>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoData2" width="75%" colspan="5"><font size="4"></font><bean:message key="prompt.newForm.question4" /></td>		
							<td class="infoData2" width="25%">	
							<%if (docOtherInfo1!= null && "Y".equals(docOtherInfo1)) { %>
								<%if(viewAction||updateAction){ %>			
									<input type=checkbox name="docOtherInfoYes1" value="Y" id="docOtherInfoYes1" checked="checked" />Yes&nbsp
									<input type=checkbox name="docOtherInfoNo1" value="N" id="docOtherInfoNo1"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes1" value="Y" id="docOtherInfoYes1" checked="checked" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo1" value="N" id="docOtherInfoNo1" disabled="disabled"/>NO									
								<%} %>
							<%} else if(docOtherInfo1!= null && "N".equals(docOtherInfo1)){ %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes1" value="N" id="docOtherInfoYes1"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo1" value="Y" id="docOtherInfoNo1" checked="checked" />NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes1" value="N" id="docOtherInfoYes1" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo1" value="Y" id="docOtherInfoNo1" checked="checked" disabled="disabled"/>NO	
								<%} %>
							<% } else { %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes1" value="N" id="docOtherInfoYes1"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo1" value="N" id="docOtherInfoNo1"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes1" value="N" id="docOtherInfoYes1" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo1" value="N" id="docOtherInfoNo1" disabled="disabled"/>NO	
								<%} %>							
							<% }%>			
							</td>	
						</tr>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoData2" width="75%" colspan="5"><font size="4"></font><bean:message key="prompt.newForm.question5" /></td>		
							<td class="infoData2" width="25%">	
							<%if (docOtherInfo2!= null && "Y".equals(docOtherInfo2)) { %>
								<%if(viewAction||updateAction){ %>			
									<input type=checkbox name="docOtherInfoYes2" value="Y" id="docOtherInfoYes2" checked="checked" />Yes&nbsp
									<input type=checkbox name="docOtherInfoNo2" value="N" id="docOtherInfoNo2"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes2" value="Y" id="docOtherInfoYes2" checked="checked" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo2" value="N" id="docOtherInfoNo2" disabled="disabled"/>NO									
								<%} %>
							<%} else if(docOtherInfo2!= null && "N".equals(docOtherInfo2)){ %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes2" value="N" id="docOtherInfoYes2"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo2" value="Y" id="docOtherInfoNo2" checked="checked" />NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes2" value="N" id="docOtherInfoYes2" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo2" value="Y" id="docOtherInfoNo2" checked="checked" disabled="disabled"/>NO	
								<%} %>
							<% } else { %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes2" value="N" id="docOtherInfoYes2"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo2" value="N" id="docOtherInfoNo2"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes2" value="N" id="docOtherInfoYes2" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo2" value="N" id="docOtherInfoNo2" disabled="disabled"/>NO	
								<%} %>							
							<% }%>			
							</td>	
						</tr>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoData2" width="75%" colspan="5"><font size="4"></font><bean:message key="prompt.newForm.question6" /></td>		
							<td class="infoData2" width="25%">	
							<%if (docOtherInfo3!= null && "Y".equals(docOtherInfo3)) { %>
								<%if(viewAction||updateAction){ %>			
									<input type=checkbox name="docOtherInfoYes3" value="Y" id="docOtherInfoYes3" checked="checked" />Yes&nbsp
									<input type=checkbox name="docOtherInfoNo3" value="N" id="docOtherInfoNo3"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes3" value="Y" id="docOtherInfoYes3" checked="checked" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo3" value="N" id="docOtherInfoNo3" disabled="disabled"/>NO									
								<%} %>
							<%} else if(docOtherInfo3!= null && "N".equals(docOtherInfo3)){ %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes3" value="N" id="docOtherInfoYes3"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo3" value="Y" id="docOtherInfoNo3" checked="checked" />NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes3" value="N" id="docOtherInfoYes3" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo3" value="Y" id="docOtherInfoNo3" checked="checked" disabled="disabled"/>NO	
								<%} %>
							<% } else { %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes3" value="N" id="docOtherInfoYes3"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo3" value="N" id="docOtherInfoNo3"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes3" value="N" id="docOtherInfoYes3" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo3" value="N" id="docOtherInfoNo3" disabled="disabled"/>NO	
								<%} %>							
							<% }%>			
							</td>	
						</tr>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoData2" width="75%" colspan="5"><font size="4"></font><bean:message key="prompt.newForm.question7" /></td>		
							<td class="infoData2" width="25%">	
							<%if (docOtherInfo4!= null && "Y".equals(docOtherInfo4)) { %>
								<%if(viewAction||updateAction){ %>			
									<input type=checkbox name="docOtherInfoYes4" value="Y" id="docOtherInfoYes4" checked="checked" />Yes&nbsp
									<input type=checkbox name="docOtherInfoNo4" value="N" id="docOtherInfoNo4"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes4" value="Y" id="docOtherInfoYes4" checked="checked" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo4" value="N" id="docOtherInfoNo4" disabled="disabled"/>NO									
								<%} %>
							<%} else if(docOtherInfo4!= null && "N".equals(docOtherInfo4)){ %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes4" value="N" id="docOtherInfoYes4"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo4" value="Y" id="docOtherInfoNo4" checked="checked" />NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes4" value="N" id="docOtherInfoYes4" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo4" value="Y" id="docOtherInfoNo4" checked="checked" disabled="disabled"/>NO	
								<%} %>
							<% } else { %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes4" value="N" id="docOtherInfoYes4"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo4" value="N" id="docOtherInfoNo4"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes4" value="N" id="docOtherInfoYes4" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo4" value="N" id="docOtherInfoNo4" disabled="disabled"/>NO	
								<%} %>							
							<% }%>			
							</td>	
						</tr>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoData2" width="75%" colspan="5"><font size="4"></font><bean:message key="prompt.newForm.question8" /></td>		
							<td class="infoData2" width="25%">	
							<%if (docOtherInfo5!= null && "Y".equals(docOtherInfo5)) { %>
								<%if(viewAction||updateAction){ %>			
									<input type=checkbox name="docOtherInfoYes5" value="Y" id="docOtherInfoYes5" checked="checked" />Yes&nbsp
									<input type=checkbox name="docOtherInfoNo5" value="N" id="docOtherInfoNo5"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes5" value="Y" id="docOtherInfoYes5" checked="checked" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo5" value="N" id="docOtherInfoNo5" disabled="disabled"/>NO									
								<%} %>
							<%} else if(docOtherInfo5!= null && "N".equals(docOtherInfo5)){ %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes5" value="N" id="docOtherInfoYes5"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo5" value="Y" id="docOtherInfoNo5" checked="checked" />NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes5" value="N" id="docOtherInfoYes5" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo5" value="Y" id="docOtherInfoNo5" checked="checked" disabled="disabled"/>NO	
								<%} %>
							<% } else { %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes5" value="N" id="docOtherInfoYes5"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo5" value="N" id="docOtherInfoNo5"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes5" value="N" id="docOtherInfoYes5" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo5" value="N" id="docOtherInfoNo5" disabled="disabled"/>NO	
								<%} %>							
							<% }%>			
							</td>	
						</tr>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoData2" width="75%" colspan="5"><font size="4"></font><bean:message key="prompt.newForm.question9" /></td>		
							<td class="infoData2" width="25%">	
							<%if (docOtherInfo5!= null && "Y".equals(docOtherInfo5)) { %>
								<%if(viewAction||updateAction){ %>			
									<input type=checkbox name="docOtherInfoYes6" value="Y" id="docOtherInfoYes6" checked="checked" />Yes&nbsp
									<input type=checkbox name="docOtherInfoNo6" value="N" id="docOtherInfoNo6"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes6" value="Y" id="docOtherInfoYes6" checked="checked" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo6" value="N" id="docOtherInfoNo6" disabled="disabled"/>NO									
								<%} %>
							<%} else if(docOtherInfo5!= null && "N".equals(docOtherInfo5)){ %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes6" value="N" id="docOtherInfoYes6"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo6" value="Y" id="docOtherInfoNo6" checked="checked" />NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes6" value="N" id="docOtherInfoYes6" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo6" value="Y" id="docOtherInfoNo6" checked="checked" disabled="disabled"/>NO	
								<%} %>
							<% } else { %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes6" value="N" id="docOtherInfoYes6"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo6" value="N" id="docOtherInfoNo6"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes6" value="N" id="docOtherInfoYes6" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo6" value="N" id="docOtherInfoNo6" disabled="disabled"/>NO	
								<%} %>							
							<% }%>			
							</td>	
						</tr>
						<tr class="smallText basicInfo3" type='basicInfo3'>
							<td class="infoData2" width="75%" colspan="5"><font size="4"></font><bean:message key="prompt.newForm.question10" /></td>		
							<td class="infoData2" width="25%">	
							<%if (docOtherInfo5!= null && "Y".equals(docOtherInfo5)) { %>
								<%if(viewAction||updateAction){ %>			
									<input type=checkbox name="docOtherInfoYes7" value="Y" id="docOtherInfoYes7" checked="checked" />Yes&nbsp
									<input type=checkbox name="docOtherInfoNo7" value="N" id="docOtherInfoNo7"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes7" value="Y" id="docOtherInfoYes7" checked="checked" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo7" value="N" id="docOtherInfoNo7" disabled="disabled"/>NO									
								<%} %>
							<%} else if(docOtherInfo5!= null && "N".equals(docOtherInfo5)){ %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes7" value="N" id="docOtherInfoYes7"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo7" value="Y" id="docOtherInfoNo7" checked="checked" />NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes7" value="N" id="docOtherInfoYes7" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo7" value="Y" id="docOtherInfoNo7" checked="checked" disabled="disabled"/>NO	
								<%} %>
							<% } else { %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docOtherInfoYes7" value="N" id="docOtherInfoYes7"/>Yes&nbsp
									<input type=checkbox name="docOtherInfoNo7" value="N" id="docOtherInfoNo7"/>NO									
								<%}else{ %>
									<input type=checkbox name="docOtherInfoYes7" value="N" id="docOtherInfoYes7" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docOtherInfoNo7" value="N" id="docOtherInfoNo7" disabled="disabled"/>NO	
								<%} %>							
							<% }%>			
							</td>	
						</tr>																												
						<%-- End basicInfo3 --%>
						
						<%-- basicInfo3 --%>
						<tr class="smallText basicInfo4" type='basicInfo4'>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.newForm01" /></font>
							</td>							
						</tr>
						<tr class="smallText basicInfo4" type='basicInfo4'>
							<td class="infoData2" colspan=6>
								<bean:message key="prompt.newForm.content5" />
							</td>							
						</tr>
						<tr class="smallText basicInfo4" type='basicInfo4'>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.sms.op.doctitle" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docProfRef1" value="<%=docProfRef1==null?"":docProfRef1 %>" maxlength="50" size="30"/>
							<%}else { %>
								<input type="text" name="docProfRef1" value="<%=docProfRef1==null?"":docProfRef1 %>" maxlength="50" size="30" readonly/>
							<%} %>			
							</td>
							<td class="infoLabel" width="20%"><bean:message key="prompt.addressFaxEmail" /></td>
							<td class="infoData2" width="45%" colspan="3">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docProfRefContact1" value="<%=docProfRefContact1==null?"":docProfRefContact1 %>" maxlength="100" size="100"/>
							<%}else { %>
								<input type="text" name="docProfRefContact1" value="<%=docProfRefContact1==null?"":docProfRefContact1 %>" maxlength="100" size="100" readonly/>
							<%} %>			
							</td>						
						</tr>
						<tr class="smallText basicInfo4" type='basicInfo4'>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.sms.op.doctitle" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docProfRef2" value="<%=docProfRef2==null?"":docProfRef2 %>" maxlength="50" size="30"/>
							<%}else { %>
								<input type="text" name="docProfRef2" value="<%=docProfRef2==null?"":docProfRef2 %>" maxlength="50" size="30" readonly/>
							<%} %>			
							</td>
							<td class="infoLabel" width="20%"><bean:message key="prompt.addressFaxEmail" /></td>
							<td class="infoData2" width="45%" colspan="3">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docProfRefContact2" value="<%=docProfRefContact2==null?"":docProfRefContact2 %>" maxlength="100" size="100"/>
							<%}else { %>
								<input type="text" name="docProfRefContact2" value="<%=docProfRefContact2==null?"":docProfRefContact2 %>" maxlength="100" size="100" readonly/>
							<%} %>			
							</td>						
						</tr>												
						<tr class="smallText basicInfo4" type='basicInfo4'>
							<td class="infoData2" colspan=6>
								<bean:message key="prompt.newForm.content6" />
							</td>							
						</tr>
						<tr class="smallText basicInfo4" type='basicInfo4'>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.newForm02" /></font>
							</td>							
						</tr>
						<tr class="smallText basicInfo4" type='basicInfo4'>
							<td class="infoData2" colspan=6>
								<table>
								<tr>		
									<td width="50%" align="right">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv01" checked="checked"/>
										<bean:message key="prompt.addressFaxEmail" />						
									<%}else { %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv01" checked="checked"/>
										<bean:message key="prompt.addressFaxEmail" />						
									<%} %>			
									</td>
									<td width="50%" align="right">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv02" checked="checked"/>
										<bean:message key="prompt.addressFaxEmail" />						
									<%}else { %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv02" checked="checked"/>
										<bean:message key="prompt.addressFaxEmail" />						
									<%} %>			
									</td>															
								</tr>
								</table>
							</td>							
						</tr>																																													
						<%-- End basicInfo4 --%>										
					</table>
										
					<%--prev/next step btn --%>

					<input type="hidden" name="command" value="<%=command%>"/>
					<input type="hidden" name="selectedIncidentType" value="<%=incident_type%>"/>
					<input type="hidden" name="pirID" value="<%=pirID%>"/>
					
					<input type="hidden" name="pageIndex" value="<%=pageIndex%>"/>
				</form>

<script language="javascript">
var editAction = false;
var viewAction = false;
var viewRptAction = false;
var checkList = new Array();
var apis = [];

function windowOnClose() {
	return 'Are you sure to close this page?';
}

$(document).ready(function() {
	//window.addEventListener("beforeunload",windowOnClose);

	$('#status').hide();

	 $(window).bind('beforeunload', windowOnClose); 
	
	setInterval("animation()",1000);
	selectStepEvent();
	selectClassEvent();
	var command = $('input[name=command]').val();
	if(command == 'edit') {
		editAction = true;
	}
	else if(command.indexOf('view') > -1) {
		viewAction = true;
	}
	$('input[name=command]').val('');
	
	
	if(viewAction) {
		$('div.reportContent').appendTo('div#content-container');
		initScroll('div#report', true);
		selectReportItemEvent();
		if(command.indexOf('view_rpt') > -1) {
			viewRptAction = true;
		}
		
		if (viewRptAction) {
//			viewReport();
		}
	}
	else if(editAction) {
		editAction = true;
		addEvent('.AddInvolvePatientInfo', 'patient');
		resetDatepicker(true);
		addEvent('.AddInvolveStaffInfo', 'staff');
		addEvent('.AddInvolveVisitorInfo', 'visitor');
		addEvent('.AddInvolveOthersInfo', 'other');
		removeEvent();
		//handleIncludePage();
		resetDatepicker(false);
		//headerEvent();
		$('#report .content-frame').each(function(i, v){
			if($(this).find('[contentId]').length > 0) {
				$(this).prev().trigger('click');
			}
		});
		$('div #removeImage').each(function(i, v) {
			if($(this).parent().find('[contentId]').length > 0) {
				if(!($(this).parent().find('.copy').length > 0)) {
					$(this).remove();
				}
				else {
					if(!($(this).next().find('tr').length > 0)) {
						$(this).next().remove();
						$(this).remove();
					}
				}
			}
			else {
				$(this).remove();
			}
		});
		involveVisitorInfoEvent();

		$('div.reportContent').appendTo('div#content-container');
		initScroll('div#report', true);
		selectReportItemEvent();
		// toy add on 2/3/2015
		makeCheckList();
	}
	else {
//		alert('* CONFIDENTIAL\n* Not part of Patient\'s Medical Record');
	}
	
	$('table').each(function(i, v) {
		if(!($(this).find('tr').length > 0)) {
			$(this).remove();
		}
	});
	submitEvent();
	$('body').css('display', '');
	referKeyEvent();
	referKeyEventChkbox();
	
});



<%--/**********************Step Flow********************/--%>
//Modified on 02-04-2012 Select Step Event
function selectStepEvent() {
	$('div.stepBtn').click(function() {
		var type = $(this).attr('type');
		
		$(this).addClass('selected');
		$('.'+type).css('display', '');
		
		$('div.stepBtn').each(function(i, v){
			if($(v).attr('type') != type) {
				$(this).removeClass('selected');
				$('form[name=reportForm]').find('table.reportcontent').find
				('.'+$(v).attr('type')).css('display', 'none');
			}
		});		
	});
	prevNextStepEvent();

	$('div.stepBtn:first').trigger('click');
}
//Modified on 02-04-2012 control prev/next btn event
function prevNextStepEvent() {
	$('div.prevBtn').click(function() {
		var dom;
		var selected = false;
		$('div.stepBtn').each(function(i, v){
			if($(v).hasClass('selected')) {
				selected = true;
			}
			if(selected) {
				dom.trigger('click');
				selected = false;
				return;
			}
			dom = $(v);
		});
	});
		
	$('div.nextBtn').click(function() {
		var selected = false;
		$('div.stepBtn').each(function(i, v){
			if(selected) {
				$(v).trigger('click');
				selected = false;
				return;
			}
			if($(v).hasClass('selected')) {
				selected = true;
			}
		});
	});
}
<%--**********************/Step Flow********************--%>

<%--******************Involving Person******************--%>
//Modified on 02/04/2012 the event of removing the block of involving person
function removeEvent() {
	$('.removeInvolvePatientInfo').unbind('click');
	$('.removeInvolvePatientInfo').each(function() {
		$(this).click(function() {
			$(this).parent().parent().parent().parent().remove();
		});
	});
}

//Modified on 02/04/2012 the event of adding involving person
function addEvent(target, type){
	$(target).each(function() {
		$(this).unbind('click');
		$(this).click(function() {
			showInfo(type);
		});
	});
}
//Modified on 02/04/2012 the event of showing the info fields of involving person
function showInfo(type){
	var addBtn = '';
		if (type == 'patient') {
			Row = $('div#hiddenInvolvePatientInfo').html();
			$('<div class="involvedPartyInfoPatient">'+Row+'</div>').appendTo('div#involvedPartyInfoPatient');
			addBtn = '.AddInvolvePatientInfo';
			resetDatepicker(true);
		}
		if(type == 'staff'){
			Row = $('div#hiddenInvolveStaffInfo').html();
			$('<div class="involvedPartyInfoStaff">'+Row+'</div>').appendTo('div#involvedPartyInfoStaff');
			addBtn = '.AddInvolveStaffInfo';
		}
		if(type == 'visitor'){
			Row = $('div#hiddenInvolveVisitorInfo').html();
			$('<div class="involvedPartyInfoVisitor">'+Row+'</div>').appendTo('div#involvedPartyInfoVisitor');
			addBtn = '.AddInvolveVisitorInfo';
			involveVisitorInfoEvent();
		}
		if(type == 'other'){
			Row = $('div#hiddenInvolveOthersInfo').html();
			$('<div class="involvedPartyInfoOther">'+Row+'</div>').appendTo('div#involvedPartyInfoOther');
			addBtn = '.AddInvolveOthersInfo';
		}
		addEvent(addBtn, type);
	return false;
}
<%--******************/Involving Person******************--%>

<%--****************************Scroll****************************--%>
//Modified on 02/04/2012 init scrollbar
function initScroll(target, autoReinitialise) {
	//destroyScroll();
	$(target).find('.scroll-pane').each(function(){
		apis.push($(this).jScrollPane({autoReinitialise:autoReinitialise}).data().jsp);
	});
	return false;
}
//Modified on 02/04/2012 destroy scrollbar
function destroyScroll() {
	if (apis.length) {
		$.each(apis,function(i) {
				this.destroy();
		});
		apis = [];
	}
	return false;
}
<%--****************************/Scroll****************************--%>

<%--**************************Go to required & empty field**************************--%>
//Modified on 02/04/2012 go to the step that contains an empty field
function goToHasEmptyStepFlow() {
	var dom = $('div.alert:first');
	while(!dom.attr('type')) {
		dom = dom.parent();
	}
	$('div.stepBtn[type='+dom.attr('type')+']').trigger('click');
}
//Modified on 03/04/2012 go to the category that is not be filled
function goToHeaderEvent() {
	var atom = false;
	var info = "";
	var atomFirstItem = "";
	//alert("Please fill all required information!");
	
	//headerEvent();
	$('#report .header').find('.alert').html('');
	$.each(checkList, function(i, v) {
		
		if (v) {
			info = v.split(',');
			if(info.length > 1) {
				$.each(info, function(i2, v2) {
					atom = true;
					if (i2 == 0) {
						atomFirstItem = v2;
					}
				});
			}
			else {
				$('#report [grpID='+v+']').find('.alert').html("<img src='../images/alert_general.gif' style='width:15px; height:15px;'/>");
			}
		}
	});	
	
	//alert("atom, checkList[0], atomFirstItem :  : " + atom + " " + checkList[0] + " " + atomFirstItem);
	
	if (atom) {
		alert("Please fill all required information! \nPlease enter ONE of the appropriate section (from a to n)");
		info = checkList[0].split(',');
		if(info.length == 1) {
			atomFirstItem = checkList[0]; 
		}
		$('#report [grpID='+atomFirstItem+']').trigger('click');//need handle more than one category
	}
	else {	
		alert("Please fill all required information!");
		$('#report [grpID='+checkList[0]+']').trigger('click');//need handle more than one category
	}	
	
	$('div.stepBtn[type=basicInfo3]').trigger('click');
	
	makeCheckList();
	return false;
}
<%--**************************/Go to required & empty field**************************--%>

<%--**************************Checking before submit**************************--%>
//Modified on 02/04/2012 checking the information which cannot be null
function checkRequiredInfo() {
	var hasEmpty = false;
	
	$('form#form1').find('div.alert').remove();
	$('form#form1').find('.notEmpty').each(function(i, v) {
		
		if(this.tagName.toLowerCase() == 'input') {
			if($(this).val().length <= 0) {
				$(this).after("<div class='alert'><img src='../images/alert_general.gif' style='width:15px; height:15px;'/><b>This information is required.</b></div>");
				hasEmpty = true;
			}
		}
		else if(this.tagName.toLowerCase() == 'textarea') {
			if($(this).val().length <= 0) {
				$(this).after("<div class='alert'><img src='../images/alert_general.gif' style='width:15px; height:15px;'/><b>This information is required.</b></div>");
				hasEmpty = true;
			}
		}
		else if(this.tagName.toLowerCase() == 'select') {
			if($(this).find('option:selected').val().length <= 0) {
				$(this).after("<div class='alert'><img src='../images/alert_general.gif' style='width:15px; height:15px;'/><b>This information is required.</b></div>");
				hasEmpty = true;
			}
		}
	});
	
	return hasEmpty;
}
<%--**************************/Checking before submit**************************--%>

<%--***************************Handling content before submit***************************--%>
//Modified on 03/04/2012 handling the content of involving person
function mergeInvolePersonInfo() {
	var personInfo = '';
	// end followup to person
	$('.involvedPartyInfoPatient').each(function(index, value) {
		if($(this).children().size() > 0) {
			personInfo = '<input type="hidden" name="isPatientInfo" value="'+
								$(this).find('[name=patHosNo]').val()+'||'+
								$(this).find('[name=patName]').val()+'||'+
								$(this).find('[name=patSex] option:selected').val()+'||'+
								$(this).find('[name=patAge]').val()+'||'+
								$(this).find('[name=patDOB]').val()+'||'+
								$(this).find('[name=attPhy]').val()+'||'+
								$(this).find('[name=diagnosis]').val()
								+((editAction)?('||'+$(this).find('[name=pir_ip_id]').val()):"")
							+'">';
			
			$(personInfo).appendTo('div#involvedPartyInfoPatient');
		}
	});
	
	$('.involvedPartyInfoStaff').each(function(index, value) {
		if($(this).children().size() > 0) {
			personInfo = '<input type="hidden" name="isStaffInfo" value="'+
								$(this).find('[name=sameAsReport]').attr('checked')+'||'+
								$(this).find('[name=involveStaffNo]').val()+'||'+
								$(this).find('[name=involeStaffHosNo]').val()+'||'+
								$(this).find('[name=involveStaffName]').val()+'||'+
								$(this).find('[name=involveStaffRank]').val()+'||'+
								$(this).find('[name=involveStaffDept] option:selected').val()+'||'+
								$(this).find('[name=involveStaffSex] option:selected').val()
								+((editAction)?('||'+$(this).find('[name=pir_ip_id]').val()):"")
							+'"/>';	
		
			$(personInfo).appendTo('div#involvedPartyInfoStaff');
		}
	});
	
	$('.involvedPartyInfoVisitor').each(function(index, value) {
		if($(this).children().size() > 0) {
			personInfo = '<input type="hidden" name="isVisitorInfo" value="'+
								$(this).find('[name=visitorOfPat]').attr('checked')+'||'+
								$(this).find('[name=involveVisitPatNo]').val()+'||'+
								$(this).find('[name=visitorOfStaff]').attr('checked')+'||'+
								$(this).find('[name=involveVisitStaffNo]').val()+'||'+
								$(this).find('[name=involveVisitorName]').val()+'||'+
								$(this).find('[name=involveVisitorRelationship]').val()+'||'+
								$(this).find('[name=involveVisitorRemark]').val()+'||'+
								$(this).find('[name=involveVisitorTel]').val()+'||'+
								$(this).find('[name=involveVisitorAddr]').val()+'||'+
								$(this).find('[name=involveVisitorDept] option:selected').val()
								+((editAction)?('||'+$(this).find('[name=pir_ip_id]').val()):"")
							+'"/>';	
							
			$(personInfo).appendTo('div#involvedPartyInfoVisitor');
		}
	});
	
	$('.involvedPartyInfoOther').each(function(index, value) {
		if($(this).children().size() > 0) {
			personInfo = '<input type="hidden" name="isOtherInfo" value="'+
								$(this).find('[name=involveOthersStatus] option:selected').val()+'||'+
								$(this).find('[name=involveOtherName]').val()+'||'+
								$(this).find('[name=involveOtherRemark]').val()+'||'+
								$(this).find('[name=involveOtherTel]').val()+'||'+
								$(this).find('[name=involveOtherAddr]').val()								
								+((editAction)?('||'+$(this).find('[name=pir_ip_id]').val()):"")
							+'"/>';	
							
			$(personInfo).appendTo('div#involvedPartyInfoOther');
		}
	});
}
//Modified on 03/04/2012 handling the report content
function handleReportContent(saveonly) {
	var report = $('div#report');
	var hiddenInput = $('input[name='+$('input[name=selectedIncidentType]').val()+'_value]');
	var hiddenInputVal = hiddenInput.val();
	
	report.find('[optType=checkbox]:checked').each(function(i, v) {		
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#checkbox@#checked@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		if(saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=checkInput]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#checkInput@#'+
							$(this).next().val()+'@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		if(saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=yesNo]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#yesNo@#'+
							$(this).val()+'@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		if(saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=input]').each(function(i, v) {
		if($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('id')+'@#input@#'+
								$(this).val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			if(saveonly == 'N') {
				checkValue($(this).attr('category'));
			}
		}
	});
	report.find('[optType=textarea]').each(function(i, v) {
		if($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('id')+'@#textarea@#'+
								$(this).val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			if(saveonly == 'N') {
				checkValue($(this).attr('category'));
			}
		}
	});
	report.find('[optType=checkboxInput]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#checkboxInput@#'+
							$(this).next().val()+'@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		if(saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=radio]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#radio@#checked@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		if(saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=date]').each(function(i, v) {
		if($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('optid')+'@#date@#'+
								$(this).val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			if(saveonly == 'N') {
				checkValue($(this).attr('category'));
			}
		}
	});
	report.find('[optType=datetime]').each(function(i, v) {
		if($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('optid')+'@#datetime@#'+
								$(this).val()+' '+
								$(this).parent().find('select[name='+$(this).attr('optid')+'_hh] option:selected').val()+':'+
								$(this).parent().find('select[name='+$(this).attr('optid')+'_mi] option:selected').val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			
			if(saveonly == 'N') {
				checkValue($(this).attr('category'));
			}
		}
	});
	report.find('[optType=checkboxDate]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#checkboxDate@#'+
							$(this).next().val()+'@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		checkValue($(this).attr('category'));
	});
	report.find('[optType=upload]').each(function(i, v) {
		if($(this).attr('contentId') || $(this).find('input').val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('id')+'@#upload@#'+
								($(this).attr('contentId')?$(this).attr('docIDs'):$(this).find('input').val())+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			if(saveonly == 'N') {			
				checkValue($(this).attr('category'));
			}
		}
	});
	
	//alert("checkList.length : " + checkList.length);
	if(saveonly == 'N') {
		if(checkList.length > 0) {
			return false;
		}
	}
	
	//alert("hiddenInput : " + hiddenInputVal);
	hiddenInput.val(hiddenInputVal);
	return true;
}
<%--***************************/Handling content before submit***************************--%>

<%--****************************Copy the content & del the copied content****************************--%>
//Modified on 03/04/2012 delete the copied content
function delPasteDom(dom) {
	var delDom = $(dom).parent().next();
	
	delDom.remove();
	$(dom).parent().remove();
}
//Modified on 03/04/2012 copy the specific content
function copyAndPasteDom(dom) {
	var copyDom = $(dom).parent().find('table');
	var currentCount = $(dom).parent().find('table').attr('count');
	
	$('<div style="float:right;" id="removeImage">'+
		'<img src="../images/delete1.png" style="cursor:pointer" onclick="delPasteDom(this)"/>'+
		'</div>').appendTo($(dom).parent().parent());
	
	var grpId = -1;
	
	if($(dom).parent().parent().find('table:last').attr('contentGrpID')) {
		grpId = $(dom).parent().parent().find('table:last').attr('contentGrpID');
	}
	
	copyDom.clone().appendTo($(dom).parent().parent());
	
	$(dom).parent().parent().find('table:last').attr('contentGrpID', parseInt(grpId)+1);
	
	$(dom).parent().parent().find('.datepickerfield').each(function(i, v) {
		$(this).datepicker('destroy');
		currentCount += 1;
		$(this).attr('id', $(this).attr('optid')+currentCount);
		$(this).datepicker({
	    	showOn: "button",
			buttonImage: "../images/calendar.jpg",
			buttonImageOnly: true
		});
	});
}
<%--****************************/Copy the content & del the copied content****************************--%>

function animation() {
	$('div.confidential').animate( { backgroundColor: 'yellow' }, 500)
    	.animate( { backgroundColor: 'white' }, 500);
}

function resetDatepicker(patient) {
	if(patient) {
		var count = $('.involvedPartyInfoPatient').length;
		$('.involvedPartyInfoPatient:last').find('.datepickerfield').each(function(i, v) {
			$(this).datepicker("destroy");
			$(this).attr('id', count);
			$(this).datepicker({
		    	showOn: "button",
				buttonImage: "../images/calendar.jpg",
				buttonImageOnly: true
			});
		});
	}
	else {
		var currentCount = 0;
		$('#report .datepickerfield').each(function(i, v) {
			$(this).datepicker('destroy');
			currentCount += 1;
			$(this).attr('id', $(this).attr('optid')+currentCount);
			$(this).datepicker({
		    	showOn: "button",
				buttonImage: "../images/calendar.jpg",
				buttonImageOnly: true
			});
		});
	}
}

function selectClassEvent() {
	$('select[name=incidentClass]').change(function() {
		var type = $('option:selected', this).attr('incidentType');
		 if(editAction) {
			 return;
		 }
		 $('input[name=selectedIncidentType]').val(type);
		 
		 $.ajax({
			 type: "POST",
			 url: "report_content2.jsp?incidentType="+type,
			 async: true,
			 cache: false,
			 success: function(values){
				 if(values != '') {
					 $("#incidentTypeForm").html(values).css('display', 'none');
					 //headerEvent();
					 resetDatepicker(false);
					 makeCheckList();
					 submitEvent();
					 $('div.reportContent').appendTo('div#content-container');
					 initScroll('div#report', false);
					 $("#incidentTypeForm").css('display', '');
					 selectReportItemEvent();
					 $('div#report .scroll-pane').data('jsp').reinitialise();
				 }
			 }//success
		 });//$.ajax
	});	
}

function selectReportItemEvent() {
	$('div#menu .reportItem').click(function() {
		 $('div#menu .selected').removeClass('selected');
		 $(this).addClass('selected');
		 $('div#content .jspPane').find('div.reportContent')
		 	.appendTo('div#content-container').css('display', 'none');
		 $('div#content-container').find('div#'+$(this).attr('grpID'))
		 	.appendTo($('div#content .jspPane')).css('display', '');
		 $('div#content div:first').data('jsp').reinitialise();
	 });
	$('div#menu .reportItem:first').trigger('click');
}

function findGrpId(dom) {
	var temp = dom.parent();
	
	while(!$(temp).attr('contentGrpID')) {
		temp = temp.parent();
	} 
	
	return $(temp).attr('contentGrpID');
}

function checkValue(category) {
	if(checkList.length > 0) {
		$.each(checkList, function(i, v) {			
			if(v == category) {
				checkList.splice(i, 1);
				return true;
			}
			else {
				if (v) {			
					//alert("else {, v : " + v);
					var info = v.split(',');
					if(info.length > 1) {										
						$.each(info, function(i2, v2) {
							if(v2 == category) {				
								checkList.splice(i, 1);
								return true;
							}
						});				
					}
				}
			}
		});	
	}else {
		return true;
	}
}

function makeCheckList() {	
	 var must = $('option:selected', $('select[name=incidentClass]')).attr('must');	
	checkList = new Array();
	if(must) {
		var info = must.split(';');
		$.each(info, function(i, v) {
			if(v.length > 0)
				checkList.splice(checkList.length, 0, v);
		});
	}
}

function getRelatedInfo(type, key, dom) {
	var currentDomName = $(dom).attr('name');
	while(!$(dom).is('table')) {
		dom = $(dom).parent();
	}
	if(type == 'patient') {
		$.ajax({
			url: "../ui/patientInfoCMB.jsp?callback=?",
			data: "patno="+key,
			dataType: "jsonp",
			cache: false,
			success: function(values){
				if (currentDomName == 'involveVisitPatNo') {
					$(dom).find('label[name=involveVisitorPatName]').text(values['PATNAME']);

				}
				else {
					$(dom).find('input[name=patName]').val(values['PATNAME']);
					$(dom).find('select[name=patSex]')
						.find('option[value='+values['PATSEX']+']').attr('selected', true);
					$(dom).find('input[name=patAge]').val(values['AGE']);
					$(dom).find('input[name=patDOB]').val(values['PATBDATE']);
					
				}
				
				alert("Please double-check the patient info.");
			},
			error: function(x, s, e) {
				if (currentDomName == 'involveVisitPatNo') {
					$(dom).find('input[name=involveVisitPatNo]').val('');				
					$(dom).find('label[name=involveVisitorPatName]').text('');
				}
				else {
					$(dom).find('input[name=patHosNo]').val('');
					$(dom).find('input[name=patName]').val('');
					$(dom).find('input[name=patAge]').val('');
					$(dom).find('input[name=patDOB]').val('');
					$(dom).find('select[name=patSex]')[0].selectedIndex = 0;
				}				
				
				if(key.length > 0)
					alert("No Such Patient!");
			}
		});
	}
	else if(type == 'staff' || type == 'depthead' || type == 'fu_staff') {
		$.ajax({
			url: "../ui/staffInfoCMB.jsp?callback=?",
			data: "staffid="+key,
			dataType: "jsonp",
			cache: false,
			success: function(values){
				if (currentDomName == 'involveVisitStaffNo') {
					$(dom).find('label[name=involveVisitorStaffName]').text(values['STAFFNAME']);
				} else {
					$(dom).find('input[name=involveStaffNo]').val(key);
					$(dom).find('input[name=involeStaffHosNo]').val(values['PATNO']);
					$(dom).find('select[name=involveStaffSex]')
						.find('option[value='+values['STAFFSEX']+']').attr('selected', true);
					$(dom).find('input[name=involveStaffName]').val(values['STAFFNAME']);
					$(dom).find('select[name=involveStaffDept]')
						.find('option[value='+values['DEPTCODE']+']').attr('selected', true);
					$(dom).find('input[name=deptHead]').val(key);
					$(dom).find('input[name=deptHeadName]').val(values['STAFFNAME']);
				}				
			},
			error: function(x, s, e) {
				if(type == 'staff') {
					if (currentDomName == 'involveVisitStaffNo') {
						$(dom).find('input[name=involveVisitStaffNo]').val('');
						$(dom).find('label[name=involveVisitorStaffName]').text('');
					}
					else {
						$(dom).find('input[name=involeStaffHosNo]').val('');
						$(dom).find('input[name=involveStaffName]').val('');
						$(dom).find('select[name=involveStaffSex]')[0].selectedIndex = 0;
						$(dom).find('select[name=involveStaffDept]')[0].selectedIndex = 0;
						$(dom).find('input[name=involveStaffNo]').val('');
						$(dom).find('input[name=sameAsReport]').attr('checked', false);
					}
				}
				else if(type == 'depthead') {
					$(dom).find('input[name=deptHead]').val('');
					$(dom).find('input[name=deptHeadName]').val('');
				}
				else if(type == 'fu_staff') {
					$(dom).find('input[name=involveStaffNo]').val('');
					$(dom).find('input[name=involveStaffName]').val('');
				}
				if(key.length > 0) {
					alert("No Such Staff!");
				}
			}
		});
	}
}

function submitEvent() {
	$('button.reportSubmit').click(function() {
		/*alert($('.involvedPartyInfoPatient').length)*/
		var btn = this;
		var deptHead = $('select[name=deptHead] option:selected').html(); //.trim();		 
		if (deptHead.indexOf(" (") > 0) {
			deptHead = deptHead.substring(0, deptHead.indexOf(" ("));
		}
		
		var dutyMgr = $('select[name=dutyMgr] option:selected').html(); //.trim();		
		if (dutyMgr != "") {
			deptHead  = deptHead + ', ' + dutyMgr;
		}		
		//alert("deptHead="+deptHead+", dutyMgr="+dutyMgr);
		$.prompt('Are you sure ? <br> The report will be submitted to : <br>' + deptHead + '<br>' + '<br> REMINDER: Please send the completed Doctor Incident Examination Form to PI Department (where appropriate). <br>   Almost all incidents require the above form including: <br> -	All patient incidents except security <br> -	All injury incidents',{
			buttons: { Ok: true, Cancel: false },			
			callback: function(v,m,f){
				if (v ){
					submitAction($(btn).attr('submitType'));
				}
			},
			prefix:'cleanblue'
		});
		return false;
	});
}

function submitAction(command) {
	if(command == 'create' || command == 'create_px2') {
		// toy		
		if ($('.involvedPartyInfoPatient').length == 0 && $('.involvedPartyInfoStaff').length == 0 && $('.involvedPartyInfoVisitor').length == 0 && $('.involvedPartyInfoOther').length == 0) {
			alert('Please input involving person');
			return false;
		}
		if(checkRequiredInfo()) {
			goToHasEmptyStepFlow();
			return false;
		}
		if(!handleReportContent('N')) {
			goToHeaderEvent();
			return false;
		}
		mergeInvolePersonInfo();
	}
	else if(command == 'create_saveonly') {
		// toy		
		//if ($('.involvedPartyInfoPatient').length == 0 && $('.involvedPartyInfoStaff').length == 0 && $('.involvedPartyInfoVisitor').length == 0 && $('.involvedPartyInfoOther').length == 0) {
			//alert('Please input involving person');
			//return false;
		//}
		//if(checkRequiredInfo()) {
			//goToHasEmptyStepFlow();
			//return false;
		//}
		if(!handleReportContent('Y')) {
			//goToHeaderEvent();
			//return false;
		}
		mergeInvolePersonInfo();		
	}
	else if(command == 'edit') {
		
	}
	else if(command == 'update' || command == 'update_px2') {
		// toy		
		//alert('command == update');
		if ($('.involvedPartyInfoPatient').length == 0 && $('.involvedPartyInfoStaff').length == 0 && $('.involvedPartyInfoVisitor').length == 0 && $('.involvedPartyInfoOther').length == 0) {
			alert('Please input involving person');
			return false;
		}
		if(checkRequiredInfo()) {
			goToHasEmptyStepFlow();
			return false;
		}
		if(!handleReportContent('N')) {
			goToHeaderEvent();
			return false;
		}
		mergeInvolePersonInfo();
	}
	else if(command == 'update_saveonly') {
		//if(checkRequiredInfo()) {
		//	goToHasEmptyStepFlow();
		//	return false;
		//}
		if(!handleReportContent('Y')) {
		//	goToHeaderEvent();
		//	return false;
		}
		mergeInvolePersonInfo();
	}
	else if(command.indexOf('view') > -1) {
		handleFlwContent();
	}
	$('input[name=command]').val(command);
	
	//window.removeEventListener("beforeunload",windowOnClose);
	
	$(window).unbind('beforeunload', windowOnClose);
		
	document.reportForm.submit();
	
	$.prompt('Submitting..... Please wait.',{
			prefix:'cleanblue', buttons: { }
	});
		
	return false;
}

function viewReport() {
	callPopUpWindow('PostIncidentExam.jsp?pirID=<%=pirID%>');
}

// Popup window code
function newPopup(url) {
	popupWindow = window.open(
		url,'popUpWindow','height=750,width=750,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
}

</script>
			</DIV>
		</DIV>
	</DIV>
	<jsp:include page="../pi/hiddenInvolvePerson.jsp" flush="false"/>
	<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%
	} 
%>
</html:html>