<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
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
String ls_ctsNO = request.getParameter("cts_no");
String ls_docCode = request.getParameter("docCode");
String ls_fName = request.getParameter("docfName");
String ls_gName = request.getParameter("docgName");
String ls_docSex = request.getParameter("docSex");
String ls_spCode = request.getParameter("spCode");
String ls_docEmail = request.getParameter("docEmail");
String ls_corrAddr = request.getParameter("corrAddr");
String ls_startDate = request.getParameter("startDate");
String ls_termDate = request.getParameter("termDate");
String ls_initContactDate = request.getParameter("initContactDate");
String ls_isSurgeon = request.getParameter("isSurgeon");
String ls_recordType = CTS.getRecordType(ls_ctsNO);

if (ls_isSurgeon==null) {
	ls_isSurgeon = "0";
}

boolean createAction = false;
boolean updateAction = false;
boolean searchAction = false;
boolean inactAction = false;
boolean closeAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("view".equals(command)&& ls_ctsNO != null && ls_ctsNO.length() > 0) {
	searchAction = true;
} else if ("delete".equals(command)) {
	inactAction = true;
}
try {
	if (createAction) {
		ls_docCode = CTS.getNewDoc();
		if (ls_isSurgeon==null) {
			ls_isSurgeon = "0";
		}
//		ls_ctsNO = CTS.addDoc(	userBean, ls_docCode, ls_fName, ls_gName, ls_docSex, ls_spCode, ls_docEmail, ls_startDate, ls_termDate, ls_initContactDate, ls_corrAddr, ls_isSurgeon, null);
		if (ls_ctsNO!=null||ls_ctsNO.length()> 0) {
			message = "New Record added.";
			createAction = false;
			searchAction = true;
		} else {
			errorMessage = "Record added fail.";
		}
	} else if (updateAction) {
		if (CTS.updateDoc(userBean, ls_ctsNO, ls_fName, ls_gName, ls_docSex, ls_spCode, ls_docEmail, ls_startDate, ls_termDate, ls_initContactDate, ls_corrAddr, null, null, null, null, null, null, null, null, null, null, null, null, null, null, ls_isSurgeon, null, null, null, null, null, null)) {
			message = "Record updated.";
			updateAction = false;
			searchAction = true;
		} else {
			errorMessage = "Record update fail.";
			updateAction = true;
		}
	} else if (searchAction) {
		ArrayList record = CTS.getDocList(ls_ctsNO);
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			ls_docCode = row.getValue(0);
			ls_fName = row.getValue(1);
			ls_gName = row.getValue(2);
			ls_docSex = row.getValue(3);
			ls_spCode = row.getValue(4);
			ls_docEmail = row.getValue(5);
			ls_startDate = row.getValue(6);
			ls_termDate = row.getValue(7);
			ls_isSurgeon = row.getValue(8);
			ls_initContactDate = row.getValue(9);
			ls_corrAddr = row.getValue(11) + " " + row.getValue(12) + " " + row.getValue(13);

			request.setAttribute("cts_log", CTS.getRecordLog(ls_ctsNO));
		}
	} else if ("view1".equals(command)&& ls_docCode != null && ls_docCode.length() > 0) {
		ArrayList record = CTS.getDocList1(ls_ctsNO);
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			ls_docCode = row.getValue(0);
			ls_fName = row.getValue(1);
			ls_gName = row.getValue(2);
			ls_docSex = row.getValue(3);
			ls_spCode = row.getValue(4);
			ls_docEmail = row.getValue(5);
			ls_corrAddr = row.getValue(6);
			ls_startDate = row.getValue(7);
			ls_termDate = row.getValue(8);
			ls_isSurgeon = row.getValue(9);
		}
	} else {
		errorMessage = "";
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
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.cts.list" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.cts.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="newDoc.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.docNo" /></td>
		<td class="infoData2" width="80%">
		<%=ls_docCode==null?"":ls_docCode%>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.docfName" /></td>
		<td class="infoData2" width="80%">
		<%if ("N".equals(ls_recordType)){%>
			<input type="textfield" name="docfName" value="<%=ls_fName==null?"":ls_fName %>"
			maxlength="100" size="80"/>
		<%} else {%>
			<%=ls_fName==null?"":ls_fName%>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.docgName" /></td>
		<td class="infoData2" width="80%">
		<%if ("N".equals(ls_recordType)){%>
			<input type="textfield" name="docgName" value="<%=ls_gName==null?"":ls_gName %>"
			maxlength="100" size="80" />
		<%} else {%>
			<%=ls_gName==null?"":ls_gName%>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.docSex" /></td>
		<td class="infoData2" width="80%">
		<%if ("N".equals(ls_recordType)){%>
			<select name="docSex">
				<option value="M">Male</option>
				<option value="F"<%="F".equals(ls_docSex)?" selected":"" %>>Female</option>
			</select>
		<%} else if("M".equals(ls_docSex)){%>
			Male
		<%} else if("F".equals(ls_docSex)){%>
			Female
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.spCode" /></td>
		<td class="infoData2" width="80%">
			<select name="spCode" <%="N".equals(ls_recordType)?"":" disabled=disabled" %>>
			<jsp:include page="../ui/specCodeCMB.jsp" flush="false">
				<jsp:param name="spCode" value="<%=ls_spCode %>" />
			</jsp:include>
<%--<jsp:param name="ignoreDeptCode" value="880" /> --%>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.email" /></td>
		<td class="infoData2" width="80%">
		<%if ("N".equals(ls_recordType)){%>
			<input type="textfield" name="docEmail" value="<%=ls_docEmail==null?"":ls_docEmail %>"
			maxlength="100" size="80"/>
		<%} else {%>
			<%=ls_docEmail==null?"":ls_docEmail%>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.corrAddr" /></td>
		<td class="infoData2" width="80%">
		<%if ("N".equals(ls_recordType)){%>
			<input type="textfield" name="corrAddr" value="<%=ls_corrAddr==null?"":ls_corrAddr %>"
			maxlength="100" size="80"/>
		<%} else {%>
			<%=ls_corrAddr==null?"":ls_corrAddr%>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.startDate" /></td>
		<td class="infoData2" width="80%">
		<%if ("N".equals(ls_recordType)){%>
			<input type="textfield" name="startDate" id="startDate" value="<%=ls_startDate==null?"":ls_startDate %>"
			maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
		<%} else {%>
			<%=ls_startDate==null?"":ls_startDate%>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.termDate" /></td>
		<td class="infoData2" width="80%">
		<%if ("N".equals(ls_recordType)){%>
			<input type="textfield" name="termDate" id="termDate" value="<%=ls_termDate==null?"":ls_termDate %>"
			maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
		<%} else {%>
			<%=ls_termDate==null?"":ls_termDate%>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.initContactDate" /></td>
		<td class="infoData2" width="80%">
		<%if ("N".equals(ls_recordType)){%>
			<input type="textfield" name="initContactDate" id="initContactDate" value="<%=ls_initContactDate==null?"":ls_initContactDate %>"
			maxlength="20" size="20" <%="view".equals(command)?" disabled=disabled":"" %> onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
		<%} else {%>
			<%=ls_initContactDate==null?"":ls_initContactDate%>
		<%} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.isSurgeon" /></td>
		<td class="infoData2" width="80%">
			<input type="checkbox" name="isSurgeon" id="isSurgeon" value="-1" <%="-1".equals(ls_isSurgeon)?" checked=checked":"" %>
			<%="view".equals(command)?" disabled=disabled":"" %>/>
		</td>
	</tr>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<% if(searchAction && "N".equals(ls_recordType)){%>
				<button onclick="submitAction('update')"><bean:message key="function.cts.update" /></button>
			<%} else if(updateAction) {%>
				<button onclick="submitAction('update')"><bean:message key="function.cts.update" /></button>
			<%} else if ("view1".equals(command)&& ls_docCode != null && ls_docCode.length() > 0) {%>
				<button onclick="submitAction('delete')"><bean:message key="function.cts.update" /></button>
			<%} else if ("view".equals(command)) {%>
			<%System.err.println("view");%>
			<%} else {%>
				<button onclick="submitAction('create');"><bean:message key="function.cts.create" /></button>
			<% }%>
		</td>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td class="infoLabe2" width="100%" align="center"><bean:message key="prompt.recordLog" /></td>
	</tr>
</table>
<display:table id="row" name="requestScope.cts_log" export="false" pagesize="" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%></display:column>
	<display:column property="fields0" title="CTS NO." style="width:10%" />
	<display:column property="fields1" title="Record Status" style="width:25%" />
	<display:column property="fields4" title="Remarks" style="width:20%" />
	<display:column property="fields2" title="Update By" style="width:20%" />
	<display:column property="fields3" title="Update Date" style="width:20%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<input type="hidden" name="command" />
<input type="hidden" name="cts_no" value="<%=ls_ctsNO %>">
<input type="hidden" name="docCode" value="<%=ls_docCode %>">
</form>
<script language="javascript">

	$().ready(function(){
		$('#initContactDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#startDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#termDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
	});

	function submitAction(cmd) {
		if (cmd=='create'||cmd=='update'){
			if (document.form1.docfName.value == '') {
				alert('Please enter first name');
				document.form1.docfName.focus();
				return false;
			}
			if (document.form1.docgName.value == '') {
				alert('Please enter given name');
				document.form1.docgName.focus();
				return false;
			}
			if (document.form1.docEmail.value == '') {
				alert('Please enter email');
				document.form1.docEmail.focus();
				return false;
			}
			if (document.form1.corrAddr.value == '') {
				alert('Please enter corresponding address');
				document.form1.corrAddr.focus();
				return false;
			}
		}

		document.form1.command.value = cmd;
		document.form1.submit();
		return false;
	}

	// ajax
	var http = createRequestObject();

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