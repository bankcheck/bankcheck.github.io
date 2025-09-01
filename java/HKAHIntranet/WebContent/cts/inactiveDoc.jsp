<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String ls_ctsNO = request.getParameter("cts_no");
String ls_docCode = request.getParameter("docNo");
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

if ("search".equals(command)) {
	searchAction = true;	
} else if ("inactive".equals(command)) {
	inactAction = true;
}
try {
	if (searchAction) {
		ArrayList record = CTS.getDocList1(ls_docCode);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
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
			inactAction = true;
		} else {
			errorMessage = "No such doctor";					
			ls_fName = null;
			ls_gName = null;
			ls_docSex = null;
			ls_spCode = null;
			ls_docEmail = null;
			ls_corrAddr = null;				
			ls_startDate = null;
			ls_termDate = null;
			ls_isSurgeon = null;			
		}
	} else 	if (inactAction) {
		ls_ctsNO = CTS.addCtsRecord(userBean, null, ls_docCode, "D","S", null, null, null);
		if (ls_ctsNO!=null||ls_ctsNO.length()> 0) {
			message = "Doctor inactived.";
			createAction = false;
			searchAction = true;			
		} else {
			errorMessage = "Doctor inactived fail.";
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
<form name="form1" action="inactiveDoc.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.docNo" /></td>		
		<td class="infoData2" width="80%">			
			<input type="textfield" name="docNo" value="<%=ls_docCode==null?"":ls_docCode %>" maxlength="100" size="80"><t> 
			<button onclick="submitAction('search')"><bean:message key="button.search" /></button>						
		</td>
		
	</tr>
	<tr class="smallText">					
		<td class="infoLabel" width="20%"><bean:message key="prompt.docfName" /></td>
		<td class="infoData2" width="80%">			
			<input type="textfield" name="docfName" value="<%=ls_fName==null?"":ls_fName %>" maxlength="100" size="80" disabled=disabled>
		</td>
	</tr>
	<tr class="smallText">			
		<td class="infoLabel" width="20%"><bean:message key="prompt.docgName" /></td>
		<td class="infoData2" width="80%">
			<input type="textfield" name="docgName" value="<%=ls_gName==null?"":ls_gName %>" maxlength="100" size="80">		
		</td>
	</tr>
	<tr class="smallText">			
		<td class="infoLabel" width="20%"><bean:message key="prompt.docSex" /></td>
		<td class="infoData2" width="80%">
			<select name="docSex" >
				<option value="M">Male</option>
				<option value="F"<%="F".equals(ls_docSex)?" selected":"" %>>Female</option>
			</select>					
		</td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.spCode" /></td>
		<td class="infoData2" width="80%">
			<select name="spCode" >
			<jsp:include page="../ui/specCodeCMB.jsp" flush="false">
				<jsp:param name="spCode" value="<%=ls_spCode %>" />
			</jsp:include>
			</select>					
		</td>
	</tr>		
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.email" /></td>
		<td class="infoData2" width="80%">
			<input type="textfield" name="docEmail" value="<%=ls_docEmail==null?"":ls_docEmail %>" maxlength="100" size="80">		
		</td>
	</tr>	
	<tr class="smallText">	
		<td class="infoLabel" width="20%"><bean:message key="prompt.corrAddr" /></td>
		<td class="infoData2" width="80%">
			<input type="textfield" name="corrAddr" value="<%=ls_corrAddr==null?"":ls_corrAddr %>" maxlength="100" size="80">		
		</td>
	</tr>
	<tr class="smallText">		
		<td class="infoLabel" width="20%"><bean:message key="prompt.startDate" /></td>
		<td class="infoData2" width="80%">
			<input type="textfield" name="startDate" id="startDate" value="<%=ls_startDate==null?"":ls_startDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
		</td>					
	</tr>
	<tr class="smallText">		
		<td class="infoLabel" width="20%"><bean:message key="prompt.termDate" /></td>
		<td class="infoData2" width="80%">
			<input type="textfield" name="termDate" id="termDate" value="<%=ls_termDate==null?"":ls_termDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
		</td>					
	</tr>					
	<tr class="smallText">		
		<td class="infoLabel" width="20%"><bean:message key="prompt.initContactDate" /></td>
		<td class="infoData2" width="80%">
			<input type="textfield" name="initContactDate" id="initContactDate" value="<%=ls_initContactDate==null?"":ls_initContactDate %>" maxlength="20" size="20" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)
		</td>					
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.isSurgeon" /></td>
		<td class="infoData2" width="80%">                   
			<input type="checkbox" name="isSurgeon" id="isSurgeon" value="-1"<%="-1".equals(ls_isSurgeon)?" checked=checked":"" %> > 	
		</td>					
	</tr>	
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<% if(inactAction){%>		
				<button onclick="submitAction('inactive')"><bean:message key="function.cts.inactive" /></button>
			<% }%>
		</td>			
</table>	
<input type="hidden" name="command" />
<input type="hidden" name="docCode" value="<%=ls_docCode %>">
</form>
<script language="javascript">

	$().ready(function(){
		$('#initContactDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('#startDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });		
		$('#termDate').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });		
	});

	function submitAction(cmd) {	
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