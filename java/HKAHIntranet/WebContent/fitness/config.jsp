<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String ruleNum = request.getParameter("ruleNum");
String desc = request.getParameter("desc");
String timeslot = request.getParameter("timeslot");
String value = request.getParameter("value");
String startdate = request.getParameter("startdate");
String enddate = request.getParameter("enddate");
String type = request.getParameter("type");
String enable = request.getParameter("enable");

String command = request.getParameter("command");
String message = request.getParameter("message");
String showAll = request.getParameter("showAll");

if (message == null) {
	message = "";	
}

String errorMessage = "";

if ("enable".equals(command)){
	if (FitnessDB.setActive(userBean, ruleNum, true)) {
		message = "Rule enabled";
	} else {
		errorMessage = "failed to enable rule";
	}
}

if ("disable".equals(command)){
	if (FitnessDB.setActive(userBean, ruleNum, false)) {
		message = "Rule disabled";
	} else {
		errorMessage = "failed to disable rule";
	}
}

if ("1".equals(showAll)){
	request.setAttribute("config_list", FitnessDB.getConfigList(true));
} else {
	request.setAttribute("config_list", FitnessDB.getConfigList(false));
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
	<jsp:param name="pageTitle" value="function.fitness.maintenance" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>

<form name="form1" action="config.jsp" method="post">
<bean:define id="functionLabel"><bean:message key="function.fitness.maintenance" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.config_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<logic:equal name="row" property="fields7" value="1">
		<display:column property="fields0" titleKey="prompt.key" class="bold" style="width:5%" />
		<display:column property="fields1" titleKey="prompt.startDate"  class="bold" style="width:8%" />
		<display:column property="fields2" titleKey="prompt.type" class="bold" style="width:5%" />
		<display:column property="fields3" titleKey="prompt.time" class="bold" style="width:9%" />
		<display:column property="fields4" titleKey="prompt.description" class="bold" style="width:35%" />
		<display:column property="fields5" titleKey="prompt.available" class="bold" style="width:8%" />
		<display:column property="fields6" titleKey="prompt.termDate" class="bold" style="width:8%" />
		<display:column titleKey="prompt.action" media="html" style="width:12%; text-align:center">
			<button onclick="return editAction('<c:out value="${row.fields0}" />');"><bean:message key='button.edit' /></button>
		    <button onclick="return disableAction('<c:out value="${row.fields0}" />');">Disable</button>
		</display:column>
	</logic:equal>
	
	<logic:notEqual name="row" property="fields7" value="1">
		<display:column property="fields0" titleKey="prompt.key" class="clear" style="width:5%" />
		<display:column property="fields1" titleKey="prompt.startDate" class="clear" style="width:8%" />
		<display:column property="fields2" titleKey="prompt.type" class="clear" style="width:5%" />
		<display:column property="fields3" titleKey="prompt.time" class="clear" style="width:9%" />
		<display:column property="fields4" titleKey="prompt.description" class="clear" style="width:35%" />
		<display:column property="fields5" titleKey="prompt.available" class="clear" style="width:8%" />
		<display:column property="fields6" titleKey="prompt.termDate" class="clear" style="width:8%" />
		<display:column titleKey="prompt.action" media="html" class="clear" style="width:12%; text-align:center">
			<button onclick="return editAction('<c:out value="${row.fields0}" />');"><bean:message key='button.edit' /></button>
			<button onclick="return enableAction('<c:out value="${row.fields0}" />');">Enable</button>
		</display:column>
	</logic:notEqual>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>		
</display:table>
<center>
	<input type="hidden" name="command" id="command"/>
	<input type="hidden" name="showAll" id="showAll" value="<%=showAll %>" />
	<input type="hidden" name="ruleNum" id="ruleNum"/>

	<button class="btn-click" onclick="return createAction();"><bean:message key="button.add" /></button>
<% if ("1".equals(showAll)) { %>
	<button class="btn-click" onclick="return showActive();">Show Active</button>
<% } else { %>	
	<button class="btn-click" onclick="return showAllRec();">Show All</button>
<% } %>	
</center>	
</form>
<script language="javascript">
<!--	
	function enableAction(ruleNum) {
		document.getElementById("command").value = "enable";
		document.getElementById("ruleNum").value = ruleNum;
		document.form1.submit();
		return false;		
	}
	
	function disableAction(ruleNum) {
		document.getElementById("command").value = "disable";
		document.getElementById("ruleNum").value = ruleNum;
		document.form1.submit();
		return false;		
	}
	
	function showAllRec() {
		document.getElementById("showAll").value = "1";
		document.form1.submit();
		return false;		
	}	
	
	function showActive() {
		document.getElementById("showAll").value = "0";
		document.form1.submit();
		return false;		
	}	
	
	function editAction(ruleNum) {
		callPopUpWindow("config_entry.jsp?command=edit&ruleNum=" + ruleNum);
		return false;
	}
	
	function createAction() {
		callPopUpWindow("config_entry.jsp?command=new");
		return false;
	}
-->	
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>