<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.*"%>
<%
UserBean userBean = new UserBean(request);

String[] current_year = DateTimeUtil.getCurrentYearRange();
String date_from = request.getParameter("date_from");
if (date_from == null || date_from.length() == 0) {
	date_from = DateTimeUtil.getCurrentDate();
}
String date_to = request.getParameter("date_to");
if (date_to == null || date_to.length() == 0) {
	date_to = DateTimeUtil.getCurrentDate();
}
String[] current_month = DateTimeUtil.getCurrentMonthRange();
String curent_date = DateTimeUtil.getCurrentDate();

String command = ParserUtil.getParameter(request, "command");
String sortBy = request.getParameter("sortBy");
if (sortBy == null) {
	sortBy = ConstantsVariable.EMPTY_VALUE;
}
String patientType = request.getParameter("patientType");
String patientStatus = request.getParameter("patientStatus");
String ordering = request.getParameter("ordering");

String dateRange = request.getParameter("dateRange");

String site = request.getParameter("site");
if ( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
	site = "Hong Kong Adventist Hospital - Stubbs Road";
} else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())) {
	site = "Hong Kong Adventist Hospital - Tsuen Wan";
}

ArrayList recordACM = null;

ArrayList record = AdmissionDB.getOutPatientList(date_from,date_to, null, sortBy, ordering, "pdfAction".equals(command),patientType,patientStatus);
request.setAttribute("admission_list", record);

if (record.size() > 0  && "pdfAction".equals(command) ) {
	File reportFile = new File(application.getRealPath("/report/pre_out_admission_report.jasper"));
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());		
		parameters.put("Site", site);


		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport,
				parameters,
				new ReportListDataSource(record) {
					public Object getFieldValue(int index) throws JRException {
						String value = (String) super.getFieldValue(index);

						if (index == 10) {
						   if("M".equals(value)){
							   return "Male";
						   }
						   else if ("F".equals(value)){
							   return "Female";
						   }
						}
						if (index == 76) {
								try {
										 String temp2 = value.replaceAll("<P>","");
										 temp2 = temp2.replaceAll("</P>","");
									return temp2;
								} catch (Exception e) {
								}
							}
						if (index == 82) {
							   if("Y".equals(value)){
								   return "Yes";
							   }
							   else{
								   return "No";
							   }
							}
						if (index == 83) {
							
							   if("1".equals(value)){
								   return "Yes";
							   }
							   else if ("0".equals(value)){
								   return "No";
							   }
							}
						if (index == 64) {
							
							if(AdmissionDB.getDocName(value)==null){ 
								   return value;
							   }
							   else{
								   return AdmissionDB.getDocName(value);
							   }
							}						
						if (index == 85) {

							}
						return value;
					}
				});


		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		JRPdfExporter exporter = new JRPdfExporter();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

        exporter.exportReport();
		return;
	}
  }
%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->e
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
	<jsp:param name="pageTitle" value="function.out.registration.list" />
</jsp:include>

<form name="search_form" action="out_admission_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Send email to customer</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.email" /></td>
		<td class="infoData" width="70%"><input type="text" name="email" value="" onkeyup="clearEmail();" maxlength="50" size="25" /><font color="blue"><span id="showEmail_indicator"></span></font></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" >	
			<%=MessageResources.getMessage(session, "out.adm.appDate") %><%=MessageResources.getMessage(session, "adm.ddmmyyyy.hhmm") %>			
		</td>
		<td>
			<input type="text" name="appointmentDate" id="appointmentDate" class="datepickerfield" value="" maxlength="10" size="10"   onkeyup="validDate(this)" />			
				<jsp:include page="../ui/timeCMB.jsp" flush="false">
				<jsp:param name="label" value="appointmentTime" />
				<jsp:param name="time" value="" />
			</jsp:include>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel">	
			<%=MessageResources.getMessage(session, "out.adm.attDoctor") %>
		</td>
		<td>
			<select name="attendDoctor">
				<option value=""></option>
				<jsp:include page="../ui/docCodeCMB.jsp" flush="false">
					<jsp:param name="selectFrom" value="Pre-addmission" />
				</jsp:include>
			</select>
		</td>	
	
	</tr>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitAction('email', '');" class="btn-click"><bean:message key="button.submit" /></button>
		</td>
	</tr>
</table>

<br/>

<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">	
	<tr class="smallText">
		<td class="infoTitle" colspan="2">Search Registration List</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.appointmentDate" /></td>
		<td class="infoData" width="70%">
			<input type="textfield" name="date_from" id="date_from" class="datepickerfield" value="<%=date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
			-
			<input type="textfield" name="date_to" id="date_to" class="datepickerfield" value="<%=date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)<br/>
			<input value='today' <%="today".equals(dateRange)?" checked":"" %> type="radio" name="dateRange" onclick="javascript:setDateRange(1);"  checked/><bean:message key="label.today" />
			<input value='thisMonth' <%="thisMonth".equals(dateRange)?" checked":"" %> type="radio" name="dateRange" onclick="javascript:setDateRange(2);"/><bean:message key="label.thisMonth" />
			<input value='thisYear' <%="thisYear".equals(dateRange)?" checked":"" %> type="radio" name="dateRange" onclick="javascript:setDateRange(3);"/><bean:message key="label.thisYear" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Patient</td>
		<td class="infoData" width="70%">			
			<select name="patientType">
				<option value="">All</option>
				<option value="exisiting"<%="exisiting".equals(patientType)?" selected":"" %>>Exisiting</option>
				<option value="new"<%="new".equals(patientType)?" selected":"" %>>New</option>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Status</td>
		<td class="infoData" width="70%">			
			<select name="patientStatus">
				<option value="">All</option>
				<option value="complete"<%="complete".equals(patientStatus)?" selected":"" %>>Complete</option>
				<option value="notComplete"<%="notComplete".equals(patientStatus)?" selected":"" %>>Not Complete</option>
				<option value="deleted"<%="deleted".equals(patientStatus)?" selected":"" %>>Deleted</option>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Sort By</td>
		<td class="infoData" width="70%">
			<select name="sortBy">				
				<option value="0"<%="0".equals(sortBy)?" selected":"" %>><bean:message key="prompt.patName" /></option>
				<option value="1"<%="1".equals(sortBy)?" selected":"" %>><bean:message key="prompt.patientNo" /></option>
				<option value="2"<%="2".equals(sortBy)?" selected":"" %>><bean:message key="prompt.createdDate" /></option>							
				<option value="3"<%="3".equals(sortBy)?" selected":"" %>><bean:message key="prompt.dateOfBirth" /></option>				
				<option value="4"<%="4".equals(sortBy)?" selected":"" %>>Created By</option>			
				<option value=""<%="".equals(sortBy)?" selected":"" %>><bean:message key="prompt.modifiedDate" /></option>
				<option value="6"<%="6".equals(sortBy)?" selected":"" %>><bean:message key="prompt.appointmentDate" /></option>
			</select>
			<select name="ordering">
				<option value="DESC"<%="DESC".equals(ordering)?" selected":"" %>>Decending</option>
				<option value="ASC"<%="ASC".equals(ordering)?" selected":"" %>>Ascending</option>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>
<bean:define id="functionLabel"><bean:message key="function.out.registration.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="out_admission_list.jsp" method="post">

<display:table id="row" name="requestScope.admission_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="generaltable">
	<display:column title="&nbsp;" media="html" style="width:5%"><c:out value="${row.fields0}" />)</display:column>	
	<display:column titleKey="prompt.appointmentDateAndTime" style="width:10%">
		<c:out value="${row.fields60}" /> <c:out value="${row.fields61}" />
	</display:column>
	<display:column titleKey="prompt.patientName" style="width:10%">
		<c:out value="${row.fields2}" /> <c:out value="${row.fields3}" />
	</display:column>
	<display:column property="fields1" titleKey="prompt.patientNo" style="width:10%" />
	<display:column  titleKey="prompt.docsName" style="width:10%">
		<%if(AdmissionDB.getDocName(((ReportableListObject)pageContext.getAttribute("row")).getFields64())==null){ %>
			<c:out value="${row.fields64}" />
		<%}else{ %>
			<%=AdmissionDB.getDocName(((ReportableListObject)pageContext.getAttribute("row")).getFields64()) %>
		<%} %>
	</display:column>
	<display:column titleKey="prompt.sex" style="width:10%">
		<logic:equal name="row" property="fields10" value="M">
			<bean:message key="label.male" />
		</logic:equal>
		<logic:equal name="row" property="fields10" value="F">
			<bean:message key="label.female" />
		</logic:equal>
	</display:column>
	<display:column titleKey="prompt.hkid" style="width:10%">
			<c:out value="${row.fields7}" />
	</display:column>
	<display:column title="Passport No" style="width:10%">
			<c:out value="${row.fields8}" />
	</display:column>
	<display:column title="Travel Document" style="width:10%">
			<c:out value="${row.fields9}" />
	</display:column>
	<display:column property="fields15" titleKey="prompt.dateOfBirth" style="width:10%" />
	<display:column titleKey="prompt.remarks" style="width:5%">
		<logic:equal name="row" property="fields76" value="">
			<bean:message key="label.no" />
		</logic:equal>
		<logic:notEqual name="row" property="fields76" value="">
			<bean:message key="label.yes" />
		</logic:notEqual>
	</display:column>
	<display:column property="fields78" titleKey="prompt.createdDate" style="width:10%" />
	<display:column titleKey="prompt.createdBy" style="width:10%">
		<logic:equal name="row" property="fields77" value="">
			<logic:equal name="row" property="fields79" value="SYSTEM">
				System
			</logic:equal>	
			<logic:notEqual name="row" property="fields79" value="SYSTEM">
			   	Web
			</logic:notEqual>
		</logic:equal>	
		<logic:notEqual name="row" property="fields77" value="">
			Email
		</logic:notEqual>
	</display:column>
	<%-- 
		<display:column property="fields85" title="Follow Up" style="width:10%" />
	
	<display:column title="Unread Information" style="width:10%">
		<logic:equal name="row" property="fields82" value="Y">
			Yes
		</logic:equal>
		<logic:notEqual name="row" property="fields82" value="Y">
			No
		</logic:notEqual>
	</display:column>
	--%>
	<display:column title="Attachment" style="width:10%">
		<logic:equal name="row" property="fields83" value="1">
			Yes
		</logic:equal>
		<logic:notEqual name="row" property="fields83" value="1">
			No
		</logic:notEqual>
	</display:column>
	<display:column title="Status" style="width:10%">
		<logic:equal name="row" property="fields88" value="1">
			<logic:equal name="row" property="fields87" value="1">
				Complete
			</logic:equal>
			<logic:equal name="row" property="fields87" value="0">
				Not Complete
			</logic:equal>
		</logic:equal>
		<logic:equal name="row" property="fields88" value="0">
			Deleted
		</logic:equal>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields0}" />');"><bean:message key='button.view' /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<table cellpadding="0"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td >Export Option:
		<a href="javascript:void(0);" onclick="return submitAction('pdfAction', '');" class="btn-click">PDF</a>
 		</td>
	</tr>
</table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '');"><bean:message key="function.out.registration.create" /></button></td>
	</tr>
</table>

<input type="hidden" name="command" />
<input type="hidden" name="admissionID" />
<input type="hidden" name="sortBy" value="<%=sortBy %>"/>
<input type="hidden" name="ordering" value="<%=ordering==null?"":ordering %>"/>

</form>
<script language="javascript">
	function setDateRange(select) {
		if (select == 1) {
			document.search_form.date_from.value = '<%=curent_date %>';
			document.search_form.date_to.value = '<%=curent_date %>';
		} else if (select == 2) {
			document.search_form.date_from.value = '<%=current_month[0] %>';
			document.search_form.date_to.value = '<%=current_month[1] %>';
		} else if (select == 3) {
			document.search_form.date_from.value = '<%=current_year[0] %>';
			document.search_form.date_to.value = '<%=current_year[1] %>';
		}
	}

	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
	}

	function submitAction(cmd, eid) {
		if (cmd == 'email') {
			submitEmail();
		}else if(cmd =='pdfAction'){
			document.form1.command.value = 'pdfAction';
			document.form1.submit();
		}else if (cmd =='refreshAction'){
			document.form1.command.value = 'refreshAction';
			document.form1.submit();
			
		} else {
			callPopUpWindow("out_admission.jsp?command=" + cmd + "&admissionID=" + eid);
		}
		return false;
	}

	// ajax
	var http = createRequestObject();

	function submitEmail() {		
		var sendEmail = true;
		
		if (document.search_form.email.value == '') {
			sendEmail = false;
			alert('Empty email.');
			document.search_form.email.focus();
		}else if (document.search_form.appointmentDate.value == '') {
			sendEmail = false;
			alert('Empty Appointment Date.');
			document.search_form.appointmentDate.focus();
		} else if (!validDate(document.search_form.appointmentDate)) {
			sendEmail = false;
			alert('Invalid Appointment Date.');
			document.search_form.appointmentDate.focus();
		} else if ($('select[name=attendDoctor] :selected').text() == ''){
			sendEmail = false; 
			alert('Empty Attending Doctor');
			document.search_form.attendDoctor.focus();		
		}
		
		
		if(sendEmail){			
			$.ajax({
				type: "POST",
				url: "out_admission_email.jsp",
				data: "email=" + document.search_form.email.value + "&ignoreCurrentStaffID=Y&showDeptDesc=N&category=nominee" +
					  "&appointmentDate="+ document.search_form.appointmentDate.value + 
					  "&appointmentTime_hh=" + document.search_form.appointmentTime_hh.value + 
					  "&appointmentTime_mi=" + document.search_form.appointmentTime_mi.value +
					  "&attendDoctor=" + $('select[name=attendDoctor] :selected').val(),
				success: function(values){
				if(values != '') {
					$("#showEmail_indicator").html(values);
				}//if
				}//success
			});//$.ajax
			document.search_form.email.value = "";
			document.search_form.appointmentDate.value = "";
			document.search_form.attendDoctor.value="";
			
		}
	}

	function clearEmail() {
		document.getElementById("showEmail_indicator").innerHTML = "";
		return false;
	}

</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>