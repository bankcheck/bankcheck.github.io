<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>

<%

UserBean userBean = new UserBean(request);
String command = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "command"));
String mode = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mode"));
String pirID = request.getParameter("pirID");
String pirDID = request.getParameter("PIR_DID");
String rptSts = "";
String replyContent = null;
String incident_classification_desc = request.getParameter("incidentType");
String incidentType = request.getParameter("incidentType");
String incident_desc = request.getParameter("incidentDesc");


Boolean SendReplyAction = false;
Boolean closeAction = false;
Boolean viewAction = false;

ReportableListObject row = null;
Boolean IsOshIcn = null;
Boolean closeAccessDeniedAction = false;

String title = "E-Incident Reporting System";
String message = "";
String errorMessage = "";

String outVal = "";
String semiColon = "";
String ReceiverType = "admin";
String ccList = "";

Boolean IsReponsiblePerson = null;
Boolean IsAddRptPerson = null;
Boolean IsDHead = null;
Boolean IsNoticeStaff = null;
Boolean IsStaffIncident = null;

String reportStatusDesc = null;
%>
<%
	ArrayList record = PiReportDB.fetchReportBasicInfo(pirID);
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		incident_classification_desc = row.getValue(10);
		rptSts = row.getValue(9);
		reportStatusDesc = PiReportDB.getRptStsDesc(PiReportDB.IsPxDeptCode(row.getValue(32)), incident_classification_desc, row.getValue(9), rptSts);
		incident_desc = row.getValue(11);
	}

	if (command != null && command.indexOf("view") > -1) {
		pirID = request.getParameter("pirID");
		viewAction = true;
	}
	// check is IsNoticeStaff

	if ("fn".equals(mode)) {  // further notice
		title = "E-Incident Reporting System";
		IsNoticeStaff = PiReportDB.IsFurtherNotifyStaff(userBean);

		if (!IsNoticeStaff) {
			closeAccessDeniedAction = true;
		}
	}
	else if ("se".equals(mode)) {  // further notice
		title = "E-Incident Reporting System - SENTINEL EVENT";
		IsNoticeStaff = PiReportDB.IsSentinelEventStaff(userBean, pirID);

		if (!IsNoticeStaff) {
			closeAccessDeniedAction = true;
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<jsp:include page="../common/banner2.jsp"/>
<%	if (userBean.isLogin() && closeAction) { %>
		<script type="text/javascript">alert('Reply Submitted');window.close();</script>
<%  }
else if (userBean.isLogin() && closeAccessDeniedAction) {%>
	<script type="text/javascript">alert('Access Denied !');window.close();</script>
<%	} else { %>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>



<%--  Follow up Show Incident Report--%>
<div>

<a href="#" class="IncidentReport" onclick="showhide(0, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', 'Incident Report - <%=incident_desc%> (<%=reportStatusDesc%>) -', 'Incident Report - <%=incident_desc%> (<%=reportStatusDesc%>) +');return false;">
	<u><span style="font-size:22px;color:#000000;" id="rr_showhidelink_0" class="visible">Incident Report - <%=incident_desc%> (<%=reportStatusDesc%>) -</span></u>
</a>
<br/>


<span id="rr_hideobj_0">



<div style="border:1px solid black">
		<b>Basic Information</b><br/>
<%
	ArrayList flwUpDialogBasicInfo = PiReportDB.fetchReportFlwUpDialogBasicInfo(pirID);
	if (flwUpDialogBasicInfo.size() > 0) {
		String dutyMgrName = null;
		row = (ReportableListObject) flwUpDialogBasicInfo.get(0);
		dutyMgrName = row.getValue(8);
		if (dutyMgrName.isEmpty()) {
			dutyMgrName = "";
		}
		else {
			dutyMgrName = StaffDB.getStaffName(row.getValue(8));
		}
%>

		&nbsp;&nbsp;&nbsp;&nbsp;Report Person<br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Name : <%=row.getValue(0)%><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Position : <%=row.getValue(1)%><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Department : <%=row.getValue(2)%><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Submitted to Department Head : <%=StaffDB.getStaffName(row.getValue(7))%><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Submitted to Duty Manager : <%=dutyMgrName%><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Is it a Sentinel Event ? <%if ("1".equals(row.getValue(9))) {%>Yes<%} else { %>No<%} %><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;Incident Information<br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date of Occurrence : <%=row.getValue(3)%><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Time of Occurrence : <%=row.getValue(4)%><br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Place of Occurrence : <%=row.getValue(5)%><br/>
		<%--
		&nbsp;&nbsp;&nbsp;&nbsp;Related Report<br/>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Report ID<%=row.getValue(6)%><br/>
		--%>
		<br/>
<%
	}
%>

		<b>Involving Person</b>
		<table border="0">
			<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td><table border="0">
<%
	ArrayList flwUpDialogInvolvePerson = PiReportDB.fetchReportFlwUpDialogInvlovePerson(pirID, "is_patient");
	if (flwUpDialogInvolvePerson.size() > 0) {
%>


		<tr><td>Involving Person-Patient Info</td></tr>
		<tr>
			<td>Pat No</td><td></td><td></td><td>Name</td><td></td><td></td><td>Sex</td><td></td><td></td><td>Age</td><td></td><td></td><td>DOB</td><td></td><td></td><td>Physician</td><td></td><td></td><td>Diagnosis</td>
		</tr>
<%
		for(int i = 0; i < flwUpDialogInvolvePerson.size(); i++) {
			row = (ReportableListObject) flwUpDialogInvolvePerson.get(i);
%>
				<tr>
				<td><%=row.getValue(0)%></td><td></td><td></td><td><%=row.getValue(1)%></td><td></td><td></td><td><%=row.getValue(2)%></td><td></td><td></td><td><%=row.getValue(3)%></td><td></td><td></td><td><%=row.getValue(4)%></td><td></td><td></td><td><%=row.getValue(5)%></td><td></td><td></td><td><%=row.getValue(6)%></td>
				</tr>
<%
		}
	}
%>

<%
	flwUpDialogInvolvePerson = PiReportDB.fetchReportFlwUpDialogInvlovePerson(pirID, "is_staff");
	if (flwUpDialogInvolvePerson.size() > 0) {
%>
				<tr><td>Involving Person-Staff Info</td></tr>
				<tr><td>Staff No</td><td></td><td></td><td>Hospital No</td><td></td><td></td><td>Name</td><td></td><td></td><td>Position</td><td></td><td></td><td>Department</td><td></td><td></td><td>Sex</td></tr>

<%
		for(int i = 0; i < flwUpDialogInvolvePerson.size(); i++) {
			row = (ReportableListObject) flwUpDialogInvolvePerson.get(i);
%>
				<tr>
				<td><%=row.getValue(0)%></td><td></td><td></td><td><%=row.getValue(1)%></td><td></td><td></td><td><%=row.getValue(2)%></td><td></td><td></td><td><%=row.getValue(3)%></td><td></td><td></td><td><%=row.getValue(4)%></td><td></td><td></td><td><%=row.getValue(5)%></td>
				</tr>
<%
		}
	}
%>


<%
	flwUpDialogInvolvePerson = PiReportDB.fetchReportFlwUpDialogInvlovePerson(pirID, "is_visitor_relative");
	if (flwUpDialogInvolvePerson.size() > 0) {
%>
				<tr><td>Involving Person-Visitor/Relatives Info</td></tr>
				<tr><td>Hospital No</td><td></td><td></td><td>Staff No</td><td></td><td></td><td>Visitor/Relatives Name</td><td></td><td></td><td>Relationship</td><td></td><td></td><td>Remark</td></tr>

<%
		for(int i = 0; i < flwUpDialogInvolvePerson.size(); i++) {
			row = (ReportableListObject) flwUpDialogInvolvePerson.get(i);
%>
				<tr>
				<td><%=row.getValue(0)%></td><td></td><td></td><td><%=row.getValue(1)%></td><td></td><td></td><td><%=row.getValue(2)%></td><td></td><td></td><td><%=row.getValue(3)%></td><td></td><td></td><td><%=row.getValue(4)%></td>
				</tr>
<%
		}
	}
%>

<%
	flwUpDialogInvolvePerson = PiReportDB.fetchReportFlwUpDialogInvlovePerson(pirID, "is_other");
	if (flwUpDialogInvolvePerson.size() > 0) {
%>
				<tr><td>Involving Person- Visitor/Relatives Info</td></tr>
				<tr><td>Status</td><td></td><td></td><td>Name</td><td></td><td></td><td>Remark</td></tr>

<%
		for(int i = 0; i < flwUpDialogInvolvePerson.size(); i++) {
			row = (ReportableListObject) flwUpDialogInvolvePerson.get(i);
%>
				<tr>
				<td><%=row.getValue(0)%></td><td></td><td></td><td><%=row.getValue(1)%></td><td></td><td></td><td><%=row.getValue(2)%></td>
				</tr>
<%
		}
	}
%>
			</table>
			</td></tr>
		</table>



		<br/>
		<b>Incident Reporting</b>
		<br/>
<%
	ArrayList flwUpDialogreportMst = PiReportDB.fetchReportFlwUpDialogReportMst(pirID);
	if (flwUpDialogreportMst.size() > 0) {
		for(int i = 0; i < flwUpDialogreportMst.size(); i++) {
			row = (ReportableListObject) flwUpDialogreportMst.get(i);
%>
			&nbsp;&nbsp;&nbsp;&nbsp;<%=row.getValue(2)%><br/>

<%
			ArrayList flwUpDialogreportDtl = PiReportDB.fetchReportFlwUpDialogReportDtl(pirID, row.getValue(1));
			for(int j = 0; j < flwUpDialogreportDtl.size(); j++) {
				row = (ReportableListObject) flwUpDialogreportDtl.get(j);
				if (flwUpDialogreportDtl.size() > 0) {
					outVal = row.getValue(1);

					if ("follow_up".equals(row.getValue(2))) {
						semiColon = " ";
%>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <%=row.getValue(0)%><br/>
					<table border=0>
						<tr>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
							<td><%=outVal%><br/></td></tr>
<%
if ("284".equals(row.getValue(3)) || ("285".equals(row.getValue(3))) || ("286".equals(row.getValue(3))) || ("287".equals(row.getValue(3)))) {
%>
						<tr>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>
							<td>
								<div>
								<%--
									<a href="#" class="dHeadAddFollowUpComment" onclick="showhide(<%=row.getValue(3)%>, 'rr_hideobj_', 'rr_showobj_', 'rr_showhidelink_', 'Dept Head Comment -', 'Dept Head Comment +');return false;">
									<u><span style="font-size:12px;color:#000000;" id="rr_showhidelink_<%=row.getValue(3)%>" class="visible">Dept Head Comment +</span></u>
									</a>
									<span id="rr_hideobj_<%=row.getValue(3)%>" style="display:none"><div>
								--%>

<%if ("284".equals(row.getValue(3))) {
%>
<%--
									<textarea readonly style="border: none;background-color:#F7EFEF;COLOR:#0000FF" name="narrative_disponly" rows="10" cols="100"><%=Narrative%></textarea>
--%>
<%
}
else if ("285".equals(row.getValue(3))) {
%>
<%--
									<textarea readonly style="border: none;background-color:#F7EFEF;COLOR:#0000FF" name="cause_disponly" rows="10" cols="100"><%=Cause%></textarea>
--%>
<%
}
else if ("286".equals(row.getValue(3))) {
%>
<%--
  									<textarea readonly style="border: none;background-color:#F7EFEF;COLOR:#0000FF" name="actionDone_disponly" rows="10" cols="100"><%=ActionDone%></textarea>
--%>
<%
}
else if ("287".equals(row.getValue(3))) {
%>
<%--
									<textarea readonly style="border: none;background-color:#F7EFEF;COLOR:#0000FF" name="actionDone_disponly" rows="10" cols="100"><%=ActionTaken%></textarea>
--%>
<%
}
%>
										</div>
									</span>
									<span id="rr_showobj_<%=row.getValue(3)%>" style="display:inline">
									</span>
								</div>
							</td>
						</tr>
<%
}
%>
					</table>
<%
					}
					else {
//						semiColon = " : ";
%>

<%
					if (row.getValue(0).indexOf(":") > 0) {
						semiColon = " ";
					}
					else {
						semiColon = " : ";
					}
%>

<%
					if ("checked".equals(outVal)) {
%>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=row.getValue(0)%><br/>
<%
					}
					else {
						// show attachment link - 314, 305, 435
						if ("314".equals(row.getValue(3)) || "305".equals(row.getValue(3)) || "435".equals(row.getValue(3))) {
%>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<jsp:include page="../common/document_list.jsp">
							<jsp:param name="moduleCode" value="pireport" />
							<jsp:param name="keyID" value="<%=pirID%>" />
							<jsp:param name="docIDs" value="<%=outVal%>" />
							<jsp:param name="separator" value="" />
						</jsp:include>
<%
						}
						else {
%>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=row.getValue(0) + semiColon + outVal%><br/>
<%
						}
					}
%>
<%

					}
%>

<%
				}
			}
		}
	}
%>
</br>
<br/>

</div>



</DIV>
</DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
<script language="javascript">

	function showconfirm(cmd, stp) {
		$.prompt('Are you sure?',{
			buttons: { Ok: true, Cancel: false },
			callback: function(v,m,f){
				if (v ){
					submitAction2(cmd, stp);
				}
			},
			prefix:'cleanblue'
		});
		return false;
	}

	$().ready(function(){
		// set javascript for the new add comment
		$('#add1').click(function() {
			var options = $('#select1 option:selected');
			if (options.length == 1 && options[0].value != '') {
				return !$('#select1 option:selected').appendTo('#select2');
			} else {
				return false;
			}
		});
		$('#remove1').click(function() {
			return !$('#select2 option:selected').appendTo('#select1');
		});
		removeDuplicateItem('form1', 'responseByIDAvailable', 'toStaffID');
	});



	$(document).ready(function() {
		showInfoFlwUp('staff');
		}
	);

	function submitAction2(cmd, stp) {
		document.form1.command.value = cmd;
		document.form1.submit();
	}

	function showhide(i, hideobj, showobj, showhidelink, hidelink, showlink){
		var showelem = document.getElementById(showobj + i);
		var hideelem = document.getElementById(hideobj + i);
		var linkelem=document.getElementById(showhidelink + i);

		showelem.style.display=showelem.style.display=='none'?'inline':'none';
		hideelem.style.display=hideelem.style.display=='none'?'inline':'none';

		if (hideelem.style.display=='none'){
			linkelem.className="invisible";
			linkelem.innerHTML = showlink;
		} else {
			linkelem.className="visible";
			linkelem.innerHTML = hidelink;
		}
	}

	function removeEventflwup() {
		$('.removeFlwUpStaffInfo').unbind('click');
		$('.removeFlwUpStaffInfo').each(function() {
			$(this).click(function() {
			  if ($('div.ShowflwUpStaffInfo').length > 1) {
				$(this).parent().parent().parent().parent().parent().remove();
			}
			});
		});
	}

	function addEventflwup(target, type){
		$(target).each(function() {
			$(this).unbind('click');
			$(this).click(function() {
				showInfoFlwUp(type);
			});
		});
	}

	function showInfoFlwUp(type){
		var addBtn = '';
		if (type == 'staff'){
				Row = $('div#hiddenFlwUpStaffInfo').html();
				$('<div class="ShowflwUpStaffInfo" style="">'+Row+'</div>').appendTo('div#ShowflwUpStaffInfo');
				addBtn = '.AddFlwUpStaffInfo';
		}
		addEventflwup(addBtn, type);
		removeEventflwup();
		referKeyEvent();
	}

	// Popup window code
	function newPopup(url) {
		popupWindow = window.open(
			url,'popUpWindow','height=700,width=800,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
	}

</script>
</body>
<%
}
%>
</html:html>