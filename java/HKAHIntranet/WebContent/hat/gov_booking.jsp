<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%!
private static String add(String bkgid, String govPosition, String sex, String catBbookingDate){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("INSERT INTO GOVREG@IWEB ");
	sqlStr.append("(BKGID, GOVJOBCODE, GOVSEX");
	if(catBbookingDate != null && catBbookingDate.length() > 0){
		sqlStr.append(", TESTDATE");
	}
	sqlStr.append(") ");
	sqlStr.append(" VALUES ");
	sqlStr.append("('" + bkgid + "', '" + govPosition + "', '" + sex + "'");
	if(catBbookingDate != null && catBbookingDate.length() > 0){
		sqlStr.append(", TO_DATE('" + catBbookingDate + "','DD/MM/YYYY HH24:MI') ");
	}
	sqlStr.append(")");
	
	//System.out.println(sqlStr.toString());
	
	if (UtilDBWeb.updateQueue(sqlStr.toString() )) {	
		return bkgid;
	} else {
		return "";
	}
}
private static boolean update(String bkgid, String govPosition, String sex, String catBbookingDate, boolean catBPosition){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("UPDATE GOVREG@IWEB ");
	sqlStr.append("SET GOVJOBCODE = '" + govPosition + "', ");
	sqlStr.append("GOVSEX = '" + sex + "' ");
	if(catBPosition){
		sqlStr.append(", TESTDATE = TO_DATE( '" + catBbookingDate + "' ,'DD/MM/YYYY HH24:MI') ");
	}else{
		sqlStr.append(", TESTDATE = null ");
	}
	sqlStr.append("WHERE BKGID = '" + bkgid + "' ");

	if (UtilDBWeb.updateQueue(sqlStr.toString() )) {	
		return true;
	} else {
		return false;
	}
}
private static ArrayList getBookingInfo(String bkgid) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT 	BKGID, INITCAP(BKGPNAME), TO_CHAR(BKGSDATE,'DD/MM/YYYY HH24:MI'), D.DOCCODE, INITCAP('DR. ' || D.DOCFNAME ||', '|| D.DOCGNAME), BKGPCNAME "); 
	sqlStr.append("FROM		BOOKING@IWEB B, DOCTOR@IWEB D, SCHEDULE@IWEB S, SLOT@IWEB T ");
	sqlStr.append("WHERE 	D.DOCCODE = S.DOCCODE ");
	sqlStr.append("AND 		S.SCHID = T.SCHID ");
	sqlStr.append("AND 		T.SLTID = B.SLTID ");
	sqlStr.append("AND 		BKGID = '" + bkgid + "' ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}
private static ArrayList getDept() {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT	ARCCODE, INITCAP(ARCNAME) "); 
	sqlStr.append("FROM		ARCODE@IWEB ");
	sqlStr.append("WHERE   	ARCCODE LIKE 'G%' ");
	sqlStr.append("ORDER BY ARCNAME ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private static ArrayList getPosition(String govPosition) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT	GOVJOBCODE, INITCAP(GOVPOSITION), ARCCODE "); 
	sqlStr.append("FROM		GOVJOB@IWEB ");
	sqlStr.append("WHERE   	GOVJOBCODE = '" + govPosition + "' ");
	sqlStr.append("ORDER BY GOVPOSITION ");

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private static ArrayList getGovReg(String bkgid){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT	BKGID, GOVJOBCODE, GOVSEX, TO_CHAR(TESTDATE,'DD/MM/YYYY HH24:MI') "); 
	sqlStr.append("FROM		GOVREG@IWEB ");
	sqlStr.append("WHERE   	BKGID = '" + bkgid + "' ");
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}


%>

<% 
String command = request.getParameter("command");
String step = request.getParameter("step");
String bkgid = request.getParameter("bkgid");
ArrayList record = new ArrayList();

boolean govbkgExist = false;
boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

//check bkgid exist or not
record = getGovReg(bkgid);

if(command == null){
	if(record.size() > 0){
		govbkgExist = true;
	}else{
		createAction = true;
	}
}else if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	if(record.size() > 0){
		updateAction = true;
		govbkgExist = true;
	}else{
		command = "create";
		createAction = true;
	}
} else if ("delete".equals(command)) {
	deleteAction = true;
}

String msg = "";

String name = "";
String cname = "";
String bookingDate = "";

String doccode = "";
String docName = "";

String govDept = request.getParameter("govDept");
String govPosition = request.getParameter("govPosition");
String govPositionName = "";
String sex = request.getParameter("sex");
String catBbooking = request.getParameter("catBbooking");
Boolean catBposition = "true".equals(request.getParameter("catBposition"));
String bDate = "";
String bTime = "";

ArrayList deptlistCode = new ArrayList();
ArrayList deptlistName = new ArrayList();
ArrayList positionListCode = new ArrayList();
ArrayList positionListName = new ArrayList();



if("1".equals(step)){
	if(createAction){
		// insert new govreg
		String success = add(bkgid, govPosition, sex, catBbooking);
		if (bkgid.equals(success)){
			createAction = false;
			step = null;
			govbkgExist = true;
		}else{
			msg = "Error. Please try again.";
		}
	}else if (updateAction){
		// update govreg
		boolean success = update(bkgid, govPosition, sex, catBbooking, catBposition);
		if(success){
			updateAction = false;
			step = null;
			govbkgExist = true;
		}else{
			msg = "Error. Please try again.";
		}
	}else if (deleteAction){
		// del record
		step = null;
		closeAction = true;
	}
}

record = getBookingInfo(bkgid);
if(record.size() > 0){
	ReportableListObject row = (ReportableListObject) record.get(0);
	name = row.getValue(1);
	cname = row.getValue(5);
	bookingDate = row.getValue(2);
	doccode = row.getValue(3);
	docName = row.getValue(4);
	catBbooking = "";
}



if(govbkgExist){
	record = getGovReg(bkgid);
	if(record.size() > 0){
		ReportableListObject row = (ReportableListObject) record.get(0);
		govPosition = row.getValue(1);
		sex = row.getValue(2);
		catBbooking = row.getValue(3);
		if(catBbooking.length() > 0){
			catBposition = true;
			bDate = catBbooking.substring(0, 10);
			bTime = catBbooking.substring(11, 16);
		}
	}
	//get deptCode
	record = getPosition(govPosition);
	if(record.size() > 0){
		for(int i=0; i<record.size(); i++){
			ReportableListObject row = (ReportableListObject) record.get(i);
			govPositionName = row.getValue(1);
			govDept = row.getValue(2);
		}
	}
}else{
		
}
record = getDept();
if(record.size() > 0){
	for(int i=0; i<record.size(); i++){
		ReportableListObject row = (ReportableListObject) record.get(i);
		deptlistCode.add(row.getValue(0));
		deptlistName.add(row.getValue(1));	
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<style>
body{
	font-size:14px;
}
table{
	width:100%;
	border: 1px;
	border-style: solid;
}
th{
	font-size:13px;
	border: 1px;
	border-style: solid;
}
td{
	height: 18px;
	border: 0px;
	border-style: solid;
}
#title{
	font-size: 24px; 
	text-align: center;
}
.infoSelect{
	width:400px;
}
#catB{
	color: red;
}
.button{
    margin: 0 7px 0 0;
    border: 1px solid #dedede;
    border-top: 1px solid #eee;
    border-left: 1px solid #eee;
    font: 12px Arial, Helvetica, sans-serif;
    font-size: 100%;
    line-height: 100%;
    text-decoration: none;
    color: #565656;
    cursor: pointer;
    padding: 5px 10px 6px 7px;
}
</style>
<body>
<div id="title">
	Government Pre-employment Physical Checkup<br/>Order Form
</div>
<br/>
<font color="red"><%=msg %></font>
<form name="govBookingForm" id="govBookingForm" action="gov_booking.jsp" method="post">
	<table>
		<tr>
			<td width="30%">Candidate Name:</td>
			<td width="70%"><%=name %> <%=cname %></td>
		</tr>
		<tr>
			<td width="30%">Gender:</td>
			<td width="70%">
<%	if (createAction || updateAction) { %>
				<input type="radio" name="sex" value="F" <%="F".equals(sex)?"checked":"" %> />F 
				<input type="radio" name="sex" value="M" <%="M".equals(sex)?"checked":"" %>/>M 
<% } else { %>
		<%=sex %>
<% } %>
			</td>
		</tr>
		<tr>
			<td width="30%">Department:</td>
			<td width="70%">
<%	if (createAction || updateAction) { %>			
				<select id="govDept" class="infoSelect" name="govDept" onclick="getPosition()">
					<option></option>
<% if(deptlistCode.size() > 0){ %>
	<% for(int i=0; i<deptlistCode.size(); i++){ %>
				<option value="<%=deptlistCode.get(i) %>" <%=deptlistCode.get(i).equals(govDept)?"selected":"" %>><%=deptlistName.get(i) %></option>
	<% } %>
<% } %>
				</select>
<% } else { %>
				<%int index = deptlistCode.indexOf( govDept ); %>
				<%if (index == -1){}else{ %>
					<%=deptlistName.get(index) %>
				<%} %>
<% } %>				
			</td>
		</tr>
		<tr>
			<td width="30%">Position:</td>
			<td width="70%">
<%	if (createAction || updateAction) { %>			
				<select id="govPosition" class="infoSelect" name="govPosition">
<jsp:include page="gov_position_ajax.jsp" flush="false">
	<jsp:param name="govPosition" value="<%=govPosition %>" />
	<jsp:param name="govDept" value="<%=govDept %>" />
</jsp:include>
				</select>
<% } else { %>
				<%=govPositionName %>
<% } %>				
			</td>
		</tr>
		<tr>
			<td colspan="2" style="text-align:center">
<%	if (createAction || updateAction) { %>
				<input type="button" class="button" onclick="getItemTest('get')" id="fetchItem" value="Fetch Test Item"/>
<% } else { %>
				
<% } %>
			</td>
		</tr>
		<tr>
			<td width="30%">Consultation Date:</td>
			<td width="70%"><%=bookingDate %></td>
		</tr>
		<tr id="catB">
			<td width="30%">Cat B Consultation Date:</td>
			<td width="70%">
<%	if (createAction || updateAction) { 
		Calendar currentDate = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>	

				<input type="textfield" name=catBbookingDate id="catBbookingDate" class="datepickerfield" value="<%=createAction?sdf.format(currentDate.getTime()):updateAction?bDate:"" %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
<jsp:include page="../ui/timeCMB.jsp" flush="false">
	<jsp:param name="label" value="catBbookingTime" />
	<jsp:param name="time" value="<%=bTime %>" />
	<jsp:param name="interval" value="5" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			(HH:MM)
			<input type="hidden" id="catBbooking" name="catBbooking" value="<%=catBbooking %>" />
<% } else { %>
		<%=catBbooking %>
<% } %>			
			</td>
		</tr>
		<tr>
			<td width="30%">Consult by:</td>
			<td width="70%"><%=docName %><input type="hidden" id="doccode" name="doccode" value="<%=doccode %>" /></td>
		</tr>
</table>
<br/><br/>
<table id="itemlist">
<jsp:include page="gov_booking_ajax.jsp" flush="false">
	<jsp:param name="action" value="<%=createAction || updateAction %>" />
	<jsp:param name="govPosition" value="<%=govPosition %>" />
	<jsp:param name="govDept" value="<%=govDept %>" />
	<jsp:param name="sex" value="<%=sex %>" />
	
</jsp:include>
</table>

<input type="hidden" id="command" name="command" value="<%=command %>" />
<input type="hidden" id="step" name="step" value="<%=step %>" />
<input type="hidden" id="bkgid" name="bkgid" value="<%=bkgid %>" />
<input type="hidden" id="catBposition" name="catBposition" value="<%=catBposition %>" />

</form>
<br/>
<div style="text-align:center">
<%if(govbkgExist){%>
	<input type="button" class="button" onclick="submitAction('update',<%=updateAction?"1":"0" %>)" id="submitButton" value="Update Order Form"/>
	<%if(!updateAction){ %><input type="button" class="button" onclick="return printAction();" value="Print Order Form"/><%} %>
<%} else{ %>
	<input type="button" class="button" onclick="submitAction('create',1)" id="submitButton" value="Save Order Form"/>
<%} %>
</div>


<script language="javascript">

$(document).ready(function() {
	<%if(catBbooking.length() == 0){ %>	
		$("#catB").hide();
	<%}%>
	<%if(createAction){ %>
	$("#submitButton").attr('disabled','disabled');
	<%}%>
});

function getPosition(){
	var govDept = $("#govDept").val();
	
	$.ajax({
        url: "gov_position_ajax.jsp",
        data: {	"govDept" : govDept },
        type: 'POST',
        dataType: 'html',
		cache: false,
        success: function(data){
        	$('#govPosition').html(data);
        },
       	error: function(data){
       		console.log(data);
       	}
    });
}
var vaild = true;
function getItemTest(cmd){
	var sex = $("input[name=sex]:checked").val();
	var govDept = $("#govDept").val();
	var govPosition = $("#govPosition").val();
	
	if($.trim(sex) == ''){
		alert("Please enter candidate gender.");
		vaild = false;
	}else if($.trim(govDept) == ''){
		alert("Please select a department.");
		vaild = false;
	}else if($.trim(govPosition) == ''){
		alert("Please select a position.");
		vaild = false;
	}else{
		if(cmd == "get"){
			$.ajax({
		        url: "gov_booking_ajax.jsp",
		        data: {	"govDept" : govDept,
		        		"govPosition" : govPosition,
		        		"sex" : sex,
		        		"action" : <%=createAction || updateAction %>},
		        type: 'POST',
		        dataType: 'html',
				cache: false,
		        success: function(data){
		        	$('#itemlist').html(data);
		        	$("#submitButton").attr('disabled',false);
		        },
		       	error: function(data){
		       		console.log(data);
		       		vaild = false;
		       	}
		    });
		}else{
			vaild = true;
		}
		
	}
	
}

function getCatBDate(){
	var dateTime = null;
	var date = $("#catBbookingDate").val();
	var hh = $("select[name=catBbookingTime_hh] option:selected").val();
	var mi = $("select[name=catBbookingTime_mi] option:selected").val();
	if($.trim(date) == ''){
		dateTime = "";
	}else{
		dateTime = date +" " + hh + ":" + mi;	
	}
	document.govBookingForm.catBbooking.value = dateTime;
}

function submitAction(cmd,stp){
	<%	if (createAction || updateAction) { %>	
	getItemTest(cmd);
	var govPos = $("select[name=govPosition] option:selected").val();
	govPos = govPos.substr(-1);
	if(govPos == 'B'){
		var date = $("#catBbookingDate").val();
		var hh = $("select[name=catBbookingTime_hh] option:selected").val();
		var mi = $("select[name=catBbookingTime_mi] option:selected").val();
		
		if($.trim(date) == '' || $.trim(hh) == '' || $.trim(mi) == ''){
			alert("Please enter cat B consultation date / time.");
			vaild = false;
		} else{
			getCatBDate();
		}
	}
	<%}%>
	if(vaild){
		document.govBookingForm.command.value = cmd;
		document.govBookingForm.step.value = stp;
		document.govBookingForm.submit();
	}
}

function printAction(){
	document.getElementById('govBookingForm').action = 'printGovOrderForm.jsp';
	document.govBookingForm.submit();
}

</script>

</body>
</html:html>