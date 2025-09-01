<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"
%><%@ page import="org.apache.struts.*"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.servlet.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"
%><%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"
%><%
UserBean userBean = new UserBean(request);
String patno = request.getParameter("patNo");//userBean.getLoginID();
String regtype = request.getParameter("regtype");
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<style>
label {
	font-size: 18px;
}
</style>
<body>
<jsp:include page="../patient/checkSession.jsp" />

<form name="form1">
<center>
	<table width="800" border="0" cellpadding="0" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
		<jsp:include page="../patient/patientInfo.jsp" />
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center"><img src="../images/billing.jpg" /><br/><span class="enquiryLabel extraBigText">Patient Billing</span></td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr align="center" id="billingContent">
			<td>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<button style="font-size:24px;" 
						class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' 
						onclick="return submitAction();">
						<img src="../images/undo2.gif"/>&nbsp;Back to Home
				</button>
			</td>
		</tr>
	</table>
</center>
</form>
<script language="javascript">
 	var patNo = <%=patno%>;
 	
	function submitAction() {
		showLoadingBox();
		document.form1.action = "../patient/main.jsp";
		document.form1.submit();
		hideLoadingBox();
	}
	
	function getBillSummary() {
		$.ajax({
			type: "POST",
			url: "../ui/billingCMB.jsp",
			data: "patientNo="+patNo,
			async: false,
			success: function(values){
				//alert(values)
				$('#billingContent td').html(values);
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "getBillSummary"');
			}
		});//$.ajax
	}
	
	function clickSummaryEvent() {
		$('.summary').click(function() {
			window.open('../patient/bill_chrgSummary.jsp?slipNo='+$(this).attr('id').split('_')[1], '_blank');
		});
	}
	
	$(document).ready(function(){
		getBillSummary();
		clickSummaryEvent();
	});
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>