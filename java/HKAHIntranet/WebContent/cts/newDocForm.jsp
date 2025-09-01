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
String command = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "command"));
String ctsNo = ParserUtil.getParameter(request, "ctsNo");	//01 CTS_NO
boolean validStatus = false;
String mustLogin = null;
String role = ParserUtil.getParameter(request, "role");

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");
String folderId = CTS.getNewFolderId(ctsNo);
String forwardPath = null;

if (fileUpload) {
//	String[] fileList = (String[]) request.getAttribute("filelist");
    String[] file1 = (String[]) request.getAttribute("file1_StringArray");
    String[] file2 = (String[]) request.getAttribute("file2_StringArray");
    String[] file3 = (String[]) request.getAttribute("file3_StringArray");
    String[] file4 = (String[]) request.getAttribute("file4_StringArray");
    String[] file5 = (String[]) request.getAttribute("file5_StringArray");
    String[] file6 = (String[]) request.getAttribute("file6_StringArray");
    String[] file7 = (String[]) request.getAttribute("file7_StringArray");
    String[] file8 = (String[]) request.getAttribute("file8_StringArray");
    String[] file9 = (String[]) request.getAttribute("file9_StringArray");
    String[] file10 = (String[]) request.getAttribute("file10_StringArray");
    String[] file11 = (String[]) request.getAttribute("file11_StringArray");
    String[] file12 = (String[]) request.getAttribute("file12_StringArray");    

	if(folderId!=null && folderId.length()>0){
		System.err.println("1[folderId]"+folderId);			
	}else{
		folderId = CTS.getFolderId(ctsNo);
	}	
	
	StringBuffer tempStrBuffer = new StringBuffer();
	tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
	tempStrBuffer.append(File.separator);
	tempStrBuffer.append("CTS");
	tempStrBuffer.append(File.separator);
	tempStrBuffer.append(folderId);
	tempStrBuffer.append(File.separator);
	String baseUrl = tempStrBuffer.toString();

	tempStrBuffer.setLength(0);
	tempStrBuffer.append(File.separator);
	tempStrBuffer.append("upload");
	tempStrBuffer.append(File.separator);
	tempStrBuffer.append("CTS");
	tempStrBuffer.append(File.separator);
	tempStrBuffer.append(folderId);
	String webUrl = tempStrBuffer.toString();
		
	if (file1 != null) {			
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + file1[0],
				baseUrl + "1" + File.separator + file1[0]
			);			
		DocumentDB.add(null, userBean, "ctsnew", folderId, webUrl, false, null, file1[0], "1");
	}
	if (file2 != null) {			
			FileUtil.moveFile(
				ConstantsServerSide.UPLOAD_FOLDER + File.separator + file2[0],
				baseUrl + "2" + File.separator + file2[0]
			);			
		DocumentDB.add(null, userBean, "ctsnew", folderId, webUrl, false, null, file2[0], "2");
	}	
	if (file3 != null) {			
		FileUtil.moveFile(
			ConstantsServerSide.UPLOAD_FOLDER + File.separator + file3[0],
			baseUrl + "3" + File.separator + file3[0]
		);			
		DocumentDB.add(null, userBean, "ctsnew", folderId, webUrl, false, null, file3[0], "3");
	}
	if (file4 != null) {			
		FileUtil.moveFile(
			ConstantsServerSide.UPLOAD_FOLDER + File.separator + file4[0],
			baseUrl + "4" + File.separator + file4[0]
		);			
		DocumentDB.add(null, userBean, "ctsnew", folderId, webUrl, false, null, file4[0], "4");
	}
	if (file5 != null) {			
		FileUtil.moveFile(
			ConstantsServerSide.UPLOAD_FOLDER + File.separator + file5[0],
			baseUrl + "5" + File.separator + file5[0]
		);			
		DocumentDB.add(null, userBean, "ctsnew", folderId, webUrl, false, null, file5[0], "5");
	}
	if (file6 != null) {			
		FileUtil.moveFile(
			ConstantsServerSide.UPLOAD_FOLDER + File.separator + file6[0],
			baseUrl + "6" + File.separator + file6[0]
		);			
		DocumentDB.add(null, userBean, "ctsnew", folderId, webUrl, false, null, file6[0], "6");
	}
	if (file7 != null) {			
		FileUtil.moveFile(
			ConstantsServerSide.UPLOAD_FOLDER + File.separator + file7[0],
			baseUrl + "7" + File.separator + file7[0]
		);			
		DocumentDB.add(null, userBean, "ctsnew", folderId, webUrl, false, null, file7[0], "7");
	}
	if (file8 != null) {			
		FileUtil.moveFile(
			ConstantsServerSide.UPLOAD_FOLDER + File.separator + file8[0],
			baseUrl + "8" + File.separator + file8[0]
		);			
		DocumentDB.add(null, userBean, "ctsnew", folderId, webUrl, false, null, file8[0], "8");
	}
	if (file9 != null) {			
		FileUtil.moveFile(
			ConstantsServerSide.UPLOAD_FOLDER + File.separator + file9[0],
			baseUrl + "9" + File.separator + file9[0]
		);			
		DocumentDB.add(null, userBean, "ctsnew", folderId, webUrl, false, null, file9[0], "9");
	}
	if (file10 != null) {			
		FileUtil.moveFile(
			ConstantsServerSide.UPLOAD_FOLDER + File.separator + file10[0],
			baseUrl + "10" + File.separator + file10[0]
		);			
		DocumentDB.add(null, userBean, "ctsnew", folderId, webUrl, false, null, file10[0], "10");
	}
	if (file11 != null) {			
		FileUtil.moveFile(
			ConstantsServerSide.UPLOAD_FOLDER + File.separator + file11[0],
			baseUrl + "11" + File.separator + file11[0]
		);			
		DocumentDB.add(null, userBean, "ctsnew", folderId, webUrl, false, null, file11[0], "11");
	}
	if (file12 != null) {			
		FileUtil.moveFile(
			ConstantsServerSide.UPLOAD_FOLDER + File.separator + file12[0],
			baseUrl + "12" + File.separator + file12[0]
		);			
		DocumentDB.add(null, userBean, "ctsnew", folderId, webUrl, false, null, file12[0], "12");
	}	
}

boolean createAction = false;
boolean submitAction = false;
boolean checkAction = false;
boolean updateSucc = false;
boolean creating = false;
boolean viewAction = false;
boolean viewRptAction = false;
boolean editAction = false;
boolean updateAction = false;
boolean closeAction = false;

if ("save".equals(command)) {
	updateAction = true;
}else if("submit".equals(command)){
	submitAction = true;
}else if("view".equals(command)){
	viewAction = true;		
}else if("check".equals(command)){
	checkAction = true;		
}

String ctsStatus = ParserUtil.getParameter(request, "ctsStatus");	//01 CTS_STATUS

String docfName = ParserUtil.getParameter(request, "docfName");	//02 DOCFNAME
String docgName = ParserUtil.getParameter(request, "docgName");	//03 DOCGNAME
String doccName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "doccName"));	//04 DOCCNAME
String docSex = ParserUtil.getParameter(request, "docSex");	//05 DOCSEX
String idNo = ParserUtil.getParameter(request, "idNo");	//06 DOCIDNO
String martialStatus = ParserUtil.getParameter(request, "martialStatus");	//07	DOCMSTS
String docSpCode = ParserUtil.getParameter(request, "docSpCode");	//08 SPCCODE
String docAddr1 = ParserUtil.getParameter(request, "docAddr1");	//09 DOCADD1
String docAddr2 = ParserUtil.getParameter(request, "docAddr2");	//10 DOCADD2
String docAddr3 = ParserUtil.getParameter(request, "docAddr3");	//11 DOCADD3
String docAddr4 = ParserUtil.getParameter(request, "docAddr4");	//12 DOCADD3	
String homeAddr1 = ParserUtil.getParameter(request, "homeAddr1");	//13 DOCHOMADD11
String homeAddr2 = ParserUtil.getParameter(request, "homeAddr2");	//14 DOCHOMADD12
String homeAddr3 = ParserUtil.getParameter(request, "homeAddr3");	//15 DOCHOMADD13
String homeAddr4 = ParserUtil.getParameter(request, "homeAddr4");	//16 DOCHOMADD14
String email = ParserUtil.getParameter(request, "email");	//17 DOCEMAIL
String pager = ParserUtil.getParameter(request, "pager");	//18 DOCPTEL
String mobile = ParserUtil.getParameter(request, "mobile");	//19 DOCMTEL
String homeTel = ParserUtil.getParameter(request, "homeTel");	//20 DOCHTEL
String officeTel = ParserUtil.getParameter(request, "officeTel");	//21 DOCOTEL
String officeFax = ParserUtil.getParameter(request, "officeFax");	//22 DOCFAXNO
String docAcademic1 = ParserUtil.getParameter(request, "docAcademic1");	//23 DOCACADEMIC1
String docAcademic2 = ParserUtil.getParameter(request, "docAcademic2");	//24 DOCACADEMIC2
String docDegree1 = ParserUtil.getParameter(request, "docDegree1");	//25 DOCDEGREE1
String docDegree2 = ParserUtil.getParameter(request, "docDegree2");	//26 DOCDEGREE2
String docAcademicDate1 = ParserUtil.getParameter(request, "docAcademicDate1");	//27 DOCACADEMICDATE1
String docAcademicDate2 = ParserUtil.getParameter(request, "docAcademicDate2");	//28 DOCACADEMICDATE1
String docSpecQual = ParserUtil.getParameter(request, "docSpecQual");	//29 DOCSPECQUAL
String docSpecQualSince = ParserUtil.getParameter(request, "docSpecQualSince");	//30 DOCSPECQUALSINCE
String docSpecQualHospital1= ParserUtil.getParameter(request, "docSpecQualHospital1");	//31 DOCSPECQUALHOSPITAL1
String docSpecQualHospital2= ParserUtil.getParameter(request, "docSpecQualHospital2");	//32 DOCSPECQUALHOSPITAL2
String docSpecQualDateFrom1 = ParserUtil.getParameter(request, "docSpecQualDateFrom1");	//33 DOCSPECQUALDATEFROM1
String docSpecQualDateFrom2 = ParserUtil.getParameter(request, "docSpecQualDateFrom2");	//34 DOCSPECQUALDATEFROM2
String docSpecQualDateTo1= ParserUtil.getParameter(request, "docSpecQualDateTo1");	//35 DOCSPECQUALDATETO1
String docSpecQualDateTo2= ParserUtil.getParameter(request, "docSpecQualDateTo2");	//36 DOCSPECQUALDATETO2
String medInfo= ParserUtil.getParameter(request, "medInfo"); //37 MEDINFO
String docPrevPracticeAddr1= ParserUtil.getParameter(request, "docPrevPracticeAddr1");	//38 DOCPREVPRACTICEADDR1
String docPrevPracticeAddr2= ParserUtil.getParameter(request, "docPrevPracticeAddr2");	//39 DOCPREVPRACTICEADDR2
String docPrevPracticeFrom1= ParserUtil.getParameter(request, "docPrevPracticeFrom1");	//40 DOCPREVPRACTICEFROM1
String docPrevPracticeFrom2= ParserUtil.getParameter(request, "docPrevPracticeFrom2");	//41 DOCPREVPRACTICEFROM2
String docPrevPracticeTo1= ParserUtil.getParameter(request, "docPrevPracticeTo1");	//40 DOCPREVPRACTICETO1
String docPrevPracticeTo2= ParserUtil.getParameter(request, "docPrevPracticeTo2");	//42 DOCPREVPRACTICETO2
String docMemProSoc1= ParserUtil.getParameter(request, "docMemProSoc1");	//44 DOCMEMPROSOC1
String docMemProSoc2= ParserUtil.getParameter(request, "docMemProSoc2");	//45 DOCMEMPROSOC2
String docMemProSocStatus1= ParserUtil.getParameter(request, "docMemProSocStatus1");	//46 DOCMEMPROSOCSTATUS1
String docMemProSocStatus2= ParserUtil.getParameter(request, "docMemProSocStatus2");	//47 DOCMEMPROSOCSTATUS2
String docMemProSocYear1= ParserUtil.getParameter(request, "docMemProSocYear1");	//48 DOCMEMPROSOCYEAR1 
String docMemProSocYear2= ParserUtil.getParameter(request, "docMemProSocYear2");	//49 DOCMEMPROSOCYEAR2
String docAcademyOfMed1= ParserUtil.getParameter(request, "docAcademyOfMed1");	//50 DOCACADEMYOFMED1
String docAcademyOfMed2= ParserUtil.getParameter(request, "docAcademyOfMed2");	//51 DOCACADEMYOFMED2
String docAcademyOfMedStatus1= ParserUtil.getParameter(request, "docAcademyOfMedStatus1"); //22 DOCACADEMYOFMEDSTATUS1
String docAcademyOfMedStatus2= ParserUtil.getParameter(request, "docAcademyOfMedStatus2"); //53 DOCACADEMYOFMEDSTATUS2
String docAcademyOfMedYear1= ParserUtil.getParameter(request, "docAcademyOfMedYear1");	//54 DOCACADEMYOFMEDYEAR1
String docAcademyOfMedYear2= ParserUtil.getParameter(request, "docAcademyOfMedYear2");	//55 DOCACADEMYOFMEDYEAR2
String docLicNo1= ParserUtil.getParameter(request, "docLicNo1");	//56 DOCLICNO1
String docLicNo2= ParserUtil.getParameter(request, "docLicNo2");	//57 DOCLICNO2
//String docHealthStatus1= ParserUtil.getParameter(request, "docHealthStatus1");
//String docHealthStatus2= ParserUtil.getParameter(request, "docHealthStatus2");
String docLicExpdate1= ParserUtil.getParameter(request, "docLicExpdate1");	//58 DOCLICEXPDATE1
String docLicExpdate2= ParserUtil.getParameter(request, "docLicExpdate2");	//59 DOCLICEXPDATE1
String docInsureCarr= ParserUtil.getParameter(request, "docInsureCarr");	//60 DOCINSURECARR
String docInsureCarrExpDate= ParserUtil.getParameter(request, "docInsureCarrExpDate");	//61 DOCINSURECARREXPDATE
//String docOtherInfo1= ParserUtil.getParameter(request, "docOtherInfo1");
//String docOtherInfo2= ParserUtil.getParameter(request, "docOtherInfo2");
//String docOtherInfo3= ParserUtil.getParameter(request, "docOtherInfo3");
//String docOtherInfo4= ParserUtil.getParameter(request, "docOtherInfo4");
//String docOtherInfo5= ParserUtil.getParameter(request, "docOtherInfo5");
String docProfRef1= ParserUtil.getParameter(request, "docProfRef1");	//62 DOCPROFREF1
String docProfRef2= ParserUtil.getParameter(request, "docProfRef2");	//63 DOCPROFREF2
String docProfRefContact1= ParserUtil.getParameter(request, "docProfRefContact1"); //64 DOCPROFREFCONTACT1
String docProfRefContact2= ParserUtil.getParameter(request, "docProfRefContact2"); //65 DOCPROFREFCONTACT2

String privilegesId = null;
String[] checkPrivDesc = null;

String checkPriv0= ParserUtil.getParameter(request, "checkPriv0");
String checkPriv1= ParserUtil.getParameter(request, "checkPriv1");
String checkPriv2= ParserUtil.getParameter(request, "checkPriv2");
String checkPriv3= ParserUtil.getParameter(request, "checkPriv3");
String checkPriv4= ParserUtil.getParameter(request, "checkPriv4");
String checkPriv5= ParserUtil.getParameter(request, "checkPriv5");
String checkPriv6= ParserUtil.getParameter(request, "checkPriv6");
String checkPriv7= ParserUtil.getParameter(request, "checkPriv7");
String checkPriv8= ParserUtil.getParameter(request, "checkPriv8");
String checkPriv9= ParserUtil.getParameter(request, "checkPriv9");
String checkPriv10= ParserUtil.getParameter(request, "checkPriv10");
String checkPriv11= ParserUtil.getParameter(request, "checkPriv11");

String formId = "F002A";
String formId2 = "F002B";
String questId = null;
String questId2 = null;
String questAns = null;
String questAns2 = null;
String questSupDtl = null;
String questSupDtl2 = null;

ArrayList questList = null;
ArrayList questList2 = null;

String[] checkPriv = null ;
String siteCode = null;

try {
	ArrayList privList = CTS.getCTSNewPrivileges();		
	int miscItemArraySize = privList.size();
	checkPrivDesc = new String[privList.size()];	

	for( int i=0;i<checkPrivDesc.length;i++) {
		ReportableListObject pRow = (ReportableListObject) privList.get(i);
		privilegesId = pRow.getValue(0);
		checkPrivDesc[i] = pRow.getValue(1);
	}
	
	checkPriv = new String[privList.size()];
	for(int i=0;i<checkPriv.length;i++) {
		 checkPriv[i]= ParserUtil.getParameter(request, "checkPriv"+i);
	}	
			
	if (updateAction || submitAction) {
		if(ctsNo!=null && ctsNo.length()>0){
			if(CTS.updateNewCTSDtl(userBean, null, ctsNo, docfName, docgName, doccName, docSex, idNo, martialStatus, docSpCode,
					docAddr1, docAddr2, docAddr3, docAddr4, homeAddr1, homeAddr2, homeAddr3, homeAddr4,
					email, pager, mobile, homeTel, officeTel, officeFax, docAcademic1, docAcademic2,
					docDegree1, docDegree2, docAcademicDate1, docAcademicDate2, docSpecQual, docSpecQualSince,
					docSpecQualHospital1, docSpecQualHospital2, docSpecQualDateFrom1, docSpecQualDateFrom2, docSpecQualDateTo1, 
					docSpecQualDateTo2, medInfo, docPrevPracticeAddr1, docPrevPracticeAddr2, docPrevPracticeFrom1, docPrevPracticeFrom2,
					docPrevPracticeTo1, docPrevPracticeTo2, docMemProSoc1, docMemProSoc2, docMemProSocStatus1, docMemProSocStatus2,
					docMemProSocYear1, docMemProSocYear2, docAcademyOfMed1, docAcademyOfMed2, docAcademyOfMedStatus1, docAcademyOfMedStatus2,
					docAcademyOfMedYear1, docAcademyOfMedYear2, docLicNo1, docLicNo2, docLicExpdate1, docLicExpdate2, docInsureCarr,
					docInsureCarrExpDate, docProfRef1, docProfRef2, docProfRefContact1, docProfRefContact2, null)){
					
					questList = CTS.getformQuest(formId,ctsNo);
					request.setAttribute("CTS", questList);	
					ReportableListObject qRow = null;
					boolean updateReturn = false; 

					for( int i=0;i<questList.size();i++) {
						qRow = (ReportableListObject) questList.get(i);
						questId = qRow.getValue(0);
						questAns = ParserUtil.getParameter(request, "HSRadio"+questId);
						updateReturn = CTS.updatFormQuestion(ctsNo, questId, questAns);
						if(!updateReturn){
							break;					
						}
					}		
					
					questList2 = CTS.getformQuest(formId2,ctsNo);
					request.setAttribute("CTS2", questList2);	
					ReportableListObject qRow2 = null;
					boolean updateReturn2 = false;			
					for( int i=0;i<questList2.size();i++) {
						qRow2 = (ReportableListObject) questList2.get(i);
						questId2 = qRow2.getValue(0);
						questAns2 = ParserUtil.getParameter(request, "OIRadio"+questId2);
						updateReturn2 = CTS.updatFormQuestion(ctsNo, questId2, questAns2);
						if(!updateReturn2){
							break;					
						}				
					}			
					
					boolean updateReturn3 = false;			
					for (int i = 0;i < checkPriv.length; i++) {
						if(checkPriv[i]==null){
							checkPriv[i]="0";
						}
						updateReturn3 = CTS.updateNewPrivileges(ctsNo, Integer.toString(i), checkPriv[i]);
						if(!updateReturn3){
							break;					
						}				
					}
					
					if(updateReturn && updateReturn2 && updateReturn3){
						errorMessage = "Save Success";
						
						if (ctsNo != null && ctsNo != null && ctsNo.length() > 0) {	
							ArrayList record = CTS.getNewCTSDtl(ctsNo);
							ReportableListObject row2 = (ReportableListObject) record.get(0);
							
							docfName = row2.getValue(4);	
							docgName = row2.getValue(5);	
							doccName = row2.getValue(6);	
							docSex = row2.getValue(7);	
							idNo = row2.getValue(8);	
							martialStatus = row2.getValue(9);	
							docSpCode = row2.getValue(10);	
							docAddr1 = row2.getValue(11);	
							docAddr2 = row2.getValue(12);	
							docAddr3 = row2.getValue(13);	
							docAddr4 = row2.getValue(14);	
							homeAddr1 = row2.getValue(15);	
							homeAddr2 = row2.getValue(16);	
							homeAddr3 = row2.getValue(17);	
							homeAddr4 = row2.getValue(18);	
							email = row2.getValue(19);	
							pager = row2.getValue(20);	
							mobile = row2.getValue(21);	
							homeTel = row2.getValue(22);	
							officeTel = row2.getValue(23);	
							officeFax = row2.getValue(24);	
							docAcademic1 = row2.getValue(25);	
							docAcademic2 = row2.getValue(26);	
							docDegree1 = row2.getValue(27);	
							docDegree2 = row2.getValue(28);	
							docAcademicDate1 = row2.getValue(29);	
							docAcademicDate2 = row2.getValue(30);	
							docSpecQual = row2.getValue(31);	
							docSpecQualSince = row2.getValue(32);	
							docSpecQualHospital1 = row2.getValue(33);	
							docSpecQualHospital2 = row2.getValue(34);	
							docSpecQualDateFrom1 = row2.getValue(35);	
							docSpecQualDateFrom2 = row2.getValue(36);	
							docSpecQualDateTo1 = row2.getValue(37);	
							docSpecQualDateTo2 = row2.getValue(38);
							medInfo= row2.getValue(39);
							docPrevPracticeAddr1 = row2.getValue(40);	
							docPrevPracticeAddr2 = row2.getValue(41);	
							docPrevPracticeFrom1 = row2.getValue(42);	
							docPrevPracticeFrom2 = row2.getValue(43);	
							docPrevPracticeTo1 = row2.getValue(44);	
							docPrevPracticeTo2 = row2.getValue(45);	
							docMemProSoc1 = row2.getValue(46);	
							docMemProSoc2 = row2.getValue(47);	
							docMemProSocStatus1 = row2.getValue(48);	
							docMemProSocStatus2 = row2.getValue(49);	
							docMemProSocYear1 = row2.getValue(50);	
							docMemProSocYear2 = row2.getValue(51);	
							docAcademyOfMed1 = row2.getValue(52);	
							docAcademyOfMed2 = row2.getValue(53);	
							docAcademyOfMedStatus1 = row2.getValue(54);	
							docAcademyOfMedStatus2 = row2.getValue(55);	
							docAcademyOfMedYear1 = row2.getValue(56);	
							docAcademyOfMedYear2 = row2.getValue(57);	
							docLicNo1 = row2.getValue(58);
							docLicNo2 = row2.getValue(59);				
							docLicExpdate1 = row2.getValue(60);	
							docLicExpdate2 = row2.getValue(61);	
							docInsureCarr = row2.getValue(62);	
							docInsureCarrExpDate = row2.getValue(63);	
							docProfRef1 = row2.getValue(64);	
							docProfRef2 = row2.getValue(65);	
							docProfRefContact1 = row2.getValue(66);	
							docProfRefContact2 = row2.getValue(67);	
							
							questList = CTS.getformQuest(formId,ctsNo);
							request.setAttribute("CTS", questList);			
							
							questList2 = CTS.getformQuest(formId2,ctsNo);
							request.setAttribute("CTS2", questList2);			
							
							ArrayList recordPrivilegesDtl = CTS.getNewPrivilegesDtl(ctsNo);
							for(int i = 0;i<recordPrivilegesDtl.size();i++){
								ReportableListObject pRow1 = (ReportableListObject) recordPrivilegesDtl.get(i);
								checkPriv[i] = pRow1.getValue(1);
							}				
					}else{
						errorMessage = "Save Fail";

					}
					System.err.println(errorMessage);
				}
					viewAction = true;
			}
		}else{
			ctsNo = CTS.addNewCtsDtl(userBean, "S", null, docfName, docgName, doccName, docSex, idNo, martialStatus, docSpCode,
					docAddr1, docAddr2, docAddr3, docAddr4, homeAddr1, homeAddr2, homeAddr3, homeAddr4,
					email, pager, mobile, homeTel, officeTel, officeFax, docAcademic1, docAcademic2,
					docDegree1, docDegree2, docAcademicDate1, docAcademicDate2, docSpecQual, docSpecQualSince,
					docSpecQualHospital1, docSpecQualHospital2, docSpecQualDateFrom1, docSpecQualDateFrom2, docSpecQualDateTo1, 
					docSpecQualDateTo2, medInfo, docPrevPracticeAddr1, docPrevPracticeAddr2, docPrevPracticeFrom1, docPrevPracticeFrom2,
					docPrevPracticeTo1, docPrevPracticeTo2, docMemProSoc1, docMemProSoc2, docMemProSocStatus1, docMemProSocStatus2,
					docMemProSocYear1, docMemProSocYear2, docAcademyOfMed1, docAcademyOfMed2, docAcademyOfMedStatus1, docAcademyOfMedStatus2,
					docAcademyOfMedYear1, docAcademyOfMedYear2, docLicNo1, docLicNo2, docLicExpdate1, docLicExpdate2, docInsureCarr,
					docInsureCarrExpDate, docProfRef1, docProfRef2, docProfRefContact1, docProfRefContact2, null, folderId, null, null);
			
			if(ctsNo!=null && ctsNo.length()>0){
					questList = CTS.getformQuest(formId,ctsNo);
					request.setAttribute("CTS", questList);	
					ReportableListObject qRow = null;
					boolean updateReturn = false; 

					for( int i=0;i<questList.size();i++) {
						qRow = (ReportableListObject) questList.get(i);
						questId = qRow.getValue(0);
						questAns = ParserUtil.getParameter(request, "HSRadio"+questId);
						updateReturn = CTS.updatFormQuestion(ctsNo, questId, questAns);
						if(!updateReturn){
							break;					
						}
					}		
					
					questList2 = CTS.getformQuest(formId2,ctsNo);
					request.setAttribute("CTS2", questList2);	
					ReportableListObject qRow2 = null;
					boolean updateReturn2 = false;			
					for( int i=0;i<questList2.size();i++) {
						qRow2 = (ReportableListObject) questList2.get(i);
						questId2 = qRow2.getValue(0);
						questAns2 = ParserUtil.getParameter(request, "OIRadio"+questId2);
						updateReturn2 = CTS.updatFormQuestion(ctsNo, questId2, questAns2);
						if(!updateReturn2){
							break;					
						}				
					}			
					
					boolean updateReturn3 = false;			
					for (int i = 0;i < checkPriv.length; i++) {
						if(checkPriv[i]==null){
							checkPriv[i]="0";
						}
						CTS.insertNewPrivileges(ctsNo, Integer.toString(i));
						updateReturn3 = CTS.updateNewPrivileges(ctsNo, Integer.toString(i), checkPriv[i]);
						if(!updateReturn3){
							break;					
						}				
					}
					
					if(updateReturn && updateReturn2 && updateReturn3){
						errorMessage = "Save Success";
						
						if (ctsNo != null && ctsNo != null && ctsNo.length() > 0) {	
							ArrayList record = CTS.getNewCTSDtl(ctsNo);
							ReportableListObject row2 = (ReportableListObject) record.get(0);
							
							docfName = row2.getValue(4);	
							docgName = row2.getValue(5);	
							doccName = row2.getValue(6);	
							docSex = row2.getValue(7);	
							idNo = row2.getValue(8);	
							martialStatus = row2.getValue(9);	
							docSpCode = row2.getValue(10);	
							docAddr1 = row2.getValue(11);	
							docAddr2 = row2.getValue(12);	
							docAddr3 = row2.getValue(13);	
							docAddr4 = row2.getValue(14);	
							homeAddr1 = row2.getValue(15);	
							homeAddr2 = row2.getValue(16);	
							homeAddr3 = row2.getValue(17);	
							homeAddr4 = row2.getValue(18);	
							email = row2.getValue(19);	
							pager = row2.getValue(20);	
							mobile = row2.getValue(21);	
							homeTel = row2.getValue(22);	
							officeTel = row2.getValue(23);	
							officeFax = row2.getValue(24);	
							docAcademic1 = row2.getValue(25);	
							docAcademic2 = row2.getValue(26);	
							docDegree1 = row2.getValue(27);	
							docDegree2 = row2.getValue(28);	
							docAcademicDate1 = row2.getValue(29);	
							docAcademicDate2 = row2.getValue(30);	
							docSpecQual = row2.getValue(31);	
							docSpecQualSince = row2.getValue(32);	
							docSpecQualHospital1 = row2.getValue(33);	
							docSpecQualHospital2 = row2.getValue(34);	
							docSpecQualDateFrom1 = row2.getValue(35);	
							docSpecQualDateFrom2 = row2.getValue(36);	
							docSpecQualDateTo1 = row2.getValue(37);	
							docSpecQualDateTo2 = row2.getValue(38);
							medInfo= row2.getValue(39);
							docPrevPracticeAddr1 = row2.getValue(40);	
							docPrevPracticeAddr2 = row2.getValue(41);	
							docPrevPracticeFrom1 = row2.getValue(42);	
							docPrevPracticeFrom2 = row2.getValue(43);	
							docPrevPracticeTo1 = row2.getValue(44);	
							docPrevPracticeTo2 = row2.getValue(45);	
							docMemProSoc1 = row2.getValue(46);	
							docMemProSoc2 = row2.getValue(47);	
							docMemProSocStatus1 = row2.getValue(48);	
							docMemProSocStatus2 = row2.getValue(49);	
							docMemProSocYear1 = row2.getValue(50);	
							docMemProSocYear2 = row2.getValue(51);	
							docAcademyOfMed1 = row2.getValue(52);	
							docAcademyOfMed2 = row2.getValue(53);	
							docAcademyOfMedStatus1 = row2.getValue(54);	
							docAcademyOfMedStatus2 = row2.getValue(55);	
							docAcademyOfMedYear1 = row2.getValue(56);	
							docAcademyOfMedYear2 = row2.getValue(57);	
							docLicNo1 = row2.getValue(58);
							docLicNo2 = row2.getValue(59);				
							docLicExpdate1 = row2.getValue(60);	
							docLicExpdate2 = row2.getValue(61);	
							docInsureCarr = row2.getValue(62);	
							docInsureCarrExpDate = row2.getValue(63);	
							docProfRef1 = row2.getValue(64);	
							docProfRef2 = row2.getValue(65);	
							docProfRefContact1 = row2.getValue(66);	
							docProfRefContact2 = row2.getValue(67);	
							
							questList = CTS.getformQuest(formId,ctsNo);
							request.setAttribute("CTS", questList);			
							
							questList2 = CTS.getformQuest(formId2,ctsNo);
							request.setAttribute("CTS2", questList2);			
							
							ArrayList recordPrivilegesDtl = CTS.getNewPrivilegesDtl(ctsNo);
							for(int i = 0;i<recordPrivilegesDtl.size();i++){
								ReportableListObject pRow1 = (ReportableListObject) recordPrivilegesDtl.get(i);
								checkPriv[i] = pRow1.getValue(1);
							}				
					}else{
						errorMessage = "Save Fail";

					}
					System.err.println(errorMessage);
				}

				}				
		}
		forwardPath = "newDocFormPreview.jsp?ctsNo="+ctsNo+"&command=view&siteCode="+siteCode;		
	} else if(viewAction || checkAction){		
		// load data from database
		if (ctsNo != null && ctsNo != null && ctsNo.length() > 0) {	
			ArrayList record = CTS.getNewCTSDtl(ctsNo);
			ReportableListObject row2 = (ReportableListObject) record.get(0);
			
			ctsStatus = row2.getValue(3);
			docfName = row2.getValue(4);	
			docgName = row2.getValue(5);	
			doccName = row2.getValue(6);	
			docSex = row2.getValue(7);	
			idNo = row2.getValue(8);	
			martialStatus = row2.getValue(9);	
			docSpCode = row2.getValue(10);	
			docAddr1 = row2.getValue(11);	
			docAddr2 = row2.getValue(12);	
			docAddr3 = row2.getValue(13);	
			docAddr4 = row2.getValue(14);	
			homeAddr1 = row2.getValue(15);	
			homeAddr2 = row2.getValue(16);	
			homeAddr3 = row2.getValue(17);	
			homeAddr4 = row2.getValue(18);	
			email = row2.getValue(19);	
			pager = row2.getValue(20);	
			mobile = row2.getValue(21);	
			homeTel = row2.getValue(22);	
			officeTel = row2.getValue(23);	
			officeFax = row2.getValue(24);	
			docAcademic1 = row2.getValue(25);	
			docAcademic2 = row2.getValue(26);	
			docDegree1 = row2.getValue(27);	
			docDegree2 = row2.getValue(28);	
			docAcademicDate1 = row2.getValue(29);	
			docAcademicDate2 = row2.getValue(30);	
			docSpecQual = row2.getValue(31);	
			docSpecQualSince = row2.getValue(32);	
			docSpecQualHospital1 = row2.getValue(33);	
			docSpecQualHospital2 = row2.getValue(34);	
			docSpecQualDateFrom1 = row2.getValue(35);	
			docSpecQualDateFrom2 = row2.getValue(36);	
			docSpecQualDateTo1 = row2.getValue(37);	
			docSpecQualDateTo2 = row2.getValue(38);
			medInfo= row2.getValue(39);
			docPrevPracticeAddr1 = row2.getValue(40);	
			docPrevPracticeAddr2 = row2.getValue(41);	
			docPrevPracticeFrom1 = row2.getValue(42);	
			docPrevPracticeFrom2 = row2.getValue(43);	
			docPrevPracticeTo1 = row2.getValue(44);	
			docPrevPracticeTo2 = row2.getValue(45);	
			docMemProSoc1 = row2.getValue(46);	
			docMemProSoc2 = row2.getValue(47);	
			docMemProSocStatus1 = row2.getValue(48);	
			docMemProSocStatus2 = row2.getValue(49);	
			docMemProSocYear1 = row2.getValue(50);	
			docMemProSocYear2 = row2.getValue(51);	
			docAcademyOfMed1 = row2.getValue(52);	
			docAcademyOfMed2 = row2.getValue(53);	
			docAcademyOfMedStatus1 = row2.getValue(54);	
			docAcademyOfMedStatus2 = row2.getValue(55);	
			docAcademyOfMedYear1 = row2.getValue(56);	
			docAcademyOfMedYear2 = row2.getValue(57);	
			docLicNo1 = row2.getValue(58);
			docLicNo2 = row2.getValue(59);				
			docLicExpdate1 = row2.getValue(60);	
			docLicExpdate2 = row2.getValue(61);	
			docInsureCarr = row2.getValue(62);	
			docInsureCarrExpDate = row2.getValue(63);	
			docProfRef1 = row2.getValue(64);	
			docProfRef2 = row2.getValue(65);	
			docProfRefContact1 = row2.getValue(66);	
			docProfRefContact2 = row2.getValue(67);				
			
//			docCode = row2.getValue(0);			
//			ArrayList questList = CTS.getformQuest(formId,ctsNo);			
//			request.setAttribute("CTS", questList);
		}
		
		questList = CTS.getformQuest(formId,ctsNo);
		request.setAttribute("CTS", questList);			
		
		questList2 = CTS.getformQuest(formId2,ctsNo);
		request.setAttribute("CTS2", questList2);
		
		ArrayList recordPrivilegesDtl = CTS.getNewPrivilegesDtl(ctsNo);
		for(int i = 0;i<recordPrivilegesDtl.size();i++){
			ReportableListObject pRow1 = (ReportableListObject) recordPrivilegesDtl.get(i);
			checkPriv[i] = pRow1.getValue(1);
		}
		
		if("R".equals(ctsStatus) && viewAction){
			forwardPath = "newDocByManualPreview.jsp?ctsNo="+ctsNo+"&command=view&siteCode="+siteCode;
		}		
	}
	
	if ("S".equals(ctsStatus)||"X".equals(ctsStatus)||"Y".equals(ctsStatus)||"Z".equals(ctsStatus)||
			"I".equals(ctsStatus)||"L".equals(ctsStatus)||"K".equals(ctsStatus)) {
		validStatus = true;
	}else{
		validStatus = false;
	}	
	
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) {
	message = "";
}
errorMessage = "";
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

#rowHS {
    width: 100%;
    margin: 10px 0 10px 0 !important;
}

#rowOI {
    width: 100%;
    margin: 10px 0 10px 0 !important;
}

<% if (ConstantsServerSide.isTWAH()) { %>
button.btn-click {
	font-size: 15px;
	font-weight: bold;
}
<%}%>

</style>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/registration/background.css" />" />
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
	<jsp:param name="title" value="Hong Kong Adventist Hospital" />	
</jsp:include>
<%Map<String, String> tooltipMap = new HashMap<String, String>();
tooltipMap.put("saveBtn","Click 'Save' to save your changes.");
tooltipMap.put("uploadBtn","File can view after click the upload button.");
tooltipMap.put("submitBtn","Click 'Submit' to confirm your renewal application, no changes are allowed after submission.");
%>
<%	if (userBean.isLogin() && closeAction) { %>
		<%if (errorMessage != null) { %>
			<script type="text/javascript">alert('Form Saving Error, please contact IM support');window.close();</script>
		<%} else { %>	
			<%if (submitAction) { %>
				<script language="javascript">parent.location.href = "<%=forwardPath %>";</script>
			<%} else { %>
				<script type="text/javascript">alert('Form Saved');window.close();</script>
			<%} %>
		<%} %>
		<script type="text/javascript">alert('Access Denied !');window.close();</script>
<%} else if(submitAction){ %>
		<script language="javascript">parent.location.href = "<%=forwardPath %>";</script>
<%} else {
	if("R".equals(ctsStatus) && viewAction){%>
		<script language="javascript">parent.location.href = "<%=forwardPath %>";</script>		
<%	}
%>
<body style="display:none;">
<jsp:include page="cts_header.jsp" flush="false" >
	<jsp:param name="headerTitle" value="Create New CTS Application"/>
</jsp:include>	
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
				<%
					if("1".equals(CTS.checkRecordLock(ctsNo))){
						mustLogin = "N";
					}else{
						mustLogin = "Y";
					}
				%>				
				<jsp:include page="../common/message.jsp" flush="false">
					<jsp:param name="message" value="<%=message %>" />
					<jsp:param name="errorMessage" value="<%=errorMessage %>" />
				</jsp:include>
				
				<%-- Start the form --%>
				<form name="reportForm" id="form1" enctype="multipart/form-data" 
							action="newDocForm.jsp" method="post">
					<%-- Step Flow --%>
					<%
						if(viewAction||updateAction) {
					%>					
						<div style="width:98%; padding-left:5px" align='center'>
							<table>
								<tr>
									<td width="20%">
										<div type='basicInfo1' id='stepBtn1' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:210px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Step 1
										</div>
									</td>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>
									<td width="20%">
										<div type='basicInfo2' id='stepBtn2' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:210px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Step 2
										</div>
									</td>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>
									<td width="20%">
										<div type='basicInfo3' id='stepBtn3' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:210px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Step 3
										</div>
									</td>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>									
									<td width="20%">
										<div type='basicInfo4' id='stepBtn4' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:210px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Step 4
										</div>
									</td>
									<td align="center">
										<img src="../images/next_icon.gif" style="height:30px"/>
									</td>									
									<td width="20%">
										<div type='basicInfo5' id='stepBtn5' class='stepBtn ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only'
												style='width:210px;height:30px;top:50%;line-height:30px;overflow:hidden;text-align:center'>
											Step 5
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
							<td class="infoLabe2" colspan=6 align="left">
							<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform2" /></font>
							</br>Please verify and update the below information if needed. Fields marked with an (*) are required.
							</td>
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4">*</font><bean:message key="prompt.docfName" /></td>		
							<td class="infoData2" width="15%">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docfName" value="<%=docfName==null?"":docfName %>" maxlength="20" size="39"/>
							<%}else { %>
								<input type="text" name="docfName" value="<%=docfName==null?"":docfName %>" maxlength="20" size="39" readonly/>		
							<%} %>			
							</td>		
							<td class="infoLabe2" width="15%" align="left"><font size="4">*</font><bean:message key="prompt.docgName" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docgName" value="<%=docgName==null?"":docgName %>" maxlength="20" size="39"/>
							<%}else { %>
								<input type="text" name="docgName" value="<%=docgName==null?"":docgName %>" maxlength="20" size="39" readonly/>
							<%} %>			
							</td>	
							<td class="infoLabe2" width="15%" align="left"><bean:message key="prompt.doccName" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="doccName" value="<%=doccName==null?"":doccName %>" maxlength="15" size="39"/>
							<%}else { %>
								<input type="text" name="doccName" value="<%=doccName==null?"":doccName %>" maxlength="15" size="39" readonly/>		
							<%} %>			
							</td>
						</tr>						
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><bean:message key="prompt.sex" /></td>									
							<td class="infoData2" width="15%">	
								<select name="docSex">
									<option value="M">Male</option>
									<option value="F"<%="F".equals(docSex)?" selected":"" %>>Female</option>
								</select>									
							</td>
							<td class="infoLabe2" width="15%"><bean:message key="prompt.docIdNO" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="idNo" value="<%=idNo==null?"":idNo %>" maxlength="15" size="39"/>
							<%}else { %>
								<input type="text" name="idNo" value="<%=idNo==null?"":idNo %>" maxlength="15" size="39" readonly/>		
							<%} %>			
							</td>
							<td class="infoLabe2" width="15%"><bean:message key="prompt.martialStatus" /></td>
							<td class="infoData2" width="25%">
								<select name="martialStatus">
									<option value="S"<%="S".equals(martialStatus)?" selected":"" %>>Single</option>
									<option value="E"<%="E".equals(martialStatus)?" selected":"" %>>Engaged</option>
									<option value="M"<%="M".equals(martialStatus)?" selected":"" %>>Married</option>
									<option value="D"<%="D".equals(martialStatus)?" selected":"" %>>Divorce</option>
									<option value="X"<%="X".equals(martialStatus)?" selected":"" %>>Separate</option>
									<option value="W"<%="W".equals(martialStatus)?" selected":"" %>>Widow</option>
									<option value="Z"<%="Z".equals(martialStatus)?" selected":"" %>>Widower</option>
									<option value="O"<%="O".equals(martialStatus)?" selected":"" %>>Other</option>																											
								</select>					
							</td>														
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4">*</font><bean:message key="prompt.docCorrAddr" /></td>
							<td class="infoData2" width="15%">
							<table>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="docAddr1" value="<%=docAddr1==null?"":docAddr1 %>" maxlength="40" size="39"/>
									<%}else { %>
										<input type="text" name="docAddr1" value="<%=docAddr1==null?"":docAddr1 %>" maxlength="40" size="39" readonly/>		
									<%} %>			
									</td>
								</tr>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="docAddr2" value="<%=docAddr2==null?"":docAddr2 %>" maxlength="40" size="39"/>
									<%}else { %>
										<input type="text" name="docAddr2" value="<%=docAddr2==null?"":docAddr2 %>" maxlength="40" size="39" readonly/>		
									<%} %>			
									</td>
								</tr>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="docAddr3" value="<%=docAddr3==null?"":docAddr3 %>" maxlength="40" size="39"/>
									<%}else { %>
										<input type="text" name="docAddr3" value="<%=docAddr3==null?"":docAddr3 %>" maxlength="40" size="39" readonly/>		
									<%} %>			
									</td>
								</tr>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="docAddr4" value="<%=docAddr4==null?"":docAddr4 %>" maxlength="40" size="39"/>
									<%}else { %>
										<input type="text" name="docAddr4" value="<%=docAddr4==null?"":docAddr4 %>" maxlength="40" size="39" readonly/>		
									<%} %>			
									</td>
								</tr>																								
							</table>
							</td>
							<td class="infoLabe2" width="15%"><font size="4">*</font><bean:message key="prompt.docHomeAddr" /></td>
							<td class="infoData2" width="15%">
							<table>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="homeAddr1" value="<%=homeAddr1==null?"":homeAddr1 %>" maxlength="40" size="39"/>
									<%}else { %>
										<input type="text" name="homeAddr1" value="<%=homeAddr1==null?"":homeAddr1 %>" maxlength="40" size="39" readonly/>	
									<%} %>									
									</td>
								</tr>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="homeAddr2" value="<%=homeAddr2==null?"":homeAddr2 %>" maxlength="40" size="39"/>
									<%}else { %>
										<input type="text" name="homeAddr2" value="<%=homeAddr2==null?"":homeAddr2 %>" maxlength="40" size="39" readonly/>	
									<%} %>									
									</td>
								</tr>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="homeAddr3" value="<%=homeAddr3==null?"":homeAddr3 %>" maxlength="40" size="39"/>
									<%}else { %>
										<input type="text" name="homeAddr3" value="<%=homeAddr3==null?"":homeAddr3 %>" maxlength="40" size="39" readonly/>	
									<%} %>									
									</td>
								</tr>
								<tr>
									<td>
									<%if(viewAction||updateAction){ %>		
										<input type="text" name="homeAddr4" value="<%=homeAddr4==null?"":homeAddr4 %>" maxlength="40" size="39"/>
									<%}else { %>
										<input type="text" name="homeAddr4" value="<%=homeAddr4==null?"":homeAddr4 %>" maxlength="40" size="39" readonly/>	
									<%} %>									
									</td>
								</tr>																								
							</table>
							<td class="infoLabel" width="15%"></td>
							<td class="infoData2" width="25%">					
							</td>																
							</td>							
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4">*</font><bean:message key="prompt.docOfficeTel" /></td>		
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="officeTel" value="<%=officeTel==null?"":officeTel %>" maxlength="20" size="39"/>
							<%}else { %>
								<input type="text" name="officeTel" value="<%=officeTel==null?"":officeTel %>" maxlength="20" size="39" readonly/>		
							<%} %>
							</td>									
							<td class="infoLabe2" width="15%"><bean:message key="prompt.docOfficeFax" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="officeFax" value="<%=officeFax==null?"":officeFax %>" maxlength="20" size="39" />
							<%}else { %>
								<input type="text" name="officeFax" value="<%=officeFax==null?"":officeFax %>" maxlength="20" size="39" readonly/>		
							<%} %>
							</td>				
							<td class="infoLabe2" width="15%"><bean:message key="prompt.docEmail" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="email" value="<%=email==null?"":email %>" maxlength="70" size="39"/>
							<%}else { %>
								<input type="text" name="email" value="<%=email==null?"":email %>" maxlength="70" size="39" readonly/>	
							<%} %>
							</td>			
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><bean:message key="prompt.docPager" /></td>		
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="pager" value="<%=pager==null?"":pager %>" maxlength="20" size="39"/>
							<%}else { %>
								<input type="text" name="pager" value="<%=pager==null?"":pager %>" maxlength="20" size="39" readonly/>		
							<%} %>
							</td>							
							<td class="infoLabe2" width="15%"><font size="4">*</font><bean:message key="prompt.docMobile" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="mobile" value="<%=mobile==null?"":mobile %>" maxlength="20" size="39"/>
							<%}else { %>
								<input type="text" name="mobile" value="<%=mobile==null?"":mobile %>" maxlength="20" size="39" readonly/>		
							<%} %>
							</td>					
							<td class="infoLabe2" width="15%"><bean:message key="prompt.docHomeTel" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="homeTel" value="<%=homeTel==null?"":homeTel %>" maxlength="20" size="39"/>
							<%}else { %>
								<input type="text" name="homeTel" value="<%=homeTel==null?"":homeTel %>" maxlength="20" size="39" readonly/>		
							<%} %>
							</td>					
						</tr>						
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabe2" colspan=6 align="left">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform14" /></font>
							</td>							
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.docAcademic1" /></td>		
							<td class="infoData2" width="15%">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docAcademic1" value="<%=docAcademic1==null?"":docAcademic1 %>" maxlength="100" size="39"/>
							<%}else { %>
								<input type="text" name="docAcademic1" value="<%=docAcademic1==null?"":docAcademic1 %>" maxlength="100" size="39" readonly/>		
							<%} %>			
							</td>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.docDegree" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docDegree1" value="<%=docDegree1==null?"":docDegree1 %>" maxlength="100" size="39"/>
							<%}else { %>
								<input type="text" name="docDegree1" value="<%=docDegree1==null?"":docDegree1 %>" maxlength="100" size="39" readonly/>
							<%} %>			
							</td>	
							<td class="infoLabel" width="15%"><bean:message key="prompt.docAcademicDate" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docAcademicDate1" value="<%=docAcademicDate1==null?"":docAcademicDate1 %>" maxlength="10" size="39"/>
							<%}else { %>
								<input type="text" name="docAcademicDate1" value="<%=docAcademicDate1==null?"":docAcademicDate1 %>" maxlength="10" size="39" readonly/>		
							<%} %>			
							</td>
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.docAcademic2" /></td>		
							<td class="infoData2" width="15%">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docAcademic2" value="<%=docAcademic2==null?"":docAcademic2 %>" maxlength="100" size="39"/>
							<%}else { %>
								<input type="text" name="docAcademic2" value="<%=docAcademic2==null?"":docAcademic2 %>" maxlength="100" size="39" readonly/>		
							<%} %>			
							</td>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.docDegree" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docDegree2" value="<%=docDegree2==null?"":docDegree2 %>" maxlength="100" size="39"/>
							<%}else { %>
								<input type="text" name="docDegree2" value="<%=docDegree2==null?"":docDegree2 %>" maxlength="100" size="39" readonly/>
							<%} %>			
							</td>	
							<td class="infoLabel" width="15%"><bean:message key="prompt.docAcademicDate" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docAcademicDate2" value="<%=docAcademicDate2==null?"":docAcademicDate2 %>" maxlength="10" size="39"/>
							<%}else { %>
								<input type="text" name="docAcademicDate2" value="<%=docAcademicDate2==null?"":docAcademicDate2 %>" maxlength="10" size="39" readonly/>		
							<%} %>			
							</td>
						</tr>						
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.docSpecQual" /></td>		
							<td class="infoData2" width="15%">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docSpecQual" value="<%=docSpecQual==null?"":docSpecQual %>" maxlength="100" size="39"/>
							<%}else { %>
								<input type="text" name="docSpecQual" value="<%=docSpecQual==null?"":docSpecQual %>" maxlength="100" size="39" readonly/>		
							<%} %>			
							</td>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.since" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docSpecQualSince" value="<%=docSpecQualSince==null?"":docSpecQualSince %>" maxlength="10" size="39"/>
							<%}else { %>
								<input type="text" name="docSpecQualSince" value="<%=docSpecQualSince==null?"":docSpecQualSince %>" maxlength="10" size="39" readonly/>
							<%} %>			
							</td>
							<td class="infoLabe2" width="15%"></td>
							<td class="infoData2" width="25%">							
						</tr>						
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.hospital" /></td>		
							<td class="infoData2" width="15%">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docSpecQualHospital1" value="<%=docSpecQualHospital1==null?"":docSpecQualHospital1 %>" maxlength="100" size="39"/>
							<%}else { %>
								<input type="text" name="docSpecQualHospital1" value="<%=docSpecQualHospital1==null?"":docSpecQualHospital1 %>" maxlength="100" size="39" readonly/>		
							<%} %>			
							</td>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.from" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docSpecQualDateFrom1" value="<%=docSpecQualDateFrom1==null?"":docSpecQualDateFrom1 %>" maxlength="10" size="39"/>
							<%}else { %>
								<input type="text" name="docSpecQualDateFrom1" value="<%=docSpecQualDateFrom1==null?"":docSpecQualDateFrom1 %>" maxlength="10" size="39" readonly/>
							<%} %>			
							</td>	
							<td class="infoLabel" width="15%"><bean:message key="prompt.to" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docSpecQualDateTo1" value="<%=docSpecQualDateTo1==null?"":docSpecQualDateTo1 %>" maxlength="10" size="39"/>								
							<%}else { %>
								<input type="text" name="docSpecQualDateTo1" value="<%=docSpecQualDateTo1==null?"":docSpecQualDateTo1 %>" maxlength="10" size="39" readonly/>		
							<%} %>			
							</td>
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.hospital" /></td>		
							<td class="infoData2" width="15%">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docSpecQualHospital2" value="<%=docSpecQualHospital2==null?"":docSpecQualHospital2 %>" maxlength="100" size="39"/>
							<%}else { %>
								<input type="text" name="docSpecQualHospital2" value="<%=docSpecQualHospital2==null?"":docSpecQualHospital2 %>" maxlength="100" size="39" readonly/>		
							<%} %>			
							</td>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.from" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docSpecQualDateFrom2" value="<%=docSpecQualDateFrom2==null?"":docSpecQualDateFrom2 %>" maxlength="10" size="39"/>								
							<%}else { %>
								<input type="text" name="docSpecQualDateFrom2" value="<%=docSpecQualDateFrom2==null?"":docSpecQualDateFrom2 %>" maxlength="10" size="39" readonly/>
							<%} %>			
							</td>	
							<td class="infoLabel" width="15%"><bean:message key="prompt.to" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docSpecQualDateTo2" value="<%=docSpecQualDateTo2==null?"":docSpecQualDateTo2 %>" maxlength="10" size="39"/>	
							<%}else { %>
								<input type="text" name="docSpecQualDateTo2" value="<%=docSpecQualDateTo2==null?"":docSpecQualDateTo2 %>" maxlength="10" size="39" readonly/>		
							<%} %>			
							</td>
						</tr>
						<tr class="smallText basicInfo1" type='basicInfo1'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.docCTSNew01" /></td>		
							<td class="infoData2" width="85%" colspan=5>	
								<textarea name="medInfo" rows="6" cols="130" style="font-size:18px;"><%=medInfo==null?"":medInfo %></textarea>		
							</td>
						</tr>												
						<%-- End basicInfo2 --%>												
						<%-- basicInfo2 --%>
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoData2" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.docPrevPractice1" /></font>
							</td>							
						</tr>												
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform15" /></font>
							</td>							
						</tr>				
						<tr class="smallText basicInfo2" type='basicInfo2'>
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="adm.Address" /></td>		
							<td class="infoData2" width="85%" colspan="5">	
							<%if(viewAction||updateAction){ %>		
								<input type="text" name="docPrevPracticeAddr1" value="<%=docPrevPracticeAddr1==null?"":docPrevPracticeAddr1 %>" maxlength="100" size="150"/>
							<%}else { %>
								<input type="text" name="docPrevPracticeAddr1" value="<%=docPrevPracticeAddr1==null?"":docPrevPracticeAddr1 %>" maxlength="100" size="150" readonly/>		
							<%} %>			
							</td>
						</tr>						
						<tr class="smallText basicInfo2" type='basicInfo2'>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.from" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docPrevPracticeFrom1" value="<%=docPrevPracticeFrom1==null?"":docPrevPracticeFrom1 %>" maxlength="10" size="16"/>
							<%}else { %>
								<input type="text" name="docPrevPracticeFrom1" value="<%=docPrevPracticeFrom1==null?"":docPrevPracticeFrom1 %>" maxlength="10" size="16" readonly/>
							<%} %>			
							</td>
							<td class="infoData2" width="15%"></td>
							<td class="infoLabel" width="15%"><bean:message key="prompt.to" /></td>
							<td class="infoData2" width="25%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docPrevPracticeTo1" value="<%=docPrevPracticeTo1==null?"":docPrevPracticeTo1 %>" maxlength="10" size="16"/>
							<%}else { %>
								<input type="text" name="docPrevPracticeTo1" value="<%=docPrevPracticeTo1==null?"":docPrevPracticeTo1 %>" maxlength="10" size="16" readonly/>		
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
								<input type="text" name="docPrevPracticeFrom2" value="<%=docPrevPracticeFrom2==null?"":docPrevPracticeFrom2 %>" maxlength="10" size="16"/>
							<%}else { %>
								<input type="text" name="docPrevPracticeFrom2" value="<%=docPrevPracticeFrom2==null?"":docPrevPracticeFrom2 %>" maxlength="10" size="16" readonly/>
							<%} %>			
							</td>
							<td class="infoData2" width="15%"></td>
							<td class="infoLabel" width="15%"><bean:message key="prompt.to" /></td>
							<td class="infoData2" width="15%">
							<%if(viewAction||updateAction){ %>
								<input type="text" name="docPrevPracticeTo2" value="<%=docPrevPracticeTo2==null?"":docPrevPracticeTo2 %>" maxlength="10" size="16"/>
							<%}else { %>
								<input type="text" name="docPrevPracticeTo2" value="<%=docPrevPracticeTo2==null?"":docPrevPracticeTo2 %>" maxlength="10" size="16" readonly/>		
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
								<input type="text" name="docMemProSoc1" value="<%=docMemProSoc1==null?"":docMemProSoc1 %>" maxlength="100" size="150"/>
							<%}else { %>
								<input type="text" name="docMemProSoc1" value="<%=docMemProSoc1==null?"":docMemProSoc1 %>" maxlength="100" size="150" readonly/>		
							<%} %>			
							</td>
						</tr>						
						<tr class="smallText basicInfo2" type='basicInfo2'>		
							<td class="infoLabel" width="15%"><font size="4"></font><bean:message key="prompt.memStatus" /></td>
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
								<input type="text" name="docMemProSoc2" value="<%=docMemProSoc2==null?"":docMemProSoc2 %>" maxlength="100" size="150"/>
							<%}else { %>
								<input type="text" name="docMemProSoc2" value="<%=docMemProSoc2==null?"":docMemProSoc2 %>" maxlength="100" size="150" readonly/>		
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
								<input type="text" name="docAcademyOfMed1" value="<%=docAcademyOfMed1==null?"":docAcademyOfMed1 %>" maxlength="100" size="150"/>
							<%}else { %>
								<input type="text" name="docAcademyOfMed1" value="<%=docAcademyOfMed1==null?"":docAcademyOfMed1 %>" maxlength="100" size="150" readonly/>		
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
								<input type="text" name="docAcademyOfMed2" value="<%=docAcademyOfMed2==null?"":docAcademyOfMed2 %>" maxlength="100" size="150"/>
							<%}else { %>
								<input type="text" name="docAcademyOfMed2" value="<%=docAcademyOfMed2==null?"":docAcademyOfMed2 %>" maxlength="100" size="150" readonly/>		
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
							<td class="infoLabel" width="15%"><font size="4">*</font><bean:message key="prompt.HKMC_LICNO" /></td>
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
								<input type="textfield" name="docLicExpdate1" id="docLicExpdate1" class="datepickerfield" value="<%=docLicExpdate1==null?"":docLicExpdate1 %>" maxlength="10" size="16" onkeyup="validDate(this)" onblur="validDate(this)"/>
							<%}else { %>
								<input type="textfield" name="docLicExpdate1" id="docLicExpdate1" class="datepickerfield" value="<%=docLicExpdate1==null?"":docLicExpdate1 %>" maxlength="10" size="16" readonly/>		
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
								<input type="textfield" name="docLicExpdate2" id="docLicExpdate2" class="datepickerfield" value="<%=docLicExpdate2==null?"":docLicExpdate2 %>" maxlength="10" size="16" onkeyup="validDate(this)" onblur="validDate(this)"/>
							<%}else { %>
								<input type="textfield" name="docLicExpdate2" id="docLicExpdate2" class="datepickerfield" value="<%=docLicExpdate2==null?"":docLicExpdate2 %>" maxlength="10" size="16" readonly/>		
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
							<td class="infoData2" width="100%" colspan="6">						
	
							<display:table id="rowHS" name="requestScope.CTS" export="false">
								<display:setProperty name="basic.show.header" value="false" />
								<display:column property="fields1" title="&nbsp;" style="width:90%" sortable="false"/>
								<display:column title="&nbsp;" style="width:10%" sortable="false">
									<logic:equal name="rowHS" property="fields2" value="Y">
									<%if(viewAction||updateAction||checkAction){%>				
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="Y" checked="checked" onclick="return showAnswerField9(this)">Yes</input>
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="N" onclick="return showAnswerField9(this)">No</input>					
									<%}else{ %>
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="Y" checked="checked" disabled="disabled">Yes</input>
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="N" disabled="disabled">No</input>			
									<%} %>							 		
									</logic:equal>
									<logic:equal name="rowHS" property="fields2" value="N">						
									<%if(viewAction||updateAction||checkAction){%>			
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="Y" onclick="return showAnswerField9(this)">Yes</input>
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="N" checked="checked" onclick="return showAnswerField9(this)">No</input>
									<%}else{ %>
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="Y" disabled="disabled">Yes</input>
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="N" checked="checked" disabled="disabled">No</input>			
									<%} %>	
									</logic:equal>
									<logic:equal name="rowHS" property="fields2" value="0">									
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="Y" onclick="return showAnswerField9(this)">Yes</input>
										<input type="radio" name="HSRadio<c:out value="${rowHS.fields0}" />" value="N" onclick="return showAnswerField9(this)">No</input>	
									</logic:equal>
								</display:column>
								<display:column title="&nbsp;" style="width:0%" sortable="false" >
									<input type="hidden" name="supDtlHS<c:out value="${rowHS.fields0}" />" value="${requestScope.CTS[row_rowNum - 1].fields3}" />		
								</display:column>				
							</display:table>
							</td>	
						</tr>							
											
<%--														
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
									<input type=checkbox name="docHealthStatusYes3" value="Y" id="docHealthStatusYes3" checked="checked" />Yes&nbsp
									<input type=checkbox name="docHealthStatusNo3" value="N" id="docHealthStatusNo3"/>NO									
								<%}else{ %>
									<input type=checkbox name="docHealthStatusYes3" value="Y" id="docHealthStatusYes3" checked="checked" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docHealthStatusNo3" value="N" id="docHealthStatusNo3" disabled="disabled"/>NO									
								<%} %>
							<%} else if(docHealthStatus2!= null && "N".equals(docHealthStatus2)){ %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docHealthStatusYes3" value="N" id="docHealthStatusYes3"/>Yes&nbsp
									<input type=checkbox name="docHealthStatusNo3" value="Y" id="docHealthStatusNo3" checked="checked" />NO									
								<%}else{ %>
									<input type=checkbox name="docHealthStatusYes3" value="N" id="docHealthStatusYes2" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docHealthStatusNo3" value="Y" id="docHealthStatusNo3" checked="checked" disabled="disabled"/>NO	
								<%} %>
							<% } else { %>
								<%if(viewAction||updateAction){ %>		
									<input type=checkbox name="docHealthStatusYes3" value="N" id="docHealthStatusYes3"/>Yes&nbsp
									<input type=checkbox name="docHealthStatusNo3" value="N" id="docHealthStatusNo3"/>NO									
								<%}else{ %>
									<input type=checkbox name="docHealthStatusYes3" value="N" id="docHealthStatusYes3" disabled="disabled"/>Yes&nbsp							
									<input type=checkbox name="docHealthStatusNo3" value="N" id="docHealthStatusNo3" disabled="disabled"/>NO	
								<%} %>							
							<% }%>			
							</td>	
						</tr>
--%>						
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
								<input type="textfield" name="docInsureCarrExpDate" id="docInsureCarrExpDate" class="datepickerfield" value="<%=docInsureCarrExpDate==null?"":docInsureCarrExpDate %>" maxlength="10" size="16" onkeyup="validDate(this)" onblur="validDate(this)"/>
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
							<td class="infoData2" colspan="6">	
							<display:table id="rowOI" name="requestScope.CTS2" export="false">
								<display:setProperty name="basic.show.header" value="false" />
								<display:column property="fields1" title="&nbsp;" style="width:90%" sortable="false"/>
								<display:column title="&nbsp;" style="width:10%" sortable="false">
									<logic:equal name="rowOI" property="fields2" value="Y">
									<%if(viewAction||updateAction||checkAction){%>				
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="Y" checked="checked" onclick="return showAnswerField9(this)">Yes</input>
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="N" onclick="return showAnswerField9(this)">No</input>					
									<%}else{ %>
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="Y" checked="checked" disabled="disabled">Yes</input>
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="N" disabled="disabled">No</input>			
									<%} %>							 		
									</logic:equal>
									<logic:equal name="rowOI" property="fields2" value="N">						
									<%if(viewAction||updateAction||checkAction){%>			
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="Y" onclick="return showAnswerField9(this)">Yes</input>
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="N" checked="checked" onclick="return showAnswerField9(this)">No</input>
									<%}else{ %>
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="Y" disabled="disabled">Yes</input>
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="N" checked="checked" disabled="disabled">No</input>			
									<%} %>	
									</logic:equal>
									<logic:equal name="rowOI" property="fields2" value="0">									
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="Y" onclick="return showAnswerField9(this)">Yes</input>
										<input type="radio" name="OIRadio<c:out value="${rowOI.fields0}" />" value="N" onclick="return showAnswerField9(this)">No</input>	
									</logic:equal>
								</display:column>
								<display:column title="&nbsp;" style="width:0%" sortable="false" >
									<input type="hidden" name="supDtlOI<c:out value="${rowOI.fields0}" />" value="${requestScope.CTS[row_rowNum - 1].fields3}" />		
								</display:column>				
							</display:table>
							</td>	
						</tr>												
<%--						
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
--%>																																		
						<%-- End basicInfo3 --%>
						
						<%-- basicInfo4 --%>
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
								<input type="text" name="docProfRef1" value="<%=docProfRef1==null?"":docProfRef1 %>" maxlength="100" size="30"/>
							<%}else { %>
								<input type="text" name="docProfRef1" value="<%=docProfRef1==null?"":docProfRef1 %>" maxlength="100" size="30" readonly/>
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
								<input type="text" name="docProfRef2" value="<%=docProfRef2==null?"":docProfRef2 %>" maxlength="100" size="30"/>
							<%}else { %>
								<input type="text" name="docProfRef2" value="<%=docProfRef2==null?"":docProfRef2 %>" maxlength="100" size="30" readonly/>
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
								<table width="100%">
								<tr>		
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv0" <%if ("1".equals(checkPriv[0])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[0] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv0" <%if ("1".equals(checkPriv[0])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[0] %>						
									<%} %>			
									</td>
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv10" <%if ("1".equals(checkPriv[10])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[10] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPrivv" <%if ("1".equals(checkPriv[10])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[10] %>						
									<%} %>			
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv1" <%if ("1".equals(checkPriv[1])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[1] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv1" <%if ("1".equals(checkPriv[1])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[1] %>						
									<%} %>			
									</td>
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv11" <%if ("1".equals(checkPriv[11])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[11] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv11" <%if ("1".equals(checkPriv[11])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[11] %>						
									<%} %>			
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv2" <%if ("1".equals(checkPriv[2])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[2] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv2" <%if ("1".equals(checkPriv[2])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[2] %>						
									<%} %>			
									</td>
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv12" <%if ("1".equals(checkPriv[12])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[12] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv12" <%if ("1".equals(checkPriv[12])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[12] %>						
									<%} %>			
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv3" <%if ("1".equals(checkPriv[3])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[3] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv3" <%if ("1".equals(checkPriv[3])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[3] %>						
									<%} %>			
									</td>
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv13" <%if ("1".equals(checkPriv[13])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[13] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv13" <%if ("1".equals(checkPriv[13])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[13] %>						
									<%} %>			
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv4" <%if ("1".equals(checkPriv[4])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[4] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv4" <%if ("1".equals(checkPriv[4])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[4] %>						
									<%} %>			
									</td>
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv14" <%if ("1".equals(checkPriv[14])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[14] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv14" <%if ("1".equals(checkPriv[14])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[14] %>						
									<%} %>			
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv5" <%if ("1".equals(checkPriv[5])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[5] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv5" <%if ("1".equals(checkPriv[5])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[5] %>						
									<%} %>			
									</td>
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv15" <%if ("1".equals(checkPriv[15])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[15] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv15" <%if ("1".equals(checkPriv[15])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[15] %>						
									<%} %>			
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv6" <%if ("1".equals(checkPriv[6])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[6] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv6" <%if ("1".equals(checkPriv[6])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[6] %>						
									<%} %>			
									</td>
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv16" <%if ("1".equals(checkPriv[16])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[16] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv16" <%if ("1".equals(checkPriv[16])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[16] %>						
									<%} %>			
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv7" <%if ("1".equals(checkPriv[7])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[7] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv7" <%if ("1".equals(checkPriv[7])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[7] %>						
									<%} %>			
									</td>
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv17" <%if ("1".equals(checkPriv[17])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[17] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv17" <%if ("1".equals(checkPriv[17])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[17] %>						
									<%} %>			
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv8" <%if ("1".equals(checkPriv[8])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[8] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv8" <%if ("1".equals(checkPriv[8])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[8] %>						
									<%} %>			
									</td>
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv18" <%if ("1".equals(checkPriv[18])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[18] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv18" <%if ("1".equals(checkPriv[18])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[18] %>						
									<%} %>			
									</td>															
								</tr>
								<tr>		
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv9" <%if ("1".equals(checkPriv[9])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[9] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,1);" type="checkbox" value ="1" name="checkPriv9" <%if ("1".equals(checkPriv[9])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[9] %>						
									<%} %>			
									</td>
									<td width="50%" align="left">
									<%if(viewAction||updateAction){ %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv19" <%if ("1".equals(checkPriv[19])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[19] %>						
									<%}else { %>
										<input onclick="onCheckRows(this,2);" type="checkbox" value ="1" name="checkPriv19" <%if ("1".equals(checkPriv[19])) {%>checked="true"<%} %>/>
										<%=checkPrivDesc[19] %>						
									<%} %>			
									</td>															
								</tr>																																																
								</table>
							</td>							
						</tr>
						<%-- End basicInfo4 --%>										

						<%-- basicInfo5 --%>
						<tr class="smallText basicInfo5" type='basicInfo5'>
							<td colspan=6>
<hr noshade="noshade"/>
<%if("admin".equals(role) || "view".equals(command) || "save".equals(command)){ %>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu2" border="0 " width="100%">
	<tr class="smallText">
		<td><b>Attach documents from below</b></td>
	</tr>	
</table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">	
	<tr><td><bean:message key="prompt.ctsnew.attachment1" /></td><td>	
		<input type="file" name="file1" size="50" class="multi" maxlength="10"/>
		<span id="showDocument_indicator1">
<%String keyId1 = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId1 %>" />
	<jsp:param name="allowRemove" value="Y" />
	<jsp:param name="subKeyID" value="1" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
		</span>		
		</td>
	</tr>
	<tr><td><bean:message key="prompt.ctsnew.attachment2" /></td><td>	
		<input type="file" name="file2" size="50" class="multi" maxlength="10"/>
		<span id="showDocument_indicator2">
<%String keyId2 = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId2 %>" />
	<jsp:param name="allowRemove" value="Y" />
	<jsp:param name="subKeyID" value="2" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
		</span>		
		</td>
	</tr>
	<tr><td><bean:message key="prompt.ctsnew.attachment3" /></td><td>	
		<input type="file" name="file3" size="50" class="multi" maxlength="10"/>
		<span id="showDocument_indicator3">
<%String keyId3 = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId3 %>" />
	<jsp:param name="allowRemove" value="Y" />
	<jsp:param name="subKeyID" value="3" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
		</span>		
		</td>
	</tr>
	<tr><td><bean:message key="prompt.ctsnew.attachment4" /></td><td>	
		<input type="file" name="file4" size="50" class="multi" maxlength="10"/>
		<span id="showDocument_indicator4">
<%String keyId4 = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId4 %>" />
	<jsp:param name="allowRemove" value="Y" />
	<jsp:param name="subKeyID" value="4" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
		</span>		
		</td>
	</tr>
	<tr><td><bean:message key="prompt.ctsnew.attachment5" /></td><td>	
		<input type="file" name="file5" size="50" class="multi" maxlength="10"/>
		<span id="showDocument_indicator5">
<%String keyId5 = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId5 %>" />
	<jsp:param name="allowRemove" value="Y" />
	<jsp:param name="subKeyID" value="5" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
		</span>		
		</td>
	</tr>
	<tr><td><bean:message key="prompt.ctsnew.attachment6" /></td><td>	
		<input type="file" name="file6" size="50" class="multi" maxlength="10"/>
		<span id="showDocument_indicator6">
<%String keyId6 = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId6 %>" />
	<jsp:param name="allowRemove" value="Y" />
	<jsp:param name="subKeyID" value="6" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
		</span>		
		</td>
	</tr>
	<tr><td><bean:message key="prompt.ctsnew.attachment7" /></td><td>	
		<input type="file" name="file7" size="50" class="multi" maxlength="10"/>
		<span id="showDocument_indicator7">
<%String keyId7 = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId7 %>" />
	<jsp:param name="allowRemove" value="Y" />
	<jsp:param name="subKeyID" value="7" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
		</span>		
		</td>
	</tr>	
	<tr><td><bean:message key="prompt.ctsnew.attachment8" /></td><td>	
		<input type="file" name="file8" size="50" class="multi" maxlength="10"/>
		<span id="showDocument_indicator8">
<%String keyId8 = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId8 %>" />
	<jsp:param name="allowRemove" value="Y" />
	<jsp:param name="subKeyID" value="8" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
		</span>		
		</td>
	</tr>
	<tr><td><bean:message key="prompt.ctsnew.attachment9" /></td><td>	
		<input type="file" name="file9" size="50" class="multi" maxlength="10"/>
		<span id="showDocument_indicator9">
<%String keyId9 = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId9 %>" />
	<jsp:param name="allowRemove" value="Y" />
	<jsp:param name="subKeyID" value="9" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
		</span>		
		</td>
	</tr>	
	<tr><td><bean:message key="prompt.ctsnew.attachment10" /></td><td>	
		<input type="file" name="file10" size="50" class="multi" maxlength="10"/>
		<span id="showDocument_indicator10">
<%String keyId10 = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId10 %>" />
	<jsp:param name="allowRemove" value="Y" />
	<jsp:param name="subKeyID" value="10" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
		</span>		
		</td>
	</tr>
	<tr><td><bean:message key="prompt.ctsnew.attachment11" /></td><td>	
		<input type="file" name="file11" size="50" class="multi" maxlength="10"/>
		<span id="showDocument_indicator11">
<%String keyId11 = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId11 %>" />
	<jsp:param name="allowRemove" value="Y" />
	<jsp:param name="subKeyID" value="11" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
		</span>		
		</td>
	</tr>
	<tr><td><bean:message key="prompt.ctsnew.attachment12" /></td><td>	
		<input type="file" name="file12" size="50" class="multi" maxlength="10"/>
		<span id="showDocument_indicator12">
<%String keyId12 = folderId == null ? "" : folderId; %>
<jsp:include page="../common/document_list.jsp" flush="false">
	<jsp:param name="moduleCode" value="ctsnew" />
	<jsp:param name="keyID" value="<%=keyId12 %>" />
	<jsp:param name="allowRemove" value="Y" />
	<jsp:param name="subKeyID" value="12" />	
	<jsp:param name="siteCode" value="<%=ConstantsServerSide.SITE_CODE %>" />
</jsp:include>
		</span>		
		</td>
	</tr>						
</table>

<%} %>
						<tr class="smallText basicInfo5" type='basicInfo5'>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.renewform7" /></font>
							</td>							
						</tr>						
						<tr class="smallText basicInfo5" type='basicInfo5'>
							<td class="infoData2" colspan=6>
								<bean:message key="prompt.newForm.content7" />
								<br><br><bean:message key="prompt.newForm.content8" />
								<br><br><bean:message key="prompt.newForm.content9" />
							</td>							
						</tr>						
						<tr class="smallText basicInfo5" type='basicInfo5'>
							<td bgcolor="#CCCCFF" align="center" colspan=6>
								<input type=checkbox name="acceptAgr" value=""/>
								&nbsp;<b>* I hereby accept the above statement of agreement.</b>		
							</td>	
						</tr>
						<tr class="smallText basicInfo5" type='basicInfo5'>
							<td class="infoCenterLabel" colspan=6 align="center">
								<font style="font-size: 14pt;" size="2"><bean:message key="prompt.newForm03" /></font>
							</td>							
						</tr>
						<tr class="smallText basicInfo5" type='basicInfo5'>
							<td class="infoData2" colspan=6 align="center">
								<table width=100%>
								<tr align="left">
									<td>
										<font style="font-size: 11pt;" size="1">Click "Save" button to save your updates and make changes later.</font></br>
										<font style="font-size: 11pt;" size="1">Click "Submit" button to confirm information. No changes are allowed after confirmation.</font></br>							
									</td>
								</tr>
								<tr align="center">
									<td>
										<button title="<%=tooltipMap.get("saveBtn") %>" onclick="return submitAction('save','<%=ctsNo %>');"><bean:message key="button.save" /></button>
<%if(!"admin".equals(role) && (viewAction||updateAction)){ %>
 											<button title="<%=tooltipMap.get("submitBtn") %>" onclick="return submitAction('submit','<%=ctsNo %>');"><bean:message key="button.submit" /></button>
<%} %>													
									</td>							
								</tr>
								</table>
							</td>													
						</tr>
							</td>
						</tr>						
						<%-- End basicInfo5 --%>
																
					<%--prev/next step btn --%>

					<input type="hidden" name="command" value="<%=command%>"/>
					<input type="hidden" name="ctsNo" value="<%=ctsNo%>"/>
					<input type="hidden" name="formId" value="<%=formId %>"/>
					<input type="hidden" name="ctsStatus" value="<%=ctsStatus%>"/>
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

	if(document.getElementsByName("radioHSQ0003")[0]){
		showAnswerField9(document.getElementsByName("radioQ0003")[0]);
		if(document.getElementsByName("radioHSQ0009")[0]=='Y'){
			document.form1.ans9.value = document.getElementsByName("supDtlHSQ0003")[0].value;
		}		
		
	}	
		
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

		resetDatepicker(true);

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

function checkUploadFile(index) {
	var fileBox = $('#showDocument_indicator'+index);
	var fileBox2 = $('#MultiFile'+index+'_wrap_list');
	
	if (fileBox && fileBox.find('a').length ==0) {
		if (fileBox2 && fileBox2.find('a').length ==0) {
			return 1;
		}else{
			return 0;
		}
	}
}

function removeDocument(mid,subKeyID,did) {
	$.ajax({
		type: "POST",
		url: "../common/document_list.jsp",
		data: "command=delete&moduleCode=" + mid + "&keyID=<%=folderId %>&subKeyID="+ subKeyID +"&documentID=" + did + "&allowRemove=Y",
		success: function(values){

		if(values != '') {
			$("#showDocument_indicator"+subKeyID).html(values);
		}//if
		}//success
	});//$.ajax
	return false;
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

function submitAction(cmd, ctsNo) {
	var popMsg = null;

	for (var i = 1; i <= 12; i++) { 
		if (checkUploadFile(i)==1){	
			switch (i) {
			  case 1:
				popMsg = 'Please Attach recent photo.\n';
			    break;
			  case 2:
				popMsg = 'Please Attach Business Card.\n';
			    break;
			  case 3:
				popMsg = null; //Application form for special procedure with supporting documents (if applicable)
			    break;
			  case 4:
				popMsg = 'Please Attach Reference Letters .\n';				  
			    break;
			  case 5:
				popMsg = 'Please Attach CV\n';				  
			    break;
			  case 6:
				popMsg = 'Please Attach Certificate of Registration.\n';
			    break;
			  case 7:
				popMsg = null; //Certificate of Specialist Registration (if applicable)
			    break;
			  case 8:
				popMsg = 'Please Attach Certificates of relevant qualifications.\n';				  
			    break;
			  case 9:
				popMsg = 'Please Attach Annual Practicing Certificate.\n';				  
			    break;
			  case 10:
				popMsg = 'Please Attach Medical Protection Society Membership Certificate.\n';
			    break;			    
			  case 11:
				popMsg = null; //Please Attach Irradiating Apparatus Licence (For Cardiologists).
				break;
			  case 12:
				popMsg = 'Please Attach Autopay Form.\n';			    
			}
			if(popMsg!=null){
				alert(popMsg);
				return false;
			}
		}
	}
	if (document.reportForm.docfName.value == '') {
		alert('Please enter family name');
		$('div.stepBtn:first').trigger('click');
		document.reportForm.docfName.focus();		
		return false;
	}
	if (document.reportForm.docgName.value == '') {
		alert('Please enter given name');
		$('div.stepBtn:first').trigger('click');		
		document.reportForm.docgName.focus();
		return false;
	}
	if (document.reportForm.docAddr1.value == '') {
		alert('Please enter correspondence Address');
		$('div.stepBtn:first').trigger('click');		
		document.reportForm.docAddr1.focus();
		return false;
	}
	if (document.reportForm.homeAddr1.value == '') {
		alert('Please enter home Address');
		$('div.stepBtn:second').trigger('click');		
		document.reportForm.homeAddr1.focus();
		return false;
	}	
	if (document.reportForm.officeTel.value == '') {
		alert('Please enter office tel. NO.');
		$('div.stepBtn:first').trigger('click');		
		document.reportForm.officeTel.focus();
		return false;
	}	
	if (document.reportForm.mobile.value == '') {
		alert('Please enter mobile NO.');
		$('div.stepBtn:first').trigger('click');		
		document.reportForm.mobile.focus();
		return false;
	}
	if (document.reportForm.docLicNo1.value == '') {
		alert('Please enter Hong Kong Medical Council License Number');
		$('div.stepBtn[type=basicInfo2]').trigger('click');		
		document.reportForm.docLicNo1.focus();
		return false;
	}
		
	if(cmd=='save'){
		$('input[name=command]').val(cmd);
		$('input[name=ctsNo]').val(ctsNo);

		$(window).unbind('beforeunload', windowOnClose);
		popMsg = 'Saving..... Please wait.';
		
		document.reportForm.submit();
		
		$.prompt(popMsg,{
			prefix:'cleanblue', buttons: { }
		});		
		return false;
	}else if(cmd == 'submit') {
		if (document.reportForm.acceptAgr.checked==false) {
			alert('You must accept the statement of agreement before submission');
			document.reportForm.acceptAgr.focus();	
			return false;
		}
		popMsg = 'Submitting..... Please wait.'; 		
		$('input[name=command]').val(cmd);
		$('input[name=ctsNo]').val(ctsNo);		
		
		$(window).unbind('beforeunload', windowOnClose);
		
		document.reportForm.submit();		
		
		$.prompt(popMsg,{
			prefix:'cleanblue', buttons: { }
		});
		return false;
	}else{
		return false;		
	}	
	if (document.reportForm.docfName.value == '') {
		alert('Please enter family name');
		$('div.stepBtn:first').trigger('click');
		document.reportForm.docfName.focus();		
		return false;
	}
	if (document.reportForm.docgName.value == '') {
		alert('Please enter given name');
		$('div.stepBtn:first').trigger('click');		
		document.reportForm.docgName.focus();
		return false;
	}
	if (document.reportForm.docAddr1.value == '') {
		alert('Please enter correspondence Address');
		$('div.stepBtn:first').trigger('click');		
		document.reportForm.docAddr1.focus();
		return false;
	}
	if (document.reportForm.homeAddr1.value == '') {
		alert('Please enter home Address');
		$('div.stepBtn:second').trigger('click');		
		document.reportForm.homeAddr1.focus();
		return false;
	}	
	if (document.reportForm.officeTel.value == '') {
		alert('Please enter office tel. NO.');
		$('div.stepBtn:first').trigger('click');		
		document.reportForm.officeTel.focus();
		return false;
	}	
	if (document.reportForm.mobile.value == '') {
		alert('Please enter mobile NO.');
		$('div.stepBtn:first').trigger('click');		
		document.reportForm.mobile.focus();
		return false;
	}
	if (document.reportForm.docLicNo1.value == '') {
		alert('Please enter Hong Kong Medical Council License Number');
		$('div.stepBtn[type=basicInfo2]').trigger('click');		
		document.reportForm.docLicNo1.focus();
		return false;
	}	

	if(cmd=='save'){
		popMsg = 'Saving..... Please wait.';
		
//		$('input[name=command]').val(command);
//		$('input[name=ctsNo]').val(ctsNo);

		document.reportForm.command.value = cmd;		
		document.reportForm.ctsNo.value = ctsNo;
						
		$(window).unbind('beforeunload', windowOnClose);
			
		document.reportForm.submit();
		
		$.prompt(popMsg,{
				prefix:'cleanblue', buttons: { }
		});
		return false;
	}else if(command == 'submit') {
		if (document.reportForm.acceptAgr.checked==false) {
			alert('You must accept the statement of agreement before submission');
			document.reportForm.acceptAgr.focus();	
			return false;
		}
		popMsg = 'Submitting..... Please wait.';
		$('form').attr('action', 'newDocFormPreview.jsp');  
		
//		$('input[name=command]').val(command);
//		$('input[name=ctsNo]').val(ctsNo);

		document.reportForm.command.value = command;		
		document.reportForm.ctsNo.value = ctsNo;
		
		$(window).unbind('beforeunload', windowOnClose);
			
		document.reportForm.submit();
		
		$.prompt(popMsg,{
				prefix:'cleanblue', buttons: { }
		});
		return false;
	}else{
		return false;		
	}		
}

// Popup window code
function newPopup(url) {
	popupWindow = window.open(
		url,'popUpWindow','height=750,width=750,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes');
}

</script>
			</DIV>
		</DIV>
	</DIV>
	<jsp:include page="../common/footer.jsp" flush="false" />	
</body>
<%
	} 
%>
</html:html>