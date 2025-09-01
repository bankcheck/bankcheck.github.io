<meta name = "format-detection" content = "telephone=no">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%!
public class OTDateRecord {
	String otPatNo;
	String otDate;
	public OTDateRecord(String otPatNo, String otDate) {
		this.otPatNo = otPatNo;
		this.otDate = otDate;
	}
}

private static ArrayList getOTdate(String patList) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT A.PATNO, A.DDATE ");
	sqlStr.append("FROM ");
	sqlStr.append("( ");
	sqlStr.append("  SELECT OT.PATNO,TO_CHAR(OT.OTAOSDATE , 'DD/MM/YYYY HH24:MI:SS') AS DDATE, MIN(ABS(OT.OTAOSDATE-SYSDATE)) AS DIFF, MIN(OT.OTAOSDATE-SYSDATE) AS ACTIVE ");
	sqlStr.append("  FROM OT_APP@IWEB OT ");
	sqlStr.append("  GROUP BY OT.PATNO, TO_CHAR(OT.OTAOSDATE , 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("  ORDER BY MIN(ABS(OT.OTAOSDATE-SYSDATE)) ");
	sqlStr.append(") A, ");
	sqlStr.append("( ");
	sqlStr.append("  SELECT OT.PATNO, MIN(ABS(OT.OTAOSDATE-SYSDATE)) AS MINDIFF ");
	sqlStr.append("  FROM OT_APP@IWEB OT ");
	sqlStr.append("  GROUP BY OT.PATNO ");
	sqlStr.append(") B ");
	sqlStr.append("WHERE A.DIFF = B.MINDIFF ");
	sqlStr.append("AND A.PATNO = B.PATNO ");
	sqlStr.append("AND A.PATNO IN ("+ patList+") ");
	sqlStr.append("AND A.PATNO NOT IN ( ");
	sqlStr.append("	SELECT DISTINCT P.PATNO ");
	sqlStr.append("	FROM OT_APP@IWEB OT,PAT_SERVICES P ");
	sqlStr.append("	WHERE OT.PATNO = P.PATNO ");
	sqlStr.append("	AND P.PATNO IN ("+ patList+") ");
	sqlStr.append("	AND P.ENABLE = '1' ");
	sqlStr.append("	AND P.STATUS IS NULL ");
	sqlStr.append("	AND P.EFFECTIVE_DATE > OT.OTAOSDATE  ");
	sqlStr.append("	) ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private static ArrayList getChapStatus(String patno) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT GET_CHAP_STATUS('"+patno+"') FROM DUAL ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
String ward = request.getParameter("ward");
String room = request.getParameter("room");
String sex = request.getParameter("sex");
String religion = request.getParameter("religion");
String language = request.getParameter("language");
String doccode = request.getParameter("doccode");
String acm = request.getParameter("acm");

String emergencyCall = request.getParameter("emergency");
String attendedWithin1hour = request.getParameter("attend");
String repeatvisit = request.getParameter("repeatvisit");

String diagnosis = request.getParameter("diagnosis");

String birthDate = null;
String birthDate_yy = request.getParameter("birthDate_yy");
String birthDate_mm = request.getParameter("birthDate_mm");
String birthDate_dd = request.getParameter("birthDate_dd");

if (birthDate_yy != null && birthDate_mm != null && birthDate_dd != null) {
	if (birthDate_yy.equals("") || birthDate_mm.equals("") || birthDate_dd.equals("")) {
		birthDate = null;
	} else {
		birthDate = String.format("%s/%s/%s",birthDate_dd,birthDate_mm,birthDate_yy);
	}
}

String admissionDate = null;
String admissionDate_yy = request.getParameter("admissionDate_yy");
String admissionDate_mm = request.getParameter("admissionDate_mm");
String admissionDate_dd = request.getParameter("admissionDate_dd");
if (admissionDate_yy != null && admissionDate_mm != null && admissionDate_dd != null) {
	if (admissionDate_yy.equals("") || admissionDate_mm.equals("") || admissionDate_dd.equals("")) {

		admissionDate = null;
	} else {
		admissionDate = String.format("%s/%s/%s",admissionDate_dd,admissionDate_mm,admissionDate_yy);
	}
}

String dischargeDate = null;
String dischargeDate_yy = request.getParameter("dischargeDate_yy");
String dischargeDate_mm = request.getParameter("dischargeDate_mm");
String dischargeDate_dd = request.getParameter("dischargeDate_dd");
if (dischargeDate_yy != null && dischargeDate_mm != null && dischargeDate_dd != null) {
	if (dischargeDate_yy.equals("") || dischargeDate_mm.equals("") || dischargeDate_dd.equals("")) {
		dischargeDate = null;
	} else {
		dischargeDate = String.format("%s/%s/%s", dischargeDate_dd, dischargeDate_mm, dischargeDate_yy);
	}
}

String startAgeYrs = request.getParameter("start_ageyrs");
startAgeYrs = (startAgeYrs == null)?"ALL":startAgeYrs;

String endAgeYrs = request.getParameter("end_ageyrs");
endAgeYrs = (endAgeYrs == null)?"ALL":endAgeYrs;

if (!startAgeYrs.equals("ALL") && !endAgeYrs.equals("ALL")) {
	if (Integer.parseInt(startAgeYrs) > Integer.parseInt(endAgeYrs)) {
		String tempAge;
		tempAge = startAgeYrs;
		startAgeYrs = endAgeYrs;
		endAgeYrs = tempAge;
	}
}

String patEName = request.getParameter("patEName");

String patCName = request.getParameter("patCName");
String patNo = request.getParameter("patNo");

String hospitalName=null;
if (ConstantsServerSide.isHKAH()) {
	hospitalName = "Hong Kong Adventist Hospital - Stubbs Road";
}
if (ConstantsServerSide.isTWAH()) {
	hospitalName = "Hong Kong Adventist Hospital - Tsuen Wan";
}

String dischargedPatient = request.getParameter("dischargedPatient");

String acmCount = request.getParameter("acmCount");
String[] acmMulti = request.getParameterValues("acmMulti");

String languageCount = request.getParameter("languageCount");
String[] languageMulti = request.getParameterValues("languageMulti");

String religionCount = request.getParameter("religionCount");
String[] religionMulti = request.getParameterValues("religionMulti");

String doccodeCount = request.getParameter("doccodeCount");
String[] doccodeMulti = request.getParameterValues("doccodeMulti");

String wardCount = request.getParameter("wardCount");
String[] wardMulti = request.getParameterValues("wardMulti");

String[] roomMulti = request.getParameterValues("roomMulti");

String repeatvisitCount = request.getParameter("repeatvisitCount");
String[] repeatvisitMulti = request.getParameterValues("repeatvisitMulti");

String sortBy = request.getParameter("sortBy");
String ordering = request.getParameter("ordering");

String chapStaffID = request.getParameter("chapStaffID");

ArrayList<OTDateRecord> otDateRecordList = new ArrayList<OTDateRecord>();
ArrayList patList = new ArrayList();
OTDateRecord tempOTDate = null;

UserBean userBean = new UserBean(request);
if (userBean != null || userBean.isLogin()) {
	ArrayList record = PatientDB.getInPatList(patNo, ward, room, null, sex,
		religion, language, doccode, (diagnosis==null)?null:TextUtil.parseStrUTF8(java.net.URLDecoder.decode(diagnosis.replaceAll("%", "%25"))), birthDate,
		admissionDate, patEName,
		(patCName==null)?null:TextUtil.parseStrUTF8(java.net.URLDecoder.decode(patCName)), startAgeYrs,
		endAgeYrs, acm, dischargedPatient,
		emergencyCall, attendedWithin1hour, repeatvisit,
		acmMulti, languageMulti, religionMulti, wardMulti, roomMulti,
		doccodeMulti, repeatvisitMulti, sortBy, ordering, chapStaffID,
		((dischargedPatient!=null && dischargedPatient.length()>0)?false:true), dischargeDate, "Y", true);
	for (int i=0; i < record.size(); i++) {
		ReportableListObject inpatList = (ReportableListObject)record.get(i);
		patList.add("'" + inpatList.getValue(7) + "'");
	}

	if (record.size() > 0) {
		ArrayList otDate = getOTdate(patList.toString().substring(1, patList.toString().length()-1));
		for (int i=0; i<otDate.size(); i++) {
			ReportableListObject otDateList = (ReportableListObject)otDate.get(i);

			tempOTDate = new OTDateRecord(otDateList.getValue(0),otDateList.getValue(1));
			otDateRecordList.add(tempOTDate);
		}
	}
	request.setAttribute("patList", record);
}
%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">

	<jsp:include page="../common/header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>

	<jsp:include page="../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="function.cs.patlist" />
		<jsp:param name="isHideTitle" value="Y" />
	</jsp:include>

	<style>
		TD,TH,A,SPAN,INPUT {
			font-size:16px !important;
		}
		.selected {
			background: url("../images/ui-bg_highlight-soft_75_ffe45c_1x100.png") repeat-x scroll 50% 50% #F6F6F6 !important;
		}
		.scroll-pane
		{
			width: 100%;
			height: 400px;
			overflow: auto;
		}
		.notContacted {
			background-color: white!important;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
		.contactedCurrentAdmission {
			background-color: #32CD32!important;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
		.contactedIndirectly{
			background-color: #78FF78!important;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
		.contactedPreviousAdmission{
			background-color: white !important;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
			color:#EB6C2C !important;
		}
		.contactedPreviousIndirectly{
			background-color: white!important;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
			color: #FFC686 !important;
		}
		.notContactedAfterOneDay{
			background-color: #FF3232!important;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
		}
		.procedureScheduled{
			background-color: white;
			background-image: url("../images/ui-bg_glass_100_f6f6f6_1x1.png") !important;
			color: #0000B9!important;
		}

	</style>

	<body>
		<DIV id=indexWrapper style="width:100%" >
			<DIV id=mainFrame style="width:100%" >
				<DIV id=contentFrame style="width:100%" >
					<!-- updating -->
					<div id="loadingListDiv" style="display:none; position:absolute; z-index:14;"
							class="ui-dialog ui-widget ui-widget-content ui-corner-all">
							<div class="ui-widget-header" style="font-size:16px">Updating......</div>
							<div style="font-size:16px; height:50px;">Loading the list.....</div>
					</div>
					<!-- overlay -->
					<div id="overlay" class="ui-widget-overlay" style="display:none;"></div>
					<!-- dialog -->
					<div id="caretrackingPanel" style="width:910px; height:730px; display:none; position:absolute; z-index:12; "
							class="ui-dialog ui-widget ui-widget-content ui-corner-all">
						<table  border="1" id="caretrackingTable">
							<tbody>
								<tr>
									<td class="ui-widget-header"style="width:5%;
											color:black; height:25px; font-size:16px;
											font-weight:bold;">
										In-Patient Chaplaincy Caretracking log
										<img src='../images/cross.jpg' style='float:right' onclick='closeCaretrackingPanel()'/>
									</td>
								</tr>
								<tr >
									<td id="patientInfo">
									</td>
								</tr>
								<tr>
									<td style='border-width:1px; border-style:solid; '>

										<div id='scroll-pane' class='scroll-pane jspScrollable' style='overflow: hidden; padding: 0px; width: 900px; height:400px'>
											<table  id='caretrackingList' style='border-width:0px;border-spacing:0px;width:100%;'>
											</table>
										</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<!-- dialog -->
					<div id="inputEntryPanel" style="width:450px; height:360px; display:none; position:absolute; z-index:18; "
							class="ui-dialog ui-widget ui-widget-content ui-corner-all">
						<table id="inputEntryTable">
							<tbody>
								<tr>
									<td class="ui-widget-header"style="width:5%;
											color:black; height:25px; font-size:16px;
											font-weight:bold;">
										Record Entry
										<img src='../images/cross.jpg' style='float:right' onclick='closeInputEntryPanel()'/>
									</td>
								</tr>
								<tr>
									<td >
										<table id='inputEntryInfoTable' style='border-width:0px;border-spacing:0px;height:265px'>
										</table>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div id="admissionHistoryPage" style="width:310px; height:550px; display:none; position:absolute; z-index:18; "
							class="ui-dialog ui-widget ui-widget-content ui-corner-all">
						<table id="admissionHisotryTable">
							<tbody>
								<tr>
									<td class="ui-widget-header"style="width:5%;
											color:black; height:25px; font-size:16px;
											font-weight:bold;">
										Admission History(Latest 20 Records)
										<img src='../images/cross.jpg' style='float:right' onclick="closePage('admissionHistoryPage')"/>
									</td>
								</tr>

								<tr>
									<td style='border-width:1px; border-style:solid; ' >
									<div  id='admissionHistoryInfoTable' style='padding: 0px; width: 290px; height:510px'>
									</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div id="diagnosisPage" style="width:450px; height:300px; display:none; position:absolute; z-index:18; "
							class="ui-dialog ui-widget ui-widget-content ui-corner-all">
						<table id="diagnosisTable">
							<tbody>
								<tr>
									<td class="ui-widget-header"style="width:5%;
											color:black; height:25px; font-size:16px;
											font-weight:bold;">
										Patient Diagnosis
										<img src='../images/cross.jpg' style='float:right' onclick="closePage('diagnosisPage')"/>
									</td>
								</tr>
								<tr>
									<td >
									<div  id='diagnosisInfoTable' style='padding: 0px;width:442px; height:272px;'>
									</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div id="refNotesPage" style="width:450px; height:300px; display:none; position:absolute; z-index:18; "
							class="ui-dialog ui-widget ui-widget-content ui-corner-all">
						<table id="refNotesTable">
							<tbody>
								<tr>
									<td class="ui-widget-header"style="width:5%;
											color:black; height:25px; font-size:16px;
											font-weight:bold;">
										Refer Patient
										<img src='../images/cross.jpg' style='float:right' onclick="closePage('refNotesPage')"/>
									</td>
								</tr>
								<tr>
									<td >
									<div  id='refNotesInfoTable' style='padding: 0px;width:442px; height:272px;'>
									</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div id="otRecordPage" style="width:510px; height:550px; display:none; position:absolute; z-index:18; "
							class="ui-dialog ui-widget ui-widget-content ui-corner-all">
						<table id="otRecordTable">
							<tbody>
								<tr>
									<td class="ui-widget-header"style="width:5%;
											color:black; height:25px; font-size:16px;
											font-weight:bold;">
										OT Record
										<img src='../images/cross.jpg' style='float:right' onclick="closePage('otRecordPage')"/>
									</td>
								</tr>
								<tr>
									<td style='border-width:1px; border-style:solid; ' >
									<div  id='otRecordInfoTable' style='padding: 0px; width: 490px; height:510px'>
									</div>
									</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div style="display:none">
						<table>
						<tr>
						<td><input type="" id="hiddenacmCount" value="<%=(acmCount==null)?"":acmCount%>"></td>
<%
if (acmMulti!=null) {
	int i = 2;
	for (String acms:acmMulti) {
%>
					<td><input type="" id="hiddenacmMulti<%=i%>" value="<%=(acms==null)?"":acms%>"></td>

<%
		i++;
	}
}
%>
					</tr>
					<tr>
					<td><input type="" id="hiddenlanguageCount" value="<%=(languageCount==null)?"":languageCount%>"></td>
<%
if (languageMulti!=null) {
	int i = 2;
	for (String languages:languageMulti) {
%>
					<td><input type="" id="hiddenlanguageMulti<%=i%>" value="<%=(languages==null)?"":languages%>"></td>

<%
		i++;
	}
}
%>
						</tr>
						<tr>
					<td><input type="" id="hiddenreligionCount" value="<%=(religionCount==null)?"":religionCount%>"></td>
<%
if (religionMulti!=null) {
	int i = 2;
	for (String religions:religionMulti) {
%>
					<td><input type="" id="hiddenreligionMulti<%=i%>" value="<%=(religions==null)?"":religions%>"></td>

<%
		i++;
	}
}
%>
						</tr>
						<tr>
					<td><input type="" id="hiddendoccodeCount" value="<%=(doccodeCount==null)?"":doccodeCount%>"></td>
<%
if (doccodeMulti!=null) {
	int i = 2;
	for (String doccodes:doccodeMulti) {
%>
					<td><input type="" id="hiddendoccodeMulti<%=i%>" value="<%=(doccodes==null)?"":doccodes%>"></td>

<%
		i++;
	}
}
%>
						</tr>
						<tr>
					<td><input type="" id="hiddenrepeatvisitCount" value="<%=(repeatvisitCount==null)?"":repeatvisitCount%>"></td>
<%
if (repeatvisitMulti!=null) {
	int i = 2;
	for (String repeatvisits:repeatvisitMulti) {
%>
					<td><input type="" id="hiddenrepeatvisitMulti<%=i%>" value="<%=(repeatvisits==null)?"":repeatvisits%>"></td>
<%
		i++;
	}
}
%>
						</tr>
						<tr>
					<td><input type="" id="hiddenwardCount" value="<%=(wardCount==null)?"":wardCount%>"></td>
<%
if (wardMulti!=null) {
	int i = 2;
	for (String wards:wardMulti) {
%>
					<td><input type="" id="hiddenwardMulti<%=i%>" value="<%=(wards==null)?"":wards%>"></td>
<%
		i++;
	}
}
%>
						</tr>
						<tr>
<%
if (roomMulti!=null) {
	int i = 2;
	for (String rooms:roomMulti) {
%>
					<td><input type="" id="hiddenroomMulti<%=i%>" value="<%=(rooms==null)?"":rooms%>"></td>
<%
		i++;
	}
}
%>
						</tr>
						<tr>
						<td><input type="" id="hiddendischargedPatient" value="<%=(dischargedPatient==null)?"":dischargedPatient%>"></td>
						</tr>
						</table>
					</div>

					<!-- SEARCH PART -->
					<form name="searchForm" action="patlist.jsp" method="post">
						<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0" style="width:100%">
							<tr style="width:100%">
								<td colspan="3" style="width:50%;background-color:gray; color:white;">
									<label style="font-size:30px;"><u><b>Patient List</b></u></label>
								</td>
								<td colspan="2">

								</td>
								<td style=" text-align: right;">
									<a href = "../">
										<b>Home</b>
									</a>
								</td>
							</tr>

							<tr style="width:100%">
								<td style=" text-align: left;" colspan="6">
									Patient:
<%if (dischargedPatient == null || dischargedPatient.length()==0) { %>

								<b>In Hospital</b> |
								<a href = "../chaplaincy/patlist.jsp?dischargedPatient=y">
								<b>Discharged From Hospital (Within 6 months)</b>
								</a>
<%} else {%>
								<a href = "../chaplaincy/patlist.jsp">
									<b>In Hospital</b>
								</a>
								|
								<b>Discharged From Hospital (Within 6 months)</b>
<%} %>
								</td>
							</tr>

							<tr class="smallText" style="width:100%">
								<td  class="infoLabel" style="width:15%">
									Patient No.
								</td>
								<td id="patNoCell" style="vertical-align:top" class="infoData" style="width:25%">
									<input name="patNo" type="textfield" value="<%=(patNo==null)?"":patNo %>" maxlength="30" size="30" />
								</td>
								<td class="infoData" style="width:10%">
									&nbsp;
								</td>

								<td class="infoLabel" style="width:15%">
									Doctor
								</td>
								<td id="doccodeCell"  class="infoData" style="width:25%">
									<select id="doccode"></select>
								</td>
								<td class="infoData" style="vertical-align:top;" style="width:10%">
									<select name = "doccodeCount" id="doccodeCount"></select>
								</td>
							</tr>

							<tr>
								<td class="infoLabel">
									English Name
								</td>
								<td colspan="2" class="infoData">
									<input name="patEName" type="textfield" value="<%=(patEName==null)?"":patEName %>"  maxlength="30" size="30"/><br/>
								</td>
								<td class="infoLabel">
									Chinese Name
								</td>
								<td colspan="2"class="infoData">
									<input name="patCName" type="textfield"  maxlength="30" size="30"
									 value="<%=(patCName==null)?"":TextUtil.parseStrUTF8(java.net.URLDecoder.decode(patCName)) %>"/>
								</td>
							</tr>


							<tr class="smallText">
								<td class="infoLabel">
									BirthDate
								</td>
								<td colspan="2" class="infoData">
									<jsp:include page="../ui/dateCMB.jsp" flush="false">
									<jsp:param name="label" value="birthDate" />
									<jsp:param name="yearRange" value="120" />
									<jsp:param name="date" value="<%=birthDate %>" />
									<jsp:param name="defaultValue" value="N" />
									<jsp:param name="showTime" value="N" />
									<jsp:param name="hideFutureYear" value="Y" />
									<jsp:param name="allowEmpty" value="Y"/>
									</jsp:include>
								</td>
								<td class="infoLabel">
									Between Age Of
								</td>
								<td colspan="2" class="infoData">
									<jsp:include page="../ui/ageCMB.jsp" flush="false">
										<jsp:param name="label" value="start"/>
										<jsp:param name="start_ageyrs" value="<%=startAgeYrs %>"/>

										<jsp:param name="yearRange" value="120"/>
										<jsp:param name="isYearOnly" value="Y"/>
									</jsp:include>
									-
									<jsp:include page="../ui/ageCMB.jsp" flush="false">
										<jsp:param name="label" value="end"/>
										<jsp:param name="end_ageyrs" value="<%=endAgeYrs %>"/>

										<jsp:param name="yearRange" value="120"/>
										<jsp:param name="isYearOnly" value="Y"/>
									</jsp:include>
								</td>

							</tr>

							<tr class="smallText">
								<td class="infoLabel">
									Admission Date
								</td>
								<td style="vertical-align:top" colspan="2"  class="infoData">
									<jsp:include page="../ui/dateCMB.jsp" flush="false">
									<jsp:param name="label" value="admissionDate" />
									<jsp:param name="yearRange" value="120" />
									<jsp:param name="date" value="<%=admissionDate %>" />
									<jsp:param name="defaultValue" value="N" />
									<jsp:param name="showTime" value="N" />
									<jsp:param name="hideFutureYear" value="Y" />
									<jsp:param name="allowEmpty" value="Y"/>
									<jsp:param name="isYearOrderDesc" value="Y"/>
									</jsp:include>
								</td>
								<td class="infoLabel">
									ACM
								</td>
								<td id="acmCell" class="infoData">
									<select id="acm"></select>
								</td>
								<td class="infoData"  style="vertical-align:top;">
									<select name = "acmCount" id="acmCount">
									</select>
								</td>
							</tr>

							<tr class="smallText">
									<td class="infoLabel" style="vertical-align:top">
									Ward
								</td>
								<td id="wardCell" class="infoData">
									<select id="ward"></select>
								</td>
								<td class="infoData"  style="vertical-align:top;">
									<select name="wardCount" id="wardCount"></select>
								</td>

								<td class="infoLabel">
									Room
								</td>
								<td colspan="2" id="roomCell" class="infoData">
									<select id="room"></select>
								</td>
							</tr>

							<tr class="smallText">
								<td class="infoLabel">
									Language
								</td>
								<td id="languageCell" class="infoData">
									<select id="language"></select>
								</td>
								<td class="infoData"  style="vertical-align:top;">
									<select name = "languageCount" id="languageCount"></select>
								</td>
								<td style="vertical-align:top" class="infoLabel">
									Sex
								</td>
								<td  style="vertical-align:top" colspan="2" class="infoData">
									<select id="sex"></select>
								</td>
							</tr>

							<tr valign=middle class="smallText">
								<td style="vertical-align:top" class="infoLabel">
									Religion
								</td>
								<td id="religionCell" style="vertical-align:top" class="infoData">
									<select id="religion"></select>
								</td>
								<td class="infoData"  style="vertical-align:top;">
									<select name = "religionCount" id="religionCount"></select>
								</td>
								<td rowspan = "2"style="vertical-align:top" class="infoLabel">
									Diagnosis
								</td>
								<td style='height:100%' rowspan = "2" style="vertical-align:top" colspan="2" class="infoData">
									<textarea name = "diagnosis" style='height:100%;width:100%'><%=(diagnosis==null)?"":TextUtil.parseStrUTF8(java.net.URLDecoder.decode(diagnosis.replaceAll("%", "%25"))) %></textarea>
								</td>
							</tr>

<%if (ConstantsServerSide.isHKAH()) { %>
							<tr valign=middle class="smallText">
								<td style="vertical-align:top" class="infoLabel">
									Emergency Call
								</td>
								<td id="emergencyCell" colspan="2" style="vertical-align:top" class="infoData">
									<input <%=("e".equals(emergencyCall))?"CHECKED":""%>  style='width:25px; height:25px;' name='emergency' id='emergency' type='checkbox' value='e'/>Emergency&nbsp;
									<input <%=("a".equals(attendedWithin1hour))?"CHECKED":""%>  style='width:25px; height:25px;' name='attend' id='attend' type='checkbox' value='a'/>Attended within 1 hour&nbsp;
								</td>
							</tr>
<%} %>

							<tr valign=middle class="smallText">
								<td style="vertical-align:top" class="infoLabel">
									Repeat Visit
								</td>
								<td id="repeatvisitCell" style="vertical-align:top" class="infoData">
									<select id="repeatvisit">
									</select>
								</td>
								<td class="infoData" style="vertical-align:top;">
									<select name = "repeatvisitCount" id="repeatvisitCount"></select>
								</td>
<%if (ConstantsServerSide.isHKAH()) { %>
								<td class="infoLabel">
									&nbsp;
								</td>
								<td style="vertical-align:top" colspan="2" class="infoData">
									&nbsp;
								</td>
<%} %>
							</tr>

							<tr class="smallText">
								<td class="infoLabel" >Supervised Area</td>
								<td class="infoData" colspan = "2">
									<select name="chapStaffID" id="chapStaffID">
										<jsp:include page="../ui/staffIDCMB.jsp">
											<jsp:param value='<%=(ConstantsServerSide.isHKAH()?"660":"CHAP") %>' name="deptCode"/>
											<jsp:param value="Y" name="showFT"/>
											<jsp:param value="Y" name="allowEmpty"/>
											<jsp:param value="<%=chapStaffID %>" name="value"/>
										</jsp:include>
									</select>
								</td>

<%if (dischargedPatient == null || dischargedPatient.length() == 0) {%>
								<td class="infoLabel">
									&nbsp;
								</td>
								<td style="vertical-align:top" colspan="2" class="infoData">
									&nbsp;
								</td>
<%} else {%>
								<td class="infoLabel">
									Discharged Date
								</td>
								<td style="vertical-align:top" colspan="2"  class="infoData">
									<jsp:include page="../ui/dateCMB.jsp" flush="false">
									<jsp:param name="label" value="dischargeDate" />
									<jsp:param name="yearRange" value="120" />
									<jsp:param name="date" value="<%=dischargeDate %>" />
									<jsp:param name="defaultValue" value="N" />
									<jsp:param name="showTime" value="N" />
									<jsp:param name="hideFutureYear" value="Y" />
									<jsp:param name="allowEmpty" value="Y"/>
									<jsp:param name="isYearOrderDesc" value="Y"/>
									</jsp:include>
								</td>
<%}%>
							</tr>

							<tr class="smallText">
								<td class="infoLabel">Sort By</td>
								<td colspan="2" class="infoData" >
									<select name="sortBy">
										<option <%="wardRoom".equals(sortBy)?" selected":"" %> value="wardRoom">Ward & Room</option>
										<option <%="patNo".equals(sortBy)?" selected":"" %> value="patNo">Patient Number</option>
										<option <%="patName".equals(sortBy)?" selected":"" %> value="patName">Patient Name</option>
										<option <%="age".equals(sortBy)?" selected":"" %> value="age">Age</option>
										<option <%="sex".equals(sortBy)?" selected":"" %> value="sex">Sex</option>
										<option <%="language".equals(sortBy)?" selected":"" %> value="language">Language</option>
										<option <%="religion".equals(sortBy)?" selected":"" %> value="religion">Religion</option>
										<option <%="admissionDate".equals(sortBy)?" selected":"" %> value="admissionDate">Admission Date</option>
									</select>
									<select name="ordering">
										<option <%="ASC".equals(ordering)?" selected":"" %> value="ASC">Ascending</option>
										<option <%="DESC".equals(ordering)?" selected":"" %> value="DESC">Decending</option>

									</select>
								</td>
								<td style="vertical-align:top" class="infoLabel">
									&nbsp;
								</td>
								<td style="vertical-align:top" colspan="2" class="infoData">
									<button type='button' style="float:right;font-size:22px;" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
									 onclick="submitAction('clear')">Reset</button>
									<button style="float:right;font-size:22px;" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
									 onclick="submitAction('search')">Search</button>

								</td>
							</tr>

							<tr>
								<td colspan='10'>
									<hr style="color:#F1EBF1;background-color:#F1EBF1;"/>
								</td>
							</tr>
<%		if (dischargedPatient == null || dischargedPatient.length()==0) { %>
							<tr class="smallText" style="width:100%">
								<td>&nbsp;</td>

								<td class="infoData"  colspan='5'>

										<div style="float:left; width:40%">
											<button type="button"style="vertical-align:middle;width:40px; height:25px" class = "notContacted ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
											</button><span style="vertical-align:middle">: Admitted less than 24 hours ago</span>
											<input onclick="filterRow()" type="checkbox" name="filterTableRow" value="notContacted" />

										</div>
										<div style="float:left; width:50%">
												<button  type="button" style="vertical-align:middle;width:40px; height:25px" class = "notContactedAfterOneDay ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
											</button><span style="vertical-align:middle">: Admitted over 24 hours ago</span>
											<input onclick="filterRow()" type="checkbox" name="filterTableRow" value="notContactedAfterOneDay" />
										</div>
										<div style="float:left; width:40%">
											<button  type="button" style="vertical-align:middle;width:40px; height:25px" class = "contactedCurrentAdmission ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
											</button><span style="vertical-align:middle">: Contacted</span>
											<input onclick="filterRow()" type="checkbox" name="filterTableRow" value="contactedCurrentAdmission" />
										</div>
										<div style="float:left; width:50%">
											<button type="button" style="vertical-align:middle;width:40px; height:25px" class = "contactedIndirectly ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
											</button><span style="vertical-align:middle">: Contacted Indirectly</span>
											<input onclick="filterRow()" type="checkbox" name="filterTableRow" value="contactedIndirectly" />
										</div>
										<div style="float:left; width:40%">
											<button type="button" style="vertical-align:middle;width:40px; height:25px" class = "contactedPreviousAdmission ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
											<span style="vertical-align:middle">Text</span></button><span style="vertical-align:middle">: Previous Admission Contacted</span>
											<input onclick="filterRow()" type="checkbox" name="filterTableRow" value="contactedPreviousAdmission" />
										</div>

										<div style="float:left; width:50%">
											<button type="button" style="vertical-align:middle;width:40px; height:25px" class = "contactedPreviousIndirectly ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
											<span style="vertical-align:middle">Text</span></button><span style="vertical-align:middle">: Previous Admission Contacted Indirectly</span>
											<input onclick="filterRow()" type="checkbox" name="filterTableRow" value="contactedPreviousIndirectly" />
										</div>
										<div style="float:left; width:40%">
											<button type="button" style="vertical-align:middle;width:40px; height:25px" class = "procedureScheduled ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
											<span style="vertical-align:middle">Text</span></button><span style="vertical-align:middle">: Procedure Scheduled</span>
											<input onclick="filterRow()" type="checkbox" name="filterTableRow" value="procedureScheduled" />
										</div>
										<div style="float:right; ">
											<button onclick="filterContact('clear')" type="button" style="vertical-align:middle;width:60px; height:25px" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Clear
											</button>

										</div>

								</td>
							</tr>
<%		} else { %>
							<tr class="smallText" style="width:100%">
								<td>&nbsp;</td>

								<td class="infoData"  colspan='5'>

										<div style="float:left; width:100%">
											<button type="button"style="vertical-align:middle;width:40px; height:25px" class = "notContacted ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
											</button><span style="vertical-align:middle">: Not Contacted</span>
											<input onclick="filterRow()" type="checkbox" name="filterTableRow" value="notContacted" />
										</div>

										<div style="float:left; width:40%">
											<button type="button" style="vertical-align:middle;width:40px; height:25px" class = "contactedPreviousAdmission ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
											<span style="vertical-align:middle">Text</span></button><span style="vertical-align:middle">: Previous Admission Contacted</span>
											<input onclick="filterRow()" type="checkbox" name="filterTableRow" value="contactedPreviousAdmission" />
										</div>

										<div style="float:left; width:40%">
											<button type="button" style="vertical-align:middle;width:40px; height:25px" class = "contactedPreviousIndirectly ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
											<span style="vertical-align:middle">Text</span></button><span style="vertical-align:middle">: Previous Admission Contacted Indirectly</span>
											<input onclick="filterRow()" type="checkbox" name="filterTableRow" value="contactedPreviousIndirectly" />
										</div>
										<div style="float:right; ">
											<button onclick="filterContact('clear')" type="button" style="vertical-align:middle;width:60px; height:25px" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Clear
											</button>
										</div>
								</td>
							</tr>
<%		} %>
							<tr>
								<td>
									<input type="hidden" name="ward" value="<%=(ward==null)?"":ward%>">
									<input type="hidden" name="room" value="<%=(room==null)?"":room%>">
									<input type="hidden" name="sex" value="<%=(sex==null)?"":sex%>">
									<input type="hidden" name="religion" value="<%=(religion==null)?"":religion%>">
									<input type="hidden" name="language" value="<%=(language==null)?"":language%>">
									<input type="hidden" name="doccode" value="<%=(doccode==null)?"":doccode%>">
									<input type="hidden" name="acm" value="<%=(acm==null)?"":acm%>">
									<input type="hidden" name="repeatvisit" value="<%=(repeatvisit==null)?"":repeatvisit%>">
									<input type="hidden" name="dischargedPatient" value="<%=(dischargedPatient==null)?"":dischargedPatient%>">
								</td>
							</tr>
						</table>
					</form>


					<display:table id="row" name="requestScope.patList" export="false" pagesize="200" sort="list">
						<display:column title="" style="display:none;width:0%">
						<!--  Button calls dialog box -->
							<button class ="viewBtn" value='<c:out value="${row.fields7}" />,<c:out value="${row.fields5}" />'
												onclick="createPanel('','list',this, '<c:out value="${row.fields7}" />')">
								<img src='../images/module-expand.png'/>
							</button>
						</display:column>
						<display:column  title="Ward" style="width:5%">
							<c:out value="${row.fields2}" />
						</display:column>
						<display:column title="Bed" style="width:5%">
							<c:out value="${row.fields3}" />
						</display:column>
						<display:column  title="Patient No" style="width:10%">
							<c:out  value="${row.fields7}" />
						</display:column>
						<display:column title="Patient Name" style="width:15%">
							<c:out value="${row.fields9}" />
						</display:column>
						<display:column title="Patient Chinese Name" style="width:10%">
							<c:out value="${row.fields10}" />
						</display:column>
						<display:column title="Age" style="width:10%">
							<c:out value="${row.fields11}" />
						</display:column>
						<display:column title="Sex" style="width:5%">
							<c:out value="${row.fields8}" />
						</display:column>
						<display:column title="" style="display:none;width:0%">
							<c:out value="${row.fields5}" />
						</display:column>
						<display:column title="Language" style="width:5%">
							<c:out value="${row.fields20}" />
						</display:column>
						<display:column title="Religion" style="width:5%">
							<c:out value="${row.fields21}" />
						</display:column>
						<display:column title="Admission Date" style="display:none;width:0%">
						<c:out value="${row.fields24}" />
						</display:column>
						<display:column title="Discharged Date" style="display:none;width:0%">
							<c:out value="${row.fields35}" />
						</display:column>
						<display:column title="Admission Date" style="width:10%">
						<c:set var="admissionD" value="${row.fields24}"/>
							<c:out value="${row.fields24}" />
							<br/>
							<c:out value="${row.fields36}" />
						</display:column>
<%
		if (dischargedPatient!=null && dischargedPatient.length() > 0) {
%>
						<display:column title="Discharge Date" style="width:10%">
							<c:out value="${row.fields35}" />
							<br/>
							<c:out value="${row.fields37}" />
						</display:column>
<%
			} else {
%>
						<display:column title="Previous Discharged Date" style="width:10%">
							<c:set var="disPatNo" value="${row.fields7}"/>
							<c:out value="${row.fields38}" />
						</display:column>
<%
			}
%>
						<display:column title="Misc" >
						<c:set var="tempPatNo" value="${row.fields7}"/>
<%
			String tempPatNo = (String)pageContext.getAttribute("tempPatNo") ;

			String status = "";
			ArrayList statusRecord = getChapStatus(tempPatNo);
			if (statusRecord.size() != 0) {
				ReportableListObject patientStatusRow = (ReportableListObject)statusRecord.get(0);
				status = patientStatusRow.getValue(0);
			}

%>
						<div id="status<%=tempPatNo%>"><c:out value='<%=status%>'/></div>
						<div id="countbox<%=tempPatNo%>"></div>
						</display:column>
						<display:column title="Reg Type" style="display:none;width:0%">
							<c:out value="${row.fields6}" />
						</display:column>
					</display:table>
				</DIV>
			</DIV>
		</DIV>
	</body>
</html:html>

<script type="text/javascript" >
	var apis = [];

	function filterRow() {
		var checkedClassName=[];
		$('input[name=filterTableRow]').each(function() {
			if ($(this).attr("checked")) {
				checkedClassName.push($(this).val());
			}
		 });

		if (checkedClassName.length==0) {
			filterContact('clear')
		} else {
			$('#row tr').each(function(i, v) {
				var dom = $(this);
				var classFound = false;
				if (dom.hasClass('notContacted')
						|| dom.hasClass('contactedCurrentAdmission')
						|| dom.hasClass('contactedIndirectly')
						|| dom.hasClass('contactedPreviousAdmission')
						|| dom.hasClass('contactedPreviousIndirectly')
						|| dom.hasClass('notContactedAfterOneDay')) {
					for (var i = 0; i < checkedClassName.length; i++) {
						if (dom.hasClass(checkedClassName[i])) {
								dom.css('display','');
								classFound = true;
						 }
					}
				}
				if (dom.hasClass('notContacted')
						|| dom.hasClass('contactedCurrentAdmission')
						|| dom.hasClass('contactedIndirectly')
						|| dom.hasClass('contactedPreviousAdmission')
						|| dom.hasClass('contactedPreviousIndirectly')
						|| dom.hasClass('notContactedAfterOneDay')) {
					if (classFound == false) {
						 dom.css('display','none');
					}
				}
			});
		}
	}

	function filterContact(className) {
		if (className == 'clear') {
				$('#row tr').each(function(i, v) {
					var dom = $(this);
					dom.css('display','');
				});
		}

		$('input[name=filterTableRow]').each(function() {
			$(this).attr("checked","");
		 });

	}

	function checkVisitStatus(patNo) {
		var refStatus ='';
		if ($('input=[id=hiddenReferral]').val().length > 0) {
			refStatus = $('#referralStaffID option[value='+$('input=[id=hiddenReferral]').val()+']').text().split('(')[0];
		}

		 var visitStatus = $('input=[class=remarkStatus_'+patNo+']:checked').val();
		 var tempVisitStatus = '';
		 if (visitStatus == 'a') {
			 tempVisitStatus = 'Again';
		 } else if (visitStatus == 'd') {
			 tempVisitStatus = 'Daily';
		 } else if (visitStatus == 'f') {
			 tempVisitStatus = 'Frequently';
		 } else if (visitStatus == 'dnd') {
			 tempVisitStatus = 'DND';
		 } else {
			 tempVisitStatus = '';
		 }

		 $('#status'+patNo).empty();
		 if (tempVisitStatus && refStatus) {
			 $('#'+patNo).find("td").eq(15).find("#status"+patNo).html(refStatus + ' / ' + tempVisitStatus);
		 }
		 else {
			 $('#'+patNo).find("td").eq(15).find("#status"+patNo).html(refStatus +  tempVisitStatus);
		 }

		 if ($('#countbox'+patNo).html().length > 0) {
			 if ($('#status'+patNo).html().length > 0) {
				$('#'+patNo).find("td").eq(15).find("#status"+patNo).append(' / ');
			 }
		 }
	}

	function submitReferral(patNo,type) {
		var refer = false;
		var comment = null;
		if ( $('#referralStaffID option:selected').val() == '') {
			type = 'remove';
		}

		if (type == 'submit') {
			if ( $('#referralStaffID option:selected').val() != '') {
				createSubPanel(patNo,'refNotes',$.trim($('#referralStaffID option:selected').text().split('(')[0]));
				//comment = prompt("Refer Patient "+patNo+" to " +  $.trim($('#referralStaffID option:selected').text().split('(')[0]) + " ?\nNotes:","");
			} else {
				alert('Please select a chaplain to refer.');
			}
		} else if (type == 'remove') {
			refer = confirm("Remove referred chaplain?");
		} else if (type == 'sendRef') {
			comment =$('textarea#refNotesEntry').val();
		}

		if ( refer == true || comment != null) {
			showLoadingBox('body', 500, $(window).scrollTop());
			var chapID = "";
			var chapName = "";
			var patHospital = $('div#caretrackingPanel').find('#patientInfo').find('#patHospital').html();
			var patDoctor = $('div#caretrackingPanel').find('#patientInfo').find('#patDoctor').html();
			var patName = $('div#caretrackingPanel').find('#patientInfo').find('#patName').html();
			var patWard = $('div#caretrackingPanel').find('#patientInfo').find('#ward').html();
			var patBed =  $('div#caretrackingPanel').find('#patientInfo').find('#bed').html();
			var patAdmissionDate =  $('div#caretrackingPanel').find('#patientInfo').find('#admissionDate').html();
			var patCName =  encodeURIComponent($('div#caretrackingPanel').find('#patientInfo').find('#patCName').html());
			var patACM =  $('div#caretrackingPanel').find('#patientInfo').find('#patACM').html();
			var patLang =  $('div#caretrackingPanel').find('#patientInfo').find('#patLang').html();
			var patAge =  $('div#caretrackingPanel').find('#patientInfo').find('#age').html();
			var patSex =  $('div#caretrackingPanel').find('#patientInfo').find('#sex').html();
			var patReligion =  $('div#caretrackingPanel').find('#patientInfo').find('#patReligion').html();
			var patAdmissionHistory =  $('div#caretrackingPanel').find('#patientInfo').find('#patAdmissionHistory').html();
			var patDiagnosis =   encodeURIComponent($('div#caretrackingPanel').find('#patientInfo').find('#displayDiagnosis').html());

			var patRepeatVisit = $('div#caretrackingPanel').find('#patientInfo').find('input[type=checkbox]:checked').attr('value')

			if (patRepeatVisit == 'a') {
				patRepeatVisit = 'Again';
			} else if (patRepeatVisit == 'd') {
				patRepeatVisit = 'Daily';
			} else if (patRepeatVisit == 'f') {
				patRepeatVisit = 'Frequently';
			} else if (patRepeatVisit == 'dnd') {
				patRepeatVisit = 'Do Not Disturb';
			} else {
				patRepeatVisit = '';
			}

			var chapEMail = $('#referralStaffID option:selected').attr('email');
			//var chapEMail = 'nfsit@hotmail.com';

			if (type == 'sendRef') {
				chapID =  $('#referralStaffID option:selected').val();
				chapName = $.trim($('#referralStaffID option:selected').text().split('(')[0]);
			} else if (type == 'remove') {
				chapID = "";
				chapName = "";
			}

			var action = 'action=referral';
			var baseUrl ='../chaplaincy/submitChapArea.jsp?';
			var url = baseUrl + action + "&" + "patNo="+patNo+ "&" + "chapID="+chapID + "&" + "chapName="+chapName+ "&" + "type="+type
			 + "&" + "patName="+patName+ "&" + "patWard="+patWard+ "&" + "patBed="+patBed+ "&" + "patAdmissionDate="+patAdmissionDate
			 + "&" + "patHospital="+patHospital+ "&" + "patDoctor="+patDoctor+ "&" + "patCName="+patCName+ "&" + "patACM="+patACM
			 + "&" + "patLang="+patLang+ "&" + "patAge="+patAge+ "&" + "patSex="+patSex+ "&" + "patReligion="+patReligion
			 + "&" + "patAdmissionHistory="+patAdmissionHistory+ "&" + "patDiagnosis="+patDiagnosis+ "&" + "patRepeatVisit="+patRepeatVisit
			 + "&" + "chapEMail="+chapEMail + "&" + "refComment="+ encodeURIComponent(comment);

			$.ajax({
				url: url,
				async: false,
				cache:false,
				success: function(values) {
					if (values.indexOf('false') > -1) {
						if (type == 'submit') {
							alert("Error occured while referring patient.");
						} else if (type == 'remove') {
							alert("Error occured while removing chaplain.");
						}
					} else {
						$('#saveRefComment').remove();
						$('#refNotesLabelCell').remove();
						$('#refNotesCell').remove();
						if (type == 'sendRef') {
							closePage('refNotesPage');
							alert("Patient referred successfully.");
							$('input=[id=hiddenReferral]').val(chapID);
							checkVisitStatus($('div#caretrackingPanel').find('#patientInfo').find('#patNo').html());
							$('#refLabelCell').append("<span style='font-weight: bold;' id='refNotesLabelCell'><br>Refer Notes&nbsp;</span>");
							$('#refCell').append("<span id='refNotesCell'><br>"+comment+"&nbsp;</span>");

							if (values.indexOf('errorwhilemail') > -1) {
								alert("Error occured while sending e-mail. Selected chaplain have not supply an e-mail address.");
							}

						} else if (type == 'remove') {
							alert("Chaplain removed successfully.")
							$('input=[id=hiddenReferral]').val(chapID);
							$('select##referralStaffID :nth-child(1)').attr('selected', 'selected');
							checkVisitStatus($('div#caretrackingPanel').find('#patientInfo').find('#patNo').html());
						}
					}
				},
				error: function() {
					alert('error');
				}
			});
			hideLoadingBox('body', 500);
		}
	}

	function setCheckBox(type, patNo) {
		var selected = $('#visit' + type + '_'+patNo).is(':checked');

		$('#visitA_'+patNo).attr('checked', false);
		$('#visitF_'+patNo).attr('checked', false);
		$('#visitD_'+patNo).attr('checked', false);
		$('#visitDND_'+patNo).attr('checked', false);

		if (selected == false) {
			$('#visit'+type+'_'+patNo).attr('checked', false);
		} else {
			$('#visit'+type+'_'+patNo).attr('checked', true);
		}
		updateRemark(patNo);
	}

	function updateRemark(patNo) {
		showLoadingBox('body', 500, $(window).scrollTop());
		var tempPatNo = '#' + patNo;

		$(tempPatNo).each(function(i, v) {
			var patNo = $.trim($(this).find("td").eq(3).html());
<%if (ConstantsServerSide.isHKAH()) { %>
			var emergency = $('input=[class=emergency_'+patNo+']:checked').val();
			if (emergency != 'e') {
				emergency = '';
			}
			var attend = $('input=[class=attend_'+patNo+']:checked').val();
			if (attend != 'a') {
				attend = '';
			}
<%} else { %>
			var emergency = '';
			var attend = '';
<%} %>
			var visitStatus = $('input=[class=remarkStatus_'+patNo+']:checked').val();

			if (patNo != '') {
				if (!visitStatus) {
					visitStatus = 'n';
				}

				if (visitStatus) {
					$.ajax({
						url: '../chaplaincy/visitStatus.jsp?'+
							'patNo=' + patNo +
							'&emergency=' + emergency +
							'&attend=' + attend +
							'&visitStatus=' + visitStatus,
							async: false,
							cache: false,
						success: function(values) {
							if (values) {
								if (values.indexOf('false') > -1) {
									alert("Error occured while updating visit status of patient #" + patNo);
								} else {
									checkVisitStatus(patNo);
								}
							}
						},
						error: function() {
							alert('Error occured.');
						}
					});
				}
			}
		});
		hideLoadingBox('body', 500);
	}

	function saveDiagnosis(patNo) {
		createSubPanel(patNo,'saveDiagnosis');
	}



	function editRemark(psID) {
		 createPanel('','editRecord','','',psID);
	}

	function deleteRemark(psID) {
		var deleteRemark = confirm("Delete remark ?");
		if ( deleteRemark == true ) {
			showLoadingBox('body', 500, $(window).scrollTop());
			var patNo = 'patNo='  + $('div#caretrackingPanel').find('#patientInfo').find('#patNo').html();
			var baseUrl ='../chaplaincy/visitHistory.jsp?action=delete' + '&' + patNo;;
			var url = baseUrl + '&psID=' + psID;
			$.ajax({
				url: url,
				async: false,
				cache:false,
				success: function(values) {
					if (values) {
						if (values.indexOf('true') > -1) {
							getViewRecord('','list', $('div#caretrackingPanel').find('#patientInfo').find('#patNo').html(),'',$('div#caretrackingPanel').find('#patientInfo').find('#regType').html());

						}
						else {
							alert('Error occured while deleteing record.');
						}
					}
				},
				error: function() {
					alert('Error occured while deleteing record.');
				}
			});

			hideLoadingBox('body', 500);
		}
	}

	function saveRecord(type,psID) {
		showLoadingBox('body', 500, $(window).scrollTop());

		if (type=='save') {
			var patNo = 'patNo='  + $('div#caretrackingPanel').find('#patientInfo').find('#patNo').html();
			var name = 'name=' + $('div#caretrackingPanel').find('#patientInfo').find('#patName').html();
			var regID = 'regID=' + $('div#caretrackingPanel').find('#patientInfo').find('#regID').html();
			var regType = 'regType=' + $('div#caretrackingPanel').find('#patientInfo').find('#regType').html();
			var ward = 'ward=' + $('div#caretrackingPanel').find('#patientInfo').find('#ward').html();
			var room = 'room=' + $('div#caretrackingPanel').find('#patientInfo').find('#room').html();
			var bed = 'bed='+ $('div#caretrackingPanel').find('#patientInfo').find('#bed').html();
			var allergy = 'allergy=';
			var status = 'status=';
			var remark = 'remark=' + encodeURIComponent($('textarea#recordEntry').val());
			var servCategory = 'servCategory=' + $('div#inputEntryPanel').find('#inputEntryTable').find('#inputEntryInfoTable').find('#servCategory').html();
			var servItem = 'servItem=' + $('div#inputEntryPanel').find('#inputEntryTable').find('#inputEntryInfoTable').find('#servItem').html();
			var recordTime = 'recordTime=' + $('select[name=recordDate_hh] :selected').val() + ':' + $('select[name=recordDate_mi] :selected').val() ;
			var recordDate = 'recordDate=' +  $('select[name=recordDate_dd] :selected').val() + '/' + $('select[name=recordDate_mm] :selected').val() + '/' + $('select[name=recordDate_yy] :selected').val();
			//alert(remark)
			var baseUrl ='../chaplaincy/visitHistory.jsp?action=insert';
			var url = baseUrl + '&' + patNo + '&' + name  + '&' + regID  + '&' + regType  + '&' + ward  + '&' + room
			 + '&' + bed  + '&' + allergy + '&' + status + '&' + remark + '&' + servCategory + '&' + servItem + '&' + recordDate + '&' + recordTime;
			//alert(url)
			$.ajax({
				url: url,
				async: false,
				cache:false,
				success: function(values) {
					if (values) {
						if (values.indexOf('true') > -1) {
							alert('Record Added Successfully.');
							if (values.indexOf('removedreferral') > -1) {
								$('select#referralStaffID :nth-child(1)').attr('selected', 'selected');
								$('input=[id=hiddenReferral]').val('');
								checkVisitStatus($('div#caretrackingPanel').find('#patientInfo').find('#patNo').html());
							}

							if (values.indexOf('neededupdate') > -1) {
								var tempPatNo = $.trim($('div#caretrackingPanel').find('#patientInfo').find('#patNo').html());
								 var tempNo = '#visitA_'+tempPatNo;
									$(tempNo).attr('checked', false);
								checkVisitStatus(tempPatNo)
							}

							if (values.indexOf('patientothaslog') > -1) {
								var tempPatNo = $.trim($('div#caretrackingPanel').find('#patientInfo').find('#patNo').html());
								$("#countbox"+tempPatNo).remove();
							}

							closeInputEntryPanel();
							getViewRecord('','list', $('div#caretrackingPanel').find('#patientInfo').find('#patNo').html(),'',$('div#caretrackingPanel').find('#patientInfo').find('#regType').html());
							$('textarea#recordEntry').val('') ;
							}
						else {
							alert('Error occured while adding record.');
						}
					}
				},
				error: function() {
					alert('Error occured while adding record.');

				}
			});
		} else if (type=='edit') {

			var remark = 'remark=' + encodeURIComponent($('textarea#recordEntry').val());
			var editDate = 'editDate=' + $('select[name=editDate_dd] :selected').val() + '/' + $('select[name=editDate_mm] :selected').val() + '/' + $('select[name=editDate_yy] :selected').val();
			var editTime = 'editTime=' + $('select[name=editDate_hh] :selected').val() + ':' + $('select[name=editDate_mi] :selected').val();
			var baseUrl ='../chaplaincy/visitHistory.jsp?action=edit';
			var patNo = 'patNo='  + $('div#caretrackingPanel').find('#patientInfo').find('#patNo').html();


			var url = baseUrl + '&' + remark+ '&psID='+psID + '&' + editDate + '&' + editTime + '&' + patNo;

			$.ajax({
				url: url,
				async: false,
				cache:false,
				success: function(values) {
					if (values) {
						if (values.indexOf('true') > -1) {
							alert('Record Added Successfully.');

							getViewRecord('','list', $('div#caretrackingPanel').find('#patientInfo').find('#patNo').html(),'',$('div#caretrackingPanel').find('#patientInfo').find('#regType').html());
							 createPanel('','editRecord','','',psID);
							 closeInputEntryPanel() ;

							 if (values.indexOf('patientothaslog') > -1) {
								var tempPatNo = $.trim($('div#caretrackingPanel').find('#patientInfo').find('#patNo').html());
								$("#countbox"+tempPatNo).remove();
							}
						}
						else {
							alert('Error occured while updating record.');
						}
					}
				},
				error: function() {
					alert('Error occured while updating record.');
				}
			});
		}

		hideLoadingBox('body', 500);
	}

	function getTrackingLogHeader(patNo, dischargedDate, visitStatus, type, regType, packageCode) {
		var baseUrl ='../chaplaincy/trackingLogHeader.jsp?';
//		var url = baseUrl + '&patNo='+ patNo + '&dischargedDate=' + dischargedDate + '&visitStatus=' + visitStatus + '&regType=' + regType+ '&packageCode=' + packageCode;
		var url = baseUrl + '&patNo='+ patNo + '&dischargedDate=' + dischargedDate + '&visitStatus=&regType=' + regType+ '&packageCode=' + packageCode;
		$('#patientInfo').html('');
		$('#caretrackingList').html('');
		$.ajax({
			url: url,
			async: true,
			cache:false,
			success: function(values) {
				if (values) {
					$('#patientInfo').html(values);
					$('#referralStaffID :nth-child(1)').html("");
					getViewRecord('',type, patNo,'',regType);
				}
			},
			error: function() {
				alert('Error occured while retrieving record.');
			}
		});
	}

	function createPanel(button_id, type, dom, patNo, psID, dischargedDate, visitStatus, regType, packageCode) {
		showLoadingBox('body', 500, $(window).scrollTop());

		if (type == 'list') {
			$('div#overlay').css('height', $(document).height());
			$('div#overlay').css('width', $(document).width());
			$('div#overlay').css('display', '');
			$('div#overlay').css('z-index', '12');
			$('div#caretrackingPanel').css('top', $(window).scrollTop());//+($(window).height()-$('div#caretrackingPanel').height())/2);
			$('div#caretrackingPanel').css('left', 5);//($(window).width()-$('div#caretrackingPanel').width())/2);
			$('div#caretrackingPanel').css('display', '');
			getTrackingLogHeader(patNo, dischargedDate, visitStatus, type, regType, packageCode);

		}
		else if (type == 'record' || type == 'editRecord') {
			$('div#overlay').css('z-index', '15');
			$('div#inputEntryPanel').css('top', $(window).scrollTop()+($(window).height()-$('div#inputEntryPanel').height())/2);
			$('div#inputEntryPanel').css('left', ($(window).width()-$('div#inputEntryPanel').width())/2);
			$('div#inputEntryPanel').css('display', '');
			if (type == 'record') {
				getViewRecord(button_id,type);
			}
			else {
				getViewRecord('',type,'',psID);
			}
		}
	}

	function getViewRecord(button_id,type, patNo,psID,regType) {
		showLoadingBox('body', 500, $(window).scrollTop());
		var baseUrl ='../chaplaincy/visitHistory.jsp?action=view&serType=chaplaincy';
		var url='';
		if (type == 'list') {
			var getListParam ='&getList=Y' +'&patNo='+patNo +'&regType='+regType;
			url = baseUrl + getListParam;
		}
		else if (type == 'record') {
			var setRecordParam ='&setRecord=Y'+'&buttonID=' + button_id;
			url = baseUrl + setRecordParam;
		}
		else if (type == 'editRecord') {
			var editRecordParam ='&editRecord=Y'+'&psID=' + psID;
			url = baseUrl + editRecordParam;
		}
		$.ajax({
			url: url,
			async: true,
			cache:false,
			success: function(values) {
				if (values) {
					if (type=='list') {
						$('#caretrackingList').html(values);
						selectRecordEvent();
						apis[0].reinitialise();
					}
					else if (type=='record' || type=='editRecord') {
						$('#inputEntryInfoTable').html(values);
					}
				}
				hideLoadingBox('body', 500);
				//$('#caretrackingTable#scroll-pane').data('jsp').reinitialise();
				resizePatientPanel();
			},
			error: function() {
				alert('Error occured.');
			}
		});
	}

	function selectRecordEvent() {
		$('button.record').each(function(i, v) {
			if (this.id == 'Chronological_History_Show') {
				$(this).click(function() {
					$('button#Chronological_History_Hide').addClass('selected');
					$('button#Chronological_History_Hide').css('display', '');
					$('div#chronologicalRow').css('display', '');
					$(this).css('display', 'none');
					apis[0].reinitialise();
				});
			} else if (this.id == 'Chronological_History_Hide') {
				$(this).click(function() {
					$(this).removeClass('selected');
					$('div#chronologicalRow').css('display', 'none');
					$(this).css('display', 'none');
					$('button#Chronological_History_Show').css('display', '');
					apis[0].reinitialise();
				});
			} else if (this.id == 'Patient_Contact_Info_Show') {
				$(this).click(function() {
					$('button#Patient_Contact_Info_Hide').addClass('selected');
					$('button#Patient_Contact_Info_Hide').css('display', '');
					$('div#patientContactInfo').css('display', '');
					$(this).css('display','none');
					resizePatientPanel();
				});
			} else if (this.id == 'Patient_Contact_Info_Hide') {
				$(this).click(function() {
					$(this).removeClass('selected');
					$('div#patientContactInfo').css('display', 'none');
					$(this).css('display', 'none');
					$('button#Patient_Contact_Info_Show').css('display', '');
					resizePatientPanel();
				});
			} else if (this.id == 'Primary_Contact_Info_Show') {
				$(this).click(function() {
					$('button#Primary_Contact_Info_Hide').addClass('selected');
					$('button#Primary_Contact_Info_Hide').css('display', '');
					$('div#primaryContactInfo').css('display', '');
					$(this).css('display','none');
					resizePatientPanel();
				});
			} else if (this.id == 'Primary_Contact_Info_Hide') {
				$(this).click(function() {
					$(this).removeClass('selected');
					$('div#primaryContactInfo').css('display', 'none');
					$(this).css('display', 'none');
					$('button#Primary_Contact_Info_Show').css('display', '');
					resizePatientPanel();
				});
			} else {
				$(this).click(function() {
					$(this).addClass('selected');
					createPanel(this.id,'record');
				});
			}
		});
	}

	function resizePatientPanel() {
		$('#caretrackingPanel').height( $('#caretrackingTable').height() + 8);
	}

	function closeCaretrackingPanel() {
		$('div#caretrackingPanel').css('display', 'none');
		showLoadingBox('body', 500, $(window).scrollTop());
		$('div#loadingListDiv').css('left', $(document).width()/2-$('div#loadingListDiv').width()/2);
		$('div#loadingListDiv').css('top', $(window).scrollTop()+$(window).height()/2-$('div#loadingListDiv').height()/2);
		$('div#loadingListDiv').css('display', '');

		checkOrderStatus($('div#caretrackingPanel').find('#patientInfo').find('#patNo').html());
		hideLoadingBox('body', 500);
		$('div#overlay').css('display', 'none');
		$('div#loadingListDiv').css('display', 'none');
	}

	function closeInputEntryPanel() {
		$('button.record').each(function(i, v) {
			if (this.id == 'Chronological_History_Show') {
			} else if (this.id == 'Chronological_History_Hide') {

			}
			else {
				$(this).removeClass('selected');
			}
		});
		$('div#overlay').css('z-index', '12');
		$('div#inputEntryPanel').css('display', 'none');
	}

	function closePage(pageID) {
		$('div#overlay').css('z-index', '12');
		$('div#'+pageID).css('display', 'none');
	}

	function initScroll(pane) {
		destroyScroll();
		$(pane).each(
			function()
			{
				apis.push($(this).jScrollPane({autoReinitialise:false}).data().jsp);
			}
		);
		return false;
	}

	function destroyScroll() {
		if (apis.length) {
			$.each(
				apis,
				function(i) {
					this.destroy();
				}
			);
			apis = [];
		}
		return false;
	}

	function submitAction(command) {
		if (command == 'search') {
			showLoadingBox('body', 500, $(window).scrollTop());
			document.searchForm.submit();
		} else if (command == 'clear') {
			$('table.contentFrameSearch').find('input[name=patNo]').val('');

			$('table.contentFrameSearch').find('select#doccode :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('input[name=doccode]').val('ALL');
			$('table.contentFrameSearch').find('select#doccodeCount :nth-child(1)').attr('selected', 'selected');
			removeExtraSelect('doccode');

			$('table.contentFrameSearch').find('input[name=patEName]').val('');
			$('table.contentFrameSearch').find('input[name=patCName]').val('');

			$('table.contentFrameSearch').find('select#birthDate_dd :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('select#birthDate_mm :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('select#birthDate_yy :nth-child(1)').attr('selected', 'selected');

			$('table.contentFrameSearch').find('select#start_ageyrs :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('select#end_ageyrs :nth-child(1)').attr('selected', 'selected');

			$('table.contentFrameSearch').find('select#admissionDate_dd :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('select#admissionDate_mm :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('select#admissionDate_yy :nth-child(1)').attr('selected', 'selected');

			$('table.contentFrameSearch').find('select#acm :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('input[name=acm]').val('ALL');
			$('table.contentFrameSearch').find('select#acmCount :nth-child(1)').attr('selected', 'selected');
			removeExtraSelect('acm');

			$('table.contentFrameSearch').find('select#ward :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('input[name=ward]').val('ALL');
			$('table.contentFrameSearch').find('select#wardCount :nth-child(1)').attr('selected', 'selected');
			removeExtraSelect('ward');

			$('table.contentFrameSearch').find('select#room :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('input[name=room]').val('ALL');

			$('table.contentFrameSearch').find('select#language :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('input[name=language]').val('ALL');
			$('table.contentFrameSearch').find('select#languageCount :nth-child(1)').attr('selected', 'selected');
			removeExtraSelect('language');

			$('table.contentFrameSearch').find('select#sex :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('input[name=sex]').val('ALL');

			$('table.contentFrameSearch').find('select#religion :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('input[name=religion]').val('ALL');
			$('table.contentFrameSearch').find('select#religionCount :nth-child(1)').attr('selected', 'selected');
			removeExtraSelect('religion');

			$('table.contentFrameSearch').find('select#repeatvisit :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('input[name=repeatvisit]').val('ALL');
			$('table.contentFrameSearch').find('select#repeatvisitCount :nth-child(1)').attr('selected', 'selected');
			removeExtraSelect('repeatvisit');

			$('table.contentFrameSearch').find('select[name=sortBy] :nth-child(1)').attr('selected', 'selected');
			$('table.contentFrameSearch').find('select[name=ordering] :nth-child(1)').attr('selected', 'selected');

			$('table.contentFrameSearch').find('textarea[name=diagnosis]').val('');
			$('#chapStaffID :nth-child(1)').attr('selected', 'selected');

			filterContact('clear');

		}

		return false;
	}

	function colorRow(dom) {
		if ($.trim($(dom).find("td").eq(16).html())=='I') {
			if ($(dom).find("td").eq(3).html()!=null) {
				$(dom).attr('id', $(dom).find("td").eq(3).html().replace(/^\s+|\s+$/g, ''));

				var patNo = 'patNo=' +  $(dom).find("td").eq(3).html().replace(/^\s+|\s+$/g, '');
				var regID = 'regID=' +  $(dom).find("td").eq(8).html().replace(/^\s+|\s+$/g, '');
				var admissionDate = 'admissionDate=' +  $(dom).find("td").eq(11).html().replace(/^\s+|\s+$/g, '');

				var dischargedDate = 'dischargedDate=' + $.trim( $(dom).find("td").eq(12).html());

				var baseUrl ='../chaplaincy/visitHistory.jsp?action=checkContact';
				var url = baseUrl + '&' + patNo + '&' + regID + '&' + admissionDate + '&' + dischargedDate;

				$.ajax({
					url: url,
					async:true,
					cache:false,
					success: function(values) {
						var trimmed = values.replace(/^\s+|\s+$/g, '') ;
						dom.attr('class', '');

							if (trimmed.indexOf('contactedCurrentAdmission')!=-1) {
								dom.attr('class', 'contactedCurrentAdmission');
							} else if (trimmed.indexOf('contactedIndirectly')!=-1) {
								dom.attr('class', 'contactedIndirectly');
							} else if (trimmed.indexOf('contactedPreviousAdmission')!=-1) {
								dom.attr('class', 'contactedPreviousAdmission');
							} else if (trimmed.indexOf('contactedPreviousIndirectly')!=-1) {
								dom.attr('class', 'contactedPreviousIndirectly');
							} else if (trimmed.indexOf('notContactedAfterOneDay')!=-1) {
								dom.attr('class', 'notContactedAfterOneDay');
							} else {
								dom.attr('class', 'notContacted');
							}

							if (trimmed.indexOf('procedureScheduled')!=-1) {
								dom.addClass('procedureScheduled');
							}

					},
					error: function() {

					}
				});

				$(dom).find("td").eq(15).css('background-color','');
				if ($.trim($(dom).find("td").eq(15).html()).length>0) {
					var repeatVisit = $.trim($(dom).find("td").eq(15).find("#status"+$(dom).find("td").eq(3).html().replace(/^\s+|\s+$/g, '')).html());

					if (repeatVisit == 'DND') {
							$(dom).find("td").eq(15).css('background-color','#FF3232');
					} else if (repeatVisit == 'Again' || repeatVisit == 'Frequently' || repeatVisit == 'Daily') {
						var patNo = 'patNo=' +  $(dom).find("td").eq(3).html().replace(/^\s+|\s+$/g, '');
						var paramRepeatVisit = 'visitStatus=' + repeatVisit;

						var baseUrl ='../chaplaincy/visitStatus.jsp?action=checkRepeatVisit';
						var url = baseUrl + '&' + patNo + '&' + paramRepeatVisit;

						$.ajax({
							url: url,
							async:true,
							cache:false,
							success: function(values) {
								if (values.indexOf('nolog')!=-1) {
									$(dom).find("td").eq(15).css('background-color','#FF3232');
								}
							},
							error: function() {

							}
						});
					} else {
						var patNo = 'patNo=' +  $(dom).find("td").eq(3).html().replace(/^\s+|\s+$/g, '');

						var baseUrl ='../chaplaincy/visitStatus.jsp?action=checkRefChapID';
						var url = baseUrl + '&' + patNo;

						$.ajax({
							url: url,
							async:true,
							cache:false,
							success: function(values) {
							if (values.indexOf('nologafteronedayref')!=-1) {
								$(dom).find("td").eq(15).css('background-color','#FF3232');
							} else if (values.indexOf('overoneday')!=-1) {
								$(dom).find("td").eq(15).css('background-color','white');
							}
							},
							error: function() {

							}
						});
					}
					$(dom).find("td").eq(15).css("color","black");
				}
			}
		} else if ($.trim($(dom).find("td").eq(16).html())=='O') {
			if ($(dom).find("td").eq(3).html()!=null) {
				$(dom).attr('id', $(dom).find("td").eq(3).html().replace(/^\s+|\s+$/g, ''));

				var patNo = 'patNo=' +  $(dom).find("td").eq(3).html().replace(/^\s+|\s+$/g, '');
				var regID = 'regID=' +  $(dom).find("td").eq(8).html().replace(/^\s+|\s+$/g, '');

				var baseUrl ='../chaplaincy/visitHistory.jsp?action=checkContactOutPatient';
				var url = baseUrl + '&' + patNo + '&' + regID;

				$.ajax({
					url: url,
					async:true,
					cache:false,
					success: function(values) {
						var trimmed = values.replace(/^\s+|\s+$/g, '') ;
						dom.attr('class', '');

						if (trimmed.indexOf('contactedCurrentAdmission')!=-1) {
							dom.attr('class', 'contactedCurrentAdmission');
						} else if (trimmed.indexOf('contactedIndirectly')!=-1) {
							dom.attr('class', 'contactedIndirectly');
						} else if (trimmed.indexOf('contactedPreviousAdmission')!=-1) {
							dom.attr('class', 'contactedPreviousAdmission');
						} else if (trimmed.indexOf('contactedPreviousIndirectly')!=-1) {
							dom.attr('class', 'contactedPreviousIndirectly');
						} else if (trimmed.indexOf('notContactedAfterOneDay')!=-1) {
							dom.attr('class', 'notContactedAfterOneDay');
						} else {
							dom.attr('class', 'notContacted');
						}

						if (trimmed.indexOf('procedureScheduled')!=-1) {
							dom.addClass('procedureScheduled');
						}
					},
					error: function() {

					}
				});

				$(dom).find("td").eq(15).css('background-color','');
				if ($.trim($(dom).find("td").eq(15).html()).length>0) {
					var repeatVisit = $.trim($(dom).find("td").eq(15).find("#status"+$(dom).find("td").eq(3).html().replace(/^\s+|\s+$/g, '')).html());

					if (repeatVisit == 'DND') {
							$(dom).find("td").eq(15).css('background-color','#FF3232');
					} else if (repeatVisit == 'Again' || repeatVisit == 'Frequently' || repeatVisit == 'Daily') {
							var patNo = 'patNo=' +  $(dom).find("td").eq(3).html().replace(/^\s+|\s+$/g, '');
							var paramRepeatVisit = 'visitStatus=' + repeatVisit;

							var baseUrl ='../chaplaincy/visitStatus.jsp?action=checkRepeatVisit';
							var url = baseUrl + '&' + patNo + '&' + paramRepeatVisit;

							$.ajax({
								url: url,
								async:true,
								cache:false,
								success: function(values) {
									if (values.indexOf('nolog')!=-1) {
										$(dom).find("td").eq(15).css('background-color','#FF3232');
									}
								},
								error: function() {

								}
							});
					} else {
							var patNo = 'patNo=' +  $(dom).find("td").eq(3).html().replace(/^\s+|\s+$/g, '');

							var baseUrl ='../chaplaincy/visitStatus.jsp?action=checkRefChapID';
							var url = baseUrl + '&' + patNo;

							$.ajax({
								url: url,
								async:true,
								cache:false,
								success: function(values) {
								if (values.indexOf('nologafteronedayref')!=-1) {
									$(dom).find("td").eq(15).css('background-color','#FF3232');
								} else if (values.indexOf('overoneday')!=-1) {
									$(dom).find("td").eq(15).css('background-color','white');
								}
							},
							error: function() {

							}
						});
					}
					$(dom).find("td").eq(15).css("color","black");
				}
			}
		}
	}

	function checkOrderStatus(patNo) {
		if (patNo === undefined) {
			$('#row tr').each(function(i, v) {
				var dom = $(this);
				colorRow(dom);
			});
		} else {
			var dom = $('tr[id='+patNo+']');
			colorRow(dom);
		}
	}

	function getSearchValues(type,url, val,sex,religion,language,doccode,acm,repeatvisit) {
		var tempType = '';
		if (type.indexOf('roomMulti')!=-1) {
			tempType = type;
			type = 'Room';
		}

		if (type=='acm') {
			type = 'Class';
		}

		$.ajax({
			url:url,
			async: false,
			cache:false,
			data: "Type="+type+"&Value="+val+"&sex="+sex+"&religion="+religion+"&language="+language+
				  "&doccode="+doccode+"&repeatvisit="+repeatvisit,
			success: function(values) {

				if (type == 'Class') {
					type = 'acm';
				}
				if (tempType.indexOf('roomMulti')!=-1) {
					$('select#'+tempType).html("<option value='ALL'>ALL</option>"+values);
					$('select#'+tempType).val($('input[id=hidden'+tempType+']').val());

				} else {
					$('select#'+type.toLowerCase()).html("<option value='ALL'>ALL</option>"+values);
					if (type.toLowerCase() != "room") {
						var str;
						for (var i=1;i<=$('select#'+type.toLowerCase()+' option').length - 1;i++) {
							str = str + '<option value="'+i+'">'+i+'</option>';
						}

						//$('#'+type+'Frame').find('select').html( str);
						$('select#'+type.toLowerCase()+'Count').html(str);
						$('select#'+type.toLowerCase()+'Count').val($('input[id=hidden'+type.toLowerCase()+'Count]').val());
						createExtraSelect($('select#'+type.toLowerCase()+'Count').val(),type.toLowerCase());
					} else {
						$('select#'+type.toLowerCase()).val($('input[name=room]').val());
					}
					selectWREvent(type);
				}

			},
			error: function() {
				alert('Error occured.');
			}
		});
	}

	function createExtraSelect(numberOfSelect,type) {
		removeExtraSelect(type);
		if (type == "ward") {
			for (var i=2;i<=numberOfSelect;i++)
			{
				$('#'+type+'Cell').append('</br><select name="'+type+'Multi" id="'+type+'Multi'+i+'" >'+$('select#'+type).html()+'</select>');

				$('select[id='+type+'Multi'+i+'] option:first').text("");
				$('select[id='+type+'Multi'+i+']').val($('input[id=hidden'+type+'Multi'+i+']').val());

				selectWREvent(type+'Multi'+i);
				$('#roomCell').append('</br><select name="roomMulti" id="roomMulti'+i+'" >'+$('select#room').html()+'</select>');
				$('select[id=roomMulti'+i+'] option:first').text("");
				$('select[id=roomMulti'+i+']').val($('input[id=hiddenroomMulti'+i+']').val());

				getSearchValues('roomMulti'+i,'../ui/rm_bedCMB.jsp',$('select[id='+type+'Multi'+i+'] :selected').val());

			}
		} else {

			for (var i=2;i<=numberOfSelect;i++)
			{
				$('#'+type+'Cell').append('</br><select name="'+type+'Multi" id="'+type+'Multi'+i+'" >'+$('select#'+type).html()+'</select>');

				$('select[id='+type+'Multi'+i+'] option:first').text("");
				$('select[id='+type+'Multi'+i+'] option:first-child').attr("selected", true);

				$('select[id='+type+'Multi'+i+']').val($('input[id=hidden'+type+'Multi'+i+']').val());
			}
		}
	}

	function removeExtraSelect(type) {
		if (type == "ward") {
			$('select[name='+type+'Multi]').remove();
			$('#'+type+'Cell').find('br').remove();
			$('select[name=roomMulti]').remove();
			$('#roomCell').find('br').remove();
		} else {
			$('select[name='+type+'Multi]').remove();
			$('#'+type+'Cell').find('br').remove();
		}
	}

	function selectWREvent(type) {
		if (type.indexOf("wardMulti") != -1) {
			$('select#'+type).change(function() {

				var tempType = type;

				tempType = tempType.replace("ward","room");
				getSearchValues(tempType,'../ui/rm_bedCMB.jsp',$('select[id='+type+'] :selected').val());

			}).trigger('change');
		} else {
			$('select#'+type.toLowerCase()).change(function() {
					$('option:selected', this).each(function() {
					$('input[name='+type.toLowerCase()+']').val(this.value);
			    });
				if (type =='Ward')
				getSearchValues('Room','../ui/rm_bedCMB.jsp', $('input[name=ward]').val());

			}).trigger('change');

			$('select#'+type.toLowerCase()+'Count').change(function() {

				createExtraSelect($('select#'+type.toLowerCase()+'Count').val(),type.toLowerCase());
			}).trigger('change');
		}
	}

	function createClickableRow() {
		$('#row td').each(function(i,v) {
			$(this).click(function() {
				createPanel('',
					'list',
					this,
					$.trim( $(this).parent('tr').find("td").eq(3).html()),
					null,
					$.trim($(this).parent('tr').find("td").eq(12).html()),
					$.trim( $(this).parent('tr').find("td").eq(15).html()),
					$.trim( $(this).parent('tr').find("td").eq(16).html()),
					$.trim( $(this).parent('tr').find("td").eq(1).html()));
			});
		});
	}

	function removeDiagnosis(patNo) {
		createSubPanel(patNo,'removeDiagnosis');
	}

	function createSubPanel(patNo,type,chaplain) {
		var baseUrl ='../chaplaincy/createSubPanel.jsp?';
		var remark='';
		if (type == "saveDiagnosis") {
			remark =encodeURIComponent($('textarea#diagnosisEntry').val());
		} else if (type == "removeDiagnosis") {
			remark = '';
		}
		var askDiaglog = true;
		if (type == "removeDiagnosis") {
			askDiaglog = confirm("Remove referred chaplain?");
		}
		if ( askDiaglog == true ) {
			var url = baseUrl + 'patNo=' + patNo + '&type=' + type + '&remark=' + remark + '&chaplain=' + chaplain;

			$.ajax({
				url: url,
				async: false,
				cache:false,
				success: function(values) {
					if (values) {
						if (type == "saveDiagnosis") {
							if (values.indexOf('true') > -1) {
								alert('Diagnosis Added Successfully.');
								$('#displayDiagnosis').text($('#diagnosisEntry').val());
								closePage('diagnosisPage');
								resizePatientPanel();
							} else {
								alert('Error occured while adding diagnosis.');
							}
						} else if (type == 'removeDiagnosis') {
							if (values.indexOf('true') > -1) {
								alert('Diagnosis Removed Successfully.')
								$('#displayDiagnosis').text('');
							} else {
								alert('Error occured while removing diagnosis.');
							}
						} else {
							$('div#overlay').css('z-index', '15');
							$('div#'+type+'Page').css('top', $(window).scrollTop()+($(window).height()-$('div#'+type+'Page').height())/2);
							$('div#'+type+'Page').css('left', ($(window).width()-$('div#'+type+'Page').width())/2);
							$('div#'+type+'Page').css('display', '');
							$('div#'+type+'InfoTable').html(values);
						}
					}
				},
				error: function() {
					if (type == 'admissionHistory') {
						alert('Error occured while displaying admission history.');
					} else if (type == 'diagnosis') {
						alert('Error occured while displaying diagnosis.');
					} else if (type == 'saveDiagnosis') {
						alert('Error occured while saving diagnosis.');
					} else {
						alert('Error occured.');
					}
				}
			});
	   	}
	}

	function textBoxNameEvent(type) {
		$('input[name='+type+']').keydown(function() {
			$('#'+type+'Cell').append('</br><input type="textfield" size="30" maxlength="30" value="fdwasdftrweqwertrewqertqwetqwe" name="patNo">');

		})
	}

	$(document).ready(function() {
		showLoadingBox('body', 500, $(window).scrollTop());
		$('div#overlay').css('height', $(document).height());
		$('div#overlay').css('width', $(document).width());
		$('div#overlay').css('display', '');
		$('div#overlay').css('z-index', '12');
		$('div#loadingListDiv').css('left', $(document).width()/2-$('div#loadingListDiv').width()/2);
		$('div#loadingListDiv').css('top', $(window).scrollTop()+$(window).height()/2-$('div#loadingListDiv').height()/2);
		$('div#loadingListDiv').css('display', '');

		getSearchValues('Ward','../ui/ward_classCMB.jsp', $('input[name=ward]').val());
		getSearchValues('Sex','../ui/sexCMB.jsp','', $('input[name=sex]').val());
		getSearchValues('Religion','../ui/relCodeCMB.jsp','','',$('input[name=religion]').val());
		getSearchValues('Language','../ui/mothCodeCMB.jsp','','','',$('input[name=language]').val());
		getSearchValues('doccode','../ui/docCodeCMB.jsp','','','','',$('input[name=doccode]').val());
		getSearchValues('acm','../ui/ward_classCMB.jsp',$('input[name=acm]').val());
		getSearchValues('repeatvisit','../ui/repeatVisitCMB.jsp','','','','','','',$('input[name=repeatvisit]').val());

		//textBoxNameEvent('patNo');

		$('th.header:nth-child(13)').hide();

		$('th.header:nth-child(12)').hide();

		$('th.header:nth-child(9)').hide();
		$('th.header:nth-child(1)').hide();
		$('th.header:nth-child(17)').hide();

		$('th.header').css('background-color','#F5EAF0');
		//$('th').unbind('click');
		createClickableRow();
		checkOrderStatus();
		hideLoadingBox('body', 500);
		$('div#overlay').css('display', 'none');
		$('div#loadingListDiv').css('display', 'none');
		initScroll('.scroll-pane');
	});

<%
	for (OTDateRecord ott : otDateRecordList) {

		String patientOT = "";
		String otYear = "";
		String otMonth = "";
		String otDay = "";
		String otHour = "";
		String otMin = "";
		String otSec = "";
		if (ott.otDate!= null && ott.otDate.length()>0) {

			patientOT = ott.otDate;
			String[] otDate = patientOT.split(" ");
			otDay = otDate[0].split("/")[0];
			otMonth = otDate[0].split("/")[1];
			otYear = otDate[0].split("/")[2];

			otHour = otDate[1].split(":")[0];
			otMin = otDate[1].split(":")[1];
			otSec = otDate[1].split(":")[2];

%>
var date<%=ott.otPatNo%> = new Date(<%=otYear%>,<%=Integer.parseInt(otMonth)-1%>,<%=otDay%>,<%=otHour%>,<%=otMin%>,<%=otSec%>);
<%
		}
	}
%>

	function GetCount(ddate,iid) {

		dateNow = new Date();
		amount = ddate.getTime() - dateNow.getTime();
		hours=0;
		mins=0;
		out="";
		if (amount < 0) {
			amount =  dateNow.getTime() -  ddate.getTime();
			amount = Math.floor(amount/1000);
			hours=Math.floor(amount/3600);
			amount=amount%3600;
			mins=Math.floor(amount/60);
			amount=amount%60;
			out = out + '(';
			if (hours >= 0) {out += (hours<=9?'0':'')+hours +" "+((hours==1)?"hour":"hours")+" : ";}
			if (mins >= 0) {out += (mins<=9?'0':'')+mins +" "+((mins==1)?"min":"mins")+", ";}
			out = out.substr(0,out.length-2);
			document.getElementById(iid).innerHTML=out + ') Since Procedure ';

		}
		else {
			amount = Math.floor(amount/1000);
			hours=Math.floor(amount/3600);
			amount=amount%3600;
			mins=Math.floor(amount/60);
			amount=amount%60;
			out = out + '(';
			if (hours >= 0) {out += (hours<=9?'0':'')+hours +" "+((hours==1)?"hour":"hours")+" : ";}
			if (mins >= 0) {out += (mins<=9?'0':'')+mins +" "+((mins==1)?"min":"mins")+", ";}
			out = out.substr(0,out.length-2);
			document.getElementById(iid).innerHTML=out + ') Until Procedure ';
		}
		delete dateNow;
		setTimeout(function() {GetCount(ddate,iid)}, 1000);

	}

	window.onload=function() {
<%
		for (OTDateRecord ott : otDateRecordList) {

%>
		GetCount(date<%=ott.otPatNo%>, 'countbox<%=ott.otPatNo%>');
<%
		}
%>
	};

</script>