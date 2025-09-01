<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
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
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>

<c:if test="${education == null}">
	<c:redirect url="contact.htm" />
</c:if>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<c:set var="pageTitle" value="Contact" />
<jsp:useBean id="pageTitle" class="java.lang.String" />
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="isHideTitle" value="Y" />
	<jsp:param name="keepReferer" value="Y" />
</jsp:include>
<style>
#main-content { margin: 10px; font-size: 120%; }
</style>

<font color="blue"><c:out value="${education.message}"/></font>
<font color="red"><c:out value="${education.errorMessage}"/></font>
<div style='background-image: url(../images/pink_effect_fill.png);background-size:auto'>
<form name="form1" method="post">
	<table border="0" style="width:100%">
		<tr style="text-align: right;">
				<td colspan="2"><a  href="reminder.jsp"><b>Staff Education Home</b></a></td>
			</tr>
			<tr style="font-size:150%" bgcolor="rgb(216, 174, 91)">
				<td style="color:rgb(0, 51, 204)" colspan="2" class="bold">
					<%=pageTitle %>&nbsp;<c:out value="${education.eeMenuModule.eeDescriptionZh}"/>
				</td>
		</tr>	
		<tr ><td>
	<div id="staffEducationWrapper">
		<div id="contentPage">		
		<table>
		<tr style="background-color:#FF69B4;"><td colspan="2">	
			<p><b>For any questions/ comments about this webpage, feel free to contact Staff Education Coordinator (Phone no. 2276 7122) / Secretary (Phone no. 2276 7123) or e-mail <a  style="color:white" href="mailto:scarlet.szeto@twah.org.hk">scarlet.szeto@twah.org.hk</a>.</b></p>
		</td></tr>
		<tr>
		<td style="background-color:#FF69B4;" colspan="2">	
			<div id="main-content">
				<p style="font-size:150%" class="bold">Scarlet SZETO</p>
				<p class="bold">Staff Education Coordinator</p>
				<br/>
				<p class="bold italic">Hong Kong Adventist Hospital - Tsuen Wan</p>
				<p class="bold">Phone no. 2276 7122</p>
				<p class="bold"><font color="red">Fax no. 2275 6446</font></p>
				<p class="bold">E-mail: <a style="color:white" href="mailto:scarlet.szeto@twah.org.hk">scarlet.szeto@twah.org.hk</a></p>
				<p class="bold"><a style="color:white" href="http://www.twah.org.hk" target="_blank">www.twah.org.hk</a></p>
			</div>			
		</td>
		<!-- 
		<td style="background-color:#FF69B4;">	
			<div id="main-content">
				<p style="font-size:150%" class="bold">Peter Chuk</p>
				<p class="bold">Health Education/ Research</p>
				<br/>
				<p class="bold italic">Hong Kong Adventist Hospital- Stubbs Road</p>
				<p class="bold">Tel: (852) 2835 1504 (Tue, Thu)</p>
				<p class="bold">Mobile: (852) 9027 7934</p>
				<p class="bold">Fax: (852) <font color="red">2276 7740</font></p>
				<p class="bold">E-mail: <a style="color:white" href="mailto:peter.chuk@hkah.org.hk">peter.chuk@hkah.org.hk</a></p>
				<p class="bold"><a style="color:white" href="http://www.hkah.org.hk" target="_blank">www.hkah.org.hk</a></p>
			</div>			
		</td>
		 -->
		</tr></table>
		</div>
	</div>
	<input type="hidden" name="documentID" />
	<input type="hidden" name="moduleCode" value="<c:out value='${education.moduleCode}' />" />
	<input type="hidden" name="keyID" />
	</td></tr></table>
</form>
<div style="margin: 10px 0;">
	<p class="mottoText">Extending the Healing Ministry of Christ</p>
	<p class="mottoText">延續基督的醫治大能</p>
</div>
</div>
</DIV>

</DIV></DIV>
<script language="javascript">
<!--
	function downloadDocument(keyID, documentID) {
		document.forms["form1"].action = "../documentManage/download.jsp";
		document.forms["form1"].elements["keyID"].value = keyID;
		document.forms["form1"].elements["documentID"].value = documentID;
		document.forms["form1"].submit();
		return false;
	}
	
	function submitAction(cmd, level) {
		var moduleCode = document.forms["form1"].elements["moduleCode"].value;
		callPopUpWindow("menu_list.htm?moduleCode=" + moduleCode + "&command=" + cmd + "&level=" + level);
		return false;
	}
-->
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>