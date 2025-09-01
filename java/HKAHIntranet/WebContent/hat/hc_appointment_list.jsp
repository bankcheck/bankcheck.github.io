<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<%
UserBean userBean = new UserBean(request);

String startDate = ParserUtil.getParameter(request, "startDate");
String endDate = ParserUtil.getParameter(request, "endDate");
String bStatus = request.getParameter("bStatus");

if (startDate == null || startDate.length() <= 0) {
	startDate = DateTimeUtil.getCurrentDate();
}

if (endDate == null || endDate.length() <= 0) {
	endDate = DateTimeUtil.getCurrentDate();
}

ArrayList record = PatientDB.getHeartCenterAppointmentList(startDate, endDate, bStatus);
request.setAttribute("appointment_list", record);
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp" />
	<body>
		<div id="indexWrapper">
			<div id="mainFrame">
				<div id="contentFrame">
					<jsp:include page="../common/page_title.jsp" flush="false">
						<jsp:param name="pageTitle" value="OPD Appointment List" />
					</jsp:include>

					<table>
						<tr>
							<td>
								<form name="search_form" action="hc_appointment_list.jsp" method="post">
									<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
										<tr class="smallText">
											<td class="infoLabel" width="30%">
												Start Date (Create):
											</td>
											<td class="infoData" width="70%">
												<input type="text" name="startDate" class="datepickerfield"
														value="<%=startDate == null ? "" : startDate%>"
														maxlength="10" size="10">
											</td>
										</tr>
										<tr class="smallText">
											<td class="infoLabel" width="30%">
												End Date (Create):
											</td>
											<td class="infoData" width="70%">
												<input type="text" name="endDate" class="datepickerfield"
														value="<%=endDate == null ? "" : endDate%>"
														maxlength="10" size="10">
											</td>
										</tr>
										<tr class="smallText">
											<td class="infoLabel" width="30%">
												Status:
											</td>
											<td class="infoData" width="70%">
												<select name="bStatus">
													<option value="">ALL</option>
													<option value="N"<%="N".equals(bStatus)?" selected":""%>>Normal</option>
													<option value="C"<%="C".equals(bStatus)?" selected":""%>>Cancel</option>
													<option value="F"<%="F".equals(bStatus)?" selected":""%>>Confirm</option>
													<option value="B"<%="B".equals(bStatus)?" selected":""%>>Block</option>
												</select>
											</td>
										</tr>
										<tr class="smallText">
											<td colspan="2" align="center">
												<button onclick="return submitSearch();">
													<bean:message key="button.search" />
												</button>
											</td>
										</tr>
									</table>
								</form>
							</td>
						</tr>
					</table>

					<bean:define id="functionLabel">Heart Center Appointment List</bean:define>
					<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
					<display:table id="row" name="requestScope.appointment_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="generaltable">
						<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
						<display:column titleKey="prompt.patientNo" style="width:7%">
							<c:out value="${row.fields0}" />
						</display:column>
						<display:column titleKey="prompt.patName" style="width:7%">
							<c:out value="${row.fields1}" />
						</display:column>
						<display:column title="Appointment Date & Time" style="width:7%">
							<c:out value="${row.fields9}" />
						</display:column>
						<display:column title="DR Code" style="width:5%">
							<c:out value="${row.fields6}" />
						</display:column>
						<display:column title="DR Name" style="width:7%">
							<c:out value="${row.fields7}" />
						</display:column>
						<display:column title="Remark" style="width:5%">
							<c:out value="${row.fields12}" />
						</display:column>
						<display:column titleKey="prompt.countryCode" style="width:5%">
							<c:out value="${row.fields3}" />
						</display:column>
						<display:column title="Patient Mobile" style="width:7%">
							<c:out value="${row.fields4}" />
						</display:column>
						<display:column title="Booking Mobile" style="width:7%">
							<c:out value="${row.fields5}" />
						</display:column>
						<display:column title="Create Date & Time" style="width:7%">
							<c:out value="${row.fields8}" />
						</display:column>
						<display:column title="SMS Template" style="width:7%">
							<c:out value="${row.fields2}" />
						</display:column>
						<display:column title="Create User" style="width:5%">
							<c:out value="${row.fields10}" />
						</display:column>
						<display:column title="Status" style="width:5%">
							<c:out value="${row.fields11}" />
						</display:column>
						<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
					</display:table>
					<script language="javascript">
						function submitSearch() {
							showOverLay('body');
							showLoadingBox('body', 100, 350);
							document.search_form.submit();
						}

						$(document).ready(function() {
						});
					</script>
				</div>
			</div>
		</div>
	</body>
</html:html>