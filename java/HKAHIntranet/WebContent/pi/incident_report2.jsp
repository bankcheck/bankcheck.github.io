<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.jasper.*"%>
<%!
	private String parseStrUTF8(HttpServletRequest request, String field) {
		String value = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, field));
		if (value != null && !"null".equals(value)) {
			return value;
		} else {
			return null;
		}
	}

	private String[] splitInfo(String info) {
		int j = 0;
		String currentInfo[] = new String[99];
		for (j = 0; info.toString().indexOf("||") > -1 && j < 10; j++) {
			currentInfo[j] = info.toString().substring(0, info.toString().indexOf("||"));

			info = info.toString().substring(info.toString().indexOf("||") + 2, info.toString().length());
		}
		currentInfo[j] = info.toString();

		return currentInfo;
	}

	private boolean isInteger(String i) {
		try {
			Integer.parseInt(i);
			return true;
		} catch(Exception e) {
			return false;
		}
	}

	private boolean AttachmentUpload(UserBean userBean, String[] fileList, String fupirflwID) {
		if (fileList != null) {
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

	private static ArrayList getDutyManager() {
		return UtilDBWeb.getReportableList("SELECT PIR_STAFF_ID, PIR_STAFF_NAME FROM PI_REPORT_PERSON_LIST WHERE PIR_TYPE = 'dutymgr' AND ENABLE = '1' ORDER BY PIR_STAFF_NAME");
	}
	
	class PiReportContent {
		String field0 = null;
		String field1 = null;
		String field2 = null;
		String field3 = null;
		String field4 = null;
		
		public PiReportContent(String field0, String field1, String field2, String field3, String field4) {
			this.field0 = field0;
			this.field1 = field1;
			this.field2 = field2;
			this.field3 = field3;
			this.field4 = field4;
		}
		
	    @Override
	    public boolean equals(Object o) {
	        // If the object is compared with itself then return true 
	        if (o == this) {
	            return true;
	        }
	 
	        /* Check if o is an instance of Complex or not
	          "null instanceof [type]" also returns false */
	        if (!(o instanceof PiReportContent)) {
	            return false;
	        }
	         
	        // typecast o to Complex so that we can compare data members
	        PiReportContent c = (PiReportContent) o;
	         
	        // Compare the data members and return accordingly
	        return 
	        	((field0 != null && field0.equals(c.field0)) || (field0 == null && c.field0 == null)) &&
	        	((field1 != null && field1.equals(c.field1)) || (field1 == null && c.field1 == null)) &&
	        	((field2 != null && field2.equals(c.field2)) || (field2 == null && c.field2 == null)) &&
	        	((field3 != null && field3.equals(c.field3)) || (field3 == null && c.field3 == null)) &&
	        	((field4 != null && field4.equals(c.field4)) || (field4 == null && c.field4 == null));
	    }
	}
%>
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
String command = parseStrUTF8(request, "command");
String pirPID = parseStrUTF8(request, "pirPID");
boolean createAction = false;
boolean creating = false;
boolean viewAction = false;
boolean viewRptAction = false;
boolean editAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean reopenAction = false;

boolean fuSendAction = false;
boolean fuRejectAction = false;
boolean fuSubmitAction = false;
boolean fuEmailOnlyAction = false;
boolean fuPICloseAction = false;
boolean fuActionInvestigateActionOshIcn = false;
boolean fuActionInvestigateActionPharmacy = false;
boolean fuRedoAction = false;
boolean fuRedoPxAction = false;
boolean fuChgStatusRespPersonAction = false;
boolean fuChgRespPersonAction = false;
boolean fuChgRespPersonActionOSH_ICN = false;
boolean fuChgRespPersonActionPharmacy = false;
boolean fuChgRespPersonActionOthers = false;

boolean closeAccessDeniedAction = false;
boolean closeSessionTimeOutAction = false;
boolean closeAction = false;
boolean fuAddRpt = false;
boolean fuAdmCmt = false;
boolean fuAdmFUCmt = false;
boolean fuFUDHCmt = false;
boolean fuPxCmt = false;
boolean fuFurtherNotice = false;
boolean fuRedoPxDutyManagerAction = false;
boolean fuSubmitPx2PiAction = false;
boolean fuSendActionRequestAction = false;
boolean fuSetReplied = false;
String fuSendActionRequestActionType = null;
boolean fuSendActionRequestReminderAction = false;
boolean fuPostExamForm = false;
boolean fuDHeadAddForm = false;
ReportableListObject row = null;
String pageIndex = null;
String personName = parseStrUTF8(request, "reportPersonName");
String rank = parseStrUTF8(request, "reportPersonRank");
String deptCode = parseStrUTF8(request, "deptCode");
String deptDesc = null;
String deptHead = parseStrUTF8(request, "deptHead");
String deptHeadName = parseStrUTF8(request, "deptHeadName");
//17-05-2017 for twah  deptcode, depthead to follow
String deptCodeflwup = null;
String deptHeadflwup = parseStrUTF8(request, "deptHeadflwup");
String deptHeadNameflwup = null;
//
String dutyMgr = parseStrUTF8(request, "dutyMgr");
String dutyMgrName = null;
String sentinelEvent = parseStrUTF8(request, "sentinel");
String sentinelID = null;
String sentinelDesc = null;
String incident_date = parseStrUTF8(request, "occurDate");
String incident_time_hh = parseStrUTF8(request, "timeOfOccurrence_hh");
String incident_time_mi = parseStrUTF8(request, "timeOfOccurrence_mi");
String incident_place = parseStrUTF8(request, "placeOfOccur");
String incident_place_freetext = parseStrUTF8(request, "placeOfOccur_freetext");
String incident_type = parseStrUTF8(request, "selectedIncidentType");
String incident_type_pi = null;
String patientInfo[] = (String[])request.getAttribute("isPatientInfo_StringArray");
String staffInfo[] = (String[])request.getAttribute("isStaffInfo_StringArray");
String visitorInfo[] = (String[])request.getAttribute("isVisitorInfo_StringArray");
String otherInfo[] = (String[])request.getAttribute("isOtherInfo_StringArray");
String pirID = parseStrUTF8(request, "pirID");
String incident_status = null;
String incident_classification = parseStrUTF8(request, "incidentClass");
String incident_classification_desc = parseStrUTF8(request, "incident_classification_desc");
String incident_classification_desc_pi = null;
String relPirID = parseStrUTF8(request, "relPirID");
String followUp = null;
// followup dialog
ReportableListObject rowRtn = null;
String fuFrom = parseStrUTF8(request, "fuFrom");
String fuTo = parseStrUTF8(request, "fuTo");
String fuCrDate = parseStrUTF8(request, "fuCrDate");
String fuDueDate = parseStrUTF8(request, "fuDueDate");
String fuCompDate = parseStrUTF8(request, "fuCompDate");
String fuAction = parseStrUTF8(request, "fuAction");
String respParty = parseStrUTF8(request, "respparty");
String fupirflwID = null;
String fupirflwpID = null;
String fuaddrptID = null;
String fustaffInfo[] = (String[])request.getAttribute("fuStaffNo_StringArray");
String rptSts = parseStrUTF8(request, "rptsts");
String newRptSts = null;
String[] toStaffID = (String []) request.getAttribute("toStaffID_StringArray");
String chgStatus = parseStrUTF8(request, "ChgStatus");
String chgFrom = parseStrUTF8(request, "ChgFrom");
String chgRespPerson = parseStrUTF8(request, "ChgRespPerson");
String chgRespPersonICN = parseStrUTF8(request, "ChgRespPersonICN");
String chgRespPersonOSH = parseStrUTF8(request, "ChgRespPersonOSH");
String chgRespPersonOthers = null;
String AddRpt = parseStrUTF8(request, "AddRpt");
// dept head add follow up comment
String piDID = parseStrUTF8(request, "pirdid");
String Narrative = parseStrUTF8(request, "narrative");
String Cause = parseStrUTF8(request, "cause");
String ActionDone = parseStrUTF8(request, "actiondone");
String ActionTaken = parseStrUTF8(request, "actiontaken");
String Narrative_followup = parseStrUTF8(request, "narrative_followup");
String Cause_followup = parseStrUTF8(request, "cause_followup");
String ActionDone_followup = parseStrUTF8(request, "actiondone_followup");
String ActionTaken_followup = parseStrUTF8(request, "actiontaken_followup");
String Narrative_UMDM = parseStrUTF8(request, "narrative_umdm");
String Cause_UMDM = parseStrUTF8(request, "cause_umdm");
String ActionDone_UMDM = parseStrUTF8(request, "actiondone_umdm");
String ActionTaken_UMDM = parseStrUTF8(request, "actiontaken_umdm");
String RiskAss = parseStrUTF8(request, "riskass");
String Mon = parseStrUTF8(request, "mon");
String Inv = parseStrUTF8(request, "inv");
String Treat = parseStrUTF8(request, "treat");
String HighCare = parseStrUTF8(request, "highcare");
String MonSpec = parseStrUTF8(request, "monspec");
String InvSpec = parseStrUTF8(request, "invspec");
String TreatSpec = parseStrUTF8(request, "treatspec");
String HighCareSpec = parseStrUTF8(request, "highcarespec");
String PersonFault = parseStrUTF8(request, "personfault");
String InadeTrain = parseStrUTF8(request, "inadetrain");
String NoPrevent = parseStrUTF8(request, "noprevent");
String MachFault = parseStrUTF8(request, "machfault");
String MisUse = parseStrUTF8(request, "misuse");
String InadeInstru = parseStrUTF8(request, "inadeinstru");
String InadeEquip = parseStrUTF8(request, "inadeequip");
String PoorQual = parseStrUTF8(request, "poorqual");
String QualDetect = parseStrUTF8(request, "qualdetect");
String ExpItem = parseStrUTF8(request, "expitem");
String InadeMat = parseStrUTF8(request, "inademat");
String InstNotFollow = parseStrUTF8(request, "instnotfollow");
String MotNature = parseStrUTF8(request, "motnature");
String Noise = parseStrUTF8(request, "noise");
String DistEnv = parseStrUTF8(request, "distenv");
String UnvFloor = parseStrUTF8(request, "unvfloor");
String Slip = parseStrUTF8(request, "slip");
String IM = parseStrUTF8(request, "im");
String Culture = parseStrUTF8(request, "culture");
String Leader = parseStrUTF8(request, "leader");
String Other = parseStrUTF8(request, "other");
String OtherSpec = parseStrUTF8(request, "otherspec");
Boolean IsDHead = false;
Boolean IsAdmin = false;
Boolean IsResponsiblePerson = false;
Boolean IsOshIcn = false;
Boolean IsPharmacy = false;
Boolean IsOshIcnOrPharmacy = false;
Boolean IsPIManager = false;
Boolean IsSubHead = false;
Boolean IsStaffIncident = false;
Boolean IsMedicationIncident = false;
Boolean IsPatientIncident = false;
Boolean IsStaffOrMedicationIncident = false;
Boolean IsActionRequestStaff = true;
Boolean subHead = false; // nurse cases Reporter-->NO-->SNO--->PI
//
String failurecomply = parseStrUTF8(request, "failurecomply");
String samedrug = parseStrUTF8(request, "samedrug");
String inappabb = parseStrUTF8(request, "inappabb");
String ordermis = parseStrUTF8(request, "ordermis");
String lasa = parseStrUTF8(request, "lasa");
String lapses = parseStrUTF8(request, "lapses");
String equipfailure = parseStrUTF8(request, "equipfailure");
String illegalhand = parseStrUTF8(request, "illegalhand");
String miscal = parseStrUTF8(request, "miscal");
String systemflaw = parseStrUTF8(request, "systemflaw");
String Inadtrainstaff = parseStrUTF8(request, "Inadtrainstaff");
String othersfreetext = parseStrUTF8(request, "othersfreetext");
String othersfreetextedit = parseStrUTF8(request, "othersfreetextedit");
String relatedstaff = parseStrUTF8(request, "relatedstaff");
String sharestaff = parseStrUTF8(request, "sharestaff");
String sharestaffdate = parseStrUTF8(request, "sharestaffdate");
String noaffect = parseStrUTF8(request, "noaffect");
String noharm = parseStrUTF8(request, "noharm");
String tempharm = parseStrUTF8(request, "tempharm");
String permharm = parseStrUTF8(request, "permharm");
String death = parseStrUTF8(request, "death");
String contamin = parseStrUTF8(request, "contamin");
String noncontamin = parseStrUTF8(request, "noncontamin");
String bodyfluexp = parseStrUTF8(request, "bodyfluexp");
String adminviewed = parseStrUTF8(request, "adminviewed");
String admincomment = parseStrUTF8(request, "admincomment");
String slDays = parseStrUTF8(request, "slDays");
String labDept = parseStrUTF8(request, "labDept");
String patInv = parseStrUTF8(request, "patInv");
String labDeptRemark = parseStrUTF8(request, "labDeptRemark");
String rptpolice = parseStrUTF8(request, "rptPolice");
String rptiod = parseStrUTF8(request, "rptIod");
// Px Comment
String pirPXID = parseStrUTF8(request, "pirpxid");
Boolean IsPx = false;
String PxRiskAss = parseStrUTF8(request, "pxPxRiskAss");
String HighAlert = parseStrUTF8(request, "HighAlert");
String BeforeWard = parseStrUTF8(request, "BeforeWard");
String BeforeOutpat = parseStrUTF8(request, "BeforeOutpat");
String AfterWardInv = parseStrUTF8(request, "AfterWardInv");
String AfterWardGiven = parseStrUTF8(request, "AfterWardGiven");
String AfterOutpatNottaken = parseStrUTF8(request, "AfterOutpatNottaken");
String AfterOutpatTaken = parseStrUTF8(request, "AfterOutpatTaken");
String BeforeDischarge = parseStrUTF8(request, "BeforeDischarge");
String AfterDischarge = parseStrUTF8(request, "AfterDischarge");
String BeforeAdmin = parseStrUTF8(request, "BeforeAdmin");
String AfterAdmin = parseStrUTF8(request, "AfterAdmin");
String BeforeAdminUnit = parseStrUTF8(request, "BeforeAdminUnit");
String AfterAdminUnit = parseStrUTF8(request, "AfterAdminUnit");
String causeReaction = parseStrUTF8(request, "causeReaction");
// redo
String redoReason = parseStrUTF8(request, "redoreason");
// Notify Email
String emailFromList = null;
String emailToList = null;
//
String actionRequest = parseStrUTF8(request, "actionRequest");
String compDate = parseStrUTF8(request, "compDate");
String requestContent = parseStrUTF8(request, "requestContent");
String autoReminder = parseStrUTF8(request, "autoReminder");
String actionrequeststaff = parseStrUTF8(request, "actionrequeststaff");
//
String piAssInjury = null;
// for checking action request staff
String pirPIID = null;
// px submit medication and adr
String deptHeadTemp = null;
String dutyMgrTemp = null;
String pxdeptHead = parseStrUTF8(request, "pxdeptHead");
String pxdutyMgr = parseStrUTF8(request, "pxdutyMgr");
String pxNurse = parseStrUTF8(request, "pxNurse");
String pxNurseName = null;
//near miss incident
String nearMiss = parseStrUTF8(request, "nearMiss");
boolean pxcreateAction = false;
boolean pxupdateAction = false;
Boolean IsPharmacyStaff = false;
Boolean IsNursingStaff = false;
boolean createActionSaveOnly = false;
boolean updateActionSaveOnly = false;
boolean CanEditReport = false;
boolean fuPIClass = false;
String piNearMiss = parseStrUTF8(request, "pinearmiss");
String piClass = parseStrUTF8(request, "piclass");
String inOutPatient = parseStrUTF8(request, "inoutpat");
String outcome = parseStrUTF8(request, "outcome");
String hazardousCondition = parseStrUTF8(request, "hazardousCondition");
String piRemarks = parseStrUTF8(request, "piRemarks");
//checkbox for follow up action
String staffedu = parseStrUTF8(request, "staffedu");
String staffedutext = parseStrUTF8(request, "staffedutext");
String staffdisc = parseStrUTF8(request, "staffdisc");
String staffdisctext = parseStrUTF8(request, "staffdisctext");
String cons = parseStrUTF8(request, "cons");
String constext = parseStrUTF8(request, "constext");
String shar = parseStrUTF8(request, "shar");
String shartext1 = parseStrUTF8(request, "shartext1");
String shartext2 = parseStrUTF8(request, "shartext2");
String revpol = parseStrUTF8(request, "revpol");
String revpoltext = parseStrUTF8(request, "revpoltext");
String revform = parseStrUTF8(request, "revform");
String revformtext = parseStrUTF8(request, "revformtext");
String creform = parseStrUTF8(request, "creform");
String creformtext = parseStrUTF8(request, "creformtext");
String refer = parseStrUTF8(request, "refer");
String refertext = parseStrUTF8(request, "refertext");
String referdepttext = parseStrUTF8(request, "referdepttext");
String others = parseStrUTF8(request, "others");
Boolean IsNeverSubmitted = false;
String staffNOUM = null;
// 17092018 all inc type use px flow
Boolean IsPxIncident = null;

System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [pi] pirID="+pirID+", command="+command+", userBean.getStaffID()="+userBean.getStaffID());

// check login
if (userBean.isAdmin() || (userBean.isLogin() && userBean.getStaffID() != null)) {
	IsDHead = PiReportDB.IsDHead(userBean.getStaffID());
	IsAdmin = PiReportDB.IsAdminStaff(userBean.getStaffID());
	IsOshIcn = PiReportDB.IsOshIcnPerson(userBean.getStaffID());
	IsPharmacy = PiReportDB.IsSeniorPharmacy(userBean.getStaffID());
	IsPx = PiReportDB.IsPx(userBean.getStaffID());
	IsPharmacyStaff = PiReportDB.IsPharmacyStaff(userBean.getStaffID());
	IsNursingStaff = PiReportDB.IsNursingStaff(userBean.getStaffID());
} else if (command != null && !command.equals("view")){
	closeSessionTimeOutAction = true;
}

if (command != null && (command.equals("create") || command.equals("create_px2") || command.equals("create_saveonly"))) {
	patientInfo = (String[])request.getAttribute("isPatientInfo_StringArray");
	staffInfo = (String[])request.getAttribute("isStaffInfo_StringArray");
	visitorInfo = (String[])request.getAttribute("isVisitorInfo_StringArray");
	otherInfo = (String[])request.getAttribute("isOtherInfo_StringArray");

	// 17052017 depthead for followup  TWAH
	deptCodeflwup = StaffDB.getDeptCode(deptHeadflwup);
	//

	if ("1".equals(sentinelEvent)) {
		sentinelID = parseStrUTF8(request, "sentinelname");
	}
	else {
		sentinelID = "0";
	}
	if (command.equals("create_px2")) {
		pxcreateAction = true;
		if (ConstantsServerSide.isTWAH()) {
			pxdeptHead = parseStrUTF8(request, "deptHeadflwup");
		} else {
			pxdeptHead = parseStrUTF8(request, "deptHead");
		}
		pxdutyMgr = parseStrUTF8(request, "dutyMgr");
		pxNurse = parseStrUTF8(request, "pxNurseMain");
	}

	if (command.equals("create_saveonly")) {
		createActionSaveOnly = true;
	}
	createAction = true;
}
else if (command != null && command.indexOf("view") > -1) {
	pirPIID = parseStrUTF8(request, "pirPIID");
	viewAction = true;
}
else if (command != null && command.indexOf("view_rpt") > -1) {
	viewAction = true;
	viewRptAction = true;
}
else if (command != null && command.equals("edit")) {
	editAction = true;
}
else if (command != null && (command.equals("update") || command.equals("update_saveonly") || command.equals("update_px2"))) {
	// 17052017 depthead for followup  TWAH
	deptCodeflwup = StaffDB.getDeptCode(deptHeadflwup);
	//

	if ("1".equals(sentinelEvent)) {
		sentinelID = parseStrUTF8(request, "sentinelname");
	}
	else {
		sentinelID = "0";
	}
	if (command.equals("update_px2")) {
		pxcreateAction = true;
		pxdeptHead = parseStrUTF8(request, "deptHeadflwup");
		//pxdeptHead = parseStrUTF8(request, "deptHead");
		pxdutyMgr = parseStrUTF8(request, "dutyMgr");
		if (!"".equals(pxdeptHead)) {
			pxupdateAction = true;
		}
	}

	if (command.equals("update_saveonly")) {
		updateActionSaveOnly = true;
	}
	updateAction = true;
}
else if (command != null && command.equals("delete")) {
	deleteAction = true;
}
else if (command != null && command.equals("reopen")) {
	reopenAction = true;
}
// follow up dialog
else if (command != null && command.equals("fu_send")) {
	fuSendAction = true;
}
/*
else if (command != null && command.equals("fu_reject")) {
	fuRejectAction = true;
}
*/
else if (command != null && command.equals("fu_submit")) {
	fuSubmitAction = true;
}
else if (command != null && command.equals("fu_emailOnly")) {
	fuEmailOnlyAction = true;
}
else if (command != null && command.equals("fu_pi_close")) {
	fuPICloseAction = true;
}
else if (command != null && command.equals("fu_accept_investigate_oshicn")) {
	fuActionInvestigateActionOshIcn = true;
}
else if (command != null && command.equals("fu_accept_investigate_pharmacy")) {
	fuActionInvestigateActionPharmacy = true;
}
else if (command != null && (command.equals("fu_redo") || command.equals("fu_redo_px"))) {
	if (command.equals("fu_redo_px")) {
		fuRedoPxAction = true;
	} else {
		fuRedoAction = true;
	}
}
else if (command != null && command.equals("fu_change_status_resp")) {
	fuChgStatusRespPersonAction = true;
}
else if (command != null && command.equals("fu_change_resp_person")) {
	fuChgRespPersonAction = true;
}
else if (command != null && command.equals("fu_change_resp_person_others")) {
	chgRespPersonOthers = parseStrUTF8(request, "ChgRespPersonOthers");
	fuChgRespPersonActionOthers = true;
}
else if (command != null && command.equals("fu_change_resp_person_osh_icn")) {
	fuChgRespPersonActionOSH_ICN = true;
}
else if (command != null && command.equals("fu_change_resp_person_pharmacy")) {
	fuChgRespPersonActionPharmacy = true;
}
else if (command != null && command.equals("fu_addrpt")) {
	fuAddRpt = true;
}
else if (command != null && command.equals("fu_adm_comment")) {
	pageIndex = "dHead";

	fuAdmCmt = true;
}
else if (command != null && command.equals("fu_adm_flwup_comment")) {
	pageIndex = "flwUp";

	fuAdmFUCmt = true;
}
//save both flwup dhead
else if (command != null && (command.equals("fu_save_flwup_dhead_1") || command.equals("fu_save_flwup_dhead_2"))) {
	if (command.equals("fu_save_flwup_dhead_1")) {
		pageIndex = "flwUp";
	} else if (command.equals("fu_save_flwup_dhead_2")) {
		pageIndex = "dHead";
	}

	fuFUDHCmt = true;
}
// end --- save both flwup dhead
else if (command != null && command.equals("fu_px_comment")) {
	fuPxCmt = true;
}
else if (command != null && command.equals("fu_furthernotice")) {
	toStaffID = (String []) request.getAttribute("toFurtherNoticeID_StringArray");
	fuFurtherNotice = true;
}
else if (command != null && command.equals("fu_redo_px_dutymanager")) {
	fuRedoPxDutyManagerAction = true;
}
else if (command != null && command.equals("fu_px2pi_submit")) {
	fuSubmitPx2PiAction = true;
}
else if (command != null && command.equals("fu_action_request_send")) {
	fuSendActionRequestActionType = "PI";
	fuSendActionRequestAction = true;
}
else if (command != null && command.equals("fu_action_request_send_sno")) {
	fuSendActionRequestActionType = "SNO";
	fuSendActionRequestAction = true;
}
else if (command != null && command.equals("fu_action_request_reminder")) {
	fuSendActionRequestReminderAction = true;
}
else if (command != null && command.equals("fu_post_exam_form")) {
	piAssInjury = parseStrUTF8(request, "assinjury");

	pageIndex = "dHead";

	fuPostExamForm = true;
}
else if (command != null && command.equals("fu_dhead_add_form")) {
	pageIndex = "dHead";

	fuDHeadAddForm = true;
}
else if (command != null && command.equals("fu_pi_class")) {
	pageIndex = "dHead";

	fuPIClass = true;
}
else if (command != null && command.equals("fu_reject")) {
	pageIndex = "dHead";

	fuRejectAction = true;
}
else if (command != null && command.equals("set_noreply")) {
	fuSetReplied = true;
}
else {
	incident_date = DateTimeUtil.getCurrentDateTime().substring(0, 10);
	sentinelEvent = "0";
	sentinelID = "0";
	nearMiss = "0";
	hazardousCondition = "0";
	creating = true;
}

IsPx = false; // modification for not using Px tab

if (incident_classification == null && pirID != null) {
	incident_classification = PiReportDB.getIncidentType(pirID);
}

IsStaffIncident = PiReportDB.IsStaffIncident(incident_classification);
IsMedicationIncident = PiReportDB.IsMedicationIncident(incident_classification);
IsPatientIncident = PiReportDB.IsPatientIncident(incident_classification);

if (pirID != null) {
	if (ConstantsServerSide.isTWAH() && !IsStaffIncident) { // check if visitor inj but has BBF (option_id 1600)
		IsStaffIncident = PiReportDB.IsVisitorBBF(pirID);
	}
	IsNeverSubmitted = PiReportDB.IsNeverSubmitted(pirID);
	//18092018 all inc type use px flow
	IsPxIncident = PiReportDB.IsPxIncident(pirID);
	if (userBean != null && userBean.getStaffID() != null) {
		//check ActionRequest Staff first or cc email staff (twah), u100, u200, u300, U3NW
		if (pirPIID != null) {
			IsActionRequestStaff = PiReportDB.IsActionRequestStaff(userBean.getStaffID(), pirID, pirPIID);
		}
		IsResponsiblePerson = PiReportDB.IsRespondsiblePerson(pirID, userBean.getStaffID());
		IsPIManager = PiReportDB.IsPIManager(userBean.getStaffID());
		IsSubHead = PiReportDB.IsSubHead(userBean.getStaffID(), pirID);
		CanEditReport = PiReportDB.CanEditReport(pirID, userBean.getStaffID());
	}
}

String message = null;
String errorMessage = null;

if (command != null && !command.equals("create") && !command.equals("create_px2") && !command.equals("create_saveonly")) {
	//for new tab
	if (pirID != null) {
		ArrayList recordRtn = PiReportDB.fetchReportBasicInfo(pirID);
		if (recordRtn.size() > 0) {
			rowRtn = (ReportableListObject) recordRtn.get(0);
			rptSts = rowRtn.getValue(9);
			staffNOUM = rowRtn.getValue(33);
		}
	}
	closeAccessDeniedAction = false;
}

if (pirID != null && PiReportDB.getRptDeptCode(pirID) == null) {
	subHead = PiReportDB.IsSubHeadCase(userBean.getDeptCode());
}
else if (staffNOUM != null) {
	subHead = PiReportDB.IsSubHeadCase(PiReportDB.getStaffDeptCode(staffNOUM));
}

if (PxRiskAss == null && pirID != null) {
	ArrayList record3 = PiReportDB.fetchReportPxComment(pirID);
	if (record3.size() > 0) {
		row = (ReportableListObject) record3.get(0);
		PxRiskAss = row.getValue(2);
	}
}

// check if not rptsts = 0 and not the reporter
if (command != null && command.equals("edit") && (!"0".equals(rptSts) || !CanEditReport)) {
	closeAccessDeniedAction = true;
} else if (pirID != null && !PiReportDB.IsAllowIncidentClass(userBean, pirID)) {
	closeAccessDeniedAction = true;
} else if ((!IsResponsiblePerson && !IsDHead && !IsActionRequestStaff) && pirID != null && (!"7".equals(rptSts) || !"8".equals(rptSts))
		&& !IsPIManager && !IsOshIcn && !IsPharmacy && !IsAdmin && !"5".equals(rptSts)
		&& !PiReportDB.IsCanEditPerson(pirID, userBean.getStaffID(), rptSts)) {
	closeAccessDeniedAction = true;
}

if (command != null && !closeSessionTimeOutAction) {
	if (fuSendAction) {
		String[] respParties = PiReportDB.fetchReportFlwUpDialogRespondPerson(pirID);
		if (respParties != null && respParties.length > 0) {
			respParty = respParties[0];
		}

		if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Message", fuCrDate, userBean.getStaffID(), fuDueDate, fuCompDate, fuAction, respParty, dutyMgr, rptSts)) != null) {
			message = "Follow up message sent sucessfully.";

			// file upload
			if (fileUpload) {
				String[] fileList = (String[]) request.getAttribute("filelist");
				AttachmentUpload(userBean, fileList, fupirflwID);
			}
			// save follow up person
			String currentInfo[] = new String[99];
			if (toStaffID != null) {
				for (int i = 0; i < toStaffID.length; i++) {
					toStaffID[i] = TextUtil.parseStrUTF8(toStaffID[i]);
					//currentInfo = splitInfo(toStaffID[i]);
					if (!toStaffID[0].isEmpty()) {
						if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, toStaffID[i])) != null) {
							message = "Follow up person message sent sucessfully.";
						}
						else {
							errorMessage = "Follow up person message sent failure.";
						}
					}
				}

				// Send the followup msg
				PiReportDB.SendFlwupMsg(userBean, "Message", incident_classification_desc, pirID, fupirflwID, "");
			}
			else {
				errorMessage = "Follow up message sent failure.";

			}
		}

		fuSendAction = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	/*
	else if (fuRejectAction) {
		rptSts = "6";

		String[] respParties = PiReportDB.fetchReportFlwUpDialogRespondPerson(pirID);
		if (respParties != null && respParties.length > 0) {
			respParty = respParties[0];
		}

		if (PiReportDB.updatePIReportStatus(userBean, pirID, "5")) {
			if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Rejected", fuCrDate, userBean.getStaffID(), fuDueDate, fuCompDate, fuAction, respParty, dutyMgr, rptSts)) != null) {
				message = "Rejected message sent sucessfully.";

				// file upload
				if (fileUpload) {
					String[] fileList = (String[]) request.getAttribute("filelist");
					AttachmentUpload(userBean, fileList, fupirflwID);
				}


				// save follow up person
				String currentInfo[] = new String[99];
				if (toStaffID != null) {
					for (int i = 0; i < toStaffID.length; i++) {
						toStaffID[i] = TextUtil.parseStrUTF8(toStaffID[i]);
						//currentInfo = splitInfo(fustaffInfo[i]);
						if (!toStaffID[i].isEmpty()) {
							if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, toStaffID[i])) != null) {
								message = "Rejected person message sent sucessfully.";
							}
							else {
								errorMessage = "Rejected person message sent failure.";
							}
						}
					}
				// Send the followup msg
				PiReportDB.SendFlwupMsg(userBean, "Rejected", incident_classification_desc, pirID, fupirflwID, "");
				}
				else {
					errorMessage = "Rejected message sent failure.";
				}
			}
		}
		fuRejectAction = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	*/
	else if (fuSubmitAction) {
		// get next status
		newRptSts = PiReportDB.getNextStatus(userBean, pirID, rptSts, command);
		if ("14".equals(newRptSts)) {
			rptSts = newRptSts;
		}

		if (IsOshIcn || IsPharmacy) {
			IsOshIcnOrPharmacy = true;
		}
		if (IsStaffIncident || IsMedicationIncident) {
			IsStaffOrMedicationIncident = true;
		}

		PiReportDB.updateDheadComment(userBean, pirID, piDID, "fuAdmCmt", rptSts, IsStaffOrMedicationIncident, IsOshIcnOrPharmacy,
			Narrative, Cause, ActionDone, ActionTaken,
			Narrative_followup, Cause_followup, ActionDone_followup, ActionTaken_followup,
			Narrative_UMDM, Cause_UMDM, ActionDone_UMDM, ActionTaken_UMDM,
			RiskAss, Mon,  Inv,  Treat,  HighCare,  MonSpec,  InvSpec,
			TreatSpec,  HighCareSpec,  PersonFault,  InadeTrain,
			NoPrevent,  MachFault,  MisUse,  InadeInstru,  InadeEquip,
			PoorQual,  QualDetect,  ExpItem,  InadeMat,  InstNotFollow,
			MotNature,  Noise,  DistEnv,  UnvFloor,  Slip,
			IM,  Culture,  Leader,  Other,  OtherSpec,
			failurecomply,
			samedrug, inappabb, ordermis, lasa, lapses,
			equipfailure, illegalhand, miscal, systemflaw, Inadtrainstaff,
			othersfreetext, othersfreetextedit, relatedstaff, sharestaff, sharestaffdate,
			noaffect, noharm, tempharm, permharm, death,
			contamin, noncontamin, bodyfluexp, adminviewed, admincomment,
			staffedu,  staffedutext,  staffdisc,  staffdisctext,
			cons,  constext,  shar,  shartext1,  shartext2,
			revpol,  revform,  creform,  refer,  refertext,  referdepttext,
			others, slDays, labDept, patInv, labDeptRemark, rptpolice, rptiod
		);

		if (PiReportDB.IsMedicationIncident(incident_classification_desc)) {
			PiReportDB.updatePxComment(userBean, pirID, pirPXID,
				PxRiskAss,
				HighAlert, BeforeWard, BeforeOutpat, AfterWardInv,
				AfterWardGiven, AfterOutpatNottaken, AfterOutpatTaken, BeforeDischarge,
				AfterDischarge, BeforeAdmin, AfterAdmin, BeforeAdminUnit,
				AfterAdminUnit, causeReaction
			);
		}
		// END --- save dHead.jsp fields to DB

		PiReportDB.updateDheadComment(userBean, pirID, piDID, "fuAdmFUCmt", rptSts, IsStaffOrMedicationIncident, IsOshIcnOrPharmacy,
			Narrative, Cause, ActionDone, ActionTaken,
			Narrative_followup, Cause_followup, ActionDone_followup, ActionTaken_followup,
			Narrative_UMDM, Cause_UMDM, ActionDone_UMDM, ActionTaken_UMDM,
			RiskAss, Mon,  Inv,  Treat,  HighCare,  MonSpec,  InvSpec,
			TreatSpec,  HighCareSpec,  PersonFault,  InadeTrain,
			NoPrevent,  MachFault,  MisUse,  InadeInstru,  InadeEquip,
			PoorQual,  QualDetect,  ExpItem,  InadeMat,  InstNotFollow,
			MotNature,  Noise,  DistEnv,  UnvFloor,  Slip,
			IM,  Culture,  Leader,  Other,  OtherSpec,
			failurecomply,
			samedrug, inappabb, ordermis, lasa, lapses,
			equipfailure, illegalhand, miscal, systemflaw, Inadtrainstaff,
			othersfreetext, othersfreetextedit, relatedstaff, sharestaff, sharestaffdate,
			noaffect, noharm, tempharm, permharm, death,
			contamin, noncontamin, bodyfluexp, adminviewed, admincomment,
			staffedu,  staffedutext,  staffdisc,  staffdisctext,
			cons,  constext,  shar,  shartext1,  shartext2,
			revpol,  revform,  creform,  refer,  refertext,  referdepttext,
			others, slDays, labDept, patInv, labDeptRemark, rptpolice, rptiod
		);

		// END -- save flwUp.jsp fields to DB

		deptHead = PiReportDB.GetNextRespPerson(userBean, pirID, newRptSts, incident_classification_desc);

		if (PiReportDB.updatePIReportStatus(userBean, pirID, newRptSts)) {
			if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Submit", fuCrDate, userBean.getStaffID(), fuDueDate, fuCompDate, fuAction, deptHead, dutyMgr, newRptSts)) != null) {
				message = "Submit message sent sucessfully.";

				// file upload
				if (fileUpload) {
					String[] fileList = (String[]) request.getAttribute("filelist");
					AttachmentUpload(userBean, fileList, fupirflwID);
				}

				// save follow up person
				if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, "")) != null) {
					message = "Submit person message sent sucessfully.";
				}
				else {
					errorMessage = "Submit person message sent failure.";
				}
				// Send the follow up msg
				PiReportDB.SendFlwupMsg(userBean, "Submit", incident_classification_desc, pirID, fupirflwID, "");
			}
		}

		emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());
		emailToList = StaffDB.getStaffEmail(deptHead);

		// submit email
		PiReportDB.sendEmailSubmit(userBean, incident_classification, pirID, "Submit", emailFromList, emailToList);

		fuSubmitAction = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = true;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuEmailOnlyAction) {
		if (pirID != null) {
			ArrayList recordRtn = PiReportDB.fetchReportBasicInfo(pirID);
			if (recordRtn.size() > 0) {
				rowRtn = (ReportableListObject) recordRtn.get(0);
				rptSts = rowRtn.getValue(9);
				incident_classification = rowRtn.getValue(10);

				deptHead = PiReportDB.GetNextRespPerson(userBean, pirID, rptSts, incident_classification);

				emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());
				emailToList = StaffDB.getStaffEmail(deptHead);

				// submit email
				PiReportDB.sendEmailSubmit(userBean, incident_classification, pirID, "Submit", emailFromList, emailToList);
			}
		}

		fuEmailOnlyAction = false;
		closeAction = true;
	}
	else if (fuPICloseAction) {
		// set "closed" status
		rptSts = "5";

		String[] respParties = PiReportDB.fetchReportFlwUpDialogRespondPerson(pirID);
		if (respParties != null && respParties.length > 0) {
			respParty = respParties[0];
		}

		//deptHead = PiReportDB.GetNextRespPerson(rptSts);
		deptHead = "";

		if (PiReportDB.updatePIReportStatus(userBean, pirID, rptSts)) {
			if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Submit", fuCrDate, userBean.getStaffID(), fuDueDate, fuCompDate, fuAction, "", dutyMgr, rptSts)) != null) {
				message = "Submit message sent sucessfully.";

				// file upload
				if (fileUpload) {
					String[] fileList = (String[]) request.getAttribute("filelist");
					AttachmentUpload(userBean, fileList, fupirflwID);
				}

				if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, "")) != null) {
					message = "Submit person message sent sucessfully.";
				}
				else {
					errorMessage = "Submit person message sent failure.";
				}
				// Send the followup msg
				PiReportDB.SendFlwupMsg(userBean, "Submit", incident_classification_desc, pirID, fupirflwID, "");
			}
		}

		//PiReportDB.sendEmailClose(userBean, incident_classification, pirID, "Close");

		fuPICloseAction = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = true;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuActionInvestigateActionOshIcn) {
		rptSts = "1";
		if (PiReportDB.updatePIReportStatus(userBean, pirID, rptSts)) {
			if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Submit", DateTimeUtil.getCurrentDateTime(), PiReportDB.getSendPerson(pirID, "OshIcn"), fuDueDate, fuCompDate, fuAction, userBean.getStaffID(), "", rptSts)) != null) {
				//message = "Submit message sent sucessfully.";

				if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, deptHead)) != null) {
					//message = "Submit person message sent sucessfully.";
				}
				else {
					//errorMessage = "Submit person message sent failure.";
				}

				// Send the followup msg
				PiReportDB.SendFlwupMsg(userBean, "Submit", incident_classification_desc, pirID, fupirflwID, "");
			}
			else {
				//errorMessage = "Submit message sent failure.";
			}
		}

		//PiReportDB.sendEmailAcceptOshIcn(userBean, incident_classification, pirID, "Accept", emailFromList, PiReportDB.getSendPerson(pirID, "OshIcn"));

		fuActionInvestigateActionOshIcn = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = false;

		pageIndex = "dHead";

		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuActionInvestigateActionPharmacy) {
		rptSts = "1";
		if (PiReportDB.updatePIReportStatus(userBean, pirID, rptSts)) {
			if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Submit", DateTimeUtil.getCurrentDateTime(), PiReportDB.getSendPerson(pirID, "Pharmacy"), fuDueDate, fuCompDate, fuAction, userBean.getStaffID(), "", rptSts)) != null) {
				//message = "Submit message sent sucessfully.";

				if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, deptHead)) != null) {
					//message = "Submit person message sent sucessfully.";
				}
				else {
					//errorMessage = "Submit person message sent failure.";
				}

				// Send the followup msg
				PiReportDB.SendFlwupMsg(userBean, "Submit", incident_classification_desc, pirID, fupirflwID, "");
			}
			else {
				//errorMessage = "Submit message sent failure.";
			}
		}

		PiReportDB.sendEmailAcceptOshIcn(userBean, incident_classification, pirID, "Accept", emailFromList, PiReportDB.getSendPerson(pirID, "Pharmacy"));

		fuActionInvestigateActionPharmacy = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = false;

		pageIndex = "flwUp";

		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuRedoAction || fuRedoPxAction) {
		if ("0".equals(rptSts)) {
			errorMessage = "Submit redo failure.";
			closeAction = true;
		} else {
			String RedoPerson = null;
			String ori_rptSts = rptSts;

			rptSts = PiReportDB.getPreviousStatus(pirID);

			RedoPerson = PiReportDB.getRespondPerson(pirID, rptSts, ori_rptSts);

			if (PiReportDB.updatePIReportStatus(userBean, pirID, rptSts)) {
				if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Redo", fuCrDate, userBean.getStaffID(), fuDueDate, fuCompDate, redoReason, RedoPerson, dutyMgr, rptSts)) != null) {
					message = "Submit message sent sucessfully.";

					if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, deptHead)) != null) {
						message = "Submit person message sent sucessfully.";
					}
					else {
						errorMessage = "Submit person message sent failure.";
					}
					// Send the followup msg
					PiReportDB.SendFlwupMsg(userBean, "Submit", incident_classification_desc, pirID, fupirflwID, "");
				}
			}

			emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());
			emailToList = StaffDB.getStaffEmail(RedoPerson);

			//redo email
			PiReportDB.sendEmailRedo(userBean.getStaffID(), incident_classification, pirID, rptSts, "Redo", emailFromList, emailToList, redoReason);

			fuRedoAction = false;
			updateAction = false;
			viewAction = true;
			command = "view";
			closeAction = true;
			//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
		}
	}
	else if (fuChgStatusRespPersonAction) {
		rptSts = chgStatus;

		if (PiReportDB.updatePIReportStatus(userBean, pirID, rptSts)) {
			if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Submit", fuCrDate, chgFrom, fuDueDate, fuCompDate, fuAction, chgRespPerson, dutyMgr, rptSts)) != null) {
				message = "Submit message sent sucessfully.";

				// file upload
				if (fileUpload) {
					String[] fileList = (String[]) request.getAttribute("filelist");
					AttachmentUpload(userBean, fileList, fupirflwID);
				}
			}
			else {
				errorMessage = "Submit message sent failure.";
			}
		}
		else {
			errorMessage = "Submit message sent failure.";
		}
		fuChgStatusRespPersonAction = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = true;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuChgRespPersonAction) {
		rptSts = "1";

		if (PiReportDB.updatePIReportStatus(userBean, pirID, rptSts)) {
			if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Submit", fuCrDate, userBean.getStaffID(), fuDueDate, fuCompDate, fuAction, chgRespPerson, dutyMgr, rptSts)) != null) {
				message = "Submit message sent sucessfully.";

				// file upload
				if (fileUpload) {
					String[] fileList = (String[]) request.getAttribute("filelist");
					AttachmentUpload(userBean, fileList, fupirflwID);
				}

				// save follow up person
				String currentInfo[] = new String[99];
				if (toStaffID != null) {
					for (int i = 0; i < toStaffID.length; i++) {
						toStaffID[i] = TextUtil.parseStrUTF8(toStaffID[i]);
						//currentInfo = splitInfo(fustaffInfo[i]);
						if (!toStaffID[i].isEmpty()) {
							if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, toStaffID[i])) != null) {
								message = "Submit person message sent sucessfully.";
							}
							else {
								errorMessage = "Submit person message sent failure.";
							}
						}
					}
					// Send the followup msg
					PiReportDB.SendFlwupMsg(userBean, "Submit", incident_classification_desc, pirID, fupirflwID, "");
				}
				else {
					errorMessage = "Submit message sent failure.";
				}
			}
		}
		fuChgRespPersonAction = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = true;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuChgRespPersonActionOthers) {
		rptSts = "10";

		if (PiReportDB.updatePIReportStatus(userBean, pirID, rptSts)) {
			if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Submit", DateTimeUtil.getCurrentDateTime(), userBean.getStaffID(), fuDueDate, fuCompDate, fuAction, chgRespPersonOthers, "", rptSts)) != null) {
				message = "Submit message sent sucessfully.";
				// save follow up person
				if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, deptHead)) != null) {
					message = "Submit person message sent sucessfully.";
				}
				else {
					errorMessage = "Submit person message sent failure.";
				}
			}
			// Send the followup msg
			PiReportDB.SendFlwupMsg(userBean, "Submit", incident_classification_desc, pirID, fupirflwID, "");
		}
		else {
			errorMessage = "Submit message sent failure.";
		}

		fuChgRespPersonActionOthers = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = true;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuChgRespPersonActionOSH_ICN) {
		// save dHead.jsp fields to DB
		if (IsOshIcn || IsPharmacy) {
			IsOshIcnOrPharmacy = true;
		}
		if (IsStaffIncident || IsMedicationIncident) {
			IsStaffOrMedicationIncident = true;
		}

		PiReportDB.updateDheadComment(userBean, pirID, piDID, "fuAdmCmt", rptSts, IsStaffOrMedicationIncident, IsOshIcnOrPharmacy,
			Narrative, Cause, ActionDone, ActionTaken,
			Narrative_followup, Cause_followup, ActionDone_followup, ActionTaken_followup,
			Narrative_UMDM, Cause_UMDM, ActionDone_UMDM, ActionTaken_UMDM,
			RiskAss, Mon,  Inv,  Treat,  HighCare,  MonSpec,  InvSpec,
			TreatSpec,  HighCareSpec,  PersonFault,  InadeTrain,
			NoPrevent,  MachFault,  MisUse,  InadeInstru,  InadeEquip,
			PoorQual,  QualDetect,  ExpItem,  InadeMat,  InstNotFollow,
			MotNature,  Noise,  DistEnv,  UnvFloor,  Slip,
			IM,  Culture,  Leader,  Other,  OtherSpec,
			failurecomply,
			samedrug, inappabb, ordermis, lasa, lapses,
			equipfailure, illegalhand, miscal, systemflaw, Inadtrainstaff,
			othersfreetext, othersfreetextedit, relatedstaff, sharestaff, sharestaffdate,
			noaffect, noharm, tempharm, permharm, death,
			contamin, noncontamin, bodyfluexp, adminviewed, admincomment,
			staffedu,  staffedutext,  staffdisc,  staffdisctext,
			cons,  constext,  shar,  shartext1,  shartext2,
			revpol,  revform,  creform,  refer,  refertext,  referdepttext,
			others, slDays, labDept, patInv, labDeptRemark, rptpolice, rptiod
		);

		if (PiReportDB.IsMedicationIncident(incident_classification_desc)) {
			PiReportDB.updatePxComment(userBean, pirID, pirPXID,
				PxRiskAss,
				HighAlert, BeforeWard, BeforeOutpat, AfterWardInv,
				AfterWardGiven, AfterOutpatNottaken, AfterOutpatTaken, BeforeDischarge,
				AfterDischarge, BeforeAdmin, AfterAdmin, BeforeAdminUnit,
				AfterAdminUnit, causeReaction
			);
		}
		// END --- save dHead.jsp fields to DB

		// save flwUp.jsp fields to DB
		if (IsOshIcn || IsPharmacy) {
			IsOshIcnOrPharmacy = true;
		}
		if (IsStaffIncident || IsMedicationIncident) {
			IsStaffOrMedicationIncident = true;
		}

		PiReportDB.updateDheadComment(userBean, pirID, piDID, "fuAdmFUCmt", rptSts, IsStaffOrMedicationIncident, IsOshIcnOrPharmacy,
			Narrative, Cause, ActionDone, ActionTaken,
			Narrative_followup, Cause_followup, ActionDone_followup, ActionTaken_followup,
			Narrative_UMDM, Cause_UMDM, ActionDone_UMDM, ActionTaken_UMDM,
			RiskAss, Mon,  Inv,  Treat,  HighCare,  MonSpec,  InvSpec,
			TreatSpec,  HighCareSpec,  PersonFault,  InadeTrain,
			NoPrevent,  MachFault,  MisUse,  InadeInstru,  InadeEquip,
			PoorQual,  QualDetect,  ExpItem,  InadeMat,  InstNotFollow,
			MotNature,  Noise,  DistEnv,  UnvFloor,  Slip,
			IM,  Culture,  Leader,  Other,  OtherSpec,
			failurecomply,
			samedrug, inappabb, ordermis, lasa, lapses,
			equipfailure, illegalhand, miscal, systemflaw, Inadtrainstaff,
			othersfreetext, othersfreetextedit, relatedstaff, sharestaff, sharestaffdate,
			noaffect, noharm, tempharm, permharm, death,
			contamin, noncontamin, bodyfluexp, adminviewed, admincomment,
			staffedu,  staffedutext,  staffdisc,  staffdisctext,
			cons,  constext,  shar,  shartext1,  shartext2,
			revpol,  revform,  creform,  refer,  refertext,  referdepttext,
			others, slDays, labDept, patInv, labDeptRemark, rptpolice, rptiod
		);
		// END -- save flwUp.jsp fields to DB

		rptSts = "7";
//		rptSts = "19";  // no/um--->SNO

		if (PiReportDB.updatePIReportStatus(userBean, pirID, rptSts)) {
			if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Submit", DateTimeUtil.getCurrentDateTime(), userBean.getStaffID(), fuDueDate, fuCompDate, fuAction, chgRespPersonOSH, chgRespPersonICN, rptSts)) != null) {
				message = "Submit message sent sucessfully.";
				// save follow up person
				if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, deptHead)) != null) {
					message = "Submit person message sent sucessfully.";
				}
				else {
					errorMessage = "Submit person message sent failure.";
				}
			}
			// Send the followup msg
			PiReportDB.SendFlwupMsg(userBean, "Submit", incident_classification_desc, pirID, fupirflwID, "");
		}
		else {
			errorMessage = "Submit message sent failure.";
		}

		emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());

		// 0509
		ArrayList flwUpDialogreportDtl = null;
		// only icn/osh for sharp injury, other is osh
		if (ConstantsServerSide.isTWAH() || "7".equals(incident_classification_desc)) {
			flwUpDialogreportDtl = PiReportDB.fetchReportSentinelEventAllPerson(userBean, "oshicn");
		} else {
			flwUpDialogreportDtl = PiReportDB.fetchReportSentinelEventAllPerson(userBean, "osh");
		}
		for (int j = 0; j < flwUpDialogreportDtl.size(); j++) {
			row = (ReportableListObject) flwUpDialogreportDtl.get(j);
			if (flwUpDialogreportDtl.size() > 0) {
				PiReportDB.sendEmailReferOshIcnPharmacy(userBean, incident_classification, pirID, "Refer", emailFromList, row.getValue(2), "");
			}
		}
		//PiReportDB.sendEmailReferOshIcnPharmacy(userBean, incident_classification, pirID, "Refer", emailFromList, StaffDB.getStaffEmail("4898"), StaffDB.getStaffEmail("4112"));

		fuChgRespPersonActionOSH_ICN = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = true;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuChgRespPersonActionPharmacy) {

		// save dHead.jsp fields to DB
		if (IsOshIcn || IsPharmacy) {
			IsOshIcnOrPharmacy = true;
		}
		if (IsStaffIncident || IsMedicationIncident) {
			IsStaffOrMedicationIncident = true;
		}

		PiReportDB.updateDheadComment(userBean, pirID, piDID, "fuAdmCmt", rptSts, IsStaffOrMedicationIncident, IsOshIcnOrPharmacy,
			Narrative, Cause, ActionDone, ActionTaken,
			Narrative_followup, Cause_followup, ActionDone_followup, ActionTaken_followup,
			Narrative_UMDM, Cause_UMDM, ActionDone_UMDM, ActionTaken_UMDM,
			RiskAss, Mon,  Inv,  Treat,  HighCare,  MonSpec,  InvSpec,
			TreatSpec,  HighCareSpec,  PersonFault,  InadeTrain,
			NoPrevent,  MachFault,  MisUse,  InadeInstru,  InadeEquip,
			PoorQual,  QualDetect,  ExpItem,  InadeMat,  InstNotFollow,
			MotNature,  Noise,  DistEnv,  UnvFloor,  Slip,
			IM,  Culture,  Leader,  Other,  OtherSpec,
			failurecomply,
			samedrug, inappabb, ordermis, lasa, lapses,
			equipfailure, illegalhand, miscal, systemflaw, Inadtrainstaff,
			othersfreetext, othersfreetextedit, relatedstaff, sharestaff, sharestaffdate,
			noaffect, noharm, tempharm, permharm, death,
			contamin, noncontamin, bodyfluexp, adminviewed, admincomment,
			staffedu,  staffedutext,  staffdisc,  staffdisctext,
			cons,  constext,  shar,  shartext1,  shartext2,
			revpol,  revform,  creform,  refer,  refertext,  referdepttext,
			others, slDays, labDept, patInv, labDeptRemark, rptpolice, rptiod
		);

		if (PiReportDB.IsMedicationIncident(incident_classification_desc)) {
			PiReportDB.updatePxComment(userBean, pirID, pirPXID,
				PxRiskAss,
				HighAlert, BeforeWard, BeforeOutpat, AfterWardInv,
				AfterWardGiven, AfterOutpatNottaken, AfterOutpatTaken, BeforeDischarge,
				AfterDischarge, BeforeAdmin, AfterAdmin, BeforeAdminUnit,
				AfterAdminUnit, causeReaction
			);
		}
		// END --- save dHead.jsp fields to DB

		// save flwUp.jsp fields to DB
		if (IsOshIcn || IsPharmacy) {
			IsOshIcnOrPharmacy = true;
		}
		if (IsStaffIncident || IsMedicationIncident) {
			IsStaffOrMedicationIncident = true;
		}

		PiReportDB.updateDheadComment(userBean, pirID, piDID, "fuAdmFUCmt", rptSts, IsStaffOrMedicationIncident, IsOshIcnOrPharmacy,
			Narrative, Cause, ActionDone, ActionTaken,
			Narrative_followup, Cause_followup, ActionDone_followup, ActionTaken_followup,
			Narrative_UMDM, Cause_UMDM, ActionDone_UMDM, ActionTaken_UMDM,
			RiskAss, Mon,  Inv,  Treat,  HighCare,  MonSpec,  InvSpec,
			TreatSpec,  HighCareSpec,  PersonFault,  InadeTrain,
			NoPrevent,  MachFault,  MisUse,  InadeInstru,  InadeEquip,
			PoorQual,  QualDetect,  ExpItem,  InadeMat,  InstNotFollow,
			MotNature,  Noise,  DistEnv,  UnvFloor,  Slip,
			IM,  Culture,  Leader,  Other,  OtherSpec,
			failurecomply,
			samedrug, inappabb, ordermis, lasa, lapses,
			equipfailure, illegalhand, miscal, systemflaw, Inadtrainstaff,
			othersfreetext, othersfreetextedit, relatedstaff, sharestaff, sharestaffdate,
			noaffect, noharm, tempharm, permharm, death,
			contamin, noncontamin, bodyfluexp, adminviewed, admincomment,
			staffedu,  staffedutext,  staffdisc,  staffdisctext,
			cons,  constext,  shar,  shartext1,  shartext2,
			revpol,  revform,  creform,  refer,  refertext,  referdepttext,
			others, slDays, labDept, patInv, labDeptRemark, rptpolice, rptiod
		);
		// END -- save flwUp.jsp fields to DB

		rptSts = "8";

		if (PiReportDB.updatePIReportStatus(userBean, pirID, rptSts)) {
			if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Submit", DateTimeUtil.getCurrentDateTime(), userBean.getStaffID(), fuDueDate, fuCompDate, fuAction, chgRespPersonOSH, chgRespPersonICN, rptSts)) != null) {
				message = "Submit message sent sucessfully.";
				// save follow up person
				if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, deptHead)) != null) {
					message = "Submit person message sent sucessfully.";
				}
				else {
					errorMessage = "Submit person message sent failure.";
				}
			}
			// Send the followup msg
			PiReportDB.SendFlwupMsg(userBean, "Submit", incident_classification_desc, pirID, fupirflwID, "");
		}
		else {
			errorMessage = "Submit message sent failure.";
		}

		emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());
		ArrayList flwUpDialogreportDtl = PiReportDB.fetchReportSentinelEventAllPerson(userBean, "pharmacy");
		for (int j = 0; j < flwUpDialogreportDtl.size(); j++) {
			row = (ReportableListObject) flwUpDialogreportDtl.get(j);
			if (flwUpDialogreportDtl.size() > 0) {
				PiReportDB.sendEmailReferOshIcnPharmacy(userBean, incident_classification, pirID, "Refer", emailFromList, row.getValue(2), "");
			}
		}
		fuChgRespPersonActionPharmacy = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = true;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuAddRpt) {

		//fuaddrptID
//		if ((fupirflwID = PiReportDB.addFlwUpAddRpt(userBean, pirID, userBean.getStaffID(), userBean.getDeptCode(), userBean.getDeptDesc(), AddRpt)) != null) {

//		}

		fuAddRpt = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuAdmCmt) {
		if (IsOshIcn || IsPharmacy) {
			IsOshIcnOrPharmacy = true;
		}
		if (IsStaffIncident || IsMedicationIncident) {
			IsStaffOrMedicationIncident = true;
		}

		PiReportDB.updateDheadComment(userBean, pirID, piDID, "fuAdmCmt", rptSts, IsStaffOrMedicationIncident, IsOshIcnOrPharmacy,
			Narrative, Cause, ActionDone, ActionTaken,
			Narrative_followup, Cause_followup, ActionDone_followup, ActionTaken_followup,
			Narrative_UMDM, Cause_UMDM, ActionDone_UMDM, ActionTaken_UMDM,
			RiskAss, Mon,  Inv,  Treat,  HighCare,  MonSpec,  InvSpec,
			TreatSpec,  HighCareSpec,  PersonFault,  InadeTrain,
			NoPrevent,  MachFault,  MisUse,  InadeInstru,  InadeEquip,
			PoorQual,  QualDetect,  ExpItem,  InadeMat,  InstNotFollow,
			MotNature,  Noise,  DistEnv,  UnvFloor,  Slip,
			IM,  Culture,  Leader,  Other,  OtherSpec,
			failurecomply,
			samedrug, inappabb, ordermis, lasa, lapses,
			equipfailure, illegalhand, miscal, systemflaw, Inadtrainstaff,
			othersfreetext, othersfreetextedit, relatedstaff, sharestaff, sharestaffdate,
			noaffect, noharm, tempharm, permharm, death,
			contamin, noncontamin, bodyfluexp, adminviewed, admincomment,
			staffedu,  staffedutext,  staffdisc,  staffdisctext,
			cons,  constext,  shar,  shartext1,  shartext2,
			revpol,  revform,  creform,  refer,  refertext,  referdepttext,
			others, slDays, labDept, patInv, labDeptRemark, rptpolice, rptiod
		);

		if (PiReportDB.IsMedicationIncident(incident_classification_desc)) {
			PiReportDB.updatePxComment(userBean, pirID, pirPXID,
				PxRiskAss,
				HighAlert, BeforeWard, BeforeOutpat, AfterWardInv,
				AfterWardGiven, AfterOutpatNottaken, AfterOutpatTaken, BeforeDischarge,
				AfterDischarge, BeforeAdmin, AfterAdmin, BeforeAdminUnit,
				AfterAdminUnit, causeReaction
			);
		}

		fuAdmCmt = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		// temp  view_rpt

		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuAdmFUCmt) {
		if (IsOshIcn || IsPharmacy) {
			IsOshIcnOrPharmacy = true;
		}
		if (IsStaffIncident || IsMedicationIncident) {
			IsStaffOrMedicationIncident = true;
		}

		PiReportDB.updateDheadComment(userBean, pirID, piDID, "fuAdmFUCmt", rptSts, IsStaffOrMedicationIncident, IsOshIcnOrPharmacy,
			Narrative, Cause, ActionDone, ActionTaken,
			Narrative_followup, Cause_followup, ActionDone_followup, ActionTaken_followup,
			Narrative_UMDM, Cause_UMDM, ActionDone_UMDM, ActionTaken_UMDM,
			RiskAss, Mon,  Inv,  Treat,  HighCare,  MonSpec,  InvSpec,
			TreatSpec,  HighCareSpec,  PersonFault,  InadeTrain,
			NoPrevent,  MachFault,  MisUse,  InadeInstru,  InadeEquip,
			PoorQual,  QualDetect,  ExpItem,  InadeMat,  InstNotFollow,
			MotNature,  Noise,  DistEnv,  UnvFloor,  Slip,
			IM,  Culture,  Leader,  Other,  OtherSpec,
			failurecomply,
			samedrug, inappabb, ordermis, lasa, lapses,
			equipfailure, illegalhand, miscal, systemflaw, Inadtrainstaff,
			othersfreetext, othersfreetextedit, relatedstaff, sharestaff, sharestaffdate,
			noaffect, noharm, tempharm, permharm, death,
			contamin, noncontamin, bodyfluexp, adminviewed, admincomment,
			staffedu,  staffedutext,  staffdisc,  staffdisctext,
			cons,  constext,  shar,  shartext1,  shartext2,
			revpol,  revform,  creform,  refer,  refertext,  referdepttext,
			others, slDays, labDept, patInv, labDeptRemark, rptpolice, rptiod
		);

		fuAdmFUCmt = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		// temp  view_rpt

		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	// save both flwUp and Dhead
	else if (fuFUDHCmt) {
		// dhead page
		if (IsOshIcn || IsPharmacy) {
			IsOshIcnOrPharmacy = true;
		}
		if (IsStaffIncident || IsMedicationIncident) {
			IsStaffOrMedicationIncident = true;
		}

		PiReportDB.updateDheadComment(userBean, pirID, piDID, "fuAdmCmt", rptSts, IsStaffOrMedicationIncident, IsOshIcnOrPharmacy,
			Narrative, Cause, ActionDone, ActionTaken,
			Narrative_followup, Cause_followup, ActionDone_followup, ActionTaken_followup,
			Narrative_UMDM, Cause_UMDM, ActionDone_UMDM, ActionTaken_UMDM,
			RiskAss, Mon,  Inv,  Treat,  HighCare,  MonSpec,  InvSpec,
			TreatSpec,  HighCareSpec,  PersonFault,  InadeTrain,
			NoPrevent,  MachFault,  MisUse,  InadeInstru,  InadeEquip,
			PoorQual,  QualDetect,  ExpItem,  InadeMat,  InstNotFollow,
			MotNature,  Noise,  DistEnv,  UnvFloor,  Slip,
			IM,  Culture,  Leader,  Other,  OtherSpec,
			failurecomply,
			samedrug, inappabb, ordermis, lasa, lapses,
			equipfailure, illegalhand, miscal, systemflaw, Inadtrainstaff,
			othersfreetext, othersfreetextedit, relatedstaff, sharestaff, sharestaffdate,
			noaffect, noharm, tempharm, permharm, death,
			contamin, noncontamin, bodyfluexp, adminviewed, admincomment,
			staffedu,  staffedutext,  staffdisc,  staffdisctext,
			cons,  constext,  shar,  shartext1,  shartext2,
			revpol,  revform,  creform,  refer,  refertext,  referdepttext,
			others, slDays, labDept, patInv, labDeptRemark, rptpolice, rptiod
		);

		if (PiReportDB.IsMedicationIncident(incident_classification_desc)) {
			PiReportDB.updatePxComment(userBean, pirID, pirPXID,
				PxRiskAss,
				HighAlert, BeforeWard, BeforeOutpat, AfterWardInv,
				AfterWardGiven, AfterOutpatNottaken, AfterOutpatTaken, BeforeDischarge,
				AfterDischarge, BeforeAdmin, AfterAdmin, BeforeAdminUnit,
				AfterAdminUnit, causeReaction
			);
		}

		// flwup page
		if (IsOshIcn || IsPharmacy) {
			IsOshIcnOrPharmacy = true;
		}
		if (IsStaffIncident || IsMedicationIncident) {
			IsStaffOrMedicationIncident = true;
		}

		PiReportDB.updateDheadComment(userBean, pirID, piDID, "fuAdmFUCmt", rptSts, IsStaffOrMedicationIncident, IsOshIcnOrPharmacy,
			Narrative, Cause, ActionDone, ActionTaken,
			Narrative_followup, Cause_followup, ActionDone_followup, ActionTaken_followup,
			Narrative_UMDM, Cause_UMDM, ActionDone_UMDM, ActionTaken_UMDM,
			RiskAss, Mon,  Inv,  Treat,  HighCare,  MonSpec,  InvSpec,
			TreatSpec,  HighCareSpec,  PersonFault,  InadeTrain,
			NoPrevent,  MachFault,  MisUse,  InadeInstru,  InadeEquip,
			PoorQual,  QualDetect,  ExpItem,  InadeMat,  InstNotFollow,
			MotNature,  Noise,  DistEnv,  UnvFloor,  Slip,
			IM,  Culture,  Leader,  Other,  OtherSpec,
			failurecomply,
			samedrug, inappabb, ordermis, lasa, lapses,
			equipfailure, illegalhand, miscal, systemflaw, Inadtrainstaff,
			othersfreetext, othersfreetextedit, relatedstaff, sharestaff, sharestaffdate,
			noaffect, noharm, tempharm, permharm, death,
			contamin, noncontamin, bodyfluexp, adminviewed, admincomment,
			staffedu,  staffedutext,  staffdisc,  staffdisctext,
			cons,  constext,  shar,  shartext1,  shartext2,
			revpol,  revform,  creform,  refer,  refertext,  referdepttext,
			others, slDays, labDept, patInv, labDeptRemark, rptpolice, rptiod
		);

		fuAdmFUCmt = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		// temp view_rpt

		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	// save both flwUp and Dhead
	else if (fuPxCmt) {
		PiReportDB.updatePxComment(userBean, pirID, pirPXID,
			PxRiskAss,
			HighAlert, BeforeWard, BeforeOutpat, AfterWardInv,
			AfterWardGiven, AfterOutpatNottaken, AfterOutpatTaken, BeforeDischarge,
			AfterDischarge, BeforeAdmin, AfterAdmin, BeforeAdminUnit,
			AfterAdminUnit, causeReaction
		);
		fuPxCmt = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		// temp
		closeAction = true;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuFurtherNotice) {
		String furtherNoticeID[] = toStaffID;
		// send further notice email
		emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());

		PiReportDB.sendEmailfurtherNotice(userBean, incident_classification, pirID, "FurtherNotice", emailFromList, furtherNoticeID);

		fuFurtherNotice = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuRedoPxDutyManagerAction) {
		String RedoPerson = null;
		String PxDutyManagerID = null;
		emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());

		// get px dutymanager
		PxDutyManagerID = PiReportDB.getPharmacyDutyManager(userBean);
		emailToList = StaffDB.getStaffEmail(PxDutyManagerID);

		// update px dutymansger to pir_res_party of pi_report_flwup
		PiReportDB.updatePharmacyRespPerson(pirID, PxDutyManagerID);

		//redo email
		PiReportDB.sendEmailRedo(userBean.getStaffID(), incident_classification, pirID, rptSts, "Redo", emailFromList, emailToList, redoReason);

		fuRedoPxDutyManagerAction = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = true;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuSubmitPx2PiAction) {
		// save dHead.jsp fields to DB

		// get next status
		rptSts = PiReportDB.getNextStatus(userBean, pirID, rptSts, command);

		if (IsOshIcn || IsPharmacy) {
			IsOshIcnOrPharmacy = true;
		}
		if (IsStaffIncident || IsMedicationIncident) {
			IsStaffOrMedicationIncident = true;
		}

		PiReportDB.updateDheadComment(userBean, pirID, piDID, "fuAdmCmt", rptSts, IsStaffOrMedicationIncident, IsOshIcnOrPharmacy,
			Narrative, Cause, ActionDone, ActionTaken,
			Narrative_followup, Cause_followup, ActionDone_followup, ActionTaken_followup,
			Narrative_UMDM, Cause_UMDM, ActionDone_UMDM, ActionTaken_UMDM,
			RiskAss, Mon,  Inv,  Treat,  HighCare,  MonSpec,  InvSpec,
			TreatSpec,  HighCareSpec,  PersonFault,  InadeTrain,
			NoPrevent,  MachFault,  MisUse,  InadeInstru,  InadeEquip,
			PoorQual,  QualDetect,  ExpItem,  InadeMat,  InstNotFollow,
			MotNature,  Noise,  DistEnv,  UnvFloor,  Slip,
			IM,  Culture,  Leader,  Other,  OtherSpec,
			failurecomply,
			samedrug, inappabb, ordermis, lasa, lapses,
			equipfailure, illegalhand, miscal, systemflaw, Inadtrainstaff,
			othersfreetext, othersfreetextedit, relatedstaff, sharestaff, sharestaffdate,
			noaffect, noharm, tempharm, permharm, death,
			contamin, noncontamin, bodyfluexp, adminviewed, admincomment,
			staffedu,  staffedutext,  staffdisc,  staffdisctext,
			cons,  constext,  shar,  shartext1,  shartext2,
			revpol,  revform,  creform,  refer,  refertext,  referdepttext,
			others, slDays, labDept, patInv, labDeptRemark, rptpolice, rptiod
		);

		if (PiReportDB.IsMedicationIncident(incident_classification_desc)) {
			PiReportDB.updatePxComment(userBean, pirID, pirPXID,
				PxRiskAss,
				HighAlert, BeforeWard, BeforeOutpat, AfterWardInv,
				AfterWardGiven, AfterOutpatNottaken, AfterOutpatTaken, BeforeDischarge,
				AfterDischarge, BeforeAdmin, AfterAdmin, BeforeAdminUnit,
				AfterAdminUnit, causeReaction
			);
		}
		// END --- save dHead.jsp fields to DB

		// save flwUp.jsp fields to DB
		if (IsOshIcn || IsPharmacy) {
			IsOshIcnOrPharmacy = true;
		}
		if (IsStaffIncident || IsMedicationIncident) {
			IsStaffOrMedicationIncident = true;
		}

		PiReportDB.updateDheadComment(userBean, pirID, piDID, "fuAdmFUCmt", rptSts, IsStaffOrMedicationIncident, IsOshIcnOrPharmacy,
			Narrative, Cause, ActionDone, ActionTaken,
			Narrative_followup, Cause_followup, ActionDone_followup, ActionTaken_followup,
			Narrative_UMDM, Cause_UMDM, ActionDone_UMDM, ActionTaken_UMDM,
			RiskAss, Mon,  Inv,  Treat,  HighCare,  MonSpec,  InvSpec,
			TreatSpec,  HighCareSpec,  PersonFault,  InadeTrain,
			NoPrevent,  MachFault,  MisUse,  InadeInstru,  InadeEquip,
			PoorQual,  QualDetect,  ExpItem,  InadeMat,  InstNotFollow,
			MotNature,  Noise,  DistEnv,  UnvFloor,  Slip,
			IM,  Culture,  Leader,  Other,  OtherSpec,
			failurecomply,
			samedrug, inappabb, ordermis, lasa, lapses,
			equipfailure, illegalhand, miscal, systemflaw, Inadtrainstaff,
			othersfreetext, othersfreetextedit, relatedstaff, sharestaff, sharestaffdate,
			noaffect, noharm, tempharm, permharm, death,
			contamin, noncontamin, bodyfluexp, adminviewed, admincomment,
			staffedu,  staffedutext,  staffdisc,  staffdisctext,
			cons,  constext,  shar,  shartext1,  shartext2,
			revpol,  revform,  creform,  refer,  refertext,  referdepttext,
			others, slDays, labDept, patInv, labDeptRemark, rptpolice, rptiod
		);
		// END -- save flwUp.jsp fields to DB

		// get report dhead
		if (fuSubmitPx2PiAction || (ConstantsServerSide.isTWAH() && "530".equals(incident_classification))) {
			deptHead = PiReportDB.GetNextRespPerson(userBean, pirID, rptSts, incident_classification_desc);
		} else {
			deptHead = PiReportDB.getMedicationReportDhead(pirID);
		}

		if (PiReportDB.updatePIReportStatus(userBean, pirID, rptSts)) {
			if ((fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Submit", fuCrDate, userBean.getStaffID(), fuDueDate, fuCompDate, fuAction, deptHead, dutyMgr, rptSts)) != null) {
				message = "Submit message sent sucessfully.";

				// file upload
				if (fileUpload) {
					String[] fileList = (String[]) request.getAttribute("filelist");
					AttachmentUpload(userBean, fileList, fupirflwID);
				}

				// save follow up person
				if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, "")) != null) {
					message = "Submit person message sent sucessfully.";
				}
				else {
					errorMessage = "Submit person message sent failure.";
				}
				// Send the follow up msg
				PiReportDB.SendFlwupMsg(userBean, "Submit", incident_classification_desc, pirID, fupirflwID, "");
			}
		}

		emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());
		emailToList = StaffDB.getStaffEmail(deptHead);

		// submit email
		PiReportDB.sendEmailSubmit(userBean, incident_classification, pirID, "Submit", emailFromList, emailToList);

		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = true;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuSendActionRequestAction) {
		emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());

		piDID = PiReportDB.addPIActionRequest(userBean, pirID, actionRequest, compDate, actionrequeststaff, requestContent, autoReminder, fuSendActionRequestActionType);

		//action request email
		actionRequest = PiReportDB.GetPIActionRequest(actionRequest, userBean);
		actionrequeststaff = StaffDB.getStaffEmail(actionrequeststaff);

		PiReportDB.sendEmailActionRequest(userBean, actionRequest, pirID, piDID, rptSts, "ActionRequest", emailFromList, actionrequeststaff, compDate, requestContent);

		fuSendActionRequestAction = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = false;

		pageIndex = "dHead";
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuSetReplied) {

		PiReportDB.setPIActionRequestReplied(userBean, pirID, pirPID);

		fuSetReplied = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = false;

		pageIndex = "dHead";
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuSendActionRequestReminderAction) {
		emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());

	//	piDID = PiReportDB.addPIActionRequest(userBean, pirID, actionRequest, compDate, actionrequeststaff, requestContent, autoReminder);

		//action request email
		actionRequest = PiReportDB.GetPIActionRequest(actionRequest, userBean);
		actionrequeststaff = StaffDB.getStaffEmail(actionrequeststaff);

		//PiReportDB.sendEmailActionRequest(userBean, actionRequest, pirID, piDID, rptSts, "ActionRequest", emailFromList, actionrequeststaff, compDate, requestContent);

		fuSendActionRequestReminderAction = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = false;

		pageIndex = "dHead";
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuPIClass) {
		piDID = PiReportDB.updatePIClass(userBean, pirID, piNearMiss, piClass, inOutPatient, hazardousCondition, outcome, piRemarks);

		fuPIClass = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = false;

		pageIndex = "dHead";
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}

	else if (fuRejectAction) {
		piDID = PiReportDB.rejectReport(userBean, pirID);

		fuRejectAction = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = false;

		pageIndex = "dHead";
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}

	else if (fuPostExamForm) {
	    // file upload
		if (fileUpload) {
			//String[] fileList = (String[]) request.getAttribute("postexamform");
			String[] fileList = (String[]) request.getAttribute("filelist");
			AttachmentUploadPostExamForm(userBean, fileList, pirID);
			PiReportDB.updatePiAssInjury(pirID, piAssInjury);
		}

		fuPostExamForm = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = false;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (fuDHeadAddForm) {
	    // file upload
		if (fileUpload) {
			//String[] fileList = (String[]) request.getAttribute("postexamform");
			String[] fileList = (String[]) request.getAttribute("filelist");
			AttachmentUploadDHeadAddExamForm(userBean, fileList, pirID);
		}

		fuDHeadAddForm = false;
		updateAction = false;
		viewAction = true;
		command = "view";
		closeAction = false;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID);
	}
	else if (createAction) {
		System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [pi] pirID="+pirID+", createAction");
		
		// 17092018 for all inc type use px flow
		//
		if (IsPharmacyStaff && PiReportDB.getPxDeptCode().equals(deptCodeflwup)) {
			if (pxcreateAction) {  // if px create report for nurse
				dutyMgr = pxdutyMgr;
				deptHeadTemp = deptHeadflwup;
				dutyMgrTemp = dutyMgr;

				//
				if (ConstantsServerSide.isHKAH()) {  // due to hk no depthead follow up combobox
					deptHeadflwup = deptHead;
					deptHeadTemp = deptHeadflwup; // add on 24042018
					deptCodeflwup = StaffDB.getDeptCode(deptHeadflwup);
				}

			} else {
				// send to pharmacy dutymanager
				ArrayList flwUpDialogreportDtl = PiReportDB.fetchReportSentinelEventAllPerson(userBean, "pharmacy");
				row = (ReportableListObject) flwUpDialogreportDtl.get(0);

				if (createActionSaveOnly) { // reporter save report only
					deptHeadTemp = deptHeadflwup;
				} else {
					deptHeadTemp = row.getValue(0);
					deptHeadflwup = deptHeadTemp;
				}
			}
		} else {
			deptHeadTemp = deptHeadflwup;
			dutyMgrTemp = dutyMgr;
		}

		if ((pirID = PiReportDB.add(userBean, personName, rank, deptCode, incident_date,
				incident_time_hh+":"+incident_time_mi, incident_place, incident_type,
				incident_classification, relPirID, incident_place_freetext, deptHead, dutyMgr, sentinelEvent, sentinelID,
				pxdeptHead, pxdutyMgr, pxNurse, nearMiss, hazardousCondition, deptCodeflwup, deptHeadflwup)) != null){
			String currentInfo[] = new String[99];
			
			System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [pi] pirID="+pirID+", add pi_report");
			System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [pi] pirID="+pirID+", patientInfo.length=" + (patientInfo == null ? "null" : patientInfo.length));
			System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [pi] pirID="+pirID+", staffInfo.length=" + (staffInfo == null ? "null" : staffInfo.length));
			System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [pi] pirID="+pirID+", visitorInfo.length=" + (visitorInfo == null ? "null" : visitorInfo.length));
			System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [pi] pirID="+pirID+", otherInfo.length=" + (otherInfo == null ? "null" : otherInfo.length));
			
			if (patientInfo != null) {
				List<String> patient = new ArrayList<String>();
				for (int i = 0; i < patientInfo.length; i++) {
					patientInfo[i] = TextUtil.parseStrUTF8(patientInfo[i]);

					currentInfo = splitInfo(patientInfo[i]);
					System.out.println("  patientInfo["+i+"], currentInfo[0]=" + currentInfo[0]);
					if (patient.contains(currentInfo[0])) {
						System.out.println("    duplicated patient=" + currentInfo[0]);
					} else {
						patient.add(currentInfo[0]);
						
						if (PiReportDB.addInvolvePatient(userBean, pirID, currentInfo[0],
								currentInfo[1], currentInfo[2],
								currentInfo[3], currentInfo[4], currentInfo[5],
								currentInfo[6])) {
							message = "Succeed in add involving patient";
						}
						else {
							errorMessage = "Error in add involving patient";
						}
						
					}
				}
			}
			if (staffInfo != null) {
				List<String> staffno = new ArrayList<String>();
				for (int i = 0; i < staffInfo.length; i++) {
					staffInfo[i] = TextUtil.parseStrUTF8(staffInfo[i]);

					currentInfo = splitInfo(staffInfo[i]);
					System.out.println("  staffInfo["+i+"], currentInfo[1]=" + currentInfo[1]);
					if (staffno.contains(currentInfo[1])) {
						System.out.println("    duplicated staff=" + currentInfo[1]);
					} else {
						staffno.add(currentInfo[1]);
						
						if (PiReportDB.addInvolveStaff(userBean, pirID, (currentInfo[0].equals("true")?"1":"0"),
								currentInfo[1], currentInfo[2], currentInfo[3], currentInfo[4],
								currentInfo[5], currentInfo[6])) {
							message = "Succeed in add involving staff";
						}
						else {
							errorMessage = "Error in add involving staff";
						}
					
					}
				}
			}
			if (visitorInfo != null) {
				List<String> visitor = new ArrayList<String>();
				for (int i = 0; i < visitorInfo.length; i++) {
					visitorInfo[i] = TextUtil.parseStrUTF8(visitorInfo[i]);

					currentInfo = splitInfo(visitorInfo[i]);
					System.out.println("  visitorInfo["+i+"], currentInfo[4]=" + currentInfo[4]);
					if (visitor.contains(currentInfo[4])) {
						System.out.println("    duplicated visitor=" + currentInfo[4]);
					} else {
						visitor.add(currentInfo[4]);
							
						if (PiReportDB.addInvolveVisitorOrRelatives(userBean, pirID,
								(currentInfo[0].equals("true")?"1":"0"), currentInfo[1],
								(currentInfo[2].equals("true")?"1":"0"),
								currentInfo[3], currentInfo[4], currentInfo[5], currentInfo[6], currentInfo[7], currentInfo[8])) {
							message = "Succeed in add involving visitor";
						}
						else {
							errorMessage = "Error in add involving visitor";
						}
						
					}
				}
			}
			if (otherInfo != null) {
				List<String> other = new ArrayList<String>();
				for (int i = 0; i < otherInfo.length; i++) {
					otherInfo[i] = TextUtil.parseStrUTF8(otherInfo[i]);

					currentInfo = splitInfo(otherInfo[i]);
					System.out.println("  otherInfo["+i+"], currentInfo[1]=" + currentInfo[1]);
					if (other.contains(currentInfo[1])) {
						System.out.println("    duplicated other=" + currentInfo[1]);
					} else {
						other.add(currentInfo[1]);
						
						if (PiReportDB.addInvolveOther(userBean, pirID, currentInfo[0], currentInfo[1], currentInfo[2],
													  currentInfo[3], currentInfo[4])) {
							message = "Succeed in add involving other";
						}
						else {
							errorMessage = "Error in add involving other";
						}
						
					}
				}
			}

			message = "Succeed in add basic information";

			if (incident_type != null) {
				String moduleValue = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, incident_type+"_value"));
				if (moduleValue != null && moduleValue.length() > 0) {
					String value[] = moduleValue.split("&#");
					
					// check duplicated
					List<PiReportContent> tempContents = new ArrayList<PiReportContent>();

					for (int i = 0; i < value.length; i++) {
						String field[] = value[i].split("@#");

						PiReportContent thisContent = new PiReportContent(field[0], field[1], field[2], field[3], field[4]);
						if (!tempContents.contains(thisContent)) {
							tempContents.add(thisContent);

							if (field[2].equals("upload")) {
								if (fileUpload) {
									StringBuffer tempStrBuffer = new StringBuffer();
									tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
									tempStrBuffer.append(File.separator);
									tempStrBuffer.append("PIReport");
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
									tempStrBuffer.append(pirID);
									String webUrl = tempStrBuffer.toString();
	
									FileUtil.moveFile(
											ConstantsServerSide.UPLOAD_FOLDER + File.separator + field[3].substring(field[3].lastIndexOf("\\")+1, field[3].length()),
											baseUrl + field[3].substring(field[3].lastIndexOf("\\")+1, field[3].length())
										);
									String documentID = "";
									if ((documentID = DocumentDB.add(ConstantsServerSide.SITE_CODE,
											userBean, "pireport", pirID, webUrl, field[3].substring(field[3].lastIndexOf("\\")+1, field[3].length()))) != null) {
										System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [pi] addReportContent 1 (upload) pirID="+pirID+", field[0]="+field[0]+", field[1]="+field[1]+", field[2]="+field[2]+", field[3]="+field[3]+", field[4]="+field[4]);
										
										if (PiReportDB.addReportContent(userBean, pirID, field[1], documentID, field[4], field[0])) {
											message = "Succeed in upload document";
										}
										else {
											errorMessage = "Error in upload document";
										}
									}
									else {
										errorMessage = "Error in upload document";
									}
								}
							}
							else {
								System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [pi] addReportContent 1 (not upload) pirID="+pirID+", field[0]="+field[0]+", field[1]="+field[1]+", field[2]="+field[2]+", field[3]="+field[3]+", field[4]="+field[4]);
								
								if (PiReportDB.addReportContent(userBean, pirID, field[1], field[3], field[4], field[0])) {
									message = "Succeed in save content";
								}
								else {
									errorMessage = "Error in save content";
								}
							}
						} else {
							System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [pi] addReportContent duplicated pirID="+pirID+", field[0]="+field[0]+", field[1]="+field[1]+", field[2]="+field[2]+", field[3]="+field[3]+", field[4]="+field[4]);
						}
					}
				}
			}

			//
			rptSts = PiReportDB.getNextStatus(userBean, pirID, rptSts, command);

			if (PiReportDB.updatePIReportStatus(userBean, pirID, rptSts)) {
				// 17092018 for all inc type use px flow
				if (IsPharmacyStaff && PiReportDB.getPxDeptCode().equals(deptCodeflwup)) {
					if (!pxcreateAction) {  // if px create report
						deptHead = "";
						dutyMgr = "";
					}
				}
				//20221219 Enable Medication Incident pass to Senior Pharmacist
				if ("8".equals(rptSts) && !PiReportDB.IsMedicationIncident(incident_classification)) {
					dutyMgr = "";
					deptHeadflwup = "";
				}

				if (createActionSaveOnly) { // reporter save report only
					fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Save", DateTimeUtil.getCurrentDateTime(), userBean.getStaffID(), null, null, null, deptHeadflwup, dutyMgr, rptSts);
				}
				else { // normal submit by reporter
					fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Submit", DateTimeUtil.getCurrentDateTime(), userBean.getStaffID(), null, null, null, deptHeadflwup, dutyMgr, rptSts);
				}

				if (fupirflwID != null) {
					message = "Submit message sent sucessfully.";
						if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, "")) != null) {
							message = "Submit person message sent sucessfully.";
						}
						else {
							errorMessage = "Submit person message sent failure.";
						}
					// Send the followup msg
					PiReportDB.SendFlwupMsg(userBean, "Submit", incident_classification_desc, pirID, fupirflwID, "");

					// Send the dhead comment
					PiReportDB.addDheadComment(userBean, pirID, rptSts, "", "", "", "", userBean.getStaffID());

					// Send the Px comment
					// incident_classification = 8, 530 = Medication error

					if (PiReportDB.IsMedicationIncident(incident_classification)) {
						PiReportDB.addPxComment(userBean, pirID);
					}
				}
				else {
					errorMessage = "Submit message sent failure.";
				}
			}

			if (errorMessage != null && errorMessage.length() > 0) {
				// save with error
				message = null;
			}
			else {
				// save complete
				message = "Succeed in save report";

				emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());
				//create email
				//PiReportDB.alert(userBean, incident_classification, pirID, "Create", emailFromList, emailToList, "");

				deptHeadflwup = deptHeadTemp;
				dutyMgr = dutyMgrTemp;

				// check if save only in twah reporter
				if (!createActionSaveOnly) {
					PiReportDB.sendEmailCreate(userBean, pxcreateAction, incident_classification, pirID, "Create", emailFromList, StaffDB.getStaffEmail(deptHeadflwup), StaffDB.getStaffEmail(dutyMgr), "");
				}

				// copy the action plan file to the folder
				if (ConstantsServerSide.isTWAH()) {
					FileUtil.copyFile("\\\\192.168.0.20\\pi\\RiskActionPlan.doc", "\\\\192.168.0.20\\pi\\" + pirID +"\\RiskActionPlan.doc");
				} else {
					FileUtil.copyFile("\\\\www-server\\pi\\RiskActionPlan.doc", "\\\\www-server\\pi\\" + pirID +"\\RiskActionPlan.doc");
				}

				// check if save only in twah reporter
				// send sentinel event email
				if ("1".equals(sentinelEvent) && (ConstantsServerSide.isHKAH() || !createActionSaveOnly)) {
					PiReportDB.sendEmailSentinelEvent(userBean, incident_classification, pirID, "SentinelEvent");
				}
			}

			createAction = false;
			viewAction = true;
			command = "view";

		}
		else {
			errorMessage = "Error in add report";
		}

		closeAction = true;
	}
	else if (updateAction) {
		if (IsPharmacyStaff && PiReportDB.IsMedicationIncident(incident_classification)) {
			if (pxupdateAction) {  // if px create report for nurse
				if (!command.equals("update_px2")) {
					deptHead = pxdeptHead;
					deptHead = deptHeadflwup;
				}
				dutyMgr = pxdutyMgr;
				deptHeadTemp = deptHead;
				dutyMgrTemp = dutyMgr;
			} else {
				// send to pharmacy dutymanager
				ArrayList flwUpDialogreportDtl = PiReportDB.fetchReportSentinelEventAllPerson(userBean, "pharmacy");
				row = (ReportableListObject) flwUpDialogreportDtl.get(0);
				deptHeadTemp = row.getValue(0);
				deptHeadflwup = deptHeadTemp;
			}
		} else {
			deptHeadTemp = deptHeadflwup;
			dutyMgrTemp = dutyMgr;
		}

		if (pirID != null) {
			if (PiReportDB.updateReport(userBean, pirID, personName, rank, deptCode, incident_date,
					incident_time_hh+":"+incident_time_mi, incident_place, incident_type,
					incident_classification, relPirID, incident_place_freetext, deptHead, dutyMgr, sentinelEvent, sentinelID,
					pxdeptHead, pxdutyMgr, pxNurse, nearMiss, hazardousCondition, deptCodeflwup, deptHeadflwup)) {
				String currentInfo[] = new String[99];
				PiReportDB.deleteInvolvePerson(userBean, pirID, null);
				if (patientInfo != null) {
					for (int i = 0; i < patientInfo.length; i++) {
						patientInfo[i] = TextUtil.parseStrUTF8(patientInfo[i]);

						currentInfo = splitInfo(patientInfo[i]);

						if (currentInfo[7] != null && currentInfo[7].length() > 0 && isInteger(currentInfo[7])) {
							if (PiReportDB.updateInvolvePatient(userBean, pirID, currentInfo[7],
									currentInfo[0], currentInfo[1], currentInfo[2],
									currentInfo[3], currentInfo[4],
									currentInfo[5], currentInfo[6])) {
								message = "Succeed in update involving patient";
							}
							else {
								errorMessage = "Error in update involving patient";
							}
						}
						else {
							if (PiReportDB.addInvolvePatient(userBean, pirID, currentInfo[0],
									currentInfo[1], currentInfo[2],
									currentInfo[3], currentInfo[4],
									currentInfo[5], currentInfo[6])) {
								message = "Succeed in add involving patient";
							}
							else {
								errorMessage = "Error in add involving patient";
							}
						}
					}
				}
				if (staffInfo != null) {
					for (int i = 0; i < staffInfo.length; i++) {
						staffInfo[i] = TextUtil.parseStrUTF8(staffInfo[i]);

						currentInfo = splitInfo(staffInfo[i]);

						if (currentInfo[7] != null && currentInfo[7].length() > 0 && isInteger(currentInfo[7])) {
							if (PiReportDB.updateInvolveStaff(userBean, pirID, currentInfo[7],
									(currentInfo[0].equals("true")?"1":"0"), currentInfo[1],
									currentInfo[2], currentInfo[3], currentInfo[4],
									currentInfo[5], currentInfo[6])) {
								message = "Succeed in update involving staff";
							}
							else {
								errorMessage = "Error in update involving staff";
							}
						}
						else {
							if (PiReportDB.addInvolveStaff(userBean, pirID, (currentInfo[0].equals("true")?"1":"0"),
									currentInfo[1], currentInfo[2], currentInfo[3], currentInfo[4],
									currentInfo[5], currentInfo[6])) {
								message = "Succeed in add involving staff";
							}
							else {
								errorMessage = "Error in add involving staff";
							}
						}
					}
				}
				if (visitorInfo != null) {
					for (int i = 0; i < visitorInfo.length; i++) {
						visitorInfo[i] = TextUtil.parseStrUTF8(visitorInfo[i]);

						currentInfo = splitInfo(visitorInfo[i]);

						if (currentInfo[10] != null && currentInfo[10].length() > 0 && isInteger(currentInfo[10])) {
							if (PiReportDB.updateInvolveVisitorOrRelatives(userBean, pirID, currentInfo[10],
									(currentInfo[0].equals("true")?"1":"0"), currentInfo[1],
									(currentInfo[2].equals("true")?"1":"0"),
									currentInfo[3], currentInfo[4], currentInfo[5], currentInfo[6], currentInfo[7], currentInfo[8])) {
								message = "Succeed in update involving visitor";
							}
							else {
								errorMessage = "Error in update involving visitor";
							}
						}
						else {
							if (PiReportDB.addInvolveVisitorOrRelatives(userBean, pirID,
									(currentInfo[0].equals("true")?"1":"0"), currentInfo[1],
									(currentInfo[2].equals("true")?"1":"0"),
									currentInfo[3], currentInfo[4], currentInfo[5], currentInfo[6], currentInfo[7], currentInfo[8])) {
								message = "Succeed in add involving visitor";
							}
							else {
								errorMessage = "Error in add involving visitor";
							}
						}
					}
				}
				if (otherInfo != null) {
					for (int i = 0; i < otherInfo.length; i++) {
						otherInfo[i] = TextUtil.parseStrUTF8(otherInfo[i]);

						currentInfo = splitInfo(otherInfo[i]);

						if (currentInfo[5] != null && currentInfo[5].length() > 0 && isInteger(currentInfo[5])) {
							if (PiReportDB.updateInvolveOther(userBean, pirID, currentInfo[5],
									currentInfo[0], currentInfo[1], currentInfo[2], currentInfo[3], currentInfo[4])) {
								message = "Succeed in update involving other";
							}
							else {
								errorMessage = "Error in update involving other";
							}
						}
						else {
							if (PiReportDB.addInvolveOther(userBean, pirID, currentInfo[0],
									currentInfo[1], currentInfo[2], currentInfo[3], currentInfo[4])) {
								message = "Succeed in add involving other";
							}
							else {
								errorMessage = "Error in add involving other";
							}
						}
					}
				}

				if (incident_type != null) {
					String moduleValue = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, incident_type + "_value"));
					if (moduleValue != null && moduleValue.length() > 0) {
						if (PiReportDB.deleteReportContent(userBean, pirID)) {
							String value[] = moduleValue.split("&#");

							for (int i = 0; i < value.length; i++) {
								String field[] = value[i].split("@#");
								if (field[2].equals("upload") && field[5].equals("undefined")&& !field[3].equals("undefined")) {
									if (fileUpload) {
										StringBuffer tempStrBuffer = new StringBuffer();
										tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
										tempStrBuffer.append(File.separator);
										tempStrBuffer.append("PIReport");
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
										tempStrBuffer.append(pirID);
										String webUrl = tempStrBuffer.toString();

										FileUtil.moveFile(
												ConstantsServerSide.UPLOAD_FOLDER + File.separator + field[3].substring(field[3].lastIndexOf("\\")+1, field[3].length()),
												baseUrl + field[3].substring(field[3].lastIndexOf("\\")+1, field[3].length())
											);
										String documentID = "";
										if ((documentID = DocumentDB.add(ConstantsServerSide.SITE_CODE,
												userBean, "pireport", pirID, webUrl, field[3].substring(field[3].lastIndexOf("\\")+1, field[3].length()))) != null) {
											System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [pi] addReportContent 2 (upload) pirID="+pirID+", field[0]="+field[0]+", field[1]="+field[1]+", field[2]="+field[2]+", field[3]="+field[3]+", field[4]="+field[4]);
											
											if (PiReportDB.addReportContent(userBean, pirID, field[1], documentID, field[4], field[0])) {
												message = "Succeed in upload document";
											}
											else {
												errorMessage = "Error in upload document";
											}
										}
										else {
											errorMessage = "Error in upload document";
										}
									}
								}
								else {
									if (!field[5].equals("undefined")) {
										if (PiReportDB.updateReportContent(userBean, pirID, field[5], field[3])) {
											message = "Succeed in update content";
										}
										else {
											errorMessage = "Error in update content";
										}
									}
									else {
										System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [pi] addReportContent 2 (undefined) pirID="+pirID+", field[0]="+field[0]+", field[1]="+field[1]+", field[2]="+field[2]+", field[3]="+field[3]+", field[4]="+field[4]);
										
										if (PiReportDB.addReportContent(userBean, pirID, field[1], field[3], field[4], field[0])) {
											message = "Succeed in save content";
										}
										else {
											errorMessage = "Error in save content";
										}
									}
								}
							}
						}
					}

					rptSts = PiReportDB.getNextStatus(userBean, pirID, rptSts, command);

					// if rptsts = 0 and onpy after saved by reporter

					// get the latest caller
					if (!CanEditReport) {
						deptHead = PiReportDB.getLastestRedoID(userBean, pirID, "Redo");
						dutyMgr = "";
					}

					if (ConstantsServerSide.isTWAH()) { // dhead for follow up
						if (IsPharmacyStaff && PiReportDB.IsMedicationIncident(incident_classification)) {
							if ("8".equals(rptSts)) {
								dutyMgr = "";
								deptHeadflwup = "";
							} else if ("12".equals(rptSts)) {
								deptHead = deptHeadflwup;
							}
						}
						else if ("8".equals(rptSts)) {
							dutyMgr = "";
							deptHeadflwup = "";
						}
						else {
							deptHead = deptHeadflwup;
						}
					}

					if (PiReportDB.updatePIReportStatus(userBean, pirID, rptSts)) {
						if (updateActionSaveOnly) { // reporter save report only
							fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Save", DateTimeUtil.getCurrentDateTime(), userBean.getStaffID(), null, null, null, deptHead, dutyMgr, rptSts);
						} else {
							if (IsPharmacyStaff && PiReportDB.IsMedicationIncident(incident_classification)) {
								//chk have been redo ?

								if (!pxupdateAction) {  // if not px create report
									// remark 06/07/2017
									deptHead = PiReportDB.getLastestRedoID(userBean, pirID, "Redo");
									if ((deptHead == null) || ("".equals(deptHead))) {
										deptHead = deptHeadflwup;
									}
								}
								dutyMgr = "";
							}
							// 21092018 detphead flwup
							fupirflwID = PiReportDB.addFlwUpDialog(userBean, pirID, "Submit", DateTimeUtil.getCurrentDateTime(), userBean.getStaffID(), null, null, null, deptHeadflwup, dutyMgr, rptSts);
						}

						if (fupirflwID != null) {
							message = "Submit message sent sucessfully.";
								if ((fupirflwpID = PiReportDB.addFlwUpDialogToPerson(userBean, pirID, fupirflwID, "")) != null) {
									message = "Submit person message sent sucessfully.";
								}
								else {
									errorMessage = "Submit person message sent failure.";
								}
							// Send the followup msg
							PiReportDB.SendFlwupMsg(userBean, "Submit", incident_classification_desc, pirID, fupirflwID, "");
						}
						else {
							errorMessage = "Submit message sent failure.";
						}
					}
				}

				if (errorMessage != null && errorMessage.length() > 0) {
					// update with error
					message = null;
				}
				else {
					// update complete
					message = "Succeed in update report";

					emailFromList = StaffDB.getStaffEmail(userBean.getStaffID());

					if (ConstantsServerSide.isTWAH()) {
						if (!updateActionSaveOnly) {
							if (IsNeverSubmitted) {  // if saved report first time resubmit
								if (PiReportDB.IsMedicationIncident(incident_classification)) {
									deptHead = deptHeadTemp;
								}
								PiReportDB.sendEmailCreate(userBean, pxupdateAction, incident_classification, pirID, "Create", emailFromList, StaffDB.getStaffEmail(deptHead), StaffDB.getStaffEmail(dutyMgr), "");
							} else {
								PiReportDB.sendEmailUpdate(userBean, pxupdateAction, incident_classification, pirID, "Resubmit", emailFromList, StaffDB.getStaffEmail(deptHead), StaffDB.getStaffEmail(dutyMgr));
							}
						}
					} else {
						//21092018 all inc type use px flow
						if (IsPxIncident) {
							PiReportDB.sendEmailUpdate(userBean, pxupdateAction, incident_classification, pirID, "Resubmit", emailFromList, StaffDB.getStaffEmail(deptHeadflwup), StaffDB.getStaffEmail(dutyMgr));
						} else {
							PiReportDB.sendEmailUpdate(userBean, pxupdateAction, incident_classification, pirID, "Resubmit", emailFromList, StaffDB.getStaffEmail(deptHead), StaffDB.getStaffEmail(dutyMgr));
						}
					}
					// send sentinel event email
					if ("1".equals(sentinelEvent) && IsNeverSubmitted) {
						PiReportDB.sendEmailSentinelEvent(userBean, incident_classification, pirID, "SentinelEvent");
					}

				}

				updateAction = false;
				viewAction = true;
				command = "view";
			}
			else {
				errorMessage = "Error in update report";
			}
		}
		closeAction = true;
		//response.sendRedirect("incident_report2.jsp?command=view&pirID="+pirID+"&refreshOpenerList=true" );
	}
	else if (deleteAction) {
		if (PiReportDB.updatePIReportEnable(userBean, pirID, "0")) {
			closeAction = true;
		} else {
			errorMessage = "Error in cancel report";
		}
	}
	else if (reopenAction) {
		if (PiReportDB.updatePIReportEnable(userBean, pirID, "1")) {
			message = "The report is opened";
		} else {
			errorMessage = "Error in reopen report";
		}
		viewAction = true;
		command = "view";
	}

	if ((viewAction || editAction) && pirID != null) {
		ArrayList record = PiReportDB.fetchReportBasicInfo(pirID);
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);

			pirID = row.getValue(0);
			personName = row.getValue(1);
			rank = row.getValue(2);
			deptCode = row.getValue(8);
			deptDesc = row.getValue(3);
			incident_date = row.getValue(4);
			if (row.getValue(5).length() >= 3) {
				incident_time_hh = row.getValue(5).substring(0, 2);
				if (row.getValue(5).length() == 5) {
					incident_time_mi = row.getValue(5).substring(3, 5);
				} else {
					incident_time_mi = "";
				}
			}
			incident_place = row.getValue(6);
			incident_place_freetext = row.getValue(13);
			incident_type = row.getValue(7);
			incident_status = row.getValue(9);
			incident_classification = row.getValue(10);
			incident_classification_desc = row.getValue(11);
			relPirID = row.getValue(12);
			//deptHead = " ";
			deptHead = row.getValue(14);
			deptHeadName = row.getValue(15);
			dutyMgr = row.getValue(17);
			dutyMgrName = row.getValue(18);
			sentinelEvent = row.getValue(19);
			sentinelID = row.getValue(20);
			sentinelDesc = row.getValue(21);
			pxdeptHead = row.getValue(23);
			pxdutyMgr = row.getValue(24);
			pxNurse = row.getValue(25);
			pxNurseName = row.getValue(26);

			nearMiss = row.getValue(27);

			incident_type_pi = row.getValue(31);
			incident_classification_desc_pi = row.getValue(30);

			// 17052017 depthead for follow up TWAH
			deptCodeflwup = row.getValue(32);
			deptHeadflwup = row.getValue(33);
			deptCodeflwup = row.getValue(34);
			deptHeadNameflwup = row.getValue(35);
			//

			hazardousCondition = row.getValue(37);
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
<%	if (closeSessionTimeOutAction) { %>
	<script type="text/javascript">alert('Session Time Out !');window.close();</script>
<%	} else if (userBean.isLogin() && closeAction) { %>
<%		if (errorMessage != null) { %>
	<script type="text/javascript">alert('Report Saving Error, <%=errorMessage %>');window.close();</script>
<%		} else { %>
<%			if (deleteAction) { %>
	<script type="text/javascript">alert('Report Cancelled');window.close();</script>
<%			} else if (createActionSaveOnly || updateActionSaveOnly) { %>
	<script type="text/javascript">alert('Report Saved');window.close();</script>
<%			} else { %>
	<script type="text/javascript">alert('Report Submitted');window.close();</script>
<%			} %>
<%		} %>
<%
	} else if (userBean.isLogin() && closeAccessDeniedAction && !userBean.isAdmin()) {
%>
	<script type="text/javascript">alert('Access Denied !');window.close();</script>
<%	} else { %>
<body style="display:none;">
	<jsp:include page="../common/banner2.jsp" />
	<div id="indexWrapper">
		<div id="mainFrame">
			<div id="Frame">
				<%
				  String title = "";
				  if (createAction)
					  title = "function.pi.report.create";
				  else if (editAction)
					  title = "function.pi.report.edit";
				  else if (viewAction)
					  title = "function.pi.report.view";
				  else
					  title = "function.pi.report.create";

				  if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
				  if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
				%>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="<%=title %>" />
					<jsp:param name="mustLogin" value="Y" />
					<jsp:param name="keepReferer" value="Y" />
				</jsp:include>

				<jsp:include page="../common/message.jsp" flush="false">
					<jsp:param name="message" value="<%=message %>" />
					<jsp:param name="errorMessage" value="<%=errorMessage %>" />
				</jsp:include>

				<div id="google_translate_element"></div>

				<%-- Start the form --%>
				<form name="reportForm" id="form1" enctype="multipart/form-data"
							action="incident_report2.jsp" method="post">

					<%-- Step Flow --%>
					<%
						if (viewAction) {
					%>
						<div style="width:98%; padding-left:5px" align='center'>
							<table>
								<tr>
									<td width="20%">
										<div type='basicInfo' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:210px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Basic Information
										</div>
									</td>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>
									<td width="20%">
										<div type='involvePerson' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:210px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Involving Person
										</div>
									</td>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>
									<td width="20%">
										<div type='incidReport' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:210px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Incident Reporting
										</div>
									</td>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>
									<td width="20%">
										<div type='flwUp' class='flwUp_click stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
										style='width:110px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Follow Up
										</div>
									</td>

									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>

									<td width="20%">
										<div type='dHead' class='dHead_click stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
										style='width:110px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Dept Head
										</div>
									</td>
<%--
<%
									if (IsPIManager) {
%>										<td align="center">
											<img src="../images/next_icon.gif" style="height:30px"/>
										</td>

										<td width="20%">
											<div type='pimanager' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
											style='width:110px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
												PI
											</div>
										</td>
<%
									}
%>
--%>
<%
							if (IsPx && "8".equals(incident_classification)) { // Px staff
%>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>

									<td width="20%">
										<div type='Px' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:170px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Medication Analysis
										</div>
									</td>
<%
							}
%>



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
										<div type='basicInfo' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:250px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Basic Information
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
										<div type='involvePerson' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:250px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Involving Person
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
										<div type='incidReport' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:250px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Incident Reporting
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
						<tr class="smallText basicInfo" type='basicInfo'>
							<td class="infoSubTitle1" colspan="2">Reporting Person</td>
						</tr>

						<tr class="smallText basicInfo" type='basicInfo'>
							<td class="infoLabel" width="30%">Report ID</td>
							<td class="infoData" width="70%">
								<%=pirID==null?"N/A":pirID %>
							</td>
						</tr>

						<tr class="smallText basicInfo" type='basicInfo'>
							<td class="infoLabel" width="30%"><font color="red">*</font>Name</td>
							<td class="infoData" width="70%">
					<%
								if (viewAction) {
					%>
									<%=personName==null?"":personName %>
									<input type="hidden" name="reportPersonName" value="<%=personName==null?(editAction?"":userBean.getUserName()):personName %>" />									
					<%
								} else {
					%>
								<input type="textfield" name="reportPersonName" value="<%=personName==null?(editAction?"":userBean.getUserName()):personName %>" maxlength="100" size="50" class="notEmpty"/>
					<%			} %>
							</td>
						</tr>
						<tr class="smallText basicInfo" type='basicInfo'>
							<td class="infoLabel" width="30%">Position</td>
							<td class="infoData" width="70%">
					<%
								if (viewAction) {
					%>
									<%=rank==null?"":rank %>
									<input type="hidden" name="reportPersonRank" value="<%=rank==null?"":rank %>" />
					<%
								} else {
					%>
								<input type="textfield" name="reportPersonRank" value="<%=rank==null?"":rank %>" maxlength="100" size="50"/>
					<%			} %>
							</td>
						</tr>
						<tr class="smallText basicInfo" id="cp_Department" type='basicInfo'>
							<td class="infoLabel" width="30%"><bean:message key="prompt.department" /></td>
							<td class="infoData" width="70%">
					<%
								if (viewAction) {
					%>
									<%=deptDesc==null?"":deptDesc %>
									<input type="hidden" name="deptCode" value="<%=deptCode==null?"":deptCode %>" /> 
					<%
								} else {
					%>
								<select name="deptCode" class="notEmpty">
									<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
										<jsp:param name="deptCode" value='<%=deptCode==null?userBean.getDeptCode():deptCode %>' />
										<jsp:param name="allowAll" value="Y" />
									</jsp:include>
								</select>
					<%			} %>
						</td>
						</tr>
						<tr class="smallText basicInfo" id="cp_DHead" type='basicInfo'>
						<%
							if (ConstantsServerSide.isTWAH()) {
						%>
							<td class="infoLabel" width="30%">Department Head of Report Person</td>
						<%
							} else {
						%>
							<td class="infoLabel" width="30%">Submitted to related Department Head</td>
						<%
							}
						%>
							<td class="infoData" width="70%">
					<%
							if (viewAction) {
					%>
								<%=deptHead==null?"":deptHeadName%>
								<input type="hidden" name="deptHead" value="<%=deptHead%>"/>								
					<%
							} else {
					%>
								<select name="deptHead" id="select1">

					<%
								if (deptHead == null) {
									deptHead = PiReportDB.getDeptHead(userBean.getDeptCode(), "ID");
					%>
									<%--
									<option value="<%=deptHead%>" selected=true><%=StaffDB.getStaffName(deptHead)%> (<%=PiReportDB.getDeptDesc(userBean.getDeptCode()) %>)</option>
									 --%>

									<option value="<%=deptHead%>" selected=true><%=StaffDB.getStaffName(deptHead)%></option>

					<%
								}
								else {
					%>
									<option value="<%=deptHead%>" selected=true><%=StaffDB.getStaffName(deptHead)%></option>
					<%

								}
					%>
										<% if (ConstantsServerSide.isHKAH()) { %>
											<option value="SRC04718"><%=StaffDB.getStaffName("SRC04718")%></option>
										<% } %>					
										<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
											<jsp:param name="value" value="<%=deptHead%>" />
											<jsp:param name="allowAll" value="Y" />
											<jsp:param name="deptHead" value="Y" />
											<jsp:param name="subHead" value="Y" />
										</jsp:include>
								</select>

								<%
									//}
								%>
					<%			} %>
							</td>
						</tr>
						<tr class="smallText basicInfo" id="cp_DHead" type='basicInfo'>
							<td class="infoLabel" width="30%">Submitted to Department Head for following up</td>
							<td class="infoData" width="70%">

						<%
							if (viewAction) {
						%>
								<%=deptHeadflwup==null?"":deptHeadNameflwup%>								 
								<input type="hidden" name="deptHeadflwup" id="selectflwup" value="<%=deptHeadflwup%>"/>
						<%
							} else {
						%>
								<select name="deptHeadflwup" id="selectflwup">

								<%
								if (deptHeadflwup == null) {
									deptHeadflwup = PiReportDB.getDeptHead(userBean.getDeptCode(), "ID");
								%>				<%--
									<option value="<%=deptHead%>" selected=true><%=StaffDB.getStaffName(deptHead)%> (<%=PiReportDB.getDeptDesc(userBean.getDeptCode()) %>)</option>
									 --%>
									<option value="<%=deptHeadflwup%>" selected=true><%=StaffDB.getStaffName(deptHeadflwup)%></option>
								<%
								}
								else {
									if (pxdeptHead != null && !"".equals(pxdeptHead)) {
										deptHeadflwup = pxdeptHead;
									}
								%>
									<option value="<%=deptHeadflwup%>" selected=true><%=StaffDB.getStaffName(deptHeadflwup)%></option>
								<%
								}
								%>
								
									<% if (ConstantsServerSide.isHKAH()) { %>
										<option value="SRC04718"><%=StaffDB.getStaffName("SRC04718")%></option>
										<option value="SRC06720"><%=StaffDB.getStaffName("SRC06720")%></option>
									<% } %>												
									<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
									<jsp:param name="value" value="<%=deptHeadflwup%>" />
									<jsp:param name="deptHead" value="Y" />
									<jsp:param name="subHead" value="Y" />
									<jsp:param name="allowEmpty" value="Y" />
									</jsp:include>
								</select>
								</td>
							</tr>
						<%
							}
						%>

						<tr class="smallText basicInfo" id="cp_DMgr" type='basicInfo'>
							<td class="infoLabel" width="30%">Submitted to Duty Manager / Deputy Department Head</td>
							<td class="infoData" width="70%">
					<%
							if (viewAction) {
					%>
								<%=dutyMgr==null?"":dutyMgrName%>
								<input type="hidden" name="dutyMgr" value="<%=dutyMgr%>"/>
					<%
							} else {
								if (ConstantsServerSide.isTWAH() || IsNursingStaff || IsPharmacyStaff) {
					%>
								<select name="dutyMgr" id="select2">
									<option value="">--Select Duty Manager--</option>
					<%
									ArrayList dutyManagerDtl = getDutyManager();
									for (int j = 0; j < dutyManagerDtl.size(); j++) {
										row = (ReportableListObject) dutyManagerDtl.get(j);
					%>
									<option value="<%=row.getValue(0) %>" <%if (row.getValue(0).equals(dutyMgr)) {%>selected<%} %>><%=row.getValue(1) %></option>
					<%
									}
					%>
								</select>
					<%
								} else {
					%>
								<select name="dutyMgr" id="select2">
									<option value="">--Select Staff--</option>
									<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
										<jsp:param name="value" value="<%=dutyMgr%>" />
										<jsp:param name="allowAll" value="Y" />
									</jsp:include>
								</select>
					<%
								}
							}
							if (ConstantsServerSide.isHKAH()) {
					%>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Select if department head is not on-duty)
					<%
							}
					%>
							</td>
						</tr>
					<%
						if (IsPharmacyStaff) {
					%>
						<tr class="smallText basicInfo" id="cp_pxnurse" type='basicInfo'>
							<td class="infoLabel" width="30%">Report for the Nurse</td>
							<td class="infoData" width="70%">
					<%
							if (viewAction) {
					%>
								<%=pxNurseName%>
								<input type="hidden" name="pxNurseMain" id="pxselect3" value="<%=pxNurse%>"/>
					<%
							} else {
					%>
									<select name="pxNurseMain" id="pxselect3">
										<option value="">--Select Staff--</option>
										<jsp:include page="../ui/staffIDCMB.jsp" flush="false">
											<jsp:param name="allowAll" value="Y" />
											<jsp:param name="staffNurse" value="Y" />
											<jsp:param name="value" value="<%=pxNurse%>" />
										</jsp:include>
									</select>
					<%
							}
						}
					%>
							</td>
						</tr>

						<tr class="smallText basicInfo" id="cp_Sentinel" type='basicInfo'>
							<td class="infoLabel" width="30%">Is it a Sentinel Event or Serious Untoward Event ?</td>
							<td class="infoData" width="70%">
					<%
							if (viewAction) {
					%>
								<%="1".equals(sentinelEvent)?"Yes":"No"%>
								<%
									if ("1".equals(sentinelEvent)) {
								%>
								<br>
								<%
									}
								%>
								<%=" : " + sentinelDesc%>
								<input type="hidden" name="sentinelEvent" value="<%=sentinelEvent%>"/>
								<input type="hidden" name="sentinelname" value="<%=sentinelID %>"/>
					<%
							} else {
					%>
									<input type="radio" name="sentinel" value="1" <%if ("1".equals(sentinelEvent)) {%>checked="true"<%} %>>Yes
									<input type="radio" name="sentinel" value="0" <%if ("0".equals(sentinelEvent)) {%>checked="true"<%} %>>No
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="JavaScript:newPopup('definitionSentinelEvent.jsp');">Definition of Sentinel Event and Other Event to be reported to DH</a>
					<%
								if (ConstantsServerSide.isTWAH()) {
					%>
									<select name="sentinelname" id="sentinelid" <%if ("0".equals(sentinelEvent)) {%>style="display:none;"<%}%>>
										<option value="0"></option>
										<option value="1" <%if ("1".equals(sentinelID)) {%>selected<%} %>>Events that have resulted in an unexpected death or permanent loss of function</option>
										<option value="2" <%if ("2".equals(sentinelID)) {%>selected<%} %>>Unanticipated maternal death or serious maternal complication associated with labour, delivery or during the postnatal period</option>
										<option value="3" <%if ("3".equals(sentinelID)) {%>selected<%} %>>Unanticipated death of a full-term infant or intra-uterine stillbirth</option>
										<option value="4" <%if ("4".equals(sentinelID)) {%>selected<%} %>>Death or serious injury that occurred during operation or interventional procedures</option>
										<option value="5" <%if ("5".equals(sentinelID)) {%>selected<%} %>>Surgery or interventional procedure involving wrong patient or body parts</option>
										<option value="6" <%if ("6".equals(sentinelID)) {%>selected<%} %>>Serious reaction after blood or blood products transfusion</option>
										<option value="7" <%if ("7".equals(sentinelID)) {%>selected<%} %>>Retained instruments or other material after surgery / interventional procedure requiring re-operation or further surgical procedure</option>
										<option value="8" <%if ("8".equals(sentinelID)) {%>selected<%} %>>Medication error resulting in major permanent loss of function of a patient</option>
										<option value="9" <%if ("9".equals(sentinelID)) {%>selected<%} %>>Intravascular gas embolism resulting in death or neurological damage</option>
										<option value="10" <%if ("10".equals(sentinelID)) {%>selected<%} %>>Death of an in-patient from suicide</option>
										<option value="11" <%if ("11".equals(sentinelID)) {%>selected<%} %>>Infant discharged to wrong family or infant abduction</option>
										<option value="12" <%if ("12".equals(sentinelID)) {%>selected<%} %>>Dispensing the same wrong medication to a number of patients</option>
										<option value="13" <%if ("13".equals(sentinelID)) {%>selected<%} %>>Use of a batch of inadequately sterilized O.T. equipment</option>
									</select>
					<%
									} else {
					%>
										<input type="hidden" name="sentinelname" value="<%=sentinelID%>"/>
					<%
									}
								}
					%>
							</td>
						</tr>
						<tr class="smallText basicInfo" id="cp_Sentinel" type='basicInfo'>
							<td class="infoLabel" width="30%">Is it a Near Miss Incident ?</td>
							<td class="infoData" width="70%">
					<%
								if (viewAction) {
					%>
									<%="1".equals(nearMiss)?"Yes":"No"%>
									<%
										if ("1".equals(nearMiss)) {
									%>
									<br>
									<%
										}
									%>
									<input type="hidden" name="nearMiss" value="<%=nearMiss%>"/>
					<%
								} else {
					%>
									<input type="radio" name="nearMiss" value="1" <%if ("1".equals(nearMiss)) {%>checked="true"<%} %>>Yes
									<input type="radio" name="nearMiss" value="0" <%if ("0".equals(nearMiss)) {%>checked="true"<%} %>>No
					<%
								}
					%>

							</td>
						</tr>
						<tr class="smallText basicInfo" id="cp_Sentinel" type='basicInfo'>
							<td class="infoLabel" width="30%">Is it a Hazardous Condition ?</td>
							<td class="infoData" width="70%">
					<%
								if (viewAction) {
					%>
									<%="1".equals(hazardousCondition)?"Yes":"No"%>
									<%
										if ("1".equals(hazardousCondition)) {
									%>
									<br>
									<%
										}
									%>
									<input type="hidden" name="hazardousCondition" value="<%=hazardousCondition%>"/>
					<%
								} else {
					%>
									<input type="radio" name="hazardousCondition" value="1" <%if ("1".equals(hazardousCondition)) {%>checked="true"<%} %>>Yes
									<input type="radio" name="hazardousCondition" value="0" <%if ("0".equals(hazardousCondition)) {%>checked="true"<%} %>>No
									&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(<a href="JavaScript:newPopup('definitionHazardousCondition.jsp');">Hazardous condition is a circumstance that increase the probability of an adverse event</a>)
					<%
								}
					%>

							</td>
						</tr>

						<tr class="smallText basicInfo" type='basicInfo'>
							<td class="infoSubTitle1" colspan="2">Incident Information</td>
						</tr>
						<tr class="smallText basicInfo" type='basicInfo'>
							<td class="infoLabel" width="30%">Date of Occurrence</td>
							<td class="infoData" width="70%">
					<%
								if (viewAction) {
					%>
									<%=incident_date==null?"":incident_date %>
									<input type="hidden" name="occurDate" value="<%=incident_date%>"/>									
					<%
								} else {
					%>
								<input type="textfield" name="occurDate" id="occurDate" class="datepickerfield notEmpty"
									value='<%=incident_date==null?"":incident_date%>' maxlength="10" size="16"/>

					<%			} %>
							</td>
						</tr>
						<tr class="smallText basicInfo" type='basicInfo'>
							<td class="infoLabel" width="30%">Time of Occurrence</td>
							<td class="infoData" width="70%">
					<%
								if (viewAction) {
					%>
									<%=(incident_time_hh==null||incident_time_mi==null)?"":(incident_time_hh+":"+incident_time_mi) %>
									<input type="hidden" name="timeOfOccurrence_hh" value="<%=incident_time_hh%>"/>
									<input type="hidden" name="timeOfOccurrence_mi" value="<%=incident_time_mi%>"/>
					<%
								} else {
					%>
								<jsp:include page="../ui/timeCMB.jsp" flush="false">
									<jsp:param name="label" value="timeOfOccurrence" />
									<jsp:param name="time" value='<%=((incident_time_hh==null||incident_time_mi==null)?"":(incident_time_hh+":"+incident_time_mi)) %>' />
									<jsp:param name="allowEmpty" value="Y" />
									<jsp:param name="defaultValue" value='<%=((incident_time_hh==null||incident_time_mi==null))?"N":"Y"%>' />
								</jsp:include>
					<%			} %>
							</td>
						</tr>
						<tr class="smallText basicInfo" type='basicInfo'>
							<td class="infoLabel" width="30%">Place of Occurrence</td>
							<td class="infoData" width="70%">
					<%
								if (viewAction) {
					%>
									<%=incident_place==null?"":incident_place %> <%=incident_place_freetext!=null && incident_place_freetext.length() > 0?"  / " +incident_place_freetext:""%>
									<input type="hidden" name="placeOfOccur" value="<%=incident_place%>"/>
									<input type="hidden" name="placeOfOccur_freetext" value="<%=incident_place_freetext%>"/>
					<%
								} else {
					%>
								<jsp:include page="../ui/piLocationCMB.jsp" flush="false">
									<jsp:param name="type" value="place_of_occurrence" />
									<jsp:param name="value" value="<%=incident_place%>" />
									<jsp:param name="allowEmpty" value="Y" />
									<jsp:param name="selectName" value="placeOfOccur" />
									<jsp:param name="selectClass" value="notEmpty" />
									<jsp:param name="inputValue" value="<%=incident_place_freetext %>" />
								</jsp:include>
					<%			} %>
							</td>
						</tr>


<%-- hide the Report ID

						<tr class="smallText basicInfo" type='basicInfo'>
							<td class="infoSubTitle1" colspan="2">Related Report</td>
						</tr>
						<tr class="smallText basicInfo" type='basicInfo'>
							<td class="infoLabel" width="30%">Report ID</td>
							<td class="infoData" width="70%">
					<%
								if (viewAction) {
					%>
									<%=relPirID==null?"":relPirID%>
					<%
								} else {
					%>
								<select name="relPirID">
									<jsp:include page="../ui/piRelatedReportCMB.jsp" flush="false">
										<jsp:param name="pirID" value="<%=pirID %>" />
										<jsp:param name="relPirID" value="<%=relPirID %>" />
										<jsp:param name="allowEmpty" value="Y" />
									</jsp:include>
								</select>
					<%			} %>
							</td>
						</tr>
--%>
						<%-- End Basic Information --%>

						<%-- Involving Person --%>
					<%
						if (!viewAction) {
					%>
						<tr class="smallText involvePerson" type='involvePerson'>
							<td class="infoSubTitle1" colspan="2">Involving Person</td>
						</tr>
						<tr class="smallText involvePerson" type='involvePerson'>
							<td class="infoData" colspan="2">
								<table width="80%">
								 <tr>
									<td width="20%"><a href="javascript:void(0);" onclick="javascript:return showInfo('patient');"><img src="../images/plus.gif" width="10" height="10">Patient</a></td>
									<td width="20%"><a href="javascript:void(0);" onclick="javascript:return showInfo('staff');"><img src="../images/plus.gif" width="10" height="10">Staff</a></td>
									<td width="20%"><a href="javascript:void(0);" onclick="javascript:return showInfo('visitor');"><img src="../images/plus.gif" width="10" height="10">Visitor/Relative</a></td>
									<td width="20%"><a href="javascript:void(0);" onclick="javascript:return showInfo('other');"><img src="../images/plus.gif" width="10" height="10">Other</a></td>
								</tr>
								</table>
							</td>
						</tr>
					<%	} %>
						<tr class="smallText involvePerson" type='involvePerson'>
					<%
						if (viewAction || editAction || "0".equals(incident_status)) {
					%>
							<td colspan="2">
								<jsp:include page="../pi/hiddenInvolvePerson.jsp" flush="false">
									<jsp:param name="action" value='<%=(viewAction)?"view":"edit" %>' />
									<jsp:param name="pirID" value="<%=pirID %>" />
								</jsp:include>
							</td>
					<%
						} else {
					%>
							<td colspan="2">
								<div id="involvedPartyInfoPatient">
								</div>
								<div id="involvedPartyInfoStaff">
								</div>
								<div id="involvedPartyInfoVisitor">
								</div>
								<div id="involvedPartyInfoOther">
								</div>
							</td>
					<%	} %>
						</tr>
						<%-- End Involving Person --%>

						<%-- Incident Reporting --%>
						<tr class="smallText incidReport" type='incidReport'>
							<td class="infoSubTitle1" colspan="2">Incident Classification</td>
						</tr>
						<tr class="smallText incidReport" type='incidReport'>
							<td class="infoData" colspan="2">
								<table width="100%">
									<tr>
										<td>
					<%	if (viewAction) { %>
											<%--
											<%=incident_classification!=null?incident_classification_desc:"" %>
											--%>
											<%=incident_classification_desc_pi!=null?incident_classification_desc_pi:"" %>
					<%	} else { %>
											<select name="incidentClass" class="notEmpty">
												<jsp:include page="../ui/piClassificationCMB.jsp" flush="false">
													<jsp:param name="value" value="<%=incident_classification %>" />
													<jsp:param name="incidentType" value="<%=incident_type %>" />
													<jsp:param name="isOption" value="Y" />
												</jsp:include>
											</select>
					<%	} %>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr class="smallText incidReport" type='incidReport'>
							<td colspan="2">
								<div id="incidentTypeForm">
					<%
						if (editAction) {
					%>
									<jsp:include page="../pi/report_content2.jsp" flush="false">
										<jsp:param name="action" value="edit" />
										<jsp:param name="pirID" value="<%=pirID %>" />
										<jsp:param name="incidentType" value="<%=incident_type %>" />
									</jsp:include>
					<%
						}
						else if (viewAction) {
					%>
									<jsp:include page="../pi/report_content2.jsp" flush="false">
										<jsp:param name="action" value="view" />
										<jsp:param name="pirID" value="<%=pirID %>" />
										<jsp:param name="incidentType" value="<%=incident_type %>" />
										<jsp:param name="incidentTypePI" value="<%=incident_type_pi %>" />
									</jsp:include>
					<%
						}
					%>
								</div>
							</td>
						</tr>
						<%-- End Incident Reporting --%>

						<%-- Follow Up --%>
					<%	if (viewAction) { %>
						<tr class="smallText flwUp" type='flwUp'>
							<td class="infoSubTitle1" colspan="2">Follow Up</td>
						</tr>
						<tr class="smallText flwUp" type='flwUp'>
							<td class="infoData" colspan="2">
								<table width="100%">
									<tr>
										<td>
					<%				
							if ("1040".equals(incident_type)) { //20230428 Arran added for new ADR incident
					%>
									
										<jsp:include page="../pi/report_content_flwUp.jsp" flush="false">
											<jsp:param name="action" value="view" />
											<jsp:param name="pirID" value="<%=pirID %>" />
											<jsp:param name="incidentType" value="<%=incident_type %>" />
											<jsp:param name="incidentTypePI" value="<%=incident_type_pi %>" />		
										</jsp:include>	
																
					<% 		} %>
															
										<jsp:include page="../pi/flwUp.jsp" flush="false">
											<jsp:param name="action" value="view" />
											<jsp:param name="pirID" value="<%=pirID %>" />
											<jsp:param name="incidentType" value="<%=incident_type%>" />
											<jsp:param name="incidentDesc" value="<%=incident_classification_desc_pi%>" />
										</jsp:include>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					<%	}
					%>
					<%-- End Follow Up --%>

					<%-- Dept Head --%>
					<%	if (viewAction) { %>
						<tr class="smallText dHead" type='dHead'>
							<td class="infoSubTitle1" colspan="2">Dept Head</td>
						</tr>
						<tr class="smallText dHead" type='dHead'>
							<td class="infoData" colspan="2">
								<table width="100%">
									<tr>
										<td>
										<jsp:include page="../pi/dHead.jsp" flush="false">
											<jsp:param name="action" value="view" />
											<jsp:param name="pirID" value="<%=pirID %>" />
											<jsp:param name="incidentType" value="<%=incident_type %>" />
										</jsp:include>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					<%	} else { %>

					<%	} %>
					<%-- End Dept Head --%>

					<%-- Px --%>
					<%	if (viewAction) { %>
					<%
						if (IsPx && "8".equals(incident_classification)) { // Px staff
					%>
								<tr class="smallText Px" type='Px'>
									<td class="infoSubTitle1" colspan="2">Pharmacy complemental follow-up</td>
								</tr>
								<tr class="smallText Px" type='Px'>
									<td class="infoData" colspan="2">
										<table width="100%">
											<tr>
												<td>
												<jsp:include page="../pi/Px.jsp" flush="false">
													<jsp:param name="action" value="view" />
													<jsp:param name="pirID" value="<%=pirID %>" />
													<jsp:param name="incidentType" value="<%=incident_type%>" />
													<jsp:param name="incidentClassification" value="<%=incident_classification %>" />
												</jsp:include>
												</td>
											</tr>
										</table>
									</td>
								</tr>
					<%
							}
						} %>
					<%-- End Px --%>

					<%-- PI
					<%	if (viewAction) { %>

						<tr class="smallText pimanager" type='pimanager'>
							<td class="infoSubTitle1" colspan="2">PI Action Request</td>
						</tr>
						<tr class="smallText pimanager" type='pimanager'>
							<td class="infoData" colspan="2">
								<table width="100%">
									<tr>
										<td>
											<jsp:include page="../pi/pi.jsp" flush="false">
												<jsp:param name="action" value="view" />
												<jsp:param name="pirID" value="<%=pirID %>" />
												<jsp:param name="incidentType" value="<%=incident_type%>" />
											</jsp:include>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					<%	} else { %>

					<%	} %>
					End PI --%>

					</table>

					<%--prev/next step btn --%>
					<%--
					<div style="float:left; width:90px; height:30px; top:50%;line-height:30px;overflow:hidden;text-align:center"
							class='prevBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>
						<< Prev
					</div>
					<div style="float:right; width:90px; height:30px; top:50%;line-height:30px;overflow:hidden;text-align:center"
							class='nextBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'>
						Next >>
					</div>
					 --%>
					<input type="hidden" name="command" value="<%=command==null?"":command%>"/>
					<input type="hidden" name="selectedIncidentType" value="<%=incident_type==null?"":incident_type%>"/>
					<input type="hidden" name="pirID" value="<%=pirID==null?"":pirID%>"/>

					<input type="hidden" name="pageIndex" value="<%=pageIndex==null?"":pageIndex%>"/>
					<input type="hidden" name="pirPID" value="<%=pirPID==null?"":pirPID%>"/>
				</form>
<script type="text/javascript" src="https://translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
<script language="javascript">
var editAction = false;
var viewAction = false;
var viewRptAction = false;
var checkList = new Array();
var apis = [];

keepAlive(60000);

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
	if (command == 'edit') {
		editAction = true;
	}
	else if (command.indexOf('view') > -1) {
		viewAction = true;
	}
	$('input[name=command]').val('');

	if (viewAction) {
		$('div.reportContent').appendTo('div#content-container');
		initScroll('div#report', true);
		selectReportItemEvent();
		selectReportItemEvent_flwUp();
		if (command.indexOf('view_rpt') > -1) {
			viewRptAction = true;
		}

		if (viewRptAction) {
//			viewReport();
		}
	}
	else if (editAction) {
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
			if ($(this).find('[contentId]').length > 0) {
				$(this).prev().trigger('click');
			}
		});
		$('div #removeImage').each(function(i, v) {
			if ($(this).parent().find('[contentId]').length > 0) {
				if (!($(this).parent().find('.copy').length > 0)) {
					$(this).remove();
				}
				else {
					if (!($(this).next().find('tr').length > 0)) {
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
		referKeyEvent();
		referKeyEventChkbox();
		$('div.reportContent').appendTo('div#content-container');
		initScroll('div#report', true);
		selectReportItemEvent();
		selectReportItemEvent_flwUp();
		// toy add on 2/3/2015
		makeCheckList();
	}
	else {
	<%	if (ConstantsServerSide.isHKAH()) { %>
		alert('* CONFIDENTIAL\n* Not part of Patient\'s Medical Record\n* Non punitive response to reporting');
	<% } else { %>	
		alert('* CONFIDENTIAL\n* Not part of Patient\'s Medical Record');
	<%}%>
	}

	$('table').each(function(i, v) {
		if (!($(this).find('tr').length > 0)) {
			$(this).remove();
		}
	});
	submitEvent();
	$('body').css('display', '');
	referKeyEvent();
	referKeyEventChkbox();

	//alert('assign event....');
	$("input[name=sentinel]").click(function(){
		//alert('assign ing event');
		privateMode(this.value);
	});


   // try to keep focus of before submit page.
   <%
   if ("dHead".equals(pageIndex)) {
   %>
		$('div.dHead_click').trigger('click');
	<%
	}
    else if ("flwUp".equals(pageIndex)) {
    %>
	$('div.flwUp_click').trigger('click');
    <%
    }
    %>
   //$('div[type='+$(input).val()+']').trigger('click');
	//

    $('#google_translate_element').bind('DOMNodeInserted', function(event) {
        $('.goog-te-menu-value span:first').html('Translate');
        $('.goog-te-menu-frame.skiptranslate').load(function(){
          setTimeout(function(){
            $('.goog-te-menu-frame.skiptranslate').contents().find('.goog-te-menu2-item-selected .text').html('Translate');
          }, 100);
        });
      });
});


function privateMode(enable) {
	if (enable == 0) {
//		alert('Hide');
		$('#sentinelid').hide();
	} else {
//		alert('Show');
		$('#sentinelid').show();
	}
}

<%--/**********************Step Flow********************/--%>
//Modified on 02-04-2012 Select Step Event
function selectStepEvent() {
	$('div.stepBtn').click(function() {
		var type = $(this).attr('type');

		$(this).addClass('selected');
		$('.'+type).css('display', '');

		$('div.stepBtn').each(function(i, v){
			if ($(v).attr('type') != type) {
				$(this).removeClass('selected');
				$('form[name=reportForm]').find('table.reportcontent').find
				('.'+$(v).attr('type')).css('display', 'none');
			}
		});
		<%
		if (!createAction && !editAction && !viewAction && ConstantsServerSide.isHKAH()) {
		%>
		if ($(this).attr('type') == 'involvePerson') {
			alert('Please provide fill in details of the source(usually patient) of body fluid exposure');
		}
		<%
		}
		%>

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
			if ($(v).hasClass('selected')) {
				selected = true;
			}
			if (selected) {
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
			if (selected) {
				$(v).trigger('click');
				selected = false;
				return;
			}
			if ($(v).hasClass('selected')) {
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
//Modified on 02/04/2012 the event of info fields
function involveVisitorInfoEvent() {
	$('input[name=visitorOfPat]').each(function(i, v) {
		$(this).unbind('click');
		$(this).click(function() {
			if ($(this).attr('checked')) {
				$(this).parent().parent().find('input[name=involveVisitPatNo]').addClass('notEmpty');
			}
			else {
				$(this).parent().parent().find('input[name=involveVisitPatNo]').removeClass('notEmpty');
			}
		});
	});
	$('input[name=visitorOfStaff]').each(function(i, v) {
		$(this).unbind('click');
		$(this).click(function() {
			if ($(this).attr('checked')) {
				$(this).parent().parent().find('input[name=involveVisitStaffNo]').addClass('notEmpty');
			}
			else {
				$(this).parent().parent().find('input[name=involveVisitStaffNo]').removeClass('notEmpty');
			}
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
		if (type == 'staff'){
			Row = $('div#hiddenInvolveStaffInfo').html();
			$('<div class="involvedPartyInfoStaff">'+Row+'</div>').appendTo('div#involvedPartyInfoStaff');
			addBtn = '.AddInvolveStaffInfo';
		}
		if (type == 'visitor'){
			Row = $('div#hiddenInvolveVisitorInfo').html();
			$('<div class="involvedPartyInfoVisitor">'+Row+'</div>').appendTo('div#involvedPartyInfoVisitor');
			addBtn = '.AddInvolveVisitorInfo';
			involveVisitorInfoEvent();
		}
		if (type == 'other'){
			Row = $('div#hiddenInvolveOthersInfo').html();
			$('<div class="involvedPartyInfoOther">'+Row+'</div>').appendTo('div#involvedPartyInfoOther');
			addBtn = '.AddInvolveOthersInfo';
		}
		addEvent(addBtn, type);
		removeEvent();
		referKeyEvent();
		referKeyEventChkbox();
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
			if (info.length > 1) {
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

//	for (i=0; i<checkList.length; i++) {
//		alert("atom, checkList[" + i + "], atomFirstItem :  : " + atom + " " + checkList[i] + " " + atomFirstItem);
//	}

	if (atom) {
		alert("Please fill all required information! \nPlease enter ONE of the appropriate section (from a to g)");
		info = checkList[0].split(',');
		if (info.length == 1) {
			atomFirstItem = checkList[0];
		}
		$('#report [grpID='+atomFirstItem+']').trigger('click');//need handle more than one category
	}
	else {
		alert("Please fill all required information!");
		$('#report [grpID='+checkList[0]+']').trigger('click');//need handle more than one category
	}

	$('div.stepBtn[type=incidReport]').trigger('click');

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

		if (this.tagName.toLowerCase() == 'input') {
			if ($(this).val().length <= 0) {
				$(this).after("<div class='alert'><img src='../images/alert_general.gif' style='width:15px; height:15px;'/><b>This information is required.</b></div>");
				hasEmpty = true;
			}
		}
		else if (this.tagName.toLowerCase() == 'textarea') {
			if ($(this).val().length <= 0) {
				$(this).after("<div class='alert'><img src='../images/alert_general.gif' style='width:15px; height:15px;'/><b>This information is required.</b></div>");
				hasEmpty = true;
			}
		}
		else if (this.tagName.toLowerCase() == 'select') {
			if ($(this).find('option:selected').val().length <= 0) {
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
		if ($(this).children().size() > 0) {
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
		if ($(this).children().size() > 0) {
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
		if ($(this).children().size() > 0) {
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
		if ($(this).children().size() > 0) {
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
		if (saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=checkInput]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#checkInput@#'+
							$(this).next().val()+'@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		if (saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=yesNo]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#yesNo@#'+
							$(this).val()+'@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		if (saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=input]').each(function(i, v) {
		if ($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('id')+'@#input@#'+
								$(this).val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			if (saveonly == 'N') {
				checkValue($(this).attr('category'));
			}
		}
	});
	report.find('[optType=textarea]').each(function(i, v) {
		if ($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('id')+'@#textarea@#'+
								$(this).val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			if (saveonly == 'N') {
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
		if (saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=radio]:checked').each(function(i, v) {
		hiddenInputVal += $(this).attr('category')+'@#'+
							$(this).attr('id')+'@#radio@#checked@#'+
							findGrpId($(this))+'@#'+
							$(this).attr('contentId')+'&#';
		if (saveonly == 'N') {
			checkValue($(this).attr('category'));
		}
	});
	report.find('[optType=date]').each(function(i, v) {
		if ($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('optid')+'@#date@#'+
								$(this).val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			if (saveonly == 'N') {
				checkValue($(this).attr('category'));
			}
		}
	});
	report.find('[optType=datetime]').each(function(i, v) {
		if ($(this).val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('optid')+'@#datetime@#'+
								$(this).val()+' '+
								$(this).parent().find('select[name='+$(this).attr('optid')+'_hh] option:selected').val()+':'+
								$(this).parent().find('select[name='+$(this).attr('optid')+'_mi] option:selected').val()+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';

			if (saveonly == 'N') {
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
		if ($(this).attr('contentId') || $(this).find('input').val().length > 0) {
			hiddenInputVal += $(this).attr('category')+'@#'+
								$(this).attr('id')+'@#upload@#'+
								($(this).attr('contentId')?$(this).attr('docIDs'):$(this).find('input').val())+'@#'+
								findGrpId($(this))+'@#'+
								$(this).attr('contentId')+'&#';
			if (saveonly == 'N') {
				checkValue($(this).attr('category'));
			}
		}
	});

//	alert("checkList.length : " + checkList.length);
	if (saveonly == 'N') {
		if (checkList.length > 0) {
			return false;
		}
	}

//	alert("hiddenInput : " + hiddenInputVal);
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

	if ($(dom).parent().parent().find('table:last').attr('contentGrpID')) {
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
	if (patient) {
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
/*
function headerEvent() {
	$('#report .header').unbind('click');
	$('#report .header').click(function() {
		$(this).next().toggle();
		if ($(this).find('div.toggleLabel').html().indexOf('Open') > -1) {
			$(this).find('div.toggleLabel').html('<img src="../images/module-collapse.png"/><b><u>Close</u></b>');
		}
		else {
			$(this).find('div.toggleLabel').html('<img src="../images/module-expand.png"/><b><u>Open</u></b>');
		}
	return false;
	}).next().hide();
	$('#report .header').find('div.toggleLabel').html('<img src="../images/module-expand.png"/><b><u>Open</u></b>');
}
*/

function selectClassEvent() {
	$('select[name=incidentClass]').change(function() {
		var type = $('option:selected', this).attr('incidentType');
		 if (editAction) {
			 return;
		 }
		 $('input[name=selectedIncidentType]').val(type);

		 $.ajax({
			 type: "POST",
			 url: "report_content2.jsp?<%=pirID==null?"":"action=edit&pirID="+pirID+"&" %>incidentType="+type,
			 async: true,
			 cache: false,
			 success: function(values){
				 if (values != '') {
					 $("#incidentTypeForm").html(values).css('display', 'none');
					 //headerEvent();
					 resetDatepicker(false);
					 makeCheckList();
					 submitEvent();
					 $('div.reportContent').appendTo('div#content-container');
					 initScroll('div#report', false);
					 $("#incidentTypeForm").css('display', '');
					 selectReportItemEvent();
					 selectReportItemEvent_flwUp();
					 $('div#report .scroll-pane').data('jsp').reinitialise();
				 }
			 }//success
		 });//$.ajax
	});
}
//Arran edited
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

function selectReportItemEvent_flwUp() {
	$('div#menu .reportItem_flwUp').click(function() {
		alert('flwUp:' + $(this).attr('grpID'));
		$('div#menu .selected').removeClass('selected');
		$(this).addClass('selected');
		$('div#content_flwUp .jspPane').find('div.reportContent_flwUp')
			.appendTo('div#content-container_flwUp').css('display', 'none');
		$('div#content-container_flwUp').find('div#'+$(this).attr('grpID'))
			.appendTo($('div#content_flwUp .jspPane')).css('display', '');
		$('div#content div:first').data('jsp').reinitialise();
	});
	$('div#menu .reportItem_flwUp:first').trigger('click');
}

function findGrpId(dom) {
	var temp = dom.parent();

	while(!$(temp).attr('contentGrpID')) {
		temp = temp.parent();
	}

	return $(temp).attr('contentGrpID');
}

function checkValue(category) {
	if (checkList.length > 0) {
		$.each(checkList, function(i, v) {
			if (v == category) {
				checkList.splice(i, 1);
				return true;
			}
			else {
				if (v) {
//					alert("else {, v : " + v);
					var info = v.split(',');
					if (info.length > 1) {
						$.each(info, function(i2, v2) {
							if (v2 == category) {
								checkList.splice(i, 1);
								return true;
							}
						});
					}
				}
			}
		});
	} else {
		return true;
	}
}

function makeCheckList() {
	var must = $('option:selected', $('select[name=incidentClass]')).attr('must');
	checkList = new Array();
	if (must) {
		var info = must.split(';');
		$.each(info, function(i, v) {
			if (v.length > 0)
				checkList.splice(checkList.length, 0, v);
		});
	}
}

function referKeyEvent() {
//	alert('function referKeyEvent() {');
	$('.referKey').unbind('blur');
	$('.referKey').blur(function() {
		if ($(this).attr('name') == 'involveVisitPatNo') {
			if ($(this).val().length > 0) {
				$(this).parent().parent().find('input[name=visitorOfPat]').attr('checked', true);
			}
			else {
				$(this).parent().parent().find('input[name=visitorOfPat]').attr('checked', false);
			}
		}

		if ($(this).attr('name') == 'involveVisitStaffNo') {
			if ($(this).val().length > 0) {
				$(this).parent().parent().find('input[name=visitorOfStaff]').attr('checked', true);
			}
			else {
				$(this).parent().parent().find('input[name=visitorOfStaff]').attr('checked', false);
			}
		}
		getRelatedInfo($(this).attr('keyType'), $(this).val(), $(this));
	});

}

function referKeyEventChkbox() {
	$('.referKeyChkBox').unbind('click');
	//$('.referKeyChkBox').on("click", function() {
	$('.referKeyChkBox').click(function() {
		if ($(this).is(':checked')) {
			getRelatedInfo($(this).attr('keyType'), '<%=userBean.getStaffID()%>', $(this));
		}
	});
}


function getRelatedInfo(type, key, dom) {
	var currentDomName = $(dom).attr('name');
	while(!$(dom).is('table')) {
		dom = $(dom).parent();
	}
	if (type == 'patient') {
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

				if (key.length > 0)
					alert("No Such Patient!");
			}
		});
	}
	else if (type == 'staff' || type == 'depthead' || type == 'fu_staff') {
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
				if (type == 'staff') {
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
				else if (type == 'depthead') {
					$(dom).find('input[name=deptHead]').val('');
					$(dom).find('input[name=deptHeadName]').val('');
				}
				else if (type == 'fu_staff') {
					$(dom).find('input[name=involveStaffNo]').val('');
					$(dom).find('input[name=involveStaffName]').val('');
				}
				if (key.length > 0) {
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
		<%
		if (ConstantsServerSide.isTWAH()) {
		%>
			var deptHead = $('select[name=deptHeadflwup] option:selected').html(); //.trim();
			var isEmpty = $('select[name=deptHeadflwup] option:selected').val(); //.trim();
		<%
		} else {
		%>
			var deptHead = $('select[name=deptHead] option:selected').html(); //.trim();
			var isEmpty = "No";
		<%
		}
		%>

		if (deptHead.indexOf(" (") > 0) {
			deptHead = deptHead.substring(0, deptHead.indexOf(" ("));
		}

		var dutyMgr = $('select[name=dutyMgr] option:selected').html(); //.trim();
		if (dutyMgr != "") {
			deptHead = deptHead + ', ' + dutyMgr;
		}

		if (isEmpty == '') {
			$.prompt('Please input "Submitted to Department Head for following up" in "Basic Information" Page',
			{
				buttons: { Ok: true},
				prefix:'cleanblue'
			});
		} else {
			if ($(btn).attr('submitType') == "create_saveonly" || $(btn).attr('submitType') == "update_saveonly") {
				$.prompt('Are you sure to save the report ?',{
					buttons: { Ok: true, Cancel: false },
					callback: function(v,m,f){
						if (v ){
							submitAction($(btn).attr('submitType'));
						}
					},
					prefix:'cleanblue'
				});
			} else {
				//alert("deptHead="+deptHead+", dutyMgr="+dutyMgr);

				$(window).unbind('beforeunload');
				$.prompt('Are you sure ? <br> The report will be submitted to : <br>' + deptHead + '<br>' + '<br> REMINDER: Please send the completed Doctor Incident Examination Form to PI Department (where appropriate). <br>   Almost all incidents require the above form including: <br> -	All patient incidents except security <br> -	All injury incidents' +
						'<br><br><a class="topstoryblue" onclick="downloadFile(\'614\', \'\'); return false;" href="javascript:void(0);" target="_blank"><span style="color:#F40A0A">Print</span> Post Incident Doctor Examination Form</a>'
						,{
					buttons: { Ok: true, Cancel: false },
					callback: function(v,m,f){
						if (v ){
							submitAction($(btn).attr('submitType'));
						}else{
							$(window).bind('beforeunload', windowOnClose);
						}
						
					},
					prefix:'cleanblue'
				});
			}
		}
		return false;
	});
}

function submitAction(command) {
	if (command == 'create' || command == 'create_px2') {
		// toy
		if ($('.involvedPartyInfoPatient').length == 0 && $('.involvedPartyInfoStaff').length == 0 && $('.involvedPartyInfoVisitor').length == 0 && $('.involvedPartyInfoOther').length == 0) {
			alert('Please input involving person');
			return false;
		}
		if (checkRequiredInfo()) {
			goToHasEmptyStepFlow();
			return false;
		}
		if (!handleReportContent('N')) {
			goToHeaderEvent();
			return false;
		}
		mergeInvolePersonInfo();
	}
	else if (command == 'create_saveonly') {
		// toy
		//if ($('.involvedPartyInfoPatient').length == 0 && $('.involvedPartyInfoStaff').length == 0 && $('.involvedPartyInfoVisitor').length == 0 && $('.involvedPartyInfoOther').length == 0) {
			//alert('Please input involving person');
			//return false;
		//}
		//if (checkRequiredInfo()) {
			//goToHasEmptyStepFlow();
			//return false;
		//}
		if (!handleReportContent('Y')) {
			//goToHeaderEvent();
			//return false;
		}
		mergeInvolePersonInfo();
	}
	else if (command == 'edit') {

	}
	else if (command == 'update' || command == 'update_px2') {
		// toy
		//alert('command == update');
		if ($('.involvedPartyInfoPatient').length == 0 && $('.involvedPartyInfoStaff').length == 0 && $('.involvedPartyInfoVisitor').length == 0 && $('.involvedPartyInfoOther').length == 0) {
			alert('Please input involving person');
			return false;
		}
		if (checkRequiredInfo()) {
			goToHasEmptyStepFlow();
			return false;
		}
		if (!handleReportContent('N')) {
			goToHeaderEvent();
			return false;
		}
		mergeInvolePersonInfo();
	}
	else if (command == 'update_saveonly') {
		//if (checkRequiredInfo()) {
		//	goToHasEmptyStepFlow();
		//	return false;
		//}
		if (!handleReportContent('Y')) {
		//	goToHeaderEvent();
		//	return false;
		}
		mergeInvolePersonInfo();
	}
	else if (command.indexOf('view') > -1) {
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

function googleTranslateElementInit() {
	//new google.translate.TranslateElement({pageLanguage: 'en-us'}, 'google_translate_element');
<% if (userBean.isAccessible("function.pi.report.translate")) { %>
    new google.translate.TranslateElement({
        pageLanguage: 'zh-tw',
        //pageLanguage: 'en',
        layout: google.translate.TranslateElement.InlineLayout.SIMPLE
      }, 'google_translate_element');
<% } %>
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