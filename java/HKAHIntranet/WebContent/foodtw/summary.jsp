<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.web.common.*"%>

<%
UserBean userBean = new UserBean(request);
String ward = request.getParameter("ward");

if (userBean.getDeptCode().equals("FOOD") || 
		userBean.getDeptCode().equals("HSKG") ||  
		userBean.getDeptCode().equals("U100") ||  
		userBean.getDeptCode().equals("U200") ||  
		userBean.getDeptCode().equals("U300") ||  
		userBean.getDeptCode().equals("U3NW") ||  
		userBean.getDeptCode().equals("U400") ||  
		userBean.getDeptCode().equals("IM")) {
	
	if (userBean.getDeptCode().equals("IM")) {
		if (userBean.getStaffID().equals("4493") ||
				userBean.getStaffID().equals("21030") ||
				userBean.getStaffID().equals("21082") ||
				userBean.getStaffID().equals("21092")) {
			
		}
		else if (!userBean.isAdmin()){
			%>
			<script>
			alert('You are not granted permission.');
				window.close();
			</script>
			<%
			return;
		}
	}
	
	if (userBean.getDeptCode().equals("HSKG")) {
		if (userBean.getStaffID().equals("16119")) {
			
		}
		else if (!userBean.isAdmin()){
			%>
			<script>
			alert('You are not granted permission.');
				window.close();
			</script>
			<%
			return;
		}
	}
}
else if (!userBean.isAdmin()){
	%>
	<script>
	alert('You are not granted permission.');
		window.close();
	</script>
	<%
	return;
}

if (userBean != null && userBean.isLogin()) {
	ArrayList record =PatientDB.getInPatList(ward, null, false);

	request.setAttribute("patList", record);
}
else {
	%>
	<script>
		window.open("../foodtw/index.jsp", "_self");
	</script>
	<%
	return;
}
%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>
	<jsp:include page="../foodtw/checkSession.jsp" />
	<style>
		TD,TH,A,SPAN,INPUT {
			font-size:18px !important;
		}
	</style>
	<body>	
		<DIV id=indexWrapper>
			<DIV id=mainFrame>
				<DIV id=contentFrame>
					<form name="searchForm" action="summary.jsp" method="get">
						<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0" style="width:100%">
							<tr style="width:100%"><td colspan='5'>&nbsp;</td></tr>
							<tr style="width:100%">
								<td colspan="2" style="background-color:gray; color:white;">
									<label style="font-size:30px;"><u><b>Summary List</b></u></label>
								</td>
								<td colspan="1">
								</td>
								<td colspan="2" align="right">
								</td>
							</tr>
							<tr style="width:100%"><td colspan='5'>&nbsp;</td></tr>
							<tr class="smallText" style="width:100%">
								<td class="infoLabel" width="15%">
									Ward
								</td>
								<td class="infoData" width="35%">
									<select id="ward"></select>
								</td>
								<td class="infoLabel" width="15%">
									Action
								</td>
								<td class="infoData" width="35%">
									<button class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only" 
											onclick="sendEmail('small')" style="<%=ward.equals("ALL")?"display:none":""%>">
										Send Email
									</button>
								</td>
							</tr>
						</table>
						<input type="hidden" name="ward" value="<%=(ward==null)?"":ward%>">
					</form>
					<display:table id="row" name="requestScope.patList" export="false" pagesize="200" class="tablesorter" sort="list">
						<display:column title="Ward" style="width:5%">
							<c:out value="${row.fields2}" />
						</display:column>
						<display:column title="Bed" style="width:5%">
							<c:out value="${row.fields3}" />
						</display:column>
						<display:column title="Patient No" style="width:10%">
							<c:out value="${row.fields7}" />
						</display:column>
						<display:column title="Patient Name" style="width:10%">
							<c:out value="${row.fields9}" />
						</display:column>
						<display:column title="Allergy" style="width:10%">
							<c:set var="patientNo" value="${row.fields7}"/>
							<%
								String patientNo = (String)pageContext.getAttribute("patientNo") ;
								String allergy = PatientDB.getInpatientAllergy(patientNo, null);
								pageContext.setAttribute("allergy", allergy);
							%>
							<c:out value="${allergy}" />
						</display:column>
						<display:column title="" style="width:60%">
							<div class="detail" patNo="${row.fields7}" regID="${row.fields5}"></div>
						</display:column>
						<display:setProperty name="basic.msg.empty_list" value="Not found any item"/>
					</display:table>
				</DIV>
			</DIV>
		</DIV>
	</body>
</html:html>

<script type="text/javascript">
	$(document).ready(function() {
		$('th').unbind('click');
		getWRB('Ward', $('input[name=ward]').val());
		showLoadingBox('body', 500, $(window).scrollTop());
		getPatientSummary();
		hideLoadingBox('body', 500);
	});
	
	function getPatientSummary() {
		$('div.detail').each(function(i, v) {
			var dom = $(this);
			$.ajax({
				url: 'summaryDetail.jsp',
				data: "patNo=" + dom.attr('patNo') + "&regID=" + dom.attr('regID'),
				async: false,
				success: function(values){
					dom.html(values);
				},
				error: function(jqXHR, textStatus, errorThrown) {
					alert('Error in "getPatientSummary"');
				}
			});
		});
	}
	
	function getWRB(type, val, selected) {
		$.ajax({
			url: (type=="Ward")?"../ui/ward_classCMB.jsp":"../ui/rm_bedCMB.jsp",
			async: false,
			data: "Type="+type+"&Value="+val+(selected?("&selected="+selected):""),
			success: function(values){
				$('select#'+type.toLowerCase()).html("<option value='ALL'>ALL</option>"+values);
				if(type == "Ward" || type == "Room") {
					selectWREvent(type, type == "Ward"?"Room":"Bed");
				}
				else {
					selectWREvent(type, type);
				}
			},
			error: function() {
				alert('error');
			}
		});
	}
	
	function selectWREvent(type, target, init) {
		$('select#'+type.toLowerCase()).change(function() {
			$('option:selected', this).each(function(){
				$('input[name='+type.toLowerCase()+']').val(this.value);
				submitAction('search');
		    });
		});
	}
	
	function submitAction(command) {
		if(command == 'search') {
			document.searchForm.submit();
		}
		
		return false;
	}
	
	function sendEmail(type) {
		showLoadingBox('body', 500);
		$.ajax({
			url: 'summaryReportPDF.jsp',
			data: 'ward='+$('input[name=ward]').val()+'&type='+type,
			async: false,
			success: function(values){
				var result = $.trim(values);
				if(result=='true') {
					alert('Successful');
				}
				else {
					alert('Fail');
				}
				hideLoadingBox('body', 500);
			},
			error: function() {
				alert('email error');
				hideLoadingBox('body', 500);
			}
		});
		return false;
	}
</script>