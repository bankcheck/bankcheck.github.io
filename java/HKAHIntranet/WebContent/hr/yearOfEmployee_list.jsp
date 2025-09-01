<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String deptCode1 = request.getParameter("deptCode1");
String deptCode2 = request.getParameter("deptCode2");
String groupBy = request.getParameter("groupBy");
String deptDesc[] = null;
String deptVoteCount[] = null;
int deptCount = 0;
int maxCount = 0;

if (groupBy == null || groupBy.length() == 0) {
	request.setAttribute("yearOfEmployee", EmployeeVoteDB.getList(deptCode1, deptCode2, null));
} else {
	ArrayList result = EmployeeVoteDB.getList(null, null, groupBy);
	if (result.size() > 0) {
		ReportableListObject row = null;
		Vector deptDescVector = new Vector();
		Vector deptVoteCountVector = new Vector();
		int tempcount = 0;

		for (int i = 0; i < result.size(); i++) {
			row = (ReportableListObject) result.get(i);
			deptDescVector.add(row.getValue(0));
			deptVoteCountVector.add(row.getValue(1));
			try {
				tempcount = Integer.parseInt(row.getValue(1));
				if (tempcount > maxCount) {
					maxCount = tempcount;
				}
			} catch (Exception e) {}
		}
		deptCount = deptDescVector.size();
		deptDesc = (String []) deptDescVector.toArray(new String [deptCount]);
		deptVoteCount = (String []) deptVoteCountVector.toArray(new String [deptCount]);
	}
}

String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
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
	<jsp:param name="pageTitle" value="function.yearOfEmployee.list" />
	<jsp:param name="category" value="group.hr" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="search_form" action="yearOfEmployee_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /> (<bean:message key="prompt.nomineeStaff" />)</td>
		<td class="infoData" width="70%">
			<select name="deptCode1">
				<option value="">--- All Departments ---</option>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="ignoreDeptCode" value="880" />
	<jsp:param name="deptCode" value="<%=deptCode1 %>" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.department" /> (<bean:message key="prompt.nominatingStaff" />)</td>
		<td class="infoData" width="70%">
			<select name="deptCode2">
				<option value="">--- All Departments ---</option>
<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
	<jsp:param name="ignoreDeptCode" value="880" />
	<jsp:param name="deptCode" value="<%=deptCode2 %>" />
	<jsp:param name="allowAll" value="Y" />
</jsp:include>
			</select>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.group" /></td>
		<td class="infoData" width="70%">
			<select name="groupBy">
				<option value="">No grouping</option>
				<option value="deptCode1"<%="deptCode1".equals(groupBy)?" selected":"" %>><bean:message key="prompt.department" /> (<bean:message key="prompt.nomineeStaff" />)</option>
				<option value="deptCode2"<%="deptCode2".equals(groupBy)?" selected":"" %>><bean:message key="prompt.department" /> (<bean:message key="prompt.nominatingStaff" />)</option>
				<option value="nominatee"<%="nominatee".equals(groupBy)?" selected":"" %>><bean:message key="prompt.nomineeStaff" /></option>
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
<%if (groupBy == null || groupBy.length() == 0) { %>
<bean:define id="functionLabel"><bean:message key="function.yearOfEmployee.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="yearOfEmployee.jsp" method="post">
<display:table id="row" name="requestScope.yearOfEmployee" export="true" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" titleKey="prompt.nomineeStaff" style="width:5%"/>
	<display:column property="fields2" titleKey="prompt.department" style="width:5%" />
	<display:column property="fields0" titleKey="prompt.staffID" style="width:5%"/>
	<display:column property="fields4" titleKey="prompt.nominatingStaff" style="width:5%" />
	<display:column property="fields5" titleKey="prompt.department" style="width:5%" />
	<display:column property="fields3" titleKey="prompt.staffID" style="width:5%"/>
	<display:column property="fields7" titleKey="prompt.vote.reason" style="width:30%"/>
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return submitAction('view', '<c:out value="${row.fields3}" />');"><bean:message key='button.view' /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</form>
<%} else { %>
<%--
deptCount = 30;
String deptDescTest[] = new String[deptCount];
String deptVoteCountTest[] = new String[deptCount];
Random random = new Random();
for (int i = 0; i < deptDescTest.length; i++ ) {
	deptDescTest[i] = "Dummy text asdf asdf " + i;
	deptVoteCountTest[i] = "" + random.nextInt(153);
	
}
deptVoteCount=deptVoteCountTest;
deptDesc = deptDescTest;
--%>
<div id="barLegend1" style="margin:10px;width:720px;text-align:center;"></div>
<div id="bar1" style="margin:10px;width:720px;height:<%=deptCount * 24 + 20 %>px;"></div>
<%} %>
<script language="javascript">
<%--
var api = new jGCharts.Api(); 
jQuery('<img>') 
.attr('src', api.make({data : [<%
	if (deptVoteCount != null) {
		for (int i = 0; i < deptCount; i++) {
			%>[<%=deptVoteCount[i] %>]<%
			if (i < deptCount - 1) {
				%>, <%
			}
		}
	}
%>], axis_labels : [<%
	if (deptDesc != null) {
		for (int i = 0; i < deptCount; i++) {
			%>'<%=deptDesc[i] %>'<%
			if (i < deptCount - 1) {
				%>,<%
			}
		}
	}
%>], type : 'bhg', size : '600x<%=100 + deptCount * 10 %>'})) 
.appendTo("#bar1"); --%>

<% if (groupBy != null && groupBy.length() > 0) { %>
data = [<%
	if (deptVoteCount != null && deptDesc != null) {
		for (int i = 0; i < deptCount; i++) { %>
			{ 
				label: "<%=deptDesc[i] %>",
				data: [[<%=deptVoteCount[i] %>, <%=deptCount - 1 - i %>]]
			} <% 
			if (i < deptCount - 1) {
				%>, <%
			}
		}
	}
%>];

options = { 
	series: {
		bars: {
			show: true,
			align: "center",
			barWidth: 0.75,
			fill: 0.7,
			horizontal: true
		}
	},
	yaxis: {
		minTickSize: 1,
		ticks: [ <% 
			if (deptDesc != null ) {
				for (int i = 0; i < deptCount; i++) { %>
					[<%= i %>, "<%=deptDesc[deptCount - 1 - i] %>"] <% 
					if (i < deptCount - 1) {	
						%>, <% 
					}
				}
			}
		%> ],
		labelWidth: 200
	},
	xaxis: {
		min: 0,
		minTickSize: 1,
		tickDecimals: 0,
		autoscaleMargin: 0.02
	},
	legend: {
		show: false
//		noColumns: 4,
//		container: $("#barLegend1")
	},
	grid: {
		hoverable: true,
		autohighlight: true
	}
};

$.plot($("#bar1"), data, options);

// Flot tooltip example
function showTooltip(x, y, contents) {
$('<div id="tooltip">' + contents + '</div>').css( {
	position: 'absolute',
	top: y - 5,
	left: x + 5,
	border: '1px solid #fdd',
	padding: '2px',
	'background-color': '#fee'
	}).appendTo("body");
}
var previousPoint = null;
$("#bar1").bind("plothover", function (event, pos, item) {
	if (item) {
		if (previousPoint != item.datapoint) {
			previousPoint = item.datapoint;

			$("#tooltip").remove();
			var x = item.datapoint[0].toFixed(2),
				y = item.datapoint[1].toFixed(2);

				showTooltip(item.pageX, item.pageY, "" + Math.floor(x));
			}
	} else {
		$("#tooltip").remove();
 		previousPoint = null;            
	}
});
<% } %>

	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
	}

	function submitAction(cmd, sid) {
		callPopUpWindow(document.form1.action + "?command=" + cmd + "&staffID=" + sid);
		return false;
	}
</script>
<style type="text/css">
#chartarea {
	float:left;
	margin-left:10px;
}
.tickLabel {
	font-size: 10pt;
}
</style>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>