<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "command");
String deptCode = ParserUtil.getParameter(request, "deptCode");
String fiscalYear = ParserUtil.getParameter(request, "fiscalYear_yy");
String planID = ParserUtil.getParameter(request, "planID");
String goalID = ParserUtil.getParameter(request, "goalID");
String taskID = ParserUtil.getParameter(request, "taskID");
String taskOrder = ParserUtil.getParameter(request, "taskOrder");

String taskDesc = null;
String taskEstimateCompleteDate = null;
String taskActualCompleteDate = null;
String progressID = null;
String progressStatus = null;
String progressContent = null;
String progressUpdatedDate = null;
String adminID = null;
String adminContent = null;
String adminResponse = null;
String isAllowUpdateYN = null;

String tempTaskID = null;
String adminApprovedYN = null;
String adminApprovedDate = null;
String adminApprovedBy = null;
String adminApprovedByName = null;

boolean isTaskApproved = false;
boolean isCurrentTask = false;
boolean isAllowUpdate = false;

boolean allowApproval = userBean.isOfficeAdministrator();

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean updateGoalAction = false;
boolean createTaskAction = false;
boolean updateTaskAction = false;
boolean createEvaluationAction = false;
boolean updateEvaluationAction = false;
boolean upTaskOrderAction = false;
boolean downTaskOrderAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("updateGoal".equals(command)) {
	updateGoalAction = true;
} else if ("createTask".equals(command)) {
	createTaskAction = true;
} else if ("updateTask".equals(command)) {
	updateTaskAction = true;
} else if ("createEvaluation".equals(command)) {
	createEvaluationAction = true;
} else if ("updateEvaluation".equals(command)) {
	updateEvaluationAction = true;
} else if  ("upTaskOrder".equals(command)){
	upTaskOrderAction = true;
} else if  ("downTaskOrder".equals(command)){
	downTaskOrderAction = true;
}

ArrayList record_task = CorporatePlanTaskDB.getList(userBean, fiscalYear, deptCode, planID, goalID);
ReportableListObject row_task = null;
ReportableListObject row_progress = null;

Map<String, String> tooltipMap = new HashMap<String, String>();
tooltipMap.put("addTask","Click to add more task");
tooltipMap.put("taskDesc","The different tasks or phases to be carried out in order to achieve each goal");
tooltipMap.put("taskBy","Choose the responsible staff on the staff");
tooltipMap.put("updateTask","click [update] to change the details of the task, click[save] to save the change on the task");
tooltipMap.put("progressDeptDesc","Filled by Department. [Status] is used to show the status of the task and [Remark] to used to describe the status");
tooltipMap.put("remarkAdminDesc","Administrator can use this panel to give opinion on different progress");
tooltipMap.put("approvalTask","Click [Approval] to approve the Task and the name of the staff who approve the Task will be displayed");
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

	<!-- Task, Progress and Admin START-->
	<tr class="smallText">
		<td class="infoSubTitle2" colspan="2">Implement and Evaluation</td>
	</tr>
	<tr class="smallText">
		<td colspan="2">
			<table id="rowTask" cellpadding="0" cellspacing="2" border="0" style="width:100%">
				<tr>
<%	if (!createTaskAction && !updateTaskAction) { %>
					<td class="infoSubTitle7" style="width: 50%">Milestone & Task</td>
					<td class="infoSubTitle8" style="width: 30%">Progress Update by Department</td>
					<td class="infoSubTitle9" style="width: 20%">Remark by Admin</td>
<%	} else { %>
					<td class="infoSubTitle7" style="width: 100%">Milestone & Task</td>
<%	}%>
				</tr>
<%	if (!createEvaluationAction && !updateEvaluationAction) { %>
				<tr class="smallText">
					<td colspan="3">
<%		if (!createAction && !updateAction && !createTaskAction && !updateTaskAction) { %>
						<a title="<%=tooltipMap.get("addTask") %>" href="javascript:void(0);" onclick="submitAction('createTask', 0, '');return false;"><bean:message key="button.add" /> more task</a>
<%		} %>
					</td>
				</tr>
<%
		//------------
		// Update / Create action
		//------------
		if (!createAction && !updateAction) {
			// List all tasks (editable)
			for (int i = 0; i < record_task.size(); i++) {
				row_task = (ReportableListObject) record_task.get(i);
				tempTaskID = row_task.getValue(0);
				taskDesc = row_task.getValue(1);
				taskEstimateCompleteDate = row_task.getValue(2);
				taskActualCompleteDate = row_task.getValue(3);
				taskOrder = row_task.getValue(4);
				adminApprovedYN = row_task.getValue(5);
				adminApprovedDate = row_task.getValue(6);
				adminApprovedBy = row_task.getValue(7);
				adminApprovedByName = row_task.getValue(8);
				isTaskApproved = ConstantsVariable.YES_VALUE.equals(adminApprovedYN);
				isCurrentTask = tempTaskID.equals(taskID);
				isAllowUpdate = updateTaskAction && isCurrentTask;
				isAllowUpdateYN = isAllowUpdate ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
%>
				<tr>
					<td>
						<table cellpadding="0" cellspacing="2" border="0" style="width:100%">
							<tr>
								<td class="infoLabe2" style="width: 10%">&nbsp;</td>
								<td title="<%=tooltipMap.get("taskDesc") %>" class="infoLabe2" style="width: 40%">Description</td>
								<td class="infoLabe2" style="width: 20%">Estimate<br>Complete Date</td>
								<td  class="infoLabe2" style="width: 30%">By</td>
							</tr>
							<tr>
								<td class="infoLabel" rowspan="3"><%=(i + 1) %>
<%				if (!createTaskAction && !updateTaskAction && !updateGoalAction) { %>
						<a href="javascript:void(0);"  onclick="submitAction('upTaskOrder', '1', '<%=taskOrder %>');"><img src="<html:rewrite page="/images/upbutton.png" />"   alt="Up" /></a>
						<a href="javascript:void(0);"  onclick="submitAction('downTaskOrder', '1', '<%=taskOrder %>');"><img src="<html:rewrite page="/images/downbutton.png" />" alt="Down" /></a>
<%				} %>
								</td>
								<td class="infoData" rowspan="3">
<%				if (isAllowUpdate) { %>
									<div class="box"><textarea name="taskDesc" rows="4" cols="50"><%=taskDesc==null?"":taskDesc %></textarea></div>
									(max 300 characters)
<%				} else { %>
									<%=taskDesc==null?"":taskDesc %>
<%				} %>
								</td>
								<td class="infoData">
<%				if (isAllowUpdate) { %>
									<input type="text" name="taskEstimateCompleteDate" id="taskEstimateCompleteDate" class="datepickerfield" value="<%=taskEstimateCompleteDate %>" />
<%				} else { %>
									<%=taskEstimateCompleteDate==null?"":taskEstimateCompleteDate %>
<%				} %>
								</td>
								<td title="<%=tooltipMap.get("taskBy") %>"  class="infoData" rowspan="2">
									<div id="taskResponsibleBox">
<jsp:include page="corporate_plan_task_response.jsp" flush="false">
	<jsp:param name="command" value="<%=command %>" />
	<jsp:param name="planID" value="<%=planID %>" />
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="fiscalYear_yy" value="<%=fiscalYear %>" />
	<jsp:param name="goalID" value="<%=goalID %>" />
	<jsp:param name="taskID" value="<%=tempTaskID %>" />
	<jsp:param name="isAllowUpdateYN" value="<%=isAllowUpdateYN %>" />
</jsp:include>
									</div>
								</td>
							</tr>
							<tr>
								<td class="infoLabe2" style="width: 20%">Actual<br>Complete Date</td>
							</tr>
							<tr>
								<td class="infoData">
<%				if (isAllowUpdate) { %>
									<input type="text" name="taskActualCompleteDate" id="taskActualCompleteDate" class="datepickerfield" value="<%=taskActualCompleteDate %>" />
<%				} else { %>
									<%=taskActualCompleteDate==null?"":taskActualCompleteDate %>
<%				} %>
								</td>
								<td class="infoData" title="<%=tooltipMap.get("updateTask") %>">
<%				if (isTaskApproved) { %>
									<table cellpadding="0" cellspacing="0" border="0" style="width:100%">
										<tr>
											<td><img src="<html:rewrite page="/images/tick_green_small.gif" />" alt="Approved" /></td>
											<td><%=adminApprovedDate==null?"":adminApprovedDate %></td>
										</tr>
										<tr>
											<td></td>
											<td><i>by <b><%=adminApprovedByName %></b></i></td>
										</tr>
									</table>
<%				} %>
									<table cellpadding="0" cellspacing="0" border="0" style="width:100%">
										<tr>
<%				if (isAllowUpdate) { %>
											<td><button onclick="submitAction('updateTask', '1', '<%=tempTaskID %>');return false;" class="btn-click">Save</button></td>
											<td><button onclick="submitAction('view', '0', '');return false;" class="btn-click">Cancel</button></td>
<%				} else if (!createTaskAction && !updateTaskAction) { %>
<%					if (allowApproval) { %>
<%						if (isTaskApproved) { %>
											<td><button title="<%=tooltipMap.get("approvalTask")%>" onclick="submitAction('rejectTask', '1', '<%=tempTaskID %>');return false;" class="btn-click">Reject</button></td>
<%						} else { %>
											<td><button title="<%=tooltipMap.get("approvalTask")%>" onclick="submitAction('approveTask', '1', '<%=tempTaskID %>');return false;" class="btn-click">Approval</button></td>
<%						} %>
<%					} %>
											<td><button onclick="submitAction('updateTask', '0', '<%=tempTaskID %>');return false;" class="btn-click">Update</button></td>
											<td><button onclick="submitAction('deleteTask', '1', '<%=tempTaskID %>');return false;" class="btn-click">Delete</button></td>
<%				} %>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
<%				if (!createTaskAction && !updateTaskAction) { %>
					<td title="<%=tooltipMap.get("progressDeptDesc") %>">
						<table cellpadding="0" cellspacing="2" border="0" style="width:100%">
<%					if (!createTaskAction && !updateTaskAction && !updateGoalAction) { %>
							<tr>
								<td class="infoLabel" style="width: 30%;">Status</td>
								<td class="infoData">
									<select name="progressStatus<%=tempTaskID %>">
<jsp:include page="../ui/cpProgressStatusCMB.jsp" flush="false">
	<jsp:param name="progressStatus" value="" />
	<jsp:param name="allowEmpty" value="Y" />
</jsp:include>
									</select>
								</td>
							</tr>
							<tr>
								<td  class="infoLabel">Remarks</td>
								<td class="infoData">
									<div class="box"><textarea name="progressDesc<%=tempTaskID %>" class="comment" rows="4" cols="40"></textarea></div>
									<button onclick="submitAction('createProgress', '1','<%=tempTaskID %>');return false;" class="btn-click">Submit</button>
								</td>
							</tr>
<%					} %>
<jsp:include page="corporate_plan_comment.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="fiscalYear_yy" value="<%=fiscalYear %>" />
	<jsp:param name="planID" value="<%=planID %>" />
	<jsp:param name="goalID" value="<%=goalID %>" />
	<jsp:param name="objectType" value="progress" />
	<jsp:param name="objectID" value="<%=tempTaskID %>" />
</jsp:include>
						</table>
					</td>

					<td >
						<table title="<%=tooltipMap.get("remarkAdminDesc") %>" cellpadding="0" cellspacing="2" border="0" style="width:100%">
<%					if (!createTaskAction && !updateTaskAction && !updateGoalAction) { %>
							<tr>
								<td  class="infoLabel" style="width: 30%;">Comment</td>
								<td class="infoData">
									<div class="box"><textarea name="adminContent<%=tempTaskID %>" class="comment" rows="4" cols="40"></textarea></div>
									<button onclick="submitAction('createAdmin', '1', '<%=tempTaskID %>');return false;" class="btn-click">Submit</button>
								</td>
							</tr>
<%					} %>
<jsp:include page="corporate_plan_comment.jsp" flush="false">
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="fiscalYear_yy" value="<%=fiscalYear %>" />
	<jsp:param name="planID" value="<%=planID %>" />
	<jsp:param name="goalID" value="<%=goalID %>" />
	<jsp:param name="objectType" value="admin.remark" />
	<jsp:param name="objectID" value="<%=tempTaskID %>" />
</jsp:include>
						</table>
					</td>
<%				} %>
				</tr>
<%
			}
		}

		// No task, create a new task by default
		if (createTaskAction) { %>
				<tr>
					<td>
						<table cellpadding="0" cellspacing="2" border="0" style="width:100%">
							<tr>
								<td class="infoLabe2" style="width: 10%">&nbsp;</td>
								<td title="<%=tooltipMap.get("taskDesc") %>" class="infoLabe2" style="width: 40%">Description</td>
								<td class="infoLabe2" style="width: 20%">Estimate<br>Complete Date</td>
								<td class="infoLabe2" style="width: 30%">By</td>
							</tr>
							<tr>
								<td class="infoLabel" rowspan="3">&nbsp;</td>
								<td class="infoData" rowspan="3">
									<div class="box"><textarea name="taskDesc" rows="4" cols="50"></textarea></div>
									(max 300 characters)
								</td>
								<td class="infoData">
									<input type="text" name="taskEstimateCompleteDate" id="taskEstimateCompleteDate" class="datepickerfield" />
								</td>
								<td title="<%=tooltipMap.get("taskBy") %>" class="infoData" rowspan="3">
									<div id="taskResponsibleBox">
<jsp:include page="corporate_plan_task_response.jsp" flush="false">
	<jsp:param name="command" value="<%=command %>" />
	<jsp:param name="planID" value="<%=planID %>" />
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="fiscalYear_yy" value="<%=fiscalYear %>" />
	<jsp:param name="goalID" value="<%=goalID %>" />
	<jsp:param name="taskID" value="<%=tempTaskID %>" />
	<jsp:param name="isAllowUpdateYN" value="Y" />
</jsp:include>
										<button onclick="submitAction('createTask', '1', '');return false;" class="btn-click">Add</button>
										<button onclick="submitAction('view', '0', '');return false;" class="btn-click">Cancel</button>
									</div>
								</td>
							</tr>
							<tr>
								<td class="infoLabe2" style="width: 20%">Actual<br>Complete Date</td>
							</tr>
							<tr>
								<td class="infoData">
									<input type="text" name="taskActualCompleteDate" id="taskActualCompleteDate" class="datepickerfield" />
								</td>
							</tr>
						</table>
					</td>
					<td colspan="2">&nbsp;</td>
				</tr>
<%		} else if (record_task.size() == 0) {
		//------------
		// View action
		//------------
		// No task, print "No task" message
%>
				<tr>
					<td colspan="3">
						No Task
					</td>
				</tr>
<%		} %>
				<tr class="smallText">
					<td colspan="3">
<%		if (!createAction && !updateAction && !createTaskAction && !updateTaskAction) { %>
						<a title="<%=tooltipMap.get("addTask") %>" href="javascript:void(0);" onclick="submitAction('createTask', 0, '');return false;"><bean:message key="button.add" /> more task</a>
<%		} %>
					</td>
				</tr>
<%	} %>
			</table>
		</td>
	</tr>
	<!-- Task, Progress and Admin END -->