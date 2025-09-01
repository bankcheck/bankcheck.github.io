<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>

<%
UserBean userBean = new UserBean(request);

String dateFrom = request.getParameter("date_from");
String dateTo = request.getParameter("date_to");
String patNo = request.getParameter("patNo");
String fName = request.getParameter("fName");
String gName = request.getParameter("gName");

int current_yy = DateTimeUtil.getCurrentYear();
int current_mm = DateTimeUtil.getCurrentMonth();
int current_dd = DateTimeUtil.getCurrentDay();

if(dateFrom == null || dateFrom.length() == 0) {
	dateFrom = current_dd + "/" + current_mm + "/" + current_yy;
}

if(dateTo == null || dateTo.length() == 0) {
	dateTo = current_dd + "/" + current_mm + "/" + current_yy;
}

request.setAttribute("surveyList",
		ReportDB.getReport("survey", dateFrom, dateTo,patNo,fName,gName));
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
	<body>
		<div id=indexWrapper>
			<div id=mainFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="function.mr.survey.list" />
					<jsp:param name="keepReferer" value="Y" />
					<jsp:param name="accessControl" value="Y"/>
				</jsp:include>
				
				<bean:define id="functionLabel"><bean:message key="function.mr.survey.list" /></bean:define>
				<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
				
				<form name="searchform" action="survey_list.jsp" method="get">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
						<tr>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.date" />
							</td>
							<td class="infoData" width="35%">
								<input type="textfield" name="date_from" id="date_from" 
									class="datepickerfield" value="<%=dateFrom==null?"":dateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
								-
								<input type="textfield" name="date_to" id="date_to" 
									class="datepickerfield" value="<%=dateTo==null?"":dateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="30%">Patient No.</td>
							<td class="infoData" width="70%"><input type="textfield" name="patNo" value="<%=patNo==null?"":patNo %>" maxlength="100" size="50"></td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="30%">Family Name</td>
							<td class="infoData" width="70%"><input type="textfield" name="fName" value="<%=fName==null?"":fName %>" maxlength="100" size="50"></td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="30%">Given Name</td>
							<td class="infoData" width="70%"><input type="textfield" name="gName" value="<%=gName==null?"":gName %>" maxlength="100" size="50"></td>
						</tr>
						<tr class="smallText">
							<td colspan="2" align="center">
								<button onclick="submitSearch()">
									<bean:message key="button.search" />
								</button>
								<button onclick="clearSearch()">
									<bean:message key="button.clear" />
								</button>
								<input type="hidden" name="command" />
							</td>
						</tr>
					</table>
				</form>
				
				<display:table id="row" name="requestScope.surveyList" export="true" 
							pagesize="<%=userBean.getNoOfRecPerPage() %>" class="generaltable">
					<display:column property="fields12" title="Survey Name" style="width:8%" />
					<display:column property="fields13" title="Patient No." style="width:8%" />
					<display:column property="fields14" title="Family Name" style="width:8%" />
					<display:column property="fields15" title="Given Name" style="width:8%" />
					<display:column property="fields5" title="Create Date" style="width:8%" />
					<display:column property="fields10" title="Create User" style="width:8%" />
					<display:column titleKey="prompt.action" media="html" style="width:5%; text-align:center">
						<button onclick="viewSurvey('<c:out value="${row.fields1}" />')"><bean:message key='button.view' /></button>
					</display:column>
					<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
				</display:table>
				
<%
				if(userBean.isAccessible("function.mr.survey.new")) {
%>
					<table align="center">
						<tr class="smallText">
								<td colspan="2" align="center">
									<button onclick="createSurvey()">
										Create Survey
									</button>
								</td>
						</tr>
					</table>
<%
				}
%>
				
				<script language="javascript">
					function submitSearch() {
						document.searchform.command.value = 'search';
						document.searchform.submit();
					}
					
					function clearSearch() {
						document.searchform.date_from.value="";
						document.searchform.date_to.value="";
						document.searchform.patNo.value="";
						document.searchform.fName.value="";
						document.searchform.gName.value="";
					}
					
					function createSurvey() {
						callPopUpWindow('../mr/survey.jsp');
					}
					
					function viewSurvey(reportID) {
						callPopUpWindow('../mr/survey.jsp?act=view&reportID='+reportID);
					}
				</script>
			</div>
		</div>
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>