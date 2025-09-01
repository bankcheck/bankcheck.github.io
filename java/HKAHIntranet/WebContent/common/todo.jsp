<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchTask(String loginID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TD.CO_TODO_ID, TD.CO_TASK_ID, TK.CO_TASK_NAME, ");
		sqlStr.append("       TO_CHAR(TD.CO_MODIFIED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TK.CO_FUNCTION_URL, ");
		sqlStr.append("       TK.CO_JOB_NAME, TD.CO_JOB_ID, ");
		sqlStr.append("       TK.CO_CLASS_NAME, TD.CO_CLASS_ID, ");
		sqlStr.append("       C.CO_EVENT_DESC, ");
		sqlStr.append("       TO_CHAR(S.CO_SCHEDULE_START, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(S.CO_SCHEDULE_START, 'HH24:MI'), ");
		sqlStr.append("       TO_CHAR(S.CO_SCHEDULE_END, 'HH24:MI'), ");
		sqlStr.append("       S.CO_LOCATION_DESC ");
		sqlStr.append("FROM   CO_TODO TD, CO_TASK TK, CO_SCHEDULE S, CO_EVENT C ");
		sqlStr.append("WHERE  TD.CO_TASK_ID = TK.CO_TASK_ID ");
		sqlStr.append("AND    TD.CO_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    TD.CO_JOB_ID = S.CO_EVENT_ID ");
		sqlStr.append("AND    TD.CO_CLASS_ID = S.CO_SCHEDULE_ID ");
		sqlStr.append("AND    S.CO_SITE_CODE = C.CO_SITE_CODE ");
		sqlStr.append("AND    S.CO_MODULE_CODE = C.CO_MODULE_CODE ");
		sqlStr.append("AND    S.CO_EVENT_ID = C.CO_EVENT_ID ");
		sqlStr.append("AND    TD.CO_ENABLED = 1 ");
		sqlStr.append("AND    TD.CO_USERNAME = ? ");
		sqlStr.append("AND    S.CO_MODULE_CODE = 'education' ");
		sqlStr.append("ORDER BY TD.CO_TODO_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { loginID });
	}
	
	private ArrayList fetchEleaveTask(String loginID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TD.CO_TODO_ID, TD.CO_TASK_ID, TK.CO_TASK_NAME, ");
		sqlStr.append("       TO_CHAR(TD.CO_MODIFIED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TK.CO_FUNCTION_URL, ");
		sqlStr.append("       TK.CO_JOB_NAME, TD.CO_JOB_ID, ");
		sqlStr.append("       TK.CO_CLASS_NAME, TD.CO_CLASS_ID, ");   
		sqlStr.append(" 	  E.EL_STAFF_ID, E.EL_LEAVE_TYPE, ");  //eleave data ..
		sqlStr.append("       TO_CHAR(E.EL_FROM_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append(" 	  TO_CHAR(E.EL_TO_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append(" 	  E.EL_APPLIED_DAYS, E.EL_REMARKS   ");	
		sqlStr.append("FROM   CO_TODO TD, CO_TASK TK, EL_ELEAVE E  ");
		sqlStr.append("WHERE  TD.CO_TASK_ID = TK.CO_TASK_ID ");
		sqlStr.append("AND    TD.CO_SITE_CODE = E.EL_SITE_CODE ");
		sqlStr.append("AND    TD.CO_JOB_ID = E.EL_ELEAVE_ID ");
		sqlStr.append("AND    TD.CO_ENABLED = 1 ");
		sqlStr.append("AND    TD.CO_USERNAME = ? ");
		sqlStr.append("ORDER BY TD.CO_TODO_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { loginID });
	}
	
	private ArrayList fetchCETask(String loginID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TD.CO_TODO_ID, TD.CO_TASK_ID, TK.CO_TASK_NAME, ");
		sqlStr.append("       TO_CHAR(TD.CO_MODIFIED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TK.CO_FUNCTION_URL, ");
		sqlStr.append("       TK.CO_JOB_NAME, TD.CO_JOB_ID, ");
		sqlStr.append("       TK.CO_CLASS_NAME, TD.CO_CLASS_ID, ");   
		sqlStr.append(" 	  CE.CE_STAFF_ID, CE.CE_COURSE_NAME, ");  //CE Data ..
		sqlStr.append("       TO_CHAR(CE.CE_FROM_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append(" 	  TO_CHAR(CE.CE_TO_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append(" 	  CE.CE_APPLIED_HOURS ");	
		sqlStr.append("FROM   CO_TODO TD, CO_TASK TK, CE_CONTINUING_EDUCATION CE  ");
		sqlStr.append("WHERE  TD.CO_TASK_ID = TK.CO_TASK_ID ");
		sqlStr.append("AND    TD.CO_SITE_CODE = CE.CE_SITE_CODE ");
		sqlStr.append("AND    TD.CO_JOB_ID = CE.CE_CONTINUING_EDUCATION_ID ");
		sqlStr.append("AND    TD.CO_ENABLED = 1 ");
		sqlStr.append("AND    TD.CO_USERNAME = ? ");
		sqlStr.append("ORDER BY TD.CO_TODO_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { loginID });
	}
	
	
%>
<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String todoID = request.getParameter("todoID");
String message = request.getParameter("message");

if (todoID != null) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("UPDATE CO_TODO ");
	sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
	sqlStr.append("WHERE  CO_TODO_ID = ? ");
	sqlStr.append("AND    CO_ENABLED = 1");

	UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { loginID, todoID } );
}

request.setAttribute("todo_list", fetchTask(loginID));
request.setAttribute("todoEleave_list", fetchEleaveTask(loginID));
request.setAttribute("todoCE_list", fetchCETask(loginID));
if (message == null) {
	message = "";
}
String errorMessage = "";
%>
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
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.todo.list" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<table><!-- dummy --></table>
<bean:define id="functionLabel"><bean:message key="prompt.task" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form name="form1">
<%
ArrayList result = (ArrayList) request.getAttribute("todo_list");
ReportableListObject reportableListObject = null;
boolean hasFound=false;
if (result.size() > 0) {
	for (int i = 0; i < result.size(); i++) {
		reportableListObject = (ReportableListObject) result.get(i);
%>
<div class="pane">
<table width="100%">
<tr>
	<td width="30%"><html:img page="/images/code.gif" /><%=reportableListObject.getValue(2) %><br><%=reportableListObject.getValue(9) %> <%=reportableListObject.getValue(10) %></td>
	<td width="35%" align="right"><button onclick="return removeToDo('<%=reportableListObject.getValue(0) %>');" class="btn-deleteToDo"><bean:message key="button.delete" /></button></td>
	<td width="35%" align="left">
			<button onclick="return submitAction('..<%=reportableListObject.getValue(4) %>','<%=reportableListObject.getValue(6) %>','<%=reportableListObject.getValue(8) %>');"><bean:message key="button.view" /></button>
	</td>		
</tr>
</table>

</div>
<%
	}
	hasFound=true;
} 
%>
<%
ArrayList result2 = (ArrayList) request.getAttribute("todoCE_list");
ReportableListObject reportableListObject2 = null;
if (result2.size() > 0) {
	for (int i = 0; i < result2.size(); i++) {
		reportableListObject2 = (ReportableListObject) result2.get(i);
%>
<div class="pane">
<table width="100%">
<tr>
	<td width="30%"><html:img page="/images/document.gif" /><%=reportableListObject2.getValue(2) %>
				<br> Staff ID:  <%=reportableListObject2.getValue(9) %> Course Name: <%=reportableListObject2.getValue(10) %> 
				<br> Date: <%=reportableListObject2.getValue(11) %> -- <%=reportableListObject2.getValue(12) %> 	Hours: <%=reportableListObject2.getValue(13) %>
	<td width="35%" align="right"><button onclick="return removeToDo('<%=reportableListObject2.getValue(0) %>');" class="btn-deleteToDo"><bean:message key="button.delete" /></button></td>
	<td width="35%" align="left">
			<button onclick="return submitCEAction('..<%=reportableListObject2.getValue(4) %>','<%=reportableListObject2.getValue(6) %>','<%=reportableListObject2.getValue(9) %>');"><bean:message key="button.view" /></button>
	</td>		
</tr>
</table>
</div>
<%
	}
	hasFound=true;
} 
if(!hasFound){
	out.println(notFoundMsg);
}
%>

<input type="hidden" name="command" value="detail">
<input type="hidden" name="step">
<input type="hidden" name="todoID">
<input type="hidden" name="courseID">
<input type="hidden" name="classID">
<input type="hidden" name="eleaveID">
<input type="hidden" name="ceID">
<input type="hidden" name="staffID">

</form>
<script type="text/javascript">
	$(document).ready(function(){
		$(".pane:even").addClass("alt");

		$(".pane .btn-deleteToDo").click(function(){
			$(this).parents(".pane").animate({ backgroundColor: "#fbc7c7" }, "fast")
			.animate({ opacity: "hide" }, "slow")
			$(this).remove();
		});
	});

	function submitAction(url, courseID, classID) {
	
		document.form1.action = url;
		document.form1.courseID.value = courseID;
		document.form1.classID.value = classID;
		document.form1.submit();
		return true;
	}

	function submitApplyAction(url, eleaveID,staffID){
		document.form1.command.value="view";
		document.form1.step.value=0;
	    document.form1.action = url;
		document.form1.eleaveID.value = eleaveID;
		document.form1.staffID.value = staffID;
		document.form1.submit();
		return true;
	}
	
	function submitCEAction(url, ceID,staffID){
		document.form1.command.value="view";
		document.form1.step.value=0;
	    document.form1.action = url;
		document.form1.ceID.value = ceID;
		document.form1.staffID.value = staffID;
		document.form1.submit();
		return true;
	}


	// ajax
	var http = createRequestObject();

	function removeToDo(tid) {
		//make a connection to the server ... specifying that you intend to make a GET request
		//to the server. Specifiy the page name and the URL parameters to send
		http.open('get', 'todo.jsp?todoID=' + tid + '&timestamp=<%=(new java.util.Date()).getTime() %>');

		//assign a handler for the response
		http.onreadystatechange = processResponse;

		//actually send the request to the server
		http.send(null);
	}

	function processResponse() {
		//check if the response has been received from the server
		if (http.readyState == 4){

			//read and assign the response from the server
			var response = http.responseText;

			//do additional parsing of the response, if needed

			//If the server returned an error message like a 404 error, that message would be shown within the div tag!!.
			//So it may be worth doing some basic error before setting the contents of the <div>
		}
	}
</script>