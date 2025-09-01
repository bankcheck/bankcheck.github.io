<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private String joinDateTime(String dateString, String hourString, String minsString) {
		if (dateString == null || "".equals(dateString.trim())) {
			return null;
		}
		return (dateString == null || dateString == "" ? "//" : dateString) + " " + (hourString == null ? "" : hourString) + ":" + (minsString == null ? "" : minsString);
	}

	private String[] splitDateTimeHourMins(String dateTime) {
		String[] ret = new String[3];
		if (dateTime != null) {
			String[] temp = dateTime.split(" ");
			if (temp.length > 0) {
				ret[0] = temp[0];
				if (temp.length > 1 && temp[1] != null) {
					ret[1] = temp[1].split(":")[0];
					ret[2] = temp[1].split(":")[1];
				}
			}
		}
		return ret;
	}
	
	private String convertMinsSec(String mins, String sec) {
		String ret = null;
		Long totalSec = null;
		Long secLong = null;
		Long minsLong = null;
		
		try {
			 secLong = Long.parseLong(sec);
		} catch (NumberFormatException nfex) {
		}
		try {
			 minsLong = Long.parseLong(mins);
		} catch (NumberFormatException nfex) {
		}
		
		if (!(secLong == null && minsLong == null)) {
			totalSec = ((minsLong == null ? 0 : minsLong)* 60) + (secLong == null ? 0 : secLong);
			ret = Long.toString(totalSec);
		}
			
		return ret;
	}
	
	private String[] parseMinsSec(String totalSec) {
		String[] ret = new String[2]; 
		if (totalSec != null) {
			try {
				
				
				long totalSecLong = Long.parseLong(totalSec);
				long minsLong = totalSecLong / 60;
				long secLong = totalSecLong % 60;
				ret[0] = Long.toString(minsLong);
				ret[1] = Long.toString(secLong);
			} catch (NumberFormatException nfex) {
			}
		}
		return ret;
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

UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}

String command = request.getParameter("command");
String step = request.getParameter("step");

//derived fields
String nurobDeliDateDate = request.getParameter("nurobDeliDateDate");
String nurobDeliDateTimeHour = request.getParameter("nurobDeliDateTimeHour");
String nurobDeliDateTimeMins = request.getParameter("nurobDeliDateTimeMins");

String nurobLaboDuraMins = request.getParameter("nurobLaboDuraMins");
String nurobLaboDuraSec = request.getParameter("nurobLaboDuraSec");


// bld_mrsa_esbl
String ICSiteCode = TextUtil.parseStrUTF8(request.getParameter("ICSiteCode"));
String CaseNum = TextUtil.parseStrUTF8(request.getParameter("CaseNum"));
String HospAdmDate = TextUtil.parseStrUTF8(request.getParameter("HospAdmDate"));
String LabNum = TextUtil.parseStrUTF8(request.getParameter("LabNum"));
String HospNum = TextUtil.parseStrUTF8(request.getParameter("HospNum"));
String PatName = TextUtil.parseStrUTF8(request.getParameter("PatName"));
String PatSex = TextUtil.parseStrUTF8(request.getParameter("PatSex"));
String PatBDate = TextUtil.parseStrUTF8(request.getParameter("PatBDate"));
String Age = TextUtil.parseStrUTF8(request.getParameter("Age"));
String Month = TextUtil.parseStrUTF8(request.getParameter("Month"));
String Ward = TextUtil.parseStrUTF8(request.getParameter("Ward"));
String RoomNum = TextUtil.parseStrUTF8(request.getParameter("RoomNum"));
String BedNum = TextUtil.parseStrUTF8(request.getParameter("BedNum"));
String DateIn = TextUtil.parseStrUTF8(request.getParameter("DateIn"));
String PREV_ICU_ADM = TextUtil.parseStrUTF8(request.getParameter("PREV_ICU_ADM"));
String UNIT_TEAM = TextUtil.parseStrUTF8(request.getParameter("UNIT_TEAM"));
String TRANSFER_FROM = TextUtil.parseStrUTF8(request.getParameter("TRANSFER_FROM"));
String ICU_ADM_DATE = TextUtil.parseStrUTF8(request.getParameter("ICU_ADM_DATE"));
String TRANS_OUT_DATE = TextUtil.parseStrUTF8(request.getParameter("TRANS_OUT_DATE"));
String DISC_DEST = TextUtil.parseStrUTF8(request.getParameter("DISC_DEST"));
String DIAG_ON_ICU = TextUtil.parseStrUTF8(request.getParameter("DIAG_ON_ICU"));
String BHX = TextUtil.parseStrUTF8(request.getParameter("BHX"));
String UNDER_DISE = TextUtil.parseStrUTF8(request.getParameter("UNDER_DISE"));
String PREM_STAT = TextUtil.parseStrUTF8(request.getParameter("PREM_STAT"));
String ALLERGY = TextUtil.parseStrUTF8(request.getParameter("ALLERGY"));
String DIAG_IN_ICU_DATE1 = TextUtil.parseStrUTF8(request.getParameter("DIAG_IN_ICU_DATE1"));
String DIAG_ON_ICU_DESC1 = TextUtil.parseStrUTF8(request.getParameter("DIAG_ON_ICU_DESC1"));
String DIAG_IN_ICU_DATE2 = TextUtil.parseStrUTF8(request.getParameter("DIAG_IN_ICU_DATE2"));
String DIAG_ON_ICU_DESC2 = TextUtil.parseStrUTF8(request.getParameter("DIAG_ON_ICU_DESC2"));
String DIAG_IN_ICU_DATE3 = TextUtil.parseStrUTF8(request.getParameter("DIAG_IN_ICU_DATE3"));
String DIAG_ON_ICU_DESC3 = TextUtil.parseStrUTF8(request.getParameter("DIAG_ON_ICU_DESC3"));
String DIAG_IN_ICU_DATE4 = TextUtil.parseStrUTF8(request.getParameter("DIAG_IN_ICU_DATE4"));
String DIAG_ON_ICU_DESC4 = TextUtil.parseStrUTF8(request.getParameter("DIAG_ON_ICU_DESC4"));
String DIAG_IN_ICU_DATE5 = TextUtil.parseStrUTF8(request.getParameter("DIAG_IN_ICU_DATE5"));
String DIAG_ON_ICU_DESC5 = TextUtil.parseStrUTF8(request.getParameter("DIAG_ON_ICU_DESC5"));
String DIAG_IN_ICU_DATE6 = TextUtil.parseStrUTF8(request.getParameter("DIAG_IN_ICU_DATE6"));
String DIAG_ON_ICU_DESC6 = TextUtil.parseStrUTF8(request.getParameter("DIAG_ON_ICU_DESC6"));
String DIAG_IN_ICU_DATE7 = TextUtil.parseStrUTF8(request.getParameter("DIAG_IN_ICU_DATE7"));
String DIAG_ON_ICU_DESC7 = TextUtil.parseStrUTF8(request.getParameter("DIAG_ON_ICU_DESC7"));
String DIAG_IN_ICU_DATE8 = TextUtil.parseStrUTF8(request.getParameter("DIAG_IN_ICU_DATE8"));
String DIAG_ON_ICU_DESC8 = TextUtil.parseStrUTF8(request.getParameter("DIAG_ON_ICU_DESC8"));
String DIAG_IN_ICU_DATE9 = TextUtil.parseStrUTF8(request.getParameter("DIAG_IN_ICU_DATE9"));
String DIAG_ON_ICU_DESC9 = TextUtil.parseStrUTF8(request.getParameter("DIAG_ON_ICU_DESC9"));
String DEV_INF = TextUtil.parseStrUTF8(request.getParameter("DEV_INF"));
String VAP1 = TextUtil.parseStrUTF8(request.getParameter("VAP1"));
String CABSI11 = TextUtil.parseStrUTF8(request.getParameter("CABSI11"));
String CAUT1 = TextUtil.parseStrUTF8(request.getParameter("CAUT1"));
String INFECT_DATE1 = TextUtil.parseStrUTF8(request.getParameter("INFECT_DATE1"));
String DEVICE_ONOFF_DATE1 = TextUtil.parseStrUTF8(request.getParameter("DEVICE_ONOFF_DATE1"));
String DEVICE_DAY1 = TextUtil.parseStrUTF8(request.getParameter("DEVICE_DAY1"));
String VAP2 = TextUtil.parseStrUTF8(request.getParameter("VAP2"));
String CABSI12 = TextUtil.parseStrUTF8(request.getParameter("CAUT2"));
String CAUT2 = TextUtil.parseStrUTF8(request.getParameter("CAUT2"));
String INFECT_DATE2 = TextUtil.parseStrUTF8(request.getParameter("INFECT_DATE2"));
String DEVICE_ONOFF_DATE2 = TextUtil.parseStrUTF8(request.getParameter("DEVICE_ONOFF_DATE2"));
String DEVICE_DAY2 = TextUtil.parseStrUTF8(request.getParameter("DEVICE_DAY2"));
String SS1 = TextUtil.parseStrUTF8(request.getParameter("SS1"));
String LAB_EVID1 = TextUtil.parseStrUTF8(request.getParameter("LAB_EVID1"));
String TREATMENT1 = TextUtil.parseStrUTF8(request.getParameter("TREATMENT1"));
String SS2 = TextUtil.parseStrUTF8(request.getParameter("SS2"));
String LAB_EVID2 = TextUtil.parseStrUTF8(request.getParameter("LAB_EVID2"));
String TREATMENT2 = TextUtil.parseStrUTF8(request.getParameter("TREATMENT2"));
//
String SI_DATE1 = TextUtil.parseStrUTF8(request.getParameter("SI_DATE1"));
String SI_DESC1 = TextUtil.parseStrUTF8(request.getParameter("SI_DESC1"));
String AIRWAY1 = TextUtil.parseStrUTF8(request.getParameter("AIRWAY1"));
String VENT_ON1 = TextUtil.parseStrUTF8(request.getParameter("VENT_ON1"));
String VENT_OFF1 = TextUtil.parseStrUTF8(request.getParameter("VENT_OFF1"));
String CL_SITE1 = TextUtil.parseStrUTF8(request.getParameter("CL_SITE1"));
String CL_TYPE1 = TextUtil.parseStrUTF8(request.getParameter("CL_TYPE1"));
String CL_ON1 = TextUtil.parseStrUTF8(request.getParameter("CL_ON1"));
String CL_OFF1 = TextUtil.parseStrUTF8(request.getParameter("CL_OFF1"));
String UC_TYPE1 = TextUtil.parseStrUTF8(request.getParameter("UC_TYPE1"));
String UC_ON1 = TextUtil.parseStrUTF8(request.getParameter("UC_ON1"));
String UC_OFF1 = TextUtil.parseStrUTF8(request.getParameter("UC_OFF1"));
String AL_ON1 = TextUtil.parseStrUTF8(request.getParameter("AL_ON1"));
String AL_OFF1 = TextUtil.parseStrUTF8(request.getParameter("AL_OFF1"));
String OTHER_DEV1 = TextUtil.parseStrUTF8(request.getParameter("OTHER_DEV1"));
//
String SI_DATE2 = TextUtil.parseStrUTF8(request.getParameter("SI_DATE2"));
String SI_DESC2 = TextUtil.parseStrUTF8(request.getParameter("SI_DESC2"));
String AIRWAY2 = TextUtil.parseStrUTF8(request.getParameter("AIRWAY2"));
String VENT_ON2 = TextUtil.parseStrUTF8(request.getParameter("VENT_ON2"));
String VENT_OFF2 = TextUtil.parseStrUTF8(request.getParameter("VENT_OFF2"));
String CL_SITE2 = TextUtil.parseStrUTF8(request.getParameter("CL_SITE2"));
String CL_TYPE2 = TextUtil.parseStrUTF8(request.getParameter("CL_TYPE2"));
String CL_ON2 = TextUtil.parseStrUTF8(request.getParameter("CL_ON2"));
String CL_OFF2 = TextUtil.parseStrUTF8(request.getParameter("CL_OFF2"));
String UC_TYPE2 = TextUtil.parseStrUTF8(request.getParameter("UC_TYPE2"));
String UC_ON2 = TextUtil.parseStrUTF8(request.getParameter("UC_ON2"));
String UC_OFF2 = TextUtil.parseStrUTF8(request.getParameter("UC_OFF2"));
String AL_ON2 = TextUtil.parseStrUTF8(request.getParameter("AL_ON2"));
String AL_OFF2 = TextUtil.parseStrUTF8(request.getParameter("AL_OFF2"));
String OTHER_DEV2 = TextUtil.parseStrUTF8(request.getParameter("OTHER_DEV2"));
//
String SI_DATE3 = TextUtil.parseStrUTF8(request.getParameter("SI_DATE3"));
String SI_DESC3 = TextUtil.parseStrUTF8(request.getParameter("SI_DESC3"));
String AIRWAY3 = TextUtil.parseStrUTF8(request.getParameter("AIRWAY3"));
String VENT_ON3 = TextUtil.parseStrUTF8(request.getParameter("VENT_ON3"));
String VENT_OFF3 = TextUtil.parseStrUTF8(request.getParameter("VENT_OFF3"));
String CL_SITE3 = TextUtil.parseStrUTF8(request.getParameter("CL_SITE3"));
String CL_TYPE3 = TextUtil.parseStrUTF8(request.getParameter("CL_TYPE3"));
String CL_ON3 = TextUtil.parseStrUTF8(request.getParameter("CL_ON3"));
String CL_OFF3 = TextUtil.parseStrUTF8(request.getParameter("CL_OFF3"));
String UC_TYPE3 = TextUtil.parseStrUTF8(request.getParameter("UC_TYPE3"));
String UC_ON3 = TextUtil.parseStrUTF8(request.getParameter("UC_ON3"));
String UC_OFF3 = TextUtil.parseStrUTF8(request.getParameter("UC_OFF3"));
String AL_ON3 = TextUtil.parseStrUTF8(request.getParameter("AL_ON3"));
String AL_OFF3 = TextUtil.parseStrUTF8(request.getParameter("AL_OFF3"));
String OTHER_DEV3 = TextUtil.parseStrUTF8(request.getParameter("OTHER_DEV3"));
//
String SI_DATE4 = TextUtil.parseStrUTF8(request.getParameter("SI_DATE4"));
String SI_DESC4 = TextUtil.parseStrUTF8(request.getParameter("SI_DESC4"));
String AIRWAY4 = TextUtil.parseStrUTF8(request.getParameter("AIRWAY4"));
String VENT_ON4 = TextUtil.parseStrUTF8(request.getParameter("VENT_ON4"));
String VENT_OFF4 = TextUtil.parseStrUTF8(request.getParameter("VENT_OFF4"));
String CL_SITE4 = TextUtil.parseStrUTF8(request.getParameter("CL_SITE4"));
String CL_TYPE4 = TextUtil.parseStrUTF8(request.getParameter("CL_TYPE4"));
String CL_ON4 = TextUtil.parseStrUTF8(request.getParameter("CL_ON4"));
String CL_OFF4 = TextUtil.parseStrUTF8(request.getParameter("CL_OFF4"));
String UC_TYPE4 = TextUtil.parseStrUTF8(request.getParameter("UC_TYPE4"));
String UC_ON4 = TextUtil.parseStrUTF8(request.getParameter("UC_ON4"));
String UC_OFF4 = TextUtil.parseStrUTF8(request.getParameter("UC_OFF4"));
String AL_ON4 = TextUtil.parseStrUTF8(request.getParameter("AL_ON4"));
String AL_OFF4 = TextUtil.parseStrUTF8(request.getParameter("AL_OFF4"));
String OTHER_DEV4 = TextUtil.parseStrUTF8(request.getParameter("OTHER_DEV4"));
//
String icType = request.getParameter("icType");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

if (fileUpload) {
	// No file upload supported
}

try {
	if ("1".equals(step)) {
		// construct fields
//		nurobDeliDate = joinDateTime(nurobDeliDateDate, nurobDeliDateTimeHour, nurobDeliDateTimeMins);
//		nurobLaboDura = convertMinsSec(nurobLaboDuraMins, nurobLaboDuraSec);
		
		if (createAction) {
			
			CaseNum = ICIcuDB.add(
					userBean,  
					icType, 
					HospAdmDate, 
					LabNum, 
					HospNum, 
					PatName, 
					PatSex,
					PatBDate, 
					Age, 
					Month,
					Ward,
					RoomNum, BedNum, 
					DateIn,
					PREV_ICU_ADM, UNIT_TEAM, TRANSFER_FROM, ICU_ADM_DATE, TRANS_OUT_DATE,
					DISC_DEST, DIAG_ON_ICU, BHX,UNDER_DISE, PREM_STAT, ALLERGY,
					DIAG_IN_ICU_DATE1, DIAG_ON_ICU_DESC1, DIAG_IN_ICU_DATE2, DIAG_ON_ICU_DESC2, DIAG_IN_ICU_DATE3, DIAG_ON_ICU_DESC3,
					DIAG_IN_ICU_DATE4, DIAG_ON_ICU_DESC4, DIAG_IN_ICU_DATE5, DIAG_ON_ICU_DESC5, DIAG_IN_ICU_DATE6, DIAG_ON_ICU_DESC6,
					DIAG_IN_ICU_DATE7, DIAG_ON_ICU_DESC7, DIAG_IN_ICU_DATE8, DIAG_ON_ICU_DESC8, DIAG_IN_ICU_DATE9, DIAG_ON_ICU_DESC9,
					DEV_INF, VAP1, CABSI11, CAUT1,
					INFECT_DATE1, DEVICE_ONOFF_DATE1, DEVICE_DAY1,
					VAP2, CABSI12, CAUT2,
					INFECT_DATE2, DEVICE_ONOFF_DATE2, DEVICE_DAY2,
					SS1, LAB_EVID1, TREATMENT1, SS2, LAB_EVID2, TREATMENT2,
					SI_DATE1, SI_DESC1, AIRWAY1,
					VENT_ON1, VENT_OFF1, CL_SITE1, CL_TYPE1,
					CL_ON1, CL_OFF1, UC_TYPE1,
					UC_ON1, UC_OFF1, AL_ON1, AL_OFF1, OTHER_DEV1,
					SI_DATE2, SI_DESC2, AIRWAY2,
					VENT_ON2, VENT_OFF2, CL_SITE2, CL_TYPE2,
					CL_ON2, CL_OFF2, UC_TYPE2,
					UC_ON2, UC_OFF2, AL_ON2, AL_OFF2, OTHER_DEV2,
					SI_DATE3, SI_DESC3, AIRWAY3,
					VENT_ON3, VENT_OFF3, CL_SITE3, CL_TYPE3,
					CL_ON3, CL_OFF3, UC_TYPE3,
					UC_ON3, UC_OFF3, AL_ON3, AL_OFF3, OTHER_DEV3,
					SI_DATE4, SI_DESC4, AIRWAY4,
					VENT_ON4, VENT_OFF4, CL_SITE4, CL_TYPE4,
					CL_ON4, CL_OFF4, UC_TYPE4,
					UC_ON4, UC_OFF4, AL_ON4, AL_OFF4, OTHER_DEV4	
				);
			//, BodySystem, IsolateOrgan, Phx, PhxOther, ClinicalInfo
			if (CaseNum != null) {
				message = "ICU Culture created.";
				createAction = false;
				step = null;
			} else {
				errorMessage = "ICU Culture create fail.";
			}
		} else if (updateAction) {
			
			boolean success = false; 
			if (CaseNum != null) {
				//System.out.println("DIAG_IN_ICU_DATE1 " + DIAG_IN_ICU_DATE1);
				success = ICIcuDB.update( 
								userBean,
								HospAdmDate, LabNum, 
								HospNum, PatName, PatSex, PatBDate,
								Age, Month, Ward, RoomNum, 
								BedNum, DateIn,
								PREV_ICU_ADM, UNIT_TEAM, TRANSFER_FROM, ICU_ADM_DATE, TRANS_OUT_DATE,
								DISC_DEST, DIAG_ON_ICU, BHX, UNDER_DISE, PREM_STAT, ALLERGY,
								DIAG_IN_ICU_DATE1, DIAG_ON_ICU_DESC1, DIAG_IN_ICU_DATE2, DIAG_ON_ICU_DESC2, DIAG_IN_ICU_DATE3, DIAG_ON_ICU_DESC3,
								DIAG_IN_ICU_DATE4, DIAG_ON_ICU_DESC4, DIAG_IN_ICU_DATE5, DIAG_ON_ICU_DESC5, DIAG_IN_ICU_DATE6, DIAG_ON_ICU_DESC6,
								DIAG_IN_ICU_DATE7, DIAG_ON_ICU_DESC7, DIAG_IN_ICU_DATE8, DIAG_ON_ICU_DESC8, DIAG_IN_ICU_DATE9, DIAG_ON_ICU_DESC9,
								DEV_INF, VAP1, CABSI11, CAUT1,
								INFECT_DATE1, DEVICE_ONOFF_DATE1, DEVICE_DAY1,
								VAP2, CABSI12, CAUT2,
								INFECT_DATE2, DEVICE_ONOFF_DATE2, DEVICE_DAY2,
								SS1, LAB_EVID1, TREATMENT1, SS2, LAB_EVID2, TREATMENT2,
								SI_DATE1, SI_DESC1, AIRWAY1,
								VENT_ON1, VENT_OFF1, CL_SITE1, CL_TYPE1,
								CL_ON1, CL_OFF1, UC_TYPE1,
								UC_ON1, UC_OFF1, AL_ON1, AL_OFF1, OTHER_DEV1,		
								SI_DATE2, SI_DESC2, AIRWAY2,
								VENT_ON2, VENT_OFF2, CL_SITE2, CL_TYPE2,
								CL_ON2, CL_OFF2, UC_TYPE2,
								UC_ON2, UC_OFF2, AL_ON2, AL_OFF2, OTHER_DEV2,
								SI_DATE3, SI_DESC3, AIRWAY3,
								VENT_ON3, VENT_OFF3, CL_SITE3, CL_TYPE3,
								CL_ON3, CL_OFF3, UC_TYPE3,
								UC_ON3, UC_OFF3, AL_ON3, AL_OFF3, OTHER_DEV3,
								SI_DATE4, SI_DESC4, AIRWAY4,
								VENT_ON4, VENT_OFF4, CL_SITE4, CL_TYPE4,
								CL_ON4, CL_OFF4, UC_TYPE4,
								UC_ON4, UC_OFF4, AL_ON4, AL_OFF4, OTHER_DEV4,							
								icType,								 											
								CaseNum 
							);
			}

			if (success) {	// do update
				message = "ICU updated.";
				updateAction = false;
				step = null;
			} else {
				errorMessage = "ICU update fail.";
			}		
		
		} else if (deleteAction) {
			boolean success = ICIcuDB.delete(userBean, CaseNum ); 
			
			if (success) {	
				message = "ICU Culture removed.";
				closeAction = true;
			} else {
				errorMessage = "ICU Culture remove fail.";
			}
		}
	} else if (createAction) {
		// start new record for insert
		nurobDeliDateDate = DateTimeUtil.getCurrentDate();
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (CaseNum != null && CaseNum.length() > 0) {
			ArrayList record = ICIcuDB.get(CaseNum);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
		
				CaseNum = row.getValue(1);
				HospAdmDate = row.getValue(2);
				LabNum = row.getValue(3);
				HospNum = row.getValue(4);				
				PatName = row.getValue(5);
				PatSex = row.getValue(6);				
				PatBDate = row.getValue(7);
				Age = row.getValue(8);
				Month = row.getValue(9);
				Ward = row.getValue(10);
				RoomNum = row.getValue(11);
				BedNum = row.getValue(12); 
				DateIn = row.getValue(13);
				PREV_ICU_ADM = row.getValue(14);
				UNIT_TEAM = row.getValue(15);
				TRANSFER_FROM = row.getValue(16);
				ICU_ADM_DATE = row.getValue(17);
				TRANS_OUT_DATE = row.getValue(18);
				DISC_DEST = row.getValue(19);
				DIAG_ON_ICU = row.getValue(20);
				BHX = row.getValue(21);
				UNDER_DISE = row.getValue(22);
				PREM_STAT = row.getValue(23);
				ALLERGY = row.getValue(24);
				DIAG_IN_ICU_DATE1 = row.getValue(25);
				DIAG_ON_ICU_DESC1 = row.getValue(26);
				DIAG_IN_ICU_DATE2 = row.getValue(27);
				DIAG_ON_ICU_DESC2 = row.getValue(28); 
				DIAG_IN_ICU_DATE3 = row.getValue(29);
				DIAG_ON_ICU_DESC3 = row.getValue(30); 
				DIAG_IN_ICU_DATE4 = row.getValue(31);
				DIAG_ON_ICU_DESC4 = row.getValue(32); 
				DIAG_IN_ICU_DATE5 = row.getValue(33);
				DIAG_ON_ICU_DESC5 = row.getValue(34);
				DIAG_IN_ICU_DATE6 = row.getValue(35);
				DIAG_ON_ICU_DESC6 = row.getValue(36); 
				DIAG_IN_ICU_DATE7 = row.getValue(37);
				DIAG_ON_ICU_DESC7 = row.getValue(38); 
				DIAG_IN_ICU_DATE8 = row.getValue(39);
				DIAG_ON_ICU_DESC8 = row.getValue(40); 
				DIAG_IN_ICU_DATE9 = row.getValue(41);
				DIAG_ON_ICU_DESC9 = row.getValue(42);				
				DEV_INF = row.getValue(43);
				VAP1 = row.getValue(44);
				CABSI11 = row.getValue(45);
				CAUT1 = row.getValue(46);
				INFECT_DATE1 = row.getValue(47);
				DEVICE_ONOFF_DATE1 = row.getValue(48);
				DEVICE_DAY1 = row.getValue(49);
				VAP2 = row.getValue(50);
				CABSI12 = row.getValue(51);
				CAUT2 = row.getValue(52);
				INFECT_DATE2 = row.getValue(53);
				DEVICE_ONOFF_DATE2 = row.getValue(54);
				DEVICE_DAY2 = row.getValue(55);
				SS1 = row.getValue(56);
				LAB_EVID1 = row.getValue(57);
				TREATMENT1 = row.getValue(58);
				SS2 = row.getValue(59);
				LAB_EVID2 = row.getValue(60);
				TREATMENT2 = row.getValue(61);
				SI_DATE1 = row.getValue(62);
				SI_DESC1 = row.getValue(63);
				AIRWAY1 = row.getValue(64);
				VENT_ON1 = row.getValue(65);
				VENT_OFF1 = row.getValue(66);
				CL_SITE1 = row.getValue(67);
				CL_TYPE1 = row.getValue(68);
				CL_ON1 = row.getValue(69);
				CL_OFF1 = row.getValue(70);				
				UC_TYPE1 = row.getValue(71);
				UC_ON1 = row.getValue(72);
				UC_OFF1 = row.getValue(73);				
				AL_ON1 = row.getValue(74);
				AL_OFF1 = row.getValue(75);				
				OTHER_DEV1 = row.getValue(76);
				//
				SI_DATE2 = row.getValue(77);
				SI_DESC2 = row.getValue(78);
				AIRWAY2 = row.getValue(79);
				VENT_ON2 = row.getValue(80);
				VENT_OFF2 = row.getValue(81);				
				CL_SITE2 = row.getValue(82);
				CL_TYPE2 = row.getValue(83);
				CL_ON2 = row.getValue(84);
				CL_OFF2 = row.getValue(85);				
				UC_TYPE2 = row.getValue(86);
				UC_ON2 = row.getValue(87);
				UC_OFF2 = row.getValue(88);				
				AL_ON2 = row.getValue(89);
				AL_OFF2 = row.getValue(90);				
				OTHER_DEV2 = row.getValue(91);
				//
				SI_DATE3 = row.getValue(92);
				SI_DESC3 = row.getValue(93);
				AIRWAY3 = row.getValue(94);
				VENT_ON3 = row.getValue(95);
				VENT_OFF3 = row.getValue(96);				
				CL_SITE3 = row.getValue(97);
				CL_TYPE3 = row.getValue(98);
				CL_ON3 = row.getValue(99);
				CL_OFF3 = row.getValue(100);				
				UC_TYPE3 = row.getValue(101);
				UC_ON3 = row.getValue(102);
				UC_OFF3 = row.getValue(103);				
				AL_ON3 = row.getValue(104);
				AL_OFF3 = row.getValue(105);				
				OTHER_DEV3 = row.getValue(106);
				//
				SI_DATE4 = row.getValue(107);
				SI_DESC4 = row.getValue(108);
				AIRWAY4 = row.getValue(109);
				VENT_ON4 = row.getValue(110);
				VENT_OFF4 = row.getValue(111);				
				CL_SITE4 = row.getValue(112);
				CL_TYPE4 = row.getValue(113);
				CL_ON4 = row.getValue(114);
				CL_OFF4 = row.getValue(115);
				UC_TYPE4 = row.getValue(116);
				UC_ON4 = row.getValue(117);
				UC_OFF4 = row.getValue(118);
				AL_ON4 = row.getValue(119);
				AL_OFF4 = row.getValue(120);
				OTHER_DEV4 = row.getValue(121);
				//																
			} else {
				message = "ICU record does not exist.";
				closeAction = true;
			}
		} else {
			closeAction = true;
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<div id=indexWrapper>
<div id=mainFrame> 
<div id=contentFrame>
<%
	String title = null;
	String pageTitle = null;
	String commandType = null;
	String mustLogin = "Y";
	if (createAction) {
		commandType = "create";
		// can create by guest
		mustLogin = "N";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else { 
		commandType = "view";
	}
	
	//System.out.println("Hello !!! " + icType + " " + commandType );
	// set submit label
	title = "function.ic.icu." + commandType;
	if ("icu".equals(icType)) {
		pageTitle = "Surveillance Form in ICU";
	} else if ("resp".equals(icType)) {
		pageTitle = "RESP";
	} else {
		pageTitle = "Error Title passing !";
	}
	
	String accessControl = "Y";
	if (ConstantsServerSide.DEBUG) {
		accessControl = "N";
	} 
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="mustLogin" value="<%=mustLogin %>" />
	<jsp:param name="accessControl" value="<%=accessControl %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<% if (!closeAction) { %>
<form name="form1" id="form1" action="<html:rewrite page="/ic/icu.jsp" />" method="post">
<div class="pane">
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
	<%	if (createAction || updateAction || deleteAction) { %>
				<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /></button>
	<%		if (!createAction) { %>
				<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
	<%		}  %>
	<%	} else { %>
				<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="button.update" /></button>
				<button class="btn-delete"><bean:message key="button.delete" /></button>
	<%	}  %>
			</td>
		</tr>
	</table>
</div>
<%	//if (!createAction) { %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="10%">Case No.</td>
		<td class="infoData" width="20%"><%=CaseNum == null ? "" : (createAction ? "New" : CaseNum) %></td>
	<td class="infoLabel" width="15%">Hosp. Adm. Date</td>
		<td class="infoData"" width="70%" colspan="3">
<%	if (createAction || updateAction) { %>
			<input type="text" name="HospAdmDate" id="HospAdmDate" class="datepickerfield" value="<%=HospAdmDate == null ? "" : HospAdmDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)			
<%	} else { %>
			<%=HospAdmDate == null ? "" : HospAdmDate %>
<%	} %>
    </td>
	</tr>
</table>
<% //} %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%">Lab No.</td>
		<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="LabNum" name="LabNum" value="<%=LabNum == null ? "" : LabNum %>" maxlength="8" size="15" />
	<%	} else { %>
			<%=LabNum == null ? "" : LabNum %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Reg Date</td>
		<td class="infoData"" width="70%" colspan="3">
<%	if (createAction || updateAction) { %>
			<span id="DateIn_span"><%=DateIn == null ? "" : DateIn %></span>
<%	} else { %>
			<%=DateIn == null ? "" : DateIn %>
<%	} %></td>	
	</tr>
	<tr>		
		<td class="infoLabel" width="15%">Hosp. No.</td>
		<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<span id="HospNum_span"><%=HospNum == null ? "" : HospNum %></span>
	<%	} else { %>
			<%=HospNum == null ? "" : HospNum %>
<%	} %>
		</td>		
		<td class="infoLabel" width="10%">Patient Name</td>
		<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<span id="PatName_span"><%=PatName == null ? "" : PatName %></span>
	<%	} else { %>
			<%=PatName == null ? "" : PatName %>
<%	} %>    
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Gender</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="PatSex_span"><%=PatSex == null ? "" : PatSex %></span>
	<%	} else { %>
			<%=PatSex == null ? "" : PatSex %>
<%	} %>    
		</td>
		<td class="infoLabel" width="15%">Birthdate</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="PatBDate_span"><%=PatBDate == null ? "" : PatBDate %></span>
<%	} else { %>
			<%=PatBDate == null ? "" : PatBDate %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Age</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="Age_span"><%=Age == null ? "" : Age %></span>
<%	} else { %>
			<%=Age == null ? "" : Age %>
<%	} %>
		</td>		
		<td class="infoLabel" width="15%">Month</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="Month_span"><%=Month == null ? "" : Month %></span>
<%	} else { %>
			<%=Month == null ? "" : Month %>
<%	} %>
		</td>		
	</tr>
	<tr>
		<td class="infoLabel" width="15%">Ward</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="Ward_span"><%=Ward == null ? "" : Ward %></span>
<%	} else { %>
			<%=Ward == null ? "" : Ward %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">RoomNum</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="RoomNum_span"><%=RoomNum == null ? "" : RoomNum %></span>
<%	} else { %>
			<%=RoomNum == null ? "" : RoomNum %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">BedNum</td>
		<td class="infoData" width="35%">
<%	if (createAction || updateAction) { %>
			<span id="BedNum_span"><%=BedNum == null ? "" : BedNum %></span>
<%	} else { %>
			<%=BedNum == null ? "" : BedNum %>
<%	} %>
		</td>
	</tr>

	<tr class="smallText">
		<td class="infoLabel" width="15%">Previous ICU adm </td>
		<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="PREV_ICU_ADM" name="PREV_ICU_ADM" value="<%=PREV_ICU_ADM == null ? "" : PREV_ICU_ADM %>" maxlength="50" size="15" />
	<%	} else { %>
			<%=PREV_ICU_ADM == null ? "" : PREV_ICU_ADM  %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Unit/Team</td>
		<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="UNIT_TEAM" name="UNIT_TEAM" value="<%=UNIT_TEAM == null ? "" : UNIT_TEAM %>" maxlength="50" size="15" />
	<%	} else { %>
			<%=UNIT_TEAM  == null ? "" : UNIT_TEAM  %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Transfer From</td>
		<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="TRANSFER_FROM" name="TRANSFER_FROM" value="<%=TRANSFER_FROM == null ? "" : TRANSFER_FROM %>" maxlength="50" size="15" />
	<%	} else { %>
			<%=TRANSFER_FROM  == null ? "" : TRANSFER_FROM  %>
<%	} %>
		</td>
	</tr>
	<tr>
	<td class="infoLabel" width="15%">ICU Adm. Date</td>
		<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="ICU_ADM_DATE" id="ICU_ADM_DATE" class="datepickerfield" value="<%=ICU_ADM_DATE == null ? "" : ICU_ADM_DATE %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)			
<%	} else { %>
			<%=ICU_ADM_DATE == null ? "" : ICU_ADM_DATE %>
<%	} %>
    </td>
	<td class="infoLabel" width="15%">Transfer out Date</td>
		<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="TRANS_OUT_DATE" id="TRANS_OUT_DATE" class="datepickerfield" value="<%=TRANS_OUT_DATE == null ? "" : TRANS_OUT_DATE %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)			
<%	} else { %>
			<%=TRANS_OUT_DATE == null ? "" : TRANS_OUT_DATE %>
<%	} %>
    </td>
   	<td class="infoLabel" width="15%">Discharge Destination</td>
	<td class="infoData" width="17%">
	<%	if (createAction || updateAction) { %>
		<select name="DISC_DEST">
			<option value="D"<%="D".equals(DISC_DEST)?" selected":"" %>>Died</option>
			<option value="H"<%="H".equals(DISC_DEST)?" selected":"" %>>Home</option>
			<option value="G"<%="G".equals(DISC_DEST)?" selected":"" %>>General Ward</option>				
			<option value="O"<%="O".equals(DISC_DEST)?" selected":"" %>>Other Hospital</option>				
		</select>
	<%	} else { %>
		<%
			if ("D".equals(DISC_DEST)) {
		%>
			Died
		<%	
			} else if ("H".equals(DISC_DEST)) {
		%>
			Home
		<%
			} else if ("G".equals(DISC_DEST)) {
		%>
			General Ward
		<%
			} else if ("O".equals(DISC_DEST)) {
		%>
			Other Hospital
		<%	
			}
		%>
	<%	} %>
	</td>        
  </tr>
<tr class="smallText">    
	<td class="infoLabel" width="30%">Diagnosis on ICU admission</td>		 
  	<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="DIAG_ON_ICU" rows="3" cols="50"><%=DIAG_ON_ICU==null?"":DIAG_ON_ICU %></textarea>
  			</div>
<%	} else { %>			
			<%=DIAG_ON_ICU == null ? "" : DIAG_ON_ICU %>
<%	} %>
  	</td>
	<td class="infoLabel" width="30%">BHx</td>	 
  	<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="BHX" rows="3" cols="50"><%=BHX==null?"":BHX %></textarea>
  			</div>
<%	} else { %>			
			<%=BHX == null ? "" : BHX %>
<%	} %>
  	</td>  	
  </tr>
  <tr>
	<td class="infoLabel" width="30%">Underlying disease</td>	 
  	<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="UNDER_DISE" rows="3" cols="50"><%=UNDER_DISE==null?"":UNDER_DISE %></textarea>
  			</div>
<%	} else { %>			
			<%=UNDER_DISE == null ? "" : UNDER_DISE %>
<%	} %>
  	</td>
  	<td class="infoLabel" width="30%">Premorbid status</td>	 
  	<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="PREM_STAT" rows="3" cols="50"><%=PREM_STAT==null?"":PREM_STAT %></textarea>
  			</div>
<%	} else { %>			
			<%=PREM_STAT == null ? "" : PREM_STAT %>
<%	} %>
  	</td>    	  
  </tr>
  <tr>
	<td class="infoLabel" width="15%">Allergy</td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
		<input type="text" id="ALLERGY" name="ALLERGY" value="<%=ALLERGY == null ? "" : ALLERGY %>" maxlength="50" size="60" />
	<%	} else { %>
		<%=ALLERGY  == null ? "" : ALLERGY  %>
<%	} %>
	</td>  
  </tr>
  <tr><td>
  

   
  <input type="hidden" id="HospNum" name="HospNum" value="<%=HospNum == null ? "" : HospNum %>" maxlength="12" size="15" />
  <input type="hidden" id="PatName" name="PatName" value="<%=PatName == null ? "" : PatName %>" maxlength="100" size="15" />
  <input type="hidden" id="PatSex" name="PatSex" value="<%=PatSex == null ? "" : PatSex %>" maxlength="100" size="15" />
  <input type="hidden" id="PatBDate" name="PatBDate" value="<%=PatBDate == null ? "" : PatBDate %>" maxlength="100" size="15" />  
  <input type="hidden" id="Age" name="Age" value="<%=Age == null ? "" : Age %>" maxlength="100" size="15" />
  <input type="hidden" id="Month" name="Month" value="<%=Month == null ? "" : Month %>" maxlength="100" size="15" />    
  <input type="hidden" id="Ward" name="Ward" value="<%=Ward == null ? "" : Ward %>" maxlength="100" size="15" />					
  <input type="hidden" id="RoomNum" name="RoomNum" value="<%=RoomNum == null ? "" : RoomNum %>" maxlength="100" size="15" />		 
  <input type="hidden" id="BedNum" name="BedNum" value="<%=BedNum == null ? "" : BedNum %>" maxlength="100" size="15" />			 
  <input type="hidden" id="DateIn" name="DateIn" value="<%=DateIn == null ? "" : DateIn %>" maxlength="100" size="15" />
  <input type="hidden" name="icType" value="<%=icType %>" />			
  </td></tr> 
</table>
  
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	
	<b>Diagnosis in ICU</b>
	<hr style="color:red"></hr>	
  <tr>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="DIAG_IN_ICU_DATE1" id="DIAG_IN_ICU_DATE1" class="datepickerfield" value="<%=DIAG_IN_ICU_DATE1 == null ? "" : DIAG_IN_ICU_DATE1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
<%	} else { %>
			<%=DIAG_IN_ICU_DATE1 == null ? "" : DIAG_IN_ICU_DATE1 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="DIAG_ON_ICU_DESC1" name="DIAG_ON_ICU_DESC1" value="<%=DIAG_ON_ICU_DESC1 == null ? "" : DIAG_ON_ICU_DESC1 %>" maxlength="50" size="90" />
	<%	} else { %>
			<%=DIAG_ON_ICU_DESC1  == null ? "" : DIAG_ON_ICU_DESC1 %>
<%	} %>
	</td>
  </tr>
  <tr>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="DIAG_IN_ICU_DATE2" id="DIAG_IN_ICU_DATE2" class="datepickerfield" value="<%=DIAG_IN_ICU_DATE2 == null ? "" : DIAG_IN_ICU_DATE2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />	
<%	} else { %>
			<%=DIAG_IN_ICU_DATE2 == null ? "" : DIAG_IN_ICU_DATE2 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="DIAG_ON_ICU_DESC2" name="DIAG_ON_ICU_DESC2" value="<%=DIAG_ON_ICU_DESC2 == null ? "" : DIAG_ON_ICU_DESC2 %>" maxlength="50" size="90" />
	<%	} else { %>
			<%=DIAG_ON_ICU_DESC2  == null ? "" : DIAG_ON_ICU_DESC2 %>
<%	} %>
	</td>
  </tr>
  <tr>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="DIAG_IN_ICU_DATE3" id="DIAG_IN_ICU_DATE3" class="datepickerfield" value="<%=DIAG_IN_ICU_DATE3 == null ? "" : DIAG_IN_ICU_DATE3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />	
<%	} else { %>
			<%=DIAG_IN_ICU_DATE3 == null ? "" : DIAG_IN_ICU_DATE3 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="DIAG_ON_ICU_DESC3" name="DIAG_ON_ICU_DESC3" value="<%=DIAG_ON_ICU_DESC3 == null ? "" : DIAG_ON_ICU_DESC3 %>" maxlength="50" size="90" />
	<%	} else { %>
			<%=DIAG_ON_ICU_DESC3  == null ? "" : DIAG_ON_ICU_DESC3 %>
<%	} %>
	</td>
  </tr>
  <tr>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="DIAG_IN_ICU_DATE4" id="DIAG_IN_ICU_DATE4" class="datepickerfield" value="<%=DIAG_IN_ICU_DATE4 == null ? "" : DIAG_IN_ICU_DATE4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=DIAG_IN_ICU_DATE4 == null ? "" : DIAG_IN_ICU_DATE4 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="DIAG_ON_ICU_DESC4" name="DIAG_ON_ICU_DESC4" value="<%=DIAG_ON_ICU_DESC4 == null ? "" : DIAG_ON_ICU_DESC4 %>" maxlength="50" size="90" />
	<%	} else { %>
			<%=DIAG_ON_ICU_DESC4  == null ? "" : DIAG_ON_ICU_DESC4 %>
<%	} %>
	</td>
  </tr>
  <tr>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="DIAG_IN_ICU_DATE5" id="DIAG_IN_ICU_DATE5" class="datepickerfield" value="<%=DIAG_IN_ICU_DATE5 == null ? "" : DIAG_IN_ICU_DATE5 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=DIAG_IN_ICU_DATE5 == null ? "" : DIAG_IN_ICU_DATE5 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="DIAG_ON_ICU_DESC5" name="DIAG_ON_ICU_DESC5" value="<%=DIAG_ON_ICU_DESC5 == null ? "" : DIAG_ON_ICU_DESC5 %>" maxlength="50" size="90" />
	<%	} else { %>
			<%=DIAG_ON_ICU_DESC5  == null ? "" : DIAG_ON_ICU_DESC5 %>
<%	} %>
	</td>
  </tr>
 <tr>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="DIAG_IN_ICU_DATE6" id="DIAG_IN_ICU_DATE6" class="datepickerfield" value="<%=DIAG_IN_ICU_DATE6 == null ? "" : DIAG_IN_ICU_DATE6 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
<%	} else { %>
			<%=DIAG_IN_ICU_DATE6 == null ? "" : DIAG_IN_ICU_DATE6 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="DIAG_ON_ICU_DESC6" name="DIAG_ON_ICU_DESC6" value="<%=DIAG_ON_ICU_DESC6 == null ? "" : DIAG_ON_ICU_DESC6 %>" maxlength="50" size="90" />
	<%	} else { %>
			<%=DIAG_ON_ICU_DESC6  == null ? "" : DIAG_ON_ICU_DESC6 %>
<%	} %>
	</td>
  </tr>
   <tr>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="DIAG_IN_ICU_DATE7" id="DIAG_IN_ICU_DATE7" class="datepickerfield" value="<%=DIAG_IN_ICU_DATE7 == null ? "" : DIAG_IN_ICU_DATE7 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />	
<%	} else { %>
			<%=DIAG_IN_ICU_DATE7 == null ? "" : DIAG_IN_ICU_DATE7 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="DIAG_ON_ICU_DESC7" name="DIAG_ON_ICU_DESC7" value="<%=DIAG_ON_ICU_DESC7 == null ? "" : DIAG_ON_ICU_DESC7 %>" maxlength="50" size="90" />
	<%	} else { %>
			<%=DIAG_ON_ICU_DESC7  == null ? "" : DIAG_ON_ICU_DESC7 %>
<%	} %>
	</td>
  </tr>
   <tr>
  <td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="DIAG_IN_ICU_DATE8" id="DIAG_IN_ICU_DATE8" class="datepickerfield" value="<%=DIAG_IN_ICU_DATE8 == null ? "" : DIAG_IN_ICU_DATE8 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=DIAG_IN_ICU_DATE8 == null ? "" : DIAG_IN_ICU_DATE8 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="DIAG_ON_ICU_DESC8" name="DIAG_ON_ICU_DESC8" value="<%=DIAG_ON_ICU_DESC8 == null ? "" : DIAG_ON_ICU_DESC8 %>" maxlength="50" size="90" />
	<%	} else { %>
			<%=DIAG_ON_ICU_DESC8  == null ? "" : DIAG_ON_ICU_DESC8 %>
<%	} %>
	</td>
  </tr>
 <tr>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="DIAG_IN_ICU_DATE9" id="DIAG_IN_ICU_DATE9" class="datepickerfield" value="<%=DIAG_IN_ICU_DATE9 == null ? "" : DIAG_IN_ICU_DATE9 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=DIAG_IN_ICU_DATE9 == null ? "" : DIAG_IN_ICU_DATE9 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="DIAG_ON_ICU_DESC9" name="DIAG_ON_ICU_DESC9" value="<%=DIAG_ON_ICU_DESC9 == null ? "" : DIAG_ON_ICU_DESC9 %>" maxlength="50" size="90" />
	<%	} else { %>
			<%=DIAG_ON_ICU_DESC9  == null ? "" : DIAG_ON_ICU_DESC9 %>
<%	} %>
	</td>
  </tr>
 </table>
 
 <table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	
	<b>Surgical intervention (OT, OGD, etc...)</b>
	<hr style="color:red"></hr>
 
 	<tr>
 	<td class="infoLabel" width="15%">Date</td>
 	<td class="infoLabel" width="15%">             </td>
	<td class="infoLabel" width="15%">Airway</td> 		
	<td class="infoLabel" width="15%">Ventilator On</td>	
	<td class="infoLabel" width="15%">Off</td>
	<td class="infoLabel" width="15%">Central line Site</td>	
	<td class="infoLabel" width="15%">Type</td>
	<td class="infoLabel" width="15%">On</td>
	<td class="infoLabel" width="15%">Off</td>
	<td class="infoLabel" width="15%">Urinary cather Type</td>
	<td class="infoLabel" width="15%">On</td>
	<td class="infoLabel" width="15%">Off</td>	
	<td class="infoLabel" width="15%">A-line On</td>
	<td class="infoLabel" width="15%">Off</td>	
	<td class="infoLabel" width="15%">Device</td>		
 	</tr>
 <tr>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="SI_DATE1" id="SI_DATE1" class="datepickerfield" value="<%=SI_DATE1 == null ? "" : SI_DATE1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=SI_DATE1 == null ? "" : SI_DATE1 %>
<%	} %>
    </td>    
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="SI_DESC1" name="SI_DESC1" value="<%=SI_DESC1 == null ? "" : SI_DESC1 %>" maxlength="30" size="30" />
	<%	} else { %>
			<%=SI_DESC1  == null ? "" : SI_DESC1 %>
<%	} %>
	</td>	
	<td class="infoData" width="10%">
	<%	if (createAction || updateAction) { %>
		<select name="AIRWAY1">
			<option value=""></option>
			<option value="N"<%="N".equals(AIRWAY1)?" selected":"" %>>NETT</option>
			<option value="O"<%="O".equals(AIRWAY1)?" selected":"" %>>OETT</option>
			<option value="T"<%="T".equals(AIRWAY1)?" selected":"" %>>TT</option>			
		</select>
	<%	} else { %>
		<%
			if ("N".equals(AIRWAY1)) {
		%>
			NETT
		<%	
			} else if ("O".equals(AIRWAY1)) {
		%>
			OETT
		<%
			} else if ("T".equals(AIRWAY1)) {
		%>
			TT
		<%		
			}
		%>
	<%	} %>
	</td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="VENT_ON1" id="VENT_ON1" class="datepickerfield" value="<%=VENT_ON1 == null ? "" : VENT_ON1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=VENT_ON1 == null ? "" : VENT_ON1 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="VENT_OFF1" id="VENT_OFF1" class="datepickerfield" value="<%=VENT_OFF1 == null ? "" : VENT_OFF1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=VENT_OFF1 == null ? "" : VENT_OFF1 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="CL_SITE1" name="CL_SITE1" value="<%=CL_SITE1 == null ? "" : CL_SITE1 %>" maxlength="10" size="20" />
	<%	} else { %>
			<%=CL_SITE1  == null ? "" : CL_SITE1 %>
<%	} %>
	</td>        
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="CL_TYPE1" name="CL_TYPE1" value="<%=CL_TYPE1 == null ? "" : CL_TYPE1 %>" maxlength="10" size="20" />
	<%	} else { %>
			<%=CL_TYPE1  == null ? "" : CL_TYPE1 %>
<%	} %>
	</td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="CL_ON1" id="CL_ON1" class="datepickerfield" value="<%=CL_ON1 == null ? "" : CL_ON1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=CL_ON1 == null ? "" : CL_ON1 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="CL_OFF1" id="CL_ON2" class="datepickerfield" value="<%=CL_OFF1 == null ? "" : CL_OFF1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=CL_OFF1 == null ? "" : CL_OFF1 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="UC_TYPE1" name="UC_TYPE1" value="<%=UC_TYPE1 == null ? "" : UC_TYPE1 %>" maxlength="10" size="20" />
	<%	} else { %>
			<%=UC_TYPE1  == null ? "" : UC_TYPE1 %>
<%	} %>
	</td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="UC_ON1" id="UC_ON1" class="datepickerfield" value="<%=UC_ON1 == null ? "" : UC_ON1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=UC_ON1 == null ? "" : UC_ON1 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="UC_OFF1" id="UC_OFF1" class="datepickerfield" value="<%=UC_OFF1 == null ? "" : UC_OFF1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=UC_OFF1 == null ? "" : UC_OFF1 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="AL_ON1" id="AL_ON1" class="datepickerfield" value="<%=AL_ON1 == null ? "" : AL_ON1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=AL_ON1 == null ? "" : AL_ON1 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="AL_OFF1" id="AL_OFF1" class="datepickerfield" value="<%=AL_OFF1 == null ? "" : AL_OFF1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=AL_OFF1 == null ? "" : AL_OFF1 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="OTHER_DEV1" name="OTHER_DEV1" value="<%=OTHER_DEV1 == null ? "" : OTHER_DEV1 %>" maxlength="30" size="30" />
	<%	} else { %>
			<%=OTHER_DEV1  == null ? "" : OTHER_DEV1 %>
<%	} %>
	</td>
  </tr>	 
 <tr>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="SI_DATE2" id="SI_DATE2" class="datepickerfield" value="<%=SI_DATE2 == null ? "" : SI_DATE2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=SI_DATE2 == null ? "" : SI_DATE2 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="SI_DESC2" name="SI_DESC2" value="<%=SI_DESC2 == null ? "" : SI_DESC2 %>" maxlength="30" size="30" />
	<%	} else { %>
			<%=SI_DESC2 == null ? "" : SI_DESC2 %>
<%	} %>
	</td>	
	<td class="infoData" width="10%">
	<%	if (createAction || updateAction) { %>
		<select name="AIRWAY2">
			<option value=""></option>
			<option value="N"<%="N".equals(AIRWAY2)?" selected":"" %>>NETT</option>
			<option value="O"<%="O".equals(AIRWAY2)?" selected":"" %>>OETT</option>
			<option value="T"<%="T".equals(AIRWAY2)?" selected":"" %>>TT</option>			
		</select>
	<%	} else { %>
		<%
			if ("N".equals(AIRWAY2)) {
		%>
			NETT
		<%	
			} else if ("O".equals(AIRWAY2)) {
		%>
			OETT
		<%
			} else if ("T".equals(AIRWAY2)) {
		%>
			TT
		<%		
			}
		%>
	<%	} %>
	</td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="VENT_ON2" id="VENT_ON2" class="datepickerfield" value="<%=VENT_ON2 == null ? "" : VENT_ON2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=VENT_ON2 == null ? "" : VENT_ON2 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="VENT_OFF2" id="VENT_OFF2" class="datepickerfield" value="<%=VENT_OFF2 == null ? "" : VENT_OFF2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=VENT_OFF2 == null ? "" : VENT_OFF2 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="CL_SITE2" name="CL_SITE2" value="<%=CL_SITE2 == null ? "" : CL_SITE2 %>" maxlength="10" size="20" />
	<%	} else { %>
			<%=CL_SITE2  == null ? "" : CL_SITE2 %>
<%	} %>
	</td>        
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="CL_TYPE2" name="CL_TYPE2" value="<%=CL_TYPE2 == null ? "" : CL_TYPE2 %>" maxlength="10" size="20" />
	<%	} else { %>
			<%=CL_TYPE2  == null ? "" : CL_TYPE2 %>
<%	} %>
	</td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="CL_ON2" id="CL_ON2" class="datepickerfield" value="<%=CL_ON2 == null ? "" : CL_ON2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=CL_ON2 == null ? "" : CL_ON2 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="CL_OFF2" id="CL_ON2" class="datepickerfield" value="<%=CL_OFF2 == null ? "" : CL_OFF2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=CL_OFF2 == null ? "" : CL_OFF2 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="UC_TYPE2" name="UC_TYPE2" value="<%=UC_TYPE2 == null ? "" : UC_TYPE2 %>" maxlength="10" size="20" />
	<%	} else { %>
			<%=UC_TYPE2  == null ? "" : UC_TYPE2 %>
<%	} %>
	</td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="UC_ON2" id="UC_ON2" class="datepickerfield" value="<%=UC_ON2 == null ? "" : UC_ON2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=UC_ON2 == null ? "" : UC_ON2 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="UC_OFF2" id="UC_OFF2" class="datepickerfield" value="<%=UC_OFF2 == null ? "" : UC_OFF2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=UC_OFF2 == null ? "" : UC_OFF2 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="AL_ON2" id="AL_ON2" class="datepickerfield" value="<%=AL_ON2 == null ? "" : AL_ON2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=AL_ON2 == null ? "" : AL_ON2 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="AL_OFF2" id="AL_OFF2" class="datepickerfield" value="<%=AL_OFF2 == null ? "" : AL_OFF2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=AL_OFF2 == null ? "" : AL_OFF2 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="OTHER_DEV2" name="OTHER_DEV2" value="<%=OTHER_DEV2 == null ? "" : OTHER_DEV2 %>" maxlength="30" size="30" />
	<%	} else { %>
			<%=OTHER_DEV2  == null ? "" : OTHER_DEV2 %>
<%	} %>
	</td>     
  </tr>	 
 <tr>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="SI_DATE3" id="SI_DATE3" class="datepickerfield" value="<%=SI_DATE3 == null ? "" : SI_DATE3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=SI_DATE3 == null ? "" : SI_DATE3 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="SI_DESC3" name="SI_DESC3" value="<%=SI_DESC3 == null ? "" : SI_DESC3 %>" maxlength="30" size="30" />
	<%	} else { %>
			<%=SI_DESC3 == null ? "" : SI_DESC3 %>
<%	} %>
	</td>	
	<td class="infoData" width="10%">
	<%	if (createAction || updateAction) { %>
		<select name="AIRWAY3">
			<option value=""></option>
			<option value="N"<%="N".equals(AIRWAY3)?" selected":"" %>>NETT</option>
			<option value="O"<%="O".equals(AIRWAY3)?" selected":"" %>>OETT</option>
			<option value="T"<%="T".equals(AIRWAY3)?" selected":"" %>>TT</option>			
		</select>
	<%	} else { %>
		<%
			if ("N".equals(AIRWAY3)) {
		%>
			NETT
		<%	
			} else if ("O".equals(AIRWAY3)) {
		%>
			OETT
		<%
			} else if ("T".equals(AIRWAY3)) {
		%>
			TT
		<%		
			}
		%>
	<%	} %>
	</td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="VENT_ON3" id="VENT_ON3" class="datepickerfield" value="<%=VENT_ON3 == null ? "" : VENT_ON3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=VENT_ON3 == null ? "" : VENT_ON3 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="VENT_OFF3" id="VENT_OFF3" class="datepickerfield" value="<%=VENT_OFF3 == null ? "" : VENT_OFF3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=VENT_OFF3 == null ? "" : VENT_OFF3 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="CL_SITE3" name="CL_SITE3" value="<%=CL_SITE3 == null ? "" : CL_SITE3 %>" maxlength="10" size="20" />
	<%	} else { %>
			<%=CL_SITE3  == null ? "" : CL_SITE3 %>
<%	} %>
	</td>        
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="CL_TYPE3" name="CL_TYPE3" value="<%=CL_TYPE3 == null ? "" : CL_TYPE3 %>" maxlength="10" size="20" />
	<%	} else { %>
			<%=CL_TYPE3  == null ? "" : CL_TYPE3 %>
<%	} %>
	</td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="CL_ON3" id="CL_ON3" class="datepickerfield" value="<%=CL_ON3 == null ? "" : CL_ON3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=CL_ON3 == null ? "" : CL_ON3 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="CL_OFF3" id="CL_OFF3" class="datepickerfield" value="<%=CL_OFF3 == null ? "" : CL_OFF3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=CL_OFF3 == null ? "" : CL_OFF3 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="UC_TYPE3" name="UC_TYPE3" value="<%=UC_TYPE3 == null ? "" : UC_TYPE3 %>" maxlength="10" size="20" />
	<%	} else { %>
			<%=UC_TYPE3  == null ? "" : UC_TYPE3 %>
<%	} %>
	</td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="UC_ON3" id="UC_ON3" class="datepickerfield" value="<%=UC_ON3 == null ? "" : UC_ON3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=UC_ON3 == null ? "" : UC_ON3 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="UC_OFF3" id="UC_OFF3" class="datepickerfield" value="<%=UC_OFF3 == null ? "" : UC_OFF3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=UC_OFF3 == null ? "" : UC_OFF3 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="AL_ON3" id="AL_ON3" class="datepickerfield" value="<%=AL_ON3 == null ? "" : AL_ON3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=AL_ON3 == null ? "" : AL_ON3 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="AL_OFF3" id="AL_OFF3" class="datepickerfield" value="<%=AL_OFF3 == null ? "" : AL_OFF3 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=AL_OFF3 == null ? "" : AL_OFF3 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="OTHER_DEV3" name="OTHER_DEV3" value="<%=OTHER_DEV3 == null ? "" : OTHER_DEV3 %>" maxlength="30" size="30" />
	<%	} else { %>
			<%=OTHER_DEV3  == null ? "" : OTHER_DEV3 %>
<%	} %>
	</td>     
  </tr>	 
 <tr>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="SI_DATE4" id="SI_DATE4" class="datepickerfield" value="<%=SI_DATE4 == null ? "" : SI_DATE4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=SI_DATE4 == null ? "" : SI_DATE4 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="SI_DESC4" name="SI_DESC4" value="<%=SI_DESC4 == null ? "" : SI_DESC4 %>" maxlength="30" size="30" />
	<%	} else { %>
			<%=SI_DESC4 == null ? "" : SI_DESC4 %>
<%	} %>
	</td>	
	<td class="infoData" width="10%">
	<%	if (createAction || updateAction) { %>
		<select name="AIRWAY4">
			<option value=""></option>
			<option value="N"<%="N".equals(AIRWAY4)?" selected":"" %>>NETT</option>
			<option value="O"<%="O".equals(AIRWAY4)?" selected":"" %>>OETT</option>
			<option value="T"<%="T".equals(AIRWAY4)?" selected":"" %>>TT</option>			
		</select>
	<%	} else { %>
		<%
			if ("N".equals(AIRWAY4)) {
		%>
			NETT
		<%	
			} else if ("O".equals(AIRWAY4)) {
		%>
			OETT
		<%
			} else if ("T".equals(AIRWAY4)) {
		%>
			TT
		<%		
			}
		%>
	<%	} %>
	</td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="VENT_ON4" id="VENT_ON4" class="datepickerfield" value="<%=VENT_ON4 == null ? "" : VENT_ON4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=VENT_ON4 == null ? "" : VENT_ON4 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="VENT_OFF4" id="VENT_OFF4" class="datepickerfield" value="<%=VENT_OFF4 == null ? "" : VENT_OFF4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=VENT_OFF4 == null ? "" : VENT_OFF4 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="CL_SITE4" name="CL_SITE4" value="<%=CL_SITE4 == null ? "" : CL_SITE4 %>" maxlength="10" size="20" />
	<%	} else { %>
			<%=CL_SITE4  == null ? "" : CL_SITE4 %>
<%	} %>
	</td>        
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="CL_TYPE4" name="CL_TYPE4" value="<%=CL_TYPE4 == null ? "" : CL_TYPE4 %>" maxlength="10" size="20" />
	<%	} else { %>
			<%=CL_TYPE4  == null ? "" : CL_TYPE4 %>
<%	} %>
	</td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="CL_ON4" id="CL_ON4" class="datepickerfield" value="<%=CL_ON4 == null ? "" : CL_ON4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=CL_ON4 == null ? "" : CL_ON4 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="CL_OFF4" id="CL_OFF4" class="datepickerfield" value="<%=CL_OFF4 == null ? "" : CL_OFF4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=CL_OFF4 == null ? "" : CL_OFF4 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="UC_TYPE4" name="UC_TYPE4" value="<%=UC_TYPE4 == null ? "" : UC_TYPE4 %>" maxlength="10" size="20" />
	<%	} else { %>
			<%=UC_TYPE4  == null ? "" : UC_TYPE4 %>
<%	} %>
	</td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="UC_ON4" id="UC_ON4" class="datepickerfield" value="<%=UC_ON4 == null ? "" : UC_ON4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=UC_ON4 == null ? "" : UC_ON4 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="UC_OFF4" id="UC_OFF4" class="datepickerfield" value="<%=UC_OFF4 == null ? "" : UC_OFF4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=UC_OFF4 == null ? "" : UC_OFF4 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="AL_ON4" id="AL_ON4" class="datepickerfield" value="<%=AL_ON4 == null ? "" : AL_ON4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=AL_ON4 == null ? "" : AL_ON4 %>
<%	} %>
    </td>
	<td class="infoData"" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" name="AL_OFF4" id="AL_OFF4" class="datepickerfield" value="<%=AL_OFF4 == null ? "" : AL_OFF4 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />			
<%	} else { %>
			<%=AL_OFF4 == null ? "" : AL_OFF4 %>
<%	} %>
    </td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
			<input type="text" id="OTHER_DEV4" name="OTHER_DEV4" value="<%=OTHER_DEV4 == null ? "" : OTHER_DEV4 %>" maxlength="30" size="30" />
	<%	} else { %>
			<%=OTHER_DEV4  == null ? "" : OTHER_DEV4 %>
<%	} %>
	</td>     
  </tr>
</table>

<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="10%">Device related infection in ICU</td>
		<td class="infoData" width="10%">
	<%	if (createAction || updateAction) { %>
		<select name="DEV_INF">
			<option value="Y"<%="Y".equals(DEV_INF)?" selected":"" %>>Yes</option>
			<option value="N"<%="N".equals(DEV_INF)?" selected":"" %>>No</option>				
		</select>
	<%	} else { %>
		<%
			if ("Y".equals(DEV_INF)) {
		%>
			Yes
		<%	
			} else if ("N".equals(DEV_INF)) {
		%>
			No
		<%
			}
		%>	
	<%	} %>
	</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="10%">VAP</td>
		<td class="infoData" width="10%">
	<%	if (createAction || updateAction) { %>
		<select name="VAP1">
			<option value="PNU1"<%="PNU1".equals(VAP1)?" selected":"" %>>PNU1</option>
			<option value="PNU2"<%="PNU2".equals(VAP1)?" selected":"" %>>PNU2</option>				
			<option value="PNU3"<%="PNU3".equals(VAP1)?" selected":"" %>>PNU3</option>			
		</select>
	<%	} else { %>
		<%
			if ("PNU1".equals(VAP1)) {
		%>
			PNU1
		<%	
			} else if ("PNU2".equals(VAP1)) {
		%>
			PNU2
		<%	
			} else if ("PNU3".equals(VAP1)) {
		%>
			PNU3
		<%
			}
		%>	
	<%	} %>
	</td>
	<td class="infoLabel" width="10%">CABSI</td>
		<td class="infoData" width="10%">
	<%	if (createAction || updateAction) { %>
		<select name="CABSI11">
			<option value="C1"<%="C1".equals(CABSI11)?" selected":"" %>>C1</option>
			<option value="C2a"<%="C2a".equals(CABSI11)?" selected":"" %>>C2a</option>				
			<option value="C2b"<%="C2b".equals(CABSI11)?" selected":"" %>>C2b</option>			
			<option value="CSEP"<%="CSEP".equals(CABSI11)?" selected":"" %>>CSEP</option>			
		</select>
	<%	} else { %>
		<%
			if ("C1".equals(CABSI11)) {
		%>
			C1
		<%	
			} else if ("C2a".equals(CABSI11)) {
		%>
			C2a
		<%	
			} else if ("C2b".equals(CABSI11)) {
		%>
			C2b
		<%
			} else if ("CSEP".equals(CABSI11)) {
		%>
			CSEP
		<%		
			}
		%>	
	<%	} %>
	</td>
		<td class="infoLabel" width="10%">CAUTI</td>
		<td class="infoData" width="10%">
	<%	if (createAction || updateAction) { %>
		<select name="CAUT1">
			<option value="ASB"<%="ASB".equals(CAUT1)?" selected":"" %>>ASB</option>
			<option value="SUTI"<%="SUTI".equals(CAUT1)?" selected":"" %>>SUTI</option>		
		</select>
	<%	} else { %>
		<%
			if ("ASB".equals(CAUT1)) {
		%>
			ASB
		<%	
			} else if ("SUTI".equals(CAUT1)) {
		%>
			SUTI
		<%	
			}
		%>	
	<%	} %>
	</td>
	</tr>
	<tr>
		<td class="infoLabel" width="15%">Infection Date</td>
		<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
		<input type="text" name="INFECT_DATE1" id="INFECT_DATE1" class="datepickerfield" value="<%=INFECT_DATE1 == null ? "" : INFECT_DATE1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
	<%	} else { %>
			<%=INFECT_DATE1  == null ? "" : INFECT_DATE1  %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Device on and off Date</td>
		<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
		<input type="text" name="DEVICE_ONOFF_DATE1" id="DEVICE_ONOFF_DATE1" class="datepickerfield" value="<%=DEVICE_ONOFF_DATE1 == null ? "" : DEVICE_ONOFF_DATE1 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
	<%	} else { %>
			<%=DEVICE_ONOFF_DATE1  == null ? "" : DEVICE_ONOFF_DATE1  %>
<%	} %>
		</td>
	<td class="infoLabel" width="15%">Device days</td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
		<input type="text" id=DEVICE_DAY1 name="DEVICE_DAY1" value="<%=DEVICE_DAY1 == null ? "" : DEVICE_DAY1 %>" maxlength="5" size="20" />
	<%	} else { %>
		<%=DEVICE_DAY1  == null ? "" : DEVICE_DAY1  %>
<%	} %>
	</td>		
	</tr>
		<tr class="smallText">
		<td class="infoLabel" width="10%">VAP</td>
		<td class="infoData" width="10%">
	<%	if (createAction || updateAction) { %>
		<select name="VAP2">
			<option value="PNU1"<%="PNU1".equals(VAP2)?" selected":"" %>>PNU1</option>
			<option value="PNU2"<%="PNU2".equals(VAP2)?" selected":"" %>>PNU2</option>				
			<option value="PNU3"<%="PNU3".equals(VAP2)?" selected":"" %>>PNU3</option>			
		</select>
	<%	} else { %>
		<%
			if ("PNU1".equals(VAP2)) {
		%>
			PNU1
		<%	
			} else if ("PNU2".equals(VAP2)) {
		%>
			PNU2
		<%	
			} else if ("PNU3".equals(VAP2)) {
		%>
			PNU3
		<%
			}
		%>	
	<%	} %>
	</td>
	<td class="infoLabel" width="10%">CABSI</td>
		<td class="infoData" width="10%">
	<%	if (createAction || updateAction) { %>
		<select name="CABSI12">
			<option value="C1"<%="C1".equals(CABSI12)?" selected":"" %>>C1</option>
			<option value="C2a"<%="C2a".equals(CABSI12)?" selected":"" %>>C2a</option>				
			<option value="C2b"<%="C2b".equals(CABSI12)?" selected":"" %>>C2b</option>			
			<option value="CSEP"<%="CSEP".equals(CABSI12)?" selected":"" %>>CSEP</option>			
		</select>
	<%	} else { %>
		<%
			if ("C1".equals(CABSI12)) {
		%>
			C1
		<%	
			} else if ("C2a".equals(CABSI12)) {
		%>
			C2a
		<%	
			} else if ("C2b".equals(CABSI12)) {
		%>
			C2b
		<%
			} else if ("CSEP".equals(CABSI12)) {
		%>
			CSEP
		<%		
			}
		%>	
	<%	} %>
	</td>
		<td class="infoLabel" width="10%">CAUTI</td>
		<td class="infoData" width="10%">
	<%	if (createAction || updateAction) { %>
		<select name="CAUT2">
			<option value="ASB"<%="ASB".equals(CAUT2)?" selected":"" %>>ASB</option>
			<option value="SUTI"<%="SUTI".equals(CAUT2)?" selected":"" %>>SUTI</option>		
		</select>
	<%	} else { %>
		<%
			if ("ASB".equals(CAUT2)) {
		%>
			ASB
		<%	
			} else if ("SUTI".equals(CAUT2)) {
		%>
			SUTI
		<%	
			}
		%>	
	<%	} %>
	</td>
	</tr>
	<tr>
		<td class="infoLabel" width="15%">Infection Date</td>
		<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
		<input type="text" name="INFECT_DATE2" id="INFECT_DATE2" class="datepickerfield" value="<%=INFECT_DATE2 == null ? "" : INFECT_DATE2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
	<%	} else { %>
			<%=INFECT_DATE2  == null ? "" : INFECT_DATE2  %>
<%	} %>
		</td>
		<td class="infoLabel" width="15%">Device on and off Date</td>
		<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
		<input type="text" name="DEVICE_ONOFF_DATE2" id="DEVICE_ONOFF_DATE2" class="datepickerfield" value="<%=DEVICE_ONOFF_DATE2 == null ? "" : DEVICE_ONOFF_DATE2 %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)
	<%	} else { %>
			<%=DEVICE_ONOFF_DATE2  == null ? "" : DEVICE_ONOFF_DATE2  %>
<%	} %>
		</td>
	<td class="infoLabel" width="15%">Device days</td>
	<td class="infoData" width="10%" valign="top">
<%	if (createAction || updateAction) { %>
		<input type="text" id=DEVICE_DAY2 name="DEVICE_DAY2" value="<%=DEVICE_DAY2 == null ? "" : DEVICE_DAY2 %>" maxlength="5" size="20" />
	<%	} else { %>
		<%=DEVICE_DAY2  == null ? "" : DEVICE_DAY2  %>
<%	} %>
	</td>		
	</tr>	
	<tr>
	  	<td class="infoLabel" width="30%">S/S</td>	 
	  	<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="SS1" rows="3" cols="50"><%=SS1==null?"":SS1 %></textarea>
  			</div>
<%	} else { %>			
			<%=SS1 == null ? "" : SS1 %>
<%	} %>
  		</td>
  		<td class="infoLabel" width="30%">Lab Evidence</td>	 
	  	<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="LAB_EVID1" rows="3" cols="50"><%=LAB_EVID1==null?"":LAB_EVID1 %></textarea>
  			</div>
<%	} else { %>			
			<%=LAB_EVID1 == null ? "" : LAB_EVID1 %>
<%	} %>
  		</td>    
		<td class="infoLabel" width="30%">Treatment</td>	 
	  	<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="TREATMENT1" rows="3" cols="50"><%=TREATMENT1==null?"":TREATMENT1 %></textarea>
  			</div>
<%	} else { %>			
			<%=TREATMENT1 == null ? "" : TREATMENT1 %>
<%	} %>
  		</td>  		    
	</tr>
<tr>
	  	<td class="infoLabel" width="30%">S/S</td>	 
	  	<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="SS2" rows="3" cols="50"><%=SS2==null?"":SS2 %></textarea>
  			</div>
<%	} else { %>			
			<%=SS2 == null ? "" : SS2 %>
<%	} %>
  		</td>
  		<td class="infoLabel" width="30%">Lab Evidence</td>	 
	  	<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="LAB_EVID2" rows="3" cols="50"><%=LAB_EVID2==null?"":LAB_EVID2 %></textarea>
  			</div>
<%	} else { %>			
			<%=LAB_EVID2 == null ? "" : LAB_EVID2 %>
<%	} %>
  		</td>    
		<td class="infoLabel" width="30%">Treatment</td>	 
	  	<td class="infoData" width="70%" valign="top">
<%	if (createAction || updateAction) { %>
			<div class="box" >
  				<textarea name="TREATMENT2" rows="3" cols="50"><%=TREATMENT2==null?"":TREATMENT2 %></textarea>
  			</div>
<%	} else { %>			
			<%=TREATMENT2 == null ? "" : TREATMENT2 %>
<%	} %>
  		</td>  		    
	</tr>	
</table>

<div class="pane">
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
	<%	if (createAction || updateAction || deleteAction) { %>
				<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /></button>
	<%		if (!createAction) { %>
				<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
	<%		}  %>
	<%	} else { %>
				<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="button.update" /></button>
				<button class="btn-delete"><bean:message key="button.delete" /></button>
	<%	}  %>
			</td>
		</tr>
	</table>
</div>

<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="CaseNum" value="<%=CaseNum %>" />

</form>


<% } %>
<script language="javascript">
$(document).ready(function() {
	<%	if (createAction || updateAction) { %>
		$("textarea[name=DIAG_ON_ICU]").supertextarea({
			maxl: 98,
			tabr: {use: false}
		});

		$("textarea[name=BHX]").supertextarea({
			maxl: 98,
			tabr: {use: false}
		});

		$("textarea[name=UNDER_DISE]").supertextarea({
			maxl: 98,
			tabr: {use: false}
		});

		$("textarea[name=PREM_STAT]").supertextarea({
			maxl: 98,
			tabr: {use: false}
		});

		$("textarea[name=SS1]").supertextarea({
			maxl: 48,
			tabr: {use: false}
		});
		
		$("textarea[name=LAB_EVID1]").supertextarea({
			maxl: 48,
			tabr: {use: false}
		});
		
		$("textarea[name=TREATMENT1]").supertextarea({
			maxl: 48,
			tabr: {use: false}
		});
		
		$("textarea[name=SS2]").supertextarea({
			maxl: 48,
			tabr: {use: false}
		});
		
		$("textarea[name=LAB_EVID2]").supertextarea({
			maxl: 48,
			tabr: {use: false}
		});
		
		$("textarea[name=TREATMENT2]").supertextarea({
			maxl: 48,
			tabr: {use: false}
		});
				
		$("#form1").validate({

		});
	<%	} %>

	
	$('input[name=LabNum]').change(function() {
		var temp = this.id.split('_');
		loadLabInfo(this.value, temp[1]);
	});
});

function loadLabInfo(labNum, rowNum) {
var param = {
	labNum:	labNum,
	command: '<%=command %>'
};
//$.getJSON('getPatInfoByLabNum.jsp', param, function(data) {
$.getJSON('getPatInfoByHospNum.jsp', param, function(data) {
	var items = [];
	$.each(data, function(key, val) {
		var id_span = '#' + key + "_span";
		var id = '#' + key;
		$(id).val(val);
		$(id_span).html(val);		
	});
});
}

function submitAction(cmd, stp) {
	if (stp == 1) {
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.LabNum.value == '') {
				alert("Please input Lab No.");
				document.form1.LabNum.focus();
				return false;
			}
		}
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.HospAdmDate.value == '') {
				alert("Please input Hosp. Adm. Date");
				document.form1.HospAdmDate.focus();
				return false;
			}
		}		
	}
	document.form1.command.value = cmd;
	document.form1.step.value = stp;
	document.form1.submit();
}
</script>

</div>
</div></div>

<jsp:include page="../common/footer.jsp"/>
</body>
</html:html>