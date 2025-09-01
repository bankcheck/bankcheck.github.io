<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private String parseDateStr(HttpServletRequest request, String label) {
		StringBuffer sqlStr = new StringBuffer();
		String date_yy = request.getParameter(label + "_yy");
		String date_mm = request.getParameter(label + "_mm");
		String date_dd = request.getParameter(label + "_dd");
		String date_hh = request.getParameter(label + "_hh");
		String date_mi = request.getParameter(label + "_mi");

		if (date_yy != null && date_yy.length() > 0
				&& date_mm != null && date_mm.length() > 0
				&& date_dd != null && date_dd.length() > 0) {
			if (date_dd.length() == 1) {
				sqlStr.append("0");
			}
			sqlStr.append(date_dd);
			sqlStr.append("/");
			if (date_mm.length() == 1) {
				sqlStr.append("0");
			}
			sqlStr.append(date_mm);
			sqlStr.append("/");
			sqlStr.append(date_yy);

			if (date_hh != null && date_hh.length() > 0
					&& date_mi != null && date_mi.length() > 0) {
				sqlStr.append(" ");
				sqlStr.append(date_hh);
				sqlStr.append(":");
				sqlStr.append(date_mi);
			}
		}
		return sqlStr.toString();
	}
%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String ls_patNo = (String) request.getParameter("patNo");
String ls_seqNo = (String) request.getParameter("seqNo");
String ls_patName = null;
String ls_patcName = null;
String ls_patTitelDesc = null;
String ls_patSex = null;
String ls_apptDate = null;
String ls_pathTel = null;
String ls_patoTel = null;
String ls_patPager = null;
String ls_docName = null;
String ls_docRmk = null;
String ls_patage = null;
String ls_docUpdateDate = null;
String ls_docUpdateUser = null;
String ls_appType = null;

String ls_recipt = null;
String ls_rmkPbo = null;
String ls_rmkNrs = null;
String ls_flwUpStatus = null;
String ls_flwUpDate = null;
String ls_cbSucess = CallBackClientDB.getMaxCBSuccess(ls_patNo,ls_seqNo);
String ls_cfmApptDate = null;
String ls_uptDate = null;
String ls_uptUser = userBean.getLoginID();

boolean createAction = false;
boolean updateAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	ls_recipt = request.getParameter("recipt");
	ls_rmkPbo = request.getParameter("rmkPbo");
	ls_rmkNrs = request.getParameter("rmkNrs");
	ls_flwUpStatus = request.getParameter("flwUpStatus");
	ls_flwUpDate = request.getParameter("flwUpDate");
	ls_cbSucess = request.getParameter("cbSucess");
	ls_cfmApptDate = request.getParameter("cfmApptDate");
	ls_uptDate = request.getParameter("uptDate");

	createAction = true;
} else if ("update".equals(command)) {
	ls_recipt = request.getParameter("recipt");
	ls_rmkPbo = request.getParameter("rmkPbo");
	ls_rmkNrs = request.getParameter("rmkNrs");
	ls_flwUpStatus = request.getParameter("flwUpStatus");
	ls_flwUpDate = request.getParameter("flwUpDate");
	ls_cbSucess = request.getParameter("cbSucess");
	ls_cfmApptDate = request.getParameter("cfmApptDate");
	ls_uptDate = request.getParameter("uptDate");

	updateAction = true;
}

try {
	if (createAction) {
		if (CallBackClientDB.add(userBean, ls_patNo, ls_seqNo, ls_recipt, ls_rmkPbo, ls_rmkNrs, ls_flwUpDate, ls_flwUpStatus, ls_cbSucess, ls_cfmApptDate)) {
			message = "history added.";
			createAction = false;
		} else {
			errorMessage = "history added fail.";
		}
	} else if (updateAction) {
		if (CallBackClientDB.update(userBean, ls_patNo, ls_seqNo, ls_recipt, ls_rmkPbo, ls_rmkNrs, ls_flwUpDate, ls_flwUpStatus, ls_cbSucess, ls_cfmApptDate, ls_uptUser, ls_uptDate)) {
			message = "history updated.";
			updateAction = false;
		} else {
			errorMessage = "history update fail.";
		}
	} else {
		errorMessage = "";
	}

	// load data from database
	if (ls_patNo != null && ls_seqNo != null && ls_patNo.length() > 0) {
		ArrayList record = CallBackClientDB.getPatDtl(ls_patNo,ls_seqNo);
		ReportableListObject row = (ReportableListObject) record.get(0);

		ls_patName = row.getValue(5);
		ls_patcName = row.getValue(8);
		ls_patTitelDesc = row.getValue(9);
		ls_patSex = row.getValue(10);
		ls_apptDate = row.getValue(2);
		ls_pathTel = row.getValue(11);
		ls_patoTel = row.getValue(12);
		ls_patPager = row.getValue(13);
		ls_docName = row.getValue(6);
		ls_docRmk = row.getValue(3);
		ls_patage = row.getValue(15);
		ls_docUpdateDate = row.getValue(14);
		ls_docUpdateUser = row.getValue(16);
		ls_appType = row.getValue(17);
	}
} catch (Exception e) {
	e.printStackTrace();
}

request.setAttribute("histList", CallBackClientDB.histList(ls_patNo,ls_seqNo));

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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<div id=indexWrapper>
<div id=mainFrame>
<div id=Frame>
<%
	String title = "function.callBackHist.client.list";
	String suffix = "_2";
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="suffix" value="<%=suffix %>" />
	<jsp:param name="category" value="admin" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.patNo" /></td>
		<td class="infoData2" width="30%"><%=ls_patNo==null?"":ls_patNo %></td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.patage" /></td>
		<td class="infoData2" width="30%"><%=ls_patage==null?"":ls_patage %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.patTitleDesc" /></td>
		<td class="infoData2" width="30%"><%=ls_patTitelDesc==null?"":ls_patTitelDesc %></td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.patSex" /></td>
		<td class="infoData2" width="30%"><%=ls_patSex==null?"":ls_patSex %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.pateName" /></td>
		<td class="infoData2" width="30%"><%=ls_patName %></td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.patcName" /></td>
		<td class="infoData2" width="30%"><%=ls_patcName==null?"":ls_patcName %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.mobilePhone" /></td>
		<td class="infoData2" width="30%"><%=ls_patPager==null?"":ls_patPager %></td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.homePhone" /></td>
		<td class="infoData2" width="30%"><%=ls_pathTel==null?"":ls_pathTel %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.officePhone" /></td>
		<td class="infoData2" width="30%"><%=ls_patoTel==null?"":ls_patoTel %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.docName" /></td>
		<td class="infoData2" width="80%" colspan=3><%=ls_docName==null?"":ls_docName %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.appointmentType" /></td>
		<td class="infoData2" width="30%"><%=ls_appType==null?"":ls_appType %></td>
		<td class="infoLabel" width="20%">Expected Appointment Date</td>
		<td class="infoData2" width="30%"><%=ls_apptDate==null?"":ls_apptDate %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.user" /></td>
		<td class="infoData2" width="30%"><%=ls_docUpdateUser==null?"":ls_docUpdateUser %></td>
		<td class="infoLabel" width="20%"><bean:message key="prompt.updatedDate" /></td>
		<td class="infoData2" width="30%"><%=ls_docUpdateDate==null?"":ls_docUpdateDate %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.docRmk" /></td>
		<td class="infoData2" width="80%" colspan=3><%=ls_docRmk==null?"":ls_docRmk %></td>
	</tr>
</table>
<hr noshade>
<bean:define id="functionLabel"><bean:message key="function.callBackHist.client.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="callBackHist.jsp" method="post">
			<span id="edit_indicator">
<jsp:include page="callHistAdd.jsp" flush="false" >
	<jsp:param name="ls_patName" value="<%=ls_patName %>" />
	<jsp:param name="as_cbSucess" value="<%=ls_cbSucess %>" />
</jsp:include>
			</span>
<hr noshade>
<display:table id="row" name="requestScope.histList" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
<%--
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
--%>
	<display:column property="fields14" title="" style="width:5%" />
	<display:column property="fields2" titleKey="prompt.patientName" style="width:8%" />
	<display:column property="fields3" titleKey="prompt.rmkPbo" style="width:15%" />
	<display:column property="fields4" titleKey="prompt.rmkNrs" style="width:15%" />
	<display:column property="fields5" titleKey="prompt.followUpDate" style="width:8%" />
	<display:column titleKey="prompt.followUpStatus" style="width:10%">
		<logic:equal name="row" property="fields12" value="0">
			Completed
		</logic:equal>
		<logic:equal name="row" property="fields12" value="1">
			Follow up by PBO
		</logic:equal>
		<logic:equal name="row" property="fields12" value="2">
			Follow up by nurse
		</logic:equal>
	</display:column>
	<display:column title="Outcome" style="width:5%">
		<logic:equal name="row" property="fields11" value="1">
			Success
		</logic:equal>
		<logic:equal name="row" property="fields11" value="2">
			Not Success
		</logic:equal>
		<logic:equal name="row" property="fields11" value="3">
			Previous Booked
		</logic:equal>
	</display:column>
	<display:column property="fields8" title="Appointment Confirmed Date" style="width:8%" />
	<display:column property="fields9" titleKey="prompt.user" style="width:8%" />
	<display:column property="fields13" titleKey="prompt.updatedDate" style="width:8%" />
	<display:column titleKey="prompt.action" media="html" style="width:5%; text-align:center">
		<button onclick="return editHist('update','<c:out value="${row.fields2}" />','<c:out value="${row.fields3}" />','<c:out value="${row.fields4}" />','<c:out value="${row.fields5}" />','<c:out value="${row.fields7}" />','<c:out value="${row.fields6}" />','<c:out value="${row.fields8}" />','<c:out value="${row.fields10}" />');"><bean:message key='button.edit' /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<input type="hidden" name="command" />
<input type="hidden" name="patNo" value="<%=ls_patNo %>" />
<input type="hidden" name="seqNo" value="<%=ls_seqNo %>" />
</form>
<script language="javascript">
	$(document).ready(function(){
		$('#flwUpDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#cfmApptDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
	});

	function submitAction(cmd) {
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.flwUpStatus.value == "0" && document.form1.cbSucess.value == "")
			{
				alert("Please select final outcome status, if follow up status is completed");
				document.form1.cbSucess.focus();
				return false;
			}

			if (document.form1.flwUpStatus.value != "0" && document.form1.flwUpDate.value == "")
			{
				alert("Please select follow up date");
				document.form1.flwUpDate.focus();
				return false;
			}

			if (document.form1.flwUpStatus.value != "0" && document.form1.cbSucess.value != "")
			{
				alert("Case is not completed. It should not have final outcome");
				document.form1.cbSucess.focus();
				return false;
			}

			if (document.form1.flwUpStatus.value == "0" && document.form1.flwUpDate.value != "")
			{
				alert("Completed case should not have follow up date");
				document.form1.flwUpDate.focus();
				return false;
			}

			if (document.form1.recipt.value == "") {
				alert("Empty call recipient.");
				document.form1.recipt.focus();
				return false;
			}

			if (document.form1.cbSucess.value == "1" && document.form1.cfmApptDate.value == "")
			{
				alert("Please select appointment date");
				document.form1.cfmApptDate.focus();
				return false;
			}
		}
		document.form1.command.value = cmd;
		document.form1.submit();
	}

	// ajax
	var http = createRequestObject();

	function editHist(cmd,rcpt,rmkpbo,rmknrs,fudate,fusts,cbss,cfadate,uptdate) {
		http.open('get', 'callHistAdd.jsp?as_command=' + cmd + '&as_recipt=' + rcpt + '&as_rmkPbo=' + rmkpbo + '&as_rmkNrs=' + rmknrs + '&as_flwUpDate=' + fudate + '&as_flwUpStatus=' + fusts + '&as_cbSucess=' + cbss + '&as_cfmApptDate=' + cfadate + '&as_updateDate=' + uptdate);
		//assign a handler for the response
		http.onreadystatechange = processResponseAppointmentDate;

		//actually send the request to the server
		http.send(null);

		return false;
	}

	function processResponseAppointmentDate() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			var response = http.responseText;

			//in this case simply assign the response to the contents of the <div> on the page.
			document.getElementById("edit_indicator").innerHTML = response;

			$('#flwUpDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
			$('#cfmApptDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		}

	}
</script>
</div>

</div></div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>