<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%

UserBean userBean = new UserBean(request);

// Test insert
/*
NurobAdmltrDB.add(userBean, "2", "3","4","5","6", "7", "8", "01/01/2011", "0",
		            "1","2", "3","4","5","6", "7", "8", "9", "0",
		            "1","2", "3","4","5","6", "7", "8", "9", "0",
		            "1","2", "3","4","5","6", "7", "8", "9", "0",
		            "1","2", "3","4","5","6", "7", "8", "9", "0",
		            "1","2", "3","4","5","01/01/2011", "7", "8", "9", "0",
		            "1","2", "3","4","5","6");
 */

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String nurobAdmltrID = ParserUtil.getParameter(request, "nurobAdmltrID");
String nurobPatient = ParserUtil.getParameter(request, "nurobPatient");
String nurobAge = ParserUtil.getParameter(request, "nurobAge");
String nurobTelno = ParserUtil.getParameter(request, "nurobTelno");
String nurobBookno = ParserUtil.getParameter(request, "nurobBookno");
String nurobStatus = ParserUtil.getParameter(request, "nurobStatus");
String nurobGravida = ParserUtil.getParameter(request, "nurobGravida");
String nurobPara = ParserUtil.getParameter(request, "nurobPara");
String nurobEdc = ParserUtil.getParameter(request, "nurobEdc");
String nurobDr = ParserUtil.getParameter(request, "nurobDr");
String nurobClinic = ParserUtil.getParameter(request, "nurobClinic");
String nurobAllergy = ParserUtil.getParameter(request, "nurobAllergy");
String nurobCardiac = ParserUtil.getParameter(request, "nurobCardiac");
String nurobDiabetes = ParserUtil.getParameter(request, "nurobDiabetes");
String nurobDm = ParserUtil.getParameter(request, "nurobDm");
String nurobGdm = ParserUtil.getParameter(request, "nurobGdm");
String nurobIgt = ParserUtil.getParameter(request, "nurobIgt");
String nurobAnemia = ParserUtil.getParameter(request, "nurobAnemia");
String nurobRenal = ParserUtil.getParameter(request, "nurobRenal");
String nurobLiver = ParserUtil.getParameter(request, "nurobLiver");
String nurobResp = ParserUtil.getParameter(request, "nurobResp");
String nurobGi = ParserUtil.getParameter(request, "nurobGi");
String nurobEpilepsy = ParserUtil.getParameter(request, "nurobEpilepsy");
String nurobPsychiatric = ParserUtil.getParameter(request, "nurobPsychiatric");
String nurobImmun = ParserUtil.getParameter(request, "nurobImmun");
String nurobThyroid = ParserUtil.getParameter(request, "nurobThyroid");
String nurobSurg = ParserUtil.getParameter(request, "nurobSurg");
String nurobMulti = ParserUtil.getParameter(request, "nurobMulti");
String nurobPrevious = ParserUtil.getParameter(request, "nurobPrevious");
String nurobHyper = ParserUtil.getParameter(request, "nurobHyper");
String nurobAph = ParserUtil.getParameter(request, "nurobAph");
String nurobPreterm = ParserUtil.getParameter(request, "nurobPreterm");
String nurobBadob = ParserUtil.getParameter(request, "nurobBadob");
String nurobIugr = ParserUtil.getParameter(request, "nurobIugr");
String nurobFetal = ParserUtil.getParameter(request, "nurobFetal");
String nurobRoutine = ParserUtil.getParameter(request, "nurobRoutine");
String nurobInduct = ParserUtil.getParameter(request, "nurobInduct");
String nurobElective = ParserUtil.getParameter(request, "nurobElective");
String nurobCurrmed = ParserUtil.getParameter(request, "nurobCurrmed");
String nurobRoom = ParserUtil.getParameter(request, "nurobRoom");
String nurobCord = ParserUtil.getParameter(request, "nurobCord");
String nurobTriallabor = ParserUtil.getParameter(request, "nurobTriallabor");
String nurobTrialscar = ParserUtil.getParameter(request, "nurobTrialscar");
String nurobFleet = ParserUtil.getParameter(request, "nurobFleet");
String nurobShaving = ParserUtil.getParameter(request, "nurobShaving");
String nurobPain = ParserUtil.getParameter(request, "nurobPain");
String nurobPainPeth = ParserUtil.getParameter(request, "nurobPainPeth");
String nurobNotify = ParserUtil.getParameter(request, "nurobNotify");
String nurobAnytime = ParserUtil.getParameter(request, "nurobAnytime");
String nurobAfter06 = ParserUtil.getParameter(request, "nurobAfter06");
String nurobNpo = ParserUtil.getParameter(request, "nurobNpo");
String nurobHep = ParserUtil.getParameter(request, "nurobHep");
String nurobPps = ParserUtil.getParameter(request, "nurobPps");
String nurobPost = ParserUtil.getParameter(request, "nurobPost");
String nurobCs = ParserUtil.getParameter(request, "nurobCs");
String nurobCsbtl = ParserUtil.getParameter(request, "nurobCsbtl");
String nurobCsdate = ParserUtil.getParameter(request, "nurobCsdate");
String nurobCsseltime = ParserUtil.getParameter(request, "nurobCsseltime");
String nurobGa = ParserUtil.getParameter(request, "nurobGa");
String nurobSa = ParserUtil.getParameter(request, "nurobSa");
String nurobIndication = ParserUtil.getParameter(request, "nurobIndication");
String nurobIndicationText = ParserUtil.getParameter(request, "nurobIndicationText");
String nurobAbdominal = ParserUtil.getParameter(request, "nurobAbdominal");
String nurobPublic = ParserUtil.getParameter(request, "nurobPublic");
String nurobAnesdr = ParserUtil.getParameter(request, "nurobAnesdr");
String nurobPremed = ParserUtil.getParameter(request, "nurobPremed");
String nurobPeddr = ParserUtil.getParameter(request, "nurobPeddr");
String nurobFeed = ParserUtil.getParameter(request, "nurobFeed");
String nurobOther = ParserUtil.getParameter(request, "nurobOther");
//String nurob_created_date = ParserUtil.getParameter(request, "nurob_created_date");
//String nurob_created_user = ParserUtil.getParameter(request, "nurob_created_user");
//String nurob_modified_date = ParserUtil.getParameter(request, "nurob_modified_date");
//String nurob_modified_user = ParserUtil.getParameter(request, "nurob_modified_user");
//String nurobEnabled = ParserUtil.getParameter(request, "nurobEnabled");


String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

try {
	if ("1".equals(step)) {
		if (createAction) {
			// get news id with dummy data
			nurobAdmltrID = NurobAdmltrDB.add(userBean,
					nurobPatient, nurobAge,
					nurobTelno, nurobBookno,
					nurobStatus, nurobGravida,
					nurobPara, nurobEdc,
					nurobDr, nurobClinic,
					nurobAllergy, nurobCardiac,
					nurobDiabetes, nurobDm,
					nurobGdm, nurobIgt,
					nurobAnemia, nurobRenal,
					nurobLiver, nurobResp,
					nurobGi, nurobEpilepsy,
					nurobPsychiatric, nurobImmun,
					nurobThyroid, nurobSurg,
					nurobMulti, nurobPrevious,
					nurobHyper, nurobAph,
					nurobPreterm, nurobBadob,
					nurobIugr, nurobFetal,
					nurobRoutine, nurobInduct,
					nurobElective, nurobCurrmed,
					nurobRoom, nurobCord,
					nurobTriallabor, nurobTrialscar,
					nurobFleet, nurobShaving,
					nurobPain, nurobPainPeth, nurobNotify,
					nurobAnytime, nurobAfter06,
					nurobNpo, nurobHep,
					nurobPps, nurobPost,
					nurobCs, nurobCsbtl,
					nurobCsdate, nurobCsseltime, nurobGa,
					nurobSa, nurobIndication, nurobIndicationText,
					nurobAbdominal, nurobPublic,
					nurobAnesdr, nurobPremed,
					nurobPeddr, nurobFeed,
					nurobOther);
			
			if (nurobAdmltrID != null) {
				errorMessage = "Record saved.";
				
				createAction = false;
				step = null;
			} else {
				errorMessage = "Record save failed.";
			}
		} else if (deleteAction) {

		}
	}

	// load data from database
	if (!createAction && !"1".equals(step)) {
		/*
		if (newsID != null && newsID.length() > 0) {
			ArrayList record = NewsDB.get(newsID, newsCategory);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				newsType = row.getValue(2);
				newsTitle = row.getValue(3);
				newsTitleUrl = row.getValue(4);
				newsTitleImage = row.getValue(5);
				newsPostDate = row.getValue(6);
				newsExpireDate = row.getValue(7);

				StringBuffer contentSB = new StringBuffer();
				record = NewsDB.getContent(newsID, newsCategory);
				if (record != null) {
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
						contentSB.append(row.getValue(0));
					}
				}
				content = contentSB.toString();
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
		*/
	}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }










/*
============
Template end
============
*/

/*
if (patbdate != null && patbdate.length() > 0) {
	if (patidno != null && patidno.length() > 0) {
		record = AdmissionDB.getHATSPatient(null, patidno, patbdate);
	} else if (patpassport != null && patpassport.length() > 0) {
		record = AdmissionDB.getHATSPatient(null, patpassport, patbdate);
	}
	if (record != null && record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		patno = row.getValue(0);
		patfname = row.getValue(1);
		patgname = row.getValue(2);
		titleDesc = row.getValue(3);
		patcname = row.getValue(4);
		patidno = row.getValue(5);
//		if (patidno.length() >= 8 && patidno.length() <= 9) {
//			patidno1 = patidno.substring(0, 7);
//			patidno2 = patidno.substring(7);
//		} else {
//			patpassport = patidno;
//		}
		patsex = row.getValue(6);
		racedesc = row.getValue(7);
		religion = row.getValue(8);
//		patbdate = row.getValue(9);

		patmsts = row.getValue(10);
		mothcode = row.getValue(11);
		edulevel = row.getValue(12);
		pathtel = row.getValue(13);
		patotel = row.getValue(14);
		patmtel = row.getValue(15);
		patftel = row.getValue(16);
		occupation = row.getValue(17);
//		patemail = row.getValue(18);
		patadd1 = row.getValue(19);
		patadd2 = row.getValue(20);
		patadd3 = row.getValue(21);
		String patkname = row.getValue(22);
		int index = patkname.indexOf(" ");
		if (index > 0) {
			patkfname1 = patkname.substring(0, index);
			patkgname1 = patkname.substring(index + 1);
		}
		patkrela1 = row.getValue(23);
		patkhtel1 = row.getValue(24);
		patkptel1 = row.getValue(25);
		patkotel1 = row.getValue(26);
		patkmtel1 = row.getValue(27);
		patkemail1 = row.getValue(28);
		String patkadd = row.getValue(29);
		String[] patkaddArray = TextUtil.split(patkadd, ",");
		if (patkaddArray.length == 4) {
			patkadd11 = patkaddArray[0];
			patkadd21 = patkaddArray[1];
			patkadd31 = patkaddArray[2];
		} else {
			patkaddArray = TextUtil.split(patkadd, 40);
			patkadd11 = patkaddArray.length > 0 ? patkaddArray[0] : null;
			patkadd21 = patkaddArray.length > 1 ? patkaddArray[1] : null;
			patkadd31 = patkaddArray.length > 2 ? patkaddArray[2] : null;
		}
		loccode = row.getValue(30);
		coucode = row.getValue(31);
	}
}
*/
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<style>

</style>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>

<!-- Display message -->
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form id="form1" name="form1" action="nurob_admltr_form.jsp" method="post">
	<!-- Logo -->
	<table width="800" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td align="left"><img src="../images/logo_hkah.gif" border="0" width="261" height="113" /></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		</tr>
	</table>
	
	<!-- Form Header -->
	<table width="800" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center"><h1>荃灣港安醫院</h1></td>
		</tr>
		<tr>
			<td align="center"><h1>Hong Kong Adventist Hospital - Tsuen Wan</h1></td>
		</tr> 
		<tr>
			<td align="center"><h1>Admission Letter for Maternity</h1></td>
		</tr>
		<tr>
			<td align="center"><h1>產科入院信</h1></td>
		</tr>
	</table>
	
	<!-- Personal Inforamtion -->
	<table width="800" border="0" cellpadding="10" cellspacing="10">
		<tr>
			<td>
				<table width="70%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td>
							<h2>Personal Information:</h2>
						</td>
					</tr>
					<tr>
						<td>
						Name:<input type="text" name="nurobPatient" value="" maxlength="40" size="45" />
						Age:<input type="text" id="nurobAge" name="nurobAge" value="" maxlength="3" size="10" />
						</td>
					</tr>
					<tr>
						<td>
						Telephone no.:<input type="text" name="nurobTelno" value="" maxlength="20" size="11" />
						Booking no.:<input type="text" name="nurobBookno" value="" maxlength="20" size="10" />
						</td>
					</tr>
					<tr>
						<td>
						Status:<input type="radio" name="nurobStatus" value="1" /> HK Resident
						<input type="radio" name="nurobStatus" value="2" /> Non HK Resident
						</td>
					</tr>
					<tr>
						<td>
						Gravida:<input type="text" name="nurobGravida" value="" maxlength="5" size="10" />
						Para:<input type="text" name="nurobPara" value="" maxlength="5" size="10" />
						EDC:<input type="date" name="nurobEDC" value="" />
						</td>
					</tr>
					<tr>
						<td>
						From Dr:<input type="text" name="nurobDr" value="" maxlength="80" size="30" />
						Clinic:<input type="text" name="nurobClinic" value="" maxlength="20" size="20" />
						Allergy:<input type="text" name="nurobAllergy" value="" maxlength="40" size="30" />
						</td>
					</tr>
					<tr>
						<td>
						<h2>Antenatal History</h2>
						</td>
					</tr>
				</table>
				<table>
					<tr>
						<td>
						Medical History/Complications:
						</td>
					</tr>
					<tr>
						<td>
						Cardiac disease:<input type="checkbox" name="nurobCardiac" value="" />
						Diabetes:<input type="checkbox" name="nurobDiabetes" value="" />
						DM on insulin:<input type="checkbox" name="nurobDM" value="" />
						</td>
					</tr>
					<tr>
						<td>
						GDM on diet:<input type="checkbox" name="nurobGdm" value="" />
						IGT:<input type="checkbox" name="nurobIgt" value="" />
						Anemia:<input type="checkbox" name="nurobAnemia" value="" />
						</td>
					</tr>
					<tr>
						<td>
						Renal Disease:<input type="checkbox" name="nurobRenal" value="" />
						Liver Disease:<input type="checkbox" name="nurobLiver" value="" />
						Respiratory Disease:<input type="checkbox" name="nurobResp" value="" />
						</td>
					</tr>
					<tr>
						<td>
						GI/Biliary Disease:<input type="checkbox" name="nurobGi" value="" />
						Epilepsy:<input type="checkbox" name="nurobEpilepsy" value="" />
						Psychiatric Disease:<input type="checkbox" name="nurobPsychiatric" value="" />
						</td>
					</tr>
					<tr>
						<td>
						Immunological Disease:<input type="checkbox" name="nurobImmun" value="" />
						Thyroid Disease:<input type="checkbox" name="nurobThyroid" value="" />
						Surgical Disease:<input type="checkbox" name="nurobSurg" value="" />
						</td>
					</tr>
					<tr><td>Obstetric Complications:</td></tr>
					
					<tr>
						<td>
						Multiple Pregnancies:<input type="checkbox" name="nurobMulti" value="" />
						Previous Uterine Scan:<input type="checkbox" name="nurobPrevious" value="" />
						Hypertension:<input type="checkbox" name="nurobHyper" value="" />
						</td>
					</tr>
					<tr>
						<td>
						APH:<input type="checkbox" name="nurobAph" value="" />
						Pre-term Labor:<input type="checkbox" name="nurobPreterm" value="" />
						Bad Obstetric History:<input type="checkbox" name="nurobBadob" value="" />
						</td>
					</tr>
					<tr>
						<td>
						IUGR:<input type="checkbox" name="nurobIugr" value="" />
						Fetal Abnormalities:<input type="checkbox" name="nurobFetal" value="" />
						</td>
					</tr>

					<tr><td><h2>Current Admission:</h2></td></tr>
					<tr><td>A. Reason for admission:</td></tr>
					<tr>
						<td>
						Routine admission in labor:<input type="checkbox" name="nurobRoutine" value="" />
						Induction for post term:<input type="checkbox" name="nurobInduct" value="" />
						Elective CS:<input type="checkbox" name="nurobElective" value="" />
						</td>
					</tr>
					<tr>
						<td>
						B. Current Medication:<input type="text" name="nurobCurrmed" value="" maxlength="80" size="80" />
						</td>
					</tr>
					<tr>
						<td>
						C. Labor Plan:
						</td>
					</tr>
					<tr>
						<td>
						1. Request room accommodation:<input type="radio" name="nurobRoom" value="1" /> Single
						<input type="radio" name="nurobRoom" value="2" /> 2-beds
						<input type="radio" name="nurobRoom" value="3" /> 3-beds
						<input type="radio" name="nurobRoom" value="4" /> 5-beds
						</td>
					</tr>
					<tr>
						<td>
						2. Cord blood collection:<input type="checkbox" name="nurobCord" value="" />
						</td>
					</tr>
					<tr>
						<td>
						3. Intending Vaginal Delivery: <input type="checkbox" name="nurobTriallabor" value="" />
						Trial of labor, <input type="checkbox" name="nurobTrialscar" value="" />
						</td>
					</tr>
					<tr>
						<td>
						Fleet Enema <input type="checkbox" name="nurobFleet" value="" />
						Shaving (Half shave/ Whole share/ no share) <input type="checkbox" name="nurobShaving" value="" />
						</td>
					</tr>
					<tr>
						<td>
						Pain relief: <input type="checkbox" name="nurobPain" value="" />
						Notify Obstetrician <input type="checkbox" name="nurobNotify" value="" />
						Anytime on admission <input type="checkbox" name="nurobAnytime" value="" />
						</td>
					</tr>
					<tr>
						<td>
						After 0600 <input type="checkbox" name="nurobAfter06" value="" />
						NPO <input type="checkbox" name="nurobNPO" value="" />
						Hep. Block <input type="checkbox" name="nurobHep" value="" />
						</td>
					</tr>
					<tr>
						<td>
						Intended PPS <input type="checkbox" name="nurobPpS" value="" />
						Post partum: <input type="checkbox" name="nurobPost" value="" />
						</td>
					</tr>
					<tr>
						<td>
						4. Elective CS
						</td>
					</tr>
					<tr>
						<td>
						CS Only <input type="checkbox" name="nurobCS" value="" />
						CS + BTL <input type="checkbox" name="nurobCsbtl" value="" />
						</td>
					</tr>
					<tr>
						<td>
						Date/Time:<input type="datetime" name="nurobCsdate" value="" />
						</td>
					</tr>
					<tr>
						<td>
						Anesthetsia : GA <input type="checkbox" name="nurobGA" value="" />
						SA <input type="checkbox" name="nurobSA" value="" />
						</td>
					</tr>
					<tr>
						<td>
						Indication <input type="checkbox" name="nurobIndication" value="" />
						</td>
					</tr>
					<tr>
						<td>
						Shaving : <input type="radio" name="nurobAbdominal" value="1" /> Abdominal
						<input type="radio" name="nurobAbdominal" value="2" /> Public shaving only
						</td>
					</tr>
					<tr>
						<td>
						Anesthetist Dr:<input type="text" name="nurobAnesdr" value="" maxlength="80" size="80" />
						</td>
					</tr>					
					<tr>
						<td>
						Pre-Medication:<input type="text" name="nurobPremed" value="" maxlength="80" size="80" />
						</td>
					</tr>					
					
				</table>

				
			</td>
		</tr>
	</table>
	
	<!-- Buttons -->
	<div class="pane">
		<table width="800" border="0" cellpadding="0" cellspacing="0">
			<tr class="smallText">
				<td align="center">
				<button class="btn-submit" onclick="submitAction('create', 1);return false;">Save</button>
				</td>
			</tr>
		</table>
	</div>
	
	<!-- Control variables -->
	<input type="hidden" name="command" />
	<input type="hidden" name="step" />
	<input type="hidden" name="nurobAdmltrID" />
</form>

<script language="javascript">
<!--//

	// field validation
	$(document).ready(function(){
	    $("#form1").validate({
		  rules: {
			// decimal only  
			nurobAge: {
		      //required: true,
		      number: true
	    	}
		  }
		});
	});
    
	function submitAction(cmd, stp) {
		var msg = '';
		var focusField;

		if (document.form1.nurobPatient.value == '') {
			if (msg.length == 0) focusField = document.form1.nurobPatient;
			msg = msg + 'Empty Name 沒有輸入名稱.\n';
		}
		
		/*
		if (document.form1.expectedAdmissionDate.value == '') {
			if (msg.length == 0) focusField = document.form1.expectedAdmissionDate;
			msg = msg + 'Empty Admission Date 沒有輸入預定入院日期.\n';
		} else if (!validDate(document.form1.expectedAdmissionDate)) {
			if (msg.length == 0) focusField = document.form1.expectedAdmissionDate;
			msg = msg + 'Invalid Admission Date 輸入不正確預定入院日期.\n';
		} else if (!checkAdmissionDate()) {
			if (msg.length == 0) focusField = document.form1.expectedAdmissionDate;
			msg = msg + 'Admission Date is less than one day prior to your admission. 預定入院日期少於一個工作天.\n';
		}
		if (document.form1.admissiondoctor.value == '') {
			if (msg.length == 0) focusField = document.form1.admissiondoctor;
			msg = msg + 'Empty Admission Doctor 沒有輸入醫生.\n';
		}
		if (document.form1.patidType[0].checked) {
			if (document.form1.patidno1.value == '') {
				if (msg.length == 0) focusField = document.form1.patidno1;
				msg = msg + 'Empty Hong Kong I.D. Card 沒有輸入香港身份證號.\n';
			} else if (document.form1.patidno2.value == '') {
				if (msg.length == 0) focusField = document.form1.patidno2;
				msg = msg + 'Empty Hong Kong I.D. Card 沒有輸入香港身份證號.\n';
			} else if (document.form1.patidno1.value.length < 7) {
				if (msg.length == 0) focusField = document.form1.patidno1;
				msg = msg + 'Invalid Hong Kong I.D. Card 輸入不正確香港身份證號.\n';
			}
		}
		if (document.form1.patidType[1].checked && document.form1.patpassport.value == '') {
			if (msg.length == 0) focusField = document.form1.patpassport;
			msg = msg + 'Empty Passport No. 沒有輸入護照號碼.\n';
		}
		if (document.form1.patbdate.value == '') {
			if (msg.length == 0) focusField = document.form1.patbdate;
			msg = msg + 'Empty Date of Birth 沒有輸入出生日期.\n';
		} else if (!validDate(document.form1.patbdate)) {
			if (msg.length == 0) focusField = document.form1.patbdate;
			msg = msg + 'Invalid Date of Birth 輸入不正確出生日期.\n';
		}
		if (document.form1.patfname.value == '') {
			if (msg.length == 0) focusField = document.form1.patfname;
			msg = msg + 'Empty Family Name 沒有輸入姓氏.\n';
		}
		if (document.form1.patgname.value == '') {
			if (msg.length == 0) focusField = document.form1.patgname;
			msg = msg + 'Empty Given Name 沒有輸入名稱.\n';
		}
		if (document.form1.titleDesc.value == '' && document.form1.titleDescOther.value == '') {
			if (msg.length == 0) focusField = document.form1.titleDesc;
			msg = msg + 'Empty Title 沒有輸入稱謂.\n';
		}
		if (document.form1.patsex.value == '') {
			if (msg.length == 0) focusField = document.form1.patsex;
			msg = msg + 'Empty Sex 沒有輸入性別.\n';
		}
		if (document.form1.racedesc.value == '' && document.form1.racedescOther.value == '') {
			if (msg.length == 0) focusField = document.form1.racedesc;
			msg = msg + 'Empty Ethnic Group 沒有輸入種族.\n';
		}
		if (document.form1.religion.value == 'OT' && document.form1.religionOther.value == '') {
			if (msg.length == 0) focusField = document.form1.religion;
			msg = msg + 'Empty Religion 沒有輸入宗教.\n';
		}
		if (document.form1.mothcode.value == 'OTH' && document.form1.mothcodeOther.value == '') {
			if (msg.length == 0) focusField = document.form1.mothcode;
			msg = msg + 'Empty Written Language 沒有輸入語言.\n';
		}
		if (document.form1.occupation.value == '') {
			if (msg.length == 0) focusField = document.form1.occupation;
			msg = msg + 'Empty Occupation 沒有輸入職業.\n';
		}
		if (document.form1.pathtel.value == ''
				&& document.form1.patotel.value == ''
				&& document.form1.patmtel.value == '') {
			if (msg.length == 0) focusField = document.form1.pathtel;
			msg = msg + 'Empty Contact Telephone Number 沒有輸入電話.\n';
		}
		if (document.form1.patemail.value == '') {
			if (msg.length == 0) focusField = document.form1.patemail;
			msg = msg + 'Empty Email 沒有輸入電郵地址.\n';
		}
		if (document.form1.patadd1.value == '') {
			if (msg.length == 0) focusField = document.form1.patadd1;
			msg = msg + 'Empty Address 沒有輸入地址.\n';
		}
		if (document.form1.patkfname1.value == '') {
			if (msg.length == 0) focusField = document.form1.patkfname1;
			msg = msg + 'Empty Family Name for Emergency Contact Person 沒有輸入緊急聯絡人姓氏.\n';
		}
		if (document.form1.patkgname1.value == '') {
			if (msg.length == 0) focusField = document.form1.patkgname1;
			msg = msg + 'Empty Given Name for Emergency Contact Person 沒有輸入緊急聯絡人名稱.\n';
		}
		if (document.form1.patkhtel1.value == ''
				&& document.form1.patkotel1.value == ''
				&& document.form1.patkmtel1.value == ''
				&& document.form1.patkptel1.value == '') {
			if (msg.length == 0) focusField = document.form1.patkhtel1;
			msg = msg + 'Empty Contact Telephone Number 沒有輸入緊急聯絡人電話.\n';
		}
		if (document.form1.patkrela1.value == '') {
			if (msg.length == 0) focusField = document.form1.patkrela1;
			msg = msg + 'Empty Relationship for Emergency Contact Person 沒有輸入緊急聯絡人關係.\n';
		}
		if (!document.form1.agreement2.checked) {
			if (msg.length == 0) focusField = document.form1.agreement2;
			msg = msg + 'Please Confirm Daily Room Rate and Advance Payment 請確定已細閱每日房租和預繳按金.\n';
		}
		*/
		
		if (msg.length > 0) {
			alert(msg);
			if (focusField)
				focusField.focus();
			return false;
		} else {
			document.form1.command.value = cmd;
			document.form1.step.value = stp;
			
			document.form1.submit();
		}
	}

	// ajax
	var http = createRequestObject();

	function validHKID() {
		if (document.form1.patidno1.value != '') {
			document.form1.patidType[0].checked = true;
			document.form1.patpassport.value = '';

			var hkid1 = document.form1.patidno1.value;
			var hkid2 = document.form1.patidno2.value;
			document.form1.patidno1.value = hkid1.toUpperCase();
			document.form1.patidno2.value = hkid2.toUpperCase();
		}
		return false;
	}

	function validPassport() {
		if (document.form1.patpassport.value != '') {
			document.form1.patidType[1].checked = true;
			document.form1.patidno1.value = '';
			document.form1.patidno2.value = '';

			document.form1.patpassport.value = document.form1.patpassport.value.toUpperCase();
			document.form1.patpassport.focus();
		}
		return false;
	}

	function validDOB(event) {
		if (document.form1.patno.value != '' && event.keyCode == 13) {
			document.form1.patbdate.focus();
		}
	}

	function changePaymentType() {
		if (document.form1.creditCardType.value != '') {
			document.form1.paymentType[2].checked = true;
		}
		return false;
	}

	function checkAdmissionDate() {
		var expectedAdmissionDate = document.form1.expectedAdmissionDate.value;
		var deadline = '<%=DateTimeUtil.getCurrentDate() %>';
		return parseDate(expectedAdmissionDate) - parseDate(deadline) > 0;
	}
//-->
</script>

<!-- 

// TEMPALTE END //

 -->



</DIV>

</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>