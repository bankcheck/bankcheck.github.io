<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%

String module= request.getParameter("module");
if(module == null)
{
	module = "ALL";
}

String year_yy = request.getParameter("day_yy");

request.setAttribute("yearOfEmployee", EmployeeVoteDB.getNomList(module,year_yy));

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
<DIV id=indexWrapper style="width:100%">
<DIV id=mainFrame style="width:100%">
<DIV id=contentFrame style="width:100%">
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.rrteam.link3" />
		<jsp:param name="mustLogin" value="Y" />
		<jsp:param name="translate" value="Y" />
		<jsp:param name="keepReferer" value="N" />
		<jsp:param name="isHideHeader" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>

<form name="search_form" action="nominationList.jsp" method="get">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Module</td>
		<td class="infoData" width="70%">
		<select name = "module" id="module">
			<option value='ALL' <%=(module.equals("ALL")?"selected":"") %> >ALL</option>
			<option value='yearOfEmployee' <%=(module.equals("yearOfEmployee")?"selected":"") %>>Employee of the year</option>
			<option value='starOfTheQuarter' <%=(module.equals("starOfTheQuarter")?"selected":"") %>>Star Of The Quarter</option>
			<option value='eSHARE' <%=(module.equals("eSHARE")?"selected":"") %>>eShare</option>		
			<option value='yearOfEmp_starOfQuart' <%=(module.equals("yearOfEmp_starOfQuart")?"selected":"") %>>Employee of the year + Star Of The Quarter</option>
		</select>
		</td>
	</tr>
	<tr>
		<td class="infoLabel">
									Year
								</td>								
								<td  class="infoData">							
									<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
									<jsp:param name="label" value="day" />								
									<jsp:param name="yearRange" value="10" />									
									<jsp:param name="date" value="<%=year_yy %>" />
									<jsp:param name="defaultValue" value="N" />
									<jsp:param name="showTime" value="N" />
									<jsp:param name="hideFutureYear" value="Y" />
									<jsp:param name="allowEmpty" value="Y"/>									
									<jsp:param name="isYearOrderDesc" value="Y"/>
									<jsp:param name="isYearOnly" value="Y"/>
									</jsp:include>
								</td>		
	</tr>

	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="submitSearch()"><bean:message key="button.search" /></button>
			<button type=button onclick="clearSearch()"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>

<bean:define id="functionLabel"><bean:message key="function.yearOfEmployee.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>

<display:table style="width:100%" id="row" name="requestScope.yearOfEmployee" export="true" class="tablesorter">
		<display:column title="&nbsp;" media="html" style="width:4%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" title="Year" style="width:5%"/>
<%
	if(module!=null){
		if(module.equals("starOfTheQuarter") || module.equals("yearOfEmp_starOfQuart")){
%>
	<display:column property="fields14" titleKey="prompt.date" style="width:5%"/>		
<%	 }else if(module.equals("yearOfEmployee")){%>
		<display:column property="fields16" title="Allow Disclose" style="width:"/>
<%	 }else{%>
	<display:column property="fields8" titleKey="prompt.date" style="width:5%"/>
<%		} 
	}
%>
	<display:column property="fields2" titleKey="prompt.nomineeStaff" style="width:7%"/>
	<display:column property="fields3" titleKey="prompt.department" style="width:7%" />
	<display:column property="fields1" titleKey="prompt.staffID" style="width:7%"/>
	<display:column property="fields5" titleKey="prompt.nominatingStaff" style="width:7%" />
	<display:column property="fields6" titleKey="prompt.department" style="width:7%" />
	<display:column property="fields4" titleKey="prompt.staffID" style="width:7%"/>
	<%
	if(module!=null){
		if(module.equals("starOfTheQuarter") || module.equals("yearOfEmp_starOfQuart")){
%>
	<display:column property="fields8" title="Dependable" style="width:7"/>
	<display:column property="fields9" title="Flexible" style="width:7"/>
	<display:column property="fields10" title="Has initiative" style="width:7"/>
	<display:column property="fields11" title="Positive Attitude" style="width:7"/>
	<display:column property="fields12" title="Companssionate" style="width:7"/>
	<display:column property="fields13" title="Total" style="width:7"/>
	
<%
		}else if(module.equals("yearOfEmployee")){
%>
	<display:column property="fields8" title="Commitment to Colleagues" style="width:7"/>
	<display:column property="fields9" title="Professional Conduct/Attitude" style="width:7"/>
	<display:column property="fields10" title="Appearance" style="width:7"/>
	<display:column property="fields11" title="Effective Communication" style="width:7"/>
	<display:column property="fields12" title="Professional Development" style="width:7"/>
	<display:column property="fields13" title="Sense of Ownership" style="width:7"/>
	<display:column property="fields14" title="Managing Up" style="width:7"/>
	<display:column property="fields15" title="Total(%)" style="width:7"/>
	
<%
		}
	}
%>
	<display:column property="fields7" titleKey="prompt.vote.reason" style="width:"/>
	
<% if (module!=null){ %>	
<%	if(module.equals("starOfTheQuarter") || module.equals("yearOfEmp_starOfQuart")){%>
		<display:column property="fields15" title="Allow Disclose" style="width:"/>
<%	 }else if(module.equals("yearOfEmployee")){%>
		<display:column property="fields17" title="Allow Disclose" style="width:"/>
<%	 }else{%>
		<display:column property="fields9" title="Allow Disclose" style="width:"/>
<% 	}%>
<%  if(module.equals("eSHARE")){ %>		
		<display:column property="fields10" title="Nominator Email" style="width:"/>
		<display:column property="fields11" title="Nominator Phone" style="width:"/>
<%	} %>
<%} %>
</display:table>

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


<script language="javascript">
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
		$('table.contentFrameSearch').find('select#module').val("ALL");
		$('table.contentFrameSearch').find('select#day_yy').val("");
	}

	
</script>