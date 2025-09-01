<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileReader" %>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="au.com.bytecode.opencsv.CSVReader"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.convert.Converter"%>

<%
UserBean userBean = new UserBean(request);

String eventID = ParserUtil.getParameter(request, "eventID");
String scheduleID = ParserUtil.getParameter(request, "scheduleID");
String loginID = userBean.getStaffID();
String courseDescription = null;
String classDate = null;
String classStartTime = null;
String classEndTime = null;
String classDuration = null;
String classSize = null;
String classEnrolled = null;
String requireAssessmentPass = null;
Locale locale = (Locale) session.getAttribute( Globals.LOCALE_KEY);

ArrayList group_enrollment = null;

String allowAll = userBean.isSuperManager() || userBean.isEducationManager() ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
String userDeptCode = userBean.getDeptCode() == null ? ConstantsVariable.EMPTY_VALUE : userBean.getDeptCode();

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");


try {
	if (eventID != null && eventID.length() > 0) {
		group_enrollment = EnrollmentDB.getEnrolledClass("christmas", eventID, scheduleID, null, null, null, null, null, null);
		request.setAttribute("group_enrollment", group_enrollment);
		System.out.println(group_enrollment.size());
	} else {
	}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<style>
<!--
.input-date-box { width: 220px; margin: 2px 0; border: 1px solid #e0dfe3; }
-->
</style>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.xmas.enrollment.list" />
	<jsp:param name="keepReferer" value="N" />
	<jsp:param name="accessControl" value="N"/>
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<bean:define id="functionLabel"><bean:message key="function.xmas.enrollment.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form>
<display:table id="row" name="requestScope.group_enrollment" export="true" pagesize="100" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)
		<input type="hidden" name="enrollIDs" value="<%=((ReportableListObject) pageContext.getAttribute("row")).getFields3() %>" />
	</display:column>
	<display:column titleKey="prompt.staffName" style="width:16%">
		<logic:equal name="row" property="fields23" value="0">
			<c:out value="${row.fields10}" />
		</logic:equal>
		<logic:notEqual name="row" property="fields23" value="0">
			<c:out value="${row.fields10}" /> - <c:out value="${row.fields21}" /> : <c:out value="${row.fields23}" />
		</logic:notEqual>
	</display:column>
	<%-- 
	<display:column titleKey="prompt.staffID" style="width:10%">
	 <c:out value="${row.fields9}" />
	</display:column>
	--%>
	<display:column titleKey="prompt.department" style="width:18%">
		<c:out value="${row.fields12}" />
	</display:column>
	
	<display:column titleKey="prompt.xmas.noofseat" style="width:8%">
		<logic:equal name="row" property="fields23" value="0">
			1
		</logic:equal>
		<logic:notEqual name="row" property="fields23" value="0">
			<c:out value="${row.fields23}" />
		</logic:notEqual>
	</display:column>
<% if (ConstantsServerSide.isHKAH()) { %>	
	<display:column titleKey="prompt.xmas.mealtype" style="width:8%">
		<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
			<logic:equal name="row" property="fields25" value="vege">
				素食者
			</logic:equal>
			<logic:notEqual name="row" property="fields25" value="vege">
				非素食者
			</logic:notEqual>
		<%} else {%>		
			<logic:equal name="row" property="fields25" value="vege">
				Vegetarian
			</logic:equal>
			<logic:notEqual name="row" property="fields25" value="vege">
				Non-Vegetarian
			</logic:notEqual>
		<%} %>
	</display:column>
	
	<display:column title="Shuttle bus to Kornhill 穿梭巴士前往康山" style="width:12%">
		<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
			<c:set var="staffID" value="${row.fields9}"/>
			<% String staffID = (String)pageContext.getAttribute("staffID");
				if(loginID.equals(staffID)){%>
					<logic:equal name="row" property="fields27" value="not-req">
						不乘坐
					</logic:equal>
					<logic:equal name="row" property="fields27" value="1815">
						18:15
					</logic:equal>
					<logic:equal name="row" property="fields27" value="1845">
						18:45
					</logic:equal>
				<% }else{ %>	
						
			<% } %>
		<%} else {%>	
			<c:set var="staffID" value="${row.fields9}"/>
			<% String staffID = (String)pageContext.getAttribute("staffID");
				if(loginID.equals(staffID)){%>
					<logic:equal name="row" property="fields27" value="not-req">
						Not Required
					</logic:equal>
					<logic:equal name="row" property="fields27" value="1815">
						18:15
					</logic:equal>
					<logic:equal name="row" property="fields27" value="1845">
						18:45
					</logic:equal>
				<% }else{ %>	
						
			<% } %>
			
		<%} %>
	</display:column>

	<display:column title="Shuttle bus to Hospital 穿梭巴士前往醫院" style="width:12%">
		<%if (Locale.TRADITIONAL_CHINESE.equals(locale) || Locale.SIMPLIFIED_CHINESE.equals(locale)) {%>
			<c:set var="staffID" value="${row.fields9}"/>
			<% String staffID = (String)pageContext.getAttribute("staffID");
			if(loginID.equals(staffID)){%>
				<logic:equal name="row" property="fields28" value="not-req">
					不乘坐
				</logic:equal>
				<logic:equal name="row" property="fields28" value="2145">
					21:45
				</logic:equal>
			<% }else{ %>	
					
			<% } %>
		<%} else {%>		
			<c:set var="staffID" value="${row.fields9}"/>
			<% String staffID = (String)pageContext.getAttribute("staffID");
			if(loginID.equals(staffID)){%>
				<logic:equal name="row" property="fields28" value="not-req">
					Not Required
				</logic:equal>
				<logic:equal name="row" property="fields28" value="2145">
					21:45
				</logic:equal>
			<% }else{ %>	
					
			<% } %>
		<%} %>
	</display:column>

<% } %>	
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<input type="hidden" name="command">
<input type="hidden" name="eventID" value="<%=eventID %>">
<input type="hidden" name="scheduleID" value="<%=scheduleID %>">
<input type="hidden" name="enrollID">
<input type="hidden" name="staffID">
</form>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
<script language="javascript">		
	function enrollFamilyAction(eid,sid,cid,staffid) {	
		callPopUpWindow("enroll_family.jsp?command=view&eventID=" + eid + "&scheduleID=" + sid + "&enrollID="+cid + "&staffID="+staffid);
		return false;
	}
	
	
</script>
