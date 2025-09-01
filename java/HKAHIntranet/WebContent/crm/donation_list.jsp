<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	public static ArrayList getEvent(String campaign) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT CO_EVENT_ID, CO_EVENT_DESC, CRM_CAMPAIGN_ID ");	
		sqlStr.append("FROM CO_EVENT ");
		sqlStr.append("WHERE CRM_CAMPAIGN_ID = '" + campaign + "' ");
		sqlStr.append("AND CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY CO_EVENT_DESC ");
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList fetchDonation(String date_from, String date_to, String campaignID, String eventID, String lastName, String firstName, String acceptPromotion) {

		// fetch donation
		StringBuffer sqlStr = new StringBuffer();
		List<String> params = new ArrayList<String>();
		
		sqlStr.append("SELECT 	D.CRM_CLIENT_ID, CONCAT(CL.CRM_LASTNAME, (' '||CL.CRM_FIRSTNAME)), CL.CRM_CHINESENAME, ");
		sqlStr.append("			CL.CRM_STREET1, CL.CRM_STREET2, CL.CRM_STREET3, CL.CRM_STREET4, ");
		sqlStr.append("			D.CRM_DONATION_ID, TO_CHAR(D.CRM_DONATION_DATE, 'DD/MM/YYYY'), D.CRM_RECEIPT_ID, ");
		sqlStr.append("			F.CRM_FUND_DESC, ");
		sqlStr.append("			D.CRM_PLEDGED_AMOUNT, D.CRM_DONATION_METHOD, ");
		sqlStr.append("			D.CRM_CAMPAIGN_ID, C.CRM_CAMPAIGN_DESC, D.CRM_EVENT_ID, E.CO_EVENT_DESC, ");
		sqlStr.append("			DECODE(CL.CRM_WILLING_PROMOTION,'Y','Yes','N','No'), D.CRM_REMARKS ");
		sqlStr.append("FROM CRM_CLIENTS_DONATION D ");
		sqlStr.append("LEFT JOIN CRM_CLIENTS CL ON CL.CRM_CLIENT_ID = D.CRM_CLIENT_ID ");
		sqlStr.append("LEFT JOIN CRM_CAMPAIGN C ON D.CRM_CAMPAIGN_ID = C.CRM_CAMPAIGN_ID ");
		sqlStr.append("LEFT JOIN CO_EVENT E ON D.CRM_EVENT_ID = E.CO_EVENT_ID ");
		sqlStr.append("LEFT JOIN CRM_FUNDS F ON D.CRM_FUND_ID = F.CRM_FUND_ID ");
		sqlStr.append("WHERE 	D.CRM_ENABLED = 1 ");
		sqlStr.append("AND D.CRM_STATUS != 'client_info' ");
	    if (date_from != null) {
	    	sqlStr.append("	AND 	D.CRM_DONATION_DATE >= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(date_from);
	    }
	    if (date_to != null) {
	    	sqlStr.append("	AND 	D.CRM_DONATION_DATE <= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(date_to);
	    }
	   	if(campaignID != null && campaignID.length() > 0){
	    	sqlStr.append("AND 		D.CRM_CAMPAIGN_ID = ? ");
	    	params.add(campaignID);
	   	}
	   	if(eventID != null && eventID.length() > 0){
	    	sqlStr.append("AND 		D.CRM_EVENT_ID = ? ");
	    	params.add(eventID);
	   	}
	   	if(lastName != null && lastName.length() > 0){
	    	sqlStr.append("AND 		CL.CRM_LASTNAME LIKE ? ");
	       	params.add("%" + lastName +"%");
	   	}
	   	if(firstName != null && firstName.length() > 0){
	    	sqlStr.append("AND 		CL.CRM_FIRSTNAME LIKE ? ");
	    	params.add("%" + firstName +"%");
	   	}
	   	if(acceptPromotion != null && !"A".equals(acceptPromotion)){
	    	sqlStr.append("AND 		CL.CRM_WILLING_PROMOTION = ? ");
	    	params.add(acceptPromotion);
	   	}
	   	sqlStr.append("ORDER BY D.CRM_CLIENT_ID, D.CRM_DONATION_DATE");
	   	
	   	//System.out.println(sqlStr.toString());
	   	
	   	return UtilDBWeb.getReportableList(sqlStr.toString(), params.toArray(new String[]{}));
	}
%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);

String command = request.getParameter("command");
String step = request.getParameter("step");
String date_from = request.getParameter("date_from");
String date_to = request.getParameter("date_to");
String campaignID = request.getParameter("campaignID");
String eventID = request.getParameter("eventID");
String clientLastName = request.getParameter("clientLastName");
String clientFirstName = request.getParameter("clientFirstName");
String acceptPromotion = request.getParameter("acceptPromotion");

ArrayList record = new ArrayList();
ArrayList eventIDshow = new ArrayList();
ArrayList eventDesc = new ArrayList();
if(campaignID != null && campaignID.length() > 0){
	record = getEvent(campaignID);
	if (record.size() > 0) {
		for (int i=0; i<record.size();i++){
			ReportableListObject row = (ReportableListObject) record.get(i);
			eventIDshow.add(row.getValue(0));
			eventDesc.add(row.getValue(1));
		}
		
	}
}

String[] current_year = DateTimeUtil.getCurrentYearRange();
if (date_from == null || date_from.length() == 0) {
	date_from = DateTimeUtil.getRollDate(current_year[0], 0, 0, 0);
}
if (date_to == null || date_to.length() == 0) {
	date_to = current_year[1];
}
String[] current_month = DateTimeUtil.getCurrentMonthRange();
String curent_date = DateTimeUtil.getCurrentDate();

record = fetchDonation(date_from,date_to,campaignID,eventID,clientLastName,clientFirstName,acceptPromotion);
int count = record.size();
float pledged = 0;
try {
	ReportableListObject row = null;
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			pledged += NumericUtil.parseFloat(row.getValue(11));
		}
	}
} catch (Exception e) {}
request.setAttribute("donation_list", record);

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";



%>
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
<style>
#campaignID, #eventID{
	width:250px;
}
</style>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.donation.list" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="donation_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText" >
		<td class="infoLabel" ><bean:message key="prompt.date" /></td>
		<td class="infoData" width="70%" colspan="3">
			<input type="text" name="date_from" id="date_from" class="datepickerfield" value="<%=date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
			-
			<input type="text" name="date_to" id="date_to" class="datepickerfield" value="<%=date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)<br />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(1);" /><bean:message key="label.today" />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(2);" /><bean:message key="label.thisMonth" />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(3);" checked /><bean:message key="label.thisYear" />
		</td>
	</tr>
	
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.campaign" /></td>
		<td class="infoData" width="35%">
			<select id="campaignID" name="campaignID">
<jsp:include page="../ui/campaignIDCMB.jsp" flush="false">
	<jsp:param name="campaignID" value="<%=campaignID %>" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
			</select>
		</td>
		<td class="infoLabel" width="15%">Event</td>
		<td class="infoData" width="35%">
			<select id="eventID" name="eventID">
				<option value="">--- All Events ---</option>
<% for(int e=0;e<eventIDshow.size();e++){%>
				<option <%=((eventID.equals(eventIDshow.get(e)))?"selected":"") %> value="<%=eventIDshow.get(e) %>"><%=eventDesc.get(e) %></option>
<%} %>
			</select>
		</td>

	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%"><bean:message key="prompt.donorLastName"/></td>
		<td class="infoData" width="35%"><input type="textfield" name="clientLastName" value="<%=clientLastName==null?"":clientLastName %>" maxlength="30" size="25"></td>
		<td class="infoLabel" width="15%"><bean:message key="prompt.donorFirstName"/></td>
		<td class="infoData" width="35%"><input type="textfield" name="clientFirstName" value="<%=clientFirstName==null?"":clientFirstName%>" maxlength="60" size="25"></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Accept Promotion</td>
		<td class="infoData" width="35%">
			<input type="radio" name="acceptPromotion" value="Y" <%="Y".equals(acceptPromotion)?"checked":"" %> />Yes 
			<input type="radio" name="acceptPromotion" value="N" <%="N".equals(acceptPromotion)?"checked":"" %> />No
			<input type="radio" name="acceptPromotion" value="A" <%=acceptPromotion == null || "A".equals(acceptPromotion)?"checked":"" %> />All
		</td>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr class="smallText">
		<td colspan="4" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
<input type="hidden" name="command" value="" />
<input type="hidden" name="step" value="0">
</form>
<bean:define id="functionLabel"><bean:message key="function.donation.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="donation_detail.jsp" method="post">
<display:table id="row" name="requestScope.donation_list" export="false" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="" style="width:5%" media="html"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Donor ID" class="smallText" style="width:10%"/>
	<display:column property="fields1" titleKey="prompt.name" class="smallText" style="width:10%" />
	<display:column property="fields2" titleKey="prompt.chineseName" class="smallText" style="width:10%" />
	<display:column property="fields3" title="Address1" class="smallText" style="width:10%" media="excel"/>
	<display:column property="fields4" title="Address2" class="smallText" style="width:10%" media="excel"/>
	<display:column property="fields5" title="Address3" class="smallText" style="width:10%" media="excel"/>
	<display:column property="fields6" title="Address4" class="smallText" style="width:10%" media="excel"/>
	<display:column property="fields8" title="Donation Date" class="smallText" style="width:10%" />
	<display:column property="fields9" title="Receipt No." class="smallText" style="width:10%" />
	<display:column property="fields10" title="Donation Item" class="smallText" style="width:10%" media="excel"/>
	<display:column property="fields11" title="Amount ($)" class="smallText" style="width:10%" />
	<display:column property="fields12" title="Payment Method" class="smallText" style="width:10%" media="excel"/>
	<display:column property="fields14" title="Campaign" class="smallText" style="width:10%" media="excel"/>
	<display:column property="fields16" title="Event" class="smallText" style="width:10%" media="excel"/>
	<display:column property="fields17" title="Accept Promotion" class="smallText" style="width:10%" media="html"/>
	
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<br/>
Total$<%=pledged %>

<input type="hidden" name="command">
<input type="hidden" name="donationID">
</form>
<div align="center">
	<button type="button" onclick="return submitAction();" class="btn-click">Export Excel</button>
</div>
<script language="javascript">
	function submitSearch() {
		document.search_form.action = "donation_list.jsp";
		document.search_form.submit();
	}

	function clearSearch() {
		document.search_form.clientLastName.value = "";
		document.search_form.clientFirstName.value = "";
		document.search_form.campaignID.value = "";
		document.search_form.eventID.value = "";
		
	}

	function submitAction() {
		document.search_form.action = "exportDonationList.jsp";
		document.search_form.submit();
	}
	
	$( "#campaignID" )
	  .change(function() {
	    var campaignSeleted = $('#campaignID option:selected' ).val();
	    $.ajax({
	        url: "/intranet/crm/getEventList.jsp",
	        data: {"campaign" : campaignSeleted ,
	        		"allowAll" : "Y"},
	        type: 'POST',
	        dataType: 'html',
			cache: false,
	        success: function(data){
	        	$( "#eventID" ).html( data );
	        },
	       	error: function(data){
	       		console.log("error");
	       	}
	    });
	  })
	  
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
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>