<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.*"%>
<%
String source = request.getParameter("source");
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
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<center>
<table width="700" border="0" cellpadding="0" cellspacing="0">
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
<form name="form1" action="ob_booking_list.jsp" method="post">
<table width="700" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td align="center">
		<b class="b1"></b><b class="b2"></b><b class="b3"></b><b class="b4"></b>
		<div class="contentb">
			<table width="690" border="0" cellpadding="0" cellspacing="0" style="background-color:white;">
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td height="50">&nbsp;</td>
							</tr>
							<tr>
								<td valign="top" align="left">
									<p><span class="admissionLabel bigText">As instructed by the Department of Health, please indicate your consent for the release of patients' data to the Department of Health by clicking "Agree"</span></p>
									<p><span class="admissionLabel bigText">&nbsp;</span></p>
								</td>
							</tr>
							<tr>
								<td height="50">&nbsp;</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<div class="pane">
							<table width="100%" border="0">
								<tr>
									<td align="center">
										<button onclick="submitAction();return false;" class="btn-click">Agree</button>
										<button onclick="submitBack();return false;" class="btn-click">Disagree</button>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			</table>
		</div>
		<b class="b4"></b><b class="b3"></b><b class="b2"></b><b class="b1"></b>
	</td>
</tr>
</table>
<input type="hidden" name="agree" value="Y">
<input type="hidden" name="source" value="<%=source %>">
</form>
</center>
<script language="javascript">
<!--//
	function submitAction() {
		document.form1.submit();
	}

	function submitBack() {
		document.form1.action = "../index.jsp";
		document.form1.submit();
	}
//-->
</script>
</body>
</html:html>