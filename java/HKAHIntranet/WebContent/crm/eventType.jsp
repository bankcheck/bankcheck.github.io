<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String step = request.getParameter("step");
String groupID = request.getParameter("groupID");
String groupDesc = TextUtil.parseStrUTF8(request.getParameter("groupDesc"));

String figureID = request.getParameter("figureID");
String figureDesc = TextUtil.parseStrUTF8(request.getParameter("figureDesc"));
String measure = TextUtil.parseStrUTF8(request.getParameter("measure"));
String type = request.getParameter("type");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

boolean levelOne = false;
boolean levelTwo = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

// set show level
if ("2".equals(step) || "3".equals(step)) {
	levelTwo = true;
} else {
	levelOne = true;
}
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	if (createAction) {
		commandType = "create";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	if (levelTwo) {
		title = "function.crm.physicalFigure." + commandType;
	} else {
		title = "function.eventType." + commandType;
	}
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<form name="form1" action="physical_group.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.description" /></td>
		<td class="infoData" width="70%">
<%	if (levelOne && (createAction || updateAction)) { %>
			<input type="textfield" name="groupDesc" value="<%=groupDesc==null?"":groupDesc %>" maxlength="100" size="50">
<%	} else { %>
			<%=groupDesc==null?"":groupDesc %>
<%	} %>
		</td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%	if (levelOne && (createAction || updateAction || deleteAction)) { %>
			<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%	} else { %>
			<button onclick="return submitAction('update', 0);" class="btn-click"><bean:message key="function.eventType.update" /></button>
			<button class="btn-delete"><bean:message key="function.eventType.delete" /></button>
<%	} %>
		</td>
	</tr>
</table>
</div>
<%
	if (groupID != null && groupID.length() > 0) {
		if (levelTwo) {
%>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.description" /></td>
		<td class="infoData" width="70%">
<%		if (levelTwo && (createAction || updateAction)) { %>
			<input type="textfield" name="figureDesc" value="<%=figureDesc==null?"":figureDesc %>" maxlength="100" size="50">
<%		} else { %>
			<%=figureDesc==null?"":figureDesc %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Measurement</td>
		<td class="infoData" width="70%">
<%		if (levelTwo && (createAction || updateAction)) { %>
			<input type="textfield" name="measure" value="<%=measure==null?"":measure %>" maxlength="100" size="50">
<%		} else { %>
			<%=measure==null?"":measure %>
<%		} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.type" /></td>
		<td class="infoData" width="80%">
<%		if (levelTwo && (createAction || updateAction)) { %>
			<input type="radio" name="type" value="string"<%="string".equals(type)?" checked":"" %>>Free Text
			<input type="radio" name="type" value="boolean"<%="boolean".equals(type)?" checked":"" %>><bean:message key="label.yes" />/<bean:message key="label.no" />
<%		} else {
			if ("string".equals(type)) {
				%>Free Text<%
			} else if ("string".equals(type)) {
				%><bean:message key="label.yes" />/<bean:message key="label.no" /><%
			}
		} %>
		</td>
	</tr>
</table>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%		if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=commandType %>', 3);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /> - <bean:message key="<%=title %>" /></button>
<%		} else { %>
			<button onclick="return submitAction('update', 2);" class="btn-click"><bean:message key="function.crm.physicalFigure.update" /></button>
			<button class="btn-delete2"><bean:message key="function.crm.physicalFigure.delete" /></button>
<%		} %>
		</td>
	</tr>
</table>
</div>
<%
		} else if (levelOne && !createAction && !updateAction && !deleteAction) {
%>
<bean:define id="functionLabel"><bean:message key="function.eventType.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="physical_group.jsp" method="post">
<display:table id="row" name="requestScope.physicalFigure_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" title="Figure" class="smallText" style="width:30%" />
	<display:column property="fields2" title="Measurement" class="smallText" style="width:25%" />
	<display:column property="fields4" titleKey="prompt.modifiedDate" class="smallText" style="width:20%" />
	<display:column titleKey="prompt.action" media="html" class="smallText" style="width:10%">
		<button onclick="return submitAction('view', '2', '<c:out value="${row.fields0}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '2');"><bean:message key="function.crm.physicalFigure.create" /></button></td>
	</tr>
</table>
<%		}%>
<%	}%>
<input type="hidden" name="command" value="" />
<input type="hidden" name="step" value="" />
<input type="hidden" name="groupID" value="<%=groupID==null?"":groupID %>" />
<input type="hidden" name="figureID" value="<%=figureID==null?"":figureID %>" />
</form>
<bean:define id="descriptionLabel"><bean:message key="prompt.description" /></bean:define>
<script language="javascript">
	function submitAction(cmd, stp, fid) {
		if (stp == 1 && (cmd == 'create' || cmd == 'update')) {
			if (document.form1.groupDesc.value == '') {
				alert("<bean:message key="errors.required" arg0="<%=descriptionLabel %>" />.");
				document.form1.groupDesc.focus();
				return false;
			}
		} else if (stp == 2 && cmd == 'view') {
			document.form1.figureID.value = fid;
		} else if (stp == 3 && (cmd == 'create' || cmd == 'update')) {
			if (document.form1.figureDesc.value == '') {
				alert("<bean:message key="errors.required" arg0="<%=descriptionLabel %>" />.");
				document.form1.figureDesc.focus();
				return false;
			}
		}
		document.form1.command.value = cmd;
		document.form1.step.value = stp;
		document.form1.submit();
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>