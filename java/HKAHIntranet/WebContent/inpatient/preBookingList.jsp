<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>

<%
UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "command");
String patNo = request.getParameter("patNo");
String patName = request.getParameter("patName");
String docLastName = request.getParameter("docLastName");
String docGivenName = request.getParameter("docGivenName");
String sortBy = request.getParameter("sortBy");
if (sortBy == null) {
	sortBy = "DOCNAME";
}
String ordering = request.getParameter("ordering");
if(ordering == null) {
	ordering = "ASC";
}
int current_yy = DateTimeUtil.getCurrentYear();
int current_mm = DateTimeUtil.getCurrentMonth();
int current_dd = DateTimeUtil.getCurrentDay();
String flwDateFrom = request.getParameter("flw_date_from");
String flwDateTo = request.getParameter("flw_date_to");
String admDateFrom = request.getParameter("date_from");
String admDateTo = request.getParameter("date_to");
String bResult = request.getParameter("bResult");

String smsDateFrom = request.getParameter("sms_date_from");
String smsDateTo = request.getParameter("sms_date_to");
//String orderDateFrom =
if ((admDateFrom == null || admDateFrom.length() == 0) &&
		flwDateFrom == null && flwDateTo == null && docLastName == null &&
		docGivenName == null && bResult == null && smsDateFrom == null &&
		smsDateTo == null) {
	admDateFrom = current_dd + "/" + current_mm + "/" + current_yy;
}

String site = request.getParameter("site");
if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
	site = "Hong Kong Adventist Hospital- Stubbs Road";
}else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
	site = "Hong Kong Adventist Hospital - Tsuen Wan";
}
String[] pbWard = request.getParameterValues("pbWard");
String reportNo = request.getParameter("reportNo");

ArrayList record = InPatientPreBookDB.getList(docLastName, docGivenName, admDateFrom, admDateTo,
			patNo, patName, flwDateFrom, flwDateTo, bResult, sortBy, ordering, "reportAction".equals(command),
			smsDateFrom, smsDateTo, null, null, pbWard);
request.setAttribute("pbList", record);
request.setAttribute("MultiValue", pbWard);
String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";

if (record.size() > 0  && "reportAction".equals(command) ) {
	File reportFile = null;
	if (reportNo.equals("1") || reportNo.equals("3")) {
		reportFile = new File(application.getRealPath("/report/RPT_INPAT_PRE_BOOK_2.jasper"));
	}
	else if (reportNo.equals("2") || reportNo.equals("4")) {
		reportFile = new File(application.getRealPath("/report/RPT_INPAT_PRE_BOOK.jasper"));
	}

	if (reportFile != null && reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("DateFrom", admDateFrom);
		parameters.put("DateTo", admDateTo);
		parameters.put("Site", site);

		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport,
				parameters,
				new ReportListDataSource(record) {
					public Object getFieldValue(int index) throws JRException {
						String value = (String) super.getFieldValue(index);

						if(index == 6) {
							if(value != null && value.length() > 0) {
								return "Yes";
							} else {
								return "No";
							}
						} else if (index == 12) {
							if("4".equals(value)){
								return "Link";
							} else if ("5".equals(value)){
								return "Email";
							} else if ("6".equals(value)){
								return "SMS";
							} else if ("7".equals(value)){
								return "Fax";
							} else if ("8".equals(value)){
								return "Phone";
							} else if ("9".equals(value)){
								return "Can't be reached";
							} else if ("10".equals(value)){
								return "Preferred upfront registration";
							} else if ("11".equals(value)){
								return "Booking cancelled/rescheduled";
							} else if ("12".equals(value)){
								   return "Web";
							} else if ("13".equals(value)){
								return "Same day booking";
							} else if ("14".equals(value)){
								return "Booking made after printing call list (1 day ahead)";
							} else if ("15".equals(value)){
								return "Without contact information";
							} else if ("16".equals(value)){
								return "Duplicate booking";
							} else if ("17".equals(value)){
								return "Virtual booking for LOG";
							} else if ("18".equals(value)){
								return "Others";
							} else {
								return "";
							}
						}
						return value;
					}
				});


		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();

		if (reportNo.equals("1") || reportNo.equals("2")) {
			response.setContentType("application/pdf");
			JRPdfExporter exporter = new JRPdfExporter();
			exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
			exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
			exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
			exporter.exportReport();
		} else if (reportNo.equals("3") || reportNo.equals("4")) {
			response.setContentType("application/vnd.ms-excel");
			JRXlsExporter exporterXLS = new JRXlsExporter();
			exporterXLS.setParameter(JRXlsExporterParameter.JASPER_PRINT, jasperPrint);
			exporterXLS.setParameter(JRXlsExporterParameter.OUTPUT_STREAM, ouputStream);
			exporterXLS.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
			exporterXLS.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, false);
			exporterXLS.setParameter(JRXlsExporterParameter.IS_AUTO_DETECT_CELL_TYPE, true);
			exporterXLS.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, false);
			exporterXLS.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, false);
			exporterXLS.exportReport();
		}
		return;
	}
}
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
					<jsp:param name="pageTitle" value="function.pbList.title" />
					<jsp:param name="category" value="group.pbList" />
				</jsp:include>

				<font color="blue"><%=message %></font>
				<font color="red"><%=errorMessage %></font>

				<form name="searchPbForm" action="preBookingList.jsp" method="get">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								DR Last Name
							</td>
							<td class="infoData" width="35%">
								<input type="textfield" name="docLastName" value="<%=docLastName==null?"":docLastName %>" maxlength="50" size="50" />
							</td>
							<td class="infoLabel" width="15%">
								DR Given Name
							</td>
							<td class="infoData" width="35%">
								<input type="textfield" name="docGivenName" value="<%=docGivenName==null?"":docGivenName %>" maxlength="50" size="50" />
							</td>
						</tr>
						<tr>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.pbList.result" />
							</td>
							<td class="infoData" width="20%">
								<select name="bResult">
									<option value=""></option>
									<option value="4"<%="4".equals(bResult)?" selected":""%>>Link</option>
									<option value="12"<%="12".equals(bResult)?" selected":""%>>Web</option>
									<option value="5"<%="5".equals(bResult)?" selected":""%>>Email</option>
									<option value="6"<%="6".equals(bResult)?" selected":""%>>SMS</option>
									<option value="7"<%="7".equals(bResult)?" selected":""%>>Fax</option>
									<option value="8"<%="8".equals(bResult)?" selected":""%>>Phone</option>
									<option value="9"<%="9".equals(bResult)?" selected":""%>>Can't be reached</option>
									<option value="10"<%="10".equals(bResult)?" selected":""%>>Preferred upfront registration</option>
									<option value="11"<%="11".equals(bResult)?" selected":""%>>Booking cancelled/rescheduled</option>
									<option value="13"<%="13".equals(bResult)?" selected":""%>>Same day booking</option>
									<option value="14" <%="14".equals(bResult)?" selected":""%>>Booking made after printing call list (1 day ahead)</option>
									<option value="15" <%="15".equals(bResult)?" selected":""%>>Without contact information</option>
									<option value="16" <%="16".equals(bResult)?" selected":""%>>Duplicate booking</option>
									<option value="17" <%="17".equals(bResult)?" selected":""%>>Virtual booking for LOG</option>
									<option value="18" <%="18".equals(bResult)?" selected":""%>>Others</option>
								</select>
							</td>
							<td class="infoLabel" width="15%">
								Wards
							</td>
							<td class="infoData" width="20%">
								<jsp:include page="../ui/ward_classCMB.jsp">
									<jsp:param value="Ward" name="Type"/>
									<jsp:param value="true" name="checkBox"/>
									<jsp:param value="pbWard" name="checkBoxName"/>
								</jsp:include>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.admissionDate" />
							</td>
							<td class="infoData" width="35%">
								<input type="textfield" name="date_from" id="date_from"
									class="datepickerfield" value="<%=admDateFrom==null?"":admDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
								-
								<input type="textfield" name="date_to" id="date_to"
									class="datepickerfield" value="<%=admDateTo==null?"":admDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
							</td>

							<td class="infoLabel" width="15%">
								<bean:message key="prompt.followUpDate" />
							</td>
							<td class="infoData" width="35%">
								<input type="textfield" name="flw_date_from" id="flw_date_from"
									class="datepickerfield" value="<%=flwDateFrom==null?"":flwDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
								-
								<input type="textfield" name="flw_date_to" id="flw_date_to"
									class="datepickerfield" value="<%=flwDateTo==null?"":flwDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.patNo" />
							</td>
							<td class="infoData" width="35%">
								<input type="textfield" name="patNo" value="<%=patNo==null?"":patNo %>" maxlength="10" size="50"/>
							</td>
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.patName" />
							</td>
							<td class="infoData" width="35%">
								<input type="textfield" name="patName" value="<%=patName==null?"":patName %>" maxlength="10" size="50"/>
							</td>
						</tr>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								Sort By
							</td>
							<td class="infoData" width="35%">
								<select name="sortBy">
									<option value="PATNO" <%="PATNO".equals(sortBy)?" selected":"" %>>Patient NO</option>
									<option value="PATNAME" <%="PATNAME".equals(sortBy)?" selected":"" %>>Patient Name</option>
									<option value="PATCNAME" <%="PATCNAME".equals(sortBy)?" selected":"" %>>Patient Chinese Name</option>
									<option value="PATPAGER" <%="PATPAGER".equals(sortBy)?" selected":"" %>>Telephone(Mobile)</option>
									<option value="PATEMAIL" <%="PATEMAIL".equals(sortBy)?" selected":"" %>>Email</option>
									<option value="CURINHSE" <%="CURINHSE".equals(sortBy)?" selected":"" %>>Currently in house</option>
									<option value="ADMDATE" <%="ADMDATE".equals(sortBy)?" selected":"" %>>Schd. Adm. Date</option>
									<option value="DOCNAME" <%="DOCNAME".equals(sortBy)?" selected":"" %>>DR Name</option>
									<option value="PATADDRMK" <%="PATADDRMK".equals(sortBy)?" selected":"" %>><bean:message key="prompt.patient.remark" /></option>
									<option value="FLW_UP_STATUS" <%="FLW_UP_STATUS".equals(sortBy)?" selected":"" %>><bean:message key="prompt.pbList.result" /></option>
									<option value="SEND_TIME" <%="SEND_TIME".equals(sortBy)?" selected":"" %>>SMS Send Time</option>
									<option value="ORDERDATE" <%="ORDERDATE".equals(sortBy)?" selected":"" %>>Order Date</option>
									<option value="SURTIME" <%="SURTIME".equals(sortBy)?" selected":"" %>>Surgery Time</option>
									<option value="BE" <%="BE".equals(sortBy)?" selected":"" %>>* BE</option>
								</select>
								<select name="ordering">
									<option value="ASC" <%="ASC".equals(ordering)?"selected":"" %>>Ascending</option>
									<option value="DESC" <%="DESC".equals(ordering)?"selected":"" %>>Descending</option>
								</select>
							</td>

							<td class="infoLabel" width="15%">
								SMS Send Time
							</td>
							<td class="infoData" width="35%">
								<input type="textfield" name="sms_date_from" id="sms_date_from"
									class="datepickerfield" value="<%=smsDateFrom==null?"":smsDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
								-
								<input type="textfield" name="sms_date_to" id="sms_date_to"
									class="datepickerfield" value="<%=smsDateTo==null?"":smsDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
							</td>
						</tr>
						<%--
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								<bean:message key="prompt.docMobile" />
							</td>
							<td class="infoData" width="35%">
								<input type="textfield" name="mobile" value="<%=mobile==null?"":mobile %>" maxlength="10" size="50"/>
							</td>
						</tr>
						--%>
						<tr class="smallText">
							<td colspan="2" align="center">
								<button onclick="return submitSearch();">
									<bean:message key="button.search" />
								</button>
								<button onclick="return clearSearch();">
									<bean:message key="button.clear" />
								</button>
								<input type="hidden" name="command" />
								<input type="hidden" name="reportNo" value=""/>
							</td>
						</tr>
					</table>
				</form>

				<bean:define id="functionLabel">
					<bean:message key="function.pbList.title" />
				</bean:define>
				<bean:define id="notFoundMsg">
					<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
				</bean:define>

				<form name="bookingForm" action="bookingInfo.jsp" method="post">
					<display:table id="row" name="requestScope.pbList" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="generaltable">
						<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
						<display:column property="fields0" title="Patient NO" style="width:6%" />
						<display:column property="fields1" title="Patient Name" style="width:15%" />
						<display:column property="fields2" title="Patient Chinese Name" style="width:6%" />
						<display:column property="fields5" title="Telephone(Mobile)" style="width:6%" />
						<display:column property="fields6" title="Email" style="width:6%" />
						<display:column property="fields9" title="Currently in house" style="width:8%" />
						<display:column property="fields22" title="Order Date" style="width:8%" />
						<display:column property="fields8" title="Schd. Adm. Date" style="width:8%" />
						<display:column property="fields10" title="DR Name" style="width:6%" />
						<display:column property="fields14" titleKey="prompt.patient.remark" style="width:12%" />
						<display:column titleKey="prompt.pbList.result" style="width:12%">
							<logic:equal name="row" property="fields12" value="4">
								Link
							</logic:equal>
							<logic:equal name="row" property="fields12" value="5">
								Email
							</logic:equal>
							<logic:equal name="row" property="fields12" value="6">
								SMS
							</logic:equal>
							<logic:equal name="row" property="fields12" value="7">
								Fax
							</logic:equal>
							<logic:equal name="row" property="fields12" value="8">
								Phone
							</logic:equal>
							<logic:equal name="row" property="fields12" value="9">
								Can't be reached
							</logic:equal>
							<logic:equal name="row" property="fields12" value="10">
								Preferred upfront registration
							</logic:equal>
							<logic:equal name="row" property="fields12" value="11">
								Booking cancelled/rescheduled
							</logic:equal>
							<logic:equal name="row" property="fields12" value="12">
								Web
							</logic:equal>
							<logic:equal name="row" property="fields12" value="13">
								Same day booking
							</logic:equal>
							<logic:equal name="row" property="fields12" value="14">
								One day ahead booking after print list
							</logic:equal>
							<logic:equal name="row" property="fields12" value="15">
								No contact information
							</logic:equal>
							<logic:equal name="row" property="fields12" value="16">
								Duplicate booking
							</logic:equal>
							<logic:equal name="row" property="fields12" value="17">
								PBO booking for LOG
							</logic:equal>
							<logic:equal name="row" property="fields12" value="18">
								Others
							</logic:equal>
						</display:column>
						<display:column property="fields19" title="SMS Send Time" style="width:12%"/>
						<%--<display:column property="fields24" title="Surgery Time" style="width:12%"/> --%>
						<display:column property="fields29" title="* BE" style="width:12%"/>
						<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
<%
	String phone = ((ReportableListObject)pageContext.getAttribute("row")).getFields5();
	phone = StringEscapeUtils.escapeJavaScript(phone);
%>
							<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />','<c:out value="${row.fields11}" />','<%=phone %>', '');"><bean:message key='button.view' /></button>
						</display:column>
						<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
					</display:table>

					<table cellpadding="0"
						class="contentFrameMenu" border="0">
						<tr class="smallText">
							<td >Export Option:
							<a href="javascript:void(0);" onclick="return submitAction('reportAction', '', '', '', '1');" class="btn-click">PDF (Arrival List)</a>,
							<a href="javascript:void(0);" onclick="return submitAction('reportAction', '', '', '', '2');" class="btn-click">PDF (Pre-booking List)</a>,
							<a href="javascript:void(0);" onclick="return submitAction('reportAction', '', '', '', '3');" class="btn-click">Excel (Arrival List)</a>,
							<a href="javascript:void(0);" onclick="return submitAction('reportAction', '', '', '', '4');" class="btn-click">Excel (Pre-booking List)</a>
							</td>
						</tr>
					</table>

					<input type="hidden" name="patNo" value="<%=patNo==null?"":patNo %>"/>
					<input type="hidden" name="patName" value="<%=patName==null?"":patName %>"/>
					<input type="hidden" name="docLastName" value="<%=docLastName==null?"":docLastName %>"/>
					<input type="hidden" name="docGivenName" value="<%=docGivenName==null?"":docGivenName %>"/>
					<input type="hidden" name="flwDateFrom" value="<%=flwDateFrom==null?"":flwDateFrom %>"/>
					<input type="hidden" name="flwDateTo" value="<%=flwDateTo==null?"":flwDateTo %>"/>
					<input type="hidden" name="date_from" value="<%=admDateFrom==null?"":admDateFrom %>"/>
					<input type="hidden" name="date_to" value="<%=admDateTo==null?"":admDateTo %>"/>
					<input type="hidden" name="bResult" value="<%=bResult==null?"":bResult %>"/>
				</form>

				<script language="javascript">
					function submitSearch() {
						showOverLay('body');
						showLoadingBox('body', 100, 350);

						document.searchPbForm.command.value = 'search';
						document.searchPbForm.submit();
					}

					function submitReport() {
						//callPopUpWindow("../callBack/callBackRpt.jsp");
					}

					function clearSearch() {
						document.searchPbForm.patNo.value="";
						document.searchPbForm.patName.value="";
						document.searchPbForm.docName.value="";
					}

					function submitAction(action, patNo, preBookID, phone, report) {
						if(action == 'reportAction') {
							showOverLay('body');
							showLoadingBox('body', 100, 350);

							document.searchPbForm.command.value = 'reportAction';
							document.searchPbForm.reportNo.value = report;
							document.searchPbForm.submit();
						}
						else if(action == 'view') {
							document.searchPbForm.command.value = 'view';
							callPopUpWindow(document.bookingForm.action + "?patNo=" + patNo + "&preBookID=" + preBookID + "&phone=" + phone);
							return false;
						}
					}
				</script>
			</div>
		</div>

		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>