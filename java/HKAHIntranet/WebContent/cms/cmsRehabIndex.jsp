<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String mode = ParserUtil.getParameter(request, "mode"); //create, view, update
String regid = ParserUtil.getParameter(request, "regid"); 
String userid = ParserUtil.getParameter(request, "userid");
String username = ParserUtil.getParameter(request, "username"); 
String patNo = ParserUtil.getParameter(request, "patno"); 
String action = ParserUtil.getParameter(request, "action");
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
<head>
</head>
	<body>
	<form name="form1" id="form1" action="PhyInitialAssFormOP.jsp" method="post">	
	<div style="margin:auto; display:block;">
	<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
	<table cellpadding="0" cellspacing="5" border="0" style="width:100%">
		<tr style="width:100%"><td>&nbsp;</td></tr>							
		<tr>
			<td align="center">
				<button type="button" onclick="submitAction('PIFOP')" style="text-decoration:none;font-size:30px;width:450px;height:100px;"class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Physiotherapy(Out-Patient) Initial Assessment Form</button>
			</td>
		</tr>	
		<tr style="width:100%"><td>&nbsp;</td></tr>			
		<tr>
			<td align="center">
				<button type="button" onclick="submitAction('RPN')" style="text-decoration:none;font-size:30px;width:450px;height:100px;"class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Rehabilitation Progress Notes</button>
			</td>
		</tr>	
	</table>	
	</div>
			<input type="hidden" id="mode" name="mode" value="<%=mode%>" />
			<input type="hidden" id="regid" name="regid" value="<%=regid%>" />
			<input type="hidden" id="patno" name="patno" value="<%=patNo%>" />
			<input type="hidden" id="action" name="action" value="<%=action%>" />
			<input type="hidden" id="userid" name="userid" value="<%=userid%>" />
			<input type="hidden" id="username" name="username" value="<%=username%>" />
	</form>			
	</body>
</html:html>
<script>
var url = "?";

url += "mode=<%=mode%>&";
url += "regid=<%=regid%>&";
url += "patno=<%=patNo%>&";
url += "action=<%=action%>&";
url += "userid=<%=userid%>&";
url += "username=<%=username%>&";
url += "command=<%=action%>&";

function openLink(type) {
	if(type == 'PIFOP') {
		window.open('../cms/PhyInitialAssFormOP.jsp'+url, '_blank');
	}
	else if(type == 'RPN') {
		window.open('../cms/RehabProgNotes.jsp'+url, '_blank');
	}
}


function submitAction(type) {
	if(type == 'PIFOP') {
		document.form1.action = "../cms/PhyInitialAssFormOP.jsp";
	}
	else if(type == 'RPN') {
		document.form1.action = "../cms/RehabProgNotes.jsp";
	}	
	  
	document.form1.submit();		

	return false;
}
</script>