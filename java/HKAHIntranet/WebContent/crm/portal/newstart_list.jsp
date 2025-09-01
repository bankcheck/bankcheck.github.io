<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>

<%!
private ArrayList getClientPastResult(UserBean userBean) {	
	StringBuffer sqlStr = new StringBuffer();	
	
	sqlStr.append("SELECT DISTINCT CRM_QUESTIONAIRE_CAID ,CRM_CREATED_DATE ");
	sqlStr.append("FROM   CRM_QUESTIONAIRE_CLIENT_ANSWER ");	
	sqlStr.append("WHERE CRM_ENABLED = '1' ");	
	sqlStr.append("AND   CRM_CLIENT_ID = '"+CRMClientDB.getClientID(userBean.getUserName())+"' ");
	sqlStr.append("ORDER BY CRM_CREATED_DATE DESC");
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private ArrayList getCRMClientDoneWeekTest(UserBean userBean,String thisWeekStartOfDate,String thisWeekEndOfDate) {	
	StringBuffer sqlStr = new StringBuffer();	
	sqlStr.append("SELECT * ");
	sqlStr.append("FROM CRM_QUESTIONAIRE_CLIENT_ANSWER ");	
	sqlStr.append("WHERE CRM_CREATED_DATE BETWEEN TO_DATE('"+thisWeekStartOfDate+" 00:00:00' ,'dd/mm/yyyy HH24:MI:SS')  ");	
	sqlStr.append("AND TO_DATE('"+thisWeekEndOfDate+" 23:59:59' , 'dd/mm/yyyy HH24:MI:SS') ");
	sqlStr.append("AND CRM_CLIENT_ID = '"+CRMClientDB.getClientID(userBean.getUserName())+"' ");
	sqlStr.append("AND CRM_ENABLED = '1' ");
	//System.out.println(sqlStr.toString());
	return  UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");

Calendar thisWeekStartOfDate = Calendar.getInstance();
thisWeekStartOfDate.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);

Calendar thisWeekEndOfDate = Calendar.getInstance();
thisWeekEndOfDate.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);
ArrayList testWeekRecord = getCRMClientDoneWeekTest(userBean,df.format(thisWeekStartOfDate.getTime()),df.format(thisWeekEndOfDate.getTime()));

boolean clientWeeklyTestDone = false;
if(testWeekRecord.size()>0){
	clientWeeklyTestDone = true;
}

String message = "";
String errorMessage = "";

try {
	request.setAttribute("client_answer_list", getClientPastResult(userBean));
		

} catch (Exception e) {
	e.printStackTrace();
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="header.jsp"/>
<body>
<DIV id=contentFrame style="width:100%;height:100%">
<jsp:include page="../../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Log Book" />
	<jsp:param name="category" value="group.crm" />
	<jsp:param name="keepReferer" value="N" />
	<jsp:param name="isHideTitle" value="Y" />
</jsp:include>
<jsp:include page="title.jsp">
	<jsp:param name="title" value="Log Book"/>
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<%
if(clientWeeklyTestDone){ 
%>
	<div style="color:green;font-weight:bold">[ 已完成本星期評估 ]</div>
<%
}else{
%>
	<button  onclick="newstartTest()" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
		尚未完成本星期評估
	</button>
<%	
}
%>
<bean:define id="functionLabel">Log Book</bean:define>
<form name="search_form" action="newstart_list.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
</table>
</form>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<br/>
<div class="crmField3">過去每周評估記錄</div>
<form name="form1" action="newstart_test.jsp" method="post">
<display:table id="row" name="requestScope.client_answer_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	
	<display:column title="Date" style="text-align:center">		
		<c:set var="tempDate" value="${row.fields1}"/>	
<%						
	String tempDate = (String)pageContext.getAttribute("tempDate") ;
	Calendar clientDate = Calendar.getInstance();
	
	String[] date = tempDate.split(" ");
	String year = date[0].split("-")[0];
	String month = date[0].split("-")[1];
	String day = date[0].split("-")[2];
	clientDate.set(Integer.parseInt(year), Integer.parseInt(month)-1, Integer.parseInt(day));	
	
	//must have
	System.out.println(df.format(clientDate.getTime()));
	
	Calendar startOfWeekDate = (Calendar)clientDate.clone();
	startOfWeekDate.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
	
	Calendar endOfWeekDate = (Calendar)clientDate.clone();
	endOfWeekDate.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);
%>
	<c:out value='<%=df.format(startOfWeekDate.getTime())%>'/> - <c:out value='<%=df.format(endOfWeekDate.getTime())%>'/> 
	</display:column>
	
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">		
		<button onclick="return submitAction('view','<c:out value="${row.fields0}" />','<c:out value="${row.fields1}" />');"><bean:message key="button.view" /></button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
</form>
<script language="javascript">
<!--
	function submitAction(cmd,caid,date) {
		callPopUpWindow('../../crm/portal/newstart_test.jsp?command='+cmd+'&questionaireCAID='+caid+'&clientAnswerDate='+date);
		
		return false;
	}
	
	function newstartTest(eid) {
		callPopUpWindow('../../crm/portal/newstart_test.jsp');
	
	}
		
-->
</script>
</DIV>
<jsp:include page="../../common/footer.jsp" flush="false" />
</body>
</html:html>