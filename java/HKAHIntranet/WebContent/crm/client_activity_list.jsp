<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchActivity(String client_ID) {
		// fetch client activity
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CA.CRM_CLIENT_ACTIVITY_ID, A.CRM_ACTIVITY_DESC,  ");
		sqlStr.append("       TO_CHAR(CA.CRM_ACTIVITY_DATE,'DD/MM/YYYY'), ");
		sqlStr.append("       E.CRM_EVENT_DESC, CA.CRM_REMARKS, ");
		sqlStr.append("       CA.CRM_MEDICAL_ID, CA.CRM_QUESTIONAIRE_ID, CA.CO_DOCUMENT_ID ");
		sqlStr.append("FROM   CRM_CLIENTS_ACTIVITIES CA, CRM_ACTIVITIES A, CRM_EVENTS E ");
		sqlStr.append("WHERE  CA.CRM_ACTIVITY_ID = A.CRM_ACTIVITY_ID ");
		sqlStr.append("AND    CA.CRM_EVENT_ID = E.CRM_EVENT_ID (+) ");
		sqlStr.append("AND    CA.CRM_ENABLED = 1 ");
		sqlStr.append("AND    CA.CRM_CLIENT_ID = '");
		sqlStr.append(client_ID);
		sqlStr.append("' ");
		sqlStr.append("ORDER BY CA.CRM_ACTIVITY_DATE DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
UserBean userBean = new UserBean(request);
String clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);
//String clientID = request.getParameter("clientID");

request.setAttribute("activity_history", fetchActivity(clientID));

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
<body>
<jsp:include page="../common/banner2.jsp"/>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.activityHistory.list" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<jsp:include page="client_info_brief.jsp" flush="false">
	<jsp:param name="tabId" value="5" />
</jsp:include>

<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel"><bean:message key="function.activityHistory.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1" action="client_activity.jsp" method="post">
<display:table id="row" name="requestScope.activity_history" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" titleKey="prompt.activity" class="smallText" style="width:10%" />
	<display:column property="fields2" titleKey="prompt.date" class="smallText" style="width:10%" />
	<display:column property="fields3" titleKey="prompt.event" class="smallText" style="width:10%" />
	<display:column property="fields4" titleKey="prompt.remarks" class="smallText" style="width:10%" />
	<display:column titleKey="prompt.physicalInfo" media="html" class="smallText" style="width:10%">
		<button onclick="return submitAction('view', '<c:out value="${row.fields5}" />','medical','');"><bean:message key="button.view" /></button>
	</display:column>
	<display:column titleKey="prompt.questionnaire" media="html" class="smallText" style="width:10%">
		<button onclick="return submitAction('view', '<c:out value="${row.fields6}" />','questionnaire','');"><bean:message key="button.view" /></button>
	</display:column>
	<display:column property="fields7" titleKey="prompt.attachment" href="${row.fields8}" paramId="fields7" class="smallText" style="width:5%" />
	<display:column titleKey="prompt.action" media="html" class="smallText" style="width:10%">
		<button onclick="return submitAction('view', '<c:out value="${row.fields8}" />','','0');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center"><button onclick="return submitAction('create', '<c:out value="${row.fields0}" />','','0');"><bean:message key="function.activityHistory.create" /></button></td>
	</tr>
</table>
<input type="hidden" name="command" value="" />
<input type="hidden" name="questionnaireID" value=""/>
<input type="hidden" name="step" value=""/>
<input type="hidden" name="medicalID" value=""/>
<input type="hidden" name="activityID"/>
<input type="hidden" name="clientID"  value="<%=clientID %>" />
</form>

<script language="javascript">
	function submitAction(cmd, id, type, step) {
		if (type == 'medical') {
		    document.form1.action = "client_medical.jsp";
			document.form1.medicalID.value = id;
		} else if (type == 'questionnaire') {
			document.form1.action = "questionnaire.jsp";
			document.form1.questionnaireID.value = id;
		} else {
			document.form1.activityID.value = id;
		}
		document.form1.command.value = cmd;
		document.form1.step.value = step;
  		document.form1.submit();
	}
</script>

</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>