<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
public static ArrayList getSlipList(String patNo){
	StringBuffer sqlStr = new StringBuffer();	
	sqlStr.append("Select s.SlpNo, s.SlpType, p.PatNo, nvl(s.SlpFName, p.PatFName) as PatFName, "); 
	sqlStr.append("nvl(s.SlpGName, p.PatGName) as PatGName, nvl(s.PatCName, p.PatCName) as PatCName, "); 
	sqlStr.append("d.DocCode, d.DocFName, d.DocGName, d.DocCName, '', "); 
	sqlStr.append("s.SlpCAmt + s.SlpDAmt + s.SlpPAmt as SlpNAmt,s.SlpSts, s.UsrID, ");
	sqlStr.append("a.ARCCode, a.ARCName, s.SlpDAmt, s.SlpPAmt, s.SLPTYPE "); 
	sqlStr.append("from      Slip@IWEB s, Reg@IWEB r, Patient@IWEB p, Doctor@IWEB d, ARCode@IWEB a "); 
	sqlStr.append("where     s.RegID = r.RegID(+) "); 
	sqlStr.append("and       s.PatNo = p.PatNo(+) ");
	sqlStr.append("and       s.DocCode = d.DocCode ");
	sqlStr.append("and       s.ArcCode = a.ArcCode(+) ");
	sqlStr.append("and       s.SlpSts = 'A' ");
	sqlStr.append("AND       p.PatNo IN ('"+patNo+"') ");
	sqlStr.append("order by  Slpno desc "); 

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getBabyList(String patNo) {
	StringBuffer sqlStr = new StringBuffer();	
	
	
	sqlStr.append("SELECT   MOTHER_PATIENT.PATNO_B, BABY.PATFNAME ||' '|| BABY.PATGNAME ,TO_CHAR(MOTHER_PATIENT.REGDATE  , 'DD/MM/YYYY HH24:MI:SS') ,TO_CHAR( BABY.PATBDATE  , 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("FROM     PATIENT@IWEB BABY,( ");
	sqlStr.append("SELECT   L.PATNO_B, P.PATFNAME ||' '|| P.PATGNAME , R.REGDATE "); 
	sqlStr.append("FROM     MBLINK@IWEB L, PATIENT@IWEB P , REG@IWEB R, INPAT@IWEB I "); 
	sqlStr.append("WHERE    L.PATNO_M = '"+patNo+"' ");
	sqlStr.append("AND      P.PATNO = R.PATNO ");
	sqlStr.append("AND      R.INPID = I.INPID "); 
	sqlStr.append("AND      L.PATNO_B = P.PATNO "); 
	sqlStr.append("AND      I.INPDDATE IS NULL ) MOTHER_PATIENT ");
	sqlStr.append("WHERE    BABY.PATNO = MOTHER_PATIENT.PATNO_B ");
	sqlStr.append("AND      TO_DATE(TO_CHAR(BABY.PATBDATE, 'DD/MM/YYYY')||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS')  >=   TO_DATE(TO_CHAR(MOTHER_PATIENT.REGDATE , 'DD/MM/YYYY')||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') "); 
		
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String patNo = userBean.getLoginID();
request.setAttribute("slip_list", getSlipList(patNo));

ArrayList babyList = getBabyList(patNo);

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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<jsp:include page="header.jsp">
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
	<table width="100%" border="0" cellpadding="0" cellspacing="0">	
		<tr>
			<td align="center">
				<img src="../images/billing.jpg" /><br/>
				<span class="enquiryLabel extraBigText"><bean:message key="prompt.patientBilling"/></span>
			</td>
		</tr>		
		<tr><td>&nbsp;</td></tr>
		<tr >
			<td style="background-color:#0070C0;color:white;font-weight:bold;font-size:16px">
				<bean:message key="prompt.patient.information"/>
			</td>
		</tr>
		<tr><td align="center">
			<table cellpadding="0" width="100%" cellspacing="5"	class="contentFrameMenu" border="0">
				<tr class="smallText">
					<td class="infoLabel" width="16%"><bean:message key="prompt.patientName"/></td>
					<td class="infoData"  width="16%"><%=userBean.getUserName() %></td>
					<td class="infoLabel" width="16%"><bean:message key="prompt.bedacm"/></td>
					<td class="infoData"  width="16%"><%=userBean.getRemark2() %> - <%=userBean.getDeptDesc() %></td>
				</tr>					
			</table>	
		</td></tr>		
		<tr><td>&nbsp;</td></tr>		
		<tr>
			<td style="background-color:#0070C0;color:white;font-weight:bold;font-size:16px">
				<bean:message key="prompt.billList" />
			</td>
		</tr>
	</table>
		
	<bean:define id="functionLabel1"><bean:message key="prompt.billList" /></bean:define>
	<bean:define id="notFoundMsg1"><bean:message key="message.notFound" arg0="<%=functionLabel1 %>" /></bean:define>
	<display:table id="row" name="requestScope.slip_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
		<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
		<display:column property="fields0" titleKey="prompt.billNo" style="width:25%" />
		<display:column property="fields16" titleKey="prompt.totalCharge" style="width:15%" />
		<display:column property="fields17" titleKey="prompt.totalPayment" style="width:15%" />
		<display:column property="fields11" titleKey="prompt.totalNetAmount" style="width:15%" />
		<display:column titleKey="prompt.action" style="width:15%" >
			<button type="button" class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' 
			 onclick="return viewSlip('<c:out value="${row.fields0}" />', '<c:out value="${row.fields18}" />');">
			 	<bean:message key="button.view"/>
			</button>
		</display:column>		
		<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg1 %>"/>
	</display:table>	
	
	<%
	for(int i = 0; i < babyList.size(); i++) {
		ReportableListObject rlo = (ReportableListObject) babyList.get(i);
		//System.out.println(rlo.getValue(0));
		ArrayList bList = getSlipList(rlo.getValue(0));
		//System.out.println(bList.size());
		request.setAttribute("slip_list"+String.valueOf(i), bList);
		String name = "requestScope.slip_list"+String.valueOf(i);
	%>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td style="background-color:#0070C0;color:white;font-weight:bold;font-size:16px">
				<bean:message key="prompt.babyInformation"/> (<%=i+1 %>)
				</td>
			</tr>
			<tr><td align="center">
				<table cellpadding="0" width="100%" cellspacing="5"	class="contentFrameMenu" border="0">
					<tr class="smallText">
						<td class="infoLabel" width="16%"><bean:message key="prompt.babyName"/></td>
						<td class="infoData"  width="16%"><%=rlo.getValue(1) %></td>
						<td class="infoLabel" width="16%"></td>
						<td class="infoData"  width="16%"></td>
					</tr>					
				</table>	
			</td></tr>		
			<tr><td>&nbsp;</td></tr>		
			<tr>
				<td style="background-color:#0070C0;color:white;font-weight:bold;font-size:16px">
					<bean:message key="prompt.billList" />
				</td>
			</tr>
		</table>
		
		<bean:define id="functionLabel2"><bean:message key="prompt.billList" /></bean:define>
		<bean:define id="notFoundMsg2"><bean:message key="message.notFound" arg0="<%=functionLabel2 %>" /></bean:define>
		<display:table id="row" name="<%=name %>" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
			<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
			<display:column property="fields0" titleKey="prompt.billNo" style="width:25%" />
			<display:column property="fields16" titleKey="prompt.totalCharge" style="width:15%" />
			<display:column property="fields17" titleKey="prompt.totalPayment"  style="width:15%" />
			<display:column property="fields11" titleKey="prompt.totalNetAmount" style="width:15%" />
			<display:column titleKey="prompt.action" style="width:15%" >
				<button type="button" class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' 
				 onclick="return viewSlip('<c:out value="${row.fields0}" />', '<c:out value="${row.fields18}" />');">
				 	<bean:message key="button.view"/>
				</button>
			</display:column>		
			<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg2 %>"/>
		</display:table>
	<%
	}
	%>
	
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<button style="font-size:24px;" 
						class='ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' 
						onclick="return submitAction();">
						<bean:message key="prompt.logout"/>
				</button>
			</td>
		</tr>	
	</table>
</form>

<div id="slipPanel" style="height:auto; display:none; position:absolute; z-index:12;">
</div>
<div id="overlay" class="ui-widget-overlay" style="display:none;"></div>
<script language="javascript">
 	var patNo = <%=patNo%>;
 	
	function submitAction() {
		showLoadingBox();
		document.form1.action = "../patient/logout.jsp";
		document.form1.submit();
		hideLoadingBox();
	}
	
	function getBillSummary(slipNo, regtype) {
		$.ajax({
			type: "POST",
			url: "../ui/billingCMB.jsp",
			data: "slipNo="+slipNo+"&regtype="+regtype,
			async: false,
			success: function(values){
				$('div#overlay').css('height', $(document).height());
				$('div#overlay').css('width', $(document).width());
				$('div#overlay').css('display', '');
				$('div#overlay').css('z-index', '11');
				$('div#slipPanel').css('top', $(window).scrollTop());//+($(window).height()-$('div#caretrackingPanel').height())/2);
				//$('div#slipPanel').css('left', 5);//($(window).width()-$('div#caretrackingPanel').width())/2);
				$('div#slipPanel').css('display', '');
				//alert(values);
				$('div#slipPanel').html(values);
				clickSummaryEvent(regtype);
			},//success
			error: function(jqXHR, textStatus, errorThrown) {
				alert('Error in "getBillSummary"');
			}
		});//$.ajax
	}
	
	function clickSummaryEvent(regtype) {
		$('.summary').unbind('click');
		//alert(regtype)
		$('.summary').click(function() {
			if (regtype == "I") {
				window.open('../patient/bill_chrgSummary.jsp?slipNo='+$(this).attr('id').split('_')[1], '_blank');
			}
			else if (regtype == "O") {
				window.open('../patient/bill_opstatement.jsp?slipNo='+$(this).attr('id').split('_')[1], '_blank');
			}
		});
	}
	
	function viewSlip(slipNo, regtype) {
		getBillSummary(slipNo, regtype);
	}
	
	function closePanel() {
		$('div#slipPanel').css('display', 'none');		
		$('div#overlay').css('display', 'none');		
	}
	
	$(document).ready(function(){
		$('div#slipPanel').css('width', $(window).width()*0.8);
		//$('div#slipPanel').css('height', $(window).height()*0.6);
		//getBillSummary();
		//clickSummaryEvent();
	});
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>