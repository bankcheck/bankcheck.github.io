<%@ page import="java.io.*"%>
<%@ page language="java" import="org.json.JSONObject"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*"%>
<%@ page import="net.sf.jasperreports.engine.util.*"%>
<%@ page import="net.sf.jasperreports.engine.export.*"%>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*"%>
<%@ page import="net.sf.jasperreports.engine.JasperPrint"%>


<%
	String message = null;
	String errorMessage = null;
	ArrayList result = null;

	//get information for CIS
	String mode = ParserUtil.getParameter(request, "mode"); //new, edit, view, viewFromID, update
	String action = ParserUtil.getParameter(request, "action"); //update, check
	String patNo = ParserUtil.getParameter(request, "patno");
	String caseNo = ParserUtil.getParameter(request, "caseno");
	String caseType = ParserUtil.getParameter(request, "caseType");
//20250520 Arran add showCategories to displays category list
	boolean showCategories = (caseType == null || caseType.isEmpty());
	
	String typeDesc = ParserUtil.getParameter(request, "typeDesc");
	String regid = ParserUtil.getParameter(request, "regid");//if no reg, default = 0

	String caseDate = ParserUtil.getParameter(request, "caseDate");
	String currAssessDate = ParserUtil.getParameter(request,"assessDate");

	String Information = ParserUtil.getParameter(request, "Information"); // patient tick
	String ad1 = ParserUtil.getParameter(request, "ad1");
	String ad5 = ParserUtil.getParameter(request, "ad5");
	if (ad1 == null) {
		ad1 = "N";
	}
	if (ad5 == null) {
		ad5 = "N";
	}
	Information = "[ad1=" + ad1 + "][ad5=" + ad5 + "]";

	String diagnosis = ParserUtil.getParameter(request, "diagnosis");
	String pastMedHist = ParserUtil.getParameter(request, "pastMedHist");
	String socialHistory = ParserUtil.getParameter(request, "socialHistory");
	String emotional = ParserUtil.getParameter(request, "emotional");
	String funcAssmt = ParserUtil.getParameter(request, "funcAssmt");
	String fallAssmt = ParserUtil.getParameter(request, "fallAssmt");
	String patientGoal = ParserUtil.getParameter(request, "patientGoal");

	String hpi = ParserUtil.getParameter(request, "hpi");
	String subjective = ParserUtil.getParameter(request, "subjective");
	String objective = ParserUtil.getParameter(request, "objective");
	String treatmentGoal = ParserUtil.getParameter(request, "treatmentGoal");
	String treatment = ParserUtil.getParameter(request, "treatment");

	String histProgNotes = ParserUtil.getParameter(request,
			"histProgNotes");
	String progNotes = ParserUtil.getParameter(request, "progNotes");

	String userid = ParserUtil.getParameter(request, "userid");
	String username = ParserUtil.getParameter(request, "username");
	if (username == null || username.isEmpty()) {
		result = AlliedNotesDB.getDocInfo(userid);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			username = reportableListObject.getValue(1);
		}
	}

	String url = null;
	String logo = null;
	if (ConstantsServerSide.isTWAH()) {
		url = "http://www.twah.org.hk";
		logo = "twah_portal_logo.gif";
	} else {
		url = "http://www.hkah.org.hk";
		logo = "hkah_portal_logo.gif";
	}
	String patName = null;
	String patFname = null;
	String patGname = null;
	String patAge = null;
	String patSex = null;
	String patDob = null;
	String patIDNo = null;
	String patReli = null;
	String patCname = null;
	String docName = null;
	boolean editable = false;
	boolean forceNew = "Y".equals(ParserUtil.getParameter(request,"forceNew")) ? true : false;
	boolean saveComplete = false;
	//get patNo using regid
	if (patNo == null || patNo.isEmpty()) {
		result = OpdRehabDB.getPatID(regid);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			patNo = reportableListObject.getValue(1);
			patName = reportableListObject.getValue(2);
			patDob = reportableListObject.getValue(3);
			patSex = reportableListObject.getValue(4);
			patIDNo = reportableListObject.getValue(5);
			patReli = reportableListObject.getValue(6);
			patCname = reportableListObject.getValue(7);
			patFname = reportableListObject.getValue(8);
			patGname = reportableListObject.getValue(9);
		}
	} else {
		//get pat info
		result = PatientDB.getPatInfo(patNo);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			patName = reportableListObject.getValue(3);
			patDob = reportableListObject.getValue(10);
			patSex = reportableListObject.getValue(1);
			patIDNo = reportableListObject.getValue(2);
			patReli = reportableListObject.getValue(9);
			patCname = reportableListObject.getValue(4);
			patFname = reportableListObject.getValue(11);
			patGname = reportableListObject.getValue(12);
		}
	}
	System.out.println("patCname:" + patCname);
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat dateFmt = new SimpleDateFormat("dd/MM/yyyy");
	String sysDate = dateFmt.format(cal.getTime());

	if ("create".equals(action) || "printSave".equals(action)|| "update".equals(action)) {
		if ("create".equals(mode)) {
			//insert form and progress note to db	
			caseNo = AlliedNotesDB.insertForm(caseNo, caseType,
					caseDate, patNo, regid, diagnosis, pastMedHist,
					socialHistory, emotional, funcAssmt, fallAssmt,
					patientGoal, hpi, subjective, objective,
					treatmentGoal, treatment, Information, userid,
					progNotes);
		} else if ("update".equals(mode)) {
			//update form to db
			caseNo = AlliedNotesDB.updateForm(caseNo, caseType,
					caseDate, patNo, regid, diagnosis, pastMedHist,
					socialHistory, emotional, funcAssmt, fallAssmt,
					patientGoal, hpi, subjective, objective,
					treatmentGoal, treatment, Information, userid,
					progNotes);
		}
		if (!"0".equals(caseNo)) {
			saveComplete = true;
		}
		System.err.println(errorMessage);
	}

	ArrayList result1 = null;
	String path = "";
	result1 = OpdRehabDB.getFormPath();
	if (result1.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result1.get(0);
		path = reportableListObject.getValue(0);
	}

	String createDate = null;
	//Check case no
	if (caseNo == null || caseNo.isEmpty()) {
		result = AlliedNotesDB.getAlliedCaseByPatno(patNo, caseType);
		if (result.size() > 0 && !forceNew) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			caseNo = reportableListObject.getValue(0);
			caseType = reportableListObject.getValue(1);
			caseDate = reportableListObject.getValue(2);
			//status = reportableListObject.getValue(3);
			//patNo = reportableListObject.getValue(4);
			//regid = reportableListObject.getValue(5);

			diagnosis = reportableListObject.getValue(6);
			pastMedHist = reportableListObject.getValue(7);
			socialHistory = reportableListObject.getValue(8);
			emotional = reportableListObject.getValue(9);
			funcAssmt = reportableListObject.getValue(10);
			fallAssmt = reportableListObject.getValue(11);
			patientGoal = reportableListObject.getValue(12);

			hpi = reportableListObject.getValue(13);
			subjective = reportableListObject.getValue(14);
			objective = reportableListObject.getValue(15);
			treatmentGoal = reportableListObject.getValue(16);
			treatment = reportableListObject.getValue(17);
			//defection = reportableListObject.getValue(18);

			ad1 = reportableListObject.getValue(19);
			ad5 = reportableListObject.getValue(20);

			//createUser = reportableListObject.getValue(21)
			createDate = reportableListObject.getValue(22);

			SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
			Date date1 = format.parse(caseDate);
			Date date2 = format.parse(sysDate);

			Date diff = new Date(date2.getTime() - date1.getTime());
			long diffDate = diff.getTime() / (60 * 60 * 1000 * 24);
			System.err.println("[currAssessDate]" + currAssessDate + ";[caseDate]:" + caseDate + ";[diff]:" + diff + ";[diffDate]:");
			if (diffDate <= 7) {
				editable = true;
			} else {
				editable = false;
			}

			String curUpdateUser = "";
			String curUpdateDate = "";
			String curUpdateProgNotes = "";
			histProgNotes = "";
			//getProgressNote
			result = AlliedNotesDB.getAlliedCaseProgress(caseNo);
			if (result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					ReportableListObject reportableListObject1 = (ReportableListObject) result.get(i);
					curUpdateUser = reportableListObject1.getValue(7);
					curUpdateDate = reportableListObject1.getValue(2);
					curUpdateProgNotes = reportableListObject1.getValue(4);

					histProgNotes += curUpdateDate + " by "	+ curUpdateUser + ": " + curUpdateProgNotes + "<br/>";
				}
			}
			mode = "update";
		} else {
			mode = "create";// New case New record
			caseNo = null;
			createDate = null;
			editable = true;
		}
	} else {
		if ((caseType == null || caseType.isEmpty()) && !"print".equals(action)) {

		} else {
			
			result = AlliedNotesDB.getAlliedCaseInfo(caseNo, caseType);
			if (result.size() > 0) {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				caseNo = reportableListObject.getValue(0);
				caseType = reportableListObject.getValue(1);
				caseDate = reportableListObject.getValue(2);
				//status = reportableListObject.getValue(3);
				//patNo = reportableListObject.getValue(4);
				//regid = reportableListObject.getValue(5);

				diagnosis = reportableListObject.getValue(6);
				pastMedHist = reportableListObject.getValue(7);
				socialHistory = reportableListObject.getValue(8);
				emotional = reportableListObject.getValue(9);
				funcAssmt = reportableListObject.getValue(10);
				fallAssmt = reportableListObject.getValue(11);
				patientGoal = reportableListObject.getValue(12);

				hpi = reportableListObject.getValue(13);
				subjective = reportableListObject.getValue(14);
				objective = reportableListObject.getValue(15);
				treatmentGoal = reportableListObject.getValue(16);
				treatment = reportableListObject.getValue(17);
				//defection = reportableListObject.getValue(18);

				ad1 = reportableListObject.getValue(19);
				ad5 = reportableListObject.getValue(20);

				//createUser = reportableListObject.getValue(21)
				createDate = reportableListObject.getValue(22);

				SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
				Date date1 = format.parse(caseDate);
				Date date2 = format.parse(sysDate);

				Date diff = new Date(date2.getTime() - date1.getTime());
				long diffDate = diff.getTime() / (60 * 60 * 1000 * 24);
				System.err.println("[currAssessDate]" + currAssessDate + ";[caseDate]:" + caseDate + ";[diff]:" + diff + ";[diffDate]:");
				System.err.println(diffDate <= 7);
				if (diffDate <= 7) {
					editable = true;
				} else {
					editable = false;
				}

				String curUpdateUser = "";
				String curUpdateDate = "";
				String curUpdateProgNotes = "";
				histProgNotes = "";
				//getProgressNote
				result = AlliedNotesDB.getAlliedCaseProgress(caseNo);

				if (result.size() > 0) {
					for (int i = 0; i < result.size(); i++) {
						ReportableListObject reportableListObject1 = (ReportableListObject) result.get(i);
						curUpdateUser = reportableListObject1.getValue(7);
						curUpdateDate = reportableListObject1.getValue(2);
						curUpdateProgNotes = reportableListObject1.getValue(4);

						histProgNotes += curUpdateDate + " by " + curUpdateUser + ": " + curUpdateProgNotes + "<br/>";
					}

				}
				mode = "update";
			}
		}
	}

	if ("print".equals(action) || "printSave".equals(action) || ("readonly".equals(mode) && "view".equals(action))) {
		File reportFile = new File(application.getRealPath("/report/AlliedNotes.jasper"));
		File reportDir = new File(application.getRealPath("/report/"));
		if (reportFile.exists()) {
			JasperReport jasperReport = (JasperReport) JRLoader.loadObject(reportFile.getPath());

			Map parameters = new HashMap();
			parameters.put("BaseDir", reportFile.getParentFile());
			parameters.put("Site", ConstantsServerSide.SITE_CODE);
			parameters.put("path", path);
			parameters.put("SUBREPORT_DIR", reportDir.getPath() + "\\");

			parameters.put("regid", regid);
			parameters.put("patno", patNo);
			parameters.put("patName", patName);
			parameters.put("patDOB", patDob);
			parameters.put("patSex", patSex);

			parameters.put("caseDate", caseDate);
			parameters.put("patientGoal", patientGoal);
			parameters.put("funcAssmt", funcAssmt);
			parameters.put("diagnosis", diagnosis);
			parameters.put("emotional", emotional);
			parameters.put("fallAssmt", fallAssmt);
			parameters.put("pastMedHist", pastMedHist);
			parameters.put("socialHistory", socialHistory);
			parameters.put("hpi", hpi);
			parameters.put("subjective", subjective);
			parameters.put("objective", objective);

			parameters.put("treatmentGoal", treatmentGoal);
			parameters.put("treatment", treatment);
			parameters.put("Information", Information);
			parameters.put("ad1", ad1);
			parameters.put("ad5", ad5);

			parameters.put("username", username);
			parameters.put("progNotes", progNotes);
			parameters.put("histProgNotes", histProgNotes);
			System.err.println("[progNotes]:" + progNotes + ";[histProgNotes]:" + histProgNotes);
			parameters.put("SubDataSource", new ReportListDataSource(UtilDBWeb.getReportableList("Select 1 From Dual Connect By Level <= 1")));

			JasperPrint jasperPrint = JasperFillManager.fillReport(
							jasperReport,
							parameters,
							new ReportListDataSource(
									UtilDBWeb.getReportableList("Select 1 From Dual Connect By Level <= 1")));

			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE,jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/pdf");
			JRPdfExporter exporter = new JRPdfExporter();
			exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
			exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
			exporter.exportReport();
			return;
		}
	}
	
//Arran Added	
	String category = "";

	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT CODE_VALUE1 ");
	sqlStr.append("FROM AH_SYS_CODE ");
	sqlStr.append("WHERE SYS_ID = 'ALL' ");
	sqlStr.append("AND CODE_TYPE = 'ALLIED_TYPE' ");
	sqlStr.append("AND STATUS = 'V' ");
	sqlStr.append("AND CODE_NO = ? ");
	
	result = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[]{caseType});
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		category = reportableListObject.getValue(0);
	}
//Arran end			
%>
<!DOCTYPE html>
<html>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<head>
<title>Allied Notes</title>
<meta http-equiv="X-UA-Compatible" content="chrome=1, IE=edge">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Expires" content="0">
<style>
body {
	
}

<%if ("view ".equals(mode) || "viewFromID ".equals(mode)) {%> 
body {
	background:gainsboro;
}

#page {
	background: white;
	width: 200mm;
}

#inputForm {
	overflow: auto;
	border: 1px solid;
	border-color: #0000ff;
	margin-bottom: 10mm;
	margin-top: 5mm;
	margin-left: 0px;
	margin-right: 0px;
	padding: 5mm;
}
<%}%>

input:hover[type=text] {
	background: #ffc;
}

.noBorderText {
	border: none;
	border-bottom: 0.5px solid;
	width: 250px;
}

table {
	vertical-align: top;
}

td[rowspan] {
	vertical-align: top;
	text-align: left;
}

.title {
	vertical-align: top;
	font-weight: bold;
}

textarea {
	width: 90%;
}

.formLabel {
	overflow: hidden;
	width: 100%;
	border: 1px solid black;
	margin-bottom: 30px;
}

#nameLabel {
	float: left;
	width: 50%;
	margin-right: -1px;
	padding-bottom: 500em;
	margin-bottom: -500em;
}

#barcodeLabel {
	float: left;
	width: 50%;
	margin-right: -1px;
	border-left: 1px solid black;
	padding-bottom: 500em;
	margin-bottom: -500em;
}

#barcodeLabel table {
	width: 100%;
	text-align: center;
	border-collapse: collapse;
}

span {
	margin-top: 5px;
}

input[type=button] {
	margin-left: 20px;
	margin-right: 20px;
}

footer {
	z-index: 1;
	position: fixed;
	bottom: 0;
	left: 0;
	right: 0;
	height: 40px;
	background-color: gainsboro;
}

tr.noBorder td {
	border: 0;
}

.textField1 {
	width: 90%;
}

#SavePopup {
	display: none; /* Hidden by default */
	position: absolute;
	z-index: 1; /* Sit on top */
	left: 88%;
	top: 85%;
	width: 12%;
	height: 7%;
	overflow: auto; /* Enable scroll if needed */
	background-color: gainsboro;
	margin: auto;
	padding: 0px;
	border: 1px solid #888;
}
</style>
<script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
<script type="text/javascript" src="../js/hkah.js" /></script>
<script type="text/javascript">
fullscreen();

	 jQuery.browser = {};
	  (function () {
	   jQuery.browser.msie = false;
	   jQuery.browser.version = 0;
	   if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
	    jQuery.browser.msie = true;
	    jQuery.browser.version = RegExp.$1;
	   }
	})();	
	
	function lockPatInfo() {		
		$('.patInfo').attr('readOnly',true);
	}

	function displayView(){		
		// lock the field when view mode
		<%if ("view".equals(mode) || "viewFromID".equals(mode)) {%>
			$('input').prop('readonly', true);
			$('textarea').prop('readonly', true);
			$('#inputForm input[type=radio]').prop('disabled', true);
			$('input[type=checkbox]').prop('disabled', true);
			$('input[type=text]').css('border-bottom','none');
		<%}%>	
		<%if ("check".equals(action)) {%>
			$('#update').remove();
			$('#printUpdate').remove();
		<%}%>
		};
	
	
	function validDate(obj) {
		date=obj.value;
		if (/[^\d/]|(\/\/)/g.test(date)) {
			obj.value=obj.value.replace(/[^\d/]/g,'');
			obj.value=obj.value.replace(/\/{2}/g,'/');
			return;
		}
		if (/^\d{2}$/.test(date)) {
			obj.value=obj.value+'/';
			return;
		}
		if (/^\d{2}\/\d{2}$/.test(date)) {
			obj.value=obj.value+'/';
			return;
		}
		if (!/^\d{2}\/\d{2}\/\d{4}$/.test(date)) {
			return;
		}
		test1=(/^\d{2}\/?\d{2}\/\d{4}$/.test(date));
		date=date.split('/');
		d=new Date(date[2],date[1]-1,date[0]);
		test2=(1*date[0]==d.getDate() && 1*date[1]==(d.getMonth()+1) && 1*date[2]==d.getFullYear());
		if (test1 && test2) return true;
		obj.select();
		obj.focus();
		return false;
	}	
</script>

</head>
<script src="../js/ui.datepicker.js" type="text/javascript"></script>
<script src="../js/jquery.searchabledropdown-1.0.8.min.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/flora.datepicker.css" />" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/w3.hkah.css" />" />
<body>
	<form name="form1" id="form1" action="alliedNotes.jsp" method="post">
		<div id="page">
			<div id="inputForm">
				<div class="title">
					<table width="100%" border="1">
						<th colspan="5" bgcolor='#D8BFD8' class="w3-container ah-pink w3-large">Allied Notes</th>
						<tr bgcolor='#DDDDD'>
							<td><b>Patient No</b><input class='patInfo' type='text' id='patno' name='patno' value="<%=patNo%>" maxlength="10"></td>
							<td><b>First Name</b><input class='patInfo' type='text' id='patFname' name='patFname' value="<%=patFname%>" maxlength="40"></td>
							<td><b>Given Name</b><input class='patInfo' type='text' id='patGname' name='patGname' value="<%=patGname%>" maxlength="40"></td>
							<td><b>Chinese Name</b><input class='patInfo' type='text' id='patCname' name='patCname' value="<%=patCname%>" maxlength="20"></td>
						</tr>
						<tr bgcolor='#DDDDD'>
							<td><b>Gender </b><input class='patInfo' type='text' id='patsex' name='patsex' value="<%=patSex%>" maxlength="10"></td>
							<td><b>Birth Date</b><input class='patInfo' type='text' id='patDOB' name='patDOB' value="<%=patDob%>" maxlength="20"></td>
							<td><b>ID No</b><input class='patInfo' type='text' id='patIDNo' name='patIDNo' value="<%=patIDNo%>" maxlength="20"></td>
							<td><b>Religion</b><input class='patInfo' type='text' id='patReli' name='patReli' value="<%=patReli%>" maxlength="20"></td>
						</tr>
					</table>
				</div>
				<div id="categoryForm" style="margin: auto; width: 40%; padding: 20px;">
					<%
						ArrayList result2 = null;
						result2 = AlliedNotesDB.getAlliedType();
						for (int i = 0; i < result2.size(); i++) {
							ReportableListObject reportableListObject = (ReportableListObject) result2.get(i);
					%>
					<input type="button" class="w3-btn w3-padding-small w3-teal category" style="width: 100%; margin-bottom: 20px;"
							value="<%=reportableListObject.getValue(1)%>" id="<%=reportableListObject.getValue(0)%>" 
							onclick="changeCategory('<%=reportableListObject.getValue(0)%>')">
					<%
						}
					%>
				</div>
				<div id="contentForm">
					<%
						if (message == null) {
							message = ConstantsVariable.EMPTY_VALUE;
						}
						if (errorMessage == null) {
							errorMessage = ConstantsVariable.EMPTY_VALUE;
						}
					%>
					<font color="blue" size="10"><%=message%></font> 
					<font color="red" size="10"><%=errorMessage%></font>
					<table width="100%" border="1">
						<th bgcolor='#D8BFD8' class="w3-container ah-pink w3-large">
							<span id="fCategory"></span></th>
					</table>

					<table style="width: 100%;">
						<tr>
							<td width="15%" class="title">Initial Date:</td>
							<td width="20%">
								<%	if (editable) {	%> 
								<input type="textfield" name="caseDate" id="caseDate" class="datepickerfield" 
										value="<%=caseDate == null ? sysDate : caseDate%>" maxlength="10"
										size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
								<%	} else { %> 
								<input type="textfield" name="caseDate" id="caseDate"
										value="<%=caseDate == null ? sysDate : caseDate%>" maxlength="10"
										size="10" readonly /> 
								<%	} %>(DD/MM/YYYY)</td>
							<td width="15%"></td>
							<td width="20%">
								<%	if (editable) {	%> 
								<input type="checkbox" name="ad1" id="ad1"value="Y" <%if ("Y".equals(ad1)) {%> checked <%}%> />
										Patient	consent treatment 
								<%	} else { %> 
								<input type="checkbox" name="ad1" id="ad1" value="Y" <%if ("Y".equals(ad1)) {%> checked <%}%> onclick="return false;" />
										Patient consent treatment 
								<%	} %>
							</td>
							<td width="30%">
								<%	if (editable) {	%> 
								<input type="checkbox" name="ad5" id="ad5" value="Y" <%if ("Y".equals(ad5)) {%> checked <%}%> />
									Parent/Guardian's consent to treatment
								<%	} else { %> 
 								<input type="checkbox" name="ad5" id="ad5" value="Y" <%if ("Y".equals(ad5)) {%> checked <%}%> onclick="return false;" />
 									Parent/Guardian's consent to treatment
								<%	} %>
							</td> 
						</tr>
						<tr>
							<td width="10%" class="title">Diagnosis:</td>
							<td width="90%" colspan="5">
								<%	if (editable) {	%>
								<input type="text" class="textField1" name="diagnosis" id="diagnosis" value="<%=diagnosis == null ? "" : diagnosis%>" maxlength="250" /> 
								<%	} else { %> 
								<input type="text" class="textField1" name="diagnosis" id="diagnosis" value="<%=diagnosis == null ? "" : diagnosis%>" maxlength="250" readonly /> 
								<%	} %>
							</td>
						</tr>
					</table>
					<br>
					<table style="width: 100%">
						<tr>
							<td width="10%" class="title">Past Medical History:</td>
							<td width="90%">
								<%	if (editable) {	%>
								<input type="text" class="textField1" name="pastMedHist" id="pastMedHist" value="<%=pastMedHist == null ? "" : pastMedHist%>" maxlength="800" />
								<%	} else { %> 
								<input type="text" class="textField1" name="pastMedHist" id="pastMedHist" value="<%=pastMedHist == null ? "" : pastMedHist%>" maxlength="800" readonly /> 
								<% 	} %>
							</td>
						</tr>
						<tr>
							<td width="10%" class="title">Social History:</td>
							<td width="90%">
								<%	if (editable) {	%>
								<input type="text" class="textField1" name="socialHistory" id="socialHistory" value="<%=socialHistory == null ? "" : socialHistory%>" maxlength="800" />
								<%	} else { %>
								<input type="text" class="textField1" name="socialHistory" id="socialHistory" value="<%=socialHistory == null ? "" : socialHistory%>" maxlength="800" readonly />
								<% 	} %>
							</td>
						</tr>
						<tr>
							<td width="10%" class="title">Psychological/Emotional:</td>
							<td width="90%">
								<%	if (editable) {	%>
								<input type="text" class="textField1" name="emotional" id="emotional" value="<%=emotional == null ? "" : emotional%>" maxlength="200" /> 
								<% 	} else { %>
								<input type="text" class="textField1" name="emotional" id="emotional" value="<%=emotional == null ? "" : emotional%>" maxlength="200" readonly /> 
								<%	} %>
							</td>
						</tr>
						<tr>
							<td width="10%" class="title">Functional Assessment:</td>
							<td width="90%">
								<%	if (editable) {	%>
								<input type="text" class="textField1" name="funcAssmt" id="funcAssmt" value="<%=funcAssmt == null ? "" : funcAssmt%>" maxlength="250" /> 
								<% 	} else { %>
								<input type="text" class="textField1" name="funcAssmt" id="funcAssmt" value="<%=funcAssmt == null ? "" : funcAssmt%>" maxlength="250" readonly /> 
								<% 	} %>
							</td>
						</tr>
						<tr>
							<td width="10%" class="title">Fall Assessment:</td>
							<td width="90%">
								<%	if (editable) {	%>
								<input type="text" class="textField1" name="fallAssmt" id="fallAssmt" value="<%=fallAssmt == null ? "" : fallAssmt%>" maxlength="200" /> 
								<% 	} else { %>
								<input type="text" class="textField1" name="fallAssmt" id="fallAssmt" value="<%=fallAssmt == null ? "" : fallAssmt%>" maxlength="200" readonly /> 
								<% 	} %>
							</td>
						</tr>
						<tr>
							<td width="10%" class="title">Patient Goal:</td>
							<td width="90%">
								<%	if (editable) {	%>
								<input type="text" class="textField1" name="patientGoal" id="patientGoal" value="<%=patientGoal == null ? "" : patientGoal%>" maxlength="250" />
								<%	} else { %> 
								<input type="text" class="textField1" name="patientGoal" id="patientGoal" value="<%=patientGoal == null ? "" : patientGoal%>" maxlength="250" readonly /> 
								<% 	} %>
							</td>
						</tr>
					</table>
					<br>
					<table style="width: 100%">
						<tr>
							<td class="title" colspan="2">History of Present Condition:</td>
						</tr>
						<tr>
							<td colspan="2">
								<%	if (editable) {	%>
								<textarea name="hpi" id="hpi" rows="5" cols="20" maxlength="1000"><%=hpi == null ? "" : hpi%></textarea> 
								<% 	} else { %>
								<textarea name="hpi" id="hpi" rows="5" cols="20"onkeypress="return false;"><%=hpi == null ? "" : hpi%></textarea> 
								<% 	} %>
							</td>
						</tr>
						<tr>
							<td height="20" colspan="2"></td>
						</tr>
						<tr>
							<td class="title" colspan="2">Assessment:</td>
						</tr>
						<tr>
							<td class="title">Subjective Examination</td>
						</tr>
						<tr>
							<td width="97%">
								<%	if (editable) {	%>
								<textarea name="subjective" id="subjective" rows="5" cols="20" maxlength="2000"><%=subjective == null ? "" : subjective%></textarea>
								<%	} else { %> 
								<textarea name="subjective" id="subjective" rows="5" cols="20" onkeypress="return false;"><%=subjective == null ? "" : subjective%></textarea>
								<%	} %> 
							</td>
						</tr>
						<tr>
							<td class="title">Objective Examination</td>
						</tr>
						<tr>
							<td>
								<%	if (editable) {	%>
								<textarea name="objective" id="objective" rows="5" cols="20" maxlength="2000"><%=objective == null ? "" : objective%></textarea>
								<%	} else { %> 
								<textarea name="objective" id="objective" rows="5" cols="20" onkeypress="return false;"><%=objective == null ? "" : objective%></textarea>
								<%	} %> 
							</td>
						</tr>
						<tr>
							<td height="20" colspan="2"></td>
						</tr>
						<tr>
							<td class="title" colspan="2">Treatment Goals:(Functionaland Measureable)</td>
						</tr>
						<tr>
							<td colspan="2">
								<%	if (editable) {	%>
								<textarea name="treatmentGoal" id="treatmentGoal" rows="5" cols="20" maxlength="800"><%=treatmentGoal == null ? "" : treatmentGoal%></textarea>
								<%	} else { %> 
								<textarea name="treatmentGoal" id="treatmentGoal" rows="5" cols="20" onkeypress="return false;"><%=treatmentGoal == null ? "" : treatmentGoal%></textarea>
								<%	} %> 
							</td>
						</tr>
					</table>
					<br>
					<table style="width: 100%">
						<tr>
							<td class="title" colspan="2">Treatment:</td>
						</tr>
						<tr>
							<td colspan="2">
								<%	if (editable) {	%>
								<textarea name="treatment" id="treatment" rows="5" cols="20" maxlength="2000"><%=treatment == null ? "" : treatment%></textarea>
								<%	} else { %> 
								<textarea name="treatment" id="treatment" rows="5" cols="20" onkeypress="return false;"><%=treatment == null ? "" : treatment%></textarea>
								<%	} %> 
							</td>
						</tr>
					</table>
					<br>
					<table style="width: 100%">
						<tr>
							<td class="title"><%=histProgNotes == null ? "" : "Historical Progress Notes"%></td>
						</tr>
						<tr>
							<td><%=histProgNotes == null ? "" : histProgNotes%></td>
						</tr>
					</table>
					<br>
					<table style="width: 100%">
						<tr>
							<td class="title">Progress Notes</td>
						</tr>
						<tr>
							<td><textarea rows="4" name="progNotes" id="progNotes" rows="5" cols="20" maxlength="2000"></textarea></td>
						</tr>
					</table>
					<table style="width: 80%">
						<tr>
							<td class="title">Assessed By: <%=username == null ? "" : username%></td>
						</tr>
					</table>
					<br />
					<div class="formLabel">
						<div id="nameLabel">
							<table width="100%">
								<tr class="title">
									<td width="20%">Patient No.:</td>
									<td width="80%">
										<input class="patInfo noBorderText" type="text" id="patno" name="patno" value="<%=patNo == null ? "" : patNo%>" maxlength="80" style="width: 90%;" />
									</td>
								</tr>
								<tr class="title">
									<td width="20%">Name:</td>
									<td width="80%">
										<input class="patInfo noBorderText" type="text" id="patName" name="patName" value="<%=patName == null ? "" : patName%>" maxlength="80" style="width: 90%;" />
									</td>
								</tr>
								<tr class="title">
									<td width="20%">Date of Birth:</td>
									<td width="80%">
										<input class="patInfo noBorderText" type="text" id="patDob" name="patDob" value="<%=patDob == null ? "" : patDob%>" maxlength="80" style="width: 90%;" />
									</td>
								</tr>
								<tr class="title">
									<td width="20%">Gender:</td>
									<td width="80%">
										<input class="patInfo noBorderText" type="text" id="gender" name="gender" value="<%=patSex == null ? "" : patSex%>" maxlength="80" style="width: 90%;" />
									</td>
								</tr>
							</table>
						</div>
						<div id="barcodeLabel">
							<table>
								<tr>
									<td colspan="2" height="30" style="font-size: 110%; vertical-align: middle;" class="title">
										<b>Allied Health Assessment and Progress Notes</b>
									</td>
								</tr>
								<tr>
									<td style="border: 1px solid black;">Aug 2020</td>
									<td style="border: 1px solid black;" class="title">RHAB-MOF48</td>
								</tr>
								<tr>
									<td colspan="2"><img src="../images/barcode.png">
									</td>
								</tr>
							</table>
						</div>
					</div>
					<br />
					<br />
				</div>
				<input type="hidden" id="caseNo" name="caseno" value="<%=caseNo%>" />
				<input type="hidden" id="regid" name="regid" value="<%=regid%>" />
				<input type="hidden" id="userid" name="userid" value="<%=userid%>" />
				<input type="hidden" name="mode" id="mode" /> 
				<input type="hidden" name="action" id="action" /> 
				<input type="hidden" name="caseType" id="caseType" value="<%=caseType%>" /> 
				<input type="hidden" name="formContent" id="formContent" /> 
				<input type="hidden" name="updateDate" id="updateDate" value="" /> 
				<input type="hidden" name="username" id="username" value="<%=username%>" /> 
				<input type="hidden" name="histProgNotes" id="histProgNotes" value="<%=histProgNotes%>" /> 
				<input type="hidden" name="currAssessDate" id="currAssessDate" value="<%=currAssessDate%>" />
			</div>
		</div>
	</form>
	<div class="w3-container w3-round-large" id="SavePopup">
		Save Completed.<br /> [Case No: <span id="saveID"></span>]
	</div>

	<footer>
		<span style="float: right;"> 
		<input type="button" value="New Record" id="newrecord" onclick="return createNewAction()" />
		<%	if ("create".equals(mode)) { %> 
			<input type="button" value="Save" id="save" onclick="return submitAction('create');" /> 
			<input type="button" value="Save & Print" id="printSave" onclick="return submitAction('printSave');" /> 
		<% 	} else if ("update".equals(mode)) { %>
			<input type="button" value="Update" id="update" onclick="return submitAction('update');" /> 
			<input type="button" value="Update & Print" id="printSave" onclick="return submitAction('printSave');" /> 
		<% 	} %> 
		<input type="button" value="Print" id="print" onclick="return submitAction('print');" /> 
		<input type="button" value="Close" id="close" onclick="document.title='[close]';close()" />
		</span>
	</footer>

</body>

<script>
	$(document).ready(function() {
		<%if (patNo != null) {%>
			lockPatInfo();
		<%}%>
		<%if ("view".equals(mode) || "edit".equals(mode) || "viewFromID".equals(mode)) {%>
			displayView();
		<%}%>
		<%if (saveComplete) {%>
			var caseNo = "<%=caseNo%>";
			$("#saveID").text(caseNo);
			$("#SavePopup").show();
			window.setTimeout("hideSave()", '1500');
		<%}%>
		<%if (showCategories) {%>
			$('#categoryForm').show();
			$('#contentForm').hide();
			$("footer").hide();
		<%} else {%>
			$('#categoryForm').hide();
			$('#contentForm').show();
			$("footer").show();
			
			$('#fCategory').html('Category: <%=category%>');			
/*			
			$('#fCategory').html('Category: <%="D".equals(caseType) ? "Dietetics" : 
						"H".equals(caseType) ? "Health Education" : 
						"M".equals(caseType) ? "Music Therapy" : 
						"O".equals(caseType) ? "Occupational Therapy" : 
						"R".equals(caseType) ? "Orthotics" : 
						"P".equals(caseType) ? "Podiatry" : 
						"S".equals(caseType) ? "Speech Therapy" : 
						"T".equals(caseType) ? "Therapeutic Counselling": ""%>');
*/						
			$('#caseType').val("<%=caseType%>");
		<%}%>
		$('input').filter('.datepickerfield').datepicker({
			beforeShow: function (textbox, instance) {
		        var txtBoxOffset = $(this).offset();
		        var top = txtBoxOffset.top;
		        var left = txtBoxOffset.left;
		        var textBoxHeight = $(this).outerHeight();
		        setTimeout(function () {
		            instance.dpDiv.css({
		               top: top-$("#ui-datepicker-div").outerHeight()-50,
		               left: left+$("#date_from").width()+25
		            });
		        }, 0);
		    },
			showOn: 'button', 
			buttonImageOnly: true, 
			buttonImage: "../images/calendar.jpg"
			});
	});
	
	function hideSave(){
		$('#SavePopup').hide();
	}
	function changeCategory(type){
		window.location.href = "/intranet/cms/alliedNotes.jsp?patno=" + $("#patno").val() + "&userid=" + $("#userid").val() + "&caseType="+ type ;
	}
	
	function createNewAction(){
		window.location.href = "/intranet/cms/alliedNotes.jsp?patno=" + $("#patno").val() + "&userid=" + $("#userid").val() + "&caseType="+ $("#caseType").val() +"&forceNew=Y";
	}

	function submitAction(cmd) {
		var hpiMaxSize = 1000;
		var subjectiveMaxSize = 2000;
		var objectiveMaxSize = 2000;
		var treatmentGoalMaxSize = 800;		
		var treatmentMaxSize = 2000;
		var exerciseMaxSize = 500;
		var progNotesMaxSize = 2000;
		var isInitial = false;
		var textValue = null;		


			if(isInitial){
	
				textValue = document.getElementById('hpi').value;

				if (textValue.length > hpiMaxSize) {
					document.form1.hpi.focus();			
					alert('Length of HPI should be < '+hpiMaxSize+', now '+textValue.length+'!');
					textValue = 0;
					return false;	
				}
				
				textValue = document.getElementById('subjective').value;

				if (textValue.length > subjectiveMaxSize) {
					document.form1.painDesc.focus();			
					alert('Length of Subjective should be < '+subjectiveMaxSize+', now '+textValue.length+'!');
					textValue = 0;
					return false;	
				}
				
				textValue = document.getElementById('objective').value;

				if (textValue.length > objectiveMaxSize) {
					document.form1.objective.focus();			
					alert('Length of Objective should be < '+objectiveMaxSize+', now '+textValue.length+'!');
					textValue = 0;
					return false;	
				}
				
				textValue = document.getElementById('treatmentGoal').value;

				if (textValue.length > treatmentGoalMaxSize) {
					document.form1.treatmentGoal.focus();			
					alert('Length of Treatment Goal should be < '+treatmentGoalMaxSize+', now '+textValue.length+'!');
					textValue = 0;
					return false;	
				}
				
				textValue = document.getElementById('treatment').value;

				if (textValue.length > treatmentMaxSize) {
					document.form1.treatment.focus();			
					alert('Length of Treatment should be < '+treatmentMaxSize+', now '+textValue.length+'!');
					textValue = 0;
					return false;	
				}
				
				textValue = document.getElementById('progNotes').value;
				
				if (textValue.length == 0) {
					document.form1.progNotes.focus();			
					alert('Please input Progress Note!');
					textValue = null;
					return false;	
				}			

				if (textValue.length > progNotesMaxSize) {
					document.form1.progNotes.focus();			
					alert('Length of Progress Note should be < '+progNotesMaxSize+', now '+textValue.length+'!');
					textValue = 0;
					return false;	
				}
			}else if (cmd!= "print"){
				
				textValue = document.getElementById('progNotes').value;
				
				if (textValue.length == 0) {
					document.form1.progNotes.focus();			
					alert('Please input Progress Note!');
					textValue = null;
					return false;	
				}			

				if (textValue.length > progNotesMaxSize) {
					document.form1.progNotes.focus();			
					alert('Length of Progress Note should be < '+progNotesMaxSize+', now '+textValue.length+'!');
					textValue = 0;
					return false;	
				}
			}	
			<%if ("create".equals(mode)) {%>
				document.form1.mode.value = "create";	
			<%} else if ("update".equals(mode)) {%>
				document.form1.mode.value = "update";
			<%} else {%>
				document.form1.mode.value = cmd;
			<%}%>
		document.form1.action.value = cmd;
		document.form1.submit(); 		

		return false;
	}
	
	function clearTextField(){
		var frm_elements = document.form1.elements;

		for (i = 0; i < frm_elements.length; i++)
		{
		    field_type = frm_elements[i].type.toLowerCase();
		    switch (field_type)
		    {
		    case "text":
		        frm_elements[i].value = "";
		        break;
/*		        
		    case "password":
		    case "textarea":
		    case "hidden":
		        frm_elements[i].value = "";
		        break;
		    case "radio":
		    case "checkbox":
		        if (frm_elements[i].checked)
		        {
		            frm_elements[i].checked = false;
		        }
		        break;
		    case "select-one":
		    case "select-multi":
		        frm_elements[i].selectedIndex = -1;
		        break;
*/		        
		    default:
		        break;
		    }
		}

	}
	
	/*
	function numCheck2(self) {
		if (isNaN(self.value)) {
			alert("It is not a number!");
			self.value = "";
			self.focus();
		}
	}*/
</script>
</html>