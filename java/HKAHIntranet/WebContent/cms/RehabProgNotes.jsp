<%@ page import="java.io.*"%>
<%@ page language="java" import="org.json.JSONObject" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.Date" %>
<%@ page import="javax.sql.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.naming.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="com.hkah.servlet.*" %>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="net.sf.jasperreports.engine.JasperPrint" %>

<%
//get information for CIS
String mode = ParserUtil.getParameter(request, "mode"); //new, edit, view, viewFromID
String action = ParserUtil.getParameter(request, "action"); //update, check
String userid = ParserUtil.getParameter(request, "userid");
String patNo = ParserUtil.getParameter(request, "patNo");
String regid = ParserUtil.getParameter(request, "regid");//if no reg, default = 0
String formuid = ParserUtil.getParameter(request, "formuid");
String command = ParserUtil.getParameter(request, "command");//if no reg, default = 0
System.err.println("1[patNo]:"+patNo+";");

//define parameter
String formDate = null;
String patName = null;
String patAge = null;
String patSex = null;
String patDob = null;
String docName = null;
String notes = null;
String message = null;
String errorMessage = null;

String formType = "";
ArrayList result = null;
ArrayList record = null;
ReportableListObject row = null;

Calendar cal = Calendar.getInstance();
SimpleDateFormat dateFmt = new SimpleDateFormat("dd/MM/yyyy");
String sysDate = dateFmt.format(cal.getTime());

boolean createAction = false;
boolean updateAction = false;
boolean viewAction = false;
boolean printAction = false;
boolean cancelAction = false;
boolean closeAction = false;

String host = request.getRemoteAddr();
System.err.println("1[command]:"+command+";[formuid]:"+formuid+";[userid]:"+userid);
if("view".equals(command)){
	viewAction = true;
}else if ("save".equals(command) || "saveprint".equals(command)) {
	if(formuid != null && formuid.length() > 0){
		System.err.println("2[command]:"+command);
		updateAction = true;
	}else{
		System.err.println("3[command]:"+command);
		createAction = true;
	}
}else if ("print".equals(command)) {
	printAction = true;
}

//get information after enter
if ((action == null || action.isEmpty()) && "view".equals(mode)){
	action = "check";
}

String formContent = ParserUtil.getParameter(request, "formContent");
String imgPath = ParserUtil.getParameter(request, "imgPath");
String updateDate = ParserUtil.getParameter(request, "updateDate");

String url = null;
String logo = null;
if (ConstantsServerSide.isTWAH()) {
	url = "http://www.twah.org.hk";
	logo = "Horizontal_billingual_HKAH_TW.jpg";
} else {
	url = "http://www.hkah.org.hk";
	logo = "Horizontal_billingual_HKAH_HK.jpg";
}

if(createAction){
	formuid = null;
	//insert form to db
	formuid = BreastHealthDB.createRehabProgNotes("O", regid, patNo, userid, formContent);
	viewAction = true;

	if("saveprint".equals(command)){
		System.err.println("4[command]:"+command);
		printAction = true;
	}

	if(formuid!=null){
		errorMessage = "Save Success";
	}else{
		errorMessage = "Save Fail";
	}
}else if(updateAction){
	record = BreastHealthDB.getFormIDByRegID(regid, patNo,"Rehabilitation Progress Notes (web)");
	if(record.size()>0){
		row = (ReportableListObject) record.get(0);
		formuid = row.getValue(0);
	}else{
		formuid = null;
	}
	formuid = BreastHealthDB.updateRehabProgNotes(formuid, "O", regid, patNo, userid, formContent);
	viewAction = true;

	if("saveprint".equals(command)){
		System.err.println("5[command]:"+command);
		printAction = true;
	}
	if(formuid!=null){
		errorMessage = "Save Success";
	}else{
		errorMessage = "Save Fail";
	}
}

if(viewAction){
	record = BreastHealthDB.getFormIDByRegID(regid, patNo, "Rehabilitation Progress Notes (web)");
	if(record.size()>0){
		row = (ReportableListObject) record.get(0);
		formuid = row.getValue(0);
	}else{
		formuid = null;
	}
	//get form info
	if (!(formuid == null || formuid.isEmpty() || "null".equals(formuid))){
		result = BreastHealthDB.getFormInfo(formuid);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			formDate = 	reportableListObject.getValue(1);
			formType = reportableListObject.getValue(2);
			regid = reportableListObject.getValue(3);
			patNo = reportableListObject.getValue(4);
			userid = reportableListObject.getValue(5);
			formContent = reportableListObject.getValue(6);
			updateDate = reportableListObject.getValue(7);
		}
	}
	System.err.println("[updateDate]:"+updateDate+";");
	if (formContent != null && formContent.length()>0){
		System.err.println("2[JSONObject]:"+formContent+";");
		JSONObject content = new JSONObject(formContent);
		notes = content.getString("notes");
	}

	//get patNo using regid
	if (patNo == null || patNo.isEmpty()){
		result = BreastHealthDB.getPatID(regid);
		if (result.size() > 0) {
			ReportableListObject reportableListObject1 = (ReportableListObject) result.get(0);
			patNo = reportableListObject1.getValue(1);
		}
	}
	System.err.println("2[patNo]:"+patNo+";");
	//get pat info
	result = PatientDB.getPatInfo(patNo);
	if (result.size() > 0) {
		ReportableListObject reportableListObject2 = (ReportableListObject) result.get(0);
		patName = reportableListObject2.getValue(3);
		patSex = reportableListObject2.getValue(1);
		patDob = reportableListObject2.getValue(10);
	}

	//get doc info
	result = BreastHealthDB.getDocInfo(userid);
	if (result.size() > 0) {
		ReportableListObject reportableListObject3 = (ReportableListObject) result.get(0);
		docName = reportableListObject3.getValue(1);
	}
}
System.err.println("[printAction]:"+printAction+"[docName]:"+docName);
if(printAction){
	File reportFile = new File(application.getRealPath("/report/rehabProgNotes.jasper"));
	File reportDir = new File(application.getRealPath("/report/"));
	if (reportFile.exists()) {
		System.err.println("2[printAction]:"+printAction);
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("Site", ConstantsServerSide.SITE_CODE);
		parameters.put("formDate", formDate);
		parameters.put("docName", docName);
		parameters.put("patNo", patNo);
		parameters.put("patName", patName);
		parameters.put("patDob", patDob);
		parameters.put("patSex", patSex);
		parameters.put("notes", notes);
		parameters.put("updateDate", updateDate);
/*
		ArrayList result1 = null;
		String path = "";
		result1 = BreastHealthDB.getFormPath();
		if (result1.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result1.get(0);
			path = reportableListObject.getValue(0);
		}

		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport, parameters, new JREmptyDataSource(1));

		String encodedFileName = "rehabProgNotes" + "_" + formuid + ".pdf";
		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		File outputFile = new File(path + encodedFileName);
		JRPdfExporter exporter = new JRPdfExporter();
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);

		exporter.setParameter(JRExporterParameter.OUTPUT_FILE, outputFile);
		exporter.setParameter(JRPdfExporterParameter.PDF_VERSION, JRPdfExporterParameter.PDF_VERSION_1_2);
		exporter.exportReport();
*/


		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport, parameters, new JREmptyDataSource(1));

		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		JRPdfExporter exporter = new JRPdfExporter();
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		exporter.exportReport();

		return;
	}
}
%>
<!DOCTYPE html>
<html>
<head>
	<title>Breast Health Centre Progress Sheet</title>
	<meta http-equiv="X-UA-Compatible" content="chrome=1, IE=edge">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">
	<meta http-equiv="Expires" content="0">
	<style>
	body{

	}
	#page{
		background: white;
	    height:450mm;
	    width:250mm;
	}
	#inputForm{
	    overflow: auto;
	    border: 1px solid;
	    border-color: #0000ff;
	    margin-bottom:10mm;
		margin-top: 5mm;
		margin-left: 0px;
		margin-right: 0px;
	    padding:5mm;
	}
	input[type=text] {
		border: none;
		border-bottom: 0.5px solid;
	}
	input[type=button]{
		margin-left: 20px;
	    margin-right: 20px;
	}
	table{
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
	textarea{
		width:90%;
	}
	.formLabel{
		overflow: hidden;
	    width: 100%;
		border: 1px solid black;
		margin-bottom: 30px;
	}
	.underLineText{
		border: none;
		border-bottom: 0.5px solid;
	}
	#nameLabel{
		float: left;
		width: 50%;
		margin-right: -1px;
		padding-bottom: 500em;
		margin-bottom: -500em;
	}
	#barcodeLabel{
		float: left;
		width: 50%;
		margin-right: -1px;
		border-left: 1px solid black;
		padding-bottom: 500em;
		margin-bottom: -500em;
	}
	#barcodeLabel table{
		width:100%;
		text-align:center;
		border-collapse: collapse;
	}
	span{
		margin-top: 5px;
	}
	footer {
		z-index: 1;
	    position: fixed;
	    bottom: 0;
	    left: 0;
	    right: 0;
	    height: 30px;
	    background-color: gainsboro;
	}
	</style>
	<script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
</head>
<body >
	<form name="rehabProgNotes" id="rehabProgNotes" action="RehabProgNotes.jsp" method="post">
			<div class="title" style="text-align:right; float: right;">Treatment and Progress Notes<br></div>
			<div>
				<img width="390px" src="../images/<%=logo%>">
			</div>
			<table style="width: 80%">
				<tr>
					<td class="title" width="15%">Date of First Consulation:</td>
					<td width="85%"><input type="text" name="formDate" id=formDate value="<%=formDate==null?sysDate:formDate %>" /></td>
				</tr>
			</table>
				<%
				  if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
				  if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
				%>
			<font color="blue" size="10"><%=message %></font>
			<font color="red" size="10"><%=errorMessage %></font>
			<table style="width: 80%">
				<tr>
					<td class="title"></td>
				</tr>
				<tr>
					<td><textarea rows="4" name="notes" id="notes"><%=notes==null?"":notes %></textarea></td>
				</tr>
			</table>
			<table style="width: 80%; margin-top:50px;">
				<tr class="title">
				<%System.err.println("1111[updateDate]:"+updateDate); %>
					<td style="width:65%; border-bottom:1px solid;" >Doctor's signature: <span style="float:right;">(<input type="text" id="docName" name="docName" value="<%=docName==null?"":docName %>" />)</span></td>
					<td style="text-align:right;">Date: <input type="text" name="updateDate" id=updateDate value="<%=updateDate==null?sysDate:updateDate %>" /></td>
				<tr>
			</table>
			<div class="formLabel">
				<div id="nameLabel">
					<table>
						<tr class="title">
							<td>Patient No.:</td>
							<td>
								<input type="text" id="patNo" name="patNo" value="<%=patNo==null?"":patNo %>"  />
								<input type="hidden" id="regid" name="regid" value="<%=regid==null?"":regid %>" />
							</td>
						</tr>
						<tr class="title">
							<td>Name: </td>
							<td><input type="text" id="patName" name="patName" value="<%=patName==null?"":patName %>" /></td>
						</tr>
						<tr class="title">
							<td>Date of Birth: </td>
							<td><input type="text" id="patDob" name="patDob" value="<%=patDob==null?"":patDob %>" /></td>
						</tr>
						<tr class="title">
							<td>Gender: </td>
							<td><input type="text" id="gender" name="gender" value="<%=patSex==null?"":patSex %>" /></td>
						</tr>
					</table>
				</div>
				<div id="barcodeLabel">
					<table>
						<tr>
							<td colspan="2" height="30" style="font-size:110%; vertical-align: middle;" class="title"><b>REHBILITATION PROGRESS NOTES</b></td>
						</tr>
						<tr>
							<td style="border: 1px solid black;">Version: DEC 15</td>
							<td style="border: 1px solid black;" class="title">RHAB-MOF13</td>
						</tr>
						<tr>
							<td colspan="2"><img src="../images/barcode.png"></td>
						</tr>
					</table>
				</div>
			</div>
			<%System.err.println("[userid]:"+userid); %>
			<input type="hidden" id="userid" name="userid" value="<%=userid==null?"":userid %>" />
			<input type="hidden" id="formuid" name="formuid" value="<%=formuid==null?"":formuid %>" />
			<input type="hidden" name="mode" id="mode" />
			<input type="hidden" name="action" id="action" />
			<input type="hidden" name="formContent" id="formContent" />
			<input type="hidden" name="formType" id="formType" value="<%=formType==null?"":formType %>" />
			<input type="hidden" name="command" id="command" />
			<input type="hidden" name="formContent" id="formContent" />
	</form>

		<span style="float: right;">
			<input type="button" value="Update" id="update" onclick="return submitAction('save');" />
			<input type="button" value="Update & Print" id="printUpdate" onclick="return submitAction('saveprint');" />
			<input type="button" value="Close" id="close" onclick="closeWindow()" />
		</span>
</body>

<script>
/*
	$(document).ready(function() {
		getCurrentDate();
	});
*/
	function saveContent(){
		var content = {};
		var formContent = "";
		var notes = $("#notes").val();

		content = {
			"notes" : notes
		};

		formContent = JSON.stringify(content);
		$("#formContent").val(formContent);
	}

	function getCurrentDate(){
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth()+1; //January is 0!
		var yyyy = today.getFullYear();
		if(dd<10) {
		    dd = '0'+dd;
		}
		if(mm<10) {
		    mm = '0'+mm;
		}
		today = dd + '/' + mm + '/' + yyyy;
		var showFormDate = "<%=formDate%>";
		showFormDate = showFormDate.substr(0,10);
		$("#formDate").val(showFormDate);
		$("#updateDate").val(today);
	};

	function submitAction(cmd) {
		document.rehabProgNotes.command.value = cmd;
		saveContent();
		document.rehabProgNotes.submit();
	}

	function closeWindow(){
	    document.title="close";
	}
</script>
</html>