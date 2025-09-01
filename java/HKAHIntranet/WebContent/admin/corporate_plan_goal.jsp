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
String goalDesc = ParserUtil.getParameter(request, "goalDesc");
String corporateObjective = ParserUtil.getParameter(request, "corporateObjective");
String corporateObjectiveOther = ParserUtil.getParameter(request, "corporateObjectiveOther");
String focus = ParserUtil.getParameter(request, "focus");
String focusOther = ParserUtil.getParameter(request, "focusOther");
String goalOrder = ParserUtil.getParameter(request, "goalOrder");

String tempGoalID = null;
String adminApprovedYN = null;
String adminApprovedDate = null;
String adminApprovedBy = null;
String adminApprovedByName = null;

boolean isGoalApproved = false;
boolean isCurrentGoal = false;
boolean isAllowUpdate = false;
boolean isGoalView = false;
boolean hasGoalID = false;
boolean allowApproval = userBean.isOfficeAdministrator();

boolean createAction = false;
boolean updateAction = false;
boolean createGoalAction = false;
boolean updateGoalAction = false;
boolean deleteGoalAction = false;
boolean createTaskAction = false;
boolean updateTaskAction = false;
boolean createEvaluationAction = false;
boolean updateEvaluationAction = false;
boolean upGoalOrderAction = false;
boolean downGoalOrderAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("createGoal".equals(command)) {
	createGoalAction = true;
} else if ("updateGoal".equals(command)) {
	updateGoalAction = true;
} else if ("deleteGoal".equals(command)) {
	deleteGoalAction = true;
} else if ("createTask".equals(command)) {
	createTaskAction = true;
} else if ("updateTask".equals(command)) {
	updateTaskAction = true;
} else if ("createEvaluation".equals(command)) {
	createEvaluationAction = true;
} else if ("updateEvaluation".equals(command)) {
	updateEvaluationAction = true;
} else if  ("upGoalOrder".equals(command)) {
	upGoalOrderAction = true;
} else if ("downGoalOrder".equals(command)){
	downGoalOrderAction = true;
}

ArrayList record = null;
ReportableListObject row = null;

if (goalID != null && goalID.length() > 0) {
	record = CorporatePlanGoalDB.get(userBean, fiscalYear, deptCode, planID, goalID);
	request.setAttribute("plan_goal", record);
} else {
	record = CorporatePlanGoalDB.getList(userBean, fiscalYear, deptCode, planID);
	request.setAttribute("plan_goal", null);
}
isGoalView = goalID != null && goalID.length() > 0 && record.size() == 1;

Map<String, String> tooltipMap = new HashMap<String, String>();
//Goal
tooltipMap.put("editGoal","Click [edit] to edit the detail of the Goal, including evaluations, tasks, resource ");
tooltipMap.put("approvalGoal","Click [Approval] to approve the Goal and the name of the staff who approve the Goal will be displayed");
tooltipMap.put("viewGoal","Click [View] to read the details of approved Goal");
tooltipMap.put("viewallGoal","Click [View all Goal] to view all the goal in the corporate plan");
tooltipMap.put("saveGoal", "Click to save the change to the edited goal");
//Objective
tooltipMap.put("objectivedesc","Select the Corporate objective you wish to focus on and Strategies to adopt to achieve the corporate objective");
tooltipMap.put("objectiveSelect", "Select the objective which fit the project, select[other] if fill in objectives that can not be found in the list");

//strategy
tooltipMap.put("strategySelect", "Select the strategy which fit the project, select[other] if fill in strategy that can not be found in the list");
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
	<!-- Goal START -->
	<tr class="smallText">
		<td class="infoSubTitle2" colspan="2">Goals or Achievements</td>
	</tr>
<%	if (!createAction && !updateAction && !createGoalAction) { %>
	<tr>
<%		if (isGoalView) { %>
		<td><a title="<%=tooltipMap.get("viewallGoal") %>" href="javascript:void(0);" onclick="submitAction('viewGoal', 0, '');return false;">View all Goals</a></td>
<%		} else {%>
		<td title="Click here to add Goal"><a href="javascript:void(0);" onclick="submitAction('createGoal', 0, '');return false;"><bean:message key="button.add" /> More Goal</a></td>
<%		} %>
		<td>&nbsp;</td>
	</tr>
<%	} %>
	<tr class="smallText">
		<td colspan="2">
			<table id="rowGoal" cellpadding="0" cellspacing="2" border="0" style="width:100%">
				<tr>
					<td class="infoLabe2" width="10%">&nbsp;</td>
					<td class="infoLabe2" width="75%">Detail Description of Goal</td>
					<td class="infoLabe2" width="20%">Action</td>
				</tr>

<%
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		tempGoalID = row.getValue(2);
		goalDesc = row.getValue(3);
		corporateObjective = row.getValue(4);
		corporateObjectiveOther = row.getValue(5);
		focus = row.getValue(6);
		focusOther = row.getValue(7);
		adminApprovedYN = row.getValue(8);
		adminApprovedDate = row.getValue(9);
		adminApprovedBy = row.getValue(10);
		adminApprovedByName = row.getValue(11);
		isGoalApproved = ConstantsVariable.YES_VALUE.equals(adminApprovedYN);
		isCurrentGoal = tempGoalID.equals(goalID);
		isAllowUpdate = updateGoalAction && isCurrentGoal;
		goalOrder = row.getValue(12);

		if (!isGoalView || isCurrentGoal) {
%>
				<tr>
					<td class="infoLabel">
<%		if (!isGoalView) { %>
						<%=i + 1 %>/<%=record.size() %>
						<a href="javascript:void(0);"  onclick="submitAction('upGoalOrder', '1', '<%=goalOrder %>');return false;"><img src="<html:rewrite page="/images/upbutton.png" />"   alt="Up" /></a>
						<a href="javascript:void(0);"  onclick="submitAction('downGoalOrder', '1', '<%=goalOrder %>');return false;"><img src="<html:rewrite page="/images/downbutton.png" />" alt="Down" /></a>


<%		} %>


					</td>
					<td class="infoData">
<%			if (!isGoalApproved && isAllowUpdate) { %>
						<div class="box"><textarea name="goalDesc" rows="4" cols="100"><%=goalDesc == null ? "" : goalDesc %></textarea></div>
						<input type="hidden" name="skipGoalDesc" value="N"/>
						(max 300 characters)
<%			} else { %>
						<%=goalDesc==null?"":goalDesc %>
						<input type="hidden" name="skipGoalDesc" value="Y"/>
<%			} %>
					</td>
					<td class="infoData" >
<%			if (isGoalApproved) { %>
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
						<button title="<%=tooltipMap.get("viewGoal") %>"  onclick="submitAction('updateGoal', '0', '<%=tempGoalID %>');return false;" class="btn-click">View</button>
<%				if (allowApproval) { %>
						<button title="<%=tooltipMap.get("approvalGoal")%>" onclick="submitAction('rejectGoal', '1', '<%=tempGoalID %>');return false;" class="btn-click">Reject</button>
<%				} %>
<%			} else if (!isGoalView && !isAllowUpdate) { %>
						<button title="<%=tooltipMap.get("editGoal") %>" onclick="submitAction('updateGoal', '0', '<%=tempGoalID %>');return false;" class="btn-click">Edit</button>
<%				if (allowApproval) { %>
						<button title="<%=tooltipMap.get("approvalGoal")%>" onclick="submitAction('approveGoal', '1', '<%=tempGoalID %>');return false;" class="btn-click">Approval</button>
<%				} %>
<%			} %>
					</td>
				</tr>
<%
		}
	}

	// new goal
	if (createGoalAction) {
%>
				<tr>
					<td class="infoLabel">&nbsp;</td>
					<td class="infoData">
						<div class="box"><textarea name="goalDesc" rows="4" cols="100"></textarea></div>
						<input type="hidden" name="skipGoalDesc" value="N"/>
						(max 300 characters)
					</td>
					<td class="infoData">&nbsp;</td>
				</tr>
<%
	} else if (record.size() == 0) {
		// No task, print "No task" message
%>
				<tr>
					<td colspan="3">
						No Goal
					</td>
				</tr>
<%	} %>
			</table>
		</td>
	</tr>
<%	if (!createAction && !updateAction && !createGoalAction) { %>
	<tr>
<%		if (isGoalView) { %>
		<td title="<%=tooltipMap.get("viewallGoal") %>"><a href="javascript:void(0);" onclick="submitAction('viewGoal', 0, '');return false;">View all Goals</a></td>
<%		} else {%>
		<td><a href="javascript:void(0);" onclick="submitAction('createGoal', 0, '');return false;"><bean:message key="button.add" /> More Goal</a></td>
<%		} %>
		<td>&nbsp;</td>
	</tr>
<%	} %>
	<!-- Goal (END) -->
<%		if (isGoalView) { %>
	<tr class="smallText">
		<td class="infoSubTitle2" colspan="2" title="<%=tooltipMap.get("objectivedesc")%>">Objectives & Strategies</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Objectives to Achieve for Each Goal</td>
		<td class="infoData" width="70%">
<%	if (updateGoalAction) { %>
			<select title="<%=tooltipMap.get("objectiveSelect") %>" name="corporateObjective" onchange="return changeCorporateObjectiveStyle()">
				<option value="Increase census"<%="Increase census".equals(corporateObjective)?"selected":"" %>>Increase census</option>
				<option value="Increase revenue"<%="Increase revenue".equals(corporateObjective)?"selected":"" %>>Increase revenue</option>
				<option value="Increase efficiency"<%="Increase efficiency".equals(corporateObjective)?"selected":"" %>>Increase efficiency</option>
				<option value="Enhance clinical quality"<%="Enhance clinical quality".equals(corporateObjective)?"selected":"" %>>Enhance clinical quality</option>
				<option value="Enhance customer service"<%="Enhance customer service".equals(corporateObjective)?"selected":"" %>>Enhance customer service</option>
				<option value="Others"<%="Others".equals(corporateObjective)?"selected":"" %>>Others</option>
			</select>
 			<input type="textfield" name="corporateObjectiveOther" style="display: <%="Others".equals(corporateObjective)?"block":"none" %>" id="corporateObjectiveOther" value="<%=corporateObjectiveOther==null?"":corporateObjectiveOther %>" maxlength="100" size="30">
 			(max 100 characters)
<%	} else { %>
			<%="Others".equals(corporateObjective) ? (corporateObjectiveOther == null ? "" : corporateObjectiveOther.toUpperCase()) : (corporateObjective == null ? "" : corporateObjective.toUpperCase()) %>
<%	} %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">Focused Direction and Strategy for Each Goal</td>
		<td class="infoData" width="70%">
<%	if (updateGoalAction) { %>
			<select title="<%=tooltipMap.get("strategySelect") %>" name="focus" onchange="return changeFocusStyle()">
				<option value="Improve Facilities"<%="Improve Facilities".equals(focus)?"selected":"" %>>Improve Facilities</option>
				<option value="Improve Information Technology"<%="Improve Information Technology".equals(focus)?"selected":"" %>>Improve Information Technology</option>
				<option value="Enhance Brand and Marketing"<%="Enhance Brand and Marketing".equals(focus)?"selected":"" %>>Enhance Brand and Marketing</option>
				<option value="Enhance Human Resource Strategies"<%="Enhance Human Resource Strategies".equals(focus)?"selected":"" %>>Enhance Human Resource Strategies</option>
				<option value="Education"<%="Education".equals(focus)?"selected":"" %>>Education</option>
				<option value="Others"<%="Others".equals(focus)?"selected":"" %>>Others</option>
			</select>
 			<input type="textfield" name="focusOther" style="display: <%="Others".equals(focus)?"block":"none" %>" id="focusOther" value="<%=focusOther==null?"":focusOther %>" maxlength="100" size="30">
 			(max 100 characters)
<%	} else { %>
			<%="Others".equals(focus) ? (focusOther == null ? "" : focusOther.toUpperCase()) : (focus == null ? "" : focus.toUpperCase()) %>
<%	} %>
 		</td>
	</tr>
<jsp:include page="corporate_plan_task.jsp" flush="false">
	<jsp:param name="command" value="<%=command %>" />
	<jsp:param name="planID" value="<%=planID %>" />
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="fiscalYear_yy" value="<%=fiscalYear %>" />
	<jsp:param name="goalID" value="<%=goalID %>" />
</jsp:include>

<jsp:include page="corporate_plan_evaluation.jsp" flush="false">
	<jsp:param name="command" value="<%=command %>" />
	<jsp:param name="planID" value="<%=planID %>" />
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="fiscalYear_yy" value="<%=fiscalYear %>" />
	<jsp:param name="goalID" value="<%=goalID %>" />
</jsp:include>

<jsp:include page="corporate_plan_resource.jsp" flush="false">
	<jsp:param name="command" value="<%=command %>" />
	<jsp:param name="planID" value="<%=planID %>" />
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="fiscalYear_yy" value="<%=fiscalYear %>" />
	<jsp:param name="goalID" value="<%=goalID %>" />
</jsp:include>

<jsp:include page="corporate_plan_attachment.jsp" flush="false">
	<jsp:param name="command" value="<%=command %>" />
	<jsp:param name="planID" value="<%=planID %>" />
	<jsp:param name="deptCode" value="<%=deptCode %>" />
	<jsp:param name="fiscalYear_yy" value="<%=fiscalYear %>" />
	<jsp:param name="goalID" value="<%=goalID %>" />
</jsp:include>
<%		} %>
<div class="pane">
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%		if (createGoalAction) { %>
			<button onclick="submitAction('createGoal', 1, '');return false;" class="btn-click"><bean:message key="button.create" /> Goal</button>
			<button onclick="submitAction('view', 0, '');return false;" class="btn-click"><bean:message key="button.cancel" /> Goal</button>
<%		} else if (updateGoalAction) { %>
			<button title="<%=tooltipMap.get("saveGoal") %>" onclick="submitAction('updateGoal', '1', '<%=goalID %>');return false;" class="btn-click"><bean:message key="button.save" /> Goal</button>
			<button onclick="submitAction('deleteGoal', '1', '<%=goalID %>');return false;" class="btn-click">Delete Goal</button>
			<button title="<%=tooltipMap.get("editGoal") %>" onclick="submitAction('view', 0, '');" class="btn-click"><bean:message key="button.cancel" /> Update Goal</button>
<%		} else if (isGoalView && !createTaskAction && !updateTaskAction && !createEvaluationAction && !updateEvaluationAction) { %>
			<button title="<%=tooltipMap.get("editGoal") %>" onclick="submitAction('updateGoal', '0', '<%=tempGoalID %>');return false;" class="btn-click">Edit</button>
<%			if (allowApproval) { %>
			<button onclick="submitAction('approveGoal', '1', '<%=tempGoalID %>');return false;" class="btn-click">Approval</button>
<%			} %>
<%		} %>
		</td>
	</tr>
</table>
</div>