<%@ page import="java.util.*"%>
<%@ page import="org.quartz.*"%>
<%@ page import="org.quartz.impl.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList fetchScheduleTask() {
		// fetch access_control
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_SCHEDULE_ID, CO_JOB_NAME, CO_JOB_CLASS, CO_CRON_EXPRESSION ");
		sqlStr.append("FROM   CO_SCHEDULE_SERVER ");
		sqlStr.append("WHERE  CO_ENABLED = '1' ");
		sqlStr.append("ORDER BY CO_SCHEDULE_ID ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList fetchRealScheduleTask() {
		ArrayList<ReportableListObject> record = new ArrayList<ReportableListObject>();
		ReportableListObject row = null;

		try {
			SchedulerFactory sf = new StdSchedulerFactory();
			Scheduler scheduler = sf.getScheduler();
			Trigger[] triggers = null;
			Date nextFireTime = null;
	
			// loop all group
			for (String groupName : scheduler.getJobGroupNames()) {
				// loop all jobs by groupname
				for (String jobName : scheduler.getJobNames(groupName)) {
					// get job's trigger
		  			triggers = scheduler.getTriggersOfJob(jobName, groupName);
						
					row = new ReportableListObject(5);
					row.setValue(0, jobName);
					row.setValue(1, groupName);
					row.setValue(2, String.valueOf(triggers.length));
					row.setValue(3, DateTimeUtil.formatDateTime(triggers[0].getPreviousFireTime()));
					row.setValue(4, DateTimeUtil.formatDateTime(triggers[0].getNextFireTime()));
					record.add(row);
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		return record;
	}

	private ArrayList fetchScheduleTask(String scheduleID) {
		// fetch access_control
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_JOB_CLASS ");
		sqlStr.append("FROM   CO_SCHEDULE_SERVER ");
		sqlStr.append("WHERE  CO_ENABLED = '1' ");
		sqlStr.append("AND    CO_SCHEDULE_ID = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { scheduleID });
	}

	private boolean runScheduleTask(String jobName, String groupName) {
		try {
			SchedulerFactory sf = new StdSchedulerFactory();
			Scheduler scheduler = sf.getScheduler();
	
			// get job's trigger
  			Trigger[] triggers = scheduler.getTriggersOfJob(jobName, groupName);

			if (triggers.length > 0) {
  				scheduler.triggerJob(jobName, groupName);
  			}
				
			return true;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return false;
	}
%>
<%
UserBean userBean = new UserBean(request);
request.setAttribute("schedule_task_list", fetchRealScheduleTask());

String command = request.getParameter("command");
String jobName = request.getParameter("jobName");
String groupName = request.getParameter("groupName");
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

if ("restart".equals(command)) {
	if (jobName != null && jobName.length() > 0 && groupName != null && groupName.length() > 0 && runScheduleTask(jobName, groupName)) {
		message = "The schedule is restarted.";
	} else {
		errorMessage = "The schedule is failed to restart.";
	}
}

if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}
%><!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
	<jsp:param name="pageTitle" value="Server Schedule Task List" />
	<jsp:param name="category" value="prompt.admin" />
</jsp:include>
<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>
<bean:define id="functionLabel">Schedule Task</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<form action="schedule_task_list.jsp" name="form1" method="post">
<display:table id="row" name="requestScope.schedule_task_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields0" titleKey="prompt.task" style="width:20%" />
	<display:column property="fields2" title="No. of Trigger" style="width:15%" />
	<display:column property="fields3" title="Previous Schedule" style="width:15%" />
	<display:column property="fields4" title="Next Schedule" style="width:15%" />
	<display:column titleKey="prompt.action" media="html" style="width:15%; text-align:center">
		<button onclick="return submitAction('<c:out value="${row.fields0}" />', '<c:out value="${row.fields1}" />');">Resend</button>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<input type="hidden" name="command">
<input type="hidden" name="jobName">
<input type="hidden" name="groupName">
</form>

<script language="javascript">
	function submitAction(jid, gid) {
		document.form1.command.value = 'restart';
		document.form1.jobName.value = jid;
		document.form1.groupName.value = gid;
		document.form1.submit();
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>