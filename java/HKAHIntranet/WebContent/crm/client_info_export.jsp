<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.fop.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String step = request.getParameter("step");
String siteCode = request.getParameter("siteCode");
String deptCode = request.getParameter("deptCode");
String[] clubID = request.getParameterValues("clubID");
String[] educationLevel = request.getParameterValues("educationLevel");
String[] sex = request.getParameterValues("sex");
String[] ageGroup = request.getParameterValues("ageGroup");
String[] districtID = request.getParameterValues("districtID");
String[] areaID = request.getParameterValues("areaID");
String[] interestIDHobby = request.getParameterValues("interestIDHobby");
String[] interestIDHospital = request.getParameterValues("interestIDHospital");
String[] medicalIDIndividual = request.getParameterValues("medicalIDIndividual");
String[] medicalIDFamily = request.getParameterValues("medicalIDFamily");
String exportType = request.getParameter("exportType");
boolean skipEmptyAddress = !"N".equals(request.getParameter("skipEmptyAddress"));

// set default value
if (siteCode == null) {
	siteCode = userBean.getSiteCode();
}
if (deptCode == null) {
	deptCode = userBean.getDeptCode();
}

ArrayList record = null;
StringBuffer pdfUrl = null;
boolean printOut = false;
if (step != null) {
	record = CRMClientDB.getList(userBean, siteCode, deptCode, clubID, sex, districtID, areaID, ageGroup, educationLevel,
		interestIDHobby, interestIDHospital, medicalIDIndividual, medicalIDFamily, skipEmptyAddress);
	request.setAttribute("client_list", record);

	// create pdf
	String foFilePath = ConstantsServerSide.TEMP_FOLDER + "/label.fo";
	String footer = (siteCode!=null?siteCode.toUpperCase():"") + "-" + (deptCode!=null?deptCode.toUpperCase():"") + "-" + DateTimeUtil.getCurrentDate();
	if ("8220".equals(exportType)) {
		Label_8220.toXMLfile(session, record, foFilePath, footer);
		printOut = true;
	} else if ("L7160".equals(exportType)) {
		Label_L7160.toXMLfile(session, record, foFilePath, footer);
		printOut = true;
	}

	if (printOut) {
		// Write Respond to HTML
		pdfUrl = new StringBuffer();
	
		String contentPath = request.getContextPath();
		String absolutePath = request.getRequestURL().toString();
		pdfUrl.append(absolutePath.substring(0, absolutePath.indexOf(contentPath) + contentPath.length()));
	
		pdfUrl.append("/FopServlet?fo=");
		pdfUrl.append(foFilePath);
		pdfUrl.append("&seqno=");
		pdfUrl.append((new Date()).getTime());
	}
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
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.client.export" />
	<jsp:param name="category" value="group.crm" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="client_info_export.jsp" method="post" onsubmit="return submitSearch();">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.category" /></td>
		<td class="infoData" width="35%">
			<select name="clubID" id="clubID" size="3" multiple>
<jsp:include page="../ui/clubIDCMB.jsp" flush="false">
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.educationLevel" /></td>
		<td class="infoData" width="35%">
			<select name="educationLevel" id="educationLevel" size="3" multiple>
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="education" />
	<jsp:param name="parameterValueName" value="educationLevel" />
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.sex" /></td>
		<td class="infoData" width="35%">
			<select name="sex" id="sex" size="3" multiple>
<jsp:include page="../ui/sexCMB.jsp" flush="false" />
			</select>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.ageGroup" /></td>
		<td class="infoData" width="35%">
			<select name="ageGroup" id="ageGroup" size="3" multiple>
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="ageGroup" />
	<jsp:param name="parameterValueName" value="ageGroup" />
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.district" /></td>
		<td class="infoData" width="35%">
			<select name="districtID" id="districtID" size="3" multiple>
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="district" />
	<jsp:param name="parameterValueName" value="districtID" />
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.area" /></td>
		<td class="infoData" width="35%">
			<select name="areaID" id="areaID" size="3" multiple>
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="area" />
	<jsp:param name="parameterValueName" value="areaID" />
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.interestHospital" /></td>
		<td class="infoData" width="35%">
			<select name="interestIDHospital" id="interestIDHospital" size="3" multiple>
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="hospitalFacility" />
	<jsp:param name="parameterValueName" value="interestIDHospital" />
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.interestHobby" /></td>
		<td class="infoData" width="35%">
			<select name="interestIDHobby" id="interestIDHobby" size="3" multiple>
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="hobby" />
	<jsp:param name="parameterValueName" value="interestIDHobby" />
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.medicalRecordIndividual" /></td>
		<td class="infoData" width="35%">
			<select name="medicalIDIndividual" id="medicalIDIndividual" size="3" multiple>
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="medical" />
	<jsp:param name="parameterValueName" value="medicalIDIndividual" />
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.medicalRecordFamily" /></td>
		<td class="infoData" width="35%">
			<select name="medicalIDFamily" id="medicalIDFamily" size="3" multiple>
<jsp:include page="../ui/parameterCMB.jsp" flush="false">
	<jsp:param name="parameterType" value="medical" />
	<jsp:param name="parameterValueName" value="medicalIDFamily" />
	<jsp:param name="allowEmpty" value="N" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.allowView"/><br>(<bean:message key="prompt.site" />)</td>
		<td class="infoData" width="35%">
			<input type="radio" name="siteCode" value="" checked><bean:message key="label.all" /><BR>
			<input type="radio" name="siteCode" value="<%=ConstantsServerSide.SITE_CODE_HKAH %>"<%=ConstantsServerSide.SITE_CODE_HKAH.equals(siteCode)?" checked":"" %>><bean:message key="label.hkah" /><BR>
			<input type="radio" name="siteCode" value="<%=ConstantsServerSide.SITE_CODE_TWAH %>"<%=ConstantsServerSide.SITE_CODE_TWAH.equals(siteCode)?" checked":"" %>><bean:message key="label.twah" />
		</td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.allowView"/><br>(<bean:message key="prompt.department" />)</td>
		<td class="infoData" width="35%">
			<input type="radio" name="deptCode" value="" checked><bean:message key="label.all" /><BR>
			<input type="radio" name="deptCode" value="520"<%="520".equals(deptCode)?" checked":"" %>><bean:message key="department.520" /><BR>
			<input type="radio" name="deptCode" value="660"<%="660".equals(deptCode)?" checked":"" %>><bean:message key="department.660" /><BR>
			<input type="radio" name="deptCode" value="670"<%="670".equals(deptCode)?" checked":"" %>><bean:message key="department.670" /><BR>
			<input type="radio" name="deptCode" value="750"<%="750".equals(deptCode)?" checked":"" %>><bean:message key="department.750" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Ignore Empty Address</td>
		<td class="infoData" width="35%">
			<input type="radio" name="skipEmptyAddress" value="Y"<%=skipEmptyAddress?" checked":"" %>><bean:message key="label.yes" />
			<input type="radio" name="skipEmptyAddress" value="N"<%=!skipEmptyAddress?" checked":"" %>><bean:message key="label.no" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Export Format</td>
		<td class="infoData" width="35%">
			<select name="exportType">
				<option value="">Display Only</option>
				<option value="L7160"<%="L7160".equals(exportType)?" selected":"" %>>Avery L7160</option>
				<option value="8220"<%="8220".equals(exportType)?" selected":"" %>>Herma-8220</option>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="4" align="center">
			<button type="submit"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="step" value="1">
</form>
<form name="form1" action="client_info.jsp" method="post">
<%if (step != null && !printOut) { %>
<bean:define id="functionLabel"><bean:message key="function.client.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.client_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column titleKey="prompt.name" style="width:10%">
		<logic:equal name="row" property="fields1" value="">
			<c:out value="${row.fields2}" />
		</logic:equal>
		<logic:notEqual name="row" property="fields1" value="">
			<logic:equal name="row" property="fields2" value="">
				<c:out value="${row.fields1}" />
			</logic:equal>
			<logic:notEqual name="row" property="fields2" value="">
				<c:out value="${row.fields1}" />, <c:out value="${row.fields2}" />
			</logic:notEqual>
		</logic:notEqual>
	</display:column>
	<display:column property="fields3" titleKey="prompt.chineseName" style="width:10%" />
	<display:column property="fields4" titleKey="prompt.hkid" style="width:10%" />
	<display:column titleKey="prompt.street" style="width:15%">
		<c:out value="${row.fields5}" /> <c:out value="${row.fields6}" /> <c:out value="${row.fields7}" /> <c:out value="${row.fields8}" />
	</display:column>
	<display:column property="fields9" titleKey="prompt.mobilePhone" style="width:10%" />
	<display:column property="fields12" titleKey="prompt.email" style="width:10%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<%} else if (printOut) { %>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('generate', '');"><bean:message key="button.print" /> to <%=exportType!=null?exportType.toUpperCase():"Label" %></button></td>
	</tr>
</table>
<%} %>
</form>
<script language="javascript">
<!--
	function submitSearch() {
		return true;
	}

	function clearSearch() {
		$('#clubID option').each(function(i) {
			$(this).attr("selected", "");
		});
		$('#sex option').each(function(i) {
			$(this).attr("selected", "");
		});
		$('#districtID option').each(function(i) {
			$(this).attr("selected", "");
		});
		$('#areaID option').each(function(i) {
			$(this).attr("selected", "");
		});
		$('#ageGroup option').each(function(i) {
			$(this).attr("selected", "");
		});
		$('#educationLevel option').each(function(i) {
			$(this).attr("selected", "");
		});
		$('#interestIDHobby option').each(function(i) {
			$(this).attr("selected", "");
		});
		$('#interestIDHospital option').each(function(i) {
			$(this).attr("selected", "");
		});
		$('#medicalIDIndividual option').each(function(i) {
			$(this).attr("selected", "");
		});
		$('#medicalIDFamily option').each(function(i) {
			$(this).attr("selected", "");
		});
	}

	function submitAction(cmd, cid) {
		if (cmd == 'view') {
			callPopUpWindow(document.form1.action + "?command=" + cmd + "&clientID=" + cid);
		} else if (cmd == 'generate') {
			callPopUpWindow('<%=pdfUrl %>');
		}
		return false;
	}
-->
</script>

</DIV>

</DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>