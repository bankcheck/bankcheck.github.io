<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.*"%>

<%
UserBean userBean = new UserBean(request);

String category = "title.ic.report";
String reportCode = ParserUtil.getParameter(request, "reportCode");
 

//System.out.println("reportCode : " + reportCode);

List<String> reportKeys = new ArrayList<String>();
reportKeys.add("ge");
reportKeys.add("resp");
reportKeys.add("bld"); 
reportKeys.add("mrsa");
reportKeys.add("icu");
reportKeys.add("icu_daily");
//reportKeys.add("esbl");
//reportKeys.add("bld_mrsa_esbl");
//reportKeys.add("bld_esbl_mrsa");
//reportKeys.add("mrsa");
reportKeys.add("ssi");
//reportKeys.add("bld");
//reportKeys.add("esbl");
reportKeys.add("others");

String selectedReportKey = request.getParameter("selectedReportKey");
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
<div id=indexWrapper>
<div id=mainFrame>
<div id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.ic.reports" />
	<jsp:param name="category" value="<%=category %>" />
</jsp:include>
<form name="tab_form" action="report.jsp" method="post">
<table width="100%">
	<tr>
		<td>
			<ul id="tabList">
			<%
				for (Iterator<String> it = reportKeys.iterator(); it.hasNext();) {
					String thisReportCode = it.next();
					String reportKey = "function.ic." + thisReportCode;
			%>
					<li><a href="javascript:void(0);" onclick="submitTabAction('<%=thisReportCode %>', true);" tabId="tab_<%=thisReportCode %>" id="tab_<%=thisReportCode %>" class="linkUnSelected"><span><bean:message key="<%=reportKey %>" /></span></a></li>
			<%		
				}
			%>
			</ul>
		</td>
	</tr>
</table>

<input type="hidden" name="command" value="" />

</form>
<div id="report_form" />
<script language="javascript">
	function submitTabSearch(c, resetTab) {
		//show loading image
		document.getElementById("report_form").innerHTML = '<img src="../images/wait30trans.gif">';

		// ajax load form
		var listFileName = c + '_list.jsp';
		if (c == 'ge' || c == 'resp') {
			listFileName = 'ge_resp_list.jsp';
		} else if (c == 'bld' || c == 'mrsa' || c == 'esbl') {
			listFileName = 'bld_mrsa_esbl_list.jsp';
		}
		// pass parameters to enclosing jsp
		var param;
		if (resetTab) {
			param = {
					tabPanelName: "report",
					dummy: new Date(),
					icType : c				
				};
		} else {
			param = {
					tabPanelName: "report",
					dummy: new Date(),
					icType : c
					<%
						// get post request parameters
				    	Enumeration e1 = request.getParameterNames();
				    	String paraName = null;
				    	while (e1.hasMoreElements()) {
				    		paraName = e1.nextElement().toString();
				    		if (!"icType".equals(paraName)) {
				    		%>
				    , <%=paraName %> : "<%=request.getParameter(paraName) %>"
				    		<%
				    		}
				    	}
					%>
					
				};
		}

		$('#report_form').load(listFileName, param);
	}

	function submitTabAction(c, resetTab) {
		resetTabBar();
		switchTab(c);
		submitTabSearch(c, resetTab);
	}
	
	function switchTab(c) {
		var tabId = 'tab_' + c;
		document.getElementById(tabId).className = 'linkSelected';
	}
	
	function resetTabBar() {
		<%
			for (Iterator<String> it = reportKeys.iterator(); it.hasNext();) {
				String thisReportCode = it.next();
		%>
		document.getElementById('tab_<%=thisReportCode %>').className = 'linkUnSelected';
		<%		
			}
		%>
	}
	
	// set default loading
	<%
		String submitReportCode;
		
		if (reportCode != null) {
			submitReportCode = reportCode;
		} else {
			submitReportCode = reportKeys.get(0);
		}
	%>
	submitTabAction('<%=submitReportCode %>');
</script>

</div>
</div>
</div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>