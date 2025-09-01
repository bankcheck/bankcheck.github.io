<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.apache.commons.lang.time.DateUtils"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.servlet.HKAHInitServlet"%>
<%@ page import="net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter"%>


<%!
public class BedOccuBookingDetails{
	String room;
	String roomClass;
	String gender;
	String diagnosis;
	String doctor;
	String admissionDate;
	String status;
	String tentativeDisDate;
	
	String nextTentativeAdmissionTwo;
	String doctorTwo;
	String diagnosisTwo;
	String tentativeDisDateTwo;
	
	String nextTentativeAdmissionThree;
	String tentativeDisDateThree;
	
	String[] days = new String[7];
	
	
	public BedOccuBookingDetails(String room, String roomClass,	String gender, String diagnosis, String doctor,
								 String admissionDate, String status, String tentativeDisDate,
								 String nextTentativeAdmissionTwo, String doctorTwo, String diagnosisTwo, String tentativeDisDateTwo,
								 String nextTentativeAdmissionThree, String tentativeDisDateThree,
								 String[] days){
		this.room = room;
		this.roomClass = roomClass;
		this.gender = gender;
		this.diagnosis = diagnosis;
		this.doctor = doctor;
		this.admissionDate = admissionDate;
		this.status = status;
		this.tentativeDisDate = tentativeDisDate;
		
		this.nextTentativeAdmissionTwo = nextTentativeAdmissionTwo;
		this.doctorTwo = doctorTwo;
		this.diagnosisTwo = diagnosisTwo;
		this.tentativeDisDateTwo = tentativeDisDateTwo;
		
		this.nextTentativeAdmissionThree = nextTentativeAdmissionThree;
		this.tentativeDisDateThree = tentativeDisDateThree;
		
		this.days = days;	
	}
}

public class BedOccuBookingDetailsTwo{	
	String bedCode;
	String nextTentativeAdmissionTwo;
	String doctorTwo;	
	String tentativeDisDateTwo;	
	String pbpId;
	public BedOccuBookingDetailsTwo(String bedCode, String nextTentativeAdmissionTwo, String doctorTwo, String tentativeDisDateTwo, String pbpId){
		this.bedCode = bedCode;		
		this.nextTentativeAdmissionTwo = nextTentativeAdmissionTwo;
		this.doctorTwo = doctorTwo;		
		this.tentativeDisDateTwo = tentativeDisDateTwo;		
		this.pbpId = pbpId;	
	}
}

private String[] isBedOccupied(String admissionDate, String tentativeDisDate,
							   String nextTentativeAdmissionTwo, String tentativeDisDateTwo,
							   String nextTentativeAdmissionThree, String tentativeDisDateThree) throws Exception{
	String[] days = new String[7];
	days[0] = "";
	days[1] = "";
	days[2] = "";
	days[3] = "";
	days[4] = "";
	days[5] = "";
	days[6] = "";	
		
	if(admissionDate.length() > 0 && tentativeDisDate.length() == 0){
		days[0] = "/ r";
		days[1] = "/ r";
		days[2] = "/ r";
		days[3] = "/ r";
		days[4] = "/ r";
		days[5] = "/ r";
		days[6] = "/ r";
	} 
	
	days = calculateDateColor(admissionDate, tentativeDisDate, days, "r");
	days = calculateDateColor(nextTentativeAdmissionTwo, tentativeDisDateTwo, days, "g");
	days = calculateDateColor(nextTentativeAdmissionThree, tentativeDisDateThree, days, "o");
	 	 
	return days;
}


private String[] calculateDateColor(String admissionDate, String dischargeDate, String[] days, String color) throws Exception{
	
	if (admissionDate.length() > 0 && dischargeDate.length() == 0) {
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		
		//Calendar today = new GregorianCalendar(2015,1,13);
		Calendar today = Calendar.getInstance();
		today.set(Calendar.HOUR_OF_DAY, 0);
		today.set(Calendar.MINUTE, 0);
		today.set(Calendar.SECOND, 0);
		today.set(Calendar.MILLISECOND, 0);
		
		//Date nextAppDate = sdf.parse("16/02/2015");
		Date nextAppDate = sdf.parse(admissionDate);							
		Calendar nextAppCal = Calendar.getInstance();
    	nextAppCal.setTime(nextAppDate);
    	
		for(int i = 1; i <= 7; i++){
			if( today.compareTo(nextAppCal) == 0){
				if(!(days[i-1].length() > 0)){
					days[i-1] = "/ " + color;
				}
			} else if ( today.compareTo(nextAppCal) == 1){
				if(!(days[i-1].length() > 0)){
					days[i-1] = "/ "+ color;
				}
			} else if (today.compareTo(nextAppCal) == -1){
				if(!(days[i-1].length() > 0)){
					days[i-1] = "";
				}
			}
			today.add(Calendar.DATE, 1);
		}							
	} else if (admissionDate.length() > 0 && dischargeDate.length() > 0) {
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
		
		//Calendar today = new GregorianCalendar(2015,1,13);
		Calendar today = Calendar.getInstance();
		today.set(Calendar.HOUR_OF_DAY, 0);
		today.set(Calendar.MINUTE, 0);
		today.set(Calendar.SECOND, 0);
		today.set(Calendar.MILLISECOND, 0);
		
		//Date nextAppDate = sdf.parse("16/02/2015");
		Date nextAppDate = sdf.parse(admissionDate);							
		Date nextAppDisDate = sdf.parse(dischargeDate);
		Calendar nextAppCal = Calendar.getInstance();
    	nextAppCal.setTime(nextAppDate);
    	Calendar nextAppDisCal = Calendar.getInstance();
    	nextAppDisCal.setTime(nextAppDisDate);
    	
		for(int i = 1; i <= 7; i++){
			if( today.compareTo(nextAppCal) == 0){
				if(!(days[i-1].length() > 0)){
					days[i-1] = "/ "+ color;
				}
			} else if (today.compareTo(nextAppDisCal) == 0){
				if(!(days[i-1].length() > 0)){
					days[i-1] = "/ "+ color;
				}
			} else if ( today.compareTo(nextAppCal) == 1 && today.compareTo(nextAppDisCal) == -1){				
				if(!(days[i-1].length() > 0)){
					days[i-1] = "/ "+ color;
				}
			} else if (today.compareTo(nextAppCal) == -1){
				if(!(days[i-1].length() > 0)){
					days[i-1] = "";
				}
			}
			today.add(Calendar.DATE, 1);
		}							
	}  
	return days;
}

private boolean isAccessible(HttpServletRequest request, UserBean userBean) {
	boolean ret = false;
	String userID = request.getParameter("userID");
	String moduleCode = request.getParameter("moduleCode");
	moduleCode = moduleCode == null ? moduleCode : moduleCode.toLowerCase();
	String accessGranted = (String) request.getSession().getAttribute("function.osb.bedOccuAndBooking.list");
	
	if (moduleCode != null && userID != null) {
		userBean = new UserBean(request);
		if (userBean.isAdmin()) {
			ret = true;
		} else {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT module_user_id  ");
			sqlStr.append("FROM SSO_USER_MAPPING ");
			sqlStr.append("WHERE MODULE_CODE = 'hk.portal' ");
			sqlStr.append("AND ENABLED = 1 ");
			sqlStr.append("AND SSO_USER_ID = (SELECT SSO_USER_ID ");
			sqlStr.append("FROM SSO_USER_MAPPING ");
			sqlStr.append("WHERE MODULE_CODE = ? AND MODULE_USER_ID = ? AND ENABLED = 1) ");
			
			ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListSEED(sqlStr.toString(), new String[]{moduleCode, userID});
			ReportableListObject row = null;
			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				String portalLoginID = row.getValue(0);
				userBean = UserDB.getUserBeanSkipPassword(request, portalLoginID);
				ret = userBean != null && userBean.isAccessible("function.osb.bedOccuAndBooking.list");
			}
		}
	} else if ("Y".equals(accessGranted)) {
		ret = true;
	}
	if (ret) {
		request.getSession().setAttribute("function.osb.bedOccuAndBooking.list", "Y");
	} else {
		request.getSession().removeAttribute("function.osb.bedOccuAndBooking.list");
	}
	
	return ret;
}
%>
<%
UserBean userBean = new UserBean(request);

if (isAccessible(request, userBean)) {
	//System.out.println("Access granted.");
} else {
	//System.out.println("Access denied.");
%>
Access restricted. Please use CIS to access Bed Occupancy and Booking Details Report.
<%	
	return;
}

String ward = request.getParameter("ward");
String doctorCode = request.getParameter("doctorCode");
String command = request.getParameter("command");

ArrayList osbReportTwo = OsbDB.getBedOccuBookingReportTwo();
ArrayList<BedOccuBookingDetailsTwo> listOfBedBookingDetailsTwo = new ArrayList<BedOccuBookingDetailsTwo>();
if( osbReportTwo.size() != 0){
	ReportableListObject osbReportTwoObject = null;
	for (int j = 0; j < osbReportTwo.size(); j++) {
		osbReportTwoObject = (ReportableListObject) osbReportTwo.get(j);
		String bedCode = osbReportTwoObject.getValue(0);
		String nextTentativeAdmissionTwo = osbReportTwoObject.getValue(1);
		String doctorTwo = osbReportTwoObject.getValue(2);		
		String tentativeDisDateTwo = osbReportTwoObject.getValue(3);
		String pbpId = osbReportTwoObject.getValue(4);
		
		listOfBedBookingDetailsTwo.add(new BedOccuBookingDetailsTwo(bedCode, nextTentativeAdmissionTwo, doctorTwo, tentativeDisDateTwo, pbpId));
	}
}


ArrayList osbReportOne = OsbDB.getBedOccuBookingReportOne(ward, doctorCode);
ArrayList<BedOccuBookingDetails> listOfBedBookingDetails = new ArrayList<BedOccuBookingDetails>();

if( osbReportOne.size() != 0){	
	ReportableListObject osbReportOneObject = null;
	for (int i = 0; i < osbReportOne.size(); i++) {
		String room = "";
		String roomClass = "";
		String gender = "";
		String diagnosis = "";
		String doctor = "";
		String admissionDate = "";
		String status = "";
		String tentativeDisDate = "";
		
		String nextTentativeAdmissionTwo = "";
		String doctorTwo = "";
		String diagnosisTwo = "";
		String tentativeDisDateTwo = "";
		
		String nextTentativeAdmissionThree = "";
		String tentativeDisDateThree = "";
						
		osbReportOneObject = (ReportableListObject) osbReportOne.get(i);
		room = osbReportOneObject.getValue(1);
		roomClass = osbReportOneObject.getValue(2);
		gender = osbReportOneObject.getValue(3);
		diagnosis = osbReportOneObject.getValue(4);
		doctor = osbReportOneObject.getValue(5);
		admissionDate = osbReportOneObject.getValue(6);
		status = osbReportOneObject.getValue(7);
		tentativeDisDate = osbReportOneObject.getValue(8);
		
		int k = 0;
		for( BedOccuBookingDetailsTwo bdt : listOfBedBookingDetailsTwo){
			if(bdt.bedCode.equals(room)){
				if(k==0){
					k++;
					nextTentativeAdmissionTwo = bdt.nextTentativeAdmissionTwo;
					doctorTwo = bdt.doctorTwo;
					tentativeDisDateTwo = bdt.tentativeDisDateTwo;
					
					ArrayList osbDiagnosis = OsbDB.getDiagnosis(bdt.pbpId);
					if( osbDiagnosis.size() != 0){
						ReportableListObject osbDiagnosisObject = (ReportableListObject) osbDiagnosis.get(0);
						diagnosisTwo = osbDiagnosisObject.getValue(0);
					}
				} else if(k==1){
					k++;
					nextTentativeAdmissionThree = bdt.nextTentativeAdmissionTwo;
					tentativeDisDateThree = bdt.tentativeDisDateTwo;
				} else {
					break;
				}
			}
		}
				
		String[] days = isBedOccupied(admissionDate, tentativeDisDate, 
				  nextTentativeAdmissionTwo, tentativeDisDateTwo,
				  nextTentativeAdmissionThree, tentativeDisDateThree);
		
		listOfBedBookingDetails.add(new BedOccuBookingDetails(room, roomClass, gender, diagnosis, doctor,
									 admissionDate, status, tentativeDisDate, 
									 nextTentativeAdmissionTwo, doctorTwo, diagnosisTwo, tentativeDisDateTwo, 
									 nextTentativeAdmissionThree, tentativeDisDateThree, days));
	}
} 

if (osbReportOne.size() > 0 && "export".equals(command) ) {
	File reportFile = new File(application.getRealPath("/report/RPT_OSB_BEDOCCU.jasper"));
	File reportDir = new File(application.getRealPath("/report/"));
	String dateStr = null;
	

	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		
		Map parameters = new HashMap();
				
		parameters.put("SUBREPORT_DIR",reportDir.getPath()+"\\");
		parameters.put("WRDCODE", ward);
		parameters.put("DOCCODE", doctorCode);
		
		Calendar today = Calendar.getInstance(); 
		parameters.put("today", today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US));
		today.add(Calendar.DATE, 1);
		parameters.put("todayOne", today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US));
		today.add(Calendar.DATE, 1);
		parameters.put("todayTwo", today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US));
		today.add(Calendar.DATE, 1);
		parameters.put("todayThree", today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US));
		today.add(Calendar.DATE, 1);
		parameters.put("todayFour", today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US));
		today.add(Calendar.DATE, 1);
		parameters.put("todayFive", today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US));
		today.add(Calendar.DATE, 1);
		parameters.put("todaySix", today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US));
		
		
		ArrayList parsedRecord = new ArrayList();
		for (BedOccuBookingDetails b : listOfBedBookingDetails){
			ReportableListObject dummyObject = new ReportableListObject(21);
			dummyObject.setValue(0, b.room);
			dummyObject.setValue(1, b.roomClass);
			dummyObject.setValue(2, b.gender);
			dummyObject.setValue(3, b.diagnosis);
			dummyObject.setValue(4, b.doctor);
			dummyObject.setValue(5, b.admissionDate);
			dummyObject.setValue(6, b.status);
			dummyObject.setValue(7, b.tentativeDisDate);
			
			dummyObject.setValue(8, b.nextTentativeAdmissionTwo);
			dummyObject.setValue(9, b.doctorTwo);
			dummyObject.setValue(10, b.diagnosisTwo);
			dummyObject.setValue(11, b.tentativeDisDateTwo);
			
			dummyObject.setValue(12, b.nextTentativeAdmissionThree);
			dummyObject.setValue(13, b.tentativeDisDateThree);
						
			for(int i = 0; i < b.days.length ; i++){
				dummyObject.setValue(14 + i, b.days[i]);
			}	
			parsedRecord.add(dummyObject);
		}

		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport,
				parameters,
				new ReportMapDataSource(parsedRecord, new String[]{"room", "roomClass", "gender", "diagnosis","doctor",
																	"admissionDate", "status", "tentativeDisDate",
																	"nextTentativeAdmissionTwo", "doctorTwo",
																	"diagnosisTwo", "tentativeDisDateTwo",
																	"nextTentativeAdmissionThree", "tentativeDisDateThree",
																	"day", "dayOne", "dayTwo", "dayThree", "dayFour",
																	"dayFive", "daySix"}
																	,null));

		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/vnd.ms-excel");
		response.setHeader("Content-Disposition", "attachment;filename=BedOccuAndBookingReport_" + tsFormat.format(new Date()) + ".xls");
		JRXlsExporter exporterXLS = new JRXlsExporter();
		exporterXLS.setParameter(JRXlsExporterParameter.JASPER_PRINT, jasperPrint);
		exporterXLS.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, ouputStream);
		exporterXLS.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
		exporterXLS.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, false);
		exporterXLS.setParameter(JRXlsExporterParameter.IS_AUTO_DETECT_CELL_TYPE, true);
		exporterXLS.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, false);
		exporterXLS.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, true);
		
		exporterXLS.exportReport();
		ouputStream.flush();
		ouputStream.close();

		return;
	}
	
	
}
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp" />
	<style>
		.pinkHeader {
			background-color: #fbe2e2;
			font-weight:bold;
		}
		.lightBlueHeader {
			background-color: #E1EFFF;
			font-weight:bold;
		}
		.lightGreenHeader {
			background-color: #C2D6AD;
			font-weight:bold;
		}
		.lightOrangeHeader {
			background-color: #ffdb99;
			font-weight:bold;
		}
		.vip {
			background-color: #fbbc49;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
		.private {
			background-color: #a0d06d;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
		.semiPrivate{
			background-color: #c0d9f6;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
		.standard{
			background-color: #ffd5d5;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
	</style>
	<body>
		<div id="indexWrapper">
			<div id="mainFrame">
				<div id="contentFrame">
					<jsp:include page="../common/page_title.jsp" flush="false">
						<jsp:param name="pageTitle" value="function.osb.bedOccuAndBooking.list" />
						<jsp:param name="mustLogin" value="N" />
					</jsp:include>
					
					<table >
						<tr>
							<td>
								<form name="search_form" action="bedOccuAndBooking.jsp" method="post">
									<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">																			
										<tr class="smallText">
											<td class="infoTitle" colspan="2">Selection for Bed Occupancy and Booking Details Report</td>
										</tr>										
										<tr class="smallText">
											<td class="infoLabel" style="width:30%">Ward :</td>
											<td class="infoData" style="width:70%">
												<select name="ward">
												<jsp:include page="../ui/wardCMB.jsp" flush="false">
													<jsp:param name="wrdCode" value="<%=ward %>" />
													<jsp:param name="allowAll" value="Y" />
													<jsp:param name="allowEmpty" value="N" />
												</jsp:include>
												</select>
											</td>											
										</tr>
										<tr class="smallText">
											<td class="infoLabel" width="30%">Physician :</td>
											<td class="infoData" width="70%">
												<select name="doctorCode">
												<option value="">--- ALL ---</option>
												<jsp:include page="../ui/docCodeCMB.jsp" flush="false">
													<jsp:param name="selectFrom" value="all" />
													<jsp:param name="doccode" value="<%=doctorCode %>" />
												</jsp:include>
												</select>
											</td>
										</tr>	
									
										
										<tr class="smallText">
											<td align="left" >
												<button name="btn-export" onclick="return submitAction('export', '');">Export</button>
											</td>
											<td>
												<button onclick="return submitSearch();">Generate</button>
												<button onclick="return clearSearch();">Cancel</button>
											
											</td>
										</tr>
									</table>
									<input type="hidden" name="command" />																	
								</form>
							</td>							
						</tr>
					</table>
					
					<div style="width:100%;text-align: center;">as of <%=(new java.text.SimpleDateFormat("MMMMM dd, yyyy",Locale.ENGLISH)).format(new java.util.Date())%></div>
					<table border='1' style="background-color: white;border-collapse: collapse;text-align:center; border: 1px solid black;">
					<tr style='vertical-align: bottom;'>
						<td class='pinkHeader'>Room</td>
						<td class='pinkHeader'>Class</td>
						<td class='pinkHeader'>Gender</td>
						<td class='pinkHeader' style='text-align:left'>Diagnosis / Procedure</td>
						<td class='pinkHeader' style='text-align:left'>Doctor</td>
						<td class='pinkHeader'>Admission Date</td>
						<td class='pinkHeader'>Status</td>
						<td class='pinkHeader'>Tentative Discharge Date</td>
						<%Calendar today = Calendar.getInstance(); %>
						<td class='lightBlueHeader' width='25px'><%=today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US) %></td>
						<%today.add(Calendar.DATE, 1); %>
						<td class='lightBlueHeader' width='25px'><%=today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US) %></td>
						<%today.add(Calendar.DATE, 1); %>
						<td class='lightBlueHeader' width='25px'><%=today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US) %></td>
						<%today.add(Calendar.DATE, 1); %>
						<td class='lightBlueHeader' width='25px'><%=today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US) %></td>
						<%today.add(Calendar.DATE, 1); %>
						<td class='lightBlueHeader' width='25px'><%=today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US) %></td>
						<%today.add(Calendar.DATE, 1); %>
						<td class='lightBlueHeader' width='25px'><%=today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US) %></td>
						<%today.add(Calendar.DATE, 1); %>
						<td class='lightBlueHeader' width='25px'><%=today.getDisplayName(Calendar.DAY_OF_WEEK, Calendar.SHORT, Locale.US) %></td>
						<td class='lightGreenHeader'>Next Tentative Admission</td>
						<td class='lightGreenHeader' style='text-align:left'>Doctor</td>
						<td class='lightGreenHeader' style='text-align:left'>Diagnosis / Procedure</td>
						<td class='lightGreenHeader'>Tentative Discharge Date</td>
						<td class='lightOrangeHeader'>Next Tentative Admission</td>
						<td class='lightOrangeHeader'>Tentative Discharge Date</td>
					</tr>
<%
					for(BedOccuBookingDetails bedBookingDetails : listOfBedBookingDetails){
%>
					<tr style='vertical-align: top;'>
<%
						String roomClassColor = "";
						String roomClassName = bedBookingDetails.roomClass;
						if("I".equals(bedBookingDetails.roomClass)){
							roomClassColor = "vip";
							roomClassName = "V";
						} else if("P".equals(bedBookingDetails.roomClass)){
							roomClassColor = "private";
							roomClassName = "P";
						} else if("S".equals(bedBookingDetails.roomClass)){
							roomClassColor = "semiPrivate";
							roomClassName = "SP";
						} else {
							roomClassColor = "standard";
							roomClassName = "S";
						}
%>					
						<td class='<%=roomClassColor%>'><%=bedBookingDetails.room %></td>
						<td ><%=roomClassName %></td>
						<td ><%=bedBookingDetails.gender %></td>
						<td style='text-align:left'><%=bedBookingDetails.diagnosis %></td>
						<td style='text-align:left'><%=bedBookingDetails.doctor %></td>						
						<td><%=bedBookingDetails.admissionDate %></td>
						<td><%=bedBookingDetails.status %></td>
						<td><%=bedBookingDetails.tentativeDisDate %></td>
						<td style="background-color:<%=(bedBookingDetails.days[0].contains("r")?"#ff4d4d":bedBookingDetails.days[0].contains("g")?"#90ee90":bedBookingDetails.days[0].contains("o")?"#ffa500":"") %>"><%=bedBookingDetails.days[0].split(" ")[0] %></td>
						<td style="background-color:<%=(bedBookingDetails.days[1].contains("r")?"#ff4d4d":bedBookingDetails.days[1].contains("g")?"#90ee90":bedBookingDetails.days[1].contains("o")?"#ffa500":"") %>"><%=bedBookingDetails.days[1].split(" ")[0] %></td>
						<td style="background-color:<%=(bedBookingDetails.days[2].contains("r")?"#ff4d4d":bedBookingDetails.days[2].contains("g")?"#90ee90":bedBookingDetails.days[2].contains("o")?"#ffa500":"") %>"><%=bedBookingDetails.days[2].split(" ")[0] %></td>
						<td style="background-color:<%=(bedBookingDetails.days[3].contains("r")?"#ff4d4d":bedBookingDetails.days[3].contains("g")?"#90ee90":bedBookingDetails.days[3].contains("o")?"#ffa500":"") %>"><%=bedBookingDetails.days[3].split(" ")[0] %></td>
						<td style="background-color:<%=(bedBookingDetails.days[4].contains("r")?"#ff4d4d":bedBookingDetails.days[4].contains("g")?"#90ee90":bedBookingDetails.days[4].contains("o")?"#ffa500":"") %>"><%=bedBookingDetails.days[4].split(" ")[0] %></td>
						<td style="background-color:<%=(bedBookingDetails.days[5].contains("r")?"#ff4d4d":bedBookingDetails.days[5].contains("g")?"#90ee90":bedBookingDetails.days[5].contains("o")?"#ffa500":"") %>"><%=bedBookingDetails.days[5].split(" ")[0] %></td>
						<td style="background-color:<%=(bedBookingDetails.days[6].contains("r")?"#ff4d4d":bedBookingDetails.days[6].contains("g")?"#90ee90":bedBookingDetails.days[6].contains("o")?"#ffa500":"") %>"><%=bedBookingDetails.days[6].split(" ")[0] %></td>
						<td><%=bedBookingDetails.nextTentativeAdmissionTwo%></td>
						<td style='text-align:left'><%=bedBookingDetails.doctorTwo %></td>
						<td style='text-align:left'><%=bedBookingDetails.diagnosisTwo %></td>
						<td><%=bedBookingDetails.tentativeDisDateTwo %></td>
						
						<td><%=bedBookingDetails.nextTentativeAdmissionThree %></td>
						<td><%=bedBookingDetails.tentativeDisDateThree %></td>					
					</tr>					
						
						
<%					
					}
%>

					</table>
<br/>
<br/>
<table>
<tr>
	<td >
		<button type="button"style="vertical-align:middle;width:40px; height:20px" class = "vip ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"></button> V - VIP, Pearl<br/>
		<button type="button"style="vertical-align:middle;width:40px; height:20px" class = "private ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"></button> P - Private, Single Room<br/>
		<button type="button"style="vertical-align:middle;width:40px; height:20px" class = "semiPrivate ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"></button> SP - Semi-private, Step-down Ward<br/>
		<button type="button"style="vertical-align:middle;width:40px; height:20px" class = "standard ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"></button> S - Standard<br/>
	</td>
</tr>	
</table>			
					<script language="javascript">
						function submitSearch() {
							showOverLay('body');
							showLoadingBox('body', 100, 350);
							document.search_form.command.value = '';
							document.search_form.submit();
						}
						
						function clearSearch() {							
							document.search_form.ward.value = "";
							document.search_form.doctorCode.value = "";
							
						}
						
						function submitAction(cmd, eid) {
							
							if (cmd == 'export') {
								document.search_form.command.value = 'export';
								
								document.search_form.submit();
							}
							return false;
						}
					</script>
				</div>
			</div>
		</div>
	</body>
</html:html>