<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String password = request.getParameter("pwd");
String command = request.getParameter("command");
String ctsNo = ParserUtil.getParameter(request, "ctsNo");
String docCode = ParserUtil.getParameter(request, "docCode");
String siteCode = ParserUtil.getParameter(request, "siteCode");
if (siteCode == null || siteCode.length() == 0) {
	siteCode = ConstantsServerSide.SITE_CODE;
}

String rtnFlag = null;
String ctsStatus = null;

boolean submitAction = false;

if ("submit".equals(command)) {
	submitAction = true;
}

try {
	if (submitAction) {
		// load data from database
					System.err.println("[ctsNo]:"+ctsNo+";[password]:"+password);
		if (ctsNo != null&&ctsNo.length() > 0&&password != null&&password.length() > 0) {
			ctsNo = ctsNo.toUpperCase();
			docCode = CTS.checkRenewRecord(ctsNo,password);
			ctsStatus = CTS.getRecordStatus(ctsNo);
			System.err.println("[docCode]:"+docCode+";[ctsStatus]:"+ctsStatus);
		}

		if (docCode != null && submitAction) {
			if ("S".equals(ctsStatus)||"X".equals(ctsStatus)||"Y".equals(ctsStatus)||"Z".equals(ctsStatus)||
					"I".equals(ctsStatus)||"L".equals(ctsStatus)||"K".equals(ctsStatus)) {
				rtnFlag = "1"; // valid status and correct password
			}else{
				rtnFlag = "2"; // invalid status
			}
		}else{
			rtnFlag = "0"; // invalid status
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
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
<body style="height:100%">
<div id=indexWrapper>
<div id=contentFrame1>

<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.cts.renew" />
	<jsp:param name="category" value="group.cts" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="pageMap" value="N" />
	<jsp:param name="isHideTitle" value="Y" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel">
<bean:message key="function.cts.renew" />
</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="renewForm.jsp" method="post" >
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="left">
	<tr style="background-color:#FFFFFF">
<%if ("twah".equals(siteCode)) {%>
		<td align="left"><img src="../images/Horizontal_billingual_HKAH_TW.jpg" border="0" width="632" height="110" /></td>
<%}else{%>
		<td align="left"><img src="../images/Horizontal_billingual_HKAH_HK.jpg" border="0" width="647" height="110" /></td>
<%}%>
		<td align="right"><div style="color:#FFFFFF" width="528" height="110"> </div></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
<table cellpadding="0" cellspacing="5" border="0" style="width:100%">
	<tr class="smallText">
		<td width="3%"></td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.rctsNo" /></td>
		<td class="infoData" width="35%"><input type="textfield" name="ctsNo" value="<%=ctsNo==null?"":ctsNo %>" maxlength="10" size="50"></td>
	</tr>
	<tr class="smallText">
		<td width="3%"></td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.password" /></td>
		<td class="infoData" width="35%"><input type="textfield" name="pwd" value="<%=password==null?"":password %>" maxlength="10" size="50" onkeypress="return submitAction('submit',event);"></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td width="3%"></td>
		<td width="15%"></td>
		<td align="left" width="35%">
			<button onclick="return submitAction('submit',null);">Enter</button>
		</td>
	</tr>
</table>
<table height="500px" width="800" border="0" cellpadding="0" cellspacing="0" align="left">
	<tr>
		<td colspan=3>
		</td>
	</tr>
</table>
<input type="hidden" name="command"/>
<input type="hidden" name="docCode" value="<%=docCode==null?"":docCode %>"/>
<input type="hidden" name="siteCode" value="<%=siteCode==null?"":siteCode %>"/>
</form>
<script language="javascript">
	function submitAction(cmd,e) {
		document.form1.command.value = cmd;

		if (cmd=='submit' && (e==null || e.keyCode==13)){
			if (document.form1.ctsNo.value == '') {
				alert('Please enter renewal record NO.');
				document.form1.ctsNo.focus();
				return false;
			}else{
				var ctsNo = document.form1.ctsNo.value;
			}
			if (document.form1.pwd.value == '') {
				alert('Please enter password');
				document.form1.pwd.focus();
				return false;
			}else{
				var pwd = document.form1.pwd.value;
			}

			$.ajax({
				type: "POST",
				url: "cts_hidden.jsp",
				data: 'p1=1&p2=' + ctsNo + '&p3=' + pwd,
				async: false,
				success: function(values){
				if(values != '') {
					if(values.substring(0, 1) == 1) {
						rtnVal = true;
						document.form1.command.value = 'view';
						document.form1.submit();
					}else if(values.substring(0, 1) == 2){
						alert('Cannot access after submit !');
						document.form1.ctsNo.focus();
						rtnVal = false;
					}else if (values.substring(0, 1) == 0){
						alert('Invalid CTS Number or password. Please enter again!');
						document.form1.pwd.focus();
					}
				}else{alert('null value');}//if
				}//success
			});//$.ajax

			return false;
		}
	}
/*
	function submitSearch() {
		var as_ctsNo = document.form1.ctsNo.value;
		var as_password = document.form1.pwd.value;

		$.ajax({
			type: "POST",
			url: "cts_hidden.jsp",
			data: 'ctsNo=' + as_ctsNo + '&password=' + as_password,
			success: function(values){
			if(values != '') {
				if (values.substring(0, 1) == 1) {
					document.form1.ctsNo.value = "";
					document.form1.pwd.value = "";
					callPopUpWindowMX("../cts/renewForm.jsp?ctsNo="+as_ctsNo);
				} else if (values.substring(0, 1) == 0) {
					alert('Invalid CTS Number or password. Please enter again!');
					document.form1.pwd.focus();
					return false;
				} else if (values.substring(0, 1) == 2) {
					alert('Cant access after submit !');
					document.form1.ctsNo.focus();
					return false;
				}
			}//if
			}//success
		});//$.ajax
	}
*/

	function clearSearch() {
		return false;
	}

	function closeAction() {
		window.close();
	}
</script>
</div></div>
<div id="bottom-content">Version Oct 2015</div>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>