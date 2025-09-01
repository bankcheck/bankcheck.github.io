<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);

String category = "title.education";
String[] current_year = DateTimeUtil.getCurrentYearRange();
String date_from = request.getParameter("date_from");
if (date_from == null || date_from.length() == 0) {
	date_from = DateTimeUtil.getRollDate(current_year[0], 0, 0, 0);
}
String date_to = request.getParameter("date_to");
if (date_to == null || date_to.length() == 0) {
	date_to = current_year[1];
}
String[] current_month = DateTimeUtil.getCurrentMonthRange();
String curent_date = DateTimeUtil.getCurrentDate();
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.eLesson.report" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<form name="search_form" action="record_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.eLesson" /></td>
		<td class="infoData" width="70%">
<select name="eventID-elearningID">
	<jsp:include page="../ui/elearningIDCMB.jsp" flush="false">
		<jsp:param name="eventType" value="online" />
	</jsp:include>
</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.searchType" /></td>
		<td class="infoData" width="70%">
			<input type="radio" id="searchTypeDateRange" name="searchType" value="dateRange" checked /><bean:message key="prompt.searchTypeDateRange" /><br/>
			<input type="radio" id="searchTypeFinancialYear" name="searchType" value="financialYear" /><bean:message key="prompt.searchTypeFinancialYear" /><br/>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.searchTypeDateRange" /></td>
		<td class="infoData" width="70%">
			<input type="text" name="date_from" id="date_from" class="datepickerfield" value="<%=date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
			-
			<input type="text" name="date_to" id="date_to" class="datepickerfield" value="<%=date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /> (DD/MM/YYYY)<br />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(1);" /><bean:message key="label.today" />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(2);" /><bean:message key="label.thisMonth" />
			<input type="radio" name="dateRange" onclick="javascript:setDateRange(3);" checked /><bean:message key="label.thisYear" />
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.searchTypeFinancialYear" /></td>
		<td class="infoData" width="70%">
<jsp:include page="../ui/dateCMB.jsp" flush="false">
	<jsp:param name="label" value="financialYear" />
	<jsp:param name="isYearOnly" value="Y" />
</jsp:include>
		</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
<table width="100%">
	<tr>
		<td>
			<ul id="tabList">
			<li><a href="javascript:submitAction('report1');" tabId="tab1" id="tab1" class="linkUnSelected"><span><bean:message key="label.report.scoreSummary" /></span></a></li>
			<li><a href="javascript:submitAction('report2');" tabId="tab2" id="tab2" class="linkUnSelected" target="content"><span><bean:message key="label.report.incorrectAnswerSummary" /></span></a></li>
			<li><a href="javascript:submitAction('report3');" tabId="tab3" id="tab3" class="linkUnSelected"><span><bean:message key="label.report.attemptCountSummary" /></span></a></li>
			<li><a href="javascript:submitAction('report4');" tabId="tab4" id="tab4" class="linkUnSelected"><span><bean:message key="label.report.hitCountSummary" /></span></a></li>
			</ul>
		</td>
	</tr>
</table>
<input type="hidden" name="reportCategory" value="" />
</form>
<span id="test_report_list_result" />
<script language="javascript">
<!--
	$(document).ready(function(){
		$('#searchTypeDateRange').click(function() {
			setSearchType(1);
		});
		$('#searchTypeFinancialYear').click(function() {
			setSearchType(2);
		});
	});

	// ajax
	var http = createRequestObject();

	function submitSearch() {
		var radioLength = document.search_form.searchType.length;
		var searchType;
		for (var i = 0; i < radioLength; i++) {
			if (document.search_form.searchType[i].checked) {
				searchType = document.search_form.searchType[i].value;
			}
		}

		if (searchType == 'dateRange') {
			if (document.search_form.date_from.value == "") {
				alert("<bean:message key="error.date.required" />.");
				document.search_form.date_from.focus();
				return false;
			}
			if (document.search_form.date_to.value == "") {
				alert("<bean:message key="error.date.required" />.");
				document.search_form.date_to.focus();
				return false;
			}
		}

		var date_from, date_to, financialYear_yy, eventIDElearningID;
		date_from = document.search_form.date_from.value;
		date_to = document.search_form.date_to.value;
		date_to = document.search_form.date_to.value;
		eventIDElearningID = document.forms["search_form"].elements["eventID-elearningID"].value;
		financialYear_yy = document.search_form.financialYear_yy.value;
		reportCategory = document.search_form.reportCategory.value;
		if (reportCategory == '') {
			// set default value
			reportCategory = 'report1';
			document.getElementById('tab1').className = 'linkSelected';
		}

		//show loading image
		document.getElementById("test_report_list_result").innerHTML = '<img src="../images/wait30trans.gif">';

		//make a connection to the server ... specifying that you intend to make a GET request
		//to the server. Specifiy the page name and the URL parameters to send
		http.open('get', 'test_report_list_result.jsp?reportCategory=' + reportCategory + '&searchType=' + searchType + '&date_from=' + date_from + '&date_to=' + date_to + '&financialYear=' + financialYear_yy + '&eventID-elearningID=' + eventIDElearningID + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);
	}

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

	function setSearchType(select) {
		if (select == 1) {
			document.getElementById("date_from").disabled = false;
			document.getElementById("date_to").disabled = false;
			document.getElementById("financialYear_yy").disabled = true;
		} else if (select == 2) {
			document.getElementById("date_from").disabled = true;
			document.getElementById("date_to").disabled = false;
			document.getElementById("financialYear_yy").disabled = false;
		}
	}

	function clearSearch() {
	}

	function submitAction(c) {
		// reset tab
		document.getElementById('tab1').className = 'linkUnSelected';
		document.getElementById('tab2').className = 'linkUnSelected';
		document.getElementById('tab3').className = 'linkUnSelected';
		document.getElementById('tab4').className = 'linkUnSelected';
		document.forms['search_form'].elements['reportCategory'].value = c;
		if (c == 'report1') document.getElementById('tab1').className = 'linkSelected';
		else if (c == 'report2') document.getElementById('tab2').className = 'linkSelected';
		else if (c == 'report3') document.getElementById('tab3').className = 'linkSelected';
		else if (c == 'report4') document.getElementById('tab4').className = 'linkSelected';
		submitSearch();
	}

	function showStaff(uid) {
		callPopUpWindow("../admin/staff.jsp?command=view&staffID=" + uid);
		return false;
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){
			//read and assign the response from the server
			document.getElementById("test_report_list_result").innerHTML = http.responseText;
		}
	}

	// set default loading
	submitAction('report1');

	// disable search financial year
	if (document.getElementById("financialYear_yy")) {
		document.getElementById("financialYear_yy").disabled = true;
	}
-->
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>